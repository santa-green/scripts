
  /* Процедура расчета инвентаризации для пересортицы по партиям */
  
  /*  EXEC ap_CalcVenPeresortByRemD 851*/
  DECLARE @ChID int = 851
 
  DECLARE 
   @Testing BIT = 1, /*Установка тестирования: 1 - режим тестирования включен; 0 - режим тестирования отключен;*/
   @DocDate SMALLDATETIME, 
   @OurID TINYINT, 
   @StockID INT,
   @ProdID INT, 
   @UM VARCHAR(10), 
   @KursMC NUMERIC(21,9), 
   @Qty NUMERIC(21,9),
   @TQty NUMERIC(21,9),
   @DifQty NUMERIC(21,9), 
   @NewQty NUMERIC(21,9), 
   @SrcPosID INT,
   @SrcPosID_Last INT = 0,
   @PPID INT, 
   @PPID_Start INT,
   @PPID_Last INT = 0,
   @PPID_End INT,
   @PriceCC NUMERIC(21,9),
   @Msg VARCHAR(MAX) = '',
   @ProdList VARCHAR(4000), 
   @BarCode VARCHAR(50),
   @TSrcPosID INT
	         
  SELECT TOP 1 @DocDate = DocDate, @OurID = OurID, @StockID = StockID, @KursMC = KursMC 
  FROM t_Ven WITH(NOLOCK) 
  WHERE ChID = @ChID
  
  IF @Testing = 1  /*При тестировании*/
  BEGIN
    SELECT TOP 1 @Msg = 'Инфо для отладки: ' + '@DocDate = ' + CONVERT(nvarchar(30),DocDate,104)  
		+ '  @OurID = ' + CAST(OurID AS VARCHAR(10)) + '  @StockID = ' + CAST(StockID AS VARCHAR(10))
    FROM t_Ven WITH(NOLOCK) WHERE ChID = @ChID
    SELECT @Msg
  END
  
  IF EXISTS (SELECT * FROM t_VenD WHERE ChID = @ChID )
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! Товарная часть уже заполнена. Создайте новый документ без товаров. %s', 18, 1, @Msg)
    RETURN
  END


  BEGIN TRAN
  
  --  DROP TABLE #TRemD
  
  CREATE TABLE #TRemD (
	OurID INT,
	StockID INT,
	ProdID INT,
	PPID INT,
	Qty NUMERIC (21, 9),
	AccQty NUMERIC (21, 9)
   )                         
  
  INSERT #TRemD
	SELECT OurID, StockID, ProdID, PPID, SUM(Qty) Qty, SUM(AccQty) AccQty
	FROM zf_t_CalcRemByDateDate ('19000101', @DocDate) 
	WHERE OurID = @OurID AND StockID = @StockID AND (Qty <> 0 OR AccQty <> 0)
	GROUP BY OurID, StockID, ProdID, PPID 
  
  IF @Testing = 1  /*При тестировании*/
  BEGIN
	DELETE _TRemD
	INSERT _TRemD
      SELECT * FROM #TRemD
  END
 
/*
select * from _TRemD WHERE ProdID in (select distinct ProdID from _TRemD WHERE Qty < 0) order by ProdID, PPID
*/
	/*Заполнение товарной части t_VenA*/
	DECLARE VenA CURSOR FAST_FORWARD
	FOR
	
	SELECT i.ProdID, p.UM, sum(Qty) Qty
	FROM #TRemD i 
	INNER JOIN r_Prods p ON i.ProdID = p.ProdID
	WHERE i.ProdID in (SELECT DISTINCT ProdID FROM #TRemD WHERE Qty < 0)  
	GROUP BY i.ProdID, p.UM
	/*HAVING SUM(Qty) >= 0*/
	ORDER BY i.ProdID
	
	OPEN VenA
	FETCH NEXT FROM VenA INTO @ProdID, @UM, @Qty
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		SELECT @BarCode = BarCode
		FROM r_ProdMQ 
		WHERE ProdID = @ProdID and UM = @UM
	
		SELECT @TSrcPosID = ISNULL(MAX(TSrcPosID), 0) + 1
		FROM t_VenA 
		WHERE ChID = @ChID

if not  EXISTS(SELECT 1 FROM t_VenA where ChID = @ChID)
begin 	
		INSERT INTO t_VenA
		(
			ChID, ProdID, UM, TQty, TNewQty, 
			TSumCC_nt, TTaxSum, TSumCC_wt, 
			TNewSumCC_nt, TNewTaxSum, TNewSumCC_wt, 
			BarCode, Norma1, TSrcPosID
		)
		SELECT
			@ChID, @ProdID, @UM, @Qty TQty, @Qty TNewQty, 
			0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 
			0 TNewSumCC_nt, 0 TNewTaxSum, 0 TNewSumCC_wt, 
			@BarCode, 0 Norma1, @TSrcPosID
end
		FETCH NEXT FROM VenA INTO @ProdID, @UM, @Qty
	END
	CLOSE VenA
	DEALLOCATE VenA
	
/*Заполнение части с партиями t_VenD */
	DECLARE VenD CURSOR FOR
	SELECT ProdID,UM,TQty
	FROM t_VenA WITH(NOLOCK)
	WHERE ChID = @ChID
	ORDER BY TSrcPosID
  
	OPEN VenD
	FETCH NEXT FROM VenD INTO @ProdID, @UM, @TQty
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @SrcPosID = 0
	    SET @NewQty = 0 /* фактическое количество */
	  
		DECLARE VenDPPID CURSOR FOR
		SELECT rd.PPID, Qty RemQty, (tp.CostMC * @KursMC) PriceCC
		FROM #TRemD rd
		JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = rd.ProdID AND tp.PPID = rd.PPID
		WHERE rd.ProdID = @ProdID AND Qty != 0
		ORDER BY rd.PPID

SELECT 'FETCH NEXT FROM VenD INTO @ProdID, @UM, @TQty',@ProdID, @UM, @TQty

SELECT rd.PPID, Qty RemQty, (tp.CostMC * @KursMC) PriceCC
FROM #TRemD rd
JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = rd.ProdID AND tp.PPID = rd.PPID
WHERE rd.ProdID = @ProdID AND Qty != 0
ORDER BY rd.PPID
		
		OPEN VenDPPID
		FETCH NEXT FROM VenDPPID INTO @PPID, @Qty, @PriceCC
		WHILE @@FETCH_STATUS = 0
		BEGIN
	        SET @SrcPosID += 1
	        
	        --запоминание последней положительной партии
	        IF @Qty > 0 SELECT @PPID_Last = @PPID, @SrcPosID_Last = @SrcPosID 
	        
select 'FETCH NEXT FROM VenDPPID INTO @PPID, @Qty, @PriceCC', @PPID, @Qty, @PriceCC
	        
			INSERT t_VenD
			(ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt,
			 PriceCC_wt, Tax, 
			 TaxSum,
			 SumCC_nt, SumCC_wt, NewQty, 
			 NewSumCC_nt,
			 NewTaxSum, NewSumCC_wt, SecID)
			VALUES 
			(@ChID, @ProdID, @SrcPosID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate),
			 @PriceCC, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate),
			 dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate) * @Qty,
			 dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @Qty, (@PriceCC * @Qty), @NewQty, 
			 dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @NewQty,dbo.zf_GetProdPrice_wtTax(@PriceCC,
			 @ProdID,@DocDate) * @NewQty, (@PriceCC * @NewQty), 1)	
			 
			FETCH NEXT FROM VenDPPID INTO @PPID, @Qty, @PriceCC 	
		END
		
	    /*обновляем по текущему товару в последней партии фактическое количество     */
	    
	    IF  @SrcPosID_Last = 0 SELECT @PPID_Last = @PPID, @SrcPosID_Last = @SrcPosID
	    
		UPDATE t_VenD
		SET NewQty = @TQty
		WHERE ChID = @ChID AND DetProdID = @ProdID AND PPID = @PPID_Last AND SrcPosID = @SrcPosID_Last   
		 
		FETCH NEXT FROM VenD INTO @ProdID, @UM, @TQty   
		CLOSE VenDPPID
		DEALLOCATE VenDPPID    
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
