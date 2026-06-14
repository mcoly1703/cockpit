-- Ajout de la photo de profil sur les utilisateurs de l'application.
-- Distincte de militants.photo_url (fiche militant) : ici c'est la photo de l'utilisateur
-- dans l'interface (organigramme, profil, etc.).
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS photo_url TEXT;