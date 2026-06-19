-- FK pour permettre le join prospects → profiles (nom du créateur)
ALTER TABLE prospects
  ADD CONSTRAINT fk_prospects_created_by
  FOREIGN KEY (created_by) REFERENCES profiles(id);