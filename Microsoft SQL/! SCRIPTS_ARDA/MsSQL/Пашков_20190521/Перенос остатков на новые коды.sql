
--1 РДЦП обнуление остатков на дату
USE Elit

DECLARE @DocDate SMALLDATETIME = '2019-02-01' --дата РДЦП (один раз в месяц, первый день месяца )
DECLARE @ROLLBACK_TRAN  int = 0       -- 1 тестирование, выполнится ROLLBACK TRAN   0 рабочий режим, выполнится COMMIT TRAN
--DECLARE @ProdIDs VARCHAR(MAX) = '26137,26138' --код товаров
IF OBJECT_ID (N'tempdb..#ProdIDs', N'U') IS NOT NULL DROP TABLE #ProdIDs
	CREATE TABLE #ProdIDs (ProdID INT NOT NULL ,NewProdID INT NOT NULL)

	INSERT #ProdIDs
		  select 33341,34454
union all select 33342,34455




SELECT * FROM #ProdIDs

--INSERT r_Prods
--SELECT 120003346 ChID, 96138 ProdID, (ProdName + ' new') ProdName, UM, Country, Notes, PCatID, PGrID, Article1, Article2, Article3, Weight, Age, PriceWithTax, Note1, Note2, Note3, MinPriceMC, MaxPriceMC, MinRem, CstDty, CstPrc, CstExc, StdExtraR, StdExtraE, MaxExtra, MinExtra, UseAlts, UseCrts, PGrID1, PGrID2, PGrID3, PGrAID, PBGrID, LExpSet, EExpSet, InRems, IsDecQty, File1, File2, File3, AutoSet, Extra1, Extra2, Extra3, Extra4, Extra5, Norma1, Norma2, Norma3, Norma4, Norma5, RecMinPriceCC, RecMaxPriceCC, RecStdPriceCC, RecRemQty, InStopList, PrepareTime, AmortID, WeightGr, WeightGrWP, PGrID4, PGrID5, DistrID, ImpID, ScaleGrID, ScaleStandard, ScaleConditions, ScaleComponents, ExcCostCC, CstDtyNotes, CstExcNotes, BoxVolume, SalesChannelID, IndRetPriceCC, IndWSPriceCC, SupID, TaxFreeReason, CstProdCode, TaxTypeID
----SELECT *
--FROM r_Prods
--WHERE ProdID = 26138


IF 2=2
BEGIN
IF OBJECT_ID (N'tempdb..#rem', N'U') IS NOT NULL DROP TABLE #rem

SELECT OurID, StockID, SecID, cr.ProdID, PPID, Qty, AccQty 
 INTO #rem
FROM t_Rem cr
JOIN #ProdIDs nid ON cr.ProdID = nid.ProdID
WHERE (Qty <> 0 or AccQty <> 0) 

END

SELECT * FROM #rem
SELECT distinct OurID, StockID FROM #rem order by 1,2

DECLARE 
	@Testing BIT = 0, /*Установка тестирования: 1 - режим тестирования включен;(При тестировании берем текущие остатки для ускорения)  0 - режим тестирования отключен;*/
	@OurID INT, 
	@OurID_Out INT, 
	@Sklad_In INT, 
	@Sklad_Out INT, 
	@TaxDocDate SMALLDATETIME, 
	@Notes VARCHAR(250), 
	@CompID INT,
	@KursMC NUMERIC(21,9),
	@KursCC NUMERIC(21,9),
	@ChID INT, 
	@DocID INT, 
	@InDocID INT,
	@StockID INT,
	@NewChID INT, 
	@NewDocID INT, 
	@NewInDocIDCRet INT,
	@CompIDRec INT, 
	@CurrID INT,
	@CodeID1 INT, 
	@CodeID2 INT, 
	@CodeID3 INT, 
	@CodeID4 INT, 
	@CodeID5 INT, 
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
	@StateCode INT,
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
	@DocCode INT, 
	@TableName VARCHAR(250),
	
	@sql NVARCHAR(MAX) = ''



   
BEGIN TRAN

--копируем партии на новые коды
INSERT t_Pinp 
SELECT nid.NewProdID ProdID, PPID, PPDesc, PriceMC_In, PriceMC, Priority, ProdDate, CurrID, CompID, Article, CostAC, PPWeight, File1, File2, File3, PriceCC_In, CostCC, PPDelay, ProdPPDate, DLSDate, IsCommission, CostMC, PriceAC_In, IsCert, ProdBarCode, PPHumidity, PPImpurity, CustDocNum, ParentPPID, CstProdCode, CstDocCode, CstDocDate, ParentDocCode, ParentChID
FROM t_Pinp cr
JOIN #ProdIDs nid ON cr.ProdID = nid.ProdID
WHERE PPID <> 0

--копируем внешние коды на новые коды
INSERT r_ProdEC 
SELECT nid.NewProdID, CompID, ExtProdID, ExtProdName, ExtBarCode FROM r_ProdEC m
JOIN #ProdIDs nid ON m.ProdID = nid.ProdID
--WHERE PPID <> 0

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT distinct OurID, StockID FROM #rem order by 1,2

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @OurID,@StockID
WHILE @@FETCH_STATUS = 0		 
BEGIN
	--Script
	SELECT  @OurID,@StockID
	
	IF 1 = 1--РДЦП
	BEGIN
 		--SET @DocDate = '2018-01-31' --дата документа
 		--SET @OurID = 1 --фирма
 		--SET @StockID = 4 --склад
	 	
 		SET @TableName = 't_Epp'
 		SET @DocCode = (SELECT top 1 DocCode FROM z_Tables where TableName = @TableName) 
 		--SELECT @DocCode
		EXEC dbo.z_NewChID @TableName, @NewChID OUTPUT /* новый ChID для t_Epp*/
		EXEC dbo.z_NewDocID @DocCode, @TableName, @OurID, @NewDocID OUTPUT /* новый DocID для t_Epp*/
		/*SET @NewDocIDCRet = ISNULL((SELECT MAX(DocID) FROM t_CRet WHERE OurID = @OurID), 0) + 1*/
		SET @InDocID = @NewDocID /*Вн. Номер*/
		SET @CompID = 108 --Предприятие
		SET @CurrID = 1 --код валюты (в Elit гривна = 2, доллар = 1)
		SET @KursMC = 1 -- dbo.zf_GetRateMC(@CurrID)/*Курс, ОВ - текущий курс*/ --28
		SET @KursCC = 1 -- dbo.zf_GetRateCC(@CurrID)/*Курс, ВC - текущий курс*/ --1
		SET @CodeID1 = 100 /* Признак 1*/
		SET @CodeID2 = 2586 /* Признак 2*/
		SET @CodeID3 = 5 /* Признак 3*/
		SET @CodeID4 = 2018 /* Признак 4*/
		SET @CodeID5 = 2018 /* Признак 5*/
		--SET @CodeID4 = ISNULL((SELECT top 1 CAST(Notes AS INT) FROM r_Uni WHERE RefTypeID = 1000000008 AND ISNUMERIC(Notes) = 1 AND RefID = @Sklad_In ), 0) /* Признак 4 для t_CRet*/
		--SET @CodeID5 = ISNULL((SELECT top 1 CAST(Notes AS INT) FROM r_Uni WHERE RefTypeID = 1000000009 AND ISNUMERIC(Notes) = 1 AND RefID = @Sklad_In ), 0) /* Признак 5 для t_CRet*/
		SET @Notes = 'создано скриптом: Перенос остатков на новые коды.sql'
		--SET @SrcDocID = cast(YEAR (@DocDate) as char(4)) + case len(cast(MONTH(@DocDate) as char(2))) when 1 then '0' + cast(MONTH(@DocDate) as char(2)) when 2 then cast(MONTH(@DocDate) as char(2)) end /* Номер источника*/
		SET @TaxDocDate = @DocDate /*дата налоговой*/
		SET @StateCode = 0 /*Статус*/
		SET @EmpID = dbo.zf_GetEmpCode()/*Служащий*/
		SET @PayDelay = 30 /*Отсрочка платежа*/
		SET @Discount = 0 /*Скидка*/

		/*Создаем новый заголовок t_Epp*/
		INSERT t_Epp 
		SELECT @NewChID ChID, @NewDocID DocID, @InDocID IntDocID, @DocDate DocDate, 
			@KursMC KursMC, @OurID OurID, @StockID StockID, @CompID CompID, 
			@CodeID1 CodeID1, @CodeID2 CodeID2, @CodeID3 CodeID3, @CodeID4 CodeID4, @CodeID5 CodeID5,
			0 Discount, 0 PayDelay, @EmpID EmpID, @Notes Notes, 0 SrcTaxDocID, NULL SrcTaxDocDate, 
			0 TaxDocID, @TaxDocDate TaxDocDate, NULL SrcDocID, NULL SrcDocDate, NULL LetAttor, 
			@CurrID CurrID, 0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 0 TSpendSumCC, 0 TRouteSumCC, 
			@StateCode StateCode, @KursCC KursCC, 0 TSumCC, 0 DepID, 0 DriverID 


		INSERT t_EppD
		SELECT 
		@NewChID ChID, ROW_NUMBER()OVER(ORDER BY SecID, ProdID, PPID, Qty) SrcPosID, 
		ProdID, PPID, (SELECT top 1 UM FROM r_Prods WHERE r_Prods.ProdID = cr.ProdID) UM, Qty, 
		(SELECT ISNULL(CostMC * @KursMC,0) FROM t_PInP pp WITH(NOLOCK) WHERE pp.ProdID = cr.ProdID AND pp.PPID = cr.PPID) - ( dbo.zf_GetIncludedTax((SELECT ISNULL(CostMC * @KursMC,0) FROM t_PInP pp WITH(NOLOCK) WHERE pp.ProdID = cr.ProdID AND pp.PPID = cr.PPID), dbo.zf_GetProdExpTax(cr.ProdID, @OurID,GETDATE())) ) as PriceCC_nt, 
		((SELECT ISNULL(CostMC * @KursMC,0) FROM t_PInP pp WITH(NOLOCK) WHERE pp.ProdID = cr.ProdID AND pp.PPID = cr.PPID) - ( dbo.zf_GetIncludedTax((SELECT ISNULL(CostMC * @KursMC,0) FROM t_PInP pp WITH(NOLOCK) WHERE pp.ProdID = cr.ProdID AND pp.PPID = cr.PPID), dbo.zf_GetProdExpTax(cr.ProdID, @OurID,GETDATE())) )) * ABS(cr.Qty) as SumCC_nt, 
		( dbo.zf_GetIncludedTax((SELECT ISNULL(CostMC * @KursMC,0) FROM t_PInP pp WITH(NOLOCK) WHERE pp.ProdID = cr.ProdID AND pp.PPID = cr.PPID), dbo.zf_GetProdExpTax(cr.ProdID, @OurID,GETDATE())) ) Tax, 
		( dbo.zf_GetIncludedTax((SELECT ISNULL(CostMC * @KursMC,0) FROM t_PInP pp WITH(NOLOCK) WHERE pp.ProdID = cr.ProdID AND pp.PPID = cr.PPID), dbo.zf_GetProdExpTax(cr.ProdID, @OurID,GETDATE())) ) * ABS(cr.Qty) as TaxSum, 
		(SELECT ISNULL(CostMC * @KursMC,0) FROM t_PInP pp WITH(NOLOCK) WHERE pp.ProdID = cr.ProdID AND pp.PPID = cr.PPID) as PriceCC_wt, 
		(SELECT ISNULL(CostMC * @KursMC,0) FROM t_PInP pp WITH(NOLOCK) WHERE pp.ProdID = cr.ProdID AND pp.PPID = cr.PPID) * ABS(cr.Qty) as SumCC_wt,
		(SELECT top 1 m.BarCode FROM r_Prods p, r_ProdMQ m WHERE m.ProdID=p.ProdID AND p.UM=m.UM AND m.ProdID= cr.ProdID) BarCode,
		--( SELECT top 1 BarCode FROM r_ProdMQ mq WHERE mq.ProdID = cr.ProdID and mq.UM = ((SELECT top 1 UM FROM r_Prods WHERE r_Prods.ProdID = cr.ProdID)) ) BarCode, 
		SecID
		--FROM t_rem cr
		FROM #rem cr
		WHERE cr.OurID = @OurID AND cr.StockID = @StockID
		
	SELECT * FROM t_Epp WHERE ChiD = @NewChID
	SELECT * FROM t_EppD WHERE ChiD = @NewChID ORDER BY 2

	--SELECT OurID, StockID, SecID, cr.ProdID, PPID, Qty, AccQty 
	--FROM t_rem cr
	--JOIN #ProdIDs nid ON nid.ProdID = cr.ProdID
	--where OurID = 1 and StockID = 20-- and (Qty <> 0 or AccQty <> 0)
	--ORDER BY 1,2,3,4,5,6,7

	END

	IF 2 = 2--Приходы
	BEGIN
		--создаем приходы
		--SELECT top 1 * FROM t_Rec
		--SELECT top 1 * FROM t_Epp

		--SELECT top 1 * FROM t_recD
		--SELECT top 1 * FROM t_EppD


		SET @TableName = 't_Rec'
 		SET @DocCode = (SELECT top 1 DocCode FROM z_Tables where TableName = @TableName) 
 		--SELECT @DocCode
		EXEC dbo.z_NewChID @TableName, @NewChIDRec OUTPUT /* новый ChID для t_Rec*/
		EXEC dbo.z_NewDocID @DocCode, @TableName, @OurID, @NewDocIDRec OUTPUT /* новый DocID для t_Rec*/
		/*SET @NewDocIDCRet = ISNULL((SELECT MAX(DocID) FROM t_CRet WHERE OurID = @OurID), 0) + 1*/
		SET @InDocIDRec = @NewDocIDRec /*Вн. Номер*/
		SET @CompID = 108 --Предприятие
		SET @CurrID = 1 --код валюты (в Elit гривна = 2, доллар = 1)
		SET @KursMC = 1 --dbo.zf_GetRateMC(@CurrID)/*Курс, ОВ - текущий курс*/ --28
		SET @KursCC = 1 --dbo.zf_GetRateCC(@CurrID)/*Курс, ВC - текущий курс*/ --1
		SET @CodeID1 = 100 /* Признак 1*/
		SET @CodeID2 = 2586 /* Признак 2*/
		SET @CodeID3 = 5 /* Признак 3*/
		SET @CodeID4 = 2018 /* Признак 4*/
		SET @CodeID5 = 2018 /* Признак 5*/
		--SET @CodeID4 = ISNULL((SELECT top 1 CAST(Notes AS INT) FROM r_Uni WHERE RefTypeID = 1000000008 AND ISNUMERIC(Notes) = 1 AND RefID = @Sklad_In ), 0) /* Признак 4 для t_CRet*/
		--SET @CodeID5 = ISNULL((SELECT top 1 CAST(Notes AS INT) FROM r_Uni WHERE RefTypeID = 1000000009 AND ISNUMERIC(Notes) = 1 AND RefID = @Sklad_In ), 0) /* Признак 5 для t_CRet*/
		SET @Notes = 'создано скриптом: Перенос остатков на новые коды.sql'
		--SET @SrcDocID = cast(YEAR (@DocDate) as char(4)) + case len(cast(MONTH(@DocDate) as char(2))) when 1 then '0' + cast(MONTH(@DocDate) as char(2)) when 2 then cast(MONTH(@DocDate) as char(2)) end /* Номер источника*/
		SET @TaxDocDate = @DocDate /*дата налоговой*/
		SET @StateCode = 0 /*Статус*/
		SET @EmpID = dbo.zf_GetEmpCode()/*Служащий*/
		SET @PayDelay = 30 /*Отсрочка платежа*/
		SET @Discount = 0 /*Скидка*/
		
		INSERT t_Rec
		SELECT @NewChIDRec ChiD,@NewDocIDRec DocID, @InDocIDRec IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, PayDelay,EmpID
				,Notes, SrcDocID, SrcDocDate
				, 0 SrcTaxDocID, NULL SrcTaxDocDate, 0 TaxDocID, NULL TaxDocDate
				, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, KursCC, TSumCC, DepID
				, 0 CstDocCode, 0 CustCmrNum, 0 CstDocDate
		FROM t_Epp WHERE ChiD = @NewChID
		
		INSERT t_RecD
		SELECT @NewChIDRec ChiD, SrcPosID, nid.NewProdID ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt 
		, 0 CostSum, PriceCC_wt CostCC, 0 Extra, PriceCC_wt PriceCC
		,BarCode, SecID
		FROM t_EppD cr
		JOIN #ProdIDs nid ON nid.ProdID = cr.ProdID
		 WHERE ChiD = @NewChID	


	SELECT * FROM t_Rec WHERE ChiD = @NewChIDRec
	SELECT * FROM t_RecD WHERE ChiD = @NewChIDRec ORDER BY 2
	
		
	/*
		/*Создаем новый заголовок t_Rec*/
	INSERT t_Rec 
	(ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, 
	 CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, PayDelay, EmpID, 
	 Notes, SrcDocID, SrcDocDate, SrcTaxDocID, SrcTaxDocDate, TaxDocID, TaxDocDate, 
	 CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, KursCC, InDocID, DepID)
	VALUES
	(@NewChIDRec, @NewDocIDRec, @NewInDocIDRec, @DocDate, @KursMC, @OurID, @StockID, @CompIDRec, 
	 @RecCodeID1, @RecCodeID2, @RecCodeID3, @RecCodeID4, @RecCodeID5, @Discount, @PayDelay, @EmpID,
	 @Notes, @SrcDocID, NULL, NULL, NULL, 0, NULL, 
	 @CurrID, 0, 0, 0, 0, 0, @StateCodeRec, @KursCC, @InDocIDRec, @DepID)

			/*Вставка детальной части прихода*/
		INSERT t_RecD
		(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, 
		 CostSum, CostCC, Extra, PriceCC, BarCode, SecID, AuxUM)
		VALUES
		(@NewChIDRec, @SrcPosID, @ProdID, @NewPPID, @UM, @Qty, @PriceCC_nt, @SumCC_nt, @Tax, @TaxSum, @PriceCC_wt, @SumCC_wt, 
		 0, @PriceCC_wt, 0, @PriceCC_wt, @BarCode, 1, '')
	*/
	
	END
	
	
	FETCH NEXT FROM CURSOR1 INTO @OurID,@StockID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

	--SELECT '' 'проверка t_rem',OurID, StockID, SecID, cr.ProdID, PPID, Qty, AccQty 
	--FROM t_rem cr
	--JOIN #ProdIDs nid ON cr.ProdID = nid.ProdID
	--where (Qty <> 0 or AccQty <> 0)
	--ORDER BY 1,2,3,4,5,6,7
	


--SELECT OurID, StockID, SecID, ProdID, PPID, Qty, AccQty 
--FROM [dbo].[zf_t_CalcRemByDateDate](null, @DocDate) cr
----FROM [dbo].[zf_t_CalcRemByDateDate](null, '2018-03-01') cr
--WHERE --OurID = 1 and StockID = 20 and 
--(Qty <> 0 or AccQty <> 0)
--and (SELECT [dbo].[zf_MatchFilterInt](cr.ProdID,@ProdIDs,',')) = 1
----Qty	2596452,000000000	-170,000000000	40859,000000000	8232
/*


*/

SELECT OurID, StockID, SecID, cr.ProdID, PPID, Qty, AccQty 
FROM t_Rem cr
JOIN #ProdIDs nid ON cr.ProdID = nid.ProdID
WHERE (Qty <> 0 or AccQty <> 0) 

SELECT OurID, StockID, SecID, cr.ProdID, PPID, Qty, AccQty 
FROM t_Rem cr
JOIN #ProdIDs nid ON cr.ProdID = nid.NewProdID
WHERE (Qty <> 0 or AccQty <> 0) 

IF @ROLLBACK_TRAN = 1 
BEGIN
	ROLLBACK TRAN   
END
ELSE
BEGIN
	IF @@TRANCOUNT > 0
	  COMMIT
	ELSE
	BEGIN
	  RAISERROR ('ВНИМАНИЕ!!! Работа инструмента завершилась ошибкой!', 10, 1)
	  ROLLBACK
	END   
END


/*
DECLARE @OurID int ,@StockID int
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT distinct OurID, StockID FROM #rem order by 1,2

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @OurID,@StockID
WHILE @@FETCH_STATUS = 0		 
BEGIN
	--Script
	SELECT  @OurID,@StockID
	
	FETCH NEXT FROM CURSOR1 INTO @OurID,@StockID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

*/

