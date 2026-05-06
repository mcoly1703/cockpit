-- NB: beneficiaire = texte libre : "Imprimerie Martin", "SNCF", "Fatou Diallo" selon le cas.
CREATE TABLE transactions (
                              id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                              type                    transaction_type NOT NULL,
                              categorie               categorie_finance NOT NULL,
                              montant                 NUMERIC(12,2) NOT NULL CHECK (montant > 0),
                              description             TEXT,
                              date_transaction        DATE NOT NULL DEFAULT CURRENT_DATE,
                              piece_justificative_url TEXT,
                              beneficiaire            TEXT,
                              unite_id                UUID NOT NULL REFERENCES unites_organisationnelles(id),
                              militant_id             UUID REFERENCES militants(id),
                              created_by              UUID NOT NULL REFERENCES profiles(id),
                              created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                              updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Suivi des cotisations par militant et par année
CREATE TABLE cotisations (
                             id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                             militant_id    UUID NOT NULL REFERENCES militants(id),
                             annee          SMALLINT NOT NULL,
                             montant        NUMERIC(12,2) NOT NULL CHECK (montant > 0),
                             statut         statut_cotisation NOT NULL DEFAULT 'en_attente',
                             date_paiement  DATE,
                             transaction_id UUID REFERENCES transactions(id),
                             created_by     UUID NOT NULL REFERENCES profiles(id),
                             created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                             updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                             UNIQUE (militant_id, annee)
);

-- Index transactions
CREATE INDEX idx_transactions_unite_id ON transactions(unite_id);
CREATE INDEX idx_transactions_type ON transactions(type);
CREATE INDEX idx_transactions_categorie ON transactions(categorie);
CREATE INDEX idx_transactions_date ON transactions(date_transaction);
CREATE INDEX idx_transactions_militant_id ON transactions(militant_id);

-- Index cotisations
CREATE INDEX idx_cotisations_militant_id ON cotisations(militant_id);
CREATE INDEX idx_cotisations_annee ON cotisations(annee);
CREATE INDEX idx_cotisations_statut ON cotisations(statut);

-- Triggers updated_at
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON transactions
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON cotisations
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

-- Activation RLS
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cotisations ENABLE ROW LEVEL SECURITY;
