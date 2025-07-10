--SELECT * FROM t_SaleTemp where CRID = 777
--SELECT * FROM t_SaleTemp where DocState = 0
--SELECT * FROM r_CRs
--SELECT * FROM r_ProdMP ORDER BY BDate desc

SELECT td.SrcPosID, td.ProdID, td.Qty, td.SumCC_wt, p.ProdName, mp.PriceMC, mp.PromoPriceCC,mp.BDate, mp.EDate,* FROM t_SaleTempD td 
join r_Prods p on p.ProdID = td.ProdID and p.UM = td.UM
join r_ProdMP mp on mp.ProdID = td.ProdID  and mp.PLID = td.PLID
where td.ChID in (SELECT t.ChID FROM t_SaleTemp t where t.DocState = 0 and t.CRID = 777)


