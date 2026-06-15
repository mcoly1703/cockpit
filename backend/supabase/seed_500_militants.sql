-- ============================================================
-- SEED 500 militants répartis sur toutes les sous-sections
-- Remplace toutes les données de test militants existantes
-- À exécuter dans le SQL Editor Supabase (une seule fois)
-- Total : 328 IDF + 172 hors IDF = 500
-- ============================================================

-- ── 1. Nettoyage dans l'ordre des dépendances FK ────────────
DELETE FROM postes_bureau;                                         -- militant_id NOT NULL
DELETE FROM cotisations;                                           -- militant_id NOT NULL
DELETE FROM presences;
UPDATE transactions SET militant_id = NULL
  WHERE militant_id IS NOT NULL;
UPDATE prospects SET converti_en_militant_id = NULL
  WHERE converti_en_militant_id IS NOT NULL;
DELETE FROM militants;

-- ── 2. Cellules manquantes (BFC + CVL) ──────────────────────
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id)
VALUES
  ('00000000-0000-0000-0004-000000010201', 'cellule', 'Cellule Dijon',
   'C-BFC-01', '00000000-0000-0000-0001-000000000102'),
  ('00000000-0000-0000-0004-000000010401', 'cellule', 'Cellule Orléans',
   'C-CVL-01', '00000000-0000-0000-0001-000000000104')
ON CONFLICT (id) DO NOTHING;

-- ── 3. Génération des 500 militants ──────────────────────────
DO $$
DECLARE
  v_user_id    UUID;
  v_cellule    RECORD;
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

  -- 7/9 actifs, 1/9 inactif, 1/9 suspendu
  v_statuts TEXT[] := ARRAY[
    'actif','actif','actif','actif','actif','actif','actif','inactif','suspendu'
  ];

BEGIN
  -- Récupère le profil du premier utilisateur (coordinateur de test)
  SELECT id INTO v_user_id FROM auth.users ORDER BY created_at LIMIT 1;
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Aucun utilisateur trouvé — connectez-vous d''abord via Supabase Auth';
  END IF;

  -- Distribution : 328 IDF + 172 hors IDF = 500
  FOR v_cellule IN
    SELECT cellule_id, quota, idf FROM (VALUES
      -- IDF — Paris 75 (68)
      ('00000000-0000-0000-0004-000000007501'::UUID, 17, TRUE),
      ('00000000-0000-0000-0004-000000007502'::UUID, 17, TRUE),
      ('00000000-0000-0000-0004-000000007503'::UUID, 17, TRUE),
      ('00000000-0000-0000-0004-000000007504'::UUID, 17, TRUE),
      -- IDF — Seine-et-Marne 77 (27)
      ('00000000-0000-0000-0004-000000007701'::UUID, 9,  TRUE),
      ('00000000-0000-0000-0004-000000007702'::UUID, 9,  TRUE),
      ('00000000-0000-0000-0004-000000007703'::UUID, 9,  TRUE),
      -- IDF — Yvelines 78 (20)
      ('00000000-0000-0000-0004-000000007801'::UUID, 10, TRUE),
      ('00000000-0000-0000-0004-000000007802'::UUID, 10, TRUE),
      -- IDF — Essonne 91 (30)
      ('00000000-0000-0000-0004-000000009101'::UUID, 10, TRUE),
      ('00000000-0000-0000-0004-000000009102'::UUID, 10, TRUE),
      ('00000000-0000-0000-0004-000000009103'::UUID, 10, TRUE),
      -- IDF — Hauts-de-Seine 92 (39)
      ('00000000-0000-0000-0004-000000009201'::UUID, 13, TRUE),
      ('00000000-0000-0000-0004-000000009202'::UUID, 13, TRUE),
      ('00000000-0000-0000-0004-000000009203'::UUID, 13, TRUE),
      -- IDF — Seine-Saint-Denis 93 (72)
      ('00000000-0000-0000-0004-000000009301'::UUID, 18, TRUE),
      ('00000000-0000-0000-0004-000000009302'::UUID, 18, TRUE),
      ('00000000-0000-0000-0004-000000009303'::UUID, 18, TRUE),
      ('00000000-0000-0000-0004-000000009304'::UUID, 18, TRUE),
      -- IDF — Val-de-Marne 94 (39)
      ('00000000-0000-0000-0004-000000009401'::UUID, 13, TRUE),
      ('00000000-0000-0000-0004-000000009402'::UUID, 13, TRUE),
      ('00000000-0000-0000-0004-000000009403'::UUID, 13, TRUE),
      -- IDF — Val-d''Oise 95 (33)
      ('00000000-0000-0000-0004-000000009501'::UUID, 11, TRUE),
      ('00000000-0000-0000-0004-000000009502'::UUID, 11, TRUE),
      ('00000000-0000-0000-0004-000000009503'::UUID, 11, TRUE),
      -- Hors IDF — Auvergne-Rhône-Alpes (22)
      ('00000000-0000-0000-0004-000000010101'::UUID, 11, FALSE),
      ('00000000-0000-0000-0004-000000010102'::UUID, 11, FALSE),
      -- Hors IDF — Bourgogne-Franche-Comté (10)
      ('00000000-0000-0000-0004-000000010201'::UUID, 10, FALSE),
      -- Hors IDF — Bretagne (12)
      ('00000000-0000-0000-0004-000000010301'::UUID, 12, FALSE),
      -- Hors IDF — Centre-Val de Loire (10)
      ('00000000-0000-0000-0004-000000010401'::UUID, 10, FALSE),
      -- Hors IDF — Grand Est (16)
      ('00000000-0000-0000-0004-000000010501'::UUID, 8,  FALSE),
      ('00000000-0000-0000-0004-000000010502'::UUID, 8,  FALSE),
      -- Hors IDF — Hauts-de-France (22)
      ('00000000-0000-0000-0004-000000010601'::UUID, 12, FALSE),
      ('00000000-0000-0000-0004-000000010602'::UUID, 10, FALSE),
      -- Hors IDF — Normandie (12)
      ('00000000-0000-0000-0004-000000010701'::UUID, 12, FALSE),
      -- Hors IDF — Nouvelle-Aquitaine (12)
      ('00000000-0000-0000-0004-000000010801'::UUID, 12, FALSE),
      -- Hors IDF — Occitanie (16)
      ('00000000-0000-0000-0004-000000010901'::UUID, 8,  FALSE),
      ('00000000-0000-0000-0004-000000010902'::UUID, 8,  FALSE),
      -- Hors IDF — PACA Marseille (22)
      ('00000000-0000-0000-0004-000000011001'::UUID, 11, FALSE),
      ('00000000-0000-0000-0004-000000011002'::UUID, 11, FALSE),
      -- Hors IDF — PACA Nice (8)
      ('00000000-0000-0000-0004-000000011101'::UUID, 8,  FALSE),
      -- Hors IDF — Pays de la Loire (10)
      ('00000000-0000-0000-0004-000000011201'::UUID, 10, FALSE)
    ) AS t(cellule_id, quota, idf)
  LOOP
    FOR v_i IN 1..v_cellule.quota LOOP
      -- Genre : 55 % hommes, 45 % femmes
      IF random() < 0.55 THEN
        v_sexe   := 'homme';
        v_prenom := v_prenoms_m[1 + (floor(random() * array_length(v_prenoms_m, 1)))::INT];
      ELSE
        v_sexe   := 'femme';
        v_prenom := v_prenoms_f[1 + (floor(random() * array_length(v_prenoms_f, 1)))::INT];
      END IF;

      v_nom    := v_noms[1 + (floor(random() * array_length(v_noms, 1)))::INT];
      v_statut := v_statuts[1 + (floor(random() * array_length(v_statuts, 1)))::INT];

      -- Ville cohérente avec la zone géographique
      IF v_cellule.idf THEN
        v_ville := v_villes_idf[1 + (floor(random() * array_length(v_villes_idf, 1)))::INT];
      ELSE
        v_ville := v_villes_nat[1 + (floor(random() * array_length(v_villes_nat, 1)))::INT];
      END IF;

      -- Date d'adhésion étalée sur les 3 dernières années
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
        v_cellule.cellule_id,
        v_user_id
      );
    END LOOP;
  END LOOP;

  RAISE NOTICE '✓ 500 militants insérés (328 IDF + 172 hors IDF)';
END $$;