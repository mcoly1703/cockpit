-- ─── Module CRA — Comptes Rendus d'Activité ────────────────────────────────
-- Remontée terrain : Cellule → Sous-section → Bureau Exécutif
-- Un seul CR par unité par mois (contrainte UNIQUE)

CREATE TYPE statut_cra AS ENUM ('brouillon', 'soumis', 'valide', 'retourne');

CREATE TABLE IF NOT EXISTS comptes_rendus (
  id                       UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  unite_id                 UUID          NOT NULL REFERENCES unites_organisationnelles(id),
  mois                     INTEGER       NOT NULL CHECK (mois BETWEEN 1 AND 12),
  annee                    INTEGER       NOT NULL,
  statut                   statut_cra    NOT NULL DEFAULT 'brouillon',
  description_activites    TEXT          NOT NULL,
  nouveaux_contacts        INTEGER       NOT NULL DEFAULT 0 CHECK (nouveaux_contacts >= 0),
  evenements_tenus         INTEGER       NOT NULL DEFAULT 0 CHECK (evenements_tenus >= 0),
  presences_total          INTEGER       NOT NULL DEFAULT 0 CHECK (presences_total >= 0),
  cotisations_collectees   DECIMAL(10,2) NOT NULL DEFAULT 0,
  difficultes              TEXT,
  observations_coordinateur TEXT,
  soumis_at                TIMESTAMPTZ,
  valide_at                TIMESTAMPTZ,
  created_at               TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  UNIQUE (unite_id, mois, annee)
);

CREATE INDEX IF NOT EXISTS idx_cr_unite  ON comptes_rendus(unite_id);
CREATE INDEX IF NOT EXISTS idx_cr_statut ON comptes_rendus(statut);
CREATE INDEX IF NOT EXISTS idx_cr_periode ON comptes_rendus(annee, mois);

-- RLS
ALTER TABLE comptes_rendus ENABLE ROW LEVEL SECURITY;

CREATE POLICY "cr_select" ON comptes_rendus
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "cr_insert" ON comptes_rendus
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "cr_update" ON comptes_rendus
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "cr_delete" ON comptes_rendus
  FOR DELETE TO authenticated USING (true);