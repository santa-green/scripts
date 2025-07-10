--отчет для кампари
-- [af_CamparyDelivery] [af_CamparyClientsFromDelivery]

DECLARE @StartDate SMALLDATETIME = '2016-12-31' --'2018-08-01' --c 2016-12-31

--Факт-таблица «Остатки складов» Файл Stocks.csv ( остатки на складе).
IF OBJECT_ID (N'dbo.tmp_CamparyStocksInDay', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyStocksInDay
CREATE TABLE [dbo].[tmp_CamparyStocksInDay](
	[StockID] [int] NULL,
	[ProductID] [int] NULL,
	[Data] [smalldatetime] NULL,
	[Qty] [numeric](21, 9) NULL,
	[Summ] [numeric](21, 9) NULL
) 

DECLARE @Date SMALLDATETIME
DECLARE @n INT = - DATEdiff( dd,@StartDate,dbo.zf_GetDate(GETDATE()) )--количество дней до сегодня
	SET @Date = DATEADD( dd,@n,dbo.zf_GetDate(GETDATE()) )
	select @n, @Date
	
	--опорные остатки на конец дня за -n дней назад
	INSERT tmp_CamparyStocksInDay (StockID, ProductID, Data, Qty, Summ)
		SELECT StockID, ProductID,Data,SUM(Qty) Qty,SUM(Summ) Summ  FROM (
			SELECT  d.StockID, d.ProdID ProductID,@Date Data,Qty,Qty*CostCC Summ 
			FROM dbo.zf_t_CalcRemByDateDate(NULL,@Date) d
			JOIN t_pinp pp ON pp.ProdID=d.ProdID and pp.PPID=d.PPID
			JOIN r_Prods ss ON pp.ProdID=ss.ProdID
			WHERE d.StockID IN (4,304,11,311,27,327,85,385,220,320,23,323,16) AND ss.PGrID1 IN (18,20,21,22,23,24,25,26)  AND Qty<>0 
			--and StockID = 4 and d.ProdID = 2159 --для быстрой отадки
		) rem                  
		GROUP BY rem.StockID, rem.ProductID, Data

while @n < 0
Begin
	set @n = @n + 1	
	SET @Date = DATEADD( dd,1,@Date )--увеличить расчетную дату на 1 день
	select @n, @Date
	
	--остатки за один день
	INSERT tmp_CamparyStocksInDay (StockID, ProductID, Data, Qty, Summ)
		SELECT StockID, ProductID,Data,SUM(Qty) Qty,SUM(Summ) Summ  FROM (
			SELECT  d.StockID, d.ProdID ProductID,@Date Data,Qty,Qty*CostCC Summ 
			FROM dbo.zf_t_CalcRemByDateDate(@Date,@Date) d
			JOIN t_pinp pp ON pp.ProdID=d.ProdID and pp.PPID=d.PPID
			JOIN r_Prods ss ON pp.ProdID=ss.ProdID
			WHERE d.StockID IN (4,304,11,311,27,327,85,385,220,320,23,323,16) AND ss.PGrID1 IN (18,20,21,22,23,24,25,26) AND Qty<>0 
			--and StockID = 4 and d.ProdID = 2159 --для быстрой отадки
		) rem                  
		GROUP BY rem.StockID, rem.ProductID, Data	
		UNION ALL
		--отнимает входящие остатки
		SELECT StockID, ProductID,Data,-SUM(Qty) Qty,-SUM(Summ) Summ  FROM (
			SELECT  d.StockID, d.ProdID ProductID,@Date Data,Qty,Qty*CostCC Summ 
			FROM dbo.zf_t_CalcRemByDateDate('2079-01-01', '1900-01-01') d --для вычитания входящих остатков
			JOIN t_pinp pp ON pp.ProdID=d.ProdID and pp.PPID=d.PPID
			JOIN r_Prods ss ON pp.ProdID=ss.ProdID
			WHERE d.StockID IN (4,304 ,11,311,27,327,85,385,220,320,23,323,16) AND ss.PGrID1 IN (18,20,21,22,23,24,25,26) AND Qty<>0 
			--and StockID = 4 and d.ProdID = 2159 --для быстрой отадки
		) rem                  
		GROUP BY rem.StockID, rem.ProductID, Data	
end

--Нарастающий итог
IF 1=1
BEGIN
	IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE dbo.tmp_Campary
	CREATE TABLE [dbo].[tmp_Campary](
		[StockID] [int] NULL,
		[ProductID] [int] NULL,
		[Data] [smalldatetime] NULL,
		[Qty] [numeric](21, 9) NULL,
		[Summ] [numeric](21, 9) NULL
	) 


	--;with prodid_stockid_cte as (SELECT m.StockID,m.ProductID FROM tmp_CamparyStocksInDay m group by m.StockID,m.ProductID)
	--,data_cte as (SELECT m.Data FROM tmp_CamparyStocksInDay m group by m.Data)

	INSERT into tmp_Campary (StockID, ProductID, Data, Qty, Summ)
	SELECT gr.StockID,gr.ProductID,gr.Data, SUM(Qty) qty,SUM(Summ) Summ 
	FROM (
		SELECT StockID, ProductID, Data
		,isnull((SELECT SUM(Qty) FROM dbo.tmp_CamparyStocksInDay s2
				WHERE s2.Data <= d.Data  and s2.StockID = ps.StockID and s2.ProductID = ps.ProductID
			  ),0) AS Qty 
		,isnull((SELECT SUM(s2.Summ) FROM dbo.tmp_CamparyStocksInDay s2
				WHERE s2.Data <= d.Data  and s2.StockID = ps.StockID and s2.ProductID = ps.ProductID
			  ),0) AS Summ 
		 FROM (SELECT m.StockID,m.ProductID FROM tmp_CamparyStocksInDay m group by m.StockID,m.ProductID) ps
		 ,(SELECT m.Data FROM tmp_CamparyStocksInDay m group by m.Data) d
	) gr group by gr.StockID,gr.ProductID,gr.Data

	SELECT SUM(Qty) FROM dbo.tmp_Campary where DATA = (SELECT max(data) FROM dbo.tmp_Campary)
	SELECT SUM(Qty) FROM dbo.tmp_CamparyStocksInDay

END
	--SELECT StockID, ProductID, Data,
	--  ( SELECT SUM(Qty) FROM dbo.tmp_CamparyStocksInDay s2
	--	WHERE s2.Data <= s1.Data and s2.StockID = s1.StockID and s2.ProductID = s1.ProductID 
	--  ) AS Qty,
	--  ( SELECT SUM(summ) FROM dbo.tmp_CamparyStocksInDay s3
	--	WHERE s3.Data <= s1.Data and s3.StockID = s1.StockID and s3.ProductID = s1.ProductID 
	--  ) AS Summ
	--FROM dbo.tmp_CamparyStocksInDay s1
	--GROUP by Data,StockID, ProductID

--##############################################################
--движения Delivery
set @n = DATEdiff( dd,@StartDate,dbo.zf_GetDate(GETDATE()) )--количество дней до сегодня


IF OBJECT_ID (N'dbo.tmp_CamparyDelivery4', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery4
SELECT * 
 INTO dbo.tmp_CamparyDelivery4 
FROM [dbo].[af_CamparyDelivery]('4,304,23,323,16', @n, null, '18,20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', 'C-10793-A-1')

IF OBJECT_ID (N'dbo.tmp_CamparyDelivery11', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery11
SELECT * 
 INTO dbo.tmp_CamparyDelivery11 
FROM [dbo].[af_CamparyDelivery]('11,311', @n, null, '18,20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', 'C-10793-A-1')

IF OBJECT_ID (N'dbo.tmp_CamparyDelivery27', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery27
SELECT * 
 INTO dbo.tmp_CamparyDelivery27 
FROM [dbo].[af_CamparyDelivery]('27,327', @n, null, '18,20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', 'C-10793-A-1')

IF OBJECT_ID (N'dbo.tmp_CamparyDelivery85', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery85
SELECT * 
 INTO dbo.tmp_CamparyDelivery85 
FROM [dbo].[af_CamparyDelivery]('85,385', @n, null, '18,20-26', '85,385', '17494,17612,17612,17612,17681,17757,17758,17758,17909,40683,58303,58309,58311,58314,58352,58366,58366,58379,58379,58379,58379,58379,58379,58417,58417,58433,58557,58603,58628,58633,58638,58657,58671,58671,58684,58705,58733,58752,58752,58752,58758,58758,58778,58790,58799,58808,58818,58820,58821,58821,58826,58841,58842,58843,58844,58852,58860,58869,58873,64017,64064', 'C-10793-A-1')
--по заявке от Макса
--FROM [dbo].[af_CamparyDelivery]('85,385', @n, null, '18,20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')

IF OBJECT_ID (N'dbo.tmp_CamparyDelivery220', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery220
SELECT * 
 INTO dbo.tmp_CamparyDelivery220
FROM [dbo].[af_CamparyDelivery]('220,320', @n, null, '18,20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', 'C-10793-A-1')



--##############################################################
--статусы Status
set @n = DATEdiff( dd,@StartDate,dbo.zf_GetDate(GETDATE()) )--количество дней до сегодня

IF OBJECT_ID (N'dbo.tmp_CamparyStatus', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyStatus
SELECT *  
 INTO dbo.tmp_CamparyStatus
FROM (
select 'Delivery' TableName,CONVERT(varchar,GETDATE()-@n,112) DayFrom,CONVERT(varchar,GETDATE(),112) DayTo
union all select 'Stocks',CONVERT(varchar,GETDATE()-@n,112),CONVERT(varchar,GETDATE(),112)
) s

--##############################################################
--клиетны Clients
IF OBJECT_ID (N'dbo.tmp_CamparyClients4', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients4
SELECT * 
 INTO dbo.tmp_CamparyClients4 
FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery4')

IF OBJECT_ID (N'dbo.tmp_CamparyClients11', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients11
SELECT * 
 INTO dbo.tmp_CamparyClients11 
FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery11')

IF OBJECT_ID (N'dbo.tmp_CamparyClients27', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients27
SELECT * 
 INTO dbo.tmp_CamparyClients27 
FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery27')

IF OBJECT_ID (N'dbo.tmp_CamparyClients85', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients85
SELECT * 
 INTO dbo.tmp_CamparyClients85
 FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery85')

IF OBJECT_ID (N'dbo.tmp_CamparyClients220', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients220
SELECT * 
 INTO dbo.tmp_CamparyClients220 
FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery220')

--##############################################################
IF OBJECT_ID (N'dbo.tmp_CamparyProducts', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyProducts

SELECT s.ProdID ProductID
,s.ProdName ProductName
,s.UM UnitName
,ISNULL((select top 1 ProdBarCode from Elit.dbo.t_PInP where ProdID=s.ProdID and ProdBarCode is not null  and ProdBarCode <>'' ),'') EAN
 INTO dbo.tmp_CamparyProducts
FROM Elit.dbo.r_Prods s WITH(NOLOCK) 
JOIN Elit.dbo.r_ProdMQ q WITH(NOLOCK) ON s.ProdID=q.ProdID AND s.UM=q.UM 
WHERE s.ProdID in (
SELECT distinct ProductID FROM tmp_CamparyDelivery11
union
SELECT distinct ProductID FROM tmp_CamparyDelivery220
union
SELECT distinct ProductID FROM tmp_CamparyDelivery4
union
SELECT distinct ProductID FROM tmp_CamparyDelivery27
union
SELECT distinct ProductID FROM tmp_CamparyDelivery85
)

/*
IF OBJECT_ID (N'dbo.tmp_CamparyDelivery4', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery4
SELECT * 
 INTO dbo.tmp_CamparyDelivery4 
FROM [dbo].[af_CamparyDelivery]('4,304,23,323', 590, null, '18,20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')
IF OBJECT_ID (N'dbo.tmp_CamparyClients4', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients4
SELECT * 
 INTO dbo.tmp_CamparyClients4 
FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery4')


SELECT * FROM tmp_CamparyDelivery4   where OutletID not in (SELECT OutletID FROM tmp_CamparyClients4)
SELECT * FROM tmp_CamparyDelivery85  where OutletID not in (SELECT OutletID FROM tmp_CamparyClients85)
SELECT * FROM tmp_CamparyDelivery11  where OutletID not in (SELECT OutletID FROM tmp_CamparyClients11)
SELECT * FROM tmp_CamparyDelivery27  where OutletID not in (SELECT OutletID FROM tmp_CamparyClients27)
SELECT * FROM tmp_CamparyDelivery220 where OutletID not in (SELECT OutletID FROM tmp_CamparyClients220)

SELECT * FROM tmp_CamparyDelivery4   where OperationID < 0
SELECT * FROM tmp_CamparyDelivery85  where OperationID < 0
SELECT * FROM tmp_CamparyDelivery11  where OperationID < 0
SELECT * FROM tmp_CamparyDelivery27  where OperationID < 0
SELECT * FROM tmp_CamparyDelivery220 where OperationID < 0

SELECT * FROM tmp_CamparyClients4  
SELECT * FROM tmp_CamparyClients85 
SELECT * FROM tmp_CamparyClients11 
SELECT * FROM tmp_CamparyClients27 
SELECT * FROM tmp_CamparyClients220

SELECT * FROM tmp_CamparyClients4   WHERE OutletName like '%;%' or OutletAddress like '%;%' or ClientName like '%;%'
SELECT * FROM tmp_CamparyClients85  WHERE OutletName like '%;%' or OutletAddress like '%;%' or ClientName like '%;%'
SELECT * FROM tmp_CamparyClients11  WHERE OutletName like '%;%' or OutletAddress like '%;%' or ClientName like '%;%'
SELECT * FROM tmp_CamparyClients27  WHERE OutletName like '%;%' or OutletAddress like '%;%' or ClientName like '%;%'
SELECT * FROM tmp_CamparyClients220 WHERE OutletName like '%;%' or OutletAddress like '%;%' or ClientName like '%;%'

SELECT * FROM tmp_CamparyDelivery4   where OutletID  in ('s-23','s-323')
SELECT * FROM tmp_CamparyClients4   where OutletID  in ('s-23','s-323')


SELECT * FROM tmp_CamparyStocksInDay
SELECT * FROM tmp_Campary ORDER BY 3

SELECT data,stockid, sum(qty) FROM tmp_Campary group by data,stockid ORDER BY 1,2
SELECT data, sum(qty) 'днепр4' FROM tmp_Campary where stockid in (4,304, 23,323) group by data ORDER BY 1,2
SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery4 group by Data ORDER BY 1
--SELECT * FROM tmp_CamparyDelivery4 ORDER BY Data


--проверка остатков и жвижения товаров, должно быть ноль
--всего  движение товара
SELECT (SELECT sum(Qty) TQty FROM tmp_CamparyDelivery4)
+ (SELECT sum(Qty) TQty FROM tmp_CamparyDelivery85)
+ (SELECT sum(Qty) TQty FROM tmp_CamparyDelivery11)
+ (SELECT sum(Qty) TQty FROM tmp_CamparyDelivery27)
+ (SELECT sum(Qty) TQty FROM tmp_CamparyDelivery220)

-(SELECT sum(Qty) TQty FROM tmp_CamparyStocksInDay)

+(SELECT sum(Qty) TQty FROM tmp_CamparyStocksInDay where data = '2016-12-31 00:00:00')



--проверка Stocks & Delivery  
SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (4,304, 23,323,16) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery4 group by Data) s2 on s1.Data = s2.Data where s1.TQty != isnull(s2.TQty,0) ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (11,311) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery11 group by Data) s2 on s1.Data = s2.Data where s1.TQty != isnull(s2.TQty,0) ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (27,327) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery27 group by Data) s2 on s1.Data = s2.Data where s1.TQty != isnull(s2.TQty,0) ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (85,385) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery85 group by Data) s2 on s1.Data = s2.Data where s1.TQty != isnull(s2.TQty,0) ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (220,320) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery220 group by Data) s2 on s1.Data = s2.Data where s1.TQty != isnull(s2.TQty,0) ORDER BY 1

*/


