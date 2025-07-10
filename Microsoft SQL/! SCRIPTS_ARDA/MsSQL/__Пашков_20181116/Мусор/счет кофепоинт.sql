SELECT * FROM (
SELECT   
       Sum(tstd.Qty) as Qty, ROUND (tstd.PurPriceCC_wt,2) as PriceCC,   
       ROUND (SUM(tstd.PurPriceCC_wt*tstd.Qty),2) as SumCC, tstd.UM,   
       PriceCC_wt as PriceCCD, ISNULL((tstd.PurPriceCC_wt-PriceCC_wt), 0) as DiscountPricePart,     
       re.UAEmpName EmpName, rd.Notes, rp.ProdName ProdName, rs.Notes StockName  
       FROM t_SaleTemp tst WITH(NOLOCK)  
       INNER JOIN t_SaleTempD tstd WITH(NOLOCK) ON tstd.ChID=tst.ChID 
       INNER JOIN r_CRs       crs WITH(NOLOCK)  ON crs.CRID=tst.CRID  
       INNER JOIN r_Stocks    rs WITH(NOLOCK)   ON rs.StockID=crs.StockID             
       INNER JOIN r_Desks     rd WITH(NOLOCK)   ON rd.DeskCode=tst.DeskCode   
       INNER JOIN r_Emps      re WITH(NOLOCK)   ON re.EmpID=tst.EmpID   
       INNER JOIN r_Prods     rp WITH(NOLOCK)   ON rp.ProdID=tstd.ProdID   
       WHERE 1=1 --AND tst.ChID = 70000695                   
       GROUP BY   
       rp.ProdName, tstd.UM, tstd.PriceCC_wt, tstd.PurPriceCC_wt, re.UAEmpName, rd.DeskName, rs.Notes , rd.Notes  
       ) m   
       WHERE m.Qty<>0  
       ORDER BY m.ProdName
       
       
       SELECT * FROM t_SaleTemp
       
       SELECT HOST_NAME() HostName