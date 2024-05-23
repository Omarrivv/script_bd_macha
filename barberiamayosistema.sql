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
-- Eliminar la tabla pagos si existe
DROP TABLE IF EXISTS pagos;
-- Crear la tabla pagos con la columna hora_pago
CREATE TABLE pagos (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_cita INT,
    corte_realizado NVARCHAR(100),
    monto DECIMAL(10, 2),
    fecha_pago DATE,
    hora_pago TIME, -- Nueva columna para la hora del pago
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita)
);
select * from citas;
select * from pagos;
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

SELECT * FROM usuario;
SELECT * FROM citas;
SELECT id_cita, fecha, hora, nota, estado, id_cliente, id_barbero FROM citas WHERE estado = 'pendiente';
SELECT * FROM productos;
INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol)
VALUES 
('dni', '72681114', 'Omar', 'Rivera', '930720474', 'omar.rivera@example.com', 'omartruewhilelove', 'cliente')
select * from usuario;
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
INSERT INTO pagos (id_cita, corte_realizado, monto, fecha_pago)
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

SELECT id_usuario, tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, rol FROM usuario WHERE numeroDeDocumento = 72681118 AND rol = 'cliente'

select * from usuario;
select * from citas;

