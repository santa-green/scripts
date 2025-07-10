
select r.ProdName  ,r.prodid  ,CAST ( ROUND ( p.PriceMC*100 ,0)as int ) , r.prodid
from r_Prods  r join r_ProdMP p on r.ProdID = p.ProdID 
where r.PGrID = 50086 and p.PriceMC >0 and PLID = 71 and r.ProdID ! = 605318
order by r.ProdID 