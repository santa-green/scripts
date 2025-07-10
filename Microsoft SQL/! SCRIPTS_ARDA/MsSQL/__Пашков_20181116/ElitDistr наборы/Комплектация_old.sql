--4 Создание комплектации из шаблона
USE ElitDistr

DECLARE @DocDate SMALLDATETIME = '2018-05-16' --дата комплектации (два раза в месяц)

IF OBJECT_ID ('tempdb..#komplekt', 'U') IS NOT NULL   DROP TABLE #komplekt;

CREATE TABLE #komplekt(
ProdID int not null,
ProdID1 int not null,
PPID1 int not null,
ProdID2 int not null,
PPID2 int not null,
Qty numeric(21,9) null,
)

insert #komplekt
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Шаблон_комплектации.xlsx' , 'select * from [Лист1$] WHERE ProdIdNabor <> ''DEL'' ')


SELECT * FROM #komplekt 
--where ProdID2 in (30986)


BEGIN TRAN


  /* Объявление переменных */
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
   @SubPriceCC_wt NUMERIC(21,9), 
   @TaxPercent NUMERIC(21,9), 
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
   @ChIDStart INT,
   @ChIDEnd INT,
   @BDate SMALLDATETIME,
   @EDate SMALLDATETIME, 
   @OurID INT = NULL, 
   @StockID INT = NULL, 
   @DocCode INT = NULL,
   @CompID INT = NULL,
	@SubTax NUMERIC(21,9),
	@SubPriceCC_nt NUMERIC(21,9),
	@SubSumCC_wt NUMERIC(21,9),
	@SubTaxSum NUMERIC(21,9),
	@SubSumCC_nt NUMERIC(21,9)
	   

BEGIN   
		SELECT @ChIDStart = ChStart, @ChIDEnd = ChEnd FROM dbo.zf_ChIDRange()
		SET @CurrID = dbo.zf_GetCurrCC() --Валюта
		SET @KursMC = dbo.zf_GetRateMC(dbo.zf_GetCurrCC()) --Курс ОВ 
        --SET @DocDate = '2018-02-16' --дата комплектации
        SET @OurID = 1
        SET @StockID = 20
        /* Получение новых кода регистрации и номера для последующего импорта "Комплектация товара: Заголовок" */
        EXEC dbo.z_NewChID 't_SRec', @ChID OUTPUT
        EXEC dbo.z_NewDocID 11321, 't_SRec', @OurID, @DocID OUTPUT 
		SET @Notes = 'Обработан с шаблона'
		
        /* Импорт в "Комплектация товара: Заголовок" */ 
        INSERT t_SRec
        (ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, 
         CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID,Notes ,SubDocDate, SubStockID, CurrID)
        VALUES
        (@ChID, @DocID, @DocID, @DocDate , @KursMC, @OurID, @StockID, 
         100, 0, 0, 0, 0,  0,@Notes, @DocDate , @StockID, @CurrID)
    
		/* Курсор импорта проданных в "Продажа товара оператором" комплектов в "Комплектация товара: Комплекты" */
		DECLARE SRecA CURSOR LOCAL FOR
			SELECT ROW_NUMBER() OVER (ORDER BY m.ProdID) SrcPosID, m.ProdID, SUM(m.Qty) TQty 
			FROM #komplekt m
			GROUP BY m.ProdID 
			 
        OPEN SRecA
        FETCH NEXT FROM SRecA INTO @SrcPosID, @ProdID, @Qty
        WHILE @@FETCH_STATUS = 0
        BEGIN
			/* Получение нового дополнительного кода регистрации для конкретного комплекта */
			SELECT @AChID = ISNULL(MAX(AChID),0) + 1 FROM t_SRecA WITH(NOLOCK)  WHERE AChID BETWEEN  @ChIDStart AND @ChIDEnd 
      
			SELECT @UM = UM FROM r_Prods WHERE ProdID = @ProdID /* еденица измерения*/
			SELECT @BarCode = BarCode FROM r_ProdMQ WHERE ProdID = @ProdID and UM = @UM /*штрихкод*/

			/* Импорт данных о проданных комплектах в "Комплектация товара: Комплекты" */
			INSERT t_SRecA
				(ChID, SrcPosID, ProdID, PPID, UM, Qty, SetCostCC, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
				Extra, PriceCC, NewPriceCC_nt, NewSumCC_nt, NewTax, NewTaxSum, NewPriceCC_wt, NewSumCC_wt, AChID, BarCode, SecID)
			VALUES
				(@ChID, @SrcPosID, @ProdID, 0, @UM, @Qty, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @AChID, @BarCode, 1)      
      
			SET @SubSrcPosID = 0             
       
			/* Курсор импорта данных в "Комплектация товара: Комплектующие" на основании составных товаров комплектов */
			DECLARE SRecD CURSOR FOR
				SELECT ProdID1,PPID1,Qty FROM #komplekt m where m.ProdID = @ProdID
				union all 
				SELECT ProdID2,PPID2,Qty FROM #komplekt m where m.ProdID = @ProdID

			OPEN SRecD
			FETCH NEXT FROM SRecD INTO @SubProdID, @SubPPID, @SubQty
			WHILE @@FETCH_STATUS = 0
			BEGIN

            SET @SubSrcPosID = @SubSrcPosID + 1
			SELECT @SubUM = UM FROM r_Prods WHERE ProdID = @SubProdID /* еденица измерения*/
			SELECT @SubBarCode = BarCode FROM r_ProdMQ WHERE ProdID = @SubProdID and UM = @SubUM /*штрихкод*/
			SELECT @SubPriceCC_wt = ISNULL(CostCC,0) FROM dbo.t_PInP where ProdID = @SubProdID and PPID = @SubPPID /* Цена с НДС*/
			SET @TaxPercent = dbo.zf_GetProdExpTax(@SubProdID, @OurID)
			SET @SubTax  = dbo.zf_GetIncludedTax(@SubPriceCC_wt, @TaxPercent) /* НДС*/
			SET @SubPriceCC_nt = @SubPriceCC_wt - @SubTax /* Цена без НДС*/
			SET @SubSumCC_wt= @SubQty * @SubPriceCC_wt /* Сумма с НДС*/
			SET @SubTaxSum  = @SubQty * @SubTax /* Сумма НДС*/
			SET @SubSumCC_nt = @SubQty * @SubPriceCC_nt /* Сумма без НДС*/
		         
        
			INSERT dbo.t_SRecD
			SELECT @AChID AChID,@SubSrcPosID SubSrcPosID,@SubProdID SubProdID,@SubPPID SubPPID,
				@SubUM SubUM,@SubQty SubQty,@SubPriceCC_nt SubPriceCC_nt,@SubSumCC_nt SubSumCC_nt,
				@SubTax SubTax,@SubTaxSum SubTaxSum,@SubPriceCC_wt SubPriceCC_wt,@SubSumCC_wt SubSumCC_wt,
				@SubPriceCC_nt SubNewPriceCC_nt,@SubSumCC_nt SubNewSumCC_nt,@SubTax SubNewTax,
				@SubTaxSum SubNewTaxSum,@SubPriceCC_wt SubNewPriceCC_wt,@SubSumCC_wt SubNewSumCC_wt,1 SubSecID,@SubBarCode SubBarCode

			--SELECT * FROM [ElitDistr_TEST].dbo.t_SRecD where AChID = 6813 and SubPPID = 240
			--SELECT * FROM [ElitDistr_TEST].dbo.t_PInP where ProdID = 30767 and PPID = 240

            FETCH NEXT FROM SRecD INTO @SubProdID, @SubPPID, @SubQty
          END
          CLOSE SRecD
          DEALLOCATE SRecD
      
          /* Блок расчёта суммарной стоимости конкретного комплекта на основании его комплектующих -------------------------------------------------*/
      
          /* Присвоение значения суммарной стоимости комплекта на основании его комплектующих */
          SELECT @PriceCC = ISNULL(dbo.zf_RoundPriceRec(SUM(SubSumCC_wt / @Qty)), 0) FROM t_SRecD WITH(NOLOCK) WHERE AChID = @AChID

          SELECT @PPID = dbo.tf_NewPPID(@OurID,@ProdID)
          SET @CompID = 0 --предприятие
 
      
        
          /* создаём новую партию на основании ранее полученного значения с параметрами суммарной стоимости комплекта */
          --ADocCode = 11321 - Комплектация товара
	      EXEC t_SavePP 
	        1, 11321, @AChID, 0, @CurrID, @KursMC, 
	        0, @PriceCC, @PriceCC, @PriceCC, 0, 
	        'Комплектация товара', @ProdID, @PPID, @PPID, 
	        @CompID, @DocDate , NULL, 0, 
	        @DocDate, 0
/*@ANewPP BIT, @ADocCode INT, @AChID INT, @AInMC BIT, @ACurrID INT, @ARateMC NUMERIC(21, 9),
@APriceMC NUMERIC(21, 9), @APriceCC NUMERIC(21, 9),@ACostAC NUMERIC(21, 9), @ACostCC NUMERIC(21, 9), @APPWeight NUMERIC(21, 9), 
@APPDesc VARCHAR(200), @AProdID INT, @APPID INT, @APriority INT, 
@ACompID INT, @AProdDate SMALLDATETIME, @AArticle VARCHAR(200), @APPDelay SMALLINT,
@AProdPPDate SMALLDATETIME, @AIsCommission BIT*/
  
          /* Обновление суммарной стоимости конкретного комплекта в "Комплектация товара: Комплекты" */
          UPDATE t_SRecA
          SET 
           PPID = @PPID, 
           PriceCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID ), 
           SumCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID ) * Qty,
           Tax = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID ), 
           TaxSum = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID ) * Qty, 
           PriceCC_wt = @PriceCC, 
           SumCC_wt = @PriceCC * Qty,
           NewPriceCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID ), 
           NewSumCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID ) * Qty,
           NewTax = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID ), 
           NewTaxSum = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID ) * Qty, 
           NewPriceCC_wt = @PriceCC, NewSumCC_wt = @PriceCC * Qty
          WHERE AChID = @AChID                                 
      
          FETCH NEXT FROM SRecA INTO @SrcPosID, @ProdID, @Qty
        END
        CLOSE SRecA
        DEALLOCATE SRecA

      END


--для проверки результата
SELECT * FROM t_SRec where ChID = @ChID
SELECT * FROM t_SRecA where ChID = @ChID ORDER BY 2
SELECT * FROM t_SRecD where AChID in (SELECT AChID FROM t_SRecA where ChID = @ChID) ORDER BY 1,3,2

SELECT p.* FROM t_PInP p
join t_SRecA d on d.ProdID = p.ProdID and d.PPID = p.PPID
where d.ChiD = @ChID
ORDER BY ProdID,PPID



ROLLBACK TRAN 
IF @@TRANCOUNT > 0 COMMIT TRAN