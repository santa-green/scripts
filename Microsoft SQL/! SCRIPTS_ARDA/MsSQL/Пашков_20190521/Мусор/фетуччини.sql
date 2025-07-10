SELECT d.Qty,* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE d.ProdID = 607861
and m.DocDate > '2018-05-27'
and Docid = 165126
ORDER BY 1


SELECT qty,* FROM t_sale_R
WHERE ProdID = 607861 and Docid = 165126
and DocDate > '2018-05-27'

213

100585940