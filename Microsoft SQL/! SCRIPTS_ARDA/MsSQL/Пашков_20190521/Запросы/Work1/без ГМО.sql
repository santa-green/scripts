use otdata 
select *
from r_prods 
where prodname like '% вес' or prodname like '% кг'
--- выборка весовых товаров

-- ниже обновление имени товара 
update r_prods 
	set r_prods.prodname =  r_prods.prodname + ' (б/гмо)'

from r_prods 
where prodname like '% вес' or prodname like '% кг'