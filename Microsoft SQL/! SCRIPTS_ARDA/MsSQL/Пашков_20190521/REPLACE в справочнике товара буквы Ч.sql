SELECT * FROM r_Prods where UAProdName like '%&�%'

SELECT * FROM r_Prods where Notes like '%&�%'

--������ ' &�' � ���� Notes
update r_Prods
set Notes = REPLACE(Notes ,' &�','') 
from r_Prods
where Notes like '% &�%'

--������ ' &�' � ���� UAProdName
update r_Prods
set UAProdName = REPLACE(UAProdName ,' &�','') 
from r_Prods
where UAProdName like '% &�%'