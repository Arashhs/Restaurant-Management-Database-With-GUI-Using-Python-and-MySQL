-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 01, 2020 at 04:34 AM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `citado`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `refreshLogs` ()  BEGIN
    delete from address_log
        where date (now()) - date (logTime) > 3;
    delete from courier_log
        where date (now()) - date (logTime) > 3;
    delete from customer_log
        where date (now()) - date (logTime) > 3;
    delete from menu_log
        where date (now()) - date (logTime) > 3;
    delete from order_menu_log
        where date (now()) - date (logTime) > 3;
    delete from orders_log
        where date (now()) - date (logTime) > 3;
    delete from shop_log
        where date (now()) - date (logTime) > 3;
    delete from shoporder_items_log
        where date (now()) - date (logTime) > 3;
    delete from shoporder_log
        where date (now()) - date (logTime) > 3;
    delete from shoporder_items_log
        where date (now()) - date (logTime) > 3;

    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `AID` int(11) NOT NULL,
  `CID` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL,
  `fphone` decimal(11,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`AID`, `CID`, `name`, `address`, `fphone`) VALUES
(8, 1, 'haha', 'asdjas dfh', '12123'),
(569, 1, 't1', 'dsaf', NULL),
(570, 1, 't2', 'des', '1234561789'),
(571, 1, 't3', 'dsaf', '144121004'),
(572, 1, 't4', 'dsa', '1441210088'),
(573, 1, 't6', 'hj', '1441261006'),
(574, 1, 't7', '523', '1234567891'),
(575, 1, 't8', '46', '1234567891'),
(578, 1, 't', '324', '9128468255'),
(579, 1, 't', '342', '1234561234'),
(581, 1, 'tre', '432', '9125674322');

--
-- Triggers `address`
--
DELIMITER $$
CREATE TRIGGER `check_address_phone` BEFORE INSERT ON `address` FOR EACH ROW BEGIN
  IF (length(NEW.fphone) <> 10) THEN -- Abort when trying to insert this record
      	CALL phone_number_not_valid; -- raise an error to prevent insertion to the table
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `del_addressLog` BEFORE DELETE ON `address` FOR EACH ROW BEGIN
    INSERT INTO address_log VALUES(Now(), 'address', 'delete', OLD.AID, OLD.CID, OLD.name, OLD.address, OLD.fphone);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_adressLog` AFTER INSERT ON `address` FOR EACH ROW BEGIN
    INSERT INTO address_log VALUES(Now(), 'address', 'insert', NEW.AID, NEW.CID, NEW.name, NEW.address, NEW.fphone);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_addressLog` BEFORE UPDATE ON `address` FOR EACH ROW BEGIN
    INSERT INTO address_log VALUES(Now(), 'address', 'update', OLD.AID, OLD.CID, OLD.name, OLD.address, OLD.fphone);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address_log`
--

CREATE TABLE `address_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `AID` int(11) DEFAULT NULL,
  `CID` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL,
  `fphone` decimal(11,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `address_log`
--

INSERT INTO `address_log` (`logTime`, `logTable`, `logOperation`, `AID`, `CID`, `name`, `address`, `fphone`) VALUES
('2020-01-31 21:51:05', 'address', 'insert', 584, 0, 'logtest', '123 street', '2144121004'),
('2020-01-31 21:51:15', 'address', 'update', 583, 1, 'dsfs', 'adsfadsf', '5212564656'),
('2020-01-31 21:51:20', 'address', 'delete', 584, 0, 'logtest', '123 street', '2144121004'),
('2020-01-31 21:51:20', 'address', 'delete', 583, 1, 'dd', 'adsfadsf', '5212564656'),
('2020-02-01 02:14:51', 'address', 'delete', 580, 1, 't4', '432', '9124565455'),
('2020-02-01 02:14:54', 'address', 'delete', 576, 1, 't9', '345', '1234567891');

-- --------------------------------------------------------

--
-- Table structure for table `courier`
--

CREATE TABLE `courier` (
  `CNID` decimal(10,0) NOT NULL,
  `CID` int(11) NOT NULL,
  `CFName` varchar(20) NOT NULL,
  `CLName` varchar(20) NOT NULL,
  `cphone` decimal(11,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `courier`
--

INSERT INTO `courier` (`CNID`, `CID`, `CFName`, `CLName`, `cphone`) VALUES
('35165', 2, 'Amir', 'Naseri', '9216588464'),
('213123', 3, 'Amir', 'Abbasi', '9325345644'),
('5846879159', 1, 'Ali', 'Amiri', '9124563456');

--
-- Triggers `courier`
--
DELIMITER $$
CREATE TRIGGER `check_courier_phone` BEFORE INSERT ON `courier` FOR EACH ROW BEGIN
  IF ((length(NEW.cphone) <> 10) OR not(CAST(NEW.cphone AS CHAR(10)) like '9%')) THEN -- Abort when trying to insert this record
      	CALL phone_number_not_valid; -- raise an error to prevent insertion to the table
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `del_courierLog` BEFORE DELETE ON `courier` FOR EACH ROW BEGIN
    INSERT INTO courier_log VALUES(Now(), 'courier', 'delete', OLD.CNID, OLD.CID, OLD.CFName, OLD.CLName, OLD.cphone);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_courierLog` AFTER INSERT ON `courier` FOR EACH ROW BEGIN
    INSERT INTO courier_log VALUES(Now(), 'courier', 'insert', NEW.CNID, NEW.CID, NEW.CFName, NEW.CLName, NEW.cphone);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_courierLog` BEFORE UPDATE ON `courier` FOR EACH ROW BEGIN
    INSERT INTO courier_log VALUES(Now(), 'courier', 'update', OLD.CNID, OLD.CID, OLD.CFName, OLD.CLName, OLD.cphone);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `courier_log`
--

CREATE TABLE `courier_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `CNID` decimal(10,0) DEFAULT NULL,
  `CID` int(11) DEFAULT NULL,
  `CFName` varchar(20) NOT NULL,
  `CLName` varchar(20) NOT NULL,
  `cphone` decimal(11,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `courier_log`
--

INSERT INTO `courier_log` (`logTime`, `logTable`, `logOperation`, `CNID`, `CID`, `CFName`, `CLName`, `cphone`) VALUES
('2020-01-31 22:08:13', 'courier', 'insert', '124234', 2, 'logTest', 'sadas', '9128534533'),
('2020-01-31 22:08:19', 'courier', 'update', '124234', 2, 'logTest', 'sadas', '9128534533'),
('2020-01-31 22:08:22', 'courier', 'delete', '124234', 2, '2', 'sadas', '9128534533'),
('2020-02-01 02:44:52', 'courier', 'insert', '213123', 3, 'Amir', 'Abbasi', '9325345644'),
('2020-02-01 03:21:49', 'courier', 'insert', '35165', 2, 'Amir', 'Naseri', '9216589744'),
('2020-02-01 03:22:05', 'courier', 'update', '35165', 2, 'Amir', 'Naseri', '9216589744'),
('2020-02-01 03:22:10', 'courier', 'delete', '35165', 2, 'Amir', 'Naseri', '9216588464'),
('2020-02-01 03:22:12', 'courier', 'insert', '35165', 2, 'Amir', 'Naseri', '9216588464');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `CID` int(11) NOT NULL,
  `FName` varchar(20) NOT NULL,
  `LName` varchar(20) NOT NULL,
  `NID` decimal(10,0) NOT NULL,
  `cphone` decimal(11,0) NOT NULL,
  `age` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`CID`, `FName`, `LName`, `NID`, `cphone`, `age`) VALUES
(0, 'GGG', 'DDD', '112254675', '912547445', 30),
(1, 'Arash', 'Haji', '102244567', '912845633', 22),
(2, 'Babak', 'Emami', '124325', '9128468635', 20),
(3, 'Abbas', 'Najafi', '1294234619', '99999999999', 19),
(13, 'Sahand', 'Najafi2', '1294234619', '99999999999', 19),
(14, '', 'Najafi2', '1294234619', '99999999999', 19),
(15, '', '', '23', '91284682550', 33),
(16, '', 'Najafi2', '1294234619', '29424123451', 19),
(17, '', 'Najafi2', '1294234619', '294241234', 19),
(20, 'asd', 'asd', '1234567891', '12341234123', 21),
(21, 'Abbas', 'Mousavi', '385492174', '12345123451', 31),
(22, 'Amir', 'Javan', '1234123469', '97412345601', 28),
(45, 'Akj', 'kls', '1395321852', '12312321', 43),
(46, 'sdaf', 'hgdf', '1239540348', '9128468255', 45);

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `check_customer_phone` BEFORE INSERT ON `customer` FOR EACH ROW BEGIN
  IF ((length(NEW.cphone) <> 10) OR not(CAST(NEW.cphone AS CHAR(10)) like '9%')) THEN -- Abort when trying to insert this record
      	CALL phone_number_not_valid; -- raise an error to prevent insertion to the table
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `del_customerLog` BEFORE DELETE ON `customer` FOR EACH ROW BEGIN
    INSERT INTO customer_log VALUES(Now(), 'customer', 'insert', OLD.CID, OLD.FName, OLD.LName, OLD.NID, OLD.cphone, OLD.age);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_customerLog` AFTER INSERT ON `customer` FOR EACH ROW BEGIN
    INSERT INTO customer_log VALUES(Now(), 'customer', 'insert', NEW.CID, NEW.FName, NEW.LName, NEW.NID, NEW.cphone, NEW.age);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_customerLog` BEFORE UPDATE ON `customer` FOR EACH ROW BEGIN
    INSERT INTO customer_log VALUES(Now(), 'customer', 'insert', OLD.CID, OLD.FName, OLD.LName, OLD.NID, OLD.cphone, OLD.age);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_log`
--

CREATE TABLE `customer_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `CID` int(11) DEFAULT NULL,
  `FName` varchar(20) NOT NULL,
  `LName` varchar(20) NOT NULL,
  `NID` decimal(10,0) NOT NULL,
  `cphone` decimal(11,0) NOT NULL,
  `age` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer_log`
--

INSERT INTO `customer_log` (`logTime`, `logTable`, `logOperation`, `CID`, `FName`, `LName`, `NID`, `cphone`, `age`) VALUES
('2020-01-31 21:40:11', 'customer', 'insert', 47, 'testLog', 'LogFN', '213432', '9235643266', 60),
('2020-01-31 21:40:38', 'customer', 'insert', 47, 'testLog', 'LogFN', '213432', '9235643266', 60),
('2020-01-31 21:40:42', 'customer', 'insert', 50, 'updatelog', 'LogFN', '213432', '9235643266', 60),
('2020-02-01 03:19:42', 'customer', 'insert', 13, 'Abbas2', 'Najafi2', '1294234619', '99999999999', 19),
('2020-02-01 03:20:00', 'customer', 'insert', 51, 'Sahandd', 'Najafi2', '1294234619', '9128468255', 19),
('2020-02-01 03:20:12', 'customer', 'insert', 51, 'Sahandd', 'Najafi2', '1294234619', '9128468255', 19);

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `foodName` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `start` date NOT NULL,
  `end` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`foodName`, `price`, `start`, `end`) VALUES
('a', '25.50', '2020-01-31', '2020-02-02'),
('a', '30.00', '2020-02-03', '2020-02-10'),
('b', '33.00', '2020-01-15', '2020-01-31'),
('c', '30.50', '2020-01-25', '2020-01-31'),
('d', '40.00', '2020-01-24', '2020-01-31');

--
-- Triggers `menu`
--
DELIMITER $$
CREATE TRIGGER `del_menuLog` BEFORE DELETE ON `menu` FOR EACH ROW BEGIN
    INSERT INTO menu_log VALUES(Now(), 'menu', 'insert', OLD.foodName, OLD.price, OLD.start, OLD.end);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_menuLog` AFTER INSERT ON `menu` FOR EACH ROW BEGIN
    INSERT INTO menu_log VALUES(Now(), 'menu', 'insert', NEW.foodName, NEW.price, new.start, new.end);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_menuLog` BEFORE UPDATE ON `menu` FOR EACH ROW BEGIN
    INSERT INTO menu_log VALUES(Now(), 'menu', 'insert', OLD.foodName, OLD.price, OLD.start, OLD.end);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `menu_log`
--

CREATE TABLE `menu_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `foodName` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `start` date NOT NULL,
  `end` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `menu_log`
--

INSERT INTO `menu_log` (`logTime`, `logTable`, `logOperation`, `foodName`, `price`, `start`, `end`) VALUES
('2020-01-31 21:30:20', 'menu', 'insert', 'f', '66.00', '2020-01-30', '2020-01-31'),
('2020-01-31 21:33:00', 'menu', 'insert', 'f', '66.00', '2020-01-30', '2020-01-31'),
('2020-01-31 21:33:06', 'menu', 'insert', 'gg', '66.22', '2020-01-30', '2024-01-31'),
('2020-01-31 21:33:36', 'menu', 'insert', 'gg', '0.22', '2020-01-30', '2024-01-31'),
('2020-02-01 03:20:41', 'menu', 'insert', 'e', '32.50', '2020-01-24', '2020-02-04'),
('2020-02-01 03:20:46', 'menu', 'insert', 'e', '32.50', '2020-01-24', '2020-02-04'),
('2020-02-01 03:20:49', 'menu', 'insert', 'e', '1.00', '2020-01-24', '2020-02-04');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `orderID` int(11) NOT NULL,
  `orderDate` datetime NOT NULL,
  `customerID` int(11) DEFAULT NULL,
  `AID` int(11) DEFAULT NULL,
  `courierID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orderID`, `orderDate`, `customerID`, `AID`, `courierID`) VALUES
(0, '2020-01-31 17:46:09', 2, NULL, NULL),
(1, '2020-01-31 17:25:05', 3, NULL, NULL),
(2, '2020-01-31 17:25:15', 1, 8, 1),
(3, '2020-01-30 17:26:22', 2, NULL, NULL),
(4, '2020-01-31 20:38:09', 3, 573, NULL),
(7, '2020-01-31 20:38:09', 46, NULL, 3),
(30, '2020-01-30 17:26:22', NULL, NULL, NULL);

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `del_ordersLog` BEFORE DELETE ON `orders` FOR EACH ROW BEGIN
    INSERT INTO orders_log VALUES(Now(), 'orders', 'update', OLD.orderID, OLD.orderDate, OLD.customerID, OLD.AID, OLD.courierID);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_ordersLog` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
    INSERT INTO orders_log VALUES(Now(), 'orders', 'insert', NEW.orderID, NEW.orderDate, NEW.customerID, NEW.AID, NEW.courierID);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_ordersLog` BEFORE UPDATE ON `orders` FOR EACH ROW BEGIN
    INSERT INTO orders_log VALUES(Now(), 'orders', 'update', OLD.orderID, OLD.orderDate, OLD.customerID, OLD.AID, OLD.courierID);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orders_log`
--

CREATE TABLE `orders_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `orderID` int(11) DEFAULT NULL,
  `orderDate` datetime NOT NULL,
  `customerID` int(11) DEFAULT NULL,
  `AID` int(11) DEFAULT NULL,
  `courierID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders_log`
--

INSERT INTO `orders_log` (`logTime`, `logTable`, `logOperation`, `orderID`, `orderDate`, `customerID`, `AID`, `courierID`) VALUES
('2020-01-31 22:13:39', 'orders', 'insert', 23, '2020-01-31 22:12:41', 0, NULL, 1),
('2020-01-31 22:13:57', 'orders', 'update', 23, '2020-01-31 22:12:41', 0, NULL, 1),
('2020-01-31 22:14:01', 'orders', 'update', 23, '2020-01-31 22:12:41', 0, NULL, NULL),
('2020-02-01 01:30:13', 'orders', 'insert', 7, '2020-01-31 20:38:09', 3, 575, NULL),
('2020-02-01 01:31:48', 'orders', 'insert', 25, '2020-01-31 20:38:09', 3, NULL, NULL),
('2020-02-01 01:32:02', 'orders', 'insert', 26, '2020-01-31 20:38:09', 3, NULL, NULL),
('2020-02-01 01:42:28', 'orders', 'insert', 27, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 01:42:33', 'orders', 'insert', 28, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 01:42:44', 'orders', 'insert', 29, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 01:50:32', 'orders', 'update', 12, '2020-01-31 17:46:09', 2, NULL, NULL),
('2020-02-01 01:52:14', 'orders', 'update', 27, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 01:54:59', 'orders', 'update', 25, '2020-01-31 20:38:09', 3, NULL, NULL),
('2020-02-01 01:55:17', 'orders', 'update', 28, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 01:55:25', 'orders', 'update', 26, '2020-01-31 20:38:09', 3, NULL, NULL),
('2020-02-01 01:55:37', 'orders', 'update', 29, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 02:01:34', 'orders', 'insert', 31, '2020-01-31 17:46:09', NULL, 572, NULL),
('2020-02-01 02:01:37', 'orders', 'insert', 32, '2020-01-31 17:46:09', NULL, 572, NULL),
('2020-02-01 02:01:42', 'orders', 'update', 31, '2020-01-31 17:46:09', NULL, 572, NULL),
('2020-02-01 02:01:46', 'orders', 'update', 32, '2020-01-31 17:46:09', NULL, 572, NULL),
('2020-02-01 02:06:22', 'orders', 'update', 3, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 02:12:54', 'orders', 'update', 4, '2020-01-31 20:38:09', 3, NULL, NULL),
('2020-02-01 02:15:18', 'orders', 'update', 3, '2020-01-30 17:26:22', 2, 573, NULL),
('2020-02-01 02:15:33', 'orders', 'update', 3, '2020-01-30 17:26:22', 2, 578, NULL),
('2020-02-01 02:15:43', 'orders', 'insert', 33, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 02:43:18', 'orders', 'insert', 34, '2020-01-31 00:00:00', 3, 573, 1),
('2020-02-01 02:43:33', 'orders', 'update', 34, '2020-01-31 00:00:00', 3, 573, 1),
('2020-02-01 02:43:44', 'orders', 'update', 33, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 02:49:55', 'orders', 'update', 7, '2020-01-31 20:38:09', 3, 575, NULL),
('2020-02-01 02:50:09', 'orders', 'insert', 35, '2020-01-31 20:38:09', 2, NULL, 1),
('2020-02-01 02:52:05', 'orders', 'update', 7, '2020-01-31 20:38:09', 46, NULL, NULL),
('2020-02-01 02:52:18', 'orders', 'update', 7, '2020-01-31 20:38:09', 14, NULL, NULL),
('2020-02-01 02:52:22', 'orders', 'update', 7, '2020-01-31 20:38:09', 46, NULL, 1),
('2020-02-01 02:52:36', 'orders', 'update', 5, '2020-01-30 17:26:22', 2, NULL, NULL),
('2020-02-01 02:52:38', 'orders', 'update', 35, '2020-01-31 20:38:09', 2, NULL, 1),
('2020-02-01 02:52:40', 'orders', 'update', 33, '2020-01-30 17:26:22', 13, 578, 1),
('2020-02-01 06:58:57', 'orders', 'insert', 36, '2020-01-30 00:00:00', NULL, NULL, NULL),
('2020-02-01 06:59:05', 'orders', 'update', 36, '2020-01-30 00:00:00', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_menu`
--

CREATE TABLE `order_menu` (
  `orderID` int(11) NOT NULL,
  `foodName` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `unit` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_menu`
--

INSERT INTO `order_menu` (`orderID`, `foodName`, `price`, `unit`) VALUES
(1, 'a', '25.50', 1),
(1, 'b', '33.00', 3),
(1, 'd', '40.00', 1),
(2, 'a', '25.50', 1),
(2, 'a', '30.00', 2),
(3, 'a', '30.00', 4),
(3, 'b', '33.00', 1),
(4, 'd', '40.00', 3);

--
-- Triggers `order_menu`
--
DELIMITER $$
CREATE TRIGGER `del_order_menuLog` BEFORE DELETE ON `order_menu` FOR EACH ROW BEGIN
    INSERT INTO order_menu_log VALUES(Now(), 'order_menu', 'delete', OLD.orderID, OLD.foodName, OLD.price, OLD.unit);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_order_menuLog` AFTER INSERT ON `order_menu` FOR EACH ROW BEGIN
    INSERT INTO order_menu_log VALUES(Now(), 'order_menu', 'insert', NEW.orderID, NEW.foodName, NEW.price, NEW.unit);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_order_menuLog` BEFORE UPDATE ON `order_menu` FOR EACH ROW BEGIN
    INSERT INTO order_menu_log VALUES(Now(), 'order_menu', 'update', OLD.orderID, OLD.foodName, OLD.price, OLD.unit);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_menu_log`
--

CREATE TABLE `order_menu_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `orderID` int(11) DEFAULT NULL,
  `foodName` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `unit` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_menu_log`
--

INSERT INTO `order_menu_log` (`logTime`, `logTable`, `logOperation`, `orderID`, `foodName`, `price`, `unit`) VALUES
('2020-01-31 22:30:30', 'order_menu', 'insert', 4, 'b', '33.00', 5),
('2020-01-31 22:30:38', 'order_menu', 'update', 4, 'b', '33.00', 5),
('2020-01-31 22:30:43', 'order_menu', 'delete', 4, 'b', '33.00', 2),
('2020-01-31 22:30:38', 'order_menu', 'update', 4, 'b', '33.00', 5);

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--

CREATE TABLE `shop` (
  `SID` int(11) NOT NULL,
  `SName` varchar(255) NOT NULL,
  `status` enum('active','inactive') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shop`
--

INSERT INTO `shop` (`SID`, `SName`, `status`) VALUES
(1, 'Shop_One', 'active'),
(2, 'Shop_Two', 'active'),
(3, 'Shop_Three', 'inactive');

--
-- Triggers `shop`
--
DELIMITER $$
CREATE TRIGGER `del_shopLog` BEFORE DELETE ON `shop` FOR EACH ROW BEGIN
    INSERT INTO shop_log VALUES(Now(), 'orders', 'delete', OLD.SID, OLD.SName, OLD.status);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_shopLog` AFTER INSERT ON `shop` FOR EACH ROW BEGIN
    INSERT INTO shop_log VALUES(Now(), 'orders', 'insert', NEW.SID, NEW.SName, NEW.status);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_shopLog` BEFORE UPDATE ON `shop` FOR EACH ROW BEGIN
    INSERT INTO shop_log VALUES(Now(), 'orders', 'update', OLD.SID, OLD.SName, OLD.status);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `shopitem`
--

CREATE TABLE `shopitem` (
  `SID` int(11) NOT NULL,
  `IID` int(11) NOT NULL,
  `IName` varchar(50) NOT NULL,
  `Iprice` decimal(10,2) NOT NULL,
  `start` date NOT NULL,
  `end` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shopitem`
--

INSERT INTO `shopitem` (`SID`, `IID`, `IName`, `Iprice`, `start`, `end`) VALUES
(1, 1, 'item1', '20.00', '2020-01-24', '2020-01-27'),
(1, 1, 'item1', '30.00', '2020-01-30', '2020-02-02'),
(1, 2, 'item2', '15.00', '2020-01-31', '2020-02-04'),
(1, 3, 'item3', '10.50', '2020-01-30', '2020-01-31'),
(2, 1, 'item1', '10.00', '2020-01-31', '2020-02-03'),
(2, 2, 'item2', '25.50', '2020-01-03', '2020-01-31'),
(3, 1, 'item1', '17.00', '2020-01-16', '2020-01-31');

--
-- Triggers `shopitem`
--
DELIMITER $$
CREATE TRIGGER `del_shopItemLog` BEFORE DELETE ON `shopitem` FOR EACH ROW BEGIN
    INSERT INTO shopItem_log VALUES(Now(), 'shopItem', 'delete', OLD.SID, OLD.IID, OLD.IName, OLD.Iprice, OLD.start, OLD.end);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_shopItemLog` AFTER INSERT ON `shopitem` FOR EACH ROW BEGIN
    INSERT INTO shopItem_log VALUES(Now(), 'shopItem', 'insert', NEW.SID, NEW.IID, NEW.IName, NEW.Iprice, NEW.start, NEW.end);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_shopItemLog` BEFORE UPDATE ON `shopitem` FOR EACH ROW BEGIN
    INSERT INTO shopItem_log VALUES(Now(), 'shopItem', 'update', OLD.SID, OLD.IID, OLD.IName, OLD.Iprice, OLD.start, OLD.end);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `shopitem_log`
--

CREATE TABLE `shopitem_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `SID` int(11) DEFAULT NULL,
  `IID` int(11) DEFAULT NULL,
  `IName` varchar(50) NOT NULL,
  `Iprice` decimal(10,2) DEFAULT NULL,
  `start` date NOT NULL,
  `end` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shopitem_log`
--

INSERT INTO `shopitem_log` (`logTime`, `logTable`, `logOperation`, `SID`, `IID`, `IName`, `Iprice`, `start`, `end`) VALUES
('2020-01-31 22:21:53', 'shopItem', 'insert', 1, 4, 'logItem', '12.50', '2020-01-31', '2020-01-23'),
('2020-01-31 22:21:59', 'shopItem', 'update', 1, 4, 'logItem', '12.50', '2020-01-31', '2020-01-23'),
('2020-01-31 22:22:03', 'shopItem', 'delete', 1, 0, 'logItem', '12.50', '2020-01-31', '2020-01-23');

-- --------------------------------------------------------

--
-- Table structure for table `shoporder`
--

CREATE TABLE `shoporder` (
  `orderID` int(11) NOT NULL,
  `SID` int(11) NOT NULL,
  `orderDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shoporder`
--

INSERT INTO `shoporder` (`orderID`, `SID`, `orderDate`) VALUES
(1, 1, '2020-01-31'),
(2, 1, '2020-01-30'),
(3, 2, '2020-01-31');

--
-- Triggers `shoporder`
--
DELIMITER $$
CREATE TRIGGER `del_shopOrderLog` BEFORE DELETE ON `shoporder` FOR EACH ROW BEGIN
    INSERT INTO shopOrder_log VALUES(Now(), 'shopOrder', 'delete', OLD.orderID, OLD.SID, OLD.orderDate);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_shopOrderLog` AFTER INSERT ON `shoporder` FOR EACH ROW BEGIN
    INSERT INTO shopOrder_log VALUES(Now(), 'shopOrder', 'insert', NEW.orderID, new.SID, new.orderDate);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_shopOrderLog` BEFORE UPDATE ON `shoporder` FOR EACH ROW BEGIN
    INSERT INTO shopOrder_log VALUES(Now(), 'shopOrder', 'update', OLD.orderID, OLD.SID, OLD.orderDate);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `shoporder_items`
--

CREATE TABLE `shoporder_items` (
  `orderID` int(11) NOT NULL,
  `SID` int(11) NOT NULL,
  `IID` int(11) NOT NULL,
  `Iprice` decimal(10,2) NOT NULL,
  `unit` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shoporder_items`
--

INSERT INTO `shoporder_items` (`orderID`, `SID`, `IID`, `Iprice`, `unit`) VALUES
(1, 1, 1, '20.00', 1),
(1, 1, 2, '15.00', 3),
(1, 1, 3, '10.50', 1),
(2, 1, 3, '10.50', 1),
(3, 1, 1, '20.00', 3);

--
-- Triggers `shoporder_items`
--
DELIMITER $$
CREATE TRIGGER `del_shoporder_itemsLog` BEFORE DELETE ON `shoporder_items` FOR EACH ROW BEGIN
    INSERT INTO shoporder_items_log VALUES(Now(), 'shoporder_items', 'delete', OLD.orderID, OLD.SID, OLD.IID, OLD.Iprice, OLD.unit);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_shoporder_itemsLog` AFTER INSERT ON `shoporder_items` FOR EACH ROW BEGIN
    INSERT INTO shoporder_items_log VALUES(Now(), 'shoporder_items', 'insert', NEW.orderID, NEW.SID, NEW.IID, NEW.Iprice, NEW.unit);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_shoporder_itemsLog` BEFORE UPDATE ON `shoporder_items` FOR EACH ROW BEGIN
    INSERT INTO shoporder_items_log VALUES(Now(), 'shoporder_items', 'update', OLD.orderID, OLD.SID, OLD.IID, OLD.Iprice, OLD.unit);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `shoporder_items_log`
--

CREATE TABLE `shoporder_items_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `orderID` int(11) DEFAULT NULL,
  `SID` int(11) DEFAULT NULL,
  `IID` int(11) DEFAULT NULL,
  `Iprice` decimal(10,2) DEFAULT NULL,
  `unit` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shoporder_items_log`
--

INSERT INTO `shoporder_items_log` (`logTime`, `logTable`, `logOperation`, `orderID`, `SID`, `IID`, `Iprice`, `unit`) VALUES
('2020-01-31 22:35:36', 'shoporder_items', 'insert', 2, 1, 3, '10.50', 5),
('2020-01-31 22:35:44', 'shoporder_items', 'update', 2, 1, 3, '10.50', 5),
('2020-01-31 22:35:48', 'shoporder_items', 'delete', 2, 1, 3, '10.50', 1),
('2020-02-01 03:16:10', 'shoporder_items', 'insert', 2, 1, 3, '10.50', 1),
('2020-02-01 03:17:03', 'shoporder_items', 'delete', 2, 1, 1, '20.00', 3),
('2020-02-01 03:36:26', 'shoporder_items', 'insert', 3, 1, 1, '20.00', 3),
('2020-02-01 03:37:08', 'shoporder_items', 'update', 3, 1, 1, '30.00', 4),
('2020-02-01 03:37:12', 'shoporder_items', 'update', 3, 1, 1, '30.00', 4),
('2020-02-01 03:37:32', 'shoporder_items', 'update', 3, 1, 1, '30.00', 2),
('2020-02-01 03:37:36', 'shoporder_items', 'delete', 3, 1, 1, '30.00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `shoporder_log`
--

CREATE TABLE `shoporder_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `orderID` int(11) DEFAULT NULL,
  `SID` int(11) NOT NULL,
  `orderDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shoporder_log`
--

INSERT INTO `shoporder_log` (`logTime`, `logTable`, `logOperation`, `orderID`, `SID`, `orderDate`) VALUES
('2020-01-31 22:26:26', 'shopOrder', 'insert', 4, 3, '2020-01-21'),
('2020-01-31 22:26:31', 'shopOrder', 'update', 4, 3, '2020-01-21'),
('2020-01-31 22:26:57', 'shopOrder', 'delete', 0, 3, '2020-01-21'),
('2020-01-31 22:26:26', 'shopOrder', 'insert', 4, 3, '2020-01-21'),
('2020-02-01 03:12:50', 'shopOrder', 'insert', 6, 1, '2020-01-31'),
('2020-02-01 03:12:56', 'shopOrder', 'update', 6, 1, '2020-01-31'),
('2020-02-01 03:13:01', 'shopOrder', 'update', 6, 2, '2020-01-31'),
('2020-02-01 03:13:06', 'shopOrder', 'delete', 7, 2, '2020-01-31'),
('2020-02-01 06:57:03', 'shopOrder', 'insert', 8, 2, NULL),
('2020-02-01 06:57:41', 'shopOrder', 'update', 8, 2, NULL),
('2020-02-01 06:57:49', 'shopOrder', 'delete', 8, 2, '2020-01-30');

-- --------------------------------------------------------

--
-- Table structure for table `shop_log`
--

CREATE TABLE `shop_log` (
  `logTime` datetime DEFAULT NULL,
  `logTable` varchar(20) DEFAULT NULL,
  `logOperation` enum('insert','delete','update') DEFAULT NULL,
  `SID` int(11) DEFAULT NULL,
  `SName` varchar(255) NOT NULL,
  `status` enum('active','inactive') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shop_log`
--

INSERT INTO `shop_log` (`logTime`, `logTable`, `logOperation`, `SID`, `SName`, `status`) VALUES
('2020-01-31 22:17:43', 'orders', 'insert', 4, 'Shop_logTest', 'active'),
('2020-01-31 22:17:52', 'orders', 'update', 4, 'Shop_logTest', 'active'),
('2020-01-31 22:17:56', 'orders', 'delete', 4, 'Shop_logTest', 'inactive'),
('2020-02-01 03:23:50', 'orders', 'insert', 5, 'Shop_Four', 'active'),
('2020-02-01 03:34:21', 'orders', 'update', 5, 'Shop_Four', 'active'),
('2020-02-01 03:34:49', 'orders', 'update', 5, 'Shop_Four', 'inactive'),
('2020-02-01 03:35:16', 'orders', 'delete', 5, 'Shop_Four', 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`AID`),
  ADD KEY `CID` (`CID`);

--
-- Indexes for table `courier`
--
ALTER TABLE `courier`
  ADD PRIMARY KEY (`CNID`),
  ADD KEY `CID` (`CID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`CID`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`foodName`,`start`),
  ADD KEY `foodName` (`foodName`,`price`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orderID`),
  ADD KEY `customerID` (`customerID`),
  ADD KEY `AID` (`AID`),
  ADD KEY `courierID` (`courierID`);

--
-- Indexes for table `order_menu`
--
ALTER TABLE `order_menu`
  ADD PRIMARY KEY (`orderID`,`foodName`,`price`),
  ADD KEY `foodName` (`foodName`,`price`);

--
-- Indexes for table `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`SID`);

--
-- Indexes for table `shopitem`
--
ALTER TABLE `shopitem`
  ADD PRIMARY KEY (`SID`,`IID`,`Iprice`);

--
-- Indexes for table `shoporder`
--
ALTER TABLE `shoporder`
  ADD PRIMARY KEY (`orderID`),
  ADD KEY `SID` (`SID`);

--
-- Indexes for table `shoporder_items`
--
ALTER TABLE `shoporder_items`
  ADD PRIMARY KEY (`orderID`,`SID`,`IID`,`Iprice`),
  ADD KEY `SID` (`SID`,`IID`,`Iprice`),
  ADD KEY `orderID` (`orderID`,`SID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `AID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=585;

--
-- AUTO_INCREMENT for table `courier`
--
ALTER TABLE `courier`
  MODIFY `CID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `CID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `orderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `shop`
--
ALTER TABLE `shop`
  MODIFY `SID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `shoporder`
--
ALTER TABLE `shoporder`
  MODIFY `orderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `address`
--
ALTER TABLE `address`
  ADD CONSTRAINT `address_ibfk_1` FOREIGN KEY (`CID`) REFERENCES `customer` (`CID`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `customer` (`CID`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`AID`) REFERENCES `address` (`AID`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`courierID`) REFERENCES `courier` (`CID`);

--
-- Constraints for table `order_menu`
--
ALTER TABLE `order_menu`
  ADD CONSTRAINT `order_menu_ibfk_1` FOREIGN KEY (`orderID`) REFERENCES `orders` (`orderID`),
  ADD CONSTRAINT `order_menu_ibfk_2` FOREIGN KEY (`foodName`,`price`) REFERENCES `menu` (`foodName`, `price`);

--
-- Constraints for table `shopitem`
--
ALTER TABLE `shopitem`
  ADD CONSTRAINT `shopitem_ibfk_1` FOREIGN KEY (`SID`) REFERENCES `shop` (`SID`);

--
-- Constraints for table `shoporder`
--
ALTER TABLE `shoporder`
  ADD CONSTRAINT `shoporder_ibfk_1` FOREIGN KEY (`SID`) REFERENCES `shop` (`SID`);

--
-- Constraints for table `shoporder_items`
--
ALTER TABLE `shoporder_items`
  ADD CONSTRAINT `shoporder_items___fk` FOREIGN KEY (`orderID`) REFERENCES `shoporder` (`orderID`),
  ADD CONSTRAINT `shoporder_items_ibfk_2` FOREIGN KEY (`SID`,`IID`,`Iprice`) REFERENCES `shopitem` (`SID`, `IID`, `Iprice`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
