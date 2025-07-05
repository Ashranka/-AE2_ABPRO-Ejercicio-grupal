CREATE DATABASE IF NOT EXISTS alquiler_automoviles;
USE alquiler_automoviles;


CREATE TABLE Alquileres(
    id_alquiler INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_vehiculo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(id_vehiculo)
);

CREATE TABLE Pagos(
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_alquiler INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    FOREIGN KEY (id_alquiler) REFERENCES Alquileres(id_alquiler)
);


INSERT INTO Alquileres (id_alquiler, id_cliente, id_vehiculo, fecha_inicio, fecha_fin) VALUES
(1, 1, 2, '2025-03-10', '2025-03-15'),
(2, 2, 1, '2025-03-12', '2025-03-16'),
(3, 3, 3, '2025-03-20', '2025-03-22');


INSERT INTO Pagos (id_pago, id_alquiler, monto, fecha_pago) VALUES
(1, 1, 150.00, '2025-03-12'),
(2, 2, 112.00, '2025-03-13'),
(3, 3, 70.00, '2025-03-20');

-- CONSULTA 6: Vehículos disponibles en una fecha específica (2025-03-18)
SELECT v.modelo, v.marca, v.precio_dia
FROM Vehiculos v
WHERE v.id_vehiculo NOT IN (
    SELECT DISTINCT a.id_vehiculo
    FROM Alquileres a
    WHERE '2025-03-18' BETWEEN a.fecha_inicio AND a.fecha_fin
);

-- CONSULTA 7: Vehículos alquilados más de una vez en marzo de 2025
SELECT v.marca, v.modelo
FROM Vehiculos v
INNER JOIN Alquileres a ON v.id_vehiculo = a.id_vehiculo
WHERE YEAR(a.fecha_inicio) = 2025 AND MONTH(a.fecha_inicio) = 3
GROUP BY v.id_vehiculo, v.marca, v.modelo
HAVING COUNT(a.id_alquiler) > 1;

-- CONSULTA 8: Total de monto pagado por cada cliente
SELECT
    c.nombre,
    SUM(p.monto) AS total_pagado
FROM Clientes c
INNER JOIN Alquileres a ON c.id_cliente = a.id_cliente
INNER JOIN Pagos p ON a.id_alquiler = p.id_alquiler
GROUP BY c.id_cliente, c.nombre;

-- CONSULTA 9: Clientes que alquilaron el Ford Focus
SELECT
    c.nombre,
    a.fecha_inicio AS fecha_alquiler
FROM Clientes c
INNER JOIN Alquileres a ON c.id_cliente = a.id_cliente
WHERE a.id_vehiculo = 3;

-- CONSULTA 10: Clientes y total de días alquilados (ordenado de mayor a menor)
SELECT
    c.nombre,
    SUM(DATEDIFF(a.fecha_fin, a.fecha_inicio) + 1) AS total_dias_alquilados
FROM Clientes c
INNER JOIN Alquileres a ON c.id_cliente = a.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY total_dias_alquilados DESC;