-- ============================================================
-- NETTOYAGE DONNÉES DE TEST — Cockpit Pastef France
-- À exécuter dans le SQL Editor Supabase quand tu as les vraies données
-- Supprime uniquement ce qui a été créé par seed_test_data.sql
-- ============================================================

DO $$
DECLARE
  -- Mêmes IDs fixes que seed_test_data.sql
  v_bex   CONSTANT UUID := '00000000-0000-0000-0000-000000000001';
  v_ss075 CONSTANT UUID := '00000000-0000-0000-0001-000000000075';
  v_ss093 CONSTANT UUID := '00000000-0000-0000-0001-000000000093';

  v_m01 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000001';
  v_m02 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000002';
  v_m03 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000003';
  v_m04 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000004';
  v_m05 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000005';
  v_m06 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000006';
  v_m07 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000007';
  v_m08 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000008';
  v_m09 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000009';
  v_m10 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000010';
  v_m11 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000011';
  v_m12 CONSTANT UUID := 'aaaaaaaa-0000-0000-0000-000000000012';

  v_r01 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000001';
  v_r02 CONSTANT UUID := 'bbbbbbbb-0000-0000-0000-000000000002';
  v_s01 CONSTANT UUID := 'cccccccc-0000-0000-0000-000000000001';

  v_militant_ids UUID[] := ARRAY[v_m01,v_m02,v_m03,v_m04,v_m05,v_m06,v_m07,v_m08,v_m09,v_m10,v_m11,v_m12];

BEGIN

-- Ordre inverse des dépendances FK

-- 1. Candidats élection (dépend scrutins + militants)
DELETE FROM candidats_election WHERE scrutin_id = v_s01;

-- 2. Scrutin
DELETE FROM scrutins WHERE id = v_s01;

-- 3. Comptes rendus
DELETE FROM comptes_rendus
WHERE (unite_id = v_ss075 AND mois = 2 AND annee = 2025)
   OR (unite_id = v_ss093 AND mois = 2 AND annee = 2025);

-- 4. Décisions (dépend réunions — supprimées en cascade par ON DELETE CASCADE)
-- supprimées automatiquement avec les réunions ci-dessous

-- 5. Réunions
DELETE FROM reunions WHERE id IN (v_r01, v_r02);

-- 6. Présences liées aux événements de test
DELETE FROM presences
WHERE evenement_id IN (
  SELECT id FROM evenements
  WHERE unite_id IN (v_ss075, v_ss093)
    AND created_by = (SELECT id FROM auth.users ORDER BY created_at LIMIT 1)
);

-- 7. Événements de test
DELETE FROM evenements
WHERE unite_id IN (v_ss075, v_ss093)
  AND created_by = (SELECT id FROM auth.users ORDER BY created_at LIMIT 1)
  AND titre IN (
    'Réunion publique Bastille',
    'Porte-à-porte Saint-Denis',
    'Formation militants Paris',
    'Meeting Paris Est',
    'Marche solidarité Seine-St-Denis'
  );

-- 8. Prospects de test
DELETE FROM prospects
WHERE telephone IN (
  '+33611111111','+33611111112','+33611111113',
  '+33611111114','+33611111115','+33611111116'
);

-- 9. Postes bureau de test (BEX, les 5 intitulés)
DELETE FROM postes_bureau
WHERE unite_id = v_bex
  AND intitule IN ('coordinateur','resp_finances','resp_communication','resp_massification','resp_it')
  AND militant_id = ANY(v_militant_ids);

-- 10. Cotisations des militants de test
DELETE FROM cotisations WHERE militant_id = ANY(v_militant_ids);

-- 11. Transactions de test (identifiées par description unique)
DELETE FROM transactions
WHERE description IN (
  'Cotisations collectées janvier 2025',
  'Don anonyme — adhérent fidèle',
  'Vente t-shirts + macarons meeting',
  'Cotisations collectées février 2025',
  'Location salle Bastille — réunion',
  'Impression affiches A3 ×200',
  'Boost publication Instagram',
  'Transport matériel porte-à-porte'
);

-- 12. Militants de test
DELETE FROM militants WHERE id = ANY(v_militant_ids);

RAISE NOTICE '✓ Données de test supprimées. Les vraies données sont intactes.';
END $$;
