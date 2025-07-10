--список товаров для весов из базы ElitR 
USE ElitR
SELECT * FROM dbo.r_Scales

----список товаров для весов днепра2 нагорка ScaleID = 61 (192.168.42.181)
--SELECT * FROM OPENQUERY([LOCALHOST],
--'EXEC ElitR.dbo.t_SaleSrvGetScalesProds 61 ')
----where ProdID = 600524

--список товаров для весов днепра1  ScaleID = 62 (192.168.70.102)
SELECT * FROM OPENQUERY([LOCALHOST],
'EXEC ElitR.dbo.t_SaleSrvGetScalesProds 62 ')
--where ProdID = 600524

--список товаров для весов Киева ScaleID = 63  (192.168.174.103)
SELECT * FROM OPENQUERY([LOCALHOST],
'EXEC ElitR.dbo.t_SaleSrvGetScalesProds 63 ')
--where ProdID = 604044

--список товаров для весов Харькова ScaleID = 64  (192.168.126.106)
SELECT * FROM OPENQUERY([LOCALHOST],
'EXEC ElitR.dbo.t_SaleSrvGetScalesProds 64 ')
--where ProdID = 604044

SELECT PLU,ProdID,ProdName,BarCode,UM,PriceCC_wt,ScaleComponents FROM OPENQUERY([LOCALHOST],'EXEC ElitR.dbo.t_SaleSrvGetScalesProds 64 ') ORDER BY 1




----старый список товаров для весов Киева ScaleID = 5  (192.168.74.103)
--SELECT * FROM [s-marketa2].elitv_kiev.dbo.r_Scales

--SELECT * FROM OPENQUERY([s-marketa2],
--'EXEC elitv_kiev.dbo.t_SaleSrvGetScalesProds 5 ')
----where ProdID = 600524


----старый список товаров для весов днепра1 ScaleID = 2  (192.168.70.102)
--SELECT * FROM [s-marketa].elitv_dp.dbo.r_Scales

--SELECT * FROM OPENQUERY([s-marketa],
--'EXEC elitv_dp.dbo.t_SaleSrvGetScalesProds 2 ')
--WHERE ProdID = 600524


--SELECT * FROM OPENQUERY([s-marketa2],'EXEC elitv_kiev.dbo.t_SaleSrvGetScalesProds 5 ')

/*
--список проданых товаров для весов Киева ScaleID = 63  (192.168.174.103)
SELECT * FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE m.StockID = 1243
and d.ProdID in (SELECT ProdID FROM OPENQUERY([LOCALHOST],'EXEC ElitR.dbo.t_SaleSrvGetScalesProds 63 '))
ORDER BY m.DocDate desc

*/