-- Carlos Eduardo Díaz Chacón 
-- PE5BM 5to perito sección B Grupo 1
-- carne 2018312

--  ------------------------------------------------------DDL------------------------------------------------------
DROP DATABASE IF EXISTS EmpresasGuatemala;
CREATE DATABASE IF NOT EXISTS EmpresasGuatemala
DEFAULT CHARACTER SET utf8 
DEFAULT COLLATE utf8_general_ci;

USE EmpresasGuatemala;

CREATE TABLE telefonos (
id int not null,
numero_telefono int,
PRIMARY KEY (id)
);

CREATE TABLE regiones (
id int not null ,
nombre_region VARCHAR (20),
PRIMARY KEY (id)
);

CREATE TABLE departamentos_guate (
id INT not null,
nombre_departamento VARCHAR (20),
id_region int,
 PRIMARY KEY (id),
 FOREIGN KEY (id_region) REFERENCES regiones (id) ON DELETE CASCADE ON UPDATE CASCADE
 );
 
 
 CREATE TABLE oficinas(
 id int not null,
direccion varchar(30),
id_departamento int,
PRIMARY KEY (id),
FOREIGN KEY (id_departamento) REFERENCES departamentos_guate (id) ON DELETE CASCADE ON UPDATE CASCADE
 );
 

 CREATE TABLE departamentos_empresa(
 id int not null,
 nombre varchar (15),
 PRIMARY KEY (id)
 );
 
 CREATE TABLE departamento_oficinas (
 id int not null,
 id_oficina int,
 id_telefono int,
 id_departamento_empresa int,
 PRIMARY KEY (id),
 FOREIGN KEY (id_oficina) REFERENCES oficinas(id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (id_telefono) REFERENCES telefonos (id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (id_departamento_empresa) REFERENCES departamentos_empresa(id)ON DELETE CASCADE ON UPDATE CASCADE
 );
 
 CREATE TABLE tipo_empleados(
 id int not null,
 nombre_tipo_empleado varchar(15),
 sueldo_base DECIMAL (10,2),
 bonificacion_ley DECIMAL(10,2),
 bonificacion_empresa DECIMAL(10,2),
PRIMARY KEY (id)
);


CREATE TABLE empleados(
id int not null,
nombre VARCHAR(20),
apellido VARCHAR(20),
edad int,
año_de_contrato year,
telefono int,
id_tipo_empleado INT,
id_departamento_oficinas INT,
PRIMARY KEY (id),
FOREIGN KEY (id_tipo_empleado) REFERENCES tipo_empleados(id)ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_departamento_oficinas)REFERENCES departamento_oficinas(id)ON DELETE CASCADE ON UPDATE CASCADE
); 
 --  ------------------------------------------------------DML------------------------------------------------------
 
 INSERT INTO telefonos (id,numero_telefono)  VALUES
(1,123455),(2,234452),
(3,589564),(4,21366599),
(5,09656422),(6,25980768),
(7,5365045),(8,23414689),
(9,975674),(10,32423850);

INSERT INTO regiones(id,nombre_region)VALUES
(1,"Metropolitana"),(2,"Verapaz"),
(3,"Nororiente"),(4,"Suroriente"),
(5,"Central"),(6,"Suroccidente"),
(7,"Noroccidente"),(8,"Petén");

INSERT INTO departamentos_guate(id,nombre_departamento,id_region)VALUES
 (1,"Guatemala",1),(2,"Alta Verapaz",2),(3,"Baja Verapaz",2),
 (4,"Chiquimula",3),(5,"El progreso",3),(6,"Izabal",3),
 (7,"Zacapa",3),(8,"Jutiapa",4),(9,"Jalapa",4),
 (10,"Santa Rosa",4),(11,"Chimaltengo",5),(12,"Sacatepéquez",5),
 (13,"Escuintla",5),(14,"Quetzaltenango",6),(15,"Retalhuleu",6),
 (16,"San Marcos",6),(17,"Suchitepequéz",6),(18,"Sololá",6),
 (19,"Totonicapán",6),(20,"Huhuetenango",7),(21,"Quiché",7),
 (22,"Petén",8);
 
 INSERT INTO oficinas(id,direccion,id_departamento) VALUES 
(1,"5ta avenida zona 3",5),(2,"3ra avenida zona 5",21),
(3,"7ma avenida zona 1",1 ),(4,"2da avenida zona 7",13),
(5,"9na avenida zona 3",11),(6,"13va avenida zona 19",22),
(7,"3ra avenida zona 14",2),(8,"12va avenida zona 12",10),
(9,"5ta avenida zona 7",8),(10,"19 avenida zona 1", 3);

INSERT INTO departamentos_empresa(id,nombre)VALUES
(1,"jefaturia"), (2,"Contaduria"),
(3,"RecursosHumanos"), (4,"Mantenimiento"),
(5,"Logistica"),(6,"ventas"),
(7,"aréa técnica")
;

 INSERT INTO departamento_oficinas (id,id_oficina,id_telefono,id_departamento_empresa)VALUES 
 (1,1,1,1),(2,2,2,2),
 (3,3,3,3),(4,4,4,4),
 (5,5,5,4),(6,6,6,5),
 (7,7,7,6),(8,8,8,6),
 (9,9,9,6),(10,10,10,7);
 
 INSERT INTO tipo_empleados(id,nombre_tipo_empleado,sueldo_base,bonificacion_ley,bonificacion_empresa)VALUES 
(1,"Jefe",37000.50,5000.37,2000.50),(2,"veterano",12000.75,3000.80,1000.00),
(3,"Nuevo",6000,1000.00,500.50),(4,"Conserje",5000.00,1500.35,500.50),
(5,"secretaria/o",6000.90,1000.00,600.00);
INSERT INTO empleados (id,nombre,apellido,edad,año_de_contrato,telefono,id_tipo_empleado,id_departamento_oficinas)VALUES 
(1,"Naomy","Garcia",19,2021,832478,3,2),(2,"Carlos","Franco",32,2019,23874232,2,3),
(3,"Elizabeth","castañeda",25,2018,18329348,5,2),(4,"Jose","Chacon",43,2007,892384,2,6),
(5,"Julio","Hernandez",33,2011,0281349,4,4),(6,"Rodolfo","Guillen",18,2022,1039841,3,6),
(7,"Melisa","Díaz",21,2019,12348913,5,5),(8,"Hilary","Stephens",36,2015,902375016,2,3),
(9,"Eduardo","Mayen",61,2002,109839501,1,1),(10,"Ana","Ispache",40,2018,19387491,4,4);
   

--  ------------------------------------------------------Consultas------------------------------------------------------

-- 1) Nombre y edad de los empleados.
SELECT e.nombre,e.edad FROM empleados AS e;

-- 2) año de contratacion de los empleados.
SELECT e.año_de_contrato FROM empleados AS e;

-- 3) Edades de los empleados.
SELECT e.edad FROM empleados AS e;

-- 4) numero de empleados para cada una de las edades.
SELECT count(e.edad) AS numero_de_empleados, e.edad FROM empleados AS e Group by e.edad  ;

-- 5)Edad media de los empleados por departamento.
SELECT departamentos_empresa.nombre,avg(e.edad) From departamentos_empresa inner join
 empleados AS e on e.id_departamento_oficinas= departamentos_empresa.id
 Group by departamentos_empresa.nombre; -- profe no se por que el valor promedio me da numeros muy grandes, ya llevo rato intentado de muchas formas y nada
 
-- 6)Tipos de Empleados que superan las 35.000 de salario.
 SELECT T.nombre_tipo_empleado AS Nombre From tipo_empleados AS T where sueldo_base > 35000.00;
 
-- 7) Datos del empleado número X.
 SELECT id,nombre,apellido,edad,año_de_contrato,telefono,id_tipo_empleado,id_departamento_oficinas
 FROM empleados where id=4;
 
-- 8) Empleados del departamento de empresa X.
 SELECT d.nombre AS departamento, e.nombre AS nombre From departamentos_empresa AS d 
 INNER JOIN empleados AS e ON d.id = e.id_departamento_oficinas where d.nombre="ventas";
 
-- 9)  Empleados cuya contratación se produjo en el año X.
 SELECT e.nombre,e.año_de_contrato AS año 
 FROM empleados AS e WHERE año_de_contrato=2018;
 
-- 10) Empleados que no sean jefe de Departamento X.
SELECT nombre From empleados where id_tipo_empleado > 1;  

-- 11) Empleados contratados entre los años X y X
SELECT nombre From empleados WHERE año_de_contrato BETWEEN 	'2020' and '2022';

-- 12) Tipos de Empleado que tienen un salario superior a 35.000 e inferior a 40,000
SELECT nombre_tipo_empleado FROM tipo_empleados where sueldo_base BETWEEN '35000.00' AND '40000.00';

-- 13) Empleados cuyo tipo de empleado es director o jefe de sección
SELECT e.nombre FROM empleados AS e where id_tipo_empleado="1";
 
-- 14) Empleados de nombre 'Jose'.
 SELECT count(nombre) AS "numero de empleados llamados Jose" FROM empleados WHERE nombre = "Jose";
 
-- 15) Empleados que pertenecen al departamento administrativo y que tienen una edad mayor a 30 años
-- no añadi un departamento con nombre administrativo pero lo haré con Mantenimiento que tiene id 4 
SELECT e.nombre , d.nombre FROM empleados AS e 
INNER JOIN departamentos_empresa as d on e.id_departamento_oficinas= d.id
 where e.edad > 30 and e.id_departamento_oficinas =4;
 
-- 16) Empleados que no pertenecen al departamento de la empresa X
 SELECT nombre FROM empleados WHERE id_departamento_oficinas between '2'AND '5';
 
-- 17) Nombre y edad de los empleados ordenados de menor a mayor edad.
 SELECT nombre,edad FROM empleados ORDER BY edad Asc;
 
-- 18)Nombre y edad de los empleados ordenados por nombre de forma descendente
 SELECT nombre,edad FROM empleados ORDER BY nombre Desc;
 
-- 19) Nombre del empleado y el departamento de la empresa en la que trabaja.
SELECT e.nombre,d.nombre FROM empleados AS e 
INNER JOIN departamentos_empresa AS d on e.id_departamento_oficinas=d.id;
 
-- 20) Código y teléfonos de los departamentos de las oficinas de la región 'Centro'.
SELECT telefonos.id, telefonos.numero_telefono FROM departamento_oficinas 
inner join telefonos on departamento_oficinas.id_telefono = telefonos.id 
INNER JOIN oficinas on departamento_oficinas.id_oficina=oficinas.id WHERE 
oficinas.id_departamento BETWEEN '11'AND '13';

-- 21) Nombre del empleado y departamento de Guatemala en el que trabaja
SELECT e.nombre, departamentos_guate.nombre_departamento As departamento fROM  departamento_oficinas 
INNER JOIN empleados AS e ON e.id_departamento_oficinas=departamento_oficinas.id 
INNER JOIN oficinas on departamento_oficinas.id_oficina= oficinas.id 
INNER JOIN departamentos_guate ON oficinas.id_departamento = departamentos_guate.id;

-- 22) Sueldo de cada empleado y sus bonificaciones.
SELECT e.nombre, T.sueldo_base,T.bonificacion_ley,T.bonificacion_empresa From empleados AS e
INNER JOIN tipo_empleados AS T ON e.id_tipo_empleado=T.id;

-- 23) Nombre de los empleados y de sus jefes de departamento. en este caso solo hay un jefe de la empresa
SELECT empleados.nombre, "Eduardo" From empleados;

-- 24) Suma del sueldo de los empleados, sin la bonificación 
SELECT sum(tipo_empleados.sueldo_base) AS "sueldos unidos" FROM empleados AS e 
INNER JOIN tipo_empleados on e.id_tipo_empleado= tipo_empleados.id;

-- 25) Promedio del sueldo, sin contar bonificación
SELECT avg(tipo_empleados.sueldo_base)AS "Promedio" FROM empleados AS e 
INNER JOIN tipo_empleados on e.id_tipo_empleado= tipo_empleados.id;

-- 26) Salario máximo y mínimo de los empleados, incluyendo bonificación.
SELECT empleados.nombre, max(T.sueldo_base) From empleados 
INNER JOIN tipo_empleados AS T ON empleados.id_tipo_empleado= T.id;

SELECT empleados.nombre, MIN(T.sueldo_base) From empleados 
INNER JOIN tipo_empleados AS T ON empleados.id_tipo_empleado= T.id;

-- 27)Número de empleados que superan los 40 años.
SELECT count(empleados.edad) From empleados Where edad >40;

-- 28) Número de edades diferentes que tienen los empleados. en este caso los 10 empleados tienene edad diferente
SELECT COUNT(edad) From empleados;



