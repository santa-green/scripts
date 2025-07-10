SELECT * FROM tmp_CamparyStocksInDay 
where 
StockID in (4,304, 23,323)
and data <= '2018-01-02' 
ORDER BY 3

--6721,000000000
--6696,000000000
--2092,000000000 1926,000000000

;WITH 
	 tmp_CamparyStocksInDay_group_CTE AS( SELECT Data,StockID, ProductID,SUM(Qty) TQty  FROM dbo.tmp_CamparyStocksInDay GROUP by Data,StockID, ProductID)
	 
SELECT /*StockID, ProductID,*/ Data, sum(TQty) tQty FROM (
	SELECT StockID, ProductID, s1.Data,
	  ( SELECT SUM(TQty) FROM tmp_CamparyStocksInDay_group_CTE s2
		WHERE s2.Data <= s1.Data and s2.StockID = s1.StockID and s2.ProductID = s1.ProductID 
	  ) AS TQty

	FROM tmp_CamparyStocksInDay_group_CTE s1 where StockID in (27,327)
	) gr  
	GROUP by gr.Data--,StockID, ProductID
	having  gr.data >= '2018-01-01' 
	ORDER BY 1

SELECT Data, sum(Qty) TQty FROM tmp_CamparyDelivery27 group by Data having  data >= '2018-01-01' ORDER BY 1


		SELECT StockID, ProductID,Data,SUM(Qty) Qty,SUM(Summ) Summ  FROM (
			SELECT  d.StockID, d.ProdID ProductID,'2018-01-02'  Data,Qty,Qty*CostCC Summ 
			FROM dbo.zf_t_CalcRemByDateDate('2018-01-02' ,'2018-01-02' ) d
			JOIN t_pinp pp ON pp.ProdID=d.ProdID and pp.PPID=d.PPID
			JOIN r_Prods ss ON pp.ProdID=ss.ProdID
			WHERE d.StockID IN (4,304 ,23,323) AND ss.PGrID1 BETWEEN 20 AND 26 AND Qty<>0 
			--and StockID = 4 and d.ProdID = 2159 --дл€ быстрой отадки
		) rem                  
		GROUP BY rem.StockID, rem.ProductID, Data
		UNION ALL
		--отнимает вход€щие остатки
		SELECT StockID, ProductID,Data,-SUM(Qty) Qty,-SUM(Summ) Summ  FROM (
			SELECT  d.StockID, d.ProdID ProductID,'2018-01-02' Data,Qty,Qty*CostCC Summ 
			FROM dbo.zf_t_CalcRemByDateDate('2079-01-01', '1900-01-01') d --дл€ вычитани€ вход€щих остатков
			JOIN t_pinp pp ON pp.ProdID=d.ProdID and pp.PPID=d.PPID
			JOIN r_Prods ss ON pp.ProdID=ss.ProdID
			WHERE d.StockID IN (4,304,23,323) AND ss.PGrID1 BETWEEN 20 AND 26 AND Qty<>0 
			--and StockID = 4 and d.ProdID = 2159 --дл€ быстрой отадки
		) rem                  
		GROUP BY rem.StockID, rem.ProductID, Data			
		
			
SELECT  d.StockID, d.ProdID ProductID,@Date Data,Qty,Qty*CostCC Summ 
			FROM dbo.zf_t_CalcRemByDateDate('2079-01-01', '1900-01-01')										

SELECT Data,StockID, ProductID,Qty  FROM dbo.tmp_CamparyStocksInDay where StockID in (4,304,23,323) and data = '2018-01-02'
ORDER BY 2,3
SELECT Data,StockID, ProductID,SUM(Qty) TQty  FROM dbo.tmp_CamparyStocksInDay where StockID in (4,304,23,323) and data = '2018-01-02'
GROUP by Data,StockID, ProductID
ORDER BY 1

SELECT StockID, ProductID, Data, sum(Qty) tQty FROM (
	SELECT StockID, ProductID, Data,
	  ( SELECT SUM(Qty) FROM dbo.tmp_CamparyStocksInDay s2
		WHERE s2.Data <= s1.Data and s2.StockID = s1.StockID and s2.ProductID = s1.ProductID 
	  ) AS Qty

	FROM dbo.tmp_CamparyStocksInDay s1
	) gr
	GROUP by Data,StockID, ProductID
	having StockID in (4,304, 23,323)
	ORDER BY 3
	
	
	SELECT * FROM (
		SELECT StockID, ProductID, Data,
	  ( SELECT isnull(SUM(Qty),0) FROM dbo.tmp_CamparyStocksInDay s2
		WHERE s2.Data <= s1.Data and s2.StockID = s1.StockID and s2.ProductID = s1.ProductID 
	  ) AS Qty
	FROM dbo.tmp_CamparyStocksInDay s1
	where StockID in (4,304, 23,323)
	) v1
	 where data = '2018-01-02'
	--GROUP by Data,StockID, ProductID
	ORDER BY 3
	
	SELECT * FROM tmp_CamparyStocksInDay
	
SELECT SUM(Qty) FROM dbo.tmp_CamparyStocksInDay s2 WHERE s2.Data < '2018-01-01' and StockID in (4,304, 23,323)
SELECT SUM(Qty) FROM dbo.tmp_CamparyStocksInDay s2 WHERE s2.Data < '2018-01-02' and StockID in (4,304, 23,323)
SELECT SUM(Qty) FROM dbo.tmp_CamparyStocksInDay s2 WHERE s2.Data < '2018-01-03' and StockID in (4,304, 23,323)

SELECT * FROM tmp_CamparyStocksInDay where StockID in (4,304, 23,323) and data = '2018-01-01'
ORDER BY 3