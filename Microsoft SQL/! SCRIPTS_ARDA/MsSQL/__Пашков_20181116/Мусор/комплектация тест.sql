      SELECT ProdID, PPID, SUM(Qty - AccQty) Qty
      FROM dbo.af_CalcRemD_F('20170218' ,9 , 1314, 1, NULL)
      GROUP BY ProdID, PPID
      HAVING ISNULL(SUM(Qty - AccQty),0) >= 0
      and ProdID in (600737)


    SELECT DISTINCT rss.SubStockID
    FROM t_Sale m WITH(NOLOCK)
    JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
    JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
    JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
    JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
    WHERE EXISTS (
		SELECT ChID FROM t_Sale WITH(NOLOCK) WHERE DocDate BETWEEN '20170218'  AND '20170218'   AND OurID = 9 AND StockID = 1314 AND StateCode = 22
     and ChID = m.ChID)
    ORDER BY rss.SubStockID
    
    SELECT ChID,* FROM t_Sale WITH(NOLOCK) WHERE DocDate BETWEEN '20170218'  AND '20170218'   AND OurID = 9 AND StockID = 1314 AND StateCode = 22
 
     SELECT m.ChID, d.ProdID, * FROM t_Sale m WITH(NOLOCK) 
     join t_SaleD d on  d.ChID = m.ChID
     WHERE DocDate BETWEEN '20170218'  AND '20170218'   AND OurID = 9 AND StockID = 1314 AND StateCode = 22
     and d.ProdID in (600737)
    
      /* Подготовка остатков на дату */  
      SELECT ProdID, PPID, SUM(Qty - AccQty) Qty
      FROM dbo.af_CalcRemD_F('20170218' , 9, 1203, 1, NULL)
      GROUP BY ProdID, PPID
      HAVING ISNULL(SUM(Qty - AccQty),0) >= 0 
      and ProdID in (600737)
      
      SELECT * FROM t_Rem where ProdID = 600737 and StockID = 1203
      and PPID = 727