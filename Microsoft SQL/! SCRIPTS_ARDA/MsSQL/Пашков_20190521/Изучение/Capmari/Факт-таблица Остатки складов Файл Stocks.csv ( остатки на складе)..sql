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
DECLARE @n INT = -45
	SET @Date = DATEADD( dd,@n,dbo.zf_GetDate(GETDATE()) )
	select @n, @Date
	
	--опорные остатки на конец дня за -45 дней назад
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
	
SELECT * FROM tmp_Campary ORDER BY 1,2,3

SELECT * FROM tmp_CamparyStocksInDay  where  StockID = 4 and ProductID = 2159 --для быстрой отадки
SELECT * FROM tmp_Campary  where  StockID = 4 and ProductID = 2159 --для быстрой отадки