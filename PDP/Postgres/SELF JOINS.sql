-- Create employee table with self-referencing foreign key
CREATE TABLE if not exists employee
(
    id         serial PRIMARY KEY,
    first_name text,
    last_name  text,
    manager_id integer
        CONSTRAINT employee_employee_id_fk
            REFERENCES public.employee(id)
            ON DELETE RESTRICT
);

-- Insert sample data representing employees and their managers
INSERT INTO employee (id, first_name, last_name, manager_id) VALUES
(1, 'Devan', 'Izatt', NULL),
(2, 'Sibyl', 'Nyssens', 1),
(3, 'Franchot', 'Scottrell', 2),
(4, 'Tait', 'Chomicz', 1),
(5, 'Klarrisa', 'Line', 3),
(6, 'Menard', 'McAnellye', 3),
(7, 'Deck', 'Bottjer', 3),
(8, 'Eyde', 'Calvard', 1),
(9, 'Bartolomeo', 'Craine', 8),
(10, 'Leonelle', 'Hammill', 7);

select * from employee;
--The task is for every employee get their manager using SQL syntax
select
	e.first_name || ' ' || e.last_name as employee,
	'>>>' as ">>>",
	coalesce(m.first_name || ' ' || m.last_name, 'TOP manager') as manager
from
	employee e
left join employee m on 
	e.manager_id = m.id;

----------------------------------------------------------------------------------------------------
/* order */
----------------------------------------------------------------------------------------------------
drop table if exists orders;
create table orders
(
    id           serial primary key,
    customer_id  integer,
    order_date   timestamp,
    total_amount integer
);

select * from orders;

-- Insert data into orders table as per provided data
INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(10, 1, '2023-08-08 03:41:57', 786),
(2, 1, '2023-01-31 17:51:49', 34),
(1, 2, '2023-11-19 00:00:22', 120),
(3, 3, '2023-01-23 23:14:27', 534),
(7, 4, '2023-01-11 14:29:08', 3442),
(9, 4, '2023-03-31 22:50:45', 200),
(4, 5, '2023-08-27 11:09:40', 234),
(5, 6, '2023-06-27 08:13:13', 100),
(8, 9, '2023-10-09 03:11:25', 435),
(6, 9, '2023-01-22 18:28:22', 45);

--find out what customers did multiple orders and the later orders was with bigger total_amount
explain analyze
select
	*
from
	orders o1
join orders o2
		using (customer_id)
where
	o1.id <> o2.id
	and o1.order_date > o2.order_date
	and o1.total_amount > o2.total_amount
order by o1.customer_id;

explain analyze
select
    o1.customer_id,
    o1.id as order_id1,
    o2.id as order_id2,
    o1.total_amount as order1_amount,
    o2.total_amount as order2_amount
from orders o1
inner join orders o2 on o1.id <> o2.id
     and o2.order_date > o1.order_date
    and o1.customer_id = o2.customer_id
    and o2.total_amount > o1.total_amount;

----------------------------------------------------------------------------------------------------
/* cross apply (ms sql server) */
----------------------------------------------------------------------------------------------------
-- Full example script demonstrating CROSS APPLY with renamed tables prefixed by 'X'

-- 1. Create XEmployees table
CREATE TABLE XEmployees (
    id INT PRIMARY KEY,
    name NVARCHAR(100)
);

-- 2. Insert sample data into XEmployees
INSERT INTO XEmployees (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- 3. Create XSales table to simulate employee sales
CREATE TABLE XSales (
    sale_id INT PRIMARY KEY,
    employee_id INT,
    sale_amount MONEY,
    sale_date DATE
);

-- 4. Insert sample sales data into XSales
INSERT INTO XSales (sale_id, employee_id, sale_amount, sale_date) VALUES
(1, 1, 500.00, '2023-01-15'),
(2, 1, 700.00, '2023-02-20'),
(3, 2, 300.00, '2023-01-10'),
(4, 3, 450.00, '2023-03-05'),
(5, 3, 650.00, '2023-03-10');

-- 5. Create a table-valued function to get the top sale for an employee
CREATE FUNCTION dbo.GetXEmployeeTopSale(@EmployeeID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1
        sale_amount,
        sale_date
    FROM XSales
    WHERE employee_id = @EmployeeID
    ORDER BY sale_amount DESC
);

-- 6. Query using CROSS APPLY to get each employee with their top sale
select * from xemployees;
select * from xsales;


SELECT
    e.id,
    e.name,
    f.sale_amount,
    f.sale_date
FROM XEmployees e
CROSS APPLY dbo.GetXEmployeeTopSale(e.id) f
ORDER BY e.id;

----------------------------------------------------------------------------------------------------
/* lateral join (postgres) */
----------------------------------------------------------------------------------------------------
-- Example of using LATERAL join in PostgreSQL to get each employee with their top sale

-- 1. Create tables with prefix X to avoid conflicts
CREATE TABLE XEmployees (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE XSales (
    sale_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES XEmployees(id),
    sale_amount NUMERIC,
    sale_date DATE
);

-- 2. Insert sample data
INSERT INTO XEmployees (name) VALUES
('Alice'), ('Bob'), ('Charlie');

INSERT INTO XSales (employee_id, sale_amount, sale_date) VALUES
(1, 500, '2023-01-15'),
(1, 700, '2023-02-20'),
(2, 300, '2023-01-10'),
(3, 450, '2023-03-05'),
(3, 650, '2023-03-10');

-- 3. Query using LATERAL join to get top sale per employee
SELECT
    e.id,
    e.name,
    s.sale_amount,
    s.sale_date
FROM XEmployees e
JOIN LATERAL (
    SELECT sale_amount, sale_date
    FROM XSales
    WHERE employee_id = e.id
    ORDER BY sale_amount DESC
    LIMIT 1
) s ON true
ORDER BY e.id;

select * from xemployees;
select * from xsales;

----------------------------------------------------------------------------------------------------
/* example PDP */
----------------------------------------------------------------------------------------------------
-- Create tables
CREATE TABLE product
(
    id    serial PRIMARY KEY,
    name  text,
    price numeric
);

CREATE TABLE wishlist
(
    id        serial PRIMARY KEY,
    username  text,
    max_price numeric
);

-- Insert data into wishlist
INSERT INTO wishlist (id, username, max_price) VALUES
(1, 'bfligg0', 15.6),
(2, 'oweiser1', 22),
(3, 'adwerryhouse2', 21),
(4, 'slinstead3', 27.2),
(5, 'ahalliday4', 46.5)
returning *;

-- Insert data into product
INSERT INTO product (id, name, price) VALUES
(1, 'bibendum felis sed interdum', 27.2),
(2, 'scelerisque mauris sit amet eros', 95.5),
(3, 'sit amet lobortis sapien sapien', 39),
(4, 'metus vitae ipsum aliquam', 66.8),
(5, 'cursus id turpis integer', 58.7),
(6, 'dignissim vestibulum vestibulum ante ipsum', 77.4),
(7, 'ac neque duis bibendum', 39.1),
(99, 'nulla neque libero convallis', 8.8),
(100, 'blandit ultrices enim', 85.8)
returning *;

--find the top 3 products that satisfy the max price customers are ready to pay. In this case, LATERAL join is beneficial for us since it allows us to pass some value from main SELECT to subquery SELECT.
select * from wishlist;
select * from product order by price;

SELECT *
FROM wishlist AS w,
     LATERAL (SELECT *
              FROM product AS p
              WHERE p.price < w.max_price
              ORDER BY p.price DESC
              LIMIT 3) AS p
ORDER BY w.id, price DESC;

SELECT *
  FROM product AS p
  WHERE p.price < 46.5
  ORDER BY p.price DESC
  LIMIT 3
  
 ----------------------------------------------------------------------------------------------------
 /* example Claude */
 ----------------------------------------------------------------------------------------------------
-- Create test tables
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);
drop table if exists orders cascade;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    amount DECIMAL(10,2),
    order_date DATE
);

-- Insert test data
INSERT INTO customers (name) VALUES 
('Alice'), ('Bob'), ('Charlie');

INSERT INTO orders (customer_id, amount, order_date) VALUES 
(1, 100.00, '2024-01-15'),
(1, 150.00, '2024-01-20'),
(2, 200.00, '2024-01-18'),
(3, 75.00, '2024-01-22'),
(3, 300.00, '2024-01-25'),
(3, 125.00, '2024-01-28');

-- This WORKS - correlated subquery (my example was wrong!)
SELECT c.name, 
       (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) as order_count
FROM customers c;

-- Better example showing LATERAL's advantage:
-- Regular subquery limitation - can't return multiple columns easily
SELECT c.name,
       (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) as order_count,
       (SELECT AVG(amount) FROM orders WHERE customer_id = c.id) as avg_amount,
       (SELECT MAX(order_date) FROM orders WHERE customer_id = c.id) as last_order
FROM customers c;

-- LATERAL join - cleaner for multiple columns
SELECT c.name, stats.*
FROM customers c
LATERAL (
    SELECT COUNT(*) as order_count, 
           AVG(amount) as avg_amount,
           MAX(order_date) as last_order
    FROM orders 
    WHERE customer_id = c.id
) stats;

-- LATERAL's real advantage: set-returning functions
-- This WON'T work with regular subquery
-- SELECT c.name, unnest(ARRAY[1,2,3]) FROM customers c;

-- This WORKS with LATERAL
SELECT c.name, t.value
FROM customers c
LATERAL unnest(ARRAY[c.id, c.id*2, c.id*3]) AS t(value);

-- Another LATERAL advantage: TOP-N per group
SELECT c.name, recent_orders.*
FROM customers c,
LATERAL (
    SELECT amount, order_date
    FROM orders 
    WHERE customer_id = c.id 
    ORDER BY order_date DESC 
    LIMIT 2
) recent_orders;

-- Clean up
DROP TABLE orders;
DROP TABLE customers;
