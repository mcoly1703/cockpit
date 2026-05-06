-- Profils utilisateurs (étend auth.users de Supabase)
-- Points importants :
--   - id est une FK vers auth.users — ce n'est pas un UUID auto-généré, c'est Supabase Auth qui le fournit
--   - ON DELETE CASCADE — si le user est supprimé de Auth, son profil disparaît aussi
--   - role et unite_id sont nullables — l'admin les remplira manuellement après création du compte
CREATE TABLE profiles (
                          id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
                          nom        TEXT NOT NULL DEFAULT '',
                          prenom     TEXT NOT NULL DEFAULT '',
                          telephone  TEXT,
                          role       user_role,
                          unite_id   UUID REFERENCES unites_organisationnelles(id),
                          is_active  BOOLEAN NOT NULL DEFAULT TRUE,
                          created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                          updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_unite_id ON profiles(unite_id);
CREATE INDEX idx_profiles_is_active ON profiles(is_active);

-- Mise à jour automatique de updated_at
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();


-- Crée automatiquement un profil vide quand un user est créé dans Supabase Auth
--   ==> Ce qui se passe : quand tu crées un compte dans Supabase Studio, ce trigger s'exécute automatiquement et crée un profil vide lié à ce compte. Tu n'as plus qu'à remplir nom, prenom, role et unite_id ensuite.
CREATE OR REPLACE FUNCTION handle_new_user()
  RETURNS TRIGGER AS $$
BEGIN
INSERT INTO public.profiles (id)
VALUES (NEW.id);
RETURN NEW;
END;
  $$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Activation du Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
