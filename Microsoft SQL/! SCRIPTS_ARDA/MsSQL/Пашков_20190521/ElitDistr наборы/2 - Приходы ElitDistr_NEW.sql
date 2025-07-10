--2 приход товара 
-- цена в файле import_t_Rec-ElitDistr.xlsx без НДС
USE ElitDistr
EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'
GO
--REVERT

DECLARE @DocDate SMALLDATETIME = '20190501' --дата Прихода (один раз в месяц)
DECLARE @ROLLBACK_TRAN  int = 1      -- 1 тестирование, выполнится ROLLBACK TRAN   0 рабочий режим, выполнится COMMIT TRAN

/*
SELECT * FROM t_Rec where ChID = 62
SELECT * FROM t_Recd where ChID = 62

SELECT * FROM t_Rec where DocDate = '20190501'
--DELETE t_Rec where DocDate = '20190501'

--текущие остатки
SELECT * FROM t_rem where OurID = 1 and StockID = 20 and (Qty <> 0 or AccQty <> 0) ORDER BY 1,2,3,4,5,6,7
*/

BEGIN TRAN 

SET NOCOUNT ON

IF OBJECT_ID (N'tempdb..#tmp', N'U') IS NOT NULL DROP TABLE #tmp
CREATE TABLE #tmp (ProdID int null, PPID int null, Qty numeric(21,9) null, Price numeric(21,9) null)

DECLARE @Num_Rec INT = 1
WHILE @Num_Rec <= 3
BEGIN

	IF @Num_Rec = 1
	BEGIN
		--загрузка из шаблона
		TRUNCATE TABLE #tmp;
		INSERT #tmp
		SELECT ProdID, PPID, Qty, Price FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Основной товар$]')
		WHERE ProdID IS NOT NULL;
	END

	IF @Num_Rec = 2
	BEGIN
		TRUNCATE TABLE #tmp;
		INSERT #tmp
		SELECT ProdID, PPID, Qty, Price FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Мусор$]')
		WHERE ProdID IS NOT NULL;
	END

	IF @Num_Rec = 3
	BEGIN
		TRUNCATE TABLE #tmp;
		INSERT #tmp
		SELECT ProdID, PPID, Qty, Price FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Чай$]') ex
		WHERE ProdID IS NOT NULL
		and EXISTS ( SELECT top 1 1 FROM r_Prods p where p.ProdID = ex.ProdID);-- не добавлять в приход товары которых нет в справочнике товаров
	END

	--INSERT INTO #tmp
	--          SELECT  1162,69,159,35.7
	--union all SELECT  1162,70,12,38.22
	--union all SELECT  1213,47,374,143.2020144

	/*
	SELECT ProdID,PPID,count(Qty) FROM #tmp 
	group by ProdID,PPID 
	ORDER BY 3 desc
	*/

		DECLARE @OurID INT,  
		@StockID INT, 
		@ChID INT,
		@Testing BIT = 0, /*Установка тестирования: 1 - режим тестирования включен;(При тестировании берем текущие остатки для ускорения)  0 - режим тестирования отключен;*/
		@KursMC NUMERIC(21,9),
		@KursCC NUMERIC(21,9),
		@NewChIDCRet INT, 
		@NewDocIDCRet INT, 
		@NewInDocIDCRet INT,
		@CompIDRec INT, 
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
		@Notes NVARCHAR(250),
		@DocIDEpp INT, 
		@CompID INT,
		@StocksList NVARCHAR(MAX) = '',
		@Price NUMERIC(21,9),
		
		@sql NVARCHAR(MAX) = ''

		--SET @DocDate = '2018-02-01' --дата
		
		SET @OurID = 1 -- фирма
		SET @StockID = 20 --склад
		SET @SrcDocID = '' --
		SET @CompID = 81 --предприятие на которое делается приход
		SET @CurrID = 2 --код валюты (в ElitDistr гривна = 2)
		SET @KursMC = dbo.zf_GetRateMC(@CurrID)/*Курс, ОВ - текущий курс*/ --28
		SET @KursCC = dbo.zf_GetRateCC(@CurrID)/*Курс, ВC - текущий курс*/ --1
		SET @Notes = @Notes + ' (' + cast(@DocIDEpp as varchar(10)) + ')'
		SET @EmpID = dbo.zf_GetEmpCode()/*Служащий*/
		SET @PayDelay = 30 /*Отсрочка платежа*/
		SET @Discount = 0 /*Скидка*/
  		EXEC z_NewChID 't_Rec', @NewChIDRec OUTPUT /* новый ChID для t_Rec*/
		EXEC z_NewDocID 11002, 't_Rec', @OurID, @NewDocIDRec OUTPUT /* новый DocID для t_CRet*/
		SET @NewInDocIDRec = @NewDocIDRec /*Вн. Номер*/
		SET @CompIDRec =  81 /*Предприятие для прихода*/
		SET @RecCodeID1 = 42 /* Признак 1 для t_Rec*/
		SET @RecCodeID2 = 23 /* Признак 2 для t_Rec*/
		SET @RecCodeID3 = case @OurID when 12 then 18 when 6 then 19 else 0 end /* Признак 3 для t_Rec*/
		SET @RecCodeID4 = ISNULL((SELECT top 1 CAST(Notes AS INT) FROM r_Uni WHERE RefTypeID = 1000000008 AND ISNUMERIC(Notes) = 1 AND RefID = @StockID ), 0) /* Признак 4 для t_Rec*/
		SET @RecCodeID5 = ISNULL((SELECT top 1 CAST(Notes AS INT) FROM r_Uni WHERE RefTypeID = 1000000009 AND ISNUMERIC(Notes) = 1 AND RefID = @StockID ), 0) /* Признак 5 для t_Rec*/
		SET @InDocIDRec = @DocIDEpp /*Заказ*/
		SET @StateCodeRec = 0 /*Статус*/
		SET @EmpID = dbo.zf_GetEmpCode()/*Служащий*/
		SET @PayDelay = 30 /*Отсрочка платежа*/
		SET @Discount = 0 /*Скидка*/
		SET @DepID = 0 /*Код отдела*/
		SET @SrcPosID = 0 --номер позиции
		
	print 'Создание документа Приход товара №' + STR(@Num_Rec)	
	  /*Создание документа Приход товара	*/
	  --BEGIN TRAN	
		/*Создаем новый заголовок t_Rec*/
		INSERT t_Rec 
		--ChID,DocID,IntDocID,DocDate,KursMC,OurID,StockID,CompID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,Discount,PayDelay,EmpID,Notes,SrcDocID,SrcDocDate,SrcTaxDocID,SrcTaxDocDate,TaxDocID,TaxDocDate,CurrID,TSumCC_nt,TTaxSum,TSumCC_wt,TSpendSumCC,TRouteSumCC,StateCode,KursCC,TSumCC,DepID,CustDocNum,CustCmrNum,CustDocDate
		(ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, 
		 CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, PayDelay, EmpID, 
		 Notes, SrcDocID, SrcDocDate, SrcTaxDocID, SrcTaxDocDate, TaxDocID, TaxDocDate, 
		 CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, KursCC, 
		 TSumCC,DepID,CustDocNum,CustCmrNum,CustDocDate)
		VALUES
		(@NewChIDRec, @NewDocIDRec, @NewInDocIDRec, @DocDate, @KursMC, @OurID, @StockID, @CompIDRec, 
		 @RecCodeID1, @RecCodeID2, @RecCodeID3, @RecCodeID4, @RecCodeID5, @Discount, @PayDelay, @EmpID,
		 @Notes, @SrcDocID, NULL, 0, NULL, 0, NULL, 
		 @CurrID, 0, 0, 0, 0, 0, @StateCodeRec, @KursCC,  
		 0, @DepID, 0, '', NULL)
		 --SELECT top 1 * FROM t_Rec
		 
	print 'Заполнение товарной части RecD Приход товара №' + STR(@Num_Rec)	

		DECLARE @pos INT = 0, @DateShow DATETIME  = GETDATE(), @DateStart DATETIME = GETDATE(), @p INT,@ToEnd INT, @t INT, @Msg varchar(200), @p100 INT
		/*Заполнение товарной части RecD "Приход товара"*/
		DECLARE CUR_RecD CURSOR STATIC --FAST_FORWARD
		FOR
			SELECT ProdID,PPID,Qty,Price * 1.2 -- так как в файле указана цена без НДС
			FROM #tmp ORDER BY 1,2

		OPEN CUR_RecD
		PRINT 'Количество записей: ' + STR(@@CURSOR_ROWS )
		FETCH NEXT FROM CUR_RecD INTO @ProdID,@PPID,@Qty,@Price
		
		WHILE @@FETCH_STATUS = 0 
		BEGIN
	------------------------------------------------------------------------------		
		IF @pos = 0 SET @p100 = @@CURSOR_ROWS	
		SET @pos = @pos + 1
		IF  DATEDIFF ( second , @DateShow , Cast (GETDATE() as DATETIME) ) >= 3 
		BEGIN
			SET @DateShow =  GETDATE()
			SET @p = (@pos*100)/@p100
			IF @p < 1 SET @p = 1
			SET @t = DATEDIFF ( second , @DateStart , Cast (GETDATE() as DATETIME) )
			SET @ToEnd = (100 - @p) * @t / @p  
			SET @Msg = CONVERT( varchar, GETDATE(), 121)  
			RAISERROR ('Выполнено %u процентов за  %u сек. Осталось = %u сек.', 10,1,@p,@t,@ToEnd) WITH NOWAIT
		END	
	------------------------------------------------------------------------------

			--SET @NewPPID = dbo.tf_NewPPID(@ProdID) /*Новая партия*/
			SELECT @UM = UM FROM r_Prods WHERE ProdID = @ProdID /* еденица измерения*/
			SELECT @BarCode = BarCode FROM r_ProdMQ WHERE ProdID = @ProdID and UM = @UM /*штрихкод*/
			--/*Альтернативный способ определять цену с ндс
			----EXEC t_GetPriceCC 11011,@NewChIDCRet,@ProdID,@PPID,@KursMC,0,0,@PriceCC_wt output-- Цена с НДС
			----SET @PriceCC_wt = ISNULL(@PriceCC_wt,0)-- Цена с НДС*/
			
			SET @PriceCC_wt = ISNULL(@Price,0)/* Цена с НДС*/ 
			--SET @PriceCC_wt = ISNULL(@Price*1.2,0)/* Цена с НДС*/ -- так как в файле указана цена без НДС
			--SET @TaxPercent = dbo.zf_GetProdTaxPercent(@ProdID, dbo.zf_GetDate(@DocDate))
			SET @TaxPercent = dbo.zf_GetProdExpTax(@ProdID, @OurID)
			
			SET @Tax  = dbo.zf_GetIncludedTax(@PriceCC_wt, @TaxPercent) /* НДС*/
			SET @PriceCC_nt = @PriceCC_wt - @Tax /* Цена без НДС*/
			SET @SumCC_wt = @Qty * @PriceCC_wt /* Сумма с НДС*/
			SET @TaxSum   = @Qty * @Tax /* Сумма НДС*/
			SET @SumCC_nt = @Qty * @PriceCC_nt /* Сумма без НДС*/

				--SELECT 
				--@ProdID ProdID,@PPID PPID,'' PPDesc, (@Price/@KursMC) PriceMC_In,
				--0 PriceMC,@PPID Priority,@DocDate ProdDate,	@CurrID CurrID,@CompID CompID,
				--'' Article,@Price CostAC,0 PPWeight,NULL File1,NULL File2,NULL File3,
				--@Price PriceCC_In,@Price CostCC, 0 PPDelay,@DocDate ProdPPDate,@DocDate DLSDate,
				--0 IsCommission, (@Price/@KursMC) CostMC, (@Price) PriceAC_In, 0 IsCert,
				--NULL FEAProdID,NULL ProdBarCode,NULL PPHumidity,NULL PPImpurity,NULL CustDocNum,NULL CustDocDate
				
			/*Создание партии прихода (Справочник товаров - Цены прихода Торговли)*/
			IF EXISTS( SELECT top 1 1 FROM dbo.t_PInP WHERE ProdID = @ProdID AND PPID = @PPID)
				UPDATE dbo.t_PInP
				SET	PriceMC_In =(@Price/@KursMC) ,
					ProdDate = @DocDate ,CurrID = @CurrID ,CompID = @CompID,
					CostAC = @Price, PriceCC_In = @Price ,CostCC = @Price ,ProdPPDate = @DocDate ,DLSDate = @DocDate ,
					CostMC = (@Price/@KursMC) , PriceAC_In = (@Price)
					,FEAProdID = case when FEAProdID is null then (SELECT top 1 FEAProdID FROM t_PInP pp1 where pp1.ProdID = @ProdID and pp1.FEAProdID is not null ORDER BY pp1.PPID desc) else FEAProdID end
				WHERE ProdID = @ProdID AND PPID = @PPID
			ELSE
			BEGIN
				--для отладки
			    IF 1=1 and not EXISTS ( SELECT top 1 1 FROM r_prods p where p.ProdID = @ProdID) 
			    SELECT 
					@ProdID ProdID,@PPID PPID,'Приход товара' PPDesc, (@Price/@KursMC) PriceMC_In,
					0 PriceMC,@PPID Priority,@DocDate ProdDate,	@CurrID CurrID,@CompID CompID,
					'' Article,@Price CostAC,0 PPWeight,NULL File1,NULL File2,NULL File3,
					@Price PriceCC_In,@Price CostCC, 0 PPDelay,@DocDate ProdPPDate,@DocDate DLSDate,
					0 IsCommission, (@Price/@KursMC) CostMC, (@Price) PriceAC_In, 0 IsCert,
					(SELECT top 1 FEAProdID FROM t_PInP pp1 where pp1.ProdID = @ProdID and pp1.FEAProdID is not null ORDER BY pp1.PPID desc) FEAProdID,
					NULL ProdBarCode,NULL PPHumidity,NULL PPImpurity,NULL CustDocNum,NULL CustDocDate
			    				
				INSERT dbo.t_PInP
				--ProdID,PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,DLSDate,IsCommission,CostMC,PriceAC_In,IsCert,FEAProdID,ProdBarCode,PPHumidity,PPImpurity,CustDocNum,CustDocDate
					SELECT 
					@ProdID ProdID,@PPID PPID,'Приход товара' PPDesc, (@Price/@KursMC) PriceMC_In,
					0 PriceMC,@PPID Priority,@DocDate ProdDate,	@CurrID CurrID,@CompID CompID,
					'' Article,@Price CostAC,0 PPWeight,NULL File1,NULL File2,NULL File3,
					@Price PriceCC_In,@Price CostCC, 0 PPDelay,@DocDate ProdPPDate,@DocDate DLSDate,
					0 IsCommission, (@Price/@KursMC) CostMC, (@Price) PriceAC_In, 0 IsCert,
					(SELECT top 1 FEAProdID FROM t_PInP pp1 where pp1.ProdID = @ProdID and pp1.FEAProdID is not null ORDER BY pp1.PPID desc) FEAProdID,
					NULL ProdBarCode,NULL PPHumidity,NULL PPImpurity,NULL CustDocNum,NULL CustDocDate

				--SELECT * FROM t_PInP WHERE ProdID = 1006 and PPID = 33
				--SELECT * FROM [ElitDistr_NEW].dbo.t_PInP WHERE PPID != 0
			END	
					
			SET @SrcPosID = @SrcPosID + 1
			
			/*Вставка детальной части прихода*/
			INSERT t_RecD
			--ChID,SrcPosID,ProdID,PPID,UM,Qty,PriceCC_nt,SumCC_nt,Tax,TaxSum,PriceCC_wt,SumCC_wt,CostSum,CostCC,Extra,PriceCC,BarCode,SecID
			(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, 
			 CostSum, CostCC, Extra, PriceCC, BarCode, SecID)
			VALUES
			(@NewChIDRec, @SrcPosID, @ProdID, @PPID, @UM, @Qty, @PriceCC_nt, @SumCC_nt, @Tax, @TaxSum, @PriceCC_wt, @SumCC_wt, 
			 0, @PriceCC_wt, 0, @PriceCC_wt, @BarCode, 1)
			--SELECT * FROM [ElitDistr_tmp].dbo.t_RecD WHERE ChiD = 20
			 
			FETCH NEXT FROM CUR_RecD INTO @ProdID,@PPID,@Qty,@Price
		END
		CLOSE CUR_RecD
		DEALLOCATE CUR_RecD 


	PRINT 'Готово'
	
	SELECT * FROM t_Rec WHERE ChiD = @NewChIDRec
	SELECT * FROM t_RecD WHERE ChiD = @NewChIDRec

	SELECT p.* FROM t_PInP p
	join t_RecD d on d.ProdID = p.ProdID and d.PPID = p.PPID
	where d.ChiD = @NewChIDRec
	ORDER BY ProdID,PPID

	SET @Num_Rec = @Num_Rec + 1
END --WHILE @Num_Rec <= 2



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
SELECT OurID, StockID, SecID, ProdID, PPID, Qty, AccQty FROM t_rem 
where OurID = 1 and StockID = 20 and (Qty <> 0 or AccQty <> 0)
ORDER BY 1,2,3,4,5,6,7
*/

--SELECT  *  FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Основной товар$]');
--SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Мусор$]');

/*проверка приходов с [ElitDistr]
SELECT t1.SumCC_wt, t2.SumCC_wt,* FROM t_RecD t1 
join [ElitDistr].dbo.t_RecD  t2 on t1.ProdID = t2.ProdID and t1.PPID = t2.PPID
WHERE t1.ChiD = 2 and t2.ChiD = 21
--and t1.Qty != t2.Qty
and round(t1.SumCC_wt,2) != round(t2.SumCC_wt,2)
*/

--BEGIN TRAN

----добавить отсутствующие товары в r_Prods_ из elit
----ChID,ProdID,ProdName,UM,Country,Notes,PCatID,PGrID,Article1,Article2,Article3,Weight,Age,TaxPercent,PriceWithTax,Note1,Note2,Note3,MinPriceMC,MaxPriceMC,MinRem,CstDty,CstPrc,CstExc,StdExtraR,StdExtraE,MaxExtra,MinExtra,UseAlts,UseCrts,PGrID1,PGrID2,PGrID3,PGrAID,PBGrID,LExpSet,EExpSet,InRems,IsDecQty,File1,File2,File3,AutoSet,Extra1,Extra2,Extra3,Extra4,Extra5,Norma1,Norma2,Norma3,Norma4,Norma5,RecMinPriceCC,RecMaxPriceCC,RecStdPriceCC,RecRemQty,InStopList,PrepareTime,AmortID,WeightGr,WeightGrWP,PGrID4,PGrID5,DistrID,ImpID,FEAprodID,ScaleGrID,ScaleStandard,ScaleConditions,ScaleComponents,ExcCostCC,CstDtyNotes,CstExcNotes,BoxVolume,SalesChannelID,IndRetPriceCC,IndWSPriceCC,SupID
----ChID,ProdID,ProdName,UM,Country,Notes,PCatID,PGrID,Article1,Article2,Article3,Weight,Age,PriceWithTax,Note1,Note2,Note3,MinPriceMC,MaxPriceMC,MinRem,CstDty,CstPrc,CstExc,StdExtraR,StdExtraE,MaxExtra,MinExtra,UseAlts,UseCrts,PGrID1,PGrID2,PGrID3,PGrAID,PBGrID,LExpSet,EExpSet,InRems,IsDecQty,File1,File2,File3,AutoSet,Extra1,Extra2,Extra3,Extra4,Extra5,Norma1,Norma2,Norma3,Norma4,Norma5,RecMinPriceCC,RecMaxPriceCC,RecStdPriceCC,RecRemQty,InStopList,PrepareTime,AmortID,WeightGr,WeightGrWP,PGrID4,PGrID5,DistrID,ImpID,ScaleGrID,ScaleStandard,ScaleConditions,ScaleComponents,ExcCostCC,CstDtyNotes,CstExcNotes,BoxVolume,SalesChannelID,IndRetPriceCC,IndWSPriceCC,SupID,TaxFreeReason,CstProdCode,TaxTypeID
--INSERT r_Prods_ (ChID,ProdID,ProdName,UM,Country,Notes,PCatID,PGrID,Article1,Article2,Article3,Weight,Age,             TaxPercent,PriceWithTax,Note1,Note2,Note3,MinPriceMC,MaxPriceMC,MinRem,CstDty,CstPrc,CstExc,StdExtraR,StdExtraE,MaxExtra,MinExtra,UseAlts,UseCrts,PGrID1,PGrID2,PGrID3,PGrAID,PBGrID,LExpSet,EExpSet,InRems,IsDecQty,File1,File2,File3,AutoSet,Extra1,Extra2,Extra3,Extra4,Extra5,Norma1,Norma2,Norma3,Norma4,Norma5,RecMinPriceCC,RecMaxPriceCC,RecStdPriceCC,RecRemQty,InStopList,PrepareTime,AmortID,WeightGr,WeightGrWP,PGrID4,PGrID5,DistrID,ImpID,     FEAprodID,ScaleGrID,ScaleStandard,ScaleConditions,ScaleComponents,ExcCostCC,CstDtyNotes,CstExcNotes,BoxVolume,SalesChannelID,IndRetPriceCC,IndWSPriceCC,SupID)
--		SELECT ROW_NUMBER()OVER(ORDER BY ChID) + (SELECT MAX(ChID) FROM r_Prods_) ChID,ProdID,ProdName,UM,Country,Notes,PCatID,PGrID,Article1,Article2,Article3,Weight,Age,20.000000000 TaxPercent,PriceWithTax,Note1,Note2,Note3,MinPriceMC,MaxPriceMC,MinRem,CstDty,CstPrc,CstExc,StdExtraR,StdExtraE,MaxExtra,MinExtra,UseAlts,UseCrts,PGrID1,PGrID2,PGrID3,PGrAID,PBGrID,LExpSet,EExpSet,InRems,IsDecQty,File1,File2,File3,AutoSet,Extra1,Extra2,Extra3,Extra4,Extra5,Norma1,Norma2,Norma3,Norma4,Norma5,RecMinPriceCC,RecMaxPriceCC,RecStdPriceCC,RecRemQty,InStopList,PrepareTime,AmortID,WeightGr,WeightGrWP,PGrID4,PGrID5,DistrID,ImpID,NULL FEAprodID,ScaleGrID,ScaleStandard,ScaleConditions,ScaleComponents,ExcCostCC,CstDtyNotes,CstExcNotes,BoxVolume,SalesChannelID,IndRetPriceCC,IndWSPriceCC,SupID--,TaxFreeReason,CstProdCode,TaxTypeID
--		FROM [Elit].dbo.r_Prods where ProdID not in (SELECT ProdID FROM r_Prods_)
--		ORDER BY ProdID


--SELECT top 1 * FROM r_Prods_
--SELECT top 1 * FROM [Elit].dbo.r_Prods

--ROLLBACK TRAN
/*
BEGIN TRAN


--SELECT * FROM r_Comps
--SELECT * FROM elit.dbo.r_Comps

--добавить предприятия в r_Comps из elit
insert r_Comps (ChID,
	CompID,CompName,CompShort,Address,PostIndex,City,Region,Code,TaxRegNo,
	TaxCode,TaxPayer,CompDesc,Contact,Phone1,Phone2,Phone3,Fax,EMail,HTTP,
	Notes,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,UseCodes,PLID,UsePL,Discount,
	UseDiscount,PayDelay,UsePayDelay,MaxCredit,CalcMaxCredit,EmpID,Contract1,
	Contract2,Contract3,License1,License2,License3,Job1,Job2,Job3,TranPrc,
	MorePrc,FirstEventMode,CompType,SysTaxType,FixTaxPercent,InStopList,Value1,
	Value2,Value3,PassNo,PassSer,PassDate,PassDept,CompGrID1,CompGrID2,CompGrID3,
	CompGrID4,CompGrID5,PayDelay2,MaxCredit2,RecipName,RecipAcc,RecipPCardID,
	AltCompID,BlockingID,CompNameFull,ProdCreditDate,ProdCreditDate2,PlanShipSumCC,
	PlanShipSumCC2,IsDutyFree,GLNCode,CanInvoicing,CanDuplicateCode,
	HasBonus,UseConsTaxDoc,CompClassID)
SELECT ROW_NUMBER()OVER(ORDER BY ChID) + (SELECT MAX(ChID) FROM r_Comps) ChID, 
	CompID, CompName, CompShort, Address, PostIndex, City, Region, Code, TaxRegNo, 
	TaxCode, TaxPayer, CompDesc, Contact, Phone1, Phone2, Phone3, Fax, EMail, HTTP, 
	Notes, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, UseCodes, PLID, UsePL, Discount, 
	UseDiscount, PayDelay, UsePayDelay, MaxCredit, CalcMaxCredit, EmpID, Contract1, 
	Contract2, Contract3, License1, License2, License3, Job1, Job2, Job3, TranPrc, 
	MorePrc, FirstEventMode, CompType, SysTaxType, FixTaxPercent, InStopList, Value1, 
	Value2, Value3, PassNo, PassSer, PassDate, PassDept, CompGrID1, CompGrID2, CompGrID3, 
	CompGrID4, CompGrID5, PayDelay2, MaxCredit2, RecipName, RecipAcc, RecipPCardID, 
	AltCompID, BlockingID, CompNameFull, ProdCreditDate, ProdCreditDate2, PlanShipSumCC, 
	PlanShipSumCC2, IsDutyFree, GLNCode, CanInvoicing, CanDuplicateCode,
	HasBonus,UseConsTaxDoc,CompClassID
FROM elit.dbo.r_Comps where CompID not in (SELECT CompID FROM r_Comps)


ROLLBACK TRAN

BEGIN TRAN

--добавить отсутствующие партии в t_PInP из elit
INSERT dbo.t_PInP (ProdID,PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,DLSDate,IsCommission,CostMC,PriceAC_In,IsCert,FEAProdID,ProdBarCode,PPHumidity,PPImpurity,CustDocNum,CustDocDate)
	SELECT p.ProdID,p.PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,DLSDate,IsCommission,CostMC,PriceAC_In,IsCert,CstProdCode,ProdBarCode,PPHumidity,PPImpurity,CustDocNum,CstDocDate 
	FROM [elit].dbo.t_PInP p
	join (
	SELECT ProdID, PPID FROM [elit].dbo.t_PInP
	except
	SELECT ProdID, PPID FROM t_PInP
	) exc on exc.ProdID = p.ProdID and exc.PPID = p.PPID 


ROLLBACK TRAN

*/