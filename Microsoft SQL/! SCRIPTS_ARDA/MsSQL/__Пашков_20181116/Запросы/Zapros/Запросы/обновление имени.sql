select * 
from r_Prods
where ProdName like '%''%'  or Notes like '%''%' or UAProdName like '%''%' 
/*
UPDATE r_Prods
SET ProdName = REPLACE (ProdName , '''' , '`') , Notes = REPLACE (Notes , '''' , '`') , UAProdName = REPLACE (UAProdName , '''' , '`')
FROM r_Prods   
WHERE ProdName like '%''%'  or Notes like '%''%' or UAProdName like '%''%' 
*/



