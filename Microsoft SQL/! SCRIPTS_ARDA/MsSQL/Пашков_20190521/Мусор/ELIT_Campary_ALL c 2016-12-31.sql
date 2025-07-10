--ELIT_Campary_ALL c 2016-12-31
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
DECLARE @n INT = - DATEdiff( dd,'2016-12-31',dbo.zf_GetDate(GETDATE()) )--количество дней до сегодня
	SET @Date = DATEADD( dd,@n,dbo.zf_GetDate(GETDATE()) )
	select @n, @Date
	
	--опорные остатки на конец дня за -n дней назад
	INSERT tmp_CamparyStocksInDay (StockID, ProductID, Data, Qty, Summ)
		SELECT StockID, ProductID,Data,SUM(Qty) Qty,SUM(Summ) Summ  FROM (
			SELECT  d.StockID, d.ProdID ProductID,@Date Data,Qty,Qty*CostCC Summ 
			FROM dbo.zf_t_CalcRemByDateDate(NULL,@Date) d
			JOIN t_pinp pp ON pp.ProdID=d.ProdID and pp.PPID=d.PPID
			JOIN r_Prods ss ON pp.ProdID=ss.ProdID
			WHERE d.StockID IN (4,304 ,11,311,27,327,85,385,220,320,23,323) AND ss.PGrID1 BETWEEN 20 AND 26 AND Qty<>0 
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
			WHERE d.StockID IN (4,304 ,11,311,27,327,85,385,220,320,23,323) AND ss.PGrID1 BETWEEN 20 AND 26 AND Qty<>0 
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
			WHERE d.StockID IN (4,304 ,11,311,27,327,85,385,220,320,23,323) AND ss.PGrID1 BETWEEN 20 AND 26 AND Qty<>0 
			--and StockID = 4 and d.ProdID = 2159 --для быстрой отадки
		) rem                  
		GROUP BY rem.StockID, rem.ProductID, Data	
end


IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE dbo.tmp_Campary
CREATE TABLE [dbo].[tmp_Campary](
	[StockID] [int] NULL,
	[ProductID] [int] NULL,
	[Data] [smalldatetime] NULL,
	[Qty] [numeric](21, 9) NULL,
	[Summ] [numeric](21, 9) NULL
) 
--Нарастающий итог
INSERT tmp_Campary (StockID, ProductID, Data, Qty, Summ)
	SELECT StockID, ProductID, Data,
	  ( SELECT SUM(Qty) FROM dbo.tmp_CamparyStocksInDay s2
		WHERE s2.Data <= s1.Data and s2.StockID = s1.StockID and s2.ProductID = s1.ProductID 
	  ) AS Qty,
	  ( SELECT SUM(summ) FROM dbo.tmp_CamparyStocksInDay s3
		WHERE s3.Data <= s1.Data and s3.StockID = s1.StockID and s3.ProductID = s1.ProductID 
	  ) AS Summ
	FROM dbo.tmp_CamparyStocksInDay s1
	GROUP by Data,StockID, ProductID

--##############################################################
--движения Delivery
set @n = DATEdiff( dd,'2016-12-31',dbo.zf_GetDate(GETDATE()) )--количество дней до сегодня

IF OBJECT_ID (N'dbo.tmp_CamparyDelivery4', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery4
SELECT * 
 INTO dbo.tmp_CamparyDelivery4 
FROM [dbo].[af_CamparyDelivery]('4,304,23,323', @n, null, '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')

IF OBJECT_ID (N'dbo.tmp_CamparyDelivery11', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery11
SELECT * 
 INTO dbo.tmp_CamparyDelivery11 
FROM [dbo].[af_CamparyDelivery]('11,311', @n, null, '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')

IF OBJECT_ID (N'dbo.tmp_CamparyDelivery27', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery27
SELECT * 
 INTO dbo.tmp_CamparyDelivery27 
FROM [dbo].[af_CamparyDelivery]('27,327', @n, null, '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')

IF OBJECT_ID (N'dbo.tmp_CamparyDelivery85', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery85
SELECT * 
 INTO dbo.tmp_CamparyDelivery85 
FROM [dbo].[af_CamparyDelivery]('85,385', @n, null, '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')

IF OBJECT_ID (N'dbo.tmp_CamparyDelivery220', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery220
SELECT * 
 INTO dbo.tmp_CamparyDelivery220
FROM [dbo].[af_CamparyDelivery]('220,320', @n, null, '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')

--##############################################################
--статусы Status
set @n = DATEdiff( dd,'2016-12-31',dbo.zf_GetDate(GETDATE()) );
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



/*
IF OBJECT_ID (N'dbo.tmp_CamparyDelivery4', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery4
SELECT * 
 INTO dbo.tmp_CamparyDelivery4 
FROM [dbo].[af_CamparyDelivery]('4,304,23,323', 590, null, '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')
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

SELECT * FROM tmp_CamparyDelivery4   where OutletID  in ('s-23','s-323')
SELECT * FROM tmp_CamparyClients4   where OutletID  in ('s-23','s-323')


SELECT * FROM tmp_CamparyStocksInDay
SELECT * FROM tmp_Campary

--проверка Stocks & Delivery  
SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (4,304, 23,323) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery4 group by Data) s2 on s1.Data = s2.Data /*where s1.TQty != isnull(s2.TQty,0)*/ ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (11,311) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery11 group by Data) s2 on s1.Data = s2.Data where s1.TQty != isnull(s2.TQty,0) ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (27,327) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery27 group by Data) s2 on s1.Data = s2.Data where s1.TQty != isnull(s2.TQty,0) ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (85,385) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery85 group by Data) s2 on s1.Data = s2.Data where s1.TQty != isnull(s2.TQty,0) ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (220,320) group by Data) s1
left join (SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery220 group by Data) s2 on s1.Data = s2.Data where s1.TQty != isnull(s2.TQty,0) ORDER BY 1


SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_Campary where StockID in (4,304, 23,323) group by Data) s1
where  data >= '2018-01-01'
ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_Campary where StockID in (27,327) group by Data) s1
where  data >= '2018-01-01'
ORDER BY 1

SELECT * FROM tmp_Campary where StockID in (4,304, 23,323) and data >= '2018-01-01'
ORDER BY 3

SELECT * FROM tmp_CamparyStocksInDay where StockID in (4,304, 23,323) and data >= '2018-01-01'
ORDER BY 3

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (4,304, 23,323) group by Data) s1
where  data >= '2018-01-01'
ORDER BY 1

SELECT * FROM (SELECT  Data, sum(Qty) TQty FROM tmp_CamparyStocksInDay where StockID in (4,304, 23,323) group by Data) s1
where  data = '2018-01-02'
ORDER BY 1

SELECT  * FROM tmp_CamparyStocksInDay where StockID in (4,304, 23,323) and data = '2018-01-02'
ORDER BY 2

SELECT  sum(Qty) TQty FROM tmp_CamparyDelivery4 
ORDER BY 1


SELECT  * FROM tmp_CamparyStocksInDay where StockID in (4,304, 23,323) 
ORDER BY 3



*/