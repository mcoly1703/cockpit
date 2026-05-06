-- Bureau Exécutif
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0000-000000000001', 'bureau_executif', 'Bureau Exécutif Pastef France', 'BEX', NULL);

-- Sous-sections IDF
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0001-000000000075', 'sous_section', 'Sous-section Paris', 'SS-075', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000077', 'sous_section', 'Sous-section Seine-et-Marne', 'SS-077', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000078', 'sous_section', 'Sous-section Yvelines', 'SS-078', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000091', 'sous_section', 'Sous-section Essonne', 'SS-091', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000092', 'sous_section', 'Sous-section Hauts-de-Seine', 'SS-092', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000093', 'sous_section', 'Sous-section Seine-Saint-Denis', 'SS-093', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000094', 'sous_section', 'Sous-section Val-de-Marne', 'SS-094', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000095', 'sous_section', 'Sous-section Val-d''Oise', 'SS-095', '00000000-0000-0000-0000-000000000001');

-- Sous-sections hors IDF
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0001-000000000101', 'sous_section', 'Sous-section Auvergne-Rhône-Alpes', 'SS-ARA', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000102', 'sous_section', 'Sous-section Bourgogne-Franche-Comté', 'SS-BFC', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000103', 'sous_section', 'Sous-section Bretagne', 'SS-BRE', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000104', 'sous_section', 'Sous-section Centre-Val de Loire', 'SS-CVL', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000105', 'sous_section', 'Sous-section Grand Est', 'SS-GRE', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000106', 'sous_section', 'Sous-section Hauts-de-France', 'SS-HDF', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000107', 'sous_section', 'Sous-section Normandie', 'SS-NOR', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000108', 'sous_section', 'Sous-section Nouvelle-Aquitaine', 'SS-NAQ', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000109', 'sous_section', 'Sous-section Occitanie', 'SS-OCC', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000110', 'sous_section', 'Sous-section PACA - Marseille', 'SS-PAM', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000111', 'sous_section', 'Sous-section PACA - Nice', 'SS-PAN', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0001-000000000112', 'sous_section', 'Sous-section Pays de la Loire', 'SS-PDL', '00000000-0000-0000-0000-000000000001');

-- Mouvements
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0002-000000000001', 'mouvement', 'Mouvement Jeunes Patriotes du Sénégal (JPS)', 'MVT-JPS', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0002-000000000002', 'mouvement', 'Mouvement des Femmes Patriotes (MOJIP)', 'MVT-MJP', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0002-000000000003', 'mouvement', 'Mouvement National des Cadres Patriotes (MONCAP)', 'MVT-MCP', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0002-000000000004', 'mouvement', 'Mouvement Maggi Pastef', 'MVT-MAG', '00000000-0000-0000-0000-000000000001');

-- Secrétariats
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0003-000000000001', 'secretariat', 'Secrétariat Finance', 'SEC-FIN', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0003-000000000002', 'secretariat', 'Secrétariat Veille Électorale', 'SEC-VEL', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0003-000000000003', 'secretariat', 'Secrétariat Communication', 'SEC-COM', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0003-000000000004', 'secretariat', 'Secrétariat Massification', 'SEC-MAS', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0003-000000000005', 'secretariat', 'Secrétariat Formation', 'SEC-FOR', '00000000-0000-0000-0000-000000000001'),
('00000000-0000-0000-0003-000000000006', 'secretariat', 'Secrétariat IT', 'SEC-ITE', '00000000-0000-0000-0000-000000000001');
