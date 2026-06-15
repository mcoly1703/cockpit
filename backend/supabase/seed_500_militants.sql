-- ============================================================
-- SEED 500 militants répartis sur toutes les sous-sections
-- Version dynamique : aucun UUID hardcodé, lookup par code SS
-- Total visé : ~500 (ajusté selon les cellules présentes)
-- ============================================================

-- ── 1. Nettoyage dans l'ordre des dépendances FK ────────────
DELETE FROM postes_bureau;
DELETE FROM cotisations;
DELETE FROM presences;
UPDATE transactions      SET militant_id            = NULL WHERE militant_id            IS NOT NULL;
UPDATE prospects         SET converti_en_militant_id = NULL WHERE converti_en_militant_id IS NOT NULL;
DELETE FROM militants;

-- ── 2. Cellules manquantes — créées via lookup code SS ───────
INSERT INTO unites_organisationnelles (type, nom, code, parent_id)
SELECT 'cellule', 'Cellule Dijon', 'C-BFC-01', id
FROM   unites_organisationnelles WHERE code = 'SS-BFC'
AND NOT EXISTS (
  SELECT 1 FROM unites_organisationnelles c
  WHERE c.type = 'cellule'
  AND   c.parent_id = (SELECT id FROM unites_organisationnelles WHERE code = 'SS-BFC')
);

INSERT INTO unites_organisationnelles (type, nom, code, parent_id)
SELECT 'cellule', 'Cellule Orléans', 'C-CVL-01', id
FROM   unites_organisationnelles WHERE code = 'SS-CVL'
AND NOT EXISTS (
  SELECT 1 FROM unites_organisationnelles c
  WHERE c.type = 'cellule'
  AND   c.parent_id = (SELECT id FROM unites_organisationnelles WHERE code = 'SS-CVL')
);

-- ── 3. Génération des militants ───────────────────────────────
DO $$
DECLARE
  v_user_id    UUID;
  v_ss         RECORD;
  v_cel        RECORD;
  v_n_cel      INT;
  v_quota_ss   INT;
  v_i          INT;
  v_sexe       TEXT;
  v_nom        TEXT;
  v_prenom     TEXT;
  v_ville      TEXT;
  v_date_adh   DATE;
  v_statut     TEXT;

  v_noms TEXT[] := ARRAY[
    'Diallo','Ndiaye','Fall','Sow','Diop','Mbaye','Gaye','Touré','Faye','Sarr',
    'Niang','Cissé','Konaté','Diatta','Mendy','Badiane','Traoré','Coulibaly',
    'Bah','Keita','Baldé','Sonko','Dème','Gueye','Seck','Camara','Sy','Kane',
    'Gomis','Diouf','Badji','Sané','Dramé','Ndour','Lô','Wane','Kouyaté',
    'Diabaté','Sidibé','Barry','Doumbia','Sangaré','Koné','Bamba','Sissoko',
    'Dembélé','Mané','Kourouma','Diarra','Kante'
  ];
  v_prenoms_m TEXT[] := ARRAY[
    'Mamadou','Ousmane','Ibrahima','Samba','Modou','Amadou','Alioune','Cheikh',
    'Moussa','Lamine','Serigne','Babacar','Aliou','Abdoulaye','Seydou','Boubacar',
    'Thierno','Adama','Idrissa','Omar','Youssou','Malick','Assane','El Hadji',
    'Pape','Daouda','Gorgui','Habib','Ismaël','Momar','Souleymane','Djibril',
    'Moustapha','Mansour','Tidiane','Waly','Landing','Demba'
  ];
  v_prenoms_f TEXT[] := ARRAY[
    'Aminata','Fatou','Ndéye','Coumba','Mariama','Aissatou','Adja','Rokhaya',
    'Bineta','Khady','Fatoumata','Sokhna','Marème','Astou','Ngoné','Awa',
    'Dieynaba','Rama','Yacine','Seynabou','Penda','Binta','Oumou','Hawa',
    'Mariétou','Kadiatou','Dior','Nafi','Khadidiatou','Maïmouna','Soda','Aby'
  ];
  v_villes_idf TEXT[] := ARRAY[
    'Paris','Saint-Denis','Montreuil','Aubervilliers','Créteil','Nanterre',
    'Vitry-sur-Seine','Argenteuil','Versailles','Évry','Cergy','Bobigny',
    'Vincennes','Ivry-sur-Seine','Pantin','Boulogne-Billancourt','Sarcelles',
    'Corbeil-Essonnes','Meaux','Melun'
  ];
  v_villes_nat TEXT[] := ARRAY[
    'Lyon','Marseille','Toulouse','Bordeaux','Lille','Strasbourg','Nantes',
    'Grenoble','Rouen','Montpellier','Rennes','Nice','Dijon','Orléans','Metz',
    'Nancy','Amiens','Tours','Clermont-Ferrand','Caen'
  ];
  v_statuts TEXT[] := ARRAY[
    'actif','actif','actif','actif','actif','actif','actif','inactif','suspendu'
  ];

  -- Quota par code SS (total SS / nombre de cellules = quota par cellule)
  v_quotas JSONB := '{
    "SS-075": 68, "SS-077": 27, "SS-078": 20, "SS-091": 30,
    "SS-092": 39, "SS-093": 72, "SS-094": 39, "SS-095": 33,
    "SS-ARA": 22, "SS-BFC": 10, "SS-BRE": 12, "SS-CVL": 10,
    "SS-GRE": 16, "SS-HDF": 22, "SS-NOR": 12, "SS-NAQ": 12,
    "SS-OCC": 16, "SS-PAM": 22, "SS-PAN":  8, "SS-PDL": 10
  }';

  -- IDF SS codes
  v_idf_codes TEXT[] := ARRAY['SS-075','SS-077','SS-078','SS-091','SS-092','SS-093','SS-094','SS-095'];

BEGIN
  SELECT id INTO v_user_id FROM auth.users ORDER BY created_at LIMIT 1;
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Aucun utilisateur trouvé — connectez-vous d''abord';
  END IF;

  -- Itère sur chaque sous-section définie dans les quotas
  FOR v_ss IN
    SELECT id, code FROM unites_organisationnelles
    WHERE type = 'sous_section'
    AND   code = ANY(ARRAY(SELECT jsonb_object_keys(v_quotas)))
    ORDER BY code
  LOOP
    v_quota_ss := (v_quotas ->> v_ss.code)::INT;

    -- Compte les cellules rattachées à cette SS
    SELECT COUNT(*) INTO v_n_cel
    FROM unites_organisationnelles
    WHERE type = 'cellule' AND parent_id = v_ss.id;

    IF v_n_cel = 0 THEN
      RAISE NOTICE 'SS % : aucune cellule, ignorée', v_ss.code;
      CONTINUE;
    END IF;

    -- Distribue les militants équitablement entre les cellules de la SS
    FOR v_cel IN
      SELECT id FROM unites_organisationnelles
      WHERE type = 'cellule' AND parent_id = v_ss.id
      ORDER BY id
    LOOP
      FOR v_i IN 1..CEIL(v_quota_ss::FLOAT / v_n_cel)::INT LOOP
        IF random() < 0.55 THEN
          v_sexe   := 'M';
          v_prenom := v_prenoms_m[1 + (floor(random() * array_length(v_prenoms_m, 1)))::INT];
        ELSE
          v_sexe   := 'F';
          v_prenom := v_prenoms_f[1 + (floor(random() * array_length(v_prenoms_f, 1)))::INT];
        END IF;

        v_nom    := v_noms[1 + (floor(random() * array_length(v_noms, 1)))::INT];
        v_statut := v_statuts[1 + (floor(random() * array_length(v_statuts, 1)))::INT];

        IF v_ss.code = ANY(v_idf_codes) THEN
          v_ville := v_villes_idf[1 + (floor(random() * array_length(v_villes_idf, 1)))::INT];
        ELSE
          v_ville := v_villes_nat[1 + (floor(random() * array_length(v_villes_nat, 1)))::INT];
        END IF;

        v_date_adh := CURRENT_DATE - (floor(random() * 1095)::INT || ' days')::INTERVAL;

        INSERT INTO militants (
          nom, prenom, sexe, telephone, email,
          ville, date_adhesion, statut, unite_id, created_by
        ) VALUES (
          v_nom,
          v_prenom,
          v_sexe::sexe_type,
          '+336' || lpad((10000000 + floor(random() * 89999999)::INT)::TEXT, 8, '0'),
          lower(v_prenom) || '.' || lower(v_nom) || '.'
            || left(replace(gen_random_uuid()::TEXT, '-', ''), 5) || '@test.fr',
          v_ville,
          v_date_adh,
          v_statut::statut_militant,
          v_cel.id,
          v_user_id
        );
      END LOOP;
    END LOOP;

    RAISE NOTICE 'SS % : % militants insérés (%  cellules)', v_ss.code, v_quota_ss, v_n_cel;
  END LOOP;

  RAISE NOTICE '✓ Génération terminée — vérifier avec : SELECT COUNT(*) FROM militants';
END $$;