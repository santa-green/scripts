SELECT * FROM r_Prods where UAProdName like '%&A N%'

	SELECT  ds.ProdID, SUM(Qty) FROM t_Sale ms JOIN t_SaleD ds ON ds.ChID = ms.ChID
	WHERE ms.DocDate between '2018-05-01' and '2018-05-16' and ms.CodeID1 = 63 and ms.CodeID3 <> 89 and ms.OurID = 6
	group by ds.ProdID
	ORDER BY 2
	
	
	
	SELECT distinct p.* FROM t_Sale m
	JOIN t_SaleD d ON d.ChID = m.ChID
	JOIN r_Prods p ON p.ProdID = d.ProdID
	WHERE m.DocDate between '2017-05-01' and '2018-05-16' and m.CodeID1 = 63 and m.CodeID3 <> 89 and m.OurID = 6
	and (p.ProdID between 600001 and 604999	or p.ProdID between 800000 and 809999)
	and p.PGrID4 = 2
	and p.PGrID2 = 40014
	
	--group by d.ProdID

	ORDER BY 2
	
	
	--список наборов
	SELECT * FROM Elitdistr.dbo.r_ProdEC ec 
	where ISNUMERIC(ExtProdID) = 1 and CompID = 10793 
	and cast(ProdID as bigint) between 634000 and 635000
	ORDER BY 1

	--список наборов
	SELECT * FROM Elitdistr.dbo.r_ProdEC ec 
	where ISNUMERIC(ExtProdID) = 1 and CompID = 10793 
	and cast(ProdID as bigint) between 634000 and 635000
	ORDER BY 1

--найти код маркета по коду элитки	
SELECT top 1 ExtProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and CompID = 10793  and ec.ProdID = 32465