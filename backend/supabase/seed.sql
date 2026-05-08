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

-- Cellules IDF — SS-075 Paris
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0004-000000007501', 'cellule', 'Cellule Paris 11e-12e', 'C75-01', '00000000-0000-0000-0001-000000000075'),
('00000000-0000-0000-0004-000000007502', 'cellule', 'Cellule Paris 13e-14e', 'C75-02', '00000000-0000-0000-0001-000000000075'),
('00000000-0000-0000-0004-000000007503', 'cellule', 'Cellule Paris 18e-19e', 'C75-03', '00000000-0000-0000-0001-000000000075'),
('00000000-0000-0000-0004-000000007504', 'cellule', 'Cellule Paris 20e', 'C75-04', '00000000-0000-0000-0001-000000000075');

-- Cellules IDF — SS-077 Seine-et-Marne
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0004-000000007701', 'cellule', 'Cellule Melun', 'C77-01', '00000000-0000-0000-0001-000000000077'),
('00000000-0000-0000-0004-000000007702', 'cellule', 'Cellule Fontainebleau', 'C77-02', '00000000-0000-0000-0001-000000000077'),
('00000000-0000-0000-0004-000000007703', 'cellule', 'Cellule Meaux', 'C77-03', '00000000-0000-0000-0001-000000000077');

-- Cellules IDF — SS-078 Yvelines
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0004-000000007801', 'cellule', 'Cellule Versailles', 'C78-01', '00000000-0000-0000-0001-000000000078'),
('00000000-0000-0000-0004-000000007802', 'cellule', 'Cellule Saint-Germain-en-Laye', 'C78-02', '00000000-0000-0000-0001-000000000078');

-- Cellules IDF — SS-091 Essonne
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0004-000000009101', 'cellule', 'Cellule Évry-Courcouronnes', 'C91-01', '00000000-0000-0000-0001-000000000091'),
('00000000-0000-0000-0004-000000009102', 'cellule', 'Cellule Massy-Palaiseau', 'C91-02', '00000000-0000-0000-0001-000000000091'),
('00000000-0000-0000-0004-000000009103', 'cellule', 'Cellule Corbeil-Essonnes', 'C91-03', '00000000-0000-0000-0001-000000000091');

-- Cellules IDF — SS-092 Hauts-de-Seine
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0004-000000009201', 'cellule', 'Cellule Boulogne-Billancourt', 'C92-01', '00000000-0000-0000-0001-000000000092'),
('00000000-0000-0000-0004-000000009202', 'cellule', 'Cellule Nanterre-Colombes', 'C92-02', '00000000-0000-0000-0001-000000000092'),
('00000000-0000-0000-0004-000000009203', 'cellule', 'Cellule Asnières-Levallois', 'C92-03', '00000000-0000-0000-0001-000000000092');

-- Cellules IDF — SS-093 Seine-Saint-Denis
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0004-000000009301', 'cellule', 'Cellule Saint-Denis', 'C93-01', '00000000-0000-0000-0001-000000000093'),
('00000000-0000-0000-0004-000000009302', 'cellule', 'Cellule Aubervilliers-Pantin', 'C93-02', '00000000-0000-0000-0001-000000000093'),
('00000000-0000-0000-0004-000000009303', 'cellule', 'Cellule Montreuil', 'C93-03', '00000000-0000-0000-0001-000000000093'),
('00000000-0000-0000-0004-000000009304', 'cellule', 'Cellule Villepinte-Tremblay', 'C93-04', '00000000-0000-0000-0001-000000000093');

-- Cellules IDF — SS-094 Val-de-Marne
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0004-000000009401', 'cellule', 'Cellule Créteil', 'C94-01', '00000000-0000-0000-0001-000000000094'),
('00000000-0000-0000-0004-000000009402', 'cellule', 'Cellule Vitry-sur-Seine', 'C94-02', '00000000-0000-0000-0001-000000000094'),
('00000000-0000-0000-0004-000000009403', 'cellule', 'Cellule Ivry-Choisy', 'C94-03', '00000000-0000-0000-0001-000000000094');

-- Cellules IDF — SS-095 Val-d'Oise
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
('00000000-0000-0000-0004-000000009501', 'cellule', 'Cellule Cergy-Pontoise', 'C95-01', '00000000-0000-0000-0001-000000000095'),
('00000000-0000-0000-0004-000000009502', 'cellule', 'Cellule Argenteuil', 'C95-02', '00000000-0000-0000-0001-000000000095'),
('00000000-0000-0000-0004-000000009503', 'cellule', 'Cellule Sarcelles-Villiers', 'C95-03', '00000000-0000-0000-0001-000000000095');

-- Cellules hors IDF (une cellule par grande métropole)
INSERT INTO unites_organisationnelles (id, type, nom, code, parent_id) VALUES
-- SS-ARA Auvergne-Rhône-Alpes
('00000000-0000-0000-0004-000000010101', 'cellule', 'Cellule Lyon', 'C-ARA-01', '00000000-0000-0000-0001-000000000101'),
('00000000-0000-0000-0004-000000010102', 'cellule', 'Cellule Grenoble', 'C-ARA-02', '00000000-0000-0000-0001-000000000101'),
-- SS-GRE Grand Est
('00000000-0000-0000-0004-000000010501', 'cellule', 'Cellule Strasbourg', 'C-GRE-01', '00000000-0000-0000-0001-000000000105'),
('00000000-0000-0000-0004-000000010502', 'cellule', 'Cellule Metz-Nancy', 'C-GRE-02', '00000000-0000-0000-0001-000000000105'),
-- SS-HDF Hauts-de-France
('00000000-0000-0000-0004-000000010601', 'cellule', 'Cellule Lille', 'C-HDF-01', '00000000-0000-0000-0001-000000000106'),
('00000000-0000-0000-0004-000000010602', 'cellule', 'Cellule Amiens', 'C-HDF-02', '00000000-0000-0000-0001-000000000106'),
-- SS-NAQ Nouvelle-Aquitaine
('00000000-0000-0000-0004-000000010801', 'cellule', 'Cellule Bordeaux', 'C-NAQ-01', '00000000-0000-0000-0001-000000000108'),
-- SS-OCC Occitanie
('00000000-0000-0000-0004-000000010901', 'cellule', 'Cellule Toulouse', 'C-OCC-01', '00000000-0000-0000-0001-000000000109'),
('00000000-0000-0000-0004-000000010902', 'cellule', 'Cellule Montpellier', 'C-OCC-02', '00000000-0000-0000-0001-000000000109'),
-- SS-PAM PACA Marseille
('00000000-0000-0000-0004-000000011001', 'cellule', 'Cellule Marseille Nord', 'C-PAM-01', '00000000-0000-0000-0001-000000000110'),
('00000000-0000-0000-0004-000000011002', 'cellule', 'Cellule Marseille Sud', 'C-PAM-02', '00000000-0000-0000-0001-000000000110'),
-- SS-PAN PACA Nice
('00000000-0000-0000-0004-000000011101', 'cellule', 'Cellule Nice', 'C-PAN-01', '00000000-0000-0000-0001-000000000111'),
-- SS-PDL Pays de la Loire
('00000000-0000-0000-0004-000000011201', 'cellule', 'Cellule Nantes', 'C-PDL-01', '00000000-0000-0000-0001-000000000112'),
-- SS-BRE Bretagne
('00000000-0000-0000-0004-000000010301', 'cellule', 'Cellule Rennes', 'C-BRE-01', '00000000-0000-0000-0001-000000000103'),
-- SS-NOR Normandie
('00000000-0000-0000-0004-000000010701', 'cellule', 'Cellule Rouen', 'C-NOR-01', '00000000-0000-0000-0001-000000000107');
