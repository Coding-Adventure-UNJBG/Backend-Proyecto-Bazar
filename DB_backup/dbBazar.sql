
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
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `compra` */
DROP TABLE IF EXISTS `proveedor`;

CREATE TABLE `proveedor`(
  `id_compra` INTEGER  AUTO_INCREMENT,
  `id_proveedor` SMALLINT NULL,
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
DROP TABLE IF EXISTS `proveedor`;

CREATE TABLE `producto`(
  `id_producto` INTEGER  AUTO_INCREMENT,
  `nombre` VARCHAR(32) NOT NULL,
  `medida` VARCHAR(32) NOT NULL,
  `marca` VARCHAR(32) NOT NULL,
  `estado` enum('activado','desactivado') NOT NULL DEFAULT 'desactivado',
  `descripcion` TEXT NULL,
  `importe_total` numeric(9,4) NOT NULL,
  `costo_flete` numeric(9,4) NOT NULL,
  `comision_banco` numeric(9,4) NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT current_timestamp(),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_compra`),
  FOREIGN key (`id_proveedor`) REFERENCES `proveedor`(`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/*Table structure for table `xxxx` */
/*Table structure for table `xxxx` */
/*Table structure for table `xxxx` */
/*Table structure for table `xxxx` */


