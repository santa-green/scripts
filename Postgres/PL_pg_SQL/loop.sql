do $$
begin
   for cnt in reverse 10..1 loop
    raise notice 'cnt: %', cnt;
--   perform cnt;
   end loop;
end; $$

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*  */
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
set role owner;
drop table if exists employees ;
CREATE TABLE employees (
  employee_id serial PRIMARY KEY,
  full_name VARCHAR NOT NULL,
  manager_id INT
);
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
 
  select * from employees e ;
  
do $$
declare rec record;
begin
	for rec in 
		select * from employees order by employee_id desc limit 10
	loop
		raise notice '% - %', rec.employee_id, rec.full_name;
	end loop;
end; $$

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*  */
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
do $$
declare
    -- sort by 1: employee_id , 2: length of name 
    sort_type smallint := 1; 
    -- return the number of films
    rec_count int := 10;
    -- use to iterate over the film
    rec record;
    -- dynamic query
    query text;
begin
        
    query := 'select full_name, employee_id from employees ';
    
    if sort_type = 1 then
        query := query || 'order by employee_id desc ';
    elsif sort_type = 2 then
      query := query || 'order by length(full_name) desc ';
    else 
       raise 'invalid sort type %s', sort_type;
    end if;

    query := query || ' limit $1';

    for rec in execute query using rec_count
        loop
         raise notice '% - %', rec.employee_id, rec.full_name;
    end loop;
end;
$$
