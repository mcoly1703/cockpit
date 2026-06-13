-- ============================================================
-- DONNÉES DE TEST — Cockpit Pastef France
-- À exécuter dans le SQL Editor Supabase (pas comme migration)
-- Couvre : militants, finances, événements, réunions, prospects,
--          bureau, élections, comptes rendus
-- ============================================================

DO $$
DECLARE
  v_user_id UUID;

  -- Unités (déjà créées dans seed.sql)
  v_bex   CONSTANT UUID := '00000000-0000-0000-0000-000000000001';
  v_ss075 CONSTANT UUID := '00000000-0000-0000-0001-000000000075';
  v_ss093 CONSTANT UUID := '00000000-0000-0000-0001-000000000093';

  -- IDs militants SS-075 Paris
  v_m01 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000001';
  v_m02 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000002';
  v_m03 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000003';
  v_m04 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000004';
  v_m05 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000005';
  v_m06 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000006';
  v_m07 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000007';
  v_m08 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000008';

  -- IDs militants SS-093 Seine-Saint-Denis
  v_m09 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000009';
  v_m10 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000010';
  v_m11 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000011';
  v_m12 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000012';

  -- IDs réunions
  v_r01 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000001';
  v_r02 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000002';

  -- ID scrutin
  v_s01 CONSTANT UUID := 'cccccccc-0000-0000-0000-000000000001';

BEGIN

-- ─── 1. Profil utilisateur (bureau exécutif = accès global) ──────────────
SELECT id INTO v_user_id FROM auth.users ORDER BY created_at LIMIT 1;

UPDATE profiles
SET role     = 'bureau_executif',
    nom      = 'Coly',
    prenom   = 'Marifa',
    unite_id = v_bex
WHERE id = v_user_id;

-- ─── 2. Militants — SS-075 Paris ─────────────────────────────────────────
INSERT INTO militants
  (id, unite_id, nom, prenom, sexe, statut, date_adhesion, numero_carte,
   date_naissance, telephone, ville, code_postal, created_by)
VALUES
  (v_m01, v_ss075, 'Diallo',  'Mamadou',  'M', 'actif',   '2023-03-15', 'PF-75-001', '1985-07-22', '+33612345671', 'Paris',         '75011', v_user_id),
  (v_m02, v_ss075, 'Ndiaye',  'Aminata',  'F', 'actif',   '2023-04-01', 'PF-75-002', '1990-02-14', '+33612345672', 'Paris',         '75013', v_user_id),
  (v_m03, v_ss075, 'Fall',    'Ousmane',  'M', 'actif',   '2023-05-20', 'PF-75-003', '1978-11-03', '+33612345673', 'Paris',         '75018', v_user_id),
  (v_m04, v_ss075, 'Sow',     'Fatou',    'F', 'actif',   '2023-06-10', 'PF-75-004', '1995-05-30', '+33612345674', 'Paris',         '75020', v_user_id),
  (v_m05, v_ss075, 'Diop',    'Ibrahima', 'M', 'actif',   '2024-01-08', 'PF-75-005', '1988-09-17', '+33612345675', 'Montreuil',     '93100', v_user_id),
  (v_m06, v_ss075, 'Mbaye',   'Rokhaya',  'F', 'actif',   '2024-02-14', 'PF-75-006', '1992-12-01', '+33612345676', 'Paris',         '75019', v_user_id),
  (v_m07, v_ss075, 'Gaye',    'Cheikh',   'M', 'inactif', '2022-09-05', 'PF-75-007', '1975-04-25', '+33612345677', 'Vincennes',     '94300', v_user_id),
  (v_m08, v_ss075, 'Touré',   'Mariama',  'F', 'actif',   '2024-03-22', 'PF-75-008', '1998-08-11', '+33612345678', 'Paris',         '75012', v_user_id)
ON CONFLICT (id) DO NOTHING;

-- ─── 3. Militants — SS-093 Seine-Saint-Denis ─────────────────────────────
INSERT INTO militants
  (id, unite_id, nom, prenom, sexe, statut, date_adhesion, numero_carte,
   date_naissance, telephone, ville, code_postal, created_by)
VALUES
  (v_m09, v_ss093, 'Faye',   'Samba',    'M', 'actif',   '2023-07-18', 'PF-93-001', '1983-03-12', '+33612345679', 'Saint-Denis',   '93200', v_user_id),
  (v_m10, v_ss093, 'Sarr',   'Ndéye',    'F', 'actif',   '2023-08-25', 'PF-93-002', '1991-10-07', '+33612345680', 'Aubervilliers', '93300', v_user_id),
  (v_m11, v_ss093, 'Niang',  'Modou',    'M', 'actif',   '2024-04-10', 'PF-93-003', '1987-06-19', '+33612345681', 'Montreuil',     '93100', v_user_id),
  (v_m12, v_ss093, 'Cissé',  'Bineta',   'F', 'inactif', '2022-11-30', 'PF-93-004', '1993-01-28', '+33612345682', 'Pantin',        '93500', v_user_id)
ON CONFLICT (id) DO NOTHING;

-- ─── 4. Transactions ─────────────────────────────────────────────────────
INSERT INTO transactions (unite_id, type, montant, date_transaction, categorie, description, created_by)
VALUES
  -- SS-075 entrées
  (v_ss075, 'entree',  450.00, '2025-01-31', 'cotisation',    'Cotisations collectées janvier 2025',    v_user_id),
  (v_ss075, 'entree',  200.00, '2025-02-10', 'don',           'Don anonyme — adhérent fidèle',          v_user_id),
  (v_ss075, 'entree',   85.50, '2025-03-05', 'goodies_vente', 'Vente t-shirts + macarons meeting',      v_user_id),
  (v_ss075, 'entree',  380.00, '2025-02-28', 'cotisation',    'Cotisations collectées février 2025',    v_user_id),
  -- SS-075 dépenses
  (v_ss075, 'depense', 120.00, '2025-02-22', 'logistique',    'Location salle Bastille — réunion',      v_user_id),
  (v_ss075, 'depense',  95.00, '2025-03-01', 'materiel',      'Impression affiches A3 ×200',            v_user_id),
  (v_ss075, 'depense',  60.00, '2025-03-12', 'communication', 'Boost publication Instagram',            v_user_id),
  -- SS-093 entrées/dépenses
  (v_ss093, 'entree',  310.00, '2025-02-28', 'cotisation',    'Cotisations collectées février 2025',    v_user_id),
  (v_ss093, 'depense',  75.00, '2025-03-10', 'logistique',    'Transport matériel porte-à-porte',       v_user_id)
ON CONFLICT DO NOTHING;

-- ─── 5. Cotisations ──────────────────────────────────────────────────────
INSERT INTO cotisations (militant_id, unite_id, annee, mois, montant_paye, montant_du, mode_paiement, statut, date_paiement, created_by)
VALUES
  (v_m01, v_ss075, 2025, 1, 30.00, 30.00, 'virement', 'payee',     '2025-01-10', v_user_id),
  (v_m01, v_ss075, 2025, 2, 30.00, 30.00, 'virement', 'payee',     '2025-02-08', v_user_id),
  (v_m01, v_ss075, 2025, 3, 30.00, 30.00, 'especes',  'payee',     '2025-03-05', v_user_id),
  (v_m02, v_ss075, 2025, 1, 30.00, 30.00, 'virement', 'payee',   '2025-01-15', v_user_id),
  (v_m02, v_ss075, 2025, 2, 15.00, 30.00, 'especes',  'partiel', '2025-02-20', v_user_id),
  (v_m03, v_ss075, 2025, 1, 30.00, 30.00, 'especes',  'payee',   '2025-01-20', v_user_id),
  (v_m03, v_ss075, 2025, 2, 30.00, 30.00, 'especes',  'payee',   '2025-02-18', v_user_id),
  (v_m09, v_ss093, 2025, 1, 30.00, 30.00, 'virement', 'payee',     '2025-01-12', v_user_id),
  (v_m09, v_ss093, 2025, 2, 30.00, 30.00, 'virement', 'payee',     '2025-02-14', v_user_id),
  (v_m10, v_ss093, 2025, 1, 30.00, 30.00, 'cheque',   'payee',     '2025-01-18', v_user_id)
ON CONFLICT (militant_id, annee, mois) DO NOTHING;

-- ─── 6. Événements ───────────────────────────────────────────────────────
INSERT INTO evenements (unite_id, titre, type, date_debut, date_fin, lieu, description, created_by)
VALUES
  -- Terminés
  (v_ss075, 'Réunion publique Bastille',        'reunion_publique', '2025-02-15 14:00+01', '2025-02-15 17:00+01', 'Salle Bastille, Paris 11e',       'Présentation du programme local et Q&A avec les habitants', v_user_id),
  (v_ss093, 'Porte-à-porte Saint-Denis',        'porte_a_porte',   '2025-02-22 09:00+01', '2025-02-22 13:00+01', 'Quartier Plaine, Saint-Denis',    'Sensibilisation dans le quartier Plaine Saint-Denis',       v_user_id),
  (v_ss075, 'Formation militants Paris',         'formation',       '2025-03-08 10:00+01', '2025-03-08 16:00+01', 'Maison des asso., Paris 19e',     'Formation sur les outils numériques militants',             v_user_id),
  -- À venir
  (v_ss075, 'Meeting Paris Est',                'meeting',         '2026-06-28 15:00+01', '2026-06-28 19:00+01', 'Salle de la Forge, Paris 20e',    'Meeting de mobilisation avant les vacances d''été',         v_user_id),
  (v_ss093, 'Marche solidarité Seine-St-Denis', 'marche',          '2026-07-14 10:00+01', '2026-07-14 14:00+01', 'Place de la République, St-Denis','Marche citoyenne et festive — ouvert à tous',               v_user_id)
ON CONFLICT DO NOTHING;

-- ─── 7. Réunions ─────────────────────────────────────────────────────────
INSERT INTO reunions (id, unite_id, titre, type, date, lieu, ordre_du_jour, created_by)
VALUES
  (v_r01, v_bex,   'Bureau mensuel — mars 2025',       'bureau',       '2025-03-10 19:00+01', 'Siège France, Paris 10e',    E'1. Bilan financier T1\n2. Campagne massification printemps\n3. Questions diverses', v_user_id),
  (v_r02, v_ss075, 'Réunion SS Paris — février 2025',  'sous_section', '2025-02-24 19:30+01', 'Café associatif, Paris 18e', E'1. Retour porte-à-porte\n2. Planning mars\n3. Cotisations en retard',              v_user_id)
ON CONFLICT (id) DO NOTHING;

-- ─── 8. Décisions ────────────────────────────────────────────────────────
INSERT INTO decisions (reunion_id, texte, responsable, echeance, statut)
VALUES
  (v_r01, 'Lancer campagne réseaux sociaux — objectif 500 abonnés',       'Aminata Ndiaye', '2025-04-15', 'en_cours'),
  (v_r01, 'Organiser formation finances pour les responsables de cellule', 'Mamadou Diallo', '2025-05-01', 'en_attente'),
  (v_r02, 'Relancer par téléphone les militants avec cotisation en retard','Ousmane Fall',   '2025-03-15', 'terminee'),
  (v_r02, 'Préparer liste prospects à contacter pour avril',               'Fatou Sow',      '2025-03-31', 'en_cours')
ON CONFLICT DO NOTHING;

-- ─── 9. Prospects ────────────────────────────────────────────────────────
INSERT INTO prospects (unite_id, nom, prenom, telephone, email, ville, sexe, etape, date_contact, mouvement_interet, notes, created_by)
VALUES
  (v_ss075, 'Sy',     'Abdoulaye',  '+33611111111', 'abdoulaye.sy@gmail.com', 'Paris',        'M', 'contact',      '2025-03-01', 'JPS',   'Rencontré au marché Château Rouge',                   v_user_id),
  (v_ss075, 'Ba',     'Ndéye Fatou','+33611111112', 'nf.ba@hotmail.fr',       'Aubervilliers','F', 'sympathisant', '2025-02-10', 'MOJIP', 'Très intéressée, a assisté à la formation',           v_user_id),
  (v_ss075, 'Mbodj',  'Lamine',     '+33611111113', NULL,                     'Paris',        'M', 'adherent',     '2025-01-20', NULL,    'A rempli le formulaire QR lors du meeting de janvier', v_user_id),
  (v_ss075, 'Diagne', 'Pape',        '+33611111114', 'p.diagne@yahoo.fr',     'Créteil',      'M', 'converti',     '2024-12-05', 'Cadres','Converti en militant — en attente de carte',          v_user_id),
  (v_ss075, 'Kane',   'Aissatou',   '+33611111115', NULL,                     'Bobigny',      'F', 'contact',      '2025-03-18', 'MOJIP', 'Contactée via un ami commun',                         v_user_id),
  (v_ss093, 'Camara', 'Seydou',     '+33611111116', 'seydou.c@gmail.com',     'Villepinte',   'M', 'sympathisant', '2025-02-25', 'JPS',   'Suit nos publications, intéressé par les JPS',        v_user_id)
ON CONFLICT DO NOTHING;

-- ─── 10. Postes bureau (BEX) ─────────────────────────────────────────────
-- Les noms/prénoms sont récupérés via JOIN avec militants, pas stockés ici
INSERT INTO postes_bureau (unite_id, intitule, militant_id, date_nomination, created_by)
VALUES
  (v_bex, 'coordinateur',       v_m01, '2024-01-15', v_user_id),
  (v_bex, 'resp_finances',      v_m02, '2024-01-15', v_user_id),
  (v_bex, 'resp_communication', v_m03, '2024-01-15', v_user_id),
  (v_bex, 'resp_massification', v_m04, '2024-02-01', v_user_id),
  (v_bex, 'resp_it',            v_m06, '2024-02-01', v_user_id)
ON CONFLICT (unite_id, intitule) DO NOTHING;

-- ─── 11. Scrutin interne SS-075 ──────────────────────────────────────────
-- scrutins n'a pas de colonne created_by
INSERT INTO scrutins (id, unite_id, titre, type, date_scrutin, statut, description)
VALUES
  (v_s01, v_ss075, 'Élection bureau local — SS Paris', 'interne', '2025-03-20', 'clos',
   'Élection du coordinateur et de son adjoint pour la sous-section Paris')
ON CONFLICT (id) DO NOTHING;

-- candidats_election stocke nom/prenom directement (pas de JOIN)
INSERT INTO candidats_election (scrutin_id, militant_id, nom, prenom, poste, voix, elu)
VALUES
  (v_s01, v_m03, 'Fall',  'Ousmane',  'coordinateur',      14, TRUE),
  (v_s01, v_m05, 'Diop',  'Ibrahima', 'coordinateur',       8, FALSE),
  (v_s01, v_m04, 'Sow',   'Fatou',    'vice_coordinateur', 19, TRUE),
  (v_s01, v_m08, 'Touré', 'Mariama',  'vice_coordinateur',  3, FALSE)
ON CONFLICT DO NOTHING;

-- ─── 12. Comptes rendus d'activité ───────────────────────────────────────
INSERT INTO comptes_rendus
  (unite_id, mois, annee, statut, description_activites,
   nouveaux_contacts, evenements_tenus, presences_total, cotisations_collectees,
   difficultes, observations_coordinateur, soumis_at)
VALUES
  (v_ss075, 2, 2025, 'soumis',
   'Organisation d''un porte-à-porte dans le 18e ayant mobilisé 12 militants. Réunion de sous-section avec 22 présents. Distribution de 150 tracts et 30 adhésions collectées.',
   8, 2, 34, 240.00,
   'Difficultés à atteindre les militants du 13e arrondissement en raison des horaires de travail.',
   'Bon travail d''ensemble. Intensifier le démarchage dans le 13e en soirée.',
   '2025-03-05 10:30:00+01'),
  (v_ss093, 2, 2025, 'brouillon',
   'Porte-à-porte quartier Plaine avec 8 militants. Collecte de cotisations en cours pour février.',
   3, 1, 8, 120.00, NULL, NULL, NULL)
ON CONFLICT (unite_id, mois, annee) DO NOTHING;

RAISE NOTICE '✓ Données de test insérées. Profil mis à jour : rôle bureau_executif, unité BEX.';
END $$;