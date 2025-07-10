set role owner;
select current_user;
drop function if exists public.netkey_user_check;

--table function call ver.1 (preferrable if you have lots of parameters to avoid wrong parameter choice)
select
	*
from
	netkey_user_check(
	param_first_name := 'Sandra',
	param_last_name := 'Le Noble',
	param_mobile := '+31642440248'); 

--table function call ver.2
select
	*
from
	netkey_user_check(
	'Sandra',
	'Le Noble',
	'+31642440248'); 

set role owner;
select current_user;
create or replace
function public.netkey_user_check (
	in param_first_name user0.first_name%type,
	in param_last_name user0.last_name%type,
	in param_mobile user0.mobile%type
) returns table (
	id user0.id%type,
	customer_id user0.customer_id%type,
	login user0.login%type,
	first_name user0.first_name%type,
	last_name user0.last_name%type,
	email user0.email%type,
	mobile user0.mobile%type,
	entity_status char(1)) --in the source table varchar(1) is used - less efficient in our case (with default value).
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
	mobile like (CONCAT('%', replace(param_mobile, ' ', ''), '%'))
	and entity_status = 'A'
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
	first_name ilike CONCAT('%', param_first_name, '%')
	and last_name ilike CONCAT('%', param_last_name, '%')
	and entity_status = 'A'
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
	last_name ilike CONCAT('%', param_first_name, '%')
	and first_name ilike CONCAT('%', param_last_name, '%')
	and entity_status = 'A'
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
	first_name ilike CONCAT('%', param_first_name, '%')
	and last_name ilike '%Bekey%'
	and entity_status = 'A'
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
        replace(replace(replace(param_first_name, 'æ', 'ae'), 'ø', 'oe'), 'å', 'aa'),
        '%', 
        replace(replace(replace(param_last_name, 'æ', 'ae'), 'ø', 'oe'), 'å', 'aa'),
        '%')
	and entity_status = 'A'
$function_netkey_user_check$

