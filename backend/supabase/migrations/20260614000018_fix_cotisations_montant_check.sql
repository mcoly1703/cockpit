-- Autorise montant_paye = 0 pour les mois en_retard / en_attente
-- (l'ancienne contrainte CHECK (montant > 0) bloquait les lignes sans paiement)
ALTER TABLE cotisations
  DROP CONSTRAINT IF EXISTS cotisations_montant_check,
  ADD  CONSTRAINT cotisations_montant_paye_check CHECK (montant_paye >= 0);