 --EXEC ap_CalcSRec '20161213', 12, 1314, 11035
  DECLARE 
   @CurrID SMALLINT, 
   @KursMC NUMERIC(21,9), 
   @ChID INT, 
   @DocID INT, 
   @AChID INT, 
   @SubSrcPosID INT,
   @DQty NUMERIC(21,9), 
   @SQty NUMERIC(21,9), 
   @SubPPID INT, 
   @SubQty NUMERIC(21,9), 
   @SubProdID INT,
   @SubPriceCC NUMERIC(21,9), 
   @SubUM VARCHAR(10), 
   @SubBarCode VARCHAR(42), 
   @SumQty NUMERIC(21,9),
   @SrcPosID INT, 
   @ProdID INT, 
   @UM VARCHAR(10), 
   @BarCode VARCHAR(42), 
   @Qty NUMERIC(21,9), 
   @RemQty NUMERIC(21,9),
   @PriceCC NUMERIC(21,9), 
   @PPID INT, 
   @SubStockID INT,
   @PPID_START INT, 
   @PPID_END INT, 
   @IsBlackSale TINYINT,
   @Msg VARCHAR(MAX) = '', 
   @STR VARCHAR(MAX), 
   @PSTR VARCHAR(255) = '',
   @Notes varchar (150),
   @BDate SMALLDATETIME,@EDate SMALLDATETIME = '20161214', @OurID INT = 12, @StockID INT = 1202, @DocCode INT = 11035
   
  --SELECT * FROM [dbo].[af_GetMissSpecs](12,1202,1204,'20161214',607438)
   
  SELECT m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID,*
              FROM t_Sale m WITH(NOLOCK)
              JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
              JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892,800895,800896)
              JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
              JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID AND mp.DepID <>0
              JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
              WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22 
              AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID))
  
SELECT DISTINCT f.ProdID
            FROM t_Sale m WITH(NOLOCK)
            JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
            JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892)
            JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
            JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID
            JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
            CROSS APPLY [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID) f
            WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22
   
  BEGIN
  
    IF EXISTS(SELECT *
              FROM t_Sale m WITH(NOLOCK)
              JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
              JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892,800895,800896)
              JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
              JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID AND mp.DepID <>0
              JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
              WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22 
              AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID)))
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
      SELECT @STR = SUBSTRING(@Msg,2,65535)
      SET @Msg = ''
      WHILE LEN(@STR) > 0
      BEGIN
        SET @PSTR = LEFT(@STR, 100)
        SET @STR = SUBSTRING(@STR,101,16000000)
        SET @Msg = @Msg + @PSTR + CHAR(13) + CHAR(10)
      END

      RAISERROR ('ВНИМАНИЕ!!! Для товаров [%s] не созданы калькуляционные карты! Действие отменено.', 18, 1, @Msg)   
	  RETURN
    END
  END