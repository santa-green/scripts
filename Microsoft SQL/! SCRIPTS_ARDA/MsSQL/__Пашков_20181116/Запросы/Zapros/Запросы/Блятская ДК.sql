(NOT EXISTS 
(SELECT ProdID, SUM(t_SaleTempD.Qty) 
 FROM t_SaleTempD, r_Discs, t_SaleTemp
 WHERE t_SaleTempD.ChID = t_SaleTemp.ChID AND t_SaleTemp.ChID = @ChID 
      AND t_SaleTemp.StockID = 1310 AND t_SaleTempD.ProdID BETWEEN 605429 AND 605436 
      AND r_Discs.DiscCode = 30 AND r_Discs.InUse = 1
      AND %CURRENT_DATE% BETWEEN r_Discs.BDate AND r_Discs.EDate
 GROUP BY t_SaleTempD.ProdID 
 HAVING SUM(t_SaleTempD.Qty) >= 3) 
AND NOT EXISTS 
(SELECT SUM(t_SaleTempD.Qty) 
 FROM t_SaleTemp, t_SaleTempD, r_Discs
 WHERE t_SaleTempD.ChID = t_SaleTemp.ChID AND t_SaleTemp.ChID = @ChID 
     AND t_SaleTemp.StockID = 1310 AND t_SaleTempD.ProdID = 601842 AND r_Discs.DiscCode = 33 
     AND %CURRENT_DATE% BETWEEN r_Discs.BDate AND r_Discs.EDate AND r_Discs.InUse = 1
 HAVING SUM(t_SaleTempD.Qty) >= 1)
AND NOT EXISTS
(SELECT *
 FROM r_ProdMP WITH(NOLOCK) 
 WHERE r_ProdMP.ProdID = t_SaleTempD.ProdID AND r_ProdMP.PLID = t_SaleTempD.PLID
     AND %CURRENT_DATE% BETWEEN r_ProdMP.BDate AND r_ProdMP.EDate 
     AND r_ProdMP.PromoPriceCC > 0 AND r_ProdMP.PromoPriceCC < r_ProdMP.PriceMC AND r_ProdMP.InUse = 1))
AND NOT ((CAST(GETDATE() AS TIME(0)) BETWEEN '12:00:00' AND '15:45:00' AND DATEPART(dw, %CURRENT_DATE%) BETWEEN 2 AND 6) 
         AND EXISTS  
         (SELECT * 
          FROM t_SaleTemp 
          WHERE t_SaleTemp.StockID IN (1202,1222) AND t_SaleTemp.ChID = @ChID AND %CURRENT_DATE% = t_SaleTemp.DocDate 
            AND CAST(t_SaleTemp.DocTime AS TIME(0)) BETWEEN '12:00:00' AND '15:45:00') 
            AND EXISTS (SELECT * 
                        FROM r_Prods WITH(NOLOCK) 
                        WHERE r_Prods.ProdID = t_SaleTempD.ProdID AND r_Prods.PCatID IN (210,211)))
-----3

	(NOT EXISTS 
(SELECT ProdID, SUM(t_SaleTempD.Qty) 
 FROM t_SaleTempD, r_Discs, t_SaleTemp
 WHERE t_SaleTempD.ChID = t_SaleTemp.ChID AND t_SaleTemp.ChID = @ChID 
      AND t_SaleTemp.StockID = 1310 AND t_SaleTempD.ProdID BETWEEN 605429 AND 605436 
      AND r_Discs.DiscCode = 30 AND r_Discs.InUse = 1
      AND %CURRENT_DATE% BETWEEN r_Discs.BDate AND r_Discs.EDate
 GROUP BY t_SaleTempD.ProdID 
 HAVING SUM(t_SaleTempD.Qty) >= 3) 
AND NOT EXISTS 
(SELECT SUM(t_SaleTempD.Qty) 
 FROM t_SaleTemp, t_SaleTempD, r_Discs
 WHERE t_SaleTempD.ChID = t_SaleTemp.ChID AND t_SaleTemp.ChID = @ChID 
     AND t_SaleTemp.StockID = 1310 AND t_SaleTempD.ProdID = 601842 AND r_Discs.DiscCode = 33 
     AND %CURRENT_DATE% BETWEEN r_Discs.BDate AND r_Discs.EDate AND r_Discs.InUse = 1
 HAVING SUM(t_SaleTempD.Qty) >= 1)
AND NOT EXISTS
(SELECT *
 FROM r_ProdMP WITH(NOLOCK) 
 WHERE r_ProdMP.ProdID = t_SaleTempD.ProdID AND r_ProdMP.PLID = t_SaleTempD.PLID
     AND %CURRENT_DATE% BETWEEN r_ProdMP.BDate AND r_ProdMP.EDate 
     AND r_ProdMP.PromoPriceCC > 0 AND r_ProdMP.PromoPriceCC < r_ProdMP.PriceMC AND r_ProdMP.InUse = 1))
AND NOT ((CAST(GETDATE() AS TIME(0)) BETWEEN '12:00:00' AND '15:45:00' AND DATEPART(dw, %CURRENT_DATE%) BETWEEN 2 AND 6) 
         AND EXISTS  
         (SELECT * 
          FROM t_SaleTemp 
          WHERE t_SaleTemp.StockID IN (1202,1222) AND t_SaleTemp.ChID = @ChID AND %CURRENT_DATE% = t_SaleTemp.DocDate 
            AND CAST(t_SaleTemp.DocTime AS TIME(0)) BETWEEN '12:00:00' AND '15:45:00') 
            AND EXISTS (SELECT * 
                        FROM r_Prods WITH(NOLOCK) 
                        WHERE r_Prods.ProdID = t_SaleTempD.ProdID AND r_Prods.PCatID IN (210,211)))
---фиксир


(NOT EXISTS 
(SELECT ProdID, SUM(Qty) 
 FROM t_SaleTempD, r_Discs
 WHERE t_SaleTempD.ChID = @ChID AND ProdID BETWEEN 605429 AND 605436 
     AND DiscCode = 30 AND dbo.zf_GetDate(GETDATE()) BETWEEN BDate AND EDate AND InUse = 1
 GROUP BY ProdID 
 HAVING SUM(Qty) >= 3 ) 
AND NOT EXISTS 
(SELECT SUM(Qty) 
 FROM t_SaleTempD, r_Discs
 WHERE t_SaleTempD.ChID = @ChID AND ProdID = 601842 AND DiscCode = 33 
     AND dbo.zf_GetDate(GETDATE()) BETWEEN BDAte AND EDate AND InUse = 1
 HAVING SUM(Qty) >= 1)
AND NOT EXISTS
(SELECT *
 FROM r_ProdMP WITH(NOLOCK) 
 WHERE ProdID = t_SaleTempD.ProdID AND PLID = t_SaleTempD.PLID
     AND dbo.zf_GetDate(GETDATE()) BETWEEN BDate AND EDate 
     AND PromoPriceCC > 0 AND PromoPriceCC < PriceMC AND InUse = 1))
AND NOT ((CAST(GETDATE() AS TIME(0)) BETWEEN '12:00:00' AND '16:45:00') AND EXISTS (SELECT * FROM t_SaleTemp WHERE ChID = @ChID AND dbo.zf_GetDate(GETDATE()) = DocDate AND CAST(DocTime AS TIME(0)) BETWEEN '12:00:00' AND '16:45:00') AND EXISTS (SELECT * FROM r_Prods WITH(NOLOCK) WHERE ProdID = t_SaleTempD.ProdID AND PCatID IN (210,211)))
