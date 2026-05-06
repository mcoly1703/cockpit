-- Table des administrateurs techniques (équipe support et dev)
-- Séparée des profils militants, aucun lien avec les rôles politiques
CREATE TABLE admins_techniques (
           id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
           nom        TEXT NOT NULL DEFAULT '',
           prenom     TEXT NOT NULL DEFAULT '',
           is_active  BOOLEAN NOT NULL DEFAULT TRUE,
           created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
           updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger updated_at
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON admins_techniques
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

-- RLS : seuls les admins techniques voient cette table
ALTER TABLE admins_techniques ENABLE ROW LEVEL SECURITY;

CREATE POLICY "admins_techniques_select" ON admins_techniques
    FOR SELECT TO authenticated
                   USING (id = auth.uid());
