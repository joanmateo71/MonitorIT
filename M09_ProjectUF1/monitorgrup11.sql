CREATE DATABASE monitoritgrup11;

USE monitoritgrup11;

CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY, 
    nombre VARCHAR(50) NOT NULL, 
    apellido VARCHAR(50) NOT NULL,
    numero_telefono VARCHAR(15)
);

CREATE TABLE maquinas (
    id_cliente INT, 
    tipo_ordenador VARCHAR(10) NOT NULL, 
    sistema_operativo VARCHAR(10) NOT NULL, 
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) 
);


