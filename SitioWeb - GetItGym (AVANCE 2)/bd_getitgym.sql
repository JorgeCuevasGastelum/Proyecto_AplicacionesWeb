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

-- PENDIENTE TABLA CLIENTES, ENTRENADORES, CLASES, ETC.

