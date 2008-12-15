-- phpMyAdmin SQL Dump
-- version 2.11.9.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 15, 2008 at 11:40 AM
-- Server version: 5.0.67
-- PHP Version: 5.2.6
--
-- Rev 11 - Rev 12 Update
--

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `cdb_habbzhotel_backup`
--

-- --------------------------------------------------------

--
-- Table structure for table `users_fuserights`
--

CREATE TABLE IF NOT EXISTS `users_fuserights` (
  `userid` int(15) NOT NULL,
  `fuseright` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
