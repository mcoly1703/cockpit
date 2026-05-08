-- ─── Utilisateurs de test pour le développement local ───────────────────────
-- À coller dans le SQL Editor de Studio (http://localhost:54323)
-- APRÈS avoir créé les comptes via Authentication → Users → Add user
--
-- Remplacer les UUIDs par ceux générés dans l'onglet Authentication.
-- Exemple rapide : copier l'ID depuis la colonne "UID" de l'utilisateur créé.

-- ── 1. Admin Technique (vue globale, tous les modules) ────────────────────────
INSERT INTO profiles (
  id, email, nom, prenom, role, entite, unite_organisationnelle_id
) VALUES (
  '<UUID_ADMIN>',                              -- ← remplacer
  'admin@pastef.fr',
  'Ndiaye',
  'Aminata',
  'admin_technique',
  'pastef_france',
  '00000000-0000-0000-0000-000000000001'       -- Bureau Exécutif
)
ON CONFLICT (id) DO UPDATE
  SET role = EXCLUDED.role,
      nom  = EXCLUDED.nom,
      prenom = EXCLUDED.prenom;

-- ── 2. Coordinateur (vue globale) ─────────────────────────────────────────────
INSERT INTO profiles (
  id, email, nom, prenom, role, entite, unite_organisationnelle_id
) VALUES (
  '<UUID_COORDO>',                             -- ← remplacer
  'coordo@pastef.fr',
  'Diallo',
  'Moussa',
  'coordinateur',
  'pastef_france',
  '00000000-0000-0000-0000-000000000001'
)
ON CONFLICT (id) DO UPDATE
  SET role = EXCLUDED.role;

-- ── 3. Responsable Sous-section Paris ─────────────────────────────────────────
INSERT INTO profiles (
  id, email, nom, prenom, role, entite, unite_organisationnelle_id
) VALUES (
  '<UUID_RESP_SS>',                            -- ← remplacer
  'paris@pastef.fr',
  'Sow',
  'Fatou',
  'responsable_sous_section',
  'pastef_france',
  '00000000-0000-0000-0001-000000000075'       -- SS-075 Paris
)
ON CONFLICT (id) DO UPDATE
  SET role = EXCLUDED.role;

-- ── 4. Coordinatrice Cellule (Paris 11e-12e) ──────────────────────────────────
INSERT INTO profiles (
  id, email, nom, prenom, role, entite, unite_organisationnelle_id
) VALUES (
  '<UUID_CELL>',                               -- ← remplacer
  'cellule@pastef.fr',
  'Ba',
  'Rokhaya',
  'coordinateur_cellule',
  'pastef_france',
  '00000000-0000-0000-0004-000000007501'       -- Cellule Paris 11e-12e
)
ON CONFLICT (id) DO UPDATE
  SET role = EXCLUDED.role;