
ALTER PROCEDURE [dbo].[ap_Perebrosvnal] (@OurID INT, @OurID_Out INT, @Sklad_In INT, @Sklad_Out INT, @DocDate SMALLDATETIME, @Notes VARCHAR(250))
AS
BEGIN
	SET NOCOUNT ON

	SET XACT_ABORT ON

/* Процедура для инструмента переброс в нал */
  
-- EXEC [ap_Perebrosvnal] 6,1201,1327,'20170926', 'Переброс в нал'

	DECLARE 
	@Testing BIT = 0, /*Установка тестирования: 1 - режим тестирования включен;(При тестировании берем текущие остатки для ускорения)  0 - режим тестирования отключен;*/
	@KursMC NUMERIC(21,9),
	@KursCC NUMERIC(21,9),
	@NewChIDCRet INT, 
	@NewDocIDCRet INT, 
	@NewInDocIDCRet INT, 
	@CompID INT, 
	@CurrID INT,
	@CRetCodeID1 INT, 
	@CRetCodeID2 INT, 
	@CRetCodeID3 INT, 
	@CRetCodeID4 INT, 
	@CRetCodeID5 INT, 
	@RecCodeID1 INT, 
	@RecCodeID2 INT, 
	@RecCodeID3 INT, 
	@RecCodeID4 INT, 
	@RecCodeID5 INT, 
	@SrcDocID VARCHAR(250), 
	@InDocIDCRet INT,
	@StateCodeCRet INT,
	@EmpID INT,
	@PayDelay INT,
	@Discount NUMERIC(21,9),
	@Qty NUMERIC(21,9),
	@TQty NUMERIC(21,9),
	@SrcPosID INT,
	@ProdID INT,
	@PPID INT,
	@UM VARCHAR(10),
	@PriceCC_nt NUMERIC(21,9), 
	@SumCC_nt NUMERIC(21,9), 
	@Tax NUMERIC(21,9), 
	@TaxSum NUMERIC(21,9), 
	@PriceCC_wt NUMERIC(21,9), 
	@SumCC_wt NUMERIC(21,9), 
	@BarCode VARCHAR(42),
	@TaxPercent NUMERIC(21,9),
	@NewQty NUMERIC(21,9),
	@PriceCC NUMERIC(21,9),
	@NewChIDRec INT, 
	@NewDocIDRec INT,
	@NewInDocIDRec INT, 
	@InDocIDRec INT,
	@StateCodeRec INT,
	@DepID INT,
	@PriceMC_In NUMERIC(21,9),
	@PriceMC NUMERIC(21,9),
	@NewPPID INT,
	
	@sql NVARCHAR(MAX) = ''
   
  BEGIN TRAN
 	
	EXEC dbo.z_NewChID 't_CRet', @NewChIDCRet OUTPUT -- новый ChID для t_CRet
	EXEC dbo.z_NewDocID 11011, 't_CRet', @OurID, @NewDocIDCRet OUTPUT -- новый DocID для t_CRet
	--SET @NewDocIDCRet = ISNULL((SELECT MAX(DocID) FROM t_CRet WHERE OurID = @OurID), 0) + 1
	SET @NewInDocIDCRet = @NewDocIDCRet --Вн. Номер
	SET @CompID = 81 --Предприятие
	SET @CurrID = 980 --Валюта dbo.zf_GetCurrCC()
	SET @KursMC = dbo.zf_GetRateMC(@CurrID)--Курс, ОВ - текущий курс
	SET @CRetCodeID1 = 82 -- Признак 1 для t_CRet
	SET @CRetCodeID2 = 15 -- Признак 2 для t_CRet
	SET @CRetCodeID3 = 19 -- Признак 3 для t_CRet
	SET @CRetCodeID4 = ISNULL((SELECT top 1 CAST(Notes AS INT) FROM r_Uni WHERE RefTypeID = 1000000008 AND ISNUMERIC(Notes) = 1 AND RefID = @Sklad_In ), 0) -- Признак 4 для t_CRet
	SET @CRetCodeID5 = ISNULL((SELECT top 1 CAST(Notes AS INT) FROM r_Uni WHERE RefTypeID = 1000000009 AND ISNUMERIC(Notes) = 1 AND RefID = @Sklad_In ), 0) -- Признак 5 для t_CRet
	SET @Notes = @Notes + ' (' + cast(@NewDocIDCRet as varchar(10)) + ')'
	SET @SrcDocID = cast(YEAR (@DocDate) as char(4)) + case len(cast(MONTH(@DocDate) as char(2))) when 1 then '0' + cast(MONTH(@DocDate) as char(2)) when 2 then cast(MONTH(@DocDate) as char(2)) end -- Номер источника
	SET @InDocIDCRet = @NewDocIDCRet --Заказ
	SET @StateCodeCRet = 0 --Статус
	SET @EmpID = dbo.zf_GetEmpCode()--Служащий
	SET @PayDelay = 30 --Отсрочка платежа
	SET @Discount = 0 --Скидка
	
	--Создаем новый заголовок t_CRet
	INSERT t_CRet 
	(ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, 
	 CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, 
	 Discount, PayDelay, EmpID, Notes, 
	 SrcTaxDocID, SrcTaxDocDate, TaxDocID, TaxDocDate, SrcDocID, SrcDocDate, LetAttor, CurrID,
	 TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, InDocID)
	VALUES
	(@NewChIDCRet, @NewDocIDCRet, @NewInDocIDCRet, @DocDate, @KursMC, @OurID, @Sklad_In, @CompID, 
	 @CRetCodeID1, @CRetCodeID2, @CRetCodeID3, @CRetCodeID4, @CRetCodeID5, 
	 @Discount, @PayDelay, @EmpID, @Notes, 
	 NULL, NULL, 0, NULL, @SrcDocID, NULL, NULL, @CurrID, 
	 0, 0, 0, 0, 0, @StateCodeCRet, @InDocIDCRet)

	--Создаем временную таблицу остатков на дату по партиям
	IF OBJECT_ID (N'tempdb..#TRemD') IS NOT NULL DROP TABLE #TRemD
	CREATE TABLE #TRemD (OurID INT,StockID INT,ProdID INT,PPID INT,Qty NUMERIC (21, 9))                         
 
 	IF @Testing = 1  /*При тестировании берем текущие остатки для ускорения*/
	INSERT #TRemD
		SELECT OurID, StockID, ProdID, PPID, SUM(Qty-AccQty) TQty
		FROM t_Rem 
		WHERE OurID = @OurID AND StockID = @Sklad_In
		GROUP BY OurID, StockID, ProdID, PPID 
		HAVING SUM(Qty-AccQty) > 0
	ELSE
		INSERT #TRemD
		SELECT OurID, StockID, ProdID, PPID, SUM(Qty-AccQty) Qty
		FROM zf_t_CalcRemByDateDate ('19000101', @DocDate) 
		WHERE OurID = @OurID AND StockID = @Sklad_In
		GROUP BY OurID, StockID, ProdID, PPID 
		
	SET @SrcPosID = 0
	
	/*Заполнение товарной части CRetD "Возврат товара поставщику"*/
	DECLARE CUR_CRetD CURSOR FAST_FORWARD
	FOR
		SELECT i.ProdID, sum(i.Qty) TQty
		FROM #perebrosvnal i 
		GROUP BY i.ProdID
		ORDER BY i.ProdID
	
	OPEN CUR_CRetD
	FETCH NEXT FROM CUR_CRetD INTO @ProdID, @TQty
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN
	    SET @NewQty = 0 -- новое количество в конкретной партии
	  
		-- По товару находим список всех партий в которых остаток больше нуля от меньшего номера партии к большему
		DECLARE CUR_CRetDPPID CURSOR 
		FOR
			SELECT rd.PPID, rd.Qty RemQty, tp.PriceAC_In 
			FROM #TRemD rd
			JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = rd.ProdID AND tp.PPID = rd.PPID
			WHERE rd.ProdID = @ProdID AND rd.Qty > 0
			ORDER BY rd.PPID
		
		OPEN CUR_CRetDPPID
		FETCH NEXT FROM CUR_CRetDPPID INTO @PPID, @Qty, @PriceCC
		WHILE @@FETCH_STATUS = 0 AND @TQty > 0 -- пока не закончатся партии или запрашиваемый остаток
		BEGIN
	        SET @SrcPosID += 1
	        
	        -- Если остаток по партии больше или равно запрашиваемого остатка 
	        IF @Qty >= @TQty 
	        BEGIN
				SET @NewQty = @TQty -- новое количество равно запрашиваемому остатку
				SET @TQty = 0 -- обнуляем запрашиваемый остаток
			END
			ELSE
			BEGIN
				SET @NewQty = @Qty -- новое количество равно остатку на партии
				SET @TQty = @TQty - @Qty -- уменьшаем запрашиваемый остаток
			END
		        
			SELECT @UM = UM FROM r_Prods WHERE ProdID = @ProdID -- еденица измерения
			SELECT @BarCode = BarCode FROM r_ProdMQ WHERE ProdID = @ProdID and UM = @UM --штрихкод
			/*Альтернативный способ определять цену с ндс
			--EXEC t_GetPriceCC 11011,@NewChIDCRet,@ProdID,@PPID,@KursMC,0,0,@PriceCC_wt output-- Цена с НДС
			--SET @PriceCC_wt = ISNULL(@PriceCC_wt,0)-- Цена с НДС*/
			SET @PriceCC_wt = ISNULL(@PriceCC,0)-- Цена с НДС
			SET @TaxPercent = dbo.zf_GetProdTaxPercent(@ProdID, dbo.zf_GetDate(@DocDate))
			SET @Tax  = dbo.zf_GetIncludedTax(@PriceCC_wt, @TaxPercent) -- НДС
			SET @PriceCC_nt = @PriceCC_wt - @Tax -- Цена без НДС
			SET @SumCC_wt = @NewQty * @PriceCC_wt -- Сумма с НДС
			SET @TaxSum   = @NewQty * @Tax -- Сумма НДС
			SET @SumCC_nt  = @NewQty * @PriceCC_nt -- Сумма без НДС

			INSERT t_CRetD
			(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID)
			VALUES
			(@NewChIDCRet, @SrcPosID, @ProdID, @PPID, @UM, @NewQty, @PriceCC_nt, @SumCC_nt, @Tax, @TaxSum, @PriceCC_wt, @SumCC_wt, @BarCode, 1)
			 
			FETCH NEXT FROM CUR_CRetDPPID INTO @PPID, @Qty, @PriceCC 	
		END
		CLOSE CUR_CRetDPPID
		DEALLOCATE CUR_CRetDPPID 
		
		FETCH NEXT FROM CUR_CRetD INTO @ProdID, @TQty
	END
	CLOSE CUR_CRetD
	DEALLOCATE CUR_CRetD 


  --Создание документа Приход товара
  	EXEC dbo.z_NewChID 't_Rec', @NewChIDRec OUTPUT -- новый ChID для t_Rec
	EXEC dbo.z_NewDocID 11002, 't_Rec', @OurID, @NewDocIDRec OUTPUT -- новый DocID для t_CRet
	SET @NewInDocIDRec = @NewDocIDRec --Вн. Номер
	SET @CompID = 181 --Предприятие
	SET @RecCodeID1 = @CRetCodeID1 -- Признак 1 для t_Rec
	SET @RecCodeID2 = @CRetCodeID2 -- Признак 2 для t_Rec
	SET @RecCodeID3 = 1 -- Признак 3 для t_Rec
	SET @RecCodeID4 = @CRetCodeID4 -- Признак 4 для t_Rec
	SET @RecCodeID5 = @CRetCodeID5 -- Признак 5 для t_Rec
	--SET @Notes = @Notes + ' (' + cast(@@NewDocIDRec as varchar(10)) + ')'
	SET @SrcDocID = cast(YEAR (@DocDate) as char(4)) + case len(cast(MONTH(@DocDate) as char(2))) when 1 then '0' + cast(MONTH(@DocDate) as char(2)) when 2 then cast(MONTH(@DocDate) as char(2)) end -- Номер источника
	SET @InDocIDRec = @InDocIDCRet --Заказ
	SET @StateCodeRec = 0 --Статус
	SET @EmpID = dbo.zf_GetEmpCode()--Служащий
	SET @PayDelay = 30 --Отсрочка платежа
	SET @Discount = 0 --Скидка
	SET @KursCC = dbo.zf_GetRateCC(@CurrID)--Курс, ВC - текущий курс
	SET @DepID = 0 --Код отдела
	
	--Создаем новый заголовок t_Rec
	INSERT t_Rec 
	(ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, 
	 CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, PayDelay, EmpID, 
	 Notes, SrcDocID, SrcDocDate, SrcTaxDocID, SrcTaxDocDate, TaxDocID, TaxDocDate, 
	 CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, KursCC, InDocID, DepID)
	VALUES
	(@NewChIDRec, @NewDocIDRec, @NewInDocIDRec, @DocDate, @KursMC, @OurID_Out, @Sklad_Out, @CompID, 
	 @RecCodeID1, @RecCodeID2, @RecCodeID3, @RecCodeID4, @RecCodeID5, @Discount, @PayDelay, @EmpID,
	 @Notes, @SrcDocID, NULL, NULL, NULL, 0, NULL, 
	 @CurrID, 0, 0, 0, 0, 0, @StateCodeRec, @KursCC, @InDocIDRec, @DepID)

	/*Заполнение товарной части CRetD "Возврат товара поставщику"*/
	DECLARE CUR_RecD CURSOR FAST_FORWARD
	FOR
		SELECT SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode
		FROM t_CRetD i
		WHERE i.ChID = @NewChIDCRet 
		ORDER BY i.SrcPosID
	
	OPEN CUR_RecD
	FETCH NEXT FROM CUR_RecD INTO @SrcPosID, @ProdID, @PPID, @UM, @Qty, @PriceCC_nt, @SumCC_nt, @Tax, @TaxSum, @PriceCC_wt, @SumCC_wt, @BarCode
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		SET @NewPPID = dbo.tf_NewPPID(@ProdID) --Новая партия

		--Копирование партии из возврата в новую партию прихода (Справочник товаров - Цены прихода Торговли)
		INSERT dbo.t_PInP
			SELECT ProdID, @NewPPID PPID, @Notes PPDesc, PriceMC_In, PriceMC, @NewPPID Priority, @DocDate ProdDate, 
				DLSDate, CurrID, @CompID CompID, Article, CostAC, PPWeight, File1, File2, File3, 
				PriceCC_In, CostCC, PPDelay, ProdPPDate, IsCommission, PriceAC_In, CostMC, CstProdCode, 
				CstDocCode, ParentDocCode, ParentChID, ElitProdID 
			FROM dbo.t_PInP WHERE ProdID = @ProdID AND PPID = @PPID
		
		--Вставка детальной части прихода
		INSERT t_RecD
		(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, 
		 CostSum, CostCC, Extra, PriceCC, BarCode, SecID, AuxUM)
		VALUES
		(@NewChIDRec, @SrcPosID, @ProdID, @NewPPID, @UM, @Qty, @PriceCC_nt, @SumCC_nt, @Tax, @TaxSum, @PriceCC_wt, @SumCC_wt, 
		 0, @PriceCC_wt, 0, @PriceCC_wt, @BarCode, 1, '')
		 
		FETCH NEXT FROM CUR_RecD INTO @SrcPosID, @ProdID, @PPID, @UM, @Qty, @PriceCC_nt, @SumCC_nt, @Tax, @TaxSum, @PriceCC_wt, @SumCC_wt, @BarCode
	END
	CLOSE CUR_RecD
	DEALLOCATE CUR_RecD 


  IF @@TRANCOUNT > 0
    COMMIT
  ELSE
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! Работа инструмента завершилась ошибкой!', 18, 1)
    ROLLBACK
  END 

END 




GO
