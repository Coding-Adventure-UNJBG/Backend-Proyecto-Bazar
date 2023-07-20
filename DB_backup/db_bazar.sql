DROP DATABASE IF EXISTS `db_bazar`;

CREATE DATABASE `db_bazar` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `db_bazar`;

DROP TABLE IF EXISTS `usuario`;

CREATE TABLE `usuario` (
    `id_usuario` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `cuenta` VARCHAR(16) NOT NULL UNIQUE,
    `password` VARCHAR(32) NOT NULL,
    `dni` INTEGER(8) NOT NULL UNIQUE,
    `nombres` VARCHAR(64) NOT NULL,
    `telefono` VARCHAR(13) NULL,
    `direccion` TINYTEXT NULL DEFAULT '',
    `estado` enum('HABILITADO', 'DESHABILITADO') NOT NULL DEFAULT 'DESHABILITADO',
    `fecha_registro` DATETIME NOT NULL DEFAULT current_timestamp(),
    `fecha_mod` DATETIME NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `comentario` TINYTEXT DEFAULT '',
    PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `rol`;

CREATE TABLE `rol` (
    `id_rol` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `tipo` VARCHAR(16) NOT NULL,
    `permiso_defecto` JSON NOT NULL,
    `comentario` TINYTEXT DEFAULT '',
    PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `detalle_rol`;

CREATE TABLE `detalle_rol` (
    `id_usuario` SMALLINT UNSIGNED NOT NULL,
    `id_rol` TINYINT UNSIGNED NOT NULL,
    `permiso` JSON NOT NULL,
    `is_custom` BOOLEAN DEFAULT 0,
    `comentario` TINYTEXT DEFAULT '',
    PRIMARY KEY (`id_usuario`, `id_rol`),
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario`(`id_usuario`),
    FOREIGN KEY (`id_rol`) REFERENCES `rol`(`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `proveedor`;

CREATE TABLE `proveedor` (
    `id_proveedor` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(32) NOT NULL,
    `ruc` VARCHAR(32) NULL UNIQUE,
    `razon_social` TINYTEXT NULL,
    `direccion` TINYTEXT NULL,
    `estado` enum('HABILITADO', 'DESHABILITADO') NOT NULL DEFAULT 'HABILITADO',
    `fecha_registro` DATETIME NOT NULL DEFAULT current_timestamp(),
    `comentario` TINYTEXT NULL DEFAULT '',
    PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `producto`;

CREATE TABLE `producto` (
    `id_producto` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(64) NOT NULL,
    `marca` VARCHAR(32) NOT NULL,
    `unidad` VARCHAR(32) NOT NULL,
    `estado` enum('DISPONIBLE', 'AGOTADO') NOT NULL DEFAULT 'AGOTADO',
    `stock` INTEGER(5) NOT NULL DEFAULT 0,
    `foto` VARCHAR(70) NOT NULL DEFAULT '',
    `fecha` DATETIME NOT NULL DEFAULT current_timestamp(),
    `comentario` TINYTEXT DEFAULT '',
    PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `precio_producto`;

CREATE TABLE `precio_producto` (
    `id_producto` SMALLINT UNSIGNED NOT NULL,
    `fechaInicio` DATETIME NOT NULL DEFAULT current_timestamp(),
    `fechaFinal` DATETIME NOT NULL DEFAULT current_timestamp(),
    `precio_venta` DECIMAL(9,4) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`fechaInicio`),
    FOREIGN KEY (`id_producto`) REFERENCES `producto`(`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `compra`;

CREATE TABLE `compra` (
    `id_compra` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_proveedor` SMALLINT UNSIGNED NOT NULL,
    `id_producto` SMALLINT UNSIGNED NOT NULL,
    `descripcion` TEXT NULL,
    `cantidad` INTEGER(5) UNSIGNED NOT NULL,
    `precio_compra` DECIMAL(9,4) UNSIGNED NOT NULL,
    `importe_total` DECIMAL(9,4) UNSIGNED NOT NULL,
    `costo_operacion` DECIMAL(9,4) UNSIGNED NOT NULL DEFAULT 0,
    `fecha` DATETIME NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id_compra`),
    FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor`(`id_proveedor`),
    FOREIGN KEY (`id_producto`) REFERENCES `producto`(`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `venta`;

CREATE TABLE `venta` (
    `id_venta` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `serie` VARCHAR(4) NOT NULL,
    `correlativo` VARCHAR(6) NOT NULL UNIQUE,
    `tipo_pago` enum('EFECTIVO', 'YAPE') NOT NULL DEFAULT 'EFECTIVO',
    `total_dinero` DECIMAL(9,4) UNSIGNED NOT NULL,
    `comentario` TINYTEXT NULL DEFAULT '',
    `fecha` DATETIME NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id_venta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `detalle_venta`;

CREATE TABLE `detalle_venta` (
    `id_venta` SMALLINT UNSIGNED NOT NULL,
    `id_producto` SMALLINT UNSIGNED NOT NULL,
    `cantidad` INTEGER(5) UNSIGNED NOT NULL,
    `costo_unitario` DECIMAL(9,4) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_venta`) REFERENCES `venta`(`id_venta`),
    FOREIGN KEY (`id_producto`) REFERENCES `producto`(`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `caja`;

CREATE TABLE `caja` (
    `id_caja` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `saldo` DECIMAL(9,4),
    `comentario` TINYTEXT NULL DEFAULT '',
    PRIMARY KEY (`id_caja`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `detalle_caja`;

CREATE TABLE `detalle_caja` (
    `id_caja` TINYINT UNSIGNED NOT NULL,
    `id_detalle` SMALLINT NOT NULL,
    `fecha` DATETIME NOT NULL DEFAULT current_timestamp(),
    `saldo_anterior` DECIMAL(9,4) NOT NULL,
    `tipo_mov` enum('VENTA', 'COMPRA', 'GASTO', 'INGRESO') NOT NULL DEFAULT 'VENTA',
    `comentario` TINYTEXT DEFAULT '',
    PRIMARY KEY (`id_detalle`),
    FOREIGN KEY (`id_caja`) REFERENCES `caja`(`id_caja`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `logs`;

CREATE TABLE `logs` (
    `id_registro` INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre_usuario` VARCHAR(32) NOT NULL,
    `saldo` DECIMAL(9,4),
    `comentario` TINYTEXT DEFAULT '',
    PRIMARY KEY (`id_registro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* DATOS PARA LA TABLA USUARIO */
LOCK TABLES `usuario` WRITE;
INSERT INTO usuario(id_usuario,cuenta,password,dni,nombres,estado,comentario)
VALUES
(1,'ADMIN','123','11','11','1','Administrador del sistema'),
(2,'INVENTARIO','123','22','22','1','Responsable de almacen'),
(3,'VENDEDOR','123','33','33','1','Vendedor de la empresa'),
(4,'REPORTE','123','44','44','1','Empleado a prueba');
UNLOCK TABLES;

/* DATOS PARA LA TABLA ROL */
LOCK TABLES `rol` WRITE;
INSERT INTO rol(id_rol,tipo,permiso_defecto,comentario)
VALUES
(1,'admin','{"productos":true,"entradas":true,"ventas":true,"usuarios":true,"reportes":true}','nivel de administrador en el sistemas'),
(2,'inventario','{"productos":true,"entradas":true,"ventas":false,"usuarios":false,"reportes":true}','nivel del encargado del almacen e inventario en el sistemas'),
(3,'vendedor','{"productos":false,"entradas":false,"ventas":true,"usuarios":false,"reportes":true}','nivel de vendedor en el sistemas'),
(4,'reporte','{"productos":false,"entradas":false,"ventas":false,"usuarios":false,"reportes":true}','nivel de empleado a prueba');
UNLOCK TABLES;

/* DATOS PARA LA TABLA DETALLE_ROL */
LOCK TABLES `detalle_rol` WRITE;
INSERT INTO detalle_rol(id_usuario,id_rol,permiso,is_custom)
VALUES
(1,1,'{"productos":true,"entradas":true,"ventas":true,"usuarios":true,"reportes":true}',0),
(2,2,'{"productos":true,"entradas":true,"ventas":false,"usuarios":false,"reportes":true}',0),
(3,3,'{"productos":false,"entradas":false,"ventas":true,"usuarios":false,"reportes":true}',0),
(4,4,'{"productos":false,"entradas":false,"ventas":false,"usuarios":false,"reportes":true}',0);
UNLOCK TABLES;

/* DATOS PARA LA TABLA PRODUCTO */
LOCK TABLES `producto` WRITE;
INSERT INTO `producto` (`id_producto`, `nombre`, `marca`, `unidad`, `estado`, `stock`, `foto`, `fecha`, `comentario`) 
VALUES
(1, 'PAÑOS ABSORVENTES', 'SAPOLIO', '20 UNIDA', 'DISPONIBLE', 5, '', '2023-07-10 21:23:44', ''),
(2, 'PASTA  DENTAL', 'DENTO', '75 ML', 'DISPONIBLE', 12, '', '2023-07-10 21:23:44', ''),
(3, 'JABON ANTIBACTERIAL', 'AVAL', '400 ML', 'DISPONIBLE', 8, '', '2023-07-10 21:23:44', ''),
(4, 'JABON ANTIBACTERIAL', 'AVAL', 'LITRO', 'AGOTADO', 0, '', '2023-07-10 21:23:44', ''),
(5, 'JABON  BALLERINA RESPUESTO', 'BALLERINA', '900 ML', 'AGOTADO', 0, '', '2023-07-10 21:23:44', ''),
(6, 'DESINFECTANTE DAC5 CONCENTRADO', 'DARYZA', 'GALON 5 LITROS', 'AGOTADO', 0, '', '2023-07-10 02:45:11', ''),
(7, 'DESINFECTANTE DAC5 CONCENTRADO', 'DARYZA', 'LITRO', 'DISPONIBLE', 6, '', '2023-07-10 02:45:35', '');
UNLOCK TABLES;

/* DATOS PARA LA TABLA PROVEEDORES */
LOCK TABLES `proveedor` WRITE;
INSERT INTO `proveedor` (`id_proveedor`, `nombre`, `ruc`, `razon_social`, `direccion`, `estado`, `fecha_registro`, `comentario`) 
VALUES
(1, 'IMPORT EXPORT GINSA EIRL', '20519893259', 'IMPORT EXPORT GINSA EMPRESA INDIVIDUAL DE RESPONSABILIDAD LIMITADA', 'MZA. D LOTE. 11 ASOC.VIV.LA FRONTERA (ESPALDAS DEL MERCADILLO BOLOGNESI) TACNA - TACNA - TACNA', 'HABILITADO', '2023-07-10 21:23:44', ''),
(2, 'CMS DEL SUR S.A.C.', '20558614120', 'CMS DEL SUR S.A.C.', 'MZA. E LOTE. 11B Z.I. PARQUE INDUSTRIAL (A MEDIA CUADRA DE FERRETERIA HELEO) TACNA - TACNA - TACNA', 'HABILITADO', '2023-07-10 21:23:44', ''),
(3, 'DIMEXA', '20100220700', 'DIMEXA S.A.', 'MZA. B LOTE. 12 URB. SANTA MARIA AREQUIPA - AREQUIPA - PAUCARPATA', 'HABILITADO', '2023-07-10 21:23:44', ''),
(4, 'POLVOS ROSADOS', '', '', 'AV. GUSTAVO PINTO S/N ALTO DE LA ALIANZA, GUSTAVO PINTO, TACNA', 'HABILITADO', '2023-07-10 21:23:44', ''),
(5, 'DARYZA', '20144109458', 'DARYZA S.A.C.', 'Nro. . Granja 1 (Altura Km 30 Panamericana Sur)', 'HABILITADO', '2023-07-10 02:28:26', ''),
(6, 'SANIMAX SOLUCIONES S.A.C.', '20603863110', 'SANIMAX SOLUCIONES S.A.C.', 'Cal. Teniente Enrique Delucchi Nro. 222 Dpto. Ss04, Lima, Perú', 'HABILITADO', '2023-07-10 02:30:02', '');
UNLOCK TABLES;

/* DATOS PARA LA TABLA COMPRA */
LOCK TABLES `compra` WRITE;
INSERT INTO `compra` (`id_compra`, `id_proveedor`, `id_producto`, `descripcion`, `cantidad`, `precio_compra`, `importe_total`, `costo_operacion`, `fecha`) VALUES
(1, 1, 1, '', 10, 10.7500, 107.5000, 0.0000, '2023-07-10 10:51:30'),
(2, 2, 2, '', 7, 2.0000, 14.0000, 0.0000, '2023-07-11 10:53:47'),
(3, 1, 3, '', 11, 4.2000, 46.2000, 0.0000, '2023-07-11 14:54:45'),
(4, 5, 7, '', 7, 10.1700, 71.1900, 1.0000, '2023-07-15 16:58:28'),
(5, 2, 2, '', 10, 2.0000, 20.0000, 0.0000, '2023-07-16 12:10:53'),
(6, 1, 3, '', 5, 4.2000, 21.0000, 0.0000, '2023-07-18 13:12:26'),
(7, 5, 7, '', 6, 10.1700, 61.0200, 1.0000, '2023-07-19 11:14:28');
UNLOCK TABLES;

/* DATOS PARA LA TABLA PRECIO PRODUCTO */
LOCK TABLES `precio_producto` WRITE;
INSERT INTO `precio_producto` (`id_producto`, `fechaInicio`, `fechaFinal`, `precio_venta`) VALUES
(1, '2023-07-10 02:51:30', '2023-07-10 02:51:30', 13.9750),
(2, '2023-07-11 02:53:47', '2023-07-11 02:53:47', 2.6000),
(3, '2023-07-11 02:54:45', '2023-07-11 02:54:45', 5.4600),
(7, '2023-07-15 02:58:28', '2023-07-15 02:58:28', 14.5210);
UNLOCK TABLES;

/* DATOS PARA LA TABLA VENTA */
LOCK TABLES `venta` WRITE;
INSERT INTO `venta` (`id_venta`, `serie`, `correlativo`, `tipo_pago`, `total_dinero`, `comentario`, `fecha`) VALUES
(1, '001', '000246', 'EFECTIVO', 2.5000, '', '2023-07-11 11:30:30'),
(2, '001', '000247', 'EFECTIVO', 8.0600, '', '2023-07-13 14:01:40'),
(3, '001', '000248', 'EFECTIVO', 27.9600, '', '2023-07-13 15:02:19'),
(4, '001', '000249', 'EFECTIVO', 114.4200, '', '2023-07-14 11:04:56'),
(5, '001', '000250', 'EFECTIVO', 36.5600, '', '2023-07-17 12:06:01'),
(6, '001', '000251', 'EFECTIVO', 33.4200, '', '2023-07-17 15:06:53'),
(7, '001', '000252', 'YAPE', 7.8000, '', '2023-07-18 14:08:57');
UNLOCK TABLES;

/* DATOS PARA LA TABLA DETALLE VENTA */
LOCK TABLES `detalle_venta` WRITE;
INSERT INTO `detalle_venta` (`id_venta`, `id_producto`, `cantidad`, `costo_unitario`) VALUES
(1, 1, 1, 2.5000),
(2, 2, 1, 2.6000),
(2, 3, 1, 5.4600),
(3, 1, 2, 13.9800),
(4, 3, 5, 5.4600),
(4, 7, 6, 14.5200),
(5, 2, 1, 2.6000),
(5, 1, 1, 13.9800),
(5, 3, 1, 5.4600),
(5, 7, 1, 14.5200),
(6, 1, 2, 13.9800),
(6, 3, 1, 5.4600),
(7, 2, 3, 2.6000);
UNLOCK TABLES;
