-- Types réunion : ajout mouvement et secrétariat
ALTER TABLE reunions DROP CONSTRAINT IF EXISTS type_reunion_valide;
ALTER TABLE reunions ADD CONSTRAINT type_reunion_valide CHECK (
  type IN ('bureau', 'cellule', 'sous_section', 'commission',
           'assemblee_generale', 'mouvement', 'secretariat', 'autre')
);

-- Champs compte rendu de réunion
ALTER TABLE reunions ADD COLUMN IF NOT EXISTS compte_rendu     TEXT;
ALTER TABLE reunions ADD COLUMN IF NOT EXISTS compte_rendu_url TEXT;

-- Bucket storage pour fichiers CR (public — lecture libre, écriture authentifiée)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'comptes-rendus', 'comptes-rendus', true, 10485760,
  ARRAY[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'image/jpeg', 'image/png', 'image/webp'
  ]
)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "cr_select"  ON storage.objects;
DROP POLICY IF EXISTS "cr_insert"  ON storage.objects;
DROP POLICY IF EXISTS "cr_update"  ON storage.objects;

CREATE POLICY "cr_select" ON storage.objects
  FOR SELECT USING (bucket_id = 'comptes-rendus');

CREATE POLICY "cr_insert" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'comptes-rendus');

CREATE POLICY "cr_update" ON storage.objects
  FOR UPDATE TO authenticated
  USING (bucket_id = 'comptes-rendus');