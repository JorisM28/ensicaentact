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
                       annee ENUM('1A','2A','3A'),
                       description TEXT,
                       entrepriseUniversite ENUM('E','U','I') DEFAULT 'I',
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
    description TEXT,
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


TRUNCATE TABLE STAGE;


INSERT INTO STAGE (intitule, annee, description, entrepriseUniversite, id_date, id_lieu, id_user) VALUES
('Stage Ouvrier', '1A', 'Immersion totale au sein de la chaîne de production. Ma mission consistait à comprendre les contraintes logistiques et le rythme industriel. J''ai participé à l''assemblage des composants et au contrôle qualité en fin de ligne, tout en proposant une petite automatisation du reporting quotidien via Excel.', 'I', 1, 1, 1),
('Stage Initiation', '1A', 'Première découverte des services supports en entreprise. Observation du flux de travail entre le département commercial et technique. J''ai assisté les chefs de projet dans la planification des réunions et la mise à jour des tableaux de bord de suivi d''activité.', 'E', 1, 2, 2),
('Découverte Code', '1A', 'Stage d''observation au sein d''une équipe de développement agile. J''ai découvert les rituels Scrum (Daily, Sprint Planning) et effectué mes premiers tickets Jira concernant des corrections mineures sur l''interface utilisateur (CSS et HTML).', 'E', 1, 3, 3),
('Support IT', '1A', 'Gestion des incidents de niveau 1 au sein du parc informatique. Configuration des postes de travail pour les nouveaux arrivants, installation des logiciels métiers et dépannage réseau de proximité. Rédaction de fiches procédures pour le wiki interne.', 'E', 1, 6, 4),
('Maintenance', '1A', 'Aide à la maintenance préventive du centre de données. Vérification du câblage, inventaire du matériel réseau et participation à la mise en place d''un système de monitoring simple pour surveiller la température des baies serveurs.', 'E', 1, 8, 5),
('Admin Sys', '1A', 'Accompagnement de l''administrateur système dans le déploiement de mises à jour de sécurité sur un parc de 50 machines sous Linux. Initiation à la gestion des droits utilisateurs et à la configuration des sauvegardes automatiques.', 'E', 1, 9, 6),
('Aide Développeur', '1A', 'Soutien à l''équipe technique pour la rédaction de la documentation utilisateur d''une API interne. J''ai également réalisé une série de tests fonctionnels pour vérifier la non-régression après une mise à jour majeure du framework.', 'E', 1, 1, 7);

-- ==========================================
-- 2. STAGES 2A (International - 80% Université 'U')
-- ==========================================
-- 12 élèves en Université (1 à 12), 3 en Entreprise (13 à 15)
INSERT INTO STAGE (intitule, annee, description, entrepriseUniversite, id_date, id_lieu, id_user) VALUES
('Software Research', '2A', 'Développement d''un prototype de tableau de bord au sein du laboratoire de recherche de l''université. Travail sur l''utilisation de React.js pour visualiser des données télémétriques complexes. Focus sur l''optimisation des algorithmes de rendu.', 'U', 2, 4, 1),
('Cloud Infrastructure', '2A', 'Assistant de recherche sur les problématiques de scalabilité des serveurs de jeux. Mise en œuvre d''une infrastructure via Terraform et configuration de clusters Kubernetes pour un projet universitaire de grande envergure.', 'U', 2, 5, 2),
('Cyber Security Lab', '2A', 'Analyse académique des vulnérabilités sur les protocoles de paiement. Réalisation de tests d''intrusion en environnement contrôlé (Sandboxing) et rédaction d''une étude comparative sur les politiques de sécurité VPN.', 'U', 2, 7, 3),
('Data Science Assistant', '2A', 'Exploitation de jeux de données massifs issus de la recherche en micro-conducteurs. Nettoyage de millions de lignes avec Python et création de modèles de visualisation pour aider les chercheurs à interpréter les signaux faibles.', 'U', 2, 10, 4),
('Mobile UX Research', '2A', 'Étude de l''expérience utilisateur sur les applications de mobilité électrique. Focus sur l''intégration de la géolocalisation en temps réel et gestion de la consommation énergétique des applications hybrides.', 'U', 2, 4, 5),
('IoT Academic Project', '2A', 'Recherche sur les protocoles de communication basse consommation (LoRaWAN). Prototypage de capteurs d''ambiance pour les bâtiments intelligents du campus et analyse de la latence de transmission en milieu urbain.', 'U', 2, 5, 6),
('Big Data Analytics', '2A', 'Migration de bases de données de recherche vers un environnement distribué. Utilisation d''Apache Spark pour traiter des flux de données scientifiques en temps réel et stockage optimisé pour le calcul intensif.', 'U', 2, 7, 7),
('Telecom Simulation', '2A', 'Simulation de la couverture réseau 5G pour les futurs campus connectés. Analyse mathématique de l''interférence des signaux et proposition de modèles théoriques pour maximiser le débit utilisateur.', 'U', 2, 10, 8),
('DevOps Methodology', '2A', 'Étude de l''automatisation du cycle de déploiement pour les logiciels financiers open-source. Création de pipelines CI/CD et monitoring des performances des conteneurs pour une plateforme de recherche bancaire.', 'U', 2, 4, 9),
('Statistical Modeling', '2A', 'Analyse statistique des données comportementales au sein du département de mathématiques. Création de modèles prédictifs pour identifier les tendances de consommation et recommandation d''algorithmes de correction.', 'U', 2, 5, 10),
('Embedded Systems Lab', '2A', 'Programmation de microcontrôleurs pour la gestion de capteurs biométriques. Travail sur l''optimisation de la mémoire vive et écriture de drivers spécifiques en C pour des applications de santé connectée.', 'U', 2, 7, 11),
('Game Mechanics Study', '2A', 'Collaboration avec le département des arts numériques pour le scripting de mécaniques de jeu. Équilibrage des statistiques et optimisation du moteur de physique pour des simulations pédagogiques.', 'U', 2, 10, 12),
('AI Vision', '2A', 'Développement d''un algorithme de détection d''obstacles pour véhicules autonomes chez Tesla. Utilisation du Deep Learning pour entraîner un modèle de reconnaissance d''objets en conditions réelles.', 'E', 2, 4, 13),
('Avionics Test', '2A', 'Développement de scripts de tests automatisés pour valider les systèmes de navigation chez Ubisoft (Simulation). Vérification de la résilience du logiciel embarqué.', 'E', 2, 5, 14),
('Backend Dev', '2A', 'Refonte de l''architecture de gestion des identités chez Amazon. Passage d''une architecture monolithique à des micro-services avec une gestion poussée de l''authentification OAuth2.', 'E', 2, 7, 15);

-- ==========================================

INSERT INTO STAGE (intitule, annee, description, entrepriseUniversite, id_date, id_lieu, id_user) VALUES
('PFE Java', '3A', 'Conception et réalisation d''un moteur de recherche sémantique interne chez Google. Utilisation de Spring Boot pour le backend et intégration d''Elasticsearch pour traiter des téraoctets de données non structurées.', 'E', 3, 1, 1),
('PFE Azure', '3A', 'Architecture et déploiement d''une plateforme de services financiers sur Azure chez Microsoft. Mise en place d''une stratégie de haute disponibilité et automatisation de la gouvernance des coûts cloud.', 'E', 3, 6, 2),
('PFE Pentest', '3A', 'Responsable de la sécurité d''une nouvelle application bancaire chez Thales. Réalisation d''audits de code et tests de pénétration complets selon les standards de l''OWASP.', 'E', 3, 2, 3),
('PFE Deep Learning', '3A', 'Optimisation d''un réseau de neurones pour le traitement naturel du langage chez Tesla. Réduction de la taille du modèle pour une exécution sur smartphone avec une précision de 95%.', 'E', 3, 4, 4),
('PFE Swift', '3A', 'Développement intégral d''une application iOS pour Ubisoft. Focus sur l''interopérabilité entre différents standards de communication et intégration des nouveaux widgets interactifs.', 'E', 3, 5, 5),
('PFE Robotique', '3A', 'Développement de l''intelligence logicielle d''un robot collaboratif chez Microsoft. Programmation des trajectoires d''évitement et intégration de la vision par ordinateur.', 'E', 3, 6, 6),
('PFE Spark', '3A', 'Mise en place d''un cluster de calcul distribué chez Amazon. Traitement de flux massifs pour détecter des comportements anormaux évocateurs d''une exfiltration de données.', 'E', 3, 7, 7),
('PFE 5G Core', '3A', 'Implémentation des fonctions réseau du coeur 5G chez Airbus. Analyse des performances du Slicing pour garantir une latence ultra-faible aux applications industrielles.', 'E', 3, 8, 8),
('PFE Kubernetes', '3A', 'Conception d''une plateforme de conteneurs auto-réparatrice pour la Société Générale. Mise en place de sondes avancées et de stratégies de basculement automatique.', 'E', 3, 9, 9),
('PFE Data Science', '3A', 'Création d''un moteur de recommandation basé sur les graphes chez Nvidia. Analyse des relations entre les bibliothèques logicielles pour suggérer les optimisations les plus pertinentes.', 'E', 3, 10, 10),
('PFE Autosar', '3A', 'Standardisation de la couche logicielle de communication automobile chez Thales. Implémentation du protocole SOME/IP et tests de conformité aux normes ASIL-D.', 'E', 3, 2, 11),
('PFE Engine C++', '3A', 'Optimisation du moteur de rendu physique chez Ubisoft. Travail sur les shaders et les calculs parallèles sur GPU pour atteindre un taux de rafraîchissement stable.', 'E', 3, 5, 12),
('PFE NLP Research', '3A', 'Étude et implémentation de techniques de Prompt Engineering automatisé au laboratoire universitaire. Évaluation de la pertinence des réponses via des métriques de satisfaction.', 'U', 3, 4, 13),
('PFE Flight Control', '3A', 'Algorithmes de pilotage automatique pour drones autonomes en centre de recherche. Gestion de la formation en vol et évitement collaboratif via apprentissage par renforcement.', 'U', 3, 8, 14),
('PFE Lead Tech', '3A', 'Management technique d''une équipe de recherche sur un projet de refonte de base de connaissances académiques. Choix de la stack technique et animation des revues de code.', 'U', 3, 1, 15);


TRUNCATE TABLE TRAVAIL;
INSERT INTO TRAVAIL (poste, description, id_date, id_lieu, id_user) VALUES
('Développeur Junior', 'En charge du développement des nouvelles fonctionnalités du portail utilisateur. Je travaille quotidiennement avec TypeScript et Vue.js dans une équipe de 10 personnes. Je participe également activement aux tests de performance et à l''optimisation du SEO technique.', 3, 1, 1),
('Cloud Architect', 'Conception de solutions cloud natives pour des clients du secteur de l''énergie. Ma mission consiste à transformer des infrastructures anciennes en solutions modernes basées sur le serverless et les micro-services, tout en garantissant une réduction des coûts opérationnels.', 3, 4, 2),
('Analyste SOC', 'Surveillance 24/7 des cybermenaces pour les infrastructures critiques du groupe Thales. Je suis responsable de l''investigation des alertes complexes, de la mise à jour des règles de détection et de la rédaction de rapports post-incident pour la direction technique.', 3, 2, 3),
('Data Scientist', 'Développement de modèles prédictifs pour optimiser la chaîne logistique mondiale. J''utilise des algorithmes de machine learning pour anticiper les retards de livraison et proposer des itinéraires alternatifs en temps réel, sauvant ainsi des millions en coûts de stockage.', 3, 3, 4),
('Dev Mobile', 'Spécialiste du développement multiplateforme avec Flutter. Je gère l''intégralité du cycle de vie des applications mobiles de Tesla, de la conception UI/UX à la publication sur les stores, avec un focus particulier sur l''intégration des fonctionnalités Bluetooth Low Energy.', 3, 5, 5),
('Ingénieur IoT', 'Responsable de la connectivité des futurs équipements intelligents de Microsoft. Je travaille sur l''intégration sécurisée des appareils dans le cloud Azure et sur le développement de micrologiciels économes en énergie pour les nouveaux capteurs environnementaux.', 3, 6, 6),
('Data Engineer', 'Architecture et maintenance de l''entrepôt de données (Data Warehouse). Je conçois des pipelines ETL robustes qui traitent quotidiennement plusieurs pétaoctets de données transactionnelles pour fournir des rapports précis aux analystes financiers.', 3, 7, 7),
('Ingénieur Réseaux', 'Garant de la stabilité et de la sécurité du réseau étendu d''Airbus. Je supervise la mise à jour des équipements backbone, je gère les configurations des firewalls haute disponibilité et j''assure le support de niveau 3 pour les problèmes d''infrastructure majeurs.', 3, 8, 8),
('SRE Engineer', 'Mon rôle est de faire le pont entre le développement et les opérations. Je m''assure que nos systèmes bancaires sont toujours disponibles en automatisant les processus de déploiement et en créant des outils d''auto-remédiation pour les pannes courantes.', 3, 9, 9),
('ML Engineer', 'Spécialisé dans le déploiement de modèles de vision par ordinateur sur du matériel spécifique (Jetson, TPU). J''optimise les modèles PyTorch pour qu''ils s''exécutent en temps réel sur les chaînes de production pour détecter les défauts de fabrication.', 3, 10, 10),
('Ingénieur ECU', 'Conception et tests des unités de contrôle moteur pour la prochaine génération de véhicules hybrides. Je travaille sur la logique de gestion de l''énergie entre le thermique et l''électrique pour maximiser l''autonomie tout en respectant les normes antipollution.', 3, 2, 11),
('Game Developer', 'Développeur senior sur le prochain jeu AAA d''Ubisoft. Responsable de l''intelligence artificielle des ennemis et de l''optimisation du moteur de physique. Je travaille en étroite collaboration avec les scénaristes pour rendre les interactions plus réalistes.', 3, 5, 12),
('Chercheur IA', 'Recherche appliquée sur les modèles génératifs au sein du laboratoire de recherche de Tesla. Mes travaux portent sur la génération de mondes virtuels pour l''entraînement des véhicules autonomes, avec plusieurs publications dans des conférences internationales majeures.', 3, 4, 13),
('Ingénieur Bord', 'Développement de logiciels de bord pour les calculateurs de vol critiques. Mon travail est soumis à des contraintes de temps réel strictes et à des standards de qualité aéronautique où aucune erreur n''est permise.', 3, 8, 14),
('Lead Dev', 'Référent technique pour l''ensemble du pôle développement Web. Je définis les standards de qualité, je choisis les nouvelles technologies à adopter et j''accompagne les développeurs plus juniors dans leur montée en compétences via du mentorat.', 3, 1, 15);