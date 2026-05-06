-- Ajout du flag adjoint sur les profils
ALTER TABLE profiles ADD COLUMN est_adjoint BOOLEAN NOT NULL DEFAULT FALSE;
