drop function if exists sum_n_product;
create or replace function public.sum_n_product(x int, y int, out sum1 int, out prod1 int) as $$
begin
    sum1 := x + y;
    prod1 := x * y;
end;
$$ language plpgsql;

drop function if exists sum_n_product;
create or replace function public.sum_n_product(x int, y int, out sum1 int, out prod1 int) 
language plpgsql	
as $$
begin
    sum1 := x + y;
    prod1 := x * y;
end;
$$;

--select sum_n_product (2, 3);
select * from sum_n_product (2, 3);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* netkey_user_check_2 */
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
set role owner;
select current_user;

select * from netkey_user_check_2(param_user_id := 258175);

drop function netkey_user_check_2;

create or replace
function public.netkey_user_check_2 (
	in param_user_id int4
) returns table (
	id int4,
	customer_id int4,
	login citext,
	first_name varchar(40),
	last_name varchar(80),
	email varchar(80),
	mobile varchar(40),
	entity_status char(1))
language sql
volatile
	as 
	$function_netkey_user_check$
select
	id,
	customer_id,
	login,
	first_name,
	last_name,
	email,
	mobile,
	entity_status
from
	user0
where
	id = param_user_id
/*--UNION	
union
select
	id,
	customer_id,
	login,
	first_name,
	last_name,
	email,
	mobile,
	entity_status
from
	user0
where
	first_name ilike CONCAT('%', first_name, '%')
	and last_name ilike CONCAT('%', last_name, '%')
	and entity_status = 'A'
--UNION	
union
select
	id,
	customer_id,
	login,
	first_name,
	last_name,
	email,
	mobile,
	entity_status
from
	user0
where
	last_name ilike CONCAT('%', first_name, '%')
	and first_name ilike CONCAT('%', last_name, '%')
	and entity_status = 'A'
--UNION	
union
select
	id,
	customer_id,
	login,
	first_name,
	last_name,
	email,
	mobile,
	entity_status
from
	user0
where
	first_name ilike CONCAT('%', first_name, '%')
	and last_name ilike '%Bekey%'
	and entity_status = 'A'
--UNION	
union
select
	id,
	customer_id,
	login,
	first_name,
	last_name,
	email,
	mobile,
	entity_status
from
	user0
where
	email ilike CONCAT('%', 
        replace(replace(replace(first_name, 'æ', 'ae'), 'ø', 'oe'), 'å', 'aa'),
        '%', 
        replace(replace(replace(last_name, 'æ', 'ae'), 'ø', 'oe'), 'å', 'aa'),
        '%')
	and entity_status = 'A'*/
$function_netkey_user_check$
