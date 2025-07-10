select d.ProdID from t_sale m
join t_SaleD d on m.ChID = d.ChID
join r_Prods p on d.ProdID = p.ProdID
where p.PGrID6 = 246 
and m.DocDate > '2016-01-01'
and m.StockID = 1201
group by d.ProdID
order by d.ProdID


select d.ProdID, p.ProdName from t_sale m
join t_SaleD d on m.ChID = d.ChID
join r_Prods p on d.ProdID = p.ProdID
where p.PGrID6 = 246 
and m.DocDate > '2016-01-01'
and m.StockID = 1201
group by d.ProdID,p.ProdName 
order by d.ProdID