/*
SQLyog Professional v13.1.1 (64 bit)
MySQL - 8.0.18 : Database - blab
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`blab` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `blab`;

/*Table structure for table `authorities` */

DROP TABLE IF EXISTS `authorities`;

CREATE TABLE `authorities` (
  `id` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'id is the name of endpoint sepcified by deveoper in code example ''post-users'' or ''update-user-by-id''',
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Authority is basicallly an endpoint of api.';

/*Data for the table `authorities` */

/*Table structure for table `buyers` */

DROP TABLE IF EXISTS `buyers`;

CREATE TABLE `buyers` (
  `phoneNumber` varchar(20) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `address` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `zipcode` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `userId` varchar(50) NOT NULL,
  PRIMARY KEY (`userId`),
  KEY `buyer_user_fk_idx` (`userId`),
  CONSTRAINT `buyer_user_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Buyer table is derivitive of user table, the redundant fields are kept so user can maintain a byer profile differently or can use same details as the main user.';

/*Data for the table `buyers` */

/*Table structure for table `cart_product_options` */

DROP TABLE IF EXISTS `cart_product_options`;

CREATE TABLE `cart_product_options` (
  `id` varchar(45) NOT NULL,
  `cartProductId` varchar(50) NOT NULL,
  `productIOptionId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_product_option_product_option_fk_idx` (`productIOptionId`),
  KEY `cart_product_option_cart_product_fk` (`cartProductId`),
  CONSTRAINT `cart_product_option_cart_product_fk` FOREIGN KEY (`cartProductId`) REFERENCES `cart_products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cart_product_option_product_option_fk` FOREIGN KEY (`productIOptionId`) REFERENCES `product_options` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='This table is to maintain options selected for a single product. A product in cart can have multiple variants with different options. Like a person can add a red also a blue shirt in the same cart. ';

/*Data for the table `cart_product_options` */

/*Table structure for table `cart_products` */

DROP TABLE IF EXISTS `cart_products`;

CREATE TABLE `cart_products` (
  `id` varchar(50) NOT NULL,
  `quantity` int(5) DEFAULT NULL COMMENT 'Once the cart is order the quantity is subtracted from option.',
  `cartId` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `prodcutId` varchar(50) NOT NULL COMMENT 'A cart can have same product listed multiple times with different options. ',
  PRIMARY KEY (`id`),
  KEY `order_product_product_fk_idx` (`prodcutId`),
  KEY `order_product_cart_f` (`cartId`),
  CONSTRAINT `order_product_cart_f` FOREIGN KEY (`cartId`) REFERENCES `carts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_product_product_fk0` FOREIGN KEY (`prodcutId`) REFERENCES `products` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `cart_products` */

/*Table structure for table `carts` */

DROP TABLE IF EXISTS `carts`;

CREATE TABLE `carts` (
  `id` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `state` varchar(100) DEFAULT NULL,
  `buyerId` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'One buyer can only have one editable cart at one time.',
  PRIMARY KEY (`id`),
  KEY `buyerId` (`buyerId`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`buyerId`) REFERENCES `buyers` (`userId`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `carts` */

/*Table structure for table `categories` */

DROP TABLE IF EXISTS `categories`;

CREATE TABLE `categories` (
  `id` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `parentCategoryId` varchar(50) DEFAULT NULL COMMENT 'If category is not derived from other category than parentCategoryId would be null. But if it derived from other category like in Monitor->LCD than the parentCategoryId will be set accordingly',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `categories` */

/*Table structure for table `order_shipping_details` */

DROP TABLE IF EXISTS `order_shipping_details`;

CREATE TABLE `order_shipping_details` (
  `receiverName` varchar(100) DEFAULT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `zipcode` varchar(20) DEFAULT NULL,
  `orderId` varchar(50) NOT NULL,
  KEY `order_shipping_detail_order_fk_idx` (`orderId`),
  CONSTRAINT `order_shipping_detail_order_fk` FOREIGN KEY (`orderId`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `order_shipping_details` */

/*Table structure for table `orders` */

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `id` varchar(50) NOT NULL,
  `billAmount` varchar(60) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `cartId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cartId` (`cartId`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `carts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The order contains the final details once the orde ris confirmed by user. ';

/*Data for the table `orders` */

/*Table structure for table `product_features` */

DROP TABLE IF EXISTS `product_features`;

CREATE TABLE `product_features` (
  `id` varchar(45) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `productId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `productId` (`productId`),
  CONSTRAINT `product_feature_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Feature in every product come with the product and user does not have option to select or unselect them.';

/*Data for the table `product_features` */

/*Table structure for table `product_options` */

DROP TABLE IF EXISTS `product_options`;

CREATE TABLE `product_options` (
  `id` varchar(45) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `stock` int(5) DEFAULT NULL COMMENT 'In case an option is added to a product than the stock depends on stock of option. ',
  `type` varchar(45) NOT NULL COMMENT 'Type of product option shows if option is like a radio or check. Radio type options can only be selected from multiple. A check type option user can select one,all or none. For example water cooling option in a PC will be check type but ram option will be radio type.',
  `optionCategory` varchar(100) NOT NULL COMMENT 'An option can be categorized into color, size or anything that contains multiple options.',
  `productId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_option_product_fk` (`productId`),
  CONSTRAINT `product_option_product_fk` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `product_options` */

/*Table structure for table `products` */

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` varchar(50) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `stock` int(5) DEFAULT NULL,
  `storeId` varchar(50) DEFAULT NULL COMMENT 'A product can exist independently without a store.',
  `categoryId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_fk_idx` (`categoryId`),
  KEY `store_fk_idx` (`storeId`),
  CONSTRAINT `product_category_fk` FOREIGN KEY (`categoryId`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `product_store_fk` FOREIGN KEY (`storeId`) REFERENCES `stores` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `products` */

/*Table structure for table `role_authorities` */

DROP TABLE IF EXISTS `role_authorities`;

CREATE TABLE `role_authorities` (
  `roleId` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `authorityId` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`roleId`,`authorityId`),
  KEY `authority` (`authorityId`),
  CONSTRAINT `role_authority_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_authority_ibfk_2` FOREIGN KEY (`authorityId`) REFERENCES `authorities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='A role has multiple authorities.';

/*Data for the table `role_authorities` */

/*Table structure for table `roles` */

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'id is name of role. A role can have multiple authorities.',
  `allowedSimoultaneousSessions` int(10) DEFAULT '1' COMMENT 'User cannot have more than allowed session at one time.',
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `level` int(4) DEFAULT NULL COMMENT 'Role level starts from ''0'' being the rolw with all the authorities. This is used to determine the power of a role over other roles. A role cannot edit or delete information of a role which is more/equal powerful than them selves.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `roles` */

/*Table structure for table `sellers` */

DROP TABLE IF EXISTS `sellers`;

CREATE TABLE `sellers` (
  `phoneNumber` varchar(20) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `zipcode` varchar(20) DEFAULT NULL,
  `userId` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`userId`),
  KEY `seller_user_fk_idx` (`userId`),
  CONSTRAINT `seller_user_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Seller table is derivitive of user table, the redundant fields are kept so user can maintain a seller profile differently or can use same details as the main user.';

/*Data for the table `sellers` */

/*Table structure for table `sessions` */

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` varchar(50) NOT NULL,
  `remoteAddress` varchar(50) DEFAULT NULL COMMENT 'Ip address of user is stored while creating session.',
  `status` varchar(45) DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `userId` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `status_UNIQUE` (`status`),
  KEY `fk_user_idx` (`userId`),
  CONSTRAINT `fk_user` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `sessions` */

/*Table structure for table `stores` */

DROP TABLE IF EXISTS `stores`;

CREATE TABLE `stores` (
  `id` varchar(50) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `address` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `sellerId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sellerId` (`sellerId`),
  CONSTRAINT `stores_ibfk_1` FOREIGN KEY (`sellerId`) REFERENCES `sellers` (`userId`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `stores` */

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` varchar(100) NOT NULL,
  `username` varchar(256) NOT NULL,
  `password` varchar(256) NOT NULL,
  `name` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `phoneNumber` varchar(30) DEFAULT NULL,
  `phoneNumberVerified` tinyint(1) DEFAULT '0',
  `email` varchar(300) DEFAULT NULL,
  `emailverified` tinyint(1) DEFAULT '0',
  `locked` tinyint(1) DEFAULT NULL,
  `expiry` timestamp NULL DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `roleId` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_username` (`username`),
  KEY `role` (`roleId`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `users` */

/* Procedure structure for procedure `get_users_without_password` */

/*!50003 DROP PROCEDURE IF EXISTS  `get_users_without_password` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `get_users_without_password`(IN username varchar(256))
BEGIN
		SELECT `users`.`id`, `users`.`username`, `users`.`firstname`,`users`.`lastname`,`users`.`email`,`users`.`locked`,
		`users`.`expiry`,`users`.`created`,`users`.`updated`  FROM `users` where `users`.`username`=`username` or `username` is null;
		SELECT `users`.`id`, `users`.`username`, `users`.`firstname`,`users`.`lastname`,`users`.`email`,`users`.`locked`,
		`users`.`expiry`,`users`.`created`,`users`.`updated`  FROM `users` WHERE `users`.`username`=`username` OR `username` IS NULL;
	END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
