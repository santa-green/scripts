do $$ 
declare
   counter    integer := 1;
   first_name varchar(50) := 'John';
   last_name  varchar(50) := 'Doe';
   payment    numeric(11,2) := 20.5;
   query text := (select actor_id from actor a limit 1);
begin 
   raise notice '% % % has been paid % USD + %', 
       counter, 
	   first_name, 
	   last_name, 
	   payment,
	   query;
end $$;


do 
$test$
declare
   test_count integer;
begin 
   select count(*) into test_count from actor a ;
   raise notice 'The number of films: %', test_count; --% is a placeholder.
end;
$test$

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* column_type */
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from address;
do $$ 
<<first_block>>
--you can use either := or = assignment operator to initialize and assign a value to a variable.
declare test_count int4 = 120; --integer, numeric, varchar, and char.
declare col_variable address.id%type = 555; --integer, numeric, varchar, and char.
begin
	raise notice E'The count is: % \nHere goes address id: %', test_count, col_variable;
end first_block $$;