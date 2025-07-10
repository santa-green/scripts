   /* 
  EXEC ap_CalcSRec_B_date_E_date '20161229', '20161229', 12, 1314, 11035
   */
 
 /* Проверка наличия калькуляционных карт */
  --IF @DocCode = 11035 /* Продажа товара оператором */
  BEGIN
    IF EXISTS(
    
    SELECT *
              FROM t_Sale m WITH(NOLOCK)
              JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
              JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892,800895,800896)
              JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
              JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID AND mp.DepID <>0
              JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
              WHERE m.DocDate = '20161229'  AND m.OurID = 12 AND m.StockID = 1314 AND m.StateCode = 22 
              AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID))
 
 select * from ir_StockSubs where StockID = 1314 and DepID = 11
 select * from r_ProdMP where ProdID = 607166 and PLID = 76 -- DepID = 11
 select * from r_Stocks where StockID = 1314 --PLID = 76
 SELECT * FROM [dbo].[af_GetMissSpecs](12,1314,1204,'20161229',607166)
 
              
              )
    BEGIN
      SELECT @Msg = @Msg + ',' + CAST(ProdID AS VARCHAR(10))
      FROM (SELECT DISTINCT f.ProdID
            FROM t_Sale m WITH(NOLOCK)
            JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
            JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892)
            JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
            JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID
            JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
            CROSS APPLY [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID) f
            WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22) q
  END