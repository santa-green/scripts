--Имя категории	Товар	Имя товара	Вес	Норма 1	УКТ ВЭД посл	Опт. индикативная стоимость, ОВ	Розн. индикативная стоимость, ОВ

select 
p.PCatID,
(select pc.PCatName PCatName from r_ProdC pc where pc.PCatID = p.PCatID) 'Имя категории',
ProdID,
ProdName,
Weight,
Norma1,
(select top 1 pp.CstProdCode  from t_PInP pp where pp.ProdID = p.ProdID and len(pp.CstProdCode) > 1 order by PPID desc) 'УКТ ВЭД посл',
IndRetPriceCC,
IndWSPriceCC
--,* 
from r_Prods p
where p.PCatID in (9,99,8,5,49,34,38,16,24,14,15,18,26,17,11,32,7,3,1,4,12,6,19,10,2)
order by 1



