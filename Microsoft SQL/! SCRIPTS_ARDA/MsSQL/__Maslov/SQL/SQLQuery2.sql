		SELECT 
		CASE StockID WHEN 23 THEN 4 WHEN 323 THEN 304 ELSE StockID END StockID, 
		ProductID,Data,isnull(SUM(Qty),0) Qty,isnull(SUM(Summ),0) Summ  FROM (
			SELECT  s.StockID, d.ProdID ProductID,'2017-01-01' Data,Qty,Qty*CostCC Summ 
			FROM r_Stocks s 
			left join dbo.zf_t_CalcRemByDateDate('2017-01-01','2017-01-01') d on s.StockID = d.StockID
			left JOIN t_pinp pp ON pp.ProdID=d.ProdID and pp.PPID=d.PPID
			left JOIN r_Prods ss ON pp.ProdID=ss.ProdID
			WHERE s.StockID IN (4,304 ,11,311,27,327,85,385,220,320,23,323) AND ss.PGrID1 BETWEEN 20 AND 26 --AND Qty<>0 
			--and StockID = 4 and d.ProdID = 2159 --для быстрой отадки
		) rem                  
		GROUP BY rem.StockID, rem.ProductID, Data	
		
		
		SELECT * FROM   dbo.zf_t_CalcRemByDateDate('2017-01-01','2017-01-01')
		
		
				SELECT s.StockID,d.* FROM  r_Stocks s 
			left join dbo.zf_t_CalcRemByDateDate('2017-01-01','2017-01-01') d on s.StockID = d.StockID
			left JOIN t_pinp pp ON pp.ProdID=d.ProdID and pp.PPID=d.PPID
			left JOIN r_Prods ss ON pp.ProdID=ss.ProdID
			WHERE s.StockID IN (4,304 ,11,311,27,327,85,385,220,320,23,323)
			 AND ss.PGrID1 BETWEEN 20 AND 26 AND Qty<>0 
	