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

