USE [ElitR]
GO
/****** Object:  StoredProcedure [dbo].[ap_VC_ImportOrders_Harkov]    Script Date: 04/26/2017 17:10:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[ap_VC_ImportOrders_Harkov]
AS
BEGIN
  SET NOCOUNT ON
  SET XACT_ABORT ON


BEGIN TRAN TranOrders
  
  IF OBJECT_ID('tempdb..#TOrders') IS NOT NULL  DROP TABLE #TOrders
  IF OBJECT_ID('tempdb..#TOrdersD') IS NOT NULL DROP TABLE #TOrdersD


  CREATE TABLE #TOrders
  (DocID INT, 
   DocDate SMALLDATETIME, 
   ExpDate SMALLDATETIME,
   ExpTime VARCHAR(250), 
   ClientID INT, 
   [Address] VARCHAR(250),
   Notes VARCHAR(250), 
   PayFormCode INT, 
   Recipient VARCHAR(250),
   Phone VARCHAR(250),
   DeliveryType VARCHAR(10), 
   DeliveryPriceCC NUMERIC(21,2),
   RegionID INT, 
   CompType TINYINT, 
   Code VARCHAR(20),
   DCardID VARCHAR(250),
   PRIMARY KEY CLUSTERED(DocID)) 

  CREATE TABLE #TOrdersD
  (DocID INT,
   PosID INT, 
   ProdID INT, 
   Qty INT, 
   PurPrice NUMERIC(21,9),
   Discount NUMERIC(21,9), 
   RemSchID VARCHAR(10),   
   IsVIP TINYINT,
   PRIMARY KEY CLUSTERED(DocID, PosID))

  CREATE NONCLUSTERED INDEX idx_nc_ProdID ON #TOrdersD (ProdID ASC)
  CREATE NONCLUSTERED INDEX idx_nc_RemSchID ON #TOrdersD (RemSchID ASC)

  DECLARE 
   @ChID INT, 
   @RecChID INT, 
   @InvChID INT, 
   @ExcChID INT, 
   @SaleChID INT, 
   @DocID INT, 
   @CurrID INT, 
   @KursMC NUMERIC(21,9), 
   @OrdID INT, 
   @ExpDate SMALLDATETIME, 
   @RangeID TINYINT,
   @SrcPosID INT, 
   @InvStockID SMALLINT, 
   @RecStockID SMALLINT,
   @t_PP TINYINT, 
   @SrcDocID VARCHAR(6), 
   @ProdID INT, 
   @Qty INT, 
   @OrdQty INT, 
   @SumQty INT, 
   @UM VARCHAR(10), 
   @BarCode VARCHAR(42), 
   @ElitBarCode VARCHAR(42),
   @Price NUMERIC(21,9), 
   @OrdPrice NUMERIC(21,2), 
   @PurPrice NUMERIC(21,2), 
   @Disc NUMERIC(21,9), 
   @PLID TINYINT, 
   @PPID INT, 
   @RecPPID INT,
   @ProdPPDate SMALLDATETIME, 
   @DLSDate SMALLDATETIME, 
   @InvSrcPosID INT, 
   @RecSrcPosID INT, 
   @ExcSrcPosID INT, 
   @SaleSrcPosID INT, 
   @ExtProdID INT,
   @VIPPrice NUMERIC(21,9), 
   @VIP2Price NUMERIC(21,9),
   @PGrID4 INT, 
   @OurID INT, 
   @CompID INT, 
   @TQty NUMERIC(21,9), 
   @RemSchID VARCHAR(10), 
   @DCardID VARCHAR(250), 
   @LogID INT, 
   @DiscCode INT, 
   @StorageID INT,
   @TaxTypeID INT,
   @sql NVARCHAR(MAX) = '',
   
   @DBiID INT = 1, -- текущая база (1 - ElitR)
   @VC_OurID INT = 6, --фирма 
   @ElitPLID INT = 66, --прайс оптовый в Elit
   @RegionID INT = 5,--регион (Днепр 1 прайс 28; Киев 2 прайс 48; Одесса 3 прайс 45; Харьков 5 прайс 40; )
   @DBNameOPT VARCHAR(250) = '[S-SQL-D4].Elit',
   @AddressIM VARCHAR(250) = 'Магазин "Vintage";м. Харків, пл. Конституції, буд.1'

  INSERT #TOrders
  (DocID, DocDate, ExpDate, ExpTime, ClientID, Address, Notes, PayFormCode, Recipient, Phone, DeliveryType, DeliveryPriceCC, RegionID, CompType, Code, DCardID)
  SELECT top  1 
   Id DocID, create_Date DocDate, dos_Date ExpDate,  Value ExpTime, COALESCE(user_id,0) ClientID, name_for_np+' '+dos_Adr Address, SUBSTRING(dos_Com,1,250) Notes, 
   CASE Payment WHEN 'cash' THEN 1 WHEN 'noncash' THEN 2 END PayFormCode, Name Recipient, Phone,
   dos_Type DeliveryType, dos DeliveryPriceCC, Region RegionID, 
   CASE type_register WHEN 'fast' THEN 1 WHEN 'physical' THEN 1 WHEN 'juridical' THEN 2 END CompType, RegInfoOKPO Code, 
   CASE WHEN create_Date + CAST(create_Time AS DATETIME) > discount_registration THEN CAST(discount_num AS VARCHAR(250)) ELSE '<Нет дисконтной карты>' END DCardID
  FROM OPENQUERY(VintageClub,
	'SELECT HIGH_PRIORITY
	 o.Id, o.create_Date, o.create_Time, o.dos_Date, t.Value, o.user_Id, d.name_for_np, o.dos_Adr, o.dos_Com, o.Phone, o.Payment,
	 o.Name, o.dos_Type, o.Dos, o.Region, o.type_register, j.RegInfoOKPO, disc.discount_num, disc.discount_registration
	FROM vintagemarket.order o
	JOIN vintagemarket.dostavka d ON d.Id = o.dos_Sity
	LEFT JOIN vintagemarket.dostavka_time t ON t.Id = o.dos_Time
	LEFT JOIN vintagemarket.users u ON u.Id = o.user_Id
	LEFT JOIN vintagemarket.discount disc ON disc.discount_num = u.discount_Num AND disc.status = ''active''
	LEFT JOIN vintagemarket.users_juristic j ON j.user_Id = o.user_id AND o.type_register = ''juridical''
	WHERE o.Imported = 0 AND  o.Id > 130123
	  AND o.dos_Date >= o.create_Date
	ORDER BY Id
	') vc
  WHERE vc.Region = @RegionID AND NOT EXISTS (SELECT * FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = vc.Id)
    AND EXISTS (SELECT * FROM dbo.at_r_Clients WITH(NOLOCK) WHERE ClientID = COALESCE(vc.user_id,0))
    AND (EXISTS (SELECT * FROM dbo.r_Comps WITH(NOLOCK) WHERE Code = vc.RegInfoOKPO AND vc.type_register = 'juridical') OR vc.type_register IN ('fast','physical'))
    AND (EXISTS(SELECT * FROM dbo.r_DCards WHERE DCardID = CASE WHEN vc.create_Date + CAST(vc.create_Time AS DATETIME) > vc.discount_registration THEN CAST(vc.discount_num AS VARCHAR(250)) ELSE '<Нет дисконтной карты>' END))    
    --and vc.id = 131521
 
   --Если нет заказа то выйти из процедуры
  IF NOT EXISTS (SELECT * FROM #TOrders) 
    BEGIN
      ROLLBACK TRAN TranOrders
      RETURN
    END

	    
  --для отладки  
  SELECT * FROM #TOrders
    
  INSERT #TOrdersD
  SELECT
   DocID, ROW_NUMBER() OVER (PARTITION BY DocID ORDER BY DocID, PosID) PosID, 
   ProdID, Qty, dbo.af_VC_GetPriceCC(@RegionID,ProdID,0) PurPrice, Discount, 
   CASE WHEN RemSch LIKE '%опт%' THEN 1 WHEN RemSch LIKE '%розн%' THEN 2 END RemSchID, 
   CASE WHEN COALESCE(vip,1) IN (1,2) THEN 0 WHEN COALESCE(vip,1) IN (3,4) THEN 1 END IsVIP
  FROM OPENQUERY(VintageClub,
	'SELECT HIGH_PRIORITY 
	  o.Id DocID, oi.id PosID, ot.item_id ProdID, ot.Count Qty, ot.Discount, s.name RemSch, u.vip, o.Region
	FROM vintagemarket.order_tmp ot
	JOIN vintagemarket.order_item oi on oi.order_Id = ot.order_Id and oi.unikod = ot.item_id
	JOIN vintagemarket.order o ON o.Id = oi.Order_Id
	LEFT JOIN vintagemarket.users u ON u.Id = o.user_id
	JOIN vintagemarket.storage s ON s.storage_Id = ot.storage_id
	WHERE o.Imported = 0 AND  o.Id > 130123
	  AND o.dos_Date >= o.create_Date
	ORDER BY o.Id, oi.Id  
	') vc 
  WHERE vc.Region = @RegionID AND EXISTS (SELECT * FROM #TOrders WHERE DocID = vc.DocID)
  
  --для отладки 
  SELECT * FROM #TOrdersD

 
	--Отправка почтового сообщения
	DECLARE @subject varchar(250), @body varchar(max)
	set @subject = 'Харьков. Новый заказ пришел '
	 + cast((SELECT DocID FROM #TOrders) as varchar) +'. Отгрузка ' 
	 + (SELECT CONVERT( varchar(10), ExpDate, 112) FROM #TOrders) + ' ' +
	 + cast((SELECT ExpTime FROM #TOrders) as varchar) + ' ' +
	 + ISNULL((SELECT top 1 ' ОПТ ' FROM #TOrdersD where RemSchID = 1),'') + 
	 + ISNULL((SELECT top 1 ' Розница ' FROM #TOrdersD where RemSchID = 2),'')
	set @body = '
	'
  BEGIN TRY 
	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'main',  
	@recipients = 'pashkovv@const.dp.ua; pogrebnyak@const.dp.ua',  
	@body = @body,  
	@subject = @subject
	,@query = 'SELECT * FROM tempdb..#TOrders; SELECT * FROM tempdb..#TOrdersD'; 
  END TRY  
  BEGIN CATCH
    SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
  END CATCH  
  	
  SELECT @CurrID = dbo.zf_GetCurrCC()

  SELECT @KursMC = dbo.zf_GetRateMC(@CurrID), @t_PP = dbo.zf_Var('t_PP')



  /* Блок определения схемы отгрузки (ОПТ или РОЗНИЦА) */
  DECLARE RemSch CURSOR FOR
  SELECT DISTINCT RemSchID
  FROM #TOrdersD
  ORDER BY RemSchID
  
  OPEN RemSch
  FETCH NEXT FROM RemSch INTO @RemSchID
  WHILE @@FETCH_STATUS = 0
  BEGIN--RemSch
    /* ОПТ - Импорт заказов. Создание РН, ПТ, ЗВР */ 
    IF @RemSchID = 1   
	BEGIN--@RemSchID = 1 
      DECLARE OrderW CURSOR FOR
      SELECT DISTINCT
        m.DocID, m.ExpDate, dbo.af_VC_GetDocStockID('Опт',m.RegionID,11012) InvStockID, dbo.af_VC_GetDocStockID('Розн',m.RegionID,666004) RecStockID,
        (CASE WHEN rp.PGrID4 IN (2,3,4) THEN 1 WHEN rp.PGrID4 = 0 THEN 2 END) RangeID, DCardID
      FROM #TOrders m
      JOIN #TOrdersD d ON d.DocID = m.DocID
      JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
      WHERE d.RemSchID = 1
      ORDER BY m.DocID, RangeID

	  --для отладки
	  PRINT N'FETCH NEXT FROM OrderW INTO @OrdID, @ExpDate, @InvStockID, @RecStockID, @RangeID, @DCardID'	
      SELECT DISTINCT
        m.DocID, m.ExpDate, dbo.af_VC_GetDocStockID('Опт',m.RegionID,11012) InvStockID, dbo.af_VC_GetDocStockID('Розн',m.RegionID,666004) RecStockID,
        (CASE WHEN rp.PGrID4 IN (2,3,4) THEN 1 WHEN rp.PGrID4 = 0 THEN 2 END) RangeID, DCardID
      FROM #TOrders m
      JOIN #TOrdersD d ON d.DocID = m.DocID
      JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
      WHERE d.RemSchID = 1
      ORDER BY m.DocID, RangeID
      
      OPEN OrderW
      FETCH NEXT FROM OrderW INTO @OrdID, @ExpDate, @InvStockID, @RecStockID, @RangeID, @DCardID
      WHILE @@FETCH_STATUS = 0
      BEGIN--OrderW
		/* ОПТ - Импорта заголовков заказов */
		IF NOT EXISTS (SELECT * FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = @OrdID AND OurID = @VC_OurID AND RemSchID = 1) -- если ОПТ
		BEGIN-- если ОПТ
		  EXEC dbo.z_NewChID 'at_t_IORes', @ChID OUTPUT

		  INSERT dbo.at_t_IORes
		    (ChID, DocID, IntDocID, DocDate, ExpDate, ExpTime, KursMC, OurID, StockID, CompID, CurrID, ClientID, ReserveProds, 
		    CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, StateCode, EmpID, Discount, Notes, Address, Recipient, Phone, DCardID, RemSchID)
		  SELECT
		    @ChID ChID, DocID, DocID IntDocID, DocDate, ExpDate, ExpTime, @KursMC KursMC, @VC_OurID OurID, dbo.af_VC_GetDocStockID('Розн',m.RegionID,666004) StockID,
		    (CASE CompType WHEN 2 THEN (SELECT CompID FROM dbo.r_Comps WITH(NOLOCK) WHERE Code = m.Code AND CompID BETWEEN 200000 AND 300000) ELSE
		    (CASE RegionID WHEN 1 THEN 114 WHEN 2 THEN 115 WHEN 3 THEN 116  WHEN 5 THEN 117 END) END) CompID, @CurrID CurrID, ClientID, 1 ReserveProds, 
		    63 CodeID1, 18 CodeID2, 
		    (CASE PayFormCode WHEN 1 THEN (CASE RegionID WHEN 1 THEN 24 WHEN 2 THEN 74 WHEN 3 THEN 91 WHEN 5 THEN 76 END) 
				  WHEN 2 THEN 19 ELSE -1 END) CodeID3,                 
		    124 CodeID4,
		    (CASE RegionID WHEN 1 THEN 997 WHEN 2 THEN 988 WHEN 3 THEN 971 WHEN 5 THEN 987 END) CodeID5, 
		     110 StateCode, 0 EmpID, 0 Discount, Notes, [Address], Recipient, Phone, DCardID, 1
		   FROM #TOrders m
		   WHERE DocID = @OrdID 
		   AND NOT EXISTS (SELECT * FROM dbo.at_t_IORes WHERE DocID = m.DocID AND OurID = @VC_OurID)

		    /* Опт - Импорт заголовка ПТО ВД */
		    EXEC dbo.z_NewChID 't_SaleTemp', @SaleChID OUTPUT  
		  
			INSERT dbo.t_SaleTemp 
			  (ChID, CRID, DocDate, DocTime, DocState, RateMC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
			  DCardID, Discount, DeskCode, OperID, EmpID, OurID, StockID, Notes, InChID)
			VALUES
			(@SaleChID, 1, @ExpDate, @ExpDate, 10, @KursMC, 0, 0, 0, 0, 0,
			 @DCardID, 0, 233, 1, 0, 6, @RecStockID, CAST(@OrdID AS VARCHAR(10)) + ' - Опт', @ChID) 
		       
			INSERT dbo.z_DocLinks
			  (LinkDocDate, ParentDocCode, ParentChID, ParentDocDate, ParentDocID, ChildDocCode, ChildChID, ChildDocDate, ChildDocID, LinkSumCC, DocLinkTypeID)
			SELECT 
			  GETDATE() LinkDocDate, 666004 ParentDocCode, ChID ParentChID, DocDate ParentDocDate, DocID ParentDocID, 
			  1011 ChildDocCode, @SaleChID ChildChID, @ExpDate ChildDocDate, 0 ChildDocID, 0 LinkSumCC, 0 DocLinkTypeID  
			FROM dbo.at_t_IORes WITH(NOLOCK)
			WHERE ChID = @ChID              
		END-- если ОПТ  
		/* ОПТ - Импорт товаров Алеф-Элит */
		IF @RangeID = 1
		BEGIN--IF @RangeID = 1
		  SET @SrcPosID = 1         
		
		  /* ОПТ - Импорт заголовков документов РН и ПТ согласно принадлежности товара фирмам */
		  DECLARE OrderW_1 CURSOR FOR
		  /* ОПТ - Определение принадлежности товара фирмам: Арда-Трейдинг, МаркетА */
		  SELECT DISTINCT CASE p.PGrID4 WHEN 3 THEN 2 ELSE p.PGrID4 END PGrID4
		  FROM #TOrdersD d
		  JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = d.ProdID
		  WHERE RemSchID = 1 AND DocID = @OrdID AND p.PGrID4 IN (2,3,4)
		  ORDER BY PGrID4

		  OPEN OrderW_1
		  FETCH NEXT FROM OrderW_1 INTO @PGrID4
		  WHILE @@FETCH_STATUS = 0
		  BEGIN--OrderW_1   
			SELECT @OurID = (CASE @PGrID4 WHEN 2 THEN 1 WHEN 4 THEN 11 END)
		    
			SELECT @StorageID = (CASE @OurID WHEN 1 THEN 1 WHEN 11 THEN 3 END)   
		
			SELECT @CompID = (CASE @OurID WHEN 1 THEN 80 WHEN 11 THEN 82 END)        

			--SET @sql = N'EXEC ' + @DBNameOPT + '.dbo.z_NewChID ''t_Inv'', @InvChID OUT '
			--EXEC SP_EXECUTESQL @sql, N'@TableName VARCHAR(250), @InvChID INT OUT', 't_Inv', @InvChID OUT   
			--select @sql
		    
			--SET @sql = N'EXEC ' + @DBNameOPT + '.dbo.z_NewDocID 11012, ''t_Inv'', @OurID, @DocID OUTPUT '
			--EXEC SP_EXECUTESQL @sql, N'@DocCode int, @TableName varchar(250), @OurID int, @DocID int OUTPUT', 11012, 't_Inv', @OurID , @DocID  OUTPUT  
			--select @sql   
		     
			EXEC [S-SQL-D4].Elit.dbo.z_NewChID 't_Inv', @InvChID OUTPUT
		
			EXEC [S-SQL-D4].Elit.dbo.z_NewDocID 11012, 't_Inv', @OurID, @DocID OUTPUT

		       
			SELECT @SrcDocID = CAST(YEAR(@ExpDate) AS VARCHAR(4)) +
							   (CASE WHEN LEN(CAST(MONTH(@ExpDate) AS VARCHAR(2))) < 2
									 THEN '0' + CAST(MONTH(@ExpDate) AS VARCHAR(2))
									 ELSE CAST(MONTH(@ExpDate) AS VARCHAR(2)) END)  
									                         
			--для отладки
			PRINT N'@InvChID, @DocID, @DocID, @ExpDate, @KursMC, @OurID, @InvStockID, 10791, 63, 18, 4, 0, 0, 0, 1, 0, 0,@ExpDate ,@OrdID, 2, 202, 1, ''Магазин "Vintage";м. Харків, пл. Конституції, буд.1'''
			SELECT @InvChID, @DocID, @DocID, @ExpDate, @KursMC, @OurID, @InvStockID, 10791, 63, 18, 4, 0, 0, 0, 1, 0, 0,@ExpDate ,@OrdID, 2, 202, 1, 'Магазин "Vintage";м. Харків, пл. Конституції, буд.1'

			/* ОПТ - Расходная накладная: Заголовок - Elit*/
			INSERT [S-SQL-D4].Elit.dbo.t_Inv
			  (ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
			  Discount, PayDelay, EmpID, TaxDocID,taxdocdate, SrcDocID, CurrID, DelivID, KursCC,Address)
			VALUES
			  (@InvChID, @DocID, @DocID, @ExpDate, @KursMC, @OurID, @InvStockID, 10791, 63, 18, 4, 0, 0, 0, 1, 0, 0,@ExpDate ,@OrdID, 2, 202, 1, @AddressIM)

			-- SET @sql = N'INSERT ' + @DBNameOPT + '.dbo.t_Inv
								 --(ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
								 --Discount, PayDelay, EmpID, TaxDocID,taxdocdate, SrcDocID, CurrID, DelivID, KursCC)
								 --VALUES
								 --(@InvChID, @DocID, @DocID, @ExpDate, @KursMC, @OurID, @InvStockID, 10791, 63, 18, 4, 0, 0, 0, 1, 0, 0,@ExpDate ,@OrdID, 2, 202, 1)'
			            
			-- EXEC SP_EXECUTESQL @sql  
			        
			/* ОПТ - Приход товара: Заголовок - ElitR */
			EXEC dbo.z_NewChID 't_Rec', @RecChID OUTPUT
			EXEC dbo.z_NewDocID 11002, 't_Rec', @VC_OurID, @DocID OUTPUT    
			
			INSERT dbo.t_Rec
			(ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
			 Discount, PayDelay, EmpID, SrcDocID, TaxDocID, CurrID, InDocID)
			VALUES
			(@RecChID, @DocID, @DocID, @ExpDate, @KursMC, @VC_OurID, @RecStockID, @CompID, 82, 15, 19, 0, 0, 0, 0, 0, @SrcDocID, 0, @CurrID, @OrdID)
			
			INSERT dbo.z_DocLinks
			(LinkDocDate, ParentDocCode, ParentChID, ParentDocDate, ParentDocID, ChildDocCode, ChildChID, ChildDocDate, ChildDocID, LinkSumCC, DocLinkTypeID)
			SELECT 
			 GETDATE() LinkDocDate, 666004 ParentDocCode, ChID ParentChID, DocDate ParentDocDate, DocID ParentDocID, 
			 11002 ChildDocCode, @RecChID ChildChID, @ExpDate ChildDocDate, @DocID ChildDocID, 0 LinkSumCC, 0 DocLinkTypeID  
			FROM dbo.at_t_IORes WITH(NOLOCK)
			WHERE DocID = @OrdID
			
			SELECT @RecSrcPosID = 1

			/* ОПТ - Подготовка товаров в детали документов РН, ПТ, ЗВР для документов согласно фирм */
			DECLARE OrderWD_1 CURSOR FOR
			SELECT
			 d.ProdID, d.Qty, d.Qty OrdQty, rp.UM, mq.BarCode, 
			 d.PurPrice PurPrice, dbo.af_VC_GetPriceCC(@RegionID,d.ProdID,d.Discount) OrdPrice,
			 (CASE WHEN dbo.af_VC_GetOrderPLID(m.RegionID,d.ProdID) IN (31,34,38,39,43,45) THEN 0 
				   ELSE d.Discount END) Discount,
			 COALESCE((SELECT PriceMC FROM dbo.r_ProdMP WITH(NOLOCK) WHERE ProdID = d.ProdID AND PLID = 32), 0) VIPPriceCC,
			 COALESCE((SELECT PriceMC FROM dbo.r_ProdMP WITH(NOLOCK) WHERE ProdID = d.ProdID AND PLID = 25), 0) VIP2PriceCC,         
			 (CASE d.IsVIP WHEN 0 THEN dbo.af_VC_GetPLID(m.RegionID) WHEN 1 THEN 32 WHEN 2 THEN 25 END) PLID ,rp.TaxTypeID
			FROM #TOrdersD d
			JOIN #TOrders m ON m.DocID = d.DocID
			JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID 
			JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = d.ProdID AND mq.UM = rp.UM
			JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rp.ProdID 
										 AND ((rp.PGrID4 = 2 AND ec.CompID IN (71,80,81))
											  OR (rp.PGrID4 = 3 AND ec.CompID = 72)
											  OR (rp.PGrID4 = 4 AND ec.CompID = 82))               
			WHERE d.RemSchID = 1 AND d.DocID = @OrdID AND CASE rp.PGrID4 WHEN 3 THEN 2 ELSE rp.PGrID4 END = @PGrID4
			  AND EXISTS (SELECT * FROM [S-SQL-D4].Elit.dbo.r_ProdMP WITH(NOLOCK) WHERE PLID = @ElitPLID AND ProdID = ec.ExtProdID AND PriceMC > 0)
			GROUP BY d.ProdID, d.Qty, rp.UM, mq.BarCode, d.PurPrice, d.Discount, m.RegionID, d.IsVIP, d.PosID ,rp.TaxTypeID           
			ORDER BY d.PosID
			
			--для отладки
			PRINT N'FETCH NEXT FROM OrderWD_1 INTO @ProdID, @Qty, @OrdQty, @UM, @BarCode, @PurPrice, @OrdPrice, @Disc, @VIPPrice, @VIP2Price, @PLID ,@TaxTypeID'
			SELECT
			 d.ProdID, d.Qty, d.Qty OrdQty, rp.UM, mq.BarCode, 
			 d.PurPrice PurPrice, dbo.af_VC_GetPriceCC(@RegionID,d.ProdID,d.Discount) OrdPrice,
			 (CASE WHEN dbo.af_VC_GetOrderPLID(m.RegionID,d.ProdID) IN (31,34,38,39,43,45) THEN 0 
				   ELSE d.Discount END) Discount,
			 COALESCE((SELECT PriceMC FROM dbo.r_ProdMP WITH(NOLOCK) WHERE ProdID = d.ProdID AND PLID = 32), 0) VIPPriceCC,
			 COALESCE((SELECT PriceMC FROM dbo.r_ProdMP WITH(NOLOCK) WHERE ProdID = d.ProdID AND PLID = 25), 0) VIP2PriceCC,         
			 (CASE d.IsVIP WHEN 0 THEN dbo.af_VC_GetPLID(m.RegionID) WHEN 1 THEN 32 WHEN 2 THEN 25 END) PLID ,rp.TaxTypeID
			FROM #TOrdersD d
			JOIN #TOrders m ON m.DocID = d.DocID
			JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID 
			JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = d.ProdID AND mq.UM = rp.UM
			JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rp.ProdID 
										 AND ((rp.PGrID4 = 2 AND ec.CompID IN (71,80,81))
											  OR (rp.PGrID4 = 3 AND ec.CompID = 72)
											  OR (rp.PGrID4 = 4 AND ec.CompID = 82))               
			WHERE d.RemSchID = 1 AND d.DocID = @OrdID AND CASE rp.PGrID4 WHEN 3 THEN 2 ELSE rp.PGrID4 END = @PGrID4
			  AND EXISTS (SELECT * FROM [S-SQL-D4].Elit.dbo.r_ProdMP WITH(NOLOCK) WHERE PLID = @ElitPLID AND ProdID = ec.ExtProdID AND PriceMC > 0)
			GROUP BY d.ProdID, d.Qty, rp.UM, mq.BarCode, d.PurPrice, d.Discount, m.RegionID, d.IsVIP, d.PosID ,rp.TaxTypeID           
			ORDER BY d.PosID	
									
			OPEN OrderWD_1
			FETCH NEXT FROM OrderWD_1 INTO @ProdID, @Qty, @OrdQty, @UM, @BarCode, @PurPrice, @OrdPrice, @Disc, @VIPPrice, @VIP2Price, @PLID ,@TaxTypeID
			WHILE @@FETCH_STATUS = 0
			BEGIN--OrderWD_1 
			  SET @TQty = @Qty             
			   
			  DECLARE ProdEC CURSOR FOR
			  SELECT CAST(ec.ExtProdID AS INT) ExtProdID, (mp.PriceMC * @KursMC) Price
			  FROM dbo.r_ProdEC ec WITH(NOLOCK)
			  JOIN [S-SQL-D4].Elit.dbo.r_ProdMP mp WITH(NOLOCK) ON mp.PLID = @ElitPLID AND mp.ProdID = ec.ExtProdID AND mp.PriceMC > 0
			  WHERE ec.ProdID = @ProdID AND ((@PGrID4 = 2 AND ec.CompID IN (71,80,81,72))
										  OR (@PGrID4 = 4 AND ec.CompID = 82)) 
			  ORDER BY mp.PriceMC
			
			  OPEN ProdEC
			  FETCH NEXT FROM ProdEC INTO @ExtProdID, @Price
			  WHILE (@@FETCH_STATUS = 0 AND @TQty > 0)
			  BEGIN--ProdEC
				SELECT @SumQty = @TQty

				/* ОПТ - Импорт товарной части документов РН, ПТ, ЗВР согласно фирм */
				DECLARE OrderWD_1_PPs CURSOR FOR
				SELECT r.PPID, (r.Qty - r.AccQty) RemQty
				FROM [S-SQL-D4].Elit.dbo.t_Rem r WITH(NOLOCK)
				JOIN [S-SQL-D4].Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID = r.ProdID AND tp.PPID = r.PPID
				WHERE OurID = @OurID AND r.StockID = @InvStockID AND r.SecID = 1 AND r.ProdID = @ExtProdID AND (r.Qty - r.AccQty) > 0          
				ORDER BY COALESCE(tp.DLSDate,'20790606') ASC, COALESCE(tp.ProdPPDate,'20790606') ASC, tp.PPID ASC

				SELECT @SaleSrcPosID = 1

				OPEN OrderWD_1_PPs
				FETCH NEXT FROM OrderWD_1_PPs INTO @PPID, @Qty
				WHILE (@@FETCH_STATUS = 0) AND (@SumQty > 0)
				BEGIN--OrderWD_1_PPs
				  IF @Qty > @SumQty	SET @Qty = @SumQty

				  SELECT @ElitBarCode = mq.BarCode 
				  FROM [S-SQL-D4].Elit.dbo.r_ProdMQ mq WITH(NOLOCK) 
				  JOIN [S-SQL-D4].Elit.dbo.r_Prods rp ON rp.ProdID = mq.ProdID AND rp.UM = mq.UM
				  WHERE mq.ProdID = @ExtProdID

				  /* ОПТ - Импорт деталей в РН - Elit */
				  SELECT @InvSrcPosID = COALESCE(MAX(SrcPosID), 0) + 1 
				  FROM [S-SQL-D4].Elit.dbo.t_InvD WHERE ChID = @InvChID
			      
			      --для отладки
			      PRINT N'SELECT @InvChID, @InvSrcPosID, @ExtProdID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate) * @Qty,
					 dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @Expdate) * @Qty, @Price, @Price * @Qty, @ElitBarCode, 1'
			      SELECT @InvChID, @InvSrcPosID, @ExtProdID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate) * @Qty,
					 dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @Expdate) * @Qty, @Price, @Price * @Qty, @ElitBarCode, 1
					             
				  INSERT [S-SQL-D4].Elit.dbo.t_InvD
					(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID)
				  VALUES
					(@InvChID, @InvSrcPosID, @ExtProdID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate) * @Qty,
					 dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @Expdate) * @Qty, @Price, @Price * @Qty, @ElitBarCode, 1)
			                  
				  -- SET @sql = N'INSERT ' + @DBNameOPT + '.dbo.t_InvD
					--  (ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID)
					--  VALUES
					--  (@InvChID, @InvSrcPosID, @ExtProdID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate) * @Qty,
					--   dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @Expdate) * @Qty, @Price, @Price * @Qty, @ElitBarCode, 1)'
				  -- EXEC SP_EXECUTESQL @sql 
							  
							  
				  SELECT @RecPPID = dbo.tf_NewPPID(@ProdID)

				  INSERT dbo.t_PInP
					 (ProdID, PPID, PriceMC_In, PriceMC, Priority, ProdDate, DLSDate, CurrID, CompID, Article, CostAC, PPWeight, File1, File2, File3,
					 PriceCC_In, CostCC, PPDelay, ProdPPDate, PriceAC_In, CostMC, CstProdCode, ElitProdID)
					 SELECT
						@ProdID ProdID, @RecPPID PPID, (@Price / @KursMC) PriceMC_In, 0 PriceMC, @RecPPID Priority, @ExpDate ProdDate, DLSDate, @CurrID CurrID, 
						@CompID CompID, Article, @Price CostAC, PPID PPWeight, File1, File2, File3, 
						@Price PriceCC_In, @Price CostCC, 0 PPDelay, ProdPPDate,  @Price PriceAC_In, (@Price / @KursMC) CostMC, CstProdCode, @ExtProdID ElitProdID
					 FROM [S-SQL-D4].Elit.dbo.t_PInP WITH(NOLOCK) 
					 WHERE ProdID = @ExtProdID AND PPID = @PPID      

				  /* ОПТ - Импорт деталей в ПТ - ElitR */
				  INSERT dbo.t_RecD
					(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, CostSum, CostCC, Extra, PriceCC, BarCode, SecID)
				  VALUES
				   (@RecChID, @RecSrcPosID, @ProdID, @RecPPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_nt(@Price, @ProdID, @ExpDate) * @Qty,
					dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@Price, @ProdID, @ExpDate) * @Qty, @Price, @Price * @Qty, 0, 0, 0, 0, @BarCode, 1)

				  SELECT @OrdPrice = CASE @PLID WHEN 32 THEN @VIPPrice WHEN 25 THEN @VIP2Price ELSE @OrdPrice END

				  /* ОПТ - Импорт ЗВР - ElitR */
				  INSERT dbo.at_t_IOResD
					(ChID, SrcPosID, BarCode, ProdID, PPID, UM, Qty, OrdQty, PriceCC_nt, SumCC_nt, 
					 Tax, TaxSum, PriceCC_wt, SumCC_wt, SecID, PLID, Discount, PurPriceCC_nt, PurTax, PurPriceCC_wt, StorageID)
				  VALUES
					 (@ChID, @SrcPosID, @BarCode, @ProdID, @RecPPID, @UM, @Qty, @OrdQty, dbo.zf_GetProdPrice_nt(@OrdPrice, @ProdID, @ExpDate), dbo.zf_GetProdPrice_nt(@OrdPrice, @ProdID, @ExpDate) * @Qty,
					  dbo.zf_GetProdPrice_wtTax(@OrdPrice, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@OrdPrice, @ProdID, @ExpDate) * @Qty, @OrdPrice, @OrdPrice * @Qty, 1, 
					  @PLID, @Disc, dbo.zf_GetProdPrice_nt(@PurPrice, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@PurPrice, @ProdID, @ExpDate), @PurPrice, @StorageID)
					 
				  INSERT dbo.t_SaleTempD 
					 (ChID, SrcPosID, ProdID, UM, Qty, RealQty, PriceCC_wt, SumCC_wt, PurPriceCC_wt, PurSumCC_wt, 
					  BarCode, RealBarCode, PLID, UseToBarQty, PosStatus, CSrcPosID, CanEditQty, TaxTypeID)
				  VALUES
					 (@SaleChID, @RecSrcPosID, @ProdID, @UM, @Qty, 1, @OrdPrice, @OrdPrice * @Qty, @PurPrice, @PurPrice * @Qty,
					  @BarCode, @BarCode, @PLID, 0, 1, @SrcPosID, 0, @TaxTypeID) 
					  
					--для отладки
					SELECT @PurPrice as PurPrice
					
				  /* Блок работы со скидками */
				  /* Заказ без ДК */
				  IF @DCardID = '<Нет дисконтной карты>' AND @OrdPrice != @PurPrice
					 BEGIN--IF @DCardID
					   IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = @DCardID)
						 INSERT dbo.z_DocDC 
						 (DocCode, ChID, DCardID)
						 VALUES
						 (1011, @SaleChID, @DCardID)
						                
					   SELECT @LogID = ISNULL ( MAX(LogID), 0) + 1  FROM dbo.z_LogDiscExp WHERE DBiID = @DBiID       

					   INSERT dbo.z_LogDiscExp
						(LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, Discount, DBiID)
					   VALUES 
					   (@LogID, @DCardID, 1, 1011, @SaleChID, @RecSrcPosID, 0, 0, (1 - (@OrdPrice / @PurPrice))  * 100, @DBiID )                              
					 END--IF @DCardID 
						/* Заказ с ДК */
					 ELSE IF EXISTS (SELECT * FROM dbo.r_DCards WITH(NOLOCK) WHERE DCardID = @DCardID AND DCTypeCode IN (1,2)) 
					 BEGIN--IF @DCardID ELSE  
						SELECT @DiscCode = CASE DCTypeCode WHEN 1 THEN 49 WHEN 2 THEN 48 END FROM dbo.r_DCards WITH(NOLOCK) WHERE DCardID = @DCardID              
						              
						IF @OrdPrice != @PurPrice 
						BEGIN--IF @OrdPrice != @PurPrice                                        
						 /* Пишем в лог предоставления скидки по ДК только неакционные товары, скидка по которым = скидке ДК */            
						 IF (NOT EXISTS (SELECT * FROM dbo.r_ProdMP WITH(NOLOCK) 
							 WHERE ProdID = @ProdID AND PLID = @PLID AND PromoPriceCC > 0 
							 AND dbo.zf_GetDate(GETDATE()) BETWEEN BDate AND EDate)
							 AND 
							 NOT EXISTS (SELECT *  FROM dbo.r_DCards WITH(NOLOCK) 
							 WHERE DCardID = @DCardID AND Discount != ROUND((1 - (@OrdPrice / @PurPrice))  * 100, 0)))
						 BEGIN--IF 01
						   IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = @DCardID)
							 INSERT dbo.z_DocDC 
							   (DocCode, ChID, DCardID)
							 VALUES
							   (1011, @SaleChID, @DCardID)                             
						              
						   SELECT @LogID = ISNULL ( MAX(LogID), 0) + 1  FROM dbo.z_LogDiscExp WHERE DBiID =@DBiID          
						            
						   INSERT dbo.z_LogDiscExp
							 (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, Discount, DBiID)
						   VALUES 
							 (@LogID, @DCardID, 1, 1011, @SaleChID, @RecSrcPosID, @DiscCode, 0, ROUND((1 - (@OrdPrice / @PurPrice))  * 100, 0), @DBiID)               
						 END--IF 01
						                
						 /* По акционным товарам или товарам, скидка на которые не соответствует скидке в свойствах ДК - лог предоставления скидки не привязываем к ДК */
						 ELSE--IF 01 ELSE                           
						 BEGIN--IF 01 ELSE  
							IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = '<Нет дисконтной карты>')
							  INSERT dbo.z_DocDC 
							   (DocCode, ChID, DCardID)
							  VALUES
							   (1011, @SaleChID, '<Нет дисконтной карты>')                 
							                
							SELECT @LogID = ISNULL ( MAX(LogID), 0) + 1 FROM dbo.z_LogDiscExp WHERE DBiID = @DBiID         
						             
							INSERT dbo.z_LogDiscExp
							  (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, Discount, DBiID)
							VALUES 
							  (@LogID, '<Нет дисконтной карты>', 1, 1011, @SaleChID, @RecSrcPosID, 0, 0, (1 - (@OrdPrice / @PurPrice))  * 100, @DBiID)                                              
						 END--IF 01 ELSE 
						END--IF @OrdPrice != @PurPrice                              
					              
						/* Начисляем бонусы на ДК */
						IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = @DCardID)
							 INSERT dbo.z_DocDC 
							 (DocCode, ChID, DCardID)
							 VALUES
							 (1011, @SaleChID, @DCardID)                  
						              
							SELECT @LogID = ISNULL ( MAX(LogID), 0) + 1 FROM dbo.z_LogDiscRec WHERE DBiID = @DBiID
						              
							INSERT dbo.z_LogDiscRec
							  (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, logdate ,BonusType, DBiID)
							VALUES 
							  (@LogID, @DCardID, 1, 1011, @SaleChID, @RecSrcPosID, @DiscCode, @OrdPrice * @Qty,GETDATE(), 0, @DBiID)              
					 END--IF @DCardID ELSE   

				  SELECT @RecSrcPosID += 1, @SrcPosID += 1, @SumQty -= @Qty, @TQty -= @Qty

				  FETCH NEXT FROM OrderWD_1_PPs INTO @PPID, @Qty
				END--OrderWD_1_PPs

				CLOSE OrderWD_1_PPs
				DEALLOCATE OrderWD_1_PPs
			    
				FETCH NEXT FROM ProdEC INTO @ExtProdID, @Price
			  END--ProdEC
			          
			  CLOSE ProdEC
			  DEALLOCATE ProdEC    

			  FETCH NEXT FROM OrderWD_1 INTO @ProdID, @Qty, @OrdQty, @UM, @BarCode, @PurPrice, @OrdPrice, @Disc, @VIPPrice, @VIP2Price, @PLID ,@TaxTypeID
			END--OrderWD_1
			        
			CLOSE OrderWD_1
			DEALLOCATE OrderWD_1

			FETCH NEXT FROM OrderW_1 INTO @PGrID4
	      END--OrderW_1

	      CLOSE OrderW_1
	      DEALLOCATE OrderW_1
		END--IF @RangeID = 1   

		/* ОПТ - Импорт товаров сторонних поставщиков */
		IF @RangeID = 2
		BEGIN--IF @RangeID = 2
			DECLARE OrderWD_2 CURSOR FOR
			SELECT
			  d.ProdID, d.Qty, d.Qty OrdQty, rp.UM, mq.BarCode, d.PurPrice PurPrice, dbo.af_VC_GetPriceCC(@RegionID,d.ProdID,d.Discount) OrdPrice,
			  (CASE WHEN dbo.af_VC_GetOrderPLID(m.RegionID,d.ProdID) IN (31,34,38,39,43,45) THEN 0 ELSE d.Discount END) Discount,
			   dbo.af_VC_GetOrderPLID(m.RegionID,d.ProdID) PLID
			FROM #TOrdersD d
			JOIN #TOrders m ON m.DocID = d.DocID
			JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
			JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = d.ProdID AND mq.UM = rp.UM
			WHERE RemSchID = 1 AND d.DocID = @OrdID AND rp.PGrID4 = 0
			ORDER BY d.PosID

			OPEN OrderWD_2
			FETCH NEXT FROM OrderWD_2 INTO @ProdID, @Qty, @OrdQty, @UM, @BarCode, @PurPrice, @OrdPrice, @Disc, @PLID
			WHILE @@FETCH_STATUS = 0
			BEGIN--OrderWD_2
				SELECT @SumQty = @Qty

				DECLARE OrderWD_2_PPs CURSOR FOR
				SELECT PPID, RemQty FROM dbo.tf_GetPPIDRems(@t_PP, @VC_OurID, @RecStockID, 1, @ProdID) WHERE RemQty > 0

				OPEN OrderWD_2_PPs
				FETCH NEXT FROM OrderWD_2_PPs INTO @PPID, @Qty
				WHILE (@@FETCH_STATUS = 0 AND @SumQty > 0)
				BEGIN--OrderWD_2_PPs
				  IF @Qty > @SumQty SET @Qty = @SumQty

				  SELECT @SrcPosID = MAX(SrcPosID) + 1 FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = @ChID

				  INSERT dbo.at_t_IOResD
					(ChID, SrcPosID, BarCode, ProdID, PPID, UM, Qty, OrdQty, PriceCC_nt, SumCC_nt,
					Tax, TaxSum, PriceCC_wt, SumCC_wt, SecID, PLID, Discount, PurPriceCC_nt, PurTax, PurPriceCC_wt, StorageID)
				  VALUES
					(@ChID, COALESCE(@SrcPosID,1), @BarCode, @ProdID, @PPID, @UM, @Qty, @OrdQty, dbo.zf_GetProdPrice_nt(@OrdPrice, @ProdID, @ExpDate), dbo.zf_GetProdPrice_nt(@OrdPrice, @ProdID, @ExpDate) * @Qty,
					 dbo.zf_GetProdPrice_wtTax(@OrdPrice, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@OrdPrice, @ProdID, @ExpDate) * @Qty, @OrdPrice, @OrdPrice * @Qty, 1, 
					 @PLID, @Disc, dbo.zf_GetProdPrice_nt(@PurPrice, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@PurPrice, @ProdID, @ExpDate), @PurPrice, 4)

				  SELECT @SrcPosID += 1, @SumQty -= @Qty

				  FETCH NEXT FROM OrderWD_2_PPs INTO @PPID, @Qty
				END--OrderWD_2_PPs
				CLOSE OrderWD_2_PPs
				DEALLOCATE OrderWD_2_PPs

				FETCH NEXT FROM OrderWD_2 INTO @ProdID, @Qty, @OrdQty, @UM, @BarCode, @PurPrice, @OrdPrice, @Disc, @PLID
		    END--OrderWD_2
		    CLOSE OrderWD_2
		    DEALLOCATE OrderWD_2  
		END--IF @RangeID = 2
		FETCH NEXT FROM OrderW INTO @OrdID, @ExpDate, @InvStockID, @RecStockID, @RangeID, @DCardID
      END--OrderW
      CLOSE OrderW
      DEALLOCATE OrderW
	END--@RemSchID = 1 
    
    /* РОЗНИЦА - Импорт заказов. Создание РН, ПТ, ЗВР */     
    ELSE IF @RemSchID = 2
    BEGIN--@RemSchID = 1 ELSE @RemSchID = 2
      DECLARE OrderR CURSOR FOR
      SELECT DISTINCT
        m.DocID, m.ExpDate, CASE mp.StockID WHEN 0 THEN 1200 ELSE mp.StockID END InvStockID, dbo.af_VC_GetDocStockID('Розн',m.RegionID,666004) RecStockID,
        (CASE WHEN rp.PGrID1 IN (SELECT AValue FROM dbo.zf_FilterToTable('200-207,209-399,401-501,704')) THEN 1 /* Супермаркет "Винтаж" */ 
              WHEN rp.PGrID1 = 208 AND mp.StockID = 1222 THEN 2 /* Кафе "Винтаж" */ 
              WHEN rp.PGrID1 = 208 AND mp.StockID = 1225 THEN 3 /* Бар "Тапас" */END) RangeID, DCardID
      FROM #TOrders m
      JOIN #TOrdersD d ON d.DocID = m.DocID
      JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
      JOIN dbo.r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = dbo.af_VC_GetPLID(m.RegionID)
      WHERE d.RemSchID = 2
      ORDER BY m.DocID, RangeID, InvStockID
      
      	  --для отладки
	  PRINT N'FETCH NEXT FROM OrderR INTO @OrdID, @ExpDate, @InvStockID, @RecStockID, @RangeID, @DCardID'	
      SELECT DISTINCT
        m.DocID, m.ExpDate, CASE mp.StockID WHEN 0 THEN 1200 ELSE mp.StockID END InvStockID, dbo.af_VC_GetDocStockID('Розн',m.RegionID,666004) RecStockID,
        (CASE WHEN rp.PGrID1 IN (SELECT AValue FROM dbo.zf_FilterToTable('200-207,209-399,401-501,704')) THEN 1 /* Супермаркет "Винтаж" */ 
              WHEN rp.PGrID1 = 208 AND mp.StockID = 1222 THEN 2 /* Кафе "Винтаж" */ 
              WHEN rp.PGrID1 = 208 AND mp.StockID = 1225 THEN 3 /* Бар "Тапас" */END) RangeID, DCardID
      FROM #TOrders m
      JOIN #TOrdersD d ON d.DocID = m.DocID
      JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
      JOIN dbo.r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = dbo.af_VC_GetPLID(m.RegionID)
      WHERE d.RemSchID = 2
      ORDER BY m.DocID, RangeID, InvStockID
      
      
      OPEN OrderR
      FETCH NEXT FROM OrderR INTO @OrdID, @ExpDate, @InvStockID, @RecStockID, @RangeID, @DCardID
      WHILE @@FETCH_STATUS = 0
      BEGIN--OrderR
		/* РОЗНИЦА - Импорт заголовков заказов */
		IF NOT EXISTS (SELECT * FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = @OrdID AND OurID = @VC_OurID AND RemSchID = 2)
		BEGIN--OrderR--RemSchID = 2
		  /* РОЗНИЦА - Импорт заголовка ЗВР */
		  EXEC dbo.z_NewChID 'at_t_IORes', @ChID OUTPUT
		  
		    --для отладки
	        PRINT N'INSERT dbo.at_t_IORes'	
		    SELECT
			  @ChID ChID, DocID, DocID IntDocID, DocDate, ExpDate, ExpTime, @KursMC KursMC, @VC_OurID OurID, @RecStockID StockID,
			  (CASE CompType WHEN 2 THEN (SELECT CompID FROM dbo.r_Comps WITH(NOLOCK) WHERE Code = m.Code AND CompID BETWEEN 200000 AND 300000) ELSE
			  (CASE RegionID WHEN 1 THEN 114 WHEN 2 THEN 115 WHEN 5 THEN 117 END) END) CompID, @CurrID CurrID, ClientID, 1 ReserveProds, 
			  63 CodeID1, 18 CodeID2, 
			  (CASE PayFormCode WHEN 1 THEN (CASE RegionID WHEN 1 THEN 24 WHEN 2 THEN 74 WHEN 5 THEN 76 END) 
						WHEN 2 THEN 19 ELSE -1 END) CodeID3,                 
			  124 CodeID4,
			  (CASE RegionID WHEN 1 THEN 997 WHEN 2 THEN 988 WHEN 3 THEN 971 WHEN 5 THEN 987 END) CodeID5, 
			   110 StateCode, 0 EmpID, 0 Discount, Notes, [Address], Recipient, Phone, DCardID, 2
			FROM #TOrders m
			WHERE DocID = @OrdID 
		    AND NOT EXISTS (SELECT * FROM dbo.at_t_IORes WHERE DocID = m.DocID AND OurID = @VC_OurID AND RemSchID = 2)
			

		  INSERT dbo.at_t_IORes
		    (ChID, DocID, IntDocID, DocDate, ExpDate, ExpTime, KursMC, OurID, StockID, CompID, CurrID, ClientID, ReserveProds, 
		     CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, StateCode, EmpID, Discount, Notes, Address, Recipient, Phone, DCardID, RemSchID)
		    SELECT
			  @ChID ChID, DocID, DocID IntDocID, DocDate, ExpDate, ExpTime, @KursMC KursMC, @VC_OurID OurID, @RecStockID StockID,
			  (CASE CompType WHEN 2 THEN (SELECT CompID FROM dbo.r_Comps WITH(NOLOCK) WHERE Code = m.Code AND CompID BETWEEN 200000 AND 300000) ELSE
			  (CASE RegionID WHEN 1 THEN 114 WHEN 2 THEN 115 WHEN 5 THEN 117 END) END) CompID, @CurrID CurrID, ClientID, 1 ReserveProds, 
			  63 CodeID1, 18 CodeID2, 
			  (CASE PayFormCode WHEN 1 THEN (CASE RegionID WHEN 1 THEN 24 WHEN 2 THEN 74 WHEN 5 THEN 76 END) 
						WHEN 2 THEN 19 ELSE -1 END) CodeID3,                 
			  124 CodeID4,
			  (CASE RegionID WHEN 1 THEN 997 WHEN 2 THEN 988 WHEN 3 THEN 971 WHEN 5 THEN 987 END) CodeID5, 
			   110 StateCode, 0 EmpID, 0 Discount, Notes, [Address], Recipient, Phone, DCardID, 2
			FROM #TOrders m
			WHERE DocID = @OrdID 
			AND NOT EXISTS (SELECT * FROM dbo.at_t_IORes WHERE DocID = m.DocID AND OurID = @VC_OurID AND RemSchID = 2)

          /* РОЗНИЦА - Импорт заголовка ПТО ВД */
          EXEC dbo.z_NewChID 't_SaleTemp', @SaleChID OUTPUT  

          INSERT dbo.t_SaleTemp 
            (ChID, CRID, DocDate, DocTime, DocState, RateMC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
             DCardID, Discount, DeskCode, OperID, EmpID, OurID, StockID, Notes, InChID)
           VALUES
             (@SaleChID, 1, @ExpDate, @ExpDate, 10, @KursMC, 0, 0, 0, 0, 0,
             @DCardID, 0, 233, 1, 0, @VC_OurID, @RecStockID, CAST(@OrdID AS VARCHAR(10)) + ' - РОЗНИЦА', @ChID) 
          
          /* РОЗНИЦА - Создание связей между ПТО ВД и ЗВР */   
          INSERT dbo.z_DocLinks
            (LinkDocDate, ParentDocCode, ParentChID, ParentDocDate, ParentDocID, ChildDocCode, ChildChID, ChildDocDate, ChildDocID, LinkSumCC, DocLinkTypeID)
		    SELECT 
			  GETDATE() LinkDocDate, 666004 ParentDocCode, ChID ParentChID, DocDate ParentDocDate, DocID ParentDocID, 
			  1011 ChildDocCode, @SaleChID ChildChID, @ExpDate ChildDocDate, 0 ChildDocID, 0 LinkSumCC, 0 DocLinkTypeID  
		    FROM dbo.at_t_IORes WITH(NOLOCK)
		    WHERE ChID = @ChID              
      
          SET @SrcPosID = 1          
        END--OrderR--RemSchID = 2     
  
        /* СУПЕРМАРКЕТ - Импорт товаров */
        IF @RangeID = 1
        BEGIN--IF @RangeID = 1         
          SELECT @SaleSrcPosID = COALESCE(MAX(SrcPosID), 0) + 1
          FROM dbo.t_SaleTempD WITH(NOLOCK)
          WHERE ChID = @SaleChID
            
          /* СУПЕРМАРКЕТ - Подготовка деталей для ПерТов, если товар есть на склад-подвале */
          DECLARE OrderRD_1 CURSOR FOR
          SELECT
           d.ProdID, d.Qty, d.Qty OrdQty, rp.UM, mq.BarCode, 
           d.PurPrice PurPrice, ROUND(d.PurPrice * (1 - (d.Discount / 100)), 2) OrdPrice, Discount,     
           (CASE d.IsVIP WHEN 0 THEN dbo.af_VC_GetPLID(m.RegionID) WHEN 1 THEN 32 WHEN 2 THEN 25 END) PLID,
           rp.TaxTypeID
          FROM #TOrdersD d
          JOIN #TOrders m ON m.DocID = d.DocID
          JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID 
          JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = d.ProdID AND mq.UM = rp.UM
          WHERE d.RemSchID = 2 AND d.DocID = @OrdID AND rp.PGrID1 IN (SELECT AValue FROM dbo.zf_FilterToTable('200-207,209-399,401-501,704'))
          ORDER BY d.PosID 

          OPEN OrderRD_1
          FETCH NEXT FROM OrderRD_1 INTO @ProdID, @Qty, @OrdQty, @UM, @BarCode, @PurPrice, @OrdPrice, @Disc, @PLID, @TaxTypeID
          WHILE @@FETCH_STATUS = 0
          BEGIN--OrderRD_1
            INSERT dbo.t_SaleTempD
            (ChID, SrcPosID, ProdID, UM, Qty, RealQty, PriceCC_wt, SumCC_wt, PurPriceCC_wt, PurSumCC_wt, 
             BarCode, RealBarCode, PLID, UseToBarQty, PosStatus, CSrcPosID, CanEditQty, TaxTypeID)
            VALUES
            (@SaleChID, @SaleSrcPosID, @ProdID, @UM, @Qty, 1, @OrdPrice, @OrdPrice * @Qty, @PurPrice, @PurPrice * @Qty,
             @BarCode, @BarCode, @PLID, 0, 1, @SaleSrcPosID, 0, @TaxTypeID)
             
            /* Блок работы со скидками */
            /* Заказ без ДК */
            IF @DCardID = '<Нет дисконтной карты>' AND @OrdPrice != @PurPrice
            BEGIN
              IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = @DCardID)
                INSERT dbo.z_DocDC 
                (DocCode, ChID, DCardID)
                VALUES
                (1011, @SaleChID, @DCardID)
                
              SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscExp WHERE DBiID = @DBiID         
            
              INSERT dbo.z_LogDiscExp
              (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, Discount, DBiID)
              VALUES 
              (@LogID, @DCardID, 1, 1011, @SaleChID, @SaleSrcPosID, 0, 0, (1 - (@OrdPrice / @PurPrice))  * 100, @DBiID)                              
            END 
            /* Заказ с ДК */
            ELSE IF EXISTS (SELECT * FROM dbo.r_DCards WITH(NOLOCK) WHERE DCardID = @DCardID AND DCTypeCode IN (1,2)) 
            BEGIN  
              SELECT @DiscCode = CASE DCTypeCode WHEN 1 THEN 49 WHEN 2 THEN 48 END FROM dbo.r_DCards WITH(NOLOCK) WHERE DCardID = @DCardID              
              
              IF @OrdPrice != @PurPrice 
              BEGIN                                        
                /* Пишем в лог предоставления скидки по ДК только неакционные товары, скидка по которым = скидке ДК */            
                IF (NOT EXISTS (SELECT * 
                                FROM dbo.r_ProdMP WITH(NOLOCK) 
                                WHERE ProdID = @ProdID AND PLID = @PLID AND PromoPriceCC > 0 
                                  AND dbo.zf_GetDate(GETDATE()) BETWEEN BDate AND EDate)
                    AND 
                    NOT EXISTS (SELECT * 
                                FROM dbo.r_DCards WITH(NOLOCK) 
                                WHERE DCardID = @DCardID AND Discount != ROUND((1 - (@OrdPrice / @PurPrice))  * 100, 0)))
                BEGIN
                  IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = @DCardID)
                    INSERT dbo.z_DocDC 
                    (DocCode, ChID, DCardID)
                    VALUES
                    (1011, @SaleChID, @DCardID)                             
              
                  SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscExp WHERE DBiID = @DBiID           
            
                  INSERT dbo.z_LogDiscExp
                  (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, Discount, DBiID)
                  VALUES 
                  (@LogID, @DCardID, 1, 1011, @SaleChID, @SaleSrcPosID, @DiscCode, 0, ROUND((1 - (@OrdPrice / @PurPrice))  * 100, 0), @DBiID)               
                END
                /* По акционным товарам или товарам, скидка на которые не соответствует скидке в свойствах ДК - лог предоставления скидки не привязываем к ДК */
                ELSE                            
                BEGIN
                  IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = '<Нет дисконтной карты>')
                    INSERT dbo.z_DocDC 
                    (DocCode, ChID, DCardID)
                    VALUES
                    (1011, @SaleChID, '<Нет дисконтной карты>')                 
                
                  SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscExp WHERE DBiID = @DBiID           
             
                  INSERT dbo.z_LogDiscExp
                  (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, Discount, DBiID)
                  VALUES 
                  (@LogID, '<Нет дисконтной карты>', 1, 1011, @SaleChID, @SaleSrcPosID, 0, 0, (1 - (@OrdPrice / @PurPrice))  * 100, @DBiID)                                              
                END
              END                             
              
              /* Начисляем бонусы на ДК */
              IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = @DCardID)
                INSERT dbo.z_DocDC 
                (DocCode, ChID, DCardID)
                VALUES
                (1011, @SaleChID, @DCardID)                  
              
              SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscRec WHERE DBiID = @DBiID
              
              INSERT dbo.z_LogDiscRec
              (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, logdate ,BonusType, DBiID)
              VALUES 
              (@LogID, @DCardID, 1, 1011, @SaleChID, @SaleSrcPosID, @DiscCode, @OrdPrice * @Qty,GETDATE(), 0, @DBiID)              
            END  
              
            SELECT @SaleSrcPosID += 1, @SumQty = @Qty
              
            SELECT @OrdPrice = CASE @PLID WHEN 32 THEN @VIPPrice WHEN 25 THEN @VIP2Price ELSE @OrdPrice END     
              
            /* СУПЕРМАРКЕТ - Резервирование товара в ЗВР */
            SELECT @Qty = @SumQty
              
            DECLARE OrderRD_1_IOResPPs CURSOR FOR
            SELECT PPID, RemQty
            FROM dbo.tf_GetPPIDRems(@t_PP,@VC_OurID,@RecStockID,1,@ProdID)
              
            OPEN OrderRD_1_IOResPPs
            FETCH NEXT FROM OrderRD_1_IOResPPs INTO @PPID, @Qty
            WHILE (@@FETCH_STATUS = 0) AND (@SumQty > 0)
            BEGIN--OrderRD_1_IOResPPs
              IF @Qty > @SumQty  SET @Qty = @SumQty                                                               

              /* СУПЕРМАРКЕТ - Импорт деталей в ЗВР по торговому залу */
              SELECT @SrcPosID =  MAX(SrcPosID) + 1 FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = @ChID   
                
              INSERT dbo.at_t_IOResD
                (ChID, SrcPosID, BarCode, ProdID, PPID, UM, Qty, OrdQty, 
                PriceCC_nt, SumCC_nt, 
				Tax, TaxSum, 
				PriceCC_wt, SumCC_wt, SecID, PLID, Discount, 
				PurPriceCC_nt, PurTax, PurPriceCC_wt, StorageID)
              VALUES
               (@ChID, COALESCE(@SrcPosID,1), @BarCode, @ProdID, @PPID, @UM, @Qty, @OrdQty, 
               dbo.zf_GetProdPrice_nt(@OrdPrice, @ProdID, @ExpDate), dbo.zf_GetProdPrice_nt(@OrdPrice, @ProdID, @ExpDate) * @Qty,
               dbo.zf_GetProdPrice_wtTax(@OrdPrice, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@OrdPrice, @ProdID, @ExpDate) * @Qty, 
               @OrdPrice, @OrdPrice * @Qty, 1, @PLID, @Disc, 
               dbo.zf_GetProdPrice_nt(@OrdPrice, @ProdID, @ExpDate), dbo.zf_GetProdPrice_wtTax(@OrdPrice, @ProdID, @ExpDate), @PurPrice, 5)
                 
              SELECT @SumQty -= @Qty 
              
              FETCH NEXT FROM OrderRD_1_IOResPPs INTO @PPID, @Qty  
            END--OrderRD_1_IOResPPs

            CLOSE OrderRD_1_IOResPPs
            DEALLOCATE OrderRD_1_IOResPPs                                 

            FETCH NEXT FROM OrderRD_1 INTO @ProdID, @Qty, @OrdQty, @UM, @BarCode, @PurPrice, @OrdPrice, @Disc, @PLID, @TaxTypeID
          END--OrderRD_1
        
          CLOSE OrderRD_1
          DEALLOCATE OrderRD_1
        END--IF @RangeID = 1
        FETCH NEXT FROM OrderR INTO @OrdID, @ExpDate, @InvStockID, @RecStockID, @RangeID, @DCardID            
      END--OrderR 
         
      CLOSE OrderR
      DEALLOCATE OrderR              
    END--@RemSchID = 1 ELSE @RemSchID = 2
    FETCH NEXT FROM RemSch INTO @RemSchID
  END--RemSch
  
  CLOSE RemSch
  DEALLOCATE RemSch
  
  /* Блок отката/закрепления транзакции */
  IF @@TRANCOUNT > 0
    COMMIT TRAN TranOrders
  ELSE
  BEGIN
    RAISERROR ('Процедура импорта заказов отработала с ошибкой!!!', 18, 1)
    ROLLBACK TRAN TranOrders
    RETURN
  END


  /* Добавление доставки - "Курьерская" и "Экспресс" ЗВР */
  INSERT dbo.at_t_IOResD
  (ChID, SrcPosID, BarCode, ProdID, PPID, UM, Qty, OrdQty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
   SecID, PLID, Discount, PurPriceCC_nt, PurTax, PurPriceCC_wt)
  SELECT
   (SELECT TOP 1 ChID FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = i.DocID ORDER BY 1) ChID, 
   (SELECT COALESCE(MAX(SrcPosID),0) + 1 FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = (SELECT TOP 1 ChID FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = i.DocID ORDER BY 1)) SrcPosID,
   CASE i.DeliveryType WHEN 'courier' THEN '8000' WHEN 'express' THEN '7999' END BarCode,  
   CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END ProdID,  
   0 PPID, 'послуга' UM, 1 Qty, 1 OrdQty, 
   dbo.zf_GetProdPrice_nt(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, @ExpDate) PriceCC_nt,
   dbo.zf_GetProdPrice_nt(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, @ExpDate) SumCC_nt,
   dbo.zf_GetProdPrice_wtTax(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, @ExpDate) Tax, 
   dbo.zf_GetProdPrice_wtTax(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, @ExpDate) TaxSum, 
   i.DeliveryPriceCC PriceCC_wt, i.DeliveryPriceCC SumCC_wt, 1 SecID, 
   dbo.af_VC_GetPLID(i.RegionID) PLID, 0 Discount, 
   dbo.zf_GetProdPrice_nt(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, @ExpDate) PurPriceCC_nt, 
   dbo.zf_GetProdPrice_wtTax(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, @ExpDate) PurTax, 
   i.DeliveryPriceCC PurPriceCC_wt
  FROM #TOrders i
  WHERE i.DeliveryPriceCC > 0 AND i.DeliveryType IN ('courier','express')
   
  /* Добавление доставки в ПТО ВД (в случае отгрузки ТОЛЬКО по розничной схеме) */
  INSERT dbo.t_SaleTempD
  (ChID, SrcPosID, 
   ProdID, UM, Qty, RealQty, PriceCC_wt, SumCC_wt, PurPriceCC_wt, PurSumCC_wt, 
   BarCode, RealBarCode, PLID, UseToBarQty, PosStatus, 
   CSrcPosID, CanEditQty, TaxTypeID)
  SELECT 
   l.ChildChID, (SELECT MAX(SrcPosID) + 1 FROM dbo.t_SaleTempD WHERE ChID = l.ChildChID) SrcPosID,
   d.ProdID, d.UM, d.Qty, 1 RealQty, d.PriceCC_wt, d.SumCC_wt, d.PurPriceCC_wt, d.PurPriceCC_wt * d.Qty PurSumCC_wt,
   d.BarCode, d.BarCode RealBarCode, d.PLID, 0 UseToBarQty, 1 PosStatus, 
   (SELECT MAX(SrcPosID) + 1 FROM dbo.t_SaleTempD WHERE ChID = l.ChildChID) CSrcPosID, 1 CanEditQty, p.TaxTypeID
  FROM dbo.at_t_IOResD d WITH(NOLOCK)
  JOIN at_t_IORes m WITH(NOLOCK) ON m.ChID = d.ChID
  JOIN #TOrders o ON o.DocID = m.DocID
  JOIN z_DocLinks l WITH(NOLOCK) ON l.ParentDocCode = 666004 AND l.ChildDocCode = 1011 AND l.ParentChID = d.ChID
  JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = d.ProdID
  WHERE d.ProdID IN (7999,8000,8001) AND m.RemSchID IN (1,2)

  /* Блок проверки/обновление итогов */
  UPDATE m
     SET m.TSumCC_nt = COALESCE((SELECT SUM(SumCC_nt) FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = m.ChID),0),
         m.TTaxSum = COALESCE((SELECT SUM(TaxSum) FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = m.ChID),0),
         m.TSumCC_wt = COALESCE((SELECT SUM(SumCC_wt) FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = m.ChID),0),
         m.TPurSumCC_wt = COALESCE((SELECT SUM(PurPriceCC_wt * Qty) FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = m.ChID),0),
         m.TPurTaxSum = COALESCE((SELECT SUM(PurTax * Qty) FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = m.ChID),0),
         m.TPurSumCC_nt = COALESCE((SELECT SUM(PurPriceCC_nt * Qty) FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = m.ChID),0)
    FROM dbo.at_t_IORes m
   WHERE EXISTS (SELECT * FROM #TOrders WHERE DocID = m.DocID)
     AND m.ChID IN (SELECT m.ChID
                    FROM dbo.at_t_IORes m WITH(NOLOCK)
                    LEFT JOIN at_t_IOResD d WITH(NOLOCK) ON m.ChID = d.ChID
                    GROUP BY m.ChID, m.TSumCC_nt, m.TSumCC_wt, m.TTaxSum, m.TPurTaxSum, m.TPurSumCC_nt, m.TPurSumCC_wt
                    HAVING m.TSumCC_nt != SUM(COALESCE(d.SumCC_nt,0))
                        OR m.TSumCC_wt != SUM(COALESCE(d.SumCC_wt,0))
                        OR m.TTaxSum != SUM(COALESCE(d.TaxSum,0))
                        OR m.TPurTaxSum != SUM(COALESCE(d.PurTax * d.Qty,0))
                        OR m.TPurSumCC_nt != SUM(COALESCE(d.PurPriceCC_nt * d.Qty,0))
                        OR m.TPurSumCC_wt != SUM(COALESCE(d.PurPriceCC_wt * d.Qty,0)))
                        
  /* Обновление статуса заказов в базе ИМ после импорта */
  --DECLARE @SQL NVARCHAR(MAX)= ''

  /*SELECT @SQL += 'UPDATE vintagemarket.order SET Imported = 1 WHERE Id = ' + CAST(m.DocID AS NVARCHAR(10)) + ';
' FROM #TOrders m
  WHERE EXISTS(SELECT * FROM dbo.at_t_IORes WHERE DocID = m.DocID)
  
  IF LEN(@SQL) > 0
    EXEC(@SQL) AT VintageClub*/
  ---------------------------------------------------------------------------------------------------------------------------------
  /* Удаление временных таблиц */
  DROP TABLE #TOrders
  DROP TABLE #TOrdersD

  ---------------------------------------------------------------------------------------------------------------------------------
  /* Удаление временных таблиц деталей заказа в БД сайта 
  SET @SQL = ''

  SELECT @SQL += 
'DELETE FROM vintagemarket.order_tmp WHERE order_id = ' + CAST(vc.order_id AS VARCHAR(10)) + ';
'
  FROM OPENQUERY (VintageClub, 
'SELECT HIGH_PRIORITY DISTINCT t.order_id 
FROM vintagemarket.order_tmp t
JOIN vintagemarket.order o ON o.id = t.order_id
WHERE o.imported = 1 AND o.region = 3') vc
  WHERE EXISTS (SELECT * FROM dbo.av_VC_GetImpOrder WHERE DocID = vc.order_id)
  
  IF LEN(@SQL) > 0
    EXEC(@SQL) AT VintageClub  
    */
    
      ---------------------------------------------------------------------------------------------------------------------------------
 -- Синхронихация CHID Киев 
  --insert [s-marketa2].ElitV_Kiev_test.dbo.t_saletemp
  -- select * FROM dbo.t_saletemp where ChID not in (select ChID from [s-marketa2].ElitV_Kiev_test.dbo.t_saletemp where DocState = 10 and crid = 1 and StockID = 1221)
  -- and CRID = 1 and StockID = 1221

 
END






GO
