-- ==========================================
-- 1. SUPPRESSION DES TABLES
-- ==========================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS STAGE, TRAVAIL, EDUCATION, UTILISATEUR, LIEU, DATE_TABLE, PROMO;
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- 2. CRÉATION DES TABLES (Syntaxe MySQL)
-- ==========================================

CREATE TABLE LIEU (
    id_lieu INT AUTO_INCREMENT PRIMARY KEY,
    entreprise VARCHAR(255),
    pays VARCHAR(255),
    ville VARCHAR(255)
);

CREATE TABLE DATE_TABLE (
    id_date INT AUTO_INCREMENT PRIMARY KEY,
    debut VARCHAR(50),
    fin VARCHAR(50)
);

CREATE TABLE PROMO (
    id_promo INT AUTO_INCREMENT PRIMARY KEY,
    promo INT,
    filiere VARCHAR(255) NOT NULL,
    formation ENUM('FISE','FISA','MTS')
);

CREATE TABLE UTILISATEUR (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    sexe ENUM('M','F','I'),
    age INT,
    tel VARCHAR(20),
    mail VARCHAR(50),
    autor TINYINT(1) DEFAULT 0,
    decede TINYINT(1) DEFAULT 0
);

CREATE TABLE EDUCATION (
    id_education INT AUTO_INCREMENT PRIMARY KEY,
    majeure VARCHAR(255) NOT NULL,
    option_ VARCHAR(255),
    ddiplome VARCHAR(255),
    id_promo INT,
    id_user INT,
    FOREIGN KEY (id_user) REFERENCES UTILISATEUR(id_user),
    FOREIGN KEY (id_promo) REFERENCES PROMO(id_promo)
);

CREATE TABLE STAGE (
    id_stage INT AUTO_INCREMENT PRIMARY KEY,
    intitule VARCHAR(255) NOT NULL,
    id_date INT,
    id_lieu INT,
    id_user INT,
    FOREIGN KEY (id_user) REFERENCES UTILISATEUR(id_user),
    FOREIGN KEY (id_date) REFERENCES DATE_TABLE(id_date),
    FOREIGN KEY (id_lieu) REFERENCES LIEU(id_lieu)
);

CREATE TABLE TRAVAIL (
    id_travail INT AUTO_INCREMENT PRIMARY KEY,
    poste VARCHAR(255) NOT NULL,
    id_date INT,
    id_lieu INT,
    id_user INT,
    FOREIGN KEY (id_user) REFERENCES UTILISATEUR(id_user),
    FOREIGN KEY (id_date) REFERENCES DATE_TABLE(id_date),
    FOREIGN KEY (id_lieu) REFERENCES LIEU(id_lieu)
);

-- ==========================================
-- 3. INSERTION DES DONNÉES
-- ==========================================

INSERT INTO PROMO (promo, filiere, formation) VALUES
(2024, 'Informatique', 'FISE'),
(2025, 'Systèmes Embarqués', 'FISA'),
(2026, 'Data Science', 'MTS');

INSERT INTO LIEU (entreprise, pays, ville) VALUES
('Google', 'France', 'Paris'), ('Thales', 'France', 'Toulouse'),
('Capgemini', 'France', 'Lyon'), ('Tesla', 'USA', 'Palo Alto'),
('Ubisoft', 'Canada', 'Montréal'), ('Microsoft', 'France', 'Issy'),
('Amazon', 'Luxembourg', 'Luxembourg'), ('Airbus', 'France', 'Blagnac'),
('Société Générale', 'France', 'La Défense'), ('Nvidia', 'USA', 'Santa Clara');

INSERT INTO DATE_TABLE (debut, fin) VALUES
('2023-01-01', '2023-06-30'), ('2024-02-15', '2024-08-15'),
('2025-09-01', '2026-09-01'), ('2022-03-01', '2022-09-01'),
('2023-10-01', '2024-04-01');

INSERT INTO UTILISATEUR (nom, prenom, sexe, age, tel, mail, autor, decede) VALUES
('Moczygepasdemeuf', 'Joris', 'M', 23, '0601010101', 'Joris.moczygepasdemeuf@ecole.ensicaen.fr', 0, 1),
('Martin', 'Alice', 'F', 22, '0602020202', 'alice.martin@ecole.ensicaen.fr', 0, 0),
('Lefebvre', 'Thomas', 'M', 24, '0603030303', 'thomas.lefebvre@ecole.ensicaen.fr', 0, 0),
('Moreau', 'Sonia', 'F', 23, '0604040404', 'sonia.moreau@ecole.ensicaen.fr', 0, 0),
('Simon', 'Luc', 'M', 25, '0605050505', 'luc.simon@ecole.ensicaen.fr', 0, 0),
('Laurent', 'Julie', 'F', 22, '0606060606', 'julie.laurent@ecole.ensicaen.fr', 0, 0),
('Michel', 'Benoit', 'M', 24, '0607070707', 'benoit.michel@ecole.ensicaen.fr', 0, 0),
('Garcia', 'Maria', 'F', 23, '0608080808', 'maria.garcia@ecole.ensicaen.fr', 0, 0),
('Muller', 'Hans', 'M', 26, '0609090909', 'hans.muller@ecole.ensicaen.fr', 1, 0),
('Roux', 'Nicolas', 'M', 24, '0610101010', 'nicolas.roux@ecole.ensicaen.fr', 1, 0),
('David', 'Emma', 'F', 21, '0611111111', 'emma.david@ecole.ensicaen.fr', 1, 0),
('Bertrand', 'Hugo', 'M', 25, '0612121212', 'hugo.bertrand@ecole.ensicaen.fr', 1, 0),
('Rousseau', 'Chloé', 'F', 22, '0613131313', 'chloe.rousseau@ecole.ensicaen.fr', 1, 0),
('Blanc', 'Mathieu', 'M', 23, '0614141414', 'mathieu.blanc@ecole.ensicaen.fr', 1, 0),
('Guerin', 'Léa', 'F', 24, '0615151515', 'lea.guerin@ecole.ensicaen.fr', 1, 0);

INSERT INTO EDUCATION (majeure, option_, ddiplome, id_promo, id_user) VALUES
('Développement', 'Fullstack', 'Ingénieur', 1, 1), ('Développement', 'Cloud', 'Master M2', 1, 2),
('Réseaux', 'Sécurité', 'Ingénieur', 2, 3), ('Data', 'IA', 'Double Diplôme', 3, 4),
('Développement', 'Mobile', 'Master', 1, 5), ('Systèmes', 'IoT', 'Ingénieur', 2, 6),
('Data', 'Big Data', 'Master', 3, 7), ('Réseaux', 'Télécom', 'Ingénieur', 2, 8),
('Développement', 'DevOps', 'Master', 1, 9), ('Data', 'Statistiques', 'Ingénieur', 3, 10),
('Systèmes', 'Automobile', 'Master', 2, 11), ('Développement', 'Jeux Vidéo', 'Ingénieur', 1, 12),
('Data', 'Deep Learning', 'Master', 3, 13), ('Systèmes', 'Aéronautique', 'Ingénieur', 2, 14),
('Développement', 'Backend', 'Master', 1, 15);

INSERT INTO STAGE (intitule, id_date, id_lieu, id_user) VALUES
('Stage Java', 1, 1, 1), ('Stage Cloud', 1, 2, 2), ('Stage Cyber', 1, 3, 3),
('Stage Data', 2, 4, 4), ('Stage Android', 2, 5, 5), ('Stage IoT', 2, 6, 6),
('Stage Analytics', 1, 7, 7), ('Stage 5G', 2, 8, 8), ('Stage Docker', 1, 9, 9),
('Stage Stats', 2, 10, 10), ('Stage Embedded', 1, 2, 11), ('Stage Unity', 2, 5, 12),
('Stage Vision', 1, 4, 13), ('Stage Avionique', 2, 8, 14), ('Stage API', 1, 1, 15);

INSERT INTO TRAVAIL (poste, id_date, id_lieu, id_user) VALUES
('Développeur Junior', 3, 1, 1), ('Cloud Architect', 3, 4, 2), ('Analyste SOC', 3, 2, 3),
('Data Scientist', 3, 3, 4), ('Dev Mobile', 3, 5, 5), ('Ingénieur IoT', 3, 6, 6),
('Data Engineer', 3, 7, 7), ('Ingénieur Réseaux', 3, 8, 8), ('SRE Engineer', 3, 9, 9),
('ML Engineer', 3, 10, 10), ('Ingénieur ECU', 3, 2, 11), ('Game Developer', 3, 5, 12),
('Chercheur IA', 3, 4, 13), ('Ingénieur Bord', 3, 8, 14), ('Lead Dev', 3, 1, 15);
