-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mer. 22 oct. 2025 à 05:00
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `todo_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `accounts_table`
--

CREATE TABLE `accounts_table` (
  `account_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `accounts_table`
--

INSERT INTO `accounts_table` (`account_id`, `email`, `password`) VALUES
(1, 'baba@gmail.com', '123456'),
(2, 'jo', '$2y$10$3Gw4VsB.onYifeOLGQfpc.ErdsR8/3QsVCXAegxzbKFar2fz/iHSm'),
(3, 'jo@gmail.com', '$2y$10$mPQL119Lc9Rad3.EhFNZl.SDRSFGT6eK5s2kczlLFKjQir2O7GhmC'),
(4, 'ja', '$2y$10$B.YVPVh6juznJfSbSs7E7eXpoBesIu4LZa7eFOsQiHiboz7Q2ih4C'),
(5, 'jiji', '$2y$10$urcwls/rf4SmlUP1jJNfpeFgh5r/Yxbis7YITFKJLktEOylkKLxTm'),
(7, 'la@gmail.com', '$2y$10$xrSKHmKPnuJJlkVKZFYXyuindNIDYwHxRkvNXiuqXYO.rsOiJJPgK'),
(8, 'kh', '$2y$10$SInkX6plSnszXKD5R1dVSuvT.pBSwdadZ9fKj2IE0O6ba1JidYWS6'),
(9, 'th', '$2y$10$WfaCH/UF/OklsBZZPWXFFuY9sf9P80F7Fog8YApocHC1uclmbSRsS');

-- --------------------------------------------------------

--
-- Structure de la table `todo_tables`
--

CREATE TABLE `todo_tables` (
  `todo_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `todo` text NOT NULL,
  `done` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `todo_tables`
--

INSERT INTO `todo_tables` (`todo_id`, `account_id`, `date`, `todo`, `done`) VALUES
(1, 2, '2025-10-14', 'JZJZ', 0),
(2, 2, '2025-06-02', 'BONJOUR', 0),
(3, 4, '2025-07-16', 'tam', 0),
(4, 4, '2025-07-07', 'TALLAL', 0),
(5, 2, '2025-07-06', 'ajakkzn', 0),
(6, 8, '2025-07-25', 'un projet pressing à terminer', 0),
(71, 1, '2025-07-01', 'Faire les courses', 1),
(72, 1, '2025-07-05', 'Appeler maman', 1),
(73, 1, '2025-07-10', 'Réviser Flutter', 0),
(74, 1, '2025-07-15', 'Nettoyer la chambre', 0),
(75, 1, '2025-07-20', 'Rendez-vous dentiste', 1),
(76, 1, '2025-07-25', 'Envoyer le rapport', 0),
(77, 1, '2025-08-01', 'Acheter cadeau anniversaire', 0),
(78, 1, '2025-08-10', 'Faire du sport', 1),
(79, 2, '2025-07-02', 'Répondre aux emails', 1),
(80, 2, '2025-07-08', 'Préparer la réunion', 1),
(81, 2, '2025-07-12', 'Lire un livre', 0),
(82, 2, '2025-07-18', 'Faire les impôts', 0),
(83, 2, '2025-07-22', 'Appeler le plombier', 1),
(84, 2, '2025-07-28', 'Mettre à jour CV', 0),
(85, 2, '2025-08-05', 'Planifier vacances', 0),
(86, 2, '2025-08-12', 'Faire les courses bio', 1),
(87, 3, '2025-07-03', 'Aller à la banque', 1),
(88, 3, '2025-07-07', 'Ranger le garage', 0),
(89, 3, '2025-07-14', 'Étudier Python', 0),
(90, 3, '2025-07-19', 'Appeler le vétérinaire', 1),
(91, 3, '2025-07-24', 'Faire les comptes', 1),
(92, 3, '2025-07-30', 'Acheter des chaussures', 0),
(93, 3, '2025-08-03', 'Préparer présentation', 0),
(94, 3, '2025-08-15', 'Faire du yoga', 1),
(95, 4, '2025-07-04', 'Envoyer colis', 1),
(96, 4, '2025-07-09', 'Nettoyer cuisine', 1),
(97, 4, '2025-07-13', 'Réviser pour examen', 0),
(98, 4, '2025-07-17', 'Aller chez le coiffeur', 0),
(99, 4, '2025-07-23', 'Faire les courses hebdo', 1),
(100, 4, '2025-07-29', 'Écrire article blog', 0),
(101, 4, '2025-08-02', 'Organiser anniversaire', 0),
(102, 4, '2025-08-14', 'Faire les vitres', 1),
(103, 5, '2025-07-06', 'Appeler assurance', 1),
(104, 5, '2025-07-11', 'Faire lessive', 1),
(105, 5, '2025-07-16', 'Apprendre Riverpod', 0),
(106, 5, '2025-07-21', 'Prendre RDV médecin', 0),
(107, 5, '2025-07-26', 'Mettre à jour site web', 1),
(108, 5, '2025-07-31', 'Faire les courses', 0),
(109, 5, '2025-08-04', 'Planifier menu semaine', 0),
(110, 5, '2025-08-11', 'Faire les courses', 1),
(111, 1, '2025-07-01', 'Rédiger rapport', 1),
(112, 1, '2025-07-08', 'Nettoyer salle de bain', 1),
(113, 3, '2025-07-15', 'Étudier API REST', 0),
(114, 2, '2025-07-20', 'Appeler client', 0),
(115, 5, '2025-07-27', 'Faire les courses', 1),
(116, 1, '2025-08-01', 'Mettre à jour profil LinkedIn', 0),
(117, 3, '2025-08-07', 'Préparer déménagement', 0),
(118, 1, '2025-08-13', 'Faire les courses', 1),
(119, 7, '2025-07-03', 'Envoyer facture', 1),
(120, 7, '2025-07-10', 'Ranger bureau', 1),
(121, 7, '2025-07-14', 'Lire documentation Flutter', 0),
(122, 7, '2025-07-19', 'Prendre RDV ophtalmo', 0),
(123, 7, '2025-07-25', 'Faire les courses', 1),
(124, 7, '2025-07-30', 'Écrire email important', 0),
(125, 7, '2025-08-06', 'Organiser réunion', 0),
(126, 7, '2025-08-16', 'Faire les courses', 1),
(127, 8, '2025-07-05', 'Appeler fournisseur', 1),
(128, 8, '2025-07-12', 'Nettoyer voiture', 1),
(129, 8, '2025-07-17', 'Étudier Dart', 0),
(130, 8, '2025-07-22', 'Faire les courses', 0),
(131, 8, '2025-07-28', 'Mettre à jour base de données', 1),
(132, 8, '2025-08-02', 'Planifier voyage', 0),
(133, 8, '2025-08-09', 'Faire les courses', 0),
(134, 8, '2025-08-15', 'Faire les courses', 1);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `accounts_table`
--
ALTER TABLE `accounts_table`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `todo_tables`
--
ALTER TABLE `todo_tables`
  ADD PRIMARY KEY (`todo_id`),
  ADD KEY `account_id` (`account_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `accounts_table`
--
ALTER TABLE `accounts_table`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `todo_tables`
--
ALTER TABLE `todo_tables`
  MODIFY `todo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `todo_tables`
--
ALTER TABLE `todo_tables`
  ADD CONSTRAINT `todo_tables_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts_table` (`account_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
