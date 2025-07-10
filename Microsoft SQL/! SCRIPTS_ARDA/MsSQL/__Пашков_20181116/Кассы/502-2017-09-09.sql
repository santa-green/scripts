SELECT * FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
join t_SalePays sp on sp.ChID = m.ChID
WHERE m.crid = 502 and DocDate = dbo.zf_GetDate(GETDATE()) 
and DocID = 100021955
ORDER BY 1

SELECT * FROM t_SalePays where ChID = 100508868

SELECT * FROM t_MonRec where OurID = 6 and DocID = 100021955

--10752,380000000 наличка
SELECT distinct m.* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
--JOIN r_Prods p ON p.ProdID = d.ProdID
join t_SalePays sp on sp.ChID = m.ChID
WHERE m.crid = 502 and DocDate = '2017-09-09'
and sp.PayFormCode = 1
--and DocID = 100021955
ORDER BY 1

--6241,850000000 безнал + сертификат
SELECT distinct m.* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
--JOIN r_Prods p ON p.ProdID = d.ProdID
join t_SalePays sp on sp.ChID = m.ChID
WHERE m.crid = 502 and DocDate = '2017-09-09'
and sp.PayFormCode = 2
--and DocID = 100021955
ORDER BY 1

