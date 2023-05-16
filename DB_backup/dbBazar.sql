
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
DROP TABLE IF EXISTS `compra`;

CREATE TABLE `compra`(
  `id_compra` INTEGER NOT NULL AUTO_INCREMENT,
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
DROP TABLE IF EXISTS `producto`;

CREATE TABLE `producto`(
  `id_producto` SMALLINT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(32) NOT NULL,
  `medida` VARCHAR(32) NOT NULL,
  `marca` VARCHAR(32) NOT NULL,
  `tipo_unidad` enum('paquete','unidad') NOT NULL DEFAULT 'unidad',
  `cantidad_unidad` TINYINT NULL,
  `precio_sugerido` numeric(9,4) NOT NULL,
  `estado` enum('disponible','no-disponible') NOT NULL DEFAULT 'no-disponible',
  `stock` SMALLINT NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT current_timestamp(),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


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
  `id_caja` INTEGER  NOT NULL,
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
  PRIMARY KEY (`id_caja`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

