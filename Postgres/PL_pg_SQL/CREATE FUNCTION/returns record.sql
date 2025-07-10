set role owner;
--DROP FUNCTION test_kirl(text,text);
DROP FUNCTION if exists test_kirl;

create or replace function test_kirl (
	in a text,
	in b text)
returns record
--returns text
as 
$$
declare ret record;
--declare ret text;
begin
--	select id from unit into ret limit 2;
	select a || ' test ' || b || ' 2nd', id, status, created_date from unit into ret limit 2;
--	select ' 2nd', id from unit limit 2;
	return ret;
end;
$$
language plpgsql;

select test_kirl('H', 'B'); --works for text and record.
select * from test_kirl('H', 'B'); --works for text return type.


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* https://www.geeksforgeeks.org/postgresql-record-type-variable/ */
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Example 1*/
create table employees (
	employee_id serial primary key,
	full_name VARCHAR not null,
	manager_id INT
);

select * from employees;

INSERT INTO employees (
employee_id,
full_name,
manager_id
)
VALUES
(1, 'M.S Dhoni', NULL),
(2, 'Sachin Tendulkar', 1),
(3, 'R. Sharma', 1),
(4, 'S. Raina', 1),
(5, 'B. Kumar', 1),
(6, 'Y. Singh', 2),
(7, 'Virender Sehwag ', 2),
(8, 'Ajinkya Rahane', 2),
(9, 'Shikhar Dhawan', 2),
(10, 'Mohammed Shami', 3),
(11, 'Shreyas Iyer', 3),
(12, 'Mayank Agarwal', 3),
(13, 'K. L. Rahul', 3),
(14, 'Hardik Pandya', 4),
(15, 'Dinesh Karthik', 4),
(16, 'Jasprit Bumrah', 7),
(17, 'Kuldeep Yadav', 7),
(18, 'Yuzvendra Chahal', 8),
(19, 'Rishabh Pant', 8),
(20, 'Sanju Samson', 8);

do
$$
declare
rec1 record;

begin
-- select the employee  
select
	employee_id,
	full_name,
	manager_id
into
	rec1
from
	employees
where
	employee_id = 13;

raise notice '% - %(Manager id=%)',
	rec1.employee_id,
	rec1.full_name,
	rec1.manager_id;
end;
$$
language plpgsql;


/*Example 2*/
do
$$
declare
rec1 record;

begin
for rec1 in
select
	employee_id,
	full_name
from
	employees
where
	employee_id > 12
order by
	employee_id
loop
 raise notice '% - %',
	rec1.employee_id,
	rec1.full_name;
end loop;
end;

$$;

