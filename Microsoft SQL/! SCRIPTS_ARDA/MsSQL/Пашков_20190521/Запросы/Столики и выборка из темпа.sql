
select r.* 
from t_SaleTemp t join r_Desks r on t.DeskCode = r.DeskCode
where StockID = 1310


select r.ProdName , t.* 
from t_SaleTempD  t join r_Prods r on t.ProdID = r.ProdID
WHERE t.ChID in (select ChID from t_SaleTemp where StockID = 1310)
order by ChID
