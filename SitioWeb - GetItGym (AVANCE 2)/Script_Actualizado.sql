CREATE DATABASE IF NOT EXISTS `bd_getitgym`
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `bd_getitgym`;

-- =========================
-- TABLA ADMINISTRADORES
-- =========================
DROP TABLE IF EXISTS `administradores`;
CREATE TABLE `administradores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario` varchar(100) NOT NULL,
  `password` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario` (`usuario`)
);

INSERT INTO administradores VALUES
(1,'admin','admin123');

-- =========================
-- TABLA CLASES
-- =========================
DROP TABLE IF EXISTS `clases`;
CREATE TABLE `clases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255),
  PRIMARY KEY (`id`)
);

CREATE TABLE instructores (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    especialidad VARCHAR(100),
    activo TINYINT(1) DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY email (email)
);

CREATE TABLE instructores_clases (
    id INT NOT NULL AUTO_INCREMENT,
    id_instructor INT NOT NULL,
    id_clase INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_instructor) REFERENCES instructores(id),
    FOREIGN KEY (id_clase) REFERENCES clases(id)
);



INSERT INTO clases VALUES
(1,'Zumba','Clase intensa de baile y cardio'),
(2,'Box','Entrenamiento de boxeo para condición física'),
(3,'Yoga','Práctica de estiramiento y relajación'),
(4,'HIT','Entrenamiento de alta intensidad'),
(5,'Crossfit','Entrenamiento funcional avanzado'),
(6,'Yoga','Mejora la flexibilidad y reduce el estrés'),
(7,'Zumba','Ejercicio cardiovascular con baile'),
(8,'Box','Resistencia física y coordinación'),
(9,'Crossfit','Entrenamiento funcional completo'),
(10,'HIIT','Rutinas cortas de alta intensidad'),
(11,'Spinning','Cardio intenso en bicicleta estática');

-- =========================
-- TABLA CLIENTES
-- =========================
DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `telefono` varchar(20),
  `edad` int,
  `objetivos` text,
  `fecha_registro` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
);

INSERT INTO clientes (id,nombre,email,telefono,edad,objetivos) VALUES
(1,'Ana García','ana@gmail.com','555-1010',25,'Bajar de peso'),
(2,'Carlos Ruiz','carlos@hotmail.com','555-2020',30,'Ganar masa muscular'),
(3,'Lucía Mendez','lucia@yahoo.com','555-3030',28,'Tonificar'),
(4,'Roberto Gomez','beto@gmail.com','555-4040',35,'Salud general'),
(5,'Juan Pérez','juan@gmail.com','555-1111',27,'Bajar de peso'),
(6,'María López','maria@gmail.com','555-1112',24,'Tonificar'),
(7,'Pedro Sánchez','pedro@gmail.com','555-1113',32,'Ganar músculo'),
(8,'Laura Torres','laura@gmail.com','555-1114',29,'Salud'),
(9,'Miguel León','miguel@gmail.com','555-1115',35,'Resistencia'),
(10,'Sofía Cruz','sofia@gmail.com','555-1116',22,'Flexibilidad'),
(11,'Andrés Moreno','andres@gmail.com','555-1117',40,'Salud general'),
(12,'Valeria Ruiz','valeria@gmail.com','555-1118',26,'Bajar estrés'),
(13,'Diego Ramírez','diego@gmail.com','555-1119',31,'Condición física'),
(14,'Paola Hernández','paola@gmail.com','555-1120',23,'Tonificar'),
(15,'Hugo Flores','hugo@gmail.com','555-1121',38,'Fuerza'),
(16,'Fernanda Díaz','fer@gmail.com','555-1122',28,'Resistencia');

-- =========================
-- TABLA CLASES_CLIENTE
-- =========================
DROP TABLE IF EXISTS `clases_cliente`;
CREATE TABLE `clases_cliente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `id_clase` int NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_cliente`) REFERENCES clientes(id),
  FOREIGN KEY (`id_clase`) REFERENCES clases(id)
);

INSERT INTO clases_cliente (id_cliente,id_clase) VALUES
(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),
(7,2),(8,2),(9,2),(10,2),
(11,3),(12,3),(13,3),(14,3),
(15,4),(16,4),(1,4),(2,4),
(3,5),(4,5),(5,5),(6,5),
(7,6),(8,6),
(9,7),(10,7),
(11,8),(12,8),
(13,9),(14,9),
(15,10),(16,10),
(1,11),(2,11);

-- =========================
-- TABLA SUSCRIPCIONES
-- =========================
DROP TABLE IF EXISTS `suscripciones`;
CREATE TABLE `suscripciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO suscripciones VALUES
(1,'diario',50.00),
(2,'semanal',250.00),
(3,'mensual',800.00),
(4,'trimestral',2000.00),
(5,'anual',7000.00);

-- =========================
-- TABLA SUSCRIPCIONES_CLIENTE
-- =========================
DROP TABLE IF EXISTS `suscripciones_cliente`;
CREATE TABLE `suscripciones_cliente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `id_suscripcion` int NOT NULL,
  `fecha_inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_fin` date,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_cliente`) REFERENCES clientes(id),
  FOREIGN KEY (`id_suscripcion`) REFERENCES suscripciones(id)
);

INSERT INTO suscripciones_cliente (id_cliente,id_suscripcion,fecha_fin) VALUES
(1,3,'2026-01-20'),
(2,3,'2026-01-20'),
(3,4,'2026-03-20'),
(4,2,'2025-12-20'),
(5,5,'2026-11-20'),
(6,3,'2026-01-20'),
(7,1,'2025-11-30'),
(8,3,'2026-01-20'),
(9,4,'2026-03-20'),
(10,2,'2025-12-20'),
(11,5,'2026-11-20'),
(12,3,'2026-01-20');

INSERT INTO instructores(nombre,email,telefono,especialidad) VALUES
('Juan Pérez','juan@gym.com','555-9001','Fuerza'),
('María López','maria@gym.com','555-9002','Cardio'),
('Carlos Soto','carlos@gym.com','555-9003','Yoga'),
('Laura Reyes','laura@gym.com','555-9004','Crossfit');

INSERT INTO instructores_clases(id_instructor,id_clase) VALUES
(1,2), -- Juan → Box
(1,5), -- Juan → Crossfit
(2,1), -- María → Zumba
(2,4), -- María → HIIT
(3,3), -- Carlos → Yoga
(4,5); -- Laura → Crossfit

