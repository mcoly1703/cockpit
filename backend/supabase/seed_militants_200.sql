-- ============================================================
-- SEED 200 militants de test générés aléatoirement
-- À exécuter dans le SQL Editor Supabase
-- ============================================================

DO $$
DECLARE
  v_user_id UUID;
  v_noms TEXT[] := ARRAY[
    'Diallo','Ndiaye','Fall','Sow','Diop','Mbaye','Gaye','Touré','Faye','Sarr',
    'Niang','Cissé','Konaté','Diatta','Mendy','Badiane','Traoré','Coulibaly',
    'Bah','Keita','Baldé','Sonko','Dème','Gueye','Seck','Camara','Sy','Kane',
    'Gomis','Diouf','Badji','Sané','Dramé','Ndour','Lô','Wane','Kouyaté',
    'Diabaté','Sidibé','Barry','Doumbia','Sangaré','Koné','Touré','Bamba',
    'Sissoko','Dembélé','Bagayoko','Coulibaly','Traoré'
  ];
  v_prenoms_m TEXT[] := ARRAY[
    'Mamadou','Ousmane','Ibrahima','Samba','Modou','Amadou','Alioune','Cheikh',
    'Moussa','Lamine','Serigne','Babacar','Aliou','Abdoulaye','Seydou','Boubacar',
    'Thierno','Adama','Idrissa','Omar','Youssou','Malick','Assane','El Hadji',
    'Pape','Daouda','Gorgui','Habib','Ismaël','Jean-Pierre','François','Luc'
  ];
  v_prenoms_f TEXT[] := ARRAY[
    'Aminata','Fatou','Ndéye','Coumba','Mariama','Aissatou','Adja','Rokhaya',
    'Bineta','Khady','Fatoumata','Sokhna','Marème','Astou','Ngoné','Awa',
    'Dieynaba','Rama','Yacine','Seynabou','Penda','Binta','Oumou','Hawa',
    'Mariétou','Kadiatou','Dior','Aminata S.','Sophie','Claire','Nathalie'
  ];
  -- Unités pour les hommes (SS + JPS + MONCAP)
  v_unites_h UUID[] := ARRAY[
    '00000000-0000-0000-0001-000000000075'::UUID, -- SS-075 Paris ×5
    '00000000-0000-0000-0001-000000000075'::UUID,
    '00000000-0000-0000-0001-000000000075'::UUID,
    '00000000-0000-0000-0001-000000000075'::UUID,
    '00000000-0000-0000-0001-000000000075'::UUID,
    '00000000-0000-0000-0001-000000000093'::UUID, -- SS-093 ×3
    '00000000-0000-0000-0001-000000000093'::UUID,
    '00000000-0000-0000-0001-000000000093'::UUID,
    '00000000-0000-0000-0001-000000000092'::UUID, -- SS-092 ×2
    '00000000-0000-0000-0001-000000000092'::UUID,
    '00000000-0000-0000-0001-000000000094'::UUID, -- SS-094
    '00000000-0000-0000-0001-000000000091'::UUID, -- SS-091
    '00000000-0000-0000-0001-000000000077'::UUID, -- SS-077
    '00000000-0000-0000-0001-000000000078'::UUID, -- SS-078
    '00000000-0000-0000-0001-000000000095'::UUID, -- SS-095
    '00000000-0000-0000-0002-000000000001'::UUID, -- JPS ×2
    '00000000-0000-0000-0002-000000000001'::UUID,
    '00000000-0000-0000-0002-000000000003'::UUID, -- MONCAP ×3
    '00000000-0000-0000-0002-000000000003'::UUID,
    '00000000-0000-0000-0002-000000000003'::UUID
  ];
  -- Unités pour les femmes (MOJIP majoritaire + quelques SS)
  v_unites_f UUID[] := ARRAY[
    '00000000-0000-0000-0002-000000000002'::UUID, -- MOJIP ×13
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0002-000000000002'::UUID,
    '00000000-0000-0000-0001-000000000075'::UUID, -- SS-075 ×3
    '00000000-0000-0000-0001-000000000075'::UUID,
    '00000000-0000-0000-0001-000000000075'::UUID,
    '00000000-0000-0000-0001-000000000093'::UUID, -- SS-093 ×2
    '00000000-0000-0000-0001-000000000093'::UUID,
    '00000000-0000-0000-0002-000000000003'::UUID, -- MONCAP ×2 (cadres femmes)
    '00000000-0000-0000-0002-000000000003'::UUID
  ];
  v_statuts TEXT[] := ARRAY[
    'actif','actif','actif','actif','actif','actif','actif','actif','actif',
    'inactif','inactif','suspendu'
  ];
  i         INT;
  v_sexe    TEXT;
  v_nom     TEXT;
  v_prenom  TEXT;
  v_unite   UUID;
  v_statut  TEXT;
  v_ville   TEXT;
  v_cp      TEXT;
  v_date_adhesion  DATE;
  v_date_naissance DATE;
BEGIN
  SELECT id INTO v_user_id FROM auth.users LIMIT 1;

  FOR i IN 1..200 LOOP
    v_sexe   := CASE WHEN random() < 0.55 THEN 'M' ELSE 'F' END;
    v_nom    := v_noms[1 + (floor(random() * array_length(v_noms, 1)))::INT];
    v_prenom := CASE WHEN v_sexe = 'M'
                  THEN v_prenoms_m[1 + (floor(random() * array_length(v_prenoms_m, 1)))::INT]
                  ELSE v_prenoms_f[1 + (floor(random() * array_length(v_prenoms_f, 1)))::INT]
                END;
    v_unite  := CASE WHEN v_sexe = 'M'
                  THEN v_unites_h[1 + (floor(random() * array_length(v_unites_h, 1)))::INT]
                  ELSE v_unites_f[1 + (floor(random() * array_length(v_unites_f, 1)))::INT]
                END;
    v_statut := v_statuts[1 + (floor(random() * array_length(v_statuts, 1)))::INT];

    -- Date adhésion entre janv. 2021 et aujourd'hui
    v_date_adhesion := LEAST('2021-01-01'::DATE + (floor(random() * 1980))::INT, CURRENT_DATE);

    -- Date naissance entre 1965 et 2003
    v_date_naissance := '1965-01-01'::DATE + (floor(random() * 13880))::INT;

    -- Ville et code postal selon l'unité
    SELECT
      CASE v_unite
        WHEN '00000000-0000-0000-0001-000000000075'::UUID THEN
          (ARRAY['Paris','Montreuil','Vincennes','Bagnolet','Ivry'])[1+(floor(random()*5))::INT]
        WHEN '00000000-0000-0000-0001-000000000093'::UUID THEN
          (ARRAY['Saint-Denis','Aubervilliers','Pantin','Montreuil','Villepinte'])[1+(floor(random()*5))::INT]
        WHEN '00000000-0000-0000-0001-000000000092'::UUID THEN
          (ARRAY['Nanterre','Boulogne-Billancourt','Colombes','Asnières'])[1+(floor(random()*4))::INT]
        WHEN '00000000-0000-0000-0001-000000000094'::UUID THEN
          (ARRAY['Créteil','Ivry-sur-Seine','Vitry-sur-Seine'])[1+(floor(random()*3))::INT]
        WHEN '00000000-0000-0000-0001-000000000091'::UUID THEN
          (ARRAY['Évry','Massy','Corbeil-Essonnes'])[1+(floor(random()*3))::INT]
        WHEN '00000000-0000-0000-0001-000000000077'::UUID THEN
          (ARRAY['Melun','Meaux','Fontainebleau'])[1+(floor(random()*3))::INT]
        WHEN '00000000-0000-0000-0001-000000000078'::UUID THEN
          (ARRAY['Versailles','Saint-Germain-en-Laye','Poissy'])[1+(floor(random()*3))::INT]
        WHEN '00000000-0000-0000-0001-000000000095'::UUID THEN
          (ARRAY['Cergy','Argenteuil','Sarcelles'])[1+(floor(random()*3))::INT]
        ELSE 'Paris'
      END,
      CASE v_unite
        WHEN '00000000-0000-0000-0001-000000000075'::UUID THEN
          '750' || lpad((11 + (floor(random()*9))::INT)::TEXT, 2, '0')
        WHEN '00000000-0000-0000-0001-000000000093'::UUID THEN '93200'
        WHEN '00000000-0000-0000-0001-000000000092'::UUID THEN '92000'
        WHEN '00000000-0000-0000-0001-000000000094'::UUID THEN '94000'
        WHEN '00000000-0000-0000-0001-000000000091'::UUID THEN '91000'
        WHEN '00000000-0000-0000-0001-000000000077'::UUID THEN '77000'
        WHEN '00000000-0000-0000-0001-000000000078'::UUID THEN '78000'
        WHEN '00000000-0000-0000-0001-000000000095'::UUID THEN '95000'
        ELSE '75001'
      END
    INTO v_ville, v_cp;

    INSERT INTO militants (
      id, unite_id, nom, prenom, sexe, statut,
      date_adhesion, numero_carte, date_naissance,
      telephone, ville, code_postal, created_by
    ) VALUES (
      gen_random_uuid(),
      v_unite,
      v_nom,
      v_prenom,
      v_sexe,
      v_statut,
      v_date_adhesion,
      'PF-GEN-' || lpad(i::TEXT, 4, '0'),
      v_date_naissance,
      '+336' || lpad((10000000 + i * 37)::TEXT, 8, '0'),
      v_ville,
      v_cp,
      v_user_id
    )
    ON CONFLICT DO NOTHING;
  END LOOP;
END $$;
