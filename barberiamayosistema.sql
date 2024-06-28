USE master ;  
GO  
DROP DATABASE barberiamacha;  
GO
-- Crear la base de datos
CREATE DATABASE barberiamacha;
GO
USE barberiamacha;
GO

select * from categorias
go

SELECT id_usuario, tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, rol FROM usuario WHERE activo = 1;
go

-- Crear las tablas (con restricciones adicionales)

CREATE TABLE usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    tipoDeDocumento NVARCHAR(50) CHECK (tipoDeDocumento IN ('dni', 'cne')),
    numeroDeDocumento NVARCHAR(20),
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    celular NVARCHAR(9) CHECK (celular LIKE '9%' AND LEN(celular) = 9),
    email NVARCHAR(100) UNIQUE CONSTRAINT CK_EmailFormato CHECK (email LIKE '%@%.%'),
    password NVARCHAR(100),
    rol NVARCHAR(50) CHECK (rol IN ('cliente', 'admin', 'barbero')),
    activo BIT DEFAULT 1,
    CONSTRAINT CK_NumeroDeDocumento CHECK (
        (tipoDeDocumento = 'dni' AND LEN(numeroDeDocumento) = 8) OR
        (tipoDeDocumento = 'cne' AND LEN(numeroDeDocumento) = 12)
    )
);
-- Primero, eliminamos la restricción de longitud para el campo numeroDeDocumento
ALTER TABLE usuario
DROP CONSTRAINT CK_NumeroDeDocumento;

use barberiamacha;
go

select * from usuario;

-- SELECT * FROM usuario WHERE rol = 'barbero' WHERE activo = 1;


SELECT * FROM usuario WHERE rol = 'barbero' AND activo = 1;



-- Luego, modificamos el tipo de datos del campo numeroDeDocumento a NVARCHAR(20)
ALTER TABLE usuario
ALTER COLUMN numeroDeDocumento NVARCHAR(20);

-- A continuación, agregamos la restricción actualizada CK_NumeroDeDocumento
ALTER TABLE usuario
ADD CONSTRAINT CK_NumeroDeDocumento CHECK (
    (tipoDeDocumento = 'dni' AND LEN(numeroDeDocumento) = 8) OR
    (tipoDeDocumento = 'cne' AND LEN(numeroDeDocumento) BETWEEN 9 AND 20)
);
use barberiamacha;
select * from sys.tables;

-- Asegurarse de que los valores actuales en los campos `numeroDeDocumento`, `celular` y `email` sean únicos antes de crear las restricciones únicas
-- Esto es necesario para evitar errores si hay valores duplicados existentes.
-- Primero, agregamos un índice único a `numeroDeDocumento`
ALTER TABLE usuario
ADD CONSTRAINT UQ_NumeroDeDocumento UNIQUE (numeroDeDocumento);

SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'usuario';


-- Luego, agregamos un índice único a `celular`
ALTER TABLE usuario
ADD CONSTRAINT UQ_Celular UNIQUE (celular);


-- Insertar un usuario administrador
INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol, activo)
VALUES ('DNI', '72681115', 'Omar Felix', 'Rivera Rosas', '930720474', 'admin@omar.com', 'omar123', 'admin', 1);

-- Insertar tres usuarios barberos
INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol, activo)
VALUES ('DNI', '23456789', 'barbero richard', 'macha', '923456789', 'richard@example.com', 'barberopassword1', 'barbero', 1);

INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol, activo)
VALUES ('DNI', '34567890', 'barbero Jhon', 'Jhon', '934567890', 'michell@example.com', 'barberopassword2', 'barbero', 1);

INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol, activo)
VALUES ('DNI', '45678901', 'barbero Benjamin', 'Benjamin', '945678901', 'harol@example.com', 'barberopassword3', 'barbero', 1);

INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol, activo)
VALUES ('DNI', '90987654', 'barbero Jose', 'Jose', '900789122', 'jhon@example.com', 'barberopassword3', 'barbero', 1);

INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol, activo)
VALUES ('DNI', '09876534', 'barbero Michell', 'Michell', '905670901', 'benjamin@example.com', 'barberopassword3', 'barbero', 1);

select * from usuario;

-- Insertar dos usuarios clientes
INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol, activo)
VALUES ('DNI', '90874562', 'alondra', 'algod', '900896345', 'alexandra@example.com', 'adefree', 'cliente', 1);

INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol, activo)
VALUES ('DNI', '09239087', 'cristianio', 'ronaldo', '902387069', 'paolofifa@gmail.com', 'paologuerreroorejasxd', 'cliente', 1);

drop table citas;

select * from usuario;

-- Verificar el máximo ID actual
SELECT MAX(id_usuario) FROM usuario;

-- Ajustar la secuencia si es necesario
DBCC CHECKIDENT ('usuario', RESEED, 8);

CREATE TABLE citas (
    id_cita INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    nota VARCHAR(100),
    estado NVARCHAR(50) CHECK (estado IN ('pendiente', 'cancelado', 'terminado')),
    id_cliente INT NOT NULL,
    id_barbero INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_barbero) REFERENCES usuario(id_usuario)
);

SELECT * FROM citas;

DROP TABLE IF EXISTS citas;
GO


SELECT id_cita, fecha, hora, nota, estado, id_cliente, id_barbero FROM citas WHERE estado = 'pendiente'

-- Eliminar la tabla pagos si existe
DROP TABLE IF EXISTS pagos;

CREATE TABLE pagos (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_cita INT NOT NULL,
    corte_realizado NVARCHAR(100) NOT NULL,
    monto DECIMAL(10, 2) NOT NULL CHECK (monto > 0), -- Asegurar que el monto sea positivo
    fecha_pago DATE NOT NULL,
    hora_pago TIME NOT NULL, -- Nueva columna para la hora del pago
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita)
);

select * from pagos;

select * from sys.tables;

ALTER TABLE pagos
ADD status INT DEFAULT 1;


select * from usuario;

select * from citas;

select * from usuario;

select * from pagos;

select * from sys.tables;

/*CREATE TABLE productos (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    imagen NVARCHAR(255),
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX),
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0), -- Asegurar que el precio sea positivo
    categoria NVARCHAR(50) NOT NULL CHECK (categoria IN ('cabello', 'maquina', 'locion', 'accesorio')), -- Restricción de categoría
    estado INT DEFAULT 1 -- Campo estado con valor predeterminado de 1 (activo)
);
*/
---------------------------------------------------------

CREATE TABLE categorias (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL UNIQUE
);

-- Insertar algunas categorías iniciales
INSERT INTO categorias (nombre) VALUES ('cabello');
INSERT INTO categorias (nombre) VALUES ('maquina');
INSERT INTO categorias (nombre) VALUES ('locion');
INSERT INTO categorias (nombre) VALUES ('accesorio');

select * from categorias;

-- Quitar la restricción de la columna categoria
/*ALTER TABLE productos
DROP CONSTRAINT CK_Categoria;
*/
-- Cambiar la columna categoria a id_categoria
/*ALTER TABLE productos
DROP COLUMN categoria;

ALTER TABLE productos
ADD id_categoria INT;*/

-- Agregar la relación de clave foránea a la tabla categorias
/*ALTER TABLE productos
ADD CONSTRAINT FK_Productos_Categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria);*/
-----------------------------------------------------

-- Eliminar la tabla productos si existe (solo si es necesario)
DROP TABLE IF EXISTS productos;

-- Crear la tabla productos con la nueva estructura
CREATE TABLE productos (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    imagen NVARCHAR(255),
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX),
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0), -- Asegurar que el precio sea positivo
    id_categoria INT NOT NULL, -- Clave foránea a la tabla categorías
    estado INT DEFAULT 1, -- Campo estado con valor predeterminado de 1 (activo)
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);


select * from productos;

-- Seleccionar todos los productos junto con el nombre de su categoría
SELECT p.id_producto, p.imagen, p.nombre, p.descripcion, p.precio, c.nombre AS categoria, p.estado
FROM productos p
JOIN categorias c ON p.id_categoria = c.id_categoria;


--------------------------------------------


-- DROP TABLE productos;
SELECT DISTINCT id_categoria FROM productos

-- Insertar un producto con todas las columnas especificadas
INSERT INTO productos (imagen, nombre, descripcion, precio, id_categoria) 
VALUES ('descarga.jpeg', 'goku black malvado', 'Black Mask Goku samas xd', 35.90, 1); -- 1 corresponde a 'cabello'

select * from productos

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

-- selecciona el id_cita , fecha , hora , nota , estado , nombre cliente  aperllido cliente . nombre barbero , apellido barbero es un join para saber con q barbero le cortara para saber a disponiblidad y mas

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

INSERT INTO citas (fecha, hora, nota, estado, id_cliente, id_barbero)
VALUES 
('2024-06-01', '10:00:00', 'Corte de cabello', 'pendiente', 1, 2),
('2024-06-02', '14:00:00', 'Afeitado', 'pendiente', 1, 2);

INSERT INTO pagos (id_cita, corte_realizado, monto, fecha_pago)
VALUES 
(1, 'Corte de cabello', 25.00, '2024-06-01');

-- Usuarios
SELECT * FROM usuario;
-- Citas
SELECT * FROM citas;
-- Pagos
SELECT * FROM pagos;
-- Productos
SELECT * FROM productos;
-- Usuarios

SELECT id_usuario, tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, rol FROM usuario WHERE numeroDeDocumento = 72681118 AND rol = 'cliente'

SELECT id_usuario, tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, rol FROM usuario WHERE activo = 0;

-- Esta consulta nos permitirá obtener la información del barbero que realizó el corte, el cliente, el monto pagado y cualquier otro detalle necesario

SELECT 
    p.id_pago,
    p.id_cita,
    p.corte_realizado,
    p.monto,
    p.fecha_pago,
    p.hora_pago,
    u_cliente.nombre AS nombre_cliente,
    u_cliente.apellido AS apellido_cliente,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_cliente ON c.id_cliente = u_cliente.id_usuario
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario;


SELECT 
    u_barbero.id_usuario AS id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero,
    SUM(p.monto) AS sueldo_total
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario
GROUP BY 
    u_barbero.id_usuario, u_barbero.nombre, u_barbero.apellido;



	SELECT 
    p.id_pago,
    p.id_cita,
    p.corte_realizado,
    p.monto,
    p.fecha_pago,
    p.hora_pago,
    c.id_cliente,
    u_cliente.nombre AS nombre_cliente,
    u_cliente.apellido AS apellido_cliente,
    c.id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_cliente ON c.id_cliente = u_cliente.id_usuario
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario;



SELECT 
    p.id_pago,
    p.id_cita,
    p.corte_realizado,
    p.monto,
    p.fecha_pago,
    p.hora_pago,
    c.id_cliente,
    u_cliente.nombre AS nombre_cliente,
    u_cliente.apellido AS apellido_cliente,
    c.id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero,
    p.monto * 0.60 AS sueldo_barbero
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_cliente ON c.id_cliente = u_cliente.id_usuario
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario;

-- Para calcular el sueldo total de cada barbero, agrupar por el barbero y sumar el monto correspondiente al 60% del pago:

SELECT 
    u_barbero.id_usuario AS id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero,
    SUM(p.monto * 0.60) AS sueldo_total
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario
GROUP BY 
    u_barbero.id_usuario, u_barbero.nombre, u_barbero.apellido;


-- Detalle de cada pago con el 60% del monto para el barbero
SELECT 
    p.id_pago,
    p.id_cita,
    p.corte_realizado,
    p.monto,
    p.fecha_pago,
    p.hora_pago,
    c.id_cliente,
    u_cliente.nombre AS nombre_cliente,
    u_cliente.apellido AS apellido_cliente,
    c.id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero,
    p.monto * 0.60 AS sueldo_barbero
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_cliente ON c.id_cliente = u_cliente.id_usuario
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario;

-- Sueldo total por barbero
SELECT 
    u_barbero.id_usuario AS id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero,
    SUM(p.monto * 0.60) AS sueldo_total
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario
GROUP BY 
    u_barbero.id_usuario, u_barbero.nombre, u_barbero.apellido;




-- Definir variables para el rango de fechas
DECLARE @fecha_inicio DATE = '2024-06-01';
DECLARE @fecha_fin DATE = '2024-06-15';

-- Consulta para calcular el sueldo quincenal de cada barbero
SELECT 
    u_barbero.id_usuario AS id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero,
    SUM(p.monto * 0.60) AS sueldo_total
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario
WHERE 
    p.fecha_pago BETWEEN @fecha_inicio AND @fecha_fin
GROUP BY 
    u_barbero.id_usuario, u_barbero.nombre, u_barbero.apellido;



-- Definir variables para el rango de fechas
DECLARE @fecha_inicio DATE = '2024-06-01';
DECLARE @fecha_fin DATE = '2024-06-15';

-- Consulta para obtener los detalles de cada corte y el pago correspondiente para el barbero
SELECT 
    p.id_pago,
    p.fecha_pago,
    p.hora_pago,
    p.corte_realizado,
    p.monto,
    p.monto * 0.60 AS sueldo_barbero,
    c.fecha AS fecha_cita,
    c.hora AS hora_cita,
    u_cliente.nombre AS nombre_cliente,
    u_cliente.apellido AS apellido_cliente,
    u_barbero.id_usuario AS id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_cliente ON c.id_cliente = u_cliente.id_usuario
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario
WHERE 
    p.fecha_pago BETWEEN @fecha_inicio AND @fecha_fin
ORDER BY 
    u_barbero.id_usuario, p.fecha_pago, p.hora_pago;







-- Obtener todos los pagos activos con el 60% del monto para el barbero
SELECT 
    p.id_pago,
    p.id_cita,
    p.corte_realizado,
    p.monto,
    p.fecha_pago,
    p.hora_pago,
    c.fecha AS fecha_cita,
    c.hora AS hora_cita,
    u_cliente.nombre AS nombre_cliente,
    u_cliente.apellido AS apellido_cliente,
    u_barbero.id_usuario AS id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero,
    p.monto * 0.60 AS sueldo_barbero
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_cliente ON c.id_cliente = u_cliente.id_usuario
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario
WHERE 
    p.status = 1;

-- Obtener todos los pagos inactivos
SELECT 
    p.id_pago,
    p.id_cita,
    p.corte_realizado,
    p.monto,
    p.fecha_pago,
    p.hora_pago,
    c.fecha AS fecha_cita,
    c.hora AS hora_cita,
    u_cliente.nombre AS nombre_cliente,
    u_cliente.apellido AS apellido_cliente,
    u_barbero.id_usuario AS id_barbero,
    u_barbero.nombre AS nombre_barbero,
    u_barbero.apellido AS apellido_barbero
FROM 
    pagos p
JOIN 
    citas c ON p.id_cita = c.id_cita
JOIN 
    usuario u_cliente ON c.id_cliente = u_cliente.id_usuario
JOIN 
    usuario u_barbero ON c.id_barbero = u_barbero.id_usuario
WHERE 
    p.status = 0;




--Reporte Resumen
SELECT u_barbero.id_usuario AS id_barbero, u_barbero.nombre AS nombre_barbero, u_barbero.apellido AS apellido_barbero, SUM(p.monto * 0.60) AS sueldo_total FROM pagos p JOIN citas c ON p.id_cita = c.id_cita JOIN usuario u_barbero ON c.id_barbero = u_barbero.id_usuario WHERE p.fecha_pago BETWEEN ? AND ? GROUP BY u_barbero.id_usuario, u_barbero.nombre, u_barbero.apellido


--Reporte Detallado
SELECT p.id_pago, p.fecha_pago, p.hora_pago, p.corte_realizado, p.monto, p.monto * 0.60 AS sueldo_barbero, c.fecha AS fecha_cita, c.hora AS hora_cita, u_cliente.nombre AS nombre_cliente, u_cliente.apellido AS apellido_cliente, u_barbero.id_usuario AS id_barbero, u_barbero.nombre AS nombre_barbero, u_barbero.apellido AS apellido_barbero FROM pagos p JOIN citas c ON p.id_cita = c.id_cita JOIN usuario u_cliente ON c.id_cliente = u_cliente.id_usuario JOIN usuario u_barbero ON c.id_barbero = u_barbero.id_usuario WHERE p.fecha_pago BETWEEN ? AND ? ORDER BY u_barbero.id_usuario, p.fecha_pago, p.hora_pago

