select * from Elit.dbo.t_Rem where ProdID in (
select ExtProdID  from r_Prods r 
join r_ProdEC e on r.ProdID = e.ProdID
where PGrID4 = 8 )and StockID =1130