-- ── 1. Ajout de 'partiel' à l'enum statut_cotisation ────────────────────────
-- Statuts possibles : payee / partiel / en_retard / en_attente
-- Règle métier :
--   payee      → montant_paye >= montant_du
--   partiel    → 0 < montant_paye < montant_du
--   en_retard  → mois passé, montant_paye = 0
--   en_attente → mois courant ou futur, pas encore payé
ALTER TYPE statut_cotisation ADD VALUE IF NOT EXISTS 'partiel';


-- ── 2. Passage au modèle mensuel ─────────────────────────────────────────────
-- Ancien modèle : 1 enregistrement par (militant, annee)
-- Nouveau modèle : 1 enregistrement par (militant, annee, mois)

-- Renommer montant → montant_paye (montant effectivement encaissé)
ALTER TABLE cotisations RENAME COLUMN montant TO montant_paye;

-- Nouvelles colonnes
ALTER TABLE cotisations
  ADD COLUMN mois          SMALLINT CHECK (mois BETWEEN 1 AND 12),
  ADD COLUMN montant_du    NUMERIC(12,2),        -- montant attendu (ex. 10 €/mois)
  ADD COLUMN mode_paiement TEXT,                  -- espèces, virement, PayPal, Lydia...
  ADD COLUMN unite_id      UUID REFERENCES unites_organisationnelles(id); -- dénormalisé pour les RLS


-- ── 3. Mise à jour de la contrainte unique ───────────────────────────────────
-- Ancienne : UNIQUE (militant_id, annee)
-- Nouvelle  : UNIQUE NULLS NOT DISTINCT (militant_id, annee, mois)
--   NULLS NOT DISTINCT (PG 15+) : traite deux NULL comme égaux pour la contrainte,
--   ce qui permet un upsert sur mois=NULL (record annuel) tout en maintenant
--   l'unicité mensuelle quand mois est renseigné.
ALTER TABLE cotisations DROP CONSTRAINT cotisations_militant_id_annee_key;
ALTER TABLE cotisations
  ADD CONSTRAINT cotisations_militant_annee_mois_key
  UNIQUE NULLS NOT DISTINCT (militant_id, annee, mois);


-- ── 4. Index ─────────────────────────────────────────────────────────────────
CREATE INDEX idx_cotisations_mois     ON cotisations(mois);
CREATE INDEX idx_cotisations_unite_id ON cotisations(unite_id);
