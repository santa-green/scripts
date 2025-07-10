USE [ElitV_DP_Test_Rkiper]
GO
/****** Object:  StoredProcedure [dbo].[ap_Rkiper_Imort_Sale]    Script Date: 12/01/2016 17:35:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*29.08.2016 10.22 pashkovv@const.dp.ua для ElitV_DP
--pvm0 15.11.2016 теперь курс доллара вычисляется автоматически
-- gdn1- 01-12-2016 добавил разделение по складам и разделение по кассам на 1314 и 1315 
--pvm0 01-12-2016 добавил запись кода налога с поля SessionDishes00.iTaxDishType в поле t_sale_R.TaxDocID
--pvm0 02-12-2016 изменил процедуру импорта  с t_sale_R в t_sale 
*/

/*
select * from t_sale_R where Docid  =105235
select * from t_sale where Docid  =105235
select * from t_SaleD where ChID  =100337754
*/

ALTER PROC [dbo].[ap_Rkiper_Imort_Sale] 
AS
declare @impotdate datetime , @Idate datetime

--set @Idate = '20160820'
--select @Idate

set @impotdate = GETDATE ()
insert [s-marketa].ElitV_DP_Test_Rkiper.dbo.t_sale_R
SELECT 	
  1 ChID,
  PrintChecks00."CHECKNUM" AS Docid, 
  CAST (PrintChecks00."CLOSEDATETIME" as DATE) AS Docdate,
  CURRENCIES00."NAME" as 'ЧП или Нет ',
  dbo.zf_GetRateCC(840) AS KursMC, --pvm0 15.11.2016 теперь курс доллара вычисляется автоматически
  CASE WHEN (CLASSIFICATORGROUPS0001.NAME = 'Кухня') THEN 12  ELSE 9 END OurID,
  CASE WHEN (TABLES00."code" IN(266,287,288)) THEN 1314 WHEN( TABLES00."code" between 400 and 500) THEN 1314  WHEN ( TABLES00."code" in(180,181,182,183,258)) THEN 1314
       ELSE 1315 END  StockID,  -- Разделение по складам
  1 CompID,63 CodeID1,18 CodeID2,
  CURRENCYTYPES00."NAME" as PayFormCode,
  CASE WHEN (CURRENCYTYPES00."NAME"  ='Наличные' )THEN 89  ELSE 27 END CodeID3,
  0 CodeID4, 
  0 CodeID5,
  0 Discount,
  CLASSIFICATORGROUPS0001.NAME AS 'Касса',
  PrintChecks00."EXTFISCID" AS "EXTFISCID",
  CASE WHEN (CLASSIFICATORGROUPS0001.NAME= 'Кухня' and TABLES00."code" IN(266,287,288)  ) THEN 161  --разделение по кассам
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Кухня' and TABLES00."code" between 400 and 500 )THEN 161
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Кухня' and TABLES00."code" in(180,181,182,183,258) )THEN 161
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Бар'AND CURRENCIES00."NAME" ='ЧП' and TABLES00."code" IN(266,287,288) ) THEN 107 
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Бар'AND CURRENCIES00."NAME" ='ЧП' and TABLES00."code" between 400 and 500) THEN 107   
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Бар'AND CURRENCIES00."NAME" ='ЧП' and TABLES00."code" in(180,181,182,183,258)) THEN 107
       WHEN (CLASSIFICATORGROUPS0001.NAME= 'Кухня' and TABLES00."code" not IN(266,287,288)  ) THEN 160
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Кухня' and TABLES00."code" not between 400 and 500 )THEN 160
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Кухня' and TABLES00."code" not in(180,181,182,183,258) )THEN 160
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Бар'AND CURRENCIES00."NAME" ='ЧП' and TABLES00."code" not IN(266,287,288) ) THEN 109 
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Бар'AND CURRENCIES00."NAME" ='ЧП' and TABLES00."code" not between 400 and 500) THEN 109   
       WHEN(CLASSIFICATORGROUPS0001.NAME= 'Бар'AND CURRENCIES00."NAME" ='ЧП' and TABLES00."code" not in(180,181,182,183,258)) THEN 109
       WHEN(CURRENCIES00."NAME" ='Мария' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code"  IN(266,287,288) ) THEN 154 
       WHEN(CURRENCIES00."NAME" ='Мария' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code"   between 400 and 500) THEN 154   
       WHEN(CURRENCIES00."NAME" ='Мария' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code"  in(180,181,182,183,258)) THEN 154
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар' and TABLES00."code"  IN(266,287,288) ) THEN 154 
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар' and TABLES00."code"   between 400 and 500) THEN 154   
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар' and TABLES00."code"  in(180,181,182,183,258)) THEN 154
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code"  IN(266,287,288) ) THEN 154 
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code"   between 400 and 500) THEN 154   
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code"  in(180,181,182,183,258)) THEN 154
       WHEN(CURRENCIES00."NAME" ='Мария' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code" NOT IN(266,287,288) ) THEN 153  -- 153 Это новый ФР для 1315  
       WHEN(CURRENCIES00."NAME" ='Мария' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code" NOT  between 400 and 500) THEN 153   
       WHEN(CURRENCIES00."NAME" ='Мария' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code" NOT in(180,181,182,183,258)) THEN 153
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар' and TABLES00."code" NOT IN(266,287,288) ) THEN 153 
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар' and TABLES00."code" NOT  between 400 and 500) THEN 153  
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар' and TABLES00."code" NOT in(180,181,182,183,258)) THEN 153
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code" NOT IN(266,287,288) ) THEN 153 
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code"  NOT between 400 and 500) THEN 153   
       WHEN(CURRENCIES00."NAME" ='VISA' AND CLASSIFICATORGROUPS0001.NAME ='Бар.' and TABLES00."code" NOT in(180,181,182,183,258)) THEN 153
         END CRID, 
       /*CASE WHEN (CLASSIFICATORGROUPS0001.NAME= 'Кухня') THEN 160 WHEN(CLASSIFICATORGROUPS0001.NAME= 'Бар'AND CURRENCIES00."NAME" ='ЧП') THEN 109 ELSE 154 END CRID, */ 
  EMPLOYEES00."NAME",
  isnull (( select  OperID from [s-marketa].ElitV_DP.dbo.r_Opers where EmpID in (
   select EmpID from [s-marketa].ElitV_DP.dbo.r_Emps 
   where EmpName = EMPLOYEES00."NAME")),325) OperID,
   ''CreditID,
  OrderSessions00."PRINTAT" AS  DocCreateTime , 
  SessionDishes00.iTaxDishType TaxDocID, --pvm0 01-12-2016 добавил запись кода налога с поля SessionDishes00.iTaxDishType в поле TaxDocID 
  '19000101'TaxDocDate, '<Нет дисконтной карты>' AS DCardID,
   isnull ((select EmpID from [s-marketa].ElitV_DP.dbo.r_Emps 
   where EmpName =  EMPLOYEES00."NAME"),10487) EmpID,
   '11111'IntDocID,0 CashSumCC, 0 ChangeSumCC,
  1 CurrID, 0 TSumCC_nt,0 TTaxSum,0 TSumCC_wt,0 StateCode,
  TABLES00."code" DeskCode,
  5 Visitors,0 TPurSumCC_nt,0 TPurTaxSum,PrintChecks00.PAYFISCALSUM as TPurSumCC_wt,
    PrintChecks00."CLOSEDATETIME" AS DocTime,0 DepID,0 ClientID, 0 InDocID,
    ''ExpTime,''DeclNum,''DeclDate,0 BLineID,PrintChecks00.PAYFISCALSUM TRealSum, 0 TLevySum, 0 RemSchID ,
  MENUITEMS00."EXTCODE" AS Prodid ,
  SaleObjects00."NAME" AS 'Наименование товара',
  PayBindings."QUANTITY" AS qty,
  PayBindings."PAYSUM" AS SumCC_wt,
  PayBindings."PRICESUM" AS PURSumCC_wt,
  CLASSIFICATORGROUPS0000.NAME AS "CATEGORY",
  DishDiscounts00."EXCLUDEFROMEARNINGS" AS "EXCLUDEFROMEARNINGS",
  UNCHANGEABLEORDERTYPES00."NAME" AS "ORDERCATEGORY",
  GLOBALSHIFTS00."SHIFTNUM" AS "SHIFTNUM",
  CASHES00."NAME" AS "CLOSESTATION",
  CASHGROUPS00."NETNAME" AS "NETNAME",
  CURRENCYTYPES00."NAME" AS "CURRENCYTYPE",
  CURRENCIES00."NAME" AS "CURRENCY",
  CURRENCIES00."CODE" AS "CURRENCYCODE",
  CLASSIFICATORGROUPS0000.SORTORDER AS "SORTORDER",
  Shifts00."PRINTSHIFTNUM" AS "CASHSHIFTNUM",
  TABLES00."code" AS ' Код Стола',
  TABLES00."NAME" AS 'Стол',
  Orders00."ORDERNAME" AS "ORDERNAME",
  PaymentsExtra00."CARDNUM" AS "CARDNUM",
  trk7EnumsValues1E00.UserMName AS "OBJKIND",
  PayBindings."TAXESADDED" AS "TAXESADDED",
--  RESTAURANTS00."NAME" AS "RESTAURANTNAME",
  EMPLOYEES01."NAME" AS "DISHCREATOR",
  CurrLines00."DBKURS" AS "DBKURS",
 -- MENUITEMS01."NAME" AS "COMBODISH",
  PrintChecks00."CLOSEDATETIME" AS "CLOSEDATETIME___37",
  trk7EnumsValues3600.UserMName AS "STATUS",
  CATEGLIST00."NAME" AS "NAME1",
    EMPLOYEES00."NAME" AS 'Официант',
    0 Import,
     SessionDishes00.KDSIDENT as KDSIDENT --Добавлено новое поле в таблицу t_sale_R 
 --into dbo.t_sale_R 
FROM [s-marketa\rkiper].rk777.dbo.PAYBINDINGS

JOIN [s-marketa\rkiper].rk777.dbo.CurrLines CurrLines00
  ON (CurrLines00.Visit = PayBindings.Visit) AND (CurrLines00.MidServer = PayBindings.MidServer) AND (CurrLines00.UNI = PayBindings.CurrUNI)
JOIN [s-marketa\rkiper].rk777.dbo.PrintChecks PrintChecks00
  ON (PrintChecks00.Visit = CurrLines00.Visit) AND (PrintChecks00.MidServer = CurrLines00.MidServer) AND (PrintChecks00.UNI = CurrLines00.CheckUNI)
JOIN [s-marketa\rkiper].rk777.dbo.Orders Orders00
  ON (Orders00.Visit = PayBindings.Visit) AND (Orders00.MidServer = PayBindings.MidServer) AND (Orders00.IdentInVisit = PayBindings.OrderIdent)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.EMPLOYEES EMPLOYEES00
  ON (EMPLOYEES00.SIFR = Orders00.MainWaiter)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.SaleObjects SaleObjects00
  ON (SaleObjects00.Visit = PayBindings.Visit) AND (SaleObjects00.MidServer = PayBindings.MidServer) AND (SaleObjects00.DishUNI = PayBindings.DishUNI) AND (SaleObjects00.ChargeUNI = PayBindings.ChargeUNI)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.SessionDishes SessionDishes00
  ON (SessionDishes00.Visit = SaleObjects00.Visit) AND (SessionDishes00.MidServer = SaleObjects00.MidServer) AND (SessionDishes00.UNI = SaleObjects00.DishUNI)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.MENUITEMS MENUITEMS00
  ON (MENUITEMS00.SIFR = SessionDishes00.Sifr)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.DISHGROUPS DISHGROUPS0000
  ON (DISHGROUPS0000.CHILD = MENUITEMS00.SIFR) AND (DISHGROUPS0000.CLASSIFICATION = 512)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.CLASSIFICATORGROUPS CLASSIFICATORGROUPS0000
  ON CLASSIFICATORGROUPS0000.SIFR * 256 + CLASSIFICATORGROUPS0000.NumInGroup = DISHGROUPS0000.PARENT  
LEFT JOIN [s-marketa\rkiper].rk777.dbo.DishDiscounts DishDiscounts00
  ON (DishDiscounts00.Visit = SaleObjects00.Visit) AND (DishDiscounts00.MidServer = SaleObjects00.MidServer) AND (DishDiscounts00.UNI = SaleObjects00.ChargeUNI)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.UNCHANGEABLEORDERTYPES UNCHANGEABLEORDERTYPES00
  ON (UNCHANGEABLEORDERTYPES00.SIFR = Orders00.UOT)
JOIN [s-marketa\rkiper].rk777.dbo.GLOBALSHIFTS GLOBALSHIFTS00
  ON (GLOBALSHIFTS00.MidServer = Orders00.MidServer) AND (GLOBALSHIFTS00.ShiftNum = Orders00.iCommonShift)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.OrderSessions OrderSessions00
  ON (OrderSessions00.Visit = SaleObjects00.Visit) AND (OrderSessions00.MidServer = SaleObjects00.MidServer) AND (OrderSessions00.UNI = SaleObjects00.SessionUNI)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.CASHES CASHES00
  ON (CASHES00.SIFR = PrintChecks00.iCloseStation)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.CASHGROUPS CASHGROUPS00
  ON (CASHGROUPS00.SIFR = PayBindings.Midserver)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.CURRENCYTYPES CURRENCYTYPES00
  ON (CURRENCYTYPES00.SIFR = CurrLines00.iHighLevelType)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.CURRENCIES CURRENCIES00
  ON (CURRENCIES00.SIFR = CurrLines00.Sifr)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.Shifts Shifts00
  ON (Shifts00.MidServer = PrintChecks00.MidServer) AND (Shifts00.iStation = PrintChecks00.iCloseStation) AND (Shifts00.ShiftNum = PrintChecks00.iShift)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.TABLES TABLES00
  ON (TABLES00.SIFR = Orders00.TableID)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.PaymentsExtra PaymentsExtra00
  ON (PaymentsExtra00.Visit = CurrLines00.Visit) AND (PaymentsExtra00.MidServer = CurrLines00.MidServer) AND (PaymentsExtra00.PayUNI = CurrLines00.PayUNIForOwnerInfo)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.trk7EnumsValues trk7EnumsValues1E00
  ON (trk7EnumsValues1E00.EnumData = SaleObjects00.OBJKIND) AND (trk7EnumsValues1E00.EnumName = 'tSaleObjectKind')
LEFT JOIN [s-marketa\rkiper].rk777.dbo.RESTAURANTS RESTAURANTS00
  ON (RESTAURANTS00.SIFR = CASHGROUPS00.Restaurant)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.EMPLOYEES EMPLOYEES01
  ON (EMPLOYEES01.SIFR = SaleObjects00.iAuthor)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.SessionDishes SessionDishes01
  ON (SessionDishes01.Visit = SessionDishes00.Visit) AND (SessionDishes01.Midserver = SessionDishes00.Midserver) AND (SessionDishes01.UNI = SessionDishes00.ComboDishUNI)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.MENUITEMS MENUITEMS01
  ON (MENUITEMS01.SIFR = SessionDishes01.Sifr)
LEFT JOIN [s-marketa\rkiper].rk777.dbo.trk7EnumsValues trk7EnumsValues3600
  ON (trk7EnumsValues3600.EnumData = GLOBALSHIFTS00.STATUS) AND (trk7EnumsValues3600.EnumName = 'TRecordStatus')
  
  LEFT JOIN [s-marketa\rkiper].rk777.dbo.DISHGROUPS DISHGROUPS0001
  ON (DISHGROUPS0001.CHILD = MENUITEMS00.SIFR) AND (DISHGROUPS0001.CLASSIFICATION = 768)

LEFT JOIN [s-marketa\rkiper].rk777.dbo.CATEGLIST CATEGLIST00
  ON (CATEGLIST00.SIFR = MENUITEMS00.PARENT)
  LEFT JOIN [s-marketa\rkiper].rk777.dbo.CLASSIFICATORGROUPS CLASSIFICATORGROUPS0001
  ON CLASSIFICATORGROUPS0001.SIFR * 256 + CLASSIFICATORGROUPS0001.NumInGroup = DISHGROUPS0001.PARENT  
WHERE
  ((PrintChecks00."STATE" = 6))
  AND ((GLOBALSHIFTS00.STATUS = 3))
  and PRINTAT < @impotdate 
  and CHECKNUM not in (select docid from t_sale_R)
  -- and CHECKNUM IN  (129008) --**************************************************************************************
  and CHECKNUM >130178
  order by CHECKNUM
  

/*Курсор импорта в продажу*/

declare @docid int  , @chid int , @SrcPosID int , @prodid int , @crid int ,@DocTime datetime , 
				@KDSIDENT int, @docid_old int, @i int , @imax int, @TaxDocID int, @PLID int, @KofAkciz money , @KofNDS money

declare sale cursor for 
	SELECT DISTINCT docid , crid  FROM t_sale_R
		WHERE  import =0 and Docid not in (select Docid from t_Sale where OurID in (9,12) and StockID in (1314,1315))--pvm0 01-12-2016 добавил в условие склад 1314 
		--and Docdate = @Idate
		--and Docid  in (129008) --****************************************************************************************
		ORDER BY docid 

OPEN sale 

/*---инфо для отладки---*/
set @i=1
--SELECT @@CURSOR_ROWS
set @imax = @@CURSOR_ROWS

set @docid_old = 0
FETCH NEXT FROM sale INTO @docid , @crid
WHILE @@FETCH_STATUS = 0
BEGIN--1 (cursor sale)
	/*---инфо для отладки---*/
	print 'Строка № '+ str(@i) + ' из' + str(@imax)
	print 'docid = '  + str(@docid) + ' crid = ' + str(@crid)
	set @i = @i + 1

		--Создать ChID новый код регистрации для таблицы 
		IF @docid <> @docid_old 
			BEGIN
				EXEC dbo.z_NewChID ' t_sale', @ChID OUTPUT ;
			END

		/*Заголовки чеков*/
		insert t_sale
			select top 1 @chid ChID,DocID,DocDate,KursMC,OurID,StockID,CompID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,Discount,''Notes, CRID,
				OperID,CreditID,DocTime,0 TaxDocID,TaxDocDate,DCardID,EmpID,IntDocID,CashSumCC,ChangeSumCC,980 CurrID,0 TSumCC_nt, 0 TTaxSum,
				0 TSumCC_wt,StateCode,DeskCode,Visitors,TPurSumCC_nt,0 TPurTaxSum, 0 TPurSumCC_wt,DocCreateTime,DepID,ClientID,InDocID,ExpTime,
				DeclNum,DeclDate,BLineID, 0 TRealSum,0  TLevySum,RemSchID
			from t_sale_R where docid = @docid and import = 0

		/*Продажа товара */
		declare saled cursor for 
			select prodid , DocTime, KDSIDENT, TaxDocID from t_sale_r where docid = @docid
			
		select @SrcPosID = 1 
		OPEN saled
		
		FETCH NEXT FROM saled INTO @prodid ,@DocTime, @KDSIDENT , @TaxDocID
		WHILE @@FETCH_STATUS = 0
		BEGIN--3
		--	@TaxDocID: 1001683 0-0 , 1000153 0-20, 1000155 5-20
		-- Коэффициент налога Акцизного сбора
		select @KofAkciz = CASE @TaxDocID  WHEN 1000153 THEN 1
																			 WHEN 1000155 THEN 1.05
																			 ELSE 1 END --1001683
		-- Коэффициент налога НДС
		select @KofNDS   = CASE @TaxDocID  WHEN 1000153 THEN 1.2
																			 WHEN 1000155 THEN 1.2
																			 ELSE 1 END	--1001683																			
										
			insert t_SaleD 
				select top 1  @chid, @SrcPosID as SrcPosID, sr.ProdID, 0 as PPID, r.UM, sr.Qty,
					round(rm.PriceMC/@KofAkciz/@KofNDS,3) as PriceCC_nt, 
					round( sr.SumCC_wt/@KofAkciz/@KofNDS,3) as SumCC_nt,
					(round((sr.SumCC_wt/sr.Qty)/@KofAkciz,2) - round(rm.PriceMC/@KofAkciz/@KofNDS,3)) as Tax,
					(round(sr.SumCC_wt /@KofAkciz,2) - round(sr.SumCC_wt/@KofAkciz/@KofNDS,3)) as TaxSum,
					round((sr.SumCC_wt/sr.Qty)/@KofAkciz,2) as PriceCC_wt,
					round(sr.SumCC_wt /@KofAkciz,2) as SumCC_wt,
					rq.BarCode, 1 as SecID,
					round((sr.PURSumCC_wt/sr.Qty)/@KofNDS,2) as PurPriceCC_nt,
					(round((sr.SumCC_wt/sr.Qty)/@KofAkciz,2) - round(rm.PriceMC/@KofAkciz/@KofNDS,3)) as PurTax,
					(sr.PURSumCC_wt/sr.Qty) as PurPriceCC_wt,
					(select top 1 PLID from r_Stocks where StockID = sr.StockID) as PLID, -- Выбор прайса по складу
					Discount, 0 as DepID, 1 as IsFiscal,
					0 as SubStockID,1 as OutQty,EmpID,DocTime as CreateTime, @DocTime as ModifyTime,
					0 as TaxTypeID, (sr.SumCC_wt/sr.Qty) as RealPrice, sr.SumCC_wt as RealSum
				from t_sale_R sr 
				join r_Prods r on sr.prodid = r.ProdID
				join r_ProdMP rm on r.ProdID = rm.ProdID and rm.PLID = (select top 1 PLID from r_Stocks where StockID = sr.StockID)-- Выбор прайса по складу
				join r_ProdMQ rq on r.ProdID = rq.ProdID and r.UM = rq.UM
				where sr.docid = @docid and sr.prodid =@prodid and sr.DocTime = @DocTime and sr.KDSIDENT = @KDSIDENT

			if @KofAkciz > 1 -- если товар акцизный
					insert t_SaleDLV
						select @chid as ChID, @SrcPosID as SrcPosID, 1 as LevyID , (RealSum-SumCC_wt)as LevySum
						from t_SaleD where ChID = @chid and SrcPosID =@SrcPosID
				
			set @SrcPosID = @SrcPosID + 1
			FETCH NEXT FROM saled INTO @prodid ,@DocTime, @KDSIDENT , @TaxDocID
		END--3
		  
		close saled
		deallocate saled
  
		update t_sale_R 
		  set import = 1 , chid = @chid
		from t_sale_R where docid = @docid 
		
		-- Оплаты
		insert t_SalePays 
			select distinct @chid ChID,
			1  as SrcPosID,
			case when (PayFormCode = 'Наличные') then 1 else 2 end as PayFormCode,
			SUM(SumCC_wt),
			'' as Notes,
			0  as POSPayID,
			'' as POSPayDocID,
			0  as POSPayRRN,
			1  as IsFiscal
			from t_sale_r where chid  = @chid
			group by ChID,PayFormCode
 
		exec t_SaleAfterClose @chid , 0, 0, '',0
  
		--Продажа товара оператором
		UPDATE m
		   SET m.TSumCC_nt = ISNULL((SELECT SUM(SumCC_nt) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),
			   m.TTaxSum = ISNULL((SELECT SUM(TaxSum) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),
			   m.TSumCC_wt = ISNULL((SELECT SUM(SumCC_wt) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),
			   m.TPurSumCC_wt = ISNULL((SELECT SUM(PurPriceCC_wt * Qty) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),         
			   m.TPurTaxSum = ISNULL((SELECT SUM(PurTax * Qty) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),  
			   m.TPurSumCC_nt = ISNULL((SELECT SUM(PurPriceCC_nt * Qty) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0)                    
		FROM t_Sale m
		WHERE m.ChID =@chid
 
	--Запись старого @docid
	set @docid_old = @docid
	print '@docid_old = ' + str(@docid_old)
	
	--получение новых @docid, @crid
	FETCH NEXT FROM sale INTO @docid, @crid
  
END--1 (cursor sale) 

close sale
deallocate sale
    

--select * from t_sale where StockID = 1315 and DocDate >= '20160613' order by DocID
--select * from t_sale where StockID = 1315 and DocDate >= '20160613' 

--select * from t_sale_r where Import = 0 order by docdate

--delete  from t_sale_r

--update t_sale_R 
--set Import = 1
--from t_sale_r where Import = 0 and docid in (select Docid from t_sale where StockID = 1315 ) 
--*/

----select * from t_sale_R where Docdate < '20160613' order by docid 

--/*==========старая версия============== 
--USE [ElitV_DP]
--GO
--/****** Object:  StoredProcedure [dbo].[ap_Rkiper_Imort_Sale]    Script Date: 08/29/2016 10:25:18 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--/*
--select * from t_sale_R where Docid  =105235
--select * from t_sale where Docid  =105235
--select * from t_SaleD where ChID  =100337754
--*/

--ALTER PROC [dbo].[ap_Rkiper_Imort_Sale] 
--AS
--declare @impotdate datetime , @Idate datetime
----set @Idate = '20160703'
----select @Idate

--set @impotdate = GETDATE ()
--insert [s-marketa].ElitV_DP.dbo.t_sale_R
--SELECT 	
--  1 ChID,
--  PrintChecks00."CHECKNUM" AS Docid, 
--  CAST (PrintChecks00."CLOSEDATETIME" as DATE) AS Docdate,
--  CURRENCIES00."NAME" as 'ЧП или Нет ',
--  26 AS KursMC,
--  CASE WHEN (CLASSIFICATORGROUPS0001.NAME = 'Кухня') THEN 12  ELSE 9 END OurID,
--  1315 StockID,1 CompID,63 CodeID1,18 CodeID2,
--  CURRENCYTYPES00."NAME" as PayFormCode,
--  CASE WHEN (CURRENCYTYPES00."NAME"  ='Наличные' )THEN 89  ELSE 27 END CodeID3,
--  0 CodeID4, 
--  0 CodeID5,
--  0 Discount,
--  CLASSIFICATORGROUPS0001.NAME AS 'Касса',
--  PrintChecks00."EXTFISCID" AS "EXTFISCID",
--  CASE WHEN (CLASSIFICATORGROUPS0001.NAME= 'Кухня') THEN 160 WHEN(CLASSIFICATORGROUPS0001.NAME= 'Бар'AND CURRENCIES00."NAME" ='ЧП') THEN 109 ELSE 154 END CRID,  
--  EMPLOYEES00."NAME",
--  isnull (( select  OperID from [s-marketa].ElitV_DP.dbo.r_Opers where EmpID in (
--   select EmpID from [s-marketa].ElitV_DP.dbo.r_Emps 
--   where EmpName = EMPLOYEES00."NAME")),325) OperID,
--   ''CreditID,
--  OrderSessions00."PRINTAT" AS  DocCreateTime , 
--  0 TaxDocID,'19000101'TaxDocDate, '<Нет дисконтной карты>' AS DCardID,
--   isnull ((select EmpID from [s-marketa].ElitV_DP.dbo.r_Emps 
--   where EmpName =  EMPLOYEES00."NAME"),10487) EmpID,
--   '11111'IntDocID,0 CashSumCC, 0 ChangeSumCC,
--  1 CurrID, 0 TSumCC_nt,0 TTaxSum,0 TSumCC_wt,0 StateCode,
--  TABLES00."code" DeskCode,
--  5 Visitors,0 TPurSumCC_nt,0 TPurTaxSum,PrintChecks00.PAYFISCALSUM as TPurSumCC_wt,
--    PrintChecks00."CLOSEDATETIME" AS DocTime,0 DepID,0 ClientID, 0 InDocID,
--    ''ExpTime,''DeclNum,''DeclDate,0 BLineID,PrintChecks00.PAYFISCALSUM TRealSum, 0 TLevySum, 0 RemSchID ,
--  MENUITEMS00."EXTCODE" AS Prodid ,
--  SaleObjects00."NAME" AS 'Наименование товара',
--  PayBindings."QUANTITY" AS qty,
--  PayBindings."PAYSUM" AS SumCC_wt,
--  PayBindings."PRICESUM" AS PURSumCC_wt,
--  CLASSIFICATORGROUPS0000.NAME AS "CATEGORY",
--  DishDiscounts00."EXCLUDEFROMEARNINGS" AS "EXCLUDEFROMEARNINGS",
--  UNCHANGEABLEORDERTYPES00."NAME" AS "ORDERCATEGORY",
--  GLOBALSHIFTS00."SHIFTNUM" AS "SHIFTNUM",
--  CASHES00."NAME" AS "CLOSESTATION",
--  CASHGROUPS00."NETNAME" AS "NETNAME",
--  CURRENCYTYPES00."NAME" AS "CURRENCYTYPE",
--  CURRENCIES00."NAME" AS "CURRENCY",
--  CURRENCIES00."CODE" AS "CURRENCYCODE",
--  CLASSIFICATORGROUPS0000.SORTORDER AS "SORTORDER",
--  Shifts00."PRINTSHIFTNUM" AS "CASHSHIFTNUM",
--  TABLES00."code" AS ' Код Стола',
--  TABLES00."NAME" AS 'Стол',
--  Orders00."ORDERNAME" AS "ORDERNAME",
--  PaymentsExtra00."CARDNUM" AS "CARDNUM",
--  trk7EnumsValues1E00.UserMName AS "OBJKIND",
--  PayBindings."TAXESADDED" AS "TAXESADDED",
----  RESTAURANTS00."NAME" AS "RESTAURANTNAME",
--  EMPLOYEES01."NAME" AS "DISHCREATOR",
--  CurrLines00."DBKURS" AS "DBKURS",
-- -- MENUITEMS01."NAME" AS "COMBODISH",
--  PrintChecks00."CLOSEDATETIME" AS "CLOSEDATETIME___37",
--  trk7EnumsValues3600.UserMName AS "STATUS",
--  CATEGLIST00."NAME" AS "NAME1",
--    EMPLOYEES00."NAME" AS 'Официант',
--    0 Import
-- --into dbo.t_sale_R 
--FROM [s-marketa\rkiper].rk777.dbo.PAYBINDINGS

--JOIN [s-marketa\rkiper].rk777.dbo.CurrLines CurrLines00
--  ON (CurrLines00.Visit = PayBindings.Visit) AND (CurrLines00.MidServer = PayBindings.MidServer) AND (CurrLines00.UNI = PayBindings.CurrUNI)
--JOIN [s-marketa\rkiper].rk777.dbo.PrintChecks PrintChecks00
--  ON (PrintChecks00.Visit = CurrLines00.Visit) AND (PrintChecks00.MidServer = CurrLines00.MidServer) AND (PrintChecks00.UNI = CurrLines00.CheckUNI)
--JOIN [s-marketa\rkiper].rk777.dbo.Orders Orders00
--  ON (Orders00.Visit = PayBindings.Visit) AND (Orders00.MidServer = PayBindings.MidServer) AND (Orders00.IdentInVisit = PayBindings.OrderIdent)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.EMPLOYEES EMPLOYEES00
--  ON (EMPLOYEES00.SIFR = Orders00.MainWaiter)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.SaleObjects SaleObjects00
--  ON (SaleObjects00.Visit = PayBindings.Visit) AND (SaleObjects00.MidServer = PayBindings.MidServer) AND (SaleObjects00.DishUNI = PayBindings.DishUNI) AND (SaleObjects00.ChargeUNI = PayBindings.ChargeUNI)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.SessionDishes SessionDishes00
--  ON (SessionDishes00.Visit = SaleObjects00.Visit) AND (SessionDishes00.MidServer = SaleObjects00.MidServer) AND (SessionDishes00.UNI = SaleObjects00.DishUNI)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.MENUITEMS MENUITEMS00
--  ON (MENUITEMS00.SIFR = SessionDishes00.Sifr)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.DISHGROUPS DISHGROUPS0000
--  ON (DISHGROUPS0000.CHILD = MENUITEMS00.SIFR) AND (DISHGROUPS0000.CLASSIFICATION = 512)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CLASSIFICATORGROUPS CLASSIFICATORGROUPS0000
--  ON CLASSIFICATORGROUPS0000.SIFR * 256 + CLASSIFICATORGROUPS0000.NumInGroup = DISHGROUPS0000.PARENT  
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.DishDiscounts DishDiscounts00
--  ON (DishDiscounts00.Visit = SaleObjects00.Visit) AND (DishDiscounts00.MidServer = SaleObjects00.MidServer) AND (DishDiscounts00.UNI = SaleObjects00.ChargeUNI)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.UNCHANGEABLEORDERTYPES UNCHANGEABLEORDERTYPES00
--  ON (UNCHANGEABLEORDERTYPES00.SIFR = Orders00.UOT)
--JOIN [s-marketa\rkiper].rk777.dbo.GLOBALSHIFTS GLOBALSHIFTS00
--  ON (GLOBALSHIFTS00.MidServer = Orders00.MidServer) AND (GLOBALSHIFTS00.ShiftNum = Orders00.iCommonShift)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.OrderSessions OrderSessions00
--  ON (OrderSessions00.Visit = SaleObjects00.Visit) AND (OrderSessions00.MidServer = SaleObjects00.MidServer) AND (OrderSessions00.UNI = SaleObjects00.SessionUNI)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CASHES CASHES00
--  ON (CASHES00.SIFR = PrintChecks00.iCloseStation)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CASHGROUPS CASHGROUPS00
--  ON (CASHGROUPS00.SIFR = PayBindings.Midserver)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CURRENCYTYPES CURRENCYTYPES00
--  ON (CURRENCYTYPES00.SIFR = CurrLines00.iHighLevelType)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CURRENCIES CURRENCIES00
--  ON (CURRENCIES00.SIFR = CurrLines00.Sifr)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.Shifts Shifts00
--  ON (Shifts00.MidServer = PrintChecks00.MidServer) AND (Shifts00.iStation = PrintChecks00.iCloseStation) AND (Shifts00.ShiftNum = PrintChecks00.iShift)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.TABLES TABLES00
--  ON (TABLES00.SIFR = Orders00.TableID)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.PaymentsExtra PaymentsExtra00
--  ON (PaymentsExtra00.Visit = CurrLines00.Visit) AND (PaymentsExtra00.MidServer = CurrLines00.MidServer) AND (PaymentsExtra00.PayUNI = CurrLines00.PayUNIForOwnerInfo)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.trk7EnumsValues trk7EnumsValues1E00
--  ON (trk7EnumsValues1E00.EnumData = SaleObjects00.OBJKIND) AND (trk7EnumsValues1E00.EnumName = 'tSaleObjectKind')
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.RESTAURANTS RESTAURANTS00
--  ON (RESTAURANTS00.SIFR = CASHGROUPS00.Restaurant)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.EMPLOYEES EMPLOYEES01
--  ON (EMPLOYEES01.SIFR = SaleObjects00.iAuthor)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.SessionDishes SessionDishes01
--  ON (SessionDishes01.Visit = SessionDishes00.Visit) AND (SessionDishes01.Midserver = SessionDishes00.Midserver) AND (SessionDishes01.UNI = SessionDishes00.ComboDishUNI)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.MENUITEMS MENUITEMS01
--  ON (MENUITEMS01.SIFR = SessionDishes01.Sifr)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.trk7EnumsValues trk7EnumsValues3600
--  ON (trk7EnumsValues3600.EnumData = GLOBALSHIFTS00.STATUS) AND (trk7EnumsValues3600.EnumName = 'TRecordStatus')
  
--  LEFT JOIN [s-marketa\rkiper].rk777.dbo.DISHGROUPS DISHGROUPS0001
--  ON (DISHGROUPS0001.CHILD = MENUITEMS00.SIFR) AND (DISHGROUPS0001.CLASSIFICATION = 768)

--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CATEGLIST CATEGLIST00
--  ON (CATEGLIST00.SIFR = MENUITEMS00.PARENT)
--  LEFT JOIN [s-marketa\rkiper].rk777.dbo.CLASSIFICATORGROUPS CLASSIFICATORGROUPS0001
--  ON CLASSIFICATORGROUPS0001.SIFR * 256 + CLASSIFICATORGROUPS0001.NumInGroup = DISHGROUPS0001.PARENT  
--WHERE
--  ((PrintChecks00."STATE" = 6))
--  AND ((GLOBALSHIFTS00.STATUS = 3))
--  and PRINTAT < @impotdate 
--  and CHECKNUM not in (select docid from t_sale_R)
--  -- and CHECKNUM IN  (101128)
--  and CHECKNUM >=114021
--  order by CHECKNUM
  

--/*Курсор импорта в продажу*/

--declare @docid int  , @chid int , @SrcPosID int , @prodid int , @crid int ,@DocTime datetime 
--declare sale cursor for 

--  SELECT DISTINCT docid , crid  FROM t_sale_R
--   WHERE  import =0 and Docid not in (select Docid from t_Sale where OurID in (9,12) and StockID = 1315) 
--  -- and Docdate = @Idate
--   --and Docid not in ()
--   ORDER BY docid 
--  OPEN sale 

--  FETCH NEXT FROM sale INTO @docid , @crid
--  WHILE @@FETCH_STATUS = 0
--  BEGIN
--    IF @crid = 160 
--  begin
  
  
-- EXEC dbo.z_NewChID ' t_sale', @ChID OUTPUT
-- print @docid
-- print @chid  
-- print @crid  

--  /*Заголовки чеков*/
--  insert t_sale
--  select top 1 @chid ChID,DocID,DocDate,KursMC,OurID,StockID,CompID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,Discount,''Notes,
--   CRID,
--  OperID,CreditID,DocTime,TaxDocID,TaxDocDate,DCardID,EmpID,IntDocID,CashSumCC,ChangeSumCC,980 CurrID,0 TSumCC_nt, 0 TTaxSum,
--  0 TSumCC_wt,StateCode,DeskCode,Visitors,TPurSumCC_nt,0 TPurTaxSum, 0 TPurSumCC_wt,DocCreateTime,DepID,ClientID,InDocID,ExpTime,
--  DeclNum,DeclDate,BLineID, 0 TRealSum,0  TLevySum,RemSchID
--  from t_sale_R where docid = @docid and import = 0
  
--  /*Продажа товара */
--  declare saled cursor for 
--select prodid , DocTime from t_sale_r where docid = @docid 
--  select @SrcPosID = 1 
--  OPEN saled
--  FETCH NEXT FROM saled INTO @prodid ,@DocTime
--  WHILE @@FETCH_STATUS = 0
--  BEGIN
--  insert t_SaleD 
--select top 1  @chid, @SrcPosID SrcPosID,sr.ProdID,0 PPID,r.UM,sr.Qty,rm.PriceMC as PriceCC_nt, sr.SumCC_wt  as SumCC_nt,0 Tax,0 TaxSum,
-- (sr.SumCC_wt/sr.Qty) PriceCC_wt,sr.SumCC_wt  as SumCC_wt,rq.BarCode,1 SecID,(sr.PURSumCC_wt/sr.Qty) as PurPriceCC_nt,
--  0 PurTax, (sr.PURSumCC_wt/sr.Qty) as PurPriceCC_wt,77 PLID,Discount,0 DepID,1 IsFiscal,
--0 SubStockID,1 OutQty,EmpID,DocTime as CreateTime, @DocTime as ModifyTime,
--0 TaxTypeID,(sr.SumCC_wt/sr.Qty) as RealPrice,sr.SumCC_wt as RealSum
--from t_sale_R sr 
--join r_Prods r on sr.prodid = r.ProdID
--join r_ProdMP rm on r.ProdID = rm.ProdID and rm.PLID = 77 
--join r_ProdMQ rq on r.ProdID = rq.ProdID and r.UM = rq.UM
--where sr.docid = @docid and sr.prodid =@prodid and sr.DocTime = @DocTime
--  set @SrcPosID = @SrcPosID +1
--  FETCH NEXT FROM saled INTO @prodid ,@DocTime
-- END
  
--  close saled
--  deallocate saled
  
--  update t_sale_R 
--  set import = 1 , chid = @chid
--  from t_sale_R where docid = @docid 
---- Оплаты
--  insert t_SalePays 
--  select distinct @chid ChID,
--  1 SrcPosID,
--  case when (PayFormCode = 'Наличные') then 1 else 2 end PayFormCode,
--  SUM (SumCC_wt),
--  ''Notes,
--  0 POSPayID,
--  ''POSPayDocID,
--  0 POSPayRRN,
--  1 IsFiscal
--  from t_sale_r where chid  =@chid
--  group by ChID,PayFormCode
 
--  exec t_SaleAfterClose @chid , 0, 0, '',0
  
--  --Продажа товара оператором
--  UPDATE m
--     SET m.TSumCC_nt = ISNULL((SELECT SUM(SumCC_nt) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),
--         m.TTaxSum = ISNULL((SELECT SUM(TaxSum) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),
--         m.TSumCC_wt = ISNULL((SELECT SUM(SumCC_wt) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),
--         m.TPurSumCC_wt = ISNULL((SELECT SUM(PurPriceCC_wt * Qty) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),         
--         m.TPurTaxSum = ISNULL((SELECT SUM(PurTax * Qty) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),  
--         m.TPurSumCC_nt = ISNULL((SELECT SUM(PurPriceCC_nt * Qty) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0)                    
--    FROM t_Sale m
--   WHERE m.ChID =@chid
 
--   end
--else 
--begin 
--print @docid
--print @crid


-- EXEC dbo.z_NewChID ' t_sale', @ChID OUTPUT
-- print @docid
-- print @chid  
-- print @crid  

--  /*Заголовки чеков ВВ*/
--  insert t_sale
--  select top 1 @chid ChID,DocID,DocDate,KursMC,OurID,StockID,CompID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,Discount,''Notes,
--   CRID,
--  OperID,CreditID,DocTime,TaxDocID,TaxDocDate,DCardID,EmpID,IntDocID,CashSumCC,ChangeSumCC,980 CurrID,0 TSumCC_nt, 0 TTaxSum,
--  0 TSumCC_wt,StateCode,DeskCode,Visitors,TPurSumCC_nt,0 TPurTaxSum, 0 TPurSumCC_wt,DocCreateTime,DepID,ClientID,InDocID,ExpTime,
--  DeclNum,DeclDate,BLineID, 0 TRealSum,0  TLevySum,RemSchID
--  from t_sale_R where docid = @docid and import = 0
  
--  /*Продажа товара */
--  declare saled cursor for 
--select prodid ,DocTime from t_sale_r where docid = @docid
--  select @SrcPosID = 1 
--  OPEN saled
--  FETCH NEXT FROM saled INTO @prodid ,@DocTime
--  WHILE @@FETCH_STATUS = 0
--  BEGIN
--  insert t_SaleD 
--select top 1  @chid, @SrcPosID SrcPosID,sr.ProdID,0 PPID,r.UM,sr.Qty,round (rm.PriceMC/1.05/1.2,3) as PriceCC_nt, round ( sr.SumCC_wt/1.05/1.2,3)  as SumCC_nt,
--0 Tax,0 TaxSum,
-- round ((sr.SumCC_wt/sr.Qty) /1.05,2) PriceCC_wt,round (sr.SumCC_wt /1.05 ,2) as SumCC_wt,rq.BarCode,1 SecID,round ((sr.PURSumCC_wt/sr.Qty)/1.2,2) as PurPriceCC_nt,
--  0 PurTax, (sr.PURSumCC_wt/sr.Qty) as PurPriceCC_wt,77 PLID,Discount,0 DepID,1 IsFiscal,
--0 SubStockID,1 OutQty,EmpID,DocTime as CreateTime, @DocTime as ModifyTime,
--0 TaxTypeID,(sr.SumCC_wt/sr.Qty) as RealPrice,sr.SumCC_wt as RealSum
--from t_sale_R sr 
--join r_Prods r on sr.prodid = r.ProdID
--join r_ProdMP rm on r.ProdID = rm.ProdID and rm.PLID = 77 
--join r_ProdMQ rq on r.ProdID = rq.ProdID and r.UM = rq.UM
--where sr.docid = @docid and sr.prodid =@prodid and sr.DocTime = @DocTime



--update t_SaleD 
--set Tax = (PriceCC_wt-PriceCC_nt ), TaxSum = (SumCC_wt-SumCC_nt), PurTax =(PriceCC_wt-PriceCC_nt )
--from t_saled where ChID = @chid and ProdID = @prodid

--insert t_SaleDLV
--select @chid as ChID, @SrcPosID as SrcPosID, 1 as LevyID , (RealSum-SumCC_wt)as LevySum
--from t_SaleD where ChID = @chid and SrcPosID =@SrcPosID


--  set @SrcPosID = @SrcPosID +1
--  FETCH NEXT FROM saled INTO @prodid ,@DocTime
-- END
  
--  close saled
--  deallocate saled
  
--  update t_sale_R 
--  set import = 1 , chid = @chid
--  from t_sale_R where docid = @docid 
---- Оплаты
--  insert t_SalePays 
--  select distinct @chid ChID,
--  case when (PayFormCode = 'Наличные') then 1 else 2 end  SrcPosID,
--  case when (PayFormCode = 'Наличные') then 1 else 2 end PayFormCode,
--  SUM (SumCC_wt),
--  ''Notes,
--  0 POSPayID,
--  ''POSPayDocID,
--  0 POSPayRRN,
--  1 IsFiscal
--  from t_sale_r where chid  =@chid
--  group by ChID,PayFormCode
 
--  exec t_SaleAfterClose @chid , 0, 0, '',0
  
--  --Продажа товара оператором
--  UPDATE m
--     SET m.TSumCC_nt = ISNULL((SELECT SUM(SumCC_nt) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),
--         m.TTaxSum = ISNULL((SELECT SUM(TaxSum) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),
--         m.TSumCC_wt = ISNULL((SELECT SUM(SumCC_wt) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),
--         m.TPurSumCC_wt = ISNULL((SELECT SUM(PurPriceCC_wt * Qty) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),         
--         m.TPurTaxSum = ISNULL((SELECT SUM(PurTax * Qty) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0),  
--         m.TPurSumCC_nt = ISNULL((SELECT SUM(PurPriceCC_nt * Qty) FROM t_SaleD WITH(NOLOCK) WHERE ChID = m.ChID),0)                    
--    FROM t_Sale m
--   WHERE m.ChID =@chid



--  end
--  FETCH NEXT FROM sale INTO @docid, @crid
--   print @docid
-- print @chid 



  
--  END 
  
--  close sale
--  deallocate sale
    
--/*
--select * from t_sale where StockID = 1315 and DocDate >= '20160613' order by DocID
--select * from t_sale where StockID = 1315 and DocDate >= '20160613' 

--select * from t_sale_r where Import = 0 order by docdate

--delete  from t_sale_r

--update t_sale_R 
--set Import = 1
--from t_sale_r where Import = 0 and docid in (select Docid from t_sale where StockID = 1315 ) 
--*/

----select * from t_sale_R where Docdate < '20160613' order by docid 

--

GO
