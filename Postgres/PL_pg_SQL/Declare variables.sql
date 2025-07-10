WITH myconstants (var1) as (
   values ((select split_part(replace('Vesterbrogade 91C, 1620', ', ', ' '), ' ', 2)))
   )
select 
	substring(var1 from '^[0-9]+') "number",  
	substring(var1 from '[A-Za-z]+$') "letter"
from myconstants;


do 
$$ 
declare
   last_n varchar(30) := 'Agerbæk';
begin 
	perform * from user0 u where last_name = 'Agerbæk';   
end 
$$;

-- choose some prefix that is unlikely to be used by postgres
set session var.last_name = 'Agerbæk';

select *
from user0 u where last_name = current_setting('var.last_name')::varchar(30);


PREPARE usrrptplan (varchar) AS
    select *
from user0 u where u.last_name = $1;
    select *
from user0 u where u.first_name = $1;
EXECUTE usrrptplan($1);
deallocate usrrptplan;


do
$$
begin