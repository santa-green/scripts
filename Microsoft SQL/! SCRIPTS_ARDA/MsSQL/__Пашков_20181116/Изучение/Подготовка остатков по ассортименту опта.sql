  /* Подготовка остатков по ассортименту опта - (Арда-Трейдинг, Аквавит) */
  SELECT p.ProdID, CASE WHEN SUM(r.Qty - r.AccQty) > 500 THEN 500 ELSE SUM(r.Qty - r.AccQty) END Qty
  FROM r_Prods p WITH(NOLOCK) 
  JOIN r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = p.ProdID 
                               AND ((p.PGrID4 IN (2,8)AND ec.CompID IN (71,81))
                                    OR (p.PGrID4 = 3 AND ec.CompID = 72)
                                    OR (p.PGrID4 = 4 AND ec.CompID = 82))  
  JOIN [S-SQL-D4].Elit.dbo.t_Rem r WITH(NOLOCK) ON r.ProdID = ec.ExtProdID AND r.OurID = CASE WHEN p.PGrID4 IN (2,3,8) THEN 1 WHEN p.PGrID4 = 4 THEN 11 END 
  AND r.StockID = CASE WHEN p.PGrID4 IN (2) THEN 220 WHEN p.PGrID4 = 8 THEN 1130 END
   AND GETDATE() NOT BETWEEN '20150313 13:20:00' AND '20150313 16:00:00' /*остатки не будут выгружаться на момент переоценки в базе Elit      */
 --  AND GETDATE() NOT BETWEEN '20160105 12:00:00' AND '20160108 12:00:00' /*остатки не будут выгружаться на момент переоценки в базе Elit      */
 
 --JOIN [S-SQL-D4].Elit.dbo.r_ProdMP mp WITH(NOLOCK) ON mp.PLID = 66 AND mp.ProdID = ec.ExtProdID AND mp.PriceMC > 0
 
  WHERE p.PGrID4 IN (2,3,4,8) AND (p.PGrID1 NOT BETWEEN 600 AND 710 OR p.PGrID1 = 709) AND ISNUMERIC(ExtProdID) = 1
  --and p.ProdID = 600916
  GROUP BY p.ProdID 
  HAVING SUM(r.Qty - r.AccQty) > 0 
  
  EXCEPT 
  
    SELECT p.ProdID, CASE WHEN SUM(r.Qty - r.AccQty) > 500 THEN 500 ELSE SUM(r.Qty - r.AccQty) END Qty
  FROM r_Prods p WITH(NOLOCK) 
  JOIN r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = p.ProdID 
                               AND ((p.PGrID4 IN (2,8)AND ec.CompID IN (71,81))
                                    OR (p.PGrID4 = 3 AND ec.CompID = 72)
                                    OR (p.PGrID4 = 4 AND ec.CompID = 82))  
  JOIN [S-SQL-D4].Elit.dbo.t_Rem r WITH(NOLOCK) ON r.ProdID = ec.ExtProdID AND r.OurID = CASE WHEN p.PGrID4 IN (2,3,8) THEN 1 WHEN p.PGrID4 = 4 THEN 11 END 
  AND r.StockID = CASE WHEN p.PGrID4 IN (2) THEN 220 WHEN p.PGrID4 = 8 THEN 1130 END
   AND GETDATE() NOT BETWEEN '20150313 13:20:00' AND '20150313 16:00:00' /*остатки не будут выгружаться на момент переоценки в базе Elit      */
 --  AND GETDATE() NOT BETWEEN '20160105 12:00:00' AND '20160108 12:00:00' /*остатки не будут выгружаться на момент переоценки в базе Elit      */
 
 JOIN [S-SQL-D4].Elit.dbo.r_ProdMP mp WITH(NOLOCK) ON mp.PLID = 66 AND mp.ProdID = ec.ExtProdID AND mp.PriceMC > 0
 
  WHERE p.PGrID4 IN (2,3,4,8) AND (p.PGrID1 NOT BETWEEN 600 AND 710 OR p.PGrID1 = 709) AND ISNUMERIC(ExtProdID) = 1
  --and p.ProdID = 600916
  GROUP BY p.ProdID 
  HAVING SUM(r.Qty - r.AccQty) > 0 
