-- ── 1. Ajout du rôle admin_technique dans l'enum ───────────────────────────────
-- Le Flutter utilise AppRoles.adminTechnique = 'admin_technique' mais ce rôle
-- n'était pas dans l'enum SQL. Les admins techniques utilisent la table profiles
-- (pas admins_techniques) avec ce rôle pour accès global en lecture.
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'admin_technique';


-- ── 2. Mise à jour de get_accessible_unite_ids ──────────────────────────────────
-- Ajout de 'admin_technique' comme rôle à accès global (comme bureau_executif).
CREATE OR REPLACE FUNCTION get_accessible_unite_ids()
  RETURNS SETOF UUID AS $$
DECLARE
  v_role     user_role;
  v_unite_id UUID;
BEGIN
  SELECT role, unite_id INTO v_role, v_unite_id
  FROM profiles WHERE id = auth.uid();

  -- Accès global : bureau exécutif, coordinateur, admin technique
  IF v_role IN ('bureau_executif', 'coordinateur', 'admin_technique') THEN
    RETURN QUERY SELECT id FROM unites_organisationnelles WHERE is_active = TRUE;

  -- Responsable sous-section : sa SS + toutes ses cellules
  ELSIF v_role = 'responsable_sous_section' THEN
    RETURN QUERY
      SELECT id FROM unites_organisationnelles
      WHERE (id = v_unite_id OR parent_id = v_unite_id)
        AND is_active = TRUE;

  -- Tous les autres : leur unité uniquement
  ELSE
    RETURN QUERY SELECT v_unite_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;


-- ── 3. Fix profiles_select : un utilisateur voit toujours son propre profil ─────
-- Problème : USING (unite_id IN (...)) → si unite_id est NULL (nouveau compte),
-- NULL IN (...) retourne NULL (pas TRUE) → l'utilisateur ne peut pas lire son
-- propre profil → le flux d'authentification casse complètement.
DROP POLICY IF EXISTS "profiles_select" ON profiles;
CREATE POLICY "profiles_select" ON profiles
  FOR SELECT TO authenticated
  USING (
    id = auth.uid()                                  -- toujours son propre profil
    OR unite_id IN (SELECT get_accessible_unite_ids())  -- ou périmètre accessible
  );


-- ── 4. Fix transactions_insert : toutes les unités peuvent saisir des dépenses ──
-- Ancienne logique : dépenses limitées à bureau_executif + coordinateur +
-- responsable_secretariat. Problème : un responsable_sous_section ne pouvait
-- pas saisir de dépense pour sa SS. Nouvelle règle : tout rôle sauf
-- responsable_secretariat peut saisir entrées ET dépenses dans son périmètre.
DROP POLICY IF EXISTS "transactions_insert" ON transactions;
CREATE POLICY "transactions_insert" ON transactions
  FOR INSERT TO authenticated
  WITH CHECK (
    unite_id IN (SELECT get_accessible_unite_ids())
    AND (SELECT role FROM profiles WHERE id = auth.uid())
      NOT IN ('responsable_secretariat')
  );