DROP DATABASE IF EXISTS control_academico_in5bm;
CREATE DATABASE control_academico_in5bm;
USE control_academico_in5bm;

-- -------------------------------------------------DDL ----------------------------------------------------------------

CREATE TABLE alumnos(
carne VARCHAR(16) not null,
nombre1 VARCHAR(16) not null,
nombre2 VARCHAR (16),
nombre3 VARCHAR (16),
apellido1 VARCHAR(16),
apellido2 VARCHAR (16) NOT NULL,
PRIMARY KEY (carne)
);
CREATE TABLE salones(
id_salon VARCHAR(5)  NOT NULL,
descripcion  VARCHAR(45),
capacidad_max INT ,
edificio VARCHAR(16),
nivel INT,
PRIMARY KEY (id_salon)
);


CREATE TABLE carreras_tecnicas(
codigo_tecnico VARCHAR (10) NOT NULL,
carrera VARCHAR (45) NOT NULL,
grado VARCHAR(10) NOT NULL,
seccion CHAR(1) not null,
jornada VARCHAR(10) not null,
PRIMARY KEY (codigo_tecnico)
);



DROP TABLE IF EXISTS instructores;
create table instructores(
id_instructor INT NOT NULL AUTO_INCREMENT,
nombre1 VARCHAR (15) not null,
nombre2 VARCHAR (15),
nombre3 VARCHAR (15),
apellido1 VARCHAR (15) not null,
apellido2 VARCHAR (15),
direccion VARCHAR (50),
email VARCHAR (45) not null,
telefono VARCHAR (25) not null,
fecha_de_nacimiento DATE,
PRIMARY KEY (id_instructor)
);

DROP TABLE IF EXISTS horarios;
CREATE TABLE horarios (
id_horario INT NOT NULL AUTO_INCREMENT,
horario_inicio TIME NOT NULL,
horario_final TIME NOT NULL,
lunes TINYINT(1),
martes TINYINT(1),
miercoles TINYINT(1),
jueves TINYINT(1),
viernes TINYINT(1),
PRIMARY KEY (id_horario)
);

DROP TABLE IF EXISTS cursos;
CREATE TABLE cursos(
id_curso INT NOT NULL AUTO_INCREMENT,
nombre_curso VARCHAR(16) NOT NULL,
ciclo YEAR,
cupo_maximo INT,
cupo_min INT,
carrera_tecnica_id VARCHAR(15) NOT NULL,
horario_id INT not null,
salon_id VARCHAR(5) not null,
instructor_id int not null,
PRIMARY KEY (id_curso),
CONSTRAINT fk_carrera_tecnica_id
FOREIGN KEY (carrera_tecnica_id) REFERENCES carreras_tecnicas (codigo_tecnico)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_horario_id
FOREIGN KEY (horario_id) REFERENCES horarios (id_horario)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_salon_id
FOREIGN KEY (salon_id) REFERENCES salones (id_salon)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_instructor_id
FOREIGN KEY (instructor_id) REFERENCES instructores(id_instructor)
ON delete cascade on update cascade 
);

DROP TABLE IF EXISTS asignaciones_alumnos;
CREATE TABLE asignaciones_alumnos(
id VARCHAR(45) NOT NULL,
alumno_id VARCHAR(16) NOT NULL,
curso_id INT NOT NULL,
fecha_asignacion DATETIME,
PRIMARY KEY(id),
CONSTRAINT fk_alumno_id
FOREIGN KEY (alumno_id)
REFERENCES alumnos(carne)
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT fk_curso_id
FOREIGN KEY (curso_id)
REFERENCES cursos(id_curso)
ON DELETE CASCADE ON UPDATE CASCADE
);



-- Procedimientos almacenados
-- Alumnos-------------------------------------------------------
-- alumnos read
DELIMITER $$

DROP PROCEDURE
 IF  EXISTS sp_alumnos_create$$

	CREATE PROCEDURE sp_alumnos_create(IN _carne VARCHAR(16), IN _nombre1 VARCHAR(16), IN _nombre2 VARCHAR(16),
		IN _nombre3 VARCHAR(16), IN _apellido1 VARCHAR(16), IN _apellido2 VARCHAR(16))
	BEGIN
		INSERT INTO alumnos (carne,nombre1,nombre2,nombre3,apellido1,apellido2)
		VALUES(_carne,_nombre1,_nombre2,_nombre3,_apellido1,_apellido2);
END $$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_alumnos_read$$

	CREATE PROCEDURE sp_alumnos_read()
	BEGIN
		SELECT * FROM alumnos;
END $$
DElimiter ;

-- READ BY ID
DROP PROCEDURE IF EXISTS sp_alumnos_read_id;
DELIMITER $$
	CREATE PROCEDURE sp_alumnos_read_id(IN _carne VARCHAR(16))
	BEGIN
		SELECT * FROM alumnos WHERE alumnos.carne = _carne;
END $$ 
DElimiter ;




-- Update alumnos

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_alumnos_update$$

	CREATE PROCEDURE sp_alumnos_update(IN _carne VARCHAR(16),IN _nombre1 VARCHAR(16), IN _nombre2 VARCHAR(16), IN _nombre3 VARCHAR(16),
		IN _apellido1 VARCHAR(16), IN _apellido2 VARCHAR(16))
	BEGIN
		UPDATE alumnos SET
		nombre1 = _nombre1,
		nombre2 = _nombre2,
		nombre3 = _nombre3,
		apellido1 = _apellido1,
		apellido2 = _apellido2
		WHERE carne = _carne;
END $$
DElimiter ; 

-- alumnos delete

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_alumnos_delete$$

	CREATE PROCEDURE sp_alumnos_delete(IN _carne VARCHAR(16))
	BEGIN
		DELETE FROM alumnos WHEre carne = _carne;
END $$ 
DElimiter ;

-- Salones----------------------------------------------------------------------------------------------------------------------------------
-- salones Create-------------------------------------------------

DELIMITER $$
DROP PROCEDURE IF  EXISTS sp_salones_create $$
	CREATE PROCEDURE sp_salones_create(IN _id_salon VARCHAR(5), IN _descripcion VARCHAR(45), 
		IN _capacidad_max INT, IN _edificio VARCHAR (16), IN _nivel INT)
	BEGIN
		INSERT INTO salones (id_salon,descripcion,capacidad_max,edificio,nivel)
		VALUES(_id_salon,_descripcion,_capacidad_max,_edificio,_nivel);
END $$
DElimiter ;

-- Salones read

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_salones_read;

	CREATE PROCEDURE sp_salones_read()
	BEGIN
		SELECT * FROM salones;
END $$
DElimiter ;

-- READ BY ID
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_salones_read_id$$

	CREATE PROCEDURE sp_salones_read_id(IN _id_salon VARCHAR(5))
	BEGIN
		SELECT * FROM salones WHERE id_salon = _id_salon;
END $$
DElimiter ;

-- salones update
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_salones_update$$

	CREATE PROCEDURE sp_salones_update(IN _descripcion VARCHAR(45), 
    IN _capacidad_max INT, IN _edificio VARCHAR (16), IN _nivel INT , IN _id_salon VARCHAR(5))
	BEGIN
	UPDATE salones SET
    descripcion = _descripcion,
    capacidad_max = _capacidad_max,
    edificio = _edificio,
    nivel = _nivel
    WHERE
    id_salon = _id_salon;
END $$
DElimiter ;

-- salones delete
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_salones_delete$$
	CREATE PROCEDURE sp_salones_delete(IN _id_salon VARCHAR(5))
	BEGIN
		DELETE FROM salones
		WHERE
		id_salon = _id_salon;
END $$
DElimiter ;

-- carreras Tecnicas------------------------------------------------------------------------------------------

-- carreras tecnicas create
DELIMITER $$
DROP PROCEDURE IF  EXISTS sp_carreras_tecnicas_create$$
	CREATE PROCEDURE sp_carreras_tecnicas_create(IN _codigo_tecnico VARCHAR(10), IN _carrera VARCHAR(45), 
		IN _grado VARCHAR(10), IN _seccion CHAR(1), IN _jornada VARCHAR (10))
	BEGIN
		INSERT INTO carreras_tecnicas (codigo_tecnico,carrera,grado,seccion,jornada)
		VALUES(_codigo_tecnico,_carrera,_grado,_seccion,_jornada);
END $$
     
     -- carreras tecnicas read
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_carreras_tecnicas_read$$
	CREATE PROCEDURE sp_carreras_tecnicas_read()
	BEGIN
		SELECT * FROM carreras_tecnicas;
END $$
DElimiter ;

-- READ BY ID

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_carreras_tecnicas_read_id $$
	CREATE PROCEDURE sp_carreras_tecnicas_read_id(IN _codigo_tecnico VARCHAR(10))
	BEGIN
		SELECT * FROM carreras_tecnicas WHERE codigo_tecnico = _codigo_tecnico;
END $$
DElimiter ;

--  carreras_tecnicas update
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_carreras_tecnicas_update$$

	CREATE PROCEDURE sp_carreras_tecnicas_update(IN _carrera VARCHAR(45), 
		IN _grado VARCHAR(10), IN _seccion CHAR(1), IN _jornada VARCHAR (10), IN _codigo_tecnico VARCHAR(8))
	BEGIN
		UPDATE carerras_tecnicas SET
		carrera = _carrera,
		grado = _grado,
		seccion = _seccion,
		jornada = _jornada
		WHERE
		codigo_tecnico = _codigo_tecnico;
END $$
DElimiter ;

-- DELETE carreras_tecnicas
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_carreras_tecnicas_delete$$

	CREATE PROCEDURE sp_carreras_tecnicas_delete(IN _codigo_tecnico VARCHAR(10))
	BEGIN
		DELETE FROM carreras_tecnicas
		WHERE
		codigo_tecnico = _codigo_tecnico;
END $$
DElimiter ;



-- Instructores ----------------------------------------------------------------------------

DELIMITER $$
DROP PROCEDURE IF  EXISTS sp_instructores_create;
	CREATE PROCEDURE sp_instructores_create(IN _nombre1 VARCHAR(15), IN _nombre2 VARCHAR(15),
		IN _nombre3 VARCHAR(15), IN _apellido1 VARCHAR(15), IN _apellido2 VARCHAR(15),
		IN _direccion VARCHAR(50), IN _email VARCHAR(45), IN _telefono VARCHAR(25), IN _fecha_nacimiento DATE)
	BEGIN
		INSERT INTO instructores (nombre1,nombre2,nombre3,apellido1,apellido2,direccion,email,telefono,fecha_de_nacimiento)
		VALUES(_nombre1,_nombre2,_nombre3,_apellido1,_apellido2,_direccion,_email,_telefono,_fecha_nacimiento);
END $$
Delimiter ;

-- Instructores Read 
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_instructores_read$$
	CREATE PROCEDURE sp_instructores_read()
	BEGIN
		SELECT * FROM instructores;
END $$
DElimiter ;
-- Instructores Read by id
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_instructores_read_id $$

	CREATE PROCEDURE sp_instructores_read_id(IN _id_instructor INT)
	BEGIN
		SELECT * FROM instructores WHERE id_instructor= _id_instructor;
END $$
DElimiter ;

--  INSTRUCTORES update

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_instructores_update $$
	CREATE PROCEDURE sp_instructores_update(IN _nombre1 VARCHAR(15), IN _nombre2 VARCHAR(15),
		IN _nombre3 VARCHAR(15), IN _apellido1 VARCHAR(15), IN _apellido2 VARCHAR(15),
		IN _direccion VARCHAR(50), IN _email VARCHAR(45), IN _telefono VARCHAR(25), IN _fecha_de_nacimiento DATE, IN _id_instuctor INT)
	BEGIN
		UPDATE instructores SET
		nombre1 = _nombre1,
		nombre2 = _nombre2,
		nombre3 = _nombre3,
		apellido1 = _apellido1,
		apellido2 = _apellido2,
		direccion = _direccion,
		email = _email,
		telefono = _telefono,
		fecha_nacimiento =_fecha_nacimiento
		WHERE id_instructor = _id_instructor;
END $$
DElimiter ;


-- instructores DELETE 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_instructores_delete $$
	CREATE PROCEDURE sp_instructores_delete (IN _id_instructor INT)
	BEGIN
		DELETE FROM instructores WHERE id_instructor =_id_instructor;
END $$ 
DElimiter ;

-- horarios -----------------------------------------------------------------------
-- horarios create
DELIMITER $$
DROP PROCEDURE IF  EXISTS sp_horarios_create $$
	CREATE PROCEDURE sp_horarios_create(IN _horario_inicio TIME, 
		IN _horario_final TIME, IN _lunes TINYINT, IN _martes TINYINT, IN _miercoles TINYINT,
		IN _jueves TINYINT, IN _viernes TINYINT)
	BEGIN
		INSERT INTO horarios (horario_inicio,horario_final,lunes,martes,miercoles,
		jueves,viernes)
		VALUES(_horario_inicio,_horario_final,_lunes,_martes,_miercoles,_jueves,viernes);
END $$
        
 -- Horarios Read 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_horarios_read$$
	CREATE PROCEDURE sp_horarios_read()
	BEGIN
		SELECT * FROM horarios;
END $$
DElimiter ;

-- horarios Read by id

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_horarios_read_id$$
	CREATE PROCEDURE sp_horarios_read_id(IN _id_horario INT)
	BEGIN
		SELECT * FROM horarios WHERE id_horario = _id_horario;
END $$
DElimiter ;

-- horarios Update 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_horarios_update$$

	CREATE PROCEDURE sp_horarios_update (IN _horario_inicio TIME, 
		IN _horario_final TIME, IN _lunes TINYINT, IN _martes TINYINT, IN _miercoles TINYINT,
		IN _jueves TINYINT, IN _viernes TINYINT, IN _id INT)
	BEGIN
		UPDATE horarios SET
		horario_inicio = _horario_inicio,
		horario_final = _horario_final,
		lunes =  _lunes,
		martes = _martes,
		miercoles = _miercoles,
		jueves = _jueves,
		viernes = _viernes
		WHERE
		id_horario = _id_horario;
END $$
DElimiter ;

-- DELETE horarios

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_horarios_delete$$
	CREATE PROCEDURE sp_horarios_delete(IN _id_horario INT)
	BEGIN
		DELETE FROM horarios
		WHERE
		id_horario = _id_horario;
END $$
DElimiter ;

-- cursos--------------------------------------------------------------------------------
-- cursos create


DELIMITER $$
DROP PROCEDURE IF  EXISTS sp_cursos_create$$

	CREATE PROCEDURE sp_cursos_create(IN _nombre_curso VARCHAR(16), IN _ciclo YEAR,
		IN _cupo_max INT , IN _cupo_min INT, IN _carrera_tecnica_id VARCHAR(15),
		IN _horario_id INT, IN _instructor_id INT, IN _salon_id VARCHAR(5))
	BEGIN
		INSERT INTO cursos (nombre_curso,ciclo,cupo_max,cupo_min,carrera_tecnica_id,
		horario_id,instructor_id,salon_id)
		VALUES(_nombre_curso,_ciclo,_cupo_max,_cupo_min,_carrera_tecnica_id,_horario_id
		,_instructor_id, _salon_id);
END $$
  DElimiter ;

  -- cursos Read 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_cursos_read$$

	CREATE PROCEDURE sp_cursos_read()
	BEGIN
		SELECT * FROM cursos;
END $$
DElimiter ;

-- curso Read by id
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_cursos_read_id$$
	CREATE PROCEDURE sp_cursos_read_id(IN _id_curso INT)
	BEGIN
		SELECT * FROM cursos WHERE id_curso = _id_curso;
END $$  

-- cursos UPDATE
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_cursos_update$$

	CREATE PROCEDURE sp_cursos_update (IN _nombre_curso VARCHAR(16), IN _ciclo YEAR,
		IN _cupo_max INT , IN _cupo_min INT, IN _carrera_tecnica_id VARCHAR(15),
		IN _horario_id INT, IN _instructor_id INT, IN _salon_id INT, IN _id_curso INT)
	BEGIN
		UPDATE cursos SET
		nombre_curso = _nombre_curso,
		ciclo = _ciclo,
		cupo_max = _cupo_max,
		cupo_minimo = _cupo_min,
		carrera_tecnica_id = _carrera_tecnica_id,
		horario_id = _horario_id,
		instructor_id = _instructor_id,
        salon_id = _salon_id
		WHERE
		id_curso = _id_curso;
END $$
DElimiter ;

-- DELETE cursos
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_cursos_delete$$

	CREATE PROCEDURE sp_cursos_delete(IN _id_curso INT)
	BEGIN
		DELETE FROM cursos
		WHERE
		id_curso = _id_curso;
END $$
DElimiter ;

-- asignaciones_alumnos-------------------------------------------------------------
-- asig_alumnos create

DELIMITER $$
DROP PROCEDURE IF  EXISTS sp_asignaciones_alumnos_create$$
	CREATE PROCEDURE sp_asignaciones_alumnos_create(IN _id VARCHAR(45),IN _alumno_id VARCHAR(16),IN _cursos_id INT,IN _fecha_asignacion DATETIME)
	BEGIN
		INSERT INTO asignacion_alumnos (id,alumno_id,curso_id,fecha_asignacion)
		VALUES(_id,_alumno_id,_curso_id,_fecha_asignacion);
END $$
   DElimiter ;
     
  -- asignacion_alumnos Read 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_asignaciones_alumnos_read$$

	CREATE PROCEDURE sp_asignaciones_alumnos_read()
	BEGIN
		SELECT * FROM asignacion_alumnos;
END $$ 
DElimiter ;
-- asignacion_alumnos Read by id
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_asignaciones_alumnos_read$$

	CREATE PROCEDURE sp_asignaciones_alumnos_id_read(IN _id INT)
	BEGIN
		SELECT * FROM asignaciones_alumnos WHERE id = _id;
END $	
DElimiter ;


-- asignacion_alumnos UPDATE
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_asignaciones_alumnos_update$$

	CREATE PROCEDURE sp_asignaciones_alumnos_update(IN _alumno_id VARCHAR(16), IN _curso_id INT, IN _fecha_asignacion DATETIME,
		IN _id INT)
	BEGIN
		UPDATE asignacion_alumnos SET
		alumno_id = _alumno_id,
		cursos_id = _curso_id,
		fecha_asignacion = _fecha_asignacion
		WHERE id = _id;
END $$
DElimiter ;

-- delete asig_alumnos
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_asignaciones_alumnos_delete$$

	CREATE PROCEDURE sp_asignaciones_alumnos_delete(IN _id INT)
	BEGIN
		DELETE FROM asignacion_alumnos WHERE id =_id;
END $$ 
DElimiter ;

CALL sp_alumnos_create("2020323","Juan","Carlos","Gabriel","García","Dubón");
CALL sp_alumnos_create("2022421","Courtn","Kevin","Louis","Kingston","Street");
CALL sp_alumnos_create("2018312","Ernesto","ALdair","Eduardo","Sanum","Pérez");
CALL sp_alumnos_create("2020991","Yeremi","Aldair","Jeremias","Pérez","Solorzano");
CALL sp_alumnos_create("2019484","Jose","Alfredo","Fernando","Bonilla","Quéme");
CALL sp_alumnos_create("2018315","Juan","Carlos","Josue","Ramirez","Fuentes");
CALL sp_alumnos_create("2017112","Luis","Edurdo","José","Restrepo","Patiño");
CALL sp_alumnos_create("2022866","Rodrigo","Jose","Carlos","Bonilla","Quiroz");
CALL sp_alumnos_create("2021581","Carlos","Fernando","Aaron","Juarez","Alveño");
CALL sp_alumnos_create("2021331","Ronald","José","Andres","Chinchilla","Tzuruy");

CALL sp_instructores_create("Jose","Salomon","Jesús","Fernández","Fernándezz","zona 3","Fernandez@gmail.com","23133424","1956-03-12");



CALL sp_salones_create("A1","Salon con cielo falso pintado",30,"EF1",1);
CALL sp_salones_create("B1","Salon de practicas ",25,"EF1",3);
CALL sp_salones_create("C2","Salon de Laboratorio",40,"EF1",2);
CALL sp_salones_create("D1","Salon amplio con 3 sillas zurdas",40,"EF2",1);
CALL sp_salones_create("F3","Salon pequeño ",25,"EF2",3);
CALL sp_salones_create("G2","salon Mediano",30,"EF2",2);
CALL sp_salones_create("H3","Salon mediano",30,"EF3",3);
CALL sp_salones_create("J1","Salon mediano-grande",35,"EF3",1);
CALL sp_salones_create("K2","Salon mediano-grande",35,"EF3",2);
CALL sp_salones_create("L1","salon pequeño",25,"EF1",1); 





