
--Выгрузка из rkeeper в промежуточную таблицу t_rkeeper_CHECKNUM_CARDCODE
INSERT  dbo.t_rkeeper_CHECKNUM_CARDCODE (CHECKNUM, CARDCODE,IMPORT)
SELECT  distinct 
  PrintChecks00."CHECKNUM" AS CHECKNUM,
  DishDiscounts00."CARDCODE" AS CARDCODE
  , 0 AS IMPORT
  --, GETDATE() AS DateTime
  --,*
  --,
  --GLOBALSHIFTS00."SHIFTDATE" AS "SHIFTDATE",  
  --DiscParts."SUM" AS "SUM",
  --EMPLOYEES00."NAME" AS "WAITER",
  --DISCOUNTS00."NAME" AS "DISCOUNT",

  --SaleObjects00."NAME" AS "DISH",
  
  --CASHGROUPS00."NETNAME" AS "NETNAME",
  --CASHES00."NAME" AS "CLOSESTATION",
  --EMPLOYEES01."NAME" AS "NAME",
  --GLOBALSHIFTS00."SHIFTNUM" AS "SHIFTNUM",
  --CURRENCYTYPES00."NAME" AS "CURRENCYTYPE",
  --CURRENCIES00."NAME" AS "CURRENCY",
  
  --trk7EnumsValues1600.UserMName AS "CHARGESOURCE",
  --RESTAURANTS00."NAME" AS "RESTAURANTNAME",
  --trk7EnumsValues1C00.UserMName AS "STATUS",
  --EMPLOYEES02."NAME" AS "MANAGER"
FROM [s-marketa\rkiper].rk777.dbo.DISCPARTS
JOIN [s-marketa\rkiper].rk777.dbo.PayBindings PayBindings00
  ON (PayBindings00.Visit = DiscParts.Visit) AND (PayBindings00.MidServer = DiscParts.MidServer) AND (PayBindings00.UNI = DiscParts.BindingUNI)
JOIN [s-marketa\rkiper].rk777.dbo.CurrLines CurrLines00
  ON (CurrLines00.Visit = PayBindings00.Visit) AND (CurrLines00.MidServer = PayBindings00.MidServer) AND (CurrLines00.UNI = PayBindings00.CurrUNI)
JOIN [s-marketa\rkiper].rk777.dbo.PrintChecks PrintChecks00
  ON (PrintChecks00.Visit = CurrLines00.Visit) AND (PrintChecks00.MidServer = CurrLines00.MidServer) AND (PrintChecks00.UNI = CurrLines00.CheckUNI)
JOIN [s-marketa\rkiper].rk777.dbo.DishDiscounts DishDiscounts00
  ON (DishDiscounts00.Visit = DiscParts.Visit) AND (DishDiscounts00.MidServer = DiscParts.MidServer) AND (DishDiscounts00.UNI = DiscParts.DiscLineUNI)
JOIN [s-marketa\rkiper].rk777.dbo.OrderSessions OrderSessions00
  ON (OrderSessions00.Visit = DishDiscounts00.Visit) AND (OrderSessions00.MidServer = DishDiscounts00.MidServer) AND (OrderSessions00.UNI = DishDiscounts00.SessionUNI)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.EMPLOYEES EMPLOYEES00
--  ON (EMPLOYEES00.SIFR = OrderSessions00.iAuthor)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.DISCOUNTS DISCOUNTS00
--  ON (DISCOUNTS00.SIFR = DishDiscounts00.Sifr)
JOIN [s-marketa\rkiper].rk777.dbo.Orders Orders00
  ON (Orders00.Visit = OrderSessions00.Visit) AND (Orders00.MidServer = OrderSessions00.MidServer) AND (Orders00.IdentInVisit = OrderSessions00.OrderIdent)
JOIN [s-marketa\rkiper].rk777.dbo.GLOBALSHIFTS GLOBALSHIFTS00
  ON (GLOBALSHIFTS00.MidServer = Orders00.MidServer) AND (GLOBALSHIFTS00.ShiftNum = Orders00.iCommonShift)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.SaleObjects SaleObjects00
--  ON (SaleObjects00.Visit = PayBindings00.Visit) AND (SaleObjects00.MidServer = PayBindings00.MidServer) AND (SaleObjects00.DishUNI = PayBindings00.DishUNI) AND (SaleObjects00.ChargeUNI = PayBindings00.ChargeUNI)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CASHGROUPS CASHGROUPS00
--  ON (CASHGROUPS00.SIFR = PayBindings00.Midserver)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CASHES CASHES00
--  ON (CASHES00.SIFR = PrintChecks00.iCloseStation)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.Orders Orders01
--  ON (Orders01.Visit = PrintChecks00.Visit) AND (Orders01.MidServer = PrintChecks00.MidServer) AND (Orders01.IdentInVisit = PrintChecks00.OrderIdent)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.EMPLOYEES EMPLOYEES01
--  ON (EMPLOYEES01.SIFR = Orders01.MainWaiter)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CURRENCYTYPES CURRENCYTYPES00
--  ON (CURRENCYTYPES00.SIFR = CurrLines00.iHighLevelType)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.CURRENCIES CURRENCIES00
--  ON (CURRENCIES00.SIFR = CurrLines00.Sifr)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.trk7EnumsValues trk7EnumsValues1600
--  ON (trk7EnumsValues1600.EnumData = DishDiscounts00.CHARGESOURCE) AND (trk7EnumsValues1600.EnumName = 'tChargeSource')
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.RESTAURANTS RESTAURANTS00
--  ON (RESTAURANTS00.SIFR = CASHGROUPS00.Restaurant)
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.trk7EnumsValues trk7EnumsValues1C00
--  ON (trk7EnumsValues1C00.EnumData = GLOBALSHIFTS00.STATUS) AND (trk7EnumsValues1C00.EnumName = 'TRecordStatus')
--LEFT JOIN [s-marketa\rkiper].rk777.dbo.EMPLOYEES EMPLOYEES02
--  ON (EMPLOYEES02.SIFR = DishDiscounts00.iAuthor)
WHERE
  ((PrintChecks00."STATE" = 6)) AND (DishDiscounts00."ISCHARGE" = 0)
  AND (DiscParts."NONZERODISC" = 1) AND ((GLOBALSHIFTS00.STATUS = 3))
  
  AND LEN(DishDiscounts00.CARDCODE) > 0
  AND GLOBALSHIFTS00."SHIFTDATE" > '2017-01-01'
  AND PrintChecks00."CHECKNUM" NOT IN (SELECT CHECKNUM FROM dbo.t_rkeeper_CHECKNUM_CARDCODE)




DECLARE 
   @CARDCODE VARCHAR(250), 
   @SaleChID INT, 
   @CHECKNUM INT, 
   @TRealSum NUMERIC(21,9), 
   @DocCreateTime SMALLDATETIME, 
   @LogID INT, 
   @DBiID INT = dbo.zf_Var('OT_DBiID')
   
   
DECLARE CUR_CHECKNUM CURSOR FOR
	SELECT s.ChID, s.DocCreateTime, s.TRealSum, r.CARDCODE, r.CHECKNUM FROM t_sale s
	JOIN t_rkeeper_CHECKNUM_CARDCODE r ON r.CHECKNUM = s.DocID
	WHERE r.IMPORT = 0

OPEN CUR_CHECKNUM
FETCH NEXT FROM CUR_CHECKNUM INTO @SaleChID, @DocCreateTime, @TRealSum, @CARDCODE, @CHECKNUM
WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRAN DCard
	IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 11035 AND ChID = @SaleChID AND DCardID = @CARDCODE)
		INSERT dbo.z_DocDC (DocCode, ChID, DCardID) VALUES (11035, @SaleChID, @CARDCODE) 


--SELECT * FROM dbo.z_DocDC where ChID = @SaleChID and DCardID = @CARDCODE
		                            
	SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscRec WHERE DBiID = @DBiID

	INSERT dbo.z_LogDiscRec
		(LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, logdate ,BonusType, DBiID)
	VALUES 
		(@LogID, @CARDCODE, 0, 11035, @SaleChID, 1, 122,  @TRealSum, @DocCreateTime, 0, @DBiID)
	
	UPDATE t_rkeeper_CHECKNUM_CARDCODE
	SET IMPORT = 1, DateTime = GETDATE()
	WHERE CHECKNUM = @CHECKNUM AND CARDCODE = @CARDCODE 
		
	COMMIT TRAN DCard  

--SELECT * FROM dbo.z_LogDiscRec where LogID = @LogID

	FETCH NEXT FROM CUR_CHECKNUM INTO @SaleChID, @DocCreateTime, @TRealSum, @CARDCODE, @CHECKNUM
END
CLOSE CUR_CHECKNUM
DEALLOCATE CUR_CHECKNUM






SELECT * FROM  dbo.t_rkeeper_CHECKNUM_CARDCODE 
	
SELECT s.ChID, s.DocID,s.DocCreateTime, s.TRealSum, r.CARDCODE, * FROM t_sale s
join t_rkeeper_CHECKNUM_CARDCODE r on r.CHECKNUM = s.DocID










SELECT * FROM dbo.t_rkeeper_CHECKNUM_CARDCODE  



--delete dbo.t_rkeeper_CHECKNUM_CARDCODE


SELECT s.ChID, s.DocID,s.DocCreateTime, s.TRealSum, r.CARDCODE, * FROM t_sale s
join t_rkeeper_CHECKNUM_CARDCODE r on r.CHECKNUM = s.DocID


