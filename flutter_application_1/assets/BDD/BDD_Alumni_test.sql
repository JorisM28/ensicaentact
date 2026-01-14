USE alumni;

-- Suppression des tables dans l'ordre inverse des dépendances
DROP TABLE IF EXISTS STAGE;
DROP TABLE IF EXISTS TRAVAIL;
DROP TABLE IF EXISTS EDUCATION;
DROP TABLE IF EXISTS UTILISATEUR;
DROP TABLE IF EXISTS LIEU;
DROP TABLE IF EXISTS `DATE`;
DROP TABLE IF EXISTS PROMO;

-- 1. Tables sans clés étrangères sortantes
CREATE TABLE LIEU (
                      id_lieu INT AUTO_INCREMENT PRIMARY KEY,
                      entreprise VARCHAR(50),
                      pays VARCHAR(25),
                      ville VARCHAR(25)
);

CREATE TABLE `DATE` (
                        id_date INT AUTO_INCREMENT PRIMARY KEY,
                        debut DATE,
                        fin DATE
);

CREATE TABLE PROMO (
                       id_promo INT AUTO_INCREMENT PRIMARY KEY,
                       promo int check ( promo >= 1900 and promo <= 2100 ),
                       filière VARCHAR(50) NOT NULL,
                       formation VARCHAR(4) CHECK (formation IN ('FISE', 'FISA', 'MTS'))
);

-- 2. Table Utilisateur (nécessaire pour les clés étrangères de STAGE et TRAVAIL)
CREATE TABLE UTILISATEUR (
                             id_user INT AUTO_INCREMENT PRIMARY KEY,
                             nom VARCHAR(50) NOT NULL,
                             prenom VARCHAR(50) NOT NULL,
                             sexe VARCHAR(1) CHECK (sexe IN ('M', 'F', 'I')),
                             age INT check ( age >= 18 and age <= 100 ),
                             decede BOOLEAN DEFAULT FALSE
);

-- 3. Tables avec clés étrangères
CREATE TABLE STAGE (
                       id_stage INT AUTO_INCREMENT PRIMARY KEY,
                       intitule VARCHAR(200) NOT NULL,
                       id_date INT,
                       id_lieu INT,
                       id_user INT,
                       CONSTRAINT fk_stage_user FOREIGN KEY (id_user) REFERENCES UTILISATEUR(id_user),
                       CONSTRAINT fk_stage_date FOREIGN KEY (id_date) REFERENCES `DATE`(id_date),
                       CONSTRAINT fk_stage_lieu FOREIGN KEY (id_lieu) REFERENCES LIEU(id_lieu)
);

CREATE TABLE TRAVAIL (
                         id_travail INT AUTO_INCREMENT PRIMARY KEY,
                         poste VARCHAR(50) NOT NULL,
                         id_date INT,
                         id_lieu INT,
                         id_user INT,
                         CONSTRAINT fk_travail_user FOREIGN KEY (id_user) REFERENCES UTILISATEUR(id_user),
                         CONSTRAINT fk_travail_date FOREIGN KEY (id_date) REFERENCES `DATE`(id_date),
                         CONSTRAINT fk_travail_lieu FOREIGN KEY (id_lieu) REFERENCES LIEU(id_lieu)
);

CREATE TABLE EDUCATION (
                           id_education INT AUTO_INCREMENT PRIMARY KEY,
                           majeure VARCHAR(25) NOT NULL,
                           option_ VARCHAR(50),
                           ddiplome VARCHAR(50),
                           id_promo INT,
                           id_user INT,
                           CONSTRAINT fk_edu_user FOREIGN KEY (id_user) REFERENCES UTILISATEUR(id_user),
                           CONSTRAINT fk_education_promo FOREIGN KEY (id_promo) REFERENCES PROMO(id_promo)
);

-- REMPLISSAGE DES DONNÉES

INSERT INTO PROMO (promo, filière, formation) VALUES
                                                  ('2024', 'Informatique', 'FISE'),
                                                  ('2025', 'Systèmes Embarqués', 'FISA'),
                                                  ('2026', 'Data Science', 'MTS');

INSERT INTO LIEU (entreprise, pays, ville) VALUES
                                               ('Google', 'France', 'Paris'), ('Thales', 'France', 'Toulouse'),
                                               ('Capgemini', 'France', 'Lyon'), ('Tesla', 'USA', 'Palo Alto'),
                                               ('Ubisoft', 'Canada', 'Montréal'), ('Microsoft', 'France', 'Issy'),
                                               ('Amazon', 'Luxembourg', 'Luxembourg'), ('Airbus', 'France', 'Blagnac'),
                                               ('Société Générale', 'France', 'La Défense'), ('Nvidia', 'USA', 'Santa Clara');

INSERT INTO `DATE` (debut, fin) VALUES
                                    ('2023-01-01', '2023-06-30'), ('2024-02-15', '2024-08-15'),
                                    ('2025-09-01', '2026-09-01'), ('2022-03-01', '2022-09-01'),
                                    ('2023-10-01', '2024-04-01');

-- 15 Utilisateurs avec Sexe et Age
INSERT INTO UTILISATEUR (nom, prenom, sexe, age) VALUES
                                                     ('Dupont', 'Jean', 'M', 23), ('Martin', 'Alice', 'F', 22), ('Lefebvre', 'Thomas', 'M', 24),
                                                     ('Moreau', 'Sonia', 'F', 23), ('Simon', 'Luc', 'M', 25), ('Laurent', 'Julie', 'F', 22),
                                                     ('Michel', 'Benoit', 'M', 24), ('Garcia', 'Maria', 'F', 23), ('Muller', 'Hans', 'M', 26),
                                                     ('Roux', 'Nicolas', 'M', 24), ('David', 'Emma', 'F', 21), ('Bertrand', 'Hugo', 'M', 25),
                                                     ('Rousseau', 'Chloé', 'F', 22), ('Blanc', 'Mathieu', 'M', 23), ('Guerin', 'Léa', 'F', 24);

-- Education pour tous
INSERT INTO EDUCATION (majeure, option_, ddiplome, id_promo, id_user) VALUES
<<<<<<< HEAD
                                                                        ('Développement', 'Fullstack', 'Ingénieur', 1, 1), ('Développement', 'Cloud', 'Master M2', 1, 2),
                                                                        ('Réseaux', 'Sécurité', 'Ingénieur', 2, 3), ('Data', 'IA', 'Double Diplôme', 3, 4),
                                                                        ('Développement', 'Mobile', 'Master', 1, 5), ('Systèmes', 'IoT', 'Ingénieur', 2, 6),
                                                                        ('Data', 'Big Data', 'Master', 3, 7), ('Réseaux', 'Télécom', 'Ingénieur', 2, 8),
                                                                        ('Développement', 'DevOps', 'Master', 1, 9), ('Data', 'Statistiques', 'Ingénieur', 3, 10),
                                                                        ('Systèmes', 'Automobile', 'Master', 2, 11), ('Développement', 'Jeux Vidéo', 'Ingénieur', 1, 12),
                                                                        ('Data', 'Deep Learning', 'Master', 3, 13), ('Systèmes', 'Aéronautique', 'Ingénieur', 2, 14),
                                                                        ('Développement', 'Backend', 'Master', 1, 15);
=======
                                                                          ('Développement', 'Fullstack', 'Ingénieur', 1, 1), ('Développement', 'Cloud', 'Master M2', 1, 2),
                                                                          ('Réseaux', 'Sécurité', 'Ingénieur', 2, 3), ('Data', 'IA', 'Double Diplôme', 3, 4),
                                                                          ('Développement', 'Mobile', 'Master', 1, 5), ('Systèmes', 'IoT', 'Ingénieur', 2, 6),
                                                                          ('Data', 'Big Data', 'Master', 3, 7), ('Réseaux', 'Télécom', 'Ingénieur', 2, 8),
                                                                          ('Développement', 'DevOps', 'Master', 1, 9), ('Data', 'Statistiques', 'Ingénieur', 3, 10),
                                                                          ('Systèmes', 'Automobile', 'Master', 2, 11), ('Développement', 'Jeux Vidéo', 'Ingénieur', 1, 12),
                                                                          ('Data', 'Deep Learning', 'Master', 3, 13), ('Systèmes', 'Aéronautique', 'Ingénieur', 2, 14),
                                                                          ('Développement', 'Backend', 'Master', 1, 15);
>>>>>>> 9e7b5fb164522351ef9243a03a76c0699756123c

-- Stages pour tous (15 stages)
INSERT INTO STAGE (intitule, id_date, id_lieu, id_user) VALUES
                                                            ('Stage Java', 1, 1, 1), ('Stage Cloud', 1, 2, 2), ('Stage Cyber', 1, 3, 3),
                                                            ('Stage Data', 2, 4, 4), ('Stage Android', 2, 5, 5), ('Stage IoT', 2, 6, 6),
                                                            ('Stage Analytics', 1, 7, 7), ('Stage 5G', 2, 8, 8), ('Stage Docker', 1, 9, 9),
                                                            ('Stage Stats', 2, 10, 10), ('Stage Embedded', 1, 2, 11), ('Stage Unity', 2, 5, 12),
                                                            ('Stage Vision', 1, 4, 13), ('Stage Avionique', 2, 8, 14), ('Stage API', 1, 1, 15);

-- Travail pour tous (15 jobs)
INSERT INTO TRAVAIL (poste, id_date, id_lieu, id_user) VALUES
                                                           ('Développeur Junior', 3, 1, 1), ('Cloud Architect', 3, 4, 2), ('Analyste SOC', 3, 2, 3),
                                                           ('Data Scientist', 3, 3, 4), ('Dev Mobile', 3, 5, 5), ('Ingénieur IoT', 3, 6, 6),
                                                           ('Data Engineer', 3, 7, 7), ('Ingénieur Réseaux', 3, 8, 8), ('SRE Engineer', 3, 9, 9),
                                                           ('ML Engineer', 3, 10, 10), ('Ingénieur ECU', 3, 2, 11), ('Game Developer', 3, 5, 12),
                                                           ('Chercheur IA', 3, 4, 13), ('Ingénieur Bord', 3, 8, 14), ('Lead Dev', 3, 1, 15);








SELECT
    u.nom,
    u.prenom,
    u.sexe,
    u.age,
    u.decede AS décédé,
    pr.promo AS annee_promo,
    pr.filière,
    e.majeure,
    e.option_ AS option_specialite,
    -- Infos Stage
    s.intitule AS stage_titre,
    l_s.entreprise AS entreprise_stage,
    d_s.debut AS debut_stage,
    d_s.fin AS fin_stage,
    -- Infos Travail
    t.poste AS job_actuel,
    l_t.entreprise AS entreprise_job,
    l_t.ville AS ville_job
FROM UTILISATEUR u
-- Jointure vers l'éducation et la promotion
         LEFT JOIN EDUCATION e ON u.id_user = e.id_user
         LEFT JOIN PROMO pr ON e.id_promo = pr.id_promo
-- Jointure vers les détails du stage
         LEFT JOIN STAGE s ON u.id_user = s.id_user
         LEFT JOIN LIEU l_s ON s.id_lieu = l_s.id_lieu
         LEFT JOIN `DATE` d_s ON s.id_date = d_s.id_date
-- Jointure vers les détails du travail actuel
         LEFT JOIN TRAVAIL t ON u.id_user = t.id_user
         LEFT JOIN LIEU l_t ON t.id_lieu = l_t.id_lieu
         LEFT JOIN `DATE` d_t ON t.id_date = d_t.id_date;