  SET NOCOUNT ON -- не выводит количество обработанных строк в "командной строке"
  /* Процедура повторного списания по документу "Продажа товара оператором */
  
  /* kaa0 20150605 - Акциз теперь рассчитывается только для тех товаров, для которых он был рассчитан предварительно */  
  
  --EXEC ap_ReWriteOffNegRems '20140917', 9, 1251, 11035
  
  
--pvm0 04.09.2017 15.50 теперь если небыло продаж то ошибку выдавать не будет

 -- SET XACT_ABORT ON -- если ошибка, то транзакция откатывается
  
  DECLARE @TRANCOUNT INT = @@TRANCOUNT
  
  DECLARE 
   @DocDate SMALLDATETIME = '2018-09-12 00:00:00', @OurID INT = 6, @StockID INT = 1201, @DocCode INT = 11035,
   @ChID INT, 
   @ProdID INT, 
   @PPID INT, 
   @UM VARCHAR(10), 
   @Qty NUMERIC(21,9),
   @DQty NUMERIC(21,9),
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
   @IsExcise BIT,
   @RQty int,
   @LQty int


  /* Проверка корректности Фирмы */
  IF ISNULL(@OurID, -1) NOT IN (6,7,9,12)
  BEGIN
    RAISERROR ('[ap_ReWriteOffNegRems] ВНИМАНИЕ!!! Указана неверная Фирма! Действие отменено.', 18, 1)
    RETURN
  END
  
  /* Проверка корректности Склада */
  IF ISNULL(@StockID, -1) NOT IN (1001,1201,1202,1252,1257,1245,1241,1243,1310,1314,1315,723)
  BEGIN
  IF ISNULL(@StockID, -1) NOT IN (SELECT StockID FROM r_Stocks WITH(NOLOCK) WHERE DepID = 21 AND IsWholesale = 0)
  BEGIN
    RAISERROR ('[ap_ReWriteOffNegRems] ВНИМАНИЕ!!! Указан неверный Склад! Действие отменено.', 18, 1)
    IF @TRANCOUNT > 0 ROLLBACK
    RETURN
  END
  END
  
  /* Проверка корректности Документа */  
  IF ISNULL(@DocCode, -1) NOT IN (11035,11012)
  BEGIN
    RAISERROR ('[ap_ReWriteOffNegRems] ВНИМАНИЕ!!! Выбран неверный документ! Действие отменено.', 18, 1)
    RETURN
  END  
	
	--pvm0 15.08.2017 (согласовано c Ровнягиной Натальей)
    --Запрет запуска мастера повторного списания, если дата документа на 10 дней меньше текущей даты, кроме списка исключений 
    /*IF SUSER_SNAME() NOT IN ('rnu','kkm0','gdn1','pvm0'   -- списка исключений     
								,'hvv5') --pvm0 01.10.2017 11.06 временно для хамазы (согласовано c Ровнягиной Натальей) 
    IF @DocDate < dbo.zf_GetDate(GETDATE()) - 11
    BEGIN
      RAISERROR ('[ap_ReWriteOffNegRems] ВНИМАНИЕ!!! Запуск мастера повторного списания доступен только за сегодня и предыдущих 10 дней! Действие отменено.', 18, 1)
      RETURN
    END */
 
 	--pvm0 09.10.2017 16.19 времено для хамазы (согласовано c Ровнягиной Натальей)
    --Запрет запуска мастера повторного списания, если дата документа на 17 дней меньше текущей даты, кроме списка исключений 
    IF SUSER_SNAME() NOT IN ('rnu','kkm0','gdn1','pvm0') -- списка исключений 
    IF @DocDate < dbo.zf_GetDate(GETDATE()) - 18
    BEGIN
      RAISERROR ('[ap_ReWriteOffNegRems] ВНИМАНИЕ!!! Запуск мастера повторного списания доступен только за сегодня и предыдущих 17 дней! Действие отменено.', 18, 1)
      RETURN
    END 
  
  --IF @TRANCOUNT = 0 
    BEGIN TRAN           
  
  
  /* Временная таблица для хранения остатков на дату */
  CREATE TABLE #TRemDD (
	ProdID INT,
	PPID INT,
	Qty NUMERIC (21, 9),
	AccQty NUMERIC (21, 9))
	
  IF @DocCode = 11035 /* Продажа товара оператором */
  BEGIN	 
    /* Временная таблица для промежуточной выгрузки данных из документа "Продажа товара" */
    CREATE TABLE #TSaleD (
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
   
    --CREATE NONCLUSTERED INDEX ChID ON #TSaleD (ChID ASC)   
          
    INSERT #TSaleD
     (ChID, ProdID, UM, Qty, PriceCC_nt, Tax, PriceCC_wt, BarCode, TaxTypeID, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, RealPrice, PLID, Discount, IsExcise)
    SELECT 
     d.ChID, d.ProdID, d.UM, SUM(d.Qty) Qty, d.PriceCC_nt, d.Tax, d.PriceCC_wt, d.BarCode, d.TaxTypeID, d.SecID, d.PurPriceCC_nt, d.PurTax, 
     d.PurPriceCC_wt, d.RealPrice, d.PLID, d.Discount, CASE ISNULL(l.LevySum,0) WHEN 0 THEN 0 ELSE 1 END IsExcise
    FROM t_SaleD d WITH(NOLOCK)
    JOIN t_Sale m WITH(NOLOCK) ON m.ChID = d.ChID
    LEFT JOIN t_SaleDLV l WITH(NOLOCK) ON l.ChID = d.ChID AND l.SrcPosID = d.SrcPosID
    WHERE m.OurID = @OurID AND m.StockID = @StockID AND m.DocDate = @DocDate AND m.StateCode != 150
			and d.ChID = 100638106
    GROUP BY 
     d.ChID, d.ProdID, d.UM, d.PriceCC_nt, d.Tax, d.PriceCC_wt, d.BarCode, d.TaxTypeID, d.SecID, d.PurPriceCC_nt, d.PurTax, 
     d.PurPriceCC_wt, d.RealPrice, d.PLID, d.Discount, l.LevySum
     HAVING SUM(d.Qty) > 5
    ORDER BY d.ChID, d.ProdID
    
    SELECT * FROM #TSaleD

	--SELECT * FROM #TSaleD where Qty > 0
    --DELETE d 
    --FROM t_SaleD d 
    --JOIN #TSaleD t ON t.ChID = d.ChID
  
    INSERT #TRemDD
    SELECT ProdID, PPID, Qty, AccQty 
    FROM dbo.af_CalcRemD_F(@DocDate, @OurID, @StockID, 1, NULL)
    WHERE Qty > 0
    ORDER BY PPID
    
	SELECT * FROM #TRemDD
	where ProdID = 800780
  
    DECLARE ReWriteOff CURSOR FOR
    SELECT 
     ChID, ProdID, UM, Qty, PriceCC_nt, Tax, PriceCC_wt, BarCode, TaxTypeID, SecID, 
     PurPriceCC_nt, PurTax, PurPriceCC_wt, RealPrice, PLID, Discount, IsExcise     
    FROM #TSaleD  
  
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
          
        SELECT @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SaleD WITH(NOLOCK) WHERE ChID = @ChID OPTION(FAST 1)                
        --SELECT @PPID
        --INSERT t_SaleD
        --(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
        -- BarCode, TaxTypeID, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, RealPrice, RealSum, PLID, Discount)
        --VALUES 
        --(@ChID, @SrcPosID, @ProdID, @PPID, @UM, @Qty, @PriceCC_nt, (@PriceCC_nt * @Qty), @Tax, (@Tax * @Qty), @PriceCC_wt, (@PriceCC_wt * @Qty),
        -- @BarCode, @TaxTypeID, @SecID, @PurPriceCC_nt, @PurTax, @PurPriceCC_wt, @RealPrice, (@RealPrice * @Qty), @PLID, @Discount)
        
        /* Перерасчет акцизного сбора */ 
        IF @IsExcise = 1
          --INSERT t_SaleDLV
          --(ChID, SrcPosID, LevyID, LevySum)
          --VALUES
          --(@ChID, @SrcPosID, @LevyID, ROUND(((@RealPrice * @Qty) / 105) * 5, 2))
        
        UPDATE #TRemDD
        SET Qty -= @Qty
        WHERE ProdID = @ProdID AND PPID = @PPID                 
        
        SET @SumQty -= @Qty
        
        FETCH NEXT FROM ReWriteOffPPIDs INTO @PPID, @Qty
      END
      CLOSE ReWriteOffPPIDs
      DEALLOCATE ReWriteOffPPIDs
      
      SELECT @DQty = ISNULL (sum (qty),0) FROM #TRemDD WHERE ProdID = @ProdID
	  SELECT @DQty
	  IF @DQty <=0
	  BEGIN
	  SELECT @OldQty = ISNULL(SUM(Qty),0) FROM #TSaleD WITH(NOLOCK) WHERE ChID = @ChID AND ProdID = @ProdID AND PriceCC_wt = @PriceCC_wt
      END
      
      SELECT @NewQty = ISNULL(SUM(Qty),0) FROM t_SaleD WITH(NOLOCK) WHERE ChID = @ChID AND ProdID = @ProdID AND PriceCC_wt = @PriceCC_wt
      
      IF (@OldQty > @NewQty)
      BEGIN 
        SELECT @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SaleD WITH(NOLOCK) WHERE ChID = @ChID
        SELECT @PPID = MAX(PPID) FROM t_SaleD WITH(NOLOCK) WHERE ProdID = @ProdID AND ChID = @ChID
        
        IF (ISNULL(@PPID, 0) = 0)
          SELECT @PPID = MAX(PPID) FROM t_PInP WITH(NOLOCK) WHERE ProdID = @ProdID AND ISNULL(ProdDate, 0) <= @DocDate           
        
        --INSERT t_SaleD
        --(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
        -- BarCode, TaxTypeID, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, RealPrice, RealSum, PLID, Discount)
        --VALUES 
        --(@ChID, @SrcPosID, @ProdID, @PPID, @UM, (@OldQty - @NewQty), @PriceCC_nt, @PriceCC_nt * (@OldQty - @NewQty),
        -- @Tax, @Tax * (@OldQty - @NewQty), @PriceCC_wt, @PriceCC_wt * (@OldQty - @NewQty),
        -- @BarCode, @TaxTypeID, @SecID, @PurPriceCC_nt, @PurTax, @PurPriceCC_wt, @RealPrice, (@RealPrice * (@OldQty - @NewQty)), @PLID, @Discount) 
         
        /* Перерасчет акцизного сбора */ 
        IF @IsExcise = 1
          --INSERT t_SaleDLV
          --(ChID, SrcPosID, LevyID, LevySum)
          --VALUES
          --(@ChID, @SrcPosID, @LevyID, ROUND(((@RealPrice * (@OldQty - @NewQty)) / 105) * 5, 2))         
        
        UPDATE #TRemDD
        SET Qty -= (@OldQty - @NewQty)
        WHERE ProdID = @ProdID AND PPID = @PPID                                  
      END
    
      FETCH NEXT FROM ReWriteOff INTO 
       @ChID, @ProdID, @UM, @Qty, @PriceCC_nt, @Tax, @PriceCC_wt, @BarCode, @TaxTypeID, @SecID, 
       @PurPriceCC_nt, @PurTax, @PurPriceCC_wt, @RealPrice, @PLID, @Discount, @IsExcise
    END
    CLOSE ReWriteOff
    DEALLOCATE ReWriteOff
    


    SELECT @OldTSumCC = SUM(PriceCC_wt * Qty) FROM #TSaleD
          
    SELECT  @RQty = SUM (Qty) FROM #TSaleD
    SELECT  @LQty = SUM (Qty) FROM t_SaleD WHERE ChID IN (SELECT ChID FROM #TSaleD )
  
    SELECT @NewTSumCC = SUM(TSumCC_wt) FROM t_Sale m WITH(NOLOCK) WHERE EXISTS (SELECT * FROM #TSaleD WHERE ChID = m.ChID)
    
   -- DROP TABLE #TSaleD
  END
      
--  DROP TABLE #TRemDD   
SELECT * FROM #TRemDD
	where ProdID = 800780
ROLLBACK TRAN;

/*
  IF ROUND(ISNULL(@OldTSumCC,0),4) = ROUND(ISNULL(@NewTSumCC,1),4)
  BEGIN
    IF @TRANCOUNT = 0 AND @@TRANCOUNT > 0
      COMMIT
  END
  ELSE
  BEGIN
    IF @@TRANCOUNT > @TRANCOUNT ROLLBACK
    DECLARE @STR VARCHAR(250) = CAST(CAST(@OldTSumCC AS NUMERIC(21,4)) AS VARCHAR(25)) + ' - ' + CAST(CAST(@NewTSumCC AS NUMERIC(21,4)) AS VARCHAR(25)) + ' - ' + 
    CAST(CAST(@RQty AS NUMERIC(21,4)) AS VARCHAR(25))+ ' - ' + CAST(CAST(@LQty AS NUMERIC(21,4)) AS VARCHAR(25))
--pvm0 04.09.2017 15.50 теперь если небыло продаж то ошибку выдавать не будет
    IF @STR is null SELECT 'Нет данных за этот день'
    ELSE  RAISERROR ('[ap_ReWriteOffNegRems] ВНИМАНИЕ!!! Процедура повторного списания отработала с ошибкой! %s', 18, 1, @STR)
  END*/