-- Module Réunions — Réunions internes + décisions + suivi

CREATE TABLE IF NOT EXISTS reunions (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  titre       TEXT        NOT NULL,
  type        TEXT        NOT NULL DEFAULT 'autre',
  date        TIMESTAMPTZ NOT NULL,
  lieu        TEXT        NOT NULL,
  ordre_du_jour TEXT,
  unite_id    UUID        NOT NULL REFERENCES unites_organisationnelles(id),
  created_by  UUID        NOT NULL REFERENCES auth.users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT type_reunion_valide CHECK (
    type IN ('bureau', 'cellule', 'sous_section', 'commission', 'assemblee_generale', 'autre')
  )
);

CREATE TABLE IF NOT EXISTS decisions (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  reunion_id  UUID        NOT NULL REFERENCES reunions(id) ON DELETE CASCADE,
  texte       TEXT        NOT NULL,
  responsable TEXT,
  echeance    DATE,
  statut      TEXT        NOT NULL DEFAULT 'en_attente',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT statut_decision_valide CHECK (
    statut IN ('en_attente', 'en_cours', 'terminee', 'abandonnee')
  )
);

CREATE INDEX IF NOT EXISTS idx_reunions_unite_id   ON reunions(unite_id);
CREATE INDEX IF NOT EXISTS idx_reunions_date        ON reunions(date);
CREATE INDEX IF NOT EXISTS idx_decisions_reunion_id ON decisions(reunion_id);
CREATE INDEX IF NOT EXISTS idx_decisions_statut     ON decisions(statut);

-- Triggers updated_at
CREATE TRIGGER set_reunions_updated_at
  BEFORE UPDATE ON reunions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_decisions_updated_at
  BEFORE UPDATE ON decisions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- RLS reunions
ALTER TABLE reunions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "reunions_select" ON reunions
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "reunions_insert" ON reunions
  FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "reunions_update" ON reunions
  FOR UPDATE USING (auth.uid() IS NOT NULL);

-- RLS decisions
ALTER TABLE decisions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "decisions_select" ON decisions
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "decisions_insert" ON decisions
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "decisions_update" ON decisions
  FOR UPDATE USING (auth.uid() IS NOT NULL);