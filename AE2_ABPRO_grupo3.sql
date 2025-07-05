CREATE DATABASE IF NOT EXISTS alquiler_automoviles;
USE alquiler_automoviles;

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(100)
);

INSERT INTO cliente (id_cliente, nombre, telefono, email, direccion) VALUES
(1, 'Juan Pérez', '555-1234', 'juan@mail.com', 'Calle 123'),
(2, 'Laura Gómez', '555-5678', 'laura@mail.com', 'Calle 456'),
(3, 'Carlos Sánchez', '555-9101', 'carlos@mail.com', 'Calle 789');

CREATE TABLE vehiculo (
    id_vehiculo INT PRIMARY KEY,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    año INT,
    precio_dia DECIMAL(10,2)
);
INSERT INTO vehiculo (id_vehiculo, marca, modelo, año, precio_dia) VALUES
(1, 'Toyota', 'Corolla', 2020, 30.00),
(2, 'Honda', 'Civic', 2019, 28.00),
(3, 'Ford', 'Focus', 2021, 35.00);

--Consulta 1: Mostrar el nombre, telefono y email de todos los clientes que tienen un alquiler 
--activo (es decir, cuya fecha actual esté dentro del rango entre fecha_inicio y fecha_fin).

SELECT c.nombre, c.telefono, c.email
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE CURRENT_DATE BETWEEN a.fecha_inicio AND a.fecha_fin;

--Consulta 2: Mostrar los vehículos que se alquilaron en el mes de marzo de 2025. 
--Debe mostrar el modelo, marca, y precio_dia de esos vehículos.

SELECT v.modelo, v.marca, v.precio_dia
FROM alquiler a
JOIN vehiculo v ON a.id_vehiculo = v.id_vehiculo
WHERE MONTH(a.fecha_inicio) = 3 AND YEAR(a.fecha_inicio) = 2025;

--Consulta 3: Calcular el precio total del alquiler para cada cliente, considerando el número de días que alquiló el vehículo (el precio por día 
--de cada vehículo multiplicado por la cantidad de días de alquiler).

SELECT 
c.nombre,
DATEDIFF(a.fecha_fin, a.fecha_inicio) + 1 AS dias_alquiler,
v.precio_dia,
(DATEDIFF(a.fecha_fin, a.fecha_inicio) + 1) * v.precio_dia AS total
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
JOIN vehiculo v ON a.id_vehiculo = v.id_vehiculo;

--Consulta 4: Encontrar los clientes que no han realizado ningún pago (no tienen registros en la tabla Pagos).
-- Muestra su nombre y email

SELECT c.nombre, c.email
FROM cliente c
LEFT JOIN alquiler a ON c.id_cliente = a.id_cliente
LEFT JOIN pago p ON a.id_alquiler = p.id_alquiler
WHERE p.id_pago IS NULL;

--Consulta 5: Calcular el promedio de los pagos realizados por cada cliente.
-- Muestra el nombre del cliente y el promedio de pago.

SELECT c.nombre, AVG(p.monto) AS promedio_pago
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
JOIN pago p ON a.id_alquiler = p.id_alquiler
GROUP BY c.nombre;
