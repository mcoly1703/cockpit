-- Retourne tous les unite_ids accessibles selon le rôle du responsable connecté
-- auth.uid() retourne l'UUID du responsable actuellement connecté — c'est Supabase qui le fournit automatiquement.
-- SECURITY DEFINER signifie que la fonction s'exécute avec les droits du créateur, pas de l'appelant — nécessaire pour lire la table profiles sans restrictions.
CREATE OR REPLACE FUNCTION get_accessible_unite_ids()
  RETURNS SETOF UUID AS $$
  DECLARE
v_role     user_role;
    v_unite_id UUID;
BEGIN
SELECT role, unite_id INTO v_role, v_unite_id
FROM profiles WHERE id = auth.uid();

-- Bureau exécutif et coordinateur : accès global
IF v_role IN ('bureau_executif', 'coordinateur') THEN
      RETURN QUERY SELECT id FROM unites_organisationnelles WHERE is_active = TRUE;

-- Responsable sous-section : sa SS + toutes ses cellules
ELSIF v_role = 'responsable_sous_section' THEN
      RETURN QUERY
SELECT id FROM unites_organisationnelles
WHERE (id = v_unite_id OR parent_id = v_unite_id)
  AND is_active = TRUE;

-- Tous les autres responsables : leur unité uniquement
ELSE
      RETURN QUERY SELECT v_unite_id;
END IF;
END;
  $$ LANGUAGE plpgsql SECURITY DEFINER STABLE;


-- Policies : profiles
-- Un responsable voit uniquement les profils de son périmètre
CREATE POLICY "profiles_select" ON profiles
   FOR SELECT TO authenticated
   USING (unite_id IN (SELECT get_accessible_unite_ids()));

-- Un responsable peut modifier uniquement son propre profil
CREATE POLICY "profiles_update" ON profiles
    FOR UPDATE TO authenticated
    USING (id = auth.uid());

-- Seul le bureau exécutif et le coordinateur peuvent créer des profils
CREATE POLICY "profiles_insert" ON profiles
    FOR INSERT TO authenticated
    WITH CHECK (
      (SELECT role FROM profiles WHERE id = auth.uid())
      IN ('bureau_executif', 'coordinateur')
    );


         -- Policies : unites_organisationnelles
  -- Tous les responsables voient les unités actives
  CREATE POLICY "unites_select" ON unites_organisationnelles
    FOR SELECT TO authenticated
                            USING (is_active = TRUE);

-- Seuls le bureau exécutif et le coordinateur peuvent créer/modifier/supprimer des unités
CREATE POLICY "unites_insert" ON unites_organisationnelles
    FOR INSERT TO authenticated
    WITH CHECK (
      (SELECT role FROM profiles WHERE id = auth.uid())
      IN ('bureau_executif', 'coordinateur')
    );

  CREATE POLICY "unites_update" ON unites_organisationnelles
    FOR UPDATE TO authenticated
                            USING (
                            (SELECT role FROM profiles WHERE id = auth.uid())
                            IN ('bureau_executif', 'coordinateur')
                            );

CREATE POLICY "unites_delete" ON unites_organisationnelles
    FOR DELETE TO authenticated
    USING (
      (SELECT role FROM profiles WHERE id = auth.uid())
      IN ('bureau_executif', 'coordinateur')
    );


-- Policies : militants
-- Un responsable voit les militants de son périmètre
CREATE POLICY "militants_select" ON militants
   FOR SELECT TO authenticated
   USING (unite_id IN (SELECT get_accessible_unite_ids()));

-- Peuvent ajouter un militant : tous sauf responsable_secretariat
CREATE POLICY "militants_insert" ON militants
    FOR INSERT TO authenticated
    WITH CHECK (
      unite_id IN (SELECT get_accessible_unite_ids())
      AND (SELECT role FROM profiles WHERE id = auth.uid())
      NOT IN ('responsable_secretariat')
    );

  -- Modification : même règle que l'insertion
  CREATE POLICY "militants_update" ON militants
    FOR UPDATE TO authenticated
    USING (
    unite_id IN (SELECT get_accessible_unite_ids())
    AND (SELECT role FROM profiles WHERE id = auth.uid())
    NOT IN ('responsable_secretariat')
    );

-- Suppression : bureau exécutif et coordinateur uniquement
CREATE POLICY "militants_delete" ON militants
    FOR DELETE TO authenticated
    USING (
      (SELECT role FROM profiles WHERE id = auth.uid())
      IN ('bureau_executif', 'coordinateur')
    );

  -- Policies : transactions
  -- Un responsable voit les transactions de son périmètre
  CREATE POLICY "transactions_select" ON transactions
    FOR SELECT TO authenticated
                                           USING (unite_id IN (SELECT get_accessible_unite_ids()));

-- Enregistrer une cotisation ou un don : tous sauf responsable_secretariat
CREATE POLICY "transactions_insert" ON transactions
    FOR INSERT TO authenticated
    WITH CHECK (
      unite_id IN (SELECT get_accessible_unite_ids())
      AND (
        -- Dépenses : secrétariat finance uniquement
        (type = 'depense' AND (SELECT role FROM profiles WHERE id = auth.uid())
          IN ('bureau_executif', 'coordinateur', 'responsable_secretariat'))
        OR
        -- Entrées : tous sauf responsable_secretariat
        (type = 'entree' AND (SELECT role FROM profiles WHERE id = auth.uid())
          NOT IN ('responsable_secretariat'))
      )
    );

  -- Modification et suppression : bureau exécutif et coordinateur uniquement
  CREATE POLICY "transactions_update" ON transactions
    FOR UPDATE TO authenticated
                            USING (
                            (SELECT role FROM profiles WHERE id = auth.uid())
                            IN ('bureau_executif', 'coordinateur')
                            );

CREATE POLICY "transactions_delete" ON transactions
    FOR DELETE TO authenticated
    USING (
      (SELECT role FROM profiles WHERE id = auth.uid())
      IN ('bureau_executif', 'coordinateur')
    );

  -- Policies : cotisations
  -- Un responsable voit les cotisations de son périmètre
  CREATE POLICY "cotisations_select" ON cotisations
    FOR SELECT TO authenticated
                                           USING (
                                           militant_id IN (
                                           SELECT id FROM militants
                                           WHERE unite_id IN (SELECT get_accessible_unite_ids())
                                           )
                                           );

-- Enregistrer une cotisation : tous sauf responsable_secretariat
CREATE POLICY "cotisations_insert" ON cotisations
    FOR INSERT TO authenticated
    WITH CHECK (
      militant_id IN (
        SELECT id FROM militants
        WHERE unite_id IN (SELECT get_accessible_unite_ids())
      )
      AND (SELECT role FROM profiles WHERE id = auth.uid())
      NOT IN ('responsable_secretariat')
    );

  -- Modification et suppression : bureau exécutif et coordinateur uniquement
  CREATE POLICY "cotisations_update" ON cotisations
    FOR UPDATE TO authenticated
                            USING (
                            (SELECT role FROM profiles WHERE id = auth.uid())
                            IN ('bureau_executif', 'coordinateur')
                            );

CREATE POLICY "cotisations_delete" ON cotisations
    FOR DELETE TO authenticated
    USING (
      (SELECT role FROM profiles WHERE id = auth.uid())
      IN ('bureau_executif', 'coordinateur')
    );
