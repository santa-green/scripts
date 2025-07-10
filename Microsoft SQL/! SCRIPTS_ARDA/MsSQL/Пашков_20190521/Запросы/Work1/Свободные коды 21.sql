USE OTData
SELECT r.ProdID, r.ProdName, p.BarCode, CONVERT (SMALLDATETIME, MAX (q.ProdDate))
FROM r_Prods r
INNER JOIN r_ProdMQ p ON r.ProdID = p.ProdID
INNER JOIN t_Rem t ON r.ProdID = t.ProdID
INNER JOIN t_PInP q ON r.ProdID = q.ProdID
WHERE p.BarCode LIKE '21%'
GROUP BY r.ProdID, r.ProdName, p.BarCode
HAVING SUM (t.Qty) = 0 AND MAX (q.ProdDate) <= getdate () - 120
