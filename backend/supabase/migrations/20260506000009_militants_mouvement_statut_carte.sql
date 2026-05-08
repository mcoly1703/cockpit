-- ── 1. Enum statut_carte ────────────────────────────────────────────────────
-- Statut physique de la carte membre (Active / Expirée / Perdue / En attente)
CREATE TYPE statut_carte AS ENUM ('active', 'expiree', 'perdue', 'en_attente');


-- ── 2. Ajout des colonnes sur militants ──────────────────────────────────────
-- mouvement_id : double appartenance — un militant peut appartenir à une cellule
--   ET simultanément à un mouvement (JPS, MOJIP, MONCAP, Maggi Pastef).
--   Nullable car la grande majorité n'est pas dans un mouvement.
ALTER TABLE militants
  ADD COLUMN mouvement_id UUID REFERENCES unites_organisationnelles(id),
  ADD COLUMN statut_carte statut_carte NOT NULL DEFAULT 'en_attente';


-- ── 3. Index ─────────────────────────────────────────────────────────────────
CREATE INDEX idx_militants_mouvement_id ON militants(mouvement_id);
CREATE INDEX idx_militants_statut_carte ON militants(statut_carte);
