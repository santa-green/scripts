CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2),
    creation_date DATE,
    last_update DATE
);

select * from employees;

INSERT INTO employees (name, salary, creation_date, last_update)
VALUES ('John Doe', 50000, '2023-01-01', '2023-01-01');

INSERT INTO employees (name, salary, creation_date, last_update)
VALUES ('Jane Smith', 60000, '2023-01-02', '2023-01-02');

INSERT INTO employees (name, salary, creation_date, last_update)
VALUES ('Emily Johnson', 55000, '2023-01-03', '2023-01-03');

create or replace function update_last_update_column()
returns trigger as
$$
begin
	new.last_update = current_date; --updates the last_update column.
	return new;
end;
$$ language plpgsql;

-- attach the function to the table.
create trigger udpate_last_update
before update on employees
for each row
execute function update_last_update_column(); 

SELECT * FROM employees;

UPDATE employees SET name ='John Snow' WHERE id=1 returning *;




----------------------------------------------------------------------------------------------------
/* audit table */
----------------------------------------------------------------------------------------------------
create table audit_log (
    log_id SERIAL primary key,
    employee_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_date TIMESTAMP default CURRENT_TIMESTAMP
);

create or replace function log_salary_change()
returns trigger as 
$$
begin
	if old.salary is distinct from new.salary then
	insert into audit_log (employee_id, old_salary, new_salary) 
		values (new.id, old.salary, new.salary);
	end if;
	return new;	
end;
$$ language plpgsql;

create trigger trigger_audit_salary_change
after update of salary on employees
for each row
execute function log_salary_change();

SELECT * FROM audit_log;
select * from employees;
UPDATE employees SET salary= 70000 WHERE name ='Jane Smith';

--check_salary_before_insert
create or replace function check_salary_before_insert()
returns trigger as
$$
begin
	if new.salary < 1000 then
		raise exception 'Salary should be at least 2000!';
	end if;
	return new;
end;
$$ language plpgsql;

create trigger trigger_check_salary_before_insert
before insert on employees
for each row
execute function check_salary_before_insert();

INSERT INTO employees (name, salary, creation_date, last_update)
VALUES ('Test Employee', 150, CURRENT_DATE, CURRENT_DATE);

----------------------------------------------------------------------------------------------------
/* AFTER triggers */
----------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION log_salary_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.salary IS DISTINCT FROM NEW.salary THEN
        INSERT INTO audit_log (employee_id, old_salary, new_salary)
        VALUES (NEW.id, OLD.salary, NEW.salary);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_salary_changes_trigger
AFTER UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_changes();


CREATE TRIGGER log_salary_changes_trigger
AFTER UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_changes();

-- This should log the salary change
UPDATE employees SET salary = 55000 WHERE id = 1;
select * from employees;

----------------------------------------------------------------------------------------------------
/* INSTEAD OF triggers (views only!) */
----------------------------------------------------------------------------------------------------

CREATE VIEW employee_salary_view AS SELECT id, salary FROM employees;

CREATE OR REPLACE FUNCTION update_salary_through_view()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE employees SET salary = NEW.salary WHERE id = NEW.id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_salary_view_trigger
/*Allow updates to the salary field through*/
INSTEAD OF UPDATE ON employee_salary_view
FOR EACH ROW
EXECUTE FUNCTION update_salary_through_view();

-- This should update the salary through the view
UPDATE employee_salary_view SET salary = 60000 WHERE id = 1;
select * from employee_salary_view;
select * from employees;


----------------------------------------------------------------------------------------------------
/* row-level */
----------------------------------------------------------------------------------------------------
--FOR EACH ROW

----------------------------------------------------------------------------------------------------
/* statement-level */
----------------------------------------------------------------------------------------------------
--FOR EACH STATEMENT

CREATE TABLE bulk_update_log (
    log_id SERIAL PRIMARY KEY,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by TEXT
);

select * from bulk_update_log;

CREATE OR REPLACE FUNCTION log_bulk_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO bulk_update_log (updated_by)
    VALUES (CURRENT_USER);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_bulk_update_trigger
AFTER UPDATE ON employees
FOR EACH STATEMENT
EXECUTE FUNCTION log_bulk_update();

-- This should log the bulk update operation
UPDATE employees SET salary = salary * 1.05;

|log_id|update_time            |updated_by|
|------|-----------------------|----------|
|1     |2025-07-07 17:20:11.687|postgres  |

