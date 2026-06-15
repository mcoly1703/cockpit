-- ============================================================
-- SEED ~500 militants répartis sur toutes les sous-sections
-- Version robuste : aucun UUID ni filtre JSONB fragile
-- ============================================================

-- ── 1. Nettoyage dans l'ordre des dépendances FK ────────────
DELETE FROM postes_bureau;
DELETE FROM cotisations;
DELETE FROM presences;
UPDATE transactions  SET militant_id             = NULL WHERE militant_id             IS NOT NULL;
UPDATE prospects     SET converti_en_militant_id  = NULL WHERE converti_en_militant_id  IS NOT NULL;
DELETE FROM militants;

-- ── 2. Génération ────────────────────────────────────────────
DO $$
DECLARE
  v_user_id    UUID;
  v_ss         RECORD;
  v_cel        RECORD;
  v_n_cel      INT;
  v_quota_ss   INT;
  v_i          INT;
  v_cel_id     UUID;
  v_sexe       TEXT;
  v_nom        TEXT;
  v_prenom     TEXT;
  v_ville      TEXT;
  v_date_adh   DATE;
  v_statut     TEXT;
  v_total      INT := 0;

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


  -- Codes IDF (pour choisir les villes appropriées)
  v_idf_codes TEXT[] := ARRAY[
    'SS-075','SS-077','SS-078','SS-091','SS-092','SS-093','SS-094','SS-095'
  ];

BEGIN
  SELECT id INTO v_user_id FROM auth.users ORDER BY created_at LIMIT 1;
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Aucun utilisateur trouvé — connectez-vous d''abord';
  END IF;

  -- Pour chaque sous-section
  FOR v_ss IN
    SELECT id, code, nom FROM unites_organisationnelles
    WHERE type = 'sous_section'
    ORDER BY code NULLS LAST
  LOOP
    -- Quota pour cette SS selon son code (défaut 25 si code inconnu)
    v_quota_ss := CASE v_ss.code
      WHEN 'SS-075' THEN 68   WHEN 'SS-077' THEN 27
      WHEN 'SS-078' THEN 20   WHEN 'SS-091' THEN 30
      WHEN 'SS-092' THEN 39   WHEN 'SS-093' THEN 72
      WHEN 'SS-094' THEN 39   WHEN 'SS-095' THEN 33
      WHEN 'SS-ARA' THEN 22   WHEN 'SS-BFC' THEN 10
      WHEN 'SS-BRE' THEN 12   WHEN 'SS-CVL' THEN 10
      WHEN 'SS-GRE' THEN 16   WHEN 'SS-HDF' THEN 22
      WHEN 'SS-NOR' THEN 12   WHEN 'SS-NAQ' THEN 12
      WHEN 'SS-OCC' THEN 16   WHEN 'SS-PAM' THEN 22
      WHEN 'SS-PAN' THEN 8    WHEN 'SS-PDL' THEN 10
      ELSE 25
    END;

    -- Crée une cellule si la SS n'en a aucune
    SELECT COUNT(*) INTO v_n_cel
    FROM unites_organisationnelles
    WHERE type = 'cellule' AND parent_id = v_ss.id;

    IF v_n_cel = 0 THEN
      INSERT INTO unites_organisationnelles (type, nom, code, parent_id)
      VALUES (
        'cellule',
        'Cellule ' || COALESCE(v_ss.nom, 'principale'),
        'C-' || COALESCE(v_ss.code, v_ss.id::TEXT) || '-01',
        v_ss.id
      )
      RETURNING id INTO v_cel_id;
      v_n_cel := 1;
      RAISE NOTICE 'SS % : cellule créée automatiquement', v_ss.code;
    END IF;

    -- Insère les militants, répartis équitablement entre cellules
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
          v_nom, v_prenom, v_sexe::sexe_type,
          '+336' || lpad((10000000 + floor(random() * 89999999)::INT)::TEXT, 8, '0'),
          lower(v_prenom) || '.' || lower(v_nom) || '.'
            || left(replace(gen_random_uuid()::TEXT, '-', ''), 5) || '@test.fr',
          v_ville, v_date_adh, v_statut::statut_militant,
          v_cel.id, v_user_id
        );
        v_total := v_total + 1;
      END LOOP;
    END LOOP;

    RAISE NOTICE 'SS % (%) : % militants, % cellule(s)',
      v_ss.code, v_ss.nom, v_quota_ss, v_n_cel;
  END LOOP;

  RAISE NOTICE '✓ Total inséré : % militants', v_total;
END $$;