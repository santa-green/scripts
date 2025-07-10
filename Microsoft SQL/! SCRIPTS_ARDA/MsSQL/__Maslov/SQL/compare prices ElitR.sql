SELECT *, 'S-marketa' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [s-marketa].elitv_dp.dbo.r_ProdMP
) m

SELECT *, 'S-marketa4' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [s-marketa4].ElitRTS181.dbo.r_ProdMP
) m

SELECT *, 'S-marketa3' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [s-marketa3].ElitRTS301.dbo.r_ProdMP
) m

SELECT *, 'Харьков 302' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [192.168.157.22].ElitRTS302.dbo.r_ProdMP
) m

SELECT *, 'Интернет-магазин' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [192.168.174.30].ElitRTS201.dbo.r_ProdMP 
) m

SELECT *, 'Киев 174.30' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [192.168.174.38].ElitRTS220.dbo.r_ProdMP
) m

SELECT *, 'Кофепоинт МОСТ СИТИ' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP --WHERE ProdID = 70815
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [192.168.42.6].FFood601.dbo.r_ProdMP --WHERE ProdID = 70815
) m


DECLARE @DbID INT
SET @DBID = 2
SELECT COUNT(m.ChID) 'In range', (SELECT COUNT(ChID) FROM [s-marketa].elitv_dp.dbo.t_Sale) 'Qty of sales', (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) 'ChID Start', (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID) 'ChID End'
FROM [s-marketa].elitv_dp.dbo.t_Sale m
WHERE m.ChID >= (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) AND m.ChID <= (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID)

SET @DBID = 12
SELECT COUNT(m.ChID) 'In range', (SELECT COUNT(ChID) FROM [s-marketa4].ElitRTS181.dbo.t_Sale) 'Qty of sales', (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) 'ChID Start', (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID) 'ChID End'
FROM [s-marketa4].ElitRTS181.dbo.t_Sale m
WHERE m.ChID >= (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) AND m.ChID <= (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID)

SET @DBID = 9
SELECT COUNT(m.ChID) 'In range', (SELECT COUNT(ChID) FROM [s-marketa3].ElitRTS301.dbo.t_Sale) 'Qty of sales', (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) 'ChID Start', (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID) 'ChID End'
FROM [s-marketa3].ElitRTS301.dbo.t_Sale m
WHERE m.ChID >= (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) AND m.ChID <= (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID)

SET @DBID = 11
SELECT COUNT(m.ChID) 'In range', (SELECT COUNT(ChID) FROM [192.168.157.22].ElitRTS302.dbo.t_Sale) 'Qty of sales', (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) 'ChID Start', (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID) 'ChID End'
FROM [192.168.157.22].ElitRTS302.dbo.t_Sale m
WHERE m.ChID >= (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) AND m.ChID <= (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID)

SET @DBID = 8
SELECT COUNT(m.ChID) 'In range', (SELECT COUNT(ChID) FROM [192.168.174.30].ElitRTS201.dbo.t_Sale) 'Qty of sales', (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) 'ChID Start', (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID) 'ChID End'
FROM [192.168.174.30].ElitRTS201.dbo.t_Sale m
WHERE m.ChID >= (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) AND m.ChID <= (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID)

SET @DBID = 16
SELECT COUNT(m.ChID) 'In range', (SELECT COUNT(ChID) FROM [192.168.174.38].ElitRTS220.dbo.t_Sale) 'Qty of sales', (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) 'ChID Start', (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID) 'ChID End'
FROM [192.168.174.38].ElitRTS220.dbo.t_Sale m
WHERE m.ChID >= (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) AND m.ChID <= (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID)

SET @DBID = 17
SELECT COUNT(m.ChID) 'In range', (SELECT COUNT(ChID) FROM [192.168.42.6].FFood601.dbo.t_Sale) 'Qty of sales', (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) 'ChID Start', (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID) 'ChID End'
FROM [192.168.42.6].FFood601.dbo.t_Sale m
WHERE m.ChID >= (SELECT ChID_Start FROM r_DBIs WHERE DBiID = @DBID) AND m.ChID <= (SELECT ChID_End FROM r_DBIs WHERE DBiID = @DBID)

SELECT * FROM [s-marketa].elitv_dp.dbo.t_Sale m WHERE m.ChID NOT IN (SELECT ChID FROM t_Sale ts WHERE ts.DocTime = m.DocTime)
SELECT * FROM [s-marketa4].ElitRTS181.dbo.t_Sale m WHERE m.ChID NOT IN (SELECT ChID FROM t_Sale ts WHERE ts.DocTime = m.DocTime)
SELECT * FROM [s-marketa3].ElitRTS301.dbo.t_Sale m WHERE m.ChID NOT IN (SELECT ChID FROM t_Sale ts WHERE ts.DocTime = m.DocTime)
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_Sale m WHERE m.ChID NOT IN (SELECT ChID FROM t_Sale ts WHERE ts.DocTime = m.DocTime)
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_Sale m WHERE m.ChID NOT IN (SELECT ChID FROM t_Sale ts WHERE ts.DocTime = m.DocTime)
SELECT * FROM [192.168.174.38].ElitRTS220.dbo.t_Sale m WHERE m.ChID NOT IN (SELECT ChID FROM t_Sale ts WHERE ts.DocTime = m.DocTime)
SELECT * FROM [192.168.42.6].FFood601.dbo.t_Sale m WHERE m.ChID NOT IN (SELECT ChID FROM t_Sale ts WHERE ts.DocTime = m.DocTime)

/*
SELECT m.ProdID, m.PLID, m.InUse, m.PromoPriceCC, m.BDate, m.EDate, rmp.BDate 'Base BDate', rmp.EDate 'Base EDate', m.PriceMC 'Store Price', rmp.PriceMC 'Base Price', m.PriceMC-rmp.PriceMC 'Diff' FROM (
SELECT DISTINCT d.ProdID, rmp.PLID, rmp.PriceMC, rmp.InUse, rmp.PromoPriceCC, rmp.BDate, rmp.EDate
FROM [s-marketa].elitv_dp.dbo.t_Sale m JOIN [s-marketa].elitv_dp.dbo.t_SaleD d ON m.ChID = d.ChID JOIN [s-marketa].elitv_dp.dbo.r_ProdMP rmp ON rmp.ProdID = d.ProdID
UNION
SELECT DISTINCT d.ProdID, rmp.PLID, rmp.PriceMC, rmp.InUse, rmp.PromoPriceCC, rmp.BDate, rmp.EDate
FROM [s-marketa4].ElitRTS181.dbo.t_Sale m JOIN [s-marketa4].ElitRTS181.dbo.t_SaleD d ON m.ChID = d.ChID JOIN [s-marketa4].ElitRTS181.dbo.r_ProdMP rmp ON rmp.ProdID = d.ProdID
UNION
SELECT DISTINCT d.ProdID, rmp.PLID, rmp.PriceMC, rmp.InUse, rmp.PromoPriceCC, rmp.BDate, rmp.EDate
FROM [s-marketa3].ElitRTS301.dbo.t_Sale m JOIN [s-marketa3].ElitRTS301.dbo.t_SaleD d ON m.ChID = d.ChID JOIN [s-marketa3].ElitRTS301.dbo.r_ProdMP rmp ON rmp.ProdID = d.ProdID
UNION
SELECT DISTINCT d.ProdID, rmp.PLID, rmp.PriceMC, rmp.InUse, rmp.PromoPriceCC, rmp.BDate, rmp.EDate
FROM [192.168.157.22].ElitRTS302.dbo.t_Sale m JOIN [192.168.157.22].ElitRTS302.dbo.t_SaleD d ON m.ChID = d.ChID JOIN [192.168.157.22].ElitRTS302.dbo.r_ProdMP rmp ON rmp.ProdID = d.ProdID
UNION
SELECT DISTINCT d.ProdID, rmp.PLID, rmp.PriceMC, rmp.InUse, rmp.PromoPriceCC, rmp.BDate, rmp.EDate
FROM [192.168.174.30].ElitRTS201.dbo.t_Sale m JOIN [192.168.174.30].ElitRTS201.dbo.t_SaleD d ON m.ChID = d.ChID JOIN [192.168.174.30].ElitRTS201.dbo.r_ProdMP rmp ON rmp.ProdID = d.ProdID
UNION
SELECT DISTINCT d.ProdID, rmp.PLID, rmp.PriceMC, rmp.InUse, rmp.PromoPriceCC, rmp.BDate, rmp.EDate
FROM [192.168.174.38].ElitRTS220.dbo.t_Sale m JOIN [192.168.174.38].ElitRTS220.dbo.t_SaleD d ON m.ChID = d.ChID JOIN [192.168.174.38].ElitRTS220.dbo.r_ProdMP rmp ON rmp.ProdID = d.ProdID
UNION
SELECT DISTINCT d.ProdID, rmp.PLID, rmp.PriceMC, rmp.InUse, rmp.PromoPriceCC, rmp.BDate, rmp.EDate
FROM [192.168.42.6].FFood601.dbo.t_Sale m JOIN [192.168.42.6].FFood601.dbo.t_SaleD d ON m.ChID = d.ChID JOIN [192.168.42.6].FFood601.dbo.r_ProdMP rmp ON rmp.ProdID = d.ProdID
) m
JOIN r_ProdMP rmp ON rmp.ProdID = m.ProdID
WHERE m.PLID IN (34,70,83,84,85,86) AND (m.PriceMC-rmp.PriceMC) != 0

SELECT * FROM z_Tables ORDER BY TableName;
SELECT 91185 - 57650 = 33535
SELECT * FROM r_PLs
SELECT * FROM r_ProdMP
SELECT * FROM r_Uni WHERE RefTypeID = 1000000007



SELECT ChID FROM [192.168.174.38].ElitRTS220.dbo.t_SaleD m WHERE m.ChID  IN (SELECT DISTINCT ChID FROM t_SaleD)
SELECT ChID FROM [192.168.174.30].ElitRTS201.dbo.t_SaleD m WHERE m.ChID  IN (SELECT DISTINCT ChID FROM t_SaleD)

SELECT * FROM t_SaleD d JOIN t_Sale m ON m.ChID = d.ChID WHERE m.ChID = 100682795
SELECT * FROM [192.168.174.38].ElitRTS220.dbo.t_SaleD d JOIN [192.168.174.38].ElitRTS220.dbo.t_Sale m ON m.ChID = d.ChID WHERE m.ChID = 100682795


SELECT * FROM r_DBIs

SELECT * FROM r_ProdMP WHERE ProdID IN (800360, 601036) AND PLID IN (0,71)
SELECT * FROM [s-marketa3].ElitRTS301.dbo.r_ProdMP WHERE ProdID IN (800360, 601036) AND PLID IN (0,71)

SELECT * FROM [s-marketa4].ElitRTS181.dbo.t_Sale
SELECT * FROM [s-marketa3].ElitRTS301.dbo.t_Sale
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_SaleD
*/