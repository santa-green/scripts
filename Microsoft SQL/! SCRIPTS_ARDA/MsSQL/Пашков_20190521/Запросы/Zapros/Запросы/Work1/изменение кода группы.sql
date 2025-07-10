use otdata
select *
from r_prods r
where r.pgrid = 98--  код группы
	and r.pgrid1 = 3-- старый код отдела 
--	and  r.prodname like 'конфет%' -- наимеенование товара если надо
--это была выборка - убеждаешс€ что выт€гиват те товары в которых надо помен€ть код группы на новый 


update r_prods  -- обновление собственно
set r_prods.pgrid1 = --новый код отдела
from r_prods r
where r.pgrid = -- код группы
	and r.pgrid1 = --старый код отдела 
--	and  r.prodname like 'конфет%' -- наимеенование товара если надо
 
