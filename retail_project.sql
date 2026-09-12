-- ddl estructura de tablas
create table clientes (
id serial primary key,
email varchar(100) unique not null,
edad_cliente integer check (edad_cliente > 0)
);


create table productos (
id serial primary key,
precio decimal check (precio > 0),
stock integer check (stock >= 0)
);

create table ventas (
id serial primary key,
id_cliente integer references clientes (id),
id_producto integer references productos (id)
);

-- Dml datos y mmantenimiento
begin;
INSERT INTO clientes (email, edad_cliente)
VALUES  ('matias@gmail.com', 35),
        ('ramiro@hotmail.com', 40),
        ('carolina@hotmail.com', 42),
        ('gen@gmail.com', 23),
        ('mielcita@hotmail.com', 33);


INSERT INTO productos (precio, stock)
  values (1000, 3),
         (8000, 0),
         (12000, 5),
         (7000, 20),
         (9000, 3);

INSERT INTO ventas (id_cliente, id_producto)
VALUES  (1, 2),
        (2, 1),
        (3, 4),
        (4, 3),
        (5, 5);

commit;

-- Update masivo
update productos
set precio = (precio * 1.10)
where precio >= 8000;

-- DELETE de un registro de prueba
INSERT INTO clientes (email, edad_cliente)
values ('seguros@oficina.com', 62);

delete from clientes 
where id = 6;

-- Previsualizacion de tablas
select * from clientes;
select * from productos;
select * from ventas;





        
