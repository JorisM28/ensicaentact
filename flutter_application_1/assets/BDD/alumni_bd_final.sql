-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : ven. 27 mars 2026 à 11:22
-- Version du serveur :  8.0.42-0ubuntu0.20.04.1
-- Version de PHP : 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `alumni_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `ACTUALITES`
--

CREATE TABLE `ACTUALITES` (
  `id_actu` int NOT NULL,
  `titre` varchar(255) NOT NULL,
  `contenu` text NOT NULL,
  `tag` varchar(50) DEFAULT NULL,
  `tag_color` varchar(20) DEFAULT '#67CBB8',
  `image_url` varchar(255) DEFAULT NULL,
  `date_publi` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_auteur` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `ACTUALITES`
--

INSERT INTO `ACTUALITES` (`id_actu`, `titre`, `contenu`, `tag`, `tag_color`, `image_url`, `date_publi`, `id_auteur`) VALUES
(52, 'Retour des Alumnis', 'Pour les 10 ans de la promos 2016, les Alumnis reviendront sur le campus le 10 Avril !', 'NEWS', '#00a1a1', 'https://alumni.ensicaen.fr/wp-content/uploads/2023/07/cropped-750300-ENSICAENalumni_logo-wordpress.png', '2026-03-23 19:57:38', 2);

-- --------------------------------------------------------

--
-- Structure de la table `ALUMNI`
--

CREATE TABLE `ALUMNI` (
  `id_user` int NOT NULL,
  `sexe` enum('M','F','I') DEFAULT NULL,
  `date_naissance` date DEFAULT NULL,
  `tel` varchar(20) DEFAULT NULL,
  `autor` tinyint(1) DEFAULT '0',
  `decede` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `ALUMNI`
--

INSERT INTO `ALUMNI` (`id_user`, `sexe`, `date_naissance`, `tel`, `autor`, `decede`) VALUES
(7, 'M', '2002-01-01', '0607070707', 0, 0),
(20, 'M', '1998-01-01', '0610203040', 1, 0),
(28, 'M', '1996-01-01', '0628282828', 0, 0),
(31, 'M', '2000-01-01', '0631313131', 1, 0),
(39, 'M', '1999-01-01', '0639393939', 0, 0),
(42, 'F', '2001-01-01', '0642424242', 0, 0),
(201, 'M', '1997-05-14', '0611223344', 1, 0),
(202, 'F', '1994-08-22', '0622334455', 0, 0),
(203, 'M', '2000-11-03', '0633445566', 1, 0),
(204, 'F', '1987-02-15', '0644556677', 1, 0),
(205, 'M', '2001-09-30', '0655667788', 0, 0),
(206, 'F', '1992-12-12', '0666778899', 1, 0),
(207, 'M', '1998-04-25', '0677889900', 0, 0),
(208, 'F', '1989-07-08', '0688990011', 1, 0),
(209, 'M', '1997-01-19', '0699001122', 0, 0),
(210, 'F', '1996-06-05', '0600112233', 1, 0);

-- --------------------------------------------------------

--
-- Structure de la table `DEMANDE_AJOUT`
--

CREATE TABLE `DEMANDE_AJOUT` (
  `id_demande` int NOT NULL,
  `nom` varchar(100) DEFAULT NULL,
  `prenom` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `date_demande` datetime DEFAULT CURRENT_TIMESTAMP,
  `contenu_json` text,
  `statut` varchar(20) DEFAULT 'EN_ATTENTE',
  `type` varchar(20) NOT NULL DEFAULT 'alumni'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `DEMANDE_AJOUT`
--

INSERT INTO `DEMANDE_AJOUT` (`id_demande`, `nom`, `prenom`, `email`, `date_demande`, `contenu_json`, `statut`, `type`) VALUES
(6, 'Michel', 'Benoît', 'benoit.michel@ensicaen.fr', '2026-02-04 17:02:27', '{\"titre\":\"Cr\\u00eapes Party\",\"type\":\"Rencontre\",\"date_event\":\"2026-02-04 17:02:06.690743\",\"lieu\":\"Bourgoin-Jallieu\",\"description\":\"Cit\\u00e9 m\\u00e9di\\u00e9vale vla les cr\\u00eapes\",\"id_auteur\":null}', 'en_attente', 'alumni');

-- --------------------------------------------------------

--
-- Structure de la table `EDUCATION`
--

CREATE TABLE `EDUCATION` (
  `id_education` int NOT NULL,
  `majeure` varchar(255) NOT NULL,
  `option_` varchar(255) DEFAULT NULL,
  `ddiplome` varchar(255) DEFAULT NULL,
  `id_promo` int DEFAULT NULL,
  `id_user` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `EDUCATION`
--

INSERT INTO `EDUCATION` (`id_education`, `majeure`, `option_`, `ddiplome`, `id_promo`, `id_user`) VALUES
(7, 'ISIA', 'Intelligence Artificielle', 'Master', 3, 7),
(27, 'ISIA', 'Intelligence Artificielle', 'Ingénieur', 1, 28),
(30, 'Systèmes embarqués et automatique', NULL, 'Ingénieur', 1, 31),
(37, 'CIA', 'Intelligence Artificielle', 'EM Normandie', 42, 20),
(39, 'ISIA', 'Intelligence Artificielle', 'Ingénieur', 106, 39),
(42, 'ISIA', 'Intelligence Artificielle', 'Ingénieur', 15, 42),
(193, 'Informatique', 'Intelligence Artificielle', 'Ingénieur', 25, 201),
(194, 'Systèmes Embarqués', 'Robotique', 'Ingénieur', 106, 202),
(195, 'Matériaux Chimie', 'Nanotechnologies', 'Ingénieur', 5, 203),
(196, 'Informatique', 'Génie Logiciel', 'Ingénieur', 16, 204),
(197, 'Systèmes Embarqués', 'Automatique', 'Ingénieur', 105, 205),
(198, 'Matériaux Chimie', 'Polymères', 'Ingénieur', 89, 206),
(199, 'Informatique', 'Data Science', 'Ingénieur', 33, 207),
(200, 'Systèmes Embarqués', 'Architecture matérielle', 'Ingénieur', 70, 208),
(201, 'Matériaux Chimie', 'Structure', 'Ingénieur', 78, 209),
(202, 'Informatique', 'Cybersécurité', 'Ingénieur', 76, 210);

-- --------------------------------------------------------

--
-- Structure de la table `EVENEMENTS`
--

CREATE TABLE `EVENEMENTS` (
  `id_event` int NOT NULL,
  `titre` varchar(255) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `date_event` datetime NOT NULL,
  `lieu` varchar(255) DEFAULT NULL,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  `id_auteur` int DEFAULT NULL,
  `date_creation` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `EVENEMENTS`
--

INSERT INTO `EVENEMENTS` (`id_event`, `titre`, `type`, `date_event`, `lieu`, `description`, `image_url`, `id_auteur`, `date_creation`) VALUES
(22, 'Rencontre du Samedi', 'Rencontre', '2026-03-28 00:00:00', 'ENSICAEN, Campus 2, Salle multiactivité', 'Notre rencontre du samedi entre Alumnis et élèves ingénieur.', NULL, 7, '2026-03-23 20:41:49'),
(24, 'Photo du carnaval de Caen', 'Rencontre', '2026-03-26 00:00:00', 'Parvis de l\'ENSICAEN site A', 'Chaque année, nous faisons une photo de toutes les personnes déguisées avant le carnaval.', NULL, 31, '2026-03-24 11:03:37');

-- --------------------------------------------------------

--
-- Structure de la table `HISTORIQUE`
--

CREATE TABLE `HISTORIQUE` (
  `id_log` int NOT NULL,
  `id_editeur` int DEFAULT NULL,
  `id_alumni` int DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `date_action` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `HISTORIQUE`
--

INSERT INTO `HISTORIQUE` (`id_log`, `id_editeur`, `id_alumni`, `action`, `description`, `date_action`) VALUES
(228, NULL, NULL, 'AJOUT', 'Ajout de aaaaa aaaa', '2026-02-25 13:38:49'),
(229, NULL, NULL, 'MODIFICATION', 'Stages modifiés', '2026-02-25 13:43:59'),
(230, NULL, NULL, 'SUPPRESSION', 'Suppression du profil de : aaaaa aaaa', '2026-02-25 15:32:22'),
(231, NULL, NULL, 'MODIFICATION', 'Stages modifiés', '2026-02-26 18:39:27'),
(232, NULL, NULL, 'MODIFICATION', 'Stages modifiés', '2026-03-02 19:13:02'),
(233, NULL, NULL, 'AJOUT', 'Ajout de Benoit Cheramy', '2026-03-02 23:11:33'),
(234, NULL, NULL, 'MODIFICATION', 'Stages modifiés', '2026-03-02 23:11:54'),
(235, NULL, NULL, 'MODIFICATION', 'Stages modifiés', '2026-03-04 16:03:58'),
(236, NULL, NULL, 'MODIFICATION', 'Stages modifiés', '2026-03-04 20:44:25'),
(237, NULL, NULL, 'AJOUT', 'Ajout de Etienne Cheramy', '2026-03-18 12:30:36'),
(238, NULL, NULL, 'SUPPRESSION', 'Suppression du profil de : Etienne Cheramy', '2026-03-18 12:39:15'),
(239, NULL, NULL, 'AJOUT', 'Ajout de Etienne Cheramy', '2026-03-18 12:40:34'),
(240, NULL, NULL, 'MODIFICATION', 'Nom | Stages | Nom (Adame -> Adam) | Stages modifiés', '2026-03-18 17:38:09'),
(241, NULL, NULL, 'MODIFICATION', 'Stages | Stages modifiés', '2026-03-18 17:42:14'),
(242, NULL, NULL, 'MODIFICATION', 'Téléphone', '2026-03-18 17:48:04'),
(243, NULL, NULL, 'MODIFICATION', 'Téléphone (072345685 -> 072345678511)', '2026-03-18 17:51:06'),
(244, NULL, NULL, 'MODIFICATION', 'Nom (Andre -> Andree) | Téléphone (072345678511 -> 072345678514)', '2026-03-18 17:56:17'),
(245, NULL, NULL, 'MODIFICATION', 'Nom (Andree -> Andre)', '2026-03-18 17:56:51'),
(247, NULL, NULL, 'SUPPRESSION', 'Suppression du profil de : Morgane Hoarau', '2026-03-18 18:29:48'),
(249, 2, NULL, 'MODIFICATION', 'Nom (Barbier -> Barbiere)', '2026-03-23 18:09:39'),
(250, 2, NULL, 'MODIFICATION', 'Nom (Barbiere -> Barbier)', '2026-03-23 21:55:35'),
(251, 2, NULL, 'MODIFICATION', 'Nom (Bouvier -> Bouviere)', '2026-03-24 09:10:06'),
(252, 2, NULL, 'AJOUT', 'Ajout de joris moc', '2026-03-24 09:31:09'),
(253, NULL, NULL, 'SUPPRESSION', 'Suppression du profil de : joris moc', '2026-03-24 09:31:47'),
(254, 2, NULL, 'AJOUT', 'Ajout de password Test', '2026-03-24 09:43:54'),
(255, NULL, NULL, 'SUPPRESSION', 'Suppression du profil de : password Test', '2026-03-24 09:45:52'),
(256, 2, 20, 'MODIFICATION', 'Nom (Mocz -> Moczygeba) | Entreprise (Foxconn -> ASSE) | Ville (New Taipei -> Ouches) | Promo (2026 -> 2027)', '2026-03-24 16:18:09'),
(257, 2, 20, 'MODIFICATION', 'Sauvegarde générale', '2026-03-24 16:21:42'),
(258, 2, 20, 'MODIFICATION', 'Sauvegarde générale', '2026-03-24 16:22:14'),
(259, 2, 20, 'MODIFICATION', 'Sauvegarde générale', '2026-03-24 16:22:16'),
(260, 2, 39, 'MODIFICATION', 'Sauvegarde générale', '2026-03-24 17:30:44'),
(261, 2, 39, 'MODIFICATION', 'Sauvegarde générale', '2026-03-24 17:49:35'),
(262, 2, 28, 'MODIFICATION', 'Sauvegarde générale', '2026-03-25 08:17:21'),
(263, 2, 39, 'MODIFICATION', 'Sauvegarde générale', '2026-03-25 08:18:52'),
(264, 2, 204, 'MODIFICATION', 'Sauvegarde générale', '2026-03-25 08:20:50'),
(265, 2, 205, 'MODIFICATION', 'Sauvegarde générale', '2026-03-25 08:48:02'),
(266, 2, 204, 'MODIFICATION', 'Sauvegarde générale', '2026-03-25 09:41:01');

-- --------------------------------------------------------

--
-- Structure de la table `KEY_FIGURES`
--

CREATE TABLE `KEY_FIGURES` (
  `id` int NOT NULL,
  `label` varchar(50) NOT NULL,
  `stat_value` int NOT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `icon_key` varchar(50) NOT NULL,
  `color_hex` varchar(10) NOT NULL,
  `display_order` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `KEY_FIGURES`
--

INSERT INTO `KEY_FIGURES` (`id`, `label`, `stat_value`, `suffix`, `icon_key`, `color_hex`, `display_order`) VALUES
(1, 'De fiancements sur des projets / In project fundin', 30000, '€', 'euro', '#E30613', 1),
(2, 'Partenariats / Partnerships', 600, '', 'business', '#1976D2', 2),
(3, 'Alumnis dans le réseau / Alumni in the network', 15000, '+', 'groups', '#EF6C00', 3),
(4, 'OFFRES D\'EMPLOI / JOB OFFERS', 800, '+', 'work', '#00796B', 4);

-- --------------------------------------------------------

--
-- Structure de la table `LIEU`
--

CREATE TABLE `LIEU` (
  `id_lieu` int NOT NULL,
  `entreprise` varchar(255) DEFAULT NULL,
  `pays` varchar(255) DEFAULT NULL,
  `ville` varchar(255) DEFAULT NULL,
  `code_postal` varchar(20) DEFAULT NULL,
  `longitude` decimal(6,3) DEFAULT NULL,
  `latitude` decimal(5,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `LIEU`
--

INSERT INTO `LIEU` (`id_lieu`, `entreprise`, `pays`, `ville`, `code_postal`, `longitude`, `latitude`) VALUES
(1, 'Google', 'France', 'Paris', NULL, '2.352', '48.856'),
(2, 'Thales', 'France', 'Toulouse', NULL, '1.444', '43.604'),
(3, 'Capgemini', 'France', 'Lyon', NULL, '4.835', '45.764'),
(4, 'Tesla', 'USA', 'Palo Alto', NULL, '-122.160', '37.444'),
(5, 'Ubisoft', 'Canada', 'Montréal', NULL, '-73.567', '45.501'),
(6, 'Microsoft', 'France', 'Issy-les-Moulineaux', NULL, '2.263', '48.826'),
(7, 'Amazon', 'Luxembourg', 'Luxembourg', NULL, '6.131', '49.611'),
(8, 'Airbus', 'France', 'Blagnac', NULL, '1.376', '43.636'),
(9, 'Société Générale', 'France', 'La Défense', NULL, '2.241', '48.889'),
(10, 'Nvidia', 'USA', 'Santa Clara', NULL, '-121.955', '37.354'),
(11, 'Fnac', 'France', 'Poitiers', NULL, '0.340', '46.580'),
(12, 'Dassault Systèmes', 'France', 'Vélizy', NULL, '2.212', '48.783'),
(13, 'Orange', 'France', 'Rennes', NULL, '-1.677', '48.117'),
(14, 'Caisse d\'Épargne', 'Pays-Bas', 'Utrecht', NULL, '5.121', '52.090'),
(15, 'Atos', 'France', 'Bezons', NULL, '2.216', '48.926'),
(16, 'King Jouet', 'France', 'Grenoble', NULL, '5.724', '45.188'),
(17, 'Intel', 'USA', 'San Francisco', NULL, '-122.419', '37.774'),
(18, 'Dell', 'France', 'Montpellier', NULL, '3.876', '43.610'),
(19, 'Amadeus', 'France', 'Cannes', NULL, '7.012', '43.551'),
(20, 'La Poste', 'France', 'Boulogne', NULL, '2.239', '48.839'),
(21, 'CERN', 'Suisse', 'Genève', NULL, '6.054', '46.233'),
(22, 'NASA (JPL)', 'USA', 'Pasadena', NULL, '-118.144', '34.148'),
(23, 'MIT Media Lab', 'USA', 'Cambridge', NULL, '-71.093', '42.360'),
(24, 'DeepMind', 'Royaume-Uni', 'Londres', NULL, '-0.127', '51.507'),
(25, 'OpenAI', 'USA', 'San Francisco', NULL, '-122.419', '37.774'),
(26, 'Samsung Electronics', 'Corée du Sud', 'Suwon', NULL, '127.028', '37.263'),
(27, 'Sony', 'Japon', 'Tokyo', NULL, '139.752', '35.689'),
(28, 'Nintendo', 'Japon', 'Kyoto', NULL, '135.755', '34.985'),
(29, 'Spotify', 'Suède', 'Stockholm', NULL, '18.068', '59.329'),
(30, 'ASML', 'Pays-Bas', 'Veldhoven', NULL, '5.404', '51.423'),
(31, 'SAP', 'Allemagne', 'Walldorf', NULL, '8.644', '49.293'),
(32, 'Siemens', 'Allemagne', 'Munich', NULL, '11.576', '48.137'),
(33, 'Booking.com', 'Pays-Bas', 'Amsterdam', NULL, '4.895', '52.370'),
(34, 'Skype', 'Estonie', 'Tallinn', NULL, '24.753', '59.437'),
(35, 'TSMC', 'Taïwan', 'Hsinchu', NULL, '120.967', '24.773'),
(36, 'Foxconn', 'Taïwan', 'New Taipei', NULL, '121.432', '25.012'),
(37, 'Tencent', 'Chine', 'Shenzhen', NULL, '114.057', '22.543'),
(38, 'Alibaba', 'Chine', 'Hangzhou', NULL, '120.155', '30.274'),
(39, 'Baidu', 'Chine', 'Pékin', NULL, '116.391', '39.906'),
(40, 'Toyota', 'Japon', 'Toyota City', NULL, '137.139', '35.082'),
(41, 'Ferrari', 'Italie', 'Maranello', NULL, '10.862', '44.529'),
(42, 'Logitech', 'Suisse', 'Lausanne', NULL, '6.632', '46.519'),
(43, 'IBM Research', 'Suisse', 'Rüschlikon', NULL, '8.564', '47.305'),
(44, 'Oracle', 'USA', 'Austin', NULL, '-97.743', '30.267'),
(45, 'Adobe', 'USA', 'San Jose', NULL, '-121.886', '37.338'),
(46, 'Netflix', 'USA', 'Los Gatos', NULL, '-121.962', '37.242'),
(47, 'Airbnb', 'USA', 'San Francisco', NULL, '-122.401', '37.774'),
(48, 'SpaceX', 'USA', 'Hawthorne', NULL, '-118.327', '33.918'),
(49, 'Meta', 'USA', 'Menlo Park', NULL, '-122.146', '37.484'),
(50, 'Apple', 'USA', 'Cupertino', NULL, '-122.032', '37.331'),
(51, 'Siemens Healthineers', 'Allemagne', 'Erlangen', NULL, '11.004', '49.589'),
(52, 'Roche', 'Suisse', 'Bâle', NULL, '7.588', '47.559'),
(53, 'Novartis', 'Suisse', 'Bâle', NULL, '7.589', '47.559'),
(54, 'Ericsson', 'Suède', 'Kista', NULL, '17.943', '59.404'),
(55, 'Nokia', 'Finlande', 'Espoo', NULL, '24.655', '60.205'),
(56, 'Volvo', 'Suède', 'Göteborg', NULL, '11.974', '57.708'),
(57, 'Red Hat', 'USA', 'Raleigh', NULL, '-78.638', '35.779'),
(77, 'Aegis', 'France', 'Chartres', NULL, '1.488', '48.444'),
(78, '', '', '', NULL, NULL, NULL),
(79, 'TotalEnergies', 'France', 'Courbevoie', NULL, '2.251', '48.897'),
(80, 'L Oréal', 'France', 'Clichy', NULL, '2.301', '48.904'),
(81, 'Sanofi', 'France', 'Paris', NULL, '2.317', '48.877'),
(82, 'BNP Paribas', 'France', 'Paris', NULL, '2.333', '48.871'),
(83, 'Carrefour', 'France', 'Massy', NULL, '2.274', '48.723'),
(84, 'AXA', 'France', 'Paris', NULL, '2.313', '48.871'),
(85, 'Renault', 'France', 'Boulogne-Billancourt', NULL, '2.231', '48.832'),
(86, 'Schneider Electric', 'France', 'Rueil-Malmaison', NULL, '2.181', '48.876'),
(87, 'Danone', 'France', 'Paris', NULL, '2.329', '48.872'),
(88, 'Veolia', 'France', 'Aubervilliers', NULL, '2.368', '48.914'),
(89, 'Michelin', 'France', 'Clermont-Ferrand', NULL, '3.082', '45.777'),
(90, 'Saint-Gobain', 'France', 'Courbevoie', NULL, '2.251', '48.892'),
(91, 'Air Liquide', 'France', 'Paris', NULL, '2.307', '48.862'),
(92, 'Vinci', 'France', 'Nanterre', NULL, '2.213', '48.894'),
(93, 'Bouygues', 'France', 'Paris', NULL, '2.296', '48.871'),
(94, 'Safran', 'France', 'Paris', NULL, '2.275', '48.839'),
(95, 'Hermès', 'France', 'Paris', NULL, '2.323', '48.868'),
(96, 'Kering', 'France', 'Paris', NULL, '2.327', '48.877'),
(97, 'Pernod Ricard', 'France', 'Paris', NULL, '2.324', '48.875'),
(98, 'Dassault Aviation', 'France', 'Saint-Cloud', NULL, '2.218', '48.844'),
(99, 'Legrand', 'France', 'Limoges', NULL, '1.264', '45.835'),
(100, 'Publicis', 'France', 'Paris', NULL, '2.298', '48.874'),
(101, 'Alstom', 'France', 'Saint-Ouen', NULL, '2.333', '48.911'),
(102, 'Edenred', 'France', 'Issy-les-Moulineaux', NULL, '2.268', '48.824'),
(103, 'Teleperformance', 'France', 'Paris', NULL, '2.294', '48.882'),
(104, 'Worldline', 'France', 'Bezons', NULL, '2.216', '48.926'),
(105, 'Eurofins Scientific', 'France', 'Nantes', NULL, '-1.553', '47.218'),
(106, 'Gecina', 'France', 'Paris', NULL, '2.302', '48.873'),
(107, 'Accor', 'France', 'Issy-les-Moulineaux', NULL, '2.264', '48.825'),
(108, 'Bureau Veritas', 'France', 'Neuilly-sur-Seine', NULL, '2.269', '48.885'),
(109, 'Valeo', 'France', 'Paris', NULL, '2.311', '48.876'),
(110, 'Faurecia', 'France', 'Nanterre', NULL, '2.204', '48.896'),
(111, 'Rexel', 'France', 'Paris', NULL, '2.301', '48.889'),
(112, 'Nexans', 'France', 'Courbevoie', NULL, '2.253', '48.898'),
(113, 'Somfy', 'France', 'Cluses', NULL, '6.583', '46.061'),
(114, 'Groupe SEB', 'France', 'Ecully', NULL, '4.781', '45.783'),
(115, 'Bic', 'France', 'Clichy', NULL, '2.306', '48.903'),
(116, 'JCDecaux', 'France', 'Neuilly-sur-Seine', NULL, '2.262', '48.887'),
(117, 'Eiffage', 'France', 'Vélizy-Villacoublay', NULL, '2.221', '48.781'),
(118, 'Arkema', 'France', 'Colombes', NULL, '2.253', '48.923'),
(119, 'Sodexo', 'France', 'Issy-les-Moulineaux', NULL, '2.268', '48.828'),
(120, 'STMicroelectronics', 'France', 'Crolles', NULL, '5.882', '45.281'),
(121, 'Naval Group', 'France', 'Paris', NULL, '2.301', '48.835'),
(122, 'SNCF', 'France', 'Saint-Denis', NULL, '2.357', '48.935'),
(123, 'OVHcloud', 'France', 'Roubaix', NULL, '3.174', '50.692'),
(124, 'BlaBlaCar', 'France', 'Paris', NULL, '2.341', '48.869'),
(125, 'Back Market', 'France', 'Paris', NULL, '2.320', '48.859'),
(126, 'ManoMano', 'France', 'Paris', NULL, '2.331', '48.881'),
(127, 'Doctolib', 'France', 'Levallois-Perret', NULL, '2.288', '48.893'),
(128, 'Deezer', 'France', 'Paris', NULL, '2.329', '48.876'),
(131, 'Orange Cybersécurité', 'France', 'Tours', NULL, NULL, NULL),
(132, 'Gentles Mates', 'France', 'Caen', NULL, NULL, NULL),
(133, 'Youtube', 'USA', 'Los Angeles', NULL, NULL, NULL),
(135, 'Univeristé de Troyes', 'France', 'Troyes', '10000', '4.085', '48.293'),
(151, 'ASSE', 'Taïwan', 'Ouches', '42155', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `OFFRES`
--

CREATE TABLE `OFFRES` (
  `id_offre` int NOT NULL,
  `titre` varchar(100) NOT NULL,
  `entreprise` varchar(100) NOT NULL,
  `ville` varchar(100) DEFAULT 'Non précisé',
  `type` varchar(50) NOT NULL,
  `description` text,
  `contact_email` varchar(100) DEFAULT NULL,
  `date_ajout` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_auteur` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `OFFRES`
--

INSERT INTO `OFFRES` (`id_offre`, `titre`, `entreprise`, `ville`, `type`, `description`, `contact_email`, `date_ajout`, `id_auteur`) VALUES
(23, 'Data Analyst', 'Thalès', 'Paris', 'CDD', 'Gestion des données de l\'entreprise.', 'contact@thales.fr', '2026-03-23 20:40:29', 7);

-- --------------------------------------------------------

--
-- Structure de la table `PROMO`
--

CREATE TABLE `PROMO` (
  `id_promo` int NOT NULL,
  `promo` int DEFAULT NULL,
  `filiere` varchar(255) NOT NULL,
  `formation` enum('FISE','FISA','MTS') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `PROMO`
--

INSERT INTO `PROMO` (`id_promo`, `promo`, `filiere`, `formation`) VALUES
(85, 1985, 'Systèmes Embarqués', 'FISE'),
(86, 1988, 'Informatique', 'FISE'),
(56, 1990, 'Matériaux Chimie', 'FISE'),
(57, 1991, 'Informatique', 'FISE'),
(58, 1992, 'Matériaux Chimie', 'FISE'),
(59, 1993, 'Systèmes Embarqués', 'FISE'),
(60, 1994, 'Matériaux Chimie', 'FISE'),
(46, 1995, 'Informatique', 'FISE'),
(61, 1996, 'Systèmes Embarqués', 'FISE'),
(62, 1997, 'Informatique', 'FISE'),
(47, 1998, 'Informatique', 'FISE'),
(63, 1999, 'Informatique', 'FISE'),
(64, 2000, 'Informatique', 'FISE'),
(88, 2000, 'Systèmes Embarqués', 'FISE'),
(65, 2001, 'Systèmes Embarqués', 'FISE'),
(48, 2002, 'Matériaux Chimie', 'FISE'),
(66, 2003, 'Matériaux Chimie', 'FISA'),
(67, 2004, 'Informatique', 'FISE'),
(49, 2005, 'Systèmes Embarqués', 'FISA'),
(68, 2006, 'Informatique', 'FISE'),
(69, 2007, 'Informatique', 'MTS'),
(70, 2008, 'Systèmes Embarqués', 'FISE'),
(71, 2009, 'Matériaux Chimie', 'FISE'),
(33, 2010, 'Informatique', 'FISE'),
(72, 2011, 'Informatique', 'FISE'),
(102, 2012, 'Informatique', 'FISE'),
(29, 2012, 'Matériaux Chimie', 'MTS'),
(105, 2012, 'Systèmes Embarqués', 'FISE'),
(73, 2012, 'Systèmes Embarqués', 'FISA'),
(74, 2013, 'Systèmes Embarqués', 'FISE'),
(75, 2014, 'Systèmes Embarqués', 'FISE'),
(51, 2015, 'Informatique', 'FISE'),
(89, 2015, 'Matériaux Chimie', 'FISA'),
(76, 2016, 'Informatique', 'FISE'),
(77, 2017, 'Systèmes Embarqués', 'FISA'),
(52, 2018, 'Matériaux Chimie', 'FISA'),
(78, 2019, 'Matériaux Chimie', 'MTS'),
(25, 2020, 'Informatique', 'FISE'),
(106, 2020, 'Systèmes Embarqués', 'FISE'),
(16, 2021, 'Informatique', 'FISE'),
(107, 2021, 'Systèmes Embarqués', 'FISE'),
(10, 2022, 'Informatique', 'FISE'),
(15, 2023, 'Informatique', 'FISE'),
(5, 2023, 'Matériaux Chimie', 'FISE'),
(81, 2023, 'Systèmes Embarqués', 'FISA'),
(1, 2024, 'Informatique', 'FISE'),
(82, 2024, 'Informatique', 'MTS'),
(103, 2024, 'Matériaux Chimie', 'FISE'),
(20, 2024, 'Matériaux Chimie', 'FISA'),
(8, 2024, 'Systèmes Embarqués', 'FISA'),
(4, 2025, 'Informatique', 'FISE'),
(91, 2025, 'Informatique', 'MTS'),
(108, 2025, 'Systèmes Embarqués', 'FISE'),
(2, 2025, 'Systèmes Embarqués', 'FISA'),
(28, 2026, 'Informatique', 'FISE'),
(3, 2026, 'Informatique', 'MTS'),
(26, 2026, 'Matériaux Chimie', 'FISE'),
(92, 2026, 'Systèmes Embarqués', 'FISE'),
(19, 2026, 'Systèmes Embarqués', 'MTS'),
(42, 2027, 'Informatique', 'FISE'),
(55, 2027, 'Informatique', 'MTS'),
(84, 2028, 'Informatique', 'FISE'),
(94, 2028, 'Informatique', 'FISA');

-- --------------------------------------------------------

--
-- Structure de la table `STAGE`
--

CREATE TABLE `STAGE` (
  `id_stage` int NOT NULL,
  `intitule` varchar(255) NOT NULL,
  `annee` enum('1A','2A','3A') DEFAULT NULL,
  `description` text,
  `entrepriseUniversite` enum('E','U','I') DEFAULT 'I',
  `id_lieu` int DEFAULT NULL,
  `id_user` int DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `STAGE`
--

INSERT INTO `STAGE` (`id_stage`, `intitule`, `annee`, `description`, `entrepriseUniversite`, `id_lieu`, `id_user`, `date_debut`, `date_fin`) VALUES
(7, 'Aide Développeur', '1A', 'Soutien à l\'équipe technique pour la rédaction de la documentation utilisateur d\'une API interne. J\'ai également réalisé une série de tests fonctionnels pour vérifier la non-régression après une mise à jour majeure du framework.', 'E', 1, 7, '2023-01-01', '2023-06-30'),
(14, 'Big Data Analytics', '2A', 'Migration de bases de données de recherche vers un environnement distribué. Utilisation d\'Apache Spark pour traiter des flux de données scientifiques en temps réel et stockage optimisé pour le calcul intensif.', 'U', 7, 7, '2024-02-15', '2024-08-15'),
(29, 'PFE Spark', '3A', 'Mise en place d\'un cluster de calcul distribué chez Amazon. Traitement de flux massifs pour détecter des comportements anormaux évocateurs d\'une exfiltration de données.', 'E', 7, 7, '2025-09-01', '2026-09-01'),
(38, 'IA and cybersecurity', '2A', 'Intégration de modules d\'intelligence artificielle pour la détection proactive d\'intrusions sur les terminaux mobiles. Développement de classifieurs légers pour identifier les comportements malveillants en temps réel sans impacter l\'autonomie de la batterie.', 'E', 26, 31, NULL, NULL),
(220, 'Stage Dev Web', '2A', 'Développement frontend.', 'E', 3, 201, NULL, NULL),
(221, 'PFE Ingénieur IA', '3A', 'Mise en place de modèles de Machine Learning.', 'E', 6, 201, NULL, NULL),
(222, 'Stage VHDL', '2A', 'Programmation de cartes FPGA.', 'E', 2, 202, NULL, NULL),
(223, 'PFE Ingénieur Embarqué', '3A', 'Développement de firmware bas niveau.', 'E', 120, 202, NULL, NULL),
(224, 'Stage Labo', '1A', 'Tests de résistance des matériaux.', 'E', 89, 203, NULL, NULL),
(225, 'Stage R&D', '2A', 'Étude sur de nouveaux alliages.', 'E', 90, 203, NULL, NULL),
(226, 'PFE Ingénieur Matériaux', '3A', 'Développement de verres innovants.', 'E', 90, 203, NULL, NULL),
(233, 'Stage Formulation', '2A', 'Tests de nouvelles formulations cosmétiques.', 'E', 80, 206, NULL, NULL),
(234, 'PFE Qualité', '3A', 'Contrôle qualité en ligne de production pharmaceutique.', 'E', 81, 206, NULL, NULL),
(235, 'Stage Cloud', '2A', 'Déploiement d\'infrastructure AWS.', 'E', 7, 207, NULL, NULL),
(236, 'PFE AI Researcher', '3A', 'Optimisation de LLM.', 'E', 25, 207, NULL, NULL),
(237, 'Stage Automatisme', '1A', 'Programmation d\'automates Siemens.', 'E', 32, 208, NULL, NULL),
(238, 'Stage Microprocesseurs', '2A', 'Tests d\'architecture processeur.', 'E', 17, 208, NULL, NULL),
(239, 'PFE Ingénieur Lidar', '3A', 'Intégration de capteurs optiques.', 'E', 30, 208, NULL, NULL),
(240, 'Stage Chimie', '2A', 'Analyse de fluides.', 'E', 79, 209, NULL, NULL),
(241, 'PFE Ingénieur Procédés', '3A', 'Optimisation des procédés de séparation de gaz.', 'E', 91, 209, NULL, NULL),
(242, 'Stage SysAdmin', '2A', 'Maintenance de serveurs Linux.', 'E', 123, 210, NULL, NULL),
(243, 'PFE Data Engineer', '3A', 'Création d\'un pipeline de données.', 'E', 124, 210, NULL, NULL),
(246, 'LLM RAG', '2A', 'Recherche sur l\'implémentation de systèmes RAG (Retrieval-Augmented Generation) pour l\'analyse automatisée de protocoles cliniques. Travail sur l\'indexation de bases de données vectorielles et l\'optimisation de la pertinence des contextes extraits.', 'U', 52, 39, NULL, NULL),
(250, 'Technicien de test', '1A', 'Tests sur banc de validation.', 'E', 85, 205, NULL, NULL),
(251, 'Stage Électronique', '2A', 'Conception de cartes PCB.', 'E', 109, 205, NULL, NULL),
(252, 'PFE Contrôle Commande', '3A', 'Systèmes d\'aide à la conduite.', 'E', 109, 205, NULL, NULL),
(253, 'Développeur Junior', '1A', 'Scripts d\'automatisation.', 'E', 15, 204, NULL, NULL),
(254, 'Stage Gameplay Programmer', '2A', 'Développement de mécaniques de jeu.', 'E', 5, 204, NULL, NULL),
(255, 'PFE Backend Developer', '3A', 'Architecture de l\'API.', 'E', 127, 204, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `TRAVAIL`
--

CREATE TABLE `TRAVAIL` (
  `id_travail` int NOT NULL,
  `poste` varchar(255) NOT NULL,
  `description` text,
  `id_lieu` int DEFAULT NULL,
  `id_user` int DEFAULT NULL,
  `date_debut` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `TRAVAIL`
--

INSERT INTO `TRAVAIL` (`id_travail`, `poste`, `description`, `id_lieu`, `id_user`, `date_debut`) VALUES
(7, 'Data Engineer', 'Architecture et maintenance de l\'entrepôt de données (Data Warehouse). Je conçois des pipelines ETL robustes qui traitent quotidiennement plusieurs pétaoctets de données transactionnelles pour fournir des rapports précis aux analystes financiers.', 7, 7, '2025-09-01'),
(30, 'Ingénieur de Recherche', 'Conception et maintenance des systèmes d\'acquisition de données pour les détecteurs de particules du LHC. Analyse des flux de données massifs en temps réel.', 22, 28, NULL),
(33, 'Project Manager AI', 'Direction technique des équipes de recherche sur les modèles de langage. Coordination entre les chercheurs et les ingénieurs produit pour l\'intégration des API.', 25, 31, NULL),
(40, 'Embedded Systems Engineer', 'Développement de micrologiciels pour les contrôleurs de robots industriels de haute précision. Optimisation de la latence et de la consommation énergétique.', 151, 20, '2026-03-24'),
(42, 'Machine Learning Engineer', 'Entraînement et déploiement de modèles de vision par ordinateur pour la reconnaissance automatique d\'images à grande échelle sur les infrastructures cloud.', 39, 39, NULL),
(45, 'Database Administrator', 'Gestion et optimisation des bases de données critiques supportant des millions de transactions quotidiennes. Mise en place de stratégies de réplication et de sauvegarde.', 44, 42, NULL),
(132, 'Software Engineer', 'Développement de nouvelles fonctionnalités sur la plateforme.', 1, 201, '2020-09-01'),
(133, 'Embedded Systems Engineer', 'Développement de logiciels temps réel pour l\'aéronautique.', 8, 202, '2020-10-01'),
(134, 'Ingénieur Matériaux', 'Recherche sur de nouveaux polymères éco-responsables.', 118, 203, '2023-09-01'),
(135, 'Lead Backend Engineer', 'Gestion de la base de données et de l\'API.', 127, 204, '2021-09-01'),
(136, 'Autopilot Firmware Engineer', 'Développement des systèmes de conduite autonome.', 4, 205, '2012-09-01'),
(137, 'Ingénieur R&D Formulation', 'Direction d\'équipe sur les nouvelles gammes cosmétiques.', 80, 206, '2015-09-01'),
(138, 'Machine Learning Engineer', 'Déploiement de modèles de deep learning en production.', 24, 207, '2010-09-01'),
(139, 'Hardware Architect', 'Conception d\'architectures matérielles pour cartes graphiques.', 10, 208, '2008-09-01'),
(140, 'Ingénieur Procédés', 'Optimisation énergétique des raffineries.', 79, 209, '2019-10-01'),
(141, 'Lead Data Engineer', 'Supervision des flux de données et de l\'équipe data.', 124, 210, '2016-09-01');

-- --------------------------------------------------------

--
-- Structure de la table `UTILISATEUR`
--

CREATE TABLE `UTILISATEUR` (
  `id_user` int NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `role` varchar(50) NOT NULL DEFAULT 'student'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `UTILISATEUR`
--

INSERT INTO `UTILISATEUR` (`id_user`, `nom`, `prenom`, `email`, `password`, `role`) VALUES
(2, 'Martin', 'Alice', 'alice.martin@ecole.ensicaen.fr', '$2y$10$CyVpMAaqqoV/kxf4s0Qxv.eoMYp9fbyat2mqlqEF3GFh6hB26vjPm', 'admin'),
(3, 'Lefebvre', 'Thomas', 'thomas.lefebvre@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'student'),
(4, 'Moreau', 'Sonia', 'sonia.moreau@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'student'),
(6, 'Laurent', 'Julie', 'julie.laurent@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'student'),
(7, 'Michel', 'Benoit', 'benoit.michel@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(8, 'Garcia', 'Maria', 'maria.garcia@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'student'),
(11, 'David', 'Emma', 'emma.david@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'student'),
(12, 'Bertrand', 'Fugo', 'hugo.bertrand@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'student'),
(13, 'Rousseau', 'Chloé', 'chloe.rousseau@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'student'),
(14, 'Blanc', 'Mathieu', 'mathieu.blanc@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'student'),
(15, 'Guerin', 'Léa', 'lea.guerin@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'student'),
(20, 'Moczygeba', 'Joris', 'joris.mocz@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(28, 'Cheramy', 'Benjamin', 'benjamin.cheramy@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(31, 'Molle', 'Robin', 'robin.molle@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(39, 'Benoit', 'Antoine', 'antoine.benoit@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(42, 'Dufour', 'Clara', 'clara.dufour@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(201, 'Dubois', 'Jean', 'jean.dubois@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(202, 'Leroy', 'Sophie', 'sophie.leroy@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(203, 'Roux', 'Lucas', 'lucas.roux@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(204, 'Bernard', 'Emma', 'emma.bernard@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(205, 'Fournier', 'Hugo', 'hugo.fournier@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(206, 'Girard', 'Inès', 'ines.girard@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(207, 'Bonnet', 'Paul', 'paul.bonnet@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(208, 'Dupont', 'Chloé', 'chloe.dupont@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(209, 'Fontaine', 'Marc', 'marc.fontaine@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni'),
(210, 'Lambert', 'Julie', 'julie.lambert@ecole.ensicaen.fr', '$2y$10$utV0/S6Ei/EvlwUu6uOIB.IR3QWIe.ghoKuozzr/BXhnFN3tmgLgO', 'alumni');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `ACTUALITES`
--
ALTER TABLE `ACTUALITES`
  ADD PRIMARY KEY (`id_actu`),
  ADD KEY `fk_actu_auteur` (`id_auteur`);

--
-- Index pour la table `ALUMNI`
--
ALTER TABLE `ALUMNI`
  ADD PRIMARY KEY (`id_user`);

--
-- Index pour la table `DEMANDE_AJOUT`
--
ALTER TABLE `DEMANDE_AJOUT`
  ADD PRIMARY KEY (`id_demande`);

--
-- Index pour la table `EDUCATION`
--
ALTER TABLE `EDUCATION`
  ADD PRIMARY KEY (`id_education`),
  ADD KEY `id_promo` (`id_promo`),
  ADD KEY `EDUCATION_ibfk_1` (`id_user`);

--
-- Index pour la table `EVENEMENTS`
--
ALTER TABLE `EVENEMENTS`
  ADD PRIMARY KEY (`id_event`),
  ADD KEY `fk_event_auteur` (`id_auteur`);

--
-- Index pour la table `HISTORIQUE`
--
ALTER TABLE `HISTORIQUE`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `fk_historique_alumni` (`id_alumni`),
  ADD KEY `fk_historique_editeur` (`id_editeur`);

--
-- Index pour la table `KEY_FIGURES`
--
ALTER TABLE `KEY_FIGURES`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `LIEU`
--
ALTER TABLE `LIEU`
  ADD PRIMARY KEY (`id_lieu`),
  ADD UNIQUE KEY `unique_lieu_idx` (`entreprise`,`ville`,`pays`);

--
-- Index pour la table `OFFRES`
--
ALTER TABLE `OFFRES`
  ADD PRIMARY KEY (`id_offre`),
  ADD KEY `fk_auteur_offre` (`id_auteur`);

--
-- Index pour la table `PROMO`
--
ALTER TABLE `PROMO`
  ADD PRIMARY KEY (`id_promo`),
  ADD UNIQUE KEY `unique_promo_idx` (`promo`,`filiere`,`formation`);

--
-- Index pour la table `STAGE`
--
ALTER TABLE `STAGE`
  ADD PRIMARY KEY (`id_stage`),
  ADD KEY `id_lieu` (`id_lieu`),
  ADD KEY `STAGE_ibfk_1` (`id_user`);

--
-- Index pour la table `TRAVAIL`
--
ALTER TABLE `TRAVAIL`
  ADD PRIMARY KEY (`id_travail`),
  ADD KEY `id_lieu` (`id_lieu`),
  ADD KEY `TRAVAIL_ibfk_1` (`id_user`);

--
-- Index pour la table `UTILISATEUR`
--
ALTER TABLE `UTILISATEUR`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `ACTUALITES`
--
ALTER TABLE `ACTUALITES`
  MODIFY `id_actu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT pour la table `ALUMNI`
--
ALTER TABLE `ALUMNI`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=211;

--
-- AUTO_INCREMENT pour la table `DEMANDE_AJOUT`
--
ALTER TABLE `DEMANDE_AJOUT`
  MODIFY `id_demande` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `EDUCATION`
--
ALTER TABLE `EDUCATION`
  MODIFY `id_education` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=203;

--
-- AUTO_INCREMENT pour la table `EVENEMENTS`
--
ALTER TABLE `EVENEMENTS`
  MODIFY `id_event` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `HISTORIQUE`
--
ALTER TABLE `HISTORIQUE`
  MODIFY `id_log` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=267;

--
-- AUTO_INCREMENT pour la table `KEY_FIGURES`
--
ALTER TABLE `KEY_FIGURES`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `LIEU`
--
ALTER TABLE `LIEU`
  MODIFY `id_lieu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT pour la table `OFFRES`
--
ALTER TABLE `OFFRES`
  MODIFY `id_offre` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT pour la table `PROMO`
--
ALTER TABLE `PROMO`
  MODIFY `id_promo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT pour la table `STAGE`
--
ALTER TABLE `STAGE`
  MODIFY `id_stage` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=256;

--
-- AUTO_INCREMENT pour la table `TRAVAIL`
--
ALTER TABLE `TRAVAIL`
  MODIFY `id_travail` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=142;

--
-- AUTO_INCREMENT pour la table `UTILISATEUR`
--
ALTER TABLE `UTILISATEUR`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=211;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `ACTUALITES`
--
ALTER TABLE `ACTUALITES`
  ADD CONSTRAINT `fk_actu_auteur` FOREIGN KEY (`id_auteur`) REFERENCES `UTILISATEUR` (`id_user`) ON DELETE SET NULL;

--
-- Contraintes pour la table `ALUMNI`
--
ALTER TABLE `ALUMNI`
  ADD CONSTRAINT `fk_alumni_utilisateur` FOREIGN KEY (`id_user`) REFERENCES `UTILISATEUR` (`id_user`) ON DELETE CASCADE;

--
-- Contraintes pour la table `EDUCATION`
--
ALTER TABLE `EDUCATION`
  ADD CONSTRAINT `EDUCATION_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `ALUMNI` (`id_user`) ON DELETE CASCADE,
  ADD CONSTRAINT `EDUCATION_ibfk_2` FOREIGN KEY (`id_promo`) REFERENCES `PROMO` (`id_promo`);

--
-- Contraintes pour la table `EVENEMENTS`
--
ALTER TABLE `EVENEMENTS`
  ADD CONSTRAINT `fk_event_auteur` FOREIGN KEY (`id_auteur`) REFERENCES `UTILISATEUR` (`id_user`) ON DELETE SET NULL;

--
-- Contraintes pour la table `HISTORIQUE`
--
ALTER TABLE `HISTORIQUE`
  ADD CONSTRAINT `fk_historique_alumni` FOREIGN KEY (`id_alumni`) REFERENCES `ALUMNI` (`id_user`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_historique_editeur` FOREIGN KEY (`id_editeur`) REFERENCES `UTILISATEUR` (`id_user`) ON DELETE SET NULL;

--
-- Contraintes pour la table `OFFRES`
--
ALTER TABLE `OFFRES`
  ADD CONSTRAINT `fk_auteur_offre` FOREIGN KEY (`id_auteur`) REFERENCES `UTILISATEUR` (`id_user`) ON DELETE CASCADE;

--
-- Contraintes pour la table `STAGE`
--
ALTER TABLE `STAGE`
  ADD CONSTRAINT `STAGE_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `ALUMNI` (`id_user`) ON DELETE CASCADE,
  ADD CONSTRAINT `STAGE_ibfk_3` FOREIGN KEY (`id_lieu`) REFERENCES `LIEU` (`id_lieu`);

--
-- Contraintes pour la table `TRAVAIL`
--
ALTER TABLE `TRAVAIL`
  ADD CONSTRAINT `TRAVAIL_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `ALUMNI` (`id_user`) ON DELETE CASCADE,
  ADD CONSTRAINT `TRAVAIL_ibfk_3` FOREIGN KEY (`id_lieu`) REFERENCES `LIEU` (`id_lieu`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
