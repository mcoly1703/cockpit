-- Refactoring types réunion : nature de la réunion (pas l'entité organisatrice)
-- Nouveaux types : reunion_interne, assemblee_generale, commission,
--                  coordination, campagne_electorale, autre

ALTER TABLE reunions DROP CONSTRAINT IF EXISTS type_reunion_valide;

-- Migration des anciennes valeurs vers les nouvelles
UPDATE reunions SET type = 'reunion_interne'
  WHERE type IN ('bureau', 'cellule', 'sous_section', 'mouvement', 'secretariat');

ALTER TABLE reunions ADD CONSTRAINT type_reunion_valide CHECK (
  type IN ('reunion_interne', 'assemblee_generale', 'commission',
           'coordination', 'campagne_electorale', 'autre')
);

-- Champ réunion extraordinaire
ALTER TABLE reunions ADD COLUMN IF NOT EXISTS is_extraordinaire BOOLEAN NOT NULL DEFAULT FALSE;