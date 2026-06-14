-- ============================================================
-- DONNÉES DE TEST — Cockpit Pastef France  (v2)
-- À exécuter dans le SQL Editor Supabase (pas comme migration)
-- Couvre toutes les fonctionnalités : militants, finances,
-- événements, présences, réunions, prospects, bureau,
-- élections, comptes rendus d'activité
-- Date de référence : juin 2026
-- ============================================================

DO $$
DECLARE
  v_user_id UUID;

  -- ── Unités (déjà dans seed.sql) ──────────────────────────
  v_bex   CONSTANT UUID := '00000000-0000-0000-0000-000000000001';
  v_ss075 CONSTANT UUID := '00000000-0000-0000-0001-000000000075';
  v_ss092 CONSTANT UUID := '00000000-0000-0000-0001-000000000092';
  v_ss093 CONSTANT UUID := '00000000-0000-0000-0001-000000000093';
  v_ss094 CONSTANT UUID := '00000000-0000-0000-0001-000000000094';
  v_jps   CONSTANT UUID := '00000000-0000-0000-0002-000000000001';
  v_mojip CONSTANT UUID := '00000000-0000-0000-0002-000000000002';

  -- ── Militants SS-075 Paris ────────────────────────────────
  v_m01 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000001';
  v_m02 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000002';
  v_m03 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000003';
  v_m04 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000004';
  v_m05 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000005';
  v_m06 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000006';
  v_m07 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000007';
  v_m08 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000008';
  v_m13 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000013';
  v_m14 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000014';
  v_m15 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000015';
  v_m16 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000016';

  -- ── Militants SS-093 Seine-Saint-Denis ────────────────────
  v_m09 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000009';
  v_m10 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000010';
  v_m11 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000011';
  v_m12 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000012';
  v_m17 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000017';
  v_m18 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000018';
  v_m19 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000019';
  v_m20 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000020';

  -- ── Militants SS-092 Hauts-de-Seine ──────────────────────
  v_m21 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000021';
  v_m22 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000022';
  v_m23 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000023';
  v_m24 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000024';
  v_m25 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000025';

  -- ── Militants SS-094 Val-de-Marne ────────────────────────
  v_m26 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000026';
  v_m27 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000027';
  v_m28 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000028';

  -- ── Militants Mouvements ──────────────────────────────────
  v_m29 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000029';
  v_m30 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000030';

  -- ── Événements ────────────────────────────────────────────
  v_e01 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000001';
  v_e02 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000002';
  v_e03 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000003';
  v_e04 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000004';
  v_e05 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000005';
  v_e06 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000006';
  v_e07 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000007';
  v_e08 CONSTANT UUID := 'dddddddd-0000-0000-0000-000000000008';

  -- ── Réunions ──────────────────────────────────────────────
  v_r01 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000001';
  v_r02 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000002';
  v_r03 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000003';
  v_r04 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000004';
  v_r05 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000005';
  v_r06 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000006';

  -- ── Scrutins ──────────────────────────────────────────────
  v_s01 CONSTANT UUID := 'cccccccc-0000-0000-0000-000000000001';
  v_s02 CONSTANT UUID := 'cccccccc-0000-0000-0000-000000000002';
  v_s03 CONSTANT UUID := 'cccccccc-0000-0000-0000-000000000003';

BEGIN

-- ════════════════════════════════════════════════════════════
-- 0. PROFIL UTILISATEUR (bureau exécutif — accès global)
-- ════════════════════════════════════════════════════════════
SELECT id INTO v_user_id FROM auth.users ORDER BY created_at LIMIT 1;

UPDATE profiles
SET role     = 'bureau_executif',
    nom      = 'Coly',
    prenom   = 'Marifa',
    unite_id = v_bex
WHERE id = v_user_id;


-- ════════════════════════════════════════════════════════════
-- 1. MILITANTS
-- ════════════════════════════════════════════════════════════

-- ── SS-075 Paris (12 militants) ──────────────────────────
INSERT INTO militants (id, unite_id, nom, prenom, sexe, statut, date_adhesion, numero_carte,
  date_naissance, telephone, ville, code_postal, created_by)
VALUES
  (v_m01, v_ss075, 'Diallo',   'Mamadou',     'M', 'actif',    '2023-03-15', 'PF-75-001', '1985-07-22', '+33612345671', 'Paris',     '75011', v_user_id),
  (v_m02, v_ss075, 'Ndiaye',   'Aminata',     'F', 'actif',    '2023-04-01', 'PF-75-002', '1990-02-14', '+33612345672', 'Paris',     '75013', v_user_id),
  (v_m03, v_ss075, 'Fall',     'Ousmane',     'M', 'actif',    '2023-05-20', 'PF-75-003', '1978-11-03', '+33612345673', 'Paris',     '75018', v_user_id),
  (v_m04, v_ss075, 'Sow',      'Fatou',       'F', 'actif',    '2023-06-10', 'PF-75-004', '1995-05-30', '+33612345674', 'Paris',     '75020', v_user_id),
  (v_m05, v_ss075, 'Diop',     'Ibrahima',    'M', 'actif',    '2024-01-08', 'PF-75-005', '1988-09-17', '+33612345675', 'Montreuil', '93100', v_user_id),
  (v_m06, v_ss075, 'Mbaye',    'Rokhaya',     'F', 'actif',    '2024-02-14', 'PF-75-006', '1992-12-01', '+33612345676', 'Paris',     '75019', v_user_id),
  (v_m07, v_ss075, 'Gaye',     'Cheikh',      'M', 'inactif',  '2022-09-05', 'PF-75-007', '1975-04-25', '+33612345677', 'Vincennes', '94300', v_user_id),
  (v_m08, v_ss075, 'Touré',    'Mariama',     'F', 'actif',    '2024-03-22', 'PF-75-008', '1998-08-11', '+33612345678', 'Paris',     '75012', v_user_id),
  (v_m13, v_ss075, 'Diouf',    'Alioune',     'M', 'actif',    '2025-01-10', 'PF-75-009', '1993-03-14', '+33612345690', 'Paris',     '75010', v_user_id),
  (v_m14, v_ss075, 'Badji',    'Coumba',      'F', 'actif',    '2025-03-18', 'PF-75-010', '1996-07-08', '+33612345691', 'Paris',     '75015', v_user_id),
  (v_m15, v_ss075, 'Sané',     'Pape Alé',    'M', 'actif',    '2025-09-05', 'PF-75-011', '1982-11-21', '+33612345692', 'Paris',     '75017', v_user_id),
  (v_m16, v_ss075, 'Baldé',    'Mariétou',    'F', 'suspendu', '2024-06-30', 'PF-75-012', '1989-04-02', '+33612345693', 'Paris',     '75014', v_user_id)
ON CONFLICT (id) DO NOTHING;

-- ── SS-093 Seine-Saint-Denis (8 militants) ───────────────
INSERT INTO militants (id, unite_id, nom, prenom, sexe, statut, date_adhesion, numero_carte,
  date_naissance, telephone, ville, code_postal, created_by)
VALUES
  (v_m09, v_ss093, 'Faye',    'Samba',        'M', 'actif',    '2023-07-18', 'PF-93-001', '1983-03-12', '+33612345679', 'Saint-Denis',   '93200', v_user_id),
  (v_m10, v_ss093, 'Sarr',   'Ndéye',         'F', 'actif',    '2023-08-25', 'PF-93-002', '1991-10-07', '+33612345680', 'Aubervilliers', '93300', v_user_id),
  (v_m11, v_ss093, 'Niang',  'Modou',         'M', 'actif',    '2024-04-10', 'PF-93-003', '1987-06-19', '+33612345681', 'Montreuil',     '93100', v_user_id),
  (v_m12, v_ss093, 'Cissé',  'Bineta',        'F', 'inactif',  '2022-11-30', 'PF-93-004', '1993-01-28', '+33612345682', 'Pantin',        '93500', v_user_id),
  (v_m17, v_ss093, 'Konaté', 'Amadou',        'M', 'actif',    '2025-02-14', 'PF-93-005', '1986-08-15', '+33612345694', 'Saint-Denis',   '93200', v_user_id),
  (v_m18, v_ss093, 'Diatta', 'Adja',          'F', 'actif',    '2025-05-20', 'PF-93-006', '1994-12-03', '+33612345695', 'Aubervilliers', '93300', v_user_id),
  (v_m19, v_ss093, 'Mendy',  'Jean-Pierre',   'M', 'actif',    '2025-10-08', 'PF-93-007', '1980-02-27', '+33612345696', 'Villepinte',    '93420', v_user_id),
  (v_m20, v_ss093, 'Badiane','Khady',         'F', 'actif',    '2026-01-15', 'PF-93-008', '1997-09-11', '+33612345697', 'Montreuil',     '93100', v_user_id)
ON CONFLICT (id) DO NOTHING;

-- ── SS-092 Hauts-de-Seine (5 militants) ──────────────────
INSERT INTO militants (id, unite_id, nom, prenom, sexe, statut, date_adhesion, numero_carte,
  date_naissance, telephone, ville, code_postal, created_by)
VALUES
  (v_m21, v_ss092, 'Traoré',  'Boubacar',     'M', 'actif',    '2024-05-12', 'PF-92-001', '1984-06-30', '+33612345700', 'Boulogne',  '92100', v_user_id),
  (v_m22, v_ss092, 'Coulibaly','Fatoumata',   'F', 'actif',    '2024-07-22', 'PF-92-002', '1990-03-17', '+33612345701', 'Nanterre',  '92000', v_user_id),
  (v_m23, v_ss092, 'Bah',     'Thierno',      'M', 'actif',    '2025-04-03', 'PF-92-003', '1988-11-05', '+33612345702', 'Colombes',  '92700', v_user_id),
  (v_m24, v_ss092, 'Keita',   'Marème',       'F', 'actif',    '2025-07-18', 'PF-92-004', '1995-08-22', '+33612345703', 'Asnières',  '92600', v_user_id),
  (v_m25, v_ss092, 'Balde',   'Ibrahima S.',  'M', 'inactif',  '2023-02-10', 'PF-92-005', '1979-01-14', '+33612345704', 'Levallois', '92300', v_user_id)
ON CONFLICT (id) DO NOTHING;

-- ── SS-094 Val-de-Marne (3 militants) ────────────────────
INSERT INTO militants (id, unite_id, nom, prenom, sexe, statut, date_adhesion, numero_carte,
  date_naissance, telephone, ville, code_postal, created_by)
VALUES
  (v_m26, v_ss094, 'Sonko',   'Adama',        'M', 'actif',    '2024-09-20', 'PF-94-001', '1987-04-11', '+33612345705', 'Créteil',  '94000', v_user_id),
  (v_m27, v_ss094, 'Dème',    'Aïssatou',     'F', 'actif',    '2025-01-27', 'PF-94-002', '1992-07-25', '+33612345706', 'Vitry',    '94400', v_user_id),
  (v_m28, v_ss094, 'Gueye',   'Idrissa',      'M', 'actif',    '2025-08-14', 'PF-94-003', '1985-12-09', '+33612345707', 'Ivry',     '94200', v_user_id)
ON CONFLICT (id) DO NOTHING;

-- ── Mouvements JPS + MOJIP (2 militants) ─────────────────
INSERT INTO militants (id, unite_id, nom, prenom, sexe, statut, date_adhesion, numero_carte,
  date_naissance, telephone, ville, code_postal, created_by)
VALUES
  (v_m29, v_jps,   'Seck',    'Oumar',        'M', 'actif',    '2024-11-05', 'PF-JPS-001', '2000-06-18', '+33612345708', 'Paris',    '75018', v_user_id),
  (v_m30, v_mojip, 'Fall',    'Sokhna',       'F', 'actif',    '2024-11-05', 'PF-MJP-001', '1998-03-07', '+33612345709', 'Paris',    '75019', v_user_id)
ON CONFLICT (id) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 2. TRANSACTIONS (6 mois glissants jan–juin 2026)
-- ════════════════════════════════════════════════════════════
INSERT INTO transactions (unite_id, type, montant, date_transaction, categorie, description, created_by)
VALUES
  -- ── SS-075 Entrées 2026 ──
  (v_ss075, 'entree',  520.00, '2026-01-31', 'cotisation',       'Cotisations janvier 2026',              v_user_id),
  (v_ss075, 'entree',  490.00, '2026-02-28', 'cotisation',       'Cotisations février 2026',              v_user_id),
  (v_ss075, 'entree',  560.00, '2026-03-31', 'cotisation',       'Cotisations mars 2026',                 v_user_id),
  (v_ss075, 'entree',  430.00, '2026-04-30', 'cotisation',       'Cotisations avril 2026',                v_user_id),
  (v_ss075, 'entree',  510.00, '2026-05-31', 'cotisation',       'Cotisations mai 2026',                  v_user_id),
  (v_ss075, 'entree',  300.00, '2026-06-10', 'cotisation',       'Cotisations juin 2026 (en cours)',      v_user_id),
  (v_ss075, 'entree',  350.00, '2026-02-08', 'don',              'Don fidèle anonyme',                    v_user_id),
  (v_ss075, 'entree',  180.00, '2026-03-22', 'benefice_evenement','Recette meeting Paris Est',            v_user_id),
  (v_ss075, 'entree',   95.00, '2026-04-15', 'goodies_vente',    'Vente t-shirts + macarons',             v_user_id),
  -- ── SS-075 Dépenses 2026 ──
  (v_ss075, 'depense', 150.00, '2026-01-20', 'logistique',       'Location salle réunion janvier',        v_user_id),
  (v_ss075, 'depense', 110.00, '2026-02-10', 'materiel',         'Impression tracts ×500',                v_user_id),
  (v_ss075, 'depense',  75.00, '2026-03-05', 'communication',    'Boost publications réseaux',            v_user_id),
  (v_ss075, 'depense', 200.00, '2026-03-28', 'logistique',       'Location salle meeting Paris Est',      v_user_id),
  (v_ss075, 'depense',  60.00, '2026-04-12', 'admin',            'Fournitures bureau',                    v_user_id),
  (v_ss075, 'depense',  90.00, '2026-05-18', 'formation',        'Supports pédagogiques formation',       v_user_id),
  (v_ss075, 'depense',  45.00, '2026-06-02', 'deplacements',     'Remboursement transport bénévoles',     v_user_id),
  -- ── SS-093 Entrées 2026 ──
  (v_ss093, 'entree',  360.00, '2026-01-31', 'cotisation',       'Cotisations janvier 2026',              v_user_id),
  (v_ss093, 'entree',  390.00, '2026-02-28', 'cotisation',       'Cotisations février 2026',              v_user_id),
  (v_ss093, 'entree',  420.00, '2026-03-31', 'cotisation',       'Cotisations mars 2026',                 v_user_id),
  (v_ss093, 'entree',  380.00, '2026-04-30', 'cotisation',       'Cotisations avril 2026',                v_user_id),
  (v_ss093, 'entree',  410.00, '2026-05-31', 'cotisation',       'Cotisations mai 2026',                  v_user_id),
  (v_ss093, 'entree',  150.00, '2026-03-10', 'don',              'Don d''un sympathisant local',          v_user_id),
  -- ── SS-093 Dépenses 2026 ──
  (v_ss093, 'depense',  85.00, '2026-01-25', 'logistique',       'Transport matériel porte-à-porte',      v_user_id),
  (v_ss093, 'depense', 120.00, '2026-03-15', 'materiel',         'Banderoles et panneaux',                v_user_id),
  (v_ss093, 'depense',  50.00, '2026-05-08', 'communication',    'Création visuel campagne mai',          v_user_id),
  -- ── SS-092 Entrées/Dépenses 2026 ──
  (v_ss092, 'entree',  240.00, '2026-02-28', 'cotisation',       'Cotisations février 2026',              v_user_id),
  (v_ss092, 'entree',  260.00, '2026-04-30', 'cotisation',       'Cotisations avril 2026',                v_user_id),
  (v_ss092, 'depense',  70.00, '2026-03-20', 'logistique',       'Location espace réunion Nanterre',      v_user_id),
  -- ── Données 2025 conservées ──
  (v_ss075, 'entree',  450.00, '2025-01-31', 'cotisation',       'Cotisations collectées janvier 2025',   v_user_id),
  (v_ss075, 'entree',  200.00, '2025-02-10', 'don',              'Don anonyme — adhérent fidèle',         v_user_id),
  (v_ss075, 'entree',   85.50, '2025-03-05', 'goodies_vente',    'Vente t-shirts + macarons meeting',     v_user_id),
  (v_ss075, 'entree',  380.00, '2025-02-28', 'cotisation',       'Cotisations collectées février 2025',   v_user_id),
  (v_ss075, 'depense', 120.00, '2025-02-22', 'logistique',       'Location salle Bastille — réunion',     v_user_id),
  (v_ss075, 'depense',  95.00, '2025-03-01', 'materiel',         'Impression affiches A3 ×200',           v_user_id),
  (v_ss093, 'entree',  310.00, '2025-02-28', 'cotisation',       'Cotisations collectées février 2025',   v_user_id),
  (v_ss093, 'depense',  75.00, '2025-03-10', 'logistique',       'Transport matériel porte-à-porte',      v_user_id)
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 3. COTISATIONS (jan–juin 2026, taux recouvrement varié)
-- ════════════════════════════════════════════════════════════
INSERT INTO cotisations (militant_id, unite_id, annee, mois, montant_paye, montant_du, mode_paiement, statut, date_paiement, created_by)
VALUES
  -- m01 — à jour
  (v_m01, v_ss075, 2026, 1, 30.00, 30.00, 'virement', 'payee',   '2026-01-08', v_user_id),
  (v_m01, v_ss075, 2026, 2, 30.00, 30.00, 'virement', 'payee',   '2026-02-06', v_user_id),
  (v_m01, v_ss075, 2026, 3, 30.00, 30.00, 'virement', 'payee',   '2026-03-07', v_user_id),
  (v_m01, v_ss075, 2026, 4, 30.00, 30.00, 'virement', 'payee',   '2026-04-05', v_user_id),
  (v_m01, v_ss075, 2026, 5, 30.00, 30.00, 'virement', 'payee',   '2026-05-08', v_user_id),
  -- m02 — paiement partiel en mai, impayé juin
  (v_m02, v_ss075, 2026, 1, 30.00, 30.00, 'especes',  'payee',   '2026-01-15', v_user_id),
  (v_m02, v_ss075, 2026, 2, 30.00, 30.00, 'especes',  'payee',   '2026-02-18', v_user_id),
  (v_m02, v_ss075, 2026, 3, 30.00, 30.00, 'especes',  'payee',   '2026-03-12', v_user_id),
  (v_m02, v_ss075, 2026, 4, 15.00, 30.00, 'especes',  'partiel', '2026-04-20', v_user_id),
  (v_m02, v_ss075, 2026, 5,  0.00, 30.00, NULL,       'impayee', NULL,         v_user_id),
  -- m03 — à jour
  (v_m03, v_ss075, 2026, 1, 30.00, 30.00, 'cheque',   'payee',   '2026-01-20', v_user_id),
  (v_m03, v_ss075, 2026, 2, 30.00, 30.00, 'cheque',   'payee',   '2026-02-22', v_user_id),
  (v_m03, v_ss075, 2026, 3, 30.00, 30.00, 'cheque',   'payee',   '2026-03-19', v_user_id),
  (v_m03, v_ss075, 2026, 4, 30.00, 30.00, 'cheque',   'payee',   '2026-04-18', v_user_id),
  (v_m03, v_ss075, 2026, 5, 30.00, 30.00, 'cheque',   'payee',   '2026-05-17', v_user_id),
  -- m04 — impayés depuis mars
  (v_m04, v_ss075, 2026, 1, 30.00, 30.00, 'virement', 'payee',   '2026-01-25', v_user_id),
  (v_m04, v_ss075, 2026, 2, 30.00, 30.00, 'virement', 'payee',   '2026-02-24', v_user_id),
  (v_m04, v_ss075, 2026, 3,  0.00, 30.00, NULL,       'impayee', NULL,         v_user_id),
  (v_m04, v_ss075, 2026, 4,  0.00, 30.00, NULL,       'impayee', NULL,         v_user_id),
  (v_m04, v_ss075, 2026, 5,  0.00, 30.00, NULL,       'impayee', NULL,         v_user_id),
  -- m05 — à jour
  (v_m05, v_ss075, 2026, 1, 30.00, 30.00, 'virement', 'payee',   '2026-01-10', v_user_id),
  (v_m05, v_ss075, 2026, 2, 30.00, 30.00, 'virement', 'payee',   '2026-02-12', v_user_id),
  (v_m05, v_ss075, 2026, 3, 30.00, 30.00, 'virement', 'payee',   '2026-03-10', v_user_id),
  (v_m05, v_ss075, 2026, 4, 30.00, 30.00, 'virement', 'payee',   '2026-04-09', v_user_id),
  (v_m05, v_ss075, 2026, 5, 30.00, 30.00, 'virement', 'payee',   '2026-05-12', v_user_id),
  -- m06 — partiel régulier
  (v_m06, v_ss075, 2026, 1, 20.00, 30.00, 'especes',  'partiel', '2026-01-22', v_user_id),
  (v_m06, v_ss075, 2026, 2, 20.00, 30.00, 'especes',  'partiel', '2026-02-20', v_user_id),
  (v_m06, v_ss075, 2026, 3, 30.00, 30.00, 'especes',  'payee',   '2026-03-24', v_user_id),
  (v_m06, v_ss075, 2026, 4, 20.00, 30.00, 'especes',  'partiel', '2026-04-22', v_user_id),
  (v_m06, v_ss075, 2026, 5, 30.00, 30.00, 'especes',  'payee',   '2026-05-20', v_user_id),
  -- m09 SS-093 — à jour
  (v_m09, v_ss093, 2026, 1, 30.00, 30.00, 'virement', 'payee',   '2026-01-12', v_user_id),
  (v_m09, v_ss093, 2026, 2, 30.00, 30.00, 'virement', 'payee',   '2026-02-14', v_user_id),
  (v_m09, v_ss093, 2026, 3, 30.00, 30.00, 'virement', 'payee',   '2026-03-13', v_user_id),
  (v_m09, v_ss093, 2026, 4, 30.00, 30.00, 'virement', 'payee',   '2026-04-11', v_user_id),
  (v_m09, v_ss093, 2026, 5, 30.00, 30.00, 'virement', 'payee',   '2026-05-10', v_user_id),
  -- m10 SS-093 — impayé depuis avril
  (v_m10, v_ss093, 2026, 1, 30.00, 30.00, 'cheque',   'payee',   '2026-01-18', v_user_id),
  (v_m10, v_ss093, 2026, 2, 30.00, 30.00, 'cheque',   'payee',   '2026-02-19', v_user_id),
  (v_m10, v_ss093, 2026, 3, 30.00, 30.00, 'cheque',   'payee',   '2026-03-20', v_user_id),
  (v_m10, v_ss093, 2026, 4,  0.00, 30.00, NULL,       'impayee', NULL,         v_user_id),
  (v_m10, v_ss093, 2026, 5,  0.00, 30.00, NULL,       'impayee', NULL,         v_user_id),
  -- m21 SS-092
  (v_m21, v_ss092, 2026, 2, 30.00, 30.00, 'virement', 'payee',   '2026-02-20', v_user_id),
  (v_m21, v_ss092, 2026, 3, 30.00, 30.00, 'virement', 'payee',   '2026-03-21', v_user_id),
  (v_m21, v_ss092, 2026, 4, 30.00, 30.00, 'virement', 'payee',   '2026-04-20', v_user_id),
  (v_m21, v_ss092, 2026, 5, 30.00, 30.00, 'virement', 'payee',   '2026-05-19', v_user_id),
  -- Données 2025 conservées
  (v_m01, v_ss075, 2025, 1, 30.00, 30.00, 'virement', 'payee',   '2025-01-10', v_user_id),
  (v_m01, v_ss075, 2025, 2, 30.00, 30.00, 'virement', 'payee',   '2025-02-08', v_user_id),
  (v_m01, v_ss075, 2025, 3, 30.00, 30.00, 'especes',  'payee',   '2025-03-05', v_user_id),
  (v_m09, v_ss093, 2025, 1, 30.00, 30.00, 'virement', 'payee',   '2025-01-12', v_user_id),
  (v_m09, v_ss093, 2025, 2, 30.00, 30.00, 'virement', 'payee',   '2025-02-14', v_user_id)
ON CONFLICT (militant_id, annee, mois) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 4. ÉVÉNEMENTS
-- ════════════════════════════════════════════════════════════
INSERT INTO evenements (id, unite_id, titre, type, date_debut, date_fin, lieu, description, created_by)
VALUES
  -- Passés (testables : présences, rapports)
  (v_e01, v_ss075, 'Réunion publique Bastille',         'reunion_publique', '2026-02-15 14:00+01', '2026-02-15 17:00+01', 'Salle Bastille, Paris 11e',       'Présentation programme local et Q&A', v_user_id),
  (v_e02, v_ss093, 'Porte-à-porte Saint-Denis',         'porte_a_porte',   '2026-03-08 09:00+01', '2026-03-08 13:00+01', 'Quartier Plaine, Saint-Denis',    'Sensibilisation dans le quartier Plaine', v_user_id),
  (v_e03, v_ss075, 'Formation numérique militants',     'formation',        '2026-04-12 10:00+01', '2026-04-12 16:00+01', 'Maison des asso., Paris 19e',     'Formation outils numériques militants', v_user_id),
  (v_e04, v_bex,   'Meeting national Paris Est',        'meeting',          '2026-05-10 15:00+01', '2026-05-10 20:00+01', 'Salle de la Forge, Paris 20e',    'Meeting de mobilisation printemps 2026', v_user_id),
  (v_e05, v_ss092, 'Réunion SS Hauts-de-Seine',         'reunion_interne',  '2026-05-25 19:00+01', '2026-05-25 21:00+01', 'Espace associatif, Nanterre',     'Réunion mensuelle SS-092', v_user_id),
  -- À venir (testables : QR code, inscription)
  (v_e06, v_ss075, 'Meeting Paris — Mobilisation été',  'meeting',          '2026-07-04 15:00+01', '2026-07-04 19:00+01', 'Salle de la Forge, Paris 20e',    'Meeting avant les vacances d''été', v_user_id),
  (v_e07, v_ss093, 'Marche solidarité Seine-St-Denis',  'marche',           '2026-07-14 10:00+01', '2026-07-14 14:00+01', 'Place République, Saint-Denis',   'Marche citoyenne et festive — ouvert à tous', v_user_id),
  (v_e08, v_bex,   'Assemblée Générale Pastef France',  'ag',               '2026-09-20 10:00+01', '2026-09-20 18:00+01', 'Palais des Congrès, Paris 17e',   'AG annuelle — bilan et perspectives', v_user_id)
ON CONFLICT (id) DO NOTHING;

-- ── Présences sur événements passés ──────────────────────
INSERT INTO presences (evenement_id, militant_id, mode, created_by)
VALUES
  -- e01 Réunion Bastille : 7 présents
  (v_e01, v_m01, 'manuel', v_user_id),
  (v_e01, v_m02, 'manuel', v_user_id),
  (v_e01, v_m03, 'manuel', v_user_id),
  (v_e01, v_m04, 'manuel', v_user_id),
  (v_e01, v_m05, 'manuel', v_user_id),
  (v_e01, v_m06, 'manuel', v_user_id),
  (v_e01, v_m08, 'qr',     v_user_id),
  -- e02 Porte-à-porte Saint-Denis : 5 présents
  (v_e02, v_m09, 'qr',     v_user_id),
  (v_e02, v_m10, 'qr',     v_user_id),
  (v_e02, v_m11, 'manuel', v_user_id),
  (v_e02, v_m17, 'qr',     v_user_id),
  (v_e02, v_m18, 'manuel', v_user_id),
  -- e03 Formation numérique : 9 présents (inter-SS)
  (v_e03, v_m01, 'qr',     v_user_id),
  (v_e03, v_m03, 'qr',     v_user_id),
  (v_e03, v_m05, 'qr',     v_user_id),
  (v_e03, v_m08, 'qr',     v_user_id),
  (v_e03, v_m13, 'qr',     v_user_id),
  (v_e03, v_m14, 'qr',     v_user_id),
  (v_e03, v_m21, 'manuel', v_user_id),
  (v_e03, v_m22, 'manuel', v_user_id),
  (v_e03, v_m29, 'qr',     v_user_id),
  -- e04 Meeting national : 15 présents
  (v_e04, v_m01, 'qr', v_user_id), (v_e04, v_m02, 'qr', v_user_id),
  (v_e04, v_m03, 'qr', v_user_id), (v_e04, v_m04, 'qr', v_user_id),
  (v_e04, v_m05, 'qr', v_user_id), (v_e04, v_m06, 'qr', v_user_id),
  (v_e04, v_m08, 'qr', v_user_id), (v_e04, v_m09, 'qr', v_user_id),
  (v_e04, v_m10, 'qr', v_user_id), (v_e04, v_m11, 'qr', v_user_id),
  (v_e04, v_m17, 'qr', v_user_id), (v_e04, v_m21, 'qr', v_user_id),
  (v_e04, v_m22, 'qr', v_user_id), (v_e04, v_m26, 'qr', v_user_id),
  (v_e04, v_m29, 'qr', v_user_id),
  -- e05 Réunion SS-092 : 4 présents
  (v_e05, v_m21, 'manuel', v_user_id),
  (v_e05, v_m22, 'manuel', v_user_id),
  (v_e05, v_m23, 'manuel', v_user_id),
  (v_e05, v_m24, 'qr',     v_user_id)
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 5. RÉUNIONS
-- ════════════════════════════════════════════════════════════
INSERT INTO reunions (id, unite_id, titre, type, date, lieu, ordre_du_jour, created_by)
VALUES
  (v_r01, v_bex,   'Bureau exécutif — janvier 2026',     'bureau',       '2026-01-13 19:00+01', 'Siège France, Paris 10e',      E'1. Bilan 2025\n2. Objectifs 2026\n3. Budget prévisionnel', v_user_id),
  (v_r02, v_bex,   'Bureau exécutif — avril 2026',       'bureau',       '2026-04-07 19:00+01', 'Siège France, Paris 10e',      E'1. Bilan T1 2026\n2. Campagne massification printemps\n3. Préparation AG', v_user_id),
  (v_r03, v_ss075, 'Réunion SS Paris — mars 2026',       'sous_section', '2026-03-16 19:30+01', 'Café associatif, Paris 18e',   E'1. Retour porte-à-porte\n2. Planning avril\n3. Cotisations en retard', v_user_id),
  (v_r04, v_ss075, 'Réunion SS Paris — mai 2026',        'sous_section', '2026-05-19 19:30+01', 'Maison des asso., Paris 19e',  E'1. Bilan meeting\n2. Préparation été\n3. Nouveaux membres', v_user_id),
  (v_r05, v_ss093, 'Réunion SS Seine-St-Denis — fév 26', 'sous_section', '2026-02-24 19:00+01', 'Salle polyvalente, St-Denis',  E'1. Porte-à-porte quartier Plaine\n2. Cotisations\n3. Événements à venir', v_user_id),
  (v_r06, v_jps,   'Réunion JPS — mars 2026',            'mouvement',    '2026-03-22 18:00+01', 'Foyer des jeunes, Paris 19e',  E'1. Recrutement jeunes\n2. Activités printemps\n3. Lien avec cellules', v_user_id)
ON CONFLICT (id) DO NOTHING;

-- ── Décisions ────────────────────────────────────────────
INSERT INTO decisions (reunion_id, texte, responsable, echeance, statut)
VALUES
  (v_r01, 'Lancer campagne massification — objectif +50 militants T1',      'Aminata Ndiaye',  '2026-03-31', 'terminee'),
  (v_r01, 'Réviser le budget prévisionnel avec les responsables SS',         'Mamadou Diallo',  '2026-02-15', 'terminee'),
  (v_r01, 'Mettre à jour les fiches de poste du bureau',                    'Ousmane Fall',    '2026-02-28', 'en_cours'),
  (v_r02, 'Organiser formation finances pour responsables de cellule',       'Fatou Sow',       '2026-05-15', 'en_cours'),
  (v_r02, 'Préparer programme AG septembre 2026',                           'Mamadou Diallo',  '2026-07-01', 'en_attente'),
  (v_r02, 'Lancer appel aux prospects pour meeting juillet',                 'Rokhaya Mbaye',   '2026-06-20', 'en_cours'),
  (v_r03, 'Relancer par téléphone les militants avec cotisation en retard',  'Ousmane Fall',    '2026-03-31', 'terminee'),
  (v_r03, 'Préparer liste prospects à contacter pour avril',                 'Fatou Sow',       '2026-04-15', 'terminee'),
  (v_r04, 'Planifier porte-à-porte juin dans le 13e',                       'Mamadou Diallo',  '2026-06-30', 'en_cours'),
  (v_r05, 'Constituer bureau de la SS-093',                                  'Samba Faye',      '2026-03-15', 'terminee'),
  (v_r06, 'Recruter 10 jeunes dans les cellules Paris',                      'Oumar Seck',      '2026-05-31', 'en_attente')
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 6. PROSPECTS (entonnoir complet — toutes les étapes)
-- ════════════════════════════════════════════════════════════
INSERT INTO prospects (unite_id, nom, prenom, telephone, email, ville, sexe, etape, date_contact, mouvement_interet, notes, created_by)
VALUES
  -- contact (nouveaux)
  (v_ss075, 'Sy',      'Abdoulaye',   '+33611111111', 'abdoulaye.sy@gmail.com',  'Paris',        'M', 'contact',      '2026-05-01', 'JPS',   'Rencontré au marché Château Rouge',         v_user_id),
  (v_ss075, 'Kane',    'Aissatou',    '+33611111115', NULL,                      'Bobigny',      'F', 'contact',      '2026-05-18', 'MOJIP', 'Contactée via ami commun',                  v_user_id),
  (v_ss075, 'Gomis',   'Serigne',     '+33611111117', NULL,                      'Paris',        'M', 'contact',      '2026-06-02', NULL,    'Rencontré lors du meeting mai',             v_user_id),
  (v_ss093, 'Camara',  'Seydou',      '+33611111116', 'seydou.c@gmail.com',      'Villepinte',   'M', 'contact',      '2026-06-05', 'JPS',   'Suit nos publications',                     v_user_id),
  -- sympathisant
  (v_ss075, 'Ba',      'Ndéye Fatou', '+33611111112', 'nf.ba@hotmail.fr',        'Aubervilliers','F', 'sympathisant', '2026-03-10', 'MOJIP', 'A assisté à la formation numérique',        v_user_id),
  (v_ss075, 'Diallo',  'Souleymane',  '+33611111118', 's.diallo@free.fr',        'Paris',        'M', 'sympathisant', '2026-04-12', NULL,    'Suit l''actualité Pastef depuis 1 an',      v_user_id),
  (v_ss092, 'Kouyaté', 'Djénéba',    '+33611111119', NULL,                      'Levallois',    'F', 'sympathisant', '2026-03-22', 'MOJIP', 'Intéressée par le mouvement femmes',        v_user_id),
  -- adhérent (formulaire rempli, en attente validation)
  (v_ss075, 'Mbodj',   'Lamine',      '+33611111113', NULL,                      'Paris',        'M', 'adherent',     '2026-01-20', NULL,    'Formulaire QR meeting janvier',             v_user_id),
  (v_ss075, 'Sarr',    'Binta',       '+33611111120', 'binta.sarr@gmail.com',    'Paris',        'F', 'adherent',     '2026-02-28', 'Cadres','A participé à 2 réunions',                 v_user_id),
  (v_ss093, 'Ndiaye',  'Boucounta',   '+33611111121', NULL,                      'Aubervilliers','M', 'adherent',     '2026-04-05', 'JPS',   'Recommandé par Samba Faye',                 v_user_id),
  -- converti (prêts à devenir militants)
  (v_ss075, 'Diagne',  'Pape',        '+33611111114', 'p.diagne@yahoo.fr',       'Créteil',      'M', 'converti',     '2025-12-05', 'Cadres','En attente de carte membre',               v_user_id),
  (v_ss093, 'Sall',    'Rokhaya',     '+33611111122', 'rokhaya.sall@outlook.fr', 'Saint-Denis',  'F', 'converti',     '2026-03-15', 'MOJIP', 'Dossier complet, carte en préparation',     v_user_id)
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 7. POSTES BUREAU
-- ════════════════════════════════════════════════════════════
-- BEX — bureau complet
INSERT INTO postes_bureau (unite_id, intitule, militant_id, date_nomination, created_by)
VALUES
  (v_bex, 'coordinateur',           v_m01, '2024-01-15', v_user_id),
  (v_bex, 'coordinateur_adjoint',   v_m02, '2024-01-15', v_user_id),
  (v_bex, 'resp_finances',          v_m03, '2024-01-15', v_user_id),
  (v_bex, 'resp_communication',     v_m04, '2024-01-15', v_user_id),
  (v_bex, 'resp_massification',     v_m05, '2024-02-01', v_user_id),
  (v_bex, 'resp_it',                v_m06, '2024-02-01', v_user_id),
  (v_bex, 'resp_formation',         v_m08, '2024-02-01', v_user_id),
  (v_bex, 'resp_veille_electorale', v_m13, '2024-03-01', v_user_id)
ON CONFLICT (unite_id, intitule) DO NOTHING;

-- SS-075 bureau
INSERT INTO postes_bureau (unite_id, intitule, militant_id, date_nomination, created_by)
VALUES
  (v_ss075, 'coordinateur',         v_m03, '2025-03-20', v_user_id),
  (v_ss075, 'coordinateur_adjoint', v_m04, '2025-03-20', v_user_id),
  (v_ss075, 'resp_finances',        v_m06, '2025-03-20', v_user_id),
  (v_ss075, 'resp_communication',   v_m08, '2025-03-20', v_user_id),
  (v_ss075, 'resp_massification',   v_m14, '2025-03-20', v_user_id)
ON CONFLICT (unite_id, intitule) DO NOTHING;

-- SS-093 bureau
INSERT INTO postes_bureau (unite_id, intitule, militant_id, date_nomination, created_by)
VALUES
  (v_ss093, 'coordinateur',         v_m09, '2026-03-15', v_user_id),
  (v_ss093, 'coordinateur_adjoint', v_m10, '2026-03-15', v_user_id),
  (v_ss093, 'resp_finances',        v_m17, '2026-03-15', v_user_id),
  (v_ss093, 'resp_communication',   v_m18, '2026-03-15', v_user_id)
ON CONFLICT (unite_id, intitule) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 8. SCRUTINS + CANDIDATS
-- ════════════════════════════════════════════════════════════
INSERT INTO scrutins (id, unite_id, titre, type, date_scrutin, statut, description)
VALUES
  -- Clos (résultats disponibles)
  (v_s01, v_ss075, 'Élection bureau SS Paris — mars 2025',   'interne', '2025-03-20', 'clos',
   'Élection du coordinateur et de son adjoint pour la sous-section Paris'),
  -- En cours (vote ouvert)
  (v_s02, v_ss093, 'Élection bureau SS-093 — juin 2026',     'interne', '2026-06-20', 'en_cours',
   'Renouvellement du bureau de la sous-section Seine-Saint-Denis'),
  -- À venir (candidatures ouvertes)
  (v_s03, v_bex,   'Élection bureau exécutif — sept. 2026',  'interne', '2026-09-19', 'a_venir',
   'Renouvellement du bureau exécutif lors de l''AG annuelle')
ON CONFLICT (id) DO NOTHING;

INSERT INTO candidats_election (scrutin_id, militant_id, nom, prenom, poste, voix, elu)
VALUES
  -- s01 SS-075 (clos)
  (v_s01, v_m03, 'Fall',    'Ousmane',   'coordinateur',       14, TRUE),
  (v_s01, v_m05, 'Diop',    'Ibrahima',  'coordinateur',        8, FALSE),
  (v_s01, v_m04, 'Sow',     'Fatou',     'vice_coordinateur',  19, TRUE),
  (v_s01, v_m08, 'Touré',   'Mariama',   'vice_coordinateur',   3, FALSE),
  -- s02 SS-093 en cours (voix partielles)
  (v_s02, v_m09, 'Faye',    'Samba',     'coordinateur',        6, FALSE),
  (v_s02, v_m11, 'Niang',   'Modou',     'coordinateur',        4, FALSE),
  (v_s02, v_m10, 'Sarr',    'Ndéye',     'vice_coordinateur',   8, FALSE),
  (v_s02, v_m17, 'Konaté',  'Amadou',    'vice_coordinateur',   3, FALSE),
  -- s03 BEX à venir (candidatures, pas encore de voix)
  (v_s03, v_m01, 'Diallo',  'Mamadou',   'coordinateur',        0, FALSE),
  (v_s03, v_m02, 'Ndiaye',  'Aminata',   'coordinateur',        0, FALSE)
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 9. COMPTES RENDUS D'ACTIVITÉ (tous les statuts)
-- ════════════════════════════════════════════════════════════
INSERT INTO comptes_rendus
  (unite_id, mois, annee, statut, description_activites,
   nouveaux_contacts, evenements_tenus, presences_total, cotisations_collectees,
   difficultes, observations_coordinateur, soumis_at)
VALUES
  -- SS-075 mars 2026 — validé
  (v_ss075, 3, 2026, 'valide',
   'Formation numérique du 12 avril ayant mobilisé 9 militants. Distribution de 300 tracts dans le 18e. Relance téléphonique des cotisations en retard : 4 régularisations.',
   6, 1, 9, 380.00,
   'Disponibilité réduite des militants les week-ends de mars.',
   'Bon mois dans l''ensemble. Formation très appréciée. Continuer sur cette lancée.',
   '2026-04-03 09:00:00+01'),
  -- SS-075 avril 2026 — soumis (en attente validation BEX)
  (v_ss075, 4, 2026, 'soumis',
   'Meeting national du 10 mai : 15 présents de la SS-075. Porte-à-porte dans le 13e avec 6 militants. 3 nouveaux prospects qualifiés.',
   3, 2, 15, 430.00,
   'Difficulté de mobilisation dans le 13e en semaine.',
   NULL,
   '2026-05-05 10:30:00+01'),
  -- SS-075 mai 2026 — brouillon (en cours de rédaction)
  (v_ss075, 5, 2026, 'brouillon',
   'Réunion SS du 19 mai : 12 présents. Planification meeting juillet. Suivi des prospects convertis.',
   5, 1, 12, 510.00, NULL, NULL, NULL),
  -- SS-093 mars 2026 — soumis
  (v_ss093, 3, 2026, 'soumis',
   'Porte-à-porte quartier Plaine le 8 mars : 5 militants. Constitution du bureau SS-093 finalisée.',
   4, 1, 5, 420.00,
   'Quelques absences non justifiées lors du porte-à-porte.',
   NULL,
   '2026-04-02 14:00:00+01'),
  -- SS-093 avril 2026 — retourné pour correction
  (v_ss093, 4, 2026, 'retourne',
   'Réunion bureau du 7 avril. Préparation scrutin interne.',
   2, 0, 0, 380.00,
   NULL, NULL,
   '2026-05-01 08:00:00+01'),
  -- SS-092 avril 2026 — brouillon
  (v_ss092, 4, 2026, 'brouillon',
   'Réunion SS du 25 mai : 4 présents. Collecte cotisations en cours.',
   1, 1, 4, 260.00, NULL, NULL, NULL)
ON CONFLICT (unite_id, mois, annee) DO NOTHING;


RAISE NOTICE '✓ Données de test v2 insérées : 30 militants, 6 mois transactions, cotisations variées, 8 événements + présences, 6 réunions, 12 prospects (toutes étapes), bureaux BEX/SS-075/SS-093, 3 scrutins, 6 CRA (tous statuts).';
END $$;