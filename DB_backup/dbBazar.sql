
DROP DATABASE IF EXISTS `db_bazar`;

CREATE DATABASE `db_bazar` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `db_bazar`;

/*Table structure for table `detalle_usuario` */
DROP TABLE IF EXISTS `detalle_usuario`;

CREATE TABLE `detalle_usuario` (
  `id_detalle` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(32) NOT NULL,
  `apellidos` VARCHAR(32) NOT NULL,
  `dni` integer(8) NOT NULL,
  `telefono` VARCHAR(13) NOT NULL,
  `correo` VARCHAR(20) NULL,
  `direccion` VARCHAR(32) NULL,
  `distrito` VARCHAR(32) NULL,
  `provincia` VARCHAR(32) NULL,
  `departamento` VARCHAR(32) NULL,
  `comentario` TEXT NULL,
  PRIMARY KEY (`id_detalle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `usuario` */
DROP TABLE IF EXISTS `usuario`;

CREATE TABLE `usuario` (
  `id_usuario` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_detalle` SMALLINT UNSIGNED NULL,
  `cuenta` VARCHAR(16) NOT NULL,
  `password` VARCHAR(32) NOT NULL,
  `estado` enum('activado','desactivado') NOT NULL DEFAULT 'desactivado',
  `fecha_registro` DATETIME NOT NULL DEFAULT current_timestamp(),
  `fecha_mod` DATETIME NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY(`id_usuario`),
  FOREIGN KEY (`id_detalle`) REFERENCES `detalle_usuario`(`id_detalle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `rol` */
DROP TABLE IF EXISTS `rol`;

CREATE TABLE `rol`(
  `id_rol` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(16) NOT NULL,
  `permiso_defecto` JSON NOT NULL,
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `detalle_rol` */
DROP TABLE IF EXISTS `detalle_rol`;

CREATE TABLE `detalle_rol`(
  `id_usuario` SMALLINT UNSIGNED NOT NULL,
  `id_rol` TINYINT UNSIGNED NOT NULL,
  `permiso` JSON NOT NULL,
  `is_custom` BOOLEAN DEFAULT 0,
  `comentario` TINYTEXT DEFAULT '',
  FOREIGN key (`id_usuario`) REFERENCES `usuario`(`id_usuario`),
  FOREIGN key (`id_rol`) REFERENCES `rol`(`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `proveedor` */
DROP TABLE IF EXISTS `proveedor`;

CREATE TABLE `proveedor`(
  `id_proveedor` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(32) NOT NULL,
  `ruc` VARCHAR(32) NULL,
  `razon_social` TINYTEXT NOT NULL,
  `direccion` TINYTEXT NOT NULL,
  `estado` enum('activado','desactivado') NOT NULL DEFAULT 'desactivado',
  `fecha_registro` DATETIME NOT NULL DEFAULT current_timestamp(),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `compra` */
DROP TABLE IF EXISTS `compra`;

CREATE TABLE `compra`(
  `id_compra` INTEGER NOT NULL AUTO_INCREMENT,
  `id_proveedor` SMALLINT UNSIGNED NOT NULL,
  `numero_comprobante` VARCHAR(16) NOT NULL,
  `descripcion` TEXT NULL,
  `importe_total` numeric(9,4) NOT NULL,
  `costo_flete` numeric(9,4) NOT NULL,
  `comision_banco` numeric(9,4) NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT current_timestamp(),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_compra`),
  FOREIGN key (`id_proveedor`) REFERENCES `proveedor`(`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `producto` */
DROP TABLE IF EXISTS `producto`;

CREATE TABLE `producto`(
  `id_producto` SMALLINT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(32) NOT NULL,
  `medida` VARCHAR(32) NOT NULL,
  `marca` VARCHAR(32) NOT NULL,
  `tipo_unidad` enum('paquete','unidad') NOT NULL DEFAULT 'unidad',
  `cantidad_unidad` TINYINT NOT NULL DEFAULT 1,
  `precio_sugerido` numeric(9,4) NULL DEFAULT 10000,
  `estado` enum('disponible','no-disponible') NOT NULL DEFAULT 'no-disponible',
  `stock` SMALLINT NOT NULL,
  `fecha` DATETIME NULL DEFAULT current_timestamp(),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `producto` */
INSERT INTO producto(nombre,medida,marca,stock) 
VALUES
('detergente','800 gr','amor',0),
('detergente','900 gr','orion',0),
('detergente','15 kg','doffi',0);

/*Table structure for table `detalle_compra` */
DROP TABLE IF EXISTS `detalle_compra`;

CREATE TABLE `detalle_compra`(
  `id_compra` INTEGER  NOT NULL,
  `id_producto` SMALLINT NOT NULL,
  `cantidad` integer(5) NOT NULL,
  `precio_bruto` numeric(9,4) NOT NULL,
  `comentario` TINYTEXT DEFAULT '',
  FOREIGN KEY (`id_producto`) REFERENCES `producto`(`id_producto`),
  FOREIGN KEY (`id_compra`) REFERENCES `compra`(`id_compra`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `cliente` */
DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente`(
  `id_cliente` INTEGER(6) NOT NULL AUTO_INCREMENT,
  `dni_ruc` integer(12) NOT NULL,
  `nombre` TEXT NULL,
  `direccion` TEXT NOT NULL,
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `venta` */
DROP TABLE IF EXISTS `venta`;
CREATE TABLE `venta`(
  `id_venta` INTEGER(6) NOT NULL AUTO_INCREMENT,
  `id_cliente` INTEGER(6) NOT NULL,
  `tipo_comprobante` enum('boleta','factura') NOT NULL DEFAULT 'boleta',
  `correlativo` integer(4) NOT NULL,
  `serie` integer(6) NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT current_timestamp(),
  `fecha_mod` DATETIME NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tipo_pago` enum('efectivo','yape') NOT NULL DEFAULT 'efectivo',
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_venta`),
  FOREIGN KEY (`id_cliente`) REFERENCES `cliente`(`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `detalle_venta` */
DROP TABLE IF EXISTS `detalle_venta`;

CREATE TABLE `detalle_venta`(
  `id_venta` INTEGER  NOT NULL,
  `id_producto` SMALLINT NOT NULL,
  `cantidad` integer(5) NOT NULL,
  `costo_unitario` numeric(9,4) NOT NULL,
  `comentario` TINYTEXT DEFAULT '',
  FOREIGN KEY (`id_venta`) REFERENCES `venta`(`id_venta`),
  FOREIGN KEY (`id_producto`) REFERENCES `producto`(`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `caja` */
DROP TABLE IF EXISTS `caja`;

CREATE TABLE `caja`(
  `id_caja` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `saldo` numeric(9,4),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_caja`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `detalle_caja` */
DROP TABLE IF EXISTS `detalle_caja`;
CREATE TABLE `detalle_caja`(
  `id_caja` TINYINT UNSIGNED NOT NULL,
  `id_detalle` SMALLINT NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT current_timestamp(),
  `saldo_anterior` numeric(9,4) NOT NULL,
  `tipo_mov` enum('venta','compra','gasto','ingreso') NOT NULL DEFAULT 'venta',
  `comentario` TINYTEXT DEFAULT '',
  FOREIGN KEY (`id_caja`) REFERENCES `caja`(`id_caja`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `logs` */
DROP TABLE IF EXISTS `logs`;

CREATE TABLE `logs`(
  `id_registro` INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(32) NOT NULL,
  `saldo` numeric(9,4),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_registro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `country`;

CREATE TABLE `country` (
  `country_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `country` varchar(50) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `coment` varchar(255) DEFAULT '',
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

/*Data for the table `country` */

LOCK TABLES `country` WRITE;

insert  into `country`(`country_id`,`country`,`last_update`,`coment`) values 
(1,'Afghanistan22','2023-05-07 15:06:30',''),
(2,'Algeria','2006-02-15 04:44:00',''),
(3,'American Samoa','2006-02-15 04:44:00',''),
(4,'Angola','2006-02-15 04:44:00',''),
(5,'Anguilla','2006-02-15 04:44:00',''),
(6,'Argentina','2006-02-15 04:44:00',''),
(7,'Armenia','2006-02-15 04:44:00',''),
(8,'Australia','2006-02-15 04:44:00',''),
(9,'Austria','2006-02-15 04:44:00',''),
(10,'Azerbaijan','2006-02-15 04:44:00',''),
(11,'Bahrain','2006-02-15 04:44:00',''),
(12,'Bangladesh','2006-02-15 04:44:00',''),
(13,'Belarus','2006-02-15 04:44:00',''),
(14,'Bolivia','2006-02-15 04:44:00',''),
(15,'Brazil','2006-02-15 04:44:00',''),
(16,'Brunei','2006-02-15 04:44:00',''),
(17,'Bulgaria','2006-02-15 04:44:00',''),
(18,'Cambodia','2006-02-15 04:44:00',''),
(19,'Afghanistan22','2023-05-07 15:15:57',''),
(20,'Canada','2006-02-15 04:44:00',''),
(21,'Chad','2006-02-15 04:44:00',''),
(22,'Chile','2006-02-15 04:44:00',''),
(23,'China','2006-02-15 04:44:00',''),
(24,'Colombia','2006-02-15 04:44:00',''),
(25,'Congo, The Democratic Republic of the','2006-02-15 04:44:00',''),
(26,'Czech Republic','2006-02-15 04:44:00',''),
(27,'Dominican Republic','2006-02-15 04:44:00',''),
(28,'Ecuador','2006-02-15 04:44:00',''),
(29,'Egypt','2006-02-15 04:44:00',''),
(30,'Estonia','2006-02-15 04:44:00',''),
(31,'Ethiopia','2006-02-15 04:44:00',''),
(32,'Faroe Islands','2006-02-15 04:44:00',''),
(33,'Finland','2006-02-15 04:44:00',''),
(34,'France','2006-02-15 04:44:00',''),
(35,'French Guiana','2006-02-15 04:44:00',''),
(36,'French Polynesia','2006-02-15 04:44:00',''),
(37,'Gambia','2006-02-15 04:44:00',''),
(38,'Germany','2006-02-15 04:44:00',''),
(39,'Greece','2006-02-15 04:44:00',''),
(40,'Greenland','2006-02-15 04:44:00',''),
(41,'Holy See (Vatican City State)','2006-02-15 04:44:00',''),
(42,'Hong Kong','2006-02-15 04:44:00',''),
(43,'Hungary','2006-02-15 04:44:00',''),
(44,'India','2006-02-15 04:44:00',''),
(45,'Indonesia','2006-02-15 04:44:00',''),
(46,'Iran','2006-02-15 04:44:00',''),
(47,'Iraq','2006-02-15 04:44:00',''),
(48,'Israel','2006-02-15 04:44:00',''),
(49,'Italy','2006-02-15 04:44:00',''),
(50,'Japan','2006-02-15 04:44:00',''),
(51,'Kazakstan','2006-02-15 04:44:00',''),
(52,'Kenya','2006-02-15 04:44:00',''),
(53,'Kuwait','2006-02-15 04:44:00',''),
(54,'Latvia','2006-02-15 04:44:00',''),
(55,'Liechtenstein','2006-02-15 04:44:00',''),
(56,'Lithuania','2006-02-15 04:44:00',''),
(57,'Madagascar','2006-02-15 04:44:00',''),
(58,'Malawi','2006-02-15 04:44:00',''),
(59,'Malaysia','2006-02-15 04:44:00',''),
(60,'Mexico','2006-02-15 04:44:00',''),
(61,'Moldova','2006-02-15 04:44:00',''),
(62,'Morocco','2006-02-15 04:44:00',''),
(63,'Mozambique','2006-02-15 04:44:00',''),
(64,'Myanmar','2006-02-15 04:44:00',''),
(65,'Nauru','2006-02-15 04:44:00',''),
(66,'Nepal','2006-02-15 04:44:00',''),
(67,'Netherlands','2006-02-15 04:44:00',''),
(68,'New Zealand','2006-02-15 04:44:00',''),
(69,'Nigeria','2006-02-15 04:44:00',''),
(70,'North Korea','2006-02-15 04:44:00',''),
(71,'Oman','2006-02-15 04:44:00',''),
(72,'Pakistan','2006-02-15 04:44:00',''),
(73,'Paraguay','2006-02-15 04:44:00',''),
(74,'Peru','2006-02-15 04:44:00',''),
(75,'Philippines','2006-02-15 04:44:00',''),
(76,'Poland','2006-02-15 04:44:00',''),
(77,'Puerto Rico','2006-02-15 04:44:00',''),
(78,'Romania','2006-02-15 04:44:00',''),
(79,'Runion','2006-02-15 04:44:00',''),
(80,'Russian Federation','2006-02-15 04:44:00',''),
(81,'Saint Vincent and the Grenadines','2006-02-15 04:44:00',''),
(82,'Saudi Arabia','2006-02-15 04:44:00',''),
(83,'Senegal','2006-02-15 04:44:00',''),
(84,'Slovakia','2006-02-15 04:44:00',''),
(85,'South Africa','2006-02-15 04:44:00',''),
(86,'South Korea','2006-02-15 04:44:00',''),
(87,'Spain','2006-02-15 04:44:00',''),
(88,'Sri Lanka','2006-02-15 04:44:00',''),
(89,'Sudan','2006-02-15 04:44:00',''),
(90,'Sweden','2006-02-15 04:44:00',''),
(91,'Switzerland','2006-02-15 04:44:00',''),
(92,'Taiwan','2006-02-15 04:44:00',''),
(93,'Tanzania','2006-02-15 04:44:00',''),
(94,'Thailand','2006-02-15 04:44:00',''),
(95,'Tonga','2006-02-15 04:44:00',''),
(96,'Tunisia','2006-02-15 04:44:00',''),
(97,'Turkey','2006-02-15 04:44:00',''),
(98,'Turkmenistan','2006-02-15 04:44:00',''),
(99,'Tuvalu','2006-02-15 04:44:00',''),
(100,'Ukraine','2006-02-15 04:44:00',''),
(101,'United Arab Emirates','2006-02-15 04:44:00',''),
(102,'United Kingdom','2006-02-15 04:44:00',''),
(103,'United States','2006-02-15 04:44:00',''),
(104,'Venezuela','2006-02-15 04:44:00',''),
(105,'Vietnam','2006-02-15 04:44:00',''),
(106,'Virgin Islands, U.S.','2006-02-15 04:44:00',''),
(107,'Yemen','2006-02-15 04:44:00',''),
(108,'Yugoslavia','2006-02-15 04:44:00',''),
(109,'Zambia','2006-02-15 04:44:00',''),
(110,'Afghanistan22','2023-05-07 15:32:09','pruebas'),
(111,'Afghanistan22','2023-05-07 15:32:27','pruebas'),
(112,'Afghanistan22','2023-05-07 15:32:50','pruebas'),
(113,'Afghanistan22','2023-05-07 15:33:58','pruebas'),
(114,'Afghanistan22','2023-05-07 15:34:11','pruebas'),
(115,'Afghanistan22','2023-05-07 15:37:07','pruebas'),
(116,'Afghanistan22','2023-05-07 15:38:34','pruebas');
