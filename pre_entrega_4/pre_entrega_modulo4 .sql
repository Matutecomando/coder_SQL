
-- Tablas 

CREATE TABLE clientes (
    idcliente INT PRIMARY KEY NOT NULL,
    nombre_cliente VARCHAR(100) NOT NULL
);

CREATE TABLE productos (
    idproducto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    precio NUMERIC(10,2)
);

CREATE TABLE ventas (
    idventa INT PRIMARY KEY,
    id_cliente INT REFERENCES clientes(idcliente),
    id_producto INT REFERENCES productos(idproducto),
    cantidad INT,
    fecha DATE
);

-- Contenido

INSERT INTO clientes (idcliente, nombre_cliente)
VALUES
(1, 'Ana'),
(2, 'Bruno'),
(3, 'Carla'),
(4, 'Diego'),
(5, 'Elena'),
(6, 'Federico');

INSERT INTO productos (idproducto, nombre_producto, categoria, precio)
VALUES
(1, 'Notebook', 'tecnología', 850000.00),
(2, 'Mouse', 'tecnología', 25000.00),
(3, 'Silla', 'hogar', 120000.00),
(4, 'Mesa', 'hogar', 200000.00),
(5, 'Zapatillas', 'indumentaria', 95000.00),
(6, 'Remera', 'indumentaria', 30000.00);

INSERT INTO ventas (idventa, id_cliente, id_producto, cantidad, fecha)
VALUES
(1, 1, 1, 1, '2026-09-01'),
(2, 1, 2, 2, '2026-09-05'),
(3, 2, 3, 2, '2026-09-07'),
(4, 2, 3, 1, '2026-09-12'),
(5, 3, 5, 2, '2026-09-15'),
(6, 3, 6, 3, '2026-09-18'),
(7, 4, 2, 4, '2026-09-20'),
(8, 4, 1, 1, '2026-09-22'),
(9, 1, 2, 3, '2026-09-24'),
(10, 5, 4, 1, '2026-09-25');


-- CONSIGNA 1: RENTABILIDAD POR CATEGORÍA
-- Esta consulta permite conocer cuánto dinero genera cada categoría
-- de productos e identificar las categorías que superan los $100.000
-- en ventas.

SELECT p.categoria,
       SUM(v.cantidad),
       SUM(v.cantidad * p.precio)
FROM ventas v
JOIN productos p
ON v.id_producto = p.idproducto
GROUP BY p.categoria
HAVING SUM(v.cantidad * p.precio) > 100000;

-- CONSIGNA 2: CLIENTES SIN COMPRA
-- Esta consulta permite identificar a los clientes registrados
-- que no realizaron ninguna compra.
-- COALESCE reemplaza el valor NULL de la venta por 0.

SELECT c.nombre_cliente,
       COALESCE(v.idventa, 0) AS idventa
FROM clientes c
LEFT JOIN ventas v
ON v.id_cliente = c.idcliente
WHERE v.id_cliente IS NULL;


-- CONSIGNA 3: TOP DE COMPRAS POR CLIENTE
-- Esta consulta permite identificar el producto que cada cliente
-- compró más veces y conocer la fecha de su última transacción.

WITH producto_mas_comprado AS (

    SELECT c.nombre_cliente,
           p.nombre_producto,
           COUNT(v.idventa) AS cantidad_compras,
           ROW_NUMBER() OVER (
               PARTITION BY c.nombre_cliente
               ORDER BY COUNT(v.idventa) DESC
           ) AS ranking_producto
    FROM ventas v
    JOIN clientes c
    ON v.id_cliente = c.idcliente
    JOIN productos p
    ON v.id_producto = p.idproducto
    GROUP BY c.nombre_cliente, p.nombre_producto

),

ultima_transaccion AS (

    SELECT c.nombre_cliente,
           MAX(v.fecha) AS ultima_fecha
    FROM clientes c
    JOIN ventas v
    ON c.idcliente = v.id_cliente
    GROUP BY c.nombre_cliente

)

SELECT pmc.nombre_cliente,
       pmc.nombre_producto,
       ut.ultima_fecha
FROM producto_mas_comprado pmc
JOIN ultima_transaccion ut
ON pmc.nombre_cliente = ut.nombre_cliente
WHERE pmc.ranking_producto = 1;





