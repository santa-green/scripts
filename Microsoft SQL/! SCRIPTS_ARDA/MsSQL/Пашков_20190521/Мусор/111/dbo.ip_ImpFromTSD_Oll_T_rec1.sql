USE [ElitR_test]
GO
/****** Object:  StoredProcedure [dbo].[ip_ImpFromTSD_Oll_T_rec]    Script Date: 08/08/2017 18:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ip_ImpFromTSD_Oll_T_rec] @Type int, @Chid_t_EOExp int = null	
AS
BEGIN
/*Импорт всех документов с ТСД*/
--pvm0 13.07.2017 для автоматической обработки товаров которых не было в заказе
DECLARE 
	@NewChID INT, 
	@NewDocID INT, 
	@OurID INT, 
	@StockID INT ,
	@CompID INT

DECLARE 
	@doc_type INT, 
	@id_doc INT,
	@id_good INT,
	@count_doc FLOAT, 
	@count_real FLOAT, 
	@SrcPosID INT,
	@UM varchar(15),
	@BarCode varchar(15),
	@UnkBarcode varchar(15),
	@TQty FLOAT,
	@Notes VARCHAR(50) ,
	
	@RecPPID INT, 
	@Price NUMERIC(21,9),
	@CurrID INT, 
    @KursMC NUMERIC(21,9) ,
    @ExpDate SMALLDATETIME
	

DECLARE 
    @ParentDocCode int, 
    @ParentChID int, 
    @ChildDocCode int, 
    @ChildChID int, 
    @RepToolCode int, 
    @ToolCode int,
    @Continue bit, 
    @Msg varchar(1000) 

SELECT @OurID = dbo.zf_GetOurID('t')
SELECT @StockID = dbo.zf_GetStockID('t')
SELECT @ExpDate = dbo.zf_GetDate(GETDATE())
SELECT @CurrID = dbo.zf_GetCurrCC()
SELECT @KursMC = dbo.zf_GetRateMC(@CurrID)

if object_id('tempdb..#sklad') is not null drop table #sklad  
		create table #sklad(sklad int)
		

IF HOST_NAME () = 'acc129' insert #sklad select StockID  from r_Stocks where StockID in (1200,1201,1203,1204,1205,1256,1257,1327)
IF SUSER_SNAME() = 'kea20' insert #sklad select StockID  from r_Stocks where StockID in (1200,1201,1203,1204,1205,1256,1257,1327)--для Харькова пользователь paa18


--IF HOST_NAME () = 'GA_KH20' insert #sklad select StockID  from r_Stocks where StockID in (1252)
IF HOST_NAME () = 'VINTAGE-KH1' insert #sklad select StockID  from r_Stocks where StockID in (1260)
IF HOST_NAME () = 'ELIT_KIEV23' insert #sklad select StockID  from r_Stocks where StockID in (1241)/*Киев новый маркетвин фирма 6*/

IF SUSER_SNAME() = 'paa18' insert #sklad select StockID  from r_Stocks where StockID in (1252,1260)--для Харькова пользователь paa18

/*для теста*/
IF HOST_NAME () = 'S-ELIT-DP' insert #sklad select StockID  from r_Stocks where StockID in (1200,1201,1203,1204,1205,1256,1257,1327)
IF SUSER_SNAME() = 'const\pashkovv' insert #sklad select StockID  from r_Stocks where StockID in (1200,1201,1203,1204,1205,1256,1257,1327)


IF @Chid_t_EOExp is null
	Declare DocType_IDDoc CURSOR FAST_FORWARD FOR 
	SELECT doc_type, id_doc FROM it_TSD_doc_head WHERE doc_type IN (@Type) and sklad_out_id in (select sklad from #sklad)
						AND id_doc NOT IN  (SELECT Id_doc FROM it_TSD_doc_details GROUP BY Id_doc HAVING SUM (Count_real)=0 )
						AND id_doc NOT IN   (SELECT ParentChID FROM z_DocLinks WHERE ParentDocCode = 11211 AND ParentDocDate >= GETDATE ()-30 AND ChildDocCode = 11002)
else--если указан конкретный Chid заказа 
	Declare DocType_IDDoc CURSOR FAST_FORWARD FOR 
	SELECT doc_type, id_doc FROM it_TSD_doc_head WHERE doc_type IN (@Type) --and sklad_out_id in (select sklad from #sklad)
						AND id_doc     IN  (SELECT Id_doc FROM it_TSD_doc_details GROUP BY Id_doc HAVING SUM (Count_real)=0 )
						AND id_doc NOT IN   (SELECT ParentChID FROM z_DocLinks WHERE ParentDocCode = 11211 AND ParentDocDate >= GETDATE ()-30 AND ChildDocCode = 11002)
						AND Id_doc = @Chid_t_EOExp

OPEN DocType_IDDoc 
FETCH NEXT FROM DocType_IDDoc 
INTO @doc_type, @id_doc
WHILE @@FETCH_STATUS=0
begin	
/*--------------------ПРИХОДЫ--------------------*/
	IF @doc_type='0'
	BEGIN

	
			SELECT @OurID = OurID , @StockID = StockID ,  @CompID = CompID
			FROM t_EOExp WHERE ChID = @id_doc /*and StockID in (select sklad from #sklad)*/
			EXEC z_NewChID 't_Rec', @NewChID OUTPUT    
			EXEC z_NewDocID 11002, 't_Rec', @OurID, @NewDocID OUTPUT  

/*Создание заголовка для приходных докумекнтов	*/		
			INSERT INTO t_Rec (ChID, DocID, DocDate, KursMC, OurID, StockID, CompID, EmpID, IntDocID, CurrID , CodeID1,CodeID2,CodeID3)
			 select 
				@NewChID AS ChID, 
				@NewDocID AS DocID, 
				dd.doc_date AS DocDate,
				dbo.zf_GetRateMC(dbo.zf_GetCurrCC()) AS KursMC, 
				@OurID AS OurID,
				@StockID AS StockID, 
				@CompID AS CompID,
				/*dd.id_user AS EmpID,*/
				0 AS EmpID, 
				@NewDocID AS IntDocID, 
				dbo.zf_GetCurrCC() AS CurrID ,
			    0  CodeID1,
			    r.CodeID2  CodeID2,
			    0  CodeID3
				FROM (SELECT * FROM it_TSD_doc_head WHERE id_doc =@id_doc  ) dd
				JOIN r_Comps r ON r.CompID = @CompID
				GROUP BY dd.Doc_date, dd.id_contragent, dd.id_user ,r.CodeID1,r.CodeID2,r.CodeID3
			
/*Вставка детальной части*/
	IF @Chid_t_EOExp is null
		Declare InsRecD CURSOR FAST_FORWARD FOR 
			SELECT Id_good, Count_real FROM it_TSD_doc_details WHERE id_doc = @id_doc 
	else 
		Declare InsRecD CURSOR FAST_FORWARD FOR 
			SELECT Id_good, Count_doc FROM it_TSD_doc_details WHERE id_doc = @id_doc 
			
		OPEN InsRecD 
		FETCH NEXT FROM InsRecD 
		INTO @Id_good, @Count_real
		WHILE @@FETCH_STATUS=0
		BEGIN
		
			SELECT @UM = (SELECT UM FROM r_prods WHERE prodid = @Id_good)

			SELECT @Barcode = (SELECT BarCode FROM r_prodmq WHERE prodid = @Id_good AND UM=@UM)
			
			IF EXISTS (SELECT TOP 1 1 FROM r_ProdMQ WHERE BarCode = @BarCode)
				BEGIN		
				
					SELECT @SrcPosID = (SELECT ISNULL(MAX(SrcPosID)+1,1) 
						                FROM t_RecD 
								        WHERE ChID = @NewChID)
								
					IF @Count_real > 0 
					BEGIN
					
					SELECT @RecPPID = dbo.tf_NewPPID(@Id_good)
					SELECT @Price =PriceCC  FROM t_EOExpd WHERE ProdID = @Id_good AND ChID = @id_doc
					
					--pvm0 13.07.2017 для автоматической обработки товаров которых не было в заказе
					--если цена не найдена в заказе то берем из справочника ТСД
					IF @Price IS NULL 
						 SELECT @Price = Good_price FROM it_TSD_goods where Id_good = @Id_good
					--если цена не найдена в справочнике ТСД то берем из справочника товаров:прайс-лист
					IF @Price IS NULL 
						SELECT PriceMC FROM r_ProdMP where ProdID = @Id_good 
								and PLID = (SELECT top(1) PLID FROM r_Stocks where StockID = (SELECT top(1) StockID  FROM t_EOExp WHERE  ChID = @id_doc) )
				   --если и теперь цена не найдена то ставим цену в ноль				
				   IF @Price IS NULL SET @Price = 0
				   
                   INSERT dbo.t_PInP
                  (ProdID, PPID, PriceMC_In, PriceMC, Priority, ProdDate, DLSDate, CurrID, CompID, Article, CostAC, PPWeight, File1, File2, File3,
                   PriceCC_In, CostCC, PPDelay, ProdPPDate, PriceAC_In, CostMC, CstProdCode, ElitProdID)
                   SELECT
                   @Id_good ProdID, @RecPPID PPID, (@Price / @KursMC) PriceMC_In, 0 PriceMC, @RecPPID Priority, @ExpDate ProdDate, ''DLSDate, @CurrID CurrID, 
					@CompID CompID, '' Article, @Price CostAC, 0 PPWeight,NULL File1, NULL File2, NULL File3, 
				 @Price PriceCC_In, @Price CostCC, 0 PPDelay, '' ProdPPDate,  @Price PriceAC_In, (@Price / @KursMC) CostMC, ''CstProdCode, NULL ElitProdID

				/*	INSERT INTO t_RecD (ChID, SrcPosID, ProdID, UM, Qty, BarCode, SecID , PPID)
						VALUES
					   (
						@NewChID, 
						@SrcPosID,
						@Id_good,
						@UM,
						@Count_real,
						@Barcode,
						1, 
						@RecPPID
					   )
				*/   
				INSERT dbo.t_RecD
                  (ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, CostSum, CostCC, Extra, PriceCC, BarCode, SecID)
                  VALUES
                  (@NewChID, @SrcPosID, @Id_good, @RecPPID, @UM, @Count_real, dbo.zf_GetProdPrice_nt(@Price, @Id_good, @ExpDate), dbo.zf_GetProdPrice_nt(@Price, @Id_good, @ExpDate) * @Count_real,
                   dbo.zf_GetProdPrice_wtTax(@Price, @Id_good, @ExpDate), dbo.zf_GetProdPrice_wtTax(@Price, @Id_good, @ExpDate) * @Count_real, @Price, @Price * @Count_real, 0, 0, 0, 0, @BarCode, 1)
					   
					   
					   END
					   
					   ELSE
					   
					   BEGIN 
					   
					INSERT INTO t_RecD (ChID, SrcPosID, ProdID, UM, Qty, BarCode, SecID )
						VALUES
					   (
						@NewChID, 
						@SrcPosID,
						@Id_good,
						@UM,
						@Count_real,
						@Barcode,
						1 
					   )
					   END
			    END
			ELSE
			    BEGIN
				/* Заполнение закладки неизвестные штрихкоды */
					SELECT @SrcPosID = (SELECT ISNULL(MAX(SrcPosID)+1,1) 
										FROM it_RecUnknBarCodes 
										WHERE ChID = @NewChID)
										
					SELECT @UnkBarcode = (SELECT Good_name FROM it_TSD_goods WHERE Id_good = @id_good)
					
					
					INSERT INTO it_RecUnknBarCodes (ChID, SrcPosID, BarCode, Qty) 
					VALUES
					(
					@NewChID,
					@SrcPosID,
					@UnkBarcode,
					@Count_real 
					) 
			    
			    END
			
		FETCH NEXT FROM InsRecD 
		INTO @Id_good, @Count_real
		END
		CLOSE InsRecD
		DEALLOCATE InsRecD
	
		/*Создание связи между документами*/
		IF EXISTS (SELECT TOP 1 1 FROM t_EOExp WHERE ChID = @id_doc)
			BEGIN
				SET @ParentDocCode = 11211  /*Заказ внешний: Формирование*/
				SET @ParentChID = @id_doc 
				SET @ChildDocCode = 11002 /*Приход товара*/
				SET @ChildChID = @NewChID 
				SET @RepToolCode = 10601 /*Монитор документа*/
				SET @ToolCode = 8       

				IF object_id('tempdb..#_DocLinks') IS NOT NULL drop table #_DocLinks
				CREATE TABLE #_DocLinks ( LinkID int,  LinkDocDate smalldatetime,  DocLinkTypeID int,  ParentDocCode int,  ParentDocName varchar(250),  ParentChID int,  ParentDocID int,  ParentDocDate smalldatetime,  ChildDocCode int,  ChildDocName varchar(250),  ChildChID int,  ChildDocID int,  ChildDocDate smalldatetime,  ParentSumCC numeric(21,9),  ParentSumCCClosed numeric(21,9),  ParentSumCCFree numeric(21,9),  ChildSumCC numeric(21,9),  ChildSumCCClosed numeric(21,9),   ChildSumCCFree numeric(21,9),  LinkSumCC  numeric(21,9),  Notes varchar(250),  RepToolCode int,  ToolCode int,  ShowDialog bit )
				        
				EXEC z_DocLinks_Prepare @ParentDocCode, @ParentChID, @ChildDocCode, @ChildChID, @RepToolCode, @ToolCode
				      
				EXEC z_DocLinks_Save @Continue OUTPUT, @Msg OUTPUT       
				IF @Continue = 0 RAISERROR (@Msg, 18, 1)  
				/*Обновление служащего на основании заказа */
				UPDATE m
				SET m.EmpID = e.EmpID
				FROM t_Rec m
				JOIN z_DocLinks l WITH(NOLOCK) ON l.ParentDocCode = 11211 AND l.ChildDocCode = 11002 AND l.ChildChID = m.ChID
				JOIN t_EOExp e WITH(NOLOCK) ON e.ChID = l.ParentChID
				WHERE e.ChID = @ParentChID
				DELETE FROM t_RecD WHERE ChID = @NewChID AND Qty = 0 
			END				
	END
	
/*----------------РАСХОДЫ--------------------*/
	/*IF @doc_type='1' BEGIN
			EXEC z_NewChID 't_Inv', @NewChID OUTPUT    
			EXEC z_NewDocID 11012, 't_Inv', @OurID, @NewDocID OUTPUT  

/*Создание заголовка для расходных докумекнтов*/
			INSERT INTO t_Inv (ChID, DocID, DocDate, KursMC, OurID, StockID, CompID, EmpID, TaxDocDate, IntDocID, CurrID)
				SELECT 
				@NewChID AS ChID, 
				@NewDocID AS DocID, 
				dd.doc_date AS DocDate,
				dbo.zf_GetRateMC(dbo.zf_GetCurrCC()) AS KursMC, 
				@OurID AS OurID,
				@StockID AS StockID, 
				dd.id_contragent AS CompID,
				dd.id_user AS EmpID, 
				dd.doc_date AS TaxDocDate,
				@NewDocID AS IntDocID,
				dbo.zf_GetCurrCC() AS CurrID
				FROM (SELECT * FROM it_TSD_doc_head WHERE id_doc=@id_doc ) dd
				GROUP BY dd.Doc_date, dd.id_contragent, dd.id_user
				
/*Вставка детальной части расходных докумекнтов*/

		Declare InsInvD CURSOR FAST_FORWARD FOR 

			SELECT Id_good, Count_real FROM it_TSD_doc_details WHERE id_doc = @id_doc

		OPEN InsInvD 
		FETCH NEXT FROM InsInvD 
		INTO @Id_good, @Count_real
		WHILE @@FETCH_STATUS=0
		BEGIN
		
			SELECT @UM = (SELECT UM FROM r_prods WHERE prodid = @Id_good)

			SELECT @Barcode = (SELECT BarCode FROM r_prodmq WHERE prodid = @Id_good AND UM=@UM)		
		
			IF EXISTS (SELECT TOP 1 1 FROM r_ProdMQ WHERE BarCode = @BarCode)
				BEGIN			
		
					SELECT @SrcPosID = (SELECT ISNULL(MAX(SrcPosID)+1,1) 
							            FROM t_InvD 
									    WHERE ChID = @NewChID)


			
					INSERT INTO t_InvD (ChID, SrcPosID, ProdID, UM, Qty, BarCode, SecID)
						VALUES
					   (
						@NewChID, 
						@SrcPosID,
						@Id_good,
						@UM,
						@Count_real,
						@Barcode,
						1
					   )
				END
			ELSE
				BEGIN
					SELECT @SrcPosID = (SELECT ISNULL(MAX(SrcPosID)+1,1) 
										FROM it_InvUnknBarCodes 
										WHERE ChID = @NewChID)
										
					SELECT @UnkBarcode = (SELECT Good_name FROM it_TSD_goods WHERE Id_good = @id_good)
					
					
					INSERT INTO it_InvUnknBarCodes (ChID, SrcPosID, BarCode, Qty) 
					VALUES
					(
					@NewChID,
					@SrcPosID,
					@UnkBarcode,
					@Count_real 
					)				
				END   
					
			    
		FETCH NEXT FROM InsInvD 
		INTO @Id_good, @Count_real
		END
		CLOSE InsInvD
		DEALLOCATE InsInvD
           
        
				
	END
	*/
	
	
	
			/*-------------Перемещение-------------------------*/
		
	IF @doc_type='1' 
	BEGIN
	
			EXEC z_NewChID 't_Exc', @NewChID OUTPUT    
			EXEC z_NewDocID 11021, 't_Exc', 9, @NewDocID OUTPUT  

/*Создание заголовка для расходных документов*/

		
			INSERT INTO t_Exc (ChID, DocID,   IntDocID, DocDate, KursMC, OurID, StockID,NewStockID, CompID, EmpID, CurrID,CodeID1,CodeID2,CodeID3)
				SELECT 
				@NewChID AS ChID, 
				@NewDocID AS DocID, 
				0 IntDocID,
				dbo.zf_GetDate(GetDate()) AS DocDate,
				dbo.zf_GetRateMC(dbo.zf_GetCurrCC()) AS KursMC, 
				9 AS OurID,
				dd.sklad_out_id AS StockID, 
				dd.sklad_in_id  AS NewStockID ,
				10793 AS CompID,
				0 AS EmpID, 
				dbo.zf_GetCurrCC() AS CurrID ,
				40 as CodeID1,
				18 as CodeID2,
				19 as CodeID3
				FROM (SELECT * FROM it_TSD_doc_head WHERE id_doc=@id_doc ) dd
				GROUP BY dd.Doc_date, dd.id_contragent, dd.id_user ,dd.sklad_in_id ,dd.sklad_out_id
			
				
/*Вставка детальной части расходных документов*/

			
	
	
	
    if object_id('tempdb..#recImp') is not null 
		drop table #recImp  
		create table #recImp(BarCode varchar(15), Qty numeric(21,9), pos int)
                            
                                                                                                                                              
	insert into #recImp (barcode, qty ,pos) 
    select                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    (SELECT ISNULL((SELECT BarCode FROM r_prodmq inner join r_prods on r_prods.prodid = r_prodmq.prodid 
	WHERE r_prodmq.prodid = dd.id_good and r_prodmq.um = r_prods.um), (SELECT good_name FROM it_TSD_goods WHERE id_good = dd.id_good) )) as BarCode, 
    dd.Count_real AS Qty ,
    row_number() over(ORDER BY id_good) AS Pos 
    FROM (SELECT * FROM it_TSD_doc_details where id_doc IN (SELECT id_doc FROM it_TSD_doc_head WHERE doc_type=1 and Id_doc = @id_doc )) dd
	
	exec ip_ImpToExcFromTerm @NewChID
	
	END
/*----------------ИНВЕНТАРИЗАЦИИ--------------------	*/
	IF @doc_type='2' BEGIN
			EXEC z_NewChID 't_Ven', @NewChID OUTPUT    
			EXEC z_NewDocID 11012, 't_Ven', @OurID, @NewDocID OUTPUT  

/*Создание заголовка для инвентаризаций			*/
			INSERT INTO t_Ven (ChID, DocID, DocDate, KursMC, OurID, StockID, CompID, EmpID, IntDocID, CurrID)
				SELECT 
				@NewChID AS ChID, 
				@NewDocID AS DocID, 
				dd.doc_date AS DocDate,
				dbo.zf_GetRateMC(dbo.zf_GetCurrCC()) AS KursMC, 
				@OurID AS OurID,
				@StockID AS StockID, 
				0 AS CompID,		
				dd.id_user AS EmpID, 	
				@NewDocID AS IntDocID,			
				dbo.zf_GetCurrCC() AS CurrID	
				FROM (SELECT * FROM it_TSD_doc_head WHERE id_doc=@id_doc ) dd
				GROUP BY dd.Doc_date, dd.id_contragent, dd.id_user
				
/*Вставка детальной части Инвентаризаций*/

		Declare InsVenA CURSOR FAST_FORWARD FOR 

			SELECT Id_good, Count_doc, Count_real FROM it_TSD_doc_details d WHERE id_doc = @id_doc

		OPEN InsVenA 
		FETCH NEXT FROM InsVenA 
		INTO @Id_good, @Count_doc, @Count_real
		WHILE @@FETCH_STATUS=0
		BEGIN

			SELECT @UM = (SELECT UM FROM r_prods WHERE prodid = @Id_good)

			SELECT @Barcode = (SELECT BarCode FROM r_prodmq WHERE prodid = @Id_good AND UM=@UM)		
		
			IF EXISTS (SELECT TOP 1 1 FROM r_ProdMQ WHERE BarCode = @BarCode)
				BEGIN		
		
					SELECT @SrcPosID = (SELECT ISNULL(MAX(TSrcPosID)+1,1) 
						                FROM t_VenA 
								        WHERE ChID = @NewChID)  


			
					SELECT @TQty = (SELECT CASE when @Count_doc=0 then dbo.tf_GetRem(dbo.zf_GetOurID('t'),dbo.zf_GetStockID('t'), 1, @Id_good,null) else @Count_doc END)

					INSERT INTO t_VenA (ChID, ProdID, UM, TQty, TNewQty, BarCode, TSrcPosID)
						VALUES
					   ( 
						@NewChID,
						@Id_good,
						@UM,
						@TQty,
						@Count_real,
						@Barcode,
						@SrcPosID
					   )
				END
			ELSE
				BEGIN
					SELECT @SrcPosID = (SELECT ISNULL(MAX(SrcPosID)+1,1) 
										FROM it_VenUnknBarCodes 
										WHERE ChID = @NewChID)
										
					SELECT @UnkBarcode = (SELECT Good_name FROM it_TSD_goods WHERE Id_good = @id_good)
					
					SELECT @Notes = 'Неизвестный товар. Товар не был выгружен на ТСД'
					
					INSERT INTO it_VenUnknBarCodes (ChID, SrcPosID, BarCode, Qty, Notes) 
					VALUES
					(
					@NewChID,
					@SrcPosID,
					@UnkBarcode,
					@Count_real,
					@Notes 
					)					
				END			
           	
        FETCH NEXT FROM InsVenA 
		INTO @Id_good, @Count_doc, @Count_real
		END
		CLOSE InsVenA
		DEALLOCATE InsVenA			
				
	end


FETCH NEXT FROM DocType_IDDoc 
INTO @doc_type, @id_doc
END
CLOSE DocType_IDDoc
DEALLOCATE DocType_IDDoc


END





GO
