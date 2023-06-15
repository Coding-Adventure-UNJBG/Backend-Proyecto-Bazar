
DROP DATABASE IF EXISTS `db_bazar`;

CREATE DATABASE `db_bazar` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `db_bazar`;

/*Table structure for table `detalle_usuario` */
DROP TABLE IF EXISTS `detalle_usuario`;

DROP TABLE IF EXISTS `usuario`;

CREATE TABLE `usuario` (
  `id_usuario` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cuenta` VARCHAR(16) NOT NULL UNIQUE,
  `password` VARCHAR(32) NOT NULL,
  `dni` integer(10) NOT NULL UNIQUE,
  `nombres` VARCHAR(64) NOT NULL,
  `telefono` VARCHAR(13) NULL,
  `direccion` TINYTEXT NULL DEFAULT '',
  `estado` enum('habilitado','deshabilitado') NOT NULL DEFAULT 'deshabilitado',
  `fecha_registro` DATETIME NOT NULL DEFAULT current_timestamp(),
  `fecha_mod` DATETIME NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY(`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `usuario` */
LOCK TABLES `usuario` WRITE;
INSERT INTO usuario(id_usuario,cuenta,password,dni,nombres,estado,comentario)
VALUES
(1,'ADMIN','123','11','11','1','Administrador del sistema'),
(2,'INVENTARIO','123','22','22','1','Responsable de almacen'),
(3,'VENDEDOR','123','33','33','1','Vendedor de la empresa'),
(4,'REPORTE','123','44','44','1','Empleado a prueba');

UNLOCK TABLES;

/*Table structure for table `rol` */
DROP TABLE IF EXISTS `rol`;

CREATE TABLE `rol`(
  `id_rol` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(16) NOT NULL,
  `permiso_defecto` JSON NOT NULL,
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `rol` */
LOCK TABLES `rol` WRITE;
INSERT INTO rol(id_rol,tipo,permiso_defecto,comentario)
VALUES
(1,'admin','{"productos":true,"entradas":true,"ventas":true,"usuarios":true,"reportes":true}','nivel de administrador en el sistemas'),
(2,'inventario','{"productos":true,"entradas":true,"ventas":false,"usuarios":false,"reportes":true}','nivel del encargado del almacen e inventario en el sistemas'),
(3,'vendedor','{"productos":false,"entradas":false,"ventas":true,"usuarios":false,"reportes":true}','nivel de vendedor en el sistemas'),
(4,'reporte','{"productos":false,"entradas":false,"ventas":false,"usuarios":false,"reportes":true}','nivel de empleado a prueba');

UNLOCK TABLES;
/*Table structure for table `detalle_rol` */
DROP TABLE IF EXISTS `detalle_rol`;

CREATE TABLE `detalle_rol`(
  `id_usuario` SMALLINT UNSIGNED NOT NULL,
  `id_rol` TINYINT UNSIGNED NOT NULL,
  `permiso` JSON NOT NULL,
  `is_custom` BOOLEAN DEFAULT 0,
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY(`id_usuario`, `id_rol`),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuario`(`id_usuario`),
  FOREIGN KEY (`id_rol`) REFERENCES `rol`(`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `rol` */
LOCK TABLES `detalle_rol` WRITE;
INSERT INTO detalle_rol(id_usuario,id_rol,permiso,is_custom)
VALUES
(1,1,'{"productos":true,"entradas":true,"ventas":true,"usuarios":true,"reportes":true}',0),
(2,2,'{"productos":true,"entradas":true,"ventas":false,"usuarios":false,"reportes":true}',0),
(3,3,'{"productos":false,"entradas":false,"ventas":true,"usuarios":false,"reportes":true}',0),
(4,4,'{"productos":false,"entradas":false,"ventas":false,"usuarios":false,"reportes":true}',0);

UNLOCK TABLES;

/*Table structure for table `proveedor` */
DROP TABLE IF EXISTS `proveedor`;

CREATE TABLE `proveedor`(
  `id_proveedor` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(32) NOT NULL,
  `ruc` VARCHAR(32) NULL UNIQUE,
  `razon_social` TINYTEXT NOT NULL,
  `direccion` TINYTEXT NOT NULL,
  `estado` enum('habilitado','deshabilitado') NOT NULL DEFAULT 'deshabilitado',
  `fecha_registro` DATETIME NOT NULL DEFAULT current_timestamp(),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `compra` */
DROP TABLE IF EXISTS `compra`;

CREATE TABLE `compra`(
  `id_compra` INTEGER NOT NULL AUTO_INCREMENT,
  `id_proveedor` SMALLINT UNSIGNED NOT NULL,
  `numero_comprobante` VARCHAR(16) NOT NULL UNIQUE,
  `descripcion` TEXT NULL,
  `importe_total` numeric(9,4) UNSIGNED NOT NULL,
  `costo_flete` numeric(9,4) UNSIGNED NOT NULL,
  `comision_banco` numeric(9,4) UNSIGNED NOT NULL,
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
  `cantidad_unidad` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `precio_sugerido` numeric(9,4) UNSIGNED NULL DEFAULT 0,
  `estado` enum('disponible','no-disponible') NOT NULL DEFAULT 'no-disponible',
  `stock` SMALLINT NOT NULL DEFAULT 0,
  `foto` VARCHAR(70) NOT NULL DEFAULT '',
  `fecha` DATETIME NULL DEFAULT current_timestamp(),
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `producto` */
LOCK TABLES `producto` WRITE;
INSERT INTO producto(nombre,medida,marca,stock)
VALUES
('detergente','800 gr','amor',0),
('detergente','900 gr','orion',0),
('detergente','15 kg','doffi',0);

UNLOCK TABLES;

/*Table structure for table `detalle_compra` */
DROP TABLE IF EXISTS `detalle_compra`;

CREATE TABLE `detalle_compra`(
  `id_compra` INTEGER  NOT NULL,
  `id_producto` SMALLINT NOT NULL,
  `cantidad` integer(5) UNSIGNED NOT NULL,
  `precio_bruto` numeric(9,4) UNSIGNED NOT NULL,
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_producto`,`id_compra`),
  FOREIGN KEY (`id_producto`) REFERENCES `producto`(`id_producto`),
  FOREIGN KEY (`id_compra`) REFERENCES `compra`(`id_compra`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `cliente` */
DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente`(
  `id_cliente` INTEGER(6) NOT NULL AUTO_INCREMENT,
  `dni_ruc` integer(12) NOT NULL,
  `nombre` TEXT NOT NULL,
  `direccion` TEXT NULL,
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
  `cantidad` integer(5) UNSIGNED NOT NULL,
  `costo_unitario` numeric(9,4) UNSIGNED NOT NULL,
  `comentario` TINYTEXT DEFAULT '',
  PRIMARY KEY (`id_venta`,`id_producto`),
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
  PRIMARY KEY (`id_detalle`),
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

/*Table structure for table `precio_producto` */
DROP TABLE IF EXISTS `precio_producto`;
CREATE TABLE `precio_producto` (
  `id_producto` smallint(6) NOT NULL,
  `fechaInicio` timestamp NOT NULL DEFAULT current_timestamp(),
  `fechaFinal` timestamp NOT NULL DEFAULT current_timestamp(),
  `precio_sugerido` decimal(9,4) UNSIGNED DEFAULT 0,
  PRIMARY KEY (`fechaInicio`,`id_producto`),
  FOREIGN KEY (`id_producto`) REFERENCES `producto`(`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

