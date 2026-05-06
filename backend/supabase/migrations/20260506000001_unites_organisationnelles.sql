-- Unités organisationnelles : Bureau Exécutif, sous-sections, mouvements, secrétariats, cellules
CREATE TABLE unites_organisationnelles (
                                           id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                           type       unite_type NOT NULL,
                                           nom        TEXT NOT NULL,
                                           code       TEXT,
                                           parent_id  UUID REFERENCES unites_organisationnelles(id),
                                           is_active  BOOLEAN NOT NULL DEFAULT TRUE,
                                           created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                           updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index pour accélérer les recherches fréquentes
CREATE INDEX idx_unites_parent_id ON unites_organisationnelles(parent_id);
CREATE INDEX idx_unites_type ON unites_organisationnelles(type);
CREATE INDEX idx_unites_is_active ON unites_organisationnelles(is_active);

-- Mise à jour automatique de updated_at
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON unites_organisationnelles
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();


-- Activation du Row Level Security
ALTER TABLE unites_organisationnelles ENABLE ROW LEVEL SECURITY;
