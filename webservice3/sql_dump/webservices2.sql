-- phpMyAdmin SQL Dump
-- version 4.5.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Sep 16, 2016 at 01:46 PM
-- Server version: 5.7.11
-- PHP Version: 5.6.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `webservices2`
--

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `product_id` int(25) NOT NULL,
  `user_id` int(25) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `category_id` int(25) NOT NULL,
  `product_detail` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`product_id`, `user_id`, `product_name`, `price`, `category_id`, `product_detail`) VALUES
(112, 13, 'jh', 5465, 546, 'ghkghjg'),
(3, 26, 'dew', 55, 44, 'df'),
(12, 26, 'hghhjg', 23112, 12, 'gjghjgh'),
(3, 26, 'hkjh', 65646, 4445, 'hjghjgh');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(25) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `category_img` varchar(255) DEFAULT NULL,
  `category_type` int(255) DEFAULT NULL,
  `category_discription` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `category_img`, `category_type`, `category_discription`) VALUES
(22, 'mnm', 'bnb', 1, 'mmbmbmb'),
(68, 'ganesh', NULL, 1, 'vikash'),
(93, 'ganesh', NULL, 1, 'vikash'),
(92, 'ganesh', NULL, 1, 'vikash'),
(91, 'ganesh', NULL, 1, 'vikash'),
(90, 'ganesh', NULL, 1, 'vikash'),
(89, 'ganesh', NULL, 1, 'vikash'),
(88, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(87, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(86, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(85, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(84, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(83, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(82, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(81, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(80, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(79, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(78, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(77, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(76, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(75, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(71, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(72, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(73, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(74, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(94, 'ganesh', NULL, 1, 'vikash'),
(95, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(96, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(97, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(98, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(99, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(100, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(101, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(102, 'ganesh', NULL, 1, 'vikash'),
(103, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(104, 'ganesh', NULL, 1, 'vikash'),
(105, 'ganesh', NULL, 1, 'vikash'),
(106, 'ganesh', NULL, 1, 'vikash'),
(107, 'ganesh', NULL, 1, 'vikash'),
(108, 'ganesh', NULL, 1, 'vikash'),
(109, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(110, 'ganesh', NULL, 1, 'vikash'),
(111, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(112, 'ganesh', NULL, 1, 'vikash'),
(113, 'x2', 'ganesh.jpg', 3, 'nxncxmcvxcm,vx'),
(114, 'vikash', 'ganesh.jpg', 2, 'this'),
(115, 'vikash', 'ganesh.jpg', 2, 'this'),
(116, 'vikash', 'ganesh.jpg', 2, 'this'),
(117, 'vikash', 'ganesh.jpg', 2, 'this'),
(118, 'vikash', 'ganesh.jpg', 2, 'this'),
(119, 'vikash', 'ganesh.jpg', 2, 'this'),
(120, 'ganesh', NULL, 1, 'vikash');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(25) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `device_id` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `password`, `email`, `token`, `device_id`) VALUES
(49, 'kjhjk', 'hkh', 'a9e3f24b8214a04472b565af8593e6ed30a11edc', 'hkjh@gmao.com', 'hhjkhjk', '54'),
(26, 'Rahul', 'admin', 'b12dfe8147ac03d1e6b29ae66409d21d6fc2c60b', 'admin@dev.pmi5media.com', '3m1UPQbW', 'APA91bFRFABZspci-sNcvfxLH5pWMbCWVYXfh0l_oG_5ZU9wpVQ7Oxy_vU_iZNKjeAtHlunm6u9m8a65SDIDZFNyL3HuGa70-6xiwSMzHGpygEQpA2AqxCU'),
(27, 'student1', 'student1', 'b12dfe8147ac03d1e6b29ae66409d21d6fc2c60b', 'student1@dev.pmi5media.com', 'CyiuzJ8y', 'APA91bHaUj0PwYNyyf3dSq1jbwh9q2HEacFs5Z8HCfohXeWkZKKEwzqQwhlb_rphR5qXYCzwaJKf4Ps8XAsWkHWJLTEaFAL8-1k-I-UG0Zn4vJ_KWA0M9P4'),
(28, 'Rahul', 'admin', 'b12dfe8147ac03d1e6b29ae66409d21d6fc2c60b', 'admin@dev.pmi5media.com', '3m1UPQbW', 'APA91bFRFABZspci-sNcvfxLH5pWMbCWVYXfh0l_oG_5ZU9wpVQ7Oxy_vU_iZNKjeAtHlunm6u9m8a65SDIDZFNyL3HuGa70-6xiwSMzHGpygEQpA2AqxCU'),
(29, 'student1', 'student1', 'b12dfe8147ac03d1e6b29ae66409d21d6fc2c60b', 'student1@dev.pmi5media.com', 'CyiuzJ8y', 'APA91bHaUj0PwYNyyf3dSq1jbwh9q2HEacFs5Z8HCfohXeWkZKKEwzqQwhlb_rphR5qXYCzwaJKf4Ps8XAsWkHWJLTEaFAL8-1k-I-UG0Zn4vJ_KWA0M9P4'),
(30, 'Rahul', 'admin', 'b12dfe8147ac03d1e6b29ae66409d21d6fc2c60b', 'admin@dev.pmi5media.com', '3m1UPQbW', 'APA91bFRFABZspci-sNcvfxLH5pWMbCWVYXfh0l_oG_5ZU9wpVQ7Oxy_vU_iZNKjeAtHlunm6u9m8a65SDIDZFNyL3HuGa70-6xiwSMzHGpygEQpA2AqxCU'),
(46, 'hjgjh', 'jghgh', 'bf3ced964cc531fcca40c6da03f33cb0bfeece04', 'jhg@gmail.com', 'hhg', '54'),
(47, 'hjgjh', 'jghgh', 'bf3ced964cc531fcca40c6da03f33cb0bfeece04', 'jhg@gmail.com', 'hhg', '54'),
(48, 'kjhjk', 'hkh', 'a9e3f24b8214a04472b565af8593e6ed30a11edc', 'hkjh@gmao.com', 'hhjkhjk', '54'),
(45, 'hjgjh', 'jghgh', 'bf3ced964cc531fcca40c6da03f33cb0bfeece04', 'jhg@gmail.com', 'hhg', '54'),
(44, 'jhg', 'hghg', 'f538c33a8b15b6218ef3830d2aa8cb61d443c071', 'ghj@gmail.com', 'gh', '54');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(25) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(25) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
