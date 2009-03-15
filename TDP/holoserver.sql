-- phpMyAdmin SQL Dump
-- version 3.1.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 28, 2009 at 12:34 AM
-- Server version: 5.1.30
-- PHP Version: 5.2.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `holoserver`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `userid` int(100) NOT NULL,
  `username` text NOT NULL,
  `appstatus` text NOT NULL,
  `age` text NOT NULL,
  `country` text NOT NULL,
  `timezone` text NOT NULL,
  `realname` text NOT NULL,
  `modname` text NOT NULL,
  `time` text NOT NULL,
  `experience` text NOT NULL,
  `message1` text NOT NULL,
  `message2` text NOT NULL,
  `message3` text NOT NULL,
  `users` text NOT NULL,
  `visitoripaddy` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `catalogue_deals`
--

CREATE TABLE `catalogue_deals` (
  `id` int(10) NOT NULL COMMENT 'The ID of this deal [the part after "deal"]',
  `tid` int(10) NOT NULL COMMENT 'The template ID of the item that should be in this deal',
  `amount` int(10) NOT NULL COMMENT 'The amount, of how many items of the type _TID should be in this deal',
  KEY `id` (`id`),
  KEY `tid` (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `catalogue_items`
--

CREATE TABLE `catalogue_items` (
  `tid` int(10) NOT NULL AUTO_INCREMENT,
  `catalogue_name` varchar(100) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `catalogue_description` varchar(200) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `catalogue_cost` int(5) NOT NULL DEFAULT '0',
  `typeid` int(1) NOT NULL DEFAULT '0',
  `length` int(2) NOT NULL DEFAULT '0',
  `width` int(2) NOT NULL DEFAULT '0',
  `top` double(4,2) NOT NULL DEFAULT '0.00',
  `name_cct` varchar(110) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `colour` varchar(100) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `catalogue_id_page` int(3) NOT NULL DEFAULT '0',
  `door` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `tradeable` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `recycleable` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `picture` varchar(20) COLLATE latin1_general_ci DEFAULT 'placeholder.gif',
  `catalogue_id_index` int(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tid`),
  KEY `typeid` (`typeid`),
  KEY `catalogue_id_index` (`catalogue_id_index`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Table structure for table `catalogue_pages`
--

CREATE TABLE `catalogue_pages` (
  `indexid` tinyint(3) NOT NULL,
  `minrank` tinyint(1) NOT NULL,
  `indexname` varchar(100) CHARACTER SET latin1 COLLATE latin1_german1_ci NOT NULL,
  `displayname` varchar(100) CHARACTER SET latin1 COLLATE latin1_german1_ci NOT NULL,
  `style_layout` varchar(100) CHARACTER SET latin1 COLLATE latin1_german1_ci NOT NULL,
  `img_header` varchar(100) CHARACTER SET latin1 COLLATE latin1_german1_ci DEFAULT NULL,
  `img_side` text CHARACTER SET latin1 COLLATE latin1_german1_ci,
  `label_description` text CHARACTER SET latin1 COLLATE latin1_german1_ci,
  `label_misc` text CHARACTER SET latin1 COLLATE latin1_german1_ci,
  `label_moredetails` varchar(150) CHARACTER SET latin1 COLLATE latin1_german1_ci DEFAULT NULL,
  `opt_bodyreplace` text CHARACTER SET latin1 COLLATE latin1_german1_ci,
  PRIMARY KEY (`indexid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cms_alerts`
--

CREATE TABLE `cms_alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `alert` text NOT NULL,
  `type` enum('1','2') NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_applications`
--

CREATE TABLE `cms_applications` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `rankname` varchar(255) NOT NULL,
  `username` varchar(50) NOT NULL,
  `realname` varchar(50) NOT NULL,
  `birth` varchar(15) NOT NULL,
  `sex` varchar(10) NOT NULL,
  `country` varchar(50) NOT NULL,
  `general_information` text NOT NULL,
  `experience` text NOT NULL,
  `education` varchar(50) NOT NULL,
  `additional_information` text NOT NULL,
  `accepted_disclaimer` int(1) NOT NULL DEFAULT '0',
  `admin_reacted` int(1) NOT NULL DEFAULT '0',
  `admin_read` int(1) NOT NULL DEFAULT '0',
  `admin_deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_application_forms`
--

CREATE TABLE `cms_application_forms` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '0' COMMENT 'For what rank can people applicate?',
  `introduction` text NOT NULL COMMENT 'What''s the description of the rank it self?',
  `requirements` text NOT NULL COMMENT 'What are the requirments if you want to do this job?',
  `hconly` int(1) NOT NULL DEFAULT '0' COMMENT 'Can only people who are HC applicate or everyone?',
  `username` int(1) NOT NULL DEFAULT '0' COMMENT 'Show username in application form?',
  `realname` int(1) NOT NULL DEFAULT '0' COMMENT 'Need people to fill in their real name?',
  `birth` int(1) NOT NULL DEFAULT '0' COMMENT 'Show birth in application form?',
  `sex` int(1) NOT NULL DEFAULT '0' COMMENT 'Need people to fill in what there sex is (male/female/shemale)?',
  `country` int(1) NOT NULL DEFAULT '0' COMMENT 'Need people to fill in, in what country they live?',
  `general_information` int(1) NOT NULL DEFAULT '0' COMMENT 'Need people to fill in general information (reasons why you''re interested/why the staff should choose you)?',
  `experience` int(1) NOT NULL DEFAULT '0' COMMENT 'Need people to fill in if they have work experience?',
  `education` int(1) NOT NULL DEFAULT '0' COMMENT 'Need people to fill in what level they (did) study?',
  `additional_information` int(1) NOT NULL DEFAULT '0' COMMENT 'Need people to fill in hobbies or interests?',
  `show_disclaimer` int(1) NOT NULL DEFAULT '0' COMMENT 'Must there be a disclaimer that the people who applicates need to accept?',
  `disclaimer_text` text NOT NULL COMMENT 'The disclaimer it self (shown if configurated).',
  `enabled` int(11) NOT NULL DEFAULT '0' COMMENT 'Can you right now apply for this rank?',
  `deleted` int(1) NOT NULL DEFAULT '0' COMMENT 'If you ''delete'' a application form it will be invisible. We don''t delete it in the sql table so no errors come up if someone applied for this rank.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='You DO NOT find any applications in this table, only the for';

-- --------------------------------------------------------

--
-- Table structure for table `cms_badge_shop`
--

CREATE TABLE `cms_badge_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `image` varchar(255) NOT NULL,
  `cost` int(11) DEFAULT '1',
  `minrank` int(11) DEFAULT '1',
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `enabled` varchar(1) DEFAULT '1',
  `category` varchar(255) DEFAULT NULL,
  `null1` varchar(255) DEFAULT NULL,
  `null2` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_banners`
--

CREATE TABLE `cms_banners` (
  `id` int(35) NOT NULL AUTO_INCREMENT,
  `text` varchar(50) NOT NULL,
  `banner` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `status` smallint(1) NOT NULL DEFAULT '0',
  `advanced` int(1) DEFAULT NULL,
  `html` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_collectables`
--

CREATE TABLE `cms_collectables` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL DEFAULT 'Unknown furniture',
  `image_small` varchar(255) DEFAULT NULL,
  `image_large` varchar(255) NOT NULL,
  `tid` int(20) NOT NULL DEFAULT '0',
  `description` varchar(175) NOT NULL DEFAULT 'No description given!',
  `month` int(2) NOT NULL DEFAULT '1',
  `year` int(2) NOT NULL,
  `showroom` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

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
  `category` int(11) NOT NULL DEFAULT '1',
  KEY `fieldtype` (`fieldtype`),
  KEY `category` (`category`),
  FULLTEXT KEY `contentkey` (`contentkey`),
  FULLTEXT KEY `contentvalue` (`contentvalue`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_faq`
--

CREATE TABLE `cms_faq` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL DEFAULT 'type',
  `catid` int(11) DEFAULT NULL,
  `title` varchar(1000) NOT NULL,
  `content` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_forum_posts`
--

CREATE TABLE `cms_forum_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `threadid` int(11) NOT NULL DEFAULT '0',
  `message` text NOT NULL,
  `author` varchar(25) NOT NULL,
  `date` varchar(30) NOT NULL,
  `edit_date` varchar(30) NOT NULL,
  `edit_author` varchar(25) NOT NULL,
  `forumid` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_forum_threads`
--

CREATE TABLE `cms_forum_threads` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL,
  `title` varchar(30) NOT NULL,
  `author` varchar(25) NOT NULL,
  `date` varchar(35) NOT NULL,
  `lastpost_author` varchar(25) NOT NULL,
  `lastpost_date` varchar(35) NOT NULL,
  `views` int(11) NOT NULL,
  `posts` tinyint(4) NOT NULL,
  `unix` varchar(40) NOT NULL,
  `forumid` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_guestbook`
--

CREATE TABLE `cms_guestbook` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `message` varchar(1000) DEFAULT NULL,
  `time` varchar(1000) DEFAULT NULL,
  `widget_id` int(10) DEFAULT NULL,
  `userid` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_help`
--

CREATE TABLE `cms_help` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) COLLATE latin1_general_ci NOT NULL,
  `ip` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `message` mediumtext COLLATE latin1_general_ci NOT NULL,
  `date` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `picked_up` enum('0','1') COLLATE latin1_general_ci NOT NULL,
  `subject` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `roomid` int(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='HoloCMS';

-- --------------------------------------------------------

--
-- Table structure for table `cms_homes_catalouge`
--

CREATE TABLE `cms_homes_catalouge` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `type` varchar(1) NOT NULL,
  `subtype` varchar(1) NOT NULL,
  `data` text NOT NULL,
  `price` int(11) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT '1',
  `category` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_homes_group_linker`
--

CREATE TABLE `cms_homes_group_linker` (
  `userid` int(11) NOT NULL,
  `groupid` int(11) NOT NULL,
  `active` varchar(1) NOT NULL DEFAULT '0',
  KEY `userid` (`userid`),
  KEY `groupid` (`groupid`),
  KEY `active` (`active`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_homes_inventory`
--

CREATE TABLE `cms_homes_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `type` varchar(1) NOT NULL,
  `subtype` varchar(1) NOT NULL,
  `data` text NOT NULL,
  `amount` varchar(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_homes_stickers`
--

CREATE TABLE `cms_homes_stickers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `x` varchar(6) NOT NULL DEFAULT '1' COMMENT 'left',
  `y` varchar(6) NOT NULL DEFAULT '1' COMMENT 'top',
  `z` varchar(6) NOT NULL DEFAULT '1' COMMENT 'z-index',
  `data` text NOT NULL,
  `type` varchar(1) NOT NULL DEFAULT '1',
  `subtype` varchar(1) NOT NULL DEFAULT '0' COMMENT 'Widget Type (if widget)',
  `skin` text NOT NULL,
  `groupid` int(11) NOT NULL DEFAULT '-1',
  `var` int(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_minimail`
--

CREATE TABLE `cms_minimail` (
  `senderid` int(11) NOT NULL,
  `to_id` int(11) DEFAULT NULL,
  `subject` varchar(30) NOT NULL,
  `date` varchar(30) NOT NULL,
  `message` text NOT NULL,
  `read_mail` enum('0','1') NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deleted` int(10) DEFAULT '0',
  `conversationid` int(10) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `senderid` (`senderid`),
  KEY `to_id` (`to_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_news`
--

CREATE TABLE `cms_news` (
  `num` int(4) NOT NULL AUTO_INCREMENT,
  `title` text COLLATE latin1_general_ci NOT NULL,
  `category` text COLLATE latin1_general_ci NOT NULL,
  `topstory` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `short_story` text COLLATE latin1_general_ci NOT NULL,
  `story` longtext COLLATE latin1_general_ci NOT NULL,
  `date` date NOT NULL,
  `author` text COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`num`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='HoloCMS';

-- --------------------------------------------------------

--
-- Table structure for table `cms_noobgifts`
--

CREATE TABLE `cms_noobgifts` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `userid` int(30) NOT NULL,
  `gift` int(2) NOT NULL,
  `read` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_recommended`
--

CREATE TABLE `cms_recommended` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `rec_id` int(10) DEFAULT NULL,
  `type` varchar(10) DEFAULT 'group',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

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
  `start_credits` int(11) NOT NULL DEFAULT '0',
  `admin_notes` text COLLATE latin1_general_ci NOT NULL,
  `loader` int(1) NOT NULL DEFAULT '1',
  `analytics` text COLLATE latin1_general_ci
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='HoloCMS';

-- --------------------------------------------------------

--
-- Table structure for table `cms_tags`
--

CREATE TABLE `cms_tags` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `ownerid` int(11) NOT NULL DEFAULT '0',
  `tag` varchar(25) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ownerid` (`ownerid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='HoloCMS';

-- --------------------------------------------------------

--
-- Table structure for table `cms_transactions`
--

CREATE TABLE `cms_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(20) NOT NULL,
  `amount` varchar(10) NOT NULL,
  `descr` text NOT NULL,
  `userid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cms_wardrobe`
--

CREATE TABLE `cms_wardrobe` (
  `userid` int(11) NOT NULL,
  `slotid` varchar(1) NOT NULL,
  `figure` text NOT NULL,
  `gender` varchar(1) NOT NULL,
  KEY `userid` (`userid`),
  KEY `slotid` (`slotid`),
  KEY `gender` (`gender`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `name` text,
  `description` text,
  `userid` int(11) DEFAULT NULL,
  `roomid` int(11) NOT NULL DEFAULT '0',
  `category` int(11) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  KEY `roomid` (`roomid`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `furniture`
--

CREATE TABLE `furniture` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'The ID of this item',
  `tid` int(10) NOT NULL COMMENT 'The template ID of this item',
  `ownerid` int(10) NOT NULL COMMENT 'The ID of the user that owns this item',
  `roomid` int(10) NOT NULL COMMENT 'The room ID the item is in. If it''s 0, then it''s in the hand of OWNERID, if it''s -1, then it''s in a present and not opened yet, if it''s -2, then it''s in the Recycler',
  `x` smallint(6) NOT NULL COMMENT 'The X of the item in a room',
  `y` smallint(6) NOT NULL COMMENT 'The Y of the item in a room',
  `z` smallint(6) NOT NULL COMMENT 'The Z [rotation] of the item in a room',
  `h` double(4,2) NOT NULL DEFAULT '0.00' COMMENT 'The H [height, double] of the item in a room',
  `var` text COLLATE latin1_general_ci COMMENT 'The variable of the item, specifying it''s turned on/off etc, :S',
  `wallpos` varchar(200) COLLATE latin1_general_ci DEFAULT NULL COMMENT 'Wallitems only. The location on the wall where the item is',
  `teleportid` int(10) DEFAULT NULL COMMENT 'Teleporters only. The ID of the teleporter that links to this one',
  `soundmachine_soundset` int(2) DEFAULT NULL,
  `soundmachine_machineid` int(10) DEFAULT NULL,
  `soundmachine_slot` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `teleportid` (`teleportid`),
  KEY `roomid` (`roomid`),
  KEY `tid` (`tid`),
  KEY `soundmachine_soundset` (`soundmachine_soundset`),
  KEY `soundmachine_machineid` (`soundmachine_machineid`),
  KEY `soundmachine_slot` (`soundmachine_slot`),
  KEY `ownerid` (`ownerid`,`roomid`),
  KEY `soundmachine_machineid_2` (`soundmachine_machineid`,`soundmachine_slot`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `furniture_moodlight`
--

CREATE TABLE `furniture_moodlight` (
  `id` int(11) NOT NULL,
  `roomid` int(11) NOT NULL,
  `preset_cur` int(1) NOT NULL DEFAULT '0',
  `preset_1` varchar(75) COLLATE latin1_general_ci DEFAULT NULL,
  `preset_2` varchar(75) COLLATE latin1_general_ci DEFAULT NULL,
  `preset_3` varchar(75) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`,`roomid`),
  UNIQUE KEY `id` (`id`),
  KEY `roomid` (`roomid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `furniture_presents`
--

CREATE TABLE `furniture_presents` (
  `id` int(10) NOT NULL,
  `itemid` int(10) NOT NULL,
  KEY `id` (`id`),
  KEY `itemid` (`itemid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `furniture_stickies`
--

CREATE TABLE `furniture_stickies` (
  `id` int(10) NOT NULL,
  `text` text COLLATE latin1_general_ci,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `games_lobbies`
--

CREATE TABLE `games_lobbies` (
  `id` int(10) NOT NULL,
  `type` enum('bb') COLLATE latin1_general_ci NOT NULL DEFAULT 'bb',
  `rank` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `bb_allowedpowerups` text COLLATE latin1_general_ci,
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `games_maps`
--

CREATE TABLE `games_maps` (
  `type` enum('ss','bb') COLLATE latin1_general_ci NOT NULL,
  `id` enum('6','5','4','3','2','1') COLLATE latin1_general_ci NOT NULL DEFAULT '1',
  `heightmap` text COLLATE latin1_general_ci NOT NULL,
  `bb_tilemap` text COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `games_maps_playerspawns`
--

CREATE TABLE `games_maps_playerspawns` (
  `type` enum('ss','bb') COLLATE latin1_general_ci NOT NULL DEFAULT 'bb',
  `mapid` enum('6','5','4','3','2','1') COLLATE latin1_general_ci NOT NULL,
  `teamid` enum('3','2','1','0') COLLATE latin1_general_ci NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `z` enum('9','8','7','6','5','4','3','2','1','0') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  KEY `type` (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `games_ranks`
--

CREATE TABLE `games_ranks` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `type` enum('ss','bb') COLLATE latin1_general_ci NOT NULL DEFAULT 'bb',
  `title` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `minpoints` int(10) NOT NULL,
  `maxpoints` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groups_details`
--

CREATE TABLE `groups_details` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE latin1_general_ci NOT NULL,
  `description` varchar(200) COLLATE latin1_general_ci NOT NULL,
  `ownerid` int(10) NOT NULL,
  `roomid` int(10) NOT NULL,
  `created` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `badge` text COLLATE latin1_general_ci NOT NULL,
  `type` int(1) NOT NULL DEFAULT '0',
  `recommended` int(1) NOT NULL DEFAULT '0',
  `views` int(15) NOT NULL,
  `pane` smallint(1) NOT NULL DEFAULT '0',
  `topics` smallint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groups_memberships`
--

CREATE TABLE `groups_memberships` (
  `userid` int(10) NOT NULL,
  `groupid` int(10) NOT NULL,
  `member_rank` enum('3','2','1') COLLATE latin1_general_ci NOT NULL DEFAULT '3',
  `is_current` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `is_pending` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  KEY `userid` (`userid`),
  KEY `groupid` (`groupid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messenger_friendrequests`
--

CREATE TABLE `messenger_friendrequests` (
  `userid_from` int(10) NOT NULL DEFAULT '0',
  `userid_to` int(10) NOT NULL DEFAULT '0',
  `requestid` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`userid_from`,`userid_to`,`requestid`),
  KEY `userid_from` (`userid_from`),
  KEY `userid_to` (`userid_to`),
  KEY `requestid` (`requestid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messenger_friendships`
--

CREATE TABLE `messenger_friendships` (
  `userid` bigint(20) NOT NULL,
  `friendid` bigint(20) NOT NULL,
  PRIMARY KEY (`userid`,`friendid`),
  KEY `userid` (`userid`),
  KEY `friendid` (`friendid`)
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
  `message` text COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`userid`,`messageid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `poll`
--

CREATE TABLE `poll` (
  `pid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rid` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `thanks` varchar(255) NOT NULL,
  PRIMARY KEY (`pid`),
  UNIQUE KEY `pid` (`pid`,`rid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `poll_answers`
--

CREATE TABLE `poll_answers` (
  `aid` int(11) NOT NULL,
  `qid` int(11) NOT NULL,
  `answer` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `poll_questions`
--

CREATE TABLE `poll_questions` (
  `qid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `type` enum('1','2','3') NOT NULL,
  `min` int(11) NOT NULL,
  `max` int(11) NOT NULL,
  UNIQUE KEY `qid` (`qid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `poll_results`
--

CREATE TABLE `poll_results` (
  `pid` int(11) NOT NULL,
  `qid` int(11) NOT NULL,
  `aid` int(11) NOT NULL,
  `answers` varchar(255) NOT NULL,
  `uid` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

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
  `rightsEverywhere` int(4) NOT NULL,
  PRIMARY KEY (`rankid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rank_fuserights`
--

CREATE TABLE `rank_fuserights` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `minrank` int(1) NOT NULL,
  `fuseright` varchar(100) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`id`,`fuseright`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rarevalue`
--

CREATE TABLE `rarevalue` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT 'Empty slot',
  `img` varchar(64) NOT NULL DEFAULT 'noimg',
  `value` decimal(15,2) NOT NULL DEFAULT '1.00',
  `valuestate` varchar(1) NOT NULL DEFAULT '0' COMMENT '0 = no change, 1 = value increase, 2 = value decrease',
  `releasestate` varchar(1) NOT NULL DEFAULT '0' COMMENT '0 = new, 1 = released',
  `category` varchar(1) NOT NULL,
  `last_update` varchar(64) NOT NULL DEFAULT '2008-06-28',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `roombots`
--

CREATE TABLE `roombots` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `roomid` int(10) NOT NULL,
  `name` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `mission` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `figure` text COLLATE latin1_general_ci NOT NULL,
  `x` int(5) NOT NULL,
  `y` int(5) NOT NULL,
  `z` int(1) NOT NULL,
  `freeroam` enum('1','0') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `message_noshouting` varchar(200) COLLATE latin1_general_ci NOT NULL DEFAULT 'Shouting is not neccessary.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roombots_coords`
--

CREATE TABLE `roombots_coords` (
  `id` int(10) NOT NULL,
  `x` int(5) NOT NULL,
  `y` int(5) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roombots_texts`
--

CREATE TABLE `roombots_texts` (
  `id` int(10) NOT NULL,
  `type` enum('shout','say') COLLATE latin1_general_ci NOT NULL,
  `text` varchar(255) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

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

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `description` varchar(125) COLLATE latin1_general_ci DEFAULT NULL,
  `owner` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `category` int(3) NOT NULL DEFAULT '0',
  `model` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `ccts` text COLLATE latin1_general_ci,
  `floor` int(3) NOT NULL DEFAULT '0',
  `wallpaper` int(3) NOT NULL DEFAULT '0',
  `state` int(11) NOT NULL DEFAULT '0' COMMENT '0 = open, 1 = closed, 2 = password, 3 = hc only, 4 = staff',
  `password` varchar(15) COLLATE latin1_general_ci DEFAULT NULL,
  `showname` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '1',
  `superusers` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `visitors_now` int(3) NOT NULL DEFAULT '0',
  `visitors_max` int(3) NOT NULL DEFAULT '25',
  `landscape` decimal(2,1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `visitors_now` (`visitors_now`),
  KEY `id` (`id`,`owner`),
  KEY `category` (`category`),
  KEY `name` (`name`),
  KEY `owner_2` (`owner`,`name`),
  KEY `owner` (`owner`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_ads`
--

CREATE TABLE `room_ads` (
  `roomid` int(10) NOT NULL,
  `img` text COLLATE latin1_general_ci NOT NULL,
  `uri` text COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`roomid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_bans`
--

CREATE TABLE `room_bans` (
  `roomid` int(10) NOT NULL,
  `userid` int(10) NOT NULL,
  `ban_expire` varchar(50) COLLATE latin1_general_ci NOT NULL,
  KEY `roomid` (`roomid`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_categories`
--

CREATE TABLE `room_categories` (
  `id` int(3) NOT NULL DEFAULT '0',
  `parent` int(3) NOT NULL DEFAULT '0',
  `type` int(1) NOT NULL DEFAULT '1',
  `name` varchar(100) COLLATE latin1_general_ci NOT NULL DEFAULT 'Non-named category',
  `access_rank_min` int(2) NOT NULL,
  `access_rank_hideforlower` enum('0','1') COLLATE latin1_general_ci NOT NULL,
  `trading` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_modeldata`
--

CREATE TABLE `room_modeldata` (
  `model` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `roomomatic_subscr_only` int(1) NOT NULL DEFAULT '0',
  `door_x` int(3) NOT NULL,
  `door_y` int(3) NOT NULL,
  `door_h` int(3) NOT NULL,
  `door_z` int(1) NOT NULL,
  `heightmap` text COLLATE latin1_general_ci NOT NULL,
  `publicroom_items` text COLLATE latin1_general_ci NOT NULL,
  `swimmingpool` enum('1','0') COLLATE latin1_general_ci NOT NULL,
  `specialcast_emitter` varchar(15) COLLATE latin1_general_ci DEFAULT NULL,
  `specialcast_interval` int(10) DEFAULT NULL,
  `specialcast_rnd_min` int(10) DEFAULT NULL,
  `specialcast_rnd_max` int(10) DEFAULT NULL,
  PRIMARY KEY (`model`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_modeldata_triggers`
--

CREATE TABLE `room_modeldata_triggers` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `model` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `object` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `x` int(5) NOT NULL DEFAULT '0',
  `y` int(5) NOT NULL DEFAULT '0',
  `stepx` int(5) NOT NULL,
  `stepy` int(5) NOT NULL,
  `goalx` int(5) NOT NULL,
  `goaly` int(5) NOT NULL,
  `roomid` int(10) NOT NULL DEFAULT '0',
  `state` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_rights`
--

CREATE TABLE `room_rights` (
  `roomid` int(11) NOT NULL,
  `userid` int(10) NOT NULL,
  PRIMARY KEY (`roomid`,`userid`),
  KEY `roomid` (`roomid`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_votes`
--

CREATE TABLE `room_votes` (
  `roomid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `vote` int(2) NOT NULL,
  UNIQUE KEY `userid_2` (`userid`,`roomid`),
  KEY `roomid` (`roomid`),
  KEY `userid` (`userid`),
  KEY `vote` (`vote`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `soundmachine_playlists`
--

CREATE TABLE `soundmachine_playlists` (
  `machineid` int(10) NOT NULL,
  `songid` int(10) NOT NULL,
  `pos` int(3) NOT NULL,
  KEY `machineid` (`machineid`),
  KEY `songid` (`songid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `soundmachine_songs`
--

CREATE TABLE `soundmachine_songs` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `userid` int(10) NOT NULL,
  `title` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `machineid` int(10) NOT NULL,
  `length` int(3) NOT NULL,
  `data` text COLLATE latin1_general_ci NOT NULL,
  `burnt` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system`
--

CREATE TABLE `system` (
  `onlinecount` int(3) NOT NULL DEFAULT '0',
  `onlinecount_peak` int(10) NOT NULL,
  `connections_accepted` int(10) NOT NULL,
  `activerooms` int(10) NOT NULL,
  `activerooms_peak` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_chatlog`
--

CREATE TABLE `system_chatlog` (
  `username` varchar(15) COLLATE latin1_general_ci NOT NULL,
  `roomid` int(10) NOT NULL,
  `mtime` time NOT NULL DEFAULT '00:00:00',
  `message` varchar(200) COLLATE latin1_general_ci NOT NULL,
  KEY `roomid` (`roomid`),
  KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_config`
--

CREATE TABLE `system_config` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `skey` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `sval` text COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_fuserights`
--

CREATE TABLE `system_fuserights` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `minrank` int(1) NOT NULL,
  `fuseright` varchar(100) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`id`,`fuseright`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_recycler`
--

CREATE TABLE `system_recycler` (
  `rclr_cost` int(5) NOT NULL,
  `rclr_reward` int(10) NOT NULL,
  PRIMARY KEY (`rclr_cost`,`rclr_reward`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_stafflog`
--

CREATE TABLE `system_stafflog` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `action` varchar(12) COLLATE latin1_general_ci NOT NULL,
  `message` text COLLATE latin1_general_ci,
  `note` text COLLATE latin1_general_ci,
  `userid` int(11) NOT NULL,
  `targetid` int(11) DEFAULT NULL,
  `timestamp` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_strings`
--

CREATE TABLE `system_strings` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `stringid` varchar(100) COLLATE latin1_general_ci NOT NULL DEFAULT 'null',
  `var_en` text COLLATE latin1_general_ci,
  `var_de` text COLLATE latin1_general_ci,
  `var_nl` text COLLATE latin1_general_ci,
  PRIMARY KEY (`id`,`stringid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
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
  `credits` int(7) NOT NULL DEFAULT '0',
  `tickets` int(5) NOT NULL DEFAULT '0',
  `badge_status` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '1',
  `lastvisit` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `figure_swim` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `user` text COLLATE latin1_general_ci,
  `postcount` bigint(20) NOT NULL DEFAULT '0',
  `ticket_sso` varchar(39) COLLATE latin1_general_ci DEFAULT NULL,
  `ipaddress_last` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `noob` int(1) NOT NULL DEFAULT '0',
  `online` mediumint(30) NOT NULL DEFAULT '1',
  `bb_totalpoints` int(30) DEFAULT '0',
  `bb_playedgames` int(30) DEFAULT '0',
  `screen` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `rea` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `gift` smallint(2) DEFAULT NULL,
  `sort` smallint(1) DEFAULT NULL,
  `roomid` int(15) DEFAULT NULL,
  `lastgift` smallint(2) DEFAULT NULL,
  `visibility` int(1) DEFAULT '1',
  `hc_before` int(1) DEFAULT NULL,
  `guideavailable` int(1) NOT NULL,
  `shockwaveid` text COLLATE latin1_general_ci NOT NULL,
  `guide` int(1) NOT NULL,
  `guide-allowed` int(1) NOT NULL,
  `window` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `name_2` (`name`(4)),
  KEY `ticket_sso` (`ticket_sso`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_badges`
--

CREATE TABLE `users_badges` (
  `userid` int(15) NOT NULL,
  `badgeid` varchar(5) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `iscurrent` enum('0','1') COLLATE latin1_general_ci NOT NULL DEFAULT '0',
  `slotid` int(5) NOT NULL,
  PRIMARY KEY (`userid`,`badgeid`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_badgescur`
--

CREATE TABLE `users_badgescur` (
  `userid` int(15) NOT NULL,
  `badge1` varchar(5) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `badge2` varchar(5) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `badge3` varchar(5) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `badge4` varchar(5) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `badge5` varchar(5) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_bans`
--

CREATE TABLE `users_bans` (
  `userid` varchar(30) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `ipaddress` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `date_expire` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `descr` text COLLATE latin1_general_ci,
  KEY `userid` (`userid`),
  KEY `ipaddress` (`ipaddress`),
  KEY `date_expire` (`date_expire`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_club`
--

CREATE TABLE `users_club` (
  `userid` bigint(6) NOT NULL,
  `months_expired` int(4) DEFAULT NULL,
  `months_left` int(4) DEFAULT NULL,
  `date_monthstarted` varchar(25) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_favouriterooms`
--

CREATE TABLE `users_favouriterooms` (
  `userid` int(10) NOT NULL,
  `roomid` int(10) NOT NULL,
  PRIMARY KEY (`userid`,`roomid`),
  KEY `userid` (`userid`),
  KEY `roomid` (`roomid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_favourites`
--

CREATE TABLE `users_favourites` (
  `userid` int(11) NOT NULL,
  `roomid` int(11) NOT NULL,
  KEY `userid` (`userid`),
  KEY `roomid` (`roomid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_fuserights`
--

CREATE TABLE `users_fuserights` (
  `userid` int(15) NOT NULL,
  `fuseright` varchar(100) NOT NULL,
  KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_online_ip`
--

CREATE TABLE `users_online_ip` (
  `ip` varchar(25) NOT NULL,
  `count` tinyint(4) NOT NULL,
  PRIMARY KEY (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_recycler`
--

CREATE TABLE `users_recycler` (
  `userid` int(10) NOT NULL,
  `session_started` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `session_reward` int(10) NOT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vouchers`
--

CREATE TABLE `vouchers` (
  `voucher` varchar(20) COLLATE latin1_general_ci NOT NULL,
  `type` enum('item','credits') COLLATE latin1_general_ci NOT NULL DEFAULT 'credits',
  `credits` varchar(255) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`voucher`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wordfilter`
--

CREATE TABLE `wordfilter` (
  `word` varchar(100) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`word`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
