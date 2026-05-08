-- ─── Module élections ───────────────────────────────────────────────────────
-- Scrutins (élections internes + suivi élections externes)
-- Candidats par scrutin + saisie des résultats

CREATE TYPE statut_scrutin AS ENUM ('en_preparation', 'ouvert', 'clos');
CREATE TYPE type_scrutin   AS ENUM ('interne', 'municipal', 'legislatif', 'europeen', 'autre');

CREATE TABLE IF NOT EXISTS scrutins (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  unite_id     UUID        REFERENCES unites_organisationnelles(id) ON DELETE SET NULL,
  titre        TEXT        NOT NULL,
  type         type_scrutin NOT NULL DEFAULT 'interne',
  date_scrutin DATE        NOT NULL,
  description  TEXT,
  statut       statut_scrutin NOT NULL DEFAULT 'en_preparation',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_scrutins_unite   ON scrutins(unite_id);
CREATE INDEX IF NOT EXISTS idx_scrutins_date    ON scrutins(date_scrutin);
CREATE INDEX IF NOT EXISTS idx_scrutins_statut  ON scrutins(statut);

CREATE TABLE IF NOT EXISTS candidats_election (
  id          UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
  scrutin_id  UUID    NOT NULL REFERENCES scrutins(id) ON DELETE CASCADE,
  militant_id UUID    REFERENCES militants(id) ON DELETE SET NULL,
  nom         TEXT    NOT NULL,
  prenom      TEXT    NOT NULL,
  poste       TEXT,
  voix        INTEGER CHECK (voix >= 0),
  elu         BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_candidats_scrutin ON candidats_election(scrutin_id);

-- RLS
ALTER TABLE scrutins           ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidats_election ENABLE ROW LEVEL SECURITY;

CREATE POLICY "scrutins_select" ON scrutins
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "scrutins_insert" ON scrutins
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "scrutins_update" ON scrutins
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "candidats_select" ON candidats_election
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "candidats_insert" ON candidats_election
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "candidats_update" ON candidats_election
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "candidats_delete" ON candidats_election
  FOR DELETE TO authenticated USING (true);