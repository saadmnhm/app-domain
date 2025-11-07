-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : ven. 07 nov. 2025 à 17:40
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `blink_domain`
--

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

CREATE TABLE `client` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `categories_id` bigint(20) UNSIGNED NOT NULL,
  `domain_id` bigint(20) UNSIGNED NOT NULL,
  `raison_sociale` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `ice` varchar(255) DEFAULT NULL,
  `if` varchar(255) DEFAULT NULL,
  `patente` varchar(255) DEFAULT NULL,
  `cnss` varchar(255) DEFAULT NULL,
  `contact_principal` bigint(20) UNSIGNED DEFAULT NULL,
  `date_integration` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `client`
--

INSERT INTO `client` (`id`, `categories_id`, `domain_id`, `raison_sociale`, `email`, `phone`, `website`, `user_id`, `ice`, `if`, `patente`, `cnss`, `contact_principal`, `date_integration`, `created_at`, `updated_at`, `deleted_at`) VALUES
(20, 9, 1, 'saad', 'sssssssss@gmail.com', 'sssssss', 'http://sssssssssssssssss', 1, 'sssssss', 'ssssssssssss', 'ssssssss', 'ssssssss', NULL, '2025-06-04', '2025-06-03 08:48:21', '2025-06-18 15:23:34', NULL),
(21, 13, 7, 'sssssssss', 'arrrrr@fm.z', '06666666666', 'https://blinkagency.ma/', 1, 'sssssssss', 'ssssssss', '06333333333', 'zzzzzzzzzzaa', 15, '2025-06-18', '2025-06-03 09:15:59', '2025-11-07 13:22:40', NULL),
(22, 9, 0, 'raison social', 'email@saad.com', '06000000', 'http://localhost:5173/apps/client/list', 1, 'ice-test', 'if-test', 'patente-test', 'cnss-test', 7, '2025-06-03', '2025-06-03 09:52:16', '2025-06-03 09:52:17', NULL),
(24, 9, 0, 'saad', 'sssssssses@gmail.com', 'sssssss', 'http://sssssssssssssssss', 1, NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-17 10:17:27', '2025-06-17 10:21:33', NULL),
(25, 9, 1, 'zzzzzzzzzz', 'saadmnm@mddifvif.com', '0222222222', NULL, 1, '6', '03333333', 'sssssssssfg', 'zzzzzzzzzaa', 17, '2025-11-25', '2025-11-07 08:39:27', '2025-11-07 08:39:37', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `clientcategories`
--

CREATE TABLE `clientcategories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `label` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `clientcategories`
--

INSERT INTO `clientcategories` (`id`, `label`, `description`, `icon`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(6, 'category2', 'zzzzzzrrrrrrrrra', '/assets/icons/6_1748871118.png', 1, '2025-06-02 09:10:25', '2025-06-03 11:47:07', NULL),
(7, 'cat 3', 'wwwwwwwww', '/assets/icons/7_1748871531.png', 1, '2025-06-02 12:08:35', '2025-06-03 11:47:04', '2025-06-03 11:47:04'),
(8, 'sssssssssfg', NULL, '/assets/icons/8_1748871470.jpg', 1, '2025-06-02 12:37:40', '2025-06-03 11:47:00', '2025-06-03 11:47:00'),
(9, 'category 1', 'test', NULL, 1, '2025-06-03 09:51:07', '2025-06-17 13:52:51', NULL),
(10, 'category 2', 'category 2 category 2', '/assets/icons/10_1748954874.png', 0, '2025-06-03 11:47:49', '2025-06-03 12:00:01', '2025-06-03 12:00:01'),
(11, 'category 3', 'qqqqqqqqq', NULL, 1, '2025-06-17 10:12:25', '2025-06-17 10:12:34', '2025-06-17 10:12:34'),
(12, 'category 4', 'aaaaaaa', NULL, 1, '2025-07-11 12:03:05', '2025-11-07 14:51:02', '2025-11-07 14:51:02'),
(13, 'author', 'z', '/assets/icons/1762525152_690dffe09ffb8.png', 1, '2025-11-07 13:19:12', '2025-11-07 13:19:12', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `client_contact`
--

CREATE TABLE `client_contact` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `fonction` varchar(255) DEFAULT NULL,
  `is_responsable` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `client_contact`
--

INSERT INTO `client_contact` (`id`, `client_id`, `first_name`, `last_name`, `email`, `phone`, `user_id`, `fonction`, `is_responsable`, `created_at`, `updated_at`, `deleted_at`) VALUES
(5, 20, 'saad', 'mnhm', 'saad@mn.dmm', '0666666666', 1, 'pssssss', 0, '2025-06-03 08:49:00', '2025-06-03 08:49:00', NULL),
(6, 21, 'saaed', 'saad', 'saad@gmail.com', 'zzzzzzzzzrr', 1, 'manager', 0, '2025-06-03 09:15:59', '2025-06-03 12:09:45', '2025-06-03 12:09:45'),
(7, 22, 'saad', 'mnaybezz', 'test-contact@saad.com', '063333333', 1, 'function', 0, '2025-06-03 09:52:17', '2025-06-03 10:18:06', NULL),
(8, 22, 'saad', 'second', 'saad@second.ma', '01111111111z', 1, 'function', 0, '2025-06-03 09:53:07', '2025-06-03 10:16:09', NULL),
(9, 22, 'zzzzzzzzzzz', 'aaaaaaaaaaa', 'aaa@gmail.com', '03333333', 1, 'author', 0, '2025-06-03 10:08:48', '2025-06-03 10:09:34', NULL),
(11, 21, 'saad', 'saad', 'saadé@gmail.com', '06633333', 1, 'function', 1, '2025-06-03 10:30:50', '2025-06-03 12:07:01', '2025-06-03 12:07:01'),
(15, 21, 'saad', 'saad', 'saadg@gmail.com', '0666666666', 1, 'manager', 1, '2025-06-03 12:10:04', '2025-06-03 12:10:12', NULL),
(16, 24, 'sssssssssssss', 'ssssssssssssssss', 'ssssss@dm.m', '06666666666', 1, 'dddddd', 1, '2025-06-17 10:20:18', '2025-06-17 10:21:33', '2025-06-17 10:21:33'),
(17, 25, 'zzzzzzzzz', 'zzzzzzzzzzz', 'saadmnm@mddife.com', 'zzzzzz', 1, 'respo', 1, '2025-11-07 08:39:37', '2025-11-07 08:39:37', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `domaine_dactivites`
--

CREATE TABLE `domaine_dactivites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `label` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `domaine_dactivites`
--

INSERT INTO `domaine_dactivites` (`id`, `label`, `description`, `icon`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'domain 1', 'zzzzzaa', NULL, '2025-06-02 10:07:46', '2025-06-17 10:24:55', NULL),
(2, 'aaaaaaaaa', 'ffffffffffffff', NULL, '2025-06-02 11:58:25', '2025-06-02 12:04:44', '2025-06-02 12:04:44'),
(3, 'zzzzzzzz', 'zzzzzzzzzzzzzz', NULL, '2025-06-02 12:02:59', '2025-06-02 12:04:41', '2025-06-02 12:04:41'),
(4, 'dddddd', 'ffffffffff', NULL, '2025-06-02 12:04:55', '2025-06-02 12:08:53', '2025-06-02 12:08:53'),
(5, 'domain 2', 'ddddvvvvvvvvv', '/assets/icons/1748869728_683da26057104.png', '2025-06-02 12:08:48', '2025-11-07 15:18:59', NULL),
(6, 'innformatque', 'descripton', '/assets/icons/6_1756113050.jpg', '2025-07-11 12:03:21', '2025-11-07 14:53:47', '2025-11-07 14:53:47'),
(7, 'ngk', NULL, '/assets/icons/1762525164_690dffec8bb10.png', '2025-11-07 13:19:24', '2025-11-07 13:19:24', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(11, '0001_01_01_000000_create_users_table', 2),
(12, '2025_05_27_121845_create_personal_access_tokens_table', 2),
(13, '2025_05_28_161033_add_soft_delete_to_users_table', 2),
(14, '2025_06_02_084308_create_clientcategories_table', 2),
(15, '2025_06_02_084309_create_client_table', 2),
(16, '2025_06_02_084940_create_client_contact_table', 2),
(17, '2025_06_02_085457_create_domaine_dactivites_table', 2),
(18, '2025_06_02_090320_add_contact_principal_foreign_key_to_client_table', 2),
(20, '2025_06_02_150443_add_if_column_to_client_table', 3),
(21, '2025_06_02_150931_add_client_id_to_client_contact_table', 4),
(22, '2025_06_18_161649_add_domain_id_to_client_table', 5);

-- --------------------------------------------------------

--
-- Structure de la table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '2b1fbf43dae6473bf2c92916b54bb72ed44efff36781b6795a3e9556fd4d245a', '[\"*\"]', '2025-06-02 16:25:31', NULL, '2025-06-02 08:07:08', '2025-06-02 16:25:31'),
(7, 'App\\Models\\User', 1, 'auth_token', '61a6eee6dc5bb11f0ef272eb499c685778bfb292a3c03d6493964b50666d7f21', '[\"*\"]', '2025-06-17 10:05:25', NULL, '2025-06-17 10:03:15', '2025-06-17 10:05:25'),
(9, 'App\\Models\\User', 3, 'auth_token', 'c4375303e4b6a36f6d7a9617b43a6f85b372e1737b1624cf5b8ac56f1940bf94', '[\"*\"]', '2025-06-17 10:09:51', NULL, '2025-06-17 10:09:49', '2025-06-17 10:09:51'),
(10, 'App\\Models\\User', 3, 'auth_token', '1c4c4ae817e295b89555fe4ebe571af57fb73ca3771b2e4bedd7dfd520f1a506', '[\"*\"]', '2025-06-18 15:27:42', NULL, '2025-06-17 13:12:06', '2025-06-18 15:27:42'),
(11, 'App\\Models\\User', 1, 'auth_token', '9c1430a87370e81ebb7e7e953be5a6b6c9aac2eb8e7d6898901ff20b1c7ebbcc', '[\"*\"]', '2025-07-11 12:00:41', NULL, '2025-07-11 12:00:41', '2025-07-11 12:00:41'),
(12, 'App\\Models\\User', 1, 'auth_token', '5b72a7f40f1d328ef4fdd282156c2d94b067a73608c6ac966261b697a0a5f690', '[\"*\"]', '2025-07-16 10:44:18', NULL, '2025-07-11 12:00:54', '2025-07-16 10:44:18'),
(13, 'App\\Models\\User', 1, 'auth_token', 'aa266c2428016eb14f6800d100363df90c0ecdbc5428121b7ec7fecce4333f7d', '[\"*\"]', '2025-08-25 07:44:00', NULL, '2025-08-25 07:43:59', '2025-08-25 07:44:00'),
(14, 'App\\Models\\User', 1, 'auth_token', '5b27bec0e233705047c59066c1f9f16ccb9e126ba0008d33e6947903a23b7a21', '[\"*\"]', '2025-08-25 07:44:07', NULL, '2025-08-25 07:44:06', '2025-08-25 07:44:07'),
(16, 'App\\Models\\User', 1, 'auth_token', '9c8dbf1ee0455628038781c17622737416d6326348e2d38a7c8e20876aaa0bb1', '[\"*\"]', '2025-08-25 07:44:53', NULL, '2025-08-25 07:44:50', '2025-08-25 07:44:53'),
(20, 'App\\Models\\User', 1, 'auth_token', 'd13da2e1fcc6ce8f7573c5c10e11a4b09fc267dbb79f4a94aa5e14fee4d625b9', '[\"*\"]', '2025-11-07 15:37:59', NULL, '2025-08-25 08:13:40', '2025-11-07 15:37:59'),
(21, 'App\\Models\\User', 1, 'auth_token', 'b9afe7a45772c872327da10d75cdc55e08023964c9c1f3f76068200d51fed710', '[\"*\"]', '2025-11-07 15:38:08', NULL, '2025-11-07 09:38:53', '2025-11-07 15:38:08'),
(23, 'App\\Models\\User', 3, 'auth_token', '6685bc01867c9291bf52de7031255cd23fea15428d9eb2dbc586645b2c807152', '[\"*\"]', '2025-11-07 14:26:08', NULL, '2025-11-07 14:26:08', '2025-11-07 14:26:08'),
(25, 'App\\Models\\User', 2, 'auth_token', '43f878c109318c8c143c295a136ab76e93cf5ff89e096229186690e9acb79256', '[\"*\"]', '2025-11-07 14:33:07', NULL, '2025-11-07 14:32:30', '2025-11-07 14:33:07'),
(26, 'App\\Models\\User', 2, 'auth_token', '61954885425edc95f364848ddbc3ead9f50ac816f75167f3664db660460bebea', '[\"*\"]', '2025-11-07 14:39:00', NULL, '2025-11-07 14:38:59', '2025-11-07 14:39:00'),
(27, 'App\\Models\\User', 2, 'auth_token', '005573d36bb26175c83f4b906f62983760760680b9cfd52917184c4e91af7270', '[\"*\"]', '2025-11-07 15:38:53', NULL, '2025-11-07 15:38:52', '2025-11-07 15:38:53');

-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('06FpvRLTuylEKy2qox6x6E7CXfUIZmpsVZgm138K', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidEpYZzl3ZkRTbm5OOHR3Y01tOElNVUdROE90VHhHNDFQWGk0bTJlNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1748952922),
('0kg0dZdFJ15oFGtNZ7Sa0AqVl0aFKa1motvWCsxB', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNndmMjJCNFIxN0pMYVlXQndvRmpTaUQ2ZFI4YUlNYWx5SHNjVFdCcyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762533022),
('0sMlzIN89VTdMmL29IG7SXk8hNcuXAZbuwvxRr90', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUjc4R2tNUjdWUkNOQ2tWMVZjMjdYRmJPMWF2c0I0dHhJQUt3d3o0RSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528495),
('19CAG9ukx2FuuzeI4YUq492NHnM5YkZmB9Du18xI', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWHdkM2c4ZE9hYjV0aGNkcWJQS083MzdwSlVZQTA2S1p0TGJ1RmlCeSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1748954770),
('1uG30ALnfaskI9lOflH2NFd6QyHV1iNOyZAnUxDs', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUdRSXMwYXg2OHZUUGVPeWlWM0R0eklSM25TVzdtQzJOdmxCcTdQciI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1756112103),
('1wNlxuJ9p5QgoJIcG2BBKowh9fHvjOOqYHu9UwZx', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQllLMlpoa0tROHF1bjliMGpCOEhDOXFKSDN0TW9oMDNZZmttZTJjbiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532569),
('2BjXh9jVVEzTlGbHkjiVGj2hyrlyENta7ca4NaaP', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY2JWcHdTZ0d6ZFZhQ3ZoZjNGSzFyZEtKZ0N4czdCZ2JlVnNuMU5PYyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1756112781),
('2sEnlRMp3Sw9m1ZuVlH6mc98jSK7mqsxIGNvtDfB', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWXdXeFZ5TVVPZjZRM3o4VDllTnJLYkZmZkpQN0NVQTVPTlZwckVzWSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528091),
('522lHPs7THP71d0JNOA1oQnNs8NBb9OPSuN9XzNJ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNldsNmFXQnJrMEp5dU83Q1l6cUFzUm92Qmt1SmkyMWh0VGZtNndPYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532845),
('59Guc4TjUlHbQUfL3ebhfvgzJW3uQLMLKCLxMo0W', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibzJzOWt3MUp1QTh4eHZWVTI3RmlaNHlRaWlUSldtb3podFRvNFJ2NSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1749111835),
('6j8KwmA95INntZdhudzRuM1I0tVuwhg5VG65dWbd', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaUVlRDQxWDJEbXdndkZXUm9rcWp1ZnhVQWRmem1BbGszbm55SjJybSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1748954793),
('6zkvA4pj8w4Xe4durCYPhXuZfgJaWGDPmIl2pdDW', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUHV2WVpIajZEb0J6cHRLWlZZeXNNYzZMRHljNkk0eThIM3BvbmsxbyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1750169536),
('7EBKA4Btuycb4CRrC5HyQqrIq3A4G7TqBonnIweZ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic0pwNGpKR2FlT0NwMHoyaU8wMWZaVGh5TjM3YUNjVkQ1SjJ1T2hvZCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528894),
('7FlJeN8kTEQQZeJwy3hr8jL1hvPbWmztcC3Qmnui', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieEEzUzBvbkZhWjRGOGwwb21RTUdFaEx5RUpvYTNCdEJiR1VKMlVqSiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532648),
('84Mm5dcxE4DhBKkZtvLg9hnjRv9yYXibnvHd3VjW', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTGwyTDVuZTNOcWNKOFpRV0dEa042MDJvRHlvNTFhTGE2YWx2c1c1YiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532943),
('90DcaemPlKFmR1RVxJUns3fzGiXnEWGkUqd3MyWJ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRDc2OHZHMnpkbWk3SFlJRWlETzI4VVV3MlNNWXE2MEJodTI1N3RXZSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762529071),
('9f5MwylbYBwAZokBLgqUGBYhgTngegpfOrKDV4MW', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUk03ZnVrcFZsSWpQTmJWbDh4VlIwR2dDUTN1OUUyN29QY2NDVmRHUSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528985),
('9fHva2tiweeZCIKeSl0RP1RMTMdCkNS65R0Dy8ep', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTEVUNmN1SHJsV3NRbjB4MVVMMzdiNWt6bzVmNXo2S2dNenJzdUpFUSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528816),
('9j7UGL5Vpc0hvsvit5bvSUPumx6eyDTt6g610h8U', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRUJDQ1VpY0dWTUg5U053ajJZV0ZpRVpGUmtYdjN3aUVvRnFwYWk5dyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1756115448),
('bea6dcYplQ3dRHOyB0Qrs3AGbfAJQYZz0EHwYeer', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS2JpUVR0SUZyNTAwbFBWR3hyTGE0QlFGVWlqdEdsWlpQNENFd295UCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762526655),
('bEr9lULqFUPjSDPXXdmb9yathmpm5Klt61unpKcY', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVHZjd2ZNM2dJbnJVRnR5MW9INVVUNnlBV3J1Y0d4aG11U0l3bFhXdiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1748948601),
('ctd6bJbG3IgqgDimBkMUpmXfeMfQU8gzIc0bNtdB', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVGh6VHd0REtPQllqOTdXTERpalZrSVFLRDJMR29NeWtUb2V2ekJEZCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532575),
('cThLcqGCb1ZfJV3tK4NqEOWFeYZOBfAgl1o1sH2P', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRktoQlNndkYwdEhtaHJYYUI4bDRqRU45TzBuaTltNmRPQ1FCMkJ3aiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1750169550),
('d7mfyZWXeIwLtvTcvzZd88BHXW4tg57RNkdVMenO', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibU9GN2NHaGFDb0VDa29DTXVIUTB3VlQzSHBhS3RuVjhONHljRVhneCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762529917),
('d8sP9Kc6V0rOxf1XiQNUv5oL3xyyQSkx2ZuZFVml', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidFI4dHViZDc3YVRXSnNqOUkxV2t0NDM1WTdoOHNPSlVvVzNwUmtLSyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1748948615),
('DE1ZnxxJycEMI6crZy0aXkCZX6T1heHeMgQjB2Ni', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSUZrcGJZcmxqb0xXY3RVcHliUEZrZDZRb3Z3dDBUTGJENkdHTHhaZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528241),
('DPtLMvGLMGzcdaZakX9eMIhrQVVZzuJzzu4mMALH', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY1VOVFJlbWd2WmhpaGU4N1JScFZNUUdsdkR2ZkVkNkREYlVNWVBEYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762530300),
('e8m8yjTu8SFthOe6raRnXBAdI3wWR7K3nxABgypX', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieE9FWGJFMTAybDdlbGJDbVZzTDl3d2s0NGlSOGZIaUE4ZDRFdkxlcSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532531),
('EnjfrP25s7q90cGiMbApcr8X9NtjF9bs9AN0h1iu', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOU9oN1lVR09xYWIyRlVLQVpBNjNGNzZrR0dKZkJNVjJyMXVCMEFUTyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528789),
('f7OG6CpaYO78Kh5VO7owHbqWUs1iSZnTp5ixkMfv', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidVJIS2lCanZ4TVJZcUVhbGE4dFoyeUpVREJoMkFTVFF3UVY1bVlIayI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762527559),
('FR1NtBNTveED1HW9SR6ZVRecujDUZjoyzFTMjCUT', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQVB1dGZYUnRIZ3cxTjdLVkh5dUxlZnRmY0xZekVRMUtESmdocElqVCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762508228),
('fZl0gSG1KLGYpMws6KfaXJy2QbNevdkayBIq6dGx', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVHJsRFNwVXhnZFRmTEloRTdCV1VRcmRaYmJaRmlYWUlHa2JZN2hPMSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1749637664),
('GQ0I2STVCxmaUqvL3S63rFCoYKQBSLWEBRdfmoEr', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVkpBMTVmc2g2VXQ0RDN0VEtSallSM2JRV3VFaU5vcmZ2emdYcHBmYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762530318),
('GSOxiNprmaOZaTUDceD7OteMsyOrDuMEZb9UaoYE', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZUtkZW1JeTcwcERPeFZFaGxQbWxwVE9XYkFhVnNoVFF4djZXcWh4WiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528390),
('H3v50lKVirhsiS1oBxqSaLxwGvZJTIM4x3dcPXtR', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTkNsWmRGQ2dMNUlrT0hSVm1DUDJnWkxpcllyOEdoRDBmOXlPUk1MQyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528491),
('h8uozmpxYFtHMmFSy00b6UbtGWsCumihLW9BxqCR', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibWx6TEc5RzVEdEV1VnhwZFZMQnV6V0xXdkw5aWZ4dVVSTVVIUTNaaSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762529187),
('HDZhNiN9nI6aoZpq8VrnXDKD2PTIXTzlBnZnTOrO', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibXVqanBHbFJmd2dNWTJRMzhyUllCTGZoREI5TUc4Zk5RUWNRSVRHZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762526647),
('hkyKBS94SYfaDKwQf1lMAgJqlh7MDvBlRrWuoF9C', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMk44d0w2RFdScGVUY2tDcThYQ1JQR1Z3bVc1VzNRREpGdElsTHdRNyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528491),
('hshZliQZQx2BGSYdHdPUf18zfAZKr1dC9Zo4kzqX', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWW1jVll3MHk0ekt3bEJZMVFBaDJTbFRZQUFNa0JvZDJkdnlMV0VyOCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532552),
('hW5mkuaU8EzB4D3kiF3PkEDXlPZsi7v7KgZ7zB8s', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaU1rcEtQbGNmdk90ajRuaGw2dUF4NVVHc2p1TUtUVkZNU2k0aDZuUCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762533108),
('IAPXkOh9L7Fu2RGjdEhcHmdkyP4xidQgFniMBnSS', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ25OdGd1NTBiSndESm5Bbm1YZzVoVFZleG9CcXUwWnM1dUU1QlB1ZyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1756111883),
('ICUCQuq5mr8ZkEMMHWauCSbJ7bVn1PLtoyeB3EBQ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidWh2U2hqdE9TUUlKYTluRzNXWGVPUFlyU1ptR3A4aDV2T01sc3JvZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1750158464),
('IlMcVwD9akHoAJY9Hpxf9UitClwIN35aOezF4Y5E', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR1N6ZnlHZ0lDS3pWYkwzV0IxRE0ydmNwZENnTFpXaVEzZEFFajNNNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532840),
('jgPz343SuLrWqzpkEAFI6lhHo6c9H1SaoK53VaVI', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM0JTdGc4NEhtWnl4MEt1VUt3aVJYQ3FaMVJZZk1YdUdaZTlscnVOTCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1756112987),
('ju5Roc27T9UiCtAFjNy0VSbwhfTmrGOVdRGIX345', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVUdPejlyZ2NoZjRpTFh6YTVrR055WTlVZzVVM3Fzb24yQWYxd1J2WCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532491),
('kfQ5Qe1b7AXix5Yv8TvPW9hzPUvOSNw0K9icEvkR', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibXVaVUhHckNJdHowekFzVHBwbUt2elpSNEI5YW5xRTFsM0VXRDM5RyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762529464),
('L4d4cIe3EFI2kVo4UMEyiwsPjCLMr07H5WKcoNAj', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSXVENWNhd0g4MG15OVEzZE9PNWFUZENtaHN6TThFUGxZUWE1SE1GRyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1756113098),
('m2Vj3v5VRqSM9UN9cwlkiSoCeTyd6FTa9tW8i56z', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRE1neG1nOWtHeklLWGVheTAyRU5YRjRTUVE2dUxZUmp1S3ZDSWN4NyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1749638050),
('mDYzCaW9rVa6CmBNR5q9BiqYNkwtSkdweRPPwn6e', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYTJVcGlTd3l5QjdUWmJoWTBmQkxXdUdjUUhGMVVNTkZMSTV4MjVYQyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762527708),
('mELqveLqDqNVo1qCyZ4nu79RSApKQzeEQzcJoa0I', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSkJNTGFNSUdkQ09Deng0VTlvWGZKSzhKcVlReVhMVjlYUTduYlhLZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528919),
('Mkhey1TKnvQYWQ6Kl4yN1nO1jf1ZKZOTCtae5xJc', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVFVUeTJJcFl1b2hPem1WM1ZLTHI3SkZoc0NYV0gweVhES1hweWNPYyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528785),
('mpY28jw8Kjgg2TegIXXZ8AowrvMKbNApdFKLTVOd', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMExhWk0wbkJmamRFZGJrR0gyRUhxWmRkV1RsZFZFb2ZaZ2ZyMWRzSiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528123),
('MtRts89CGp978Yk4EYiy7bWc6IMEZ3vPjNyl0eZB', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZFBvS3FudlNwVjdqMkozOFhUbU5VTmthbGZXN1JxbzVRUWFZNUMwTSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1748952919),
('MuY0myZ3XzOgtHvEob8osjjVb71rcaZtWbyOHJgp', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZTNYejNNTk95NUlMV1g2RkszWG9FNTJWcjVGTFhtUXN5THVLc014eCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528427),
('MXWwkpsBsM6MFkTTHD3JjSyPp3YlGTmvxptjf35K', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaWZMelBlSlhiTjdicndueDRoOWllNlpwVDhIbHMwT1QyWTNHVzhUSyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1752238828),
('OGqDrRNzxwM5y80a3fFTE2aBg9fjJlYy2fDdn6qQ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ2V4bzJJTlRrNXBqZllaazRUdElxMVNCbHpUM1FLd0VCelhvNUpjNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532997),
('oJdRCoOXqcSYPrA5h2Y24KlPKNPlzR13k99ax4zH', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVVUxdTIyNVFDSFFnVjVGOVN4YVlyeDFmcGlOTW8zZHFVRzRHN2Q3RCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1756111510),
('oLY9NJLcXQ0reNrye7K454SjAXOn4il8LfdUVEsz', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWXR6cFhFNkpHZkhteFZpWGM4a0xibE9sdVpFcWxDd0NhSlMwOXlwcSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762526664),
('Ov9BLJkEWSMQRImKTFs7VIYwdqROkB03eQ7M31sY', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibXcwamtzMm1vVXVsQTF3NUloV0tWaGZzM2hkaTVPTzllN3hpWkhFZyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528391),
('q3Lx4QuvMncRuDRSO1lpf7FeCittDxavcogc17qJ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNnlzSDQ0OWVWOFE1M2d5dkN1bEp5eVJYd2ExS2Fab2wyZGFiajF2RyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528231),
('q8dGALcH0dliaUrxjVQKjvKAHhGY1E9nDKFuyNsD', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY3VUUjBrN0xLTXhWZm1WZGtJZmhPbnBCZXRGdWdIVjhSNW43T1IzbyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528965),
('QECZOnlVJkBhCdpxyRb1AOkGtM4pckOwxvIIR0Oa', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY05DN1dtZjF2cXc0UzVhMnFtNHVXWFRPclI1M0RTNHY5ZmZSZHBCQSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528547),
('qkWH0q11OqYIhshPEUp5nqi0d3qA5Dx1cldKQ92l', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRVFLZTNqN3ZBaFljY2d6bGlud0hhTm9PVUxnVlRrMnBWUHI3dmVFSyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528230),
('qshVymc1qNdPC8fsxBRR519gAtXPKfnY5bXJGlOW', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNU14ZFpUYjB6MllVV0p5b3pjTWE1c2thUFA1a1hGYkE2T2tld2ZYSSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528473),
('R05wHSVjWOQtfHVVIRhOLX5PK7Mi2jQgnDgYRCcV', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZHdVbFUyOGFjb1NXZ2VCckk4Y1FPMDVTN3l4MUFVbU9zR0pZSjhHSCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1750169215),
('roizOQJHI46MpUcpoeu4L9RiULuMlCM1ZIqChPnX', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSnJ4aUVzN1VoME00emNLbVRDQlRHVWtWV2NqbWVncXJkZHh2OUdGeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762527926),
('rveCpjPlN8EQeOmqHOvxKrEQ6bInYvIlUle8mov6', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOWhUekM0ekJ0ZXR6RzNGc0NUYWdpQ2NaQ1lKSFBtNTU5R0x1ZnNVNSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762527959),
('rZex6TAirHMPnRyRvJ7afXEbUaU7YurHqtO88jzL', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUG80YW9mbEhTa2JFMjRoUzZxNm5MZXUyWmJCR2xUaldacWlqYVF5eiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528435),
('smDpAQ4VtmTBUVWVMvJHMaPSvs4ib0DQvKClaCq2', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS0FiNDk5UUw1QkNKSkk4aEtDVkQ5eWhSQkJmQUppa0xsUndRcEVVYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762527703),
('Sx4nHnyxnJdeCmBbcFFK454yz35QAqYoNyTEKAJw', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiekx5WnZ1NjczZXhmRFdabFV6ZXByZExPUGp4bGNGYUx1TXE3NG1NaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1756112123),
('tAOkVCHpd26VgISP400m6b05JsvpkM03bH35l219', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVW9IOG1tZGZ2Y05KZXdaZGdNQU1uOHVGRVc1NDYzQmZHa0xTc1hzTCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528218),
('tcs97ndwMpW8WLVx4hBSkLta1mAdsMS4zgYAfBAJ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNHdUOHU0cHpEb1hTdmtSNnNVN2pvZjN3Q2hyOFI4bkUzRloyaTNxViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762527867),
('TMcbdz7PLt5Uqg37q2tZ8fY0qwXOlbkH0aWSvxIa', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ2ZWek9RY3V4Wk5HeVhnZWpRdVNpZTNWclNvSDZxWUVmdUVlUzM4eCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1750158453),
('TOiqcSsPsicMQU3S96jlJLzDrLWcV9Sa0rJFor8q', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTGZVajVDVzF2cnBZOExxMzl6Z2pEenMyTUVWand2TGdkVHZiUlBLTCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1752666517),
('twqXOIUHYlVDnZGpEDra5Bu8tUmCPVHYBtTosyBZ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQmd2WndZbmJPRk5kVVZsbGhvRERiTnhqbWVuUHlHTFRBRGFLNDNMSSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762530325),
('ug8tanvO56WsNwxfY9FDAiKj1YzNpKilNEwEyxjI', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRjgxclBtUEFHVVNUZnlVMUVOdkQzOTVDNGFwcXpra0k0SEpkTnNkMiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528247),
('UKWXAOuO1QbDtSxlN0c8t8pL6Jm8TQN68iYnH9Q8', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidmMxVVRrWDVxOExGelJkMXlNQXo0ZEVPMjZOSEpKcVY3aVNHcFJZUCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762527940),
('uO0DTpD2GlujX9fZtrQ3guVcQoXhdWH8rEDzUTG4', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidDFtTmlmakRyUjlKd3dJRmNYZU1wbnZxeVQ3VWFuSTd5cHF2bDN5aCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528219),
('uV2auitzVG2o7wAVMPTMdhU0PZqtRD71t2ePxBC0', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibHl2Y3BDNnEzTmpzZVpYY050ckhBRzczQktVQ2hOTW9za0NkbGEyZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1750158553),
('V1RxHzE8uYPM99W4rgbjGCmHen6YxGQthdqTE1pC', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidlZpbXA1TUJlbndWZ25CNjhmMkFLVkZUZTZVR3ZDZWVLNEZtcjg5USI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1749050200),
('VdWQmJqrRLnBk5fj4blmQG1UjwVgmuRAW9VVcuqA', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQUhkUThCMjhYRm1SajNwbFVLSkFjT0pJYnJWMEZLeWIxU3Rtdk1EMiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762533053),
('VooKoSb552VSDvx9YwnsdCSR3uARcjAoiZ0helDg', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib2pTVDl6NHFSUWk2d2lBSnNtM3d3SUZYRVVOcXZucjVhbERwV1JDdSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762526628),
('vTkocCOFhLQUHcL8Iut5ThfcgpAfQs96mdq8CVk9', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid0o3dWZmUWlseHpvVlNSUmdXN2gyTnp1REswejQzWkd4eVpqVnZRbiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1750158563),
('WOlDYaDMAuBs0zQhb4EA8B7jRhVC4aDKhqbGVKNE', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQXpyUnVUbUtYWHR2YkhjSTBveGduNVg1SFcwd2dpN0pmRVJuNndoVCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528819),
('x3Y4DqdRMyo71zy8XFDqos1gfIJu1EkxoWJF00Ht', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibTRTdXJNS1B5ak84ck1qb3hQYnNCQkp4QUNsVlhWSUpUMFFqdXB3TyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528474),
('XhafThp3Te4IaF5JeG3Tkh8Ok7338boDPYNb14pN', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMGdwVDc0Nkw5WkxIN29CdnVMVWtUeEE2bGgzVU51dDhxd25MdHVNUyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762526633),
('xJeEAfqtrjXysqP2RDYx3BbZ0lTVIQoAcepoK2Qk', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNWJtUTZ2RzVoUHRmVkNSRjRsQzVCTFZOWjZZZ05BZHBEYW82OHgxNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528495),
('Xl3gSnp9FSKKA26641sjRwNq1LUpdx3MInczs8Sh', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTkx4N3RrRkJLVkVBRTVRM0VwMWFYYVlTZnNUVkZSQ1RVaGFscmE0TiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1748948594),
('yFiTZ5TMNejMyNUsDK08OF4aKRjPcBQ5NXJONmSA', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTVZyWnU2Ync3UHRyNDc0ZEg1SFBZc0ZMdUhLcHBBRXVGVW1hV1loRSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1750158505),
('yLLbUERKueFwVRHNW65yNRJsZIiqU38I9Stv6hYy', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHZqa3dFZk9kWHdydlBDb2R3Mk9WRVNRaXFFUFFqWHZYc0J5cU1lMiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1756113088),
('yMFMz8rQHiaWemfhERcurvO7JHdqsjFRpTBIyXA4', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiam42ZHJBeEpFZmFKb3lrcERuNzR3enA3RmkzRk9OaEdxa3N3U1Y2aSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528252),
('YXzsDOc9hXnGkdNAvJ4LAyklmB4JbOUvJ4Pkesas', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZHpwQkpUeTNtYUVZWFZyVjR1TlQzOWJXM0dLT2tZWUd6ZkVjTmJuVCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762533037),
('z0sRKKikEbQtQWCAOxVXtKvuSePgG25VS8MGb0hC', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQmluVUVZQlUzamdZWXhMRDVMN3ZwQ0ZJN2JKeU0xczh3TjY1N0w1ZSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762527930),
('zDmaD9B5sYlGhtUeVX3CIeCvfsjsIsGZnflYGA45', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiU0dsRU1xODhnS05DTUpHQnl2Sk1mejlhTHpSbFNSaVh0c1E5cmYzUiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762532405),
('zIExScW3nAbESNxK74AftXfzB5Aum180mbL7Era7', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN0F2VVNaSmVkWEV0UVVUVnV4MVdmdERzbHJSa3FGcDVvV0NGRUtPNiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528077),
('ziMM9c6931i0hUkiPlrFOJFqfwiYmoq4zkjAOVeU', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR3RqazVWVG4wMnJHcFlUMllxWFdPNXdNdU42VG1DQW9jM3ptbDN0USI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528260),
('ZmhlxSrDAClZLIErLRuMHteL3ApkDxdKRIGLtSDR', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicHFTNUhTNkRTZE1SNGl2aThNcG5LeU9DQmU3dEpveHBnTjR2RTBLMCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1762528556);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `role` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `avatar`, `email_verified_at`, `role`, `password`, `is_active`, `remember_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'saad', 'blink', 'admin@gmail.com', '0600000000', '/assets/avatars/1_1748948606.png', NULL, 'admin', '$2y$12$TE83.lBxau0ZUCooD2B4v.GUZWrJaWa.nWThsCKU7mCz8OTlKVWGi', 1, NULL, NULL, '2025-08-25 07:51:18', NULL),
(2, 'admin', 'blink', 'admin2@gmail.com', '06666666666', NULL, NULL, 'admin', '$2y$12$PBdm7o9.pwxMYhErn9K9keIlcrI2FkHSSJX33.iavM4f1aZXzz3Cm', 1, NULL, '2025-06-03 10:17:30', '2025-11-07 14:43:48', NULL),
(3, 'saad', 'mnaybez', 'saadmnhm@gmail.com', '0698438171', NULL, NULL, 'manager', '$2y$12$By1xBCc4ro6VRjjB62leoOD3slaMdoTE0NY6W4s7fSgHW7PwohBFO', 1, NULL, '2025-06-03 11:45:54', '2025-11-07 15:38:06', NULL);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `client_email_unique` (`email`),
  ADD KEY `client_categories_id_foreign` (`categories_id`),
  ADD KEY `client_user_id_foreign` (`user_id`),
  ADD KEY `client_contact_principal_foreign` (`contact_principal`),
  ADD KEY `domain_d` (`domain_id`);

--
-- Index pour la table `clientcategories`
--
ALTER TABLE `clientcategories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clientcategories_label_unique` (`label`);

--
-- Index pour la table `client_contact`
--
ALTER TABLE `client_contact`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `client_contact_email_unique` (`email`),
  ADD KEY `client_contact_user_id_foreign` (`user_id`),
  ADD KEY `client_contact_client_id_foreign` (`client_id`);

--
-- Index pour la table `domaine_dactivites`
--
ALTER TABLE `domaine_dactivites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `domaine_dactivites_label_unique` (`label`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Index pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Index pour la table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `client`
--
ALTER TABLE `client`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `clientcategories`
--
ALTER TABLE `clientcategories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `client_contact`
--
ALTER TABLE `client_contact`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT pour la table `domaine_dactivites`
--
ALTER TABLE `domaine_dactivites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `client_categories_id_foreign` FOREIGN KEY (`categories_id`) REFERENCES `clientcategories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `client_contact_principal_foreign` FOREIGN KEY (`contact_principal`) REFERENCES `client_contact` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `client_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `client_contact`
--
ALTER TABLE `client_contact`
  ADD CONSTRAINT `client_contact_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `client_contact_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
