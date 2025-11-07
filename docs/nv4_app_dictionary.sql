-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 07, 2025 at 11:18 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nv4_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `nv5_api_role`
--

CREATE TABLE `nv5_api_role` (
  `role_id` smallint(4) NOT NULL,
  `role_md5title` char(32) NOT NULL,
  `role_type` enum('private','public') NOT NULL DEFAULT 'private',
  `role_object` enum('admin','user') NOT NULL DEFAULT 'admin',
  `role_title` varchar(250) NOT NULL DEFAULT '',
  `role_description` varchar(250) NOT NULL DEFAULT '',
  `role_data` text NOT NULL,
  `log_period` int(11) NOT NULL DEFAULT 0,
  `flood_rules` text NOT NULL,
  `addtime` int(11) NOT NULL DEFAULT 0,
  `edittime` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Role api';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_api_role_credential`
--

CREATE TABLE `nv5_api_role_credential` (
  `id` int(11) NOT NULL,
  `userid` int(11) UNSIGNED NOT NULL,
  `role_id` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `access_count` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_access` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `endtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `quota` int(20) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quyền truy cập API Role';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_api_role_logs`
--

CREATE TABLE `nv5_api_role_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` smallint(4) NOT NULL DEFAULT 0,
  `userid` int(11) NOT NULL DEFAULT 0,
  `command` char(100) NOT NULL DEFAULT '',
  `log_time` int(11) NOT NULL DEFAULT 0,
  `log_ip` char(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lịch sử gọi API';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_api_user`
--

CREATE TABLE `nv5_api_user` (
  `id` int(11) NOT NULL,
  `userid` int(11) UNSIGNED NOT NULL,
  `ident` varchar(50) NOT NULL DEFAULT '',
  `secret` varchar(250) NOT NULL DEFAULT '',
  `ips` text NOT NULL,
  `method` enum('none','password_verify','md5_verify') NOT NULL DEFAULT 'password_verify',
  `addtime` int(11) NOT NULL DEFAULT 0,
  `edittime` int(11) NOT NULL DEFAULT 0,
  `last_access` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='User API theo từng phương thức xác thực';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors`
--

CREATE TABLE `nv5_authors` (
  `admin_id` int(11) UNSIGNED NOT NULL,
  `editor` varchar(100) DEFAULT '',
  `lev` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `lev_expired` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `after_exp_action` mediumtext DEFAULT NULL,
  `files_level` varchar(255) DEFAULT '',
  `position` varchar(255) NOT NULL,
  `main_module` varchar(50) NOT NULL DEFAULT 'siteinfo',
  `admin_theme` varchar(100) NOT NULL DEFAULT '',
  `addtime` int(11) NOT NULL DEFAULT 0,
  `edittime` int(11) NOT NULL DEFAULT 0,
  `is_suspend` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `susp_reason` text DEFAULT NULL,
  `pre_check_num` varchar(40) NOT NULL DEFAULT '',
  `pre_last_login` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `pre_last_ip` varchar(45) DEFAULT '',
  `pre_last_agent` varchar(255) DEFAULT '',
  `check_num` varchar(40) NOT NULL DEFAULT '',
  `last_login` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_ip` varchar(45) DEFAULT '',
  `last_agent` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quản trị site';

--
-- Dumping data for table `nv5_authors`
--

INSERT INTO `nv5_authors` (`admin_id`, `editor`, `lev`, `lev_expired`, `after_exp_action`, `files_level`, `position`, `main_module`, `admin_theme`, `addtime`, `edittime`, `is_suspend`, `susp_reason`, `pre_check_num`, `pre_last_login`, `pre_last_ip`, `pre_last_agent`, `check_num`, `last_login`, `last_ip`, `last_agent`) VALUES
(1, 'ckeditor5-classic', 1, 0, NULL, 'adobe,archives,audio,documents,images,real,video|1|1|1', 'Administrator', 'siteinfo', '', 0, 0, 0, '', '', 0, '', '', '70a9744de0cf57331a03cc2e6f0f9159', 1762349025, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors_config`
--

CREATE TABLE `nv5_authors_config` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `keyname` varchar(39) NOT NULL DEFAULT '',
  `mask` tinyint(4) NOT NULL DEFAULT 0,
  `begintime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `endtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `notice` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cấu hình tường lửa từng tài khoản quản trị';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors_module`
--

CREATE TABLE `nv5_authors_module` (
  `mid` mediumint(8) NOT NULL,
  `module` varchar(50) NOT NULL,
  `lang_key` varchar(50) NOT NULL DEFAULT '',
  `weight` mediumint(8) NOT NULL DEFAULT 0,
  `act_1` tinyint(4) NOT NULL DEFAULT 0,
  `act_2` tinyint(4) NOT NULL DEFAULT 1,
  `act_3` tinyint(4) NOT NULL DEFAULT 1,
  `checksum` varchar(32) DEFAULT '',
  `icon` varchar(100) NOT NULL DEFAULT '' COMMENT 'Icon'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bật tắt module trong quản trị theo cấp quản trị';

--
-- Dumping data for table `nv5_authors_module`
--

INSERT INTO `nv5_authors_module` (`mid`, `module`, `lang_key`, `weight`, `act_1`, `act_2`, `act_3`, `checksum`, `icon`) VALUES
(1, 'siteinfo', 'mod_siteinfo', 1, 1, 1, 1, '697317c943c7876776885f4b2972223a', 'fa-solid fa-server'),
(2, 'authors', 'mod_authors', 2, 1, 1, 1, '541f2ed6970c6eab30aba3b270c043e1', 'fa-solid fa-user-gear'),
(3, 'settings', 'mod_settings', 3, 1, 1, 0, '39853b9cdcc1ae3e230569891c455d17', 'fa-solid fa-gears'),
(4, 'database', 'mod_database', 4, 1, 0, 0, '7ee80b5404123786881b9be0aa5d65e5', 'fa-solid fa-database'),
(5, 'webtools', 'mod_webtools', 5, 1, 1, 0, 'ac4a6270511751807f415c57cacea7db', 'fa-solid fa-toolbox'),
(6, 'seotools', 'mod_seotools', 6, 1, 1, 0, '155f09e7985ff0af2fa136845a8b4ec3', 'fa-brands fa-searchengin'),
(7, 'language', 'mod_language', 7, 1, 1, 0, 'd989111d179d0b4fbc67e0557de76ab1', 'fa-solid fa-language'),
(8, 'modules', 'mod_modules', 8, 1, 1, 0, 'c11fb193daf7abb7341e08db7a9869fd', 'fa-solid fa-cubes'),
(9, 'themes', 'mod_themes', 9, 1, 1, 0, '7ffad807f52726ddbf58c057fab34e50', 'fa-solid fa-palette'),
(10, 'extensions', 'mod_extensions', 10, 1, 0, 0, 'b650c8ba38e9bbea9887b8bf1d7cad05', 'fa-solid fa-cubes-stacked'),
(11, 'upload', 'mod_upload', 11, 1, 1, 1, 'd5b3e80258a89baad708904f2d36b1c8', 'fa-solid fa-folder-plus'),
(12, 'emailtemplates', 'mod_emailtemplates', 12, 1, 1, 0, 'a95ddd3bf3a5cb2d82ae4f6be989f2fb', 'fa-solid fa-at');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors_oauth`
--

CREATE TABLE `nv5_authors_oauth` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `admin_id` int(11) UNSIGNED NOT NULL COMMENT 'ID của quản trị',
  `oauth_server` varchar(50) NOT NULL COMMENT 'Eg: facebook, google...',
  `oauth_uid` varchar(50) NOT NULL COMMENT 'ID duy nhất ứng với server',
  `oauth_email` varchar(50) NOT NULL COMMENT 'Email',
  `oauth_id` varchar(50) NOT NULL DEFAULT '',
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng lưu xác thực 2 bước từ oauth của admin';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors_vars`
--

CREATE TABLE `nv5_authors_vars` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `admin_id` int(11) UNSIGNED NOT NULL COMMENT 'ID của quản trị',
  `lang` varchar(3) NOT NULL DEFAULT 'all' COMMENT 'Ngôn ngữ hoặc tất cả',
  `theme` varchar(100) NOT NULL DEFAULT '' COMMENT 'Giao diện',
  `config_name` varchar(60) NOT NULL DEFAULT '' COMMENT 'Khóa cấu hình',
  `config_value` text DEFAULT NULL COMMENT 'Nội dung cấu hình',
  `weight` smallint(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sắp xếp'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các config khác của quản trị';

--
-- Dumping data for table `nv5_authors_vars`
--

INSERT INTO `nv5_authors_vars` (`id`, `admin_id`, `lang`, `theme`, `config_name`, `config_value`, `weight`) VALUES
(1, 1, 'all', 'admin_future', 'collapsed_left_sidebar', '0', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_banners_click`
--

CREATE TABLE `nv5_banners_click` (
  `id` int(11) UNSIGNED NOT NULL,
  `bid` mediumint(8) NOT NULL DEFAULT 0,
  `click_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `click_day` int(2) NOT NULL,
  `click_ip` varchar(46) NOT NULL,
  `click_country` varchar(10) NOT NULL,
  `click_browse_key` varchar(100) NOT NULL,
  `click_browse_name` varchar(100) NOT NULL,
  `click_os_key` varchar(100) NOT NULL,
  `click_os_name` varchar(100) NOT NULL,
  `click_ref` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_banners_plans`
--

CREATE TABLE `nv5_banners_plans` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `blang` char(2) DEFAULT '',
  `title` varchar(250) NOT NULL,
  `description` text DEFAULT NULL,
  `form` varchar(100) NOT NULL,
  `width` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `height` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `require_image` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `uploadtype` varchar(255) NOT NULL DEFAULT '',
  `uploadgroup` varchar(255) NOT NULL DEFAULT '',
  `exp_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_banners_plans`
--

INSERT INTO `nv5_banners_plans` (`id`, `blang`, `title`, `description`, `form`, `width`, `height`, `act`, `require_image`, `uploadtype`, `uploadgroup`, `exp_time`) VALUES
(1, '', 'Mid-page ad block', '', 'sequential', 575, 72, 1, 1, 'images', '', 0),
(2, '', 'Left-column ad block', '', 'sequential', 212, 800, 1, 1, 'images', '', 0),
(3, '', 'Right-column ad block', '', 'random', 250, 500, 1, 1, 'images', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_banners_rows`
--

CREATE TABLE `nv5_banners_rows` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `pid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `clid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `file_name` varchar(255) NOT NULL,
  `file_ext` varchar(100) NOT NULL,
  `file_mime` varchar(100) NOT NULL,
  `width` int(4) UNSIGNED NOT NULL DEFAULT 0,
  `height` int(4) UNSIGNED NOT NULL DEFAULT 0,
  `file_alt` varchar(255) DEFAULT '',
  `imageforswf` varchar(255) DEFAULT '',
  `click_url` varchar(255) DEFAULT '',
  `target` varchar(10) NOT NULL DEFAULT '_blank',
  `bannerhtml` mediumtext NOT NULL,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publ_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exp_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `hits_total` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `weight` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_banners_rows`
--

INSERT INTO `nv5_banners_rows` (`id`, `title`, `pid`, `clid`, `file_name`, `file_ext`, `file_mime`, `width`, `height`, `file_alt`, `imageforswf`, `click_url`, `target`, `bannerhtml`, `add_time`, `publ_time`, `exp_time`, `hits_total`, `act`, `weight`) VALUES
(1, 'Mid-page advertisement', 1, 1, 'webnhanh.jpg', 'png', 'image/jpeg', 575, 72, '', '', 'http://webnhanh.vn', '_blank', '', 1759423352, 1759423352, 0, 0, 1, 1),
(2, 'Left-column advertisement', 2, 1, 'vinades.jpg', 'jpg', 'image/jpeg', 212, 400, '', '', 'https://vinades.vn', '_blank', '', 1759423352, 1759423352, 0, 0, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_config`
--

CREATE TABLE `nv5_config` (
  `lang` varchar(3) NOT NULL DEFAULT 'sys',
  `module` varchar(50) NOT NULL DEFAULT 'global',
  `config_name` varchar(30) NOT NULL DEFAULT '',
  `config_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cấu hình hệ thống';

--
-- Dumping data for table `nv5_config`
--

INSERT INTO `nv5_config` (`lang`, `module`, `config_name`, `config_value`) VALUES
('en', 'about', 'activecomm', '0'),
('en', 'about', 'adminscomm', ''),
('en', 'about', 'allowattachcomm', '0'),
('en', 'about', 'allowed_comm', '-1'),
('en', 'about', 'alloweditorcomm', '0'),
('en', 'about', 'auto_postcomm', '1'),
('en', 'about', 'captcha_area_comm', '1'),
('en', 'about', 'emailcomm', '0'),
('en', 'about', 'perpagecomm', '5'),
('en', 'about', 'setcomm', '4'),
('en', 'about', 'sortcomm', '0'),
('en', 'about', 'timeoutcomm', '360'),
('en', 'about', 'view_comm', '6'),
('en', 'comment', 'captcha_type', 'captcha'),
('en', 'contact', 'bodytext', 'If you have any questions or comments, please contact us below and we will get back to you as soon as possible.'),
('en', 'contact', 'captcha_type', 'captcha'),
('en', 'contact', 'feedback_address', '0'),
('en', 'contact', 'feedback_phone', '0'),
('en', 'contact', 'sendcopymode', '0'),
('en', 'contact', 'silent_mode', '1'),
('en', 'dictionary', 'admin_review_required', '1'),
('en', 'dictionary', 'alias_lower', '1'),
('en', 'dictionary', 'allow_submit', '0'),
('en', 'dictionary', 'cache_ttl', '300'),
('en', 'dictionary', 'example_limit', '3'),
('en', 'dictionary', 'per_page', '20'),
('en', 'dictionary', 'search_min_length', '2'),
('en', 'dictionary', 'search_mode', 'prefix'),
('en', 'dictionary', 'show_examples', '1'),
('en', 'dictionary', 'show_phonetic', '1'),
('en', 'dictionary', 'suggest_limit', '10'),
('en', 'freecontent', 'next_execute', '0'),
('en', 'global', 'antispam_warning', '0'),
('en', 'global', 'antispam_warning_content', ''),
('en', 'global', 'autologomod', ''),
('en', 'global', 'autologosize1', '50'),
('en', 'global', 'autologosize2', '40'),
('en', 'global', 'autologosize3', '30'),
('en', 'global', 'data_warning', '0'),
('en', 'global', 'data_warning_content', ''),
('en', 'global', 'disable_site_content', 'For technical reasons Web site temporary not available. we are very sorry for that inconvenience!'),
('en', 'global', 'dkim_included', 'sendmail,mail'),
('en', 'global', 'force_reply', '0'),
('en', 'global', 'force_sender', '0'),
('en', 'global', 'mail_tpl', ''),
('en', 'global', 'mailer_mode', 'mail'),
('en', 'global', 'mobile_theme', 'mobile_default'),
('en', 'global', 'name_show', '1'),
('en', 'global', 'notify_email_error', '0'),
('en', 'global', 'opensearch_link', ''),
('en', 'global', 'preview_theme', ''),
('en', 'global', 'reply_email', ''),
('en', 'global', 'reply_name', ''),
('en', 'global', 'sender_email', ''),
('en', 'global', 'sender_name', ''),
('en', 'global', 'site_banner', ''),
('en', 'global', 'site_description', 'Sharing success, connect passions'),
('en', 'global', 'site_domain', ''),
('en', 'global', 'site_favicon', ''),
('en', 'global', 'site_home_module', 'news'),
('en', 'global', 'site_keywords', ''),
('en', 'global', 'site_logo', ''),
('en', 'global', 'site_name', 'NUKEVIET'),
('en', 'global', 'site_theme', 'default'),
('en', 'global', 'smime_included', 'sendmail,mail'),
('en', 'global', 'smtp_host', 'smtp.gmail.com'),
('en', 'global', 'smtp_password', 'Tyqij_YRe7sz8GDFCkvX0g,,'),
('en', 'global', 'smtp_port', '465'),
('en', 'global', 'smtp_ssl', '1'),
('en', 'global', 'smtp_username', 'user@gmail.com'),
('en', 'global', 'switch_mobi_des', '1'),
('en', 'global', 'theme_type', 'r,d,m'),
('en', 'global', 'tinify_active', '0'),
('en', 'global', 'tinify_api', ''),
('en', 'global', 'upload_logo', ''),
('en', 'global', 'upload_logo_pos', 'bottomRight'),
('en', 'global', 'user_allowed_theme', ''),
('en', 'global', 'verify_peer_name_ssl', '1'),
('en', 'global', 'verify_peer_ssl', '1'),
('en', 'news', 'active_history', '0'),
('en', 'news', 'activecomm', '1'),
('en', 'news', 'adminscomm', ''),
('en', 'news', 'alias_lower', '1'),
('en', 'news', 'allowattachcomm', '0'),
('en', 'news', 'allowed_comm', '-1'),
('en', 'news', 'allowed_rating', '1'),
('en', 'news', 'allowed_rating_point', '1'),
('en', 'news', 'alloweditorcomm', '0'),
('en', 'news', 'auto_postcomm', '1'),
('en', 'news', 'auto_save', '0'),
('en', 'news', 'auto_tags', '0'),
('en', 'news', 'blockheight', '75'),
('en', 'news', 'blockwidth', '70'),
('en', 'news', 'captcha_area_comm', '1'),
('en', 'news', 'captcha_type', 'captcha'),
('en', 'news', 'config_source', '0'),
('en', 'news', 'copy_news', '1'),
('en', 'news', 'copyright', 'Note: The above article reprinted at the website or other media sources not specify the source https://nukeviet.vn is copyright infringement'),
('en', 'news', 'elas_host', ''),
('en', 'news', 'elas_index', ''),
('en', 'news', 'elas_port', '9200'),
('en', 'news', 'elas_use', '0'),
('en', 'news', 'emailcomm', '0'),
('en', 'news', 'facebookappid', ''),
('en', 'news', 'frontend_edit_alias', '0'),
('en', 'news', 'frontend_edit_layout', '1'),
('en', 'news', 'hide_author', '0'),
('en', 'news', 'hide_inauthor', '0'),
('en', 'news', 'homeheight', '150'),
('en', 'news', 'homewidth', '100'),
('en', 'news', 'htmlhometext', '0'),
('en', 'news', 'identify_cat_change', '0'),
('en', 'news', 'imagefull', '460'),
('en', 'news', 'imgposition', '2'),
('en', 'news', 'indexfile', 'viewcat_main_right'),
('en', 'news', 'instant_articles_active', '0'),
('en', 'news', 'instant_articles_auto', '1'),
('en', 'news', 'instant_articles_gettime', '120'),
('en', 'news', 'instant_articles_httpauth', '0'),
('en', 'news', 'instant_articles_livetime', '60'),
('en', 'news', 'instant_articles_password', ''),
('en', 'news', 'instant_articles_template', 'default'),
('en', 'news', 'instant_articles_username', ''),
('en', 'news', 'keywords_tag', '1'),
('en', 'news', 'mobile_indexfile', 'viewcat_page_new'),
('en', 'news', 'order_articles', '0'),
('en', 'news', 'per_page', '20'),
('en', 'news', 'perpagecomm', '5'),
('en', 'news', 'report_active', '1'),
('en', 'news', 'report_group', '4'),
('en', 'news', 'report_limit', '2'),
('en', 'news', 'schema_type', 'newsarticle'),
('en', 'news', 'setcomm', '4'),
('en', 'news', 'show_no_image', ''),
('en', 'news', 'showhometext', '1'),
('en', 'news', 'showtooltip', '1'),
('en', 'news', 'socialbutton', 'facebook,twitter'),
('en', 'news', 'sortcomm', '0'),
('en', 'news', 'st_links', '10'),
('en', 'news', 'structure_upload', 'Ym'),
('en', 'news', 'tags_alias', '0'),
('en', 'news', 'tags_remind', '1'),
('en', 'news', 'timecheckstatus', '0'),
('en', 'news', 'timeoutcomm', '360'),
('en', 'news', 'tooltip_length', '150'),
('en', 'news', 'tooltip_position', 'bottom'),
('en', 'news', 'view_comm', '6'),
('en', 'page', 'activecomm', '0'),
('en', 'page', 'adminscomm', ''),
('en', 'page', 'allowattachcomm', '0'),
('en', 'page', 'allowed_comm', '-1'),
('en', 'page', 'alloweditorcomm', '0'),
('en', 'page', 'auto_postcomm', '1'),
('en', 'page', 'captcha_area_comm', '1'),
('en', 'page', 'emailcomm', '0'),
('en', 'page', 'perpagecomm', '5'),
('en', 'page', 'setcomm', '4'),
('en', 'page', 'sortcomm', '0'),
('en', 'page', 'timeoutcomm', '360'),
('en', 'page', 'view_comm', '6'),
('en', 'seotools', 'prcservice', ''),
('en', 'siteterms', 'activecomm', '0'),
('en', 'siteterms', 'adminscomm', ''),
('en', 'siteterms', 'allowattachcomm', '0'),
('en', 'siteterms', 'allowed_comm', '-1'),
('en', 'siteterms', 'alloweditorcomm', '0'),
('en', 'siteterms', 'auto_postcomm', '1'),
('en', 'siteterms', 'captcha_area_comm', '1'),
('en', 'siteterms', 'emailcomm', '0'),
('en', 'siteterms', 'perpagecomm', '5'),
('en', 'siteterms', 'setcomm', '4'),
('en', 'siteterms', 'sortcomm', '0'),
('en', 'siteterms', 'timeoutcomm', '360'),
('en', 'siteterms', 'view_comm', '6'),
('en', 'voting', 'captcha_type', 'captcha'),
('en', 'voting', 'difftimeout', '3600'),
('sys', 'banners', 'captcha_type', 'captcha'),
('sys', 'define', 'nv_allowed_html_tags', 'embed, object, param, a, b, blockquote, br, caption, col, colgroup, div, em, h1, h2, h3, h4, h5, h6, hr, i, img, li, p, span, strong, s, sub, sup, table, tbody, td, th, tr, u, ul, ol, iframe, figure, figcaption, video, audio, source, track, code, pre, mark'),
('sys', 'define', 'nv_anti_agent', '0'),
('sys', 'define', 'nv_anti_iframe', '1'),
('sys', 'define', 'nv_debug', '1'),
('sys', 'define', 'nv_gfx_height', '40'),
('sys', 'define', 'nv_gfx_num', '6'),
('sys', 'define', 'nv_gfx_width', '150'),
('sys', 'define', 'nv_live_cookie_time', '31104000'),
('sys', 'define', 'nv_live_session_time', '0'),
('sys', 'define', 'nv_max_height', '1500'),
('sys', 'define', 'nv_max_width', '1500'),
('sys', 'define', 'nv_mobile_mode_img', '480'),
('sys', 'global', 'admfirewall', '0'),
('sys', 'global', 'admin_2step_default', 'code'),
('sys', 'global', 'admin_2step_opt', 'code'),
('sys', 'global', 'admin_check_pass_time', '1800'),
('sys', 'global', 'admin_login_duration', '10800'),
('sys', 'global', 'admin_rewrite', '0'),
('sys', 'global', 'admin_user_logout', '0'),
('sys', 'global', 'admin_XSSsanitize', '1'),
('sys', 'global', 'allow_null_origin', '0'),
('sys', 'global', 'allow_sitelangs', 'en'),
('sys', 'global', 'api_check_time', '5'),
('sys', 'global', 'assets_cdn', '0'),
('sys', 'global', 'authors_detail_main', '0'),
('sys', 'global', 'auto_acao', '1'),
('sys', 'global', 'autocheckupdate', '1'),
('sys', 'global', 'autoupdatetime', '24'),
('sys', 'global', 'blank_operation', '1'),
('sys', 'global', 'block_admin_ip', '0'),
('sys', 'global', 'cdn_url', ''),
('sys', 'global', 'check_zaloip_expired', '0'),
('sys', 'global', 'closed_site', '0'),
('sys', 'global', 'cookie_httponly', '1'),
('sys', 'global', 'cookie_notice_popup', '0'),
('sys', 'global', 'cookie_prefix', 'nv4'),
('sys', 'global', 'cookie_SameSite', 'Lax'),
('sys', 'global', 'cookie_secure', '0'),
('sys', 'global', 'cookie_share', '0'),
('sys', 'global', 'crossadmin_restrict', '1'),
('sys', 'global', 'crossadmin_valid_domains', ''),
('sys', 'global', 'crossadmin_valid_ips', ''),
('sys', 'global', 'crosssite_allowed_variables', ''),
('sys', 'global', 'crosssite_restrict', '1'),
('sys', 'global', 'crosssite_valid_domains', ''),
('sys', 'global', 'crosssite_valid_ips', ''),
('sys', 'global', 'display_errors_list', '1'),
('sys', 'global', 'domains_restrict', '1'),
('sys', 'global', 'domains_whitelist', '[\"youtube.com\",\"www.youtube.com\",\"google.com\",\"www.google.com\",\"drive.google.com\",\"docs.google.com\",\"view.officeapps.live.com\"]'),
('sys', 'global', 'dump_autobackup', '0'),
('sys', 'global', 'dump_backup_day', '30'),
('sys', 'global', 'dump_backup_ext', 'gz'),
('sys', 'global', 'dump_interval', '1'),
('sys', 'global', 'end_url_variables', ''),
('sys', 'global', 'error_send_email', 'you@example.com'),
('sys', 'global', 'error_separate_file', '0'),
('sys', 'global', 'error_set_logs', '1'),
('sys', 'global', 'file_allowed_ext', 'adobe,archives,audio,documents,images,real,video'),
('sys', 'global', 'forbid_extensions', 'htm,html,htmls,js,php,php3,php4,php5,phtml,inc'),
('sys', 'global', 'forbid_mimes', 'application/ecmascript,application/javascript,application/x-javascript,text/ecmascript,text/html,text/javascript,application/x-httpd-php,application/x-httpd-php-source,application/php,application/x-php,text/php,text/x-php'),
('sys', 'global', 'ftp_check_login', '0'),
('sys', 'global', 'ftp_path', '/'),
('sys', 'global', 'ftp_port', '21'),
('sys', 'global', 'ftp_server', 'localhost'),
('sys', 'global', 'ftp_user_name', ''),
('sys', 'global', 'ftp_user_pass', 'Z3mdzB7BV403yvMn-i9OMw,,'),
('sys', 'global', 'gzip_method', '1'),
('sys', 'global', 'ip_allow_null_origin', ''),
('sys', 'global', 'is_flood_blocker', '1'),
('sys', 'global', 'is_login_blocker', '1'),
('sys', 'global', 'lang_geo', '0'),
('sys', 'global', 'lang_multi', '0'),
('sys', 'global', 'load_files_seccode', ''),
('sys', 'global', 'login_number_tracking', '5'),
('sys', 'global', 'login_time_ban', '30'),
('sys', 'global', 'login_time_tracking', '5'),
('sys', 'global', 'max_requests_300', '150'),
('sys', 'global', 'max_requests_60', '40'),
('sys', 'global', 'my_domains', 'localhost'),
('sys', 'global', 'notification_active', '1'),
('sys', 'global', 'notification_autodel', '15'),
('sys', 'global', 'nv_auto_resize', '1'),
('sys', 'global', 'nv_display_errors_list', '1'),
('sys', 'global', 'nv_max_size', '41943040'),
('sys', 'global', 'nv_overflow_size', '0'),
('sys', 'global', 'nv_static_url', ''),
('sys', 'global', 'passshow_button', '0'),
('sys', 'global', 'proxy_blocker', '0'),
('sys', 'global', 'read_type', '0'),
('sys', 'global', 'recaptcha_secretkey', ''),
('sys', 'global', 'recaptcha_sitekey', ''),
('sys', 'global', 'recaptcha_type', 'image'),
('sys', 'global', 'recaptcha_ver', '2'),
('sys', 'global', 'region', ''),
('sys', 'global', 'remote_api_access', '0'),
('sys', 'global', 'request_uri_check', 'page'),
('sys', 'global', 'resource_preload', '2'),
('sys', 'global', 'rewrite_enable', '0'),
('sys', 'global', 'rewrite_endurl', '/'),
('sys', 'global', 'rewrite_exturl', '.html'),
('sys', 'global', 'rewrite_op_mod', ''),
('sys', 'global', 'rewrite_optional', '0'),
('sys', 'global', 'session_prefix', 'nv4s_g6KUaN'),
('sys', 'global', 'site_keywords', 'NukeViet, portal, mysql, php'),
('sys', 'global', 'site_lang', 'en'),
('sys', 'global', 'site_reopening_time', '0'),
('sys', 'global', 'site_timezone', 'byCountry'),
('sys', 'global', 'spadmin_add_admin', '1'),
('sys', 'global', 'static_noquerystring', '0'),
('sys', 'global', 'str_referer_blocker', '0'),
('sys', 'global', 'timestamp', '1759423352'),
('sys', 'global', 'turnstile_secretkey', ''),
('sys', 'global', 'turnstile_sitekey', ''),
('sys', 'global', 'two_step_verification', '0'),
('sys', 'global', 'unsign_vietwords', '1'),
('sys', 'global', 'upload_alt_require', '1'),
('sys', 'global', 'upload_auto_alt', '1'),
('sys', 'global', 'upload_checking_mode', 'strong'),
('sys', 'global', 'upload_chunk_size', '0'),
('sys', 'global', 'useactivate', '2'),
('sys', 'global', 'users_special', '0'),
('sys', 'global', 'version', '5.0.00'),
('sys', 'global', 'XSSsanitize', '1'),
('sys', 'global', 'zaloWebhookIPs', ''),
('sys', 'site', 'admin_theme', 'admin_default'),
('sys', 'site', 'allowloginchange', '0'),
('sys', 'site', 'allowmailchange', '1'),
('sys', 'site', 'allowquestion', '0'),
('sys', 'site', 'allowuserlogin', '1'),
('sys', 'site', 'allowuserloginmulti', '0'),
('sys', 'site', 'allowuserpublic', '1'),
('sys', 'site', 'allowuserreg', '2'),
('sys', 'site', 'auto_login_after_reg', '1'),
('sys', 'site', 'breadcrumblist', '0'),
('sys', 'site', 'captcha_area', 'r,m,p'),
('sys', 'site', 'captcha_type', 'captcha'),
('sys', 'site', 'cronjobs_interval', '5'),
('sys', 'site', 'cronjobs_last_time', '1762418695'),
('sys', 'site', 'cronjobs_launcher', 'system'),
('sys', 'site', 'description_length', '170'),
('sys', 'site', 'dir_forum', ''),
('sys', 'site', 'email_dot_equivalent', '1'),
('sys', 'site', 'email_plus_equivalent', '1'),
('sys', 'site', 'facebook_client_id', ''),
('sys', 'site', 'facebook_client_secret', ''),
('sys', 'site', 'google_client_id', ''),
('sys', 'site', 'google_client_secret', ''),
('sys', 'site', 'google_tag_manager', ''),
('sys', 'site', 'googleAnalytics4ID', ''),
('sys', 'site', 'googleAnalyticsID', ''),
('sys', 'site', 'googleAnalyticsMethod', 'classic'),
('sys', 'site', 'googleAnalyticsSetDomainName', '0'),
('sys', 'site', 'inform_active', '1'),
('sys', 'site', 'inform_default_exp', '604800'),
('sys', 'site', 'inform_exp_del', '604800'),
('sys', 'site', 'inform_max_characters', '200'),
('sys', 'site', 'inform_numrows', '10'),
('sys', 'site', 'inform_refresh_time', '30'),
('sys', 'site', 'is_user_forum', '0'),
('sys', 'site', 'localbusiness', '0'),
('sys', 'site', 'login_name_type', 'username'),
('sys', 'site', 'max_user_admin', '0'),
('sys', 'site', 'max_user_number', '0'),
('sys', 'site', 'metaTagsOgp', '1'),
('sys', 'site', 'nv_csp', '{\"default-src\":{\"self\":1},\"script-src\":{\"self\":1,\"unsafe-inline\":1,\"unsafe-eval\":1,\"hosts\":[\"*.google.com\",\"*.google-analytics.com\",\"*.googletagmanager.com\",\"*.gstatic.com\",\"*.facebook.com\",\"*.facebook.net\",\"*.twitter.com\",\"*.zalo.me\",\"*.zaloapp.com\",\"*.tawk.to\",\"*.cloudflareinsights.com\",\"*.cloudflare.com\"]},\"style-src\":{\"self\":1,\"data\":1,\"unsafe-inline\":1,\"hosts\":[\"*.google.com\",\"*.googleapis.com\",\"*.tawk.to\"]},\"img-src\":{\"self\":1,\"data\":1,\"hosts\":[\"*.twitter.com\",\"*.google.com\",\"*.googleapis.com\",\"*.google-analytics.com\",\"*.gstatic.com\",\"*.facebook.com\",\"tawk.link\",\"*.tawk.to\",\"static.nukeviet.vn\"]},\"font-src\":{\"self\":1,\"data\":1,\"hosts\":[\"*.googleapis.com\",\"*.gstatic.com\",\"*.tawk.to\"]},\"connect-src\":{\"self\":1,\"hosts\":[\"*.google-analytics.com\",\"*.zalo.me\",\"*.tawk.to\",\"wss://*.tawk.to\"]},\"media-src\":{\"self\":1,\"hosts\":[\"*.tawk.to\"]},\"frame-src\":{\"self\":1,\"hosts\":[\"*.google.com\",\"*.youtube.com\",\"*.facebook.com\",\"*.facebook.net\",\"*.twitter.com\",\"*.zalo.me\",\"*.live.com\",\"*.cloudflare.com\"]},\"form-action\":{\"self\":1,\"hosts\":[\"*.google.com\"]}}'),
('sys', 'site', 'nv_csp_act', '1'),
('sys', 'site', 'nv_csp_script_nonce', '0'),
('sys', 'site', 'nv_fp', 'accelerometer \'self\'; autoplay \'self\' https://youtube.com https://www.youtube.com; camera \'self\'; display-capture \'self\'; encrypted-media \'self\'; fullscreen \'self\' https://youtube.com https://www.youtube.com; gamepad \'self\'; geolocation \'self\'; gyroscope \'self\'; hid \'self\'; identity-credentials-get \'self\'; idle-detection \'self\'; local-fonts \'self\'; magnetometer \'self\'; microphone \'self\'; midi \'self\'; otp-credentials \'self\'; payment \'self\'; picture-in-picture \'self\' https://youtube.com https://www.youtube.com; publickey-credentials-get \'self\'; screen-wake-lock \'self\'; serial \'self\'; storage-access \'self\'; usb \'self\'; web-share \'self\'; window-management \'self\'; xr-spatial-tracking \'self\''),
('sys', 'site', 'nv_fp_act', '1'),
('sys', 'site', 'nv_pp', 'accelerometer=(self), autoplay=(self \"https://youtube.com\" \"https://www.youtube.com\" \"https://*.youtube.com\"), camera=(self), display-capture=(self), encrypted-media=(self), fullscreen=(self \"https://youtube.com\" \"https://www.youtube.com\" \"https://*.youtube.com\"), gamepad=(self), geolocation=(self), gyroscope=(self), hid=(self), identity-credentials-get=(self), idle-detection=(self), local-fonts=(self), magnetometer=(self), microphone=(self), midi=(self), otp-credentials=(self), payment=(self), picture-in-picture=(self \"https://youtube.com\" \"https://www.youtube.com\" \"https://*.youtube.com\" \"https://*.cloudflare.com\"), publickey-credentials-get=(self), screen-wake-lock=(self), serial=(self), storage-access=(self), usb=(self), web-share=(self), window-management=(self), xr-spatial-tracking=(self)'),
('sys', 'site', 'nv_pp_act', '1'),
('sys', 'site', 'nv_rp', 'no-referrer-when-downgrade, strict-origin-when-cross-origin'),
('sys', 'site', 'nv_rp_act', '1'),
('sys', 'site', 'nv_unick_type', '4'),
('sys', 'site', 'nv_unickmax', '20'),
('sys', 'site', 'nv_unickmin', '4'),
('sys', 'site', 'nv_upass_type', '3'),
('sys', 'site', 'nv_upassmax', '32'),
('sys', 'site', 'nv_upassmin', '8'),
('sys', 'site', 'ogp_image', ''),
('sys', 'site', 'oldpass_num', '5'),
('sys', 'site', 'online_upd', '1'),
('sys', 'site', 'openid_processing', 'connect,create,auto'),
('sys', 'site', 'openid_servers', ''),
('sys', 'site', 'organization_logo', ''),
('sys', 'site', 'over_capacity', '0'),
('sys', 'site', 'pageTitleMode', 'pagetitle'),
('sys', 'site', 'pass_timeout', '0'),
('sys', 'site', 'private_site', '1'),
('sys', 'site', 'referer_blocker', '1'),
('sys', 'site', 'remove_2step_allow', '0'),
('sys', 'site', 'remove_2step_method', '0'),
('sys', 'site', 'searchEngineUniqueID', ''),
('sys', 'site', 'send_pass', '0'),
('sys', 'site', 'show_folder_size', '0'),
('sys', 'site', 'site_email', 'you@example.com'),
('sys', 'site', 'site_phone', ''),
('sys', 'site', 'sitelinks_search_box_schema', '1'),
('sys', 'site', 'ssl_https', '0'),
('sys', 'site', 'stat_excl_bot', '0'),
('sys', 'site', 'statistic', '1'),
('sys', 'site', 'statistics_timezone', 'Asia/Bangkok'),
('sys', 'site', 'thumb_max_height', '350'),
('sys', 'site', 'thumb_max_width', '350'),
('sys', 'site', 'user_check_pass_time', '1800'),
('sys', 'site', 'whoviewuser', '2'),
('sys', 'site', 'zaloAppID', ''),
('sys', 'site', 'zaloAppSecretKey', ''),
('sys', 'site', 'zaloOAAccessToken', ''),
('sys', 'site', 'zaloOAAccessTokenTime', '0'),
('sys', 'site', 'zaloOARefreshToken', ''),
('sys', 'site', 'zaloOASecretKey', ''),
('sys', 'site', 'zaloOfficialAccountID', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_cookies`
--

CREATE TABLE `nv5_cookies` (
  `name` varchar(50) NOT NULL DEFAULT '',
  `value` mediumtext NOT NULL,
  `domain` varchar(100) NOT NULL DEFAULT '',
  `path` varchar(100) NOT NULL DEFAULT '',
  `expires` int(11) NOT NULL DEFAULT 0,
  `secure` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cookie truy cập kho store';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_counter`
--

CREATE TABLE `nv5_counter` (
  `c_type` varchar(100) NOT NULL,
  `c_val` varchar(100) NOT NULL,
  `last_update` int(11) NOT NULL DEFAULT 0,
  `c_count` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `en_count` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thống kê truy cập';

--
-- Dumping data for table `nv5_counter`
--

INSERT INTO `nv5_counter` (`c_type`, `c_val`, `last_update`, `c_count`, `en_count`) VALUES
('bot', 'bingbot', 0, 0, 0),
('bot', 'coccocbot', 0, 0, 0),
('bot', 'googlebot', 0, 0, 0),
('bot', 'msnbot', 0, 0, 0),
('bot', 'w3cvalidator', 0, 0, 0),
('bot', 'yahooslurp', 0, 0, 0),
('browser', 'amaya', 0, 0, 0),
('browser', 'android', 0, 0, 0),
('browser', 'bingbot', 0, 0, 0),
('browser', 'blackberry', 0, 0, 0),
('browser', 'bots', 0, 0, 0),
('browser', 'chrome', 1762418704, 65, 65),
('browser', 'coccoc', 0, 0, 0),
('browser', 'coccocbot', 0, 0, 0),
('browser', 'edge', 0, 0, 0),
('browser', 'explorer', 0, 0, 0),
('browser', 'firebird', 0, 0, 0),
('browser', 'firefox', 0, 0, 0),
('browser', 'galeon', 0, 0, 0),
('browser', 'googlebot', 0, 0, 0),
('browser', 'icab', 0, 0, 0),
('browser', 'icecat', 0, 0, 0),
('browser', 'iceweasel', 0, 0, 0),
('browser', 'ipad', 0, 0, 0),
('browser', 'iphone', 0, 0, 0),
('browser', 'ipod', 0, 0, 0),
('browser', 'konqueror', 0, 0, 0),
('browser', 'lynx', 0, 0, 0),
('browser', 'Mobile', 0, 0, 0),
('browser', 'mozilla', 0, 0, 0),
('browser', 'msn', 0, 0, 0),
('browser', 'msnbot', 0, 0, 0),
('browser', 'netpositive', 0, 0, 0),
('browser', 'netscape', 0, 0, 0),
('browser', 'nokia', 0, 0, 0),
('browser', 'nokias60', 0, 0, 0),
('browser', 'omniweb', 0, 0, 0),
('browser', 'opera', 0, 0, 0),
('browser', 'operamini', 0, 0, 0),
('browser', 'phoenix', 0, 0, 0),
('browser', 'pocket', 0, 0, 0),
('browser', 'safari', 0, 0, 0),
('browser', 'shiretoko', 0, 0, 0),
('browser', 'Unknown', 0, 0, 0),
('browser', 'w3cvalidator', 0, 0, 0),
('browser', 'webtv', 0, 0, 0),
('browser', 'yahooslurp', 0, 0, 0),
('c_time', 'last', 0, 1762418704, 0),
('c_time', 'start', 0, 0, 0),
('country', 'AD', 0, 0, 0),
('country', 'AE', 0, 0, 0),
('country', 'AF', 0, 0, 0),
('country', 'AG', 0, 0, 0),
('country', 'AI', 0, 0, 0),
('country', 'AL', 0, 0, 0),
('country', 'AM', 0, 0, 0),
('country', 'AN', 0, 0, 0),
('country', 'AO', 0, 0, 0),
('country', 'AQ', 0, 0, 0),
('country', 'AR', 0, 0, 0),
('country', 'AS', 0, 0, 0),
('country', 'AT', 0, 0, 0),
('country', 'AU', 0, 0, 0),
('country', 'AW', 0, 0, 0),
('country', 'AZ', 0, 0, 0),
('country', 'BA', 0, 0, 0),
('country', 'BB', 0, 0, 0),
('country', 'BD', 0, 0, 0),
('country', 'BE', 0, 0, 0),
('country', 'BF', 0, 0, 0),
('country', 'BG', 0, 0, 0),
('country', 'BH', 0, 0, 0),
('country', 'BI', 0, 0, 0),
('country', 'BJ', 0, 0, 0),
('country', 'BM', 0, 0, 0),
('country', 'BN', 0, 0, 0),
('country', 'BO', 0, 0, 0),
('country', 'BR', 0, 0, 0),
('country', 'BS', 0, 0, 0),
('country', 'BT', 0, 0, 0),
('country', 'BW', 0, 0, 0),
('country', 'BY', 0, 0, 0),
('country', 'BZ', 0, 0, 0),
('country', 'CA', 0, 0, 0),
('country', 'CD', 0, 0, 0),
('country', 'CF', 0, 0, 0),
('country', 'CG', 0, 0, 0),
('country', 'CH', 0, 0, 0),
('country', 'CI', 0, 0, 0),
('country', 'CK', 0, 0, 0),
('country', 'CL', 0, 0, 0),
('country', 'CM', 0, 0, 0),
('country', 'CN', 0, 0, 0),
('country', 'CO', 0, 0, 0),
('country', 'CR', 0, 0, 0),
('country', 'CS', 0, 0, 0),
('country', 'CU', 0, 0, 0),
('country', 'CV', 0, 0, 0),
('country', 'CY', 0, 0, 0),
('country', 'CZ', 0, 0, 0),
('country', 'DE', 0, 0, 0),
('country', 'DJ', 0, 0, 0),
('country', 'DK', 0, 0, 0),
('country', 'DM', 0, 0, 0),
('country', 'DO', 0, 0, 0),
('country', 'DZ', 0, 0, 0),
('country', 'EC', 0, 0, 0),
('country', 'EE', 0, 0, 0),
('country', 'EG', 0, 0, 0),
('country', 'ER', 0, 0, 0),
('country', 'ES', 0, 0, 0),
('country', 'ET', 0, 0, 0),
('country', 'EU', 0, 0, 0),
('country', 'FI', 0, 0, 0),
('country', 'FJ', 0, 0, 0),
('country', 'FK', 0, 0, 0),
('country', 'FM', 0, 0, 0),
('country', 'FO', 0, 0, 0),
('country', 'FR', 0, 0, 0),
('country', 'GA', 0, 0, 0),
('country', 'GB', 0, 0, 0),
('country', 'GD', 0, 0, 0),
('country', 'GE', 0, 0, 0),
('country', 'GF', 0, 0, 0),
('country', 'GH', 0, 0, 0),
('country', 'GI', 0, 0, 0),
('country', 'GL', 0, 0, 0),
('country', 'GM', 0, 0, 0),
('country', 'GN', 0, 0, 0),
('country', 'GP', 0, 0, 0),
('country', 'GQ', 0, 0, 0),
('country', 'GR', 0, 0, 0),
('country', 'GS', 0, 0, 0),
('country', 'GT', 0, 0, 0),
('country', 'GU', 0, 0, 0),
('country', 'GW', 0, 0, 0),
('country', 'GY', 0, 0, 0),
('country', 'HK', 0, 0, 0),
('country', 'HN', 0, 0, 0),
('country', 'HR', 0, 0, 0),
('country', 'HT', 0, 0, 0),
('country', 'HU', 0, 0, 0),
('country', 'ID', 0, 0, 0),
('country', 'IE', 0, 0, 0),
('country', 'IL', 0, 0, 0),
('country', 'IN', 0, 0, 0),
('country', 'IO', 0, 0, 0),
('country', 'IQ', 0, 0, 0),
('country', 'IR', 0, 0, 0),
('country', 'IS', 0, 0, 0),
('country', 'IT', 0, 0, 0),
('country', 'JM', 0, 0, 0),
('country', 'JO', 0, 0, 0),
('country', 'JP', 0, 0, 0),
('country', 'KE', 0, 0, 0),
('country', 'KG', 0, 0, 0),
('country', 'KH', 0, 0, 0),
('country', 'KI', 0, 0, 0),
('country', 'KM', 0, 0, 0),
('country', 'KN', 0, 0, 0),
('country', 'KR', 0, 0, 0),
('country', 'KW', 0, 0, 0),
('country', 'KY', 0, 0, 0),
('country', 'KZ', 0, 0, 0),
('country', 'LA', 0, 0, 0),
('country', 'LB', 0, 0, 0),
('country', 'LC', 0, 0, 0),
('country', 'LI', 0, 0, 0),
('country', 'LK', 0, 0, 0),
('country', 'LR', 0, 0, 0),
('country', 'LS', 0, 0, 0),
('country', 'LT', 0, 0, 0),
('country', 'LU', 0, 0, 0),
('country', 'LV', 0, 0, 0),
('country', 'LY', 0, 0, 0),
('country', 'MA', 0, 0, 0),
('country', 'MC', 0, 0, 0),
('country', 'MD', 0, 0, 0),
('country', 'MG', 0, 0, 0),
('country', 'MH', 0, 0, 0),
('country', 'MK', 0, 0, 0),
('country', 'ML', 0, 0, 0),
('country', 'MM', 0, 0, 0),
('country', 'MN', 0, 0, 0),
('country', 'MO', 0, 0, 0),
('country', 'MP', 0, 0, 0),
('country', 'MQ', 0, 0, 0),
('country', 'MR', 0, 0, 0),
('country', 'MT', 0, 0, 0),
('country', 'MU', 0, 0, 0),
('country', 'MV', 0, 0, 0),
('country', 'MW', 0, 0, 0),
('country', 'MX', 0, 0, 0),
('country', 'MY', 0, 0, 0),
('country', 'MZ', 0, 0, 0),
('country', 'NA', 0, 0, 0),
('country', 'NC', 0, 0, 0),
('country', 'NE', 0, 0, 0),
('country', 'NF', 0, 0, 0),
('country', 'NG', 0, 0, 0),
('country', 'NI', 0, 0, 0),
('country', 'NL', 0, 0, 0),
('country', 'NO', 0, 0, 0),
('country', 'NP', 0, 0, 0),
('country', 'NR', 0, 0, 0),
('country', 'NU', 0, 0, 0),
('country', 'NZ', 0, 0, 0),
('country', 'OM', 0, 0, 0),
('country', 'PA', 0, 0, 0),
('country', 'PE', 0, 0, 0),
('country', 'PF', 0, 0, 0),
('country', 'PG', 0, 0, 0),
('country', 'PH', 0, 0, 0),
('country', 'PK', 0, 0, 0),
('country', 'PL', 0, 0, 0),
('country', 'PR', 0, 0, 0),
('country', 'PS', 0, 0, 0),
('country', 'PT', 0, 0, 0),
('country', 'PW', 0, 0, 0),
('country', 'PY', 0, 0, 0),
('country', 'QA', 0, 0, 0),
('country', 'RE', 0, 0, 0),
('country', 'RO', 0, 0, 0),
('country', 'RU', 0, 0, 0),
('country', 'RW', 0, 0, 0),
('country', 'SA', 0, 0, 0),
('country', 'SB', 0, 0, 0),
('country', 'SC', 0, 0, 0),
('country', 'SD', 0, 0, 0),
('country', 'SE', 0, 0, 0),
('country', 'SG', 0, 0, 0),
('country', 'SI', 0, 0, 0),
('country', 'SK', 0, 0, 0),
('country', 'SL', 0, 0, 0),
('country', 'SM', 0, 0, 0),
('country', 'SN', 0, 0, 0),
('country', 'SO', 0, 0, 0),
('country', 'SR', 0, 0, 0),
('country', 'ST', 0, 0, 0),
('country', 'SV', 0, 0, 0),
('country', 'SY', 0, 0, 0),
('country', 'SZ', 0, 0, 0),
('country', 'TD', 0, 0, 0),
('country', 'TF', 0, 0, 0),
('country', 'TG', 0, 0, 0),
('country', 'TH', 0, 0, 0),
('country', 'TJ', 0, 0, 0),
('country', 'TK', 0, 0, 0),
('country', 'TL', 0, 0, 0),
('country', 'TM', 0, 0, 0),
('country', 'TN', 0, 0, 0),
('country', 'TO', 0, 0, 0),
('country', 'TR', 0, 0, 0),
('country', 'TT', 0, 0, 0),
('country', 'TV', 0, 0, 0),
('country', 'TW', 0, 0, 0),
('country', 'TZ', 0, 0, 0),
('country', 'UA', 0, 0, 0),
('country', 'UG', 0, 0, 0),
('country', 'unkown', 0, 0, 0),
('country', 'US', 0, 0, 0),
('country', 'UY', 0, 0, 0),
('country', 'UZ', 0, 0, 0),
('country', 'VA', 0, 0, 0),
('country', 'VC', 0, 0, 0),
('country', 'VE', 0, 0, 0),
('country', 'VG', 0, 0, 0),
('country', 'VI', 0, 0, 0),
('country', 'VN', 0, 0, 0),
('country', 'VU', 0, 0, 0),
('country', 'WS', 0, 0, 0),
('country', 'YE', 0, 0, 0),
('country', 'YT', 0, 0, 0),
('country', 'YU', 0, 0, 0),
('country', 'ZA', 0, 0, 0),
('country', 'ZM', 0, 0, 0),
('country', 'ZW', 0, 0, 0),
('country', 'ZZ', 1762418704, 88, 88),
('day', '01', 1761992931, 1, 1),
('day', '02', 1759423465, 0, 0),
('day', '03', 1762159883, 2, 2),
('day', '04', 1759567884, 0, 0),
('day', '05', 1762350755, 2, 2),
('day', '06', 1762418704, 1, 1),
('day', '07', 0, 0, 0),
('day', '08', 1759918654, 0, 0),
('day', '09', 1759989622, 0, 0),
('day', '10', 0, 0, 0),
('day', '11', 1760175969, 0, 0),
('day', '12', 0, 0, 0),
('day', '13', 1760349283, 0, 0),
('day', '14', 0, 0, 0),
('day', '15', 0, 0, 0),
('day', '16', 0, 0, 0),
('day', '17', 1760715648, 0, 0),
('day', '18', 1760722268, 0, 0),
('day', '19', 1760816389, 0, 0),
('day', '20', 1760974027, 0, 0),
('day', '21', 1760985581, 0, 0),
('day', '22', 0, 0, 0),
('day', '23', 0, 0, 0),
('day', '24', 0, 0, 0),
('day', '25', 1761384017, 0, 0),
('day', '26', 0, 0, 0),
('day', '27', 1761565820, 0, 0),
('day', '28', 0, 0, 0),
('day', '29', 0, 0, 0),
('day', '30', 1761843454, 0, 0),
('day', '31', 1761929262, 0, 0),
('dayofweek', 'Friday', 1761929262, 42, 42),
('dayofweek', 'Monday', 1762159883, 13, 13),
('dayofweek', 'Saturday', 1761992931, 16, 16),
('dayofweek', 'Sunday', 1760816389, 2, 2),
('dayofweek', 'Thursday', 1762418704, 9, 9),
('dayofweek', 'Tuesday', 1760985581, 3, 3),
('dayofweek', 'Wednesday', 1762350755, 3, 3),
('hour', '00', 1760722268, 0, 0),
('hour', '01', 1760985581, 0, 0),
('hour', '02', 1760816389, 0, 0),
('hour', '03', 0, 0, 0),
('hour', '04', 0, 0, 0),
('hour', '05', 0, 0, 0),
('hour', '06', 0, 0, 0),
('hour', '07', 0, 0, 0),
('hour', '08', 1759972840, 0, 0),
('hour', '09', 1761360288, 0, 0),
('hour', '10', 1761364062, 0, 0),
('hour', '11', 1761885420, 0, 0),
('hour', '12', 0, 0, 0),
('hour', '13', 1759989622, 0, 0),
('hour', '14', 1761378582, 0, 0),
('hour', '15', 1762418704, 1, 1),
('hour', '16', 1761904351, 0, 0),
('hour', '17', 1761992931, 0, 0),
('hour', '18', 1761565820, 0, 0),
('hour', '19', 0, 0, 0),
('hour', '20', 1762350755, 0, 0),
('hour', '21', 1761921553, 0, 0),
('hour', '22', 1761923353, 0, 0),
('hour', '23', 1761929262, 0, 0),
('month', 'Apr', 0, 0, 0),
('month', 'Aug', 0, 0, 0),
('month', 'Dec', 0, 0, 0),
('month', 'Feb', 0, 0, 0),
('month', 'Jan', 0, 0, 0),
('month', 'Jul', 0, 0, 0),
('month', 'Jun', 0, 0, 0),
('month', 'Mar', 0, 0, 0),
('month', 'May', 0, 0, 0),
('month', 'Nov', 1762418704, 6, 6),
('month', 'Oct', 1761929262, 82, 82),
('month', 'Sep', 0, 0, 0),
('os', 'android', 0, 0, 0),
('os', 'apple', 0, 0, 0),
('os', 'beos', 0, 0, 0),
('os', 'blackberry', 0, 0, 0),
('os', 'freebsd', 0, 0, 0),
('os', 'ipad', 0, 0, 0),
('os', 'iphone', 0, 0, 0),
('os', 'ipod', 0, 0, 0),
('os', 'irix', 0, 0, 0),
('os', 'linux', 1762418704, 65, 65),
('os', 'netbsd', 0, 0, 0),
('os', 'nokia', 0, 0, 0),
('os', 'openbsd', 0, 0, 0),
('os', 'opensolaris', 0, 0, 0),
('os', 'os2', 0, 0, 0),
('os', 'palm', 0, 0, 0),
('os', 'sunos', 0, 0, 0),
('os', 'unknown', 0, 0, 0),
('os', 'win', 0, 0, 0),
('os', 'win10', 0, 0, 0),
('os', 'win2000', 0, 0, 0),
('os', 'win2003', 0, 0, 0),
('os', 'win7', 0, 0, 0),
('os', 'win8', 0, 0, 0),
('os', 'wince', 0, 0, 0),
('os', 'winvista', 0, 0, 0),
('os', 'winxp', 0, 0, 0),
('total', 'hits', 1762418704, 88, 88),
('year', '2025', 1762418704, 88, 88),
('year', '2026', 0, 0, 0),
('year', '2027', 0, 0, 0),
('year', '2028', 0, 0, 0),
('year', '2029', 0, 0, 0),
('year', '2030', 0, 0, 0),
('year', '2031', 0, 0, 0),
('year', '2032', 0, 0, 0),
('year', '2033', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_cronjobs`
--

CREATE TABLE `nv5_cronjobs` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `start_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `inter_val` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `inter_val_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Lặp lại sau thời điểm bắt đầu thực tế, 1:lặp lại sau thời điểm bắt đầu trong CSDL',
  `run_file` varchar(255) NOT NULL,
  `run_func` varchar(255) NOT NULL,
  `params` varchar(255) DEFAULT NULL,
  `del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `is_sys` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `last_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_result` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `en_cron_name` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tiến trình tự động';

--
-- Dumping data for table `nv5_cronjobs`
--

INSERT INTO `nv5_cronjobs` (`id`, `start_time`, `inter_val`, `inter_val_type`, `run_file`, `run_func`, `params`, `del`, `is_sys`, `act`, `last_time`, `last_result`, `en_cron_name`) VALUES
(1, 1759423352, 5, 0, 'online_expired_del.php', 'cron_online_expired_del', '', 0, 1, 1, 1762418695, 1, 'Delete expired online status'),
(2, 1759423352, 1440, 0, 'dump_autobackup.php', 'cron_dump_autobackup', '', 0, 1, 1, 1762349018, 1, 'Automatic backup database'),
(3, 1759423352, 60, 0, 'temp_download_destroy.php', 'cron_auto_del_temp_download', '', 0, 1, 1, 1762418695, 1, 'Empty temporary files'),
(4, 1759423352, 30, 0, 'ip_logs_destroy.php', 'cron_del_ip_logs', '', 0, 1, 1, 1762418695, 1, 'Delete IP log files'),
(5, 1759423352, 1440, 0, 'error_log_destroy.php', 'cron_auto_del_error_log', '', 0, 1, 1, 1762349018, 1, 'Delete expired error_log log files'),
(6, 1759423352, 360, 0, 'error_log_sendmail.php', 'cron_auto_sendmail_error_log', '', 0, 1, 0, 0, 0, 'Send error logs to admin'),
(7, 1759423352, 60, 0, 'ref_expired_del.php', 'cron_ref_expired_del', '', 0, 1, 1, 1762418695, 1, 'Delete expired referer'),
(8, 1759423352, 60, 0, 'check_version.php', 'cron_auto_check_version', '', 0, 1, 1, 1762418695, 1, 'Check NukeViet version'),
(9, 1759423352, 1440, 0, 'notification_autodel.php', 'cron_notification_autodel', '', 0, 1, 1, 1762349018, 1, 'Delete old notification'),
(10, 1759423352, 1440, 0, 'remove_expired_inform.php', 'cron_remove_expired_inform', '', 0, 1, 1, 1762349018, 1, 'Remove expired notifications'),
(11, 1759423352, 60, 0, 'apilogs_autodel.php', 'cron_apilogs_autodel', '', 0, 1, 1, 1762418695, 1, 'Remove expired API-logs'),
(12, 1759423352, 60, 0, 'expadmin_handling.php', 'cron_expadmin_handling', '', 0, 1, 1, 1762418695, 1, 'Handling expired admins');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_dictionary_entries`
--

CREATE TABLE `nv5_dictionary_entries` (
  `id` int(11) UNSIGNED NOT NULL,
  `headword` varchar(128) NOT NULL,
  `slug` varchar(160) NOT NULL,
  `pos` varchar(16) DEFAULT '',
  `phonetic` varchar(64) DEFAULT '',
  `meaning_vi` text NOT NULL,
  `notes` text DEFAULT NULL,
  `audio_file` varchar(255) DEFAULT NULL,
  `created_at` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_dictionary_entries`
--

INSERT INTO `nv5_dictionary_entries` (`id`, `headword`, `slug`, `pos`, `phonetic`, `meaning_vi`, `notes`, `audio_file`, `created_at`, `updated_at`) VALUES
(1, 'hello', 'hello', 'interj.', '/ˈhɛləʊ/', 'Xin chào', '', '1_v74TXS4j.mp3', 1761904434, 1761962093),
(2, 'world', 'world', 'n.', '/wɜːld/', 'Thế giới', '', NULL, 1761904434, 1761919784),
(3, 'book', 'book', 'n.', '/bʊk/', 'Sách', '', '3_n9IsB7Me.mp3', 1761904434, 1761992925),
(4, 'computer', 'computer', 'n.', '/kəmˈpjuːtə(r)/', 'Máy tính', '', NULL, 1761904434, 1761904434),
(5, 'language', 'language', 'n.', '/ˈlæŋɡwɪdʒ/', 'Ngôn ngữ', '', '5_a17CbbHJ.mp3', 1761904434, 1762250201),
(6, 'translate', 'translate', 'v.', '/trænzˈleɪt/', 'Dịch', '', NULL, 1761904434, 1761904434),
(7, 'example', 'example', 'n.', '/ɪɡˈzɑːmpl/', 'Ví dụ', '', NULL, 1761904434, 1761904434),
(8, 'search', 'search', 'v.', '/sɜːtʃ/', 'Tìm kiếm', '', NULL, 1761904434, 1761904434),
(9, 'dictionary', 'dictionary', 'n.', '/ˈdɪkʃənri/', 'Từ điển', '', NULL, 1761904434, 1761904434),
(10, 'word', 'word', 'n.', '/wɜːd/', 'Từ', '', NULL, 1761904434, 1761904434);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_dictionary_examples`
--

CREATE TABLE `nv5_dictionary_examples` (
  `id` int(11) UNSIGNED NOT NULL,
  `entry_id` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `sentence_en` text NOT NULL,
  `translation_vi` text DEFAULT NULL,
  `audio_file` varchar(255) DEFAULT NULL,
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_dictionary_examples`
--

INSERT INTO `nv5_dictionary_examples` (`id`, `entry_id`, `sentence_en`, `translation_vi`, `audio_file`, `sort`, `created_at`) VALUES
(27, 1, 'She waved hello to her neighbors.', 'Cô ấy vẫy tay chào hàng xóm.', NULL, 2, 1761962093),
(29, 3, 'This book is very interesting.', 'Cuốn sách này rất thú vị.', NULL, 2, 1761992925),
(28, 3, 'I read a book every week.', 'Tôi đọc một cuốn sách mỗi tuần.', NULL, 1, 1761992925),
(5, 4, 'This computer is very fast.', 'Chiếc máy tính này rất nhanh.', NULL, 0, 1761904434),
(6, 4, 'He bought a new computer yesterday.', 'Anh ấy đã mua một chiếc máy tính mới hôm qua.', NULL, 0, 1761904434),
(7, 7, 'Here is an example sentence.', 'Đây là một câu ví dụ.', NULL, 0, 1761904434),
(8, 8, 'You can search the dictionary online.', 'Bạn có thể tìm kiếm từ điển trực tuyến.', NULL, 0, 1761904434),
(11, 2, 'a', 'b', NULL, 1, 1761919784),
(26, 1, 'Hello, how are you?', 'Xin chào, bạn khỏe không?', NULL, 1, 1761962093);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_emailtemplates`
--

CREATE TABLE `nv5_emailtemplates` (
  `emailid` mediumint(8) UNSIGNED NOT NULL,
  `lang` varchar(2) NOT NULL DEFAULT '' COMMENT 'Ngôn ngữ',
  `module_file` varchar(50) NOT NULL DEFAULT '' COMMENT 'Module file của email',
  `module_name` varchar(50) NOT NULL DEFAULT '' COMMENT 'Module name của email',
  `id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID mẫu theo module',
  `sys_pids` varchar(255) NOT NULL DEFAULT '' COMMENT 'Các plugin xử lý dữ liệu của hệ thống',
  `pids` varchar(255) NOT NULL DEFAULT '' COMMENT 'Các plugin xử lý dữ liệu',
  `catid` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `time_add` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Tạo lúc',
  `time_update` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cập nhật lúc',
  `send_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Tên người gửi',
  `send_email` varchar(255) NOT NULL DEFAULT '' COMMENT 'Email người gửi',
  `send_cc` text NOT NULL COMMENT 'CC Emails',
  `send_bcc` text NOT NULL COMMENT 'BCC Emails',
  `attachments` text NOT NULL COMMENT 'Đính kèm',
  `is_system` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Của hệ thống hay không',
  `is_plaintext` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Gửi dạng text thuần hay có định dạng',
  `is_disabled` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Đình chỉ gửi mail hay không',
  `is_selftemplate` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 thì không dùng template của giao diện, 0 thì dùng',
  `mailtpl` varchar(255) NOT NULL DEFAULT '' COMMENT 'Tên mẫu cứng trong file nếu chọn',
  `default_subject` varchar(250) NOT NULL DEFAULT '' COMMENT 'Tiêu đề email tất cả các ngôn ngữ',
  `default_content` mediumtext NOT NULL COMMENT 'Nội dung email tất cả các ngôn ngữ',
  `en_title` varchar(250) NOT NULL DEFAULT '',
  `en_subject` varchar(250) NOT NULL DEFAULT '',
  `en_content` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng mẫu email';

--
-- Dumping data for table `nv5_emailtemplates`
--

INSERT INTO `nv5_emailtemplates` (`emailid`, `lang`, `module_file`, `module_name`, `id`, `sys_pids`, `pids`, `catid`, `time_add`, `time_update`, `send_name`, `send_email`, `send_cc`, `send_bcc`, `attachments`, `is_system`, `is_plaintext`, `is_disabled`, `is_selftemplate`, `mailtpl`, `default_subject`, `default_content`, `en_title`, `en_subject`, `en_content`) VALUES
(1, '', '', '', 1, '4', '', 2, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Information from {$site_name} website', 'Administrator {$site_name} website notify:<br />Your administrator account in {$site_name} website deleted at {$time}{if not empty($note)}. Reason: {$note}{/if}.<br />If you have any questions... please email <a href=\"mailto:{$email}\">{$email}</a>{if not empty($username)}<br/><br/>{$sig}<br/><br/>{$username}<br/>{$position}<br/>{$email}{/if}', 'Notice that the administrator account has been deleted', '', ''),
(2, '', '', '', 2, '4', '', 2, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Information from {$site_name} website', 'Information from {$site_name} aministrators:<br />Your administrator account in {$site_name} is suspended at {$time} reason: {$note}.<br />If you have any questions... please email <a href=\"mailto:{$email}\">{$email}</a>{if not empty($username)}<br/><br/>{$sig}<br/><br/>{$username}<br/>{$position}<br/>{$email}{/if}', 'Notice of suspension of site administration', '', ''),
(3, '', '', '', 3, '4', '', 2, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Information from {$site_name} website', 'Information from {$site_name} aministrators:<br />Your administrator account in {$site_name} is reactive at {$time}.<br />Your account has been suspended before because: {$note}{if not empty($username)}<br/><br/>{$sig}<br/><br/>{$username}<br/>{$position}<br/>{$email}{/if}', 'Notice of reactivation of site administration', '', ''),
(4, '', '', '', 4, '4', '', 2, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Configuring 2-step verification using Oauth done', '{$greeting_user}<br /><br />Administration of the site {$site_name} would like to inform:<br />Two-step authentication using Oauth in the admin panel has been successfully installed. You can use the account <strong>{$oauth_id}</strong> of the provider <strong>{$oauth_name}</strong> for authentication when you log into the site admin area.', 'Notice that a new two-step authentication method has been added to the admin account', '', ''),
(5, '', '', '', 5, '4', '', 2, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Configuring Two-Step Authentication with Oauth has been canceled', '{$greeting_user}<br /><br />Administration of the site {$site_name} would like to inform:<br />At your request, 2-Step Verification using Oauth has been successfully canceled. From now on, you cannot use the accounts <strong>{$oauth_id}</strong> to authenticate in the site admin area.', 'Notification that all two-step authentication methods have been removed from the admin account', '', ''),
(6, '', '', '', 6, '4', '', 2, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Configuring Two-Step Authentication with Oauth has been canceled', '{$greeting_user}<br /><br />Administration of the site {$site_name} would like to inform:<br />At your request, 2-Step Verification using Oauth has been successfully canceled. From now on, you cannot use the account <strong>{$oauth_id}</strong> of the provider <strong>{$oauth_name}</strong> to authenticate in the site admin area.', 'Notice that two-step authentication has been removed from the admin account', '', ''),
(7, '', '', '', 7, '5', '', 1, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Error report from website {$site_name}', 'The system received some error messages. Please open the attached file for details.', 'Email auto-notification error', '', ''),
(8, '', '', '', 8, '5', '', 1, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Test email', 'This is a test email to check the mail configuration. Simply delete it!', 'Send test email to test email sending configuration', '', ''),
(1001, 'en', 'news', 'news', 1, '5', '', 4, 1759423352, 0, '', '', '', '', '', 0, 0, 0, 0, '', 'Message from {$from_name}', 'Hello!<br />Your friend {$from_name} would like to introduce to you the article “{$post_name}” on website {$site_name}{if not empty($message)} with the message:<br />{$message}{/if}.<br/>----------<br/><strong>{$post_name}</strong><br/>{$hometext}<br/><br/>You can view the full article by clicking on the link below:<br /><a href=\"{$link}\" title=\"{$post_name}\">{$link}</a>', 'Send an email introducing the article to friend at the news module', '', ''),
(1002, 'en', 'news', 'news', 2, '5', '', 4, 1759423352, 0, '', '', '', '', '', 0, 0, 0, 0, '', 'Thank you for submitting an error report', 'Hello!<br />{$site_name} website administration thank you very much for submitting an error report in the content of the article of our website. We fixed the error you reported.<br />Hope to receive your next help in the future. Wish you always healthy, happy and successful!', 'Email thanking the person who reported the error at module news', '', ''),
(1003, 'en', 'users', 'users', 1, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Activate information', '{$greeting_user}<br /><br />Your account at website {$site_name} waitting to activate. To activate, please click link follow:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br /><br />Account information:<br /><br />Username: {$username}<br />Email: {$email}<br /><br />Activate expired on {$active_deadline}<br /><br />This is email automatic sending from website {$site_name}.', 'Account activation via email', '', ''),
(1004, 'en', 'users', 'users', 2, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Email notification to delete account', '{$greeting_user}<br /><br />We are so sorry to delete your account at website {$site_name}.', 'Email notification to delete account', '', ''),
(1005, 'en', 'users', 'users', 3, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'New backup code', '{$greeting_user}<br /><br /> backup code to your account at the website {$site_name} has been changed. Here is a new backup code: <br /><br />{foreach from=$new_code item=code}{$code}<br />{/foreach}<br />You keep your backup safe. If you lose your phone and lose your backup code, you will no longer be able to access your account.<br /><br />This is an automated message sent to your e-mail from website {$site_name}. If you do not understand the content of this letter, simply delete it.', 'Send new backup code', '', ''),
(1006, 'en', 'users', 'users', 4, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Your account was created', '{$greeting_user}<br /><br />Your account at website {$site_name} activated. Your login information:<br /><br />Username: {$username}<br />Email: {$email}<br /><br />Please click the link below to log in:<br />URL: <a href=\"{$link}\">{$link}</a><br /><br />This is email automatic sending from website {$site_name}.', 'Notification that the account has been created when the member successfully registers in the form', '', ''),
(1007, 'en', 'users', 'users', 5, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Your account was created', '{$greeting_user}<br /><br />Your account at website {$site_name} activated. To log into your account please visit the page: <a href=\"{$link}\">{$link}</a> and press the button: Sign in with {$oauth_name}.<br /><br />This is email automatic sending from website {$site_name}.', 'Notification that the account has been created when the member successfully registers via Oauth', '', ''),
(1008, 'en', 'users', 'users', 6, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Your account was created', '{$greeting_user}<br /><br />Your account at website {$site_name} activated. Your login information:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Username: {$username}<br />Email: {$email}<br /><br />This is email automatic sending from website {$site_name}.', 'Notification of account created by group leader', '', ''),
(1009, 'en', 'users', 'users', 7, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Your account was created', '{$greeting_user}<br /><br />Your account at website {$site_name} has been created. Here are the logins:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Username: {$username}<br />Password: {$password}<br />{if $pass_reset gt 0 or $email_reset gt 0}<br />Note:<br />{if $pass_reset eq 2}- We recommend that you change your password before using the account.<br />{elseif $pass_reset eq 1}- You need to change your password before using the account.<br />{/if}{if $email_reset eq 2}- We recommend that you change your email before using the account.<br />{elseif $email_reset eq 1}- You need to change your email before using the account.<br />{/if}{/if}<br />This is an automated message sent to Your email box from website {$site_name}. If you do not understand the content of this letter, simply delete it.', 'Notification of account created by administrator', '', ''),
(1010, 'en', 'users', 'users', 8, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Safe mode verification code', '{$greeting_user}<br /><br />You sent a request using safe mode in website {$site_name}. Below is a verifykey  for activating or off safe mode:<br /><br /><strong>{$code}</strong><br /><br />This verifykey only works on-off safe mode once only. After you turn off safe mode, this verification code will be worthless.<br /><br />These are automatic messages sent to your e-mail inbox from website {$site_name}.', 'Send verification code when user turns on/ off safe mode', '', ''),
(1011, 'en', 'users', 'users', 9, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Update account infomation success', '{$greeting_user}<br /><br />Your account on the website {$site_name} has been updated {if $send_newvalue}with new {$label}: <strong>{$newvalue}</strong>{else}new {$label}{/if}.<br /><br />These are automatic messages sent to your e-mail inbox from website {$site_name}.', 'Notify account changes just made by the user', '', ''),
(1012, 'en', 'users', 'users', 10, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Your account has been updated', '{$greeting_user}<br /><br />Your account on the website {$site_name} has been updated. Below are your login details:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Alias: {$username}<br />Email: {$email}{if not empty($password)}<br />Password: {$password}{/if}<br />{if $pass_reset gt 0 or $email_reset gt 0}<br />Notice:<br />{if $pass_reset eq 2}- We recommend that you change your password before using the account.<br />{elseif $pass_reset eq 1}- You are required to change your password before using the account.<br />{/if}{if $email_reset eq 2}- We recommend that you change your email before using the account.<br />{elseif $email_reset eq 1}- You are required to change your email before using the account.<br />{/if}{/if}<br />This is an automated email sent to your inbox from the website {$site_name}. If you do not understand the contents of this email, simply delete it.', 'Notify account changes just made by the administrator', '', ''),
(1013, 'en', 'users', 'users', 11, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Activation information for changing email', '{$greeting_user}<br /><br />You sent a request to change the email address of the personal Account on the website {$site_name}. To complete this change, you must confirm your new email address by entering the verifykey below in the appropriate fields in the area Edit Account Information:<br /><br />Verifykey: <strong>{$code}</strong><br /><br />This key expires on {$deadline}.<br /><br />These are automatic messages sent to your e-mail inbox from website {$site_name}. If you do not understand anything about the contents of this letter, simply delete it.', 'Confirmation email to change account email', '', ''),
(1014, 'en', 'users', 'users', 12, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Request to join group', 'Hello leader <strong>{$group_name}</strong>,<br /><br /><strong>{$full_name}</strong> has sent the request to join the group <strong>{$group_name}</strong> you are managing. You need to approve this request!<br /><br />Please <a href=\"{$link}\"> visit this link </a> to approve membership.', 'Notice asking to join the group', '', ''),
(1015, 'en', 'users', 'users', 13, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Activate account', '{$greeting_user}<br /><br />Your account at website {$site_name} waitting to activate. To activate, please click link follow:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Account information:<br />Account: {$username}<br />Email: {$email}<br />Password: {$password}<br /><br />Activate expired on {$active_deadline}<br /><br />This is email automatic sending from website {$site_name}.', 'Resend account activation information', '', ''),
(1016, 'en', 'users', 'users', 14, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Guide password recovery', '{$greeting_user}<br /><br />You propose to change my login password at the website {$site_name}. To change your password, you will need to enter the verification code below in the corresponding box at the password change area.<br /><br />Verification code: <strong>{$code}</strong><br /><br />This code is only used once and before the deadline of {$deadline}.<br />More information about this request:<br />- IP: <strong>{$ip}</strong><br />- Browser: <strong>{$user_agent}</strong><br />- Time: <strong>{$request_time}</strong><br /><br />This letter is automatically sent to your email inbox from site {$site_name}. If you do not know anything about the contents of this letter, just delete it.', 'Instructions for retrieving member password', '', ''),
(1017, 'en', 'users', 'users', 15, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', '2-Step Verification is turned off', '{$greeting_user}<br /><br />At your request, we have turned off 2-Step Verification for your account at the {$site_name} website.<br /><br />This is email automatic sending from website {$site_name}.', 'Notice that two-step authentication has been successfully removed', '', ''),
(1018, 'en', 'users', 'users', 16, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Information about turning off 2-step verification', '{$greeting_user}<br /><br />We have received a request to turn off 2-step verification for your account at the {$site_name} website. If you sent this request yourself, please use the Verification Code below to proceed:<br /><br />Verification Code: <strong>{$code}</strong><br /><br />This is email automatic sending from website {$site_name}.', 'Instructions for turning off two-step authentication when forgetting code', '', ''),
(1019, 'en', 'users', 'users', 17, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />We are informing you that a third party account <strong>{$oauth_name}</strong> has just been connected to your <strong>{$username}</strong> account by the group leader.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Third-party accounts Management</a>', 'Notification oauth is added to the account by the team leader', '', ''),
(1020, 'en', 'users', 'users', 18, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />The third party account <strong>{$oauth_name}</strong> has just been connected to your <strong>{$username}</strong> account. If this was not your intention, please quickly remove it from your account by visiting the third party account management area.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Third-party accounts Management</a>', 'Notification oauth is added to the account by the user themselves', '', ''),
(1021, 'en', 'users', 'users', 19, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />We are informing you that the third party account <strong>{$oauth_name}</strong> has just been disconnected from your <strong>{$username}</strong> account by the group leader.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Third-party accounts Management</a>', 'Notification oauth is removed to the account by the team leader', '', ''),
(1022, 'en', 'users', 'users', 21, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />The third-party account <strong>{$oauth_name}</strong> has just been disconnected from your <strong>{$username}</strong> account. If this is not your intention, please quickly contact the site administrator for help.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Third-party accounts Management</a>', 'Notification oauth is removed to the account by the user themselves', '', ''),
(1023, 'en', 'users', 'users', 22, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'New e-mail verification', 'Hello!<br /><br />You have sent a request to verify your email address: {$email}. Copy the code below and paste it into the Verification code box on the site.<br /><br />Verification code: <strong>{$code}</strong><br /><br />This is email automatic sending from website {$site_name}.', 'Send email verification code when logging in via Oauth and the email matches your existing account', '', ''),
(1024, 'en', 'users', 'users', 24, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Your account has been created', '{$greeting_user}<br /><br />Your account at website {$site_name} activated. {if empty($oauth_name)}Your login information:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Username: {$username}<br />{if not empty($password)}Password: {$password}{/if}{else}To log into your account please visit the page: <a href=\"{$link}\">{$link}</a> and press the button: <strong>Sign in with {$oauth_name}</strong>.{if not empty($password)}<br /><br />You can also log in using the usual method with the following information:<br />Username: {$username}<br />Password: {$password}{/if}{/if}{if $pass_reset gt 0 or $email_reset gt 0}<br />Note:<br />{if $pass_reset eq 2}- We recommend that you change your password before using the account.<br />{elseif $pass_reset eq 1}- You need to change your password before using the account.<br />{/if}{if $email_reset eq 2}- We recommend that you change your email before using the account.<br />{elseif $email_reset eq 1}- You need to change your email before using the account.<br />{/if}{/if}<br />This is email automatic sending from website {$site_name}.', 'Email notifies users when the administrator activates the account', '', ''),
(1025, 'en', 'users', 'users', 25, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', '{if $pass_reset eq 2}Recommended account password change{else}Need to change account password{/if}', '{$greeting_user}<br /><br />The {$site_name} website administration informs: For security reasons, {if $pass_reset eq 2}we recommend that you{else}you need to{/if} change your account password as soon as possible. To change your password, you need to first visit the <a href=\"{$link}\">Manage Personal Account page</a>, select the Account Settings button, then the Password button, and follow the instructions.', 'Email asking user to change password', '', ''),
(1026, 'en', 'users', 'users', 26, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />Your account has just had two-step authentication disabled by your administrator. We send you this email to inform you.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Manage two-step authentication</a>', 'Notification to users that two-step authentication has been turned off by the administrator', '', ''),
(1027, 'en', 'users', 'users', 20, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />We are informing you that the third party account <strong>{$oauth_name}</strong> has just been disconnected from your account by an administrator. We send you this email to inform you.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Third-party accounts Management</a>', 'Notify users when administrators delete their third-party account', '', ''),
(1028, 'en', 'users', 'users', 23, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />We inform you that all third party accounts have been disconnected from your account by an administrator.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Third-party accounts Management</a>', 'Notify users when administrators delete all of their third-party accounts', '', ''),
(1029, 'en', 'users', 'users', 27, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', '{if $email_reset eq 2}Recommended email change{else}Need to change email{/if}', '{$greeting_user}<br /><br />The {$site_name} website administration informs: For security reasons, {if $email_reset eq 2}we recommend that you{else}you need to{/if} change your account email as soon as possible. To change your email, you need to first visit the <a href=\"{$link}\">Manage Personal Account page</a>, select the Account Settings button, then the Email button, and follow the instructions.', 'Email requesting user to change email', '', ''),
(1030, 'en', 'users', 'users', 28, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'A security key has been added to your account', '{$greeting_user}<br /><br />A security key named &quot;{$security_key}&quot; has just been added to your account on the website {$site_name}. This action originated from:\n<ul>\n    <li>Browser: <strong>{$user_agent}</strong></li>\n    <li>IP: <strong>{$ip}</strong></li>\n    <li>Action time: <strong>{$action_time}</strong></li>\n</ul>\n<p>We send this mandatory notification to your email to ensure that it was you who performed the action. If it was not you, please urgently visit the <a href=\"{$tstep_link}\">two-step authentication management page</a> to review the security keys. Also, <a href=\"{$pass_link}\">change your password immediately</a> to ensure safety.</p>\nReminder: Have you stored your backup codes? If not, please take a moment to download and store them carefully, as they are the last resort to ensure you can access your account in case you lose the devices used for two-step authentication. You can <a href=\"{$code_link}\">download them here</a>.', 'Email adding security key', '', ''),
(1031, 'en', 'users', 'users', 29, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'A passkey has been added to your account', '{$greeting_user}<br /><br />A passkey named &quot;{$passkey}&quot; has just been added to your account on the website {$site_name}. This action originated from:\n<ul>\n    <li>Browser: <strong>{$user_agent}</strong></li>\n    <li>IP: <strong>{$ip}</strong></li>\n    <li>Action time: <strong>{$action_time}</strong></li>\n</ul>\nWe send this mandatory notification to your email to ensure that it was you who performed the action. If it was not you, please urgently visit the <a href=\"{$passkey_link}\">passkey management page</a> to review the passkeys. Also, <a href=\"{$pass_link}\">change your password immediately</a> to ensure safety.', 'Email adding passkey', '', ''),
(1032, 'en', 'users', 'users', 30, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Security key has been removed from your account', '{$greeting_user}<br /><br />The security key named &quot;{$security_key}&quot; has just been removed from your account on the website {$site_name}. This action originated from:\n<ul>\n    <li>Browser: <strong>{$user_agent}</strong></li>\n    <li>IP: <strong>{$ip}</strong></li>\n    <li>Action time: <strong>{$action_time}</strong></li>\n</ul>\n<p>We send this mandatory notification to your email to ensure that it was you who performed the action. If it was not you, please urgently visit the <a href=\"{$tstep_link}\">two-step authentication management page</a> to review the security keys. Also, <a href=\"{$pass_link}\">change your password immediately</a> to ensure safety.</p>\nReminder: Have you stored your backup codes? If not, please take a moment to download and store them carefully, as they are the last resort to ensure you can access your account in case you lose the devices used for two-step authentication. You can <a href=\"{$code_link}\">download them here</a>.', 'Email deleting security key', '', ''),
(1033, 'en', 'users', 'users', 31, '3', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Passkey has been removed from your account', '{$greeting_user}<br /><br />The passkey named &quot;{$passkey}&quot; has just been removed from your account on the website {$site_name}. This action originated from:\n<ul>\n    <li>Browser: <strong>{$user_agent}</strong></li>\n    <li>IP: <strong>{$ip}</strong></li>\n    <li>Action time: <strong>{$action_time}</strong></li>\n</ul>\nWe send this mandatory notification to your email to ensure that it was you who performed the action. If it was not you, please urgently visit the <a href=\"{$passkey_link}\">passkey management page</a> to review the passkeys. Also, <a href=\"{$pass_link}\">change your password immediately</a> to ensure safety.', 'Email deleting passkey', '', ''),
(1034, 'en', 'two-step-verification', 'two-step-verification', 1, '5', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />Your account at <a href=\"{$Home}\"><strong>{$site_name}</strong></a> has just enabled Two-Factor Authentication. Information:<br /><br />- Time: <strong>{$time}</strong><br />- IP: <strong>{$ip}</strong><br />- Browser: <strong>{$browser}</strong><br /><br />If this is you, ignore this email. If this is not you, your account is most likely stolen. Please contact the site administrator for assistance', 'Notice to enable two-step authentication for member accounts', '', ''),
(1035, 'en', 'two-step-verification', 'two-step-verification', 2, '5', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />Your account at <a href=\"{$Home}\"><strong>{$site_name}</strong></a> has just disabled Two-Factor Authentication. Information:<br /><br />- Time: <strong>{$time}</strong><br />- IP: <strong>{$ip}</strong><br />- Browser: <strong>{$browser}</strong><br /><br />If this is you, ignore this email. If this is not you, please check your personal information at <a href=\"{$link}\">{$link}</a>', 'Notice to turn off two-step authentication for member accounts', '', ''),
(1036, 'en', 'two-step-verification', 'two-step-verification', 3, '5', '', 3, 1759423352, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Privacy Notice', '{$greeting_user}<br /><br />Your account at <a href=\"{$Home}\"><strong>{$site_name}</strong></a> has just recreated the backup code. Information:<br /><br />- Time: <strong>{$time}</strong><br />- IP: <strong>{$ip}</strong><br />- Browser: <strong>{$browser}</strong><br /><br />If this is you, ignore this email. If this is not you, please check your personal information at <a href=\"{$link}\">{$link}</a>', 'Notice of regenerating two-step authentication backup codes for member accounts', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_emailtemplates_categories`
--

CREATE TABLE `nv5_emailtemplates_categories` (
  `catid` smallint(4) UNSIGNED NOT NULL,
  `time_add` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Tạo lúc',
  `time_update` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cập nhật lúc',
  `weight` smallint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sắp thứ tự',
  `is_system` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0 ẩn, 1 hiển thị',
  `en_title` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng danh mục mẫu email';

--
-- Dumping data for table `nv5_emailtemplates_categories`
--

INSERT INTO `nv5_emailtemplates_categories` (`catid`, `time_add`, `time_update`, `weight`, `is_system`, `status`, `en_title`) VALUES
(1, 1759423352, 0, 1, 1, 1, 'System Messages'),
(2, 1759423352, 0, 3, 1, 1, 'Admin Messages'),
(3, 1759423352, 0, 2, 1, 1, 'User Messages'),
(4, 1759423352, 0, 4, 1, 1, 'Module Messages');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_about`
--

CREATE TABLE `nv5_en_about` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `alias` varchar(250) NOT NULL,
  `image` varchar(255) DEFAULT '',
  `imagealt` varchar(255) DEFAULT '',
  `imageposition` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `bodytext` mediumtext NOT NULL,
  `keywords` text DEFAULT NULL,
  `socialbutton` tinyint(4) NOT NULL DEFAULT 0,
  `activecomm` varchar(255) DEFAULT '',
  `layout_func` varchar(100) DEFAULT '',
  `weight` smallint(4) NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hot_post` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `schema_type` varchar(20) NOT NULL DEFAULT 'article' COMMENT 'Dữ liệu có cấu trúc của bài viết',
  `schema_about` varchar(50) NOT NULL DEFAULT 'Organization' COMMENT 'Trang viết về gì nếu dữ liệu có cấu trúc là WebPage'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_about`
--

INSERT INTO `nv5_en_about` (`id`, `title`, `alias`, `image`, `imagealt`, `imageposition`, `description`, `bodytext`, `keywords`, `socialbutton`, `activecomm`, `layout_func`, `weight`, `admin_id`, `add_time`, `edit_time`, `status`, `hitstotal`, `hot_post`, `schema_type`, `schema_about`) VALUES
(1, 'Welcome to NukeViet 3.0', 'Welcome-to-NukeViet-3-0', '', '', 0, '', '<p> NukeViet developed by Vietnamese and for Vietnamese. It&#039;s the 1st opensource CMS in Vietnam. Next generation of NukeViet, version 3.0 coding ground up. Support newest web technology, include xHTML, CSS 3, XTemplate, jQuery, AJAX...<br /> <br /> NukeViet&#039;s has it own core libraries build in. So, it&#039;s doesn&#039;t depend on other exists frameworks. With basic knowledge of PHP and MySQL, you can easily using NukeViet for your purposes.<br /> <br /> NukeViet 3 core is simply but powerful. It support modules can be multiply. We called it abstract modules. It help users automatic crea-te many modules without any line of code from any exists module which support crea-te abstract modules.<br /> <br /> NukeViet 3 support automatic setup modules, blocks, themes at Admin Control Panel. It&#039;s also allow you to share your modules by packed it into packets.<br /> <br /> NukeViet 3 support multi languages in 2 types. Multi interface languages and multi database langguages. Had features support web master to build new languages. Many advance features still developing. Let use it, distribute it and feel about opensource.<br /> <br /> At last, NukeViet 3 is a thanksgiving gift from VINADES.,JSC to community for all of your supports. And we hoping we going to be a biggest opensource CMS not only in VietNam, but also in the world. :).<br /> <br /> If you had any feedbacks and ideas for NukeViet 3 close beta. Feel free to send email to admin@nukeviet.vn. All are welcome<br /> <br /> Best regard.</p>', '', 0, '4', '', 1, 1, 1277266815, 1277266815, 1, 1, 0, 'article', 'Organization'),
(2, 'NukeViet&#039;s versioning schemes', 'NukeViet-s-versioning-schemes', '', '', 0, '', '<p> NukeViet using 2 versioning schemes:<br /> <br /> I. By numbers (technical purposes):<br /> Structure for numbers is:<br /> major.minor.revision<br /> <br /> 1.Major: Major up-date. Probably not backwards compatible with older version.<br /> 2.Minor: Minor change, may introduce new features, but backwards compatibility is mostly retained.<br /> 3.Revision: Minor bug fixes. Packed for testing or pre-release purposes... Closed beta, open beta, RC, Official release.<br /> <br /> II: By names (new version release management)<br /> Main milestones: Closed beta, Open beta, Release candidate, Official.<br /> 1. Closed beta: Limited testing.<br /> characteristics: New features testing. It may not include in official version if doesn&#039;t accord with community. Closed beta&#039;s name can contain unique numbers. Ex: Closed beta 1, closed beta 2,... Features of previous release may not include in it&#039;s next release. Time release is announced by development team. This milestone stop when system haven&#039;t any major changes.<br /> Purposes: Pre-release version to receive feedbacks and ideas from community. Bug fixes for release version.<br /> Release to: Programmers, expert users.<br /> Supports:<br /> &nbsp;&nbsp;&nbsp; Using: None.<br /> &nbsp;&nbsp;&nbsp; Testing: Documents, not include manual.<br /> Upgrade: None.<br /> <br /> 2. Open beta: Public testing.<br /> characteristics: Features testing, contain full features of official version. It&#039;s almost include in official version even if it doesn&#039;t accord with community. This milestone start after closed beta milestone closed and release weekly to fix bugs. Open beta&#039;s name can contain unique numbers. Ex: Open beta 1, open beta 2,... Next release include all features of it&#039;s previous release. Open beta milestone stop when system haven&#039;t any critical issue.<br /> Purposes: Bug fixed which not detect in closed beta.<br /> Release to: All users of nukeviet.vn forum.<br /> Supports:<br /> &nbsp;&nbsp;&nbsp; Using: Limited. Manual and forum supports.<br /> &nbsp;&nbsp;&nbsp; Testing: Full.<br /> Upgrade: None.<br /> <br /> 3. Release Candidate:<br /> characteristics: Most stable version and prepare for official release. Release candidate&#039;s name can contain unique numbers.<br /> Ex: RC 1, RC 2,... by released number.<br /> If detect cretical issue in this milestone. Another Release Candidate version can be release sooner than release time announced by development team.<br /> Purposes: Reduce bugs of using official version.<br /> Release to: All people.<br /> Supports: Full.<br /> Upgrade: Yes.<br /> <br /> 4. Official:<br /> characteristics: 1st stable release of new version. It only using 1 time. Next release using numbers. Release about 2 weeks after Release Candidate milestone stoped.<br /> Purposes: Stop testing and recommend users using new version.</p>', '', 0, '4', '', 2, 1, 1277267054, 1277693688, 1, 1, 0, 'article', 'Organization');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_about_config`
--

CREATE TABLE `nv5_en_about_config` (
  `config_name` varchar(30) NOT NULL,
  `config_value` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_about_config`
--

INSERT INTO `nv5_en_about_config` (`config_name`, `config_value`) VALUES
('schema_type', 'article'),
('schema_about', 'organization'),
('viewtype', '0'),
('facebookapi', ''),
('per_page', '20'),
('news_first', '0'),
('related_articles', '5'),
('copy_page', '0'),
('alias_lower', '1'),
('socialbutton', 'facebook,twitter');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_blocks_groups`
--

CREATE TABLE `nv5_en_blocks_groups` (
  `bid` mediumint(8) UNSIGNED NOT NULL,
  `theme` varchar(55) NOT NULL,
  `module` varchar(55) NOT NULL,
  `file_name` varchar(55) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `template` varchar(55) DEFAULT NULL,
  `heading` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Thẻ heading mong muốn',
  `position` varchar(55) DEFAULT NULL,
  `dtime_type` char(50) NOT NULL DEFAULT 'regular',
  `dtime_details` text DEFAULT NULL,
  `active` varchar(10) DEFAULT '1',
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `groups_view` varchar(255) DEFAULT '',
  `all_func` tinyint(4) NOT NULL DEFAULT 0,
  `weight` int(11) NOT NULL DEFAULT 0,
  `config` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Danh sách block theo ngôn ngữ, giao diện';

--
-- Dumping data for table `nv5_en_blocks_groups`
--

INSERT INTO `nv5_en_blocks_groups` (`bid`, `theme`, `module`, `file_name`, `title`, `link`, `template`, `heading`, `position`, `dtime_type`, `dtime_details`, `active`, `act`, `groups_view`, `all_func`, `weight`, `config`) VALUES
(1, 'default', 'news', 'module.block_newscenter.php', 'Breaking news', '', 'no_title', 0, '[TOP]', 'regular', '[]', '1', 1, '6', 0, 1, 'a:10:{s:6:\"numrow\";i:6;s:11:\"showtooltip\";i:1;s:16:\"tooltip_position\";s:6:\"bottom\";s:14:\"tooltip_length\";s:3:\"150\";s:12:\"length_title\";i:0;s:15:\"length_hometext\";i:0;s:17:\"length_othertitle\";i:60;s:5:\"width\";i:500;s:6:\"height\";i:0;s:7:\"nocatid\";a:0:{}}'),
(2, 'default', 'banners', 'global.banners.php', 'Center Banner', '', 'no_title', 0, '[TOP]', 'regular', '[]', '1', 1, '6', 0, 2, 'a:1:{s:12:\"idplanbanner\";i:1;}'),
(3, 'default', 'news', 'global.block_category.php', 'Category', '', 'no_title', 0, '[LEFT]', 'regular', '[]', '1', 1, '6', 0, 1, 'a:2:{s:5:\"catid\";i:0;s:12:\"title_length\";i:0;}'),
(4, 'default', 'theme', 'global.module_menu.php', 'Module Menu', '', 'no_title', 0, '[LEFT]', 'regular', '[]', '1', 1, '6', 0, 2, ''),
(5, 'default', 'banners', 'global.banners.php', 'Left Banner', '', 'no_title', 0, '[LEFT]', 'regular', '[]', '1', 1, '6', 1, 3, 'a:1:{s:12:\"idplanbanner\";i:2;}'),
(6, 'default', 'statistics', 'global.counter.php', 'Statistics', '', 'primary', 0, '[LEFT]', 'regular', '[]', '1', 1, '6', 1, 4, ''),
(7, 'default', 'about', 'global.about.php', 'About', '', 'border', 0, '[RIGHT]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(8, 'default', 'banners', 'global.banners.php', 'Right Banner', '', 'no_title', 0, '[RIGHT]', 'regular', '[]', '1', 1, '6', 1, 2, 'a:1:{s:12:\"idplanbanner\";i:3;}'),
(9, 'default', 'voting', 'global.voting_random.php', 'Voting', '', 'primary', 0, '[RIGHT]', 'regular', '[]', '1', 1, '6', 1, 3, ''),
(10, 'default', 'news', 'global.block_tophits.php', 'Top Hits', '', 'primary', 0, '[RIGHT]', 'regular', '[]', '1', 1, '6', 1, 4, 'a:6:{s:10:\"number_day\";i:3650;s:6:\"numrow\";i:10;s:11:\"showtooltip\";i:1;s:16:\"tooltip_position\";s:6:\"bottom\";s:14:\"tooltip_length\";s:3:\"150\";s:7:\"nocatid\";a:2:{i:0;i:10;i:1;i:11;}}'),
(11, 'default', 'theme', 'global.copyright.php', 'Copyright', '', 'no_title', 0, '[FOOTER_SITE]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:5:{s:12:\"copyright_by\";s:0:\"\";s:13:\"copyright_url\";s:0:\"\";s:9:\"design_by\";s:12:\"VINADES.,JSC\";s:10:\"design_url\";s:19:\"https://vinades.vn/\";s:13:\"siteterms_url\";s:48:\"/nukeviet/index.php?language=en&amp;nv=siteterms\";}'),
(12, 'default', 'contact', 'global.contact_form.php', 'Feedback', '', 'no_title', 0, '[FOOTER_SITE]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(13, 'default', 'theme', 'global.QR_code.php', 'QR code', '', 'no_title', 0, '[QR_CODE]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(14, 'default', 'statistics', 'global.counter_button.php', 'Online button', '', 'no_title', 0, '[QR_CODE]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(15, 'default', 'inform', 'global.inform.php', 'Notification', '', 'no_title', 0, '[PERSONALAREA]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(16, 'default', 'users', 'global.user_button.php', 'Member login', '', 'no_title', 0, '[PERSONALAREA]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(17, 'default', 'theme', 'global.company_info.php', 'Managing company', '', 'simple', 0, '[COMPANY_INFO]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:13:{s:12:\"company_name\";s:51:\"Vietnam Open Source Development Joint Stock Company\";s:15:\"company_address\";s:106:\"6th floor, Song Da building, No. 131 Tran Phu street, Van Quan ward, Ha Dong district, Hanoi city, Vietnam\";s:16:\"company_sortname\";s:12:\"VINADES.,JSC\";s:15:\"company_regcode\";s:0:\"\";s:16:\"company_regplace\";s:0:\"\";s:21:\"company_licensenumber\";s:0:\"\";s:22:\"company_responsibility\";s:0:\"\";s:15:\"company_showmap\";i:1;s:14:\"company_mapurl\";s:312:\"https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d427.01613794022035!2d105.78849184070538!3d20.979995366268337!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ac93055e2f2f%3A0x91f4b423089193dd!2zQ8O0bmcgdHkgQ-G7lSBwaOG6p24gUGjDoXQgdHJp4buDbiBOZ3Xhu5NuIG3hu58gVmnhu4d0IE5hbQ!5e0!3m2!1svi!2s!4v1701239622249!5m2!1svi!2s\";s:13:\"company_phone\";s:30:\"+84-24-85872007[+842485872007]\";s:11:\"company_fax\";s:15:\"+84-24-35500914\";s:13:\"company_email\";s:18:\"contact@vinades.vn\";s:15:\"company_website\";s:18:\"https://vinades.vn\";}'),
(18, 'default', 'menu', 'global.bootstrap.php', 'Menu Site', '', 'no_title', 0, '[MENU_SITE]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:2:{s:6:\"menuid\";i:1;s:12:\"title_length\";i:0;}'),
(19, 'default', 'contact', 'global.contact_default.php', 'Contact Default', '', 'no_title', 0, '[CONTACT_DEFAULT]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(20, 'default', 'theme', 'global.social.php', 'Social icon', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:3:{s:8:\"facebook\";s:32:\"http://www.facebook.com/nukeviet\";s:7:\"youtube\";s:37:\"https://www.youtube.com/user/nukeviet\";s:7:\"twitter\";s:28:\"https://twitter.com/nukeviet\";}'),
(21, 'default', 'theme', 'global.menu_footer.php', 'Main categories', '', 'simple', 0, '[MENU_FOOTER]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:1:{s:14:\"module_in_menu\";a:8:{i:0;s:5:\"about\";i:1;s:4:\"news\";i:2;s:5:\"users\";i:3;s:7:\"contact\";i:4;s:6:\"voting\";i:5;s:7:\"banners\";i:6;s:4:\"seek\";i:7;s:5:\"feeds\";}}'),
(22, 'default', 'freecontent', 'global.free_content.php', 'Introduction', '', 'no_title', 0, '[FEATURED_PRODUCT]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:2:{s:7:\"blockid\";i:1;s:7:\"numrows\";i:2;}'),
(23, 'mobile_default', 'menu', 'global.metismenu.php', 'Menu Site', '', 'no_title', 0, '[MENU_SITE]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:2:{s:6:\"menuid\";i:1;s:12:\"title_length\";i:0;}'),
(24, 'mobile_default', 'inform', 'global.inform.php', 'Notification', '', 'no_title', 0, '[MENU_SITE]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(25, 'mobile_default', 'users', 'global.user_button.php', 'Sign In', '', 'no_title', 0, '[MENU_SITE]', 'regular', '[]', '1', 1, '6', 1, 3, ''),
(26, 'mobile_default', 'contact', 'global.contact_default.php', 'Contact Default', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(27, 'mobile_default', 'contact', 'global.contact_form.php', 'Feedback', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(28, 'mobile_default', 'theme', 'global.social.php', 'Social icon', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 3, 'a:3:{s:8:\"facebook\";s:32:\"http://www.facebook.com/nukeviet\";s:7:\"youtube\";s:37:\"https://www.youtube.com/user/nukeviet\";s:7:\"twitter\";s:28:\"https://twitter.com/nukeviet\";}'),
(29, 'mobile_default', 'theme', 'global.QR_code.php', 'QR code', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 4, ''),
(30, 'mobile_default', 'theme', 'global.copyright.php', 'Copyright', '', 'no_title', 0, '[FOOTER_SITE]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:5:{s:12:\"copyright_by\";s:0:\"\";s:13:\"copyright_url\";s:0:\"\";s:9:\"design_by\";s:12:\"VINADES.,JSC\";s:10:\"design_url\";s:19:\"https://vinades.vn/\";s:13:\"siteterms_url\";s:48:\"/nukeviet/index.php?language=en&amp;nv=siteterms\";}'),
(31, 'mobile_default', 'theme', 'global.menu_footer.php', 'Main categories', '', 'primary', 0, '[MENU_FOOTER]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:1:{s:14:\"module_in_menu\";a:9:{i:0;s:5:\"about\";i:1;s:4:\"news\";i:2;s:5:\"users\";i:3;s:7:\"contact\";i:4;s:6:\"voting\";i:5;s:7:\"banners\";i:6;s:4:\"seek\";i:7;s:5:\"feeds\";i:8;s:9:\"siteterms\";}}'),
(32, 'mobile_default', 'theme', 'global.company_info.php', 'Managing company', '', 'primary', 0, '[COMPANY_INFO]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:13:{s:12:\"company_name\";s:51:\"Vietnam Open Source Development Joint Stock Company\";s:15:\"company_address\";s:106:\"6th floor, Song Da building, No. 131 Tran Phu street, Van Quan ward, Ha Dong district, Hanoi city, Vietnam\";s:16:\"company_sortname\";s:12:\"VINADES.,JSC\";s:15:\"company_regcode\";s:0:\"\";s:16:\"company_regplace\";s:0:\"\";s:21:\"company_licensenumber\";s:0:\"\";s:22:\"company_responsibility\";s:0:\"\";s:15:\"company_showmap\";i:1;s:14:\"company_mapurl\";s:312:\"https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d427.01613794022035!2d105.78849184070538!3d20.979995366268337!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ac93055e2f2f%3A0x91f4b423089193dd!2zQ8O0bmcgdHkgQ-G7lSBwaOG6p24gUGjDoXQgdHJp4buDbiBOZ3Xhu5NuIG3hu58gVmnhu4d0IE5hbQ!5e0!3m2!1svi!2s!4v1701239622249!5m2!1svi!2s\";s:13:\"company_phone\";s:30:\"+84-24-85872007[+842485872007]\";s:11:\"company_fax\";s:15:\"+84-24-35500914\";s:13:\"company_email\";s:18:\"contact@vinades.vn\";s:15:\"company_website\";s:18:\"https://vinades.vn\";}');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_blocks_weight`
--

CREATE TABLE `nv5_en_blocks_weight` (
  `bid` mediumint(8) NOT NULL DEFAULT 0,
  `func_id` mediumint(8) NOT NULL DEFAULT 0,
  `weight` mediumint(8) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vị trí đặt các block';

--
-- Dumping data for table `nv5_en_blocks_weight`
--

INSERT INTO `nv5_en_blocks_weight` (`bid`, `func_id`, `weight`) VALUES
(1, 4, 1),
(2, 4, 2),
(3, 4, 1),
(3, 5, 1),
(3, 6, 1),
(3, 7, 1),
(3, 8, 1),
(3, 9, 1),
(3, 10, 1),
(3, 11, 1),
(3, 12, 1),
(4, 20, 1),
(4, 21, 1),
(4, 22, 1),
(4, 23, 1),
(4, 24, 1),
(4, 25, 1),
(4, 26, 1),
(4, 27, 1),
(4, 28, 1),
(4, 29, 1),
(4, 30, 1),
(4, 31, 1),
(4, 36, 1),
(4, 37, 1),
(4, 38, 1),
(4, 39, 1),
(4, 40, 1),
(4, 41, 1),
(4, 42, 1),
(5, 1, 1),
(5, 2, 1),
(5, 3, 1),
(5, 4, 2),
(5, 5, 2),
(5, 6, 2),
(5, 7, 2),
(5, 8, 2),
(5, 9, 2),
(5, 10, 2),
(5, 11, 2),
(5, 12, 2),
(5, 13, 1),
(5, 14, 1),
(5, 15, 1),
(5, 16, 1),
(5, 17, 1),
(5, 18, 1),
(5, 19, 1),
(5, 20, 2),
(5, 21, 2),
(5, 22, 2),
(5, 23, 2),
(5, 24, 2),
(5, 25, 2),
(5, 26, 2),
(5, 27, 2),
(5, 28, 2),
(5, 29, 2),
(5, 30, 2),
(5, 31, 2),
(5, 32, 1),
(5, 33, 1),
(5, 34, 1),
(5, 35, 1),
(5, 36, 2),
(5, 37, 2),
(5, 38, 2),
(5, 39, 2),
(5, 40, 2),
(5, 41, 2),
(5, 42, 2),
(5, 43, 1),
(5, 44, 1),
(5, 45, 1),
(5, 46, 1),
(5, 47, 1),
(5, 48, 1),
(5, 49, 1),
(5, 50, 1),
(5, 51, 1),
(5, 52, 1),
(5, 53, 1),
(5, 54, 1),
(5, 55, 1),
(5, 56, 1),
(5, 57, 1),
(5, 58, 1),
(5, 59, 1),
(5, 60, 1),
(5, 61, 1),
(5, 62, 1),
(5, 63, 1),
(5, 64, 1),
(5, 65, 1),
(5, 66, 1),
(5, 67, 1),
(5, 68, 1),
(5, 69, 1),
(5, 70, 1),
(5, 71, 1),
(5, 72, 1),
(5, 73, 1),
(5, 74, 1),
(5, 75, 1),
(5, 76, 1),
(5, 77, 1),
(5, 78, 1),
(5, 79, 1),
(5, 80, 1),
(5, 81, 1),
(5, 83, 1),
(6, 1, 2),
(6, 2, 2),
(6, 3, 2),
(6, 4, 3),
(6, 5, 3),
(6, 6, 3),
(6, 7, 3),
(6, 8, 3),
(6, 9, 3),
(6, 10, 3),
(6, 11, 3),
(6, 12, 3),
(6, 13, 2),
(6, 14, 2),
(6, 15, 2),
(6, 16, 2),
(6, 17, 2),
(6, 18, 2),
(6, 19, 2),
(6, 20, 3),
(6, 21, 3),
(6, 22, 3),
(6, 23, 3),
(6, 24, 3),
(6, 25, 3),
(6, 26, 3),
(6, 27, 3),
(6, 28, 3),
(6, 29, 3),
(6, 30, 3),
(6, 31, 3),
(6, 32, 2),
(6, 33, 2),
(6, 34, 2),
(6, 35, 2),
(6, 36, 3),
(6, 37, 3),
(6, 38, 3),
(6, 39, 3),
(6, 40, 3),
(6, 41, 3),
(6, 42, 3),
(6, 43, 2),
(6, 44, 2),
(6, 45, 2),
(6, 46, 2),
(6, 47, 2),
(6, 48, 2),
(6, 49, 2),
(6, 50, 2),
(6, 51, 2),
(6, 52, 2),
(6, 53, 2),
(6, 54, 2),
(6, 55, 2),
(6, 56, 2),
(6, 57, 2),
(6, 58, 2),
(6, 59, 2),
(6, 60, 2),
(6, 61, 2),
(6, 62, 2),
(6, 63, 2),
(6, 64, 2),
(6, 65, 2),
(6, 66, 2),
(6, 67, 2),
(6, 68, 2),
(6, 69, 2),
(6, 70, 2),
(6, 71, 2),
(6, 72, 2),
(6, 73, 2),
(6, 74, 2),
(6, 75, 2),
(6, 76, 2),
(6, 77, 2),
(6, 78, 2),
(6, 79, 2),
(6, 80, 2),
(6, 81, 2),
(6, 83, 2),
(7, 1, 1),
(7, 2, 1),
(7, 3, 1),
(7, 4, 1),
(7, 5, 1),
(7, 6, 1),
(7, 7, 1),
(7, 8, 1),
(7, 9, 1),
(7, 10, 1),
(7, 11, 1),
(7, 12, 1),
(7, 13, 1),
(7, 14, 1),
(7, 15, 1),
(7, 16, 1),
(7, 17, 1),
(7, 18, 1),
(7, 19, 1),
(7, 20, 1),
(7, 21, 1),
(7, 22, 1),
(7, 23, 1),
(7, 24, 1),
(7, 25, 1),
(7, 26, 1),
(7, 27, 1),
(7, 28, 1),
(7, 29, 1),
(7, 30, 1),
(7, 31, 1),
(7, 32, 1),
(7, 33, 1),
(7, 34, 1),
(7, 35, 1),
(7, 36, 1),
(7, 37, 1),
(7, 38, 1),
(7, 39, 1),
(7, 40, 1),
(7, 41, 1),
(7, 42, 1),
(7, 43, 1),
(7, 44, 1),
(7, 45, 1),
(7, 46, 1),
(7, 47, 1),
(7, 48, 1),
(7, 49, 1),
(7, 50, 1),
(7, 51, 1),
(7, 52, 1),
(7, 53, 1),
(7, 54, 1),
(7, 55, 1),
(7, 56, 1),
(7, 57, 1),
(7, 58, 1),
(7, 59, 1),
(7, 60, 1),
(7, 61, 1),
(7, 62, 1),
(7, 63, 1),
(7, 64, 1),
(7, 65, 1),
(7, 66, 1),
(7, 67, 1),
(7, 68, 1),
(7, 69, 1),
(7, 70, 1),
(7, 71, 1),
(7, 72, 1),
(7, 73, 1),
(7, 74, 1),
(7, 75, 1),
(7, 76, 1),
(7, 77, 1),
(7, 78, 1),
(7, 79, 1),
(7, 80, 1),
(7, 81, 1),
(7, 83, 1),
(8, 1, 2),
(8, 2, 2),
(8, 3, 2),
(8, 4, 2),
(8, 5, 2),
(8, 6, 2),
(8, 7, 2),
(8, 8, 2),
(8, 9, 2),
(8, 10, 2),
(8, 11, 2),
(8, 12, 2),
(8, 13, 2),
(8, 14, 2),
(8, 15, 2),
(8, 16, 2),
(8, 17, 2),
(8, 18, 2),
(8, 19, 2),
(8, 20, 2),
(8, 21, 2),
(8, 22, 2),
(8, 23, 2),
(8, 24, 2),
(8, 25, 2),
(8, 26, 2),
(8, 27, 2),
(8, 28, 2),
(8, 29, 2),
(8, 30, 2),
(8, 31, 2),
(8, 32, 2),
(8, 33, 2),
(8, 34, 2),
(8, 35, 2),
(8, 36, 2),
(8, 37, 2),
(8, 38, 2),
(8, 39, 2),
(8, 40, 2),
(8, 41, 2),
(8, 42, 2),
(8, 43, 2),
(8, 44, 2),
(8, 45, 2),
(8, 46, 2),
(8, 47, 2),
(8, 48, 2),
(8, 49, 2),
(8, 50, 2),
(8, 51, 2),
(8, 52, 2),
(8, 53, 2),
(8, 54, 2),
(8, 55, 2),
(8, 56, 2),
(8, 57, 2),
(8, 58, 2),
(8, 59, 2),
(8, 60, 2),
(8, 61, 2),
(8, 62, 2),
(8, 63, 2),
(8, 64, 2),
(8, 65, 2),
(8, 66, 2),
(8, 67, 2),
(8, 68, 2),
(8, 69, 2),
(8, 70, 2),
(8, 71, 2),
(8, 72, 2),
(8, 73, 2),
(8, 74, 2),
(8, 75, 2),
(8, 76, 2),
(8, 77, 2),
(8, 78, 2),
(8, 79, 2),
(8, 80, 2),
(8, 81, 2),
(8, 83, 2),
(9, 1, 3),
(9, 2, 3),
(9, 3, 3),
(9, 4, 3),
(9, 5, 3),
(9, 6, 3),
(9, 7, 3),
(9, 8, 3),
(9, 9, 3),
(9, 10, 3),
(9, 11, 3),
(9, 12, 3),
(9, 13, 3),
(9, 14, 3),
(9, 15, 3),
(9, 16, 3),
(9, 17, 3),
(9, 18, 3),
(9, 19, 3),
(9, 20, 3),
(9, 21, 3),
(9, 22, 3),
(9, 23, 3),
(9, 24, 3),
(9, 25, 3),
(9, 26, 3),
(9, 27, 3),
(9, 28, 3),
(9, 29, 3),
(9, 30, 3),
(9, 31, 3),
(9, 32, 3),
(9, 33, 3),
(9, 34, 3),
(9, 35, 3),
(9, 36, 3),
(9, 37, 3),
(9, 38, 3),
(9, 39, 3),
(9, 40, 3),
(9, 41, 3),
(9, 42, 3),
(9, 43, 3),
(9, 44, 3),
(9, 45, 3),
(9, 46, 3),
(9, 47, 3),
(9, 48, 3),
(9, 49, 3),
(9, 50, 3),
(9, 51, 3),
(9, 52, 3),
(9, 53, 3),
(9, 54, 3),
(9, 55, 3),
(9, 56, 3),
(9, 57, 3),
(9, 58, 3),
(9, 59, 3),
(9, 60, 3),
(9, 61, 3),
(9, 62, 3),
(9, 63, 3),
(9, 64, 3),
(9, 65, 3),
(9, 66, 3),
(9, 67, 3),
(9, 68, 3),
(9, 69, 3),
(9, 70, 3),
(9, 71, 3),
(9, 72, 3),
(9, 73, 3),
(9, 74, 3),
(9, 75, 3),
(9, 76, 3),
(9, 77, 3),
(9, 78, 3),
(9, 79, 3),
(9, 80, 3),
(9, 81, 3),
(9, 83, 3),
(10, 1, 4),
(10, 2, 4),
(10, 3, 4),
(10, 4, 4),
(10, 5, 4),
(10, 6, 4),
(10, 7, 4),
(10, 8, 4),
(10, 9, 4),
(10, 10, 4),
(10, 11, 4),
(10, 12, 4),
(10, 13, 4),
(10, 14, 4),
(10, 15, 4),
(10, 16, 4),
(10, 17, 4),
(10, 18, 4),
(10, 19, 4),
(10, 20, 4),
(10, 21, 4),
(10, 22, 4),
(10, 23, 4),
(10, 24, 4),
(10, 25, 4),
(10, 26, 4),
(10, 27, 4),
(10, 28, 4),
(10, 29, 4),
(10, 30, 4),
(10, 31, 4),
(10, 32, 4),
(10, 33, 4),
(10, 34, 4),
(10, 35, 4),
(10, 36, 4),
(10, 37, 4),
(10, 38, 4),
(10, 39, 4),
(10, 40, 4),
(10, 41, 4),
(10, 42, 4),
(10, 43, 4),
(10, 44, 4),
(10, 45, 4),
(10, 46, 4),
(10, 47, 4),
(10, 48, 4),
(10, 49, 4),
(10, 50, 4),
(10, 51, 4),
(10, 52, 4),
(10, 53, 4),
(10, 54, 4),
(10, 55, 4),
(10, 56, 4),
(10, 57, 4),
(10, 58, 4),
(10, 59, 4),
(10, 60, 4),
(10, 61, 4),
(10, 62, 4),
(10, 63, 4),
(10, 64, 4),
(10, 65, 4),
(10, 66, 4),
(10, 67, 4),
(10, 68, 4),
(10, 69, 4),
(10, 70, 4),
(10, 71, 4),
(10, 72, 4),
(10, 73, 4),
(10, 74, 4),
(10, 75, 4),
(10, 76, 4),
(10, 77, 4),
(10, 78, 4),
(10, 79, 4),
(10, 80, 4),
(10, 81, 4),
(10, 83, 4),
(11, 1, 1),
(11, 2, 1),
(11, 3, 1),
(11, 4, 1),
(11, 5, 1),
(11, 6, 1),
(11, 7, 1),
(11, 8, 1),
(11, 9, 1),
(11, 10, 1),
(11, 11, 1),
(11, 12, 1),
(11, 13, 1),
(11, 14, 1),
(11, 15, 1),
(11, 16, 1),
(11, 17, 1),
(11, 18, 1),
(11, 19, 1),
(11, 20, 1),
(11, 21, 1),
(11, 22, 1),
(11, 23, 1),
(11, 24, 1),
(11, 25, 1),
(11, 26, 1),
(11, 27, 1),
(11, 28, 1),
(11, 29, 1),
(11, 30, 1),
(11, 31, 1),
(11, 32, 1),
(11, 33, 1),
(11, 34, 1),
(11, 35, 1),
(11, 36, 1),
(11, 37, 1),
(11, 38, 1),
(11, 39, 1),
(11, 40, 1),
(11, 41, 1),
(11, 42, 1),
(11, 43, 1),
(11, 44, 1),
(11, 45, 1),
(11, 46, 1),
(11, 47, 1),
(11, 48, 1),
(11, 49, 1),
(11, 50, 1),
(11, 51, 1),
(11, 52, 1),
(11, 53, 1),
(11, 54, 1),
(11, 55, 1),
(11, 56, 1),
(11, 57, 1),
(11, 58, 1),
(11, 59, 1),
(11, 60, 1),
(11, 61, 1),
(11, 62, 1),
(11, 63, 1),
(11, 64, 1),
(11, 65, 1),
(11, 66, 1),
(11, 67, 1),
(11, 68, 1),
(11, 69, 1),
(11, 70, 1),
(11, 71, 1),
(11, 72, 1),
(11, 73, 1),
(11, 74, 1),
(11, 75, 1),
(11, 76, 1),
(11, 77, 1),
(11, 78, 1),
(11, 79, 1),
(11, 80, 1),
(11, 81, 1),
(11, 83, 1),
(12, 1, 2),
(12, 2, 2),
(12, 3, 2),
(12, 4, 2),
(12, 5, 2),
(12, 6, 2),
(12, 7, 2),
(12, 8, 2),
(12, 9, 2),
(12, 10, 2),
(12, 11, 2),
(12, 12, 2),
(12, 13, 2),
(12, 14, 2),
(12, 15, 2),
(12, 16, 2),
(12, 17, 2),
(12, 18, 2),
(12, 19, 2),
(12, 20, 2),
(12, 21, 2),
(12, 22, 2),
(12, 23, 2),
(12, 24, 2),
(12, 25, 2),
(12, 26, 2),
(12, 27, 2),
(12, 28, 2),
(12, 29, 2),
(12, 30, 2),
(12, 31, 2),
(12, 32, 2),
(12, 33, 2),
(12, 34, 2),
(12, 35, 2),
(12, 36, 2),
(12, 37, 2),
(12, 38, 2),
(12, 39, 2),
(12, 40, 2),
(12, 41, 2),
(12, 42, 2),
(12, 43, 2),
(12, 44, 2),
(12, 45, 2),
(12, 46, 2),
(12, 47, 2),
(12, 48, 2),
(12, 49, 2),
(12, 50, 2),
(12, 51, 2),
(12, 52, 2),
(12, 53, 2),
(12, 54, 2),
(12, 55, 2),
(12, 56, 2),
(12, 57, 2),
(12, 58, 2),
(12, 59, 2),
(12, 60, 2),
(12, 61, 2),
(12, 62, 2),
(12, 63, 2),
(12, 64, 2),
(12, 65, 2),
(12, 66, 2),
(12, 67, 2),
(12, 68, 2),
(12, 69, 2),
(12, 70, 2),
(12, 71, 2),
(12, 72, 2),
(12, 73, 2),
(12, 74, 2),
(12, 75, 2),
(12, 76, 2),
(12, 77, 2),
(12, 78, 2),
(12, 79, 2),
(12, 80, 2),
(12, 81, 2),
(12, 83, 2),
(13, 1, 1),
(13, 2, 1),
(13, 3, 1),
(13, 4, 1),
(13, 5, 1),
(13, 6, 1),
(13, 7, 1),
(13, 8, 1),
(13, 9, 1),
(13, 10, 1),
(13, 11, 1),
(13, 12, 1),
(13, 13, 1),
(13, 14, 1),
(13, 15, 1),
(13, 16, 1),
(13, 17, 1),
(13, 18, 1),
(13, 19, 1),
(13, 20, 1),
(13, 21, 1),
(13, 22, 1),
(13, 23, 1),
(13, 24, 1),
(13, 25, 1),
(13, 26, 1),
(13, 27, 1),
(13, 28, 1),
(13, 29, 1),
(13, 30, 1),
(13, 31, 1),
(13, 32, 1),
(13, 33, 1),
(13, 34, 1),
(13, 35, 1),
(13, 36, 1),
(13, 37, 1),
(13, 38, 1),
(13, 39, 1),
(13, 40, 1),
(13, 41, 1),
(13, 42, 1),
(13, 43, 1),
(13, 44, 1),
(13, 45, 1),
(13, 46, 1),
(13, 47, 1),
(13, 48, 1),
(13, 49, 1),
(13, 50, 1),
(13, 51, 1),
(13, 52, 1),
(13, 53, 1),
(13, 54, 1),
(13, 55, 1),
(13, 56, 1),
(13, 57, 1),
(13, 58, 1),
(13, 59, 1),
(13, 60, 1),
(13, 61, 1),
(13, 62, 1),
(13, 63, 1),
(13, 64, 1),
(13, 65, 1),
(13, 66, 1),
(13, 67, 1),
(13, 68, 1),
(13, 69, 1),
(13, 70, 1),
(13, 71, 1),
(13, 72, 1),
(13, 73, 1),
(13, 74, 1),
(13, 75, 1),
(13, 76, 1),
(13, 77, 1),
(13, 78, 1),
(13, 79, 1),
(13, 80, 1),
(13, 81, 1),
(13, 83, 1),
(14, 1, 2),
(14, 2, 2),
(14, 3, 2),
(14, 4, 2),
(14, 5, 2),
(14, 6, 2),
(14, 7, 2),
(14, 8, 2),
(14, 9, 2),
(14, 10, 2),
(14, 11, 2),
(14, 12, 2),
(14, 13, 2),
(14, 14, 2),
(14, 15, 2),
(14, 16, 2),
(14, 17, 2),
(14, 18, 2),
(14, 19, 2),
(14, 20, 2),
(14, 21, 2),
(14, 22, 2),
(14, 23, 2),
(14, 24, 2),
(14, 25, 2),
(14, 26, 2),
(14, 27, 2),
(14, 28, 2),
(14, 29, 2),
(14, 30, 2),
(14, 31, 2),
(14, 32, 2),
(14, 33, 2),
(14, 34, 2),
(14, 35, 2),
(14, 36, 2),
(14, 37, 2),
(14, 38, 2),
(14, 39, 2),
(14, 40, 2),
(14, 41, 2),
(14, 42, 2),
(14, 43, 2),
(14, 44, 2),
(14, 45, 2),
(14, 46, 2),
(14, 47, 2),
(14, 48, 2),
(14, 49, 2),
(14, 50, 2),
(14, 51, 2),
(14, 52, 2),
(14, 53, 2),
(14, 54, 2),
(14, 55, 2),
(14, 56, 2),
(14, 57, 2),
(14, 58, 2),
(14, 59, 2),
(14, 60, 2),
(14, 61, 2),
(14, 62, 2),
(14, 63, 2),
(14, 64, 2),
(14, 65, 2),
(14, 66, 2),
(14, 67, 2),
(14, 68, 2),
(14, 69, 2),
(14, 70, 2),
(14, 71, 2),
(14, 72, 2),
(14, 73, 2),
(14, 74, 2),
(14, 75, 2),
(14, 76, 2),
(14, 77, 2),
(14, 78, 2),
(14, 79, 2),
(14, 80, 2),
(14, 81, 2),
(14, 83, 2),
(15, 1, 1),
(15, 2, 1),
(15, 3, 1),
(15, 4, 1),
(15, 5, 1),
(15, 6, 1),
(15, 7, 1),
(15, 8, 1),
(15, 9, 1),
(15, 10, 1),
(15, 11, 1),
(15, 12, 1),
(15, 13, 1),
(15, 14, 1),
(15, 15, 1),
(15, 16, 1),
(15, 17, 1),
(15, 18, 1),
(15, 19, 1),
(15, 20, 1),
(15, 21, 1),
(15, 22, 1),
(15, 23, 1),
(15, 24, 1),
(15, 25, 1),
(15, 26, 1),
(15, 27, 1),
(15, 28, 1),
(15, 29, 1),
(15, 30, 1),
(15, 31, 1),
(15, 32, 1),
(15, 33, 1),
(15, 34, 1),
(15, 35, 1),
(15, 36, 1),
(15, 37, 1),
(15, 38, 1),
(15, 39, 1),
(15, 40, 1),
(15, 41, 1),
(15, 42, 1),
(15, 43, 1),
(15, 44, 1),
(15, 45, 1),
(15, 46, 1),
(15, 47, 1),
(15, 48, 1),
(15, 49, 1),
(15, 50, 1),
(15, 51, 1),
(15, 52, 1),
(15, 53, 1),
(15, 54, 1),
(15, 55, 1),
(15, 56, 1),
(15, 57, 1),
(15, 58, 1),
(15, 59, 1),
(15, 60, 1),
(15, 61, 1),
(15, 62, 1),
(15, 63, 1),
(15, 64, 1),
(15, 65, 1),
(15, 66, 1),
(15, 67, 1),
(15, 68, 1),
(15, 69, 1),
(15, 70, 1),
(15, 71, 1),
(15, 72, 1),
(15, 73, 1),
(15, 74, 1),
(15, 75, 1),
(15, 76, 1),
(15, 77, 1),
(15, 78, 1),
(15, 79, 1),
(15, 80, 1),
(15, 81, 1),
(15, 83, 1),
(16, 1, 2),
(16, 2, 2),
(16, 3, 2),
(16, 4, 2),
(16, 5, 2),
(16, 6, 2),
(16, 7, 2),
(16, 8, 2),
(16, 9, 2),
(16, 10, 2),
(16, 11, 2),
(16, 12, 2),
(16, 13, 2),
(16, 14, 2),
(16, 15, 2),
(16, 16, 2),
(16, 17, 2),
(16, 18, 2),
(16, 19, 2),
(16, 20, 2),
(16, 21, 2),
(16, 22, 2),
(16, 23, 2),
(16, 24, 2),
(16, 25, 2),
(16, 26, 2),
(16, 27, 2),
(16, 28, 2),
(16, 29, 2),
(16, 30, 2),
(16, 31, 2),
(16, 32, 2),
(16, 33, 2),
(16, 34, 2),
(16, 35, 2),
(16, 36, 2),
(16, 37, 2),
(16, 38, 2),
(16, 39, 2),
(16, 40, 2),
(16, 41, 2),
(16, 42, 2),
(16, 43, 2),
(16, 44, 2),
(16, 45, 2),
(16, 46, 2),
(16, 47, 2),
(16, 48, 2),
(16, 49, 2),
(16, 50, 2),
(16, 51, 2),
(16, 52, 2),
(16, 53, 2),
(16, 54, 2),
(16, 55, 2),
(16, 56, 2),
(16, 57, 2),
(16, 58, 2),
(16, 59, 2),
(16, 60, 2),
(16, 61, 2),
(16, 62, 2),
(16, 63, 2),
(16, 64, 2),
(16, 65, 2),
(16, 66, 2),
(16, 67, 2),
(16, 68, 2),
(16, 69, 2),
(16, 70, 2),
(16, 71, 2),
(16, 72, 2),
(16, 73, 2),
(16, 74, 2),
(16, 75, 2),
(16, 76, 2),
(16, 77, 2),
(16, 78, 2),
(16, 79, 2),
(16, 80, 2),
(16, 81, 2),
(16, 83, 2),
(17, 1, 1),
(17, 2, 1),
(17, 3, 1),
(17, 4, 1),
(17, 5, 1),
(17, 6, 1),
(17, 7, 1),
(17, 8, 1),
(17, 9, 1),
(17, 10, 1),
(17, 11, 1),
(17, 12, 1),
(17, 13, 1),
(17, 14, 1),
(17, 15, 1),
(17, 16, 1),
(17, 17, 1),
(17, 18, 1),
(17, 19, 1),
(17, 20, 1),
(17, 21, 1),
(17, 22, 1),
(17, 23, 1),
(17, 24, 1),
(17, 25, 1),
(17, 26, 1),
(17, 27, 1),
(17, 28, 1),
(17, 29, 1),
(17, 30, 1),
(17, 31, 1),
(17, 32, 1),
(17, 33, 1),
(17, 34, 1),
(17, 35, 1),
(17, 36, 1),
(17, 37, 1),
(17, 38, 1),
(17, 39, 1),
(17, 40, 1),
(17, 41, 1),
(17, 42, 1),
(17, 43, 1),
(17, 44, 1),
(17, 45, 1),
(17, 46, 1),
(17, 47, 1),
(17, 48, 1),
(17, 49, 1),
(17, 50, 1),
(17, 51, 1),
(17, 52, 1),
(17, 53, 1),
(17, 54, 1),
(17, 55, 1),
(17, 56, 1),
(17, 57, 1),
(17, 58, 1),
(17, 59, 1),
(17, 60, 1),
(17, 61, 1),
(17, 62, 1),
(17, 63, 1),
(17, 64, 1),
(17, 65, 1),
(17, 66, 1),
(17, 67, 1),
(17, 68, 1),
(17, 69, 1),
(17, 70, 1),
(17, 71, 1),
(17, 72, 1),
(17, 73, 1),
(17, 74, 1),
(17, 75, 1),
(17, 76, 1),
(17, 77, 1),
(17, 78, 1),
(17, 79, 1),
(17, 80, 1),
(17, 81, 1),
(17, 83, 1),
(18, 1, 1),
(18, 2, 1),
(18, 3, 1),
(18, 4, 1),
(18, 5, 1),
(18, 6, 1),
(18, 7, 1),
(18, 8, 1),
(18, 9, 1),
(18, 10, 1),
(18, 11, 1),
(18, 12, 1),
(18, 13, 1),
(18, 14, 1),
(18, 15, 1),
(18, 16, 1),
(18, 17, 1),
(18, 18, 1),
(18, 19, 1),
(18, 20, 1),
(18, 21, 1),
(18, 22, 1),
(18, 23, 1),
(18, 24, 1),
(18, 25, 1),
(18, 26, 1),
(18, 27, 1),
(18, 28, 1),
(18, 29, 1),
(18, 30, 1),
(18, 31, 1),
(18, 32, 1),
(18, 33, 1),
(18, 34, 1),
(18, 35, 1),
(18, 36, 1),
(18, 37, 1),
(18, 38, 1),
(18, 39, 1),
(18, 40, 1),
(18, 41, 1),
(18, 42, 1),
(18, 43, 1),
(18, 44, 1),
(18, 45, 1),
(18, 46, 1),
(18, 47, 1),
(18, 48, 1),
(18, 49, 1),
(18, 50, 1),
(18, 51, 1),
(18, 52, 1),
(18, 53, 1),
(18, 54, 1),
(18, 55, 1),
(18, 56, 1),
(18, 57, 1),
(18, 58, 1),
(18, 59, 1),
(18, 60, 1),
(18, 61, 1),
(18, 62, 1),
(18, 63, 1),
(18, 64, 1),
(18, 65, 1),
(18, 66, 1),
(18, 67, 1),
(18, 68, 1),
(18, 69, 1),
(18, 70, 1),
(18, 71, 1),
(18, 72, 1),
(18, 73, 1),
(18, 74, 1),
(18, 75, 1),
(18, 76, 1),
(18, 77, 1),
(18, 78, 1),
(18, 79, 1),
(18, 80, 1),
(18, 81, 1),
(18, 83, 1),
(19, 1, 1),
(19, 2, 1),
(19, 3, 1),
(19, 4, 1),
(19, 5, 1),
(19, 6, 1),
(19, 7, 1),
(19, 8, 1),
(19, 9, 1),
(19, 10, 1),
(19, 11, 1),
(19, 12, 1),
(19, 13, 1),
(19, 14, 1),
(19, 15, 1),
(19, 16, 1),
(19, 17, 1),
(19, 18, 1),
(19, 19, 1),
(19, 20, 1),
(19, 21, 1),
(19, 22, 1),
(19, 23, 1),
(19, 24, 1),
(19, 25, 1),
(19, 26, 1),
(19, 27, 1),
(19, 28, 1),
(19, 29, 1),
(19, 30, 1),
(19, 31, 1),
(19, 32, 1),
(19, 33, 1),
(19, 34, 1),
(19, 35, 1),
(19, 36, 1),
(19, 37, 1),
(19, 38, 1),
(19, 39, 1),
(19, 40, 1),
(19, 41, 1),
(19, 42, 1),
(19, 43, 1),
(19, 44, 1),
(19, 45, 1),
(19, 46, 1),
(19, 47, 1),
(19, 48, 1),
(19, 49, 1),
(19, 50, 1),
(19, 51, 1),
(19, 52, 1),
(19, 53, 1),
(19, 54, 1),
(19, 55, 1),
(19, 56, 1),
(19, 57, 1),
(19, 58, 1),
(19, 59, 1),
(19, 60, 1),
(19, 61, 1),
(19, 62, 1),
(19, 63, 1),
(19, 64, 1),
(19, 65, 1),
(19, 66, 1),
(19, 67, 1),
(19, 68, 1),
(19, 69, 1),
(19, 70, 1),
(19, 71, 1),
(19, 72, 1),
(19, 73, 1),
(19, 74, 1),
(19, 75, 1),
(19, 76, 1),
(19, 77, 1),
(19, 78, 1),
(19, 79, 1),
(19, 80, 1),
(19, 81, 1),
(19, 83, 1),
(20, 1, 1),
(20, 2, 1),
(20, 3, 1),
(20, 4, 1),
(20, 5, 1),
(20, 6, 1),
(20, 7, 1),
(20, 8, 1),
(20, 9, 1),
(20, 10, 1),
(20, 11, 1),
(20, 12, 1),
(20, 13, 1),
(20, 14, 1),
(20, 15, 1),
(20, 16, 1),
(20, 17, 1),
(20, 18, 1),
(20, 19, 1),
(20, 20, 1),
(20, 21, 1),
(20, 22, 1),
(20, 23, 1),
(20, 24, 1),
(20, 25, 1),
(20, 26, 1),
(20, 27, 1),
(20, 28, 1),
(20, 29, 1),
(20, 30, 1),
(20, 31, 1),
(20, 32, 1),
(20, 33, 1),
(20, 34, 1),
(20, 35, 1),
(20, 36, 1),
(20, 37, 1),
(20, 38, 1),
(20, 39, 1),
(20, 40, 1),
(20, 41, 1),
(20, 42, 1),
(20, 43, 1),
(20, 44, 1),
(20, 45, 1),
(20, 46, 1),
(20, 47, 1),
(20, 48, 1),
(20, 49, 1),
(20, 50, 1),
(20, 51, 1),
(20, 52, 1),
(20, 53, 1),
(20, 54, 1),
(20, 55, 1),
(20, 56, 1),
(20, 57, 1),
(20, 58, 1),
(20, 59, 1),
(20, 60, 1),
(20, 61, 1),
(20, 62, 1),
(20, 63, 1),
(20, 64, 1),
(20, 65, 1),
(20, 66, 1),
(20, 67, 1),
(20, 68, 1),
(20, 69, 1),
(20, 70, 1),
(20, 71, 1),
(20, 72, 1),
(20, 73, 1),
(20, 74, 1),
(20, 75, 1),
(20, 76, 1),
(20, 77, 1),
(20, 78, 1),
(20, 79, 1),
(20, 80, 1),
(20, 81, 1),
(20, 83, 1),
(21, 1, 1),
(21, 2, 1),
(21, 3, 1),
(21, 4, 1),
(21, 5, 1),
(21, 6, 1),
(21, 7, 1),
(21, 8, 1),
(21, 9, 1),
(21, 10, 1),
(21, 11, 1),
(21, 12, 1),
(21, 13, 1),
(21, 14, 1),
(21, 15, 1),
(21, 16, 1),
(21, 17, 1),
(21, 18, 1),
(21, 19, 1),
(21, 20, 1),
(21, 21, 1),
(21, 22, 1),
(21, 23, 1),
(21, 24, 1),
(21, 25, 1),
(21, 26, 1),
(21, 27, 1),
(21, 28, 1),
(21, 29, 1),
(21, 30, 1),
(21, 31, 1),
(21, 32, 1),
(21, 33, 1),
(21, 34, 1),
(21, 35, 1),
(21, 36, 1),
(21, 37, 1),
(21, 38, 1),
(21, 39, 1),
(21, 40, 1),
(21, 41, 1),
(21, 42, 1),
(21, 43, 1),
(21, 44, 1),
(21, 45, 1),
(21, 46, 1),
(21, 47, 1),
(21, 48, 1),
(21, 49, 1),
(21, 50, 1),
(21, 51, 1),
(21, 52, 1),
(21, 53, 1),
(21, 54, 1),
(21, 55, 1),
(21, 56, 1),
(21, 57, 1),
(21, 58, 1),
(21, 59, 1),
(21, 60, 1),
(21, 61, 1),
(21, 62, 1),
(21, 63, 1),
(21, 64, 1),
(21, 65, 1),
(21, 66, 1),
(21, 67, 1),
(21, 68, 1),
(21, 69, 1),
(21, 70, 1),
(21, 71, 1),
(21, 72, 1),
(21, 73, 1),
(21, 74, 1),
(21, 75, 1),
(21, 76, 1),
(21, 77, 1),
(21, 78, 1),
(21, 79, 1),
(21, 80, 1),
(21, 81, 1),
(21, 83, 1),
(22, 1, 1),
(22, 2, 1),
(22, 3, 1),
(22, 4, 1),
(22, 5, 1),
(22, 6, 1),
(22, 7, 1),
(22, 8, 1),
(22, 9, 1),
(22, 10, 1),
(22, 11, 1),
(22, 12, 1),
(22, 13, 1),
(22, 14, 1),
(22, 15, 1),
(22, 16, 1),
(22, 17, 1),
(22, 18, 1),
(22, 19, 1),
(22, 20, 1),
(22, 21, 1),
(22, 22, 1),
(22, 23, 1),
(22, 24, 1),
(22, 25, 1),
(22, 26, 1),
(22, 27, 1),
(22, 28, 1),
(22, 29, 1),
(22, 30, 1),
(22, 31, 1),
(22, 32, 1),
(22, 33, 1),
(22, 34, 1),
(22, 35, 1),
(22, 36, 1),
(22, 37, 1),
(22, 38, 1),
(22, 39, 1),
(22, 40, 1),
(22, 41, 1),
(22, 42, 1),
(22, 43, 1),
(22, 44, 1),
(22, 45, 1),
(22, 46, 1),
(22, 47, 1),
(22, 48, 1),
(22, 49, 1),
(22, 50, 1),
(22, 51, 1),
(22, 52, 1),
(22, 53, 1),
(22, 54, 1),
(22, 55, 1),
(22, 56, 1),
(22, 57, 1),
(22, 58, 1),
(22, 59, 1),
(22, 60, 1),
(22, 61, 1),
(22, 62, 1),
(22, 63, 1),
(22, 64, 1),
(22, 65, 1),
(22, 66, 1),
(22, 67, 1),
(22, 68, 1),
(22, 69, 1),
(22, 70, 1),
(22, 71, 1),
(22, 72, 1),
(22, 73, 1),
(22, 74, 1),
(22, 75, 1),
(22, 76, 1),
(22, 77, 1),
(22, 78, 1),
(22, 79, 1),
(22, 80, 1),
(22, 81, 1),
(22, 83, 1),
(23, 1, 1),
(23, 2, 1),
(23, 3, 1),
(23, 4, 1),
(23, 5, 1),
(23, 6, 1),
(23, 7, 1),
(23, 8, 1),
(23, 9, 1),
(23, 10, 1),
(23, 11, 1),
(23, 12, 1),
(23, 13, 1),
(23, 14, 1),
(23, 15, 1),
(23, 16, 1),
(23, 17, 1),
(23, 18, 1),
(23, 19, 1),
(23, 20, 1),
(23, 21, 1),
(23, 22, 1),
(23, 23, 1),
(23, 24, 1),
(23, 25, 1),
(23, 26, 1),
(23, 27, 1),
(23, 28, 1),
(23, 29, 1),
(23, 30, 1),
(23, 31, 1),
(23, 32, 1),
(23, 33, 1),
(23, 34, 1),
(23, 35, 1),
(23, 36, 1),
(23, 37, 1),
(23, 38, 1),
(23, 39, 1),
(23, 40, 1),
(23, 41, 1),
(23, 42, 1),
(23, 43, 1),
(23, 44, 1),
(23, 45, 1),
(23, 46, 1),
(23, 47, 1),
(23, 48, 1),
(23, 49, 1),
(23, 50, 1),
(23, 51, 1),
(23, 52, 1),
(23, 53, 1),
(23, 54, 1),
(23, 55, 1),
(23, 56, 1),
(23, 57, 1),
(23, 58, 1),
(23, 59, 1),
(23, 60, 1),
(23, 61, 1),
(23, 62, 1),
(23, 63, 1),
(23, 64, 1),
(23, 65, 1),
(23, 66, 1),
(23, 67, 1),
(23, 68, 1),
(23, 69, 1),
(23, 70, 1),
(23, 71, 1),
(23, 72, 1),
(23, 73, 1),
(23, 74, 1),
(23, 75, 1),
(23, 76, 1),
(23, 77, 1),
(23, 78, 1),
(23, 79, 1),
(23, 80, 1),
(23, 81, 1),
(23, 83, 1),
(24, 1, 2),
(24, 2, 2),
(24, 3, 2),
(24, 4, 2),
(24, 5, 2),
(24, 6, 2),
(24, 7, 2),
(24, 8, 2),
(24, 9, 2),
(24, 10, 2),
(24, 11, 2),
(24, 12, 2),
(24, 13, 2),
(24, 14, 2),
(24, 15, 2),
(24, 16, 2),
(24, 17, 2),
(24, 18, 2),
(24, 19, 2),
(24, 20, 2),
(24, 21, 2),
(24, 22, 2),
(24, 23, 2),
(24, 24, 2),
(24, 25, 2),
(24, 26, 2),
(24, 27, 2),
(24, 28, 2),
(24, 29, 2),
(24, 30, 2),
(24, 31, 2),
(24, 32, 2),
(24, 33, 2),
(24, 34, 2),
(24, 35, 2),
(24, 36, 2),
(24, 37, 2),
(24, 38, 2),
(24, 39, 2),
(24, 40, 2),
(24, 41, 2),
(24, 42, 2),
(24, 43, 2),
(24, 44, 2),
(24, 45, 2),
(24, 46, 2),
(24, 47, 2),
(24, 48, 2),
(24, 49, 2),
(24, 50, 2),
(24, 51, 2),
(24, 52, 2),
(24, 53, 2),
(24, 54, 2),
(24, 55, 2),
(24, 56, 2),
(24, 57, 2),
(24, 58, 2),
(24, 59, 2),
(24, 60, 2),
(24, 61, 2),
(24, 62, 2),
(24, 63, 2),
(24, 64, 2),
(24, 65, 2),
(24, 66, 2),
(24, 67, 2),
(24, 68, 2),
(24, 69, 2),
(24, 70, 2),
(24, 71, 2),
(24, 72, 2),
(24, 73, 2),
(24, 74, 2),
(24, 75, 2),
(24, 76, 2),
(24, 77, 2),
(24, 78, 2),
(24, 79, 2),
(24, 80, 2),
(24, 81, 2),
(24, 83, 2),
(25, 1, 3),
(25, 2, 3),
(25, 3, 3),
(25, 4, 3),
(25, 5, 3),
(25, 6, 3),
(25, 7, 3),
(25, 8, 3),
(25, 9, 3),
(25, 10, 3),
(25, 11, 3),
(25, 12, 3),
(25, 13, 3),
(25, 14, 3),
(25, 15, 3),
(25, 16, 3),
(25, 17, 3),
(25, 18, 3),
(25, 19, 3),
(25, 20, 3),
(25, 21, 3),
(25, 22, 3),
(25, 23, 3),
(25, 24, 3),
(25, 25, 3),
(25, 26, 3),
(25, 27, 3),
(25, 28, 3),
(25, 29, 3),
(25, 30, 3),
(25, 31, 3),
(25, 32, 3),
(25, 33, 3),
(25, 34, 3),
(25, 35, 3),
(25, 36, 3),
(25, 37, 3),
(25, 38, 3),
(25, 39, 3),
(25, 40, 3),
(25, 41, 3),
(25, 42, 3),
(25, 43, 3),
(25, 44, 3),
(25, 45, 3),
(25, 46, 3),
(25, 47, 3),
(25, 48, 3),
(25, 49, 3),
(25, 50, 3),
(25, 51, 3),
(25, 52, 3),
(25, 53, 3),
(25, 54, 3),
(25, 55, 3),
(25, 56, 3),
(25, 57, 3),
(25, 58, 3),
(25, 59, 3),
(25, 60, 3),
(25, 61, 3),
(25, 62, 3),
(25, 63, 3),
(25, 64, 3),
(25, 65, 3),
(25, 66, 3),
(25, 67, 3),
(25, 68, 3),
(25, 69, 3),
(25, 70, 3),
(25, 71, 3),
(25, 72, 3),
(25, 73, 3),
(25, 74, 3),
(25, 75, 3),
(25, 76, 3),
(25, 77, 3),
(25, 78, 3),
(25, 79, 3),
(25, 80, 3),
(25, 81, 3),
(25, 83, 3),
(26, 1, 1),
(26, 2, 1),
(26, 3, 1),
(26, 4, 1),
(26, 5, 1),
(26, 6, 1),
(26, 7, 1),
(26, 8, 1),
(26, 9, 1),
(26, 10, 1),
(26, 11, 1),
(26, 12, 1),
(26, 13, 1),
(26, 14, 1),
(26, 15, 1),
(26, 16, 1),
(26, 17, 1),
(26, 18, 1),
(26, 19, 1),
(26, 20, 1),
(26, 21, 1),
(26, 22, 1),
(26, 23, 1),
(26, 24, 1),
(26, 25, 1),
(26, 26, 1),
(26, 27, 1),
(26, 28, 1),
(26, 29, 1),
(26, 30, 1),
(26, 31, 1),
(26, 32, 1),
(26, 33, 1),
(26, 34, 1),
(26, 35, 1),
(26, 36, 1),
(26, 37, 1),
(26, 38, 1),
(26, 39, 1),
(26, 40, 1),
(26, 41, 1),
(26, 42, 1),
(26, 43, 1),
(26, 44, 1),
(26, 45, 1),
(26, 46, 1),
(26, 47, 1),
(26, 48, 1),
(26, 49, 1),
(26, 50, 1),
(26, 51, 1),
(26, 52, 1),
(26, 53, 1),
(26, 54, 1),
(26, 55, 1),
(26, 56, 1),
(26, 57, 1),
(26, 58, 1),
(26, 59, 1),
(26, 60, 1),
(26, 61, 1),
(26, 62, 1),
(26, 63, 1),
(26, 64, 1),
(26, 65, 1),
(26, 66, 1),
(26, 67, 1),
(26, 68, 1),
(26, 69, 1),
(26, 70, 1),
(26, 71, 1),
(26, 72, 1),
(26, 73, 1),
(26, 74, 1),
(26, 75, 1),
(26, 76, 1),
(26, 77, 1),
(26, 78, 1),
(26, 79, 1),
(26, 80, 1),
(26, 81, 1),
(26, 83, 1),
(27, 1, 2),
(27, 2, 2),
(27, 3, 2),
(27, 4, 2),
(27, 5, 2),
(27, 6, 2),
(27, 7, 2),
(27, 8, 2),
(27, 9, 2),
(27, 10, 2),
(27, 11, 2),
(27, 12, 2),
(27, 13, 2),
(27, 14, 2),
(27, 15, 2),
(27, 16, 2),
(27, 17, 2),
(27, 18, 2),
(27, 19, 2),
(27, 20, 2),
(27, 21, 2),
(27, 22, 2),
(27, 23, 2),
(27, 24, 2),
(27, 25, 2),
(27, 26, 2),
(27, 27, 2),
(27, 28, 2),
(27, 29, 2),
(27, 30, 2),
(27, 31, 2),
(27, 32, 2),
(27, 33, 2),
(27, 34, 2),
(27, 35, 2),
(27, 36, 2),
(27, 37, 2),
(27, 38, 2),
(27, 39, 2),
(27, 40, 2),
(27, 41, 2),
(27, 42, 2),
(27, 43, 2),
(27, 44, 2),
(27, 45, 2),
(27, 46, 2),
(27, 47, 2),
(27, 48, 2),
(27, 49, 2),
(27, 50, 2),
(27, 51, 2),
(27, 52, 2),
(27, 53, 2),
(27, 54, 2),
(27, 55, 2),
(27, 56, 2),
(27, 57, 2),
(27, 58, 2),
(27, 59, 2),
(27, 60, 2),
(27, 61, 2),
(27, 62, 2),
(27, 63, 2),
(27, 64, 2),
(27, 65, 2),
(27, 66, 2),
(27, 67, 2),
(27, 68, 2),
(27, 69, 2),
(27, 70, 2),
(27, 71, 2),
(27, 72, 2),
(27, 73, 2),
(27, 74, 2),
(27, 75, 2),
(27, 76, 2),
(27, 77, 2),
(27, 78, 2),
(27, 79, 2),
(27, 80, 2),
(27, 81, 2),
(27, 83, 2),
(28, 1, 3),
(28, 2, 3),
(28, 3, 3),
(28, 4, 3),
(28, 5, 3),
(28, 6, 3),
(28, 7, 3),
(28, 8, 3),
(28, 9, 3),
(28, 10, 3),
(28, 11, 3),
(28, 12, 3),
(28, 13, 3),
(28, 14, 3),
(28, 15, 3),
(28, 16, 3),
(28, 17, 3),
(28, 18, 3),
(28, 19, 3),
(28, 20, 3),
(28, 21, 3),
(28, 22, 3),
(28, 23, 3),
(28, 24, 3),
(28, 25, 3),
(28, 26, 3),
(28, 27, 3),
(28, 28, 3),
(28, 29, 3),
(28, 30, 3),
(28, 31, 3),
(28, 32, 3),
(28, 33, 3),
(28, 34, 3),
(28, 35, 3),
(28, 36, 3),
(28, 37, 3),
(28, 38, 3),
(28, 39, 3),
(28, 40, 3),
(28, 41, 3),
(28, 42, 3),
(28, 43, 3),
(28, 44, 3),
(28, 45, 3),
(28, 46, 3),
(28, 47, 3),
(28, 48, 3),
(28, 49, 3),
(28, 50, 3),
(28, 51, 3),
(28, 52, 3),
(28, 53, 3),
(28, 54, 3),
(28, 55, 3),
(28, 56, 3),
(28, 57, 3),
(28, 58, 3),
(28, 59, 3),
(28, 60, 3),
(28, 61, 3),
(28, 62, 3),
(28, 63, 3),
(28, 64, 3),
(28, 65, 3),
(28, 66, 3),
(28, 67, 3),
(28, 68, 3),
(28, 69, 3),
(28, 70, 3),
(28, 71, 3),
(28, 72, 3),
(28, 73, 3),
(28, 74, 3),
(28, 75, 3),
(28, 76, 3),
(28, 77, 3),
(28, 78, 3),
(28, 79, 3),
(28, 80, 3),
(28, 81, 3),
(28, 83, 3),
(29, 1, 4),
(29, 2, 4),
(29, 3, 4),
(29, 4, 4),
(29, 5, 4),
(29, 6, 4),
(29, 7, 4),
(29, 8, 4),
(29, 9, 4),
(29, 10, 4),
(29, 11, 4),
(29, 12, 4),
(29, 13, 4),
(29, 14, 4),
(29, 15, 4),
(29, 16, 4),
(29, 17, 4),
(29, 18, 4),
(29, 19, 4),
(29, 20, 4),
(29, 21, 4),
(29, 22, 4),
(29, 23, 4),
(29, 24, 4),
(29, 25, 4),
(29, 26, 4),
(29, 27, 4),
(29, 28, 4),
(29, 29, 4),
(29, 30, 4),
(29, 31, 4),
(29, 32, 4),
(29, 33, 4),
(29, 34, 4),
(29, 35, 4),
(29, 36, 4),
(29, 37, 4),
(29, 38, 4),
(29, 39, 4),
(29, 40, 4),
(29, 41, 4),
(29, 42, 4),
(29, 43, 4),
(29, 44, 4),
(29, 45, 4),
(29, 46, 4),
(29, 47, 4),
(29, 48, 4),
(29, 49, 4),
(29, 50, 4),
(29, 51, 4),
(29, 52, 4),
(29, 53, 4),
(29, 54, 4),
(29, 55, 4),
(29, 56, 4),
(29, 57, 4),
(29, 58, 4),
(29, 59, 4),
(29, 60, 4),
(29, 61, 4),
(29, 62, 4),
(29, 63, 4),
(29, 64, 4),
(29, 65, 4),
(29, 66, 4),
(29, 67, 4),
(29, 68, 4),
(29, 69, 4),
(29, 70, 4),
(29, 71, 4),
(29, 72, 4),
(29, 73, 4),
(29, 74, 4),
(29, 75, 4),
(29, 76, 4),
(29, 77, 4),
(29, 78, 4),
(29, 79, 4),
(29, 80, 4),
(29, 81, 4),
(29, 83, 4),
(30, 1, 1),
(30, 2, 1),
(30, 3, 1),
(30, 4, 1),
(30, 5, 1),
(30, 6, 1),
(30, 7, 1),
(30, 8, 1),
(30, 9, 1),
(30, 10, 1),
(30, 11, 1),
(30, 12, 1),
(30, 13, 1),
(30, 14, 1),
(30, 15, 1),
(30, 16, 1),
(30, 17, 1),
(30, 18, 1),
(30, 19, 1),
(30, 20, 1),
(30, 21, 1),
(30, 22, 1),
(30, 23, 1),
(30, 24, 1),
(30, 25, 1),
(30, 26, 1),
(30, 27, 1),
(30, 28, 1),
(30, 29, 1),
(30, 30, 1),
(30, 31, 1),
(30, 32, 1),
(30, 33, 1),
(30, 34, 1),
(30, 35, 1),
(30, 36, 1),
(30, 37, 1),
(30, 38, 1),
(30, 39, 1),
(30, 40, 1),
(30, 41, 1),
(30, 42, 1),
(30, 43, 1),
(30, 44, 1),
(30, 45, 1),
(30, 46, 1),
(30, 47, 1),
(30, 48, 1),
(30, 49, 1),
(30, 50, 1),
(30, 51, 1),
(30, 52, 1),
(30, 53, 1),
(30, 54, 1),
(30, 55, 1),
(30, 56, 1),
(30, 57, 1),
(30, 58, 1),
(30, 59, 1),
(30, 60, 1),
(30, 61, 1),
(30, 62, 1),
(30, 63, 1),
(30, 64, 1),
(30, 65, 1),
(30, 66, 1),
(30, 67, 1),
(30, 68, 1),
(30, 69, 1),
(30, 70, 1),
(30, 71, 1),
(30, 72, 1),
(30, 73, 1),
(30, 74, 1),
(30, 75, 1),
(30, 76, 1),
(30, 77, 1),
(30, 78, 1),
(30, 79, 1),
(30, 80, 1),
(30, 81, 1),
(30, 83, 1),
(31, 1, 1),
(31, 2, 1),
(31, 3, 1),
(31, 4, 1),
(31, 5, 1),
(31, 6, 1),
(31, 7, 1),
(31, 8, 1),
(31, 9, 1),
(31, 10, 1),
(31, 11, 1),
(31, 12, 1),
(31, 13, 1),
(31, 14, 1),
(31, 15, 1),
(31, 16, 1),
(31, 17, 1),
(31, 18, 1),
(31, 19, 1),
(31, 20, 1),
(31, 21, 1),
(31, 22, 1),
(31, 23, 1),
(31, 24, 1),
(31, 25, 1),
(31, 26, 1),
(31, 27, 1),
(31, 28, 1),
(31, 29, 1),
(31, 30, 1),
(31, 31, 1),
(31, 32, 1),
(31, 33, 1),
(31, 34, 1),
(31, 35, 1),
(31, 36, 1),
(31, 37, 1),
(31, 38, 1),
(31, 39, 1),
(31, 40, 1),
(31, 41, 1),
(31, 42, 1),
(31, 43, 1),
(31, 44, 1),
(31, 45, 1),
(31, 46, 1),
(31, 47, 1),
(31, 48, 1),
(31, 49, 1),
(31, 50, 1),
(31, 51, 1),
(31, 52, 1),
(31, 53, 1),
(31, 54, 1),
(31, 55, 1),
(31, 56, 1),
(31, 57, 1),
(31, 58, 1),
(31, 59, 1),
(31, 60, 1),
(31, 61, 1),
(31, 62, 1),
(31, 63, 1),
(31, 64, 1),
(31, 65, 1),
(31, 66, 1),
(31, 67, 1),
(31, 68, 1),
(31, 69, 1),
(31, 70, 1),
(31, 71, 1),
(31, 72, 1),
(31, 73, 1),
(31, 74, 1),
(31, 75, 1),
(31, 76, 1),
(31, 77, 1),
(31, 78, 1),
(31, 79, 1),
(31, 80, 1),
(31, 81, 1),
(31, 83, 1),
(32, 1, 1),
(32, 2, 1),
(32, 3, 1),
(32, 4, 1),
(32, 5, 1),
(32, 6, 1),
(32, 7, 1),
(32, 8, 1),
(32, 9, 1),
(32, 10, 1),
(32, 11, 1),
(32, 12, 1),
(32, 13, 1),
(32, 14, 1),
(32, 15, 1),
(32, 16, 1),
(32, 17, 1),
(32, 18, 1),
(32, 19, 1),
(32, 20, 1),
(32, 21, 1),
(32, 22, 1),
(32, 23, 1),
(32, 24, 1),
(32, 25, 1),
(32, 26, 1),
(32, 27, 1),
(32, 28, 1),
(32, 29, 1),
(32, 30, 1),
(32, 31, 1),
(32, 32, 1),
(32, 33, 1),
(32, 34, 1),
(32, 35, 1),
(32, 36, 1),
(32, 37, 1),
(32, 38, 1),
(32, 39, 1),
(32, 40, 1),
(32, 41, 1),
(32, 42, 1),
(32, 43, 1),
(32, 44, 1),
(32, 45, 1),
(32, 46, 1),
(32, 47, 1),
(32, 48, 1),
(32, 49, 1),
(32, 50, 1),
(32, 51, 1),
(32, 52, 1),
(32, 53, 1),
(32, 54, 1),
(32, 55, 1),
(32, 56, 1),
(32, 57, 1),
(32, 58, 1),
(32, 59, 1),
(32, 60, 1),
(32, 61, 1),
(32, 62, 1),
(32, 63, 1),
(32, 64, 1),
(32, 65, 1),
(32, 66, 1),
(32, 67, 1),
(32, 68, 1),
(32, 69, 1),
(32, 70, 1),
(32, 71, 1),
(32, 72, 1),
(32, 73, 1),
(32, 74, 1),
(32, 75, 1),
(32, 76, 1),
(32, 77, 1),
(32, 78, 1),
(32, 79, 1),
(32, 80, 1),
(32, 81, 1),
(32, 83, 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_comment`
--

CREATE TABLE `nv5_en_comment` (
  `cid` mediumint(8) UNSIGNED NOT NULL,
  `module` varchar(55) NOT NULL,
  `area` char(50) NOT NULL DEFAULT '',
  `id` char(50) NOT NULL DEFAULT '',
  `pid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `content` text NOT NULL,
  `attach` varchar(255) NOT NULL DEFAULT '',
  `post_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `post_name` varchar(100) NOT NULL,
  `post_email` varchar(100) NOT NULL,
  `post_ip` varchar(39) NOT NULL DEFAULT '',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `likes` mediumint(9) NOT NULL DEFAULT 0,
  `dislikes` mediumint(9) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_contact_department`
--

CREATE TABLE `nv5_en_contact_department` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `full_name` varchar(250) NOT NULL,
  `alias` varchar(250) NOT NULL,
  `image` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(255) NOT NULL,
  `fax` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `address` varchar(255) NOT NULL,
  `note` text NOT NULL,
  `others` text NOT NULL,
  `cats` text NOT NULL,
  `admins` text NOT NULL,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `weight` smallint(5) NOT NULL,
  `is_default` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_contact_department`
--

INSERT INTO `nv5_en_contact_department` (`id`, `full_name`, `alias`, `image`, `phone`, `fax`, `email`, `address`, `note`, `others`, `cats`, `admins`, `act`, `weight`, `is_default`) VALUES
(1, 'Consumer Care Division', 'Consumer-Care', '', '(08) 38.000.000[+84838000000]', '08 38.000.001', 'customer@mysite.com', '', 'Receive requests, suggestions, comments relating to the operations of company', '{\"viber\":\"myViber\",\"skype\":\"mySkype\"}', '[\"Consulting\",\"Complaints\",\"Cooperation\"]', '', 1, 1, 1),
(2, 'Technical Department', 'Technical', '', '(08) 38.000.002[+84838000002]', '08 38.000.003', 'technical@mysite.com', '', 'Resolve technical issues', '{\"viber\":\"myViber2\",\"skype\":\"mySkype2\"}', '[\"Bug Reports\",\"Recommendations to improve\"]', '', 1, 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_contact_reply`
--

CREATE TABLE `nv5_en_contact_reply` (
  `rid` mediumint(8) UNSIGNED NOT NULL,
  `id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `reply_recipient` varchar(255) NOT NULL DEFAULT '',
  `reply_cc` varchar(255) NOT NULL DEFAULT '',
  `reply_content` text DEFAULT NULL,
  `reply_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `reply_aid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_contact_send`
--

CREATE TABLE `nv5_en_contact_send` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `cid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `cat` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `send_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `sender_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `sender_name` varchar(100) NOT NULL,
  `sender_address` varchar(250) NOT NULL,
  `sender_email` varchar(100) NOT NULL,
  `sender_phone` varchar(20) DEFAULT '',
  `sender_ip` varchar(39) NOT NULL DEFAULT '',
  `auto_forward` varchar(250) NOT NULL DEFAULT '',
  `is_read` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `is_reply` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `read_admins` text DEFAULT NULL,
  `is_processed` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `processed_by` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `processed_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_contact_supporter`
--

CREATE TABLE `nv5_en_contact_supporter` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `departmentid` smallint(5) UNSIGNED NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `others` text NOT NULL,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `weight` smallint(5) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_freecontent_blocks`
--

CREATE TABLE `nv5_en_freecontent_blocks` (
  `bid` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_freecontent_blocks`
--

INSERT INTO `nv5_en_freecontent_blocks` (`bid`, `title`, `description`) VALUES
(1, 'Sản phẩm', 'Sản phẩm của công ty cổ phần phát triển nguồn mở Việt Nam - VINADES.,JSC');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_freecontent_rows`
--

CREATE TABLE `nv5_en_freecontent_rows` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `bid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL,
  `link` varchar(255) NOT NULL DEFAULT '',
  `target` varchar(10) NOT NULL DEFAULT '' COMMENT '_blank|_self|_parent|_top',
  `image` varchar(255) NOT NULL DEFAULT '',
  `start_time` int(11) NOT NULL DEFAULT 0,
  `end_time` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: In-Active, 1: Active, 2: Expired'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_freecontent_rows`
--

INSERT INTO `nv5_en_freecontent_rows` (`id`, `bid`, `title`, `description`, `link`, `target`, `image`, `start_time`, `end_time`, `status`) VALUES
(1, 1, 'Hệ quản trị nội dung NukeViet', '<ul>\n	<li>Giải thưởng Nhân tài đất Việt 2011, 10.000+ website đang sử dụng</li>\n	<li>Được Bộ GD&amp;ĐT khuyến khích sử dụng trong các cơ sở giáo dục</li>\n	<li>Bộ TT&amp;TT quy định ưu tiên sử dụng trong cơ quan nhà nước</li>\n</ul>', 'https://vinades.vn/vi/san-pham/nukeviet/', '_blank', 'nukeviet.jpg', 1759423352, 0, 1),
(2, 1, 'Cổng thông tin doanh nghiệp', '<ul>\n	<li>Tích hợp bán hàng trực tuyến</li>\n	<li>Tích hợp các nghiệp vụ quản lý (quản lý khách hàng, quản lý nhân sự, quản lý tài liệu)</li>\n</ul>', 'https://vinades.vn/vi/san-pham/Cong-thong-tin-doanh-nghiep-NukeViet-portal/', '_blank', 'nukeviet-portal.jpg', 1759423352, 0, 1),
(3, 1, 'Cổng thông tin Phòng giáo dục, Sở giáo dục', '<ul>\n	<li>Tích hợp chung website hàng trăm trường</li>\n	<li>Tích hợp các ứng dụng trực tuyến (Tra điểm SMS, Tra cứu văn bằng, Học bạ điện tử ...)</li>\n</ul>', 'https://vinades.vn/vi/san-pham/Cong-thong-tin-giao-duc-NukeViet-Edugate/', '_blank', 'nukeviet-edu.jpg', 1759423352, 0, 1),
(4, 1, 'Tòa soạn báo điện tử chuyên nghiệp', '<ul>\n	<li>Bảo mật đa tầng, phân quyền linh hoạt</li>\n	<li>Hệ thống bóc tin tự động, đăng bài tự động, cùng nhiều chức năng tiên tiến khác...</li>\n</ul>', 'https://vinades.vn/vi/san-pham/Toa-soan-bao-dien-tu/', '_blank', 'nukeviet-toasoan.jpg', 1759423352, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_menu`
--

CREATE TABLE `nv5_en_menu` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_menu`
--

INSERT INTO `nv5_en_menu` (`id`, `title`) VALUES
(1, 'Top Menu');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_menu_rows`
--

CREATE TABLE `nv5_en_menu_rows` (
  `id` mediumint(5) NOT NULL,
  `parentid` mediumint(5) UNSIGNED NOT NULL,
  `mid` smallint(5) NOT NULL DEFAULT 0,
  `title` varchar(255) NOT NULL,
  `link` text NOT NULL,
  `icon` varchar(255) DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `note` varchar(255) DEFAULT '',
  `weight` int(11) NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `lev` int(11) NOT NULL DEFAULT 0,
  `subitem` text DEFAULT NULL,
  `groups_view` varchar(255) DEFAULT '',
  `module_name` varchar(255) DEFAULT '',
  `op` varchar(255) DEFAULT '',
  `target` tinyint(4) DEFAULT 0,
  `css` varchar(255) DEFAULT '',
  `active_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_menu_rows`
--

INSERT INTO `nv5_en_menu_rows` (`id`, `parentid`, `mid`, `title`, `link`, `icon`, `image`, `note`, `weight`, `sort`, `lev`, `subitem`, `groups_view`, `module_name`, `op`, `target`, `css`, `active_type`, `status`) VALUES
(1, 0, 1, 'About', '/nukeviet/index.php?language=en&nv=about', '', '', '', 1, 1, 0, '', '6', 'about', '', 1, '', 1, 1),
(2, 0, 1, 'News', '/nukeviet/index.php?language=en&nv=news', '', '', '', 2, 2, 0, '', '6', 'news', '', 1, '', 1, 1),
(3, 0, 1, 'Users', '/nukeviet/index.php?language=en&nv=users', '', '', '', 3, 3, 0, '6,7,8,9,10,11', '6', 'users', '', 1, '', 1, 1),
(4, 0, 1, 'Voting', '/nukeviet/index.php?language=en&nv=voting', '', '', '', 4, 10, 0, '', '6', 'voting', '', 1, '', 1, 1),
(5, 0, 1, 'Contact', '/nukeviet/index.php?language=en&nv=contact', '', '', '', 5, 11, 0, '', '6', 'contact', '', 1, '', 1, 1),
(6, 3, 1, 'Login', '/nukeviet/index.php?language=en&nv=users&op=login', '', '', '', 1, 4, 1, '', '5', 'users', 'login', 1, '', 1, 1),
(7, 3, 1, 'Register', '/nukeviet/index.php?language=en&nv=users&op=register', '', '', '', 2, 5, 1, '', '5', 'users', 'register', 1, '', 1, 1),
(8, 3, 1, 'Password recovery', '/nukeviet/index.php?language=en&nv=users&op=lostpass', '', '', '', 3, 6, 1, '', '5', 'users', 'lostpass', 1, '', 1, 1),
(9, 3, 1, 'Account Settings', '/nukeviet/index.php?language=en&nv=users&op=editinfo', '', '', '', 4, 7, 1, '', '4,7', 'users', 'editinfo', 1, '', 1, 1),
(10, 3, 1, 'Members list', '/nukeviet/index.php?language=en&nv=users&op=memberlist', '', '', '', 5, 8, 1, '', '4,7', 'users', 'memberlist', 1, '', 1, 1),
(11, 3, 1, 'Logout', '/nukeviet/index.php?language=en&nv=users&op=logout', '', '', '', 6, 9, 1, '', '4,7', 'users', 'logout', 1, '', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_modblocks`
--

CREATE TABLE `nv5_en_modblocks` (
  `module_name` varchar(50) NOT NULL COMMENT 'Tên module',
  `tag` varchar(100) NOT NULL COMMENT 'Tag của khối block',
  `ini_tag` varchar(160) NOT NULL COMMENT 'Tag tương đương trong config ini',
  `title` varchar(250) NOT NULL DEFAULT '' COMMENT 'Tên gọi nếu có'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vị trí block tùy chỉnh theo từng module';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_modfuncs`
--

CREATE TABLE `nv5_en_modfuncs` (
  `func_id` mediumint(8) UNSIGNED NOT NULL,
  `func_name` varchar(55) NOT NULL,
  `alias` varchar(55) NOT NULL DEFAULT '',
  `func_custom_name` varchar(255) NOT NULL,
  `func_site_title` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `in_module` varchar(50) NOT NULL,
  `show_func` tinyint(4) NOT NULL DEFAULT 0,
  `in_submenu` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `subweight` smallint(2) UNSIGNED NOT NULL DEFAULT 1,
  `setting` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Func của module';

--
-- Dumping data for table `nv5_en_modfuncs`
--

INSERT INTO `nv5_en_modfuncs` (`func_id`, `func_name`, `alias`, `func_custom_name`, `func_site_title`, `description`, `in_module`, `show_func`, `in_submenu`, `subweight`, `setting`) VALUES
(1, 'main', 'main', 'Main', '', '', 'about', 1, 0, 1, ''),
(2, 'sitemap', 'sitemap', 'Sitemap', '', '', 'about', 0, 0, 0, ''),
(3, 'rss', 'rss', 'Rss', '', '', 'about', 0, 0, 0, ''),
(4, 'main', 'main', 'Main', '', '', 'news', 1, 0, 1, ''),
(5, 'viewcat', 'viewcat', 'Viewcat', '', '', 'news', 1, 0, 2, ''),
(6, 'topic', 'topic', 'Topic', '', '', 'news', 1, 0, 3, ''),
(7, 'content', 'content', 'Content', '', '', 'news', 1, 1, 4, ''),
(8, 'detail', 'detail', 'Detail', '', '', 'news', 1, 0, 5, ''),
(9, 'tag', 'tag', 'Tag', '', '', 'news', 1, 0, 6, ''),
(10, 'rss', 'rss', 'Rss', '', '', 'news', 1, 1, 7, ''),
(11, 'search', 'search', 'Search', '', '', 'news', 1, 1, 8, ''),
(12, 'groups', 'groups', 'Groups', '', '', 'news', 1, 0, 9, ''),
(13, 'author', 'author', 'Author', '', '', 'news', 1, 0, 10, ''),
(14, 'sitemap', 'sitemap', 'Sitemap', '', '', 'news', 0, 0, 0, ''),
(15, 'print', 'print', 'Print', '', '', 'news', 0, 0, 0, ''),
(16, 'rating', 'rating', 'Rating', '', '', 'news', 0, 0, 0, ''),
(17, 'savefile', 'savefile', 'Savefile', '', '', 'news', 0, 0, 0, ''),
(18, 'sendmail', 'sendmail', 'Sendmail', '', '', 'news', 0, 0, 0, ''),
(19, 'instant-rss', 'instant-rss', 'Instant Articles RSS', '', '', 'news', 0, 0, 0, ''),
(20, 'main', 'main', 'Main', '', '', 'users', 1, 0, 1, ''),
(21, 'login', 'login', 'Login', '', '', 'users', 1, 1, 2, ''),
(22, 'register', 'register', 'Register', '', '', 'users', 1, 1, 3, ''),
(23, 'lostpass', 'lostpass', 'Password recovery', '', '', 'users', 1, 1, 4, ''),
(24, 'active', 'active', 'Active account', '', '', 'users', 1, 0, 5, ''),
(25, 'lostactivelink', 'lostactivelink', 'Retrieve activation link', '', '', 'users', 1, 0, 6, ''),
(26, 'r2s', 'r2s', 'Turn off 2-step authentication', '', '', 'users', 1, 0, 7, ''),
(27, 'editinfo', 'editinfo', 'Account Settings', '', '', 'users', 1, 1, 8, ''),
(28, 'memberlist', 'memberlist', 'Members list', '', '', 'users', 1, 1, 9, ''),
(29, 'groups', 'groups', 'Group management', '', '', 'users', 1, 1, 10, ''),
(30, 'avatar', 'avatar', 'Avatar', '', '', 'users', 1, 0, 11, ''),
(31, 'logout', 'logout', 'Logout', '', '', 'users', 1, 1, 12, ''),
(32, 'oauth', 'oauth', 'Oauth', '', '', 'users', 0, 0, 0, ''),
(33, 'main', 'main', 'Main', '', '', 'myapi', 1, 0, 1, ''),
(34, 'main', 'main', 'Main', '', '', 'inform', 1, 0, 1, ''),
(35, 'main', 'main', 'Main', '', '', 'contact', 1, 0, 1, ''),
(36, 'main', 'main', 'Main', '', '', 'statistics', 1, 0, 1, ''),
(37, 'allreferers', 'allreferers', 'By referrers', '', '', 'statistics', 1, 1, 2, ''),
(38, 'allcountries', 'allcountries', 'By countries', '', '', 'statistics', 1, 1, 3, ''),
(39, 'allbrowsers', 'allbrowsers', 'By browsers ', '', '', 'statistics', 1, 1, 4, ''),
(40, 'allos', 'allos', 'By operating system', '', '', 'statistics', 1, 1, 5, ''),
(41, 'allbots', 'allbots', 'By search engines', '', '', 'statistics', 1, 1, 6, ''),
(42, 'referer', 'referer', 'By month', '', '', 'statistics', 1, 0, 7, ''),
(43, 'main', 'main', 'Main', '', '', 'voting', 1, 0, 1, ''),
(44, 'main', 'main', 'Main', '', '', 'banners', 1, 0, 1, ''),
(45, 'addads', 'addads', 'Addads', '', '', 'banners', 1, 0, 2, ''),
(46, 'clientinfo', 'clientinfo', 'Clientinfo', '', '', 'banners', 1, 0, 3, ''),
(47, 'stats', 'stats', 'Stats', '', '', 'banners', 1, 0, 4, ''),
(48, 'cledit', 'cledit', 'Cledit', '', '', 'banners', 0, 0, 0, ''),
(49, 'click', 'click', 'Click', '', '', 'banners', 0, 0, 0, ''),
(50, 'clinfo', 'clinfo', 'Clinfo', '', '', 'banners', 0, 0, 0, ''),
(51, 'logininfo', 'logininfo', 'Logininfo', '', '', 'banners', 0, 0, 0, ''),
(52, 'viewmap', 'viewmap', 'Viewmap', '', '', 'banners', 0, 0, 0, ''),
(53, 'main', 'main', 'Main', '', '', 'seek', 1, 0, 1, ''),
(54, 'opensearch', 'opensearch', 'Opensearch', '', '', 'seek', 0, 0, 0, ''),
(55, 'main', 'main', 'Main', '', '', 'feeds', 1, 0, 1, ''),
(56, 'main', 'main', 'Main', '', '', 'page', 1, 0, 1, ''),
(57, 'sitemap', 'sitemap', 'Sitemap', '', '', 'page', 0, 0, 0, ''),
(58, 'rss', 'rss', 'Rss', '', '', 'page', 0, 0, 0, ''),
(59, 'main', 'main', 'Main', '', '', 'comment', 1, 0, 1, ''),
(60, 'post', 'post', 'Post', '', '', 'comment', 1, 0, 2, ''),
(61, 'like', 'like', 'Like', '', '', 'comment', 1, 0, 3, ''),
(62, 'delete', 'delete', 'Delete', '', '', 'comment', 1, 0, 4, ''),
(63, 'down', 'down', 'Down', '', '', 'comment', 1, 0, 5, ''),
(64, 'main', 'main', 'Main', '', '', 'siteterms', 1, 0, 1, ''),
(65, 'rss', 'rss', 'Rss', '', '', 'siteterms', 1, 0, 2, ''),
(66, 'sitemap', 'sitemap', 'Sitemap', '', '', 'siteterms', 0, 0, 0, ''),
(67, 'main', 'main', 'Main', '', '', 'two-step-verification', 1, 0, 1, ''),
(68, 'confirm', 'confirm', 'Confirm', '', '', 'two-step-verification', 1, 0, 2, ''),
(69, 'setup', 'setup', 'Setup', '', '', 'two-step-verification', 1, 0, 3, ''),
(70, 'qrimg', 'qrimg', 'Qrimg', '', '', 'two-step-verification', 0, 0, 0, ''),
(71, 'main', 'main', 'Main', '', '', 'test', 1, 0, 1, ''),
(81, 'detail', 'detail', 'Detail', '', '', 'dictionary', 1, 0, 2, ''),
(82, 'download_audio', 'download_audio', 'Download_audio', '', '', 'dictionary', 0, 0, 0, ''),
(83, 'main', 'main', 'Main', '', '', 'dictionary', 1, 0, 1, '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_modthemes`
--

CREATE TABLE `nv5_en_modthemes` (
  `func_id` mediumint(8) DEFAULT NULL,
  `layout` varchar(100) DEFAULT NULL,
  `theme` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Layout của giao diện theo từng khu vực';

--
-- Dumping data for table `nv5_en_modthemes`
--

INSERT INTO `nv5_en_modthemes` (`func_id`, `layout`, `theme`) VALUES
(0, 'left-main-right', 'default'),
(0, 'main', 'mobile_default'),
(1, 'left-main-right', 'default'),
(1, 'main', 'mobile_default'),
(4, 'left-main-right', 'default'),
(4, 'main', 'mobile_default'),
(5, 'left-main-right', 'default'),
(5, 'main', 'mobile_default'),
(6, 'left-main-right', 'default'),
(6, 'main', 'mobile_default'),
(7, 'left-main-right', 'default'),
(7, 'main', 'mobile_default'),
(8, 'left-main-right', 'default'),
(8, 'main', 'mobile_default'),
(9, 'left-main-right', 'default'),
(9, 'main', 'mobile_default'),
(10, 'left-main-right', 'default'),
(11, 'left-main-right', 'default'),
(11, 'main', 'mobile_default'),
(12, 'left-main-right', 'default'),
(12, 'main', 'mobile_default'),
(13, 'left-main-right', 'default'),
(13, 'main', 'mobile_default'),
(20, 'left-main', 'default'),
(20, 'main', 'mobile_default'),
(21, 'left-main', 'default'),
(21, 'main', 'mobile_default'),
(22, 'left-main', 'default'),
(22, 'main', 'mobile_default'),
(23, 'left-main', 'default'),
(23, 'main', 'mobile_default'),
(24, 'left-main', 'default'),
(24, 'main', 'mobile_default'),
(25, 'left-main', 'default'),
(25, 'main', 'mobile_default'),
(26, 'left-main', 'default'),
(26, 'main', 'mobile_default'),
(27, 'left-main', 'default'),
(27, 'main', 'mobile_default'),
(28, 'left-main', 'default'),
(28, 'main', 'mobile_default'),
(29, 'left-main', 'default'),
(29, 'main', 'mobile_default'),
(30, 'left-main', 'default'),
(31, 'left-main', 'default'),
(31, 'main', 'mobile_default'),
(33, 'main', 'default'),
(33, 'main', 'mobile_default'),
(34, 'left-main', 'default'),
(34, 'main', 'mobile_default'),
(35, 'left-main', 'default'),
(35, 'main', 'mobile_default'),
(36, 'left-main', 'default'),
(36, 'main', 'mobile_default'),
(37, 'left-main', 'default'),
(37, 'main', 'mobile_default'),
(38, 'left-main', 'default'),
(38, 'main', 'mobile_default'),
(39, 'left-main', 'default'),
(39, 'main', 'mobile_default'),
(40, 'left-main', 'default'),
(40, 'main', 'mobile_default'),
(41, 'left-main', 'default'),
(41, 'main', 'mobile_default'),
(42, 'left-main', 'default'),
(42, 'main', 'mobile_default'),
(43, 'left-main', 'default'),
(43, 'main', 'mobile_default'),
(44, 'left-main-right', 'default'),
(44, 'main', 'mobile_default'),
(45, 'left-main-right', 'default'),
(45, 'main', 'mobile_default'),
(46, 'left-main-right', 'default'),
(46, 'main', 'mobile_default'),
(47, 'left-main-right', 'default'),
(47, 'main', 'mobile_default'),
(53, 'left-main-right', 'default'),
(53, 'main', 'mobile_default'),
(55, 'left-main-right', 'default'),
(55, 'main', 'mobile_default'),
(56, 'left-main', 'default'),
(56, 'main', 'mobile_default'),
(59, 'left-main-right', 'default'),
(59, 'main', 'mobile_default'),
(60, 'left-main-right', 'default'),
(60, 'main', 'mobile_default'),
(61, 'left-main-right', 'default'),
(61, 'main', 'mobile_default'),
(62, 'left-main-right', 'default'),
(62, 'main', 'mobile_default'),
(64, 'left-main-right', 'default'),
(64, 'main', 'mobile_default'),
(65, 'left-main-right', 'default'),
(65, 'main', 'mobile_default'),
(67, 'left-main-right', 'default'),
(67, 'main', 'mobile_default'),
(68, 'left-main-right', 'default'),
(68, 'main', 'mobile_default'),
(69, 'left-main-right', 'default'),
(69, 'main', 'mobile_default'),
(71, 'left-main-right', 'default'),
(71, 'main', 'mobile_default'),
(81, 'left-main-right', 'default'),
(81, 'main', 'mobile_default'),
(82, 'left-main-right', 'default'),
(83, 'left-main-right', 'default'),
(83, 'main', 'mobile_default');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_modules`
--

CREATE TABLE `nv5_en_modules` (
  `title` varchar(50) NOT NULL,
  `module_file` varchar(50) NOT NULL DEFAULT '',
  `module_data` varchar(50) NOT NULL DEFAULT '',
  `module_upload` varchar(50) NOT NULL DEFAULT '',
  `module_theme` varchar(50) NOT NULL DEFAULT '',
  `custom_title` varchar(255) NOT NULL,
  `site_title` varchar(255) NOT NULL DEFAULT '',
  `admin_title` varchar(255) NOT NULL DEFAULT '',
  `set_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `main_file` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `admin_file` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `theme` varchar(100) DEFAULT '',
  `mobile` varchar(100) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `keywords` text DEFAULT NULL,
  `icon` varchar(100) NOT NULL DEFAULT '' COMMENT 'Icon',
  `groups_view` varchar(255) NOT NULL,
  `weight` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `admins` varchar(4000) DEFAULT '',
  `rss` tinyint(4) NOT NULL DEFAULT 1,
  `sitemap` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Module ngoài site theo ngôn ngữ';

--
-- Dumping data for table `nv5_en_modules`
--

INSERT INTO `nv5_en_modules` (`title`, `module_file`, `module_data`, `module_upload`, `module_theme`, `custom_title`, `site_title`, `admin_title`, `set_time`, `main_file`, `admin_file`, `theme`, `mobile`, `description`, `keywords`, `icon`, `groups_view`, `weight`, `act`, `admins`, `rss`, `sitemap`) VALUES
('about', 'page', 'about', 'about', 'page', 'About', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-campground', '6', 1, 1, '', 1, 1),
('banners', 'banners', 'banners', 'banners', 'banners', 'Banners', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-rectangle-ad', '6', 10, 1, '', 0, 1),
('comment', 'comment', 'comment', 'comment', 'comment', 'Comment', '', '', 1759423352, 0, 1, '', '', '', '', 'fa-solid fa-comments', '6', 15, 1, '', 0, 1),
('contact', 'contact', 'contact', 'contact', 'contact', 'Contact', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-phone', '6', 7, 1, '', 0, 1),
('dictionary', 'dictionary', 'dictionary', 'dictionary', 'dictionary', 'Dictionary', '', '', 1761904434, 1, 1, '', '', '', '', '', '6', 20, 1, '', 0, 0),
('feeds', 'feeds', 'feeds', 'feeds', 'feeds', 'RSS-feeds', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-rss', '6', 13, 1, '', 0, 1),
('freecontent', 'freecontent', 'freecontent', 'freecontent', 'freecontent', 'Introduction', '', '', 1759423352, 0, 1, '', '', '', '', 'fa-solid fa-cube', '6', 17, 1, '', 0, 1),
('inform', 'inform', 'inform', 'inform', 'inform', 'Notification', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-bell', '4', 6, 1, '', 0, 0),
('menu', 'menu', 'menu', 'menu', 'menu', 'Navigation Bar', '', '', 1759423352, 0, 1, '', '', '', '', 'fa-solid fa-network-wired', '6', 12, 1, '', 0, 1),
('myapi', 'myapi', 'myapi', 'myapi', 'myapi', 'My APIs', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-brands fa-nfc-symbol', '6', 5, 1, '', 0, 0),
('news', 'news', 'news', 'news', 'news', 'News', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-newspaper', '6', 3, 1, '', 1, 1),
('page', 'page', 'page', 'page', 'page', 'Page', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-file-pen', '6', 14, 1, '', 1, 0),
('seek', 'seek', 'seek', 'seek', 'seek', 'Search', '', '', 1759423352, 1, 0, '', '', '', '', 'fa-solid fa-magnifying-glass', '6', 11, 1, '', 0, 1),
('siteterms', 'page', 'siteterms', 'siteterms', 'page', 'Terms & Conditions', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-gavel', '6', 16, 1, '', 1, 1),
('statistics', 'statistics', 'statistics', 'statistics', 'statistics', 'Statistics', '', '', 1759423352, 1, 1, '', '', '', 'online, statistics', 'fa-solid fa-chart-simple', '6', 8, 1, '', 0, 1),
('test', 'test', 'test', 'test', 'test', 'test', '', '', 1759475557, 1, 1, '', '', '', '', '', '6', 19, 1, '', 0, 0),
('two-step-verification', 'two-step-verification', 'two_step_verification', 'two_step_verification', 'two-step-verification', '2-Step Verification', '', '', 1759423352, 1, 0, '', '', '', '', 'fa-solid fa-shield-halved', '6', 18, 1, '', 0, 1),
('users', 'users', 'users', 'users', 'users', 'Users', '', 'Users', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-users', '6', 4, 1, '', 0, 1),
('voting', 'voting', 'voting', 'voting', 'voting', 'Voting', '', '', 1759423352, 1, 1, '', '', '', '', 'fa-solid fa-square-poll-vertical', '6', 9, 1, '', 1, 1),
('zalo', 'zalo', 'zalo', 'zalo', 'zalo', 'Zalo', '', 'Zalo', 1759423352, 0, 1, '', '', '', '', 'fa-solid fa-z', '3', 2, 1, '', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_1`
--

CREATE TABLE `nv5_en_news_1` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_1`
--

INSERT INTO `nv5_en_news_1` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(1, 1, '1,7,8', 0, 8, 'VINADES', 0, 1277689959, 1277690410, 1, 0, 1277689920, 0, 2, 'Invite to co-operate announcement', 'Invite-to-co-operate-announcement', 'VINADES.,JSC was founded in order to professionalize NukeViet opensource development and release. We also using NukeViet in our bussiness projects to make it continue developing. Include Advertisment, provide hosting services for NukeViet CMS development.', 'hoptac.jpg', '', 1, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_2`
--

CREATE TABLE `nv5_en_news_2` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_3`
--

CREATE TABLE `nv5_en_news_3` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_4`
--

CREATE TABLE `nv5_en_news_4` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_4`
--

INSERT INTO `nv5_en_news_4` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(4, 4, '4', 0, 1, 'VOVNews&#x002F;VNA', 0, 1292959020, 1292959513, 1, 0, 1292959020, 0, 2, 'First open-source company starts operation', 'First-open-source-company-starts-operation', 'The Vietnam Open Source Development Joint Stock Company (VINADES.,JSC), the first firm operating in the field of open source in the country, made its debut on February 25.', 'nangly.jpg', '', 1, 1, '6', 1, 0, 1, 0, 0, 0, 0, '', 0),
(5, 4, '4', 0, 1, '', 0, 1292959490, 1292959664, 1, 0, 1292959440, 0, 2, 'NukeViet 3.0 - New CMS for News site', 'NukeViet-30-New-CMS-for-News-site', 'NukeViet 3.0 is a professional system: VINADES.,JSC founded to maintain and improve NukeViet 3.0 features. VINADES.,JSC co-operated with many professional hosting providers to test compatibility issues.', 'nukeviet-cms.jpg', '', 1, 1, '6', 1, 0, 1, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_5`
--

CREATE TABLE `nv5_en_news_5` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_6`
--

CREATE TABLE `nv5_en_news_6` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_7`
--

CREATE TABLE `nv5_en_news_7` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_7`
--

INSERT INTO `nv5_en_news_7` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(1, 1, '1,7,8', 0, 8, 'VINADES', 0, 1277689959, 1277690410, 1, 0, 1277689920, 0, 2, 'Invite to co-operate announcement', 'Invite-to-co-operate-announcement', 'VINADES.,JSC was founded in order to professionalize NukeViet opensource development and release. We also using NukeViet in our bussiness projects to make it continue developing. Include Advertisment, provide hosting services for NukeViet CMS development.', 'hoptac.jpg', '', 1, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0),
(3, 12, '12,7', 0, 8, '', 2, 1277691851, 1287160943, 1, 0, 1277691840, 0, 2, 'HTML 5 review', 'HTML-5-review', 'I have to say that my money used to be on XHTML 2.0 eventually winning the battle for the next great web standard. Either that, or the two titans would continue to battle it out for the forseable future, leading to an increasingly fragmented web.', '', '', 0, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_8`
--

CREATE TABLE `nv5_en_news_8` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_8`
--

INSERT INTO `nv5_en_news_8` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(1, 1, '1,7,8', 0, 8, 'VINADES', 0, 1277689959, 1277690410, 1, 0, 1277689920, 0, 2, 'Invite to co-operate announcement', 'Invite-to-co-operate-announcement', 'VINADES.,JSC was founded in order to professionalize NukeViet opensource development and release. We also using NukeViet in our bussiness projects to make it continue developing. Include Advertisment, provide hosting services for NukeViet CMS development.', 'hoptac.jpg', '', 1, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0),
(2, 14, '14,8', 0, 8, '', 1, 1277691366, 1277691470, 1, 0, 1277691360, 0, 2, 'What does WWW mean?', 'What-does-WWW-mean', 'The World Wide Web, abbreviated as WWW and commonly known as the Web, is a system of interlinked hypertext&nbsp; documents accessed via the Internet.', '', '', 0, 1, '2', 1, 0, 0, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_9`
--

CREATE TABLE `nv5_en_news_9` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_10`
--

CREATE TABLE `nv5_en_news_10` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_11`
--

CREATE TABLE `nv5_en_news_11` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_12`
--

CREATE TABLE `nv5_en_news_12` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_12`
--

INSERT INTO `nv5_en_news_12` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(3, 12, '12,7', 0, 8, '', 2, 1277691851, 1287160943, 1, 0, 1277691840, 0, 2, 'HTML 5 review', 'HTML-5-review', 'I have to say that my money used to be on XHTML 2.0 eventually winning the battle for the next great web standard. Either that, or the two titans would continue to battle it out for the forseable future, leading to an increasingly fragmented web.', '', '', 0, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_13`
--

CREATE TABLE `nv5_en_news_13` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_14`
--

CREATE TABLE `nv5_en_news_14` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_14`
--

INSERT INTO `nv5_en_news_14` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(2, 14, '14,8', 0, 8, '', 1, 1277691366, 1277691470, 1, 0, 1277691360, 0, 2, 'What does WWW mean?', 'What-does-WWW-mean', 'The World Wide Web, abbreviated as WWW and commonly known as the Web, is a system of interlinked hypertext&nbsp; documents accessed via the Internet.', '', '', 0, 1, '2', 1, 0, 0, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_admins`
--

CREATE TABLE `nv5_en_news_admins` (
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `catid` smallint(5) NOT NULL DEFAULT 0,
  `admin` tinyint(4) NOT NULL DEFAULT 0,
  `add_content` tinyint(4) NOT NULL DEFAULT 0,
  `pub_content` tinyint(4) NOT NULL DEFAULT 0,
  `edit_content` tinyint(4) NOT NULL DEFAULT 0,
  `del_content` tinyint(4) NOT NULL DEFAULT 0,
  `app_content` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_author`
--

CREATE TABLE `nv5_en_news_author` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `uid` int(11) UNSIGNED NOT NULL,
  `alias` varchar(100) NOT NULL DEFAULT '',
  `pseudonym` varchar(100) NOT NULL DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `description` text DEFAULT NULL,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `numnews` mediumint(8) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_author`
--

INSERT INTO `nv5_en_news_author` (`id`, `uid`, `alias`, `pseudonym`, `image`, `description`, `add_time`, `edit_time`, `active`, `numnews`) VALUES
(1, 1, 'hazeruno', 'hazeruno', '', '', 1759989555, 0, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_authorlist`
--

CREATE TABLE `nv5_en_news_authorlist` (
  `id` int(11) NOT NULL,
  `aid` mediumint(8) NOT NULL,
  `alias` varchar(100) NOT NULL DEFAULT '',
  `pseudonym` varchar(100) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_block`
--

CREATE TABLE `nv5_en_news_block` (
  `bid` smallint(5) UNSIGNED NOT NULL,
  `id` int(11) UNSIGNED NOT NULL,
  `weight` int(11) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_block_cat`
--

CREATE TABLE `nv5_en_news_block_cat` (
  `bid` smallint(5) UNSIGNED NOT NULL,
  `adddefault` tinyint(4) NOT NULL DEFAULT 0,
  `numbers` smallint(5) NOT NULL DEFAULT 10,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `weight` smallint(5) NOT NULL DEFAULT 0,
  `keywords` text DEFAULT NULL,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_block_cat`
--

INSERT INTO `nv5_en_news_block_cat` (`bid`, `adddefault`, `numbers`, `title`, `alias`, `image`, `description`, `weight`, `keywords`, `add_time`, `edit_time`) VALUES
(1, 0, 4, 'Hot News', 'Hot-News', '', '', 1, '', 1279963759, 1279963759),
(2, 1, 4, 'Top News', 'Top-News', '', '', 2, '', 1279963766, 1279963766);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_cat`
--

CREATE TABLE `nv5_en_news_cat` (
  `catid` smallint(5) UNSIGNED NOT NULL,
  `parentid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL,
  `titlesite` varchar(250) DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `description` text DEFAULT NULL,
  `descriptionhtml` text DEFAULT NULL,
  `image` varchar(255) DEFAULT '',
  `viewdescription` tinyint(2) NOT NULL DEFAULT 0,
  `weight` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `sort` smallint(5) NOT NULL DEFAULT 0,
  `lev` smallint(5) NOT NULL DEFAULT 0,
  `viewcat` varchar(50) NOT NULL DEFAULT 'viewcat_page_new',
  `numsubcat` smallint(5) NOT NULL DEFAULT 0,
  `subcatid` varchar(255) DEFAULT '',
  `numlinks` tinyint(2) UNSIGNED NOT NULL DEFAULT 3,
  `newday` tinyint(2) UNSIGNED NOT NULL DEFAULT 2,
  `featured` int(11) NOT NULL DEFAULT 0,
  `ad_block_cat` varchar(255) NOT NULL DEFAULT '',
  `layout_func` varchar(100) NOT NULL DEFAULT '' COMMENT 'Layout khi xem chuyên mục',
  `keywords` text DEFAULT NULL,
  `admins` text DEFAULT NULL,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `groups_view` varchar(255) DEFAULT '',
  `status` smallint(4) NOT NULL DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_cat`
--

INSERT INTO `nv5_en_news_cat` (`catid`, `parentid`, `title`, `titlesite`, `alias`, `description`, `descriptionhtml`, `image`, `viewdescription`, `weight`, `sort`, `lev`, `viewcat`, `numsubcat`, `subcatid`, `numlinks`, `newday`, `featured`, `ad_block_cat`, `layout_func`, `keywords`, `admins`, `add_time`, `edit_time`, `groups_view`, `status`) VALUES
(1, 0, 'Co-operate', '', 'Co-operate', '', '', '', 0, 2, 5, 0, 'viewcat_page_new', 2, '2,3', 3, 2, 0, '', '', '', '', 1277689708, 1277689708, '6', 1),
(2, 1, 'Careers at NukeViet', '', 'Careers-at-NukeViet', '', '', '', 0, 1, 6, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690086, 1277690259, '6', 1),
(3, 1, 'Partners', '', 'Partners', '', '', '', 0, 2, 7, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690142, 1277690291, '6', 1),
(4, 0, 'NukeViet news', '', 'NukeViet-news', '', '', '', 0, 1, 1, 0, 'viewcat_page_new', 3, '5,6,7', 3, 2, 0, '', '', '', '', 1277690451, 1277690451, '6', 1),
(5, 4, 'Security issues', '', 'Security-issues', '', '', '', 0, 1, 2, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690497, 1277690564, '6', 1),
(6, 4, 'Release notes', '', 'Release-notes', '', '', '', 0, 2, 3, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690588, 1277690588, '6', 1),
(7, 4, 'Development team talk', '', 'Development-team-talk', '', '', '', 0, 3, 4, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690652, 1277690652, '6', 1),
(8, 0, 'NukeViet community', '', 'NukeViet-community', '', '', '', 0, 3, 8, 0, 'viewcat_page_new', 3, '9,10,11', 3, 2, 0, '', '', '', '', 1277690748, 1277690748, '6', 1),
(9, 8, 'Activities', '', 'Activities', '', '', '', 0, 1, 9, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690765, 1277690765, '6', 1),
(10, 8, 'Events', '', 'Events', '', '', '', 0, 2, 10, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690783, 1277690783, '6', 1),
(11, 8, 'Faces of week &#x3A;D', '', 'Faces-of-week-D', '', '', '', 0, 3, 11, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690821, 1277690821, '6', 1),
(12, 0, 'Lastest technologies', '', 'Lastest-technologies', '', '', '', 0, 4, 12, 0, 'viewcat_page_new', 2, '13,14', 3, 2, 0, '', '', '', '', 1277690888, 1277690888, '6', 1),
(13, 12, 'World wide web', '', 'World-wide-web', '', '', '', 0, 1, 13, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690934, 1277690934, '6', 1),
(14, 12, 'Around internet', '', 'Around-internet', '', '', '', 0, 2, 14, 1, 'viewcat_page_new', 0, '', 3, 2, 0, '', '', '', '', 1277690982, 1277690982, '6', 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_config_post`
--

CREATE TABLE `nv5_en_news_config_post` (
  `group_id` smallint(5) NOT NULL,
  `addcontent` tinyint(4) NOT NULL,
  `postcontent` tinyint(4) NOT NULL,
  `editcontent` tinyint(4) NOT NULL,
  `delcontent` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_config_post`
--

INSERT INTO `nv5_en_news_config_post` (`group_id`, `addcontent`, `postcontent`, `editcontent`, `delcontent`) VALUES
(4, 0, 0, 0, 0),
(7, 0, 0, 0, 0),
(5, 0, 0, 0, 0),
(10, 0, 0, 0, 0),
(11, 0, 0, 0, 0),
(12, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_detail`
--

CREATE TABLE `nv5_en_news_detail` (
  `id` int(11) UNSIGNED NOT NULL,
  `titlesite` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `bodyhtml` longtext NOT NULL,
  `voicedata` text DEFAULT NULL COMMENT 'Data giọng đọc json',
  `keywords` varchar(255) DEFAULT '',
  `sourcetext` varchar(255) DEFAULT '',
  `files` text DEFAULT NULL,
  `reject_reason` text DEFAULT NULL COMMENT 'Nguyên nhân từ chối',
  `imgposition` tinyint(1) NOT NULL DEFAULT 1,
  `layout_func` varchar(100) DEFAULT '',
  `copyright` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_send` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_print` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_save` tinyint(1) NOT NULL DEFAULT 0,
  `auto_nav` tinyint(1) NOT NULL DEFAULT 0,
  `group_view` varchar(255) DEFAULT '',
  `localization` text DEFAULT NULL COMMENT 'Json url ngôn ngữ khác của bài viết',
  `related_ids` varchar(255) NOT NULL DEFAULT '' COMMENT 'ID bài đăng liên quan',
  `related_pos` tinyint(1) NOT NULL DEFAULT 2 COMMENT 'Vị trí bài liên quan: 0 tắt, 1 dưới mô tả ngắn gọn, 2 dưới cùng bài đăng',
  `schema_type` varchar(20) NOT NULL DEFAULT 'newsarticle' COMMENT 'Loại dữ liệu có cấu trúc'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_detail`
--

INSERT INTO `nv5_en_news_detail` (`id`, `titlesite`, `description`, `bodyhtml`, `voicedata`, `keywords`, `sourcetext`, `files`, `reject_reason`, `imgposition`, `layout_func`, `copyright`, `allowed_send`, `allowed_print`, `allowed_save`, `auto_nav`, `group_view`, `localization`, `related_ids`, `related_pos`, `schema_type`) VALUES
(1, '', '', '<p> <span style=\"color: black;\"><span style=\"color: black;\"><font size=\"2\"><span style=\"font-family: verdana,sans-serif;\">VIETNAM OPEN SOURCE DEVELOPMENT COMPANY (VINADES.,JSC)<br /> Head office: 6th floor, Song Da building, No. 131 Tran Phu street, Van Quan ward, Ha Dong district, Hanoi city, Vietnam.<br /> Mobile: (+84) 24 8587 2007<br /> Fax: (+84) 24 3550 0914<br /> Website: <a f8f55ee40942436149=\"true\" href=\"http://www.vinades.vn/\" target=\"_blank\">www.vinades.vn</a> - <a f8f55ee40942436149=\"true\" href=\"http://www.nukeviet.vn/\" target=\"_blank\">www.nukeviet.vn</a></span></font></span></span></p><div h4f82558737983=\"nukeviet.vn\" style=\"display: inline; cursor: pointer; padding-right: 16px; width: 16px; height: 16px;\"> <span style=\"color: black;\"><span style=\"color: black;\"><font size=\"2\"><span style=\"font-family: verdana,sans-serif;\">&nbsp;</span></font></span></span></div><br /><p> <span style=\"color: black;\"><span style=\"color: black;\"><font size=\"2\"><span style=\"font-family: verdana,sans-serif;\">Email: <a href=\"mailto:contact@vinades.vn\" target=\"_blank\">contact@vinades.vn</a><br /> <br /> <br /> Dear valued customers and partners,<br /> <br /> VINADES.,JSC was founded in order to professionalize NukeViet opensource development and release. We also using NukeViet in our bussiness projects to make it continue developing.<br /> <br /> NukeViet is a Content Management System (CMS). 1st general purpose CMS developed by Vietnamese community. It have so many pros. Ex: Biggest community in VietNam, pure Vietnamese, easy to use, easy to develop...<br /> <br /> NukeViet 3 is lastest version of NukeViet and it still developing but almost complete with many advantage features.<br /> <br /> With respects to invite hosting - domain providers, and all company that pay attension to NukeViet in bussiness co-operate.<br /> <br /> Co-operate types:<br /> <br /> 1. Website advertisement, banners exchange, links:<br /> a. Description:<br /> Website advertising &amp; communication channels.<br /> On each release version of NukeViet.<br /> b. Benefits:<br /> Broadcast to all end users on both side.<br /> Reduce advertisement cost.<br /> c. Warranties:<br /> Place advertisement banner of partners on both side.<br /> Open sub-forum at NukeViet.VN to support end users who using hosting services providing by partners.<br /> <br /> 2. Provide host packet for NukeViet development testing purpose:<br /> <br /> a. Description:<br /> Sign the contract and agreements.<br /> Partners provide all types of hosting packet for VINADES.,JSC. Each type at least 1 re-sale packet.<br /> VINADES.,JSC provide an certificate verify host providing by partner compartable with NukeViet.<br /> b. Benefits:<br /> Expand market.<br /> Reduce cost, improve bussiness value.<br /> c. Warranties:<br /> Partner provide free hosting packet for VINADES.,JSC to test NukeViet compatibility.<br /> VINADES.JSC annoucement tested result to community.<br /> <br /> 3. Support end users:<br /> a. Description:<br /> Co-operate to solve problem of end user.<br /> Partners send end user requires about NukeViet CMS to VINADES.,JSC. VINADES also send user requires about hosting services to partners.<br /> b. Benefits:<br /> Reduce cost, human resources to support end users.<br /> Support end user more effective.<br /> c. Warranties:<br /> Solve end user requires as soon as possible.<br /> <br /> 4. Other types:<br /> Besides, as a publisher of NukeViet CMS, we also place advertisements on software user interface, sample articles in each release version. With thousands of downloaded hits each release version, we believe that it is the most effective advertisement type to webmasters.<br /> If partners have any ideas about new co-operate types. You are welcome and feel free to send specifics to us. Our slogan is &quot;Co-operate for development&quot;.<br /> <br /> We look forward to co-operating with you.<br /> <br /> Sincerely,<br /> <br /> VINADES.,JSC</span></font></span></span></p>', NULL, '', '', NULL, NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2, 'newsarticle'),
(2, '', '', '<p> With a web browser, one can view web pages&nbsp; that may contain text, images, videos, and other multimedia&nbsp; and navigate between them by using hyperlinks. Using concepts from earlier hypertext systems, British engineer and computer scientist Sir Tim Berners-Lee, now the Director of the World Wide Web Consortium, wrote a proposal in March 1989 for what would eventually become the World Wide Web. He was later joined by Belgian computer scientist Robert Cailliau while both were working at CERN in Geneva, Switzerland. In 1990, they proposed using &quot;HyperText to link and access information of various kinds as a web of nodes in which the user can browse at will&quot;, and released that web in December.<br /> <br /> &quot;The World-Wide Web (W3) was developed to be a pool of human knowledge, which would allow collaborators in remote sites to share their ideas and all aspects of a common project.&quot;. If two projects are independently crea-ted, rather than have a central figure make the changes, the two bodies of information could form into one cohesive piece of work.</p><p> For more detail. See <a href=\"http://en.wikipedia.org/wiki/World_Wide_Web\" target=\"_blank\">Wikipedia</a></p>', NULL, '', '', NULL, NULL, 1, '', 0, 1, 1, 1, 0, '', NULL, '', 2, 'newsarticle'),
(3, '', '', '<p> But now that the W3C has admitted defeat, and abandoned <span class=\"caps\">XHTML</span> 2.0, there’s now no getting away f-rom the fact that <span class=\"caps\">HTML</span> 5 is the future. As such, I’ve now spent some time taking a look at this emerging standard, and hope you’ll endulge my ego by taking a glance over my thoughts on the matter.</p><p> Before I get started though, I have to say that I’m very impressed by what I’ve seen. It’s a good set of standards that are being cre-ated, and I hope that they will gradually be adopted over the next few years.</p><h2> New markup</h2><p> <span class=\"caps\">HTML</span> 5 introduces some new markup elements to encourage better structure within documents. The most important of these is &lt;section&gt;, which is used to define a hierarchy within a document. Sections can be nested to define subsections, and each section can be broken up into &lt;header&gt; and &lt;footer&gt; areas.</p><p> The important thing about this addition is that it removes the previous dependancy on &lt;h1&gt;, &lt;h2&gt; and related tags to define structure. Within each &lt;section&gt;, the top level heading is always &lt;h1&gt;. You can use as many &lt;h1&gt; tags as you like within your content, so long as they are correctly nested within &lt;section&gt; tags.</p><p> There’s a plethora of other new tags, all of which seem pretty useful. The best thing about all of this, however, is that there’s no reason not to start using them right away. There’s a small piece of JavaScript that’s needed to make Internet Explorer behave, but aside f-rom that it’s all good. More details about this hack are available at <a href=\"http://www.diveintohtml5.org/\">http://www.diveintohtml5.org</a></p><h2> Easier media embedding</h2><p> <span class=\"caps\">HTML</span> 5 defines some new tags that will make it a lot easier to embed video and audio into pages. In the same way that images are embedded using &lt;img&gt; tags, so now can video and audio files be embedded using &lt;video&gt; and &lt;audio&gt;.</p><p> I don’t think than anyone is going to complain about these new features. They free us f-rom relying on third-party plugins, such as Adobe Flash, for such simple activities such as playing video.</p><p> Unfortunately, due to some annoying licensing conditions and a lack of support for the open-source Theora codec, actually using these tags at the moment requires that videos are encoded in two different formats. Even then, you’ll still need to still provide an Adobe Flash fallback for Internet Explorer.</p><p> You’ll need to be pretty devoted to <span class=\"caps\">HTML</span> 5 to use these tags yet…</p><h2> Relaxed markup rules</h2><p> This is one thorny subject. You know how we’ve all been so good recently with our well-formed <span class=\"caps\">XHTML</span>, quoting those attributes and closing those tags? Now there’s no need to, apparently…</p><p> On the surface, this seems like a big step backwards into the bad days of tag soup. However, if you dig deeper, the reasoning behind this decision goes something like this:</p><ol> <li> It’s unnacceptable to crash out an entire <span class=\"caps\">HTML</span> page just because of a simple <span class=\"caps\">XML</span> syntax error.</li> <li> This means that browsers cannot use an <span class=\"caps\">XML</span> parser, and must instead use a HTML-aware fault-tolerant parser.</li> <li> For consistency, all browsers should handle any such “syntax errors” (such as unquoted attributes and unclosed tags), in the same way.</li> <li> If all browsers are behaving in the same way, then unquoted attributes and unclosed tags are not really syntax errors any more. In fact, by leaving them out of our pages, we can save a few bytes!</li></ol><p> This isn’t to say that you have to throw away those <span class=\"caps\">XHTML</span> coding habits. It’s still all valid <span class=\"caps\">HTML</span> 5. In fact, if you really want to be strict, you can set a different content-type header to enforce well-formed <span class=\"caps\">XHTML</span>. But for most people, we’ll just carry on coding well-formed <span class=\"caps\">HTML</span> with the odd typo, but no longer have to worry about clients screaming at us when the perfectly-rendered page doesn’t validate.</p><h2> So what now?</h2><p> The <span class=\"caps\">HTML</span> 5 specification is getting pretty close to stable, so it’s now safe to use bits of this new standard in your code. How much you use is entirely a personal choice. However, we should all get used to the new markup over the next few years, because <span class=\"caps\">HTML</span> 5 is assuredly here to stay.</p><p> Myself, I’ll be switching to the new doctype and using the new markup for document sections in my code. This step involves very little effort and does a good job of showing support for the new specification.</p><p> The new media tags are another matter. Until all platforms support a single video format, it’s simply not sustainable to be transcoding all videos into two filetypes. When this is coupled with having to provide a Flash fallback, it all seems like a pretty poor return on investment.</p><p> These features will no doubt become more useable over the next few years, as newer browser take the place of old. One day, hopefully, we’ll be able write clean, semantic pages without having to worry about backwards-compatibility.</p><p> Part of this progress relies on web developers using these new standards in our pages. By adopting new technology, we show our support for the standards it represents and place pressure on browser vendors to adhere to those standards. It’s a bit of effort in the short term, but in the long term it will pay dividends.</p>\', \'http://www.etianen.com/blog/developers/2010/2/html-5-review/', NULL, '', '', NULL, NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2, 'newsarticle'),
(4, '', '', '<p> <span>The Hanoi-based company will further develop and popularise an open source content management system best known as NukeViet in the country. </span></p><p> <span>VINADES Chairman Nguyen Anh Tu said NukeViet is totally free and users can download the product at www.nukeviet.vn. </span></p><p> <span>NukeViet has been widely used across the country over the past five years. The system, built on PHP-Nuke and MySQL database, enables users to easily post and manage files on the Internet or Intranet.</span></p>', NULL, '', '', NULL, NULL, 0, '', 0, 1, 1, 1, 0, '', NULL, '', 2, 'newsarticle'),
(5, '', '', '<p> NukeViet also testing by many experienced webmasters to optimize system features. NukeViet&#039;s core team are programming enthusiasts. All of them want to make NukeViet become the best and most popular open source CMS.</p><p> <strong>NukeViet 3.0 is a powerful system:</strong><br /> Learn by experiences f-rom NukeViet 2.0, NukeViet 3.0 build ground up on latest web technologies, allow you easily cre-ate portal, online news express, social network, e commerce system.<br /> NukeViet 3.0 can process huge amount of data. It was used by many companies, corporation&#039;s website with millions of news entries with high traffic.<br /> <br /> <strong>NukeViet 3.0 is easy to use system:</strong><br /> NukeViet allow you easily to customize and instantly use without any line of code. As developers, NukeViet help you build your own modules rapidly.</p><h2> NukeViet 3.0 features:</h2><p> <strong>Technology bases:</strong><br /> NukeViet 3.0 using PHP 5 and MySQL 5 as main programming languages. XTemplate and jQuery for use Ajax f-rom system core.<br /> NukeViet 3.0 is fully validated with xHTML 1.0, CSS 2.1 and compatible with all major browsers.<br /> NukeViet 3.0 layout website using grid CSS framework like BluePrintCSS for design templates rapidly.<br /> <br /> NukeViet 3.0 has it own core libraries and it is platform independent. You can build your own modules with basic knowledge of PHP and MySQL.<br /> <br /> <strong>Module structure:</strong><br /> NukeViet 3.0 re-construct module structure. All module files packed into a particular folder. It&#039;s also define module block and module theme for layout modules in many ways.<br /> <br /> NukeViet 3.0 support modules can be multiply. We called it abstract modules. It help users automatic cre-ate many modules without any line of code f-rom any exists module which support cre-ate abstract modules.<br /> <br /> NukeViet 3.0 support automatic setup modules, blocks, themes f-rom Admin Control Panel. It&#039;s also allow you to share your modules by packed it into packets. NukeViet allow grant, deny access or even re-install, de-lete module.<br /> <br /> <strong>Multi language:</strong><br /> NukeViet 3 support multi languages in 2 types. Multi interface languages and multi database languages. It had features support administrators to build new languages. In NukeViet 3, admin language, user language, interface language, database language are separate for easily build multi languages systems.<br /> <br /> <strong>Right:</strong><br /> All manage features only access in admin area. NukeViet 3.0 allow grant access by module and language. It also allow cre-ate user groups and grant access modules by group.<br /> <br /> <strong>Themes:</strong><br /> NukeViet 3.0 support automatic install and uninstall themes. You can easily customize themes in module and module&#039;s functions. NukeViet store HTML, CSS code separately f-rom PHP code to help designers rapidly layout website.<br /> <br /> <strong>Customize website using blocks</strong><br /> A block can be a widget, advertisement pictures or any defined data. You can place block in many positions visually by drag and d-rop or argument it in Admin Control Panel.<br /> <br /> <strong>Securities:</strong><br /> NukeViet using security filters to filter data upload.<br /> Logging and control access f-rom many search engine as Google, Yahoo or any search engine.<br /> Anti spam using Captcha, anti flood data...<br /> NukeViet 3.0 has logging systems to log and track information about client to prevent attack.<br /> NukeViet 3.0 support automatic up-date to fix security issues or upgrade your website to latest version of NukeViet.<br /> <br /> <strong>Database:</strong><br /> You can backup database and download backup files to restore database to any point you restored your database.<br /> <br /> <strong>Control errors report</strong><br /> You can configure to display each type of error only one time. System then sent log files about this error to administrator via email.<br /> <br /> <strong>SEO:</strong><br /> Support SEO link<br /> Manage and customize website title<br /> Manage meta tag<br /> <br /> Support keywords for cre-ate statistic via search engine<br /> <br /> <strong>Prepared for integrate with third party application</strong><br /> NukeViet 3.0 has it own user database and many built-in methods to connect with many forum application. PHPBB or VBB can integrate and use with NukeViet 3.0 by single click.<br /> <br /> <strong>Distributed login</strong><br /> NukeViet support login by OpenID. Users can login to your website by accounts f-rom popular and well-known provider, such as Google, Yahoo or other OpenID providers. It help your website more accessible and reduce user&#039;s time to filling out registration forms.<br /> <br /> Download NukeViet 3.0: <a href=\"http://code.google.com/p/nuke-viet/downloads/list\">http://code.google.com/p/nuke-viet/downloads/list</a><br /> Website: <a href=\"https://nukeviet.vn/\">https://nukeviet.vn</a></p>', NULL, '', '', NULL, NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2, 'newsarticle');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_logs`
--

CREATE TABLE `nv5_en_news_logs` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `sid` mediumint(8) NOT NULL DEFAULT 0,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `log_key` varchar(60) NOT NULL DEFAULT '' COMMENT 'Khóa loại log, tùy vào lập trình',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `note` varchar(255) NOT NULL DEFAULT '',
  `set_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_report`
--

CREATE TABLE `nv5_en_news_report` (
  `id` int(11) UNSIGNED NOT NULL,
  `newsid` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `md5content` char(32) NOT NULL DEFAULT '',
  `post_ip` char(50) NOT NULL DEFAULT '',
  `post_email` varchar(100) NOT NULL DEFAULT '',
  `post_time` int(11) NOT NULL DEFAULT 0,
  `orig_content` varchar(255) NOT NULL DEFAULT '',
  `repl_content` varchar(255) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_rows`
--

CREATE TABLE `nv5_en_news_rows` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_rows`
--

INSERT INTO `nv5_en_news_rows` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(1, 1, '1,7,8', 0, 8, 'VINADES', 0, 1277689959, 1277690410, 1, 0, 1277689920, 0, 2, 'Invite to co-operate announcement', 'Invite-to-co-operate-announcement', 'VINADES.,JSC was founded in order to professionalize NukeViet opensource development and release. We also using NukeViet in our bussiness projects to make it continue developing. Include Advertisment, provide hosting services for NukeViet CMS development.', 'hoptac.jpg', '', 1, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0),
(2, 14, '14,8', 0, 8, '', 1, 1277691366, 1277691470, 1, 0, 1277691360, 0, 2, 'What does WWW mean?', 'What-does-WWW-mean', 'The World Wide Web, abbreviated as WWW and commonly known as the Web, is a system of interlinked hypertext&nbsp; documents accessed via the Internet.', '', '', 0, 1, '2', 1, 0, 0, 0, 0, 0, 0, '', 0),
(3, 12, '12,7', 0, 8, '', 2, 1277691851, 1287160943, 1, 0, 1277691840, 0, 2, 'HTML 5 review', 'HTML-5-review', 'I have to say that my money used to be on XHTML 2.0 eventually winning the battle for the next great web standard. Either that, or the two titans would continue to battle it out for the forseable future, leading to an increasingly fragmented web.', '', '', 0, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0),
(4, 4, '4', 0, 1, 'VOVNews&#x002F;VNA', 0, 1292959020, 1292959513, 1, 0, 1292959020, 0, 2, 'First open-source company starts operation', 'First-open-source-company-starts-operation', 'The Vietnam Open Source Development Joint Stock Company (VINADES.,JSC), the first firm operating in the field of open source in the country, made its debut on February 25.', 'nangly.jpg', '', 1, 1, '6', 1, 0, 1, 0, 0, 0, 0, '', 0),
(5, 4, '4', 0, 1, '', 0, 1292959490, 1292959664, 1, 0, 1292959440, 0, 2, 'NukeViet 3.0 - New CMS for News site', 'NukeViet-30-New-CMS-for-News-site', 'NukeViet 3.0 is a professional system: VINADES.,JSC founded to maintain and improve NukeViet 3.0 features. VINADES.,JSC co-operated with many professional hosting providers to test compatibility issues.', 'nukeviet-cms.jpg', '', 1, 1, '6', 1, 0, 1, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_row_histories`
--

CREATE TABLE `nv5_en_news_row_histories` (
  `id` int(11) UNSIGNED NOT NULL,
  `new_id` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `historytime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID người đăng',
  `author` varchar(250) NOT NULL DEFAULT '',
  `sourceid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0,
  `titlesite` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `bodyhtml` longtext NOT NULL,
  `voicedata` text DEFAULT NULL COMMENT 'Data giọng đọc json',
  `keywords` varchar(255) DEFAULT '',
  `sourcetext` varchar(255) DEFAULT '',
  `files` text DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `internal_authors` varchar(255) NOT NULL DEFAULT '',
  `imgposition` tinyint(1) NOT NULL DEFAULT 1,
  `layout_func` varchar(100) DEFAULT '',
  `copyright` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_send` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_print` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_save` tinyint(1) NOT NULL DEFAULT 0,
  `auto_nav` tinyint(1) NOT NULL DEFAULT 0,
  `group_view` varchar(255) DEFAULT '',
  `schema_type` varchar(20) NOT NULL DEFAULT 'newsarticle' COMMENT 'Loại dữ liệu có cấu trúc',
  `changed_fields` text NOT NULL COMMENT 'Các field thay đổi'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lịch sử bài viết';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_sources`
--

CREATE TABLE `nv5_en_news_sources` (
  `sourceid` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL DEFAULT '',
  `link` varchar(255) DEFAULT '',
  `logo` varchar(255) DEFAULT '',
  `weight` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) UNSIGNED NOT NULL,
  `edit_time` int(11) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_sources`
--

INSERT INTO `nv5_en_news_sources` (`sourceid`, `title`, `link`, `logo`, `weight`, `add_time`, `edit_time`) VALUES
(1, 'Wikipedia', 'http://www.wikipedia.org', '', 1, 1277691366, 1277691366),
(2, 'Enlightened Website Development', 'http://www.etianen.com', '', 2, 1277691851, 1277691851);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_tags`
--

CREATE TABLE `nv5_en_news_tags` (
  `tid` mediumint(8) UNSIGNED NOT NULL,
  `numnews` mediumint(8) NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `description` text DEFAULT NULL,
  `keywords` varchar(255) DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_tags`
--

INSERT INTO `nv5_en_news_tags` (`tid`, `numnews`, `title`, `alias`, `image`, `description`, `keywords`) VALUES
(1, 0, 'VINADES', 'vinades', '', '', 'vinades'),
(2, 0, 'Web', 'web', '', '', 'Web'),
(3, 0, 'HTML5', 'html5', '', '', 'html5'),
(4, 0, 'Nguyen Anh Tu', 'nguyen-anh-tu', '', '', 'nguyen anh tu'),
(5, 0, 'NukeViet', 'nukeviet', '', '', 'nukeviet');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_tags_id`
--

CREATE TABLE `nv5_en_news_tags_id` (
  `id` int(11) NOT NULL,
  `tid` mediumint(9) NOT NULL,
  `keyword` varchar(65) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_news_tags_id`
--

INSERT INTO `nv5_en_news_tags_id` (`id`, `tid`, `keyword`) VALUES
(1, 1, 'vinades'),
(2, 2, 'web'),
(3, 3, 'html5'),
(4, 1, 'vinades'),
(4, 4, 'nguyen anh tu'),
(5, 5, 'nukeviet'),
(5, 1, 'vinades');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_tmp`
--

CREATE TABLE `nv5_en_news_tmp` (
  `id` int(11) UNSIGNED NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0: thao tác sửa bài, 1: bản nháp',
  `new_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID bài viết',
  `admin_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID người thao tác',
  `time_edit` int(11) NOT NULL DEFAULT 0 COMMENT 'Thời gian thao tác',
  `time_late` int(11) NOT NULL DEFAULT 0 COMMENT 'Thời gian cuối cùng thao tác',
  `ip` varchar(40) NOT NULL DEFAULT '' COMMENT 'IP thao tác',
  `uuid` varchar(36) NOT NULL DEFAULT '' COMMENT 'ID bản nháp nếu soạn bài mới',
  `properties` mediumtext DEFAULT NULL COMMENT 'Json khác'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bản nháp và ghi nhận sửa bài';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_topics`
--

CREATE TABLE `nv5_en_news_topics` (
  `topicid` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `weight` smallint(5) NOT NULL DEFAULT 0,
  `keywords` text DEFAULT NULL,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_news_voices`
--

CREATE TABLE `nv5_en_news_voices` (
  `id` smallint(4) UNSIGNED NOT NULL,
  `voice_key` varchar(50) NOT NULL DEFAULT '' COMMENT 'Khóa dùng trong Api sau này',
  `title` varchar(250) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `weight` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0: Dừng, 1: Hoạt động'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_page`
--

CREATE TABLE `nv5_en_page` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `alias` varchar(250) NOT NULL,
  `image` varchar(255) DEFAULT '',
  `imagealt` varchar(255) DEFAULT '',
  `imageposition` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `bodytext` mediumtext NOT NULL,
  `keywords` text DEFAULT NULL,
  `socialbutton` tinyint(4) NOT NULL DEFAULT 0,
  `activecomm` varchar(255) DEFAULT '',
  `layout_func` varchar(100) DEFAULT '',
  `weight` smallint(4) NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hot_post` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `schema_type` varchar(20) NOT NULL DEFAULT 'article' COMMENT 'Dữ liệu có cấu trúc của bài viết',
  `schema_about` varchar(50) NOT NULL DEFAULT 'Organization' COMMENT 'Trang viết về gì nếu dữ liệu có cấu trúc là WebPage'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_page_config`
--

CREATE TABLE `nv5_en_page_config` (
  `config_name` varchar(30) NOT NULL,
  `config_value` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_page_config`
--

INSERT INTO `nv5_en_page_config` (`config_name`, `config_value`) VALUES
('schema_type', 'article'),
('schema_about', 'organization'),
('viewtype', '0'),
('facebookapi', ''),
('per_page', '20'),
('news_first', '0'),
('related_articles', '5'),
('copy_page', '0'),
('alias_lower', '1'),
('socialbutton', 'facebook,twitter');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_referer_stats`
--

CREATE TABLE `nv5_en_referer_stats` (
  `host` varchar(250) NOT NULL,
  `total` int(11) NOT NULL DEFAULT 0,
  `month01` int(11) NOT NULL DEFAULT 0,
  `month02` int(11) NOT NULL DEFAULT 0,
  `month03` int(11) NOT NULL DEFAULT 0,
  `month04` int(11) NOT NULL DEFAULT 0,
  `month05` int(11) NOT NULL DEFAULT 0,
  `month06` int(11) NOT NULL DEFAULT 0,
  `month07` int(11) NOT NULL DEFAULT 0,
  `month08` int(11) NOT NULL DEFAULT 0,
  `month09` int(11) NOT NULL DEFAULT 0,
  `month10` int(11) NOT NULL DEFAULT 0,
  `month11` int(11) NOT NULL DEFAULT 0,
  `month12` int(11) NOT NULL DEFAULT 0,
  `last_update` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thống kê đường dẫn đến site';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_searchkeys`
--

CREATE TABLE `nv5_en_searchkeys` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `skey` varchar(250) NOT NULL,
  `total` int(11) NOT NULL DEFAULT 0,
  `search_engine` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Từ khóa tìm kiếm';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_siteterms`
--

CREATE TABLE `nv5_en_siteterms` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `alias` varchar(250) NOT NULL,
  `image` varchar(255) DEFAULT '',
  `imagealt` varchar(255) DEFAULT '',
  `imageposition` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `bodytext` mediumtext NOT NULL,
  `keywords` text DEFAULT NULL,
  `socialbutton` tinyint(4) NOT NULL DEFAULT 0,
  `activecomm` varchar(255) DEFAULT '',
  `layout_func` varchar(100) DEFAULT '',
  `weight` smallint(4) NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hot_post` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `schema_type` varchar(20) NOT NULL DEFAULT 'article' COMMENT 'Dữ liệu có cấu trúc của bài viết',
  `schema_about` varchar(50) NOT NULL DEFAULT 'Organization' COMMENT 'Trang viết về gì nếu dữ liệu có cấu trúc là WebPage'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_siteterms`
--

INSERT INTO `nv5_en_siteterms` (`id`, `title`, `alias`, `image`, `imagealt`, `imageposition`, `description`, `bodytext`, `keywords`, `socialbutton`, `activecomm`, `layout_func`, `weight`, `admin_id`, `add_time`, `edit_time`, `status`, `hitstotal`, `hot_post`, `schema_type`, `schema_about`) VALUES
(1, 'Terms & Conditions', 'Terms-Conditions', '', '', 0, '', '<h2><strong>Term no</strong><strong> 1: Collect information</strong></h2><strong>1.1. Collecting information automatically.</strong><br />Like the other modern websites, Websites will collect IP address and some information of the standard website like: browser, pages that you access to websites for process using services by desktop, laptop, computer and network devices, etc. It aims to analyze information for privacy and keeping safe mode the system.<br /><strong>1.2. Collecting your information through an account.</strong><br />All information of your account (creating a new account, contacting to us, and so on) will be stored in profile for caring customer services later.<br /><strong>1.3. Collecting information through setting up cookies.</strong><br />Like the other modern websites, when you access to websites, we (or monitoring tools; or the statistics of website activities that provided by partners ) will create some profiles that named Cookies on hard-disk or memory of your computer. One of some Cookies may be exist with the long time to become convenient process using. For example, saving your email in login page to avoid login again, ect.<br /><strong>1.4. Collecting and storing information in the last.</strong><h3>You can change the private information any time, however, we will save in all information that changed to prevent the erase traces of illegal activities.</h3><h2><br /><strong>Term no</strong><strong> 2: Storing and protecting information.</strong></h2>Almost collected information will be stored in us database system.<br />We protect personal information by using some tools as password, firewall, encryption, and with some other tools that is license for accessing and suitable for data management process. For example, you and staffs must be responsibility for information processing through identifying steps in private information.<h2><br /><strong>Term no</strong><strong> 3: Using information</strong></h2>Collected information will be used to:<ul>	<li>Supplying support services &amp; customer care.</li>	<li>Transaction payment and Payment Notifications will send when a new payment is created</li>	<li>Handling complaints, charges &amp; Troubleshooting.</li>	<li>Stopping any forbidden or illegal act and must guarantee to follow the policies in &quot;User agreement”</li>	<li><a name=\"_GoBack\"></a> Measurement, upgrading &amp; improving services, content and form of the website.</li>	<li>Sending information to user about Marketing&#039;s Programs, announcements and promotional programs.</li>	<li>Comparison of the accuracy of your personal information in the process of checking with third parties.</li></ul><h2><br /><strong>Term no 4: Receiving information from partners</strong></h2>When using payment and transactions tools via the internet, we can receive more information about you such as your username address, email, bank account number ... We check that information with our user database to confirm whether you are the customer of us or not in order to enable the implementation of the service is convenient for you.<br />The received information will be secured as the information that we collected directly from you.<h2><br /><strong>Term no 5: Sharing information with the third party</strong></h2>We will not share your personal information, financial information... for the 3rd party, unless we have your consent or when we are forced to comply with the law or in case of having the requests from government agencies having jurisdiction.<h2><br /><strong>Term no 6: Changing the privacy policy</strong></h2>This Privacy Policy may change from time to time. We will not reduce your rights under this Privacy Policy without your explicit consent. We will post any changes to this Privacy Policy on this website and if the changes are significant, we will provide a more prominent notice (including information email message about the change of the Privacy Policy for certain services).<br /><br />&nbsp;<div style=\"text-align: right;\">Tham khảo từ website <a href=\"http://webnhanh.vn/vi/thiet-ke-web/detail/Chinh-sach-bao-mat-Quyen-rieng-tu-Privacy-Policy-2147/\">webnhanh.vn</a><br />&nbsp;</div>', '', 0, '4', '', 1, 1, 1759423352, 1759423352, 1, 0, 0, 'article', 'Organization');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_siteterms_config`
--

CREATE TABLE `nv5_en_siteterms_config` (
  `config_name` varchar(30) NOT NULL,
  `config_value` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_siteterms_config`
--

INSERT INTO `nv5_en_siteterms_config` (`config_name`, `config_value`) VALUES
('schema_type', 'article'),
('schema_about', 'organization'),
('viewtype', '0'),
('facebookapi', ''),
('per_page', '20'),
('news_first', '0'),
('related_articles', '5'),
('copy_page', '0'),
('alias_lower', '1'),
('socialbutton', 'facebook,twitter');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_voting`
--

CREATE TABLE `nv5_en_voting` (
  `vid` smallint(5) UNSIGNED NOT NULL,
  `question` varchar(250) NOT NULL,
  `link` varchar(255) DEFAULT '',
  `acceptcm` int(2) NOT NULL DEFAULT 1,
  `active_captcha` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `groups_view` varchar(255) DEFAULT '',
  `publ_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exp_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `vote_one` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 cho phép vote nhiều lần 1 cho phép vote 1 lần'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_voting`
--

INSERT INTO `nv5_en_voting` (`vid`, `question`, `link`, `acceptcm`, `active_captcha`, `admin_id`, `groups_view`, `publ_time`, `exp_time`, `act`, `vote_one`) VALUES
(1, 'What do you know about Nukeviet 4?', '', 1, 0, 1, '6', 1759423352, 0, 1, 0),
(2, 'What interests you about open source?', '', 1, 0, 1, '6', 1759423352, 0, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_voting_rows`
--

CREATE TABLE `nv5_en_voting_rows` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `vid` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(245) NOT NULL DEFAULT '',
  `url` varchar(255) DEFAULT '',
  `hitstotal` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_en_voting_rows`
--

INSERT INTO `nv5_en_voting_rows` (`id`, `vid`, `title`, `url`, `hitstotal`) VALUES
(1, 1, 'Brand new source code for the site', '', 1),
(2, 1, 'Open source, free to use', '', 0),
(3, 1, 'XHTML, CSS and Ajax support', '', 0),
(4, 1, 'All of the above', '', 0),
(5, 2, 'Constantly improving, modified by the whole world', '', 0),
(6, 2, 'Free to use', '', 0),
(7, 2, 'Free to explore, change at will', '', 0),
(8, 2, 'Suitable for study, research', '', 0),
(9, 2, 'All of the above', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_en_voting_voted`
--

CREATE TABLE `nv5_en_voting_voted` (
  `vid` smallint(5) UNSIGNED NOT NULL,
  `voted` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_extension_files`
--

CREATE TABLE `nv5_extension_files` (
  `idfile` mediumint(8) UNSIGNED NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT 'other',
  `title` varchar(55) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `lastmodified` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `duplicate` smallint(4) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='File của các ứng dụng';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_inform`
--

CREATE TABLE `nv5_inform` (
  `id` int(11) UNSIGNED NOT NULL,
  `receiver_grs` varchar(1000) NOT NULL DEFAULT '',
  `receiver_ids` varchar(1000) NOT NULL DEFAULT '',
  `sender_role` enum('system','group','admin') NOT NULL DEFAULT 'system',
  `sender_group` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `sender_admin` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `message` text DEFAULT NULL,
  `link` varchar(500) NOT NULL DEFAULT '',
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exp_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thông báo khu vực người dùng';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_inform_status`
--

CREATE TABLE `nv5_inform_status` (
  `pid` int(11) UNSIGNED NOT NULL,
  `userid` int(11) UNSIGNED NOT NULL,
  `shown_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `viewed_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `favorite_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `hidden_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Trạng thái đọc thông báo của người dùng';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_ips`
--

CREATE TABLE `nv5_ips` (
  `id` mediumint(8) NOT NULL,
  `type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0,
  `ip` varchar(32) DEFAULT NULL,
  `mask` tinyint(4) UNSIGNED NOT NULL DEFAULT 0,
  `area` tinyint(3) NOT NULL,
  `begintime` int(11) DEFAULT NULL,
  `endtime` int(11) DEFAULT NULL,
  `notice` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thiết lập tường lửa IP truy cập site';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_language`
--

CREATE TABLE `nv5_language` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `idfile` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `langtype` varchar(50) NOT NULL DEFAULT 'lang_module',
  `lang_key` varchar(50) NOT NULL,
  `weight` smallint(4) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Key lang ngôn ngữ giao diện';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_language_file`
--

CREATE TABLE `nv5_language_file` (
  `idfile` mediumint(8) UNSIGNED NOT NULL,
  `module` varchar(50) NOT NULL,
  `admin_file` varchar(200) NOT NULL DEFAULT '0',
  `langtype` varchar(50) NOT NULL DEFAULT 'lang_module'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các file ngôn ngữ giao diện';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_logs`
--

CREATE TABLE `nv5_logs` (
  `id` int(11) NOT NULL,
  `lang` varchar(10) NOT NULL,
  `module_name` varchar(50) NOT NULL,
  `name_key` varchar(255) NOT NULL,
  `note_action` text NOT NULL,
  `link_acess` varchar(255) DEFAULT '',
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `log_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Nhật kí hệ thống';

--
-- Dumping data for table `nv5_logs`
--

INSERT INTO `nv5_logs` (`id`, `lang`, `module_name`, `name_key`, `note_action`, `link_acess`, `userid`, `log_time`) VALUES
(1, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1759474828),
(2, 'en', 'settings', 'Change System setting', '', '', 1, 1759474960),
(3, 'en', 'modules', 'Setup new module test', '', '', 1, 1759475557),
(4, 'en', 'modules', 'Edit modules &ldquo;test&rdquo;', '', '', 1, 1759475570),
(5, 'en', 'users', '[hazeruno] Regular login', ' Client IP:::1', '', 0, 1759559867),
(6, 'en', 'login', '[hazeruno023156] Login Fail', ' Client IP:::1', '', 0, 1759559906),
(7, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1759559910),
(8, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1759738996),
(9, 'en', 'users', 'Change password', '::1 | 1', '', 1, 1759918699),
(10, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1759918720),
(11, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1759943310),
(12, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1759943334),
(13, 'en', 'modules', 'Edit modules &ldquo;dictionary&rdquo;', '', '', 1, 1759943350),
(14, 'en', 'modules', 'Delete module \"dictionary\"', '', '', 1, 1759943515),
(15, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1759972883),
(16, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1759972913),
(17, 'en', 'modules', 'Edit modules &ldquo;dictionary&rdquo;', '', '', 1, 1759972928),
(18, 'en', 'modules', 'Reinstall module \"dictionary\"', '', '', 1, 1759974601),
(19, 'en', 'modules', 'Delete module \"dictionary\"', '', '', 1, 1759974652),
(20, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1759974662),
(21, 'en', 'modules', 'Edit modules &ldquo;dictionary&rdquo;', '', '', 1, 1759974664),
(22, 'en', 'modules', 'Delete module \"dictionary\"', '', '', 1, 1759975388),
(23, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1759975397),
(24, 'en', 'modules', 'Edit modules &ldquo;dictionary&rdquo;', '', '', 1, 1759975402),
(25, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1759989521),
(26, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760008986),
(27, 'en', 'modules', 'Reinstall module \"dictionary\"', '', '', 1, 1760009011),
(28, 'en', 'login', '[hazeruno] Login Fail', ' Client IP:::1', '', 0, 1760027906),
(29, 'en', 'login', '[hazeruno] Login Fail', ' Client IP:::1', '', 0, 1760027912),
(30, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760027919),
(31, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760168235),
(32, 'en', 'siteinfo', 'DELETE_NOTIFICATION', '[2]', '', 1, 1760169170),
(33, 'en', 'siteinfo', 'DELETE_NOTIFICATION', '[1]', '', 1, 1760169170),
(34, 'en', 'login', '[hazeruno] Leave Administration', ' Client IP:::1', '', 0, 1760173110),
(35, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760173270),
(36, 'en', 'login', '[hazeruno] Leave Administration', ' Client IP:::1', '', 0, 1760175648),
(37, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760175664),
(38, 'en', 'login', '[hazeruno] Leave Administration', ' Client IP:::1', '', 0, 1760177970),
(39, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760178869),
(40, 'en', 'login', '[hazeruno] Leave Administration', ' Client IP:::1', '', 0, 1760182909),
(41, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760345329),
(42, 'en', 'siteinfo', 'READ_ALL_NOTIFICATION', '', '', 1, 1760345394),
(43, 'en', 'siteinfo', 'DELETE_NOTIFICATION', '[4]', '', 1, 1760345675),
(44, 'en', 'siteinfo', 'DELETE_NOTIFICATION', '[3]', '', 1, 1760345676),
(45, 'en', 'siteinfo', 'READ_ALL_NOTIFICATION', '', '', 1, 1760345737),
(46, 'en', 'siteinfo', 'DELETE_NOTIFICATION', '[7]', '', 1, 1760346533),
(47, 'en', 'siteinfo', 'DELETE_NOTIFICATION', '[6]', '', 1, 1760346533),
(48, 'en', 'siteinfo', 'DELETE_NOTIFICATION', '[5]', '', 1, 1760346533),
(49, 'en', 'login', '[hazeruno] Leave Administration', ' Client IP:::1', '', 0, 1760348205),
(50, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760348236),
(51, 'en', 'modules', 'Delete module \"dictionary\"', '', '', 1, 1760349380),
(52, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1760349388),
(53, 'en', 'modules', 'Edit modules &ldquo;dictionary&rdquo;', '', '', 1, 1760349390),
(54, 'en', 'modules', 'Delete module \"dictionary\"', '', '', 1, 1760349892),
(55, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1760349903),
(56, 'en', 'modules', 'Delete module \"dictionary\"', '', '', 1, 1760349914),
(57, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1760349921),
(58, 'en', 'modules', 'Edit modules &ldquo;dictionary&rdquo;', '', '', 1, 1760349923),
(59, 'en', 'modules', 'Delete module \"dictionary\"', '', '', 1, 1760350018),
(60, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1760350045),
(61, 'en', 'modules', 'Edit modules &ldquo;dictionary&rdquo;', '', '', 1, 1760350047),
(62, 'en', 'login', '[hazeruno] Leave Administration', ' Client IP:::1', '', 0, 1760351865),
(63, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760351995),
(64, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760371964),
(65, 'en', 'login', '[hazeruno] Leave Administration', ' Client IP:::1', '', 0, 1760373826),
(66, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760514341),
(67, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760539091),
(68, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760594964),
(69, 'en', 'siteinfo', 'READ_ALL_NOTIFICATION', '', '', 1, 1760598319),
(70, 'en', 'login', '[hazeruno] Leave Administration', ' Client IP:::1', '', 0, 1760600094),
(71, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760675876),
(72, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760688062),
(73, 'en', 'users', '[hazeruno] Log out of a user\'s account', ' Client IP:::1', '', 0, 1760715648),
(74, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760814539),
(75, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760948019),
(76, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760970219),
(77, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760970349),
(78, 'en', 'modules', 'Delete module \"dictionary\"', '', '', 1, 1760970479),
(79, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1760970485),
(80, 'en', 'modules', 'Edit modules &ldquo;dictionary&rdquo;', '', '', 1, 1760970488),
(81, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760973790),
(82, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1760983245),
(83, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761216575),
(84, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761360278),
(85, 'en', 'login', '[admin] Login Fail', ' Client IP:::1', '', 0, 1761363324),
(86, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761376517),
(87, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761552827),
(88, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761793554),
(89, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761794044),
(90, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761794115),
(91, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761794133),
(92, 'en', 'login', '[hazeruno] Leave Administration', ' Client IP:::1', '', 0, 1761796088),
(93, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761840762),
(94, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761843381),
(95, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761884615),
(96, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761904416),
(97, 'en', 'modules', 'Delete module \"dictionary\"', '', '', 1, 1761904426),
(98, 'en', 'modules', 'Setup new module dictionary', '', '', 1, 1761904434),
(99, 'en', 'modules', 'Edit modules &ldquo;dictionary&rdquo;', '', '', 1, 1761904436),
(100, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761919709),
(101, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761930437),
(102, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761962067),
(103, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1761992881),
(104, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1762158080),
(105, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1762250164),
(106, 'en', 'login', '[hazeruno] Login', ' Client IP:::1', '', 0, 1762349025);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_notification`
--

CREATE TABLE `nv5_notification` (
  `id` int(11) UNSIGNED NOT NULL,
  `admin_view_allowed` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cấp quản trị được xem: 0,1,2',
  `logic_mode` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Cấp trên xem được cấp dưới, 1: chỉ cấp hoặc người được chỉ định',
  `send_to` varchar(250) NOT NULL DEFAULT '' COMMENT 'Danh sách id người nhận, phân cách bởi dấu phảy',
  `send_from` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `area` tinyint(1) UNSIGNED NOT NULL,
  `language` char(3) NOT NULL,
  `module` varchar(50) NOT NULL,
  `obid` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `type` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `add_time` int(11) UNSIGNED NOT NULL,
  `view` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thông báo trong quản trị';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_plugins`
--

CREATE TABLE `nv5_plugins` (
  `pid` mediumint(8) UNSIGNED NOT NULL,
  `plugin_lang` varchar(3) NOT NULL DEFAULT 'all' COMMENT 'Ngôn ngữ sử dụng, all là tất cả ngôn ngữ',
  `plugin_file` varchar(50) NOT NULL COMMENT 'File PHP của plugin',
  `plugin_area` varchar(50) NOT NULL DEFAULT '' COMMENT 'Tên hook, tự đặt, không nên có tên nào trùng nhau',
  `plugin_module_name` varchar(50) NOT NULL DEFAULT '' COMMENT 'Tên module nhận và xử lý data',
  `plugin_module_file` varchar(50) NOT NULL DEFAULT '' COMMENT 'Tên module chứa file plugin, rỗng thì nằm ở includes/plugin',
  `hook_module` varchar(50) NOT NULL DEFAULT '' COMMENT 'Module xảy ra event, rỗng thì là của hệ thống',
  `weight` tinyint(4) NOT NULL COMMENT 'Thứ tự trong cùng một hook, càng to càng ưu tiên'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các hooks';

--
-- Dumping data for table `nv5_plugins`
--

INSERT INTO `nv5_plugins` (`pid`, `plugin_lang`, `plugin_file`, `plugin_area`, `plugin_module_name`, `plugin_module_file`, `hook_module`, `weight`) VALUES
(1, 'all', 'qrcode.php', 'get_qr_code', '', '', '', 1),
(2, 'all', 'cdn_js_css_image.php', 'change_site_buffer', '', '', '', 1),
(3, 'all', 'emf_code_user.php', 'get_email_merge_fields', 'users', 'users', '', 1),
(4, 'all', 'emf_core_author.php', 'get_email_merge_fields', '', '', '', 2),
(5, 'all', 'emf_all.php', 'get_email_merge_fields', '', '', '', 3),
(998, 'all', 'get_module_admin_theme.php', 'get_module_admin_theme', '', '', '', 1),
(999, 'all', 'get_global_admin_theme.php', 'get_global_admin_theme', '', '', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_sessions`
--

CREATE TABLE `nv5_sessions` (
  `session_id` varchar(50) DEFAULT NULL,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `username` varchar(100) NOT NULL,
  `onl_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_setup_extensions`
--

CREATE TABLE `nv5_setup_extensions` (
  `id` int(11) NOT NULL DEFAULT 0,
  `type` varchar(10) NOT NULL DEFAULT 'other',
  `title` varchar(55) NOT NULL,
  `is_sys` tinyint(1) NOT NULL DEFAULT 0,
  `is_virtual` tinyint(1) NOT NULL DEFAULT 0,
  `basename` varchar(50) NOT NULL DEFAULT '',
  `table_prefix` varchar(55) NOT NULL DEFAULT '',
  `version` varchar(50) NOT NULL,
  `addtime` int(11) NOT NULL DEFAULT 0,
  `author` text NOT NULL,
  `note` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các ứng dụng cài vào';

--
-- Dumping data for table `nv5_setup_extensions`
--

INSERT INTO `nv5_setup_extensions` (`id`, `type`, `title`, `is_sys`, `is_virtual`, `basename`, `table_prefix`, `version`, `addtime`, `author`, `note`) VALUES
(0, 'module', 'about', 0, 0, 'page', 'about', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(19, 'module', 'banners', 1, 0, 'banners', 'banners', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(281, 'module', 'comment', 1, 0, 'comment', 'comment', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(20, 'module', 'contact', 0, 1, 'contact', 'contact', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(0, 'module', 'dictionary', 0, 1, 'dictionary', 'dictionary', '5.0.00 1759928400', 1759943331, 'huynguyen03dev', ''),
(283, 'module', 'feeds', 1, 0, 'feeds', 'feeds', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(312, 'module', 'freecontent', 0, 1, 'freecontent', 'freecontent', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(22, 'module', 'inform', 1, 0, 'inform', 'inform', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(29, 'module', 'menu', 0, 0, 'menu', 'menu', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(22, 'module', 'myapi', 1, 0, 'myapi', 'myapi', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(1, 'module', 'news', 0, 1, 'news', 'news', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(282, 'module', 'page', 1, 1, 'page', 'page', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(284, 'module', 'seek', 1, 0, 'seek', 'seek', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(0, 'module', 'siteterms', 0, 0, 'page', 'siteterms', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(27, 'module', 'statistics', 0, 0, 'statistics', 'statistics', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(0, 'module', 'test', 0, 1, 'test', 'test', '4.0.00 1412726400', 1759475105, 'huynguyen', ''),
(327, 'module', 'two-step-verification', 1, 0, 'two-step-verification', 'two_step_verification', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(24, 'module', 'users', 1, 1, 'users', 'users', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(21, 'module', 'voting', 0, 0, 'voting', 'voting', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(517, 'module', 'zalo', 1, 0, 'zalo', 'zalo', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(307, 'theme', 'default', 0, 0, 'default', 'default', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', ''),
(311, 'theme', 'mobile_default', 0, 0, 'mobile_default', 'mobile_default', '5.0.00 1736144674', 1759423352, 'VINADES.,JSC <contact@vinades.vn>', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_setup_language`
--

CREATE TABLE `nv5_setup_language` (
  `lang` char(2) NOT NULL,
  `setup` tinyint(1) NOT NULL DEFAULT 0,
  `weight` smallint(4) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ngôn ngữ data';

--
-- Dumping data for table `nv5_setup_language`
--

INSERT INTO `nv5_setup_language` (`lang`, `setup`, `weight`) VALUES
('en', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_upload_dir`
--

CREATE TABLE `nv5_upload_dir` (
  `did` mediumint(8) NOT NULL,
  `dirname` varchar(250) DEFAULT NULL,
  `time` int(11) NOT NULL DEFAULT 0,
  `total_size` double UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Dung lượng thư mục',
  `thumb_type` tinyint(4) NOT NULL DEFAULT 0,
  `thumb_width` smallint(6) NOT NULL DEFAULT 0,
  `thumb_height` smallint(6) NOT NULL DEFAULT 0,
  `thumb_quality` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thư mục upload';

--
-- Dumping data for table `nv5_upload_dir`
--

INSERT INTO `nv5_upload_dir` (`did`, `dirname`, `time`, `total_size`, `thumb_type`, `thumb_width`, `thumb_height`, `thumb_quality`) VALUES
(0, '', 0, 0, 3, 300, 300, 90),
(1, 'uploads', 1759423399, 1413366, 0, 0, 0, 0),
(2, 'uploads/about', 1759423399, 242102, 0, 0, 0, 0),
(3, 'uploads/banners', 1759423399, 179287, 0, 0, 0, 0),
(4, 'uploads/banners/files', 1759423399, 0, 0, 0, 0, 0),
(5, 'uploads/comment', 1759423399, 0, 0, 0, 0, 0),
(6, 'uploads/contact', 1759423399, 0, 0, 0, 0, 0),
(7, 'uploads/emailtemplates', 1759423399, 0, 0, 0, 0, 0),
(8, 'uploads/feeds', 1759423399, 0, 0, 0, 0, 0),
(9, 'uploads/freecontent', 1759423399, 138096, 0, 0, 0, 0),
(10, 'uploads/inform', 1759423399, 0, 0, 0, 0, 0),
(11, 'uploads/menu', 1759423399, 0, 0, 0, 0, 0),
(12, 'uploads/news', 1759423399, 853881, 0, 0, 0, 0),
(13, 'uploads/news/authors', 1759423399, 0, 0, 0, 0, 0),
(14, 'uploads/news/source', 1759423399, 0, 0, 0, 0, 0),
(15, 'uploads/news/temp_pic', 1759423399, 0, 0, 0, 0, 0),
(16, 'uploads/news/topics', 1759423399, 0, 0, 0, 0, 0),
(17, 'uploads/page', 1759423399, 0, 0, 0, 0, 0),
(18, 'uploads/siteterms', 1759423399, 0, 0, 0, 0, 0),
(19, 'uploads/users', 1759423399, 0, 0, 0, 0, 0),
(20, 'uploads/users/groups', 1759423399, 0, 0, 0, 0, 0),
(21, 'uploads/users/userfiles', 1759423399, 0, 0, 0, 0, 0),
(22, 'uploads/zalo', 1759423399, 0, 0, 0, 0, 0),
(27, 'uploads/news/2025_10', 0, 0, 0, 0, 0, 0),
(32, 'uploads/dictionary', 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_upload_file`
--

CREATE TABLE `nv5_upload_file` (
  `name` varchar(245) NOT NULL,
  `ext` varchar(10) NOT NULL DEFAULT '',
  `type` varchar(5) NOT NULL DEFAULT '',
  `filesize` double NOT NULL DEFAULT 0,
  `src` varchar(255) NOT NULL DEFAULT '',
  `srcwidth` int(11) NOT NULL DEFAULT 0,
  `srcheight` int(11) NOT NULL DEFAULT 0,
  `sizes` varchar(50) NOT NULL DEFAULT '',
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `mtime` int(11) NOT NULL DEFAULT 0,
  `did` int(11) NOT NULL DEFAULT 0,
  `title` varchar(245) NOT NULL DEFAULT '',
  `alt` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='File upload';

--
-- Dumping data for table `nv5_upload_file`
--

INSERT INTO `nv5_upload_file` (`name`, `ext`, `type`, `filesize`, `src`, `srcwidth`, `srcheight`, `sizes`, `userid`, `mtime`, `did`, `title`, `alt`) VALUES
('logo-nukev...png', 'png', 'image', 13223, 'assets/about/logo-nukeviet3-flag-180x75.png', 80, 33, '180|75', 1, 1759410696, 2, 'logo-nukeviet3-flag-180x75.png', 'logo nukeviet3 flag 180x75'),
('nukevietcm...png', 'png', 'image', 13125, 'assets/about/nukevietcms_laco_180x57.png', 80, 25, '180|57', 1, 1759410696, 2, 'nukevietcms_laco_180x57.png', 'nukevietcms laco 180x57'),
('nukevietcm...png', 'png', 'image', 13319, 'assets/about/nukevietcms_mu_noel_180x84.png', 80, 37, '180|84', 1, 1759410696, 2, 'nukevietcms_mu_noel_180x84.png', 'nukevietcms mu noel 180x84'),
('nukevietcm...png', 'png', 'image', 11974, 'assets/about/nukevietcms-180x84.png', 80, 37, '180|84', 1, 1759410696, 2, 'nukevietcms-180x84.png', 'nukevietcms 180x84'),
('nukevietcms.png', 'png', 'image', 85684, 'assets/about/nukevietcms.png', 80, 37, '1500|700', 1, 1759410696, 2, 'nukevietcms.png', 'nukevietcms'),
('nukevietvn...png', 'png', 'image', 11586, 'assets/about/nukevietvn_180x84.png', 80, 37, '180|84', 1, 1759410696, 2, 'nukevietvn_180x84.png', 'nukevietvn 180x84'),
('nukevietvn.png', 'png', 'image', 81035, 'assets/about/nukevietvn.png', 80, 37, '1500|700', 1, 1759410696, 2, 'nukevietvn.png', 'nukevietvn'),
('w.png', 'png', 'image', 12156, 'assets/about/w.png', 80, 40, '288|143', 1, 1759410696, 2, 'w.png', 'w'),
('vinades.jpg', 'jpg', 'image', 104940, 'assets/banners/vinades.jpg', 42, 80, '212|400', 1, 1759410696, 3, 'vinades.jpg', 'vinades'),
('webnhanh.jpg', 'jpg', 'image', 74347, 'assets/banners/webnhanh.jpg', 80, 10, '572|72', 1, 1759410696, 3, 'webnhanh.jpg', 'webnhanh'),
('cms.jpg', 'jpg', 'image', 29026, 'assets/freecontent/cms.jpg', 80, 44, '130|71', 1, 1759410696, 9, 'cms.jpg', 'cms'),
('edugate.jpg', 'jpg', 'image', 28008, 'assets/freecontent/edugate.jpg', 80, 44, '130|71', 1, 1759410696, 9, 'edugate.jpg', 'edugate'),
('portal.jpg', 'jpg', 'image', 25973, 'assets/freecontent/portal.jpg', 80, 44, '130|71', 1, 1759410696, 9, 'portal.jpg', 'portal'),
('shop.jpg', 'jpg', 'image', 26352, 'assets/freecontent/shop.jpg', 80, 44, '130|71', 1, 1759410696, 9, 'shop.jpg', 'shop'),
('toa-soan-d...jpg', 'jpg', 'image', 28737, 'assets/freecontent/toa-soan-dien-tu.jpg', 80, 44, '130|71', 1, 1759410696, 9, 'toa-soan-dien-tu.jpg', 'toa soan dien tu'),
('chuc-mung-...jpg', 'jpg', 'image', 130708, 'assets/news/chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', 80, 63, '461|360', 1, 1759410696, 12, 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', 'chuc mung nukeviet thong tu 20 bo tttt'),
('hoc-viec-t...jpg', 'jpg', 'image', 167193, 'assets/news/hoc-viec-tai-cong-ty-vinades.jpg', 80, 63, '460|360', 1, 1759410696, 12, 'hoc-viec-tai-cong-ty-vinades.jpg', 'hoc viec tai cong ty vinades'),
('hoptac.jpg', 'jpg', 'image', 12871, 'assets/news/hoptac.jpg', 80, 66, '382|314', 1, 1759410696, 12, 'hoptac.jpg', 'hoptac'),
('nangly.jpg', 'jpg', 'image', 34802, 'assets/news/nangly.jpg', 80, 53, '500|332', 1, 1759410696, 12, 'nangly.jpg', 'nangly'),
('nukeviet-cms.jpg', 'jpg', 'image', 83489, 'assets/news/nukeviet-cms.jpg', 80, 55, '500|345', 1, 1759410696, 12, 'nukeviet-cms.jpg', 'nukeviet cms'),
('nukeviet-n...jpg', 'jpg', 'image', 18611, 'assets/news/nukeviet-nhantaidatviet2011.jpg', 80, 54, '400|268', 1, 1759410696, 12, 'nukeviet-nhantaidatviet2011.jpg', 'nukeviet nhantaidatviet2011'),
('tap-huan-p...jpg', 'jpg', 'image', 132379, 'assets/news/tap-huan-pgd-ha-dong-2015.jpg', 80, 51, '460|295', 1, 1759410696, 12, 'tap-huan-pgd-ha-dong-2015.jpg', 'tap huan pgd ha dong 2015'),
('thuc-tap-sinh.jpg', 'jpg', 'image', 71135, 'assets/news/thuc-tap-sinh.jpg', 80, 63, '460|360', 1, 1759410696, 12, 'thuc-tap-sinh.jpg', 'thuc tap sinh'),
('tuyen-dung...png', 'png', 'image', 118910, 'assets/news/tuyen-dung-nvkd.png', 80, 56, '400|279', 1, 1759410696, 12, 'tuyen-dung-nvkd.png', 'tuyen dung nvkd'),
('tuyendung-...jpg', 'jpg', 'image', 83783, 'assets/news/tuyendung-kythuat.jpg', 80, 80, '300|300', 1, 1759410696, 12, 'tuyendung-kythuat.jpg', 'tuyendung kythuat');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users`
--

CREATE TABLE `nv5_users` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `group_id` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `username` varchar(100) NOT NULL DEFAULT '',
  `md5username` char(32) NOT NULL DEFAULT '',
  `password` varchar(150) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `gender` char(1) DEFAULT '',
  `photo` varchar(255) DEFAULT '',
  `birthday` int(11) NOT NULL,
  `sig` text DEFAULT NULL,
  `regdate` int(11) NOT NULL DEFAULT 0,
  `question` varchar(255) NOT NULL,
  `answer` varchar(255) NOT NULL DEFAULT '',
  `passlostkey` varchar(50) DEFAULT '',
  `view_mail` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `remember` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `in_groups` varchar(255) DEFAULT '',
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `active2step` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `secretkey` varchar(20) DEFAULT '',
  `pref_2fa` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Xác thực 2 bước ưu tiên: 0 chưa chọn để hệ thống tự xác định, 1 mã ứng dụng, 2 khóa truy cập',
  `sec_keys` smallint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Số khóa bảo mật hoặc passkey',
  `checknum` varchar(40) DEFAULT '',
  `last_login` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_ip` varchar(45) DEFAULT '',
  `last_agent` varchar(255) DEFAULT '',
  `last_openid` varchar(255) DEFAULT '',
  `last_passkey` varchar(100) NOT NULL DEFAULT '' COMMENT 'Nickname của passkey cuối cùng',
  `last_update` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời điểm cập nhật thông tin lần cuối',
  `idsite` int(11) NOT NULL DEFAULT 0,
  `safemode` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `safekey` varchar(40) DEFAULT '',
  `pass_creation_time` int(11) NOT NULL DEFAULT 0,
  `pass_reset_request` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Yêu cầu thay đổi mật khẩu: 0: không; 1: Bắt buộc; 2: Khuyến khích',
  `email_creation_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian cập nhật email',
  `email_reset_request` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Yêu cầu thay đổi email: 0: không; 1: Bắt buộc; 2: Khuyến khích',
  `email_verification_time` int(11) NOT NULL DEFAULT -1 COMMENT '-3: Tài khoản sys, -2: Admin kích hoạt, -1 không cần kích hoạt, 0: Chưa xác minh, > 0 thời gian xác minh',
  `active_obj` varchar(50) NOT NULL DEFAULT 'SYSTEM' COMMENT 'SYSTEM, EMAIL, OAUTH:xxxx, quản trị kích hoạt thì lưu userid',
  `language` char(2) NOT NULL DEFAULT '' COMMENT 'Ngôn ngữ giao diện'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users`
--

INSERT INTO `nv5_users` (`userid`, `group_id`, `username`, `md5username`, `password`, `email`, `first_name`, `last_name`, `gender`, `photo`, `birthday`, `sig`, `regdate`, `question`, `answer`, `passlostkey`, `view_mail`, `remember`, `in_groups`, `active`, `active2step`, `secretkey`, `pref_2fa`, `sec_keys`, `checknum`, `last_login`, `last_ip`, `last_agent`, `last_openid`, `last_passkey`, `last_update`, `idsite`, `safemode`, `safekey`, `pass_creation_time`, `pass_reset_request`, `email_creation_time`, `email_reset_request`, `email_verification_time`, `active_obj`, `language`) VALUES
(1, 1, 'hazeruno', '7e4f6df6c0fe55460442d9e2c01f153a', '{SSHA512}TP8SRnCk4+8fUVIK1XP/MdjubRY5NAxs3YFlavtnWwSqBKP+vKxy5nKCcqAQ5us6w2+yac6qPGyBYMyAPkY8xTZmMmI=', 'huy023156@gmail.com', 'hazeruno', '', '', '', 0, '', 1759423399, '1+1&#x3D;', '2', '', 0, 1, '1,4', 1, 0, '', 0, 0, '5c1dee2241c000fc0103b953d356bb85', 1759559867, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', 1759918699, 0, 0, '', 1759918699, 0, 1759423399, 0, -3, 'SYSTEM', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_backupcodes`
--

CREATE TABLE `nv5_users_backupcodes` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `code` varchar(20) NOT NULL,
  `is_used` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `time_used` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `time_creat` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_config`
--

CREATE TABLE `nv5_users_config` (
  `config` varchar(100) NOT NULL,
  `content` text DEFAULT NULL,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_config`
--

INSERT INTO `nv5_users_config` (`config`, `content`, `edit_time`) VALUES
('access_admin', 'a:8:{s:15:\"access_viewlist\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:12:\"access_addus\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:14:\"access_waiting\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:17:\"access_editcensor\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:13:\"access_editus\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:12:\"access_delus\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:13:\"access_passus\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:13:\"access_groups\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}}', 1759423352),
('password_simple', '000000|1234|2000|12345|111111|123123|123456|11223344|654321|696969|1234567|12345678|87654321|123456789|23456789|1234567890|66666666|68686868|66668888|88888888|99999999|999999999|1234569|12345679|aaaaaa|abc123|abc123@|abc@123|admin123|admin123@|admin@123|nuke123|nuke123@|nuke@123|adobe1|adobe123|azerty|baseball|dragon|football|harley|iloveyou|jennifer|jordan|letmein|macromedia|master|michael|monkey|mustang|password|photoshop|pussy|qwerty|shadow|superman|hoilamgi|khongbiet|khongco|khongcopass', 1759423352),
('deny_email', 'yoursite.com|mysite.com|localhost|xxx', 1759423352),
('deny_name', 'anonimo|anonymous|god|linux|nobody|operator|root', 1759423352),
('avatar_width', '80', 1759423352),
('avatar_height', '80', 1759423352),
('active_group_newusers', '0', 1759423352),
('active_editinfo_censor', '0', 1759423352),
('active_user_logs', '1', 1759423352),
('min_old_user', '16', 1759423352),
('register_active_time', '86400', 1759423352),
('auto_assign_oauthuser', '0', 1759423352),
('admin_email', '0', 1759423352),
('siteterms_en', '<p style=\"text-align:center;\"> <strong>Website usage terms and conditions – sample template</strong></p><p> Welcome to our website. If you continue to browse and use this website you are agreeing to comply with and be bound by the following terms and conditions of use, which together with our privacy policy govern [business name]’s relationship with you in relation to this website.<br /> The term ‘[business name]’ or ‘us’ or ‘we’ refers to the owner of the website whose registered office is [address]. Our company registration number is [company registration number and place of registration]. The term ‘you’ refers to the user or viewer of our website.<br /> The use of this website is subject to the following terms of use:<br /> • The content of the pages of this website is for your general information and use only. It is subject to change without notice.<br /> • Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness or suitability of the information and materials found or offered on this website for any particular purpose. You acknowledge that such information and materials may contain inaccuracies or errors and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.<br /> • Your use of any information or materials on this website is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services or information available through this website meet your specific requirements.<br /> • This website contains material which is owned by or licensed to us. This material includes, but is not limited to, the design, layout, look, appearance and graphics. Reproduction is prohibited other than in accordance with the copyright notice, which forms part of these terms and conditions.<br /> • All trademarks reproduced in this website, which are not the property of, or licensed to the operator, are acknowledged on the website.<br /> • Unauthorised use of this website may give rise to a claim for damages and/or be a criminal offence.<br /> • fr0m time to time this website may also include links to other websites. These links are provided for your convenience to provide further information. They do not signify that we endorse the website(s). We have no responsibility for the content of the linked website(s).<br /> • You may not crea-te a link to this website fr0m another website or document without [business name]’s prior written consent.<br /> • Your use of this website and any dispute arising out of such use of the website is subject to the laws of England, Scotland and Wales.</p>', 1274757617);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_edit`
--

CREATE TABLE `nv5_users_edit` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `lastedit` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `info_basic` text NOT NULL,
  `info_custom` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_field`
--

CREATE TABLE `nv5_users_field` (
  `fid` mediumint(8) NOT NULL,
  `field` varchar(25) NOT NULL,
  `weight` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `field_type` enum('number','date','textbox','textarea','editor','select','radio','checkbox','multiselect','file') NOT NULL DEFAULT 'textbox',
  `field_choices` text NOT NULL,
  `sql_choices` text NOT NULL,
  `match_type` enum('none','alphanumeric','unicodename','email','url','regex','callback') NOT NULL DEFAULT 'none',
  `match_regex` varchar(250) NOT NULL DEFAULT '',
  `func_callback` varchar(75) NOT NULL DEFAULT '',
  `min_length` int(11) NOT NULL DEFAULT 0,
  `max_length` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `limited_values` text DEFAULT NULL,
  `for_admin` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `required` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `show_register` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `user_editable` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `show_profile` tinyint(4) NOT NULL DEFAULT 1,
  `class` varchar(50) NOT NULL,
  `language` text NOT NULL,
  `default_value` varchar(255) NOT NULL DEFAULT '',
  `is_system` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_field`
--

INSERT INTO `nv5_users_field` (`fid`, `field`, `weight`, `field_type`, `field_choices`, `sql_choices`, `match_type`, `match_regex`, `func_callback`, `min_length`, `max_length`, `limited_values`, `for_admin`, `required`, `show_register`, `user_editable`, `show_profile`, `class`, `language`, `default_value`, `is_system`) VALUES
(1, 'first_name', 1, 'textbox', '', '', 'none', '', '', 0, 100, '', 0, 1, 1, 1, 1, 'input', 'a:1:{s:2:\"en\";a:2:{i:0;s:10:\"First Name\";i:1;s:0:\"\";}}', '', 1),
(2, 'last_name', 2, 'textbox', '', '', 'none', '', '', 0, 100, '', 0, 0, 1, 1, 1, 'input', 'a:1:{s:2:\"en\";a:2:{i:0;s:9:\"Last Name\";i:1;s:0:\"\";}}', '', 1),
(3, 'gender', 3, 'select', 'a:3:{s:1:\"N\";s:0:\"\";s:1:\"M\";s:0:\"\";s:1:\"F\";s:0:\"\";}', '', 'none', '', '', 0, 1, '', 0, 0, 1, 1, 1, 'input', 'a:1:{s:2:\"en\";a:2:{i:0;s:6:\"Gender\";i:1;s:0:\"\";}}', '2', 1),
(4, 'birthday', 4, 'date', 'a:1:{s:12:\"current_date\";i:0;}', '', 'none', '', '', 0, 0, '', 0, 1, 1, 1, 1, 'input', 'a:1:{s:2:\"en\";a:2:{i:0;s:8:\"Birthday\";i:1;s:0:\"\";}}', '0', 1),
(5, 'sig', 5, 'textarea', '', '', 'none', '', '', 0, 1000, '', 0, 0, 1, 1, 1, 'input', 'a:1:{s:2:\"en\";a:2:{i:0;s:9:\"Signature\";i:1;s:0:\"\";}}', '', 1),
(6, 'question', 6, 'textbox', '', '', 'none', '', '', 3, 255, '', 0, 1, 1, 1, 1, 'input', 'a:1:{s:2:\"en\";a:2:{i:0;s:17:\"Security Question\";i:1;s:0:\"\";}}', '', 1),
(7, 'answer', 7, 'textbox', '', '', 'none', '', '', 3, 255, '', 0, 1, 1, 1, 1, 'input', 'a:1:{s:2:\"en\";a:2:{i:0;s:6:\"Answer\";i:1;s:0:\"\";}}', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_groups`
--

CREATE TABLE `nv5_users_groups` (
  `group_id` smallint(5) UNSIGNED NOT NULL,
  `alias` varchar(240) NOT NULL,
  `email` varchar(100) DEFAULT '',
  `group_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0:Sys, 1:approval, 2:public',
  `group_color` varchar(10) NOT NULL,
  `group_avatar` varchar(255) NOT NULL,
  `require_2step_admin` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `require_2step_site` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `is_default` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) NOT NULL,
  `exp_time` int(11) NOT NULL,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL,
  `idsite` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `numbers` mediumint(9) UNSIGNED NOT NULL DEFAULT 0,
  `siteus` tinyint(4) UNSIGNED NOT NULL DEFAULT 0,
  `config` varchar(250) DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_groups`
--

INSERT INTO `nv5_users_groups` (`group_id`, `alias`, `email`, `group_type`, `group_color`, `group_avatar`, `require_2step_admin`, `require_2step_site`, `is_default`, `add_time`, `exp_time`, `weight`, `act`, `idsite`, `numbers`, `siteus`, `config`) VALUES
(1, 'Super-Admin', '', 0, '', '', 0, 0, 0, 1759423352, 0, 1, 1, 0, 1, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(2, 'General-Admin', '', 0, '', '', 0, 0, 0, 1759423352, 0, 2, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(3, 'Module-Admin', '', 0, '', '', 0, 0, 0, 1759423352, 0, 3, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(4, 'Users', '', 0, '', '', 0, 0, 0, 1759423352, 0, 4, 1, 0, 1, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(7, 'New-Users', '', 0, '', '', 0, 0, 0, 1759423352, 0, 5, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(5, 'Guest', '', 0, '', '', 0, 0, 0, 1759423352, 0, 6, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(6, 'All', '', 0, '', '', 0, 0, 0, 1759423352, 0, 7, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(10, 'NukeViet-Fans', '', 2, '', '', 0, 0, 1, 1759423352, 0, 8, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(11, 'NukeViet-Admins', '', 2, '', '', 0, 0, 0, 1759423352, 0, 9, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(12, 'NukeViet-Programmers', '', 1, '', '', 0, 0, 0, 1759423352, 0, 10, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_groups_detail`
--

CREATE TABLE `nv5_users_groups_detail` (
  `group_id` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `lang` char(2) NOT NULL DEFAULT '',
  `title` varchar(240) NOT NULL,
  `description` varchar(240) NOT NULL DEFAULT '',
  `content` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_groups_detail`
--

INSERT INTO `nv5_users_groups_detail` (`group_id`, `lang`, `title`, `description`, `content`) VALUES
(1, 'en', 'Super Admin', '', ''),
(2, 'en', 'General Admin', '', ''),
(3, 'en', 'Module Admin', '', ''),
(4, 'en', 'Users', '', ''),
(7, 'en', 'New Users', '', ''),
(5, 'en', 'Guest', '', ''),
(6, 'en', 'All', '', ''),
(10, 'en', 'NukeViet-Fans', 'NukeViet System Fans Group', ''),
(11, 'en', 'NukeViet-Admins', 'Group of administrators for sites built by the NukeViet system', ''),
(12, 'en', 'NukeViet-Programmers', 'NukeViet System Programmers Group', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_groups_users`
--

CREATE TABLE `nv5_users_groups_users` (
  `group_id` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `is_leader` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `approved` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `data` text NOT NULL,
  `time_requested` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian yêu cầu tham gia',
  `time_approved` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian duyệt yêu cầu tham gia'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_groups_users`
--

INSERT INTO `nv5_users_groups_users` (`group_id`, `userid`, `is_leader`, `approved`, `data`, `time_requested`, `time_approved`) VALUES
(1, 1, 1, 1, '0', 1759423399, 1759423399);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_info`
--

CREATE TABLE `nv5_users_info` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `inform` char(30) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_info`
--

INSERT INTO `nv5_users_info` (`userid`, `inform`) VALUES
(1, '0|1762352166');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_login`
--

CREATE TABLE `nv5_users_login` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `clid` char(32) NOT NULL,
  `logtime` int(11) UNSIGNED NOT NULL,
  `mode` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `agent` varchar(255) NOT NULL,
  `ip` char(50) NOT NULL,
  `mode_extra` varchar(255) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_oldpass`
--

CREATE TABLE `nv5_users_oldpass` (
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `password` varchar(150) NOT NULL DEFAULT '',
  `pass_creation_time` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_oldpass`
--

INSERT INTO `nv5_users_oldpass` (`userid`, `password`, `pass_creation_time`) VALUES
(1, '{SSHA512}BRsRELC162wcfi/QfVqeImREAk4AxIbt71NUQTSfxA6+B2pDNdAgAi5BiOlM7wvRgF4TFBaViw0AQok9jH5TVWI5YzA=', 1759423399);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_openid`
--

CREATE TABLE `nv5_users_openid` (
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `openid` char(50) NOT NULL DEFAULT '',
  `opid` char(50) NOT NULL DEFAULT '',
  `id` char(50) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_passkey`
--

CREATE TABLE `nv5_users_passkey` (
  `id` int(11) UNSIGNED NOT NULL,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `keyid` varchar(180) NOT NULL DEFAULT '' COMMENT 'Key ID',
  `publickey` text NOT NULL COMMENT 'Public key',
  `userhandle` varchar(100) NOT NULL DEFAULT '' COMMENT 'User handle',
  `counter` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Bộ đếm phát hiện thiết bị fake',
  `aaguid` varchar(50) NOT NULL DEFAULT '' COMMENT 'GUID thiết bị',
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT 'Loại, thường chỉ là public-key',
  `created_at` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Tạo',
  `last_used_at` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Lần cuối sử dụng',
  `clid` varchar(32) NOT NULL DEFAULT '' COMMENT 'ID trình duyệt tạo ra nó',
  `enable_login` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cho phép đăng nhập hay không',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT 'Đặt tên gợi nhớ'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Passkey của thành viên để đăng nhập/xác thực 2 bước';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_question`
--

CREATE TABLE `nv5_users_question` (
  `qid` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(240) NOT NULL DEFAULT '',
  `lang` char(2) NOT NULL DEFAULT '',
  `weight` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_question`
--

INSERT INTO `nv5_users_question` (`qid`, `title`, `lang`, `weight`, `add_time`, `edit_time`) VALUES
(1, 'What is the first name of your favorite uncle?', 'en', 1, 1274841115, 1274841115),
(2, 'whe-re did you meet your spouse', 'en', 2, 1274841123, 1274841123),
(3, 'What is your oldest cousin&#039;s name?', 'en', 3, 1274841131, 1274841131),
(4, 'What is your youngest child&#039;s username?', 'en', 4, 1274841142, 1274841142),
(5, 'What is your oldest child&#039;s username?', 'en', 5, 1274841150, 1274841150),
(6, 'What is the first name of your oldest niece?', 'en', 6, 1274841158, 1274841158),
(7, 'What is the first name of your oldest nephew?', 'en', 7, 1274841167, 1274841167),
(8, 'What is the first name of your favorite aunt?', 'en', 8, 1274841175, 1274841175),
(9, 'whe-re did you spend your honeymoon?', 'en', 9, 1274841183, 1274841183);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_reg`
--

CREATE TABLE `nv5_users_reg` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `username` varchar(100) NOT NULL DEFAULT '',
  `md5username` char(32) NOT NULL DEFAULT '',
  `password` varchar(150) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `gender` char(1) NOT NULL DEFAULT '',
  `birthday` int(11) NOT NULL,
  `sig` text DEFAULT NULL,
  `regdate` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `question` varchar(255) NOT NULL,
  `answer` varchar(255) NOT NULL DEFAULT '',
  `checknum` varchar(50) NOT NULL DEFAULT '',
  `users_info` text DEFAULT NULL,
  `openid_info` text DEFAULT NULL,
  `idsite` mediumint(8) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_article`
--

CREATE TABLE `nv5_zalo_article` (
  `id` mediumint(8) NOT NULL,
  `zalo_id` char(100) NOT NULL DEFAULT '',
  `token` text NOT NULL,
  `type` char(10) NOT NULL DEFAULT '',
  `title` varchar(150) NOT NULL DEFAULT '',
  `author` char(50) NOT NULL DEFAULT '',
  `cover_type` char(20) NOT NULL DEFAULT '',
  `cover_photo_url` varchar(250) NOT NULL DEFAULT '',
  `cover_video_id` char(100) NOT NULL DEFAULT '',
  `cover_view` char(10) NOT NULL DEFAULT 'horizontal',
  `cover_status` char(10) NOT NULL DEFAULT 'hide',
  `description` text NOT NULL,
  `body` text NOT NULL,
  `related_medias` text NOT NULL,
  `tracking_link` varchar(250) NOT NULL DEFAULT '',
  `video_id` char(100) NOT NULL DEFAULT '',
  `video_avatar` varchar(250) NOT NULL DEFAULT '',
  `status` char(10) NOT NULL DEFAULT 'show',
  `comment` char(10) NOT NULL DEFAULT 'show',
  `create_date` int(11) NOT NULL DEFAULT 0,
  `update_date` int(11) NOT NULL DEFAULT 0,
  `total_view` int(11) NOT NULL DEFAULT 0,
  `total_share` int(11) NOT NULL DEFAULT 0,
  `is_sync` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_conversation`
--

CREATE TABLE `nv5_zalo_conversation` (
  `message_id` char(50) NOT NULL,
  `user_id` char(30) NOT NULL,
  `src` tinyint(1) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `type` char(20) NOT NULL DEFAULT '',
  `message` text NOT NULL,
  `links` text NOT NULL,
  `thumb` varchar(250) NOT NULL DEFAULT '',
  `url` varchar(250) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `location` char(150) NOT NULL DEFAULT '',
  `note` text NOT NULL,
  `displayed` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_followers`
--

CREATE TABLE `nv5_zalo_followers` (
  `user_id` char(30) NOT NULL,
  `app_id` char(30) NOT NULL,
  `user_id_by_app` char(30) NOT NULL DEFAULT '',
  `display_name` varchar(250) NOT NULL DEFAULT '',
  `is_sensitive` tinyint(1) NOT NULL DEFAULT 0,
  `avatar120` varchar(250) NOT NULL DEFAULT '',
  `avatar240` varchar(250) NOT NULL DEFAULT '',
  `user_gender` char(1) NOT NULL DEFAULT '',
  `tags_info` text NOT NULL,
  `notes_info` text NOT NULL,
  `isfollow` tinyint(1) NOT NULL DEFAULT 1,
  `weight` mediumint(8) NOT NULL DEFAULT 0,
  `name` char(100) NOT NULL DEFAULT '',
  `phone_code` char(10) NOT NULL DEFAULT '',
  `phone_number` char(20) NOT NULL DEFAULT '',
  `address` varchar(250) NOT NULL DEFAULT '',
  `city_id` char(10) NOT NULL DEFAULT '',
  `district_id` char(10) NOT NULL DEFAULT '',
  `is_sync` tinyint(1) NOT NULL DEFAULT 0,
  `updatetime` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_settings`
--

CREATE TABLE `nv5_zalo_settings` (
  `skey` char(100) NOT NULL,
  `type` char(20) NOT NULL DEFAULT '',
  `svalue` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_tags`
--

CREATE TABLE `nv5_zalo_tags` (
  `alias` char(50) NOT NULL,
  `name` char(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_tags_follower`
--

CREATE TABLE `nv5_zalo_tags_follower` (
  `tag` char(50) NOT NULL,
  `user_id` char(30) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_template`
--

CREATE TABLE `nv5_zalo_template` (
  `id` smallint(4) NOT NULL,
  `type` char(10) NOT NULL,
  `content` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_upload`
--

CREATE TABLE `nv5_zalo_upload` (
  `id` tinyint(8) NOT NULL,
  `type` char(50) NOT NULL,
  `extension` char(10) NOT NULL,
  `file` varchar(250) NOT NULL,
  `localfile` varchar(250) NOT NULL DEFAULT '',
  `width` smallint(4) NOT NULL DEFAULT 0,
  `height` smallint(4) NOT NULL DEFAULT 0,
  `zalo_id` varchar(250) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  `addtime` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_video`
--

CREATE TABLE `nv5_zalo_video` (
  `id` mediumint(8) NOT NULL,
  `video_id` char(100) NOT NULL DEFAULT '',
  `token` text NOT NULL,
  `video_name` char(100) NOT NULL DEFAULT '',
  `video_size` int(11) NOT NULL DEFAULT 0,
  `description` varchar(250) NOT NULL DEFAULT '',
  `view` char(10) NOT NULL DEFAULT 'horizontal',
  `thumb` varchar(250) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `status_message` char(100) NOT NULL DEFAULT '',
  `convert_percent` int(11) NOT NULL DEFAULT 0,
  `convert_error_code` int(11) NOT NULL DEFAULT 0,
  `addtime` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `nv5_api_role`
--
ALTER TABLE `nv5_api_role`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_md5title` (`role_md5title`);

--
-- Indexes for table `nv5_api_role_credential`
--
ALTER TABLE `nv5_api_role_credential`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `userid_role_id` (`userid`,`role_id`);

--
-- Indexes for table `nv5_api_role_logs`
--
ALTER TABLE `nv5_api_role_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_log_time_userid` (`log_time`,`userid`);

--
-- Indexes for table `nv5_api_user`
--
ALTER TABLE `nv5_api_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `userid_method` (`userid`,`method`),
  ADD UNIQUE KEY `ident` (`ident`),
  ADD UNIQUE KEY `secret` (`secret`);

--
-- Indexes for table `nv5_authors`
--
ALTER TABLE `nv5_authors`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `nv5_authors_config`
--
ALTER TABLE `nv5_authors_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `keyname` (`keyname`);

--
-- Indexes for table `nv5_authors_module`
--
ALTER TABLE `nv5_authors_module`
  ADD PRIMARY KEY (`mid`),
  ADD UNIQUE KEY `module` (`module`);

--
-- Indexes for table `nv5_authors_oauth`
--
ALTER TABLE `nv5_authors_oauth`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_id` (`admin_id`,`oauth_server`,`oauth_uid`),
  ADD KEY `oauth_email` (`oauth_email`);

--
-- Indexes for table `nv5_authors_vars`
--
ALTER TABLE `nv5_authors_vars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `lang` (`lang`),
  ADD KEY `theme` (`theme`),
  ADD KEY `config_name` (`config_name`),
  ADD KEY `weight` (`weight`);

--
-- Indexes for table `nv5_banners_click`
--
ALTER TABLE `nv5_banners_click`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bid` (`bid`),
  ADD KEY `click_day` (`click_day`),
  ADD KEY `click_ip` (`click_ip`),
  ADD KEY `click_country` (`click_country`),
  ADD KEY `click_browse_key` (`click_browse_key`),
  ADD KEY `click_os_key` (`click_os_key`);

--
-- Indexes for table `nv5_banners_plans`
--
ALTER TABLE `nv5_banners_plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `title` (`title`);

--
-- Indexes for table `nv5_banners_rows`
--
ALTER TABLE `nv5_banners_rows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pid` (`pid`),
  ADD KEY `clid` (`clid`);

--
-- Indexes for table `nv5_config`
--
ALTER TABLE `nv5_config`
  ADD UNIQUE KEY `lang` (`lang`,`module`,`config_name`);

--
-- Indexes for table `nv5_cookies`
--
ALTER TABLE `nv5_cookies`
  ADD UNIQUE KEY `cookiename` (`name`,`domain`,`path`),
  ADD KEY `name` (`name`);

--
-- Indexes for table `nv5_counter`
--
ALTER TABLE `nv5_counter`
  ADD UNIQUE KEY `c_type` (`c_type`,`c_val`);

--
-- Indexes for table `nv5_cronjobs`
--
ALTER TABLE `nv5_cronjobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `is_sys` (`is_sys`);

--
-- Indexes for table `nv5_dictionary_entries`
--
ALTER TABLE `nv5_dictionary_entries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_slug` (`slug`),
  ADD KEY `idx_headword` (`headword`);

--
-- Indexes for table `nv5_dictionary_examples`
--
ALTER TABLE `nv5_dictionary_examples`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_entry_id` (`entry_id`);

--
-- Indexes for table `nv5_emailtemplates`
--
ALTER TABLE `nv5_emailtemplates`
  ADD PRIMARY KEY (`emailid`),
  ADD UNIQUE KEY `module_id` (`lang`,`module_name`,`id`),
  ADD KEY `lang` (`lang`),
  ADD KEY `module_file` (`module_file`),
  ADD KEY `catid` (`catid`),
  ADD KEY `time_add` (`time_add`),
  ADD KEY `time_update` (`time_update`),
  ADD KEY `en_title` (`en_title`);

--
-- Indexes for table `nv5_emailtemplates_categories`
--
ALTER TABLE `nv5_emailtemplates_categories`
  ADD PRIMARY KEY (`catid`),
  ADD UNIQUE KEY `en_title` (`en_title`(191)),
  ADD KEY `status` (`status`);

--
-- Indexes for table `nv5_en_about`
--
ALTER TABLE `nv5_en_about`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_en_about_config`
--
ALTER TABLE `nv5_en_about_config`
  ADD UNIQUE KEY `config_name` (`config_name`);

--
-- Indexes for table `nv5_en_blocks_groups`
--
ALTER TABLE `nv5_en_blocks_groups`
  ADD PRIMARY KEY (`bid`),
  ADD KEY `theme` (`theme`),
  ADD KEY `module` (`module`),
  ADD KEY `position` (`position`);

--
-- Indexes for table `nv5_en_blocks_weight`
--
ALTER TABLE `nv5_en_blocks_weight`
  ADD UNIQUE KEY `bid` (`bid`,`func_id`);

--
-- Indexes for table `nv5_en_comment`
--
ALTER TABLE `nv5_en_comment`
  ADD PRIMARY KEY (`cid`),
  ADD KEY `mod_id` (`module`,`area`,`id`),
  ADD KEY `post_time` (`post_time`);

--
-- Indexes for table `nv5_en_contact_department`
--
ALTER TABLE `nv5_en_contact_department`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `full_name` (`full_name`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_en_contact_reply`
--
ALTER TABLE `nv5_en_contact_reply`
  ADD PRIMARY KEY (`rid`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `nv5_en_contact_send`
--
ALTER TABLE `nv5_en_contact_send`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_name` (`sender_name`);

--
-- Indexes for table `nv5_en_contact_supporter`
--
ALTER TABLE `nv5_en_contact_supporter`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_en_freecontent_blocks`
--
ALTER TABLE `nv5_en_freecontent_blocks`
  ADD PRIMARY KEY (`bid`);

--
-- Indexes for table `nv5_en_freecontent_rows`
--
ALTER TABLE `nv5_en_freecontent_rows`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_en_menu`
--
ALTER TABLE `nv5_en_menu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `nv5_en_menu_rows`
--
ALTER TABLE `nv5_en_menu_rows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parentid` (`parentid`,`mid`);

--
-- Indexes for table `nv5_en_modblocks`
--
ALTER TABLE `nv5_en_modblocks`
  ADD UNIQUE KEY `modblock` (`module_name`,`tag`),
  ADD KEY `module_name` (`module_name`),
  ADD KEY `tag` (`tag`);

--
-- Indexes for table `nv5_en_modfuncs`
--
ALTER TABLE `nv5_en_modfuncs`
  ADD PRIMARY KEY (`func_id`),
  ADD UNIQUE KEY `func_name` (`func_name`,`in_module`),
  ADD UNIQUE KEY `alias` (`alias`,`in_module`);

--
-- Indexes for table `nv5_en_modthemes`
--
ALTER TABLE `nv5_en_modthemes`
  ADD UNIQUE KEY `func_id` (`func_id`,`layout`,`theme`);

--
-- Indexes for table `nv5_en_modules`
--
ALTER TABLE `nv5_en_modules`
  ADD PRIMARY KEY (`title`);

--
-- Indexes for table `nv5_en_news_1`
--
ALTER TABLE `nv5_en_news_1`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_2`
--
ALTER TABLE `nv5_en_news_2`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_3`
--
ALTER TABLE `nv5_en_news_3`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_4`
--
ALTER TABLE `nv5_en_news_4`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_5`
--
ALTER TABLE `nv5_en_news_5`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_6`
--
ALTER TABLE `nv5_en_news_6`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_7`
--
ALTER TABLE `nv5_en_news_7`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_8`
--
ALTER TABLE `nv5_en_news_8`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_9`
--
ALTER TABLE `nv5_en_news_9`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_10`
--
ALTER TABLE `nv5_en_news_10`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_11`
--
ALTER TABLE `nv5_en_news_11`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_12`
--
ALTER TABLE `nv5_en_news_12`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_13`
--
ALTER TABLE `nv5_en_news_13`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_14`
--
ALTER TABLE `nv5_en_news_14`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_admins`
--
ALTER TABLE `nv5_en_news_admins`
  ADD UNIQUE KEY `userid` (`userid`,`catid`);

--
-- Indexes for table `nv5_en_news_author`
--
ALTER TABLE `nv5_en_news_author`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uid` (`uid`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_en_news_authorlist`
--
ALTER TABLE `nv5_en_news_authorlist`
  ADD UNIQUE KEY `id_aid` (`id`,`aid`),
  ADD KEY `aid` (`aid`),
  ADD KEY `alias` (`alias`);

--
-- Indexes for table `nv5_en_news_block`
--
ALTER TABLE `nv5_en_news_block`
  ADD UNIQUE KEY `bid` (`bid`,`id`);

--
-- Indexes for table `nv5_en_news_block_cat`
--
ALTER TABLE `nv5_en_news_block_cat`
  ADD PRIMARY KEY (`bid`),
  ADD UNIQUE KEY `title` (`title`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_en_news_cat`
--
ALTER TABLE `nv5_en_news_cat`
  ADD PRIMARY KEY (`catid`),
  ADD UNIQUE KEY `alias` (`alias`),
  ADD KEY `parentid` (`parentid`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `nv5_en_news_config_post`
--
ALTER TABLE `nv5_en_news_config_post`
  ADD PRIMARY KEY (`group_id`);

--
-- Indexes for table `nv5_en_news_detail`
--
ALTER TABLE `nv5_en_news_detail`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_en_news_logs`
--
ALTER TABLE `nv5_en_news_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sid` (`sid`),
  ADD KEY `log_key` (`log_key`),
  ADD KEY `status` (`status`),
  ADD KEY `userid` (`userid`);

--
-- Indexes for table `nv5_en_news_report`
--
ALTER TABLE `nv5_en_news_report`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `newsid_md5content_post_ip` (`newsid`,`md5content`,`post_ip`);

--
-- Indexes for table `nv5_en_news_rows`
--
ALTER TABLE `nv5_en_news_rows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_en_news_row_histories`
--
ALTER TABLE `nv5_en_news_row_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `new_id` (`new_id`),
  ADD KEY `historytime` (`historytime`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `nv5_en_news_sources`
--
ALTER TABLE `nv5_en_news_sources`
  ADD PRIMARY KEY (`sourceid`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `nv5_en_news_tags`
--
ALTER TABLE `nv5_en_news_tags`
  ADD PRIMARY KEY (`tid`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_en_news_tags_id`
--
ALTER TABLE `nv5_en_news_tags_id`
  ADD UNIQUE KEY `id_tid` (`id`,`tid`),
  ADD KEY `tid` (`tid`);

--
-- Indexes for table `nv5_en_news_tmp`
--
ALTER TABLE `nv5_en_news_tmp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tmp_id` (`new_id`,`type`,`admin_id`),
  ADD KEY `draft_id` (`admin_id`,`type`),
  ADD KEY `uuid` (`uuid`);

--
-- Indexes for table `nv5_en_news_topics`
--
ALTER TABLE `nv5_en_news_topics`
  ADD PRIMARY KEY (`topicid`),
  ADD UNIQUE KEY `title` (`title`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_en_news_voices`
--
ALTER TABLE `nv5_en_news_voices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD KEY `weight` (`weight`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `nv5_en_page`
--
ALTER TABLE `nv5_en_page`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_en_page_config`
--
ALTER TABLE `nv5_en_page_config`
  ADD UNIQUE KEY `config_name` (`config_name`);

--
-- Indexes for table `nv5_en_referer_stats`
--
ALTER TABLE `nv5_en_referer_stats`
  ADD UNIQUE KEY `host` (`host`),
  ADD KEY `total` (`total`);

--
-- Indexes for table `nv5_en_searchkeys`
--
ALTER TABLE `nv5_en_searchkeys`
  ADD KEY `id` (`id`),
  ADD KEY `skey` (`skey`),
  ADD KEY `search_engine` (`search_engine`);

--
-- Indexes for table `nv5_en_siteterms`
--
ALTER TABLE `nv5_en_siteterms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_en_siteterms_config`
--
ALTER TABLE `nv5_en_siteterms_config`
  ADD UNIQUE KEY `config_name` (`config_name`);

--
-- Indexes for table `nv5_en_voting`
--
ALTER TABLE `nv5_en_voting`
  ADD PRIMARY KEY (`vid`),
  ADD UNIQUE KEY `question` (`question`);

--
-- Indexes for table `nv5_en_voting_rows`
--
ALTER TABLE `nv5_en_voting_rows`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vid` (`vid`,`title`);

--
-- Indexes for table `nv5_en_voting_voted`
--
ALTER TABLE `nv5_en_voting_voted`
  ADD UNIQUE KEY `vid` (`vid`);

--
-- Indexes for table `nv5_extension_files`
--
ALTER TABLE `nv5_extension_files`
  ADD PRIMARY KEY (`idfile`);

--
-- Indexes for table `nv5_inform`
--
ALTER TABLE `nv5_inform`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_inform_status`
--
ALTER TABLE `nv5_inform_status`
  ADD UNIQUE KEY `pid_userid` (`pid`,`userid`);

--
-- Indexes for table `nv5_ips`
--
ALTER TABLE `nv5_ips`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ip` (`ip`,`type`);

--
-- Indexes for table `nv5_language`
--
ALTER TABLE `nv5_language`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `filelang` (`idfile`,`lang_key`,`langtype`);

--
-- Indexes for table `nv5_language_file`
--
ALTER TABLE `nv5_language_file`
  ADD PRIMARY KEY (`idfile`),
  ADD UNIQUE KEY `module` (`module`,`admin_file`);

--
-- Indexes for table `nv5_logs`
--
ALTER TABLE `nv5_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_notification`
--
ALTER TABLE `nv5_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `send_to` (`send_to`),
  ADD KEY `admin_view_allowed` (`admin_view_allowed`),
  ADD KEY `logic_mode` (`logic_mode`);

--
-- Indexes for table `nv5_plugins`
--
ALTER TABLE `nv5_plugins`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `plugin` (`plugin_lang`,`plugin_file`,`plugin_area`,`plugin_module_name`,`hook_module`);

--
-- Indexes for table `nv5_sessions`
--
ALTER TABLE `nv5_sessions`
  ADD UNIQUE KEY `session_id` (`session_id`),
  ADD KEY `onl_time` (`onl_time`);

--
-- Indexes for table `nv5_setup_extensions`
--
ALTER TABLE `nv5_setup_extensions`
  ADD UNIQUE KEY `title` (`type`,`title`),
  ADD KEY `id` (`id`),
  ADD KEY `type` (`type`);

--
-- Indexes for table `nv5_setup_language`
--
ALTER TABLE `nv5_setup_language`
  ADD PRIMARY KEY (`lang`);

--
-- Indexes for table `nv5_upload_dir`
--
ALTER TABLE `nv5_upload_dir`
  ADD PRIMARY KEY (`did`),
  ADD UNIQUE KEY `name` (`dirname`);

--
-- Indexes for table `nv5_upload_file`
--
ALTER TABLE `nv5_upload_file`
  ADD UNIQUE KEY `did` (`did`,`title`),
  ADD KEY `userid` (`userid`),
  ADD KEY `type` (`type`);

--
-- Indexes for table `nv5_users`
--
ALTER TABLE `nv5_users`
  ADD PRIMARY KEY (`userid`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `md5username` (`md5username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idsite` (`idsite`);

--
-- Indexes for table `nv5_users_backupcodes`
--
ALTER TABLE `nv5_users_backupcodes`
  ADD UNIQUE KEY `userid` (`userid`,`code`);

--
-- Indexes for table `nv5_users_config`
--
ALTER TABLE `nv5_users_config`
  ADD PRIMARY KEY (`config`);

--
-- Indexes for table `nv5_users_edit`
--
ALTER TABLE `nv5_users_edit`
  ADD PRIMARY KEY (`userid`);

--
-- Indexes for table `nv5_users_field`
--
ALTER TABLE `nv5_users_field`
  ADD PRIMARY KEY (`fid`),
  ADD UNIQUE KEY `field` (`field`);

--
-- Indexes for table `nv5_users_groups`
--
ALTER TABLE `nv5_users_groups`
  ADD PRIMARY KEY (`group_id`),
  ADD UNIQUE KEY `kalias` (`alias`,`idsite`),
  ADD KEY `exp_time` (`exp_time`);

--
-- Indexes for table `nv5_users_groups_detail`
--
ALTER TABLE `nv5_users_groups_detail`
  ADD UNIQUE KEY `group_id_lang` (`lang`,`group_id`);

--
-- Indexes for table `nv5_users_groups_users`
--
ALTER TABLE `nv5_users_groups_users`
  ADD PRIMARY KEY (`group_id`,`userid`);

--
-- Indexes for table `nv5_users_info`
--
ALTER TABLE `nv5_users_info`
  ADD PRIMARY KEY (`userid`);

--
-- Indexes for table `nv5_users_login`
--
ALTER TABLE `nv5_users_login`
  ADD UNIQUE KEY `userid` (`userid`,`clid`);

--
-- Indexes for table `nv5_users_oldpass`
--
ALTER TABLE `nv5_users_oldpass`
  ADD UNIQUE KEY `pass_creation_time` (`userid`,`pass_creation_time`);

--
-- Indexes for table `nv5_users_openid`
--
ALTER TABLE `nv5_users_openid`
  ADD UNIQUE KEY `opid` (`openid`,`opid`),
  ADD KEY `userid` (`userid`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `nv5_users_passkey`
--
ALTER TABLE `nv5_users_passkey`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uid` (`userid`,`keyid`),
  ADD UNIQUE KEY `ukeyid` (`userhandle`(40),`keyid`(151)),
  ADD KEY `userhandle` (`userhandle`);

--
-- Indexes for table `nv5_users_question`
--
ALTER TABLE `nv5_users_question`
  ADD PRIMARY KEY (`qid`),
  ADD UNIQUE KEY `title` (`title`,`lang`);

--
-- Indexes for table `nv5_users_reg`
--
ALTER TABLE `nv5_users_reg`
  ADD PRIMARY KEY (`userid`),
  ADD UNIQUE KEY `login` (`username`),
  ADD UNIQUE KEY `md5username` (`md5username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `nv5_zalo_article`
--
ALTER TABLE `nv5_zalo_article`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `zalo_id` (`zalo_id`),
  ADD KEY `is_sync` (`is_sync`);

--
-- Indexes for table `nv5_zalo_conversation`
--
ALTER TABLE `nv5_zalo_conversation`
  ADD PRIMARY KEY (`message_id`);

--
-- Indexes for table `nv5_zalo_followers`
--
ALTER TABLE `nv5_zalo_followers`
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `nv5_zalo_settings`
--
ALTER TABLE `nv5_zalo_settings`
  ADD UNIQUE KEY `info_key` (`skey`,`type`);

--
-- Indexes for table `nv5_zalo_tags`
--
ALTER TABLE `nv5_zalo_tags`
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_zalo_tags_follower`
--
ALTER TABLE `nv5_zalo_tags_follower`
  ADD UNIQUE KEY `tag` (`tag`,`user_id`);

--
-- Indexes for table `nv5_zalo_template`
--
ALTER TABLE `nv5_zalo_template`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_zalo_upload`
--
ALTER TABLE `nv5_zalo_upload`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type` (`type`);

--
-- Indexes for table `nv5_zalo_video`
--
ALTER TABLE `nv5_zalo_video`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `nv5_api_role`
--
ALTER TABLE `nv5_api_role`
  MODIFY `role_id` smallint(4) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_api_role_credential`
--
ALTER TABLE `nv5_api_role_credential`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_api_role_logs`
--
ALTER TABLE `nv5_api_role_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_api_user`
--
ALTER TABLE `nv5_api_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_authors_config`
--
ALTER TABLE `nv5_authors_config`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_authors_module`
--
ALTER TABLE `nv5_authors_module`
  MODIFY `mid` mediumint(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `nv5_authors_oauth`
--
ALTER TABLE `nv5_authors_oauth`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_authors_vars`
--
ALTER TABLE `nv5_authors_vars`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_banners_click`
--
ALTER TABLE `nv5_banners_click`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_banners_plans`
--
ALTER TABLE `nv5_banners_plans`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `nv5_banners_rows`
--
ALTER TABLE `nv5_banners_rows`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_cronjobs`
--
ALTER TABLE `nv5_cronjobs`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `nv5_dictionary_entries`
--
ALTER TABLE `nv5_dictionary_entries`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `nv5_dictionary_examples`
--
ALTER TABLE `nv5_dictionary_examples`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `nv5_emailtemplates`
--
ALTER TABLE `nv5_emailtemplates`
  MODIFY `emailid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1037;

--
-- AUTO_INCREMENT for table `nv5_emailtemplates_categories`
--
ALTER TABLE `nv5_emailtemplates_categories`
  MODIFY `catid` smallint(4) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `nv5_en_about`
--
ALTER TABLE `nv5_en_about`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_en_blocks_groups`
--
ALTER TABLE `nv5_en_blocks_groups`
  MODIFY `bid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `nv5_en_comment`
--
ALTER TABLE `nv5_en_comment`
  MODIFY `cid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_contact_department`
--
ALTER TABLE `nv5_en_contact_department`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_en_contact_reply`
--
ALTER TABLE `nv5_en_contact_reply`
  MODIFY `rid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_contact_send`
--
ALTER TABLE `nv5_en_contact_send`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_contact_supporter`
--
ALTER TABLE `nv5_en_contact_supporter`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_freecontent_blocks`
--
ALTER TABLE `nv5_en_freecontent_blocks`
  MODIFY `bid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_en_freecontent_rows`
--
ALTER TABLE `nv5_en_freecontent_rows`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `nv5_en_menu`
--
ALTER TABLE `nv5_en_menu`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_en_menu_rows`
--
ALTER TABLE `nv5_en_menu_rows`
  MODIFY `id` mediumint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `nv5_en_modfuncs`
--
ALTER TABLE `nv5_en_modfuncs`
  MODIFY `func_id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `nv5_en_news_1`
--
ALTER TABLE `nv5_en_news_1`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_en_news_2`
--
ALTER TABLE `nv5_en_news_2`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_3`
--
ALTER TABLE `nv5_en_news_3`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_4`
--
ALTER TABLE `nv5_en_news_4`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `nv5_en_news_5`
--
ALTER TABLE `nv5_en_news_5`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_6`
--
ALTER TABLE `nv5_en_news_6`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_7`
--
ALTER TABLE `nv5_en_news_7`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `nv5_en_news_8`
--
ALTER TABLE `nv5_en_news_8`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_en_news_9`
--
ALTER TABLE `nv5_en_news_9`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_10`
--
ALTER TABLE `nv5_en_news_10`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_11`
--
ALTER TABLE `nv5_en_news_11`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_12`
--
ALTER TABLE `nv5_en_news_12`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `nv5_en_news_13`
--
ALTER TABLE `nv5_en_news_13`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_14`
--
ALTER TABLE `nv5_en_news_14`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_en_news_author`
--
ALTER TABLE `nv5_en_news_author`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_en_news_block_cat`
--
ALTER TABLE `nv5_en_news_block_cat`
  MODIFY `bid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_en_news_cat`
--
ALTER TABLE `nv5_en_news_cat`
  MODIFY `catid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `nv5_en_news_logs`
--
ALTER TABLE `nv5_en_news_logs`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_report`
--
ALTER TABLE `nv5_en_news_report`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_rows`
--
ALTER TABLE `nv5_en_news_rows`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `nv5_en_news_row_histories`
--
ALTER TABLE `nv5_en_news_row_histories`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_sources`
--
ALTER TABLE `nv5_en_news_sources`
  MODIFY `sourceid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_en_news_tags`
--
ALTER TABLE `nv5_en_news_tags`
  MODIFY `tid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `nv5_en_news_tmp`
--
ALTER TABLE `nv5_en_news_tmp`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_topics`
--
ALTER TABLE `nv5_en_news_topics`
  MODIFY `topicid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_news_voices`
--
ALTER TABLE `nv5_en_news_voices`
  MODIFY `id` smallint(4) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_page`
--
ALTER TABLE `nv5_en_page`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_en_siteterms`
--
ALTER TABLE `nv5_en_siteterms`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_en_voting`
--
ALTER TABLE `nv5_en_voting`
  MODIFY `vid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_en_voting_rows`
--
ALTER TABLE `nv5_en_voting_rows`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `nv5_extension_files`
--
ALTER TABLE `nv5_extension_files`
  MODIFY `idfile` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_inform`
--
ALTER TABLE `nv5_inform`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_ips`
--
ALTER TABLE `nv5_ips`
  MODIFY `id` mediumint(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_language`
--
ALTER TABLE `nv5_language`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_language_file`
--
ALTER TABLE `nv5_language_file`
  MODIFY `idfile` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_logs`
--
ALTER TABLE `nv5_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `nv5_notification`
--
ALTER TABLE `nv5_notification`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `nv5_plugins`
--
ALTER TABLE `nv5_plugins`
  MODIFY `pid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;

--
-- AUTO_INCREMENT for table `nv5_upload_dir`
--
ALTER TABLE `nv5_upload_dir`
  MODIFY `did` mediumint(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `nv5_users`
--
ALTER TABLE `nv5_users`
  MODIFY `userid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_users_backupcodes`
--
ALTER TABLE `nv5_users_backupcodes`
  MODIFY `userid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_users_field`
--
ALTER TABLE `nv5_users_field`
  MODIFY `fid` mediumint(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `nv5_users_groups`
--
ALTER TABLE `nv5_users_groups`
  MODIFY `group_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `nv5_users_passkey`
--
ALTER TABLE `nv5_users_passkey`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_users_question`
--
ALTER TABLE `nv5_users_question`
  MODIFY `qid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `nv5_users_reg`
--
ALTER TABLE `nv5_users_reg`
  MODIFY `userid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_zalo_article`
--
ALTER TABLE `nv5_zalo_article`
  MODIFY `id` mediumint(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_zalo_template`
--
ALTER TABLE `nv5_zalo_template`
  MODIFY `id` smallint(4) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_zalo_upload`
--
ALTER TABLE `nv5_zalo_upload`
  MODIFY `id` tinyint(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_zalo_video`
--
ALTER TABLE `nv5_zalo_video`
  MODIFY `id` mediumint(8) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
