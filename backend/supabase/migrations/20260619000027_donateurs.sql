-- Table donateurs : personnes (non-militants) ayant fait des dons
CREATE TABLE donateurs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nom         TEXT NOT NULL,
  prenom      TEXT,
  telephone   TEXT,
  email       TEXT,
  ville       TEXT,
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX idx_donateurs_telephone ON donateurs(telephone) WHERE telephone IS NOT NULL;

ALTER TABLE transactions ADD COLUMN donateur_id UUID REFERENCES donateurs(id);

ALTER TABLE donateurs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "donateurs_select" ON donateurs FOR SELECT TO authenticated USING (true);
CREATE POLICY "donateurs_insert" ON donateurs FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "donateurs_update" ON donateurs FOR UPDATE TO authenticated USING (true);

CREATE TRIGGER set_donateurs_updated_at
  BEFORE UPDATE ON donateurs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
