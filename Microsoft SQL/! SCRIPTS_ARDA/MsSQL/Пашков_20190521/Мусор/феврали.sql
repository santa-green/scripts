SELECT * FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE MONTH ( m.DocDate) = 2
--and DeskCode <> 0
and StockID in( 1202)
and DeskCode in (172,177,182,187,192,219,253)
and m.TRealSum > 2000
ORDER BY DocDate desc
--ORDER BY DeskCode desc


SELECT m.DocDate,m.DocID,m.CRID,m.OperID,m.TRealSum,p.ProdID, p.ProdName,d.Qty,d.RealPrice,d.RealSum,* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE MONTH ( m.DocDate) = 2
--and DeskCode <> 0
and StockID in( 1202)
and DeskCode in (172,177,182,187,192,219,253)
and m.TRealSum > 2000
ORDER BY m.DocDate desc, m.DocID
--ORDER BY DeskCode desc

SELECT distinct m.DocID FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE MONTH ( m.DocDate) = 2
--and DeskCode <> 0
and StockID in( 1202)
and DeskCode in (172,177,182,187,192,219,253)
and m.TRealSum > 2000

ORDER BY m.DocDate desc
--ORDER BY DeskCode desc