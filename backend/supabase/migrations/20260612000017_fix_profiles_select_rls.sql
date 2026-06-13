-- Fix : un utilisateur peut toujours lire son propre profil,
-- même si unite_id est NULL (profil créé par le trigger sans unité assignée).
-- Avant : USING (unite_id IN (...)) → NULL IN (...) = NULL → profil invisible → échec login.
-- Après : on ajoute id = auth.uid() comme condition courte-circuit.

DROP POLICY IF EXISTS "profiles_select" ON profiles;

CREATE POLICY "profiles_select" ON profiles
  FOR SELECT TO authenticated
  USING (id = auth.uid() OR unite_id IN (SELECT get_accessible_unite_ids()));