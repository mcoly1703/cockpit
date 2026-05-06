-- Séquence pour générer les numéros de carte membres
CREATE SEQUENCE militants_carte_seq START 1;

CREATE TABLE militants (
                           id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                           numero_carte    TEXT UNIQUE NOT NULL DEFAULT 'TEMP-' || LPAD(NEXTVAL('militants_carte_seq')::TEXT, 6, '0'),
                           nom             TEXT NOT NULL,
                           prenom          TEXT NOT NULL,
                           date_naissance  DATE,
                           sexe            sexe_type,
                           telephone       TEXT,
                           email           TEXT,
                           ville           TEXT,
                           code_postal     TEXT,
                           unite_id        UUID NOT NULL REFERENCES unites_organisationnelles(id),
                           statut          statut_militant NOT NULL DEFAULT 'actif',
                           date_adhesion   DATE NOT NULL DEFAULT CURRENT_DATE,
                           photo_url       TEXT,
                           created_by      UUID REFERENCES profiles(id),
                           created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                           updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index
CREATE INDEX idx_militants_unite_id ON militants(unite_id);
CREATE INDEX idx_militants_statut ON militants(statut);
CREATE INDEX idx_militants_numero_carte ON militants(numero_carte);
CREATE INDEX idx_militants_created_by ON militants(created_by);

-- Mise à jour automatique de updated_at
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON militants
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

-- Activation du Row Level Security
ALTER TABLE militants ENABLE ROW LEVEL SECURITY;
