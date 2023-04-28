drop database if exists db_control_materia_in5bm;
create database db_control_materia_in5bm;
use db_control_materia_in5bm;


CREATE TABLE IF NOT EXISTS  materias (
	id_materia INT AUTO_INCREMENT NOT NULL,
	nombre_materia VARCHAR(25) NOT NULL,
	ciclo_escolar YEAR NOT NULL,
	horario_inicio TIME,
	horario_final TIME,
	nota INT,
	catedratico VARCHAR(25),
	salon VARCHAR (25),
	cupo_maximo VARCHAR(25),
	cupo_minimo VARCHAR(25),
	PRIMARY KEY(id_materia)
);

-- -------------------------------------------------------------------------------DDL----------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO materias(nombre_materia,ciclo_escolar,horario_inicio,horario_final,nota,catedratico,salon,cupo_minimo,cupo_maximo) 
VALUES 
("Matematica",'2022','7:05:00','8:05:00',76,"Luis","c-22",35,40),("Taller",'2022','8:05:00','9:05:00',87,"Adher","c-7",20,30),
("Literatura",'2022','9:05:00','10:05:00',65,"Morfeo","c-90",15,25),("Musica",'2022','10:05:00','11:05:00',47,"Andres","c-23",40,45),
("Ciencias Sociales",'2022','11:05:00','12:05:00',87,"Manuel","c-40",25,30),("Fisica",'2022','12:05:00','13:05:00',98,"Isidoro","c-84",30,40),
("Quimica",'2022','13:05:00','14:05:00',78,"Julio","c-95",20,25),("Estadistica",'2022','14:05:00','15:05:00',89,"Pedro","c-75",45,50),
("Lenguaje",'2022','15:05:00','16:05:00',60,"KoI","c-50",25,35),("Dibujo",'2022','16:05:00','17:05:00',86,"Mynor","c-01",30,35);
-- .-----------------------------procedimientos---------------------------------------------------------------------------------------------------------------------------------------------------------------

delimiter $$
CREATE PROCEDURE sp_materias_read()
BEGIN
	Select nombre_materia,
	ciclo_escolar,
	horario_inicio,
	horario_final,
	
    catedratico,
	salon,
	cupo_minimo,
	cupo_maximo, 
    nota
	FROM materias;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_materias_update(IN nombre_materia_ VARCHAR(25),IN ciclo_escolar_ YEAR,IN horario_inicio_ TIME, IN horario_final_ TIME,
IN catedratico_ VARCHAR(25),IN salon_ VARCHAR(25),IN cupo_minimo_ INT,IN cupo_maximo_ INT, IN nota_ INT, IN id_materia_ INT )
BEGIN
UPDATE materias SET nombre_materia = nombre_materia_,
ciclo_escolar = ciclo_escolar_,
horario_inicio = horario_inicio_,
horario_final = horario_final_,

catedratico = catedratico_,
salon = salon_,
cupo_minimo = cupo_minimo_,
cupo_maximo = cupo_maximo_,
nota = nota_
where id_materia =id_materia_;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_materias_create(IN nombre_materia_ VARCHAR(25), IN ciclo_escolar_ YEAR , IN horario_inicio_ TIME, 
IN horario_final_ TIME ,IN catedratico_ VARCHAR(25),IN salon_ VARCHAR(25),IN cupo_minimo_ INT ,IN cupo_maximo_ INT, IN nota_ INT )
BEGIN 
INSERT INTO materias(nombre_materia,ciclo_escolar,horario_inicio,horario_final,catedratico,salon,cupo_minimo,cupo_maximo) VALUES 
(nombre_materia_,ciclo_escolar_, horario_inicio_, horario_final_,catedratico_ , salon_,cupo_minimo_, cupo_maximo_,nota_ );
END $$

delimiter $$
CREATE PROCEDURE sp_materias_delete( IN id_materias_ int)
BEGIN
DELETE FROM materias where id_materia = id_materia_;
END $$
delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_registros()
BEGIN
SELECT count(id_materia) FROM materias; 
END$$

call sp_registros();

CALL sp_materias_read();


