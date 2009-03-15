-- phpMyAdmin SQL Dump
-- version 3.1.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 28, 2009 at 01:20 AM
-- Server version: 5.1.30
-- PHP Version: 5.2.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `holoserver`
--

--
-- Dumping data for table `system_config`
--

INSERT INTO `system_config` (`id`, `skey`, `sval`) VALUES
(1, 'server_game_port', '21'),
(2, 'server_game_maxconnections', '300'),
(4, 'server_mus_port', '20'),
(5, 'server_mus_maxconnections', '50000'),
(6, 'server_mus_host', '127.0.0.1'),
(3, 'server_game_backlog', '25000'),
(7, 'server_mus_backlog', '5000'),
(8, 'lang', 'en'),
(9, 'welcomemessage_enable', '1'),
(10, 'wordfilter_enable', '1'),
(11, 'wordfilter_censor', 'bobba'),
(12, 'chatanims_enable', '1'),
(13, 'trading_enable', '1'),
(14, 'recycler_enable', '1'),
(15, 'recycler_minownertime', '43200'),
(16, 'recycler_session_length', '60'),
(17, 'recycler_session_expirelength', '10080'),
(18, 'rooms_loadadvertisement_img', 'http://ads.habbohotel.co.uk/max/adview.php?zoneid=325&n=hhuk'),
(19, 'rooms_loadadvertisement_uri', 'http://www.holographemulator.com/'),
(20, 'statuses_wave_duration', '1500'),
(21, 'statuses_carryitem_sipamount', '10'),
(22, 'statuses_carryitem_sipinterval', '9000'),
(23, 'statuses_carryitem_sipduration', '1000'),
(24, 'rooms_roomban_duration', '15'),
(25, 'items_stacking_maxstackheight', '20'),
(28, 'navigator_roomsearch_maxresults', '30'),
(27, 'navigator_createroom_maxrooms', '50'),
(26, 'events_categorycount', '11'),
(29, 'navigator_opencategory_maxresults', '30'),
(30, 'navigator_favourites_maxrooms', '30'),
(31, 'events_deadevents_removeinterval', '120'),
(32, 'soundmachine_burntodisk_disktid', '1355'),
(35, 'game_bb_gamelength_seconds', '180'),
(34, 'game_scorewindow_restartgame_seconds', '1200'),
(33, 'game_countdown_seconds', '15'),
(36, 'spectator_bar_enabled', '0'),
(37, 'max_registered_per_ip', '3'),
(38, 'max_online_per_ip', '10');
