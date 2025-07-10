--старая
USE [ElitV_KIEV_backup_2016-08-31]
GO
/****** Object:  StoredProcedure [dbo].[ap_ReWriteOffNegRems]    Script Date: 09/01/2016 15:37:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_ReWriteOffNegRems] (@DocDate SMALLDATETIME, @OurID INT = NULL, @StockID INT = NULL)
AS
BEGIN
  SET NOCOUNT ON
  
  /* Процедура повторного списания по документу "Продажа товара оператором */
  
  /* kaa0 20150605 - Акциз теперь повторно рассчитывается только для тех товаров, для которых он был рассчитан предварительно */
  
  --EXEC ap_ReWriteOffNegRems '20101206', '20101206', 9, 1202

  SET XACT_ABORT ON
  
  DECLARE @TRANCOUNT INT = @@TRANCOUNT
  
  DECLARE 
   @ChID INT, 
   @ProdID INT, 
   @PPID INT, 
   @UM VARCHAR(10), 
   @Qty NUMERIC(21,9),
   @PriceCC_nt NUMERIC(21,9), 
   @Tax NUMERIC(21,9), 
   @PriceCC_wt NUMERIC(21,9), 
   @BarCode VARCHAR(42),
   @TaxTypeID TINYINT, 
   @SecID TINYINT, 
   @PurPriceCC_nt NUMERIC(21,9), 
   @PurTax NUMERIC(21,9),
   @PurPriceCC_wt NUMERIC(21,9),
   @RealPrice NUMERIC(21,9), 
   @PLID TINYINT, 
   @Discount NUMERIC(21,9),
   @SumQty NUMERIC(21,9), 
   @RemQty NUMERIC(21,9), 
   @SrcPosID INT, 
   @OldQty NUMERIC(21,9), 
   @NewQty NUMERIC(21,9),
   @OldTSumCC NUMERIC(21,9), 
   @NewTSumCC NUMERIC(21,9),
   @LevyID INT = 1,
   @IsExcise BIT

  /* Проверка корректности Фирмы */
  IF ISNULL(@OurID, -1) != 9
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! Указана неверная Фирма! Действие отменено.', 18, 1)
    RETURN
  END
  
  /* Проверка корректности Склада */
  IF ISNULL(@StockID, -1) NOT IN (1201,1202,1221,1222,1310,1225,723)
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! Указан неверный Склад! Действие отменено.', 18, 1)
    RETURN
  END
  
  /* Запрет запуска мастера повторного списания по складам торгового зала супермаркетов (05.04.2013 - diablo)*/
  IF @StockID IN (1201,1221)
  BEGIN
    IF SUSER_SNAME() NOT IN ('rnu','kev19','kaa0','kkm0','biv0','rss0', 'dgn1' ,'ven3','pvm0')
    BEGIN
      RAISERROR ('ВНИМАНИЕ!!! У Вас нет прав на использование мастера повторного списания. Действие отменено.', 18, 1)
      RETURN
    END
    IF SUSER_SNAME() NOT IN ('rnu','kev19','biv0','rss0','ven3')
    IF @DocDate < dbo.zf_GetDate(GETDATE()) - 6
    BEGIN
      RAISERROR ('ВНИМАНИЕ!!! Запуск мастера повторного списания доступен только за сегодня и предыдущие 5 дней! Действие отменено.', 18, 1)
      RETURN
    END
    IF SUSER_SNAME() IN ('kev19','biv0','rss0','dgn1','ven3')
    IF @DocDate < dbo.zf_GetDate(GETDATE()) - 16
    BEGIN
      RAISERROR ('ВНИМАНИЕ!!! Запуск мастера повторного списания доступен только за сегодня и предыдущие 15 дней! Действие отменено.', 18, 1)
      RETURN
    END
    IF SUSER_SNAME() IN ('rnu')
    IF @DocDate < dbo.zf_GetDate(GETDATE()) - 31
    BEGIN
      RAISERROR ('ВНИМАНИЕ!!! Запуск мастера повторного списания доступен только за сегодня и предыдущие 30 дней! Действие отменено.', 18, 1)
      RETURN
    END
  END    
  
  IF @TRANCOUNT = 0 
    BEGIN TRAN           
  
  /* Временная таблица для промежуточной выгрузки данных из документа "Продажа товара" */
  CREATE TABLE #TSaleD (
    DocDate SMALLDATETIME, 
    ChID INT, 
    ProdID INT, 
    UM VARCHAR(42), 
    Qty NUMERIC(21,9), 
    PriceCC_nt NUMERIC(21,9),
    Tax NUMERIC(21,9), 
    PriceCC_wt NUMERIC(21,9), 
    BarCode VARCHAR(42), 
    TaxTypeID TINYINT,
    SecID INT, 
    PurPriceCC_nt NUMERIC(21,9), 
    PurTax NUMERIC(21,9), 
    PurPriceCC_wt NUMERIC(21,9),
    RealPrice NUMERIC(21,9),
    PLID TINYINT, 
    Discount NUMERIC(21,9),
    IsExcise BIT)
   
  CREATE NONCLUSTERED INDEX ChID ON #TSaleD (ChID ASC) 
  CREATE NONCLUSTERED INDEX DocDate ON #TSaleD (DocDate ASC)    
  
  /* Временная таблица для хранения остатков на дату */
  CREATE TABLE #TRemDD (
	ProdID INT,
	PPID INT,
	Qty NUMERIC (21, 9),
	AccQty NUMERIC (21, 9))       
  
  INSERT #TSaleD
  (DocDate, ChID, ProdID, UM, Qty, PriceCC_nt, Tax, PriceCC_wt, BarCode, TaxTypeID, SecID, 
   PurPriceCC_nt, PurTax, PurPriceCC_wt, RealPrice, PLID, Discount, IsExcise)
  SELECT 
   m.DocDate, d.ChID, d.ProdID, d.UM, SUM(d.Qty) Qty, d.PriceCC_nt, d.Tax, d.PriceCC_wt, d.BarCode, d.TaxTypeID, d.SecID, 
   d.PurPriceCC_nt, d.PurTax, d.PurPriceCC_wt, d.RealPrice, d.PLID, d.Discount, CASE ISNULL(l.LevySum,0) WHEN 0 THEN 0 ELSE 1 END IsExcise
  FROM t_SaleD d WITH(NOLOCK)
  JOIN t_Sale m WITH(NOLOCK) ON m.ChID = d.ChID
  LEFT JOIN t_SaleDLV l WITH(NOLOCK) ON l.ChID = d.ChID AND l.SrcPosID = d.SrcPosID
  WHERE m.OurID = @OurID AND m.StockID = @StockID AND m.DocDate = @DocDate AND m.StateCode != 150
  GROUP BY 
   m.DocDate, d.ChID, d.ProdID, d.UM, d.PriceCC_nt, d.Tax, d.PriceCC_wt, d.BarCode, d.TaxTypeID, d.SecID, 
   d.PurPriceCC_nt, d.PurTax, d.PurPriceCC_wt, d.RealPrice, d.PLID, d.Discount, l.LevySum 
  ORDER BY m.DocDate, d.ChID, d.ProdID
  
  DECLARE DocDate CURSOR LOCAL FAST_FORWARD FOR
  SELECT DISTINCT DocDate FROM #TSaleD ORDER BY DocDate
  
  OPEN DocDate
  FETCH NEXT FROM DocDate INTO @DocDate
  WHILE @@FETCH_STATUS = 0
  BEGIN
    DELETE d 
    FROM t_SaleD d 
    JOIN #TSaleD t ON t.ChID = d.ChID AND t.DocDate = @DocDate  
  
    INSERT #TRemDD
    SELECT ProdID, PPID, Qty, AccQty 
    FROM dbo.af_CalcRemD_F(@DocDate, @OurID, @StockID, 1, NULL)
  
    DECLARE ReWriteOff CURSOR FOR
    SELECT 
     ChID, ProdID, UM, Qty, PriceCC_nt, Tax, PriceCC_wt, BarCode, TaxTypeID, SecID, 
     PurPriceCC_nt, PurTax, PurPriceCC_wt, RealPrice, PLID, Discount, IsExcise     
    FROM #TSaleD  
    WHERE DocDate = @DocDate
  
    OPEN ReWriteOff
    FETCH NEXT FROM ReWriteOff INTO 
     @ChID, @ProdID, @UM, @Qty, @PriceCC_nt, @Tax, @PriceCC_wt, @BarCode, @TaxTypeID, @SecID, 
     @PurPriceCC_nt, @PurTax, @PurPriceCC_wt, @RealPrice, @PLID, @Discount, @IsExcise
  
    WHILE @@FETCH_STATUS = 0
    BEGIN    
      SET @SumQty = @Qty
      SET @OldQty = @Qty  
    
      DECLARE ReWriteOffPPIDs CURSOR FOR
      SELECT PPID, (Qty - AccQty) Qty
      FROM #TRemDD WITH(NOLOCK)
      WHERE ProdID = @ProdID AND (Qty - AccQty) > 0
      ORDER BY PPID
     
      OPEN ReWriteOffPPIDs
      FETCH NEXT FROM ReWriteOffPPIDs INTO @PPID, @Qty
      WHILE (@@FETCH_STATUS = 0) AND (@SumQty > 0)
      BEGIN
        IF @Qty > @SumQty
          SET @Qty = @SumQty 
          
        SELECT TOP 1 @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SaleD WITH(NOLOCK) WHERE ChID = @ChID OPTION(FAST 1)                
        
        INSERT t_SaleD
        (ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxTypeID, SecID, 
        PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, Discount, RealPrice, RealSum)
        VALUES 
        (@ChID, @SrcPosID, @ProdID, @PPID, @UM, @Qty, @PriceCC_nt, (@PriceCC_nt * @Qty), @Tax, (@Tax * @Qty), @PriceCC_wt, (@PriceCC_wt * @Qty), @BarCode, @TaxTypeID, @SecID, 
         @PurPriceCC_nt, @PurTax, @PurPriceCC_wt, @PLID, @Discount, @RealPrice, (@RealPrice * @Qty))
        
        /* Перерасчет акцизного сбора */ 
        IF @IsExcise = 1
          INSERT t_SaleDLV
          (ChID, SrcPosID, LevyID, LevySum)
          VALUES
          (@ChID, @SrcPosID, @LevyID, ROUND(((@RealPrice * @Qty) / 105) * 5, 2))        
        
        UPDATE #TRemDD
        SET Qty = (Qty - @Qty)
        WHERE ProdID = @ProdID AND PPID = @PPID                 
        
        SET @SumQty = @SumQty - @Qty
        
        FETCH NEXT FROM ReWriteOffPPIDs INTO @PPID, @Qty
      END
      CLOSE ReWriteOffPPIDs
      DEALLOCATE ReWriteOffPPIDs
      
      SELECT @NewQty = ISNULL(SUM(Qty),0) FROM t_SaleD WITH(NOLOCK) WHERE ChID = @ChID AND ProdID = @ProdID AND PriceCC_wt = @PriceCC_wt
      
      IF (@OldQty > @NewQty)
      BEGIN 
        SELECT @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SaleD WITH(NOLOCK) WHERE ChID = @ChID
        SELECT @PPID = MAX(PPID) FROM t_SaleD WITH(NOLOCK) WHERE ProdID = @ProdID AND ChID = @ChID
        
        IF (ISNULL(@PPID, 0) = 0)
          SELECT @PPID = MAX(PPID) FROM t_PInP WITH(NOLOCK) WHERE ProdID = @ProdID AND ISNULL(ProdDate, 0) <= @DocDate           
        
        INSERT t_SaleD
        (ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
         BarCode, TaxTypeID, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, Discount, RealPrice, RealSum)
        VALUES 
        (@ChID, @SrcPosID, @ProdID, @PPID, @UM, (@OldQty - @NewQty), @PriceCC_nt, @PriceCC_nt * (@OldQty - @NewQty),
         @Tax, @Tax * (@OldQty - @NewQty), @PriceCC_wt, @PriceCC_wt * (@OldQty - @NewQty),
         @BarCode, @TaxTypeID, @SecID, @PurPriceCC_nt, @PurTax, @PurPriceCC_wt, @PLID, @Discount, @RealPrice, (@RealPrice * (@OldQty - @NewQty))) 
         
        /* Перерасчет акцизного сбора */ 
        IF @IsExcise = 1
          INSERT t_SaleDLV
          (ChID, SrcPosID, LevyID, LevySum)
          VALUES
          (@ChID, @SrcPosID, @LevyID, ROUND(((@RealPrice * (@OldQty - @NewQty)) / 105) * 5, 2))        
        
        UPDATE #TRemDD
        SET Qty = (Qty - (@OldQty - @NewQty))
        WHERE ProdID = @ProdID AND PPID = @PPID                                  
      END
    
      FETCH NEXT FROM ReWriteOff INTO 
       @ChID, @ProdID, @UM, @Qty, @PriceCC_nt, @Tax, @PriceCC_wt, @BarCode, @TaxTypeID, @SecID, 
       @PurPriceCC_nt, @PurTax, @PurPriceCC_wt, @RealPrice, @PLID, @Discount, @IsExcise
    END
    CLOSE ReWriteOff
    DEALLOCATE ReWriteOff
    
    DELETE #TRemDD
    
    FETCH NEXT FROM DocDate INTO @DocDate
  END
  CLOSE DocDate
  DEALLOCATE DocDate
  
  SELECT @OldTSumCC = SUM(PriceCC_wt * Qty) FROM #TSaleD
  
  SELECT @NewTSumCC = SUM(TSumCC_wt) FROM t_Sale m WITH(NOLOCK) WHERE EXISTS (SELECT * FROM #TSaleD WHERE ChID = m.ChID)
  
  DROP TABLE #TSaleD
  DROP TABLE #TRemDD

  IF ROUND(ISNULL(@OldTSumCC,0),4)  = ROUND(ISNULL(@NewTSumCC,1),4)
  BEGIN
    IF @TRANCOUNT = 0 AND @@TRANCOUNT > 0
      COMMIT
  END
  ELSE
  BEGIN
    IF @@TRANCOUNT > @TRANCOUNT ROLLBACK
    DECLARE @STR VARCHAR(250) = CAST(CAST(ISNULL(@OldTSumCC, 0) AS NUMERIC(21,4)) AS VARCHAR(25)) + ' - ' + CAST(CAST(ISNULL(@NewTSumCC, 0) AS NUMERIC(21,4)) AS VARCHAR(25))
    RAISERROR ('ВНИМАНИЕ!!! Процедура повторного списания отработала с ошибкой! Суммы (старая - новая): %s', 18, 1, @STR)
    RETURN 1
  END
END     
        

