-- La fonction update_updated_at_column() a été ajoutée à init_types.sql après
-- son application initiale sur le cloud. Cette migration la crée rétroactivement
-- pour débloquer les migrations 11+ qui en dépendent.
CREATE OR REPLACE FUNCTION update_updated_at_column()
  RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;