-- Permet à tous les rôles authentifiés de lire TOUS les militants.
-- Les stats globales (par SS, mouvement, cellule) sont ainsi visibles
-- par tous les responsables. Le filtrage de la liste détaillée est
-- géré côté frontend selon le rôle.
DROP POLICY "militants_select" ON militants;
CREATE POLICY "militants_select" ON militants
  FOR SELECT TO authenticated
  USING (true);