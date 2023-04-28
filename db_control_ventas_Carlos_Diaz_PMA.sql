/* 	
Curso: Taller
Catedrático: Jorge Luis Pérez Canto

	Nombre alumno:	Carlos Eduardo
	Carné:	2018312
  Código técnico: IN5BM
  Grupo:1
	Fecha: 16/02/2022
*/


-- -----------------------------------------------------
-- Nombre de la base de datos: db_control_ventas-----------------------------------------------------------------------
-- -----------------------------------------------------
DROP DATABASE IF EXISTS db_control_ventas_carlos_diaz;
CREATE DATABASE IF NOT EXISTS db_control_ventas_carlos_diaz;
USE db_control_ventas_carlos_diaz;


-- -----------------------------------------------------
-- Tabla: productos-----------------------------------------------------------------------
-- -----------------------------------------------------
DROP TABLE IF EXISTS productos;

CREATE TABLE IF NOT EXISTS productos (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  existencia INT NULL DEFAULT '0',
  precio_unitario DECIMAL(10,2) NULL DEFAULT '0.00',
  precio_docena DECIMAL(10,2) NULL DEFAULT '0.00',
  precio_mayor DECIMAL(10,2) NULL DEFAULT '0.00',
  PRIMARY KEY (id)
);


-- -----------------------------------------------------
-- Tabla: compras-----------------------------------------------------------------------
-- -----------------------------------------------------
DROP TABLE IF EXISTS compras;

CREATE TABLE IF NOT EXISTS compras (
  id INT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  PRIMARY KEY (id)
);


-- -----------------------------------------------------
-- Tabla: ventas-----------------------------------------------------------------------
-- -----------------------------------------------------
DROP TABLE IF EXISTS ventas;

CREATE TABLE IF NOT EXISTS ventas (
  id INT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  PRIMARY KEY (id)
);


-- -----------------------------------------------------
-- Tabla: detalle_compras-----------------------------------------------------------------------
-- -----------------------------------------------------
DROP TABLE IF EXISTS detalle_compras;

CREATE TABLE  detalle_compras (
  id INT NOT NULL AUTO_INCREMENT,
  compra_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL,
  total DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (id),
  CONSTRAINT fk_productos_detalle_compras
    FOREIGN KEY (producto_id)
    REFERENCES productos (id),
  CONSTRAINT fk_compras_detalle_compras
    FOREIGN KEY (compra_id)
    REFERENCES compras (id)
);


-- -----------------------------------------------------
-- Tabla: detalle_ventas-----------------------------------------------------------------------
-- -----------------------------------------------------
DROP TABLE IF EXISTS detalle_ventas;

CREATE TABLE IF NOT EXISTS detalle_ventas (
  id INT NOT NULL AUTO_INCREMENT,
  venta_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_productos_detalle_ventas
    FOREIGN KEY (producto_id)
    REFERENCES productos (id),
  CONSTRAINT fk_ventas_detalle_ventas
    FOREIGN KEY (venta_id)
    REFERENCES ventas (id)
);



/*
	INDICACIONES GENERALES:
  Leer el documento PDF que el profesor le proporcionó
  y realizar lo que ahí se le pide.    
*/


-- SERIE I:

-- -----------------------------------------------------
-- 1. Procedimiento almacenado para insertar ventas-----------------------------------------------------------------------
-- -----------------------------------------------------
DELIMITER %%

CREATE PROCEDURE  sp_ventas_create(IN _fecha DATE)
BEGIN 
	INSERT INTO ventas(fecha) VALUES 
    (_fecha);
END%%
DELIMITER ;


-- -----------------------------------------------------
-- 2. Procedimiento almacenado para insertar compras-----------------------------------------------------------------------
-- -----------------------------------------------------
DELIMITER %%
DROP PROCEDURE IF EXISTS sp_compras_create;
CREATE PROCEDURE sp_compras_create(IN _fecha DATE)
BEGIN 
	INSERT INTO compras(fecha) VALUES 
    (_fecha);
END%%
DELIMITER ;
-- -------------------------------------------------------------
-- 3. Procedimiento almacenado para insertar detalles de compras -----------------------------------------------------------
-- -------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_detalle_compras_create $$
CREATE PROCEDURE sp_detalle_compras_create(IN _compra_id INT,IN _producto_id int,IN _cantidad INT, IN _total INT)
BEGIN 
	INSERT INTO detalle_compras (compra_id,producto_id,contidad,total) VALUES 
    (_compra_id,producto_id,_contidad,_total);
END $$
DELIMITER ;
-- -----------------------------------------------------
-- 4. Procedimiento almacenado para insertar productos-----------------------------------------------------------------------
-- -----------------------------------------------------
DELIMITER %%
DROP PROCEDURE IF EXISTS sp_productos_create %%
CREATE PROCEDURE sp_productos_create(IN _nombre VARCHAR (50))
BEGIN 
	INSERT INTO productos (nombre)VALUES 
    (_nombre);
END %%
DELIMITER ;


-- --------------------------------------------------------
-- 5. Procedimiento almacenado para insertar detalle ventas------------------------------------------------------------------
-- --------------------------------------------------------
DELIMITER %%
DROP PROCEDURE IF EXISTS sp_detalle_ventas_create %%
CREATE PROCEDURE sp_detalle_ventas_create (IN _venta_id INT,IN _producto_id INT,IN _cantidad INT) 
BEGIN 
	INSERT INTO detalle_ventas(venta_id,producto_id,cantidad) VALUES 
    (_venta_id,_producto_id,_cantidad);
END %%
DELIMITER ; 

-- SERIE II:
-- Las instrucciones específicas se encuentran en el documento PDF proporcionado.


-- -----------------------------------------------------
-- 1. Trigger para actualizar precios de productos-------------------------------------------------------------------------
-- -----------------------------------------------------
DELIMITER $$
DROP TRIGGER IF EXISTS tr_detalle_compras_after_insert $$
CREATE TRIGGER tr_detalle_compras_after_insert
AFTER INSERT
ON detalle_compras
FOR EACH ROW
BEGIN
	UPDATE 
    productos 
    SET 
    precio_unitario = (new.total/new.cantidad) + ((NEW.total/NEW.cantidad)*0.35),
	precio_docena = (new.total/new.cantidad)+ ((NEW.total/NEW.cantidad)*0.25),
	productos.precio_mayor = (new.total/new.cantidad)+ ((NEW.total/NEW.cantidad)*0.15 )
    where
		productos.id = new.producto_id;
END $$
DELIMITER ;
 

-- -------------------------------------------------------------------------
-- 2. Trigger para actualizar existencias (agregando la cantidad comprada).------------------------------------------------
-- -------------------------------------------------------------------------
DELIMITER $$
DROP TRIGGER if exists tr_detalle_compras_after_insert $$
CREATE TRIGGER tr_detalle_compras_after_insert 
AFTER INSERT 
ON detalle_compras
FOR EACH ROW
BEGIN 
	UPDATE productos SET existencia= existencia + new.cantidad 
    WHERE id=new.producto_id ; 
END $$
DELIMITER ; 



-- -------------------------------------------------------------------------
-- 3. Trigger para actualizar existencias (restando la cantidad vendida)--------------------------------------------------
-- -------------------------------------------------------------------------
DELIMITER $$
DROP TRIGGER if exists tr_detalle_ventas_after_insert $$
CREATE TRIGGER tr_detalle_ventas_after_insert 
AFTER INSERT 
ON detalle_ventas
FOR EACH ROW
BEGIN 
	UPDATE productos SET existencia= existencia - new.cantidad 
    WHERE id=new.producto_id ; 
END $$
DELIMITER ; 




-- -------------------------------------------------------------------------
-- Al finalizar se ejecutar lo siguiente:---------------------------------------------------------------------------------
-- -------------------------------------------------------------------------

call sp_ventas_create(now());
call sp_ventas_create('2019-12-01');
call sp_ventas_create('2010-09-11');
call sp_ventas_create('2020-01-01');
call sp_ventas_create('2003-03-01');

call sp_compras_create('2012-12-02');
call sp_compras_create('2010-12-02');
call sp_compras_create('2009-09-12');
call sp_compras_create('2009-01-02');
call sp_compras_create('2003-03-02');

call sp_productos_create('Televisores 65 Curve LG');
call sp_productos_create('Laptop AlienWare i9');
call sp_productos_create('Lavadoras ');
call sp_productos_create('Equipo de Sonido AIWA');
call sp_productos_create('Walkman Sony Antishok');

call sp_detalle_compras_create(1, 1, 10, 100000);
call sp_detalle_compras_create(2, 2, 5, 100000);
call sp_detalle_compras_create(3, 3, 20, 50000);
call sp_detalle_compras_create(4, 4, 10, 250000);
call sp_detalle_compras_create(5, 5, 10, 456666);

call sp_detalle_ventas_create(1, 1, 6);
call sp_detalle_ventas_create(2, 2, 4);
call sp_detalle_ventas_create(3, 3, 4);
call sp_detalle_ventas_create(4, 5, 2);
call sp_detalle_ventas_create(5, 5, 5);

select * from ventas;
select * from productos;
select * from detalle_ventas;
