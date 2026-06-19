-- Fonctions publiques pour l'espace militant (sans authentification)
-- Accessibles via supabase.rpc() avec le rôle anon

-- 1. Vérification militant par numéro de carte + téléphone
CREATE OR REPLACE FUNCTION get_espace_militant(p_numero_carte TEXT, p_telephone TEXT)
RETURNS JSON AS $$
DECLARE
  v_mil   RECORD;
  v_unite RECORD;
  v_parent RECORD;
BEGIN
  SELECT id, nom, prenom, numero_carte, telephone, unite_id, statut, date_adhesion
  INTO v_mil
  FROM militants
  WHERE numero_carte = p_numero_carte
    AND telephone = p_telephone
    AND statut = 'actif';

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  SELECT id, nom, type, parent_id
  INTO v_unite
  FROM unites_organisationnelles
  WHERE id = v_mil.unite_id;

  IF v_unite.parent_id IS NOT NULL THEN
    SELECT id, nom, type
    INTO v_parent
    FROM unites_organisationnelles
    WHERE id = v_unite.parent_id;
  END IF;

  RETURN json_build_object(
    'militant_id',       v_mil.id,
    'nom',               v_mil.nom,
    'prenom',            v_mil.prenom,
    'numero_carte',      v_mil.numero_carte,
    'statut',            v_mil.statut,
    'date_adhesion',     v_mil.date_adhesion,
    'unite_id',          v_unite.id,
    'unite_nom',         v_unite.nom,
    'unite_type',        v_unite.type,
    'parent_unite_id',   v_parent.id,
    'parent_unite_nom',  v_parent.nom,
    'parent_unite_type', v_parent.type
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_espace_militant(TEXT, TEXT) TO anon;

-- 2. Cotisations du militant pour l'année en cours
CREATE OR REPLACE FUNCTION get_espace_cotisations(p_militant_id UUID)
RETURNS JSON AS $$
BEGIN
  RETURN (
    SELECT COALESCE(json_agg(json_build_object(
      'mois',         c.mois,
      'annee',        c.annee,
      'montant_paye', c.montant_paye,
      'montant_du',   c.montant_du,
      'statut',       c.statut
    ) ORDER BY c.mois), '[]'::json)
    FROM cotisations c
    WHERE c.militant_id = p_militant_id
      AND c.annee = EXTRACT(YEAR FROM CURRENT_DATE)::INT
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_espace_cotisations(UUID) TO anon;

-- 3. Résumé finances cellule + sous-section parente
CREATE OR REPLACE FUNCTION get_espace_finances(p_unite_id UUID)
RETURNS JSON AS $$
DECLARE
  v_solde      NUMERIC;
  v_nb         INT;
  v_parent_id  UUID;
  v_parent_nom TEXT;
  v_p_solde    NUMERIC;
  v_p_nb       INT;
BEGIN
  SELECT COALESCE(SUM(CASE WHEN type = 'entree' THEN montant ELSE -montant END), 0)
  INTO v_solde
  FROM transactions WHERE unite_id = p_unite_id;

  SELECT COUNT(*) INTO v_nb
  FROM militants WHERE unite_id = p_unite_id AND statut = 'actif';

  SELECT parent_id INTO v_parent_id
  FROM unites_organisationnelles WHERE id = p_unite_id;

  IF v_parent_id IS NOT NULL THEN
    SELECT nom INTO v_parent_nom
    FROM unites_organisationnelles WHERE id = v_parent_id;

    SELECT COALESCE(SUM(CASE WHEN type = 'entree' THEN montant ELSE -montant END), 0)
    INTO v_p_solde
    FROM transactions WHERE unite_id = v_parent_id;

    SELECT COUNT(*) INTO v_p_nb
    FROM militants m
    JOIN unites_organisationnelles u ON m.unite_id = u.id
    WHERE (u.id = v_parent_id OR u.parent_id = v_parent_id)
      AND m.statut = 'actif';
  END IF;

  RETURN json_build_object(
    'cellule_solde',          v_solde,
    'cellule_nb_membres',     v_nb,
    'sous_section_id',        v_parent_id,
    'sous_section_nom',       v_parent_nom,
    'sous_section_solde',     v_p_solde,
    'sous_section_nb_membres', v_p_nb
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_espace_finances(UUID) TO anon;
