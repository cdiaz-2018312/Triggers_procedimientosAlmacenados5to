/* 
Actividad de aprendizaje.
Funciones almacenadas
Temario: A

Curso: Taller II
Catedrático: Jorge Pérez.

	Nombre alumno: Carlos Eduardo Díaz Chacón
	Carné:	2018312
	Sección: B
    Grupo: 1
	Fecha: 10/02/2022
    
*/

DROP DATABASE IF EXISTS db_funciones_CarlosDiaz;
CREATE DATABASE db_funciones_CarlosDiaz;

USE db_funciones_CarlosDiaz;

CREATE TABLE resultados (
	id INT AUTO_INCREMENT NOT NULL,
    area DECIMAL(10,2),
    impares VARCHAR(45),
    menor INT,
    PRIMARY KEY pk_funciones_Id (id)
);

-- INSTRUCCIONES:

-- 1. Crear un procedimiento almacenado para insertar registros en la tabla Resultados
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_resultados_INSERT $$
CREATE PROCEDURE sp_resultados_INSERT(IN _area DECIMAL(10,2),IN _impares VARCHAR(45),IN _menor INT)
BEGIN 
	INSERT INTO resultados(	id,
		area,
		impares,
		menor
)
	VALUES(
		_area, 
		_impares,
		_menor
);

END $$
DELIMITER ;


-- 2. Crear una función para calcular el área de un triangulo.

DELIMITER %%
DROP FUNCTION IF EXISTS fn_area %%
CREATE FUNCTION fn_area(base DECIMAL(10,2),altura DECIMAL(10,2))
RETURNS DECIMAL (10,2)
READS SQL DATA DETERMINISTIC
BEGIN 
		DECLARE area DECIMAL(10,2);
        SET area = (base*altura)/2;
        RETURN area;
END %%
DELIMITER ;


SET @area=fn_area(4.8,2.6);
select @area;

-- 3. Crear una función que acumule en una variable todos los números impares del 1 al N.

DELIMITER &&
DROP FUNCTION IF EXISTS fn_impares &&
CREATE FUnction fn_impares( fin int)
RETURNS INT 
READS SQL DATA DETERMINISTIC 
BEGIN
	DECLARE i INT  ;
    DECLARE numero int;
		set i=0;
		ciclo: LOOP 
        SET i=i+1;
        if i%2=0 THEN 
			iterate ciclo;
		END IF;
	set numero= concat(i,"|");
  if i=fin then
  lEAVE ciclo;
  end if;
   END LOOP ciclo;
	return numero ;  
   END &&
DELIMITER ;

SET @impares=fn_impares(15);
select @impares;
-- 4. Crear una función para calcular el número menor de 4 números enteros.
DELIMITER %%

CREATE FUNCTION fn_menor(num1 INT,num2 INT, num3 INT, num4 INT) RETURNS varchar(240) CHARSET utf8mb4
    READS SQL DATA DETERMINISTIC
BEGIN 
	DECLARE mini INT DEFAULT 0;
    DECLARE valores VARCHAR(240) DEFAULT " " ;
    IF (num1<num2)AND(num1<num3)AND(num1<num4) THEN
		SET mini=num1;
		ELSEIF (num2<num1)AND(num2<num3)AND(num2<num4) THEN 
			SET mini=num2;
			ELSEIF (num3<num1)AND(num3<num2)AND(num3<num4)THEN
				SET mini=num3;
				ELSEIF (num4<num1)AND(num4<num2)AND(num4<num3)THEN
					SET mini=num4;
	END IF;
    SET valores =CONCAT(num1," | ",num2," | ",num3," | ",num4," | ","el valor menor es: ",mini) ;
    RETURN valores;
    END %%
    DELIMITER ;
set @menor=fn_menor(15,24,65,8);
SELECT @menor;
-- 5. Llamar al procedimiento almacenado creado anteriormente para insertar el resultado de las funciones en la tabla Resultados

CALL sp_resultados_INSERT( @area, @impares, @menor);

-- crear un procedimiento almacenado para listar todos los registros de la tabla resultados

Delimiter $$
CREATE PROCEDURE Almacenamiento()
Begin 
	select * From resultados;
END $$
DELIMITER ; 
call Almacenamiento();