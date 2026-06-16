-- ============================================================
-- SEED COMPLET — cellules hétérogènes + mouvements + cotisations
-- Distribution : IDF >> hors IDF, répartition inégale entre cellules
-- Mouvements : JPS, MOJIP, Cadres, Foyers, Maggi Pastef
-- Taux de recouvrement visé : ~75-80 %
-- ============================================================

-- ── 1. Nettoyage (ordre FK) ──────────────────────────────────
DELETE FROM postes_bureau;
DELETE FROM cotisations;
DELETE FROM presences;
UPDATE transactions SET militant_id             = NULL WHERE militant_id             IS NOT NULL;
UPDATE prospects    SET converti_en_militant_id  = NULL WHERE converti_en_militant_id  IS NOT NULL;
DELETE FROM militants;
DELETE FROM unites_organisationnelles WHERE type = 'cellule';

DO $$
DECLARE
  v_user_id  UUID;
  v_ss       RECORD;
  v_cel      RECORD;
  v_mvt      RECORD;
  v_m        RECORD;
  v_n_cel    INT;
  v_n_create INT;
  v_j        INT;
  v_i        INT;
  v_quota_ss INT;
  v_quota_cel INT;
  v_rang     INT;
  v_sexe     TEXT;
  v_nom      TEXT;
  v_prenom   TEXT;
  v_ville    TEXT;
  v_date_adh DATE;
  v_statut   TEXT;
  v_total    INT := 0;
  v_mois     INT;
  v_ss_label TEXT;

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
  -- 7/9 actifs, 1/9 inactif, 1/9 suspendu
  v_statuts TEXT[] := ARRAY[
    'actif','actif','actif','actif','actif','actif','actif','inactif','suspendu'
  ];
  v_idf_codes TEXT[] := ARRAY[
    'SS-075','SS-077','SS-078','SS-091','SS-092','SS-093','SS-094','SS-095'
  ];

BEGIN
  SELECT id INTO v_user_id FROM auth.users ORDER BY created_at LIMIT 1;
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Aucun utilisateur trouvé — connectez-vous d''abord';
  END IF;

  -- ══════════════════════════════════════════════════════════
  -- ÉTAPE 1 : Création des cellules (distribution hétérogène)
  -- Nombre de cellules par SS : plus il y a de militants, plus c'est divisé
  -- ══════════════════════════════════════════════════════════
  FOR v_ss IN
    SELECT id, code, nom FROM unites_organisationnelles
    WHERE type = 'sous_section' ORDER BY code NULLS LAST
  LOOP
    v_n_create := CASE v_ss.code
      WHEN 'SS-075' THEN 4   WHEN 'SS-093' THEN 4
      WHEN 'SS-092' THEN 3   WHEN 'SS-094' THEN 3
      WHEN 'SS-077' THEN 2   WHEN 'SS-078' THEN 2
      WHEN 'SS-091' THEN 2   WHEN 'SS-095' THEN 2
      WHEN 'SS-ARA' THEN 2   WHEN 'SS-GRE' THEN 2
      WHEN 'SS-HDF' THEN 2   WHEN 'SS-OCC' THEN 2
      WHEN 'SS-PAM' THEN 2
      ELSE 1
    END;

    -- Nom de base = 2e mot du nom de la SS ("Sous-section Paris" → "Paris")
    v_ss_label := SPLIT_PART(COALESCE(v_ss.nom, v_ss.code), ' ', 2);

    FOR v_j IN 1..v_n_create LOOP
      INSERT INTO unites_organisationnelles (type, nom, code, parent_id)
      VALUES (
        'cellule',
        'Cellule ' || v_ss_label || ' ' ||
          (ARRAY['Nord','Sud','Est','Ouest'])[v_j],
        'C-' || COALESCE(v_ss.code, 'SS') || '-0' || v_j,
        v_ss.id
      );
    END LOOP;
  END LOOP;

  -- ══════════════════════════════════════════════════════════
  -- ÉTAPE 2 : Militants dans les SOUS-SECTIONS (via cellules)
  -- Répartition inégale entre cellules : rang 1 = plus grande
  -- ══════════════════════════════════════════════════════════
  FOR v_ss IN
    SELECT id, code FROM unites_organisationnelles
    WHERE type = 'sous_section' ORDER BY code NULLS LAST
  LOOP
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
      ELSE 20
    END;

    SELECT COUNT(*) INTO v_n_cel
    FROM unites_organisationnelles
    WHERE type = 'cellule' AND parent_id = v_ss.id;

    IF v_n_cel = 0 THEN CONTINUE; END IF;

    -- Itère avec rang pour varier le quota par cellule
    v_rang := 0;
    FOR v_cel IN
      SELECT id FROM unites_organisationnelles
      WHERE type = 'cellule' AND parent_id = v_ss.id ORDER BY id
    LOOP
      v_rang := v_rang + 1;

      -- Poids décroissant selon le rang et le nombre de cellules
      v_quota_cel := CASE v_n_cel
        WHEN 4 THEN CASE v_rang
          WHEN 1 THEN ROUND(v_quota_ss * 0.40)
          WHEN 2 THEN ROUND(v_quota_ss * 0.27)
          WHEN 3 THEN ROUND(v_quota_ss * 0.20)
          ELSE        GREATEST(3, v_quota_ss - ROUND(v_quota_ss * 0.87))
        END
        WHEN 3 THEN CASE v_rang
          WHEN 1 THEN ROUND(v_quota_ss * 0.50)
          WHEN 2 THEN ROUND(v_quota_ss * 0.30)
          ELSE        GREATEST(3, v_quota_ss - ROUND(v_quota_ss * 0.80))
        END
        WHEN 2 THEN CASE v_rang
          WHEN 1 THEN ROUND(v_quota_ss * 0.60)
          ELSE        GREATEST(3, v_quota_ss - ROUND(v_quota_ss * 0.60))
        END
        ELSE v_quota_ss
      END;

      FOR v_i IN 1..GREATEST(1, v_quota_cel) LOOP
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
  END LOOP;

  -- ══════════════════════════════════════════════════════════
  -- ÉTAPE 3 : Militants dans les MOUVEMENTS
  -- Chaque mouvement a sa propre base de militants
  -- ══════════════════════════════════════════════════════════
  FOR v_mvt IN
    SELECT id, code, nom FROM unites_organisationnelles
    WHERE type = 'mouvement' ORDER BY code NULLS LAST
  LOOP
    v_quota_ss := CASE
      WHEN v_mvt.nom ILIKE '%MOJIP%'   OR v_mvt.code ILIKE '%MOJIP%'   THEN 45
      WHEN v_mvt.nom ILIKE '%JPS%'     OR v_mvt.code ILIKE '%JPS%'     THEN 35
      WHEN v_mvt.nom ILIKE '%Cadres%'  OR v_mvt.code ILIKE '%Cadres%'  THEN 20
      WHEN v_mvt.nom ILIKE '%Foyer%'   OR v_mvt.code ILIKE '%Foyer%'   THEN 15
      WHEN v_mvt.nom ILIKE '%Maggi%'   OR v_mvt.code ILIKE '%Maggi%'   THEN 12
      ELSE 15
    END;

    FOR v_i IN 1..v_quota_ss LOOP
      -- MOJIP = mouvement des femmes → 100 % F
      IF v_mvt.nom ILIKE '%MOJIP%' OR v_mvt.code ILIKE '%MOJIP%' THEN
        v_sexe   := 'F';
        v_prenom := v_prenoms_f[1 + (floor(random() * array_length(v_prenoms_f, 1)))::INT];
      -- JPS = jeunesse → même mix
      ELSIF random() < 0.55 THEN
        v_sexe   := 'M';
        v_prenom := v_prenoms_m[1 + (floor(random() * array_length(v_prenoms_m, 1)))::INT];
      ELSE
        v_sexe   := 'F';
        v_prenom := v_prenoms_f[1 + (floor(random() * array_length(v_prenoms_f, 1)))::INT];
      END IF;

      v_nom    := v_noms[1 + (floor(random() * array_length(v_noms, 1)))::INT];
      v_statut := v_statuts[1 + (floor(random() * array_length(v_statuts, 1)))::INT];
      v_ville  := v_villes_idf[1 + (floor(random() * array_length(v_villes_idf, 1)))::INT];
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
        v_mvt.id, v_user_id
      );
      v_total := v_total + 1;
    END LOOP;

    RAISE NOTICE 'Mouvement % : % militants', v_mvt.nom, v_quota_ss;
  END LOOP;

  RAISE NOTICE '✓ % militants au total (SS + mouvements)', v_total;

  -- ══════════════════════════════════════════════════════════
  -- ÉTAPE 4 : Cotisations → taux de recouvrement ~75-80 %
  -- Actifs    → payée janv–juin 2026 + 2025 (80 % des actifs)
  -- Inactifs  → en_retard sur 2026
  -- Suspendus → aucune cotisation
  -- ══════════════════════════════════════════════════════════
  FOR v_m IN
    SELECT id, statut, unite_id FROM militants
  LOOP
    IF v_m.statut = 'actif' THEN
      IF random() < 0.80 THEN
        FOR v_mois IN 1..12 LOOP
          INSERT INTO cotisations (
            militant_id, annee, mois, montant_paye, montant_du,
            statut, date_paiement, mode_paiement, unite_id, created_by
          ) VALUES (
            v_m.id, 2025, v_mois, 10, 10, 'payee',
            MAKE_DATE(2025, v_mois, (floor(random() * 25) + 1)::INT),
            (ARRAY['espèces','virement','PayPal','Lydia'])[1 + floor(random()*4)::INT],
            v_m.unite_id, v_user_id
          ) ON CONFLICT DO NOTHING;
        END LOOP;
      END IF;
      FOR v_mois IN 1..6 LOOP
        INSERT INTO cotisations (
          militant_id, annee, mois, montant_paye, montant_du,
          statut, date_paiement, mode_paiement, unite_id, created_by
        ) VALUES (
          v_m.id, 2026, v_mois, 10, 10, 'payee',
          MAKE_DATE(2026, v_mois, (floor(random() * 25) + 1)::INT),
          (ARRAY['espèces','virement','PayPal','Lydia'])[1 + floor(random()*4)::INT],
          v_m.unite_id, v_user_id
        ) ON CONFLICT DO NOTHING;
      END LOOP;

    ELSIF v_m.statut = 'inactif' THEN
      FOR v_mois IN 1..6 LOOP
        INSERT INTO cotisations (
          militant_id, annee, mois, montant_paye, montant_du,
          statut, unite_id, created_by
        ) VALUES (
          v_m.id, 2026, v_mois, 0, 10, 'en_retard',
          v_m.unite_id, v_user_id
        ) ON CONFLICT DO NOTHING;
      END LOOP;
    END IF;
  END LOOP;

  RAISE NOTICE '✓ Cotisations générées — taux attendu ~75-80%%';
END $$;