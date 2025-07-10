CREATE TABLE employees_foreign (
    id SERIAL PRIMARY KEY,
    name TEXT,
    email TEXT,
    department_id INTEGER,
    salary NUMERIC
);

INSERT INTO employees_foreign (name, email, department_id, salary) VALUES
('John Doe', 'john@example.com', 1, 50000),
('Jane Smith', 'jane@example.com', 2, 60000),
('Alice Johnson', 'alice@example.com', 1, 55000),
('Bob Brown', 'bob@example.com', 3, 45000),
('Carol White', 'carol@example.com', 2, 62000);

select * from employees_foreign;

--function calculate_bonus(salary numeric) that calculates a 10% bonus on the provided salary
create or replace function calculate_bonus (p_salary numeric)
returns numeric
as $$
begin
	return p_salary * 0.1;
end;
$$ language plpgsql;

select *, calculate_bonus(salary) from employees_foreign;

--function department_status(department_id integer) that returns 'Large' if the number of employees in a department is greater than 10, otherwise 'Small'.
create or replace function department_status(p_dep_id integer)
returns text
as $$
declare employee_count int;
begin
	select count(*) into employee_count from employees_foreign where department_id = p_dep_id;
	if employee_count = 1 then return 'small';
	elsif employee_count > 1 then return 'large';
	end if;
end;
$$ language plpgsql;
end


select department_id, count(*) "num_of_employees"
from employees_foreign
group by department_id ;

select * from employees_foreign;
select department_status(1);

----------------------------------------------------------------------------------------------------
/* Aggregate function */
----------------------------------------------------------------------------------------------------
--custom aggregate function total_salaries() that calculates the total salaries of all employees
create or replace function sum_salary(state numeric, salary numeric)
returns numeric
as $$
begin
	return state + salary;
--	select sum(salary) from employees_foreign;
end;
$$ language plpgsql;

--drop aggregate total_salaries(numeric);
create aggregate total_salaries(numeric) (
	SFUNC = sum_salary, 
	STYPE = numeric,
	INITCOND = 0
);

select total_salaries(salary) from employees;

----------------------------------------------------------------------------------------------------
/* Error Handling in Function */
----------------------------------------------------------------------------------------------------
create or replace function safe_divide(numerator numeric, denominator numeric)
returns numeric
as $$
begin
	if denominator = 0 then
		raise exception 'You can''t divide by 0';
	else
		return numerator / denominator;
	end if;
	exception when others then 
--		raise exception '[!] error occurred'; --info, debug, log, warning.
		raise notice '[!] error occurred';
		return null; 
end;
$$ language plpgsql;

select safe_divide(100, 5);
select safe_divide(100, 0);

--string manipulation.
CREATE FUNCTION email_domain(email TEXT) RETURNS TEXT AS $$
BEGIN
    RETURN split_part(email, '@', 2); --extracts the part after the @ in an email address—essentially, it returns the domain.
END;
$$ LANGUAGE PLPGSQL;

SELECT name, email, email_domain(email) AS domain
FROM employees;

--table function:
create or replace function department_employees(dept_id int)
returns setof employees
as $$
begin
	return query select * from employees where id = dept_id;
end;
$$ language plpgsql;

select department_employees(3);