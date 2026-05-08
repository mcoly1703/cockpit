-- Module Prospects — Entonnoir 4 étapes

CREATE TABLE IF NOT EXISTS prospects (
  id                      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  nom                     TEXT        NOT NULL,
  prenom                  TEXT        NOT NULL,
  telephone               TEXT        NOT NULL,
  email                   TEXT,
  ville                   TEXT        NOT NULL,
  sexe                    TEXT,
  mouvement_interet       TEXT,
  etape                   TEXT        NOT NULL DEFAULT 'contact',
  date_contact            DATE        NOT NULL DEFAULT CURRENT_DATE,
  notes                   TEXT,
  unite_id                UUID        NOT NULL REFERENCES unites_organisationnelles(id),
  converti_en_militant_id UUID        REFERENCES militants(id),
  created_by              UUID        NOT NULL REFERENCES auth.users(id),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT etape_valide CHECK (etape IN ('contact', 'sympathisant', 'adherent', 'converti'))
);

CREATE INDEX IF NOT EXISTS idx_prospects_unite_id ON prospects(unite_id);
CREATE INDEX IF NOT EXISTS idx_prospects_etape    ON prospects(etape);

-- Trigger updated_at
CREATE TRIGGER set_prospects_updated_at
  BEFORE UPDATE ON prospects
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- RLS
ALTER TABLE prospects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "prospects_select" ON prospects
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "prospects_insert" ON prospects
  FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "prospects_update" ON prospects
  FOR UPDATE USING (auth.uid() IS NOT NULL);