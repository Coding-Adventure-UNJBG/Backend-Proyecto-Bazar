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
    `ruc` INTEGER(11) NULL UNIQUE,
    `razon_social` TINYTEXT NULL,
    `direccion` TINYTEXT NULL,
    `estado` enum('HABILITADO', 'DESHABILITADO') NOT NULL DEFAULT 'DESHABILITADO',
    `fecha_registro` DATETIME NOT NULL DEFAULT current_timestamp(),
    `comentario` TINYTEXT NULL DEFAULT '',
    PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `producto`;

CREATE TABLE `producto` (
    `id_producto` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(32) NOT NULL,
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
    `precio_sugerido` DECIMAL(9,4) UNSIGNED NOT NULL DEFAULT 0,
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
    `costo_operacion` DECIMAL(9,4) UNSIGNED NOT NULL,
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
    `fecha_mod` DATETIME NOT NULL DEFAULT current_timestamp(),
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
