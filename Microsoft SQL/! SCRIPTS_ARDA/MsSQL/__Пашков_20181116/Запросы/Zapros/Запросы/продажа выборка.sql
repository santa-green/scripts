select r.ProdName , r.PCatID, t.DocDate,t.* 
from t_SaleTempD d 
join t_SaleTemp t on d.ChID = t.ChID
join r_Prods r on d.ProdID = r.ProdID
where t.StockID = 1310
order by ChID
