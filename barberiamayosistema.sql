-- Crear la base de datos
CREATE DATABASE barberiamacha;
GO
USE barberiamacha;
GO
-- Crear las tablas (con restricciones adicionales)
CREATE TABLE usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    tipoDeDocumento NVARCHAR(50) CHECK (tipoDeDocumento IN ('dni', 'cne')),
    numeroDeDocumento NVARCHAR(20),
    nombre NVARCHAR(100),
    apellido NVARCHAR(100),
    celular NVARCHAR(9) CHECK (celular LIKE '9%'),
    email NVARCHAR(100) CONSTRAINT CK_EmailFormato CHECK (email LIKE '%@%.%'),
    password NVARCHAR(100),
    rol NVARCHAR(50) CHECK (rol IN ('cliente', 'admin', 'barbero'))
);
select * from usuario;
CREATE TABLE citas (
    id_cita INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE,
    hora TIME,
    nota VARCHAR(100),
    estado NVARCHAR(50) CHECK (estado IN ('pendiente', 'cancelado', 'terminado')),
    id_cliente INT,
    id_barbero INT,
    FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_barbero) REFERENCES usuario(id_usuario)
);
SELECT * FROM citas;
SELECT id_cita, fecha, hora, nota, estado, id_cliente, id_barbero FROM citas WHERE estado = 'pendiente'
CREATE TABLE pagos (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_cita INT,
    corteRealizado NVARCHAR(100),
    monto DECIMAL(10, 2),
    fechaPago DATE,
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita)
);
CREATE TABLE productos (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    imagen NVARCHAR(255),
    nombre NVARCHAR(100),
    descripcion NVARCHAR(MAX),
    precio DECIMAL(10, 2)
);
SELECT * FROM productos;
SELECT 
    c.id_cita,
    u_cliente.nombre AS nombre_cliente,
    u_cliente.apellido AS apellido_cliente,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero,
    c.fecha,
    c.hora,
    c.estado,
    c.nota
FROM 
    citas c
JOIN 
    usuario u_cliente ON c.id_cliente = u_cliente.id_usuario
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario;

SELECT id_cita, fecha, hora, nota, estado, id_cliente, id_barbero FROM citas WHERE estado = 'pendiente'


SELECT 
    c.id_cita,
    c.fecha,
    c.hora,
    c.nota,
    c.estado,
    uc.nombre AS nombre_cliente,
    uc.apellido AS apellido_cliente,
    ub.nombre AS nombre_barbero,
    ub.apellido AS apellido_barbero
FROM 
    citas c
JOIN 
    usuario uc ON c.id_cliente = uc.id_usuario
JOIN 
    usuario ub ON c.id_barbero = ub.id_usuario
WHERE 
    c.estado = 'pendiente';

CREATE TABLE usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    tipoDeDocumento NVARCHAR(50) CHECK (tipoDeDocumento IN ('dni', 'cne')) NOT NULL,
    numeroDeDocumento NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    celular NVARCHAR(9) CHECK (celular LIKE '9%') NOT NULL,
    email NVARCHAR(100) CONSTRAINT CK_EmailFormato CHECK (email LIKE '%@%.%') NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL,
    rol NVARCHAR(50) CHECK (rol IN ('cliente', 'admin', 'barbero')) NOT NULL,
    CONSTRAINT UQ_Documento UNIQUE (tipoDeDocumento, numeroDeDocumento) -- Unicidad del documento
);
CREATE TABLE citas (
    id_cita INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    nota NVARCHAR(100),
    estado NVARCHAR(50) CHECK (estado IN ('pendiente', 'cancelado', 'terminado')) NOT NULL,
    id_cliente INT NOT NULL,
    id_barbero INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_barbero) REFERENCES usuario(id_usuario),
    CHECK (id_cliente <> id_barbero) -- Asegura que el cliente no sea el mismo que el barbero
);
CREATE TABLE pagos (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_cita INT NOT NULL,
    corteRealizado NVARCHAR(100) NOT NULL,
    monto DECIMAL(10, 2) CHECK (monto > 0) NOT NULL,
    fechaPago DATE NOT NULL,
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita),
    CONSTRAINT UQ_PagoCita UNIQUE (id_cita) -- Asegura que solo hay un pago por cita
);
CREATE TABLE productos (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    imagen NVARCHAR(255) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX) NOT NULL,
    precio DECIMAL(10, 2) CHECK (precio > 0) NOT NULL,
    CONSTRAINT UQ_NombreProducto UNIQUE (nombre) -- Asegura que no haya dos productos con el mismo nombre
);
SELECT * FROM usuario;
SELECT * FROM citas;
SELECT id_cita, fecha, hora, nota, estado, id_cliente, id_barbero FROM citas WHERE estado = 'pendiente';
SELECT * FROM productos;

INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol)
VALUES 
('dni', '12345678', 'Juan', 'Perez', '912345678', 'juan.perez@example.com', 'password123', 'cliente'),
('dni', '87654321', 'Maria', 'Gomez', '987654321', 'maria.gomez@example.com', 'password456', 'barbero'),
('cne', 'A1234567', 'Carlos', 'Lopez', '923456789', 'carlos.lopez@example.com', 'password789', 'admin');

UPDATE usuario
SET nombre = 'Juan Carlos', apellido = 'Pérez Gómez'
WHERE id_usuario = 1;

DELETE FROM usuario
WHERE id_usuario = 3;

INSERT INTO citas (fecha, hora, nota, estado, id_cliente, id_barbero)
VALUES 
('2024-06-01', '10:00:00', 'Corte de cabello', 'pendiente', 1, 2),
('2024-06-02', '14:00:00', 'Afeitado', 'pendiente', 1, 2);

UPDATE citas
SET estado = 'terminado'
WHERE id_cita = 1;

DELETE FROM citas
WHERE id_cita = 2;

INSERT INTO pagos (id_cita, corteRealizado, monto, fechaPago)
VALUES 
(1, 'Corte de cabello', 25.00, '2024-06-01');

UPDATE pagos
SET monto = 30.00
WHERE id_pago = 1;

DELETE FROM pagos
WHERE id_pago = 1;

INSERT INTO productos (imagen, nombre, descripcion, precio)
VALUES 
('imagen1.jpg', 'Shampoo', 'Shampoo para cabello seco', 15.00),
('imagen2.jpg', 'Gel', 'Gel para peinado', 10.00);

UPDATE productos
SET precio = 12.00
WHERE id_producto = 2;

DELETE FROM productos
WHERE id_producto = 1;


-- Usuarios
INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol)
VALUES ('dni', '12345679', 'Ana', 'Torres', '923456780', 'ana.torres@example.com', 'password321', 'cliente');

-- Citas
INSERT INTO citas (fecha, hora, nota, estado, id_cliente, id_barbero)
VALUES ('2024-06-03', '11:00:00', 'Corte de barba', 'pendiente', 1, 2);

-- Pagos
INSERT INTO pagos (id_cita, corteRealizado, monto, fechaPago)
VALUES (1, 'Corte de barba', 20.00, '2024-06-03');

-- Productos
INSERT INTO productos (imagen, nombre, descripcion, precio)
VALUES ('imagen3.jpg', 'Cera', 'Cera para peinado', 8.00);

-- Usuarios
SELECT * FROM usuario;

-- Citas
SELECT * FROM citas;

-- Pagos
SELECT * FROM pagos;

-- Productos
SELECT * FROM productos;


-- Usuarios
UPDATE usuario
SET celular = '999999999'
WHERE id_usuario = 1;

-- Citas
UPDATE citas
SET estado = 'cancelado'
WHERE id_cita = 1;

-- Pagos
UPDATE pagos
SET monto = 22.00
WHERE id_pago = 1;

-- Productos
UPDATE productos
SET precio = 9.00
WHERE id_producto = 3;


-- Usuarios
DELETE FROM usuario
WHERE id_usuario = 4;

-- Citas
DELETE FROM citas
WHERE id_cita = 3;

-- Pagos
DELETE FROM pagos
WHERE id_pago = 2;

-- Productos
DELETE FROM productos
WHERE id_producto = 2;


