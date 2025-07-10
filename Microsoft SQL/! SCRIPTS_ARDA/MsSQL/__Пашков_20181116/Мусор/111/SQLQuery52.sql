
SELECT d.ProdID, d.PPID, d.Qty,SrcDocID, OurID, StockID, d.* FROM t_CRRet m
JOIN t_CRRetD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE m.ChiD = 100000624
ORDER BY DocDate desc



SELECT d.ProdID, d.PPID, d.Qty, d.* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE m.DocID = 100013884 and OurID = 6 and StockID = 1201
ORDER BY 1
