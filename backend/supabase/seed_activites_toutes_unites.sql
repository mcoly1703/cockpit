-- ============================================================
-- ACTIVITÉS TOUTES UNITÉS — transactions, événements,
-- prospects, réunions, élections pour les unités manquantes
-- À exécuter dans le SQL Editor Supabase
-- ============================================================

DO $$
DECLARE
  v_user_id UUID;

  -- Unités
  v_bex   CONSTANT UUID := '00000000-0000-0000-0000-000000000001';
  v_ss075 CONSTANT UUID := '00000000-0000-0000-0001-000000000075';
  v_ss077 CONSTANT UUID := '00000000-0000-0000-0001-000000000077';
  v_ss078 CONSTANT UUID := '00000000-0000-0000-0001-000000000078';
  v_ss091 CONSTANT UUID := '00000000-0000-0000-0001-000000000091';
  v_ss092 CONSTANT UUID := '00000000-0000-0000-0001-000000000092';
  v_ss093 CONSTANT UUID := '00000000-0000-0000-0001-000000000093';
  v_ss094 CONSTANT UUID := '00000000-0000-0000-0001-000000000094';
  v_ss095 CONSTANT UUID := '00000000-0000-0000-0001-000000000095';
  v_jps   CONSTANT UUID := '00000000-0000-0000-0002-000000000001';
  v_mojip CONSTANT UUID := '00000000-0000-0000-0002-000000000002';
  v_moncap CONSTANT UUID := '00000000-0000-0000-0002-000000000003';
  v_maggi  CONSTANT UUID := '00000000-0000-0000-0002-000000000004';

  -- Nouveaux événements
  v_e09 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000009';
  v_e10 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000010';
  v_e11 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000011';
  v_e12 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000012';
  v_e13 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000013';
  v_e14 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000014';
  v_e15 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000015';
  v_e16 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000016';
  v_e17 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000017';
  v_e18 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000018';

  -- Nouvelles réunions
  v_r07 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000007';
  v_r08 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000008';
  v_r09 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000009';
  v_r10 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000010';
  v_r11 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000011';
  v_r12 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000012';
  v_r13 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000013';
  v_r14 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000014';

  -- Nouveaux scrutins
  v_s04 CONSTANT UUID := 'cccccccc-0000-0000-0000-000000000004';
  v_s05 CONSTANT UUID := 'cccccccc-0000-0000-0000-000000000005';
  v_s06 CONSTANT UUID := 'cccccccc-0000-0000-0000-000000000006';

BEGIN
  SELECT id INTO v_user_id FROM auth.users LIMIT 1;


-- ════════════════════════════════════════════════════════════
-- 1. TRANSACTIONS — toutes les unités manquantes
-- ════════════════════════════════════════════════════════════
INSERT INTO transactions (unite_id, type, montant, date_transaction, categorie, description, created_by)
VALUES
  -- ── SS-091 Essonne ──
  (v_ss091, 'entree',  280.00, '2026-01-31', 'cotisation',     'Cotisations jan 2026',             v_user_id),
  (v_ss091, 'entree',  310.00, '2026-02-28', 'cotisation',     'Cotisations fév 2026',             v_user_id),
  (v_ss091, 'entree',  260.00, '2026-03-31', 'cotisation',     'Cotisations mars 2026',            v_user_id),
  (v_ss091, 'entree',  290.00, '2026-04-30', 'cotisation',     'Cotisations avr 2026',             v_user_id),
  (v_ss091, 'entree',  120.00, '2026-03-10', 'don',            'Don d''un sympathisant Évry',      v_user_id),
  (v_ss091, 'depense',  80.00, '2026-02-15', 'logistique',     'Location salle Évry',              v_user_id),
  (v_ss091, 'depense',  55.00, '2026-04-05', 'materiel',       'Impression tracts',                v_user_id),
  -- ── SS-094 Val-de-Marne ──
  (v_ss094, 'entree',  210.00, '2026-01-31', 'cotisation',     'Cotisations jan 2026',             v_user_id),
  (v_ss094, 'entree',  240.00, '2026-02-28', 'cotisation',     'Cotisations fév 2026',             v_user_id),
  (v_ss094, 'entree',  195.00, '2026-03-31', 'cotisation',     'Cotisations mars 2026',            v_user_id),
  (v_ss094, 'entree',  220.00, '2026-04-30', 'cotisation',     'Cotisations avr 2026',             v_user_id),
  (v_ss094, 'entree',   80.00, '2026-02-20', 'don',            'Don militant Créteil',             v_user_id),
  (v_ss094, 'depense',  65.00, '2026-03-12', 'logistique',     'Transport porte-à-porte',          v_user_id),
  (v_ss094, 'depense',  40.00, '2026-04-18', 'communication',  'Visuels réseaux sociaux',          v_user_id),
  -- ── SS-077 Seine-et-Marne ──
  (v_ss077, 'entree',  160.00, '2026-01-31', 'cotisation',     'Cotisations jan 2026',             v_user_id),
  (v_ss077, 'entree',  175.00, '2026-02-28', 'cotisation',     'Cotisations fév 2026',             v_user_id),
  (v_ss077, 'entree',  150.00, '2026-03-31', 'cotisation',     'Cotisations mars 2026',            v_user_id),
  (v_ss077, 'entree',   90.00, '2026-03-05', 'don',            'Don sympathisant Melun',           v_user_id),
  (v_ss077, 'depense',  50.00, '2026-02-08', 'logistique',     'Location salle Melun',             v_user_id),
  -- ── SS-078 Yvelines ──
  (v_ss078, 'entree',  140.00, '2026-01-31', 'cotisation',     'Cotisations jan 2026',             v_user_id),
  (v_ss078, 'entree',  165.00, '2026-02-28', 'cotisation',     'Cotisations fév 2026',             v_user_id),
  (v_ss078, 'entree',  155.00, '2026-03-31', 'cotisation',     'Cotisations mars 2026',            v_user_id),
  (v_ss078, 'depense',  45.00, '2026-03-20', 'materiel',       'Impression flyers Versailles',     v_user_id),
  -- ── SS-095 Val-d'Oise ──
  (v_ss095, 'entree',  180.00, '2026-01-31', 'cotisation',     'Cotisations jan 2026',             v_user_id),
  (v_ss095, 'entree',  200.00, '2026-02-28', 'cotisation',     'Cotisations fév 2026',             v_user_id),
  (v_ss095, 'entree',  170.00, '2026-03-31', 'cotisation',     'Cotisations mars 2026',            v_user_id),
  (v_ss095, 'entree',   75.00, '2026-04-10', 'goodies_vente',  'Vente t-shirts Cergy',             v_user_id),
  (v_ss095, 'depense',  60.00, '2026-02-25', 'logistique',     'Location espace Argenteuil',       v_user_id),
  -- ── JPS ──
  (v_jps,   'entree',  320.00, '2026-01-31', 'cotisation',     'Cotisations jan 2026',             v_user_id),
  (v_jps,   'entree',  350.00, '2026-02-28', 'cotisation',     'Cotisations fév 2026',             v_user_id),
  (v_jps,   'entree',  300.00, '2026-03-31', 'cotisation',     'Cotisations mars 2026',            v_user_id),
  (v_jps,   'entree',  280.00, '2026-04-30', 'cotisation',     'Cotisations avr 2026',             v_user_id),
  (v_jps,   'entree',  150.00, '2026-02-14', 'benefice_event', 'Recette soirée jeunes',            v_user_id),
  (v_jps,   'entree',   60.00, '2026-04-20', 'goodies_vente',  'Vente casquettes JPS',             v_user_id),
  (v_jps,   'depense', 120.00, '2026-02-10', 'logistique',     'Location salle jeunes',            v_user_id),
  (v_jps,   'depense',  80.00, '2026-03-15', 'materiel',       'Banderoles et goodies',            v_user_id),
  (v_jps,   'depense',  45.00, '2026-04-22', 'communication',  'Création contenu réseaux',         v_user_id),
  -- ── MOJIP ──
  (v_mojip, 'entree',  290.00, '2026-01-31', 'cotisation',     'Cotisations jan 2026',             v_user_id),
  (v_mojip, 'entree',  320.00, '2026-02-28', 'cotisation',     'Cotisations fév 2026',             v_user_id),
  (v_mojip, 'entree',  310.00, '2026-03-31', 'cotisation',     'Cotisations mars 2026',            v_user_id),
  (v_mojip, 'entree',  330.00, '2026-04-30', 'cotisation',     'Cotisations avr 2026',             v_user_id),
  (v_mojip, 'entree',  200.00, '2026-03-08', 'benefice_event', 'Recette journée 8 mars',           v_user_id),
  (v_mojip, 'entree',   85.00, '2026-04-05', 'goodies_vente',  'Vente pagnes MOJIP',               v_user_id),
  (v_mojip, 'depense', 140.00, '2026-03-07', 'logistique',     'Organisation journée femmes',      v_user_id),
  (v_mojip, 'depense',  70.00, '2026-04-15', 'formation',      'Atelier leadership féminin',       v_user_id),
  -- ── MONCAP ──
  (v_moncap,'entree',  400.00, '2026-01-31', 'cotisation',     'Cotisations jan 2026',             v_user_id),
  (v_moncap,'entree',  450.00, '2026-02-28', 'cotisation',     'Cotisations fév 2026',             v_user_id),
  (v_moncap,'entree',  420.00, '2026-03-31', 'cotisation',     'Cotisations mars 2026',            v_user_id),
  (v_moncap,'entree',  380.00, '2026-04-30', 'cotisation',     'Cotisations avr 2026',             v_user_id),
  (v_moncap,'entree',  500.00, '2026-02-20', 'don',            'Don cadre — contribution spéciale',v_user_id),
  (v_moncap,'depense', 200.00, '2026-02-18', 'formation',      'Séminaire cadres Paris',           v_user_id),
  (v_moncap,'depense', 120.00, '2026-03-25', 'deplacements',   'Déplacements cadres IDF',          v_user_id),
  (v_moncap,'depense',  90.00, '2026-04-12', 'communication',  'Production document stratégique',  v_user_id),
  -- ── Maggi Pastef ──
  (v_maggi, 'entree',  180.00, '2026-02-28', 'cotisation',     'Cotisations fév 2026',             v_user_id),
  (v_maggi, 'entree',  160.00, '2026-03-31', 'cotisation',     'Cotisations mars 2026',            v_user_id),
  (v_maggi, 'entree',   95.00, '2026-03-20', 'goodies_vente',  'Vente produits Maggi',             v_user_id),
  (v_maggi, 'depense',  55.00, '2026-03-15', 'logistique',     'Organisation stand Maggi',         v_user_id)
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 2. ÉVÉNEMENTS — une activité par unité manquante
-- ════════════════════════════════════════════════════════════
INSERT INTO evenements (id, unite_id, titre, type, date_debut, date_fin, lieu, description, created_by)
VALUES
  (v_e09, v_ss091, 'Porte-à-porte Évry',              'porte_a_porte', '2026-03-21 10:00+01', '2026-03-21 14:00+01', 'Centre-ville, Évry',             'Sensibilisation quartiers populaires',       v_user_id),
  (v_e10, v_ss091, 'Réunion militants Essonne',        'reunion_publique','2026-05-05 19:00+01','2026-05-05 21:00+01', 'MJC d''Évry',                    'Bilan porte-à-porte et perspectives',        v_user_id),
  (v_e11, v_ss094, 'Rencontre citoyenne Créteil',      'reunion_publique','2026-02-18 19:00+01','2026-02-18 21:00+01', 'Maison pour tous, Créteil',      'Échanges avec habitants du Val-de-Marne',    v_user_id),
  (v_e12, v_ss094, 'Distribution tracts Vitry',        'porte_a_porte', '2026-04-25 10:00+01', '2026-04-25 13:00+01', 'Marché de Vitry-sur-Seine',      'Campagne de massification',                  v_user_id),
  (v_e13, v_ss077, 'Réunion publique Melun',           'reunion_publique','2026-03-14 19:00+01','2026-03-14 21:00+01', 'Salle des fêtes, Melun',         'Présentation programme Pastef',              v_user_id),
  (v_e14, v_ss078, 'Formation militants Versailles',   'formation',     '2026-04-18 10:00+01', '2026-04-18 16:00+01', 'Bibliothèque, Versailles',       'Formation organisation militante',           v_user_id),
  (v_e15, v_ss095, 'Meeting Cergy-Pontoise',           'meeting',       '2026-05-16 15:00+01', '2026-05-16 19:00+01', 'Espace culturel, Cergy',         'Meeting mobilisation Val-d''Oise',           v_user_id),
  (v_e16, v_jps,   'Forum jeunes — Perspectives',      'formation',     '2026-03-29 14:00+01', '2026-03-29 18:00+01', 'CROUS Paris Nord',               'Échanges jeunes militants IDF',              v_user_id),
  (v_e17, v_mojip, 'Journée Femmes Patriotes',         'reunion_publique','2026-03-08 10:00+01','2026-03-08 18:00+01', 'Centre culturel africain, Paris','Célébration journée internationale femmes',  v_user_id),
  (v_e18, v_moncap,'Séminaire Cadres Patriotes',       'formation',     '2026-04-05 09:00+01', '2026-04-05 17:00+01', 'Hôtel Mercure, Paris 15e',       'Formation cadres — gouvernance et stratégie',v_user_id)
ON CONFLICT (id) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 3. PROSPECTS — toutes les unités
-- ════════════════════════════════════════════════════════════
INSERT INTO prospects (unite_id, nom, prenom, telephone, email, ville, sexe, etape, date_contact, mouvement_interet, notes, created_by)
VALUES
  -- SS-091 Essonne
  (v_ss091, 'Koné',    'Souleymane',  '+33622000001', NULL,                      'Évry',       'M', 'contact',      '2026-04-15', 'JPS',    'Rencontré au forum emploi',             v_user_id),
  (v_ss091, 'Diarra',  'Mariam',      '+33622000002', 'mariam.d@gmail.com',      'Corbeil',    'F', 'sympathisant', '2026-03-10', 'MOJIP',  'Suit nos publications',                 v_user_id),
  (v_ss091, 'Baldé',   'Oumar',       '+33622000003', NULL,                      'Massy',      'M', 'adherent',     '2026-02-05', NULL,     'Prêt à adhérer — relance en cours',     v_user_id),
  -- SS-094 Val-de-Marne
  (v_ss094, 'Camara',  'Fatoumata',   '+33622000010', NULL,                      'Créteil',    'F', 'contact',      '2026-05-02', 'MOJIP',  'Contactée via réunion quartier',        v_user_id),
  (v_ss094, 'Ndiaye',  'Pape',        '+33622000011', 'pape.n@yahoo.fr',         'Ivry',       'M', 'sympathisant', '2026-03-20', NULL,     'Intéressé, demande de la doc',          v_user_id),
  (v_ss094, 'Sow',     'Khadidiatou', '+33622000012', NULL,                      'Vitry',      'F', 'adherent',     '2026-04-01', 'MOJIP',  'Formulaire rempli — en attente carte',  v_user_id),
  -- SS-077 Seine-et-Marne
  (v_ss077, 'Fall',    'Mamadou S.',  '+33622000020', NULL,                      'Melun',      'M', 'contact',      '2026-04-20', NULL,     'Rencontré au marché de Melun',          v_user_id),
  (v_ss077, 'Diallo',  'Hawa',        '+33622000021', 'hawa.d@gmail.com',        'Meaux',      'F', 'sympathisant', '2026-03-15', 'MOJIP',  'Active sur les réseaux',                v_user_id),
  -- SS-078 Yvelines
  (v_ss078, 'Sarr',    'Cheikh A.',   '+33622000030', NULL,                      'Versailles', 'M', 'contact',      '2026-04-08', 'JPS',    'Jeune rencontré à la fac',              v_user_id),
  (v_ss078, 'Touré',   'Aïssatou',    '+33622000031', 'aissatou.t@hotmail.fr',   'Poissy',     'F', 'adherent',     '2026-03-25', 'MOJIP',  'Très motivée, parraine 2 amies',        v_user_id),
  -- SS-095 Val-d'Oise
  (v_ss095, 'Gueye',   'Lamine',      '+33622000040', NULL,                      'Cergy',      'M', 'contact',      '2026-05-10', NULL,     'Passant lors du meeting',               v_user_id),
  (v_ss095, 'Mbaye',   'Fatou',       '+33622000041', 'fatou.m@gmail.com',       'Argenteuil', 'F', 'sympathisant', '2026-04-12', 'MOJIP',  'Connue via le réseau MOJIP',            v_user_id),
  (v_ss095, 'Niang',   'Ibrahima',    '+33622000042', NULL,                      'Sarcelles',  'M', 'adherent',     '2026-03-30', 'JPS',    'Dossier complet — validation en cours', v_user_id),
  -- JPS
  (v_jps,   'Diouf',   'Moussa Jr',   '+33622000050', NULL,                      'Paris',      'M', 'contact',      '2026-04-25', 'JPS',    'Étudiant Sorbonne rencontré au forum',  v_user_id),
  (v_jps,   'Faye',    'Astou',       '+33622000051', NULL,                      'Montreuil',  'F', 'sympathisant', '2026-04-18', 'JPS',    'Jeune militante potentielle',           v_user_id),
  (v_jps,   'Konaté',  'Souleymane',  '+33622000052', 'soul.k@gmail.com',        'Paris',      'M', 'converti',     '2026-02-15', 'JPS',    'A rejoint JPS — carte en cours',        v_user_id),
  -- MOJIP
  (v_mojip, 'Diatta',  'Mariama',     '+33622000060', 'mariama.d@gmail.com',     'Paris',      'F', 'contact',      '2026-05-05', 'MOJIP',  'Rencontrée journée 8 mars',             v_user_id),
  (v_mojip, 'Badji',   'Ndéye Aby',   '+33622000061', NULL,                      'Aubervilliers','F','sympathisant', '2026-04-22', 'MOJIP',  'Suit nos actions depuis 2 mois',        v_user_id),
  (v_mojip, 'Sané',    'Yaye',        '+33622000062', 'yaye.s@hotmail.fr',       'Saint-Denis','F', 'adherent',     '2026-03-18', 'MOJIP',  'Parraine 3 nouvelles membres',          v_user_id),
  (v_mojip, 'Coly',    'Ndéye Fatou', '+33622000063', NULL,                      'Paris',      'F', 'converti',     '2026-01-20', 'MOJIP',  'Militante active — coordinatrice cell.', v_user_id),
  -- MONCAP
  (v_moncap,'Ba',      'Mamadou',     '+33622000070', 'ba.mamadou@gmail.com',    'Paris',      'M', 'contact',      '2026-04-30', NULL,     'Cadre rencontré au séminaire',          v_user_id),
  (v_moncap,'Diop',    'Rokhaya',     '+33622000071', 'r.diop@yahoo.fr',         'Boulogne',   'F', 'sympathisant', '2026-03-22', 'MOJIP',  'Cadre intéressée par MONCAP',           v_user_id),
  (v_moncap,'Toure',   'Boubacar',    '+33622000072', 'b.toure@gmail.com',       'Paris',      'M', 'adherent',     '2026-02-28', NULL,     'Ingénieur, souhaite intégrer bureau',   v_user_id)
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 4. RÉUNIONS — une par unité manquante
-- ════════════════════════════════════════════════════════════
INSERT INTO reunions (id, unite_id, titre, type, date, lieu, ordre_du_jour, created_by)
VALUES
  (v_r07, v_ss091, 'Réunion SS Essonne — fév 2026',        'sous_section', '2026-02-16 19:00+01', 'MJC d''Évry',                   E'1. Bilan recrutement\n2. Cotisations\n3. Événements à venir',        v_user_id),
  (v_r08, v_ss094, 'Réunion SS Val-de-Marne — mars 2026',  'sous_section', '2026-03-09 19:00+01', 'Mairie annexe, Créteil',        E'1. Porte-à-porte mars\n2. Nouveaux membres\n3. Budget',              v_user_id),
  (v_r09, v_ss077, 'Réunion SS Seine-et-Marne — avr 2026', 'sous_section', '2026-04-13 19:00+01', 'Café citoyen, Melun',           E'1. Meeting Melun\n2. Massification\n3. Divers',                      v_user_id),
  (v_r10, v_ss078, 'Réunion SS Yvelines — mars 2026',      'sous_section', '2026-03-23 19:00+01', 'Salle polyvalente, Versailles', E'1. Formation militante\n2. Prospects\n3. Planning été',              v_user_id),
  (v_r11, v_ss095, 'Réunion SS Val-d''Oise — avr 2026',    'sous_section', '2026-04-20 19:00+01', 'Espace Cergy Pontoise',         E'1. Bilan meeting\n2. Cellules actives\n3. Budget',                   v_user_id),
  (v_r12, v_jps,   'Réunion JPS — avr 2026',               'autre',        '2026-04-19 18:00+01', 'Foyer jeunes, Paris 18e',       E'1. Forum jeunes bilan\n2. Recrutement campus\n3. Été actif',         v_user_id),
  (v_r13, v_mojip, 'Réunion MOJIP — mars 2026',             'autre',        '2026-03-15 18:00+01', 'Centre culturel, Paris 10e',    E'1. Journée 8 mars bilan\n2. Nouveaux prospects\n3. Formation',       v_user_id),
  (v_r14, v_moncap,'Réunion MONCAP — fév 2026',             'autre',        '2026-02-22 18:00+01', 'Hôtel Mercure, Paris 15e',      E'1. Présentation MONCAP\n2. Recrutement cadres\n3. Séminaire avr',   v_user_id)
ON CONFLICT (id) DO NOTHING;

-- Décisions des nouvelles réunions
INSERT INTO decisions (reunion_id, texte, responsable, echeance, statut)
VALUES
  (v_r07, 'Organiser 2 portes-à-porte dans Évry avant fin mars',    'Resp. SS-091',  '2026-03-31', 'terminee'),
  (v_r07, 'Relancer 5 prospects en attente',                         'Resp. SS-091',  '2026-03-15', 'terminee'),
  (v_r08, 'Constituer liste militants à jour pour cotisations',      'Resp. SS-094',  '2026-04-01', 'en_cours'),
  (v_r08, 'Planifier meeting Créteil pour juin',                     'Resp. SS-094',  '2026-05-15', 'en_attente'),
  (v_r09, 'Mobiliser 20 militants pour meeting Melun',               'Resp. SS-077',  '2026-04-30', 'en_cours'),
  (v_r10, 'Lancer recrutement campus Versailles',                    'Resp. SS-078',  '2026-04-30', 'en_cours'),
  (v_r11, 'Ouvrir nouvelle cellule à Argenteuil',                    'Resp. SS-095',  '2026-06-01', 'en_attente'),
  (v_r12, 'Recruter 15 jeunes dans les universités IDF',             'Resp. JPS',     '2026-06-30', 'en_cours'),
  (v_r12, 'Organiser soirée débat pour les jeunes en mai',           'Resp. JPS',     '2026-05-31', 'en_attente'),
  (v_r13, 'Documenter les actions du 8 mars pour le rapport',        'Resp. MOJIP',   '2026-03-31', 'terminee'),
  (v_r13, 'Préparer atelier leadership féminin pour avril',          'Resp. MOJIP',   '2026-04-15', 'terminee'),
  (v_r14, 'Identifier 20 cadres potentiels en IDF',                  'Resp. MONCAP',  '2026-04-30', 'en_cours'),
  (v_r14, 'Préparer programme séminaire cadres avril',               'Resp. MONCAP',  '2026-03-31', 'terminee')
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 5. ÉLECTIONS — scrutins supplémentaires
-- ════════════════════════════════════════════════════════════
INSERT INTO scrutins (id, unite_id, titre, type, date_scrutin, statut, description)
VALUES
  (v_s04, v_ss091, 'Élection bureau SS-091 — mai 2026',   'interne', '2026-05-28', 'ouvert',
   'Élection du bureau de la sous-section Essonne'),
  (v_s05, v_mojip, 'Élection bureau MOJIP — mars 2026',   'interne', '2026-03-30', 'clos',
   'Renouvellement du bureau du Mouvement des Femmes Patriotes'),
  (v_s06, v_jps,   'Élection bureau JPS — juil. 2026',    'interne', '2026-07-15', 'en_preparation',
   'Élection du bureau des Jeunes Patriotes du Sénégal')
ON CONFLICT (id) DO NOTHING;

INSERT INTO candidats_election (scrutin_id, militant_id, nom, prenom, poste, voix, elu)
VALUES
  -- s04 SS-091 ouvert (voix partielles)
  (v_s04, NULL, 'Baldé',    'Oumar',     'coordinateur',      12, false),
  (v_s04, NULL, 'Koné',     'Aminata',   'coordinateur',       8, false),
  (v_s04, NULL, 'Diarra',   'Lamine',    'resp_finances',      0, false),
  -- s05 MOJIP clos
  (v_s05, NULL, 'Sané',     'Yaye',       'coordinateur',      31, true),
  (v_s05, NULL, 'Diatta',   'Mariama',    'coordinateur',      14, false),
  (v_s05, NULL, 'Badji',    'Ndéye Aby',  'resp_massification', 45, true),
  -- s06 JPS en préparation (pas encore de candidats officiels)
  (v_s06, NULL, 'Konaté',   'Souleymane', 'coordinateur',       0, false)
ON CONFLICT DO NOTHING;

END $$;