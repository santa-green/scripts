SELECT Data, Sum(Qty) FROM (
SELECT * FROM tmp_Campary) dildo
WHERE dildo.StockID in (4,304,23,323) and dildo.Data < '2017-02-01'
GROUP BY Data
ORDER BY 1

SELECT * FROM tmp_CamparyStocksInDay
WHERE StockID in (4,304,23,323) and Data < '2017-01-01' --and Data >= '2018-07-01'
ORDER BY 3

SELECT * FROM tmp_CamparyStocksInDay
WHERE StockID in (4,304,23,323) --and Data >= '2018-07-01'
ORDER BY 3


--SELECT * FROM tmp_Campary
--WHERE StockID in (4,304,23,323) and Data < '2017-02-01' and ProductID = 31517
--ORDER BY 3

	SELECT StockID, ProductID, Data,
	  ( SELECT SUM(Qty) FROM tmp_CamparyStocksInDay s2
		WHERE s1.Data < '2017-03-01' and StockID in (4,304,23,323) --s2.Data <= s1.Data and s2.StockID = s1.StockID and s2.ProductID = s1.ProductID
	  ) AS Qty,
	  ( SELECT SUM(summ) FROM tmp_CamparyStocksInDay s3
		WHERE s3.Data <= s1.Data and s3.StockID = s1.StockID and s3.ProductID = s1.ProductID
	  ) AS Summ
	FROM tmp_CamparyStocksInDay s1
	WHERE StockID in (4,304,23,323) and Data = '2017-01-01' --and ProductID = 31517
	GROUP by Data,StockID,ProductID
	ORDER BY 3

	SELECT * FROM tmp_CamparyDelivery4
	WHERE Data < '20170101' --and ProductID = 31436 --and Data >= '20170401'
	ORDER BY 4
	
	SELECT * FROM tmp_CamparyStocksInDay
	where Data < '2017-01-01' and StockID in (4,304,23,323)


IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE dbo.tmp_Campary
CREATE TABLE [dbo].[tmp_Campary](
	[StockID] [int] NULL,
	[ProductID] [int] NULL,
	[Data] [smalldatetime] NULL,
	[Qty] [numeric](21, 9) NULL,
	[Summ] [numeric](21, 9) NULL
) 

	INSERT tmp_Campary (StockID, ProductID, Data, Qty, Summ)
	SELECT StockID, ProductID, Data,
	  ( SELECT SUM(Qty) FROM tmp_CamparyStocksInDay s2
		where s2.Data <= @Date
	  ) AS Qty ,1
	FROM dbo.tmp_CamparyStocksInDay s1
	GROUP by Data,StockID, ProductID
	
WHILE @n < -560
BEGIN
	set @n = @n + 1
	SET @Date = DATEADD( dd,1,@Date )--увеличить расчетную дату на 1 день
	--select @n, @Date
	
	INSERT tmp_Campary (StockID, ProductID, Data, Qty, Summ)
	SELECT StockID, ProductID, Data,
	  ( SELECT SUM(Qty) FROM tmp_CamparyStocksInDay s2
		where s2.Data <= @Date
	  ) AS Qty ,1
	FROM dbo.tmp_CamparyStocksInDay s1
	GROUP by Data,StockID, ProductID
	
END
SELECT * FROM tmp_Campary
where Data < '2017-02-01' and StockID in (4,304,23,323) and Data > '2016-12-31'
ORDER BY 3

SELECT * 
FROM [dbo].[af_CamparyDelivery]('4,304,23,323', 1, '2018-01-02', '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')

SELECT SUM(Qty) FROM tmp_CamparyStocksInDay
SELECT SUM(Qty) FROM tmp_Campary where data = (SELECT max(data) FROM tmp_Campary)

SELECT * FROM tmp_CamparyStocksInDay
ORDER BY data desc

SELECT * FROM tmp_Campary
ORDER BY 3


IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE dbo.tmp_Campary
CREATE TABLE [dbo].[tmp_Campary](
	[StockID] [int] NULL,
	[ProductID] [int] NULL,
	[Data] [smalldatetime] NULL,
	[Qty] [numeric](21, 9) NULL,
	[Summ] [numeric](21, 9) NULL
)

;with
 groups AS (SELECT StockID, ProductID, Data, sum(Qty) Qty, SUM(Summ) Summ FROM dbo.tmp_CamparyStocksInDay GROUP BY StockID, ProductID, Data) 

--Нарастающий итог
INSERT tmp_Campary (StockID, ProductID, Data, Qty, Summ)
	SELECT StockID, ProductID, Data,
	  ( SELECT SUM(Qty) FROM groups s2
		WHERE s2.Data <= s1.Data and s2.StockID = s1.StockID and s2.ProductID = s1.ProductID 
	  ) AS Qty,
	  ( SELECT SUM(summ) FROM groups s3
		WHERE s3.Data <= s1.Data and s3.StockID = s1.StockID and s3.ProductID = s1.ProductID 
	  ) AS Summ
	FROM groups s1
	GROUP by Data,StockID, ProductID
	ORDER BY Data desc




IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE dbo.tmp_Campary
CREATE TABLE [dbo].[tmp_Campary](
	[StockID] [int] NULL,
	[Data] [smalldatetime] NULL,
	[Qty] [numeric](21, 9) NULL,
)

;with
 groups AS (SELECT StockID, Data, Sum(qty) Qty FROM tmp_CamparyStocksInDay GROUP BY Data,StockID) 

--Нарастающий итог
INSERT tmp_Campary (StockID, Data, Qty)
	SELECT  StockID,Data,
	  ( SELECT SUM(Qty) FROM groups s2
		WHERE s2.Data <= s1.Data and s2.StockID = s1.StockID 
	  ) AS Qty

	FROM groups s1
	GROUP by StockID,Data
	ORDER BY Data desc

SELECT SUM(Qty) FROM tmp_CamparyStocksInDay
SELECT SUM(Qty) FROM tmp_Campary where data = (SELECT max(data) FROM tmp_Campary)
SELECT * FROM tmp_Campary


	SELECT Data, Sum(qty) Qty FROM tmp_CamparyStocksInDay GROUP BY Data
		ORDER BY Data
SELECT SUM(Qty) FROM tmp_Campary where data = (SELECT max(data) FROM tmp_Campary)


IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE dbo.tmp_Campary
CREATE TABLE [dbo].[tmp_Campary](
	[Data] [smalldatetime] NULL,
	[Qty] [numeric](21, 9) NULL,
)

;with
 groups AS (SELECT Data, Sum(qty) Qty FROM tmp_CamparyStocksInDay GROUP BY Data) 

--Нарастающий итог
--INSERT tmp_Campary ( Data, Qty)
	SELECT  Data,
	  ( SELECT SUM(Qty) FROM groups s2
		WHERE s2.Data <= s1.Data-- and s1.StockID = s2.StockID
	  ) AS Qty

	FROM groups s1
	GROUP by Data
	ORDER BY Data desc

SELECT SUM(Qty) FROM tmp_CamparyStocksInDay
SELECT SUM(Qty) FROM tmp_Campary where data = (SELECT max(data) FROM tmp_Campary)
SELECT * FROM tmp_Campary
WHERE StockID in (4,304,23,323)

SELECT Data, SUM(Qty) FROM tmp_CamparyStocksInDay
WHERE StockID in (4,304,23,323) and Data <= '2017-02-15'
GROUP BY Data
ORDER BY Data

SELECT Data, SUM(Qty) FROM tmp_Campary
WHERE StockID in (4,304,23,323)
GROUP BY Data
ORDER BY Data

/*time 4:09*/
DECLARE @Date SMALLDATETIME
DECLARE @n INT = - DATEdiff( dd,'2016-12-31',dbo.zf_GetDate(GETDATE()) )--количество дней до сегодня
	SET @Date = DATEADD( dd,@n+1,dbo.zf_GetDate(GETDATE()) )
	SET @n = @n + 1
	--select @n, @Date

IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE dbo.tmp_Campary
CREATE TABLE [dbo].[tmp_Campary](
	[StockID] [int] NULL,
	[ProductID] [int] NULL,
	[Data] [smalldatetime] NULL,
	[Qty] [numeric](21, 9) NULL,
	[Summ] [numeric](21, 9) NULL
)
	INSERT tmp_Campary (StockID, ProductID, Data, Qty, Summ)

	SELECT StockID,ProductID,Data,
	  ( SELECT SUM(Qty) FROM dbo.tmp_CamparyStocksInDay s2
		WHERE s2.Data < @Date and s1.ProductID = s2.ProductID and s1.StockID = s2.StockID
	  ) AS Qty,
	  ( SELECT SUM(summ) FROM dbo.tmp_CamparyStocksInDay s3
		WHERE s3.Data < @Date and s1.ProductID = s3.ProductID and s1.StockID = s3.StockID
	  ) AS Summ
	FROM dbo.tmp_CamparyStocksInDay s1	
	WHERE s1.Data < @Date
	GROUP by Data,ProductID,StockID


while @n < -5 -- -5
Begin
SET @Date = DATEADD( dd,-1,@Date )

IF OBJECT_ID (N'tempdb..#TempDay', N'U') IS NOT NULL DROP TABLE #TempDay

SELECT *
INTO #TempDay
FROM tmp_Campary s1
WHERE s1.Data = @Date

	set @n = @n + 1	
	SET @Date = DATEADD( dd,1,@Date )--увеличить расчетную дату на 1 день

IF EXISTS(SELECT DISTINCT t1.ProductID FROM ((SELECT DISTINCT ProductID, StockID FROM tmp_CamparyStocksInDay ca WHERE ca.Data <= @Date) EXCEPT (SELECT DISTINCT ProductID, StockID FROM #TempDay da where da.Data <= @Date)) t1)
BEGIN
	INSERT tmp_Campary (StockID, ProductID, Data, Qty, Summ)
	SELECT StockID,ProductID,@Date,
	  ( SELECT (s1.Qty + ISNULL(SUM(s2.Qty),0)) Qty FROM dbo.tmp_CamparyStocksInDay s2
		WHERE s2.Data = @Date and s1.ProductID = s2.ProductID and s1.StockID = s2.StockID
	  ) AS Qty,
	  ( SELECT (s1.Summ + ISNULL(SUM(s3.Summ),0)) Summ FROM dbo.tmp_CamparyStocksInDay s3
		WHERE s3.Data = @Date and s1.ProductID = s3.ProductID and s1.StockID = s3.StockID
	  ) AS Summ
	FROM #TempDay s1
	
	UNION ALL
		
	SELECT s1.StockID,s1.ProductID,@Date, ISNULL(SUM(s1.Qty),0) Qty, ISNULL(SUM(s1.Summ),0) Summ 
	FROM tmp_CamparyStocksInDay s1	
	WHERE s1.Data = @Date and s1.StockID in(4,11,23,27,85,220) and s1.ProductID in (SELECT DISTINCT ProductID FROM ((SELECT DISTINCT ProductID FROM tmp_CamparyStocksInDay ca WHERE ca.Data <= @Date) EXCEPT (SELECT DISTINCT ProductID FROM #TempDay da where da.Data <= @Date)) t1 )
	GROUP BY s1.ProductID, s1.StockID
	
	UNION ALL
	
	SELECT s1.StockID,s1.ProductID,@Date, ISNULL(SUM(s1.Qty),0) Qty, ISNULL(SUM(s1.Summ),0) Summ 
	FROM tmp_CamparyStocksInDay s1	
	WHERE s1.Data = @Date and s1.StockID in (304,311,323,327,385,322) and s1.ProductID in (SELECT DISTINCT ProductID FROM ((SELECT DISTINCT ProductID, StockID FROM tmp_CamparyStocksInDay ca WHERE ca.Data <= @Date) EXCEPT (SELECT DISTINCT ProductID, StockID FROM #TempDay da where da.Data <= @Date)) t1 )
	GROUP BY s1.ProductID, s1.StockID
END

ELSE
BEGIN
	INSERT tmp_Campary (StockID, ProductID, Data, Qty, Summ)
	SELECT StockID,ProductID,@Date,
	  ( SELECT (s1.Qty + ISNULL(SUM(s2.Qty),0)) Qty FROM dbo.tmp_CamparyStocksInDay s2
		WHERE s2.Data = @Date and s1.ProductID = s2.ProductID and s1.StockID = s2.StockID
	  ) AS Qty,
	  ( SELECT (s1.Summ + ISNULL(SUM(s3.Summ),0)) Summ FROM dbo.tmp_CamparyStocksInDay s3
		WHERE s3.Data = @Date and s1.ProductID = s3.ProductID and s1.StockID = s3.StockID
	  ) AS Summ
	FROM #TempDay s1
END	
	
	SET @Date = DATEADD( dd,1,@Date )--увеличить расчетную дату на 1 день
END

SELECT /*DISTINCT ProductID*/* FROM #TempDay
WHERE StockID in (4,304,23,323)

IF EXISTS((SELECT DISTINCT ProductID, StockID FROM tmp_CamparyStocksInDay ca WHERE ca.Data < '2018-01-01') EXCEPT (SELECT DISTINCT ProductID, StockID FROM #TempDay da where da.Data = '2018-08-13'))
BEGIN
PRINT 1
END

ELSE 
BEGIN
PRINT 0
END

SELECT * FROM tmp_CamparyStocksInDay s1
WHERE s1.ProductID in ((SELECT DISTINCT ProductID FROM tmp_CamparyStocksInDay ca WHERE ca.Data < '2017-01-06') EXCEPT (SELECT DISTINCT ProductID FROM #TempDay da where da.Data = '2018-08-13'))


SELECT StockID, ProductID, Data, Qty FROM tmp_CamparyStocksInDay
where StockID in (4,304,23,323) and ProductID = 31437 and Data = '2017-01-10'

SELECT * FROM tmp_CamparyDelivery4
ORDER BY Data

SELECT ProductID FROM ((SELECT DISTINCT ProductID, StockID FROM tmp_CamparyStocksInDay ca WHERE ca.Data <= '2017-01-11') EXCEPT (SELECT DISTINCT ProductID, StockID FROM #TempDay da where da.Data < '2017-01-11')) elda
order by 1


	SELECT s1.StockID,s1.ProductID,'2017-01-02', ISNULL(SUM(s1.Qty),0) Qty, ISNULL(SUM(s1.Summ),0) Summ 
	FROM tmp_CamparyStocksInDay s1
	JOIN #TempDay s2 on s2.ProductID = s1.ProductID
	
	WHERE s1.Data = '2017-01-02' and s1.ProductID in (SELECT DISTINCT ProductID FROM ((SELECT DISTINCT ProductID, StockID FROM tmp_CamparyStocksInDay ca WHERE ca.Data <= '2017-01-02') EXCEPT (SELECT DISTINCT ProductID, StockID FROM #TempDay da where da.Data <= '2017-01-02')) t1 )
						  and s2.StockID not in (SELECT DISTINCT StockID FROM ((SELECT DISTINCT ProductID, StockID FROM tmp_CamparyStocksInDay ca WHERE ca.Data <= '2017-01-02') EXCEPT (SELECT DISTINCT ProductID, StockID FROM #TempDay da where da.Data <= '2017-01-02')) t2)
	GROUP BY s1.ProductID, s1.StockID
	
	
	SELECT s1.StockID,s1.ProductID,'2017-01-11', ISNULL(SUM(s1.Qty),0) Qty, ISNULL(SUM(s1.Summ),0) Summ 
	FROM tmp_CamparyStocksInDay s1	
	WHERE s1.Data = '2017-01-11' and s1.StockID in (304) and s1.ProductID in (SELECT DISTINCT ProductID FROM ((SELECT DISTINCT ProductID, StockID FROM tmp_CamparyStocksInDay ca WHERE ca.Data <= '2017-01-11') EXCEPT (SELECT DISTINCT ProductID, StockID FROM #TempDay da where da.Data <= '2017-01-11')) t1 )
	GROUP BY s1.ProductID, s1.StockID
	
	SELECT s1.StockID,s1.ProductID,'2017-01-11', ISNULL(SUM(s1.Qty),0) Qty, ISNULL(SUM(s1.Summ),0) Summ 
	FROM tmp_CamparyStocksInDay s1	
	WHERE s1.Data = '2017-01-11' and s1.StockID in (304,311,323,327,385,322) and s1.ProductID in (SELECT DISTINCT ProductID FROM ((SELECT DISTINCT ProductID, StockID FROM tmp_CamparyStocksInDay ca WHERE ca.Data <= '2017-01-11') EXCEPT (SELECT DISTINCT ProductID, StockID FROM #TempDay da where da.Data <= '2017-01-11')) t1 )
	GROUP BY s1.ProductID, s1.StockID
	
	SELECT * FROM tmp_CamparyStocksInDay
	where ProductID = 31437 and StockID in (304)
	order by 3
	