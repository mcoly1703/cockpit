-- Module Bureau — Composition des postes et nominations

CREATE TABLE IF NOT EXISTS postes_bureau (
  id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  unite_id         UUID        NOT NULL REFERENCES unites_organisationnelles(id),
  intitule         TEXT        NOT NULL,
  militant_id      UUID        NOT NULL REFERENCES militants(id),
  date_nomination  DATE        NOT NULL DEFAULT CURRENT_DATE,
  created_by       UUID        NOT NULL REFERENCES auth.users(id),
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(unite_id, intitule)
);

CREATE INDEX IF NOT EXISTS idx_postes_bureau_unite_id    ON postes_bureau(unite_id);
CREATE INDEX IF NOT EXISTS idx_postes_bureau_militant_id ON postes_bureau(militant_id);

-- Trigger updated_at
CREATE TRIGGER set_postes_bureau_updated_at
  BEFORE UPDATE ON postes_bureau
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- RLS
ALTER TABLE postes_bureau ENABLE ROW LEVEL SECURITY;

CREATE POLICY "postes_bureau_select" ON postes_bureau
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "postes_bureau_insert" ON postes_bureau
  FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "postes_bureau_update" ON postes_bureau
  FOR UPDATE USING (auth.uid() IS NOT NULL);

CREATE POLICY "postes_bureau_delete" ON postes_bureau
  FOR DELETE USING (auth.uid() IS NOT NULL);