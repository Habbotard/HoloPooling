-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 07, 2019 at 10:23 AM
-- Server version: 10.3.13-MariaDB
-- PHP Version: 7.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `holotdp`
--

-- --------------------------------------------------------

--
-- Table structure for table `catalogue_deals`
--

CREATE TABLE `catalogue_deals` (
  `id` int(10) NOT NULL COMMENT 'The ID of this deal [the part after "deal"]',
  `tid` int(10) NOT NULL COMMENT 'The template ID of the item that should be in this deal',
  `amount` int(10) NOT NULL COMMENT 'The amount, of how many items of the type _TID should be in this deal'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `catalogue_deals`
--

INSERT INTO `catalogue_deals` (`id`, `tid`, `amount`) VALUES
(1, 1, 6),
(1, 419, 3),
(1, 471, 5),
(1, 398, 1);

-- --------------------------------------------------------

--
-- Table structure for table `catalogue_items`
--

CREATE TABLE `catalogue_items` (
  `tid` int(10) NOT NULL COMMENT 'The template ID of this item. Unique',
  `name_cct` varchar(110) COLLATE latin1_general_ci NOT NULL COMMENT 'The CCT name [sprite] of this item',
  `typeid` int(1) NOT NULL COMMENT 'The typeid of this item. 0 = poster/null, 1 = solid, 2 = seat, 3 = bed, 4 = rug',
  `length` int(2) NOT NULL COMMENT 'The length of this item',
  `width` int(2) NOT NULL COMMENT 'The width of this item',
  `top` double(4,2) NOT NULL COMMENT 'The top of this item, used with stacking/sitting [the height of this item]',
  `colour` varchar(100) COLLATE latin1_general_ci NOT NULL COMMENT 'The colour of this item, default = 0,0,0, but HTML colors are useable too',
  `door` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0' COMMENT 'Specifies if this item can be used as door true/false.',
  `tradeable` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '1' COMMENT 'Specifies if this item can be traded between users',
  `recycleable` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '1' COMMENT 'Specifies if this item is allowed to put in the Recycler',
  `catalogue_id_page` int(3) NOT NULL COMMENT 'Specifies the ID of the catalogue page this item is on. -1 = on no page, set this for items that arent''in catalogue but have to be cached [or previous bought instances will appear as PH boxes]',
  `catalogue_id_index` int(5) NOT NULL COMMENT 'The index of this item on _CATALOGUE_ID_PAGE. If this is 1, then it appears as first on the page. Sorted ascending',
  `catalogue_name` varchar(100) COLLATE latin1_general_ci NOT NULL DEFAULT '' COMMENT 'The displayname of this item in the catalogue',
  `catalogue_description` varchar(200) COLLATE latin1_general_ci NOT NULL COMMENT 'The description of this item in the catalogue',
  `catalogue_cost` int(5) NOT NULL COMMENT 'The price of this item in the catalogue'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `catalogue_items`
--

INSERT INTO `catalogue_items` (`tid`, `name_cct`, `typeid`, `length`, `width`, `top`, `colour`, `door`, `tradeable`, `recycleable`, `catalogue_id_page`, `catalogue_id_index`, `catalogue_name`, `catalogue_description`, `catalogue_cost`) VALUES
(1, 'rare_parasol*0', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#94f718', '0', '1', '1', 6, 1, 'Green Parasol', 'Block those rays!', 25),
(2, 'floor', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 2, 'floor', 'Floor', 3),
(3, 'wallpaper 1', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 3, 'wallpaper', 'wallpaper', 3),
(4, 'wallpaper 2', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 4, 'wallpaper', 'wallpaper', 3),
(5, 'wallpaper 3', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 5, 'wallpaper', 'wallpaper', 3),
(6, 'wallpaper 4', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 6, 'wallpaper', 'wallpaper', 3),
(7, 'wallpaper 5', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 7, 'wallpaper', 'wallpaper', 3),
(8, 'wallpaper 6', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 8, 'wallpaper', 'wallpaper', 3),
(9, 'wallpaper 7', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 9, 'wallpaper', 'wallpaper', 3),
(10, 'wallpaper 8', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 10, 'wallpaper', 'wallpaper', 3),
(11, 'wallpaper 9', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 11, 'wallpaper', 'wallpaper', 3),
(12, 'wallpaper 10', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 12, 'wallpaper', 'wallpaper', 3),
(13, 'wallpaper 11', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 13, 'wallpaper', 'wallpaper', 5),
(14, 'wallpaper 12', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 14, 'wallpaper', 'wallpaper', 5),
(15, 'wallpaper 13', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 15, 'wallpaper', 'wallpaper', 5),
(16, 'wallpaper 14', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 16, 'wallpaper', 'wallpaper', 5),
(17, 'wallpaper 15', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 17, 'wallpaper', 'wallpaper', 5),
(18, 'wallpaper 16', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 18, 'wallpaper', 'wallpaper', 5),
(19, 'wallpaper 17', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 19, 'wallpaper', 'wallpaper', 5),
(20, 'wallpaper 18', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 20, 'wallpaper', 'wallpaper', 5),
(21, 'wallpaper 19', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 21, 'wallpaper', 'wallpaper', 5),
(22, 'wallpaper 20', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 22, 'wallpaper', 'wallpaper', 5),
(23, 'wallpaper 21', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 23, 'wallpaper', 'wallpaper', 5),
(24, 'wallpaper 22', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 24, 'wallpaper', 'wallpaper', 5),
(25, 'wallpaper 23', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 25, 'wallpaper', 'wallpaper', 5),
(26, 'wallpaper 24', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 26, 'wallpaper', 'wallpaper', 5),
(27, 'wallpaper 25', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 27, 'wallpaper', 'wallpaper', 5),
(28, 'wallpaper 26', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 28, 'wallpaper', 'wallpaper', 5),
(29, 'wallpaper 27', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 29, 'wallpaper', 'wallpaper', 5),
(30, 'wallpaper 28', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 30, 'wallpaper', 'wallpaper', 5),
(31, 'wallpaper 29', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 31, 'wallpaper', 'wallpaper', 5),
(32, 'wallpaper 30', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 32, 'wallpaper', 'wallpaper', 5),
(33, 'wallpaper 31', 0, 0, 0, 0.00, '0', '0', '0', '0', 7, 33, 'wallpaper', 'wallpaper', 5),
(34, 'nest', 1, 1, 1, 0.00, '0,0,0', '0', '0', '1', 8, 34, 'Basket', 'Night, night', 20),
(35, 'nest', 1, 1, 1, 0.00, '0,0,0', '0', '0', '1', 8, 35, 'Basket', 'Night, night', 20),
(36, 'nest', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 8, 36, 'Basket', 'Night, night', 20),
(37, 'deal97', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 0, 37, 'Doggy Bones', 'Natural nutrition for the barking one', 2),
(38, 'deal98', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 0, 38, 'Sardines', 'Fresh catch of the day', 2),
(39, 'deal99', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 0, 39, 'Cabbage', 'Health food for pets', 2),
(40, 'deal96', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 0, 40, 'T-Bones', 'For the croc!', 2),
(41, 'petfood1', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 9, 41, 'Doggy Bones', 'Natural nutrition for the barking one', 1),
(42, 'petfood2', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 9, 42, 'Sardines', 'Fresh catch of the day', 1),
(43, 'petfood3', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 9, 43, 'Cabbage', 'Health food for pets', 1),
(44, 'petfood4', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 9, 44, 'T-Bones', 'For the croc!', 1),
(45, 'waterbowl*1', 1, 1, 1, 0.00, '#ff3f3f,#ffffff,#ffffff', '0', '1', '1', 9, 45, 'Red Water Bowl', 'Aqua unlimited', 2),
(46, 'waterbowl*2', 1, 1, 1, 0.00, '#3fff3f,#ffffff,#ffffff', '0', '1', '1', 9, 46, 'Green Water Bowl', 'Aqua unlimited', 2),
(47, 'waterbowl*3', 1, 1, 1, 0.00, '#ffff00,#ffffff,#ffffff', '0', '1', '1', 9, 47, 'Yellow Water Bowl', 'Aqua unlimited', 2),
(48, 'waterbowl*4', 1, 1, 1, 0.00, '#0099ff,#ffffff,#ffffff', '0', '1', '1', 9, 48, 'Blue Water Bowl', 'Aqua unlimited', 2),
(49, 'waterbowl*5', 1, 1, 1, 0.00, '#bf7f00,#ffffff,#ffffff', '0', '1', '1', 9, 49, 'Brown Water Bowl', 'Aqua unlimited', 2),
(50, 'goodie2', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 9, 50, 'Chocolate Mouse', 'For gourmet kittens', 1),
(51, 'goodie1', 1, 1, 1, 0.00, '#ff4cbf,#ffffff', '0', '1', '1', 9, 51, 'Marzipan Man', 'Crunchy Dog Treat', 1),
(52, 'goodie1*1', 1, 1, 1, 0.00, '#3fffff,#ffffff', '0', '1', '1', 9, 52, 'Marzipan Man', 'Crunchy Dog Treat', 1),
(53, 'goodie1*2', 1, 1, 1, 0.00, '#ffbf00,#ffffff', '0', '1', '1', 9, 53, 'Marzipan Man', 'Crunchy Dog Treat', 1),
(54, 'toy1', 1, 1, 1, 0.00, '#ff0000,#ffff00,#ffffff,#ffffff', '0', '1', '1', 9, 54, 'Rubber Ball', 'it\'s bouncy-tastic', 2),
(55, 'toy1*1', 1, 1, 1, 0.00, '#ff7f00,#007f00,#ffffff,#ffffff', '0', '1', '1', 9, 55, 'Rubber Ball', 'it\'s bouncy-tastic', 2),
(56, 'toy1*2', 1, 1, 1, 0.00, '#003f7f,#ff00bf,#ffffff,#ffffff', '0', '1', '1', 9, 56, 'Rubber Ball', 'it\'s bouncy-tastic', 2),
(57, 'toy1*3', 1, 1, 1, 0.00, '#bf1900,#00bfbf,#ffffff,#ffffff', '0', '1', '1', 9, 57, 'Rubber Ball', 'it\'s bouncy-tastic', 2),
(58, 'toy1*4', 1, 1, 1, 0.00, '#000000,#ffffff,#ffffff,#ffffff', '0', '1', '1', 9, 58, 'Rubber Ball', 'it\'s bouncy-tastic', 2),
(59, 'silo_studydesk', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 10, 59, 'Area Quest Desk', 'For the true Habbo Scholars', 15),
(60, 'bed_silo_two', 3, 2, 3, 2.00, '0,0,0', '0', '1', '1', 10, 60, 'Double Bed', 'Plain and simple x2', 3),
(61, 'bed_silo_one', 3, 1, 3, 2.00, '0,0,0', '0', '1', '1', 10, 61, 'Single Bed', 'Plain and simple', 3),
(62, 'shelves_silo', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 10, 62, 'Bookcase', 'For nic naks and art deco books', 3),
(63, 'sofa_silo', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#A2C6C8,#A2C6C8,#A2C6C8,#A2C6C8', '0', '1', '1', 10, 63, 'Two-Seater Sofa', 'Cushioned, understated comfort', 3),
(64, 'sofachair_silo', 1, 1, 1, 1.00, '#ffffff,#ffffff,#A2C6C8,#A2C6C8,#ffffff', '0', '1', '1', 10, 64, 'Armchair', 'Large, but worth it', 3),
(65, 'table_silo_small', 1, 1, 1, 1.10, '#ffffff,#A2C6C8,#ffffff,#A2C6C8', '0', '1', '1', 10, 65, 'Occasional Table', 'For those random moments', 1),
(66, 'divider_silo3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#A2C6C8', '1', '1', '1', 10, 66, 'Gate (lockable)', 'Form following function', 6),
(67, 'divider_silo2', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 10, 67, 'Screen', 'Stylish sectioning', 3),
(68, 'divider_silo1', 1, 1, 1, 0.00, '#ffffff,#A2C6C8,0,#A2C6C8', '0', '1', '1', 10, 68, 'Corner Shelf', 'Neat and natty', 3),
(69, 'chair_silo', 2, 1, 1, 1.10, '#ffffff,#ffffff,#A2C6C8,#A2C6C8,#ffffff', '0', '1', '1', 10, 69, 'Dining Chair', 'Keep it simple', 3),
(70, 'safe_silo', 1, 1, 1, 1.20, '#ffffff,#A2C6C8,#ffffff', '0', '1', '1', 10, 70, 'Safe Minibar', 'Totally shatter-proof!', 3),
(71, 'barchair_silo', 1, 1, 1, 0.90, '#ffffff,#A2C6C8,#ffffff', '0', '1', '1', 10, 71, 'Bar Stool', 'Practical and convenient', 3),
(72, 'table_silo_med', 1, 2, 2, 0.90, '#ffffff,#8FAEAF', '0', '1', '1', 10, 72, 'Coffee Table', 'Wipe clean and unobtrusive', 3),
(73, 'tv_luxus', 1, 1, 3, 0.00, '0,0,0', '0', '1', '1', 11, 73, 'Digital TV', 'Bang up to date', 6),
(74, 'wood_tv', 1, 1, 2, 0.00, '0,0,0', '0', '1', '1', 11, 74, 'Large TV', 'For family viewing', 4),
(75, 'red_tv', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 75, 'Portable TV', 'Don\'t miss those soaps', 3),
(76, 'post.it', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 11, 76, 'Pad of stickies', 'Pad of stickies', 3),
(77, 'pizza', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 77, 'Pizza Box', 'You dirty Habbo', 3),
(78, 'drinks', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 78, 'Empty Cans', 'Are you a slob too?', 3),
(79, 'bottle', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 79, 'Empty Spinning Bottle', 'For interesting games!', 3),
(80, 'edice', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 80, 'Holo-dice', 'What\'s your lucky number?', 6),
(81, 'habbocake', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 81, 'Cake', 'Save me a slice!', 4),
(82, 'menorah', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 82, 'Menorah', 'Light up your room', 3),
(83, 'bunny', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 83, 'Squidgy Bunny', 'Yours to cuddle up to', 3),
(84, 'poster 44', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 11, 84, 'Mummy', 'Beware the curse...', 3),
(85, 'wcandleset', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 85, 'White Candle Plate', 'Simple but stylish', 3),
(86, 'rcandleset', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 86, 'Red Candle Plate', 'Simple but stylish', 3),
(87, 'ham', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 87, 'Joint of Ham', 'Tuck in', 3),
(88, 'hockey_light', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 11, 88, 'Lert', 'Set it off.', 5),
(89, 'wall_china', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 12, 89, 'Drakenscherm', 'Voor je eigen Grote Muur', 8),
(90, 'corner_china', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 12, 90, 'Voor Grote Muur', 'Stevig en vuurvast', 8),
(91, 'china_shelve', 2, 2, 1, 0.00, '0,0,0', '0', '1', '1', 12, 91, 'Lakwerk boekenkast', 'Bewaarder van je boekenschat', 8),
(92, 'china_table', 1, 1, 1, 0.90, '0,0,0', '0', '1', '1', 12, 92, 'Yin Yang tafel', 'Exotic and classy', 5),
(93, 'chair_china', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 12, 93, 'Yin Yang stoel', 'Zitten in evenwicht', 5),
(94, 'poster 57', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 12, 94, 'Kalligrafie', 'Een kwast, vaste hand en concentratie', 3),
(95, 'poster 58', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 12, 95, 'Chinese rode knopen', 'Veel geluk!', 5),
(96, 'cn_sofa', 2, 3, 1, 1.00, '0,0,0', '0', '1', '1', 12, 96, 'Yin Yang bank', 'Zitten in evenwicht!', 10),
(97, 'cn_lamp', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 12, 97, 'Rode lantaarn', 'Zacht licht voor je Habbo Kamer', 15),
(98, 'bath', 2, 1, 2, 1.00, '0,0,0', '0', '1', '1', 13, 98, 'Bubble Bath', 'The ultimate in pampering', 6),
(99, 'sink', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 13, 99, 'Sink', 'Hot and cold thrown in for no charge', 3),
(100, 'duck', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 13, 100, 'Rubber Duck', 'Every bather needs one', 1),
(101, 'toilet', 2, 1, 1, 1.10, '0,0,0', '0', '1', '1', 13, 101, 'Loo Seat', 'Loo Seat', 4),
(102, 'toilet_red', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 13, 102, 'Loo Seat', 'Loo Seat', 4),
(103, 'toilet_yell', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 13, 103, 'Loo Seat', 'Loo Seat', 4),
(104, 'tile', 4, 4, 4, 0.00, '0,0,0', '0', '1', '1', 13, 104, 'Floor Tiles', 'In a choice of colours', 3),
(105, 'tile_red', 4, 4, 4, 0.00, '0,0,0', '0', '1', '1', 13, 105, 'Floor Tiles', 'In a choice of colours', 3),
(106, 'tile_yell', 4, 4, 4, 0.00, '0,0,0', '0', '1', '1', 13, 106, 'Floor Tiles', 'In a choice of colours', 3),
(107, 'bardesk_polyfon*5', 1, 2, 1, 1.00, '#ffffff,#ffffff,#FF9BBD,#FF9BBD', '0', '1', '1', 14, 107, 'Candy Bar/desk', 'Perfect for work or play', 3),
(108, 'bardeskcorner_polyfon*5', 1, 1, 1, 1.10, '#ffffff,#FF9BBD', '0', '1', '1', 14, 108, 'Candy Corner', 'Tuck it away', 3),
(109, 'divider_poly3*5', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#EE7EA4,#EE7EA4', '0', '1', '1', 14, 109, 'Candy Hatch (lockable)', 'All bars should have one', 6),
(110, 'sofachair_polyfon_girl', 2, 1, 1, 1.00, '#ffffff,#ffffff,#EE7EA4,#EE7EA4', '0', '1', '1', 14, 110, 'Armchair', 'Think pink', 3),
(111, 'sofa_polyfon_girl', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#EE7EA4,#EE7EA4,#E', '0', '1', '1', 14, 111, 'Two-seater Sofa', 'Romantic pink for two', 4),
(112, 'carpet_polar*1', 4, 2, 3, 0.00, '#ffbbcf,#ffbbcf,#ffddef', '0', '1', '1', 14, 112, 'Pink Faux-Fur', 'Bear Rug Cute', 4),
(113, 'bed_polyfon_girl_one', 3, 1, 3, 2.00, '#ffffff,#ffffff,#ffffff,#EE7EA4,#EE7EA4', '0', '1', '1', 14, 113, 'Armchair', 'Think pink', 3),
(114, 'bed_polyfon_girl', 3, 2, 3, 2.00, '#ffffff,#ffffff,#EE7EA4,#EE7EA4', '0', '1', '1', 14, 114, 'Double Bed', 'Snuggle down in princess pink', 4),
(115, 'camera', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 15, 115, 'Camera', 'Smile!', 10),
(116, 'photo_film', 0, 0, 0, 0.00, '0,0,0', '0', '0', '0', 15, 116, 'Film', 'Film for five photos', 6),
(117, 'poster 500', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 117, 'Union Jack', 'The UK flag', 3),
(118, 'poster 501', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 118, 'Jolly Roger', 'For pirates everywhere', 3),
(119, 'poster 502', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 119, 'The Stars and Stripes', 'The US flag', 3),
(120, 'poster 503', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 120, 'The Swiss flag', 'There\'s no holes in this...', 3),
(121, 'poster 504', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 121, 'The Bundesflagge', 'The German flag', 3),
(122, 'poster 505', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 122, 'The Maple Leaf', 'The Canadian flag', 3),
(123, 'poster 506', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 123, 'The flag of Finland', 'To \'Finnish\' your decor...', 3),
(124, 'poster 507', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 124, 'The French Tricolore', 'The French flag', 3),
(125, 'poster 508', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 125, 'The Spanish flag', 'The flag of Spain', 3),
(126, 'poster 509', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 126, 'The Jamaican flag', 'The flag of Jamaica', 3),
(127, 'poster 510', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 127, 'The Italian flag', 'The flag of Italy', 3),
(128, 'poster 511', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 128, 'The Dutch flag', 'The flag of The Netherlands', 3),
(129, 'poster 512', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 129, 'The Irish flag', 'The flag of Ireland', 3),
(130, 'poster 513', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 130, 'The Australian flag', 'Aussies rule!', 3),
(131, 'poster 514', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 131, 'The EU flag', 'Be proud to be in the Union!', 3),
(132, 'poster 515', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 132, 'The Swedish flag', 'Waved by Swedes everywhere', 3),
(133, 'poster 516', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 133, 'The English flag', 'Eng-er-land', 3),
(134, 'poster 517', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 134, 'The Scottish flag', 'Where\'s your kilt?', 3),
(135, 'poster 518', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 135, 'The Welsh flag', 'A fiery dragon for your wall', 3),
(136, 'poster 520', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 136, 'The Rainbow Flag', 'Every colour for everyone', 3),
(137, 'poster 521', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 137, 'Flag of Brazil', 'The flag of Brazil', 3),
(138, 'poster 522', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 138, 'The flag of Japan', 'The flag of Japan', 3),
(139, 'poster 523', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 16, 139, 'The flag of India', 'The flag of India', 3),
(140, 'poster 2001', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 140, 'Rug on the wall', 'Rug', 10),
(141, 'poster 2004', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 141, 'Rastaman', 'Rasta tarjoaa rakkautta', 3),
(142, 'poster 2002', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 142, 'Presidentin Muotokuva', 'Presidentin Muotokuva', 10),
(143, 'poster 7', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 143, 'Hammer Cabinet', 'for emergencies only', 3),
(144, 'poster 12', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 144, 'Skyline Poster', 'skyscrapers at night', 3),
(145, 'poster 13', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 145, 'BW Skyline Poster', 'skyscrapers in arty black and white', 3),
(146, 'poster 14', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 146, 'Fox Poster', 'a truly cunning design', 3),
(147, 'poster 17', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 147, 'Butterfly Cabinet', 'beautiful reproduction butterfly', 3),
(148, 'poster 18', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 148, 'Butterfly Cabinet (blue)', 'beautiful reproduction butterfly', 3),
(149, 'poster 16', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 149, 'Bars', 'high security for your room', 3),
(150, 'poster 1003', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 150, 'UK Map', 'get the lovely isles on your walls', 3),
(151, 'poster 15', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 151, 'Himalaya Poster', 'marvellous mountains', 3),
(152, 'poster 1006', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 152, 'Hoot Poster', 'The eyes follow you...', 3),
(153, 'poster 32', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 153, 'Siva Poster', 'The Auspicious One', 3),
(154, 'poster 33', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 154, 'Save the Panda', 'We can\'t bear to lose them', 3),
(155, 'poster 2', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 155, 'Carrot Plaque', 'take pride in your veg!', 3),
(156, 'poster 3', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 156, 'Fish Plaque', 'smells fishy, looks cool', 3),
(157, 'poster 4', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 157, 'Bear Plaque', 'fake of course!', 3),
(158, 'poster 5', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 158, 'Duck Poster', 'quacking good design!', 3),
(159, 'poster 1', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 159, 'Ancestor Poster', 'a touch of history', 3),
(160, 'poster 6', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 160, 'Abstract Poster', 'but is it the right way up?', 3),
(161, 'poster 1002', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 161, 'Queen Mum Poster', 'aw, bless...', 3),
(162, 'poster 1001', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 162, 'Prince Charles Poster', 'Even walls have ears', 3),
(163, 'poster 8', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 163, 'Habbo Colours Poster', 'Habbos come in all colours', 3),
(164, 'poster 9', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 164, 'Rainforest Poster', 'do your bit for the environment', 3),
(165, 'poster 1004', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 165, 'Eid Mubarak', 'Celebrate with us', 3),
(166, 'poster 2006', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 166, 'DJ Throne', 'He is the magic Habbo', 3),
(167, 'poster 2008', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 167, 'Green Gecko Art', 'Like a gecko it wont fall of your wall', 3),
(168, 'poster 11', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 168, 'Certificate', 'award, charter or the Habbo Way - you decide', 3),
(169, 'poster 41', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 169, 'Habbo Golden Record', 'For the best music-makers', 3),
(170, 'poster 40', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 170, 'Bonnie Blonde', 'The one and only. Adore her!', 3),
(171, 'poster 35', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 171, 'The Habbo Babes 1', 'The Hotel\'s girlband. Dream on!', 3),
(172, 'poster 36', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 172, 'The Habbo Babes 2', 'The Hotel\'s girlband. Dream on!', 3),
(173, 'poster 37', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 173, 'The Habbo Babes 3', 'The Hotel\'s girlband. Dream on!', 3),
(174, 'poster 1005', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 174, 'Johnny Squabble', 'The muscly movie hero', 3),
(175, 'poster 34', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 175, 'Scamme\'d', 'Habbo-punk for the never-agreeing', 3),
(176, 'poster 39', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 176, 'Screaming Furnies', 'The rock masters of virtual music', 3),
(177, 'poster 2000', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 177, 'Suomen kartta', 'Suomen kartta', 3),
(178, 'poster 38', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 178, 'Smiling Headbangerz', 'For really TOUGH Habbos!', 3),
(179, 'poster 2008', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 179, 'Habbo Cola Poster', 'For serious bubblers', 3),
(180, 'poster 2007', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 180, 'The Father Of Habbo', 'The legendary founder of the Hotel', 3),
(181, 'poster 2003', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 181, 'Dodgy Geezer', 'Would you trust this man?', 3),
(182, 'poster 31', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 182, 'System of a Ban', 'Pure and unbridled nu-metal', 3),
(183, 'poster 55', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 17, 183, 'Beach Tree Poster', 'Natural', 3),
(184, 'glass_shelf', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 18, 184, 'Glass shelf', 'Translucent beauty', 4),
(185, 'glass_sofa', 2, 2, 1, 1.10, '#ffffff,#ABD0D2,#ABD0D2,#ffffff,#ffffff,#ABD0D2,#ffffff,#ABD0D2', '0', '1', '1', 18, 185, 'Glass sofa', 'Translucent beauty', 4),
(186, 'glass_table', 1, 2, 2, 0.90, '#ffffff,#ABD0D2,#ABD0D2,#ffffff', '0', '1', '1', 18, 186, 'Glass table', 'Translucent beauty', 4),
(187, 'glass_chair', 2, 1, 1, 1.10, '#ffffff,#ABD0D2,#ABD0D2,#ffffff', '0', '1', '1', 18, 187, 'Glass chair', 'Translucent beauty', 3),
(188, 'glass_stool', 2, 1, 1, 1.10, '#ffffff,#ABD0D2,#ABD0D2,#ffffff', '0', '1', '1', 18, 188, 'Glass stool', 'Translucent beauty', 3),
(189, 'glass_sofa*2', 2, 2, 1, 1.10, '#ffffff,#525252,#525252,#ffffff,#ffffff,#525252,#ffffff,#525252', '0', '1', '1', 18, 189, 'Glass sofa', 'Translucent beauty', 4),
(190, 'glass_table*2', 1, 2, 2, 0.90, '#ffffff,#525252,#525252,#ffffff', '0', '1', '1', 18, 190, 'Glass table', 'Translucent beauty', 4),
(191, 'glass_chair*2', 2, 1, 1, 1.10, '#ffffff,#525252,#525252,#ffffff', '0', '1', '1', 18, 191, 'Glass chair', 'Translucent beauty', 3),
(192, 'glass_stool*2', 2, 1, 1, 1.10, '#ffffff,#525252,#525252,#ffffff', '0', '1', '1', 18, 192, 'Glass stool', 'Translucent beauty', 3),
(193, 'glass_sofa*3', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 18, 193, 'Glass sofa', 'Translucent beauty', 4),
(194, 'glass_table*3', 1, 2, 2, 0.90, '#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 18, 194, 'Glass table', 'Translucent beauty', 4),
(195, 'glass_chair*3', 2, 1, 1, 1.00, '#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 18, 195, 'Glass chair', 'Translucent beauty', 3),
(196, 'glass_stool*3', 2, 1, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 18, 196, 'Glass stool', 'Translucent beauty', 3),
(197, 'glass_sofa*4', 2, 2, 1, 1.10, '#ffffff,#F7EBBC,#F7EBBC,#ffffff,#ffffff,#F7EBBC,#ffffff,#F7EBBC', '0', '1', '1', 18, 197, 'Glass sofa', 'Translucent beauty', 4),
(198, 'glass_table*4', 1, 2, 2, 0.90, '#ffffff,#F7EBBC,#F7EBBC,#ffffff', '0', '1', '1', 18, 198, 'Glass table', 'Translucent beauty', 4),
(199, 'glass_chair*4', 2, 1, 1, 1.10, '#ffffff,#F7EBBC,#F7EBBC,#ffffff', '0', '1', '1', 18, 199, 'Glass chair', 'Translucent beauty', 3),
(200, 'glass_stool*4', 2, 1, 1, 1.10, '#ffffff,#F7EBBC,#F7EBBC,#ffffff', '0', '1', '1', 18, 200, 'Glass stool', 'Translucent beauty', 3),
(201, 'glass_sofa*5', 2, 2, 1, 1.10, '#ffffff,#FF99BC,#FF99BC,#ffffff,#ffffff,#FF99BC,#ffffff,#FF99BC', '0', '1', '1', 18, 201, 'Glass sofa', 'Translucent beauty', 4),
(202, 'glass_table*5', 1, 2, 2, 0.90, '#ffffff,#FF99BC,#FF99BC,#ffffff', '0', '1', '1', 18, 202, 'Glass table', 'Translucent beauty', 4),
(203, 'glass_chair*5', 2, 1, 1, 1.10, '#ffffff,#FF99BC,#FF99BC,#ffffff', '0', '1', '1', 18, 203, 'Glass chair', 'Translucent beauty', 3),
(204, 'glass_stool*5', 2, 1, 1, 1.10, '#ffffff,#FF99BC,#FF99BC,#ffffff', '0', '1', '1', 18, 204, 'Glass stool', 'Translucent beauty', 3),
(205, 'glass_sofa*6', 2, 2, 1, 1.10, '#ffffff,#5EAAF8,#5EAAF8,#ffffff,#ffffff,#5EAAF8,#ffffff,#5EAAF8', '0', '1', '1', 18, 205, 'Glass sofa', 'Translucent beauty', 4),
(206, 'glass_table*6', 1, 2, 2, 0.90, '#ffffff,#5EAAF8,#5EAAF8,#ffffff', '0', '1', '1', 18, 206, 'Glass table', 'Translucent beauty', 4),
(207, 'glass_chair*6', 2, 1, 1, 1.10, '#ffffff,#5EAAF8,#5EAAF8,#ffffff', '0', '1', '1', 18, 207, 'Glass chair', 'Translucent beauty', 3),
(208, 'glass_stool*6', 2, 1, 1, 1.10, '#ffffff,#5EAAF8,#5EAAF8,#ffffff', '0', '1', '1', 18, 208, 'Glass stool', 'Translucent beauty', 3),
(209, 'glass_sofa*7', 2, 2, 1, 1.10, '#ffffff,#92D13D,#92D13D,#ffffff,#ffffff,#92D13D,#ffffff,#92D13D', '0', '1', '1', 18, 209, 'Glass sofa', 'Translucent beauty', 4),
(210, 'glass_table*7', 1, 2, 2, 0.90, '#ffffff,#92D13D,#92D13D,#ffffff', '0', '1', '1', 18, 210, 'Glass table', 'Translucent beauty', 4),
(211, 'glass_chair*7', 2, 1, 1, 1.10, '#ffffff,#92D13D,#92D13D,#ffffff', '0', '1', '1', 18, 211, 'Glass chair', 'Translucent beauty', 3),
(212, 'glass_stool*7', 2, 1, 1, 1.10, '#ffffff,#92D13D,#92D13D,#ffffff', '0', '1', '1', 18, 212, 'Glass stool', 'Translucent beauty', 3),
(213, 'glass_sofa*8', 2, 2, 1, 1.10, '#ffffff,#FFD837,#FFD837,#ffffff,#ffffff,#FFD837,#ffffff,#FFD837', '0', '1', '1', 18, 213, 'Glass sofa', 'Translucent beauty', 4),
(214, 'glass_table*8', 1, 2, 2, 0.90, '#ffffff,#FFD837,#FFD837,#ffffff', '0', '1', '1', 18, 214, 'Glass table', 'Translucent beauty', 4),
(215, 'glass_chair*8', 2, 1, 1, 1.10, '#ffffff,#FFD837,#FFD837,#ffffff', '0', '1', '1', 18, 215, 'Glass chair', 'Translucent beauty', 3),
(216, 'glass_stool*8', 2, 1, 1, 1.10, '#ffffff,#FFD837,#FFD837,#ffffff', '0', '1', '1', 18, 216, 'Glass stool', 'Translucent beauty', 3),
(217, 'glass_sofa*9', 2, 2, 1, 1.10, '#ffffff,#E14218,#E14218,#ffffff,#ffffff,#E14218,#ffffff,#E14218', '0', '1', '1', 18, 217, 'Glass sofa', 'Translucent beauty', 4),
(218, 'glass_table*9', 1, 2, 2, 0.90, '#ffffff,#E14218,#E14218,#ffffff', '0', '1', '1', 18, 218, 'Glass table', 'Translucent beauty', 4),
(219, 'glass_chair*9', 2, 1, 1, 1.10, '#ffffff,#E14218,#E14218,#ffffff', '0', '1', '1', 18, 219, 'Glass chair', 'Translucent beauty', 3),
(220, 'glass_stool*9', 2, 1, 1, 1.10, '#ffffff,#E14218,#E14218,#ffffff', '0', '1', '1', 18, 220, 'Glass stool', 'Translucent beauty', 3),
(221, 'gothic_chair*3', 2, 1, 1, 1.10, '#ffffff,#dd0000,#ffffff,#dd0000', '0', '1', '1', 19, 221, 'Red Gothic Chair', 'The head of the table', 10),
(222, 'gothic_sofa*3', 2, 2, 1, 1.10, '#ffffff,#dd0000,#ffffff,#ffffff,#dd0000,#ffffff', '0', '1', '1', 19, 222, 'Red Gothic Sofa', 'Not great for hiding behind', 7),
(223, 'gothic_stool*3', 1, 1, 1, 1.10, '#ffffff,#dd0000,#ffffff', '0', '1', '1', 19, 223, 'Red Gothic Stool', 'Be calm. Be seated', 5),
(224, 'gothic_carpet', 4, 2, 4, 0.00, '0,0,0', '0', '1', '1', 19, 224, 'Cobbled Path', 'The route less travelled', 5),
(225, 'gothic_carpet2', 4, 2, 4, 0.00, '0,0,0', '0', '1', '1', 19, 225, 'Dungeon Floor', 'What lies beneath?', 5),
(226, 'goth_table', 1, 1, 5, 1.00, '0,0,0', '0', '1', '1', 19, 226, 'Gothic Table', 'A table with two heads', 15),
(227, 'gothrailing', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 19, 227, 'Gothic Railing', 'Keep out!', 8),
(228, 'torch', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 19, 228, 'Gothic Torch', 'Keeping dungeons light', 10),
(229, 'gothicfountain', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 19, 229, 'Gothic Fountain', 'The dark side of Habbo', 10),
(230, 'gothiccandelabra', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 19, 230, 'Gothic Candleabra', 'Through darkness came light', 10),
(231, 'gothgate', 1, 2, 1, 0.00, '0,0,0', '1', '1', '1', 19, 231, 'Gothic Portcullis', 'Don\'t get caught beneath!', 10),
(232, 'industrialfan', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 19, 232, 'Industrial Turbine', 'Powerful and resilient', 10),
(233, 'grunge_barrel', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 20, 233, 'Flaming Barrel', 'Beacon of light!', 3),
(234, 'grunge_bench', 2, 3, 1, 1.10, '0,0,0', '0', '1', '1', 20, 234, 'Bench', 'Laid back seating', 3),
(235, 'grunge_candle', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 20, 235, 'Candle Box', 'Late night debate', 2),
(236, 'grunge_chair', 2, 1, 1, 1.10, '0,0,0', '0', '1', '1', 20, 236, 'Grunge Chair', 'Alternative chair for alternative people', 4),
(237, 'grunge_mattress', 2, 3, 1, 0.80, '0,0,0', '0', '1', '1', 20, 237, 'Grunge Mattress', 'Beats sleeping on the floor!', 3),
(238, 'grunge_radiator', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 20, 238, 'Radiator', 'Started cool but now it\'s hot!', 3),
(239, 'grunge_shelf', 1, 3, 1, 0.00, '0,0,0', '0', '1', '1', 20, 239, 'Grunge Bookshelf', 'Scrap books and photo albums', 5),
(240, 'grunge_sign', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 20, 240, 'Road Sign', 'Bought legitimately from an M1 cafe.', 3),
(241, 'grunge_table', 1, 2, 2, 1.00, '0,0,0', '0', '1', '1', 20, 241, 'Grunge Table', 'Students of the round table!', 4),
(242, 'CF_1_coin_bronze', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 21, 242, 'Bronze Coin', 'Worth: 1 Habbo Credit', 1),
(243, 'CF_5_coin_silver', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 21, 243, 'Silver Coin', 'Worth: 5 Habbo Credits', 5),
(244, 'CF_10_coin_gold', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 21, 244, 'Gold Coin', 'Worth: 10 Habbo Credits', 10),
(245, 'CF_20_moneybag', 1, 1, 1, 1.00, '0,0,0', '0', '1', '1', 21, 245, 'Money Bag', 'Worth: 20 Habbo Credits', 20),
(246, 'CF_50_goldbar', 1, 1, 1, 0.60, '0,0,0', '0', '1', '1', 21, 246, 'Gold Bars', 'Worth: 50 Habbo Credits', 50),
(247, 'habbowood_chair', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 22, 247, 'Habbowood Chair', 'null', 5),
(248, 'rope_divider', 1, 2, 1, 0.00, '0,0,0', '1', '1', '1', 22, 248, 'Rope Divider', 'null', 5),
(249, 'spotlight', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 22, 249, 'Spotlight', 'Light, camera, action!', 15),
(250, 'theatre_seat', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 22, 250, 'Theatre Seat', 'It\'s a Theatre Seat', 10),
(251, 'rare_icecream_campaign', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 22, 251, 'Icecream Machine', 'null', 25),
(252, 'habw_mirror', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 22, 252, 'Habbowood Mirror', 'Starts only!', 10),
(253, 'chair_norja', 2, 1, 1, 1.00, '#ffffff,#ffffff,#F7EBBC,#F7EBBC', '0', '1', '1', 23, 253, 'Chair', 'Sleek and chic for each cheek', 3),
(254, 'couch_norja', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#F7EBBC,#F7EBBC,#F7EBBC,#F7EBBC', '0', '1', '1', 23, 254, 'Bench', 'Two can perch comfortably', 3),
(255, 'table_norja_med', 1, 2, 2, 0.90, '#ffffff,#F7EBBC', '0', '1', '1', 23, 255, 'Coffee Table', 'Elegance embodied', 3),
(256, 'shelves_norja', 1, 1, 1, 0.00, '#ffffff,#F7EBBC', '0', '1', '1', 23, 256, 'Bookcase', 'For nic naks and art deco books', 3),
(257, 'soft_sofachair_norja', 2, 1, 1, 1.00, '#ffffff,#F7EBBC,#F7EBBC', '0', '1', '1', 23, 257, 'iced sofachair', 'Soft iced sofachair', 3),
(258, 'soft_sofa_norja', 2, 2, 1, 1.00, '#ffffff,#F7EBBC,#ffffff,#F7EBBC,#F7EBBC,#F7EBBC', '0', '1', '1', 23, 258, 'iced sofa', 'A soft iced sofa', 4),
(259, 'divider_nor2', 1, 2, 1, 0.00, '#ffffff,#ffffff,#F7EBBC,#F7EBBC', '0', '1', '1', 23, 259, 'Ice Bar-Desk', 'Strong, yet soft looking', 3),
(260, 'divider_nor1', 1, 1, 1, 0.00, '#ffffff,#F7EBBC', '0', '1', '1', 23, 260, 'Ice Corner', 'Looks squishy, but isn\'t', 3),
(261, 'divider_nor3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#F7EBBC,#F7EBBC', '1', '1', '1', 23, 261, 'Door (Lockable)', 'Do go through...', 6),
(262, 'divider_nor4', 1, 2, 1, 0.00, '#ffffff,#ffffff,#F7EBBC,#F7EBBC,#F7EBBC,#F7EBBC', '1', '1', '1', 23, 262, 'Iced Auto Shutter', 'Habbos, roll out!', 3),
(263, 'divider_nor5', 1, 1, 1, 0.00, '#ffffff,#F7EBBC,#F7EBBC,#F7EBBC,#F7EBBC,#F7EBBC', '1', '1', '1', 23, 263, 'Iced Angle', 'Cool cornering for you!', 3),
(264, 'jp_bamboo', 4, 2, 2, 0.00, '0,0,0', '0', '1', '1', 24, 264, 'Bamboo Forest', 'Don\'t get lost', 25),
(265, 'jp_pillow', 2, 1, 1, 0.70, '0,0,0', '0', '1', '1', 24, 265, 'Pillow', 'null', 5),
(266, 'jp_irori', 1, 2, 2, 0.00, '0,0,0', '0', '1', '1', 24, 266, 'Sushi Bar', 'null', 10),
(267, 'jp_tatami', 4, 2, 2, 0.00, '0,0,0', '0', '1', '1', 24, 267, 'Tatami', 'null', 6),
(268, 'jp_tatami2', 4, 2, 4, 0.00, '0,0,0', '0', '1', '1', 24, 268, 'Tatami', 'null', 8),
(269, 'jp_lantern', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 24, 269, 'Lantern', 'null', 10),
(270, 'jp_drawer', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 24, 270, 'Drawers', 'null', 6),
(271, 'jp_ninjastars', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 24, 271, 'Ninjastars', 'Ouch!', 10),
(272, 'bed_armas_two', 3, 2, 3, 2.00, '0,0,0', '0', '1', '1', 25, 272, 'Double Bed', 'King-sized pine comfort', 3),
(273, 'bed_armas_one', 3, 1, 3, 2.00, '0,0,0', '0', '1', '1', 25, 273, 'Single Bed', 'Rustic charm for one', 3),
(274, 'fireplace_armas', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 25, 274, 'Fireplace', 'Authentic, real flame fire', 4),
(275, 'bartable_armas', 1, 1, 3, 1.20, '0,0,0', '0', '1', '1', 25, 275, 'Bardesk', 'Bar-Style Table - essential for extra guests', 3),
(276, 'table_armas', 1, 2, 2, 1.00, '0,0,0', '0', '1', '1', 25, 276, 'Dining Table', 'For informal dining', 3),
(277, 'bench_armas', 2, 2, 1, 1.10, '0,0,0', '0', '1', '1', 25, 277, 'Bench', 'To complete the dining set', 3),
(278, 'divider_arm3', 1, 1, 1, 0.00, '0,0,0', '1', '1', '1', 25, 278, 'Gate (lockable)', 'Knock, knock...', 6),
(279, 'divider_arm1', 1, 1, 1, 1.20, '0,0,0', '0', '1', '1', 25, 279, 'Corner plinth', 'Good solid wood', 3),
(280, 'divider_arm2', 1, 2, 1, 1.20, '0,0,0', '0', '1', '1', 25, 280, 'Room divider', 'I wooden go there', 3),
(281, 'shelves_armas', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 25, 281, 'Bookcase', 'For all those fire-side stories', 3),
(282, 'bar_armas', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 25, 282, 'Barrel Minibar', 'It\'s a barrel of laughs and a great talking point', 4),
(283, 'bar_chair_armas', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 25, 283, 'Barrel Stool', 'The ultimate recycled furniture', 1),
(284, 'lamp_armas', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 25, 284, 'Table Lamp', 'Ambient lighting is essential', 3),
(285, 'lamp2_armas', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 25, 285, 'Lodge Candle', 'Wax lyrical with some old-world charm', 3),
(286, 'small_table_armas', 1, 1, 1, 1.10, '0,0,0', '0', '1', '1', 25, 286, 'Occasional Table', 'Practical and beautiful', 2),
(287, 'small_chair_armas', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 25, 287, 'Stool', 'Rustic charm at it\'s best', 1),
(288, 'bed_polyfon', 3, 2, 3, 2.00, '#ffffff,#ffffff,#ABD0D2,#ABD0D2', '0', '1', '1', 26, 288, 'Double Bed', 'Give yourself space to stretch out', 4),
(289, 'bed_polyfon_one', 3, 1, 3, 2.00, 'ffffff,#ffffff,#ffffff,#ABD0D2,#ABD0D2', '0', '1', '1', 26, 289, 'Single Bed', 'Cot of the artistic', 3),
(290, 'fireplace_polyfon', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 26, 290, 'Fireplace', 'Comfort in stainless steel', 5),
(291, 'sofa_polyfon', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#ABD0D2,#ABD0D2,#ABD0D2,#ABD0D2', '0', '1', '1', 26, 291, 'Two-seater Sofa', 'Comfort for stylish couples', 4),
(292, 'sofachair_polyfon', 2, 1, 1, 1.00, '#ffffff,#ffffff,#ABD0D2,#ABD0D2', '0', '1', '1', 26, 292, 'Armchair', 'Loft-style comfort', 3),
(293, 'bar_polyfon', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 26, 293, 'Mini-Bar', 'You naughty Habbo!', 5),
(294, 'divider_poly3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#ABD0D2,#ABD0D2', '1', '1', '1', 26, 294, 'Hatch (Lockable)', 'All bars should have one', 6),
(295, 'bardesk_polyfon', 1, 2, 1, 1.00, '#ffffff,#ffffff,#ABD0D2,#ABD0D2', '0', '1', '1', 26, 295, 'Bar/desk', 'Perfect for work or play', 3),
(296, 'bardeskcorner_polyfon', 1, 1, 1, 0.00, '#ffffff,#ABD0D2', '0', '1', '1', 26, 296, 'Corner Cabinet/Desk', 'Tuck it away', 3),
(297, 'chair_polyfon', 2, 1, 1, 1.10, '0,0,0', '0', '1', '1', 26, 297, 'Dining Chair', 'Metallic seating experience', 3),
(298, 'table_polyfon', 1, 2, 2, 0.80, '0,0,0', '0', '1', '1', 26, 298, 'Large Coffee Table', 'For larger gatherings', 4),
(299, 'table_polyfon_med', 1, 2, 2, 1.00, '0,0,0', '0', '1', '1', 26, 299, 'Large Coffee Table', 'For larger gatherings', 3),
(300, 'table_polyfon_small', 1, 2, 2, 0.90, '0,0,0', '0', '1', '1', 26, 300, 'Small Coffee Table', 'For serving a stylish latte', 1),
(301, 'smooth_table_polyfon', 1, 2, 2, 0.90, '0,0,0', '0', '1', '1', 26, 301, 'Large Dining Table', 'For larger gatherings', 4),
(302, 'stand_polyfon_z', 1, 1, 1, 0.70, '0,0,0', '0', '1', '1', 26, 302, 'Shelf', 'Tidy up', 1),
(303, 'shelves_polyfon', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 26, 303, 'Bookcase', 'For the arty pad', 4),
(304, 'present_gen1', 1, 1, 1, 1.00, '0,0,0', '0', '0', '0', -1, 0, '', '', 0),
(305, 'present_gen2', 1, 1, 1, 1.00, '0,0,0', '0', '0', '0', -1, 0, '', '', 0),
(306, 'present_gen3', 1, 1, 1, 1.00, '0,0,0', '0', '0', '0', -1, 0, '', '', 0),
(307, 'present_gen4', 1, 1, 1, 1.00, '0,0,0', '0', '0', '0', -1, 0, '', '', 0),
(308, 'present_gen5', 1, 1, 1, 1.00, '0,0,0', '0', '0', '0', -1, 0, '', '', 0),
(309, 'present_gen6', 1, 1, 1, 1.00, '0,0,0', '0', '0', '0', -1, 0, '', '', 0),
(313, 'giftflowers', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 313, 'Vase of Flowers', 'Guaranteed to stay fresh', 4),
(314, 'plant_rose', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 314, 'Cut Roses', 'Sleek and chic', 3),
(315, 'plant_sunflower', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 315, 'Cut Sunflower', 'For happy Habbos', 3),
(316, 'plant_yukka', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 316, 'Yukka Plant', 'Easy to care for', 3),
(317, 'plant_pineapple', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 317, 'Pineapple Plant', 'Needs loving glances', 3),
(318, 'plant_bonsai', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 318, 'Bonsai Tree', 'You can be sure it lives', 3),
(319, 'plant_big_cactus', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 319, 'Mature Cactus', 'Habbo Dreams monster in hiding!  Shhhh', 3),
(320, 'plant_fruittree', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 320, 'Fruit Tree', 'Great yield and sweet fruit', 3),
(321, 'plant_small_cactus', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 321, 'Small Cactus', 'Even less watering than the real world', 1),
(322, 'plant_maze', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 28, 322, 'Maze shrubbery', 'Labyrinths Galore!', 5),
(323, 'plant_mazegate', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 28, 323, 'Maze Shrubbery Gate', 'Labyrinths Galore!', 6),
(324, 'plant_bulrush', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 28, 324, 'Bulrush', 'Ideal for the riverside', 3),
(325, 'chair_plasto*16', 2, 1, 1, 1.00, '#ffffff,#CC3399,#ffffff,#CC3399', '0', '1', '1', 29, 325, 'Chair', 'Hip plastic furniture', 3),
(326, 'chair_plasto*15', 2, 1, 1, 1.00, '#ffffff,#FF97BA,#ffffff,#FF97BA', '0', '1', '1', 29, 326, 'Chair', 'Hip plastic furniture', 3),
(327, 'chair_plasto*5', 2, 1, 1, 1.00, '#ffffff,#54ca00,#ffffff,#54ca00', '0', '1', '1', 29, 327, 'Chair', 'Hip plastic furniture', 3),
(328, 'chair_plasto', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 29, 328, 'Chair', 'Hip plastic furniture', 3),
(329, 'chair_plasto*8', 2, 1, 1, 1.00, '#ffffff,#c38d1a,#ffffff,#c38d1a', '0', '1', '1', 29, 329, 'Chair', 'Hip plastic furniture', 3),
(330, 'chair_plasto*7', 2, 1, 1, 1.00, '#ffffff,#ff6d00,#ffffff,#ff6d00', '0', '1', '1', 29, 330, 'Chair', 'Hip plastic furniture', 3),
(331, 'chair_plasto*1', 2, 1, 1, 1.00, '#ffffff,#ff1f08,#ffffff,#ff1f08', '0', '1', '1', 29, 331, 'Chair', 'Hip plastic furniture', 3),
(332, 'chair_plasto*4', 2, 1, 1, 1.00, '#ffffff,#ccddff,#ffffff,#ccddff', '0', '1', '1', 29, 332, 'Chair', 'Hip plastic furniture', 3),
(333, 'chair_plasto*6', 2, 1, 1, 1.00, '#ffffff,#3444ff,#ffffff,#3444ff', '0', '1', '1', 29, 333, 'Chair', 'Hip plastic furniture', 3),
(334, 'chair_plasto*3', 2, 1, 1, 1.00, '#ffffff,#ffee00,#ffffff,#ffee00', '0', '1', '1', 29, 334, 'Chair', 'Hip plastic furniture', 3),
(335, 'chair_plasto*2', 2, 1, 1, 1.00, '#ffffff,#99DCCC,#ffffff,#99DCCc', '0', '1', '1', 29, 335, 'Chair', 'Hip plastic furniture', 3),
(336, 'table_plasto_square*15', 1, 1, 1, 1.10, '#ffffff,#FF97BA', '0', '1', '1', 29, 336, 'Occasional Table', 'Hip plastic furniture', 3),
(337, 'table_plasto_square*14', 1, 1, 1, 1.10, '#ffffff,#CC3399', '0', '1', '1', 29, 337, 'Occasional Table', 'Hip plastic furniture', 3),
(338, 'table_plasto_square*1', 1, 1, 1, 1.10, '#ffffff,#ff1f08', '0', '1', '1', 29, 338, 'Occasional Table', 'Hip plastic furniture', 3),
(339, 'table_plasto_square*7', 1, 1, 1, 1.10, '#ffffff,#ff6d00', '0', '1', '1', 29, 339, 'Square Dining Table', 'Hip plastic furniture', 3),
(340, 'table_plasto_square', 1, 1, 1, 1.10, '0,0,0', '0', '1', '1', 29, 340, 'Occasional Table', 'Hip plastic furniture', 3),
(341, 'table_plasto_square*2', 1, 1, 1, 1.10, '#ffffff,#99DCCC', '0', '1', '1', 29, 341, 'Round Dining Table', 'Hip plastic furniture', 3),
(342, 'table_plasto_square*4', 1, 1, 1, 1.10, '#ffffff,#ccddff', '0', '1', '1', 29, 342, 'Square Dining Table', 'Hip plastic furniture', 3),
(343, 'table_plasto_square*6', 1, 1, 1, 1.10, '#ffffff,#3444ff', '0', '1', '1', 29, 343, 'Square Dining Table', 'Hip plastic furniture', 3),
(344, 'table_plasto_square*3', 1, 1, 1, 1.10, '#ffffff,#ffee00', '0', '1', '1', 29, 344, 'Square Dining Table', 'Hip plastic furniture', 3),
(345, 'table_plasto_square*9', 1, 1, 1, 1.10, '#ffffff,#533e10', '0', '1', '1', 29, 345, 'Square Dining Table', 'Hip plastic furniture', 3),
(346, 'table_plasto_square*5', 1, 1, 1, 1.10, '#ffffff,#54ca00', '0', '1', '1', 29, 346, 'Square Dining Table', 'Hip plastic furniture', 3),
(347, 'table_plasto_square*8', 1, 1, 1, 1.10, '#ffffff,#c38d1a', '0', '1', '1', 29, 347, 'Square Dining Table', 'Hip plastic furniture', 3),
(348, 'table_plasto_round*15', 1, 2, 2, 1.10, '#ffffff,#FF97BA', '0', '1', '1', 29, 348, 'Occasional Table', 'Hip plastic furniture', 3),
(349, 'table_plasto_round*14', 1, 2, 2, 1.10, '#ffffff,#CC3399', '0', '1', '1', 29, 349, 'Occasional Table', 'Hip plastic furniture', 3),
(350, 'table_plasto_round*7', 1, 2, 2, 1.10, '#ffffff,#ff6d00', '0', '1', '1', 29, 350, 'Round Dining Table', 'Hip plastic furniture', 3),
(351, 'table_plasto_round*1', 1, 2, 2, 1.10, '#ffffff,#ff1f08', '0', '1', '1', 29, 351, 'Round Dining Table', 'Hip plastic furniture', 3),
(352, 'table_plasto_round*2', 1, 2, 2, 1.10, '#ffffff,#99DCCC', '0', '1', '1', 29, 352, 'Round Dining Table', 'Hip plastic furniture', 3),
(353, 'table_plasto_round*4', 1, 2, 2, 1.10, '#ffffff,#ccddff', '0', '1', '1', 29, 353, 'Square Dining Table', 'Hip plastic furniture', 3),
(354, 'table_plasto_round*6', 1, 2, 2, 1.10, '#ffffff,#3444ff', '0', '1', '1', 29, 354, 'Round Dining Table', 'Hip plastic furniture', 3),
(355, 'table_plasto_round*3', 1, 2, 2, 1.10, '#ffffff,#ffee00', '0', '1', '1', 29, 355, 'Round Dining Table', 'Hip plastic furniture', 3),
(356, 'table_plasto_round*9', 1, 2, 2, 1.10, '#ffffff,#533e10', '0', '1', '1', 29, 356, 'Round Dining Table', 'Hip plastic furniture', 3),
(357, 'table_plasto_round', 1, 2, 2, 1.10, '0,0,0', '0', '1', '1', 29, 357, 'Round Dining Table', 'Hip plastic furniture', 3),
(358, 'table_plasto_round*5', 1, 2, 2, 1.10, '#ffffff,#54ca00', '0', '1', '1', 29, 358, 'Round Dining Table', 'Hip plastic furniture', 3),
(359, 'table_plasto_round*8', 1, 2, 2, 1.10, '#ffffff,#c38d1a', '0', '1', '1', 29, 359, 'Round Dining Table', 'Hip plastic furniture', 3),
(360, 'table_plasto_bigsquare*15', 1, 2, 2, 1.10, '#ffffff,#FF97BA', '0', '1', '1', 29, 360, 'Occasional Table', 'Hip plastic furniture', 3),
(361, 'table_plasto_bigsquare*14', 1, 2, 2, 1.10, '#ffffff,#CC3399', '0', '1', '1', 29, 361, 'Occasional Table', 'Hip plastic furniture', 3),
(362, 'table_plasto_bigsquare*7', 1, 2, 2, 1.10, '#ffffff,#ff6d00', '0', '1', '1', 29, 362, 'Square Dining Table', 'Hip plastic furniture', 3),
(363, 'table_plasto_bigsquare*1', 1, 2, 2, 1.10, '#ffffff,#ff1f08', '0', '1', '1', 29, 363, 'Square Dining Table', 'Hip plastic furniture', 3),
(364, 'table_plasto_bigsquare*2', 1, 2, 2, 1.10, '#ffffff,#99DCCC', '0', '1', '1', 29, 364, 'Square Dining Table', 'Hip plastic furniture', 3),
(365, 'table_plasto_bigsquare', 1, 2, 2, 1.10, '0,0,0', '0', '1', '1', 29, 365, 'Square Dining Table', 'Hip plastic furniture', 3),
(366, 'table_plasto_bigsquare*8', 1, 2, 2, 1.10, '#ffffff,#c38d1a', '0', '1', '1', 29, 366, 'Square Dining Table', 'Hip plastic furniture', 3),
(367, 'table_plasto_bigsquare*5', 1, 2, 2, 1.10, '#ffffff,#54ca00', '0', '1', '1', 29, 367, 'Square Dining Table', 'Hip plastic furniture', 3),
(368, 'table_plasto_bigsquare*9', 1, 2, 2, 1.10, '#ffffff,#533e10', '0', '1', '1', 29, 368, 'Square Dining Table', 'Hip plastic furniture', 3),
(369, 'table_plasto_bigsquare*3', 1, 2, 2, 1.10, '#ffffff,#ffee00', '0', '1', '1', 29, 369, 'Square Dining Table', 'Hip plastic furniture', 3),
(370, 'table_plasto_bigsquare*6', 1, 2, 2, 1.10, '#ffffff,#3444ff', '0', '1', '1', 29, 370, 'Square Dining Table', 'Hip plastic furniture', 3),
(371, 'table_plasto_bigsquare*4', 1, 2, 2, 1.10, '#ffffff,#ccddff', '0', '1', '1', 29, 371, 'Square Dining Table', 'Hip plastic furniture', 3),
(372, 'table_plasto_4leg*6', 1, 2, 2, 1.10, '#ffffff,#3444ff', '0', '1', '1', 29, 372, 'Occasional table Table', 'Hip plastic furniture', 3),
(373, 'table_plasto_4leg*1', 1, 2, 2, 1.10, '#ffffff,#ff1f08', '0', '1', '1', 29, 373, 'Square Dining Table', 'Hip plastic furniture', 3),
(374, 'table_plasto_4leg*3', 1, 2, 2, 1.10, '#ffffff,#ffee00', '0', '1', '1', 29, 374, 'Round Dining Table', 'Hip plastic furniture', 3),
(375, 'table_plasto_4leg*9', 1, 2, 2, 1.10, '#ffffff,#533e10', '0', '1', '1', 29, 375, 'Occasional Table', 'Hip plastic furniture', 3),
(376, 'table_plasto_4leg', 1, 2, 2, 1.10, '0,0,0', '0', '1', '1', 29, 376, 'Occasional Table', 'Hip plastic furniture', 3),
(377, 'table_plasto_4leg*5', 1, 2, 2, 1.10, '#ffffff,#54ca00', '0', '1', '1', 29, 377, 'Occasional Table', 'Hip plastic furniture', 3),
(378, 'table_plasto_4leg*2', 1, 2, 2, 1.10, '#ffffff,#99DCCC', '0', '1', '1', 29, 378, 'Occasional Table', 'Hip plastic furniture', 3),
(379, 'table_plasto_4leg*8', 1, 2, 2, 1.10, '#ffffff,#c38d1a', '0', '1', '1', 29, 379, 'Occasional Table', 'Hip plastic furniture', 3),
(380, 'table_plasto_4leg*7', 1, 2, 2, 1.10, '#ffffff,#ff6d00', '0', '1', '1', 29, 380, 'Occasional table', 'Hip plastic furniture', 3),
(381, 'table_plasto_4leg*10', 1, 2, 2, 1.10, '#ffffff,#ccddff', '0', '1', '1', 29, 381, 'Occasional Table', 'Hip plastic furniture', 3),
(382, 'table_plasto_4leg*15', 1, 2, 2, 1.10, '#ffffff,#FF97BA', '0', '1', '1', 29, 382, 'Occasional Table', 'Hip plastic furniture', 3),
(383, 'table_plasto_4leg*16', 1, 2, 2, 1.10, '#ffffff,#CC3399', '0', '1', '1', 29, 383, 'Occasional Table', 'Hip plastic furniture', 3),
(384, 'chair_plasty', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 29, 384, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(385, 'chair_plasty*1', 2, 1, 1, 1.00, '#ffffff,#8EB5D1,#ffffff,#8EB5D1', '0', '1', '1', 29, 385, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(386, 'chair_plasty*2', 2, 1, 1, 1.00, '#ffffff,#ff9900,#ffffff,#ff9900', '0', '1', '1', 29, 386, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(387, 'chair_plasty*3', 2, 1, 1, 1.00, '#ffffff,#ff2200,#ffffff,#ff2200', '0', '1', '1', 29, 387, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(388, 'chair_plasty*4', 2, 1, 1, 1.00, '#ffffff,#00cc00,#ffffff,#00cc00', '0', '1', '1', 29, 388, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(389, 'chair_plasty*4', 2, 1, 1, 1.00, '#ffffff,#0033CC,#ffffff,#0033CC', '0', '1', '1', 29, 389, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(390, 'chair_plasty*4', 2, 1, 1, 1.00, '#ffffff,#333333,#ffffff,#333333', '0', '1', '1', 29, 390, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(391, 'chair_plasty*7', 2, 1, 1, 1.00, '#ffffff,#99DCCc,#ffffff,#99DCCc', '0', '1', '1', 29, 391, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(392, 'chair_plasty*8', 2, 1, 1, 1.00, '#ffffff,#c38d1a,#ffffff,#c38d1a', '0', '1', '1', 29, 392, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(393, 'chair_plasty*9', 2, 1, 1, 1.00, '#ffffff,#533e10,#ffffff,#533e10', '0', '1', '1', 29, 393, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(394, 'chair_plasty*10', 2, 1, 1, 1.00, '#ffffff,#CC3399,#ffffff,#CC3399', '0', '1', '1', 29, 394, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(395, 'chair_plasty*11', 2, 1, 1, 1.00, '#ffffff,#FF97BA,#ffffff,#FF97BA', '0', '1', '1', 29, 395, 'Plastic Pod Chair', 'Hip plastic furniture', 3),
(396, 'chair_plasto*9', 2, 1, 1, 1.00, '#ffffff,#533e10,#ffffff,#533e10', '0', '1', '1', 29, 396, 'Chair', 'Hip plastic furniture', 3),
(397, 'shelves_basic', 1, 2, 1, 1.00, '0,0,0', '0', '1', '1', 31, 397, 'Pura Shelves', 'Pura Series 404 shelves', 3),
(398, 'bar_basic', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 31, 398, 'A Pura Minibar', 'A Pura series 300 minibar', 4),
(399, 'fridge', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 31, 399, 'Pura Refridgerator', 'Keep cool with a chilled snack or drink', 6),
(400, 'lamp_basic', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 31, 400, 'Pura Lamp', 'Switch on the atmosphere with this sophisticated light', 3),
(401, 'bed_budgetb', 3, 2, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 31, 401, 'White Plain Double Bed', 'Sweet dreams for two', 3),
(402, 'bed_budgetb_one', 3, 1, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 31, 402, 'White Plain Single Bed', 'All you need for a good night\'s kip', 3),
(403, 'bed_budget', 3, 2, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#ABD0D2,#ABD0D2,#ABD0D2', '0', '1', '1', 31, 403, 'Aqua Plain Double Bed', 'Sweet dreams for two', 3),
(404, 'bed_budget_one', 3, 1, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#ABD0D2,#ABD0D2,#ABD0D2', '0', '1', '1', 31, 404, 'Aqua Plain Single Bed', 'All you need for a good night\'s kip', 3),
(405, 'bed_budgetb', 3, 2, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FF99BC,#FF99BC,#FF99BC', '0', '1', '1', 31, 405, 'Pink Plain Double Bed', 'Sweet dreams for two', 3),
(406, 'bed_budgetb_one', 3, 1, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FF99BC,#FF99BC,#FF99BC', '0', '1', '1', 31, 406, 'Pink Plain Single Bed', 'All you need for a good night\'s kip', 3),
(407, 'bed_budget', 3, 2, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#525252,#525252,#525252', '0', '1', '1', 31, 407, 'Black Plain Double Bed', 'Sweet dreams for two', 3),
(408, 'bed_budget_one', 3, 1, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#525252,#525252,#525252', '0', '1', '1', 31, 408, 'Black Plain Single Bed', 'All you need for a good night\'s kip', 3),
(409, 'bed_budgetb', 3, 2, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#F7EBBC,#F7EBBC,#F7EBBC', '0', '1', '1', 31, 409, 'Beige Plain Double Bed', 'Sweet dreams for two', 3),
(410, 'bed_budgetb_one', 3, 1, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#F7EBBC,#F7EBBC,#F7EBBC', '0', '1', '1', 31, 410, 'Beige Plain Single Bed', 'All you need for a good night\'s kip', 3),
(411, 'bed_budget', 3, 2, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#5EAAF8,#5EAAF8,#5EAAF8', '0', '1', '1', 31, 411, 'Blue Plain Single Bed', 'Sweet dreams for two', 3);
INSERT INTO `catalogue_items` (`tid`, `name_cct`, `typeid`, `length`, `width`, `top`, `colour`, `door`, `tradeable`, `recycleable`, `catalogue_id_page`, `catalogue_id_index`, `catalogue_name`, `catalogue_description`, `catalogue_cost`) VALUES
(412, 'bed_budget_one', 3, 1, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#5EAAF8,#5EAAF8,#5EAAF8', '0', '1', '1', 31, 412, 'Blue Plain Single Bed', 'All you need for a good night\'s kip', 3),
(413, 'bed_budgetb', 3, 2, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#92D13D,#92D13D,#92D13D', '0', '1', '1', 31, 413, 'Green Plain Single Bed', 'Sweet dreams for two', 3),
(414, 'bed_budgetb_one', 3, 1, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#92D13D,#92D13D,#92D13D', '0', '1', '1', 31, 414, 'Green Plain Single Bed', 'All you need for a good night\'s kip', 3),
(415, 'bed_budget', 3, 2, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFD837,#FFD837,#FFD837', '0', '1', '1', 31, 415, 'Yellow Plain Single Bed', 'Sweet dreams for two', 3),
(416, 'bed_budget_one', 3, 1, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFD837,#FFD837,#FFD837', '0', '1', '1', 31, 416, 'Yellow Plain Single Bed', 'All you need for a good night\'s kip', 3),
(417, 'bed_budgetb', 3, 2, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#E14218,#E14218,#E14218', '0', '1', '1', 31, 417, 'Red Plain Single Bed', 'Sweet dreams for two', 3),
(418, 'bed_budgetb_one', 3, 1, 3, 2.00, '#FFFFFF,#FFFFFF,#FFFFFF,#E14218,#E14218,#E14218', '0', '1', '1', 31, 418, 'Red Plain Single Bed', 'All you need for a good night\'s kip', 3),
(419, 'rclr_sofa', 2, 2, 1, 1.00, '0,0,0', '0', '1', '1', -1, 419, 'Recycler Sofa', 'Handmade...', 25),
(420, 'rclr_chair', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', -1, 420, 'Recycler Chair', 'Handmade...', 25),
(421, 'rclr_garden', 1, 1, 3, 0.00, '0,0,0', '0', '1', '1', -1, 421, 'Recycler Garden', 'Give them water!', 25),
(422, 'queue_tile1*0', 1, 1, 1, 0.20, '#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 33, 422, 'White Habbo Roller', 'The power of movement', 5),
(423, 'queue_tile1*1', 1, 1, 1, 0.20, '#ffffff,#FF7C98,#ffffff,#ffffff', '0', '1', '1', 33, 423, 'Pink Habbo Roller', 'The power of movement', 5),
(424, 'queue_tile1*2', 1, 1, 1, 0.20, '#ffffff,#FF3333,#ffffff,#ffffff', '0', '1', '1', 33, 424, 'Red Habbo Roller', 'The power of movement', 5),
(425, 'queue_tile1*3', 1, 1, 1, 0.20, '#ffffff,#67c39c,#ffffff,#ffffff', '0', '1', '1', 33, 425, 'Aqua Habbo Roller', 'The power of movement', 5),
(426, 'queue_tile1*4', 1, 1, 1, 0.20, '#ffffff,#FFAA2B,#ffffff,#ffffff', '0', '1', '1', 33, 426, 'Gold Habbo Roller', 'The power of movement', 5),
(427, 'queue_tile1*5', 1, 1, 1, 0.20, '#ffffff,#555A37,#ffffff,#ffffff', '0', '1', '1', 33, 427, 'Knight Habbo Roller', 'The power of movement', 5),
(428, 'queue_tile1*6', 1, 1, 1, 0.20, '#ffffff,#A2E8FA,#ffffff,#ffffff', '0', '1', '1', 33, 428, 'Blue Habbo Roller', 'The power of movement', 5),
(429, 'queue_tile1*7', 1, 1, 1, 0.20, '#ffffff,#FC5AFF,#ffffff,#ffffff', '0', '1', '1', 33, 429, 'Purple Habbo Roller', 'The power of movement', 5),
(430, 'queue_tile1*8', 1, 1, 1, 0.20, '#ffffff,#1E8AA5,#ffffff,#ffffff', '0', '1', '1', 33, 430, 'Navy Habbo Roller', 'The power of movement', 5),
(431, 'queue_tile1*9', 1, 1, 1, 0.20, '#ffffff,#9AFF60,#ffffff,#ffffff', '0', '1', '1', 33, 431, 'Green Habbo Roller', 'The power of movement', 5),
(432, 'grand_piano*1', 1, 2, 2, 0.00, '#FFFFFF,#FF8B8B,#FFFFFF', '0', '1', '1', 34, 432, 'Rose Quartz Grand Piano', 'Chopin\'s revolutionary instrument', 10),
(433, 'romantique_pianochair*1', 2, 1, 1, 1.00, '#FFFFFF,#FF8B8B,#FFFFFF', '0', '1', '1', 34, 433, 'Rose Quartz Piano Stool', 'Here sat the legend of 1900', 2),
(434, 'romantique_divan*1', 2, 2, 1, 0.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FF8B8B', '0', '1', '1', 34, 434, 'Rose Quartz Chaise-Longue', 'Recline in continental comfort', 6),
(435, 'romantique_chair*1', 2, 1, 1, 1.00, '#FFFFFF,#FF8B8B,#FFFFFF', '0', '1', '1', 34, 435, 'Rose Quartz Chair', 'Elegant seating for elegant Habbos', 5),
(436, 'romantique_divider*1', 1, 2, 1, 0.00, '#FF8B8B,#FF8B8B,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 34, 436, 'Rose Quartz Screen', 'Beauty lies within', 6),
(437, 'romantique_smalltabl*1', 1, 1, 1, 1.00, '#FFFFFF,#FF8B8B,#FFFFFF', '0', '1', '1', 34, 437, 'Rose Quartz Tray Table', 'Every tray needs a table...', 4),
(438, 'wallmirror', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 34, 438, 'Wall Mirror', 'Mirror, mirror on the wall', 4),
(439, 'romantique_tray2', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 34, 439, 'Treats Tray', 'Spoil yourself', 5),
(440, 'rom_lamp', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 34, 440, 'Crystal Lamp', 'Light up your life', 6),
(441, 'romantique_mirrortabl', 1, 1, 1, 1.00, '0,0,0', '0', '1', '1', 34, 441, 'Dressing Table', 'Get ready for your big date', 8),
(442, 'carpet_standard', 4, 3, 5, 0.00, '0,0,0', '0', '1', '1', 35, 442, 'Floor Rug', 'Available in a variety of colours', 3),
(443, 'carpet_standard*a', 4, 3, 5, 0.00, '#55AC00,#55AC00,#55AC00', '0', '1', '1', 35, 443, 'Floor Rug', 'Available in a variety of colours', 3),
(444, 'carpet_standard*b', 4, 3, 5, 0.00, '#336666,#336666,#336666', '0', '1', '1', 35, 444, 'Floor Rug', 'Available in a variety of colours', 3),
(445, 'carpet_standard*1', 4, 3, 5, 0.00, '#ff1f08', '0', '1', '1', 35, 445, 'Floor Rug', 'Available in a variety of colours', 3),
(446, 'carpet_standard*2', 4, 3, 5, 0.00, '#99DCCC', '0', '1', '1', 35, 446, 'Floor Rug', 'Available in a variety of colours', 3),
(447, 'carpet_standard*3', 4, 3, 5, 0.00, '#ffee00', '0', '1', '1', 35, 447, 'Floor Rug', 'Available in a variety of colours', 3),
(448, 'carpet_standard*4', 4, 3, 5, 0.00, '#ccddff', '0', '1', '1', 35, 448, 'Floor Rug', 'Available in a variety of colours', 3),
(449, 'carpet_standard*5', 4, 3, 5, 0.00, '#ddccff', '0', '1', '1', 35, 449, 'Floor Rug', 'Available in a variety of colours', 3),
(450, 'carpet_standard*6', 4, 3, 5, 0.00, '#777777', '0', '1', '1', 35, 450, 'Floor Rug', 'Available in a variety of colours', 3),
(451, 'carpet_standard*7', 4, 3, 5, 0.00, '#99CCFF,#99CCFF,#99CCFF', '0', '1', '1', 35, 451, 'Floor Rug', 'Available in a variety of colours', 3),
(452, 'carpet_standard*8', 4, 3, 5, 0.00, '#999966,#999966,#999966', '0', '1', '1', 35, 452, 'Floor Rug', 'Available in a variety of colours', 3),
(453, 'carpet_soft', 4, 2, 4, 0.00, '', '0', '1', '1', 35, 453, 'Soft Wool Rug', 'Soft Wool Rug', 3),
(454, 'carpet_soft*1', 4, 2, 4, 0.00, '#CC3333', '0', '1', '1', 35, 454, 'Soft Wool Rug', 'Soft Wool Rug', 3),
(455, 'carpet_soft*2', 4, 2, 4, 0.00, '#66FFFF', '0', '1', '1', 35, 455, 'Soft Wool Rug', 'Soft Wool Rug', 3),
(456, 'carpet_soft*3', 4, 2, 4, 0.00, '#FFCC99', '0', '1', '1', 35, 456, 'Soft Wool Rug', 'Soft Wool Rug', 3),
(457, 'carpet_soft*4', 4, 2, 4, 0.00, '#FFCCFF', '0', '1', '1', 35, 457, 'Soft Wool Rug', 'Soft Wool Rug', 3),
(458, 'carpet_soft*5', 4, 2, 4, 0.00, '#FFFF66', '0', '1', '1', 35, 458, 'Soft Wool Rug', 'Soft Wool Rug', 3),
(459, 'carpet_soft*6', 4, 2, 4, 0.00, '#669933', '0', '1', '1', 35, 459, 'Soft Wool Rug', 'Soft Wool Rug', 3),
(460, 'doormat_love', 4, 1, 1, 0.00, '0,0,0', '0', '1', '1', 35, 460, 'Doormat', 'Welcome Habbos in style', 1),
(461, 'doormat_plain', 4, 1, 1, 0.00, '0,0,0', '0', '1', '1', 35, 461, 'Doormat', 'Available in a variety of colours', 1),
(462, 'doormat_plain*1', 4, 1, 1, 0.00, '#ff1f08', '0', '1', '1', 35, 462, 'Doormat', 'Available in a variety of colours', 1),
(463, 'doormat_plain*2', 4, 1, 1, 0.00, '#99DCCC', '0', '1', '1', 35, 463, 'Doormat', 'Available in a variety of colours', 1),
(464, 'doormat_plain*3', 4, 1, 1, 0.00, '#ffee00', '0', '1', '1', 35, 464, 'Doormat', 'Available in a variety of colours', 1),
(465, 'doormat_plain*4', 4, 1, 1, 0.00, '#ccddff', '0', '1', '1', 35, 465, 'Doormat', 'Available in a variety of colours', 1),
(466, 'doormat_plain*5', 4, 1, 1, 0.00, '#ddccff', '0', '1', '1', 35, 466, 'Doormat', 'Available in a variety of colours', 1),
(467, 'doormat_plain*6', 4, 1, 1, 0.00, '#777777', '0', '1', '1', 35, 467, 'Doormat', 'Available in a variety of colours', 1),
(468, 'carpet_armas', 4, 2, 4, 0.00, '0,0,0', '0', '1', '1', 35, 468, 'Hand-Woven Rug', 'Adds instant warmth', 3),
(469, 'carpet_polar', 4, 2, 3, 0.00, '#ffffff,#ffffff,#ffffff', '0', '1', '1', 35, 469, 'Faux-Fur Bear Rug', 'For cuddling up on', 4),
(470, 'carpet_polar*2', 4, 2, 3, 0.00, '#ccddff,#ccddff,#ffffff', '0', '1', '1', 35, 470, 'Blue Bear Rug', 'Snuggle up on a Funky bear rug...', 10),
(471, 'carpet_polar*3', 4, 2, 3, 0.00, '#ffee99,#ffee99,#ffffff', '0', '1', '1', 35, 471, 'Yellow Bear Rug', 'Snuggle up on a Funky bear rug...', 10),
(472, 'carpet_polar*4', 4, 2, 3, 0.00, '#ddffaa,#ddffaa,#ffffff', '0', '1', '1', 35, 472, 'Green Bear Rug', 'Snuggle up on a Funky bear rug...', 10),
(473, 'poster 52', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 36, 473, 'Hockey stick', 'whack that ball!', 3),
(474, 'poster 53', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 36, 474, 'Hockey stick', 'whack that ball!', 3),
(475, 'poster 54', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 36, 475, 'Hockey stick', 'whack that ball!', 3),
(476, 'hockey_score', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 36, 476, 'Scoreboard', '...for keeping your score', 6),
(477, 'legotrophy', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 36, 477, 'Basketball Trophy', 'For the winning team', 3),
(478, 'poster 51', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 36, 478, 'Basketball Hoop', '2 points for every basket', 3),
(479, 'carpet_legocourt', 4, 3, 3, 0.00, '0,0,0', '0', '1', '1', 36, 479, 'Basketball Court', 'Line up your slam dunk', 3),
(480, 'bench_lego', 2, 4, 1, 1.00, '0,0,0', '0', '1', '1', 36, 480, 'Team Bench', 'For your reserve players', 6),
(481, 'sporttrack1*1', 4, 2, 2, 0.00, '#ffffff,#e4592d,#ffffff', '0', '1', '1', 36, 481, 'Sport track straight', 'Let\'s get sporty!', 3),
(482, 'sporttrack1*2', 4, 2, 2, 0.00, '#ffffff,#62818b,#ffffff', '0', '1', '1', 36, 482, 'Sport track straight asphalt', 'Let\'s get sporty!', 3),
(483, 'sporttrack1*3', 4, 2, 2, 0.00, '#ffffff,#5cb800,#ffffff', '0', '1', '1', 36, 483, 'Sport track straight grass', 'Let\'s get sporty!', 3),
(484, 'sporttrack2*1', 4, 2, 2, 0.00, '#ffffff,#e4592d,#ffffff', '0', '1', '1', 36, 484, 'Sport corner', 'Let\'s get sporty!', 3),
(485, 'sporttrack2*2', 4, 2, 2, 0.00, '#ffffff,#62818b,#ffffff', '0', '1', '1', 36, 485, 'Sport corner asphalt', 'Let\'s get sporty!', 3),
(486, 'sporttrack2*3', 4, 2, 2, 0.00, '#ffffff,#5cb800,#ffffff', '0', '1', '1', 36, 486, 'Sport corner grass', 'Let\'s get sporty!', 3),
(488, 'sporttrack3*1', 4, 2, 2, 0.00, '#ffffff,#e4592d,#ffffff', '0', '1', '1', 36, 488, 'Sport goal', 'Let\'s get sporty!', 3),
(487, 'sporttrack3*3', 4, 2, 2, 0.00, '#ffffff,#5cb800,#ffffff', '0', '1', '1', 36, 487, 'Sport goal grass', 'Let\'s get sporty!', 3),
(489, 'sporttrack3*2', 4, 2, 2, 0.00, '#ffffff,#62818b,#ffffff', '0', '1', '1', 36, 489, 'Sport goal asphalt', 'Let\'s get sporty!', 3),
(490, 'footylamp', 4, 2, 2, 0.00, '0,0,0', '0', '1', '1', 36, 490, 'Football Lamp', 'Let\'s get sporty!', 10),
(491, 'door', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 37, 491, 'Telephone Box', 'Dr Who?', 5),
(492, 'doorC', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 37, 492, 'Portaloo', 'In a hurry?', 4),
(493, 'doorB', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 37, 493, 'Wardrobe', 'Narnia this way!', 3),
(494, 'teleport_door', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 37, 494, 'Teleport Door', 'Teleport Door', 6),
(495, 'sound_machine', 1, 1, 1, 0.00, '#FFFFFF,#FFFFFF,#828282,#FFFFFF', '0', '1', '1', 38, 495, 'Sound Machine', 'Creating fancy sounds', 8),
(496, 'sound_set_4', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 496, 'Ambient 1', 'Chilled out beats', 5),
(497, 'sound_set_8', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 497, 'Ambient 2', 'Mellow electric grooves', 5),
(498, 'sound_set_6', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 498, 'Ambient 3', 'Background ambience loops', 5),
(499, 'sound_set_5', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 499, 'Ambient 4', 'The dark side of Habbo', 5),
(500, 'sound_set_26', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 500, 'Groove 1', 'Bollywood Beats!', 5),
(501, 'sound_set_27', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 501, 'Groove 2', 'Jingle Bells will never be the same...', 5),
(502, 'sound_set_17', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 502, 'Groove 3', 'Jive\'s Alive!', 5),
(503, 'sound_set_18', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 503, 'Groove 4', 'Listen while you tan', 5),
(504, 'sound_set_3', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 504, 'Electronic 1', 'Chilled grooves', 5),
(505, 'sound_set_9', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 38, 505, 'Electronic 2', 'Mystical ambient soundscapes', 5),
(506, 'jukebox*1', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 39, 506, 'Jukebox', 'For your Happy Days!', 5),
(507, 'sound_set_46', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 507, 'Club 1', 'De bada bada bo!', 5),
(508, 'sound_set_47', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 508, 'Club 2', 'Storm the UKCharts!', 5),
(509, 'sound_set_48', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 509, 'Club 3', 'Sweet party beat', 5),
(510, 'sound_set_49', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 510, 'Club 4', 'You will belong', 5),
(511, 'sound_set_50', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 511, 'Club 5', 'The harder generation', 5),
(512, 'sound_set_51', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 512, 'Club 6', 'Bop to the beat', 5),
(513, 'sound_set_25', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 513, 'Dance 1', 'Actually, it\'s Partay!', 5),
(514, 'sound_set_29', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 514, 'Dance 2', 'Electronic house', 5),
(515, 'sound_set_31', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 515, 'Dance 3', 'House loops', 5),
(516, 'sound_set_11', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 516, 'Dance 4', 'Music you can really sink your teeth into', 5),
(517, 'sound_set_13', 1, 1, 1, 0.10, '0,0,0', '0', '1', '1', 39, 517, 'Dance 5', 'Let Music be the food of Habbo', 5),
(518, 'sound_set_35', 1, 0, 1, 0.10, '0,0,0', '0', '1', '1', 39, 518, 'Dance 6', 'Groovelicious', 5),
(519, 'jukebox*1', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 40, 519, 'Jukebox', 'For your Happy Days!', 5),
(520, 'guitar_v', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 40, 520, 'V-Guitar', 'V-Guitar', 5),
(521, 'guitar_skull', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 40, 521, 'Skull-Guitar', 'Skull-Guitar', 5),
(522, 'sound_set_21', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 40, 522, 'Rock 1', 'Headbanging riffs', 5),
(523, 'sound_set_28', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 40, 523, 'Rock 2', 'Head for the pit!', 5),
(524, 'sound_set_33', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 40, 524, 'Rock 3', 'Guitar solo set', 5),
(525, 'sound_set_40', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 40, 525, 'Rock 4', 'Dude? Cheese!', 5),
(526, 'sound_set_34', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 40, 526, 'Rock 5', 'For guitar heroes', 5),
(527, 'sound_set_38', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 40, 527, 'Rock 6', 'Rock and Roses!', 5),
(528, 'sound_set_39', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 40, 528, 'Rock 7', 'Rock with a roll', 5),
(529, 'sound_set_41', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 40, 529, 'Rock 8', 'Burning Riffs', 5),
(530, 'jukebox*1', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 41, 530, 'Jukebox', 'For your Happy Days!', 5),
(531, 'sound_set_1', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 531, 'Habbo Sounds 1', 'Get the party started!', 5),
(532, 'sound_set_12', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 532, 'Habbo Sounds 2', 'Unusual as Standard', 5),
(533, 'sound_set_2', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 533, 'Habbo Sounds 3', 'Get the party started!', 5),
(534, 'sound_set_24', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 534, 'Habbo Sounds 4', 'It\'s all about the Pentiums, baby!', 5),
(535, 'sound_set_43', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 535, 'SFX 1', 'Beware zombies!', 5),
(536, 'sound_set_20', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 536, 'SFX 2', 'Musical heaven', 5),
(537, 'sound_set_22', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 537, 'SFX 3', 'With a hamper full of sounds, not sarnies', 5),
(538, 'sound_set_23', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 538, 'SFX 4', 'Don\'t be afraid of the dark', 5),
(539, 'sound_set_7', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 539, 'SFX 5', 'Sound effects for Furni', 5),
(540, 'sound_set_30', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 540, 'Instrumental 1', 'Moments in love', 5),
(541, 'sound_set_32', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 41, 541, 'Instrumental 2', 'Piano concert set', 5),
(542, 'sound_set_36', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 542, 'Latin Love 1', 'For adult minded', 5),
(543, 'sound_set_60', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 543, 'Latin Love 2', 'Love and affection!', 5),
(544, 'sound_set_61', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 544, 'Latin Love 3', 'Straight from the heart', 5),
(545, 'sound_set_55', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 545, 'RnB Grooves 1', 'Can you fill me in?', 5),
(546, 'sound_set_56', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 546, 'RnB Grooves 2', 'Get down tonight!', 5),
(547, 'sound_set_57', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 547, 'RnB Grooves 3', 'Feel the groove', 5),
(548, 'sound_set_58', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 548, 'RnB Grooves 4', 'Sh-shake it!', 5),
(549, 'sound_set_59', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 549, 'RnB Grooves 5', 'Urban break beats', 5),
(550, 'sound_set_15', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 550, 'RnB Grooves 6', 'Unadulterated essentials', 5),
(551, 'sound_set_10', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 551, 'Hip Hop Beats 1', 'Made from real Boy Bands!', 5),
(552, 'sound_set_14', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 552, 'Hip Hop Beats 2', 'Rock them bodies', 5),
(553, 'sound_set_16', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 553, 'Hip Hop Beats 3', 'Ferry, ferry good!', 5),
(554, 'sound_set_19', 0, 0, 0, 0.10, '0,0,0', '0', '1', '1', 42, 554, 'Hip Hop Beats 4', 'Shake your body!', 5),
(555, 'prizetrophy6*1', 1, 1, 1, 0.00, '#ffffff,#ffffff,#FFDD3F', '0', '1', '1', 43, 555, 'Champion trophy', 'Glittery gold', 12),
(556, 'prizetrophy6*2', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff', '0', '1', '1', 43, 556, 'Champion trophy', 'Shiny silver', 10),
(557, 'prizetrophy6*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#996600', '0', '1', '1', 43, 557, 'Champion trophy', 'Breathtaking bronze', 8),
(558, 'prizetrophy3*1', 1, 1, 1, 0.00, '#ffffff,#ffffff,#FFDD3F', '0', '1', '1', 43, 558, 'Globe trophy', 'Glittery gold', 12),
(559, 'prizetrophy3*2', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff', '0', '1', '1', 43, 559, 'Globe trophy', 'Shiny silver', 10),
(560, 'prizetrophy3*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#996600', '0', '1', '1', 43, 560, 'Globe trophy', 'Breathtaking bronze', 8),
(561, 'prizetrophy4*1', 1, 1, 1, 0.00, '#ffffff,#ffffff,#FFDD3F', '0', '1', '1', 43, 561, 'Fish trophy', 'Glittery gold', 12),
(562, 'prizetrophy4*2', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff', '0', '1', '1', 43, 562, 'Fish trophy', 'Shiny silver', 10),
(563, 'prizetrophy4*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#996600', '0', '1', '1', 43, 563, 'Fish trophy', 'Breathtaking bronze', 8),
(564, 'prizetrophy*1', 1, 1, 1, 0.00, '#ffffff,#ffffff,#FFDD3F', '0', '1', '1', 43, 564, 'Classic trophy', 'Glittery gold', 12),
(565, 'prizetrophy*2', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff', '0', '1', '1', 43, 565, 'Classic trophy', 'Shiny silver', 10),
(566, 'prizetrophy*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#996600', '0', '1', '1', 43, 566, 'Classic trophy', 'Breathtaking bronze', 8),
(567, 'prizetrophy5*1', 1, 1, 1, 0.00, '#ffffff,#ffffff,#FFDD3F', '0', '1', '1', 43, 567, 'Duo trophy', 'Glittery gold', 12),
(568, 'prizetrophy5*2', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff', '0', '1', '1', 43, 568, 'Duo trophy', 'Shiny silver', 10),
(569, 'prizetrophy5*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#996600', '0', '1', '1', 43, 569, 'Duo trophy', 'Breathtaking bronze', 8),
(570, 'prizetrophy2*1', 1, 1, 1, 0.00, '#ffffff,#ffffff,#FFDD3F', '0', '1', '1', 43, 570, 'Duck trophy', 'Glittery gold', 12),
(571, 'prizetrophy2*2', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff', '0', '1', '1', 43, 571, 'Duck trophy', 'Shiny silver', 10),
(572, 'prizetrophy2*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#996600', '0', '1', '1', 43, 572, 'Duck trophy', 'Breathtaking bronze', 8),
(573, 'prizetrophy8*1', 1, 1, 1, 0.00, '#ffffff,#ffffff,#FFDD3F', '0', '1', '1', 43, 573, 'Duo trophy', 'Glittery gold', 12),
(574, 'prizetrophy9*1', 1, 1, 1, 0.00, '#ffffff,#ffffff,#FFDD3F', '0', '1', '1', 43, 574, 'Champion trophy', 'Glittery gold', 12),
(575, 'poster 20', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 575, 'Snowman Poster', 'A new use for carrots!', 3),
(576, 'poster 21', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 576, 'Angel Poster', 'See that halo gleam!', 3),
(577, 'poster 22', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 577, 'Winter Wonderland Poster', 'A chilly snowy scene', 3),
(578, 'poster 23', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 578, 'Santa Poster Poster', 'The jolly fat man himself', 3),
(579, 'poster 24', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 579, 'Three Wise Men Poster', 'Following the star!', 3),
(580, 'poster 25', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 580, 'Reindeer Poster', 'Doing a hard night\'s work', 3),
(581, 'poster 26', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 581, 'Stocking', 'Hung yours up yet?', 3),
(582, 'poster 27', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 582, 'Holly Garland', 'Deck the halls!', 3),
(583, 'poster 28', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 583, 'Tinsel (silver)', 'A touch of festive sparkle', 3),
(584, 'poster 29', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 584, 'Tinsel (gold)', 'A touch of festive sparkle', 3),
(585, 'poster 30', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 585, 'Mistletoe', 'Pucker up', 3),
(586, 'poster 46', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 586, 'Small gold star', 'Twinkle, twinkle', 3),
(587, 'poster 47', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 587, 'Small silver star', 'Twinkle, twinkle', 3),
(588, 'poster 48', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 588, 'Large gold star', 'All that glitters...', 3),
(589, 'poster 49', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 44, 589, 'Large silver star', 'All that glitters...', 3),
(590, 'tree3', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 590, 'Christmas Tree 1', 'Any presents under it yet?', 6),
(591, 'tree4', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 591, 'Christmas Tree 2', 'Any presents under it yet?', 6),
(592, 'tree5', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 592, 'Christmas Tree 3', 'Any presents under it yet?', 6),
(593, 'triplecandle', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 593, 'Electric Candles', 'No need to worry about wax drips', 3),
(594, 'turkey', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 594, 'Roast Turkey', 'Where\'s the cranberry sauce?', 3),
(595, 'house', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 595, 'Gingerbread House', 'Good enough to eat', 3),
(596, 'pudding', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 596, 'Christmas Pudding', 'Will you get the lucky sixpence?', 3),
(597, 'xmasduck', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 597, 'Christmas Rubber Duck', 'A right Christmas quacker!', 2),
(598, 'hyacinth1', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 598, 'Pink Hyacinth', 'Beautiful bulb', 3),
(599, 'hyacinth2', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 599, 'Blue Hyacinth', 'Beautiful bulb', 3),
(600, 'joulutahti', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 600, 'Poinsetta', 'Christmas in a pot', 3),
(601, 'rcandle', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 601, 'Red Candle', 'Xmas tea light', 3),
(602, 'wcandle', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 44, 602, 'White Candle', 'Xmas tea light', 3),
(603, 'easterduck', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 45, 603, 'Wannabe bunny', 'Can you tell what it is yet?', 2),
(604, 'birdie', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 45, 604, 'Pop-up Egg', 'Cheep (!) and cheerful', 5),
(605, 'basket', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 45, 605, 'Basket Of Eggs', 'Eggs-actly what you want for Easter', 4),
(606, 'bunny', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 45, 606, 'Squidgy Bunny', 'Yours to cuddle up to', 3),
(607, 'pumpkin', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 46, 607, 'Pumpkin Lamp', 'Cast a spooky glow', 6),
(608, 'poster 42', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 46, 608, 'Spiderweb', 'Not something you want to run into', 3),
(609, 'poster 43', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 46, 609, 'Chains', 'Shake, rattle and roll!', 4),
(610, 'skullcandle', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 46, 610, 'Skull Candle Holder', 'Alas poor Yorrick...', 4),
(611, 'poster 45', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 46, 611, 'Skeleton', 'Needs a few more Habburgers', 3),
(612, 'poster 44', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 46, 612, 'Mummy', 'Beware the curse...', 3),
(613, 'deadduck', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 46, 613, 'Dead Duck', 'Blood, but no guts', 2),
(614, 'deadduck2', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 46, 614, 'Dead Duck 2', 'Someone forgot to feed me...', 2),
(615, 'deadduck3', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 46, 615, 'Dead Duck 3', 'With added ectoplasm', 2),
(616, 'poster 50', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 46, 616, 'Bat Poster', 'flap, flap, screech, screech...', 3),
(617, 'poster 501', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 46, 617, 'Jolly Roger', 'For pirates everywhere', 3),
(618, 'ham2', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 46, 618, 'Eaten Ham', 'Looks like you\'re too late!', 3),
(619, 'habboween_crypt', 1, 2, 2, 0.00, '0,0,0', '0', '1', '1', 46, 619, 'HabboWheen Crypt', 'HabboWheen Crypt', 5),
(625, 'habboween_grass', 4, 2, 2, 0.00, '0,0,0', '0', '1', '1', 46, 625, 'HabboWheen Grass', 'HabboWheen Grass', 5),
(620, 'valeduck', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 47, 620, 'Valentine\'s Duck', 'He\'s lovestruck', 2),
(621, 'hal_cauldron', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 46, 621, 'HabboWheen Cauldron', 'HabboWheen Cauldron', 5),
(622, 'hal_grave', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 46, 622, 'HabboWheen Grave', 'HabboWheen Grave', 5),
(623, 'heartsofa', 2, 2, 1, 1.00, '0,0,0', '0', '1', '1', 47, 623, 'Heart Sofa', 'Perfect for snuggling up on', 5),
(624, 'statue', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 47, 624, 'Cupid Statue', 'Watch out for those arrows!', 3),
(626, 'heart', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 47, 626, 'Giant Heart', 'Full of love', 6),
(627, 'post.it.vd', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 47, 627, 'Heart stickies', 'Heart stickies', 3),
(628, 'carpet_valentine', 4, 2, 7, 0.00, '0,0,0', '0', '1', '1', 47, 628, 'Red Carpet', 'For making an entrance.', 15),
(629, 'val_heart', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 47, 629, 'Valentine\'s lamp', 'Valentine\'s lamp', 10),
(630, 'plant_valentinerose*1', 1, 1, 1, 0.00, '#FFFFFF,#FF1E1E,#FFFFFF,#FFFFFF', '0', '1', '1', 47, 630, 'Valentine rose Red', 'For a love that it true', 8),
(631, 'plant_valentinerose*2', 1, 1, 1, 0.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 47, 631, 'White Valentine Rose', 'Your secret love', 8),
(632, 'plant_valentinerose*3', 1, 1, 1, 0.00, '#FFFFFF,#ffee00,#FFFFFF,#FFFFFF', '0', '1', '1', 47, 632, 'Yellow Valentine Rose', 'Relight your passions', 8),
(633, 'plant_valentinerose*4', 1, 1, 1, 0.00, '#FFFFFF,#ffbbcf,#FFFFFF,#FFFFFF', '0', '1', '1', 47, 633, 'Pink Valentine\'s Rose', 'Be mine!', 8),
(634, 'plant_valentinerose*5', 1, 1, 1, 0.00, '#FFFFFF,#CC3399,#FFFFFF,#FFFFFF', '0', '1', '1', 47, 634, 'Purple Valentine Rose', 'For that special pixel', 8),
(635, 'sofa_silo*2', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#525252,#525252,#525252,#525252', '0', '1', '1', 48, 635, 'Two-Seater Sofa', 'Cushioned, understated comfort', 3),
(636, 'sofachair_silo*2', 1, 1, 1, 1.00, '#ffffff,#ffffff,#525252,#525252', '0', '1', '1', 48, 636, 'Armchair', 'Large, but worth it', 3),
(637, 'table_silo_small*2', 1, 1, 1, 1.10, '#ffffff,#525252', '0', '1', '1', 48, 637, 'Occasional Table', 'For those random moments', 1),
(638, 'divider_silo3*2', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#525252', '1', '1', '1', 48, 638, 'Gate (lockable)', 'Form following function', 6),
(639, 'divider_silo1*2', 1, 1, 1, 1.00, '#ffffff,#525252', '0', '1', '1', 48, 639, 'Corner Shelf', 'Neat and natty', 3),
(640, 'chair_silo*2', 2, 1, 1, 1.10, '#ffffff,#ffffff,#525252,#525252', '0', '1', '1', 48, 640, 'Dining Chair', 'Keep it simple', 3),
(641, 'safe_silo*2', 1, 1, 1, 1.20, '#ffffff,#525252', '0', '1', '1', 48, 641, 'Safe Minibar', 'Totally shatter-proof!', 3),
(642, 'barchair_silo*2', 1, 1, 1, 0.90, '#ffffff,#525252', '0', '1', '1', 48, 642, 'Bar Stool', 'Practical and convenient', 3),
(643, 'table_silo_med*2', 1, 2, 2, 0.90, '#ffffff,#525252', '0', '1', '1', 48, 643, 'Coffee Table', 'Wipe clean and unobtrusive', 3),
(644, 'sofa_silo*3', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 48, 644, 'Two-Seater Sofa', 'Cushioned, understated comfort', 3),
(645, 'sofachair_silo*3', 1, 1, 1, 1.00, '#ffffff,#ffffff,#FFFFFF,#FFFFFF', '0', '1', '1', 48, 645, 'Armchair', 'Large, but worth it', 3),
(646, 'table_silo_small*3', 1, 1, 1, 1.10, '#ffffff,#FFFFFF', '0', '1', '1', 48, 646, 'Occasional Table', 'For those random moments', 1),
(647, 'divider_silo3*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#FFFFFF', '1', '1', '1', 48, 647, 'Gate (lockable)', 'Form following function', 6),
(648, 'divider_silo1*3', 1, 1, 1, 1.00, '#ffffff,#FFFFFF', '0', '1', '1', 48, 648, 'Corner Shelf', 'Neat and natty', 3),
(649, 'chair_silo*3', 2, 1, 1, 1.10, '#ffffff,#ffffff,#FFFFFF,#FFFFFF', '0', '1', '1', 48, 649, 'Dining Chair', 'Keep it simple', 3),
(650, 'safe_silo*3', 1, 1, 1, 1.20, '#ffffff,#FFFFFF', '0', '1', '1', 48, 650, 'Safe Minibar', 'Totally shatter-proof!', 3),
(651, 'barchair_silo*3', 1, 1, 1, 0.90, '#ffffff,#FFFFFF', '0', '1', '1', 48, 651, 'Bar Stool', 'Practical and convenient', 3),
(652, 'table_silo_med*3', 1, 2, 2, 0.90, '#ffffff,#FFFFFF', '0', '1', '1', 48, 652, 'Coffee Table', 'Wipe clean and unobtrusive', 3),
(653, 'sofa_silo*4', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#F7EBBC,#F7EBBC,#F7EBBC,#F7EBBC', '0', '1', '1', 48, 653, 'Two-Seater Sofa', 'Cushioned, understated comfort', 3),
(654, 'sofachair_silo*4', 1, 1, 1, 1.00, '#ffffff,#ffffff,#F7EBBC,#F7EBBC', '0', '1', '1', 48, 654, 'Armchair', 'Large, but worth it', 3),
(655, 'table_silo_small*4', 1, 1, 1, 1.10, '#ffffff,#F7EBBC', '0', '1', '1', 48, 655, 'Occasional Table', 'For those random moments', 1),
(656, 'divider_silo3*4', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#F7EBBC', '1', '1', '1', 48, 656, 'Gate (lockable)', 'Form following function', 6),
(657, 'divider_silo1*4', 1, 1, 1, 1.00, '#ffffff,#F7EBBC', '0', '1', '1', 48, 657, 'Corner Shelf', 'Neat and natty', 3),
(658, 'chair_silo*4', 2, 1, 1, 1.10, '#ffffff,#ffffff,#F7EBBC,#F7EBBC', '0', '1', '1', 48, 658, 'Dining Chair', 'Keep it simple', 3),
(659, 'safe_silo*4', 1, 1, 1, 1.20, '#ffffff,#F7EBBC', '0', '1', '1', 48, 659, 'Safe Minibar', 'Totally shatter-proof!', 3),
(660, 'barchair_silo*4', 1, 1, 1, 0.90, '#ffffff,#F7EBBC', '0', '1', '1', 48, 660, 'Bar Stool', 'Practical and convenient', 3),
(661, 'table_silo_med*4', 1, 2, 2, 0.90, '#ffffff,#F7EBBC', '0', '1', '1', 48, 661, 'Coffee Table', 'Wipe clean and unobtrusive', 3),
(662, 'sofa_silo*5', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#FF99BC,#FF99BC,#FF99BC,#FF99BC', '0', '1', '1', 48, 662, 'Two-Seater Sofa', 'Cushioned, understated comfort', 3),
(663, 'sofachair_silo*5', 1, 1, 1, 1.00, '#ffffff,#ffffff,#FF99BC,#FF99BC', '0', '1', '1', 48, 663, 'Armchair', 'Large, but worth it', 3),
(664, 'table_silo_small*5', 1, 1, 1, 1.10, '#ffffff,#FF99BC', '0', '1', '1', 48, 664, 'Occasional Table', 'For those random moments', 1),
(665, 'divider_silo3*5', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#FF99BC', '1', '1', '1', 48, 665, 'Gate (lockable)', 'Form following function', 6),
(666, 'divider_silo1*5', 1, 1, 1, 1.00, '#ffffff,#FF99BC', '0', '1', '1', 48, 666, 'Corner Shelf', 'Neat and natty', 3),
(667, 'chair_silo*5', 2, 1, 1, 1.10, '#ffffff,#ffffff,#FF99BC,#FF99BC', '0', '1', '1', 48, 667, 'Dining Chair', 'Keep it simple', 3),
(668, 'safe_silo*5', 1, 1, 1, 1.20, '#ffffff,#FF99BC', '0', '1', '1', 48, 668, 'Safe Minibar', 'Totally shatter-proof!', 3),
(669, 'barchair_silo*5', 1, 1, 1, 0.90, '#ffffff,#FF99BC', '0', '1', '1', 48, 669, 'Bar Stool', 'Practical and convenient', 3),
(670, 'table_silo_med*5', 1, 2, 2, 0.90, '#ffffff,#FF99BC', '0', '1', '1', 48, 670, 'Coffee Table', 'Wipe clean and unobtrusive', 3),
(671, 'sofa_silo*6', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#5EAAF8,#5EAAF8,#5EAAF8,#5EAAF8', '0', '1', '1', 48, 671, 'Two-Seater Sofa', 'Cushioned, understated comfort', 3),
(672, 'sofachair_silo*6', 1, 1, 1, 1.00, '#ffffff,#ffffff,#5EAAF8,#5EAAF8', '0', '1', '1', 48, 672, 'Armchair', 'Large, but worth it', 3),
(673, 'table_silo_small*6', 1, 1, 1, 1.10, '#ffffff,#5EAAF8', '0', '1', '1', 48, 673, 'Occasional Table', 'For those random moments', 1),
(674, 'divider_silo3*6', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#5EAAF8', '1', '1', '1', 48, 674, 'Gate (lockable)', 'Form following function', 6),
(675, 'divider_silo1*6', 1, 1, 1, 1.00, '#ffffff,#5EAAF8', '0', '1', '1', 48, 675, 'Corner Shelf', 'Neat and natty', 3),
(676, 'chair_silo*6', 2, 1, 1, 1.10, '#ffffff,#ffffff,#5EAAF8,#5EAAF8', '0', '1', '1', 48, 676, 'Dining Chair', 'Keep it simple', 3),
(677, 'safe_silo*6', 1, 1, 1, 1.20, '#ffffff,#5EAAF8', '0', '1', '1', 48, 677, 'Safe Minibar', 'Totally shatter-proof!', 3),
(678, 'barchair_silo*6', 1, 1, 1, 0.90, '#ffffff,#5EAAF8', '0', '1', '1', 48, 678, 'Bar Stool', 'Practical and convenient', 3),
(679, 'table_silo_med*6', 1, 2, 2, 0.90, '#ffffff,#5EAAF8', '0', '1', '1', 48, 679, 'Coffee Table', 'Wipe clean and unobtrusive', 3),
(680, 'sofa_silo*7', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#92D13D,#92D13D,#92D13D,#92D13D', '0', '1', '1', 48, 680, 'Two-Seater Sofa', 'Cushioned, understated comfort', 3),
(681, 'sofachair_silo*7', 1, 1, 1, 1.00, '#ffffff,#ffffff,#92D13D,#92D13D', '0', '1', '1', 48, 681, 'Armchair', 'Large, but worth it', 3),
(682, 'table_silo_small*7', 1, 1, 1, 1.10, '#ffffff,#92D13D', '0', '1', '1', 48, 682, 'Occasional Table', 'For those random moments', 1),
(683, 'divider_silo3*7', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#92D13D', '1', '1', '1', 48, 683, 'Gate (lockable)', 'Form following function', 6),
(684, 'divider_silo1*7', 1, 1, 1, 1.00, '#ffffff,#92D13D', '0', '1', '1', 48, 684, 'Corner Shelf', 'Neat and natty', 3),
(685, 'chair_silo*7', 2, 1, 1, 1.10, '#ffffff,#ffffff,#92D13D,#92D13D', '0', '1', '1', 48, 685, 'Dining Chair', 'Keep it simple', 3),
(686, 'safe_silo*7', 1, 1, 1, 1.20, '#ffffff,#92D13D', '0', '1', '1', 48, 686, 'Safe Minibar', 'Totally shatter-proof!', 3),
(687, 'barchair_silo*7', 1, 1, 1, 0.90, '#ffffff,#92D13D', '0', '1', '1', 48, 687, 'Bar Stool', 'Practical and convenient', 3),
(688, 'table_silo_med*7', 1, 2, 2, 0.90, '#ffffff,#92D13D', '0', '1', '1', 48, 688, 'Coffee Table', 'Wipe clean and unobtrusive', 3),
(689, 'sofa_silo*8', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#FFD837,#FFD837,#FFD837,#FFD837', '0', '1', '1', 48, 689, 'Two-Seater Sofa', 'Cushioned, understated comfort', 3),
(690, 'sofachair_silo*8', 1, 1, 1, 1.00, '#ffffff,#ffffff,#FFD837,#FFD837', '0', '1', '1', 48, 690, 'Armchair', 'Large, but worth it', 3),
(691, 'table_silo_small*8', 1, 1, 1, 1.10, '#ffffff,#FFD837', '0', '1', '1', 48, 691, 'Occasional Table', 'For those random moments', 1),
(692, 'divider_silo3*8', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#FFD837', '1', '1', '1', 48, 692, 'Gate (lockable)', 'Form following function', 6),
(693, 'divider_silo1*8', 1, 1, 1, 1.00, '#ffffff,#FFD837', '0', '1', '1', 48, 693, 'Corner Shelf', 'Neat and natty', 3),
(694, 'chair_silo*8', 2, 1, 1, 1.10, '#ffffff,#ffffff,#FFD837,#FFD837', '0', '1', '1', 48, 694, 'Dining Chair', 'Keep it simple', 3),
(695, 'safe_silo*8', 1, 1, 1, 1.20, '#ffffff,#FFD837', '0', '1', '1', 48, 695, 'Safe Minibar', 'Totally shatter-proof!', 3),
(696, 'barchair_silo*8', 1, 1, 1, 0.90, '#ffffff,#FFD837', '0', '1', '1', 48, 696, 'Bar Stool', 'Practical and convenient', 3),
(697, 'table_silo_med*8', 1, 2, 2, 0.90, '#ffffff,#FFD837', '0', '1', '1', 48, 697, 'Coffee Table', 'Wipe clean and unobtrusive', 3),
(698, 'sofa_silo*9', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#E14218,#E14218,#E14218,#E14218', '0', '1', '1', 48, 698, 'Two-Seater Sofa', 'Cushioned, understated comfort', 3),
(699, 'sofachair_silo*9', 1, 1, 1, 1.00, '#ffffff,#ffffff,#E14218,#E14218', '0', '1', '1', 48, 699, 'Armchair', 'Large, but worth it', 3),
(700, 'table_silo_small*9', 1, 1, 1, 1.10, '#ffffff,#E14218', '0', '1', '1', 48, 700, 'Occasional Table', 'For those random moments', 1),
(701, 'divider_silo3*9', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#E14218', '1', '1', '1', 48, 701, 'Gate (lockable)', 'Form following function', 6),
(702, 'divider_silo1*9', 1, 1, 1, 1.00, '#ffffff,#E14218', '0', '1', '1', 48, 702, 'Corner Shelf', 'Neat and natty', 3),
(703, 'chair_silo*9', 2, 1, 1, 1.10, '#ffffff,#ffffff,#E14218,#E14218', '0', '1', '1', 48, 703, 'Dining Chair', 'Keep it simple', 3),
(704, 'safe_silo*9', 1, 1, 1, 1.20, '#ffffff,#E14218', '0', '1', '1', 48, 704, 'Safe Minibar', 'Totally shatter-proof!', 3),
(705, 'barchair_silo*9', 1, 1, 1, 0.90, '#ffffff,#E14218', '0', '1', '1', 48, 705, 'Bar Stool', 'Practical and convenient', 3),
(706, 'table_silo_med*9', 1, 2, 2, 0.90, '#ffffff,#E14218', '0', '1', '1', 48, 706, 'Coffee Table', 'Wipe clean and unobtrusive', 3),
(707, 'chair_norja*2', 2, 1, 1, 1.00, '#ffffff,#ffffff,#525252,#525252', '0', '1', '1', 49, 707, 'Chair', 'Sleek and chic for each cheek', 3),
(708, 'couch_norja*2', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#525252,#525252,#525252,#525252', '0', '1', '1', 49, 708, 'Bench', 'Two can perch comfortably', 3),
(709, 'table_norja_med*2', 1, 2, 2, 0.90, '#ffffff,#525252', '0', '1', '1', 49, 709, 'Coffee Table', 'Elegance embodied', 3),
(710, 'shelves_norja*2', 1, 1, 1, 0.00, '#ffffff,#525252', '0', '1', '1', 49, 710, 'Bookcase', 'For nic naks and art deco books', 3),
(711, 'soft_sofachair_norja*2', 2, 1, 1, 1.00, '#ffffff,#525252,#525252', '0', '1', '1', 49, 711, 'iced sofachair', 'Soft iced sofachair', 3),
(712, 'soft_sofa_norja*2', 2, 2, 1, 1.00, '#ffffff,#525252,#ffffff,#525252,#525252,#525252', '0', '1', '1', 49, 712, 'iced sofa', 'A soft iced sofa', 4),
(713, 'divider_nor2*2', 1, 2, 1, 0.00, '#ffffff,#ffffff,#525252,#525252', '0', '1', '1', 49, 713, 'Ice Bar-Desk', 'Strong, yet soft looking', 3),
(714, 'divider_nor1*2', 1, 1, 1, 0.00, '#ffffff,#525252', '0', '1', '1', 49, 714, 'Ice Corner', 'Looks squishy, but isn\'t', 3),
(715, 'divider_nor3*2', 1, 1, 1, 0.00, '#ffffff,#ffffff,#525252,#525252', '1', '1', '1', 49, 715, 'Door (Lockable)', 'Do go through...', 6),
(716, 'divider_nor4*2', 1, 2, 1, 0.00, '#ffffff,#ffffff,#525252,#525252,#525252,#525252', '1', '1', '1', 49, 716, 'Iced Auto Shutter', 'Habbos, roll out!', 3),
(717, 'divider_nor5*2', 1, 1, 1, 0.00, '#ffffff,#525252,#525252,#525252,#525252,#525252', '1', '1', '1', 49, 717, 'Iced Angle', 'Cool cornering for you!', 3),
(718, 'chair_norja*3', 2, 1, 1, 1.00, '#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 49, 718, 'Chair', 'Sleek and chic for each cheek', 3),
(719, 'couch_norja*3', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 49, 719, 'Bench', 'Two can perch comfortably', 3),
(720, 'table_norja_med*3', 1, 2, 2, 0.90, '#ffffff,#ffffff', '0', '1', '1', 49, 720, 'Coffee Table', 'Elegance embodied', 3),
(721, 'shelves_norja*3', 1, 1, 1, 0.00, '#ffffff,#ffffff', '0', '1', '1', 49, 721, 'Bookcase', 'For nic naks and art deco books', 3),
(722, 'soft_sofachair_norja*3', 2, 1, 1, 1.00, '#ffffff,#ffffff,#ffffff', '0', '1', '1', 49, 722, 'iced sofachair', 'Soft iced sofachair', 3),
(723, 'soft_sofa_norja*3', 2, 2, 1, 1.00, '#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 49, 723, 'iced sofa', 'A soft iced sofa', 4),
(724, 'divider_nor2*3', 1, 2, 1, 0.00, '#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 49, 724, 'Ice Bar-Desk', 'Strong, yet soft looking', 3),
(725, 'divider_nor1*3', 1, 1, 1, 0.00, '#ffffff,#ffffff', '0', '1', '1', 49, 725, 'Ice Corner', 'Looks squishy, but isn\'t', 3),
(726, 'divider_nor3*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#ffffff', '1', '1', '1', 49, 726, 'Door (Lockable)', 'Do go through...', 6),
(727, 'divider_nor4*3', 1, 2, 1, 0.00, '#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff', '1', '1', '1', 49, 727, 'Iced Auto Shutter', 'Habbos, roll out!', 3),
(728, 'divider_nor5*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff', '1', '1', '1', 49, 728, 'Iced Angle', 'Cool cornering for you!', 3),
(729, 'chair_norja*4', 2, 1, 1, 1.00, '#ffffff,#ffffff,#ABD0D2,#ABD0D2', '0', '1', '1', 49, 729, 'Chair', 'Sleek and chic for each cheek', 3),
(730, 'couch_norja*4', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#ABD0D2,#ABD0D2,#ABD0D2,#ABD0D2', '0', '1', '1', 49, 730, 'Bench', 'Two can perch comfortably', 3),
(731, 'table_norja_med*4', 1, 2, 2, 0.90, '#ffffff,#ABD0D2', '0', '1', '1', 49, 731, 'Coffee Table', 'Elegance embodied', 3),
(732, 'shelves_norja*4', 1, 1, 1, 0.00, '#ffffff,#ABD0D2', '0', '1', '1', 49, 732, 'Bookcase', 'For nic naks and art deco books', 3),
(733, 'soft_sofachair_norja*4', 2, 1, 1, 1.00, '#ffffff,#ABD0D2,#ABD0D2', '0', '1', '1', 49, 733, 'iced sofachair', 'Soft iced sofachair', 3),
(734, 'soft_sofa_norja*4', 2, 2, 1, 1.00, '#ffffff,#ABD0D2,#ffffff,#ABD0D2,#ABD0D2,#ABD0D2', '0', '1', '1', 49, 734, 'iced sofa', 'A soft iced sofa', 4),
(735, 'divider_nor2*4', 1, 2, 1, 0.00, '#ffffff,#ffffff,#ABD0D2,#ABD0D2', '0', '1', '1', 49, 735, 'Ice Bar-Desk', 'Strong, yet soft looking', 3),
(736, 'divider_nor1*4', 1, 1, 1, 0.00, '#ffffff,#ABD0D2', '0', '1', '1', 49, 736, 'Ice Corner', 'Looks squishy, but isn\'t', 3),
(737, 'divider_nor3*4', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ABD0D2,#ABD0D2', '1', '1', '1', 49, 737, 'Door (Lockable)', 'Do go through...', 6),
(738, 'divider_nor4*4', 1, 2, 1, 0.00, '#ffffff,#ffffff,#ABD0D2,#ABD0D2,#ABD0D2,#ABD0D2', '1', '1', '1', 49, 738, 'Iced Auto Shutter', 'Habbos, roll out!', 3),
(739, 'divider_nor5*4', 1, 1, 1, 0.00, '#ffffff,#ABD0D2,#ABD0D2,#ABD0D2,#ABD0D2,#ABD0D2', '1', '1', '1', 49, 739, 'Iced Angle', 'Cool cornering for you!', 3),
(740, 'chair_norja*5', 2, 1, 1, 1.00, '#ffffff,#ffffff,#EE7EA4,#EE7EA4', '0', '1', '1', 49, 740, 'Chair', 'Sleek and chic for each cheek', 3),
(741, 'couch_norja*5', 2, 2, 1, 1.00, '#ffffff,#ffffff,#ffffff,#ffffff,#EE7EA4,#EE7EA4,#EE7EA4,#EE7EA4', '0', '1', '1', 49, 741, 'Bench', 'Two can perch comfortably', 3),
(742, 'table_norja_med*5', 1, 2, 2, 0.90, '#ffffff,#EE7EA4', '0', '1', '1', 49, 742, 'Coffee Table', 'Elegance embodied', 3),
(743, 'shelves_norja*5', 1, 1, 1, 0.00, '#ffffff,#EE7EA4', '0', '1', '1', 49, 743, 'Bookcase', 'For nic naks and art deco books', 3),
(744, 'soft_sofachair_norja*5', 2, 1, 1, 1.00, '#ffffff,#EE7EA4,#EE7EA4', '0', '1', '1', 49, 744, 'iced sofachair', 'Soft iced sofachair', 3),
(745, 'soft_sofa_norja*5', 2, 2, 1, 1.00, '#ffffff,#EE7EA4,#ffffff,#EE7EA4,#EE7EA4,#EE7EA4', '0', '1', '1', 49, 745, 'iced sofa', 'A soft iced sofa', 4),
(746, 'divider_nor2*5', 1, 2, 1, 0.00, '#ffffff,#ffffff,#EE7EA4,#EE7EA4', '0', '1', '1', 49, 746, 'Ice Bar-Desk', 'Strong, yet soft looking', 3),
(747, 'divider_nor1*5', 1, 1, 1, 0.00, '#ffffff,#EE7EA4', '0', '1', '1', 49, 747, 'Ice Corner', 'Looks squishy, but isn\'t', 3),
(748, 'divider_nor3*5', 1, 1, 1, 0.00, '#ffffff,#ffffff,#EE7EA4,#EE7EA4', '1', '1', '1', 49, 748, 'Door (Lockable)', 'Do go through...', 6),
(749, 'divider_nor4*5', 1, 2, 1, 0.00, '#ffffff,#ffffff,#EE7EA4,#EE7EA4,#EE7EA4,#EE7EA4', '1', '1', '1', 49, 749, 'Iced Auto Shutter', 'Habbos, roll out!', 3),
(750, 'divider_nor5*5', 1, 1, 1, 0.00, '#ffffff,#EE7EA4,#EE7EA4,#EE7EA4,#EE7EA4,#EE7EA4', '1', '1', '1', 49, 750, 'Iced Angle', 'Cool cornering for you!', 3),
(751, 'chair_norja*6', 2, 1, 1, 1.00, '#ffffff,#ffffff,#5EAAF8,#5EAAF8', '0', '1', '1', 49, 751, 'Chair', 'Sleek and chic for each cheek', 3),
(752, 'couch_norja*6', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#5EAAF8,#5EAAF8,#5EAAF8,#5EAAF8', '0', '1', '1', 49, 752, 'Bench', 'Two can perch comfortably', 3),
(753, 'table_norja_med*6', 1, 2, 2, 0.90, '#ffffff,#5EAAF8', '0', '1', '1', 49, 753, 'Coffee Table', 'Elegance embodied', 3),
(754, 'shelves_norja*6', 1, 1, 1, 0.00, '#ffffff,#5EAAF8', '0', '1', '1', 49, 754, 'Bookcase', 'For nic naks and art deco books', 3),
(755, 'soft_sofachair_norja*6', 2, 1, 1, 1.00, '#ffffff,#5EAAF8,#5EAAF8', '0', '1', '1', 49, 755, 'iced sofachair', 'Soft iced sofachair', 3),
(756, 'soft_sofa_norja*6', 2, 2, 1, 1.00, '#ffffff,#5EAAF8,#ffffff,#5EAAF8,#5EAAF8,#5EAAF8', '0', '1', '1', 49, 756, 'iced sofa', 'A soft iced sofa', 4),
(757, 'divider_nor2*6', 1, 2, 1, 0.00, '#ffffff,#ffffff,#5EAAF8,#5EAAF8', '0', '1', '1', 49, 757, 'Ice Bar-Desk', 'Strong, yet soft looking', 3),
(758, 'divider_nor1*6', 1, 1, 1, 0.00, '#ffffff,#5EAAF8', '0', '1', '1', 49, 758, 'Ice Corner', 'Looks squishy, but isn\'t', 3),
(759, 'divider_nor3*6', 1, 1, 1, 0.00, '#ffffff,#ffffff,#5EAAF8,#5EAAF8', '1', '1', '1', 49, 759, 'Door (Lockable)', 'Do go through...', 6),
(760, 'divider_nor4*6', 1, 2, 1, 0.00, '#ffffff,#ffffff,#5EAAF8,#5EAAF8,#5EAAF8,#5EAAF8', '1', '1', '1', 49, 760, 'Iced Auto Shutter', 'Habbos, roll out!', 3),
(761, 'divider_nor5*6', 1, 1, 1, 0.00, '#ffffff,#5EAAF8,#5EAAF8,#5EAAF8,#5EAAF8,#5EAAF8', '1', '1', '1', 49, 761, 'Iced Angle', 'Cool cornering for you!', 3),
(762, 'chair_norja*7', 2, 1, 1, 1.00, '#ffffff,#ffffff,#7CB135,#7CB135', '0', '1', '1', 49, 762, 'Chair', 'Sleek and chic for each cheek', 3),
(763, 'couch_norja*7', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#7CB135,#7CB135,#7CB135,#7CB135', '0', '1', '1', 49, 763, 'Bench', 'Two can perch comfortably', 3),
(764, 'table_norja_med*7', 1, 2, 2, 0.90, '#ffffff,#7CB135', '0', '1', '1', 49, 764, 'Coffee Table', 'Elegance embodied', 3),
(765, 'shelves_norja*7', 1, 1, 1, 0.00, '#ffffff,#7CB135', '0', '1', '1', 49, 765, 'Bookcase', 'For nic naks and art deco books', 3),
(766, 'soft_sofachair_norja*7', 2, 1, 1, 1.00, '#ffffff,#7CB135,#7CB135', '0', '1', '1', 49, 766, 'iced sofachair', 'Soft iced sofachair', 3),
(767, 'soft_sofa_norja*7', 2, 2, 1, 1.00, '#ffffff,#7CB135,#ffffff,#7CB135,#7CB135,#7CB135', '0', '1', '1', 49, 767, 'iced sofa', 'A soft iced sofa', 4),
(768, 'divider_nor2*7', 1, 2, 1, 0.00, '#ffffff,#ffffff,#7CB135,#7CB135', '0', '1', '1', 49, 768, 'Ice Bar-Desk', 'Strong, yet soft looking', 3),
(769, 'divider_nor1*7', 1, 1, 1, 0.00, '#ffffff,#7CB135', '0', '1', '1', 49, 769, 'Ice Corner', 'Looks squishy, but isn\'t', 3),
(770, 'divider_nor3*7', 1, 1, 1, 0.00, '#ffffff,#ffffff,#7CB135,#7CB135', '1', '1', '1', 49, 770, 'Door (Lockable)', 'Do go through...', 6),
(771, 'divider_nor4*7', 1, 2, 1, 0.00, '#ffffff,#ffffff,#7CB135,#7CB135,#7CB135,#7CB135', '1', '1', '1', 49, 771, 'Iced Auto Shutter', 'Habbos, roll out!', 3),
(772, 'divider_nor5*7', 1, 1, 1, 0.00, '#ffffff,#7CB135,#7CB135,#7CB135,#7CB135,#7CB135', '1', '1', '1', 49, 772, 'Iced Angle', 'Cool cornering for you!', 3),
(773, 'chair_norja*8', 2, 1, 1, 1.00, '#ffffff,#ffffff,#FFD837,#FFD837', '0', '1', '1', 49, 773, 'Chair', 'Sleek and chic for each cheek', 3),
(774, 'couch_norja*8', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#FFD837,#FFD837,#FFD837,#FFD837', '0', '1', '1', 49, 774, 'Bench', 'Two can perch comfortably', 3),
(775, 'table_norja_med*8', 1, 2, 2, 0.90, '#ffffff,#FFD837', '0', '1', '1', 49, 775, 'Coffee Table', 'Elegance embodied', 3),
(776, 'shelves_norja*8', 1, 1, 1, 0.00, '#ffffff,#FFD837', '0', '1', '1', 49, 776, 'Bookcase', 'For nic naks and art deco books', 3),
(777, 'soft_sofachair_norja*8', 2, 1, 1, 1.00, '#ffffff,#FFD837,#FFD837', '0', '1', '1', 49, 777, 'iced sofachair', 'Soft iced sofachair', 3),
(778, 'soft_sofa_norja*8', 2, 2, 1, 1.00, '#ffffff,#FFD837,#ffffff,#FFD837,#FFD837,#FFD837', '0', '1', '1', 49, 778, 'iced sofa', 'A soft iced sofa', 4),
(779, 'divider_nor2*8', 1, 2, 1, 0.00, '#ffffff,#ffffff,#FFD837,#FFD837', '0', '1', '1', 49, 779, 'Ice Bar-Desk', 'Strong, yet soft looking', 3),
(780, 'divider_nor1*8', 1, 1, 1, 0.00, '#ffffff,#FFD837', '0', '1', '1', 49, 780, 'Ice Corner', 'Looks squishy, but isn\'t', 3),
(781, 'divider_nor3*8', 1, 1, 1, 0.00, '#ffffff,#ffffff,#FFD837,#FFD837', '1', '1', '1', 49, 781, 'Door (Lockable)', 'Do go through...', 6),
(782, 'divider_nor4*8', 1, 2, 1, 0.00, '#ffffff,#ffffff,#FFD837,#FFD837,#FFD837,#FFD837', '1', '1', '1', 49, 782, 'Iced Auto Shutter', 'Habbos, roll out!', 3),
(783, 'divider_nor5*8', 1, 1, 1, 0.00, '#ffffff,#FFD837,#FFD837,#FFD837,#FFD837,#FFD837', '1', '1', '1', 49, 783, 'Iced Angle', 'Cool cornering for you!', 3),
(784, 'chair_norja*9', 2, 1, 1, 1.00, '#ffffff,#ffffff,#E14218,#E14218', '0', '1', '1', 49, 784, 'Chair', 'Sleek and chic for each cheek', 3),
(785, 'couch_norja*9', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#E14218,#E14218,#E14218,#E14218', '0', '1', '1', 49, 785, 'Bench', 'Two can perch comfortably', 3),
(786, 'table_norja_med*9', 1, 2, 2, 0.90, '#ffffff,#E14218', '0', '1', '1', 49, 786, 'Coffee Table', 'Elegance embodied', 3),
(787, 'shelves_norja*9', 1, 1, 1, 0.00, '#ffffff,#E14218', '0', '1', '1', 49, 787, 'Bookcase', 'For nic naks and art deco books', 3),
(788, 'soft_sofachair_norja*9', 2, 1, 1, 1.00, '#ffffff,#E14218,#E14218', '0', '1', '1', 49, 788, 'iced sofachair', 'Soft iced sofachair', 3),
(789, 'soft_sofa_norja*9', 2, 2, 1, 1.00, '#ffffff,#E14218,#ffffff,#E14218,#E14218,#E14218', '0', '1', '1', 49, 789, 'iced sofa', 'A soft iced sofa', 4),
(790, 'divider_nor2*9', 1, 2, 1, 0.00, '#ffffff,#ffffff,#E14218,#E14218', '0', '1', '1', 49, 790, 'Ice Bar-Desk', 'Strong, yet soft looking', 3),
(791, 'divider_nor1*9', 1, 1, 1, 0.00, '#ffffff,#E14218', '0', '1', '1', 49, 791, 'Ice Corner', 'Looks squishy, but isn\'t', 3),
(792, 'divider_nor3*9', 1, 1, 1, 0.00, '#ffffff,#ffffff,#E14218,#E14218', '1', '1', '1', 49, 792, 'Door (Lockable)', 'Do go through...', 6),
(793, 'divider_nor4*9', 1, 2, 1, 0.00, '#ffffff,#ffffff,#E14218,#E14218,#E14218,#E14218', '1', '1', '1', 49, 793, 'Iced Auto Shutter', 'Habbos, roll out!', 3),
(794, 'divider_nor5*9', 1, 1, 1, 0.00, '#ffffff,#E14218,#E14218,#E14218,#E14218,#E14218', '1', '1', '1', 49, 794, 'Iced Angle', 'Cool cornering for you!', 3),
(795, 'bed_polyfon*2', 3, 2, 3, 2.00, '#ffffff,#ffffff,#525252,#525252', '0', '1', '1', 50, 795, 'Double Bed', 'Give yourself space to stretch out', 4);
INSERT INTO `catalogue_items` (`tid`, `name_cct`, `typeid`, `length`, `width`, `top`, `colour`, `door`, `tradeable`, `recycleable`, `catalogue_id_page`, `catalogue_id_index`, `catalogue_name`, `catalogue_description`, `catalogue_cost`) VALUES
(796, 'bed_polyfon_one*2', 3, 1, 3, 2.00, '#ffffff,#ffffff,#ffffff,#525252,#525252', '0', '1', '1', 50, 796, 'Single Bed', 'Cot of the artistic', 3),
(797, 'sofa_polyfon*2', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#525252,#525252,#525252,#525252', '0', '1', '1', 50, 797, 'Two-seater Sofa', 'Comfort for stylish couples', 4),
(798, 'sofachair_polyfon*2', 2, 1, 1, 1.00, '#ffffff,#ffffff,#525252,#525252', '0', '1', '1', 50, 798, 'Armchair', 'Loft-style comfort', 3),
(799, 'divider_poly3*2', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#525252,#525252', '1', '1', '1', 50, 799, 'Hatch (Lockable)', 'All bars should have one', 6),
(800, 'bardesk_polyfon*2', 1, 2, 1, 1.00, '#ffffff,#ffffff,#525252,#525252', '0', '1', '1', 50, 800, 'Bar/desk', 'Perfect for work or play', 3),
(801, 'bardeskcorner_polyfon*2', 1, 1, 1, 1.00, '#ffffff,#525252', '0', '1', '1', 50, 801, 'Corner Cabinet/Desk', 'Tuck it away', 3),
(802, 'bed_polyfon*3', 3, 2, 3, 2.00, '#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 50, 802, 'Double Bed', 'Give yourself space to stretch out', 4),
(803, 'bed_polyfon_one*3', 3, 1, 3, 2.00, '#ffffff,#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 50, 803, 'Single Bed', 'Cot of the artistic', 3),
(804, 'sofa_polyfon*3', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 50, 804, 'Two-seater Sofa', 'Comfort for stylish couples', 4),
(805, 'sofachair_polyfon*3', 2, 1, 1, 1.00, '#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 50, 805, 'Armchair', 'Loft-style comfort', 3),
(806, 'divider_poly3*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#ffffff,#ffffff', '1', '1', '1', 50, 806, 'Hatch (Lockable)', 'All bars should have one', 6),
(807, 'bardesk_polyfon*3', 1, 2, 1, 1.00, '#ffffff,#ffffff,#ffffff,#ffffff', '0', '1', '1', 50, 807, 'Bar/desk', 'Perfect for work or play', 3),
(808, 'bardeskcorner_polyfon*3', 1, 1, 1, 1.00, '#ffffff,#ffffff', '0', '1', '1', 50, 808, 'Corner Cabinet/Desk', 'Tuck it away', 3),
(809, 'bed_polyfon*4', 3, 2, 3, 2.00, '#ffffff,#ffffff,#F7EBBC,#F7EBBC', '0', '1', '1', 50, 809, 'Double Bed', 'Give yourself space to stretch out', 4),
(810, 'bed_polyfon_one*4', 3, 1, 3, 2.00, '#ffffff,#ffffff,#ffffff,#F7EBBC,#F7EBBC', '0', '1', '1', 50, 810, 'Single Bed', 'Cot of the artistic', 3),
(811, 'sofa_polyfon*4', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#F7EBBC,#F7EBBC,#F7EBBC,#F7EBBC', '0', '1', '1', 50, 811, 'Two-seater Sofa', 'Comfort for stylish couples', 4),
(812, 'sofachair_polyfon*4', 2, 1, 1, 1.00, '#ffffff,#ffffff,#F7EBBC,#F7EBBC', '0', '1', '1', 50, 812, 'Armchair', 'Loft-style comfort', 3),
(813, 'divider_poly3*4', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#F7EBBC,#F7EBBC', '1', '1', '1', 50, 813, 'Hatch (Lockable)', 'All bars should have one', 6),
(814, 'bardesk_polyfon*4', 1, 2, 1, 1.00, '#ffffff,#ffffff,#F7EBBC,#F7EBBC', '0', '1', '1', 50, 814, 'Bar/desk', 'Perfect for work or play', 3),
(815, 'bardeskcorner_polyfon*4', 1, 1, 1, 1.00, '#ffffff,#F7EBBC', '0', '1', '1', 50, 815, 'Corner Cabinet/Desk', 'Tuck it away', 3),
(816, 'bed_polyfon*6', 3, 2, 3, 2.00, '#ffffff,#ffffff,#5EAAF8,#5EAAF8', '0', '1', '1', 50, 816, 'Double Bed', 'Give yourself space to stretch out', 4),
(817, 'bed_polyfon_one*6', 3, 1, 3, 2.00, '#ffffff,#ffffff,#ffffff,#5EAAF8,#5EAAF8', '0', '1', '1', 50, 817, 'Single Bed', 'Cot of the artistic', 3),
(818, 'sofa_polyfon*6', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#5EAAF8,#5EAAF8,#5EAAF8,#5EAAF8', '0', '1', '1', 50, 818, 'Two-seater Sofa', 'Comfort for stylish couples', 4),
(819, 'sofachair_polyfon*6', 2, 1, 1, 1.00, '#ffffff,#ffffff,#5EAAF8,#5EAAF8', '0', '1', '1', 50, 819, 'Armchair', 'Loft-style comfort', 3),
(820, 'divider_poly3*6', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#5EAAF8,#5EAAF8', '1', '1', '1', 50, 820, 'Hatch (Lockable)', 'All bars should have one', 6),
(821, 'bardesk_polyfon*6', 1, 2, 1, 1.00, '#ffffff,#ffffff,#5EAAF8,#5EAAF8', '0', '1', '1', 50, 821, 'Bar/desk', 'Perfect for work or play', 3),
(822, 'bardeskcorner_polyfon*6', 1, 1, 1, 1.00, '#ffffff,#5EAAF8', '0', '1', '1', 50, 822, 'Corner Cabinet/Desk', 'Tuck it away', 3),
(823, 'bed_polyfon*7', 3, 2, 3, 2.00, '#ffffff,#ffffff,#7CB135,#7CB135', '0', '1', '1', 50, 823, 'Double Bed', 'Give yourself space to stretch out', 4),
(824, 'bed_polyfon_one*7', 3, 1, 3, 2.00, '#ffffff,#ffffff,#ffffff,#7CB135,#7CB135', '0', '1', '1', 50, 824, 'Single Bed', 'Cot of the artistic', 3),
(825, 'sofa_polyfon*7', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#7CB135,#7CB135,#7CB135,#7CB135', '0', '1', '1', 50, 825, 'Two-seater Sofa', 'Comfort for stylish couples', 4),
(826, 'sofachair_polyfon*7', 2, 1, 1, 1.00, '#ffffff,#ffffff,#7CB135,#7CB135', '0', '1', '1', 50, 826, 'Armchair', 'Loft-style comfort', 3),
(827, 'divider_poly3*7', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#7CB135,#7CB135', '1', '1', '1', 50, 827, 'Hatch (Lockable)', 'All bars should have one', 6),
(828, 'bardesk_polyfon*7', 1, 2, 1, 1.00, '#ffffff,#ffffff,#7CB135,#7CB135', '0', '1', '1', 50, 828, 'Bar/desk', 'Perfect for work or play', 3),
(829, 'bardeskcorner_polyfon*7', 1, 1, 1, 1.00, '#ffffff,#7CB135', '0', '1', '1', 50, 829, 'Corner Cabinet/Desk', 'Tuck it away', 3),
(830, 'bed_polyfon*8', 3, 2, 3, 2.00, '#ffffff,#ffffff,#FFD837,#FFD837', '0', '1', '1', 50, 830, 'Double Bed', 'Give yourself space to stretch out', 4),
(831, 'bed_polyfon_one*8', 3, 1, 3, 2.00, '#ffffff,#ffffff,#ffffff,#FFD837,#FFD837', '0', '1', '1', 50, 831, 'Single Bed', 'Cot of the artistic', 3),
(832, 'sofa_polyfon*8', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#FFD837,#FFD837,#FFD837,#FFD837', '0', '1', '1', 50, 832, 'Two-seater Sofa', 'Comfort for stylish couples', 4),
(833, 'sofachair_polyfon*8', 2, 1, 1, 1.00, '#ffffff,#ffffff,#FFD837,#FFD837', '0', '1', '1', 50, 833, 'Armchair', 'Loft-style comfort', 3),
(834, 'divider_poly3*8', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#FFD837,#FFD837', '1', '1', '1', 50, 834, 'Hatch (Lockable)', 'All bars should have one', 6),
(835, 'bardesk_polyfon*8', 1, 2, 1, 1.00, '#ffffff,#ffffff,#FFD837,#FFD837', '0', '1', '1', 50, 835, 'Bar/desk', 'Perfect for work or play', 3),
(836, 'bardeskcorner_polyfon*8', 1, 1, 1, 1.00, '#ffffff,#FFD837', '0', '1', '1', 50, 836, 'Corner Cabinet/Desk', 'Tuck it away', 3),
(837, 'bed_polyfon*9', 3, 2, 3, 2.00, '#ffffff,#ffffff,#E14218,#E14218', '0', '1', '1', 50, 837, 'Double Bed', 'Give yourself space to stretch out', 4),
(838, 'bed_polyfon_one*9', 3, 1, 3, 2.00, '#ffffff,#ffffff,#ffffff,#E14218,#E14218', '0', '1', '1', 50, 838, 'Single Bed', 'Cot of the artistic', 3),
(839, 'sofa_polyfon*9', 2, 2, 1, 1.10, '#ffffff,#ffffff,#ffffff,#ffffff,#E14218,#E14218,#E14218,#E14218', '0', '1', '1', 50, 839, 'Two-seater Sofa', 'Comfort for stylish couples', 4),
(840, 'sofachair_polyfon*9', 2, 1, 1, 1.00, '#ffffff,#ffffff,#E14218,#E14218', '0', '1', '1', 50, 840, 'Armchair', 'Loft-style comfort', 3),
(841, 'divider_poly3*9', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#E14218,#E14218', '1', '1', '1', 50, 841, 'Hatch (Lockable)', 'All bars should have one', 6),
(842, 'bardesk_polyfon*9', 1, 2, 1, 1.00, '#ffffff,#ffffff,#E14218,#E14218', '0', '1', '1', 50, 842, 'Bar/desk', 'Perfect for work or play', 3),
(843, 'bardeskcorner_polyfon*9', 1, 1, 1, 1.00, '#ffffff,#E14218', '0', '1', '1', 50, 843, 'Corner Cabinet/Desk', 'Tuck it away', 3),
(844, 'pura_mdl1*1', 2, 1, 1, 1.00, '#FFFFFF,#ABD0D2,#ABD0D2,#FFFFFF', '0', '1', '1', 51, 844, 'Aqua Pura module 1', 'Endless fun!', 2),
(845, 'pura_mdl2*1', 2, 1, 1, 1.00, '#FFFFFF,#ABD0D2,#ABD0D2,#FFFFFF', '0', '1', '1', 51, 845, 'Aqua Pura module 2', 'Endless fun!', 2),
(846, 'pura_mdl3*1', 2, 1, 1, 1.00, '#FFFFFF,#ABD0D2,#ABD0D2,#FFFFFF', '0', '1', '1', 51, 846, 'Aqua Pura module 3', 'Endless fun!', 2),
(847, 'pura_mdl4*1', 2, 1, 1, 1.00, '#FFFFFF,#ABD0D2,#ABD0D2,#ABD0D2', '0', '1', '1', 51, 847, 'Aqua Pura module 4', 'Endless fun!', 2),
(848, 'pura_mdl5*1', 2, 1, 1, 1.00, '#FFFFFF,#ABD0D2,#FFFFFF', '0', '1', '1', 51, 848, 'Aqua Pura module 5', 'Endless fun!', 1),
(849, 'pura_mdl1*2', 2, 1, 1, 1.00, '#FFFFFF,#FF99BC,#FF99BC,#FFFFFF', '0', '1', '1', 51, 849, 'Pink Pura module 1', 'Endless fun!', 2),
(850, 'pura_mdl2*2', 2, 1, 1, 1.00, '#FFFFFF,#FF99BC,#FF99BC,#FFFFFF', '0', '1', '1', 51, 850, 'Pink Pura module 2', 'Endless fun!', 2),
(851, 'pura_mdl3*2', 2, 1, 1, 1.00, '#FFFFFF,#FF99BC,#FF99BC,#FFFFFF', '0', '1', '1', 51, 851, 'Pink Pura module 3', 'Endless fun!', 2),
(852, 'pura_mdl4*2', 2, 1, 1, 1.00, '#FFFFFF,#FF99BC,#FF99BC,#FF99BC', '0', '1', '1', 51, 852, 'Pink Pura module 4', 'Endless fun!', 2),
(853, 'pura_mdl5*2', 2, 1, 1, 1.00, '#FFFFFF,#FF99BC,#FF99BC,#FFFFFF', '0', '1', '1', 51, 853, 'Pink Pura module 5', 'Endless fun!', 1),
(854, 'pura_mdl1*3', 2, 1, 1, 1.00, '#FFFFFF,#525252,#525252,#FFFFFF', '0', '1', '1', 51, 854, 'Black Pura module 1', 'Endless fun!', 2),
(855, 'pura_mdl2*3', 2, 1, 1, 1.00, '#FFFFFF,#525252,#525252,#FFFFFF', '0', '1', '1', 51, 855, 'Black Pura module 2', 'Endless fun!', 2),
(856, 'pura_mdl3*3', 2, 1, 1, 1.00, '#FFFFFF,#525252,#525252,#FFFFFF', '0', '1', '1', 51, 856, 'Black Pura module 3', 'Endless fun!', 2),
(857, 'pura_mdl4*3', 2, 1, 1, 1.00, '#FFFFFF,#525252,#525252,#525252', '0', '1', '1', 51, 857, 'Black Pura module 4', 'Endless fun!', 2),
(858, 'pura_mdl5*3', 2, 1, 1, 1.00, '#FFFFFF,#525252,#525252,#FFFFFF', '0', '1', '1', 51, 858, 'Black Pura module 5', 'Endless fun!', 1),
(859, 'pura_mdl1*4', 2, 1, 1, 1.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 51, 859, 'White Pura module 1', 'Endless fun!', 2),
(860, 'pura_mdl2*4', 2, 1, 1, 1.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 51, 860, 'White Pura module 2', 'Endless fun!', 2),
(861, 'pura_mdl3*4', 2, 1, 1, 1.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 51, 861, 'White Pura module 3', 'Endless fun!', 2),
(862, 'pura_mdl4*4', 2, 1, 1, 1.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 51, 862, 'White Pura module 4', 'Endless fun!', 2),
(863, 'pura_mdl5*4', 2, 1, 1, 1.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 51, 863, 'White Pura module 5', 'Endless fun!', 1),
(864, 'pura_mdl1*5', 2, 1, 1, 1.00, '#FFFFFF,#F7EBBC,#F7EBBC,#FFFFFF', '0', '1', '1', 51, 864, 'Beige Pura module 1', 'Endless fun!', 2),
(865, 'pura_mdl2*5', 2, 1, 1, 1.00, '#FFFFFF,#F7EBBC,#F7EBBC,#FFFFFF', '0', '1', '1', 51, 865, 'Beige Pura module 2', 'Endless fun!', 2),
(866, 'pura_mdl3*5', 2, 1, 1, 1.00, '#FFFFFF,#F7EBBC,#F7EBBC,#FFFFFF', '0', '1', '1', 51, 866, 'Beige Pura module 3', 'Endless fun!', 2),
(867, 'pura_mdl4*5', 2, 1, 1, 1.00, '#FFFFFF,#F7EBBC,#F7EBBC,#F7EBBC', '0', '1', '1', 51, 867, 'Beige Pura module 4', 'Endless fun!', 2),
(868, 'pura_mdl5*5', 2, 1, 1, 1.00, '#FFFFFF,#F7EBBC,#F7EBBC,#FFFFFF', '0', '1', '1', 51, 868, 'Beige Pura module 5', 'Endless fun!', 1),
(869, 'pura_mdl1*6', 2, 1, 1, 1.00, '#FFFFFF,#5EAAF8,#5EAAF8,#FFFFFF', '0', '1', '1', 51, 869, 'Blue Pura module 1', 'Endless fun!', 2),
(870, 'pura_mdl2*6', 2, 1, 1, 1.00, '#FFFFFF,#5EAAF8,#5EAAF8,#FFFFFF', '0', '1', '1', 51, 870, 'Blue Pura module 2', 'Endless fun!', 2),
(871, 'pura_mdl3*6', 2, 1, 1, 1.00, '#FFFFFF,#5EAAF8,#5EAAF8,#FFFFFF', '0', '1', '1', 51, 871, 'Blue Pura module 3', 'Endless fun!', 2),
(872, 'pura_mdl4*6', 2, 1, 1, 1.00, '#FFFFFF,#5EAAF8,#5EAAF8,#5EAAF8', '0', '1', '1', 51, 872, 'Blue Pura module 4', 'Endless fun!', 2),
(873, 'pura_mdl5*6', 2, 1, 1, 1.00, '#FFFFFF,#5EAAF8,#5EAAF8,#FFFFFF', '0', '1', '1', 51, 873, 'Blue Pura module 5', 'Endless fun!', 1),
(874, 'pura_mdl1*7', 2, 1, 1, 1.00, '#FFFFFF,#92D13D,#92D13D,#FFFFFF', '0', '1', '1', 51, 874, 'Green Pura module 1', 'Endless fun!', 2),
(875, 'pura_mdl2*7', 2, 1, 1, 1.00, '#FFFFFF,#92D13D,#92D13D,#FFFFFF', '0', '1', '1', 51, 875, 'Green Pura module 2', 'Endless fun!', 2),
(876, 'pura_mdl3*7', 2, 1, 1, 1.00, '#FFFFFF,#92D13D,#92D13D,#FFFFFF', '0', '1', '1', 51, 876, 'Green Pura module 3', 'Endless fun!', 2),
(877, 'pura_mdl4*7', 2, 1, 1, 1.00, '#FFFFFF,#92D13D,#92D13D,#92D13D', '0', '1', '1', 51, 877, 'Green Pura module 4', 'Endless fun!', 2),
(878, 'pura_mdl5*7', 2, 1, 1, 1.00, '#FFFFFF,#92D13D,#92D13D,#FFFFFF', '0', '1', '1', 51, 878, 'Green Pura module 5', 'Endless fun!', 1),
(879, 'pura_mdl1*8', 2, 1, 1, 1.00, '#FFFFFF,#FFD837,#FFD837,#FFFFFF', '0', '1', '1', 51, 879, 'Yellow Pura module 1', 'Endless fun!', 2),
(880, 'pura_mdl2*8', 2, 1, 1, 1.00, '#FFFFFF,#FFD837,#FFD837,#FFFFFF', '0', '1', '1', 51, 880, 'Yellow Pura module 2', 'Endless fun!', 2),
(881, 'pura_mdl3*8', 2, 1, 1, 1.00, '#FFFFFF,#FFD837,#FFD837,#FFFFFF', '0', '1', '1', 51, 881, 'Yellow Pura module 3', 'Endless fun!', 2),
(882, 'pura_mdl4*8', 2, 1, 1, 1.00, '#FFFFFF,#FFD837,#FFD837,#FFD837', '0', '1', '1', 51, 882, 'Yellow Pura module 4', 'Endless fun!', 2),
(883, 'pura_mdl5*8', 2, 1, 1, 1.00, '#FFFFFF,#FFD837,#FFD837,#FFFFFF', '0', '1', '1', 51, 883, 'Yellow Pura module 5', 'Endless fun!', 1),
(884, 'pura_mdl1*9', 2, 1, 1, 1.00, '#FFFFFF,#E14218,#E14218,#FFFFFF', '0', '1', '1', 51, 884, 'Red Pura module 1', 'Endless fun!', 2),
(885, 'pura_mdl2*9', 2, 1, 1, 1.00, '#FFFFFF,#E14218,#E14218,#FFFFFF', '0', '1', '1', 51, 885, 'Red Pura module 2', 'Endless fun!', 2),
(886, 'pura_mdl3*9', 2, 1, 1, 1.00, '#FFFFFF,#E14218,#E14218,#FFFFFF', '0', '1', '1', 51, 886, 'Red Pura module 3', 'Endless fun!', 2),
(887, 'pura_mdl4*9', 2, 1, 1, 1.00, '#FFFFFF,#E14218,#E14218,#E14218', '0', '1', '1', 51, 887, 'Red Pura module 4', 'Endless fun!', 2),
(888, 'pura_mdl5*9', 2, 1, 1, 1.00, '#FFFFFF,#E14218,#E14218,#FFFFFF', '0', '1', '1', 51, 888, 'Red Pura module 5', 'Endless fun!', 1),
(889, 'chair_basic*1', 2, 1, 1, 1.00, '#FFFFFF,#ABD0D2,#FFFFFF', '0', '1', '1', 51, 889, 'Aqua Retro Chair', 'Sitback and relax', 5),
(890, 'chair_basic*1', 2, 1, 1, 1.00, '#FFFFFF,#FF99BC,#FFFFFF', '0', '1', '1', 51, 890, 'Pink Retro Chair', 'Sitback and relax', 5),
(891, 'chair_basic*1', 2, 1, 1, 1.00, '#FFFFFF,#525252,#FFFFFF', '0', '1', '1', 51, 891, 'Black Retro Chair', 'Sitback and relax', 5),
(892, 'chair_basic*1', 2, 1, 1, 1.00, '#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 51, 892, 'White Retro Chair', 'Sitback and relax', 5),
(893, 'chair_basic*1', 2, 1, 1, 1.00, '#FFFFFF,#F7EBBC,#FFFFFF', '0', '1', '1', 51, 893, 'Beige Retro Chair', 'Sitback and relax', 5),
(894, 'chair_basic*1', 2, 1, 1, 1.00, '#FFFFFF,#5EAAF8,#FFFFFF', '0', '1', '1', 51, 894, 'Blue Retro Chair', 'Sitback and relax', 5),
(895, 'chair_basic*1', 2, 1, 1, 1.00, '#FFFFFF,#92D13D,#FFFFFF', '0', '1', '1', 51, 895, 'Green Retro Chair', 'Sitback and relax', 5),
(896, 'chair_basic*1', 2, 1, 1, 1.00, '#FFFFFF,#FFD837,#FFFFFF', '0', '1', '1', 51, 896, 'Yellow Retro Chair', 'Sitback and relax', 5),
(897, 'chair_basic*1', 2, 1, 1, 1.00, '#FFFFFF,#E14218,#FFFFFF', '0', '1', '1', 51, 897, 'Red Retro Chair', 'Sitback and relax', 5),
(898, 'grand_piano*1', 1, 2, 2, 0.00, '#FFFFFF,#FF8B8B,#FFFFFF', '0', '1', '1', 52, 898, 'Rose Grand Piano', 'Rose Grand Piano', 10),
(899, 'romantique_pianochair*1', 2, 1, 1, 1.00, '#FFFFFF,#FF8B8B,#FFFFFF', '0', '1', '1', 52, 899, 'Rose Quartz Piano Stool', 'Here sat the legend of 1900', 2),
(900, 'romantique_chair*1', 2, 1, 1, 1.00, '#FFFFFF,#FF8B8B,#FFFFFF', '0', '1', '1', 52, 900, 'Rose Quartz Chair', 'Elegant seating for elegant Habbos', 5),
(901, 'romantique_divan*1', 2, 2, 1, 0.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FF8B8B', '0', '1', '1', 52, 901, 'Rose Romantique Divan', 'null', 6),
(902, 'romantique_divider*1', 1, 2, 1, 0.00, '#FF8B8B,#FF8B8B,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 52, 902, 'Rose Quartz Screen', 'Beauty lies within', 6),
(903, 'romantique_smalltabl*1', 1, 1, 1, 0.00, '#FFFFFF,#FF8B8B,#FFFFFF', '0', '1', '1', 52, 903, 'Rose Quartz Tray Table', 'Every tray needs a table...', 4),
(904, 'grand_piano*2', 1, 2, 2, 0.00, '#FFFFFF,#A1DC67,#FFFFFF', '0', '1', '1', 52, 904, 'Lime Grand Piano', 'Lime Grand Piano', 10),
(905, 'romantique_pianochair*2', 2, 1, 1, 1.00, '#FFFFFF,#A1DC67,#FFFFFF', '0', '1', '1', 52, 905, 'Lime Piano Chair', 'Let the music begin', 2),
(906, 'romantique_chair*2', 2, 1, 1, 1.00, '#FFFFFF,#A1DC67,#FFFFFF', '0', '1', '1', 52, 906, 'Lime Romantique Chair', 'null', 5),
(907, 'romantique_divan*2', 2, 2, 1, 0.00, '#FFFFFF,#FFFFFF,#FFFFFF,#A1DC67', '0', '1', '1', 52, 907, 'Emerald Chaise-Longue', 'Recline in continental comfort', 6),
(908, 'romantique_divider*2', 1, 2, 1, 0.00, '#A1DC67,#A1DC67,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 52, 908, 'Green Screen', 'Keeping things separated', 6),
(909, 'romantique_smalltabl*2', 1, 1, 1, 1.00, '#FFFFFF,#A1DC67,#FFFFFF', '0', '1', '1', 52, 909, 'Lime Tray Table', 'Every tray needs a table...', 4),
(910, 'grand_piano*3', 1, 2, 2, 0.00, '#FFFFFF,#5BD1D2,#FFFFFF', '0', '1', '1', 52, 910, 'Pink Grand Piano', 'Make sure you play in key!', 10),
(911, 'romantique_pianochair*3', 2, 1, 1, 1.00, '#FFFFFF,#5BD1D2,#FFFFFF', '0', '1', '1', 52, 911, 'Turquoise Piano Chair', 'null', 2),
(912, 'romantique_chair*3', 2, 1, 1, 1.00, '#FFFFFF,#5BD1D2,#FFFFFF', '0', '1', '1', 52, 912, 'Turquoise Chair', 'null', 5),
(913, 'romantique_divan*3', 2, 2, 1, 0.00, '#FFFFFF,#FFFFFF,#FFFFFF,#5BD1D2', '0', '1', '1', 52, 913, 'Turquoise Divan', 'null', 6),
(914, 'romantique_divider*3', 1, 2, 1, 0.00, '#5BD1D2,#5BD1D2,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 52, 914, 'Turquoise Screen', 'Keeping things separated', 6),
(915, 'romantique_smalltabl*3', 1, 1, 1, 1.00, '#FFFFFF,#5BD1D2,#FFFFFF', '0', '1', '1', 52, 915, 'Turquoise Tray Table', 'Every tray needs a table...', 4),
(916, 'grand_piano*4', 1, 2, 2, 0.00, '#FFFFFF,#FFC924,#FFFFFF', '0', '1', '1', 52, 916, 'Amber Grand Piano', 'Why is that key green?', 10),
(917, 'romantique_pianochair*4', 2, 1, 1, 1.00, '#FFFFFF,#FFC924,#FFFFFF', '0', '1', '1', 52, 917, 'Amber Piano Stool', 'I can feel air coming through...', 2),
(918, 'romantique_chair*4', 2, 1, 1, 1.00, '#FFFFFF,#FFC924,#FFFFFF', '0', '1', '1', 52, 918, 'Amber Chair', 'What does this button do?', 5),
(919, 'romantique_divan*4', 2, 2, 1, 0.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFC924', '0', '1', '1', 52, 919, 'Amber Chaise-Longue', 'Is that a cape hanging there?', 6),
(920, 'romantique_divider*4', 1, 2, 1, 0.00, '#FFC924,#FFC924,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 52, 920, 'Ochre Screen', 'Keeping things separated', 6),
(921, 'romantique_smalltabl*4', 1, 1, 1, 1.00, '#FFFFFF,#FFC924,#FFFFFF', '0', '1', '1', 52, 921, 'Amber Tray Table', 'Why is one leg different?', 4),
(922, 'grand_piano*5', 1, 2, 2, 0.00, '#FFFFFF,#323C46,#FFFFFF', '0', '1', '1', 52, 922, 'Onyx Grand Piano', 'Why is that key green?', 10),
(923, 'romantique_pianochair*5', 2, 1, 1, 1.00, '#FFFFFF,#323C46,#FFFFFF', '0', '1', '1', 52, 923, 'Onyx Piano Stool', 'I can feel air coming through...', 2),
(924, 'romantique_chair*5', 2, 1, 1, 1.00, '#FFFFFF,#323C46,#FFFFFF', '0', '1', '1', 52, 924, 'Onyx Chair', 'What does this button do?', 5),
(925, 'romantique_divan*5', 2, 2, 1, 0.00, '#FFFFFF,#FFFFFF,#FFFFFF,#323C46', '0', '1', '1', 52, 925, 'Onyx Chaise-Longue', 'Is that a cape hanging there?', 6),
(926, 'romantique_divider*5', 1, 2, 1, 0.00, '#323C46,#323C46,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 52, 926, 'Onyx Quartz Screen', 'Beauty lies within', 6),
(927, 'romantique_smalltabl*5', 1, 1, 1, 1.00, '#FFFFFF,#323C46,#FFFFFF', '0', '1', '1', 52, 927, 'Onyx Tray Table', 'Why is one leg different?', 4),
(928, 'club_sofa', 2, 2, 1, 1.00, '0,0,0', '0', '1', '1', 53, 928, 'Club sofa', 'Importants habbos only', 25),
(929, 'chair_plasto*14', 2, 1, 1, 1.00, '#ffffff,#3CB4F0,#ffffff,#3CB4F0', '0', '1', '1', 53, 929, 'HC chair', 'Aqua chair', 3),
(930, 'table_plasto_4leg*14', 1, 2, 2, 1.10, '#ffffff,#3CB4F0,#ffffff,#3CB4F0', '0', '1', '1', 53, 930, 'HC table', 'Aqua table', 3),
(931, 'mocchamaster', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 53, 931, 'Mochamaster', 'Wake up and smell it!', 25),
(932, 'edicehc', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 53, 932, 'Dicemaster', 'Click and roll!', 25),
(933, 'hcamme', 2, 1, 2, 1.00, '0,0,0', '0', '1', '1', 53, 933, 'Tubmaster', 'Time for a soak', 25),
(934, 'doorD', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 53, 934, 'Imperial Teleport', 'Let\'s go over tzar!', 25),
(935, 'hcsohva', 2, 2, 1, 1.00, '0,0,0', '0', '1', '1', 53, 935, 'Throne Sofa', 'For royal bottoms...', 25),
(936, 'hc_lmp', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 53, 936, 'Oil Lamp', 'Be enlightened', 25),
(937, 'hc_tbl', 1, 1, 3, 1.00, '0,0,0', '0', '1', '1', 53, 937, 'Nordic Table', 'Perfect for banquets', 25),
(938, 'hc_chr', 2, 1, 1, 1.00, '0,0,0', '0', '1', '1', 53, 938, 'Majestic Chair', 'Royal comfort', 25),
(939, 'hc_dsk', 1, 1, 2, 0.00, '0,0,0', '0', '1', '1', 53, 939, 'Study Desk', 'For Habbo scholars', 25),
(940, 'hc_trll', 1, 1, 2, 0.00, '0,0,0', '0', '1', '1', 53, 940, 'Drinks Trolley', 'For swanky dinners only', 25),
(941, 'hc_crpt', 4, 3, 5, 0.00, '0,0,0', '0', '1', '1', 53, 941, 'Persian Carpet', 'Ultimate craftsmanship', 25),
(942, 'hc_lmpst', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 53, 942, 'Victorian Street Light', 'Somber and atmospheric', 25),
(943, 'hc_crtn', 1, 2, 1, 0.00, '0,0,0', '1', '1', '1', 53, 943, 'Antique Drapery', 'Topnotch privacy protection', 25),
(944, 'hc_tv', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 53, 944, 'Mega TV Set', 'Forget plasma, go HC!', 25),
(945, 'hc_btlr', 1, 1, 1, 0.00, '0,0,0', '0', '1', '1', 53, 945, 'Electric Butler', 'Your personal caretaker', 25),
(946, 'hc_bkshlf', 1, 1, 4, 0.00, '0,0,0', '0', '1', '1', 53, 946, 'Medieval Bookcase', 'For the scholarly ones', 25),
(947, 'hc_rntgn', 1, 2, 1, 0.00, '0,0,0', '0', '1', '1', 53, 947, 'X-Ray Divider', 'Believe it or not!', 25),
(948, 'hc_machine', 1, 1, 3, 0.00, '0,0,0', '0', '1', '1', 53, 948, 'Weird Science Machine', 'By and for mad inventors', 25),
(949, 'hc_frplc', 1, 1, 3, 0.00, '0,0,0', '0', '1', '1', 53, 949, 'Heavy Duty Fireplace', 'Pixel-powered for maximum heating', 25),
(950, 'hc_djset', 1, 3, 1, 0.00, '0,0,0', '0', '1', '1', 53, 950, 'The Grammophon', 'Very old skool scratch\'n\'spin', 25),
(951, 'hc_wall_lamp', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 53, 951, 'Retro Wall Lamp', 'Tres chic!', 25),
(952, 'roomdimmer', 0, 0, 0, 0.00, '0,0,0', '0', '1', '1', 54, 952, 'Moodlight', 'Turn this off when you\'re gonna bend her over', 25),
(953, 'rare_dragonlamp*0', 1, 1, 1, 0.00, '#ffffff,#fa2d00,#fa2d00', '0', '1', '1', 55, 953, 'Fire Dragon Lamp', 'George and the...', 25),
(954, 'rare_dragonlamp*1', 1, 1, 1, 0.00, '#ffffff,#3470ff,#3470ff', '0', '1', '1', 55, 954, 'Sea Dragon Lamp', 'Out of the deep blue!', 25),
(955, 'rare_dragonlamp*2', 1, 1, 1, 0.00, '#ffffff,#02bb70,#02bb70', '0', '1', '1', 55, 955, 'Jade Dragon Lamp', 'Oriental beast of legends', 25),
(956, 'rare_dragonlamp*3', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff', '0', '1', '1', 55, 956, 'Silver Dragon Lamp', 'Scary and scorching!', 25),
(957, 'rare_dragonlamp*4', 1, 1, 1, 0.00, '#ffffff,#3e3d40,#3e3d40', '0', '1', '1', 55, 957, 'Serpent of Doom', 'Scary and scorching!', 25),
(958, 'rare_dragonlamp*5', 1, 1, 1, 0.00, '#ffffff,#589a03,#589a03', '0', '1', '1', 55, 958, 'Elf Green Dragon Lamp', 'Roast your chestnuts here!', 25),
(959, 'rare_dragonlamp*6', 1, 1, 1, 0.00, '#ffffff,#ffbc00,#ffbc00', '0', '1', '1', 55, 959, 'Gold Dragon Lamp', 'Scary and scorching!', 25),
(960, 'rare_dragonlamp*7', 1, 1, 1, 0.00, '#ffffff,#83aeff,#83aeff', '0', '1', '1', 55, 960, 'Sky Dragon Lamp', 'Scary and scorching!', 25),
(961, 'rare_dragonlamp*8', 1, 1, 1, 0.00, '#ffffff,#ff5f01,#ff5f01', '0', '1', '1', 55, 961, 'Bronze Dragon Lamp', 'Scary and scorching!', 25),
(962, 'rare_dragonlamp*9', 1, 1, 1, 0.00, '#FFFFFF,#B357FF,#B357FF', '0', '1', '1', 55, 962, 'Purple Dragon Lamp', 'Scary and scorching!', 25),
(963, 'rare_fan*0', 1, 1, 1, 0.00, '#F43100,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 963, 'Festive Fan', 'As red as Rudolph\'s nose', 25),
(964, 'rare_fan*1', 1, 1, 1, 0.00, '#3C75FF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 964, 'Blue Powered Fan', 'It\'ll blow you away!', 25),
(965, 'rare_fan*2', 1, 1, 1, 0.00, '#55CD01,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 965, 'Green Powered Fan', 'It\'ll blow you away!', 25),
(966, 'rare_fan*3', 1, 1, 1, 0.00, '#BC9BFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 966, 'Purple Powered Fan', 'It\'ll blow you away!', 25),
(967, 'rare_fan*4', 1, 1, 1, 0.00, '#e78b8b,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 967, 'SUPERLOVE Fan', 'Fanning the fires of SUPERLOVE...', 25),
(968, 'rare_fan*5', 1, 1, 1, 0.00, '#ffcc00,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 968, 'Yellow Powered Fan', 'It\'ll blow you away!', 25),
(969, 'rare_fan*6', 1, 1, 1, 0.00, '#FF8000,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 969, 'Ochre Powered Fan', 'It\'ll blow you away!', 25),
(970, 'rare_fan*7', 1, 1, 1, 0.00, '#682B00,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 970, 'Brown Powered Fan', 'It\'ll blow you away!', 25),
(971, 'rare_fan*8', 1, 1, 1, 0.00, '#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 971, 'Habbo Wind Turbine', 'Stylish, Eco-Energy!', 25),
(972, 'rare_fan*9', 1, 1, 1, 0.00, '#FF60B0,#FFFFFF,#FFFFFF,#FFFFFF', '0', '1', '1', 56, 972, 'Fucsia Powered Fan', 'It\'ll blow you away!', 25),
(973, 'rare_icecream*0', 1, 1, 1, 0.00, '#FFFFFF,#d02a1f', '0', '1', '1', 57, 973, 'Cherry Ice Cream', 'Virtual cherry rocks!', 25),
(974, 'rare_icecream*1', 1, 1, 1, 0.00, '#FFFFFF,#55c4de', '0', '1', '1', 57, 974, 'Blueberry Ice Cream', 'Virtual blueberry rocks!', 25),
(975, 'rare_icecream*2', 1, 1, 1, 0.00, '#FFFFFF,#94f718', '0', '1', '1', 57, 975, 'Pistachio Ice Cream', 'Virtual pistachio rocks!', 25),
(976, 'rare_icecream*3', 1, 1, 1, 0.00, '#FFFFFF,#B357FF', '0', '1', '1', 57, 976, 'Blackcurrant Ice Cream', 'Virtual blackcurrant rocks!', 25),
(977, 'rare_icecream*4', 1, 1, 1, 0.00, '#FFFFFF,#e78b8b', '0', '1', '1', 57, 977, 'Strawberry Ice Cream', 'Virtual strawberry rocks!', 25),
(978, 'rare_icecream*5', 1, 1, 1, 0.00, '#FFFFFF,#E1CC00', '0', '1', '1', 57, 978, 'Vanilla Ice Cream', 'Virtual vanilla rocks!', 25),
(979, 'rare_icecream*6', 1, 1, 1, 0.00, '#FFFFFF,#FF8000', '0', '1', '1', 57, 979, 'Toffee Ice Cream', 'Virtual toffee rocks!', 25),
(980, 'rare_icecream*7', 1, 1, 1, 0.00, '#FFFFFF,#97420C', '0', '1', '1', 57, 980, 'Chocolate Ice Cream', 'Virtual chocolate rocks!', 25),
(981, 'rare_icecream*8', 1, 1, 1, 0.00, '#FFFFFF,#00E5E2', '0', '1', '1', 57, 981, 'Peppermint Ice Cream', 'Virtual peppermint rocks!', 25),
(982, 'rare_icecream*9', 1, 1, 1, 0.00, '#FFFFFF,#FF60B0', '0', '1', '1', 57, 982, 'Bubblegum Ice Cream', 'Virtual bubblegum rocks!', 25),
(983, 'rubberchair*1', 2, 1, 1, 1.00, '#0080FF,0,0', '0', '1', '1', 58, 983, 'Blue Inflatable Chair', 'Soft and stylish HC chair', 25),
(984, 'rubberchair*2', 2, 1, 1, 1.00, '#FF8B8B,0,0', '0', '1', '1', 58, 984, 'Pink Inflatable Chair', 'Soft and tearproof!', 25),
(985, 'rubberchair*3', 2, 1, 1, 1.00, '#FF8000,0,0', '0', '1', '1', 58, 985, 'Orange Inflatable Chair', 'Soft and tearproof!', 25),
(986, 'rubberchair*4', 2, 1, 1, 1.00, '#00E5E2,0,0', '0', '1', '1', 58, 986, 'Ocean Inflatable Chair', 'Soft and tearproof!', 25),
(987, 'rubberchair*5', 2, 1, 1, 1.00, '#A1DC67,0,0', '0', '1', '1', 58, 987, 'Lime Inflatable Chair', 'Soft and tearproof!', 25),
(988, 'rubberchair*6', 2, 1, 1, 1.00, '#B357FF,0,0', '0', '1', '1', 58, 988, 'Violet Inflatable Chair', 'Soft and tearproof!', 25),
(989, 'rubberchair*7', 2, 1, 1, 1.00, '#CFCFCF,0,0', '0', '1', '1', 58, 989, 'White Inflatable Chair', 'Soft and tearproof!', 25),
(990, 'rubberchair*8', 2, 1, 1, 1.00, '#333333,0,0', '0', '1', '1', 58, 990, 'Black Inflatable Chair', 'Soft and tearproof for HC!', 25),
(991, 'scifiport*0', 1, 1, 1, 0.00, '#ffffff,#F43100,#ffffff,#ffffff,#ffffff,#F43100', '1', '1', '1', 59, 991, 'Red Laser Door', 'Energy beams. No trespassers!', 25),
(992, 'scifiport*1', 1, 1, 1, 0.00, '#ffffff,#ffbc00,#ffffff,#ffffff,#ffffff,#ffbc00', '1', '1', '1', 59, 992, 'Gold Laser Gate', 'Energy beams. No trespassers!', 25),
(993, 'scifiport*2', 1, 1, 1, 0.00, '#ffffff,#5599ff,#ffffff,#ffffff,#ffffff,#5599ff', '1', '1', '1', 59, 993, 'Blue Laser Gate', 'Get in the ring!', 25),
(994, 'scifiport*3', 1, 1, 1, 0.00, '#ffffff,#02bb70,#ffffff,#ffffff,#ffffff,#02bb70', '1', '1', '1', 59, 994, 'Jade Sci-Fi Port', 'Energy beams. No trespassers!', 25),
(995, 'scifiport*4', 1, 1, 1, 0.00, '#ffffff,#e78b8b,#ffffff,#ffffff,#ffffff,#e78b8b', '1', '1', '1', 59, 995, 'Pink Sci-Fi Port', 'Energy beams. No trespassers!', 25),
(996, 'scifiport*5', 1, 1, 1, 0.00, '#ffffff,#555555,#ffffff,#ffffff,#ffffff,#555555', '1', '1', '1', 59, 996, 'Security Fence', 'Recovered from Roswell', 25),
(997, 'scifiport*6', 1, 1, 1, 0.00, '#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff', '1', '1', '1', 59, 997, 'White Sci-Fi Port', 'Energy beams. No trespassers!', 25),
(998, 'scifiport*7', 1, 1, 1, 0.00, '#ffffff,#00cccc,#ffffff,#ffffff,#ffffff,#00cccc', '1', '1', '1', 59, 998, 'Turquoise Sci-Fi Port', 'Energy beams. No trespassers!', 25),
(999, 'scifiport*8', 1, 1, 1, 0.00, '#ffffff,#bb55cc,#ffffff,#ffffff,#ffffff,#bb55cc', '1', '1', '1', 59, 999, 'Purple Sci-Fi Port', 'Energy beams. No trespassers!', 25),
(1000, 'scifiport*9', 1, 1, 1, 0.00, '#ffffff,#B357FF,#ffffff,#ffffff,#ffffff,#B357FF', '1', '1', '1', 59, 1000, 'Violet Sci-Fi Port', 'Energy beams. No trespassers!', 25),
(1001, 'song_disk', 1, 1, 1, 0.20, '0,0,0', '0', '1', '1', -1, 0, '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `catalogue_pages`
--

CREATE TABLE `catalogue_pages` (
  `indexid` tinyint(3) NOT NULL,
  `minrank` tinyint(1) NOT NULL,
  `indexname` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `displayname` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `style_layout` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `img_header` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `img_side` text COLLATE latin1_general_ci DEFAULT NULL,
  `label_description` text COLLATE latin1_general_ci DEFAULT NULL,
  `label_misc` text COLLATE latin1_general_ci DEFAULT NULL,
  `label_moredetails` varchar(150) COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `catalogue_pages`
--

INSERT INTO `catalogue_pages` (`indexid`, `minrank`, `indexname`, `displayname`, `style_layout`, `img_header`, `img_side`, `label_description`, `label_misc`, `label_moredetails`) VALUES
(1, 1, 'Frontpage', 'Frontpage', 'ctlg_frontpage2', 'catal_fp_header', 'catal_fp_pic4,catal_fp_pic5,', 'Need some Furni for your Habbo room?  Well, you?re in the right place!  This Catalogue is packed FULL of funky Furni, just click the tabs on the right to browse.<br><br>We regularly add and remove Furni, so check back regularly for new items.', 's:Need some Funky Furni for your Habbo room?', 't1:You need Habbo Credits to buy Furni for your room, click the Purse at the bottom of your screen for more information about Credits.'),
(5, 1, 'no rares', 'Rare', 'ctlg_norares', 'catalog_rares_headline1', 'ctlg_norare_char1,', 'There isn\'t a rare item to buy at the moment, but it\'s coming soon! Please don\'t email us about it - we\'re keeping it secret...<br>', '', ''),
(6, 7, 'Rare', 'Rare', 'ctlg_productpage1', 'catalog_rares_headline1', '', 'It\'s Spring, and it\'s the best time to stock up on Parasols! Go get your Green Parasol Now!:', 's:Only for 2 weeks!!!', ''),
(7, 1, 'Spaces', 'Spaces', 'ctlg_spaces', 'catalog_spaces_headline1', NULL, 'Are your walls looking a little grey?  What you need is a splash of paint and this is the place to get it!  <br><br>A splash of colour on the walls and a nice carpet can make all the difference. Use our virtual room below to test out the combinations before you buy.', 't1:Wall\rt2:Floor\rt3:Pattern\rt4:Colour\rt5:Pattern\rt6:Colour\rt7:Preview', NULL),
(8, 1, 'Pets', 'Pets', 'ctlg_pets', 'catalog_pet_headline1', 'catalog_pets_teaser1,', 'Fluff, scales and whiskers, meows, snaps and woofs!  Anyone can have a pet on Habbo!  Select your new pet from our ever changing selection, just click to page two then click back, to see more pets!', 'u:Pets2', 'Adopt a Pet today!'),
(9, 1, 'Pet Accesories', 'Pet Accessories', 'ctlg_layout2', 'catalog_pet_headline2', 'ctlg_pet_teaser1,', 'You\'ll need to take care of your pet to keep it happy and healthy. This section of the Catalogue has EVERYTHING you?ll need to satisfy your pet?s needs.', 's:You\'ll have to share it!', 'Click on the item you want for more information.'),
(10, 1, 'Area', 'Area', 'ctlg_layout2', 'catalog_area_headline1', 'catalog_area_teaser1,', 'Introducing the Area Collection...  Clean, chunky lines set this collection apart as a preserve of the down-to-earth Habbo. It\'s beautiful in its simplicity, and welcoming to everyone.', 's:2: Beautiful in it\'s simplicity!', 'Click on the item you want for more information.'),
(11, 1, 'Accessories', 'Accessories', 'ctlg_layout2', 'catalog_extra_headline1', 'catalog_extra_teaser1,', 'Is your room missing something?  Well, now you can add the finishing touches that express your true personality. And don\'t forget, like everything else, these accessories can be moved about to suit your mood.', 's:2: I love my rabbit...', 'Click on the item you want for more information.'),
(12, 1, 'Asian', 'Asian', 'ctlg_layout2', 'catalog_asian_headline1', 'catalog_asian_teaser1,', 'Dit pure haandwerk uit de eeuwenoude oosterse pixeltraditie brengt balans in elk Habbointerieur. Jin en Yang vloeien samen met Feng en Shui in een uitgebalanceerde collectie meubi. ', 's:2: Oh, look there! Is Mulan the girl of Disney xD', 'Click on the item you want for more information.'),
(13, 1, 'Bathroom', 'Bathroom', 'ctlg_layout2', 'catalog_bath_headline1', 'catalog_bath_teaser1,', 'Introducing the Bathroom Collection...  Have some fun with the cheerful bathroom collection. Give yourself and your guests somewhere to freshen up - vital if you want to avoid nasty niffs. Put your loo in a corner though...', 's:2: Every Habbo needs one!', 'Click on the item you want for more information.'),
(14, 1, 'Candy', 'Candy', 'ctlg_layout2', 'catalog_candy_headline1', 'catalog_candy_teaser1,', 'Introducing the Candy Collection...  Candy combines the cool, clean lines of the Mode collection with a softer, more soothing style. It\'s urban sharpness with a hint of the feminine.', 's:2: Relax! It\'s faux-fur.', 'Click on the item you want for more information.'),
(15, 1, 'Camera', 'Camera', 'ctlg_camera1', 'catalog_camera_headline1', 'campic_cam,campic_film,', 'Take a picture and keep a record of those special moments forever.  With your Habbo camera you can take pictures of just about anything in the Hotel – Even your friend on the loo...<br><br>A Camera costs 10 Credits (TWO FREE photos  included).', '', 't1:When you\'ve used your free photos, you\'ll need to buy more… Each Film (5 photos) costs 6 Credits.  <br><br>Your Camera will show how much film you '),
(16, 1, 'Flags', 'Flags', 'ctlg_layout2', 'catalog_flags_headline1', 'catalog_flags_teaser1,', 'If you\'re feeling patriotic, get a flag to prove it. Our finest cloth flags will brighten up the dullest walls.', 's:2: Flag this section for later!', 'Click on the item you want for more information.'),
(17, 1, 'Gallery', 'Gallery', 'ctlg_layout2', 'catalog_gallery_headline1', 'catalog_posters_teaser1,', 'Adorn your walls with wondrous works of art, posters, plaques and wall hangings. We have items to suit all tastes, from kitsch to cool, traditional to modern.', 's:2: Brighten up your walls!', 'Click on the item you want for more information.'),
(18, 1, 'Glass', 'Glass', 'ctlg_layout2', 'catalog_glass_headline1', 'catalog_glass_teaser1,', 'Glass: Habbo Hotels exclusive furni line made from plexiglass, in different colors! Buy here your furni for a modern lounge!', 's:2: Oh My God, it\'s transparant!', 'Click on the item you want for more information.'),
(19, 1, 'Gothic', 'Gothic', 'ctlg_layout2', 'catalog_gothic_headline1', 'catalog_gothic_teaser1,', 'The Gothic section is full of medieval looking Furni. Check back for additions to this section as there are still some unreleased items to come!', 's:Gothic is my style.', 'Click on the item you want for more information.'),
(20, 1, 'Grunge', 'Grunge', 'ctlg_layout2', 'catalog_gru_headline1', 'catalog_gru_teaser,', 'Introducing the Grunge Range. Alternative Habbos with alternative style or rebellious students with a point to prove. The Grunge range will get your bedroom looking just the way you like it - organised, neat and tidy!', '', 'New! Flaming Barrels out now!'),
(21, 1, 'Habbo Exchange', 'Habbo Exchange', 'ctlg_layout2', 'catalog_bank_headline1', 'catalog_bank_teaser,', 'The Habbo Exchange is where you can convert your Habbo Credits into a tradable currency. You can use this tradable currency to exchange Habbo Credits for Furni!', 's:Refundable goods!', 'Click on an item to see more details'),
(22, 1, 'Habbowood', 'Habbowood', 'ctlg_layout2', 'catalog_limited_headline1', 'catalog_limited_teaser1,', 'Exclusive: the new Habbowood furni, collect them all!', 's:1: Light, Camera, Action!', 'Click on the item you want for more information.'),
(23, 1, 'Iced', 'Iced', 'ctlg_layout2', 'catalog_iced_headline1', 'catalog_iced_teaser1,', 'Introducing the Iced Collection...  For the Habbo who needs no introduction. It\'s so chic, it says everything and nothing. It\'s a blank canvas, let your imagination to run wild!', 's:2: These chairs are so comfy.', 'Click on the item you want for more information.'),
(24, 1, 'Japanese', 'Japanese', 'ctlg_layout2', 'catalog_jap_headline2', 'catalog_jap_teaser3,', 'Here you can find the new Japanese furni! Get them now!', 's:1: Brand new furni!', 'Click on the item you want for more information.'),
(25, 1, 'Lodge', 'Lodge', 'ctlg_layout2', 'catalog_lodge_headline1', 'catalog_lodge_teaser1,', 'Introducing the Lodge Collection...  Do you appreciate the beauty of wood?  For that ski lodge effect, or to match that open fire... Lodge is the Furni of choice for Habbos with that no frills approach to decorating.  <br>', 's:2: I LOVE this wood Furni!', 'Click on the item you want for more information.'),
(26, 1, 'Mode', 'Mode', 'ctlg_layout2', 'catalog_mode_headline1', 'catalog_mode_teaser1,', 'Introducing the Mode Collection...  Steely grey functionality combined with sleek designer upholstery. The Habbo that chooses this furniture is a cool urban cat - streetwise, sassy and so slightly untouchable.', 's:2: So shiny and new...', 'Click on the item you want for more information.'),
(27, 1, 'Offers', 'Offers', 'ctlg_layout2', 'catalog_deals_headline1', 'catalog_deals_teaser1,', 'Special Offers are great if you?re just starting out. Take a look at our special collections, all at a great price.<br><br>Check them out!', '', 'Click on a deal to find out what\'s included and how much it costs.'),
(28, 1, 'Plants', 'Plants', 'ctlg_layout2', 'catalog_plants_headline1', 'catalog_plants_teaser1,', 'New, never before seen Bulrush Plant is here for a limited time only. Buy it now!<br>Introducing the Plant Collection...  Every room needs a plant! Not only do they bring a bit of the outside inside, they also enhance the air quality!', 's:2: I am at one with the trees', 'Click on the item you want for more information.'),
(29, 1, 'Plastic', 'Plastic', 'ctlg_plasto', 'catalog_plasto_headline1', NULL, 'Introducing The Plastic Collection...  Can you feel that 1970s vibe?  Decorate with Plastic and add some colour to your life. Choose a colour that reflect your mood, or just pick your favourite shade.', 't2:Select The Colour\rs:New colours!\rt3:Preview\rt1:Choose An Item', 'Select an item and a colour and buy!'),
(30, 1, 'Presents', 'Presents', 'ctlg_presents', 'catalog_gifts_headline1', 'catalog_presents_teaser1,catalog_presents_teaser2,', 'Show your Habbo friends just how much you care and send them a gift from the Habbo Catalogue.  ANY Catalogue item can be sent as a gift to ANY Habbo, all you need is their Habbo name!', 't1:Buying an item as a gift couldn?to be simpler...  <br><br>Buy an item from the Catalogue in the normal way, but tick \'buy as a gift\'. Tell us which Habbo you want to give the gift to and we\'ll gift wrap it and deliver it straight to their hand.', ''),
(31, 1, 'Pura', 'Pura', 'ctlg_layout2', 'catalog_pura_headline1', 'catalog_pura_teaser1,', 'Introducing the Pura Collection...  This collection breathes fresh, clean air and cool tranquility. The Pura Waltzer has arrived!  Check back regularly to see  new colours of Pura on sale!', '', 'Click on the item you want for more information.'),
(32, 1, 'Recycler', 'Recycler', 'ctlg_recycler', 'catalog_recycler_headline1', NULL, NULL, '', NULL),
(33, 1, 'Rollers', 'Rollers', 'ctlg_layout2', 'catalog_roller_headline1', '', 'Move your imagination, while you move your Habbo!  Perfect for mazes, games, for keeping your queue moving or making your pet go round in circles for hours.  Available in multi-packs ? the more you buy the cheaper the Roller! Pink Rollers out now!', 's:You can fit 35 Rollers in a Guest Room!', 'Click on a Roller to see more information!'),
(34, 1, 'Romantique', 'Romantique', 'ctlg_layout2', 'catalog_romantique_headline1', 'catalog_rom_teaser,', 'The Romantique range features Grand Pianos, old antique lamps and tables. It is the ideal range for setting a warm and loving mood in your room. Spruce up your room and invite that special someone over. Now featuring the extra special COLOUR edition.', '', 'Click on the item you want for more information.'),
(35, 1, 'Rugs', 'Rugs', 'ctlg_layout2', 'catalog_rugs_headline1', 'catalog_rugs_teaser1,', 'We have rugs for all occasions.  All rugs are non-slip and washable.', 's:2: Rugs, rugs and more rugs!', 'Click on the item you want for more information.'),
(36, 1, 'Sports', 'Sports', 'ctlg_layout2', 'catalog_sports_headline1', 'catalog_sports_teaser1,', 'For the sporty habbos, here is the sports section!', NULL, 'Click on the item you want for more information.'),
(37, 1, 'Teleport', 'Teleport', 'ctlg_layout2', 'catalog_doors_headline1', 'catalog_teleports_teaser2,catalog_door_c,catalog_door_b,', 'Beam your Habbo from one room to another with one of our cunningly disguised, space age teleports. Now you can link any two rooms together! Teleports are sold in pairs, so if you trade for them, check you\'re getting a linked pair.', 's:Teleport!', 'Select an item by clicking one of the icons on the left.'),
(38, 1, 'Trax Ambient', 'Trax Ambient', 'ctlg_soundmachine', 'catalog_trx_header1', 'catalog_trx_teaser1,', 'Welcome to the Ambient Trax Store! With groovy beats and chilled out melodies, this is the section for some cool and relaxing tunes.', NULL, NULL),
(39, 1, 'Trax Dance', 'Trax Dance', 'ctlg_soundmachine', 'catalog_trx_header2', 'catalog_trx_teaser2,', 'Welcome to the Dance Trax Store! With funky beats and catchy melodies, this is the section for every clubber  to indulge in.', NULL, NULL),
(40, 1, 'Trax Rock', 'Trax Rock', 'ctlg_soundmachine', 'catalog_trx_header3', 'catalog_trx_teaser3,', 'Welcome to the Rock Trax Store! With heavy beats and rockin\' riffs, this is the section for every rock fan to experiment with.', NULL, NULL),
(41, 1, 'Trax SFX', 'Trax SFX', 'ctlg_soundmachine', 'catalog_trx_header4', 'catalog_trx_teaser4,', 'Welcome to the SFX Trax Store! With crazy sounds and weird noises, this is the section for every creative room builder  to indulge in.', NULL, NULL),
(42, 1, 'Trax Urban', 'Trax Urban', 'ctlg_soundmachine', 'catalog_trx_header5', 'catalog_trx_teaser5,', 'Welcome to the Urban Trax Store! With hip hop beats and RnB vocals, this is the section for every city bopper  to indulge in.', NULL, NULL),
(43, 1, 'Trophies', 'Trophies', 'ctlg_trophies', 'catalog_trophies_headline1', '', 'Reward your Habbo friends, or yourself with one of our fabulous glittering array of bronze, silver and gold trophies.<br><br>First choose the trophy model (click on the arrows to see all the different styles) and then the metal (click on the seal below the trophy). Type your inscription below and we\'ll engrave it on the trophy along with your name and today\'s date.', 't1:Type your inscription CAREFULLY, it\'s permanent!', NULL),
(44, 7, 'Christmas', 'Christmas', 'ctlg_layout2', 'catalog_xmas_headline1', 'catalog_xmas_teaser,', 'The Habbo Christmas catalogue has everything you need to make the perfect festive room: Trees, ducks with santa hats on, puddings and of course, Menorahs!', 's:2:Tuck into Christmas!', 'Click on an item to see a bigger version of it!'),
(45, 7, 'Easter', 'Easter', 'ctlg_layout2', 'catalog_easter_headline1', 'catalog_easter_teaser1,', '\'Egg\'cellent furni - Bouncing bunnies, fluffy chicks, choccy eggs... Yep, it\'s Easter! Celebrate with something \'eggs\'tra special from our Easter range. But hurry - it\'s not here for long this year!', 's:2: \'Egg\'-Tastic!', 'Click on an item for more details.'),
(46, 7, 'Halloween', 'Halloween', 'ctlg_layout2', 'catalog_halloween_headline1', 'catalog_halloween_teaser,', 'Yes, it\'s a spookfest! Get your boney hands on our creepy collection of ghoulish goodies. But be quick - they\'ll be gone from the Catalogue after two weeks!', 's:2:Halloween is My day!', 'Click on an item to see a bigger version of it!'),
(47, 7, 'Love', 'Love', 'ctlg_layout2', 'catalog_love_headline1', 'catalog_love_teaser1,', 'The love collection has everything to create the perfect love room, for a good price!', 's:2:Oh! Comes Valentine\'s Day!', 'Click on an item to see a bigger version of it!'),
(48, 7, 'Area Colour', 'Area Colour', 'ctlg_layout2', 'catalog_area_headline1', 'catalog_area_teaser1,', 'Introducing the Area Collection...  Clean, chunky lines set this collection apart as a preserve of the down-to-earth Habbo. It\'s beautiful in its simplicity, and welcoming to everyone.', 's:Much More Colours!!!', 'Click on the item you want for more information.'),
(49, 7, 'Iced Colour', 'Iced Colour', 'ctlg_layout2', 'catalog_iced_headline1', 'catalog_iced_teaser1,', 'Introducing the Iced Collection...  For the Habbo who needs no introduction. It\'s so chic, it says everything and nothing. It\'s a blank canvas, let your imagination to run wild!', 's:Much More Colours!!!', 'Click on the item you want for more information.'),
(50, 7, 'Mode Colour', 'Mode Colour', 'ctlg_layout2', 'catalog_mode_headline1', 'catalog_mode_teaser1,', 'Introducing the Mode Collection...  Steely grey functionality combined with sleek designer upholstery. The Habbo that chooses this furniture is a cool urban cat - streetwise, sassy and so slightly untouchable.', 's:Much More Colours!!!', 'Click on the item you want for more information.'),
(51, 7, 'Pura Colour', 'Pura Colour', 'ctlg_layout2', 'catalog_pura_headline1', 'catalog_pura_teaser1,', 'Introducing the Pura Collection...  This collection breathes fresh, clean air and cool tranquility. The Pura Waltzer has arrived!  Check back regularly to see  new colours of Pura on sale!', 's:Much More Colours!!!', 'Click on the item you want for more information.'),
(52, 7, 'Romantique Colour', 'Romantique Colour', 'ctlg_layout2', 'catalog_romantique_headline1', 'catalog_rom_teaser,', 'The Romantique range features Grand Pianos, old antique lamps and tables. It is the ideal range for setting a warm and loving mood in your room. Spruce up your room and invite that special someone over. Now featuring the extra special COLOUR edition.', 's:Much More Colours!!!', 'Click on the item you want for more information.'),
(53, 7, 'Club Furni', 'Club Furni', 'ctlg_layout2', 'catalog_club_headline1', 'catalog_hc_teaser,', 'Welcome to the club furni page. Here you can buy any club furni for just 25 credits!', 's:For Habbo Club members only!', 'Click on an item to see more details'),
(54, 7, 'Club Shop', 'Club Shop', 'ctlg_layout2', 'catalog_club_headline1', 'catalog_hc_teaser,', 'Welcome to the Brand New Habbo Club Shop, where Habbo Club members can purchase exclusive items!<br>The Furni in this section can only be purchased by Habbos who have joined Habbo Club.', 's:For Habbo Club members only!', 'Click on an item to see more details'),
(55, 7, 'Dragons', 'Dragons', 'ctlg_layout2', 'catalog_jap_headline2', 'catalog_jap_teaser3,', 'Here you can find the Power of Dragons! Get them now!', 's:1: All Colours!', 'Click on the item you want for more information.'),
(56, 7, 'Fans', 'Fans', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(57, 7, 'Ice Cream Rare', 'Ice Cream Rare', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(58, 7, 'Inflatables', 'Inflatables', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(59, 7, 'Laser Gates', 'Laser Gates', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(60, 7, 'Marquee', 'Marquee', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(61, 7, 'Monoliths', 'Monoliths', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(62, 7, 'Oriental Screen', 'Oriental Screen', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(63, 7, 'Pilars Rare', 'Pilars Rare', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(64, 7, 'Pillow Rare', 'Pillow Rare', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(65, 7, 'Smoke Machines', 'Smoke Machines', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(66, 7, 'Summer Pools', 'Summer Pools', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(67, 7, 'Rares', 'Rares', 'ctlg_layout2', 'catalog_rares_headline1', '', 'Hm... You have permission to stay here? Oh! if you don\'t have permission, please go away!!!', 's:Restricted Zone', 'Select a item, and see more details'),
(68, 7, 'Trophies Rare', 'Tropies Rare', '', '', '', '', '', ''),
(69, 7, 'Limited Edition', 'Limited Edition', 'ctlg_layout2', 'catalog_limited_headline1', 'catalog_limited_teaser1,', 'Get it while its hot.. <br><br>LIMITED EDITION FURNITURE!', '', 'For a limited time only!');

-- --------------------------------------------------------

--
-- Table structure for table `cms_alerts`
--

CREATE TABLE `cms_alerts` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `alert` text NOT NULL,
  `type` enum('1','2') NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_content`
--

CREATE TABLE `cms_content` (
  `contentkey` text NOT NULL,
  `contentvalue` text NOT NULL,
  `setting_title` text NOT NULL,
  `setting_desc` text NOT NULL,
  `fieldtype` enum('1','2','3') NOT NULL DEFAULT '1',
  `category` varchar(1) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cms_content`
--

INSERT INTO `cms_content` (`contentkey`, `contentvalue`, `setting_title`, `setting_desc`, `fieldtype`, `category`) VALUES
('credits1', 'Credits are the hotel\\\'s currency. You can use them to buy all kinds of things, from rubber ducks and sofas, to Habbo Club membership, jukeboxes and teleports.', 'Credits Content Box 1', 'The text within a content box on the credits page.', '1', '3'),
('credits2', '<img class=\\\'credits-image\\\' src=\\\'./web-gallery/album1/palmchair.gif\\\' align=\\\'left\\\' />To buy furniture or play games, you need <b>credits</b>. We provide you with free credits on registration, and if you run out, there are several ways you can earn more credits:<li>* Refer a friend to the hotel and earn credits</li><li>* Ask a staff member ingame</li><li>* Redeem a voucher if you have one</li><li>* Trade your furniture with others for credit furniture</li>', 'Credits Content Box 2', 'The text within a content box on the credits page.', '1', '3'),
('credits1-heading', 'What are credits?', 'Credits Content Box 1 Heading', 'The title (heading) of Credit Content Box 1.', '1', '3'),
('credits2-heading', 'Get credits!', 'Credit Content Box 2 Heading', 'The title (heading) of Credit Content Box 2.', '1', '3'),
('staff1', 'You can find the staff members all over the hotel -- in the public rooms, their own rooms, or that dark little corner in your room. But how can you call them if you actually need them!? Easy. If it\\\'s urgent, use the Call for Help system ingame by using the blue questionmark in the right bottom of your screen. If it isn\\\'t urgent, use the Help Tool on the website.', 'Staff Content Box 1', 'The text within a content box on the staff page (if enabled).', '1', '2'),
('staff2', 'So you want that sexy staff badge next to your name in the hotel and on the site? Do you want to join Holo Hotel\\\'s moderation team? Keep your eyes focused on this section and the news -- if we\\\'re looking for staff it will be announced there, and surely you won\\\'t miss it!', 'Staff Content Box 2', 'The text within a content box on the staff page (if enabled).', '1', '2'),
('staff1-heading', 'Need our help?', 'Staff Content Box 1 Heading', 'The title (heading) of Staff Content Box 1.', '1', '2'),
('staff2-heading', 'Joining the Team', 'Staff Content Box 2 Heading', 'The title (heading) of Staff Content Box 2.', '1', '2'),
('staff1-color', 'green', 'Staff Content Box 1 Color', 'Only valid colors defined in CSS such as \'orange\', \'blue\', etc', '3', '2'),
('staff2-color', 'green', 'Staff Content Box 2 Color', 'Only valid colors defined in CSS such as \'orange\', \'blue\', etc', '3', '2'),
('mod_staff-enabled', '1', 'Staff Module Enabled', 'This determines wether the Staff Module (staff.php) will be displayed/enabled.', '2', '2'),
('client-widescreen', '1', 'Client in Widescreen', 'This determines wether the game client should display in widescreen mode or not.', '2', '1'),
('birthday-notifications', '1', 'Birthday Notifications Enabled', 'This will determine wether a \'Happy birthday\' message will be shown on a user\'s birthday.', '2', '1'),
('allow-group-purchase', '1', 'Group Purchasing Enabled', 'This determines wether new groups can be created or not.', '2', '1'),
('forum-enabled', '1', 'Forum Enabled', 'This determines wether the Discussion Board will be shown/enabled.', '2', '4'),
('allow-guests', '1', 'Allow guests?', 'This determines wether guest mode is enabled. Guest Mode allows you to visit (parts of) your site (with limitations) without logging in.', '2', '1'),
('enable-flash-promo', '0', 'Enable Flash Promo', 'If disabled, a HTML promo will be used instead.', '2', '1');

-- --------------------------------------------------------

--
-- Table structure for table `cms_forum_posts`
--

CREATE TABLE `cms_forum_posts` (
  `id` int(11) NOT NULL,
  `threadid` int(11) NOT NULL DEFAULT 0,
  `message` text NOT NULL,
  `author` varchar(25) NOT NULL,
  `date` varchar(30) NOT NULL,
  `edit_date` varchar(30) NOT NULL,
  `edit_author` varchar(25) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_forum_threads`
--

CREATE TABLE `cms_forum_threads` (
  `id` int(4) NOT NULL,
  `type` tinyint(4) NOT NULL,
  `title` varchar(30) NOT NULL,
  `author` varchar(25) NOT NULL,
  `date` varchar(35) NOT NULL,
  `lastpost_author` varchar(25) NOT NULL,
  `lastpost_date` varchar(35) NOT NULL,
  `views` int(11) NOT NULL,
  `posts` tinyint(4) NOT NULL,
  `unix` varchar(40) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_help`
--

CREATE TABLE `cms_help` (
  `id` int(11) NOT NULL,
  `username` varchar(25) COLLATE latin1_general_ci NOT NULL,
  `ip` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `message` mediumtext COLLATE latin1_general_ci NOT NULL,
  `date` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `picked_up` enum('0','1') COLLATE latin1_general_ci NOT NULL,
  `subject` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `roomid` int(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='HoloCMS';

-- --------------------------------------------------------

--
-- Table structure for table `cms_homes_catalouge`
--

CREATE TABLE `cms_homes_catalouge` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `type` varchar(1) NOT NULL,
  `subtype` varchar(1) NOT NULL,
  `data` text NOT NULL,
  `price` int(11) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 1,
  `category` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cms_homes_catalouge`
--

INSERT INTO `cms_homes_catalouge` (`id`, `name`, `type`, `subtype`, `data`, `price`, `amount`, `category`) VALUES
(1, 'Genie Fire Head', '1', '0', 'geniefirehead', 2, 1, '19'),
(2, 'Trax SFX', '1', '0', 'trax_sfx', 1, 1, '3'),
(3, 'Trax Disco', '1', '0', 'trax_disco', 1, 1, '3'),
(4, 'Trax 8 Bit', '1', '0', 'trax_8_bit', 1, 1, '3'),
(5, 'Trax Electro', '1', '0', 'trax_electro', 1, 1, '3'),
(6, 'Trax Reggae', '1', '0', 'trax_reggae', 1, 1, '3'),
(7, 'Trax Ambient', '1', '0', 'trax_ambient', 1, 1, '3'),
(8, 'Trax Bling', '1', '0', 'trax_bling', 1, 1, '3'),
(9, 'Trax Heavy', '1', '0', 'trax_heavy', 1, 1, '3'),
(10, 'Trax Latin', '1', '0', 'trax_latin', 1, 1, '3'),
(11, 'Trax Rock', '1', '0', 'trax_rock', 1, 1, '3'),
(12, 'Animated Falling Rain', '4', '0', 'bg_rain', 3, 1, '27'),
(13, 'Notes', '3', '0', 'stickienote', 2, 5, '29'),
(14, 'Animated Blue Serpentine', '4', '0', 'bg_serpentine_darkblue', 3, 1, '27'),
(15, 'Animated Red Serpentine', '4', '0', 'bg_serpntine_darkred', 3, 1, '27'),
(16, 'Animated Brown Serpentine', '4', '0', 'bg_serpentine_1', 3, 1, '27'),
(17, 'Animated Pink Serpentine', '4', '0', 'bg_serpentine_2', 3, 1, '27'),
(18, 'Denim', '4', '0', 'bg_denim', 3, 1, '27'),
(19, 'Lace', '4', '0', 'bg_lace', 3, 1, '27'),
(20, 'Stiched', '4', '0', 'bg_stitched', 3, 1, '27'),
(21, 'Wood', '4', '0', 'bg_wood', 3, 1, '27'),
(22, 'Cork', '4', '0', 'bg_cork', 3, 1, '27'),
(23, 'Stone', '4', '0', 'bg_stone', 3, 1, '27'),
(24, 'Bricks', '4', '0', 'bg_pattern_bricks', 3, 1, '27'),
(25, 'Ruled Paper', '4', '0', 'bg_ruled_paper', 3, 1, '27'),
(26, 'Grass', '4', '0', 'bg_grass', 3, 1, '27'),
(27, 'Hotel', '4', '0', 'bg_hotel', 3, 1, '27'),
(28, 'Bubble', '4', '0', 'bg_bubble', 3, 1, '27'),
(29, 'Bobba Skulls', '4', '0', 'bg_pattern_bobbaskulls1', 3, 1, '27'),
(30, 'Deep Space', '4', '0', 'bg_pattern_space', 3, 1, '27'),
(31, 'Submarine', '4', '0', 'bg_image_submarine', 3, 1, '27'),
(32, 'Metal II', '4', '0', 'bg_metal2', 3, 1, '27'),
(33, 'Broken Glass', '4', '0', 'bg_broken_glass', 3, 1, '27'),
(34, 'Clouds', '4', '0', 'bg_pattern_clouds', 3, 1, '27'),
(35, 'Comic', '4', '0', 'bg_comic2', 3, 1, '27'),
(36, 'Floral 1', '4', '0', 'bg_pattern_floral_01', 3, 1, '27'),
(37, 'A', '1', '0', 'a', 1, 1, '5'),
(38, 'B', '1', '0', 'b_2', 1, 1, '5'),
(39, 'C', '1', '0', 'c', 1, 1, '5'),
(40, 'D', '1', '0', 'd', 1, 1, '5'),
(41, 'E', '1', '0', 'e', 1, 1, '5'),
(42, 'F', '1', '0', 'f', 1, 1, '5'),
(43, 'G', '1', '0', 'g', 1, 1, '5'),
(44, 'H', '1', '0', 'h', 1, 1, '5'),
(45, 'I', '1', '0', 'i', 1, 1, '5'),
(46, 'J', '1', '0', 'j', 1, 1, '5'),
(47, 'K', '1', '0', 'k', 1, 1, '5'),
(48, 'L', '1', '0', 'l', 1, 1, '5'),
(49, 'M', '1', '0', 'm', 1, 1, '5'),
(50, 'N', '1', '0', 'n', 1, 1, '5'),
(51, 'O', '1', '0', 'o', 1, 1, '5'),
(52, 'P', '1', '0', 'p', 1, 1, '5'),
(53, 'Q', '1', '0', 'q', 1, 1, '5'),
(54, 'R', '1', '0', 'r', 1, 1, '5'),
(55, 'S', '1', '0', 's', 1, 1, '5'),
(56, 'T', '1', '0', 't', 1, 1, '5'),
(57, 'U', '1', '0', 'u', 1, 1, '5'),
(58, 'V', '1', '0', 'v', 1, 1, '5'),
(59, 'W', '1', '0', 'w', 1, 1, '5'),
(60, 'X', '1', '0', 'x', 1, 1, '5'),
(61, 'Y', '1', '0', 'y', 1, 1, '5'),
(62, 'Z', '1', '0', 'z', 1, 1, '5'),
(63, 'Bling Star', '1', '0', 'bling_star', 1, 1, '6'),
(64, 'Bling A', '1', '0', 'bling_a', 1, 1, '6'),
(65, 'Bling B', '1', '0', 'bling_b', 1, 1, '6'),
(66, 'Bling C', '1', '0', 'bling_c', 1, 1, '6'),
(67, 'Bling D', '1', '0', 'bling_d', 1, 1, '6'),
(68, 'Bling E', '1', '0', 'bling_e', 1, 1, '6'),
(69, 'Bling F', '1', '0', 'bling_f', 1, 1, '6'),
(70, 'Bling G', '1', '0', 'bling_g', 1, 1, '6'),
(71, 'Bling H', '1', '0', 'bling_h', 1, 1, '6'),
(72, 'Bling I', '1', '0', 'bling_i', 1, 1, '6'),
(73, 'Bling J', '1', '0', 'bling_j', 1, 1, '6'),
(74, 'Bling K', '1', '0', 'bling_k', 1, 1, '6'),
(75, 'Bling L', '1', '0', 'bling_l', 1, 1, '6'),
(76, 'Bling M', '1', '0', 'bling_m', 1, 1, '6'),
(77, 'Bling N', '1', '0', 'bling_n', 1, 1, '6'),
(78, 'Bling O', '1', '0', 'bling_o', 1, 1, '6'),
(79, 'Bling P', '1', '0', 'bling_p', 1, 1, '6'),
(80, 'Bling Q', '1', '0', 'bling_q', 1, 1, '6'),
(81, 'Bling R', '1', '0', 'bling_r', 1, 1, '6'),
(82, 'Bling S', '1', '0', 'bling_s', 1, 1, '6'),
(83, 'Bling T', '1', '0', 'bling_t', 1, 1, '6'),
(84, 'Bling U', '1', '0', 'bling_u', 1, 1, '6'),
(85, 'Bling V', '1', '0', 'bling_v', 1, 1, '6'),
(86, 'Bling W', '1', '0', 'bling_w', 1, 1, '6'),
(87, 'Bling X', '1', '0', 'bling_x', 1, 1, '6'),
(88, 'Bling Y', '1', '0', 'bling_y', 1, 1, '6'),
(89, 'Bling Z', '1', '0', 'bling_z', 1, 1, '6'),
(90, 'Bling Underscore', '1', '0', 'bling_underscore', 1, 1, '6'),
(91, 'Bling Comma', '1', '0', 'bling_comma', 1, 1, '6'),
(92, 'Bling Dot', '1', '0', 'bling_dot', 1, 1, '6'),
(93, 'Bling Exclamation', '1', '0', 'bling_exclamation', 1, 1, '6'),
(94, 'Bling Question', '1', '0', 'bling_question', 1, 1, '6'),
(95, 'European Letter 3', '1', '0', 'a_with_circle', 1, 1, '5'),
(96, 'European Letter 1', '1', '0', 'a_with_dots', 1, 1, '5'),
(97, 'European Letter 2', '1', '0', 'o_with_dots', 1, 1, '5'),
(98, 'Dot', '1', '0', 'dot', 1, 1, '5'),
(99, 'Acsent 1', '1', '0', 'acsent1', 1, 1, '5'),
(100, 'Acsent 2', '1', '0', 'acsent2', 1, 1, '5'),
(101, 'Underscore', '1', '0', 'underscore', 1, 1, '5'),
(102, 'Holograph Emulator', '1', '0', 'sticker_holograph', 5, 1, '19'),
(103, 'Chain 1', '1', '0', 'chain_horizontal', 1, 1, '7'),
(104, 'Chain 2', '1', '0', 'chain_vertical', 1, 1, '7'),
(105, 'Ruler 1', '1', '0', 'ruler_horizontal', 1, 1, '7'),
(106, 'Ruler 2', '1', '0', 'ruler_vertical', 1, 1, '7'),
(107, 'Vine 1', '1', '0', 'vine', 1, 1, '7'),
(108, 'Vine 2', '1', '0', 'vine2', 1, 1, '7'),
(109, 'Leaves 1', '1', '0', 'leafs1', 1, 1, '7'),
(110, 'Leaves 2', '1', '0', 'leafs2', 1, 1, '7'),
(111, 'Zipper', '1', '0', 'sticker_zipper_v_tile', 1, 1, '7'),
(112, 'Zipper', '1', '0', 'sticker_zipper_h_tile', 1, 1, '7'),
(113, 'Zipper', '1', '0', 'sticker_zipper_h_normal_lock', 1, 1, '7'),
(114, 'Zipper', '1', '0', 'sticker_zipper_h_bobba_lock', 1, 1, '7'),
(115, 'Zipper', '1', '0', 'sticker_zipper_h_end', 1, 1, '7'),
(116, 'Zipper', '1', '0', 'sticker_zipper_v_end', 1, 1, '7'),
(117, 'Zipper', '1', '0', 'sticker_zipper_v_bobba_lock', 1, 1, '7'),
(118, 'Zipper', '1', '0', 'sticker_zipper_v_normal_lock', 1, 1, '7'),
(119, 'Wormhand', '1', '0', 'wormhand', 5, 1, '8'),
(120, 'Gentleman', '1', '0', 'sticker_gentleman', 2, 1, '8'),
(121, 'Chewed Bubblegum', '1', '0', 'chewed_bubblegum', 1, 1, '8'),
(122, 'Cactus', '1', '0', 'sticker_cactus_anim', 2, 1, '8'),
(123, 'Spaceduck', '1', '0', 'sticker_spaceduck', 1, 1, '8'),
(124, 'Moonpig', '1', '0', 'sticker_moonpig', 2, 1, '8'),
(125, 'Swimming fish', '1', '0', 'swimming_fish', 2, 1, '8'),
(126, 'Boxer', '1', '0', 'sticker_boxer', 2, 1, '8'),
(127, 'Wunder Frank', '1', '0', 'wunderfrank', 1, 1, '8'),
(128, 'Submarine', '1', '0', 'sticker_submarine', 2, 1, '8'),
(129, 'Clown', '1', '0', 'sticker_clown_anim', 2, 1, '8'),
(130, 'Stars', '1', '0', 'blingblingstars', 2, 1, '9'),
(131, 'Hearts', '1', '0', 'blinghearts', 2, 1, '9'),
(132, 'Heartbeat', '1', '0', 'sticker_heartbeat', 2, 1, '9'),
(133, 'Cat in a box', '1', '0', 'sticker_catinabox', 2, 1, '9'),
(134, 'Bear', '1', '0', 'bear', 2, 1, '9'),
(135, 'Vampire', '1', '0', 'gothic_draculacape ', 3, 1, '10'),
(136, 'Giant Evil Bunny', '1', '0', 'evil_giant_bunny', 2, 1, '10'),
(137, 'Zombie Bunny!', '1', '0', 'zombiepupu', 2, 1, '10'),
(138, 'Skelly', '1', '0', 'skeletor_001', 2, 1, '10'),
(139, 'Skull 1', '1', '0', 'skull', 2, 1, '10'),
(140, 'Skull 2', '1', '0', 'skull2', 2, 1, '10'),
(141, 'Scuba capsule', '1', '0', 'scubacapsule_anim', 2, 1, '10'),
(142, 'Bobbaskull', '1', '0', 'sticker_bobbaskull', 2, 1, '10'),
(143, 'Pack 1', '1', '0', 'sticker_flower1', 3, 5, '11'),
(144, 'Pack 2', '1', '0', 'icecube_big', 3, 10, '11'),
(145, 'Pack 3', '1', '0', 'leafs2', 5, 7, '11'),
(146, 'Pack 4', '1', '0', 'vine2', 3, 5, '11'),
(147, 'Pack 5', '1', '0', 'chain_horizontal', 3, 5, '11'),
(148, 'Pack 6', '1', '0', 'icecube_small', 3, 10, '11'),
(149, 'Arrow up', '1', '0', 'sticker_arrow_up', 2, 1, '12'),
(150, 'Arrow down', '1', '0', 'sticker_arrow_down', 2, 1, '12'),
(151, 'Arrow left', '1', '0', 'sticker_arrow_left', 2, 1, '12'),
(152, 'Arrow right', '1', '0', 'sticker_arrow_right', 2, 1, '12'),
(153, 'Ponting hand right', '1', '0', 'sticker_pointing_hand_1', 2, 1, '12'),
(154, 'Ponting hand up', '1', '0', 'sticker_pointing_hand_2', 2, 1, '12'),
(155, 'Ponting hand down', '1', '0', 'sticker_pointing_hand_3', 2, 1, '12'),
(156, 'Pointing hand left', '1', '0', 'sticker_pointing_hand_4', 2, 1, '12'),
(157, 'Nail 1', '1', '0', 'nail2', 2, 1, '12'),
(158, 'Nail 2', '1', '0', 'nail3', 2, 1, '12'),
(159, 'Red pin', '1', '0', 'needle_1', 1, 1, '12'),
(160, 'Green pin', '1', '0', 'needle_2', 1, 1, '12'),
(161, 'Blue pin', '1', '0', 'needle_3', 1, 1, '12'),
(162, 'Purple pin', '1', '0', 'needle_4', 1, 1, '12'),
(163, 'Yellow pin', '1', '0', 'needle_5', 1, 1, '12'),
(164, 'Grass Meadow', '1', '0', 'grass', 2, 1, '13'),
(165, 'Flower', '1', '0', 'sticker_flower1', 1, 1, '13'),
(166, 'Yellow Flower', '1', '0', 'sticker_flower_big_yellow', 1, 1, '13'),
(167, 'Pink Flower', '1', '0', 'sticker_flower_pink', 1, 1, '13'),
(168, 'Bobba badge', '1', '0', 'sticker_bobbaskull', 1, 1, '14'),
(169, 'Coffee badge', '1', '0', 'i_love_coffee', 1, 1, '14'),
(170, 'Bam!', '1', '0', 'sticker_effect_bam', 1, 1, '14'),
(171, 'Burp!', '1', '0', 'sticker_effect_burp', 1, 1, '14'),
(172, 'Whoosh!', '1', '0', 'sticker_effect_woosh', 1, 1, '14'),
(173, 'Zap!', '1', '0', 'sticker_effect_zap', 1, 1, '14'),
(174, 'Whoosh 2', '1', '0', 'sticker_effect_whoosh2', 1, 1, '14'),
(175, 'Small Ice Cube', '1', '0', 'icecube_small', 1, 1, '15'),
(176, 'Snowball Machine', '1', '0', 'ss_snowballmachine', 1, 1, '15'),
(177, 'Big Ice Cube', '1', '0', 'icecube_big', 1, 1, '15'),
(178, 'Boots and Gloves', '1', '0', 'bootsitjalapaset_red', 2, 1, '15'),
(179, 'Boots and Gloves', '1', '0', 'ss_bootsitjalapaset_blue', 2, 1, '15'),
(180, 'Red SnowStorm Costume', '1', '0', 'ss_costume_red', 2, 1, '15'),
(181, 'Blue SnowStorm Costume', '1', '0', 'ss_costume_blue', 2, 1, '15'),
(182, 'Splash!', '1', '0', 'ss_hits_by_snowball', 1, 1, '15'),
(183, 'SnowStorm Duck!', '1', '0', 'extra_ss_duck_left', 1, 1, '15'),
(184, 'Snowtree', '1', '0', 'ss_snowtree', 2, 1, '15'),
(185, 'SnowStorm Duck!', '1', '0', 'extra_ss_duck_right', 1, 1, '15'),
(186, 'Snowman', '1', '0', 'ss_snowman', 2, 1, '15'),
(187, 'Lumihiutale', '1', '0', 'ss_snowflake2', 1, 1, '15'),
(188, 'Snow Queen', '1', '0', 'ss_snowqueen', 2, 1, '15'),
(189, 'Battle 1', '1', '0', 'battle1', 1, 1, '16'),
(190, 'Battle 2', '1', '0', 'battle3', 1, 1, '16'),
(191, 'HC Hat', '1', '0', 'hc_hat', 5, 1, '18'),
(192, 'Left Eye', '1', '0', 'eyeleft', 2, 1, '18'),
(193, 'Right Eye', '1', '0', 'eyeright', 2, 1, '18'),
(194, 'Angel Wings', '1', '0', 'angelwings_anim', 3, 1, '18'),
(195, 'Gray Beard', '1', '0', 'sticker_gurubeard_gray', 1, 1, '18'),
(196, 'Brown Beard', '1', '0', 'sticker_gurubeard_brown', 1, 1, '18'),
(197, 'Supernerd', '1', '0', 'sticker_glasses_supernerd', 1, 1, '18'),
(198, 'Goofy Glasses', '1', '0', 'sticker_glasses_elton', 1, 1, '18'),
(199, 'Blue Eyes', '1', '0', 'sticker_eyes_blue', 1, 1, '18'),
(200, 'Animated Eyes', '1', '0', 'sticker_eye_anim', 2, 1, '18'),
(201, 'Evil Eye', '1', '0', 'sticker_eye_evil_anim', 2, 1, '18'),
(202, 'Eraser', '1', '0', 'sticker_eraser', 1, 1, '20'),
(203, 'star', '1', '0', 'star', 1, 1, '20'),
(204, 'Pencil', '1', '0', 'sticker_pencil', 1, 1, '20'),
(205, 'Dreamer', '1', '0', 'sticker_dreamer', 3, 1, '20'),
(206, 'Pencil 2', '1', '0', 'sticker_pencil_2', 1, 1, '20'),
(207, 'Lone Wolf', '1', '0', 'sticker_lonewolf', 3, 1, '20'),
(208, 'Prankster', '1', '0', 'sticker_prankster', 3, 1, '20'),
(209, 'Prankster', '1', '0', 'sticker_prankster', 3, 1, '20'),
(210, 'Romantic', '1', '0', 'sticker_romantic', 3, 1, '20'),
(211, 'Red lamp', '1', '0', 'redlamp', 2, 1, '20'),
(212, 'Lightbulb', '1', '0', 'lightbulb', 2, 1, '20'),
(213, 'Bullet hole', '1', '0', 'bullet1', 2, 1, '20'),
(214, 'Spill 1', '1', '0', 'spill1', 1, 1, '20'),
(215, 'Spill 2', '1', '0', 'spill2', 1, 1, '20'),
(216, 'Spill 3', '1', '0', 'spill3', 1, 1, '20'),
(217, 'Coffee stain', '1', '0', 'sticker_coffee_stain', 1, 1, '20'),
(218, 'Hole', '1', '0', 'sticker_hole', 1, 1, '20'),
(219, 'Flames', '1', '0', 'sticker_flames', 2, 1, '20'),
(220, 'Paperclip 1', '1', '0', 'paper_clip_1', 1, 1, '20'),
(221, 'Paperclip 2', '1', '0', 'paper_clip_2', 1, 1, '20'),
(222, 'Paperclip 3', '1', '0', 'paper_clip_3', 1, 1, '20'),
(223, 'Highlight 1', '1', '0', 'highlighter_1', 1, 1, '20'),
(224, 'Highlight', '1', '0', 'highlighter_mark5', 1, 1, '20'),
(225, 'Highlight', '1', '0', 'highlighter_mark6', 1, 1, '20'),
(226, 'Highlight', '1', '0', 'highlighter_mark4b', 1, 1, '20'),
(227, 'Highlight 2', '1', '0', 'highlighter_2', 1, 1, '20'),
(228, 'Highlight', '1', '0', 'highlighter_mark1', 1, 1, '20'),
(229, 'Highlight', '1', '0', 'highlighter_mark2', 1, 1, '20'),
(230, 'Highlight', '1', '0', 'highlighter_mark3', 1, 1, '20'),
(231, 'Plaster', '1', '0', 'plaster1', 1, 1, '20'),
(232, 'Plaster', '1', '0', 'plaster2', 1, 1, '20'),
(233, 'Croc', '1', '0', 'sticker_croco', 1, 1, '20'),
(234, 'Fish', '1', '0', 'fish', 1, 1, '20'),
(235, 'Parrot', '1', '0', 'parrot', 1, 1, '20'),
(236, 'Sleeping Holo', '1', '0', 'sticker_sleeping_habbo', 2, 1, '20'),
(237, 'Burger', '1', '0', 'burger', 1, 1, '20'),
(238, 'Juice', '1', '0', 'juice', 1, 1, '20'),
(239, 'Coffee Stain Blue', '1', '0', 'sticker_coffee_steam_blue', 1, 1, '20'),
(240, 'Coffee Stain Gray', '1', '0', 'sticker_coffee_steam_grey', 1, 1, '20'),
(241, 'Cassette 1', '1', '0', 'cassette1', 1, 1, '20'),
(242, 'Cassette 2', '1', '0', 'cassette2', 1, 1, '20'),
(243, 'Cassette 3', '1', '0', 'cassette3', 1, 1, '20'),
(244, 'Cassette 4', '1', '0', 'cassette4', 1, 1, '20'),
(245, 'Football', '1', '0', 'football', 1, 1, '20'),
(246, 'Floral 2', '4', '0', 'bg_pattern_floral_02', 2, 1, '27'),
(247, 'Floral 3', '4', '0', 'bg_pattern_floral_03', 2, 1, '27'),
(248, 'Cars', '4', '0', 'bg_pattern_cars', 2, 1, '27'),
(249, 'Carpants', '4', '0', 'bg_pattern_carpants', 2, 1, '27'),
(250, 'Plasto', '4', '0', 'bg_pattern_plasto', 2, 1, '27'),
(251, 'Tinny room', '4', '0', 'bg_pattern_tinyroom', 2, 1, '27'),
(252, 'Hearts', '4', '0', 'bg_pattern_hearts', 2, 1, '27'),
(253, 'Abstract 1', '4', '0', 'bg_pattern_abstract1', 2, 1, '27'),
(254, 'Bathroom tile', '4', '0', 'bg_bathroom_tile', 2, 1, '27'),
(255, 'Fish', '4', '0', 'bg_pattern_fish', 2, 1, '27'),
(256, 'Deepred', '4', '0', 'bg_pattern_deepred', 2, 1, '27'),
(257, 'Background', '4', '0', 'bg_colour_02', 2, 1, '27'),
(258, 'Background', '4', '0', 'bg_colour_03', 2, 1, '27'),
(259, 'Background', '4', '0', 'bg_colour_04', 2, 1, '27'),
(260, 'Background', '4', '0', 'bg_colour_05', 2, 1, '27'),
(261, 'Background', '4', '0', 'bg_colour_06', 2, 1, '27'),
(262, 'Background', '4', '0', 'bg_colour_07', 2, 1, '27'),
(263, 'Background', '4', '0', 'bg_colour_08', 2, 1, '27'),
(264, 'Background', '4', '0', 'bg_colour_09', 2, 1, '27'),
(265, 'Background', '4', '0', 'bg_colour_10', 2, 1, '27'),
(266, 'Background', '4', '0', 'bg_colour_11', 2, 1, '27'),
(267, 'Background', '4', '0', 'bg_colour_12', 2, 1, '27'),
(268, 'Background', '4', '0', 'bg_colour_13', 2, 1, '27'),
(269, 'Background', '4', '0', 'bg_colour_14', 2, 1, '27'),
(270, 'Background', '4', '0', 'bg_colour_15', 2, 1, '27'),
(271, 'Background', '4', '0', 'bg_colour_17', 2, 1, '27'),
(272, 'Tonga', '4', '0', 'bg_tonga', 2, 1, '27'),
(273, 'HoloCMS', '1', '0', 'sticker_holocms', 5, 1, '19'),
(274, 'Pedobear Seal of Approval', '1', '0', 'sticker_pedo', 50, 1, '19'),
(275, 'Alhambra Group Background', '4', '0', 'alhambragroup', 0, 1, '50'),
(276, 'Themepark Background 1', '4', '0', 'themepark_bg_01', 0, 1, '50'),
(277, 'Themepark Background 2', '4', '0', 'themepark_bg_02', 0, 1, '50'),
(278, 'Unofficial Fansites Background', '4', '0', 'bg_unofficial_fansites', 0, 1, '50'),
(279, 'Unofficial Fansites Background 2', '4', '0', 'bg_official_fansites2', 0, 1, '50'),
(280, 'Welcoming Party Background', '4', '0', 'welcoming_party', 0, 1, '50'),
(281, 'Random Habbos Background', '4', '0', 'random_habbos', 0, 1, '50'),
(282, 'Habborella Sea Background', '4', '0', 'habborella_sea_bg', 0, 1, '50'),
(283, 'Penelope Background', '4', '0', 'penelope', 0, 1, '50'),
(284, 'Orca Background', '4', '0', 'orca', 0, 1, '50'),
(285, 'sttriniansgroup Background', '4', '0', 'sttriniansgroup', 0, 1, '50'),
(286, 'sttriniansblackboard Background', '4', '0', 'sttriniansblackboard', 0, 1, '50'),
(287, 'Habbo X Background', '4', '0', 'habbox', 0, 1, '50'),
(288, 'Christmas 2007 BG 1', '4', '0', 'christmas2007bg_001', 0, 1, '50'),
(289, 'Kerrang Background 2', '4', '0', 'bg_kerrang2', 0, 1, '50'),
(291, 'VoiceOfTeens Background', '4', '0', 'bg_voiceofteens', 0, 1, '50'),
(292, 'Makeover Background', '4', '0', 'makeover', 0, 1, '50'),
(293, 'SnowStorm Background', '4', '0', 'snowstorm_bg', 0, 1, '50'),
(294, 'Habbo Group Background', '4', '0', 'habbogroup', 0, 1, '50'),
(295, 'Wobble Squabble Background', '4', '0', 'bg_wobble_squabble', 0, 1, '50'),
(296, 'VIP Background', '4', '0', 'bg_vip', 0, 1, '50'),
(297, 'Lido Background', '4', '0', 'bg_lidoo', 0, 1, '50'),
(298, 'Lido (Flat) Background', '4', '0', 'bg_lido_flat', 0, 1, '50'),
(299, 'Infobus (Yellow) Background', '4', '0', 'bg_infobus_yellow', 0, 1, '50'),
(300, 'Infobus (White) Background', '4', '0', 'bg_infobus_white', 0, 1, '50'),
(301, 'Infobus (Blue) Background', '4', '0', 'bg_infobus_blue', 0, 1, '50'),
(302, 'Battle Ball (2) Background', '4', '0', 'bg_battle_ball2', 0, 1, '50'),
(303, 'Grunge Wall Background', '4', '0', 'grungewall', 0, 1, '50');

-- --------------------------------------------------------

--
-- Table structure for table `cms_homes_group_linker`
--

CREATE TABLE `cms_homes_group_linker` (
  `userid` int(11) NOT NULL,
  `groupid` int(11) NOT NULL,
  `active` varchar(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_homes_inventory`
--

CREATE TABLE `cms_homes_inventory` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `type` varchar(1) NOT NULL,
  `subtype` varchar(1) NOT NULL,
  `data` text NOT NULL,
  `amount` varchar(3) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_homes_stickers`
--

CREATE TABLE `cms_homes_stickers` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `x` varchar(6) NOT NULL DEFAULT '1' COMMENT 'left',
  `y` varchar(6) NOT NULL DEFAULT '1' COMMENT 'top',
  `z` varchar(6) NOT NULL DEFAULT '1' COMMENT 'z-index',
  `data` text NOT NULL,
  `type` varchar(1) NOT NULL DEFAULT '1',
  `subtype` varchar(1) NOT NULL DEFAULT '0' COMMENT 'Widget Type (if widget)',
  `skin` text NOT NULL,
  `groupid` int(11) NOT NULL DEFAULT -1
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_minimail`
--

CREATE TABLE `cms_minimail` (
  `userid` int(11) NOT NULL,
  `senderid` int(11) NOT NULL,
  `subject` varchar(30) NOT NULL,
  `date` varchar(30) NOT NULL,
  `message` text NOT NULL,
  `read` enum('0','1') NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_news`
--

CREATE TABLE `cms_news` (
  `num` int(4) NOT NULL,
  `title` text COLLATE latin1_general_ci NOT NULL,
  `category` text COLLATE latin1_general_ci NOT NULL,
  `topstory` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `short_story` text COLLATE latin1_general_ci NOT NULL,
  `story` longtext COLLATE latin1_general_ci NOT NULL,
  `date` date NOT NULL,
  `author` text COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='HoloCMS';

-- --------------------------------------------------------

--
-- Table structure for table `cms_posts`
--

CREATE TABLE `cms_posts` (
  `id` int(11) NOT NULL,
  `thread` int(11) NOT NULL,
  `poster` varchar(25) NOT NULL,
  `date` varchar(25) NOT NULL,
  `post` text NOT NULL,
  `modified` varchar(50) NOT NULL,
  `modified_by` varchar(25) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='HoloCMS';

-- --------------------------------------------------------

--
-- Table structure for table `cms_system`
--

CREATE TABLE `cms_system` (
  `sitename` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `shortname` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `site_closed` enum('0','1') COLLATE latin1_general_ci NOT NULL COMMENT 'Maintenance Mode',
  `enable_sso` enum('0','1') COLLATE latin1_general_ci NOT NULL,
  `language` varchar(2) COLLATE latin1_general_ci NOT NULL,
  `ip` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `port` varchar(5) COLLATE latin1_general_ci NOT NULL,
  `texts` varchar(250) COLLATE latin1_general_ci NOT NULL,
  `variables` varchar(250) COLLATE latin1_general_ci NOT NULL,
  `dcr` varchar(250) COLLATE latin1_general_ci NOT NULL,
  `reload_url` varchar(250) COLLATE latin1_general_ci NOT NULL,
  `localhost` enum('0','1') COLLATE latin1_general_ci NOT NULL COMMENT 'Local server?',
  `start_credits` int(11) NOT NULL DEFAULT 0,
  `admin_notes` text COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='HoloCMS';

--
-- Dumping data for table `cms_system`
--

INSERT INTO `cms_system` (`sitename`, `shortname`, `site_closed`, `enable_sso`, `language`, `ip`, `port`, `texts`, `variables`, `dcr`, `reload_url`, `localhost`, `start_credits`, `admin_notes`) VALUES
('Holo Hotel', 'Holo', '0', '1', 'en', '213.10.143.234', '21', 'http://www.habbohotel.co.uk/gamedata/external?id=external_texts', 'http://www.habbohotel.co.uk/gamedata/external?id=external_variables', 'http://images.habbohotel.co.uk/dcr/r23_20080605_0403_6053b_deebb3529e0d9d4e847a31e5f6fb4c5b/habbo.dcr', 'http://213.10.143.234/holocms/client.php', '1', 500, 'Holo note :]');

-- --------------------------------------------------------

--
-- Table structure for table `cms_tags`
--

CREATE TABLE `cms_tags` (
  `id` int(255) NOT NULL,
  `ownerid` int(25) NOT NULL,
  `tag` varchar(25) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='HoloCMS';

-- --------------------------------------------------------

--
-- Table structure for table `cms_threads`
--

CREATE TABLE `cms_threads` (
  `id` int(11) NOT NULL,
  `title` varchar(20) NOT NULL,
  `views` varchar(4) NOT NULL,
  `replies` varchar(4) NOT NULL,
  `starter` varchar(25) NOT NULL,
  `lastposter` varchar(25) NOT NULL,
  `lastpostdate` varchar(25) NOT NULL,
  `lastposttime` varchar(50) NOT NULL,
  `startdate` varchar(25) NOT NULL,
  `unix` varchar(50) NOT NULL,
  `firstpostid` int(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='HoloCMS';

-- --------------------------------------------------------

--
-- Table structure for table `cms_transactions`
--

CREATE TABLE `cms_transactions` (
  `id` int(11) NOT NULL,
  `date` varchar(20) NOT NULL,
  `amount` varchar(10) NOT NULL,
  `descr` text NOT NULL,
  `userid` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_wardrobe`
--

CREATE TABLE `cms_wardrobe` (
  `userid` int(11) NOT NULL,
  `slotid` varchar(1) NOT NULL,
  `figure` text NOT NULL,
  `gender` varchar(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `furniture`
--

CREATE TABLE `furniture` (
  `id` int(10) NOT NULL COMMENT 'The ID of this item',
  `tid` int(10) NOT NULL COMMENT 'The template ID of this item',
  `ownerid` int(10) NOT NULL COMMENT 'The ID of the user that owns this item',
  `roomid` int(10) NOT NULL COMMENT 'The room ID the item is in. If it''s 0, then it''s in the hand of OWNERID, if it''s -1, then it''s in a present and not opened yet, if it''s -2, then it''s in the Recycler',
  `x` smallint(6) NOT NULL DEFAULT 0 COMMENT 'The X of the item in a room',
  `y` smallint(6) NOT NULL DEFAULT 0 COMMENT 'The Y of the item in a room',
  `z` smallint(6) NOT NULL DEFAULT 0 COMMENT 'The Z [rotation] of the item in a room',
  `h` double(4,2) NOT NULL DEFAULT 0.00 COMMENT 'The H [height, double] of the item in a room',
  `var` text COLLATE latin1_general_ci DEFAULT NULL COMMENT 'The variable of the item, specifying it''s turned on/off etc, :S',
  `wallpos` varchar(200) COLLATE latin1_general_ci DEFAULT NULL COMMENT 'Wallitems only. The location on the wall where the item is',
  `teleportid` int(10) DEFAULT NULL COMMENT 'Teleporters only. The ID of the teleporter that links to this one',
  `soundmachine_soundset` int(2) DEFAULT NULL,
  `soundmachine_machineid` int(10) DEFAULT NULL,
  `soundmachine_slot` int(1) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `furniture`
--

INSERT INTO `furniture` (`id`, `tid`, `ownerid`, `roomid`, `x`, `y`, `z`, `h`, `var`, `wallpos`, `teleportid`, `soundmachine_soundset`, `soundmachine_machineid`, `soundmachine_slot`) VALUES
(1, 103, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 99, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 107, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 109, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 109, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 109, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(7, 112, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(8, 112, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(9, 112, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(10, 52, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 443, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 443, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 443, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 443, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(15, 443, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(16, 443, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 443, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(18, 443, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(20, 100, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(21, 100, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(25, 78, 1, 0, 0, 0, 0, 0.00, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 419, 1, 201, 4, 1, 4, 0.00, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `furniture_moodlight`
--

CREATE TABLE `furniture_moodlight` (
  `id` int(11) NOT NULL,
  `roomid` int(11) NOT NULL,
  `preset_cur` int(1) NOT NULL DEFAULT 0,
  `preset_1` varchar(75) COLLATE latin1_general_ci DEFAULT NULL,
  `preset_2` varchar(75) COLLATE latin1_general_ci DEFAULT NULL,
  `preset_3` varchar(75) COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `furniture_presents`
--

CREATE TABLE `furniture_presents` (
  `id` int(10) NOT NULL,
  `itemid` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `furniture_stickies`
--

CREATE TABLE `furniture_stickies` (
  `id` int(10) NOT NULL,
  `text` text COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `games_lobbies`
--

CREATE TABLE `games_lobbies` (
  `id` int(10) NOT NULL,
  `type` enum('bb') COLLATE latin1_general_ci NOT NULL DEFAULT 'bb',
  `rank` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `bb_allowedpowerups` text COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `games_lobbies`
--

INSERT INTO `games_lobbies` (`id`, `type`, `rank`, `bb_allowedpowerups`) VALUES
(113, 'bb', 'Noob', '1,2,3,4,5,6,7,8'),
(114, 'bb', 'Amateur', '1,2,3,4,5,6,7,8'),
(115, 'bb', 'Intermediate', '1,2,3,4,5,6,7,8'),
(116, 'bb', 'Expert', '1,2,3,4,5,6,7,8'),
(117, 'bb', 'Leet', '1,2,3,4,5,6,7,8'),
(118, '', 'noob', '1,2,3,4,5,6,7,8'),
(119, '', 'Amateur', '1,2,3,4,5,6,7,8'),
(120, '', 'Intermediate', '1,2,3,4,5,6,7,8'),
(121, '', 'Intermediate', '1,2,3,4,5,6,7,8'),
(122, '', 'Expert', '1,2,3,4,5,6,7,8');

-- --------------------------------------------------------

--
-- Table structure for table `games_ranks`
--

CREATE TABLE `games_ranks` (
  `id` int(5) NOT NULL,
  `type` enum('ss','bb') COLLATE latin1_general_ci NOT NULL DEFAULT 'bb',
  `title` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `minpoints` int(10) NOT NULL,
  `maxpoints` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `games_ranks`
--

INSERT INTO `games_ranks` (`id`, `type`, `title`, `minpoints`, `maxpoints`) VALUES
(1, 'bb', 'Noob', 0, 10000),
(2, 'bb', 'Amateur', 10001, 100000),
(3, 'bb', 'Intermediate', 100001, 500000),
(4, 'bb', 'Expert', 500001, 10000000),
(5, 'bb', 'Leet', 10000001, 0),
(6, 'ss', 'Noob', 0, 10000),
(7, 'ss', 'Amateur', 10001, 100000),
(8, 'ss', 'Intermediate', 100001, 500000),
(9, 'ss', 'Expert', 500001, 10000000),
(10, 'ss', 'Leet', 10000001, 0);

-- --------------------------------------------------------

--
-- Table structure for table `groups_details`
--

CREATE TABLE `groups_details` (
  `id` int(10) NOT NULL,
  `name` varchar(45) COLLATE latin1_general_ci NOT NULL,
  `description` varchar(200) COLLATE latin1_general_ci NOT NULL,
  `ownerid` int(10) NOT NULL,
  `roomid` int(10) NOT NULL,
  `created` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `badge` text COLLATE latin1_general_ci NOT NULL,
  `type` varchar(1) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groups_memberships`
--

CREATE TABLE `groups_memberships` (
  `userid` int(10) NOT NULL,
  `groupid` int(10) NOT NULL,
  `member_rank` enum('3','2','1') COLLATE latin1_general_ci NOT NULL DEFAULT '3',
  `is_current` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `is_pending` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messenger_friendrequests`
--

CREATE TABLE `messenger_friendrequests` (
  `userid_from` int(10) NOT NULL DEFAULT 0,
  `userid_to` int(10) NOT NULL DEFAULT 0,
  `requestid` int(10) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messenger_friendships`
--

CREATE TABLE `messenger_friendships` (
  `userid` bigint(20) NOT NULL,
  `friendid` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messenger_messages`
--

CREATE TABLE `messenger_messages` (
  `userid` int(15) NOT NULL,
  `friendid` int(15) NOT NULL,
  `messageid` int(11) NOT NULL,
  `sent_on` text COLLATE latin1_general_ci NOT NULL,
  `message` text COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ranks`
--

CREATE TABLE `ranks` (
  `rankid` int(1) NOT NULL,
  `rankname` varchar(15) COLLATE latin1_general_ci DEFAULT NULL,
  `ignoreFilter` int(1) NOT NULL,
  `receiveCFH` int(1) NOT NULL,
  `enterAllRooms` int(1) NOT NULL,
  `seeAllOwners` int(1) NOT NULL,
  `adminCatalogue` int(1) NOT NULL,
  `staffFloor` int(1) NOT NULL,
  `rightsEverywhere` int(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rank_fuserights`
--

CREATE TABLE `rank_fuserights` (
  `id` int(3) NOT NULL,
  `minrank` int(1) NOT NULL,
  `fuseright` varchar(100) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `rank_fuserights`
--

INSERT INTO `rank_fuserights` (`id`, `minrank`, `fuseright`) VALUES
(1, 1, 'default'),
(2, 1, 'fuse_login'),
(3, 1, 'fuse_buy_credits'),
(4, 1, 'fuse_trade'),
(5, 1, 'fuse_room_queue_default'),
(6, 2, 'fuse_extended_buddylist'),
(7, 2, 'fuse_habbo_chooser'),
(8, 2, 'fuse_furni_chooser'),
(9, 2, 'fuse_room_queue_club'),
(10, 2, 'fuse_priority_access'),
(11, 2, 'fuse_use_special_room_layouts'),
(12, 2, 'fuse_use_club_dance'),
(13, 3, 'fuse_enter_full_rooms'),
(14, 4, 'fuse_enter_locked_rooms'),
(16, 4, 'fuse_kick'),
(17, 4, 'fuse_mute'),
(18, 5, 'fuse_ban'),
(19, 5, 'fuse_room_mute'),
(20, 5, 'fuse_room_kick'),
(21, 5, 'fuse_receive_calls_for_help'),
(22, 5, 'fuse_remove_stickies'),
(23, 6, 'fuse_mod'),
(24, 6, 'fuse_superban'),
(25, 6, 'fuse_pick_up_any_furni'),
(26, 6, 'fuse_ignore_room_owner'),
(27, 6, 'fuse_any_room_controller'),
(28, 3, 'fuse_room_alert'),
(29, 6, 'fuse_moderator_access'),
(30, 7, 'fuse_administrator_access'),
(31, 7, 'fuse_see_flat_ids'),
(35, 5, 'fuse_chat_log'),
(33, 6, 'fuse_performance_panel'),
(34, 4, 'fuse_alert'),
(36, 5, 'fuse_see_all_roomowners'),
(37, 6, 'fuse_hotelalert'),
(38, 6, 'fuse_teleport');

-- --------------------------------------------------------

--
-- Table structure for table `roombots`
--

CREATE TABLE `roombots` (
  `id` int(10) NOT NULL,
  `roomid` int(10) NOT NULL,
  `name` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `mission` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `figure` text COLLATE latin1_general_ci NOT NULL,
  `x` int(5) NOT NULL,
  `y` int(5) NOT NULL,
  `z` int(1) NOT NULL,
  `freeroam` enum('1','0') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `message_noshouting` varchar(200) COLLATE latin1_general_ci NOT NULL DEFAULT 'Shouting is not neccessary.'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `roombots`
--

INSERT INTO `roombots` (`id`, `roomid`, `name`, `mission`, `figure`, `x`, `y`, `z`, `freeroam`, `message_noshouting`) VALUES
(1, 102, 'Rosanne', 'Serving the pool since \'08', 'sd=001&sh=002/148,98,32&lg=200/120,66,21&ch=018/255,230,57&lh=001/215,175,125&rh=001/215,175,125&hd=001/215,175,125&ey=001&fc=001/215,175,125&hr=023/255,230,50&rs=003/255,230,57&ls=003/255,230,57&bd=001/215,175,125', 6, 30, 2, '0', 'Shouting is not neccessary, keep it quiet! :)'),
(2, 105, 'Dean', 'Luvving teh white gold', 'sd=001/0&hr=996/&hd=002/255,204,153&ey=003/0&fc=001/255,204,153&bd=001/255,204,153&lh=001/255,204,153&rh=001/255,204,153&ch=001/74,106,24&ls=002/74,106,24&rs=002/74,106,24&lg=001/51,51,51&sh=001/223,203,175', 22, 29, 2, '0', 'Shouting is not neccessary, pirates don\'t shout!');

-- --------------------------------------------------------

--
-- Table structure for table `roombots_coords`
--

CREATE TABLE `roombots_coords` (
  `id` int(10) NOT NULL,
  `x` int(5) NOT NULL,
  `y` int(5) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `roombots_coords`
--

INSERT INTO `roombots_coords` (`id`, `x`, `y`) VALUES
(1, 6, 31),
(1, 6, 29),
(1, 6, 30),
(2, 22, 28),
(2, 22, 27),
(2, 22, 26),
(2, 22, 25),
(2, 22, 24),
(2, 23, 29),
(2, 23, 28),
(2, 23, 27),
(2, 23, 26),
(2, 23, 25),
(2, 23, 24);

-- --------------------------------------------------------

--
-- Table structure for table `roombots_texts`
--

CREATE TABLE `roombots_texts` (
  `id` int(10) NOT NULL,
  `type` enum('shout','say') COLLATE latin1_general_ci NOT NULL,
  `text` varchar(255) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `roombots_texts`
--

INSERT INTO `roombots_texts` (`id`, `type`, `text`) VALUES
(1, 'shout', 'Pff why not go for a splash? :)'),
(1, 'say', 'It\'s-hawt... :('),
(1, 'shout', 'Hey, who wants some fresh milk?'),
(1, 'say', 'Don\'t worry, I won\'t bite ya! Order something!'),
(1, 'say', 'The pool is looking blue right now. Meh, it always does, but it\'s great!'),
(1, 'say', 'Lahlahlahlaah, dundundun, lalala...'),
(1, 'say', 'I work for free!'),
(1, 'say', 'I need to pee I guess, hmm, the pool. ^^'),
(1, 'say', 'Woop it\'s always sunny here! :D'),
(1, 'say', 'Since when do they have sand here?!'),
(2, 'shout', 'Ugh, coke has become worser these days'),
(2, 'shout', 'Crap, where\'s my basepipe?'),
(2, 'say', 'What kind of animal smokes crack? It\'s ammoniac bitches!'),
(2, 'shout', 'FUCK, A CAT!'),
(2, 'shout', 'My dad was a communist and he has raped me 11 times, ugh'),
(2, 'say', 'Meeh'),
(2, 'shout', 'Doing tha dishes and smoking my basepipe = my life'),
(2, 'say', 'I used to be a smuggler in USA'),
(2, 'shout', 'Are you a cop yappie?'),
(2, 'shout', 'Wanna hop on my stick kid?'),
(2, 'say', 'Lalala, lalalala, lalaa'),
(2, 'shout', 'ANYONE GOT SOMETHING TO SMOKE FOR ME?'),
(2, 'shout', 'Anyone up for a fresh CokeJuice?'),
(2, 'shout', 'Someone wants a CokeJuice? Ask away!'),
(2, 'say', 'Who wants a CokeJuice? :o');

-- --------------------------------------------------------

--
-- Table structure for table `roombots_texts_triggers`
--

CREATE TABLE `roombots_texts_triggers` (
  `id` int(10) NOT NULL,
  `words` text COLLATE latin1_general_ci NOT NULL,
  `replies` text COLLATE latin1_general_ci NOT NULL,
  `serve_replies` text COLLATE latin1_general_ci NOT NULL,
  `serve_item` varchar(20) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `roombots_texts_triggers`
--

INSERT INTO `roombots_texts_triggers` (`id`, `words`, `replies`, `serve_replies`, `serve_item`) VALUES
(1, 'milk}cow juice}sperm', 'Fresh from the cow, coming up to ya!}Hah sir wants some milk? I\'ll ask the cow!}Cow #22, some milk please.}Cow? Cow? I need some milk for this thirsty user!}COW WTF IS U DOING!?!!11oneone', 'Enjoy it while it\'s cold, when it\'s hot it\'ll make you sleepy. :)}Fresh from the cow, it\'ll burp you away!}Hmm, fresh milk, should I keep it? Nah it\'s yours! :)', '5'),
(2, 'coke}cocaine', 'WUT?! Cocaine?}You got cocaine for me?}I love cocaine, just like you I guess?}Ah I remember the day when I sniffed my first pile!}My dad learnt me to smoke/roll etc it!', '', ''),
(2, 'cokejuice}coke juice', 'Ah you want some CokeJuice? Coming up!}Okay, one CokeJuice for you coming up!}Okay I\'ll bring it ya, keep hanging}One CokeJuice coming up there!', 'Don\'t show it to the cops kid, enjoy!}You\'ll be dead meat if I see you throwing it away! Enjoy!}Ah, here you are!}Here, enjoy & take care}Enjoy your CokeJuice!', 'CokeJuice (68%)'),
(2, 'beer}alcohol}drink', 'If you want something to drink, you should ask for CokeJuice!}Ask for CokeJuice!}Thirsty kid? CokeJuice is what ya want!}Hmm ask for some CokeJuice? It\'s free cuz it\'s Holo doh', '', ''),
(2, 'dean', 'Yeah that\'s me!}Hey how do you know me?!}At your service d00d}Yeah, I\'m Dean, I got a communist dad and he has raped me 11 times so far}Woot, you know my name?}Dean is your man dude', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(10) NOT NULL,
  `name` varchar(25) COLLATE latin1_general_ci NOT NULL,
  `description` varchar(125) COLLATE latin1_general_ci DEFAULT NULL,
  `owner` varchar(15) COLLATE latin1_general_ci DEFAULT NULL,
  `category` int(3) NOT NULL DEFAULT 0,
  `model` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `ccts` text COLLATE latin1_general_ci DEFAULT NULL,
  `floor` int(3) NOT NULL DEFAULT 0,
  `wallpaper` int(3) NOT NULL DEFAULT 0,
  `state` int(11) NOT NULL DEFAULT 0 COMMENT '0 = open, 1 = closed, 2 = password, 3 = hc only, 4 = staff',
  `password` varchar(15) COLLATE latin1_general_ci DEFAULT NULL,
  `showname` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '1',
  `superusers` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `visitors_now` int(3) NOT NULL DEFAULT 0,
  `visitors_max` int(3) NOT NULL DEFAULT 25
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `description`, `owner`, `category`, `model`, `ccts`, `floor`, `wallpaper`, `state`, `password`, `showname`, `superusers`, `visitors_now`, `visitors_max`) VALUES
(101, 'Welcome Lounge', 'welcome_lounge', NULL, 3, 'newbie_lobby', 'hh_room_nlobby', 0, 0, 0, NULL, '1', '0', 0, 35),
(103, 'Holoween theatre', 'theatredrome_halloween', NULL, 7, 'theater', 'hh_room_theater_halloween', 0, 0, 0, NULL, '1', '0', 0, 40),
(102, 'Pool - A', 'habbo_lido', NULL, 5, 'pool_a', 'hh_room_pool,hh_people_pool', 0, 0, 0, NULL, '1', '0', 0, 25),
(104, 'The pr0n shop', 'library', NULL, 7, 'library', 'hh_room_library_twr_trr', 0, 0, 0, NULL, '1', '0', 0, 20),
(105, 'The Cokerunners Inn', 'sunset_cafe', NULL, 9, 'sunset_cafe', 'hh_room_sunsetcafe', 0, 0, 0, NULL, '1', '0', 0, 20),
(107, 'Pool - B', 'habbo_lido_ii', NULL, 5, 'pool_b', 'hh_room_pool,hh_people_pool', 0, 0, 0, NULL, '1', '0', 0, 25),
(106, 'The Pub', 'the_dirty_duck_pub', NULL, 9, 'pub_a', 'hh_room_pub', 0, 0, 0, NULL, '1', '0', 0, 35),
(108, 'Natalee Holloway is here', 'floatinggarden', NULL, 5, 'floatinggarden', 'hh_room_floatinggarden', 0, 0, 0, NULL, '1', '0', 0, 30),
(109, 'Monkey Bumble', 'rooftop_rumble', NULL, 5, 'md_a', 'hh_room_terrace,hh_paalu,hh_people_pool,hh_people_paalu', 0, 0, 0, NULL, '1', '0', 1, 25),
(110, 'Picnic Fields', 'picnic', NULL, 5, 'picnic', 'hh_room_picnic', 0, 0, 0, NULL, '1', '0', 0, 25),
(111, 'The Park', 'park', NULL, 8, 'park_a', 'hh_room_park_general,hh_room_park', 0, 0, 0, NULL, '1', '0', 0, 30),
(112, 'The Infobus', 'park', NULL, 8, 'park_b', 'hh_room_park_general,hh_room_park', 0, 0, 0, NULL, '1', '0', 0, 15),
(201, 't7it', NULL, 'Alex', 0, 'a', NULL, 0, 0, 0, '', '1', '0', 0, 25);

-- --------------------------------------------------------

--
-- Table structure for table `room_ads`
--

CREATE TABLE `room_ads` (
  `roomid` int(10) NOT NULL,
  `img` text COLLATE latin1_general_ci NOT NULL,
  `uri` text COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `room_ads`
--

INSERT INTO `room_ads` (`roomid`, `img`, `uri`) VALUES
(105, 'http://ads.habbohotel.co.uk/max/adview.php?zoneid=1312&n=10019470771151', 'http://ads.habbohotel.co.uk/max/adclick.php?n=10019470771151');

-- --------------------------------------------------------

--
-- Table structure for table `room_bans`
--

CREATE TABLE `room_bans` (
  `roomid` int(10) NOT NULL,
  `userid` int(10) NOT NULL,
  `ban_expire` varchar(50) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_categories`
--

CREATE TABLE `room_categories` (
  `id` int(3) NOT NULL DEFAULT 0,
  `parent` int(3) NOT NULL DEFAULT 0,
  `type` int(1) NOT NULL DEFAULT 1,
  `name` varchar(100) COLLATE latin1_general_ci NOT NULL DEFAULT 'Non-named category',
  `access_rank_min` int(2) NOT NULL,
  `access_rank_hideforlower` enum('0','1') COLLATE latin1_general_ci NOT NULL,
  `trading` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `room_categories`
--

INSERT INTO `room_categories` (`id`, `parent`, `type`, `name`, `access_rank_min`, `access_rank_hideforlower`, `trading`) VALUES
(0, 1, 2, 'No category', 1, '0', '0'),
(3, 0, 0, 'Public Rooms', 1, '0', '0'),
(4, 0, 2, 'Guestrooms', 1, '0', '0'),
(6, 4, 2, 'Category I', 1, '0', '1'),
(5, 3, 0, 'Outside spaces', 1, '0', '0'),
(7, 3, 0, 'Entertainment', 1, '0', '0'),
(8, 5, 0, 'The Park & Infobus', 1, '0', '0'),
(9, 7, 0, 'Clubs & bars', 7, '0', '0'),
(10, 4, 2, 'Staff rooms', 6, '0', '1');

-- --------------------------------------------------------

--
-- Table structure for table `room_modeldata`
--

CREATE TABLE `room_modeldata` (
  `model` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `roomomatic_subscr_only` int(1) NOT NULL DEFAULT 0,
  `door_x` int(3) NOT NULL,
  `door_y` int(3) NOT NULL,
  `door_h` int(3) NOT NULL,
  `door_z` int(1) NOT NULL,
  `heightmap` text COLLATE latin1_general_ci NOT NULL,
  `publicroom_items` text COLLATE latin1_general_ci NOT NULL,
  `swimmingpool` int(11) NOT NULL,
  `specialcast_emitter` varchar(15) COLLATE latin1_general_ci DEFAULT NULL,
  `specialcast_interval` int(10) DEFAULT NULL,
  `specialcast_rnd_min` int(10) DEFAULT NULL,
  `specialcast_rnd_max` int(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `room_modeldata`
--

INSERT INTO `room_modeldata` (`model`, `roomomatic_subscr_only`, `door_x`, `door_y`, `door_h`, `door_z`, `heightmap`, `publicroom_items`, `swimmingpool`, `specialcast_emitter`, `specialcast_interval`, `specialcast_rnd_min`, `specialcast_rnd_max`) VALUES
('a', 0, 3, 5, 0, 0, 'xxxxxxxxxxxx\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxx00000000\rxxxxxxxxxxxx\rxxxxxxxxxxxx\r', '', 0, '0', 1, NULL, NULL),
('b', 0, 0, 5, 0, 0, 'xxxxxxxxxxxx\rxxxxx0000000\rxxxxx0000000\rxxxxx0000000\rxxxxx0000000\rx00000000000\rx00000000000\rx00000000000\rx00000000000\rx00000000000\rx00000000000\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\r', '', 0, '0', 1, NULL, NULL),
('c', 0, 4, 7, 0, 0, 'xxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx', '', 0, '0', 1, NULL, NULL),
('d', 0, 4, 7, 0, 0, 'xxxxxxxxxxxx\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxx000000x\rxxxxxxxxxxxx\r', '', 0, '0', 1, NULL, NULL),
('e', 0, 1, 5, 0, 0, 'xxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxx0000000000\rxx0000000000\rxx0000000000\rxx0000000000\rxx0000000000\rxx0000000000\rxx0000000000\rxx0000000000\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\r', '', 0, '0', 1, NULL, NULL),
('f', 0, 2, 5, 0, 0, 'xxxxxxxxxxxx\rxxxxxxx0000x\rxxxxxxx0000x\rxxx00000000x\rxxx00000000x\rxxx00000000x\rxxx00000000x\rx0000000000x\rx0000000000x\rx0000000000x\rx0000000000x\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx\r', '', 0, '0', 1, NULL, NULL),
('g', 0, 1, 7, 1, 0, 'xxxxxxxxxxxxx\rxxxxxxxxxxxxx\rxxxxxxx00000x\rxxxxxxx00000x\rxxxxxxx00000x\rxx1111000000x\rxx1111000000x\rxx1111000000x\rxx1111000000x\rxx1111000000x\rxxxxxxx00000x\rxxxxxxx00000x\rxxxxxxx00000x\rxxxxxxxxxxxxx\rxxxxxxxxxxxxx\rxxxxxxxxxxxxx\rxxxxxxxxxxxxx', '', 0, '0', 1, NULL, NULL),
('h', 0, 4, 4, 1, 0, 'xxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxx111111x\rxxxxx111111x\rxxxxx111111x\rxxxxx111111x\rxxxxx111111x\rxxxxx000000x\rxxxxx000000x\rxxx00000000x\rxxx00000000x\rxxx00000000x\rxxx00000000x\rxxxxxxxxxxxx\rxxxxxxxxxxxx\rxxxxxxxxxxxx', '', 0, '0', 1, NULL, NULL),
('i', 0, 0, 10, 0, 0, 'xxxxxxxxxxxxxxxxx\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rx0000000000000000\rxxxxxxxxxxxxxxxxx', '', 0, '0', 1, NULL, NULL),
('j', 0, 0, 10, 0, 0, 'xxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxx0000000000\rxxxxxxxxxxx0000000000\rxxxxxxxxxxx0000000000\rxxxxxxxxxxx0000000000\rxxxxxxxxxxx0000000000\rxxxxxxxxxxx0000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx0000000000xxxxxxxxxx\rx0000000000xxxxxxxxxx\rx0000000000xxxxxxxxxx\rx0000000000xxxxxxxxxx\rx0000000000xxxxxxxxxx\rx0000000000xxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxx\r', '', 0, '0', 1, NULL, NULL),
('k', 0, 0, 13, 0, 0, 'xxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx00000000\rxxxxxxxxxxxxxxxxx00000000\rxxxxxxxxxxxxxxxxx00000000\rxxxxxxxxxxxxxxxxx00000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rx000000000000000000000000\rx000000000000000000000000\rx000000000000000000000000\rx000000000000000000000000\rx000000000000000000000000\rx000000000000000000000000\rx000000000000000000000000\rx000000000000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxxxxxxxxxxxxxxxxxx\r\r', '', 0, '0', 1, NULL, NULL),
('l', 0, 0, 16, 0, 0, 'xxxxxxxxxxxxxxxxxxxxx\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rx00000000xxxx00000000\rxxxxxxxxxxxxxxxxxxxxx\r', '', 0, '0', 1, NULL, NULL),
('m', 0, 0, 15, 1, 0, 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rx0000000000000000000000000000\rx0000000000000000000000000000\rx0000000000000000000000000000\rx0000000000000000000000000000\rx0000000000000000000000000000\rx0000000000000000000000000000\rx0000000000000000000000000000\rx0000000000000000000000000000\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxx00000000xxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', '', 0, '0', 1, NULL, NULL),
('n', 0, 0, 16, 0, 0, 'xxxxxxxxxxxxxxxxxxxxx\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx000000xxxxxxxx000000\rx000000x000000x000000\rx000000x000000x000000\rx000000x000000x000000\rx000000x000000x000000\rx000000x000000x000000\rx000000x000000x000000\rx000000xxxxxxxx000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rx00000000000000000000\rxxxxxxxxxxxxxxxxxxxxx\r', '', 0, '0', 1, NULL, NULL),
('o', 0, 0, 18, 1, 0, 'xxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxx11111111xxxx\rxxxxxxxxxxxxx11111111xxxx\rxxxxxxxxxxxxx11111111xxxx\rxxxxxxxxxxxxx11111111xxxx\rxxxxxxxxxxxxx11111111xxxx\rxxxxxxxxxxxxx11111111xxxx\rxxxxxxxxxxxxx11111111xxxx\rxxxxxxxxxxxxx00000000xxxx\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rx111111100000000000000000\rx111111100000000000000000\rx111111100000000000000000\rx111111100000000000000000\rx111111100000000000000000\rx111111100000000000000000\rx111111100000000000000000\rx111111100000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxx0000000000000000\rxxxxxxxxxxxxxxxxxxxxxxxxx', '', 0, '0', 1, NULL, NULL),
('p', 0, 0, 23, 2, 0, 'xxxxxxxxxxxxxxxxxxx\rxxxxxxx222222222222\rxxxxxxx222222222222\rxxxxxxx222222222222\rxxxxxxx222222222222\rxxxxxxx222222222222\rxxxxxxx222222222222\rxxxxxxx22222222xxxx\rxxxxxxx11111111xxxx\rx222221111111111111\rx222221111111111111\rx222221111111111111\rx222221111111111111\rx222221111111111111\rx222221111111111111\rx222221111111111111\rx222221111111111111\rx2222xx11111111xxxx\rx2222xx00000000xxxx\rx2222xx000000000000\rx2222xx000000000000\rx2222xx000000000000\rx2222xx000000000000\rx2222xx000000000000\rx2222xx000000000000\rxxxxxxxxxxxxxxxxxxx', '', 0, '0', 1, NULL, NULL),
('q', 0, 10, 4, 2, 0, 'xxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxx22222222\rxxxxxxxxxxx22222222\rxxxxxxxxxxx22222222\rxxxxxxxxxxx22222222\rxxxxxxxxxxx22222222\rxxxxxxxxxxx22222222\rx222222222222222222\rx222222222222222222\rx222222222222222222\rx222222222222222222\rx222222222222222222\rx222222222222222222\rx2222xxxxxxxxxxxxxx\rx2222xxxxxxxxxxxxxx\rx2222211111xx000000\rx222221111110000000\rx222221111110000000\rx2222211111xx000000\rxx22xxx1111xxxxxxxx\rxx11xxx1111xxxxxxxx\rx1111xx1111xx000000\rx1111xx111110000000\rx1111xx111110000000\rx1111xx1111xx000000\rxxxxxxxxxxxxxxxxxxx', '', 0, '0', 1, NULL, NULL),
('r', 0, 10, 4, 3, 0, 'xxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxx33333333333333\rxxxxxxxxxxx33333333333333\rxxxxxxxxxxx33333333333333\rxxxxxxxxxxx33333333333333\rxxxxxxxxxxx33333333333333\rxxxxxxxxxxx33333333333333\rxxxxxxx333333333333333333\rxxxxxxx333333333333333333\rxxxxxxx333333333333333333\rxxxxxxx333333333333333333\rxxxxxxx333333333333333333\rxxxxxxx333333333333333333\rx4444433333xxxxxxxxxxxxxx\rx4444433333xxxxxxxxxxxxxx\rx44444333333222xx000000xx\rx44444333333222xx000000xx\rxxx44xxxxxxxx22xx000000xx\rxxx33xxxxxxxx11xx000000xx\rxxx33322222211110000000xx\rxxx33322222211110000000xx\rxxxxxxxxxxxxxxxxx000000xx\rxxxxxxxxxxxxxxxxx000000xx\rxxxxxxxxxxxxxxxxx000000xx\rxxxxxxxxxxxxxxxxx000000xx\rxxxxxxxxxxxxxxxxxxxxxxxxx', '', 0, '0', 1, NULL, NULL),
('newbie_lobby', 0, 2, 11, 0, 2, 'xxxxxxxxxxxxxxxx000000\rxxxxx0xxxxxxxxxx000000\rxxxxx00000000xxx000000\rxxxxx000000000xx000000\r0000000000000000000000\r0000000000000000000000\r0000000000000000000000\r0000000000000000000000\r0000000000000000000000\rxxxxx000000000000000xx\rxxxxx000000000000000xx\rx0000000000000000000xx\rx0000000000000000xxxxx\rxxxxxx00000000000xxxxx\rxxxxxxx0000000000xxxxx\rxxxxxxxx000000000xxxxx\rxxxxxxxx000000000xxxxx\rxxxxxxxx000000000xxxxx\rxxxxxxxx000000000xxxxx\rxxxxxxxx000000000xxxxx\rxxxxxxxx000000000xxxxx\rxxxxxx00000000000xxxxx\rxxxxxx00000000000xxxxx\rxxxxxx00000000000xxxxx\rxxxxxx00000000000xxxxx\rxxxxxx00000000000xxxxx\rxxxxx000000000000xxxxx\rxxxxx000000000000xxxxx\r', 'a160 crl_lamp 16 0 0 0 1\r\ny170 crl_sofa2c 17 0 0 4 2\r\nw180 crl_sofa2b 18 0 0 4 2\r\nv190 crl_sofa2a 19 0 0 4 2\r\na200 crl_lamp 20 0 0 0 1\r\nb161 crl_chair 16 1 0 2 2\r\na72 crl_lamp 7 2 0 0 1\r\na112 crl_lamp 11 2 0 0 1\r\nb162 crl_chair 16 2 0 2 2\r\nc53 crl_pillar 5 3 0 0 1\r\nb73 crl_chair 7 3 0 2 2\r\nu93 crl_table1b 9 3 0 0 1\r\ns113 crl_sofa1c 11 3 0 6 2\r\nb163 crl_chair 16 3 0 2 2\r\nA193 crl_table2b 19 3 0 0 1\r\nz203 crl_table2a 20 3 0 0 1\r\na04 crl_lamp 0 4 0 0 1\r\ny14 crl_sofa2c 1 4 0 4 2\r\nw24 crl_sofa2b 2 4 0 4 2\r\nv34 crl_sofa2a 3 4 0 4 2\r\na44 crl_lamp 4 4 0 0 1\r\nt94 crl_table1a 9 4 0 0 1\r\nr114 crl_sofa1b 11 4 0 6 2\r\nh154 crl_wall2a 15 4 0 0 1\r\na164 crl_lamp 16 4 0 0 1\r\nb05 crl_chair 0 5 0 2 2\r\nb75 crl_chair 7 5 0 2 2\r\nq115 crl_sofa1a 11 5 0 6 2\r\nA26 crl_table2b 2 6 0 0 1\r\nz36 crl_table2a 3 6 0 0 1\r\na116 crl_lamp 11 6 0 0 1\r\nb07 crl_chair 0 7 0 2 2\r\na08 crl_lamp 0 8 0 0 1\r\nD18 crl_sofa3c 1 8 0 0 2\r\nC28 crl_sofa3b 2 8 0 0 2\r\nB38 crl_sofa3a 3 8 0 0 2\r\na48 crl_lamp 4 8 0 0 1\r\no198 crl_barchair2 19 8 0 0 2\r\np208 crl_tablebar 20 8 0 0 1\r\no218 crl_barchair2 21 8 0 0 2\r\nE59 crl_pillar2 5 9 0 0 1\r\nc99 crl_pillar 9 9 0 0 1\r\nP815 crl_desk1a 8 15 0 0 1\r\nO915 crl_deski 9 15 0 0 1\r\nN1015 crl_deskh 10 15 0 0 1\r\nM1016 crl_deskg 10 16 0 0 1\r\nL1017 crl_deskf 10 17 0 0 1\r\nK1018 crl_deske 10 18 0 0 1\r\nK1019 crl_deske 10 19 0 0 1\r\nK1020 crl_deske 10 20 0 0 1\r\nK1021 crl_deske 10 21 0 0 1\r\nK1022 crl_deske 10 22 0 0 1\r\nK1023 crl_deske 10 23 0 0 1\r\nG724 crl_wallb 7 24 0 0 1\r\nK1024 crl_deske 10 24 0 0 1\r\nF725 crl_walla 7 25 0 0 1\r\nH825 crl_desk1b 8 25 0 0 1\r\nI925 crl_desk1c 9 25 0 0 1\r\nJ1025 crl_desk1d 10 25 0 0 1\r\nd1227 crl_lamp2 12 27 0 0 1\r\nf1327 crl_cabinet2 13 27 0 0 1\r\ne1427 crl_cabinet1 14 27 0 0 1\r\nd1527 crl_lamp2 15 27 0 0 1', 0, '0', 1, NULL, NULL),
('theater', 0, 20, 27, 0, 0, 'XXXXXXXXXXXXXXXXXXXXXXX\rXXXXXXXXXXXXXXXXXXXXXXX\rXXXXXXXXXXXXXXXXXXXXXXX\rXXXXXXXXXXXXXXXXXXXXXXX\rXXXXXXXXXXXXXXXXXXXXXXX\rXXXXXXXXXXXXXXXXXXXXXXX\rXXXXXXX111111111XXXXXXX\rXXXXXXX11111111100000XX\rXXXX00X11111111100000XX\rXXXX00x11111111100000XX\r4XXX00X11111111100000XX\r4440000XXXXXXXXX00000XX\r444000000000000000000XX\r4XX000000000000000000XX\r4XX0000000000000000000X\r44400000000000000000000\r44400000000000000000000\r44X0000000000000000O000\r44X11111111111111111000\r44X11111111111111111000\r33X11111111111111111000\r22X11111111111111111000\r22X11111111111111111000\r22X11111111111111111000\r22X11111111111111111000\r22X11111111111111111000\r22211111111111111111000\r22211111111111111111000\rXXXXXXXXXXXXXXXXXXXX00X\rXXXXXXXXXXXXXXXXXXXX00X\r', 'm1110 mic 11 10 1 0 1\r\nd211 thchair2 2 11 4 2 2\r\nd212 thchair2 2 12 4 2 2\r\nd215 thchair2 2 15 4 2 2\r\nc615 thchair1 6 15 0 0 2\r\nc715 thchair1 7 15 0 0 2\r\nc815 thchair1 8 15 0 0 2\r\nc915 thchair1 9 15 0 0 2\r\nc1015 thchair1 10 15 0 0 2\r\nc1215 thchair1 12 15 0 0 2\r\nc1315 thchair1 13 15 0 0 2\r\nc1415 thchair1 14 15 0 0 2\r\nc1515 thchair1 15 15 0 0 2\r\nc1615 thchair1 16 15 0 0 2\r\nd216 thchair2 2 16 4 2 2\r\nc620 thchair1 6 20 1 0 2\r\nc720 thchair1 7 20 1 0 2\r\nc820 thchair1 8 20 1 0 2\r\nc920 thchair1 9 20 1 0 2\r\nc1020 thchair1 10 20 1 0 2\r\nc1220 thchair1 12 20 1 0 2\r\nc1320 thchair1 13 20 1 0 2\r\nc1420 thchair1 14 20 1 0 2\r\nc1520 thchair1 15 20 1 0 2\r\nc1620 thchair1 16 20 1 0 2\r\nc623 thchair1 6 23 1 0 2\r\nc723 thchair1 7 23 1 0 2\r\nc823 thchair1 8 23 1 0 2\r\nc923 thchair1 9 23 1 0 2\r\nc1023 thchair1 10 23 1 0 2\r\nc1223 thchair1 12 23 1 0 2\r\nc1323 thchair1 13 23 1 0 2\r\nc1423 thchair1 14 23 1 0 2\r\nc1523 thchair1 15 23 1 0 2\r\nc1623 thchair1 16 23 1 0 2\r\nc626 thchair1 6 26 1 0 2\r\nc726 thchair1 7 26 1 0 2\r\nc826 thchair1 8 26 1 0 2\r\nc926 thchair1 9 26 1 0 2\r\nc1026 thchair1 10 26 1 0 2\r\nc1226 thchair1 12 26 1 0 2\r\nc1326 thchair1 13 26 1 0 2\r\nc1426 thchair1 14 26 1 0 2\r\nc1526 thchair1 15 26 1 0 2\r\nc1626 thchair1 16 26 1 0 2', 0, '0', 1, NULL, NULL),
('library', 0, 20, 3, 1, 0, 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxx11111xx1xx1x111111x\rxxxxxxxxxxxx111111xx1xx11111111x\rxx111xxxxxxx111111xx1xx11111111x\rxx111xxxxxxx1111111111111111111x\rxx111xxxxxxx1111111111111111111x\rxx111xxxxxxx1111111111111111111x\rxx111xxxxxxx1111111111111xxxxxxx\rxx111xxxxxx11111111111111111111x\rxx111xxxxxx11111111111111111111x\rxx111xxxxxx11111111111111111111x\rxx111xxxxxx11111111111111xxxxxxx\rxx111xxxxxxxx111111111111111111x\rxx111xx11111x111111111111111111x\rxx111xx11111x111111111111111111x\rxx111xxxxx11x11111111x111xxxxxxx\rxx111xxxxxxxx11111111xx11111111x\rxx111xxx1111111111111xxx1111111x\rxx111xxx1111111111111xxxx111111x\rxxx111xx1111111111x11xxxx000000x\rxxxxx1111xx1111111x11xxxx000000x\rxxxxxxxxxxxx111111x11xxxx000000x\rxxxxxxxxxxxx11xx11x11xxxx000000x\rxxxxxxxxxxxx11xx11x11xxxx000000x\rxxxxxxxxxxxx11xx11x11xxxx000000x\rxxxxxxxxxxxx11xx11x11xxxx000000x\rxxxxxxxxxxxx11xx11x11xxxx000000x\rxxxxxxxxxxxx11xx11x111xxx000000x\rxxxxxxxxxxxxxxxxxxxx11xxx000000x\rxxxxxxxxxxxxxxxxxxxx11xxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxx22222xxxxxxx\rxxxxxxxxxxxxxxxxxxxx22222xxxxxxx\rxxxxxxxxxxxxxxxxxxxx22222xxxxxxx\rxxxxxxxxxxxxxxxxxxxx22222xxxxxxx\rxxxxxxxxxxxxxxxxxxxx22222xxxxxxx\rxxxxxxxxxxxxxxxxxxxx22222xxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r', 'a142 libchair 14 2 1 4 2\r\na162 libchair 16 2 1 4 2\r\na262 libchair 26 2 1 4 2\r\na243 libchair 24 3 1 2 2\r\na124 libchair 12 4 1 2 2\r\na126 libchair 12 6 1 2 2\r\nb1314 libstool 13 14 1 6 2\r\nb1315 libstool 13 15 1 6 2\r\nb1316 libstool 13 16 1 6 2\r\na2827 libchair 28 27 0 4 2\r\na2729 libchair 27 29 0 2 2\r\nb2433 libstool 24 33 2 6 2\r\nb2434 libstool 24 34 2 6 2\r\nb2435 libstool 24 35 2 6 2\r\nb2136 libstool 21 36 2 0 2\r\nb2236 libstool 22 36 2 0 2\r\nb2336 libstool 23 36 2 0 2', 0, '0', 1, NULL, NULL),
('floatinggarden', 0, 2, 21, 5, 0, 'xxxxxxxxxxxxxxxx333333xxxxxxxxx\rxxxxxxxxxxxxxxxx3xxxx3xxxxxxxxx\rxxxxxxxxxxxxxxxx3xxxx3xxxxxxxxx\rxxxxxxxxxxxxxxxx3xxxx3xxxxxxxxx\rxxxxxxxxxxxxxxx223xxx33xxxxxxxx\rxxxxxxxxxxxxxxx11xxx33333xxxxxx\rxxxxxxxxxxxxxxxx11xx3333333xxxx\rxxxxxxxxxxxxxxxx11xx33333333xxx\rxxxxxxxxxxxxxxxxx11xxxxxxxx3xxx\rxxxxxxxxxxxxxxxxxx11xxxx3333xxx\rxxxxxxxxxxxxxxxxxxx1xxxx33333xx\rxxxxxxxxxxxxxxxxxxx1xxx3333333x\r555xxxxxxxxxxx1111111x333333333\r555xxxxxxxxxxx21111111xxxxxx333\r555xxxxxxxxxxx22111111111xxxxxx\r555xxxxxxxxxxx222xxxxxxx111xxxx\r555xxxxxxxxxxx22xxxxxxxxxx1xxxx\r555xxxxxxxxxxx23333333333x111xx\r555xxxxxxxx33333333333333x111xx\r555xxxxxxxx333333x3333333x111xx\r555xxxxxxxx33333333333333x111xx\r555xxxxxxxx33x33333333333x111xx\r555xxxxxxxx33x33x33333333x111xx\r555xxxxxxxx33x33x33333333x111xx\r5554333333333x333x3333333x111xx\rx554333333xxxx33xxxxxxxxxx111xx\rxxxxxxxxx3xxxx333221111111111xx\rxxxxxxxxx3xxxx333221111111111xx\rxxxxxxxxx33333333xx1111x11x11xx\rxxxxxxxxx33333333111xxx11xxxxxx\rxxxxxxxxxxxxxx33311xxxx11xxxxxx\rxxxxxxxxxxxxxx33311xxxx11xxxxxx\rxxxxxxxxxxxxxx333x1xxxx11xxxxxx\rxxxxxxxxxxxxxx333x1xx111111xxxx\rxxxxxxxxxxxxxx33311xx111111xxxx\rxxxxxxxxxx333333311xx111111xxxx\rxxxxxxxxxxx33333311xx111111xxxx\rxxxxxxxxxxxxxxxx111xxxxxxxxxxxx\rxxxxxxxxxxxxxxx111xxxxxxxxxxxxx\r', 'a249 float_dummychair 24 9 3 4 2\r\na259 float_dummychair 25 9 3 4 2\r\nb2813 float_dummychair2 28 13 3 4 2\r\nb2913 float_dummychair2 29 13 3 4 2\r\ne1717 floatbench2 17 17 3 2 2\r\ne1917 floatbench2 19 17 3 6 2\r\ne2117 floatbench2 21 17 3 2 2\r\ne2317 floatbench2 23 17 3 6 2\r\ne2717 floatbench2 27 17 1 4 2\r\nd2817 floatbench1 28 17 1 4 2\r\nd1718 floatbench1 17 18 3 2 2\r\nd1918 floatbench1 19 18 3 6 2\r\nd2118 floatbench1 21 18 3 2 2\r\nd2318 floatbench1 23 18 3 6 2\r\ne2719 floatbench2 27 19 1 0 2\r\nd2819 floatbench1 28 19 1 0 2\r\ne1723 floatbench2 17 23 3 2 2\r\ne1923 floatbench2 19 23 3 6 2\r\ne2123 floatbench2 21 23 3 2 2\r\ne2323 floatbench2 23 23 3 6 2\r\ne2723 floatbench2 27 23 1 4 2\r\nd2823 floatbench1 28 23 1 4 2\r\nd1724 floatbench1 17 24 100000 2 2\r\nd1924 floatbench1 19 24 3 6 2\r\nd2124 floatbench1 21 24 3 2 2\r\nd2324 floatbench1 23 24 3 6 2\r\ne2725 floatbench2 27 25 1 0 2\r\nd2825 floatbench1 28 25 1 0 2\r\na1729 float_dummychair 17 29 1 2 2\r\na1730 float_dummychair 17 30 1 2 2\r\na1731 float_dummychair 17 31 1 2 2\r\na2133 float_dummychair 21 33 1 2 2\r\na2633 float_dummychair 26 33 1 6 2\r\na2134 float_dummychair 21 34 1 2 2\r\na2634 float_dummychair 26 34 1 6 2\r\na1735 float_dummychair 17 35 1 2 2\r\na2135 float_dummychair 21 35 1 2 2\r\na2635 float_dummychair 26 35 1 6 2\r\na1736 float_dummychair 17 36 1 2 2\r\na2136 float_dummychair 21 36 1 2 2\r\na2636 float_dummychair 26 36 1 6 2\r\na1537 float_dummychair 15 37 100000 4 2\r\na1637 float_dummychair 16 37 1 4 2', 0, '0', 1, NULL, NULL),
('sunset_cafe', 0, 34, 40, 0, 4, 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000xxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0000000xxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxx00000xx00000000xxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxx000000000000000000xxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxx000000000000000000xxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxx000000000000000000xxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxx000000000000000000xxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxx00000000xxx0000000xxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxx00000000xxxx000000xxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxx00000000xxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxx0000000000000000xxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxx00000000000000000xxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxx00000000000000000xxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxx00000000000000000xxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxx00000000000000000xxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxx00000000000000000xxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx00000000xxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0000000xxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0000xxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0000xxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0000xxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\n', 'd3221 chairup4 32 21 0 3 2\r\nf3321 chairup6 33 21 0 4 2\r\nf3421 chairup6 34 21 0 4 2\r\nf3521 chairup6 35 21 0 4 2\r\nf3621 chairup6 36 21 0 4 2\r\ng3721 chairup7 37 21 0 4 2\r\nb3222 chairup2 32 22 0 2 2\r\ne2523 chairup5 25 23 0 4 2\r\nf2623 chairup6 26 23 0 4 2\r\nf2723 chairup6 27 23 0 4 2\r\nf2823 chairup6 28 23 0 4 2\r\ng2923 chairup7 29 23 0 4 2\r\na3223 chairup1 32 23 0 2 2\r\nA2424 counter5 24 24 0 7 1\r\nr2524 table2 25 24 0 7 1\r\nq2624 table1 26 24 0 7 1\r\np2425 counter3 24 25 0 7 1\r\nz2426 counter4 24 26 0 7 1\r\np2427 counter3 24 27 0 7 1\r\np2428 counter3 24 28 0 7 1\r\ny2928 palms4 29 28 0 7 1\r\np2429 counter3 24 29 0 7 1\r\nx2929 palms3 29 29 0 7 1\r\np2430 counter3 24 30 0 7 1\r\nw2930 palms2 29 30 0 7 1\r\nn2231 counter1 22 31 0 7 1\r\nn2331 counter1 23 31 0 7 1\r\no2431 counter2 24 31 0 7 1\r\nv2931 palms1 29 31 0 7 1\r\ne3031 chairup5 30 31 0 4 2\r\nf3131 chairup6 31 31 0 4 2\r\nf3231 chairup6 32 31 0 4 2\r\nf3331 chairup6 33 31 0 4 2\r\nf3431 chairup6 34 31 0 4 2\r\nf3531 chairup6 35 31 0 4 2\r\nf3631 chairup6 36 31 0 4 2\r\nj3731 chairright3 37 31 0 5 2\r\nc2132 chairup3 21 32 0 2 2\r\nt2232 table4 22 32 0 7 1\r\nr3032 table2 30 32 0 7 1\r\nq3132 table1 31 32 0 7 1\r\nr3332 table2 33 32 0 7 1\r\nq3432 table1 34 32 0 7 1\r\ni3732 chairright2 37 32 0 6 2\r\nb2133 chairup2 21 33 0 2 2\r\ns2233 table3 22 33 0 7 1\r\ni3733 chairright2 37 33 0 6 2\r\nb2134 chairup2 21 34 0 2 2\r\nt3634 table4 36 34 0 7 1\r\ni3734 chairright2 37 34 0 6 2\r\nb2135 chairup2 21 35 0 2 2\r\nr2435 table2 24 35 0 7 1\r\nq2535 table1 25 35 0 7 1\r\nr2735 table2 27 35 0 7 1\r\nq2835 table1 28 35 0 7 1\r\nu3335 palm 33 35 0 7 1\r\ns3635 table3 36 35 0 7 1\r\ni3735 chairright2 37 35 0 6 2\r\nm2136 chairleft3 21 36 0 1 2\r\nl2236 chairleft2 22 36 0 0 2\r\nl2336 chairleft2 23 36 0 0 2\r\nl2436 chairleft2 24 36 0 0 2\r\nl2536 chairleft2 25 36 0 0 2\r\nl2636 chairleft2 26 36 0 0 2\r\nl2736 chairleft2 27 36 0 0 2\r\nk2836 chairleft1 28 36 0 0 2\r\ni3736 chairright2 37 36 0 6 2\r\nt3637 table4 36 37 0 7 1\r\ni3737 chairright2 37 37 0 6 2\r\ns3638 table3 36 38 0 7 1\r\nh3738 chairright1 37 38 0 6 2', 0, 'sf', 5000, 1, 6),
('pool_a', 0, 2, 25, 7, 2, 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx7xxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx777xxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxx7777777xxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxx77777777xxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx77777777xxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx777777777xxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx7xxx777777xxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx7x777777777xxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx7xxx77777777xxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx7x777777777x7xxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx7xxx7777777777xxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx777777777777xxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx77777777777x2111xxxxxxxxxxxx\rxxxxxxxxxxxxxxx7777777777x221111xxxxxxxxxxx\rxxxxxxxxx7777777777777777x2211111xxxxxxxxxx\rxxxxxxxxx7777777777777777x22211111xxxxxxxxx\rxxxxxxxxx7777777777777777x222211111xxxxxxxx\rxxxxxx77777777777777777777x222211111xxxxxxx\rxxxxxx7777777xx777777777777x222211111xxxxxx\rxxxxxx7777777xx77777777777772222111111xxxxx\rxxxxxx777777777777777777777x22221111111xxxx\rxx7777777777777777777777x322222211111111xxx\r77777777777777777777777x33222222111111111xx\r7777777777777777777777x333222222211111111xx\rxx7777777777777777777x333322222222111111xxx\rxx7777777777777777777333332222222221111xxxx\rxx777xxx777777777777733333222222222211xxxxx\rxx777x7x77777777777773333322222222222xxxxxx\rxx777x7x7777777777777x33332222222222xxxxxxx\rxxx77x7x7777777777777xx333222222222xxxxxxxx\rxxxx77777777777777777xxx3222222222xxxxxxxxx\rxxxxx777777777777777777xx22222222xxxxxxxxxx\rxxxxxx777777777777777777x2222222xxxxxxxxxxx\rxxxxxxx777777777777777777222222xxxxxxxxxxxx\rxxxxxxxx7777777777777777722222xxxxxxxxxxxxx\rxxxxxxxxx77777777777777772222xxxxxxxxxxxxxx\rxxxxxxxxxx777777777777777222xxxxxxxxxxxxxxx\rxxxxxxxxxxx77777777777777x2xxxxxxxxxxxxxxxx\rxxxxxxxxxxxx77777777777777xxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxx777777777777xxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxx7777777777xxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx77777777xxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxx777777xxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx7777xxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxx77xxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r', 'u184 umbrella2 18 4 7 0 1\r\nb185 pool_2sofa2 18 5 7 2 2\r\nB186 pool_2sofa1 18 6 7 2 2\r\nu720 umbrella2 7 20 7 0 1\r\nc820 pool_chair2 8 20 7 4 2\r\nu2420 umbrella2 24 20 7 0 1\r\nc2520 pool_chair2 25 20 7 4 2\r\nc721 pool_chair2 7 21 7 2 2\r\nt821 pool_table2 8 21 7 0 2\r\nc921 pool_chair2 9 21 7 6 2\r\nc2421 pool_chair2 24 21 7 2 2\r\nt2521 pool_table2 25 21 7 0 1\r\nc822 pool_chair2 8 22 7 0 2\r\nR228 flower2b 2 28 7 0 1\r\nr229 flower2a 2 29 7 0 1\r\nL632 box 6 32 7 0 1\r\nf1333 flower1 13 33 7 0 1\r\ny1034 pool_chairy 10 34 7 4 2\r\n8835 umbrellay 8 35 7 0 1\r\ny935 pool_chairy 9 35 7 2 2 2\r\nQ1035 pool_tabley 10 35 7 0 1\r\ny1135 pool_chairy 11 35 7 6 2\r\n91535 umbrellap 15 35 7 0 1\r\n72135 umbrellao 21 35 7 0 1\r\ny1036 pool_chairy 10 36 7 0 2\r\nP1536 pool_chairp 15 36 7 4 2\r\no2136 pool_chairo 21 36 7 4 2\r\no2236 pool_chairo 22 36 7 4 2\r\nP1437 pool_chairp 14 37 7 2 2\r\nZ1537 pool_tablep 15 37 7 0 1\r\nP1637 pool_chairp 16 37 7 6 2\r\nK2137 pool_tabo 21 37 7 6 1\r\nk2237 pool_tabo2 22 37 7 6 1\r\nP1438 pool_chairp 14 38 7 2 2\r\nz1538 pool_tablep2 15 38 7 0 1\r\nP1638 pool_chairp 16 38 7 6 2\r\no2138 pool_chairo 21 38 7 0 2\r\no2238 pool_chairo 22 38 7 0 2\r\nP1539 pool_chairp 15 39 7 0 2\r\ng2041 pool_chairg 20 41 7 4 2\r\ng2141 pool_chairg 21 41 7 4 2\r\nW2042 pool_tablg 20 42 7 6 1\r\nw2142 pool_tablg2 21 42 7 6 1\r\nG1943 umbrellag 19 43 7 0 1\r\ng2043 pool_chairg 20 43 7 0 2\r\ng2143 pool_chairg 21 43 7 0 2', 1, NULL, NULL, NULL, NULL),
('pub_a', 0, 15, 25, 0, 6, 'xxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxx2222222211111xxx\rxxxxxxxxx2222222211111xxx\rxxxxxxxxx2222222211111xxx\rxxxxxxxxx2222222211111xxx\rxxxxxxxxx2222222222111xxx\rxxxxxxxxx2222222222111xxx\rxxxxxxxxx2222222222000xxx\rxxxxxxxxx2222222222000xxx\rxxxxxxxxx2222222222000xxx\rxxxxxxxxx2222222222000xxx\rx333333332222222222000xxx\rx333333332222222222000xxx\rx333333332222222222000xxx\rx333333332222222222000xxx\rx333333332222222222000xxx\rx333332222222222222000xxx\rx333332222222222222000xxx\rx333332222222222222000xxx\rx333332222222222222000xxx\rx333333332222222222000xxx\rxxxxx31111112222222000xxx\rxxxxx31111111000000000xxx\rxxxxx31111111000000000xxx\rxxxxx31111111000000000xxx\rxxxxx31111111000000000xxx\rxxxxxxxxxxxxxxx00xxxxxxxx\rxxxxxxxxxxxxxxx00xxxxxxxx\rxxxxxxxxxxxxxxx00xxxxxxxx\rxxxxxxxxxxxxxxx00xxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxx\r', 'S191 pub_sofa2 19 1 1 4 1\r\ns201 pub_sofa 20 1 1 4 2\r\ns211 pub_sofa 21 1 1 4 2\r\nq112 bardesk1 11 2 2 0 1\r\nc122 pub_chair 12 2 2 6 2\r\nQ113 bardesk2 11 3 2 0 1\r\nq114 bardesk1 11 4 2 0 1\r\nc124 pub_chair 12 4 2 6 2\r\nQ115 bardesk2 11 5 2 0 1\r\nf185 pub_fence 18 5 2 1 1\r\nq116 bardesk1 11 6 2 0 1\r\nc126 pub_chair 12 6 2 6 2\r\nf186 pub_fence 18 6 2 0 1\r\nQ117 bardesk2 11 7 2 0 1\r\nf187 pub_fence 18 7 2 0 1\r\nq118 bardesk1 11 8 2 0 1\r\nc128 pub_chair 12 8 2 6 2\r\nf188 pub_fence 18 8 2 0 1\r\nw109 bardesk4 10 9 2 0 1\r\nW119 bardesk3 11 9 2 0 1\r\nf189 pub_fence 18 9 2 0 1\r\nf1810 pub_fence 18 10 2 0 1\r\nC211 pub_chair2 2 11 3 4 2\r\nC311 pub_chair2 3 11 3 4 2\r\nC511 pub_chair2 5 11 3 4 2\r\nC611 pub_chair2 6 11 3 4 2\r\nf811 pub_fence 8 11 3 1 1\r\nf1811 pub_fence 18 11 2 0 1\r\nf812 pub_fence 8 12 3 0 1\r\nf1812 pub_fence 18 12 2 0 1\r\nf813 pub_fence 8 13 3 0 1\r\nC913 pub_chair2 9 13 2 2 2\r\nk1413 pub_chair3 14 13 2 2 2\r\nT1513 pub_table2 15 13 2 1 1\r\nk1613 pub_chair3 16 13 2 6 2\r\nf1813 pub_fence 18 13 2 0 1\r\nf814 pub_fence 8 14 3 2 1\r\nC914 pub_chair2 9 14 2 2 2\r\nk1414 pub_chair3 14 14 2 2 2\r\nT1514 pub_table2 15 14 2 2 1\r\nk1614 pub_chair3 16 14 2 6 2\r\nf1814 pub_fence 18 14 2 0 1\r\nt115 pub_table 1 15 3 0 1\r\nf515 pub_fence 5 15 3 1 1\r\nf1815 pub_fence 18 15 2 0 1\r\nS116 pub_sofa2 1 16 3 2 2\r\nf516 pub_fence 5 16 3 0 1\r\nf1816 pub_fence 18 16 2 0 1\r\ns117 pub_sofa 1 17 3 2 2\r\nf517 pub_fence 5 17 3 0 1\r\nk1317 pub_chair3 13 17 2 4 2\r\nk1417 pub_chair3 14 17 2 4 2\r\nk1517 pub_chair3 15 17 2 4 2\r\nk1617 pub_chair3 16 17 2 4 2\r\nf1817 pub_fence 18 17 2 0 1\r\ns118 pub_sofa 1 18 3 2 2\r\nf518 pub_fence 5 18 3 0 1\r\nT1318 pub_table2 13 18 2 5 1\r\nT1418 pub_table2 14 18 2 6 1\r\nT1518 pub_table2 15 18 2 6 1\r\nT1618 pub_table2 16 18 2 4 1\r\nf1818 pub_fence 18 18 2 0 1\r\ns219 pub_sofa 2 19 3 0 2\r\nS319 pub_sofa2 3 19 3 0 2\r\nf519 pub_fence 5 19 3 0 1\r\nk1319 pub_chair3 13 19 2 0 2\r\nk1419 pub_chair3 14 19 2 0 2\r\nk1519 pub_chair3 15 19 2 0 2\r\nk1619 pub_chair3 16 19 2 0 2\r\nf1819 pub_fence 18 19 2 0 1\r\nf120 pub_fence 1 20 3 5 1\r\nf220 pub_fence 2 20 3 6 1\r\nf320 pub_fence 3 20 3 6 1\r\nf420 pub_fence 4 20 3 6 1\r\nf520 pub_fence 5 20 3 3 1\r\nf1820 pub_fence 18 20 2 0 1\r\nS721 pub_sofa2 7 21 1 4 2\r\ns821 pub_sofa 8 21 1 4 2\r\nf1221 pub_fence 12 21 2 5 1\r\nf1321 pub_fence 13 21 2 6 1\r\nf1421 pub_fence 14 21 2 6 1\r\nf1521 pub_fence 15 21 2 6 1\r\nf1621 pub_fence 16 21 2 6 1\r\nf1721 pub_fence 17 21 2 6 1\r\nf1821 pub_fence 18 21 2 3 1\r\nS622 pub_sofa2 6 22 1 2 2\r\nt1522 pub_table 15 22 0 0 1\r\nC1622 pub_chair2 16 22 0 4 2\r\nC1722 pub_chair2 17 22 0 4 2\r\ns623 pub_sofa 6 23 1 2 2\r\nT823 pub_table2 8 23 1 1 1\r\ns624 pub_sofa 6 24 1 2 2\r\nT824 pub_table2 8 24 1 0 1\r\ns625 pub_sofa 6 25 1 2 2\r\nT825 pub_table2 8 25 1 2 1', 0, '0', 1, NULL, NULL),
('md_a', 0, 1, 5, 7, 2, 'xxxxxxxx77xxxxxxxxxxxxxxxx\rxxxxxxxx77xxxxxxxxxxxxxxxx\rxxxxxx77777x77xxxxxxxxxxxx\rxxx77777777777xxx44xxxxxxx\r77777777777777xx444444444x\r777777777777777xx44444444x\rxxx777777777777xx44444444x\rxxxx7777777777xxx44444444x\r7777777777777777744448444x\r7777777777777x4x744448444x\r777777777777x444444448444x\r7777777777774444444448444x\r7777777777774444444448444x\r777777777777x444444448444x\r7777777777777x44444448444x\rxxx777777777777x444448444x\rxxx7777777777777444448444x\rxxx7777777777777444448444x\rxxx777777777777x444448444x\rxxx77777777777x4444444444x\rxxxx777777777444444444444x\rxxxxxxxxxxxxxxxxxxxxxxxxxx\r', 'A43 mntdwchair 4 3 7 4 2\r\nA53 mntdwchair 5 3 7 4 2\r\nM28 barmask 2 8 7 0 1\r\ns78 mntdwsofa2 7 8 7 2 2\r\nt88 mntdwtable2 8 8 7 0 2\r\ns98 mntdwsofa2 9 8 7 6 2\r\ny218 paalu5 21 8 8 0 1\r\nM29 barmask 2 9 7 0 1\r\nS79 mntdwsofa1 7 9 7 2 2\r\nT89 mntdwtable1 8 9 7 0 2\r\nS99 mntdwsofa1 9 9 7 6 2\r\ny219 paalu5 21 9 8 0 1\r\nM210 barmask 2 10 7 0 1\r\ny2110 paalu5 21 10 8 0 1\r\nM211 barmask 2 11 7 0 1\r\ny2111 paalu5 21 11 8 0 1\r\nM212 barmask 2 12 7 0 1\r\ns712 mntdwsofa2 7 12 7 4 2\r\nS812 mntdwsofa1 8 12 7 4 2\r\ne2112 paalu3 21 12 8 0 1\r\nM213 barmask 2 13 7 0 1\r\nt713 mntdwtable2 7 13 7 2 1\r\nT813 mntdwtable1 8 13 7 2 1\r\ne2113 paalu3 21 13 8 0 1\r\nM214 barmask 2 14 7 0 1\r\ns714 mntdwsofa2 7 14 7 0 2\r\nS814 mntdwsofa1 8 14 7 0 2\r\ne2114 paalu3 21 14 8 0 1\r\nM215 barmask 2 15 100000 0 1\r\nq2115 paalu1 21 15 8 0 1\r\nM216 barmask 2 16 100000 0 1\r\ns1216 mntdwsofa2 12 16 7 4 2\r\nS1316 mntdwsofa1 13 16 7 4 2\r\nq2116 paalu1 21 16 8 0 1\r\nA317 mntdwchair 3 17 7 2 2\r\ns617 mntdwsofa2 6 17 7 2 2\r\nt717 mntdwtable2 7 17 7 0 1\r\ns817 mntdwsofa2 8 17 7 6 2\r\nt1217 mntdwtable2 12 17 7 2 1\r\nT1317 mntdwtable1 13 17 7 2 1\r\nq2117 paalu1 21 17 8 0 1\r\nA318 mntdwchair 3 18 7 2 2\r\nS618 mntdwsofa1 6 18 7 2 2\r\nT718 mntdwtable1 7 18 7 0 1\r\nS818 mntdwsofa1 8 18 7 6 2\r\ns1218 mntdwsofa2 12 18 7 0 2\r\nS1318 mntdwsofa1 13 18 7 0 2\r\nq2118 paalu1 21 18 8 0 1', 1, 'cam1', 4500, 1, 4),
('picnic', 0, 16, 5, 2, 4, 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxx22222xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r22xxxxxxxxxxxxx22xxxxxxxxxxxxxxxxxxxxx\r2222222222222222222x222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222xxx222222222222222222222222\r2222222222xx33x22222222222222222222222\r222222222xx3333x2222222222222222222222\r222222222x333333x222222222222222222222\r222222222x333333x222222222222222222222\r2222222222x3332x2222222222222222222222\r22222222222x33x22222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222x22222xxxx22222222222222222222\r22222222222222xxxx22222222222222222222\r22222222222222xxx222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r22222222222222222222222222222222222222\r', 'h107 hedge7 10 7 2 4 1\r\nh117 hedge7 11 7 2 4 1\r\nh127 hedge7 12 7 2 4 1\r\nh137 hedge7 13 7 2 4 1\r\ny147 hedge8 14 7 2 4 1\r\ns187 hedge2 18 7 2 4 1\r\nh197 hedge7 19 7 2 4 1\r\nh207 hedge7 20 7 2 4 1\r\nh217 hedge7 21 7 2 4 1\r\nz148 hedge9 14 8 2 4 1\r\nz188 hedge9 18 8 2 4 1\r\nv39 hedge5 3 9 2 4 1\r\nz310 hedge9 3 10 2 4 1\r\nc1211 picnic_dummychair1 12 11 3 4 2\r\nc1311 picnic_dummychair1 13 11 3 4 2\r\nc1411 picnic_dummychair1 14 11 100000 4 2\r\nc1013 picnic_dummychair1 10 13 3 2 2\r\nc1513 picnic_dummychair1 15 13 3 6 2\r\nb2113 picnic_ground 21 13 2 4 2\r\nb714 picnic_ground 7 14 2 4 2\r\nc1014 picnic_dummychair1 10 14 3 2 2\r\nc1514 picnic_dummychair1 15 14 3 6 2\r\nb1915 picnic_ground 19 15 2 2 2\r\nb2315 picnic_ground 23 15 2 6 2\r\nb516 picnic_ground 5 16 2 2 2\r\nb916 picnic_ground 9 16 2 6 2\r\nL2016 picnic_cloth1 20 16 2 2 1\r\nL617 picnic_cloth1 6 17 2 2 1\r\nb2117 picnic_ground 21 17 2 0 2\r\nb718 picnic_ground 7 18 2 0 2\r\na019 picnic_redbench2 0 19 2 2 2\r\nA020 picnic_redbench1 0 20 2 2 2\r\nw1120 hedge6 11 20 2 4 1\r\nh1220 hedge7 12 20 2 4 1\r\nh1320 hedge7 13 20 2 4 1\r\nt1420 hedge3 14 20 2 4 1\r\nu1720 hedge4 17 20 2 4 1\r\nh1820 hedge7 18 20 2 4 1\r\nh1920 hedge7 19 20 2 4 1\r\ny2020 hedge8 20 20 2 4 1\r\nv1121 hedge5 11 21 2 4 1\r\nM1221 picnic_bench1 12 21 2 4 2\r\nN1321 picnic_bench2 13 21 2 4 2\r\nO1421 picnic_bench3 14 21 2 4 2\r\nM1721 picnic_bench1 17 21 2 4 2\r\nN1821 picnic_bench2 18 21 2 4 2\r\nO1921 picnic_bench3 19 21 2 4 2\r\nv2021 hedge5 20 21 2 4 1\r\na022 picnic_redbench2 0 22 2 2 2\r\nv1122 hedge5 11 22 2 4 1\r\nv2022 hedge5 20 22 2 4 1\r\nb2522 picnic_ground 25 22 2 4 1\r\nA023 picnic_redbench1 0 23 2 2 2\r\nv1123 hedge5 11 23 2 4 1\r\nM1223 picnic_bench1 12 23 2 2 2\r\nM1923 picnic_bench1 19 23 2 6 2\r\nv2023 hedge5 20 23 2 4 1\r\nc624 picnic_dummychair1 6 24 2 4 2\r\nd724 picnic_dummychair4 7 24 2 4 2\r\ne824 picnic_dummychair6 8 24 2 4 2\r\nv1124 hedge5 11 24 2 4 1\r\nN1224 picnic_bench2 12 24 2 2 2\r\nN1924 picnic_bench2 19 24 2 6 2\r\nv2024 hedge5 20 24 2 4 1\r\nb2324 picnic_ground 23 24 2 2 2\r\nb2724 picnic_ground 27 24 2 6 2\r\nK525 picnic_stump 5 25 2 2 2\r\nv1125 hedge5 11 25 2 4 1\r\nN1225 picnic_bench2 12 25 2 2 2\r\nN1925 picnic_bench2 19 25 2 6 2\r\nv2025 hedge5 20 25 2 4 1\r\nG2425 picnic_cloth2 24 25 2 2 1\r\nK726 picnic_stump 7 26 2 0 2\r\nv1126 hedge5 11 26 2 4 1\r\nO1226 picnic_bench3 12 26 2 2 2\r\nH1426 picnic_fireplace1 14 26 2 0 1\r\nI1626 picnic_fireplace2 16 26 2 2 1\r\nO1926 picnic_bench3 19 26 2 6 2\r\nv2026 hedge5 20 26 2 4 1\r\nb2526 picnic_ground 25 26 2 0 1\r\nz1127 hedge9 11 27 2 4 1\r\nQ1227 picnic_lemonade 12 27 2 4 1\r\nz2027 hedge9 20 27 2 4 1\r\nE829 picnic_firewood2 8 29 2 0 1\r\na030 picnic_redbench2 0 30 2 2 2\r\nD830 picnic_firewood1 8 30 2 0 1\r\nA031 picnic_redbench1 0 31 2 2 2\r\nD831 picnic_firewood1 8 31 2 0 1\r\nM1231 picnic_bench1 12 31 2 4 2\r\nN1331 picnic_bench2 13 31 2 4 2\r\nO1431 picnic_bench3 14 31 2 4 2\r\nM1831 picnic_bench1 18 31 2 4 2\r\nN1931 picnic_bench2 19 31 2 4 2\r\nO2031 picnic_bench3 20 31 2 4 2\r\nf2731 picnic_carrot 27 31 2 0 1\r\nf2831 picnic_carrot 28 31 2 0 1\r\nf2931 picnic_carrot 29 31 2 0 1\r\nf3031 picnic_carrot 30 31 2 0 1\r\nf3131 picnic_carrot 31 31 2 0 1\r\nD832 picnic_firewood1 8 32 2 0 1\r\nF1232 picnic_table2 12 32 2 2 1\r\nP1432 picnic_table 14 32 2 2 1\r\nF1832 picnic_table2 18 32 2 2 1\r\nP2032 picnic_table 20 32 2 2 1\r\nr333 hedge1 3 33 2 4 1\r\nD833 picnic_firewood1 8 33 2 0 1\r\nM1233 picnic_bench1 12 33 2 0 2\r\nN1333 picnic_bench2 13 33 2 0 2\r\nO1433 picnic_bench3 14 33 2 0 2\r\nM1833 picnic_bench1 18 33 2 0 2\r\nN1933 picnic_bench2 19 33 2 0 2\r\nO2033 picnic_bench3 20 33 2 0 2\r\ng2733 picnic_cabbage 27 33 2 0 1\r\ng2833 picnic_cabbage 28 33 2 0 1\r\ng2933 picnic_cabbage 29 33 2 0 1\r\nv334 hedge5 3 34 2 4 1\r\nD834 picnic_firewood1 8 34 2 0 1\r\nv335 hedge5 3 35 2 4 1\r\nD835 picnic_firewood1 8 35 2 0 1\r\nv336 hedge5 3 36 2 4 1\r\nD836 picnic_firewood1 8 36 2 0 1\r\nD837 picnic_firewood1 8 37 2 0 1\r\nM1237 picnic_bench1 12 37 2 4 2\r\nN1337 picnic_bench2 13 37 2 4 2\r\nO1437 picnic_bench3 14 37 2 4 2\r\nM1837 picnic_bench1 18 37 2 4 2\r\nN1937 picnic_bench2 19 37 2 4 2\r\nO2037 picnic_bench3 20 37 2 4 2\r\nD838 picnic_firewood1 8 38 2 0 1\r\nF1238 picnic_table2 12 38 2 2 1\r\nP1438 picnic_table 14 38 2 2 1\r\nF1838 picnic_table2 18 38 2 2 1\r\nP2038 picnic_table 20 38 2 2 1\r\nJ839 picnic_firewood3 8 39 2 0 1\r\nM1239 picnic_bench1 12 39 2 0 2\r\nN1339 picnic_bench2 13 39 2 0 2\r\nO1439 picnic_bench3 14 39 2 0 2\r\nM1839 picnic_bench1 18 39 2 0 2\r\nN1939 picnic_bench2 19 39 2 0 2\r\nO2039 picnic_bench3 20 39 2 0 2', 0, '0', 1, NULL, NULL),
('park_a', 0, 2, 15, 0, 6, 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0xxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx00xxxxxxxxxxxx\rxxxxxxxxxxxxx0x00xxxxxxxxxxx0x000xxxxxxxxxxx\rxxxxxxxxxxxx0000000000000000000000xxxxxxxxxx\rxxxxxxxxxxx000000000000000000000000xxxxxxxxx\rxxxxxxxxxxx0000000000000000000000000xxxxxxxx\rxxxxxxxxxxx00000000000000000000000000xxxxxxx\rxxxxxxxx000000000000000000000000000000xxxxxx\rxxxxxxx00000000000000000000000000000000xxxxx\rxxxxxxx000000000000000000000000000000000xxxx\rxxxxxxx0000000000000000000000000000000000xxx\rxxxxxxxxx000000000000000000000000000000000xx\r00000000000000000000xx00000000000000000000xx\r0000000000000000000xxxx00000000000xxxxxxx0xx\r0000000000000000000xxxx00000000000x00000xxxx\rxxxxx00x0000000000xxxxx0xxxxxx0000x0000000xx\rxxxxx0000000000000xxxxx0xx000x0000x000000xxx\rxxxxx0000000000000xxxxx0x000000000x00000xxxx\rxxxxx000000x0000000xxxx0x000000000xxx00xxxxx\rxxxxxxxx000x0000000xxx00xxx000000x0000xxxxxx\rxxxxxxxx000x000000xxxx0x0000000000000xxxxxxx\rxxxxxxxx000x000000011100000000000000xxxxxxxx\rxxxxxxxx000x00000001110000000000000xxxxxxxxx\rxxxxxxxxx00x0000000111x00000000x00xxxxxxxxxx\rxxxxxxxxxx0x0000000xxx0000000xxxxxxxxxxxxxxx\rxxxxxxxxxxxx000000xxxx0000000xxxxxxxxxxxxxxx\rxxxxxxxxxxxx000000xxx00xxxxx00xxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx0xxx0xx000x00xxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx0xxx0x000000xxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx0xxx0x00000xxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx0xxxxx00xxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx0xxxxx0xxxxxxxxxxxxxxxxxxxx\r', 'L89 bench2 8 9 0 4 2\r\nK99 bench 9 9 0 4 2\r\nL711 bench2 7 11 0 2 2\r\nK712 bench 7 12 0 2 2\r\nL3516 bench2 35 16 0 2 2\r\nL3716 bench2 37 16 0 4 2\r\nK3816 bench 38 16 0 4 2\r\nK3517 bench 35 17 0 2 2\r\nL2718 bench2 27 18 0 4 2\r\nK2818 bench 28 18 0 4 2\r\nL3518 bench2 35 18 0 2 2\r\nL2519 bench2 25 19 0 2 2\r\nK3519 bench 35 19 0 2 2\r\nK2520 bench 25 20 0 2 2\r\nL2529 bench2 25 29 0 4 2\r\nK2629 bench 26 29 0 4 2\r\nL2330 bench2 23 30 0 2 2\r\nK2331 bench 23 31 0 2 2', 0, NULL, 1, NULL, NULL),
('park_b', 0, 11, 2, 0, 6, '0000x0000000\r0000xx000000\r000000000000\r00000000000x\r000000000000\r00x0000x0000\r', 'C00 cornerchair2 0 0 0 4 2\r\nB10 cornerchair1 1 0 0 4 2\r\nA20 chair1 2 0 0 4 2\r\nA30 chair1 3 0 0 4 2\r\nH50 table1 5 0 0 4 1\r\nE60 chair1line 6 0 0 4 2\r\nA70 chair1 7 0 0 4 2\r\nF80 chair1frontend 8 0 0 4 2\r\nJ100 hububar 10 0 0 4 1\r\nB01 cornerchair1 0 1 0 2 2\r\nA02 chair1 0 2 0 2 2\r\nA03 chair1 0 3 0 2 2\r\nA04 chair1 0 4 0 2 2\r\nF05 chair1frontend 0 5 0 2 2\r\nI35 table2 3 5 0 4 1\r\nD55 modchair 5 5 0 0 2\r\nI85 table2 8 5 0 4 1', 0, NULL, 1, NULL, NULL),
('pool_b', 0, 9, 21, 7, 0, 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx7xxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx777xxxxxxxxxxx\rxxxxxxxxxxxxxxxxxx8888888x7xxx77777xxxxxxxxxx\rxxxxxxxxxxxxxxxxxx8888888x7xxx777777xxxxxxxxx\rxxxxxxxxxxxxxxxx88xxxxx77x7x777777777xxxxxxxx\rxxxxxxxxxxxxxxxx88x7777777777777777777xxxxxxx\rxxxxxxxxxxxxxxxx88x77777777777777777777xxxxxx\rxxxxxxxxxxxxxx9988x77777777777777777777xxxxxx\rxxxxxxxxxxxxxx9988x7777777777777777777x00xxxx\rxxxxxxxxxxxxxx9988x777777777777777777x0000xxx\rxxxxxxxxxxxxxx9988x7777777x0000000000000000xx\rxxxxxxxxxxxxxx9988x777777x000000000000000000x\r7777777777xxxx9988777777x0x0000000000000000xx\rx7777777777xxx998877777x000x00000000000000xxx\rxx7777777777xx99887777x00000x000000000000xxxx\rxxx7777777777x9988777x0000000x0000000000xxxxx\rxxxx777777777x777777x00000000x000000000xxxxxx\rxxxxx777777777777777000000000x00000000xxxxxxx\rxxxxxx77777777777777000000000x0000000xxxxxxxx\rxxxxxxx777777x7777770000000000xxxx00xxxxxxxxx\rxxxxxxxx77777777777xx0000000000000xxxxxxxxxxx\rxxxxxxxxx777777110000x000000000000xxxxxxxxxxx\rxxxxxxxxxx7x77x1100000x0000000000xxxxxxxxxxxx\rxxxxxxxxxxx777x11000000x00000000xxxxxxxxxxxxx\rxxxxxxxxxxxx771110000000x000000xxxxxxxxxxxxxx\rxxxxxxxxxxxxx111100000000x0000xxxxxxxxxxxxxxx\rxxxxxxxxxxxxxx11100000000x000xxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxx1100000000x00xxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxx110000000x0xxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxx110000000xxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxx1100000xxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxx11000xxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxx110xxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxx1xxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'u332 umbrella2 33 2 7 0 1\r\nb183 pool_2sofa2 18 3 8 4 2\r\nB193 pool_2sofa1 19 3 8 4 2\r\nb203 pool_2sofa2 20 3 8 4 2\r\nB213 pool_2sofa1 21 3 8 4 2\r\nb223 pool_2sofa2 22 3 8 4 2\r\nB233 pool_2sofa1 23 3 8 4 2\r\nc333 pool_chair2 33 3 7 4 2\r\nc324 pool_chair2 32 4 7 2 2\r\nt334 pool_table2 33 4 7 0 1\r\nc344 pool_chair2 34 4 7 6 2\r\nb165 pool_2sofa2 16 5 8 2 2\r\nc335 pool_chair2 33 5 7 0 2\r\nB166 pool_2sofa1 16 6 8 2 2\r\nb167 pool_2sofa2 16 7 8 2 2\r\nc357 pool_chair2 35 7 7 4 2\r\nf148 flower1 14 8 9 0 1\r\nB168 pool_2sofa1 16 8 8 2 2\r\nu338 umbrella2 33 8 7 0 1\r\nc348 pool_chair2 34 8 7 2 2\r\nt358 pool_table2 35 8 7 0 1\r\nc368 pool_chair2 36 8 7 6 2\r\nb149 pool_2sofa2 14 9 9 2 2\r\nb169 pool_2sofa2 16 9 8 2 2\r\nc359 pool_chair2 35 9 7 0 2\r\nB1410 pool_2sofa1 14 10 9 2 2\r\nB1610 pool_2sofa1 16 10 8 2 2\r\nb1411 pool_2sofa2 14 11 9 2 2\r\nb1611 pool_2sofa2 16 11 8 2 2\r\nB1412 pool_2sofa1 14 12 9 2 2\r\nB1612 pool_2sofa1 16 12 8 2 2\r\nR313 flower2b 3 13 7 2 1\r\nr413 flower2a 4 13 7 2 1\r\nb1413 pool_2sofa2 14 13 9 2 2\r\nb1613 pool_2sofa2 16 13 8 2 2\r\nB1414 pool_2sofa1 14 14 9 2 2\r\nB1614 pool_2sofa1 16 14 8 2 2', 1, 'cam1', 4500, 1, 4);

-- --------------------------------------------------------

--
-- Table structure for table `room_modeldata_triggers`
--

CREATE TABLE `room_modeldata_triggers` (
  `id` int(5) NOT NULL,
  `model` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `object` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `x` int(5) NOT NULL DEFAULT 0,
  `y` int(5) NOT NULL DEFAULT 0,
  `stepx` int(5) NOT NULL,
  `stepy` int(5) NOT NULL,
  `goalx` int(5) NOT NULL,
  `goaly` int(5) NOT NULL,
  `roomid` int(10) NOT NULL DEFAULT 0,
  `state` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `room_modeldata_triggers`
--

INSERT INTO `room_modeldata_triggers` (`id`, `model`, `object`, `x`, `y`, `stepx`, `stepy`, `goalx`, `goaly`, `roomid`, `state`) VALUES
(1, 'pool_a', 'curtains1', 17, 11, 0, 0, 19, 11, 0, '0'),
(2, 'pool_a', 'curtains2', 17, 9, 0, 0, 19, 9, 0, '0'),
(5, 'md_a', 'curtains1', 8, 0, 0, 0, 8, 2, 0, '0'),
(6, 'md_a', 'curtains2', 9, 0, 0, 0, 9, 2, 0, '0'),
(3, 'pool_a', 'Splash0 enter', 20, 28, 21, 28, 22, 28, 0, '0'),
(4, 'pool_a', 'Splash0 exit', 21, 28, 20, 28, 19, 28, 0, '0'),
(7, 'md_a', 'Splash0 enter', 11, 11, 12, 12, 13, 12, 0, '0'),
(8, 'md_a', 'Splash0 exit', 12, 12, 11, 11, 10, 11, 0, '0'),
(9, 'pool_b', 'door', 0, 0, 0, 0, 0, 0, 0, '0');

-- --------------------------------------------------------

--
-- Table structure for table `room_rights`
--

CREATE TABLE `room_rights` (
  `roomid` int(11) NOT NULL,
  `userid` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_votes`
--

CREATE TABLE `room_votes` (
  `roomid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `vote` int(2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `room_votes`
--

INSERT INTO `room_votes` (`roomid`, `userid`, `vote`) VALUES
(201, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `soundmachine_playlists`
--

CREATE TABLE `soundmachine_playlists` (
  `machineid` int(10) NOT NULL,
  `songid` int(10) NOT NULL,
  `pos` int(3) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `soundmachine_songs`
--

CREATE TABLE `soundmachine_songs` (
  `id` int(10) NOT NULL,
  `userid` int(10) NOT NULL,
  `title` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `machineid` int(10) NOT NULL,
  `length` int(3) NOT NULL,
  `data` text COLLATE latin1_general_ci NOT NULL,
  `burnt` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system`
--

CREATE TABLE `system` (
  `onlinecount` int(3) NOT NULL DEFAULT 0,
  `onlinecount_peak` int(10) NOT NULL,
  `connections_accepted` int(10) NOT NULL,
  `activerooms` int(10) NOT NULL,
  `activerooms_peak` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `system`
--

INSERT INTO `system` (`onlinecount`, `onlinecount_peak`, `connections_accepted`, `activerooms`, `activerooms_peak`) VALUES
(1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `system_chatlog`
--

CREATE TABLE `system_chatlog` (
  `username` varchar(15) COLLATE latin1_general_ci NOT NULL,
  `roomid` int(10) NOT NULL,
  `mtime` time NOT NULL DEFAULT '00:00:00',
  `message` varchar(200) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_config`
--

CREATE TABLE `system_config` (
  `id` int(10) NOT NULL,
  `skey` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `sval` text COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `system_config`
--

INSERT INTO `system_config` (`id`, `skey`, `sval`) VALUES
(1, 'server_game_port', '12321'),
(2, 'server_game_maxconnections', '400'),
(4, 'server_mus_port', '22'),
(5, 'server_mus_maxconnections', '500'),
(6, 'server_mus_host', '127.0.0.1'),
(3, 'server_game_backlog', '25'),
(7, 'server_mus_backlog', '50'),
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
(21, 'statuses_carryitem_sipamount', '5'),
(22, 'statuses_carryitem_sipinterval', '9000'),
(23, 'statuses_carryitem_sipduration', '1000'),
(24, 'rooms_roomban_duration', '15'),
(25, 'items_stacking_maxstackheight', '20'),
(28, 'navigator_roomsearch_maxresults', '30'),
(27, 'navigator_createroom_maxrooms', '15'),
(26, 'events_categorycount', '11'),
(29, 'navigator_opencategory_maxresults', '30'),
(30, 'navigator_favourites_maxrooms', '30'),
(31, 'events_deadevents_removeinterval', '120'),
(32, 'soundmachine_burntodisk_disktid', '1001'),
(35, 'game_bb_gamelength_seconds', '180'),
(34, 'game_scorewindow_restartgame_seconds', '1200'),
(33, 'game_countdown_seconds', '15'),
(36, 'spectator_bar_enabled', '0'),
(37, 'max_registered_per_ip', '3'),
(38, 'max_online_per_ip', '10');

-- --------------------------------------------------------

--
-- Table structure for table `system_fuserights`
--

CREATE TABLE `system_fuserights` (
  `id` int(3) NOT NULL,
  `minrank` int(1) NOT NULL,
  `fuseright` varchar(100) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `system_fuserights`
--

INSERT INTO `system_fuserights` (`id`, `minrank`, `fuseright`) VALUES
(1, 1, 'default'),
(2, 1, 'fuse_login'),
(3, 1, 'fuse_buy_credits'),
(4, 1, 'fuse_trade'),
(5, 1, 'fuse_room_queue_default'),
(6, 2, 'fuse_extended_buddylist'),
(7, 2, 'fuse_habbo_chooser'),
(8, 2, 'fuse_furni_chooser'),
(9, 2, 'fuse_room_queue_club'),
(10, 2, 'fuse_priority_access'),
(11, 2, 'fuse_use_special_room_layouts'),
(12, 2, 'fuse_use_club_dance'),
(13, 3, 'fuse_enter_full_rooms'),
(14, 4, 'fuse_enter_locked_rooms'),
(16, 4, 'fuse_kick'),
(17, 4, 'fuse_mute'),
(18, 5, 'fuse_ban'),
(19, 5, 'fuse_room_mute'),
(20, 5, 'fuse_room_kick'),
(21, 5, 'fuse_receive_calls_for_help'),
(22, 5, 'fuse_remove_stickies'),
(23, 5, 'fuse_mod'),
(24, 6, 'fuse_superban'),
(25, 6, 'fuse_pick_up_any_furni'),
(26, 6, 'fuse_ignore_room_owner'),
(27, 6, 'fuse_any_room_controller'),
(28, 3, 'fuse_room_alert'),
(29, 6, 'fuse_moderator_access'),
(30, 7, 'fuse_administrator_access'),
(31, 7, 'fuse_see_flat_ids'),
(35, 5, 'fuse_chat_log'),
(33, 6, 'fuse_performance_panel'),
(34, 4, 'fuse_alert'),
(36, 5, 'fuse_see_all_roomowners'),
(37, 6, 'fuse_hotelalert'),
(38, 6, 'fuse_teleport'),
(39, 7, 'fuse_guide'),
(40, 7, 'fuse_freeze'),
(41, 6, 'fuse_chat_log');

-- --------------------------------------------------------

--
-- Table structure for table `system_recycler`
--

CREATE TABLE `system_recycler` (
  `rclr_cost` int(5) NOT NULL,
  `rclr_reward` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `system_recycler`
--

INSERT INTO `system_recycler` (`rclr_cost`, `rclr_reward`) VALUES
(20, 419),
(30, 420),
(40, 421);

-- --------------------------------------------------------

--
-- Table structure for table `system_stafflog`
--

CREATE TABLE `system_stafflog` (
  `id` int(5) NOT NULL,
  `action` varchar(12) COLLATE latin1_general_ci NOT NULL,
  `message` text COLLATE latin1_general_ci DEFAULT NULL,
  `note` text COLLATE latin1_general_ci DEFAULT NULL,
  `userid` int(11) NOT NULL,
  `targetid` int(11) DEFAULT NULL,
  `timestamp` varchar(50) COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_strings`
--

CREATE TABLE `system_strings` (
  `id` int(5) NOT NULL,
  `stringid` varchar(100) COLLATE latin1_general_ci NOT NULL DEFAULT 'null',
  `var_en` text COLLATE latin1_general_ci DEFAULT NULL,
  `var_de` text COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `system_strings`
--

INSERT INTO `system_strings` (`id`, `stringid`, `var_en`, `var_de`) VALUES
(1, 'console_onhotelview', 'On Hotel View', 'auf Hotelansicht'),
(2, 'modtool_accesserror', 'Sorry, but you do not have access to this feature of the MOD-Tool.\\rIf you think you should have access to this feature, then please contact the Hotel staff.\\rIf not, gtfo.', NULL),
(3, 'modtool_actionfail', 'Action failed.', NULL),
(4, 'modtool_rankerror', 'You do not have the rights for this action on this user!', NULL),
(5, 'modtool_usernotfound', 'Probably the user is offline or does not exist.', NULL),
(6, 'room_rightsreset', 'The roomowner has reset all the roomrights.<br>Please re-enter the room.', NULL),
(7, 'trading_disabled', 'Sorry, but the Hotel staff has disabled trading.\\rPlease try later!', NULL),
(8, 'trading_nottradeable', 'Sorry, but you can\'t trade this item!', NULL),
(9, 'welcomemessage_text', 'Welcome at the Holograph Testserver.<br>Please don\'t bitch or whine about bugs, better report them.<br>- Jukebox is not coded<br>- Any lag is due to the interwebs or Qurb<br><br>Nillus', NULL),
(10, 'console_inpublicroom', 'In Public Room', NULL),
(11, 'room_stafflocked', 'Sorry, but only Staff is allowed to enter this room.', NULL),
(12, 'room_full', 'Sorry, but this publicroom is full.', NULL),
(13, 'room_infobus_closed', 'Sorry, but the Infobus is closed at the moment.', NULL),
(14, 'scommand_hotelalert', 'Message from the Hotel management:', NULL),
(15, 'scommand_failed', 'Unable to process speech command.\r\nCheck your parameters and/or make sure that the target user is in room. (if any)', NULL),
(16, 'scommand_success', 'Speech command processed, action performed.', NULL),
(17, 'scommand_muted', 'You have been muted for the following reason:', NULL),
(18, 'scommand_unmuted', 'You have been unmuted.', NULL),
(19, 'scommand_rankalert', 'Message from a staffmember with same rank:', NULL),
(20, 'banreport_header', 'Ban report for', NULL),
(21, 'common_userrank', 'Rank', NULL),
(22, 'common_ip', 'IP address', NULL),
(23, 'banreport_banner', 'Banned by', NULL),
(24, 'banreport_posted', 'Date of ban posting', NULL),
(25, 'banreport_expires', 'Date of ban expire', NULL),
(29, 'banreport_affectedusernames', 'Usernames affected by this ban', NULL),
(26, 'banreport_reason', 'Reason', NULL),
(27, 'banreport_ipbanflag', 'IP ban applied', NULL),
(28, 'banreport_staffnote', 'Staff note from banner', NULL),
(29, 'userinfo_header', 'Virtual user information', NULL),
(30, 'userinfo_accesserror', 'Sorry, but you haven\'t got access to this user\'s details.\r\n- It can be possible that the user doesn\'t exist\r\n- It can be possible that the user has got a higher rank than you', NULL),
(31, 'common_usernotfound', 'The user was not found.', NULL),
(32, 'common_userid', 'User ID', NULL),
(33, 'common_username', 'Username', NULL),
(34, 'common_usermission', 'Mission', NULL),
(35, 'common_email', 'Email address', NULL),
(36, 'common_credits', 'Credits', NULL),
(37, 'common_tickets', 'Tickets', NULL),
(38, 'common_birth', 'Birth date', NULL),
(39, 'common_hbirth', 'Registered at', NULL),
(40, 'common_online', 'Online', NULL),
(41, 'common_yes', 'Yes', NULL),
(42, 'common_no', 'No', NULL),
(43, 'common_location', 'Location', NULL),
(44, 'common_owner', 'Owner', NULL),
(45, 'common_room', 'Room', NULL),
(46, 'common_hotelview', 'Hotel View', NULL),
(47, 'common_lastaccess', 'Last access', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(15) NOT NULL,
  `name` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `password` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `rank` int(1) NOT NULL,
  `email` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `birth` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `hbirth` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `figure` varchar(150) COLLATE latin1_general_ci NOT NULL,
  `sex` varchar(5) COLLATE latin1_general_ci NOT NULL,
  `mission` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `consolemission` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `credits` int(7) NOT NULL DEFAULT 0,
  `tickets` int(5) NOT NULL DEFAULT 0,
  `badge_status` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '1',
  `lastvisit` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `figure_swim` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `user` text COLLATE latin1_general_ci DEFAULT NULL,
  `postcount` bigint(20) NOT NULL DEFAULT 0,
  `ticket_sso` varchar(39) COLLATE latin1_general_ci DEFAULT NULL,
  `ipaddress_last` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `online` text COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `password`, `rank`, `email`, `birth`, `hbirth`, `figure`, `sex`, `mission`, `consolemission`, `credits`, `tickets`, `badge_status`, `lastvisit`, `figure_swim`, `user`, `postcount`, `ticket_sso`, `ipaddress_last`, `online`) VALUES
(1, 'Alex', '', 7, 'eewqweqw@cc.com', '01.01.1970', '01.01.1970', 'he-1607-.sh-730-62.ch-824-110.lg-695-110.hd-600-2.hr-836-42.ca-1813-', 'M', 'test', 'test 123', 9872, 10002, '1', NULL, 'ch=s02/157,89,126', NULL, 0, '123', NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `users_badges`
--

CREATE TABLE `users_badges` (
  `userid` int(15) NOT NULL,
  `badgeid` varchar(5) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `iscurrent` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `slotid` int(5) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_bans`
--

CREATE TABLE `users_bans` (
  `userid` varchar(30) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `ipaddress` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `date_expire` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `descr` text COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_club`
--

CREATE TABLE `users_club` (
  `userid` bigint(6) NOT NULL,
  `months_expired` int(4) DEFAULT NULL,
  `months_left` int(4) DEFAULT NULL,
  `date_monthstarted` varchar(25) COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_favourites`
--

CREATE TABLE `users_favourites` (
  `userid` int(10) NOT NULL,
  `roomid` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_fuserights`
--

CREATE TABLE `users_fuserights` (
  `userid` int(15) NOT NULL,
  `fuseright` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_recycler`
--

CREATE TABLE `users_recycler` (
  `userid` int(10) NOT NULL,
  `session_started` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `session_reward` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vouchers`
--

CREATE TABLE `vouchers` (
  `voucher` varchar(20) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `type` enum('item','credits') COLLATE latin1_general_ci NOT NULL DEFAULT 'credits',
  `credits` int(5) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wordfilter`
--

CREATE TABLE `wordfilter` (
  `word` varchar(100) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `wordfilter`
--

INSERT INTO `wordfilter` (`word`) VALUES
('aaron'),
('anal'),
('ass'),
('cunt'),
('dick'),
('fuck'),
('goddamn'),
('motherfucker'),
('pussy');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `catalogue_items`
--
ALTER TABLE `catalogue_items`
  ADD PRIMARY KEY (`tid`);

--
-- Indexes for table `catalogue_pages`
--
ALTER TABLE `catalogue_pages`
  ADD PRIMARY KEY (`indexid`);

--
-- Indexes for table `cms_alerts`
--
ALTER TABLE `cms_alerts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_forum_posts`
--
ALTER TABLE `cms_forum_posts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_forum_threads`
--
ALTER TABLE `cms_forum_threads`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_help`
--
ALTER TABLE `cms_help`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_homes_catalouge`
--
ALTER TABLE `cms_homes_catalouge`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_homes_inventory`
--
ALTER TABLE `cms_homes_inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_homes_stickers`
--
ALTER TABLE `cms_homes_stickers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_minimail`
--
ALTER TABLE `cms_minimail`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_news`
--
ALTER TABLE `cms_news`
  ADD PRIMARY KEY (`num`);

--
-- Indexes for table `cms_posts`
--
ALTER TABLE `cms_posts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_tags`
--
ALTER TABLE `cms_tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_threads`
--
ALTER TABLE `cms_threads`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_transactions`
--
ALTER TABLE `cms_transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `furniture`
--
ALTER TABLE `furniture`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `furniture_moodlight`
--
ALTER TABLE `furniture_moodlight`
  ADD PRIMARY KEY (`id`,`roomid`);

--
-- Indexes for table `furniture_stickies`
--
ALTER TABLE `furniture_stickies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `games_lobbies`
--
ALTER TABLE `games_lobbies`
  ADD KEY `id` (`id`);

--
-- Indexes for table `games_ranks`
--
ALTER TABLE `games_ranks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `groups_details`
--
ALTER TABLE `groups_details`
  ADD PRIMARY KEY (`id`,`name`);

--
-- Indexes for table `messenger_friendrequests`
--
ALTER TABLE `messenger_friendrequests`
  ADD PRIMARY KEY (`userid_from`,`userid_to`,`requestid`);

--
-- Indexes for table `messenger_friendships`
--
ALTER TABLE `messenger_friendships`
  ADD KEY `index extreme` (`userid`),
  ADD KEY `extreme the 2nd` (`friendid`);

--
-- Indexes for table `messenger_messages`
--
ALTER TABLE `messenger_messages`
  ADD PRIMARY KEY (`userid`,`messageid`);

--
-- Indexes for table `ranks`
--
ALTER TABLE `ranks`
  ADD PRIMARY KEY (`rankid`);

--
-- Indexes for table `rank_fuserights`
--
ALTER TABLE `rank_fuserights`
  ADD PRIMARY KEY (`id`,`fuseright`);

--
-- Indexes for table `roombots`
--
ALTER TABLE `roombots`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `room_ads`
--
ALTER TABLE `room_ads`
  ADD PRIMARY KEY (`roomid`);

--
-- Indexes for table `room_categories`
--
ALTER TABLE `room_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `room_modeldata`
--
ALTER TABLE `room_modeldata`
  ADD PRIMARY KEY (`model`);

--
-- Indexes for table `room_modeldata_triggers`
--
ALTER TABLE `room_modeldata_triggers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `room_rights`
--
ALTER TABLE `room_rights`
  ADD KEY `index` (`userid`);

--
-- Indexes for table `soundmachine_songs`
--
ALTER TABLE `soundmachine_songs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `system_config`
--
ALTER TABLE `system_config`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `system_fuserights`
--
ALTER TABLE `system_fuserights`
  ADD PRIMARY KEY (`id`,`fuseright`);

--
-- Indexes for table `system_recycler`
--
ALTER TABLE `system_recycler`
  ADD PRIMARY KEY (`rclr_cost`,`rclr_reward`);

--
-- Indexes for table `system_stafflog`
--
ALTER TABLE `system_stafflog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `system_strings`
--
ALTER TABLE `system_strings`
  ADD PRIMARY KEY (`id`,`stringid`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_badges`
--
ALTER TABLE `users_badges`
  ADD PRIMARY KEY (`userid`,`badgeid`),
  ADD KEY `userid` (`userid`);

--
-- Indexes for table `users_club`
--
ALTER TABLE `users_club`
  ADD PRIMARY KEY (`userid`);

--
-- Indexes for table `users_fuserights`
--
ALTER TABLE `users_fuserights`
  ADD KEY `userid` (`userid`);

--
-- Indexes for table `users_recycler`
--
ALTER TABLE `users_recycler`
  ADD PRIMARY KEY (`userid`);

--
-- Indexes for table `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`voucher`);

--
-- Indexes for table `wordfilter`
--
ALTER TABLE `wordfilter`
  ADD PRIMARY KEY (`word`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `catalogue_items`
--
ALTER TABLE `catalogue_items`
  MODIFY `tid` int(10) NOT NULL AUTO_INCREMENT COMMENT 'The template ID of this item. Unique', AUTO_INCREMENT=1002;

--
-- AUTO_INCREMENT for table `cms_alerts`
--
ALTER TABLE `cms_alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `cms_forum_posts`
--
ALTER TABLE `cms_forum_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `cms_forum_threads`
--
ALTER TABLE `cms_forum_threads`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cms_help`
--
ALTER TABLE `cms_help`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `cms_homes_catalouge`
--
ALTER TABLE `cms_homes_catalouge`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=304;

--
-- AUTO_INCREMENT for table `cms_homes_inventory`
--
ALTER TABLE `cms_homes_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=287;

--
-- AUTO_INCREMENT for table `cms_homes_stickers`
--
ALTER TABLE `cms_homes_stickers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=526;

--
-- AUTO_INCREMENT for table `cms_minimail`
--
ALTER TABLE `cms_minimail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cms_news`
--
ALTER TABLE `cms_news`
  MODIFY `num` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `cms_posts`
--
ALTER TABLE `cms_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cms_tags`
--
ALTER TABLE `cms_tags`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `cms_threads`
--
ALTER TABLE `cms_threads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cms_transactions`
--
ALTER TABLE `cms_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=494;

--
-- AUTO_INCREMENT for table `furniture`
--
ALTER TABLE `furniture`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'The ID of this item', AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `games_ranks`
--
ALTER TABLE `games_ranks`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `groups_details`
--
ALTER TABLE `groups_details`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `rank_fuserights`
--
ALTER TABLE `rank_fuserights`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `roombots`
--
ALTER TABLE `roombots`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=202;

--
-- AUTO_INCREMENT for table `room_modeldata_triggers`
--
ALTER TABLE `room_modeldata_triggers`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `soundmachine_songs`
--
ALTER TABLE `soundmachine_songs`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `system_config`
--
ALTER TABLE `system_config`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `system_fuserights`
--
ALTER TABLE `system_fuserights`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `system_stafflog`
--
ALTER TABLE `system_stafflog`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=485;

--
-- AUTO_INCREMENT for table `system_strings`
--
ALTER TABLE `system_strings`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
