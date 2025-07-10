SELECT * FROM r_Prods where UAProdName like '%&Ч%'

SELECT * FROM r_Prods where Notes like '%&Ч%'

--замена ' &Ч' в поле Notes
update r_Prods
set Notes = REPLACE(Notes ,' &Ч','') 
from r_Prods
where Notes like '% &Ч%'

--замена ' &Ч' в поле UAProdName
update r_Prods
set UAProdName = REPLACE(UAProdName ,' &Ч','') 
from r_Prods
where UAProdName like '% &Ч%'