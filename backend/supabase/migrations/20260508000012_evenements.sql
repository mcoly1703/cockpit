-- Module Événements — Planification + présences

CREATE TABLE IF NOT EXISTS evenements (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  titre       TEXT        NOT NULL,
  description TEXT,
  date_debut  TIMESTAMPTZ NOT NULL,
  date_fin    TIMESTAMPTZ,
  lieu        TEXT        NOT NULL,
  type        TEXT        NOT NULL DEFAULT 'autre',
  unite_id    UUID        NOT NULL REFERENCES unites_organisationnelles(id),
  created_by  UUID        NOT NULL REFERENCES auth.users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT type_evenement_valide CHECK (
    type IN ('reunion_publique', 'meeting', 'marche', 'formation', 'porte_a_porte', 'autre')
  )
);

CREATE TABLE IF NOT EXISTS presences (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  evenement_id UUID        NOT NULL REFERENCES evenements(id) ON DELETE CASCADE,
  militant_id  UUID        REFERENCES militants(id),
  nom          TEXT        NOT NULL,
  prenom       TEXT        NOT NULL,
  telephone    TEXT,
  checked_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_evenements_unite_id    ON evenements(unite_id);
CREATE INDEX IF NOT EXISTS idx_evenements_date_debut  ON evenements(date_debut);
CREATE INDEX IF NOT EXISTS idx_presences_evenement_id ON presences(evenement_id);

-- Triggers updated_at
CREATE TRIGGER set_evenements_updated_at
  BEFORE UPDATE ON evenements
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- RLS evenements
ALTER TABLE evenements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "evenements_select" ON evenements
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "evenements_insert" ON evenements
  FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "evenements_update" ON evenements
  FOR UPDATE USING (auth.uid() IS NOT NULL);

-- RLS presences
ALTER TABLE presences ENABLE ROW LEVEL SECURITY;

CREATE POLICY "presences_select" ON presences
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "presences_insert" ON presences
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);