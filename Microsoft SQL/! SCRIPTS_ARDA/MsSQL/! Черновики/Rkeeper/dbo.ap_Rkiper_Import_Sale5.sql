USE [ElitR]
GO
/****** Object:  StoredProcedure [dbo].[ap_Rkiper_Import_Sale]    Script Date: 09.02.2021 10:02:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
--29.08.2016 10.22 pashkovv@const.dp.ua для ElitV_DP
--pvm0 15.11.2016 теперь курс доллара вычисляется автоматически
--gdn1- 01-12-2016 добавил разделение по складам и разделение по кассам на 1314 и 1315 
--pvm0 01-12-2016 добавил запись кода налога с поля SessionDishes00.iTaxDishType в поле t_Sale_R.TaxDocID
--pvm0 02-12-2016 изменил импорт в продажу
--gdn1 9.02.2017  разделение на склад 1202 и разделение на кассы 104,106,108
--[CHANGED] moa0 27.03.2019 16:57 внес изменения для работы с базой данных версии 3.16
--[ADDED] moa0 25.06.2019 15:09 добавил установку признака 3
--[CHANGED] Maslov Oleg '2020-03-05 17:10:31.315' В связи с перездом на новый сервер, переносим процедуры для получения продаж по RKeeper на S-SQL-D4.
--[CHANGED] Pashkovv '2020-03-17 10:54:10.576' заменил s-marketa на [S-VINTAGE].ElitRTS501
--[CHANGED] Pashkovv '2020-11-12 12:20:47.993' добавил что устранить выборку одного вехнего товара в тех случаях когда есть касса одна а валюты разные по заявке #2254 2020-10-13_sales.xlsx
*/

/*
select * from t_Sale_R where Docid = 105235
select * from t_Sale where Docid = 105235
select * from t_SaleD where ChID = 100337754

BEGIN TRAN
    EXEC ap_Rkiper_Import_Sale
    SELECT * FROM t_Sale WHERE ChID BETWEEN 1800000000 AND 1899999999
    SELECT * FROM t_MonRec WHERE ChID BETWEEN 1800000000 AND 1899999999
ROLLBACK TRAN;
*/
ALTER PROCEDURE [dbo].[ap_Rkiper_Import_Sale] 
AS
BEGIN

DECLARE @ImportDate DATETIME--, @Idate DATETIME

IF 2=2
BEGIN
	IF OBJECT_ID (N'tempdb..#CHECKNUM', N'U') IS NOT NULL DROP TABLE #CHECKNUM
	IF OBJECT_ID (N'tempdb..#Imported', N'U') IS NOT NULL DROP TABLE #Imported
	
	SELECT DISTINCT Docid
	 INTO #Imported 
	FROM t_Sale_R --t_Sale_R Здесь, по идее, хранятся продажи RKeeper (промежуточная таблица между кипером и ElitR).

	--SELECT Docid FROM #Imported
	
	--Берем все новые чеки из кипера (с учетом фильтра) и инсертим в #CHECKNUM.
    SELECT DISTINCT CHECKNUM 
	 INTO #CHECKNUM
	FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks pc 
	WHERE 1 = 1 
        and CHECKNUM between  130178 and 1000000
        and CHECKNUM not in (462495,462496,810647,146819,148106,148772,149973,156400,157738,159011,159862,159949,456666,457035,457039,458019,458954,458955,460809,460811,462273,462281,462282,805260,805573,807308,807309)
        and CHECKNUM not in (SELECT Docid FROM #Imported) --здесь исключаем уже залитые в t_Sale_R.
        and pc.[STATE] = 6

SELECT * FROM #CHECKNUM
END;

--set @Idate = '20160820'
--select @Idate

SET @ImportDate = GETDATE()

INSERT t_Sale_R
SELECT 	
  1 'ChID',
  PrintChecks00."CHECKNUM" 'Docid', 
  CAST(PrintChecks00."CLOSEDATETIME" as DATE) 'Docdate',
  CURRENCIES00."NAME" 'ЧП или Нет',
  dbo.zf_GetRateCC(840) 'KursMC', --pvm0 15.11.2016 теперь курс доллара вычисляется автоматически /*zf_GetRateCC Возвращает курс валюты страны для указанного кода валюты*/
  
  --Разделение по складам
  CASE WHEN (CLASSIFICATORGROUPS0001.[NAME] = 'Кухня') THEN 12 ELSE 6 END 'OurID', --12 - Куриленко Светлана Николаевна ФЛП, 6 - МаркетВин.
  CASE WHEN (PrintChecks00."CHECKNUM" BETWEEN 450000 and 800150) THEN 1314 --Коктейль - Бар "Винтаж", прайс 76 Балоньез.
       WHEN (PrintChecks00."CHECKNUM" BETWEEN 135000 and 499999) THEN 1315 --Летняя площадка Бар-а-Вин, прайс 77 Летка.
       WHEN (PrintChecks00."CHECKNUM" BETWEEN 800153 and 1000000) THEN 1202 --Кафе Винтаж  (ТРЦ Каскад Плаза) Днепр, прайс 71 Ресторан. 
       END 'StockID',
  
  1 'CompID', 63 'CodeID1', 18 'CodeID2',
  CURRENCYTYPES00."NAME" 'PayFormCode',
  CASE WHEN (CURRENCYTYPES00."NAME"  = 'Наличные') THEN 89 ELSE 27 END 'CodeID3',
  0 'CodeID4', 
  0 'CodeID5',
  0 'Discount',
  CLASSIFICATORGROUPS0001.[NAME] 'Касса',
  PrintChecks00."EXTFISCID" 'EXTFISCI',
  
  --разделение по кассам:                                           
  CASE WHEN (CLASSIFICATORGROUPS0001.[NAME] = 'Кухня' and PrintChecks00."CHECKNUM" BETWEEN 450000 and 800150) THEN 161 
       WHEN(CLASSIFICATORGROUPS0001.[NAME]= 'Кухня' and PrintChecks00."CHECKNUM" BETWEEN 135000 and 499999) THEN 160
       WHEN(CLASSIFICATORGROUPS0001.[NAME]= 'Кухня' and PrintChecks00."CHECKNUM" BETWEEN 800153 and 1000000) THEN 108
       WHEN(CLASSIFICATORGROUPS0001.[NAME]= 'Бар' AND CURRENCIES00."NAME" ='ЧП' and PrintChecks00."CHECKNUM" BETWEEN 450000 and 800150) THEN 107 
       --WHEN(CLASSIFICATORGROUPS0001.[NAME]= 'Бар.'AND CURRENCIES00."NAME" ='ЧП' and PrintChecks00."CHECKNUM" BETWEEN 450000 and 800150 ) THEN 107 
       WHEN(CLASSIFICATORGROUPS0001.[NAME]= 'Бар' AND CURRENCIES00."NAME" ='ЧП' and PrintChecks00."CHECKNUM" BETWEEN 135000 and 499999) THEN 109   
       WHEN(CLASSIFICATORGROUPS0001.[NAME]= 'Бар' AND CURRENCIES00."NAME" ='ЧП' and PrintChecks00."CHECKNUM" BETWEEN 800153 and 1000000) THEN 106
       WHEN(CURRENCIES00."NAME" = 'Мария' AND CLASSIFICATORGROUPS0001.[NAME] = 'Бар.' and PrintChecks00."CHECKNUM" BETWEEN 450000 and 800150) THEN 154 
       WHEN(CURRENCIES00."NAME" = 'Мария' AND CLASSIFICATORGROUPS0001.[NAME] = 'Бар.' and  PrintChecks00."CHECKNUM" BETWEEN 135000 and 499999) THEN 153   
       WHEN(CURRENCIES00."NAME" = 'Мария' AND CLASSIFICATORGROUPS0001.[NAME] = 'Бар.' and PrintChecks00."CHECKNUM" BETWEEN 800153 and 1000000) THEN 104
       WHEN(CURRENCIES00."NAME" = 'VISA' AND CLASSIFICATORGROUPS0001.[NAME] = 'Бар' and PrintChecks00."CHECKNUM" BETWEEN 450000 and 800150) THEN 154
       WHEN(CURRENCIES00."NAME" = 'VISA' AND CLASSIFICATORGROUPS0001.[NAME] = 'Бар' and PrintChecks00."CHECKNUM" BETWEEN 135000 and 499999) THEN 153   
       WHEN(CURRENCIES00."NAME" = 'VISA' AND CLASSIFICATORGROUPS0001.[NAME] = 'Бар' and PrintChecks00."CHECKNUM" BETWEEN 800153 and 1000000) THEN 104
       WHEN(CURRENCIES00."NAME" = 'VISA' AND CLASSIFICATORGROUPS0001.[NAME] = 'Бар.' and PrintChecks00."CHECKNUM" BETWEEN 450000 and 800150) THEN 154 
       WHEN(CURRENCIES00."NAME" = 'VISA' AND CLASSIFICATORGROUPS0001.[NAME] = 'Бар.' and PrintChecks00."CHECKNUM" BETWEEN 135000 and 499999) THEN 153    
       WHEN(CURRENCIES00."NAME" = 'VISA' AND CLASSIFICATORGROUPS0001.[NAME] = 'Бар.' and PrintChecks00."CHECKNUM" BETWEEN 800153 and 1000000) THEN 104
       WHEN(CURRENCIES00."NAME" = 'Мария' AND CLASSIFICATORGROUPS0001.[NAME] ='Бар' and PrintChecks00."CHECKNUM" BETWEEN 450000 and 800150) THEN 107
       WHEN(CURRENCIES00."NAME" = 'Мария' AND CLASSIFICATORGROUPS0001.[NAME] ='Бар' and PrintChecks00."CHECKNUM" BETWEEN 135000 and 499999) THEN 109  
       WHEN(CURRENCIES00."NAME" = 'Мария' AND CLASSIFICATORGROUPS0001.[NAME] ='Бар' and PrintChecks00."CHECKNUM" BETWEEN 800153 and 1000000) THEN 106
       END 'CRID', 
       /*CASE WHEN (CLASSIFICATORGROUPS0001.NAME= 'Кухня') THEN 160 WHEN(CLASSIFICATORGROUPS0001.NAME= 'Бар'AND CURRENCIES00."NAME" ='ЧП') THEN 109 ELSE 154 END CRID, */ 
  EMPLOYEES00."NAME",

  ISNULL (( select  OperID from [S-VINTAGE].ElitRTS501.dbo.r_Opers where EmpID in ( --r_Opers Справочник ЭККА: операторы
   select EmpID from [S-VINTAGE].ElitRTS501.dbo.r_Emps --r_Emps	Справочник служащих
   where EmpName = EMPLOYEES00."NAME")),325) 'OperID',

   '' 'CreditID',
  OrderSessions00."PRINTAT" 'DocCreateTime', 
  SessionDishes00.iTaxDishType 'TaxDocID', --pvm0 01-12-2016 добавил запись кода налога с поля SessionDishes00.iTaxDishType в поле TaxDocID 
  '19000101' 'TaxDocDate', '<Нет дисконтной карты>' 'DCardID',
   isnull ((select EmpID from [S-VINTAGE].ElitRTS501.dbo.r_Emps 
   where EmpName =  EMPLOYEES00."NAME"),10487) 'EmpID',
   '11111' 'IntDocID', 0 'CashSumCC', 0 'ChangeSumCC',
  1 'CurrID', 0 'TSumCC_nt', 0 'TTaxSum', 0 'TSumCC_wt', 0 'StateCode',
  TABLES00."code" 'DeskCode',
  5 'Visitors', 0 'TPurSumCC_nt', 0 'TPurTaxSum', PrintChecks00.PAYFISCALSUM 'TPurSumCC_wt',
    PrintChecks00."CLOSEDATETIME" 'DocTime', 0 'DepID', 0 'ClientID', 0 'InDocID',
    '' 'ExpTime', '' 'DeclNum', '' 'DeclDate', 0 'BLineID', PrintChecks00.PAYFISCALSUM 'TRealSum', 0 'TLevySum', 0 'RemSchID',
  MENUITEMS00."EXTCODE" 'Prodid',
  SaleObjects00."NAME" 'Наименование товара',
  PayBindings."QUANTITY" 'qty',
  PayBindings."PAYSUM" 'SumCC_wt',
  PayBindings."PRICESUM" 'PURSumCC_wt',
  CLASSIFICATORGROUPS0000.[NAME] 'CATEGORY',
  DishDiscounts00."EXCLUDEFROMEARNINGS" 'EXCLUDEFROMEARNINGS',
  UNCHANGEABLEORDERTYPES00."NAME" 'ORDERCATEGORY',
  GLOBALSHIFTS00."SHIFTNUM" AS "SHIFTNUM",
  CASHES00."NAME" AS "CLOSESTATION",
  CASHGROUPS00."NETNAME" 'NETNAME',
  CURRENCYTYPES00."NAME" 'CURRENCYTYPE',
  CURRENCIES00."NAME" 'CURRENCY',
  CURRENCIES00."CODE" 'CURRENCYCODE',
  CLASSIFICATORGROUPS0000.SORTORDER 'SORTORDER',
  Shifts00."PRINTSHIFTNUM" 'CASHSHIFTNUM',
  TABLES00."code" 'Код Стола',
  TABLES00."NAME" 'Стол',
  Orders00."ORDERNAME" 'ORDERNAME',
  PaymentsExtra00."CARDNUM" 'CARDNUM',
  trk7EnumsValues1E00.UserMName 'OBJKIND',
  PayBindings."TAXESADDED" 'TAXESADDED',
--  RESTAURANTS00."NAME" 'RESTAURANTNAME',
  EMPLOYEES01."NAME" 'DISHCREATOR',
  CurrLines00."DBKURS" 'DBKURS',
 -- MENUITEMS01."NAME" 'COMBODISH',
  PrintChecks00."CLOSEDATETIME" 'CLOSEDATETIME___37',
  trk7EnumsValues3600.UserMName 'STATUS',
  CATEGLIST00."NAME" 'NAME1',
  EMPLOYEES00."NAME" 'Официант',
  0 'Import',
  SessionDishes00.KDSIDENT 'KDSIDENT' --Добавлено новое поле в таблицу t_Sale_R 
 --into dbo.t_Sale_R 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*FROM [S-VINTAGE].[SQL_RK7].dbo.PAYBINDINGS*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FROM [S-VINTAGE].[SQL_RK7].dbo.PAYBINDINGS

JOIN [S-VINTAGE].[SQL_RK7].dbo.CurrLines CurrLines00 --CurrLines
  ON (CurrLines00.Visit = PayBindings.Visit) AND (CurrLines00.MidServer = PayBindings.MidServer) AND (CurrLines00.UNI = PayBindings.CurrUNI)
JOIN [S-VINTAGE].[SQL_RK7].dbo.PrintChecks PrintChecks00 --PrintChecks
  ON (PrintChecks00.Visit = CurrLines00.Visit) AND (PrintChecks00.MidServer = CurrLines00.MidServer) AND (PrintChecks00.UNI = CurrLines00.CheckUNI)
JOIN [S-VINTAGE].[SQL_RK7].dbo.Orders Orders00 --Orders
  ON (Orders00.Visit = PayBindings.Visit) AND (Orders00.MidServer = PayBindings.MidServer) AND (Orders00.IdentInVisit = PayBindings.OrderIdent)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.EMPLOYEES EMPLOYEES00 --EMPLOYEES
  ON (EMPLOYEES00.SIFR = Orders00.MainWaiter)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.SaleObjects SaleObjects00 --SaleObjects
  ON (SaleObjects00.Visit = PayBindings.Visit) AND (SaleObjects00.MidServer = PayBindings.MidServer) AND (SaleObjects00.DishUNI = PayBindings.DishUNI) AND (SaleObjects00.ChargeUNI = PayBindings.ChargeUNI)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.SessionDishes SessionDishes00 --SessionDishes
  ON (SessionDishes00.Visit = SaleObjects00.Visit) AND (SessionDishes00.MidServer = SaleObjects00.MidServer) AND (SessionDishes00.UNI = SaleObjects00.DishUNI)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.MENUITEMS MENUITEMS00 --MENUITEMS
  ON (MENUITEMS00.SIFR = SessionDishes00.Sifr)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.DISHGROUPS DISHGROUPS0000 --DISHGROUPS
  ON (DISHGROUPS0000.CHILD = MENUITEMS00.SIFR) AND (DISHGROUPS0000.CLASSIFICATION = 512)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.CLASSIFICATORGROUPS CLASSIFICATORGROUPS0000 --CLASSIFICATORGROUPS
  ON CLASSIFICATORGROUPS0000.SIFR * 256 + CLASSIFICATORGROUPS0000.NumInGroup = DISHGROUPS0000.PARENT  
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.DishDiscounts DishDiscounts00 --DishDiscounts
  ON (DishDiscounts00.Visit = SaleObjects00.Visit) AND (DishDiscounts00.MidServer = SaleObjects00.MidServer) AND (DishDiscounts00.UNI = SaleObjects00.ChargeUNI)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.UNCHANGEABLEORDERTYPES UNCHANGEABLEORDERTYPES00 --UNCHANGEABLEORDERTYPES
  ON (UNCHANGEABLEORDERTYPES00.SIFR = Orders00.UOT)
JOIN [S-VINTAGE].[SQL_RK7].dbo.GLOBALSHIFTS GLOBALSHIFTS00 --GLOBALSHIFTS
  ON (GLOBALSHIFTS00.MidServer = Orders00.MidServer) AND (GLOBALSHIFTS00.ShiftNum = Orders00.iCommonShift)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.OrderSessions OrderSessions00 --OrderSessions
  ON (OrderSessions00.Visit = SaleObjects00.Visit) AND (OrderSessions00.MidServer = SaleObjects00.MidServer) AND (OrderSessions00.UNI = SaleObjects00.SessionUNI)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.CASHES CASHES00 --CASHES (Кассовые станции)
  ON (CASHES00.SIFR = PrintChecks00.iCloseStation)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.CASHGROUPS CASHGROUPS00 --CASHGROUPS
  ON (CASHGROUPS00.SIFR = PayBindings.Midserver)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.CURRENCYTYPES CURRENCYTYPES00 --CURRENCYTYPES (типы оплат)
  ON (CURRENCYTYPES00.SIFR = CurrLines00.iHighLevelType)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.CURRENCIES CURRENCIES00 --CURRENCIES (типы валют)
  ON (CURRENCIES00.SIFR = CurrLines00.Sifr)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.Shifts Shifts00 --Shifts (Смены: открытие, закрытие..)
  ON (Shifts00.MidServer = PrintChecks00.MidServer) AND (Shifts00.iStation = PrintChecks00.iCloseStation) AND (Shifts00.ShiftNum = PrintChecks00.iShift)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.[TABLES] TABLES00 --[TABLES]
  ON (TABLES00.SIFR = Orders00.TableID)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.PaymentsExtra PaymentsExtra00 --PaymentsExtra
  ON (PaymentsExtra00.Visit = CurrLines00.Visit) AND (PaymentsExtra00.MidServer = CurrLines00.MidServer) AND (PaymentsExtra00.PayUNI = CurrLines00.PayUNIForOwnerInfo)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.trk7EnumsValues trk7EnumsValues1E00 --trk7EnumsValues
  ON (trk7EnumsValues1E00.EnumData = SaleObjects00.OBJKIND) AND (trk7EnumsValues1E00.EnumName = 'tSaleObjectKind')
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.RESTAURANTS RESTAURANTS00 --RESTAURANTS
  ON (RESTAURANTS00.SIFR = CASHGROUPS00.Restaurant)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.EMPLOYEES EMPLOYEES01 --EMPLOYEES
  ON (EMPLOYEES01.SIFR = SaleObjects00.iAuthor)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.SessionDishes SessionDishes01 --SessionDishes
  ON (SessionDishes01.Visit = SessionDishes00.Visit) AND (SessionDishes01.Midserver = SessionDishes00.Midserver) AND (SessionDishes01.UNI = SessionDishes00.ComboDishUNI)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.MENUITEMS MENUITEMS01 --MENUITEMS
  ON (MENUITEMS01.SIFR = SessionDishes01.Sifr)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.trk7EnumsValues trk7EnumsValues3600 --trk7EnumsValues
  ON (trk7EnumsValues3600.EnumData = GLOBALSHIFTS00.[STATUS]) AND (trk7EnumsValues3600.EnumName = 'TRecordStatus')
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.DISHGROUPS DISHGROUPS0001 --DISHGROUPS
  ON (DISHGROUPS0001.CHILD = MENUITEMS00.SIFR) AND (DISHGROUPS0001.CLASSIFICATION = 768)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.CATEGLIST CATEGLIST00 --CATEGLIST
  ON (CATEGLIST00.SIFR = MENUITEMS00.PARENT)
LEFT JOIN [S-VINTAGE].[SQL_RK7].dbo.CLASSIFICATORGROUPS CLASSIFICATORGROUPS0001 --CLASSIFICATORGROUPS
  ON CLASSIFICATORGROUPS0001.SIFR * 256 + CLASSIFICATORGROUPS0001.NumInGroup = DISHGROUPS0001.PARENT  

WHERE
  GLOBALSHIFTS00.[STATUS] = 3
  and PRINTAT < @ImportDate 
  and CURRENCYTYPES00."NAME"  <> 'Неплательщики'
  and CHECKNUM in (select CHECKNUM from #CHECKNUM)
 
  --((PrintChecks00."STATE" = 6))
  --AND ((GLOBALSHIFTS00.STATUS = 3))
  --and PRINTAT < @ImportDate 
  --and CHECKNUM not in (select docid from t_Sale_R)
  ---- and CHECKNUM IN  (101128)
  --and CURRENCYTYPES00."NAME"  <> 'Неплательщики'
  --and CHECKNUM  between  130178 and 1000000
  --and CHECKNUM not in (462495,462496,810647)
  order by CHECKNUM
  

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Курсор импорта в продажу*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @docid int, @chid int , @SrcPosID int , @prodid int, @crid int ,@DocTime datetime , 
		@KDSIDENT int, @docid_old int, @i int , @imax int, @TaxDocID int, @PLID int, @KofAkciz money , @KofNDS money, @CHP varchar(20),
		@ChIDStart bigint, @ChIDEnd bigint, @MRChID INT

SELECT @ChIDStart = ChID_Start, @ChIDEnd = ChID_End FROM r_DBIs WHERE DBiID = 18

declare sale cursor for 
	SELECT DISTINCT docid , crid  FROM t_Sale_R
		WHERE  import = 0 and Docid not in (select Docid from t_Sale where OurID in (6,12) and StockID in (1314,1315,1202))--pvm0 01-12-2016 добавил в условие склад 1314 
		--and Docdate = @Idate
		--and Docid  in (129008) --****************************************************************************************
		--or Docid  in (231313) 
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
				SELECT @ChID = (ISNULL(MAX(ChID), @ChIDStart - 1) + 1) FROM t_Sale WITH(XLOCK, HOLDLOCK) WHERE ChID BETWEEN @ChIDStart AND @ChIDEnd 
                    --HOLDLOCK (equivalent to SERIALIZABLE) applies only to the table or view for which it is specified and only for the duration of the transaction defined by the statement that it is used in. 
                    --XLOCK Specifies that exclusive locks are to be taken and held until the transaction completes.
			END

		/*Заголовки чеков*/
		insert t_sale
			select top 1 @chid ChID,DocID,DocDate,KursMC,OurID,StockID,CompID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,Discount,''Notes, CRID,
				OperID,CreditID,DocTime,0 TaxDocID,TaxDocDate,DCardID,EmpID,IntDocID,CashSumCC,ChangeSumCC,980 CurrID,0 TSumCC_nt, 0 TTaxSum,
				0 TSumCC_wt,StateCode,DeskCode,Visitors,TPurSumCC_nt,0 TPurTaxSum, 0 TPurSumCC_wt,DocCreateTime,DepID,ClientID,InDocID,ExpTime,
				DeclNum,DeclDate,BLineID, 0 TRealSum,0  TLevySum, RemSchID,
				0, (SELECT TOP 1 ChID FROM r_DCards rd WHERE rd.DCardID = sr.DCardID)
			from t_Sale_R sr where sr.docid = @docid and sr.import = 0

		/*Продажа товара */
		declare saled cursor for 
			select prodid , DocTime, KDSIDENT, TaxDocID, [ЧП или Нет ] as CHP from t_Sale_R where docid = @docid

			
		select @SrcPosID = 1 
		OPEN saled
		
		FETCH NEXT FROM saled INTO @prodid ,@DocTime, @KDSIDENT , @TaxDocID, @CHP
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

		if 1=0 --отладка
		BEGIN
			select 'test1'
			select  @chid as chid
			select * from t_Sale where chid = @chid
			select * from t_Sale where docid = @docid
			select prodid , DocTime, KDSIDENT, TaxDocID, [ЧП или Нет ] as CHP from t_Sale_R where docid = @docid

				select top 1  @chid as chid, @SrcPosID as SrcPosID, sr.ProdID, 0 as PPID, r.UM, sr.Qty,
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
				from t_Sale_R sr 
				join r_Prods r on sr.prodid = r.ProdID
				join r_ProdMP rm on r.ProdID = rm.ProdID and rm.PLID = (select top 1 PLID from r_Stocks where StockID = sr.StockID)-- Выбор прайса по складу
				join r_ProdMQ rq on r.ProdID = rq.ProdID and r.UM = rq.UM
				where sr.docid = @docid and sr.prodid =@prodid and sr.DocTime = @DocTime and sr.KDSIDENT = @KDSIDENT

		END
		
												
			insert t_SaleD 
				select top 1  @chid as chid, @SrcPosID as SrcPosID, sr.ProdID, 0 as PPID, r.UM, sr.Qty,
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
				from t_Sale_R sr 
				join r_Prods r on sr.prodid = r.ProdID
				join r_ProdMP rm on r.ProdID = rm.ProdID and rm.PLID = (select top 1 PLID from r_Stocks where StockID = sr.StockID)-- Выбор прайса по складу
				join r_ProdMQ rq on r.ProdID = rq.ProdID and r.UM = rq.UM
				where sr.docid = @docid and sr.prodid =@prodid and sr.DocTime = @DocTime and sr.KDSIDENT = @KDSIDENT
				and sr.[ЧП или Нет ] = @CHP --Pashkovv '2020-11-12 12:20:47.993' добавил что устранить выборку одного вехнего товара в тех случаях когда есть касса одна а валюты разные по заявке #2254 2020-10-13_sales.xlsx

			if @KofAkciz > 1 -- если товар акцизный
					insert t_SaleDLV
						select @chid as ChID, @SrcPosID as SrcPosID, 1 as LevyID , (RealSum-SumCC_wt)as LevySum
						from t_SaleD where ChID = @chid and SrcPosID =@SrcPosID
				
			set @SrcPosID = @SrcPosID + 1
			FETCH NEXT FROM saled INTO @prodid ,@DocTime, @KDSIDENT , @TaxDocID, @CHP
		END--3
		  
		close saled
		deallocate saled
  
		update t_Sale_R 
		  set import = 1 , chid = @chid
		from t_Sale_R where docid = @docid 
		
		-- Оплаты
		insert t_SalePays --t_SalePays – Здесь подробности оплаты по продаже (нал, безнал, сдача).
			select distinct @chid ChID,
			1  as SrcPosID,
			case when (PayFormCode = 'Наличные') then 1 else 2 end as PayFormCode,
			SUM(SumCC_wt),
			'' as Notes,
			0  as POSPayID,
			'' as POSPayDocID,
			0  as POSPayRRN,
			1  as IsFiscal,
			'' as ChequeText,
			0  as BServID,
			NULL as PayPartsQty,
			NULL as ContractNo,
			'' as POSPayText
			from t_Sale_R where chid  = @chid
			group by ChID,PayFormCode
 
		exec t_SaleAfterClose @chid, 0, 0, 0, '',0 --Процедура после закрытия чека
--------------------------------------------------------------------------------
--moa0 25.06.2019 15:09 добавил установку признака 3
/*
В теории можно сделать процедуру, которая будет устанавливать признаки в документе,
а потом вызывать ее в нужно месте (передавать туда ChID продажи).
*/
	  /* Установка признаков документа */
	  IF (SELECT COUNT(*) 
		  FROM t_Sale m WITH(NOLOCK)
		  JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID AND m.ChID = @ChID
		  WHERE p.Notes NOT LIKE 'Сдача') = 1
			UPDATE m
			SET m.CodeID1 = 63, 
				m.CodeID2 = 18, 
				m.CodeID3 = CASE p.PayFormCode WHEN 1 THEN (CASE WHEN m.StockID IN (1201) THEN 81 
		         												 WHEN m.StockID IN (1202,1315,1314) and  m.CRID in ( 104,153,154,159) THEN 81
		         												 WHEN m.StockID IN (1202,1315,1314) and  m.CRID in ( 105,106,108,109,160,161,107) THEN 89
		         												 --WHEN m.StockID IN (1221,1222)THEN 82
																 --WHEN m.StockID IN (1310,1314) THEN 84 
																 END)    	         
	    									   WHEN 2 THEN 27
											   WHEN 5 THEN 70 END,
			m.RemSchID = 0 
	   						       
  			FROM t_Sale m WITH(NOLOCK)
			JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID AND p.ChID = @ChID
		  ELSE
			UPDATE m
			SET m.CodeID1 = 63, m.CodeID2 = 18, m.CodeID3 = 83 
			FROM t_Sale m WITH(NOLOCK)
			WHERE m.ChID = @ChID
--------------------------------------------------------------------------------			 
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
	
	   /* Создание оплаты */
	   --EXEC dbo.apt_SaleInsertMonRec @ChID = @ChID
	   IF 1 = 1
	   BEGIN 
		  SELECT @MRChID = (ISNULL(MAX(ChID), @ChIDStart - 1) + 1) FROM t_MonRec WITH(XLOCK, HOLDLOCK) WHERE ChID BETWEEN @ChIDStart AND @ChIDEnd

		  INSERT t_MonRec --Прием наличных денег на склад
		  (ChID, OurID, AccountAC, DocDate, DocID, StockID, CompID, CompAccountAC, CurrID, KursMC, KursCC, SumAC,
		   Subject, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID)
		  SELECT
		   ROW_NUMBER() OVER (ORDER BY m.DocID, p.PayFormCode) - 1 + @MRChID ChID, OurID, '0' AccountAC, DocDate, DocID, StockID, CompID, 
		   '0' CompAccountAC, CurrID, KursMC, 1 KursCC, SUM(p.SumCC_wt) SumAC, REPLACE(p.Notes,'Сдача','') Subject, CodeID1, CodeID2, CodeID3, CASE m.StockID WHEN 704 THEN 0 ELSE m.CodeID4 END CodeID4,  CASE m.StockID WHEN 704 THEN 0 ELSE m.CodeID5 END CodeID5, EmpID
		  FROM t_Sale m WITH(NOLOCK)
		  JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID 
		  WHERE m.ChID = @ChID AND p.PayFormCode IN (1,5)
		  GROUP BY OurID, DocDate, DocID, StockID, CompID, CurrID, KursMC, REPLACE(p.Notes,'Сдача',''), CodeID1, CodeID2, PayFormCode, CodeID3, CodeID4, CodeID5, EmpID
		  HAVING SUM(p.SumCC_wt) != 0
	   END;

	   /* Установка статуса документа */
	   UPDATE t_Sale
	   SET
		 StateCode = dbo.zf_Var('t_ChequeStateCode') --zf_Var Возвращает значение переменной; t_ChequeStateCode	Статус документа после печати на ЭККА.
	   WHERE ChID = @ChID

	--получение новых @docid, @crid
	FETCH NEXT FROM sale INTO @docid, @crid
  
END--1 (cursor sale) 

close sale
deallocate sale

END

/*
--проверка на чеки в которых на одной позиции раздвоение по валютам
SELECT * FROM t_sale_r where Docid in (SELECT Docid FROM t_sale_r where Docdate >= '2020-10-13' group by  Docid ,CRID having  count(distinct [ЧП или Нет ]) > 1 ) ORDER BY 2





--пересоздать чек с ркипера в базе
if 1=1
BEGIN
	
BEGIN TRAN

DECLARE @Docid int = 231313  --231313,231246,231235,231218
SELECT * FROM t_sale_r where Docid in (@Docid)
update t_sale_r set Import = 0 where Docid in (@Docid)

SELECT * FROM t_sale where OurID in (6,12) and Docid in (@Docid)
SELECT * FROM t_saleD where chid in (SELECT chid FROM t_sale where  OurID in (6,12) and Docid in (@Docid))
SELECT * FROM t_SaleDLV where chid in (SELECT chid FROM t_sale where  OurID in (6,12) and Docid in (@Docid))
SELECT * FROM t_SalePays where chid in (SELECT chid FROM t_sale where  OurID in (6,12) and Docid in (@Docid))
SELECT * FROM t_MonRec where OurID in (6,12) and Docid in (@Docid)

delete t_sale where OurID in (6,12) and Docid in (@Docid)
delete t_MonRec where OurID in (6,12) and Docid in (@Docid)

SELECT * FROM t_sale where OurID in (6,12) and Docid in (@Docid)
SELECT * FROM t_saleD where chid in (SELECT chid FROM t_sale where  OurID in (6,12) and Docid in (@Docid))
SELECT * FROM t_SaleDLV where chid in (SELECT chid FROM t_sale where  OurID in (6,12) and Docid in (@Docid))
SELECT * FROM t_SalePays where chid in (SELECT chid FROM t_sale where  OurID in (6,12) and Docid in (@Docid))
SELECT * FROM t_MonRec where OurID in (6,12) and Docid in (@Docid)

EXEC ap_Rkiper_Import_Sale

SELECT * FROM t_sale where OurID in (6,12) and Docid in (@Docid)
SELECT * FROM t_saleD where chid in (SELECT chid FROM t_sale where  OurID in (6,12) and Docid in (@Docid))
SELECT * FROM t_SaleDLV where chid in (SELECT chid FROM t_sale where  OurID in (6,12) and Docid in (@Docid))
SELECT * FROM t_SalePays where chid in (SELECT chid FROM t_sale where  OurID in (6,12) and Docid in (@Docid))
SELECT * FROM t_MonRec where OurID in (6,12) and Docid in (@Docid)

ROLLBACK TRAN

END





--проверка синхронизации ркимера (t_sale_r) и базы (t_sale)
SELECT * FROM (
SELECT * 
,(SELECT sum(qty) FROM t_sale_r r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) Tqty_R
,(SELECT sum(SumCC_wt) FROM t_sale_r r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) TSumCC_wt_R
,(SELECT sum(qty) FROM t_saleD d with (nolock) where d.chid = (SELECT chid FROM t_sale r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) ) Tqty
,(SELECT sum(RealSum) FROM t_saleD d with (nolock) where d.chid = (SELECT chid FROM t_sale r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) ) TRealSum
,(SELECT sum(SumCC_wt) FROM t_SalePays d with (nolock) where d.chid = (SELECT chid FROM t_sale r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) ) TSalePays
,(SELECT sum(SumAC) FROM t_MonRec r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) TSumAC_MonRec
FROM 
(SELECT distinct Docid,OurID FROM t_sale_r with (nolock) where Docdate >= '2020-01-01') s1
) s2 
where Tqty_R <> Tqty or TSumCC_wt_R <> round(TRealSum , 2) or TSumCC_wt_R <> round(TSalePays , 2) or TSumCC_wt_R <> round(TSumAC_MonRec , 2)




*/


GO
