SELECT * FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE m.ChiD = 800023334
ORDER BY 1


SELECT * FROM [10.1.0.155].ElitR.dbo.t_SaleD where ChiD = 800023334
SELECT * FROM dbo.t_SaleD where ChiD = 800023334

delete [10.1.0.155].ElitR.dbo.t_SaleD where ChiD = 800023334

insert [10.1.0.155].ElitR.dbo.t_SaleD
SELECT * FROM dbo.t_SaleD where ChiD = 800023334