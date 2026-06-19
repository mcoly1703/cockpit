-- Parrain : le militant qui a parrainé/facilité l'adhésion
ALTER TABLE militants
  ADD COLUMN parrain_id UUID REFERENCES militants(id);

CREATE INDEX idx_militants_parrain_id ON militants(parrain_id);