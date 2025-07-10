set role owner;
select current_user;
--drop function public.get_postal_code_by_address_id;
create or replace function public.get_country_name_by_address_id (
	param_address_id int4
) returns table (
	country_name varchar(80)	
)
language sql
volatile
as
$$
select country_name from xaddress x where id = param_address_id; --2277806
$$;

select * from public.get_country_name_by_address_id(2277806);
select public.get_country_name_by_address_id(2277806);