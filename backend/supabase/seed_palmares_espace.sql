-- ============================================================
-- SEED : données de test pour Palmarès + Espace Militant
-- - Parrains sur des militants existants
-- - Donateurs externes + transactions dons
-- - Militants avec numéro de carte + téléphone connus pour tester /mon-espace
-- ============================================================

DO $$
DECLARE
  v_user_id UUID;
  v_mil     RECORD;
  v_parrain RECORD;
  v_i       INT;
  v_don     RECORD;
  v_unite   UUID;
BEGIN

  SELECT id INTO v_user_id FROM auth.users LIMIT 1;

  -- ══════════════════════════════════════════════════════════
  -- 1. PARRAINS : attribuer des parrains à ~150 militants
  -- On prend les 20 premiers militants actifs comme parrains potentiels
  -- et on leur attribue des filleuls parmi les autres militants
  -- ══════════════════════════════════════════════════════════

  -- Récupérer les 20 "top parrains" potentiels
  FOR v_parrain IN
    SELECT id, nom, prenom FROM militants
    WHERE statut = 'actif'
    ORDER BY created_at
    LIMIT 20
  LOOP
    -- Attribuer entre 3 et 15 filleuls aléatoires à chaque parrain
    UPDATE militants
    SET parrain_id = v_parrain.id
    WHERE id IN (
      SELECT id FROM militants
      WHERE statut = 'actif'
        AND parrain_id IS NULL
        AND id != v_parrain.id
      ORDER BY random()
      LIMIT 3 + (floor(random() * 12))::INT
    );

    RAISE NOTICE 'Parrain : % % → filleuls attribués', v_parrain.prenom, v_parrain.nom;
  END LOOP;

  -- ══════════════════════════════════════════════════════════
  -- 2. DONATEURS EXTERNES + transactions dons
  -- ══════════════════════════════════════════════════════════

  -- Créer 10 donateurs externes
  INSERT INTO donateurs (nom, prenom, telephone, email, ville) VALUES
    ('Dupont',    'Pierre',    '+33612345001', 'pierre.dupont@gmail.com',    'Paris'),
    ('Martin',    'Sophie',    '+33612345002', 'sophie.martin@gmail.com',    'Lyon'),
    ('Sagna',     'Abdoulaye', '+33612345003', 'abdou.sagna@gmail.com',     'Marseille'),
    ('Kouyaté',   'Fatoumata', '+33612345004', 'fatou.kouyate@gmail.com',   'Bordeaux'),
    ('Leclerc',   'Jean',      '+33612345005', 'jean.leclerc@gmail.com',    'Toulouse'),
    ('Diakhaté',  'Mariama',   '+33612345006', 'mariama.diakhate@gmail.com','Nantes'),
    ('Bernard',   'François',  '+33612345007', 'francois.bernard@gmail.com','Strasbourg'),
    ('Thiam',     'Moussa',    '+33612345008', 'moussa.thiam@gmail.com',    'Lille'),
    ('Moreau',    'Isabelle',  '+33612345009', 'isabelle.moreau@gmail.com',  'Nice'),
    ('Kamara',    'Ousmane',   '+33612345010', 'ousmane.kamara@gmail.com',   'Grenoble');

  -- Récupérer une unité pour les transactions
  SELECT id INTO v_unite FROM unites_organisationnelles
  WHERE type = 'sous_section' LIMIT 1;

  -- Créer des dons des donateurs externes (montants variés)
  FOR v_don IN
    SELECT id, nom FROM donateurs ORDER BY created_at
  LOOP
    FOR v_i IN 1..(2 + (floor(random() * 4))::INT) LOOP
      INSERT INTO transactions (
        type, categorie, montant, date_transaction,
        unite_id, description, donateur_id, created_by
      ) VALUES (
        'entree', 'don',
        (50 + floor(random() * 450))::NUMERIC,
        CURRENT_DATE - (floor(random() * 180))::INT,
        v_unite,
        'Don de ' || v_don.nom,
        v_don.id,
        v_user_id
      );
    END LOOP;
  END LOOP;

  -- Créer aussi des dons de militants (pour le classement mixte)
  FOR v_mil IN
    SELECT id, nom FROM militants WHERE statut = 'actif' ORDER BY random() LIMIT 15
  LOOP
    FOR v_i IN 1..(1 + (floor(random() * 3))::INT) LOOP
      INSERT INTO transactions (
        type, categorie, montant, date_transaction,
        unite_id, description, militant_id, created_by
      ) VALUES (
        'entree', 'don',
        (20 + floor(random() * 200))::NUMERIC,
        CURRENT_DATE - (floor(random() * 180))::INT,
        v_unite,
        'Don militant ' || v_mil.nom,
        v_mil.id,
        v_user_id
      );
    END LOOP;
  END LOOP;

  RAISE NOTICE '✓ Donateurs et dons créés';

  -- ══════════════════════════════════════════════════════════
  -- 3. MILITANTS DE TEST pour l'Espace Militant
  -- 5 militants avec numéro de carte et téléphone connus
  -- URL : /mon-espace/{numero_carte}  +  téléphone pour vérification
  -- ══════════════════════════════════════════════════════════

  -- Récupérer une cellule pour y rattacher les militants de test
  SELECT u.id INTO v_unite FROM unites_organisationnelles u
  WHERE type = 'cellule' LIMIT 1;

  INSERT INTO militants (
    nom, prenom, sexe, telephone, email, ville,
    date_adhesion, statut, unite_id, created_by
  ) VALUES
    ('DIOP',    'Mariam',    'F', '+33600000001', 'mariam.diop@test.fr',    'Paris',     '2024-03-15', 'actif', v_unite, v_user_id),
    ('NDIAYE',  'Amadou',    'M', '+33600000002', 'amadou.ndiaye@test.fr',  'Montreuil', '2024-06-01', 'actif', v_unite, v_user_id),
    ('FALL',    'Coumba',    'F', '+33600000003', 'coumba.fall@test.fr',    'Créteil',   '2025-01-10', 'actif', v_unite, v_user_id),
    ('SOW',     'Ibrahima',  'M', '+33600000004', 'ibrahima.sow@test.fr',   'Nanterre',  '2025-03-20', 'actif', v_unite, v_user_id),
    ('GUEYE',   'Fatou',     'F', '+33600000005', 'fatou.gueye@test.fr',    'Bobigny',   '2024-09-01', 'actif', v_unite, v_user_id);

  -- Ajouter des cotisations pour ces militants de test (année 2026)
  FOR v_mil IN
    SELECT id FROM militants WHERE telephone IN (
      '+33600000001', '+33600000002', '+33600000003', '+33600000004', '+33600000005'
    )
  LOOP
    FOR v_i IN 1..6 LOOP
      INSERT INTO cotisations (
        militant_id, annee, mois, montant_paye, montant_du,
        statut, unite_id, created_by
      ) VALUES (
        v_mil.id, 2026, v_i,
        CASE WHEN random() < 0.8 THEN 10.00 ELSE 0.00 END,
        10.00,
        (CASE WHEN random() < 0.8 THEN 'payee' ELSE 'en_retard' END)::statut_cotisation,
        v_unite, v_user_id
      );
    END LOOP;
  END LOOP;

  RAISE NOTICE '✓ 5 militants de test créés pour Espace Militant';

  -- Afficher les infos pour les tests
  RAISE NOTICE '──────────────────────────────────────────────';
  RAISE NOTICE 'MILITANTS DE TEST (Espace Militant) :';
  FOR v_mil IN
    SELECT numero_carte, telephone, nom, prenom FROM militants
    WHERE telephone IN (
      '+33600000001', '+33600000002', '+33600000003', '+33600000004', '+33600000005'
    )
  LOOP
    RAISE NOTICE '  % — % % — tél: %', v_mil.numero_carte, v_mil.prenom, v_mil.nom, v_mil.telephone;
  END LOOP;
  RAISE NOTICE '──────────────────────────────────────────────';

END $$;
