  SET NOCOUNT ON

  SET XACT_ABORT ON

  /* Процедура расчёта инвентаризации на основании остатков на дату */
  
  
  BEGIN TRAN
  DECLARE @ChID INT 
  DECLARE @DocDate SMALLDATETIME, @OurID TINYINT, @StockID INT
  DECLARE @ProdID INT, @UM VARCHAR(10), @KursMC NUMERIC(21,9), @Qty NUMERIC(21,9)
  DECLARE @DifQty NUMERIC(21,9), @NewQty NUMERIC(21,9), @SrcPosID INT
  DECLARE @PPID INT, @PriceCC NUMERIC(21,9)
  
  SET @ChID = 100000033
  SELECT TOP 1 @DocDate = DocDate, @OurID = OurID, @StockID = StockID, @KursMC = KursMC 
  FROM t_Ven WITH(NOLOCK) 
  WHERE ChID = @ChID
  
  SELECT  @DocDate , @OurID , @StockID , @KursMC  
  
  
  
  DELETE t_VenD WHERE ChID = @ChID 
  
  CREATE TABLE #TRemD (
	OurID INT,
	StockID INT,
	ProdID INT,
	PPID INT,
	Qty NUMERIC (21, 9)
   )                         
  
  INSERT #TRemD
  SELECT OurID, StockID, ProdID, PPID, SUM(Qty-AccQty) Qty
  FROM zf_t_CalcRemByDateDate ('19000101', @DocDate) 
  WHERE OurID = @OurID AND StockID = @StockID
  GROUP BY OurID, StockID, ProdID, PPID 
  
  SELECT * FROM #TRemD
  
  
  DECLARE VenD CURSOR FOR
  SELECT ProdID,UM,(TQty - TNewQty) DifQty
  FROM t_VenA WITH(NOLOCK)
  WHERE ChID = @ChID AND (TQty - TNewQty) != 0
  ORDER BY TSrcPosID
  
  OPEN VenD
  FETCH NEXT FROM VenD INTO @ProdID, @UM, @DifQty
  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @SrcPosID = 1
    
    IF @DifQty > 0
    BEGIN
      DECLARE VenDPPIDs CURSOR FOR
      SELECT rd.PPID, Qty RemQty, (tp.CostMC * @KursMC) PriceCC
      FROM #TRemD rd
      JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = rd.ProdID AND tp.PPID = rd.PPID
      WHERE rd.ProdID = @ProdID AND Qty != 0
      ORDER BY rd.PPID
  
      OPEN VenDPPIDs
      FETCH NEXT FROM VenDPPIDs INTO @PPID, @Qty, @PriceCC
      WHILE (@@FETCH_STATUS = 0 AND @DifQty != 0)
      BEGIN
        IF @Qty >= @DifQty
        BEGIN
          SET @NewQty = @Qty - @DifQty
          
          INSERT t_VenD
          (ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt, PriceCC_wt, Tax, TaxSum,
           SumCC_nt, SumCC_wt, NewQty, NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID)
          VALUES 
          (@ChID, @ProdID, @SrcPosID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID), @PriceCC, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID), dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID) * @Qty,
          dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID) * @Qty, (@PriceCC * @Qty), @NewQty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID) * @NewQty,dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID) * @NewQty, (@PriceCC * @NewQty), 1)
          
          UPDATE #TRemD
          SET Qty = (Qty - @Qty + @NewQty)
          WHERE ProdID = @ProdID AND PPID = @PPID            
          
          SET @DifQty = 0
          SET @SrcPosID += 1
        END
        ELSE
        BEGIN
          SET @NewQty = 0
        
          INSERT t_VenD
          (ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt, PriceCC_wt, Tax, TaxSum,
           SumCC_nt, SumCC_wt, NewQty, NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID)
          VALUES 
          (@ChID, @ProdID, @SrcPosID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID), @PriceCC, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID),dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID) * @Qty,
          dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID) * @Qty,(@PriceCC * @Qty), @NewQty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID) * @NewQty, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID) * @NewQty, (@PriceCC * @NewQty), 1)
          
          UPDATE #TRemD
          SET Qty = (Qty - @Qty)
          WHERE ProdID = @ProdID AND PPID = @PPID        
          
          SET @DifQty = @DifQty - @Qty
          SET @SrcPosID += 1
        END
        
        FETCH NEXT FROM VenDPPIDs INTO @PPID, @Qty, @PriceCC
      END  
      CLOSE VenDPPIDs
      DEALLOCATE VenDPPIDs
    END
    
    IF @DifQty < 0
    BEGIN
      SELECT @Qty = 0, @NewQty = 0
    
      SELECT TOP 1 @PPID = MAX(PPID) FROM #TRemD WHERE ProdID = @ProdID
      
      IF @PPID IS NULL
        SELECT TOP 1 @PPID = ISNULL(MAX(PPID),0) FROM t_PInP WITH(NOLOCK) WHERE ProdID = @ProdID AND ProdDate <= @DocDate
         
      SELECT TOP 1 @Qty = ISNULL(Qty, 0)
      FROM #TRemD
      WHERE ProdID = @ProdID AND PPID = @PPID
      
      SELECT @NewQty = (@Qty - @DifQty)
      
      SELECT TOP 1 @PriceCC = CostMC * @KursMC FROM t_PInP WITH(NOLOCK) WHERE ProdID = @ProdID AND PPID = @PPID
      
      INSERT t_VenD
      (ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt, PriceCC_wt, Tax, TaxSum,
       SumCC_nt, SumCC_wt, NewQty, NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID)
      VALUES 
      (@ChID, @ProdID, @SrcPosID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID) ,@PriceCC, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID), dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID) * @Qty,
       dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID) * @Qty, (@PriceCC * @Qty), @NewQty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID) * @NewQty, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID) * @NewQty, (@PriceCC * @NewQty),1)
      
      UPDATE #TRemD
      SET Qty = (Qty - @Qty + @NewQty)
      WHERE ProdID = @ProdID AND PPID = @PPID      
      
      SET @SrcPosID += 1
    END
    FETCH NEXT FROM VenD INTO @ProdID, @UM, @DifQty
  END
  CLOSE VenD
  DEALLOCATE VenD
  
  IF @@TRANCOUNT > 0
    COMMIT
  ELSE
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! Расчёт инвентаризации завершился с ошибкой!', 18, 1)
    ROLLBACK
  END  
  
  
  
