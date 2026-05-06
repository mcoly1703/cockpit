-- Rôles des utilisateurs de la plateforme
CREATE TYPE user_role AS ENUM (
    'bureau_executif',
    'coordinateur',
    'responsable_sous_section',
    'responsable_mouvement',
    'responsable_secretariat',
    'coordinateur_cellule'
);

-- Types d'unités organisationnelles
CREATE TYPE unite_type AS ENUM (
    'bureau_executif',
    'sous_section',
    'mouvement',
    'secretariat',
    'cellule'
);

-- Sexe
CREATE TYPE sexe_type AS ENUM ('M', 'F');

-- Statut d'un militant
CREATE TYPE statut_militant AS ENUM ('actif', 'inactif', 'suspendu');

-- Type de mouvement financier
CREATE TYPE transaction_type AS ENUM ('entree', 'depense');

-- Statut d'une cotisation
CREATE TYPE statut_cotisation AS ENUM ('payee', 'en_attente', 'en_retard');


-- Catégories financières
CREATE TYPE categorie_finance AS ENUM (
    -- Entrées
    'cotisation',
    'don',
    'benefice_event',
    'goodies_vente',
    -- Dépenses
    'logistique',
    'communication',
    'materiel',
    'deplacements',
    'goodies_achat',
    'administration',
    'formation'
  );

-- Fonction réutilisable pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION trigger_set_updated_at()
  RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
  $$ LANGUAGE plpgsql;
