-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS bd_getitgym;

-- Seleccionar la base de datos
USE bd_getitgym;

-- Crear la tabla de administradores
CREATE TABLE IF NOT EXISTS administradores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(200) NOT NULL
);

-- Insertar un administrador por defecto
INSERT INTO administradores (usuario, password)
VALUES ('admin', 'admin123');

-- Tabla de tipos de clases
CREATE TABLE clases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
);

INSERT INTO clases(nombre, descripcion) VALUES
('Zumba', 'Clase intensa de baile y cardio'),
('Box', 'Entrenamiento de boxeo para condición física'),
('Yoga', 'Práctica de estiramiento y relajación'),
('HIT', 'Entrenamiento de alta intensidad'),
('Crossfit', 'Entrenamiento funcional avanzado');

-- Tabla de tipos de pases / suscripciones
CREATE TABLE suscripciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

INSERT INTO suscripciones(tipo, precio) VALUES
('diario', 50),
('semanal', 250),
('mensual', 800),
('trimestral', 2000),
('anual', 7000);

-- Tabla de clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    edad INT,
    objetivos TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Relación cliente → clase elegida
CREATE TABLE clases_cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_clase INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    FOREIGN KEY (id_clase) REFERENCES clases(id)
);

-- Relación cliente → suscripción
CREATE TABLE suscripciones_cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_suscripcion INT NOT NULL,
    fecha_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_fin DATE NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    FOREIGN KEY (id_suscripcion) REFERENCES suscripciones(id)
);


