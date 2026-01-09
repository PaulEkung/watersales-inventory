-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: watersales
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `app_customer`
--

DROP TABLE IF EXISTS `app_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(50) NOT NULL,
  `customer_email` varchar(50) NOT NULL,
  `customer_phone` varchar(15) NOT NULL,
  `customer_address` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `customer_email` (`customer_email`),
  UNIQUE KEY `customer_phone` (`customer_phone`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_customer`
--

LOCK TABLES `app_customer` WRITE;
/*!40000 ALTER TABLE `app_customer` DISABLE KEYS */;
INSERT INTO `app_customer` VALUES (1,'Paul Ekung','ekungpaul3@gmail.com','09067476828','No. 23 Adagom, Ogoja, Cross River State, Nigeria\r\nCommunity 26, House 17','pbkdf2_sha256$870000$fWNY8m9WaEjKAHeEUXwR3L$9sqN8bI16OqUjoCET7TfgKMfc97nsKy8ki4GVByKNEc='),(2,'Elizabeth Inyangudo','lizzinyangudo@gmail.com','09135971061','Front Gate, Unwana','pbkdf2_sha256$870000$KCDAd8GgSPt1qgJEjJbWVf$JP+7I2YaQ2hLdJM5yNGzfDywypc+UZ3DGJz096PJkkM='),(5,'Lizy Inyang','lizybenz90@yahoo.com','08105749917','BackGate, Unwana','pbkdf2_sha256$870000$ndgRq5CFgrPh6s4o2lm1nF$BrQguwCtnzDDtrrXLEbB/ZMCOkY+GpdLZth1aY5gxNE=');
/*!40000 ALTER TABLE `app_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_delivery`
--

DROP TABLE IF EXISTS `app_delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_delivery` (
  `delivery_id` int NOT NULL AUTO_INCREMENT,
  `delivery_date` date NOT NULL,
  `delivery_status` varchar(20) NOT NULL,
  `sales_id` int NOT NULL,
  PRIMARY KEY (`delivery_id`),
  KEY `app_delivery_sales_id_85253923_fk_app_sale_sale_id` (`sales_id`),
  CONSTRAINT `app_delivery_sales_id_85253923_fk_app_sale_sale_id` FOREIGN KEY (`sales_id`) REFERENCES `app_sale` (`sale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_delivery`
--

LOCK TABLES `app_delivery` WRITE;
/*!40000 ALTER TABLE `app_delivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_product`
--

DROP TABLE IF EXISTS `app_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_product` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(40) NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `stock_quantity` int NOT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_product`
--

LOCK TABLES `app_product` WRITE;
/*!40000 ALTER TABLE `app_product` DISABLE KEYS */;
INSERT INTO `app_product` VALUES (1,'Polyunwana Pure Water',350.00,1452),(2,'Polyunwana Bottle Water',4000.00,2460);
/*!40000 ALTER TABLE `app_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_sale`
--

DROP TABLE IF EXISTS `app_sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_sale` (
  `sale_id` int NOT NULL AUTO_INCREMENT,
  `sale_date` datetime(6) NOT NULL,
  `quantity_sold` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_status` varchar(20) NOT NULL,
  `customer_id` int NOT NULL,
  `product_id` int NOT NULL,
  `delivery_address` longtext NOT NULL DEFAULT (_utf8mb3'Unknown'),
  `delivery_status` varchar(20) NOT NULL,
  PRIMARY KEY (`sale_id`),
  KEY `app_sale_customer_id_f9d9ca56_fk_app_customer_customer_id` (`customer_id`),
  KEY `app_sale_product_id_b96488e6_fk_app_product_product_id` (`product_id`),
  CONSTRAINT `app_sale_customer_id_f9d9ca56_fk_app_customer_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `app_customer` (`customer_id`),
  CONSTRAINT `app_sale_product_id_b96488e6_fk_app_product_product_id` FOREIGN KEY (`product_id`) REFERENCES `app_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_sale`
--

LOCK TABLES `app_sale` WRITE;
/*!40000 ALTER TABLE `app_sale` DISABLE KEYS */;
INSERT INTO `app_sale` VALUES (1,'2025-08-19 20:10:39.647982',5,20000.00,'Paid',1,2,'No. 23 D12, Fish Pond, New Jerusalem Lodge. ','Delivered'),(2,'2025-08-20 13:41:24.599757',30,10500.00,'Paid',1,1,'No. 22, Camel road, Afikpo','Delivered'),(3,'2025-08-22 22:53:54.717608',25,100000.00,'Paid',1,2,'No. 22, Camel road, Afikpo','Not Delivered'),(4,'2025-08-22 22:59:43.757597',15,5250.00,'Paid',1,1,'447 Broadway, 2nd Floor\r\n','Not Delivered'),(5,'2025-09-18 10:26:38.340724',5,20000.00,'Paid',2,2,'Front Gate, Blessed Lodge, Unwana.','Delivered'),(6,'2025-09-18 10:44:28.347968',3,1050.00,'Paid',2,1,'Front Gate, Unwana','Not Delivered'),(7,'2025-09-18 12:21:53.534482',5,20000.00,'Paid',2,2,'BackGate, Unwana','Not Delivered');
/*!40000 ALTER TABLE `app_sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_staff`
--

DROP TABLE IF EXISTS `app_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_staff` (
  `staff_id` int NOT NULL AUTO_INCREMENT,
  `staff_name` varchar(50) NOT NULL,
  `staff_role` varchar(20) NOT NULL,
  `staff_email` varchar(50) NOT NULL,
  `staff_phone` varchar(15) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `staff_email` (`staff_email`),
  UNIQUE KEY `staff_phone` (`staff_phone`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_staff`
--

LOCK TABLES `app_staff` WRITE;
/*!40000 ALTER TABLE `app_staff` DISABLE KEYS */;
INSERT INTO `app_staff` VALUES (1,'Innocent Dominic ','Manager','egbedominic01@gmail.com','08145334996','pbkdf2_sha256$870000$9yRLdE1H83sMfPWfRxFkvy$4C13airjv91Jsd+PkLzltU9a2JAQ3M961gWOnjiqn6Q='),(3,'Dan Etim','Salesperson','danakongetim@gmail.com','09077483484','pbkdf2_sha256$870000$QljHmqxIdpkHTIALBMrnNl$eerMmqVWQ7PO90E4Zk0s7eByFlyD7/9Rcf3cPlIdnW4='),(4,'Glory Oko','Cashier','okoglory@gmail.com','09099993939','pbkdf2_sha256$870000$Xwsuu6TWtNbxjTFbOzKmBp$Y4tPnB5StafClDef332rFuC4bqJYu68AvKHEOq2Uizw=');
/*!40000 ALTER TABLE `app_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add customer',7,'add_customer'),(26,'Can change customer',7,'change_customer'),(27,'Can delete customer',7,'delete_customer'),(28,'Can view customer',7,'view_customer'),(29,'Can add product',8,'add_product'),(30,'Can change product',8,'change_product'),(31,'Can delete product',8,'delete_product'),(32,'Can view product',8,'view_product'),(33,'Can add report',9,'add_report'),(34,'Can change report',9,'change_report'),(35,'Can delete report',9,'delete_report'),(36,'Can view report',9,'view_report'),(37,'Can add staff',10,'add_staff'),(38,'Can change staff',10,'change_staff'),(39,'Can delete staff',10,'delete_staff'),(40,'Can view staff',10,'view_staff'),(41,'Can add sale',11,'add_sale'),(42,'Can change sale',11,'change_sale'),(43,'Can delete sale',11,'delete_sale'),(44,'Can view sale',11,'view_sale'),(45,'Can add delivery',12,'add_delivery'),(46,'Can change delivery',12,'change_delivery'),(47,'Can delete delivery',12,'delete_delivery'),(48,'Can view delivery',12,'view_delivery');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(7,'app','customer'),(12,'app','delivery'),(8,'app','product'),(9,'app','report'),(11,'app','sale'),(10,'app','staff'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-08-15 11:22:28.713060'),(2,'auth','0001_initial','2025-08-15 11:23:15.665572'),(3,'admin','0001_initial','2025-08-15 11:23:25.000784'),(4,'admin','0002_logentry_remove_auto_add','2025-08-15 11:23:25.253366'),(5,'admin','0003_logentry_add_action_flag_choices','2025-08-15 11:23:25.612169'),(6,'app','0001_initial','2025-08-15 11:23:53.651910'),(7,'contenttypes','0002_remove_content_type_name','2025-08-15 11:23:57.314759'),(8,'auth','0002_alter_permission_name_max_length','2025-08-15 11:24:00.617006'),(9,'auth','0003_alter_user_email_max_length','2025-08-15 11:24:01.609089'),(10,'auth','0004_alter_user_username_opts','2025-08-15 11:24:01.819584'),(11,'auth','0005_alter_user_last_login_null','2025-08-15 11:24:08.135118'),(12,'auth','0006_require_contenttypes_0002','2025-08-15 11:24:08.394079'),(13,'auth','0007_alter_validators_add_error_messages','2025-08-15 11:24:08.570245'),(14,'auth','0008_alter_user_username_max_length','2025-08-15 11:24:11.357061'),(15,'auth','0009_alter_user_last_name_max_length','2025-08-15 11:24:14.988801'),(16,'auth','0010_alter_group_name_max_length','2025-08-15 11:24:15.527030'),(17,'auth','0011_update_proxy_permissions','2025-08-15 11:24:15.773822'),(18,'auth','0012_alter_user_first_name_max_length','2025-08-15 11:24:19.657805'),(19,'sessions','0001_initial','2025-08-15 11:24:21.858214'),(20,'app','0002_customer_password_staff_password','2025-08-15 14:37:38.071260'),(21,'app','0003_remove_sale_staff','2025-08-19 17:30:42.842779'),(22,'app','0004_sale_delivery_address','2025-08-20 10:32:37.470091'),(23,'app','0005_sale_delivery_status','2025-08-22 19:32:17.537145'),(24,'app','0006_delete_report','2025-08-22 22:02:06.206651');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('g0hv84iprw9faw696n6aey6pd6ya5se5','eyJlbWFpbCI6Imxpenppbnlhbmd1ZG9AZ21haWwuY29tIn0:1uzDbD:SxbJWKe8BMp5uDi0ZtekvV8KT8GQ7hhxLiANzw3ibXQ','2025-10-02 12:18:55.627925'),('gilg5rv6kjk1db5gulrm82vcpt4eekbz','eyJlbWFpbCI6ImVrdW5ncGF1bDNAZ21haWwuY29tIn0:1upacG:PY1YXmShvUvzQdwlFbbHd8hANot-hXx4Y7Opv4sSUi4','2025-09-05 22:52:12.316319'),('jvi10srruf4hjo8zbqrv2hra92lu0w69','eyJlbWFpbCI6Imxpenppbnlhbmd1ZG9AZ21haWwuY29tIn0:1v28Ao:gRV5Ksz9_1YEtCHoWsuXsr1WLpw2GZ6cbc3ULzO7xjw','2025-10-10 13:07:42.681877'),('n9dllk4ye6m94pn0rh2qsc1exi3hwptu','eyJlbWFpbCI6Imxpenppbnlhbmd1ZG9AZ21haWwuY29tIn0:1v0fpP:O9kl-68ynPnTmLG1MgeFLvh812TCXhueQn2Tw-hsnGc','2025-10-06 12:39:35.659853'),('toadblhehebkvknufwc535rsy418nv8v','eyJlbWFpbCI6ImRhbmFrb25nZXRpbUBnbWFpbC5jb20ifQ:1up4bI:Cj9K9tIPdk-8NF5acg5ks8vFHiOoAHV57r_-BDuLrYM','2025-09-04 12:41:04.170887');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-29 10:55:40
