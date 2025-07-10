USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EXITE_ExportDoc]    Script Date: 19.11.2020 14:20:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[ap_EXITE_ExportDoc] @DocType VARCHAR(20), @DocCode INT = 11012, @ChID INT, @Out XML OUT, @TOKEN INT OUT
AS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ПРОЦЕДУРА ВЫГРУЗКИ ДОКУМЕНТА EXITE ПО ЕГО ТИПУ @DOCTYPE И КОДУ РЕГИСТРАЦИИ @CHID*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] '2019-04-22 15:58' rkv0  добавил проверку на пустой тег 'PRICEWITHVAT' (проблема с Розеткой)
-- [ADDED] '2019-04-22 15:58' rkv0  добавил проверку на пустой тег 'PRICE' (проблема с Розеткой)
-- [ADDED] '2019-06-25 10:41' rkv0  добавил розетко-единицы в COMDOC.
-- [CHANGED] '2019-07-01 17:29' rkv0 изменил подстановку розетко-единиц через справочник r_ProdMQ (для DESADV, ORDRSP, COMDOC)
-- [CHANGED] '2019-09-11 11:08' rkv0 COMDOC: "Продавець" меняем на "Відправник", добавляем тег "Отримувач".
-- [CHANGED] '2019-10-15 13:19' rkv0 делаю округление в одну строку (нет необходимости в длинных преобразованиях).
-- [CHANGED] '2019-10-15 16:50' rkv0 меняю подстановку № уведомления-№ заказа на №уведомления-№расходной
-- [REMOVED] '2019-10-16 15:50' rkv0 убираем группировку по 3-м полям: dd.SumCC_nt, dd.TaxSum, dd.SumCC_wt
-- [ADDED] '2020-04-24 17:25' rkv0 добавляем единицы измерения.
-- [ADDED] '2020-05-25 13:20:13.272' Maslov Oleg Добавил в текст сообщения каждой ошибки название процедуры. Для того чтобы проще было искать источник сообщения.
-- [CHANGED] '2020-07-08 18:02' rkv0 убираем нули (письмо от Гали Танцюры: "сеть МЕТРО не принимает на подпись товарные с нулями в начале").
-- [ADDED] rvk0 '2020-07-30 15:05' добавил код УКТВЭД (для сети Розетка - он обязательный). + добавить в группировку GROUP BY
-- [ADDED] Maslov Oleg '2020-08-04 15:02:50.675' Добавил поле "Цена продукту c ПДВ" (для сети Розетка - он обязательный, ВНЕЗАПНО). И добавил его (dd.PriceCC_wt) в группировку GROUP BY.
-- [ADDED] Maslov Oleg '2020-08-04 15:05:34.538' Добавил поле "Ставка податку (ПДВ,%)" (для сети Розетка - он обязательный, ВНЕЗАПНО).	
-- [FIXED] rkv0 '2020-09-28 10:55' TotalLines считать надо по количеству строк в расходной.
-- [CHANGED] rkv0 '2020-10-21 19:05' изменил COMDOC на COMDOC_ROZETKA, т.к. эта расходная отправляется только на Розетку (также это будет использоваться для ограничения отправки расходных из инструмента F11 Exite).
--[CHANGED] rkv0 '2020-11-10 19:46' изменил тег sender-buyer (для подвязки документов в цепочку). ##RE-433##
--[FIXED] rkv0 '2020-11-13 10:47' для сети METRO делаю замену символа "+" на пустоту "".
--[CHANGED] rkv0 '2020-11-19 14:21' заявка #2421. Меняю теги для сети Розетка: убираю "Отримувач", меняю "Видправник" на "Продавець".

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Тест формирования xml*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
DECLARE @xml XML, @token INT; EXEC ap_EXITE_ExportDoc @DocType='COMDOC_METRO', @DocCode=11012, @ChID=200438292,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token 'Token', @xml 'XML';
DECLARE @xml XML, @token INT; EXEC ap_EXITE_ExportDoc @DocType='DECLAR', @DocCode=11012, @ChID=200373969,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token 'Token', @xml 'XML';
DECLARE @xml XML, @token INT; EXEC ap_EXITE_ExportDoc @DocType='INVOICE', @DocCode=11012, @ChID=200430088,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token 'Token', @xml 'XML';
DECLARE @xml XML, @token INT; EXEC ap_EXITE_ExportDoc @DocType='PACKAGE_METRO', @DocCode=11012, @ChID=200342776,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token 'Token', @xml 'XML';
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='ORDRSP', @DocCode=11012, @ChID=200314506,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='DESADV', @DocCode=11012, @ChID=200417133,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='COMDOC_ROZETKA', @DocCode=11012, @ChID=200435159,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
*/


BEGIN
  SET NOCOUNT ON
  --DECLARE @ChID INT = 300097817
  DECLARE @CompID INT, @CompName VARCHAR(250), @CompAddID INT
  DECLARE @DocID INT
  DECLARE @Msg VARCHAR(250), @Msg1 VARCHAR(250)
	--DECLARE @DocCode INT = 11012
  DECLARE @Desadv XML--(DesadvSchema)
	DECLARE @TblName VARCHAR(250) = (SELECT TableName FROM dbo.z_Tables WHERE TableCode = @DocCode * 1000 + 1)
  DECLARE @TblNameD VARCHAR(250) = (SELECT TableName FROM dbo.z_Tables WHERE TableCode = @DocCode * 1000 + 2)
	DECLARE @SQL NVARCHAR(MAX), @O VARCHAR(250)
	
	EXEC dbo.z_DocLookup 'CompID', @DocCode, @ChID, @CompID OUT
	EXEC dbo.z_DocLookup 'CompAddID', @DocCode, @ChID, @CompAddID OUT
	EXEC dbo.z_DocLookup 'DocID', @DocCode, @ChID, @DocID OUT
	SELECT @CompName = CompName FROM dbo.r_Comps WITH(NOLOCK) WHERE CompID = @CompID OPTION(FAST 1)

  IF NOT EXISTS(SELECT * FROM dbo.r_Uni WITH(NOLOCK) WHERE RefTypeID = 80019 AND RefID = @CompID)
    BEGIN
      RAISERROR('[dbo].[ap_EXITE_ExportDoc] Для данного контрагента "%s" (%u) невозможно отправить сообщение "%s", так как для него не заполнен "Список допустимых сообщений" (Справочник универсальный "80019").', 18, 1, @CompName, @CompID, @DocType)
      RETURN
    END
     
  /* Так как GLN берём из заказа, то и проверять его нет смысла
  IF NOT EXISTS(SELECT * FROM dbo.t_Inv m WITH(NOLOCK) JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID WHERE m.ChID = @ChID AND rc.GLNCode <> '')
    BEGIN
      RAISERROR('Для данного контрагента "%s" (%u) невозможно отправить сообщение "%s", так как для него не установлен "Номер GLN".', 18, 1, @CompName, @CompID, @DocType)
      RETURN
    END*/

	SET @Out = NULL
	SET @SQL = N'SELECT TOP 1 @O = 1 FROM dbo.' + @TblNameD + N' WHERE ChID = @C AND Qty = 0 OPTION(FAST 1)'
	EXEC sp_executesql @SQL, N'@O INT OUT, @C INT', @O OUT, @ChID

  IF @Out IS NOT NULL
  BEGIN
    RAISERROR('[dbo].[ap_EXITE_ExportDoc] В документе %u присутствует товар с количеством = 0. Экспорт отменён.', 18, 1, @DocID)
    RETURN
  END
	
	SET @Out = NULL
	SET @SQL = N'SELECT TOP 1 @O = 1 FROM dbo.' + @TblName + N' WHERE ChID = @C AND TaxDocID = 0 OPTION(FAST 1)'
	EXEC sp_executesql @SQL, N'@O INT OUT, @C INT', @O OUT, @ChID
  IF @Out IS NOT NULL
  BEGIN
    RAISERROR('[dbo].[ap_EXITE_ExportDoc] В документе %u не установлен номер налоговой накладной. Экспорт отменён.', 18, 1, @DocID)
    RETURN
  END
  
  IF @DocType = 'INVOICE' AND @DocCode = 11012
  BEGIN
    IF EXISTS(SELECT * FROM dbo.t_Inv m JOIN r_Comps rc ON rc.CompID = m.ChID WHERE m.ChID = @ChID
  	AND rc.Code = '32049199' AND NOT (m.SrcDocID IS NOT NULL AND (m.SrcDocID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR m.SrcDocID LIKE '[0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')))
    BEGIN
      RAISERROR('[dbo].[ap_EXITE_ExportDoc] В накладной %u не установлен номер "Зелёной марки". Экспорт отменён.', 18, 1, @DocID)
			RETURN
    END
  END
  ELSE IF @DocType IN ('DESADV', 'ORDRSP') AND @DocCode = 11012
  BEGIN
    IF EXISTS(SELECT * FROM dbo.t_Inv m JOIN r_Comps rc ON rc.CompID = m.ChID WHERE m.ChID = @ChID
      AND rc.Code IN ('36387249','38916558'))
    AND NOT EXISTS(SELECT * FROM dbo.at_t_InvLoad WHERE ChID = @ChID AND BoxQty IS NOT NULL AND ISNUMERIC(BoxQty) = 1
      AND PalQty IS NOT NULL AND ISNUMERIC(PalQty) = 1
      AND CarQty IS NOT NULL AND ISNUMERIC(CarQty) = 1)
    BEGIN
      RAISERROR('[dbo].[ap_EXITE_ExportDoc] В накладной %u не заполонена логистическая информация. Экспорт отменён.', 18, 1, @DocID)
	  RETURN
    END
  END 
/*
  IF EXISTS(SELECT *
    FROM dbo.r_CompsAdd rca WITH(NOLOCK)
    WHERE rca.CompID = @CompID AND rca.CompAddID = @CompAddID AND rca.GLNCode = '')
  BEGIN
    SELECT TOP 1 @Msg = rca.CompAdd
	  FROM dbo.r_CompsAdd rca WITH(NOLOCK)
    WHERE rca.CompID = @CompID AND rca.CompAddID = @CompAddID AND rca.GLNCode = ''
    OPTION(FAST 1)
    RAISERROR('В документе %u для контрагента "%s" (%u) и адреса доставки "%s" (%u) не установлен "Номер GLN". Экспорт отменён.', 18, 1, @DocID, @CompName, @CompID, @Msg, @CompAddID)
    RETURN
  END  */

  IF @DocCode = 11012 AND EXISTS(SELECT * FROM dbo.t_InvD d JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d.ProdID AND tpp.PPID = d.PPID WHERE ChID = @ChID AND (tpp.ProdBarCode = '' OR tpp.ProdBarCode IS NULL))
  BEGIN
    SELECT @Msg = d.ProdID, @Msg1 = d.PPID
    FROM dbo.t_InvD d JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d.ProdID AND tpp.PPID = d.PPID WHERE ChID = @ChID AND (tpp.ProdBarCode = '' OR tpp.ProdBarCode IS NULL)
    RAISERROR('[dbo].[ap_EXITE_ExportDoc] В накладной %u для товара %s в партии %s не заполнено поле "Штрих-код производителя". Экспорт отменён.', 18, 1, @DocID, @Msg, @Msg1)
    RETURN
  END  

  IF EXISTS(SELECT * FROM dbo.r_Uni WITH(NOLOCK) WHERE RefTypeID = 80019 AND RefID = @CompID)
    IF NOT EXISTS(SELECT * FROM dbo.r_Uni WITH(NOLOCK) WHERE RefTypeID = 80019 AND RefID = @CompID AND Notes LIKE '%' + @DocType + '%')
    BEGIN
      RAISERROR('[dbo].[ap_EXITE_ExportDoc] Для данного контрагента "%s" (%u) невозможно отправить сообщение "%s", так как контрагент не принимает сообщений такого типа. Список допустимых сообщений можно уточнить, нажав на кнопку "?" окна параметров инструмента (потребуется Adobe Reader).', 18, 1, @CompName, @CompID, @DocType)
      RETURN
    END
  
  DECLARE @OrdChID INT = dbo.af_GetParentChID(@DocCode, @ChID, 11221)
  
	IF @DocCode = 11012
  IF NOT EXISTS(SELECT *
  FROM
  (SELECT CAST(di.ProdID AS VARCHAR(20)) ProdID, irec.ExtProdID FROM dbo.t_IORecD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID WHERE ChID = @OrdChID GROUP BY di.ProdID, irec.ExtProdID HAVING SUM(di.Qty) > 0) ird
   JOIN (SELECT ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20))) ProdID, irec.ExtProdID, tpp.ProdBarCode, SUM(Qty) Qty FROM dbo.t_InvD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = di.ProdID AND tpp.PPID = di.PPID WHERE ChID = @ChID GROUP BY irec.ExtProdID, tpp.ProdBarCode, ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20)))) dd ON (dd.ProdID = ird.ProdID AND dd.ExtProdID IS NULL) OR (dd.ProdID = ird.ExtProdID AND dd.ExtProdID IS NOT NULL))
  BEGIN
    RAISERROR('[dbo].[ap_EXITE_ExportDoc] Накладная %u не содержит какого-либо заказанного контрагентом товара. Экспорт отменён.', 18, 1, @DocID)
    RETURN
  END
  
  SET @TOKEN = CAST(LEFT(CAST(@CompID AS VARCHAR(250)) + '000000000', 9) AS INT) + ISNULL(CAST((SELECT TOP 1 VarValue FROM dbo.r_CompValues WITH(NOLOCK) WHERE VarName = 'EDIINTERCHANGEID' AND CompID = @CompID) AS INT),0) + 1

    IF OBJECT_ID('tempdb.dbo.#invnum' ,'U') IS NOT NULL DROP TABLE #invnum
    SELECT * INTO #invnum FROM (
    SELECT FileData.value('(./Document-Invoice/Invoice-Header/InvoiceNumber)[1]','varchar(16)') 'InvNum' FROM at_z_filesexchange WHERE [FileName] like '%documentinvoice%'
    ) AS invnum

 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /*INVOICE (счет-фактура)*/
 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  IF @DocType = 'INVOICE'
  BEGIN
  /* Документ INVOICE */
    SET @Out = (
    SELECT
    380 'DOCUMENTNAME',
    CAST(m.TaxDocID AS INT) 'NUMBER',
    CAST(m.TaxDocDate AS DATE) 'DATE',
    CAST(m.TaxDocDate AS DATE) 'DELIVERYDATE',
    NULL 'DELIVERYTIME',
    'UAH' 'CURRENCY',
    CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END 'ORDERNUMBER',
    irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'ORDERDATE',
    CAST(m.TaxDocID AS INT) 'DELIVERYNOTENUMBER',
    CAST(m.TaxDocDate AS DATE) 'DELIVERYNOTEDATE',
    CASE WHEN c.Code = '32049199' AND m.SrcDocID IS NOT NULL AND (m.SrcDocID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR m.SrcDocID LIKE '[0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]') AND m.SrcDocID != ir.OrderID THEN m.SrcDocID END 'PAYMENTORDERNUMBER',
    zc.ContrID 'CAMPAIGNNUMBER',
    LTRIM(RTRIM(o.TaxCode)) 'FISCALNUMBER',
    LTRIM(RTRIM(o.Code)) 'REGISTRATIONNUMBER',
    ISNULL((SELECT SUM(SumCC_nt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID),0) 'GOODSTOTALAMOUNT',
    ISNULL((SELECT SUM(SumCC_nt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID),0) 'POSITIONSAMOUNT',
    ISNULL((SELECT SUM(TaxSum) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID),0) 'VATSUM',
    ISNULL((SELECT SUM(SumCC_wt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID),0) 'INVOICETOTALAMOUNT',
    ISNULL((SELECT SUM(SumCC_nt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID AND Tax > 0),0) 'TAXABLEAMOUNT',
    CAST(ISNULL((SELECT SUM(TaxSum) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID AND Tax > 0) / (SELECT SUM(SumCC_nt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID AND Tax > 0),0) * 100 AS INT) 'VAT',
    (
    SELECT COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SUPPLIER',
    COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) 'BUYER',
    COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'DELIVERYPLACE',
    COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) 'CONSEGNOR',
    COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'CONSIGNEE',
    COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SENDER',
    COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)')) 'RECIPIENT',
    @TOKEN 'EDIINTERCHANGEID',
      (
      SELECT ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) 'POSITIONNUMBER',
      tpp.ProdBarCode 'PRODUCT',
      dd.ProdID 'PRODUCTIDSUPPLIER',
			irec.ExtProdID 'PRODUCTIDBUYER',
      SUM(dd.Qty) 'INVOICEDQUANTITY',
      --[ADDED] '2020-04-24 17:25' rkv0 добавляем единицы измерения.
      CASE WHEN p.UM = 'шт.' THEN 'PCE' ELSE 'PCE' END 'INVOICEUNIT',
      dd.PriceCC_nt 'UNITPRICE',
			dd.PriceCC_wt 'GROSSPRICE',
      SUM(dd.SumCC_nt) 'AMOUNT',
      LEFT(p.Notes, 70) 'DESCRIPTION',
      203 'AMOUNTTYPE',
      7 'TAX/FUNCTION',
      'VAT' 'TAX/TAXTYPECODE',
      CAST(dbo.zf_GetProdTaxPercent(dd.ProdID, m.DocDate) AS INT) 'TAX/TAXRATE',
      SUM(dd.TaxSum) 'TAX/TAXAMOUNT',
      'S' 'TAX/CATEGORY'
      FROM dbo.t_InvD dd WITH(NOLOCK)
      JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = dd.prodid
      JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = dd.ProdID AND tpp.PPID = dd.PPID
			LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = dd.ProdID AND irec.CompID = @CompID
      WHERE dd.ChID = @ChID
      GROUP BY tpp.ProdBarCode, p.Notes, dd.ProdID, irec.ExtProdID, dd.PriceCC_nt, dd.PriceCC_wt, p.UM
      FOR XML PATH ('POSITION'), TYPE)
    FOR XML PATH ('HEAD'), TYPE
    )
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.[Address]
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    --JOIN dbo.r_OurValues ov WITH(NOLOCK) ON m.OurID = ov.OurID AND ov.VarName = 'GLNCode'
    JOIN dbo.r_Comps c WITH(NOLOCK) ON c.CompID = m.CompID
    LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
    LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    WHERE m.ChID = @ChID AND
    --c.GLNCode <> '' AND
    rca.GLNCode <> '' AND
    (ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    m.TaxDocID <> 0 AND
    ir.OrderID IS NOT NULL AND ir.OrderID != ''
    FOR XML PATH ('INVOICE'))
    END;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESADV (Уведомление об отгрузке)*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ELSE IF @DocType = 'DESADV'
  BEGIN
    SET @Desadv = (
    SELECT
    -- '2019-10-15 16:50' rkv0 меняю подстановку № уведомления-№ заказа на №уведомления-№расходной
      --CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END 'NUMBER',
      CAST(m.TaxDocID AS INT) 'NUMBER',
      CAST(m.TaxDocDate AS DATE) 'DATE',
      CAST(m.TaxDocDate AS DATE) 'DELIVERYDATE',
      CASE WHEN CAST(il.ExpDate AS TIME) <> '00:00:00' THEN LEFT(CAST(il.ExpDate AS TIME), 5) END 'DELIVERYTIME',
      CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END 'ORDERNUMBER',
      irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'ORDERDATE',
      CAST(m.TaxDocID AS INT) 'DELIVERYNOTENUMBER',
      CAST(m.TaxDocDate AS DATE) 'DELIVERYNOTEDATE',
      m.DocID 'SUPPLIERORDERNUMBER',
      CAST(m.DocDate AS DATE) 'SUPPLIERORDERDATE',
      CAST(il.BoxQty AS INT) 'TOTALPACKAGES',
      CAST(il.PalQty AS INT) 'TOTALPALLETS',
      zc.ContrID 'CAMPAIGNNUMBER',
      CAST(il.CarQty AS INT) 'TRANSPORTQUANTITY',
      rd.CarName 'TRANSPORTMARK',
      rd.CarNo 'TRANSPORTID',
      rd.DriverName 'TRANSPORTERNAME',
      30 'TRANSPORTTYPE',
      31 'TRANSPORTERTYPE',
      rc4.CodeName4 'CARRIERNAME',
      CASE WHEN rc4.Notes LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR rc4.Notes LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' THEN rc4.Notes END 'CARRIERINN',
      (
      SELECT COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SUPPLIER',
      COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) 'BUYER',
      COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'DELIVERYPLACE',
      COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SENDER',
      COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)')) 'RECIPIENT',
      @TOKEN 'EDIINTERCHANGEID',
        (
          SELECT 1 'HIERARCHICALID',
          (
            SELECT ROW_NUMBER() OVER(ORDER BY MAX(ird.SrcPosID))'POSITIONNUMBER',
            ISNULL(dd.ProdBarCode, pp.ProdBarCode) 'PRODUCT',
            ird.ProdID 'PRODUCTIDSUPPLIER',
            ird.ExtProdID 'PRODUCTIDBUYER',

            -- [ADDED] rvk0 '2020-07-30 15:05' добавил код УКТВЭД (для сети Розетка - он обязательный). + добавить в группировку GROUP BY
            CASE WHEN @compid in (7136, 7138) THEN pp.CstProdCode END as 'CUSTOMSTARIFFNUMBER',
            
              CASE WHEN RIGHT(SUBSTRING(CAST(SUM(ISNULL(CASE
                 WHEN  @CompID=7138 THEN dd.Qty/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
                 ELSE dd.Qty END,0)) AS varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))), 1) = '.' 
					 THEN SUBSTRING(CAST(SUM(ISNULL(
                 CASE
   				 WHEN  @CompID=7138 THEN dd.Qty/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				 ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))) + '0'
                 ELSE SUBSTRING(CAST(SUM(ISNULL(
                 CASE
   				     WHEN  @CompID=7138 THEN dd.Qty/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				 ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0)))))
            END  'DELIVEREDQUANTITY',
            
--            SUM(ird.Qty) 'ORDEREDQUANTITY',            
            CASE WHEN RIGHT(SUBSTRING(CAST(
            CASE 
   				WHEN  @CompID=7138 THEN SUM(ird.Qty)/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
			ELSE SUM(ird.Qty) END AS varchar ), 1, LEN(SUM(ird.Qty))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ird.Qty)))), 1) = '.' 
                 THEN SUBSTRING(CAST(
					CASE
   				        WHEN  @CompID=7138 THEN SUM(ird.Qty)/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
					ELSE SUM(ird.Qty) END AS varchar), 1, LEN(SUM(ird.Qty))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ird.Qty)))) + '0'
                 ELSE SUBSTRING(CAST(
					CASE
   				        WHEN  @CompID=7138 THEN SUM(ird.Qty)/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
					ELSE SUM(ird.Qty) END AS varchar), 1, LEN(SUM(ird.Qty))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ird.Qty))))
            END 'ORDEREDQUANTITY',
            
--            SUM(dd.SumCC_nt) 'AMOUNT',
            CASE WHEN RIGHT(SUBSTRING(CAST(
            CASE 
   			    WHEN  @CompID=7138 THEN SUM(dd.SumCC_nt)*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
			ELSE SUM(dd.SumCC_nt) END AS varchar ), 1, LEN(SUM(dd.SumCC_nt))+1 - PATINDEX('%[^0]%', REVERSE(SUM(dd.SumCC_nt)))), 1) = '.' 
                 THEN SUBSTRING(CAST
                 (CASE
   			        WHEN  @CompID=7138 THEN SUM(dd.SumCC_nt)*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				ELSE SUM(dd.SumCC_nt) END AS varchar), 1, LEN(SUM(dd.SumCC_nt))+1 - PATINDEX('%[^0]%', REVERSE(SUM(dd.SumCC_nt)))) + '0'
                 ELSE SUBSTRING(CAST
                 (CASE
   			        WHEN  @CompID=7138 THEN SUM(dd.SumCC_nt)*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				ELSE SUM(dd.SumCC_nt) END AS varchar), 1, LEN(SUM(dd.SumCC_nt))+1 - PATINDEX('%[^0]%', REVERSE(SUM(dd.SumCC_nt))))
            END 'AMOUNT',
            
--            dd.PriceCC_nt 'PRICE', 
            CASE WHEN RIGHT(SUBSTRING(CAST(
            CASE 
   			     WHEN  @CompID=7138 THEN dd.PriceCC_nt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
			ELSE   dd.PriceCC_nt END AS varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt))), 1) = '.' 
                 THEN SUBSTRING(CAST(
                 CASE 
   			         WHEN  @CompID=7138 THEN dd.PriceCC_nt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)  
				ELSE   dd.PriceCC_nt END as varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt))) + '0'
                 ELSE SUBSTRING(CAST(
                 CASE
   			         WHEN  @CompID=7138 THEN dd.PriceCC_nt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID) 
				ELSE   dd.PriceCC_nt END as varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt)))
            END 'PRICE', 

			-- [ADDED] Maslov Oleg '2020-08-04 15:02:50.675' Добавил поле "Цена продукту c ПДВ" (для сети Розетка - он обязательный, ВНЕЗАПНО). И добавил его (dd.PriceCC_wt) в группировку GROUP BY.
			CASE WHEN @compid in (7136, 7138)
			       THEN
						CASE WHEN RIGHT(SUBSTRING(CAST(
						CASE 
   							 WHEN  @CompID=7138 THEN dd.PriceCC_wt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
						ELSE   dd.PriceCC_wt END AS varchar), 1, LEN(dd.PriceCC_wt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_wt))), 1) = '.' 
							 THEN SUBSTRING(CAST(
							 CASE 
   								 WHEN  @CompID=7138 THEN dd.PriceCC_wt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)  
							ELSE   dd.PriceCC_wt END as varchar), 1, LEN(dd.PriceCC_wt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_wt))) + '0'
							 ELSE SUBSTRING(CAST(
							 CASE
   								 WHEN  @CompID=7138 THEN dd.PriceCC_wt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID) 
							ELSE   dd.PriceCC_wt END as varchar), 1, LEN(dd.PriceCC_wt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_wt)))
						END
            END AS 'PRICEWITHVAT',

			-- [ADDED] Maslov Oleg '2020-08-04 15:05:34.538' Добавил поле "Ставка податку (ПДВ,%)" (для сети Розетка - он обязательный, ВНЕЗАПНО).
			CASE WHEN @compid in (7136, 7138) THEN CAST(FLOOR(dbo.zf_GetProdTaxPercent(ird.ProdID, GETDATE())) AS VARCHAR) END AS 'TAXRATE',


            LEFT(rp.Notes, 70) 'DESCRIPTION'
            FROM (SELECT MIN(SrcPosID) SrcPosID
			            ,CAST(di.ProdID AS VARCHAR(20)) ProdID
						,irec.ExtProdID
						,SUM(Qty) Qty
			      FROM dbo.t_IORecD di WITH(NOLOCK)
				  LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID
				  WHERE ChID = @OrdChID GROUP BY di.ProdID, irec.ExtProdID
				  HAVING SUM(di.Qty) > 0
				 ) ird
            LEFT JOIN (SELECT ISNULL(irec.ExtProdID
			                 ,CAST(di.ProdID AS VARCHAR(20))) ProdID
							 ,irec.ExtProdID
							 ,tpp.ProdBarCode
							 ,SUM(Qty) Qty
							 ,PriceCC_nt
							 ,PriceCC_wt
							 ,SUM(di.SumCC_nt) SumCC_nt
					   FROM dbo.t_InvD di WITH(NOLOCK)
					   LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID
					   JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = di.ProdID AND tpp.PPID = di.PPID
					   WHERE ChID = @ChID
					   GROUP BY irec.ExtProdID, tpp.ProdBarCode, PriceCC_nt, PriceCC_wt, ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20)))
					  ) dd ON (dd.ProdID = ird.ProdID AND dd.ExtProdID IS NULL) OR (dd.ProdID = ird.ExtProdID AND dd.ExtProdID IS NOT NULL)
            JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = ird.ProdID
            LEFT JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = rp.ProdID AND pp.PPID = (SELECT MAX(PPID) FROM dbo.t_PInP WITH(NOLOCK) WHERE ProdID = rp.ProdID AND NOT (ProdBarCode = '' OR ProdBarCode IS NULL))--если выстреливает 2 одинаковых кода товара, но с разными кодами УКТВЭД, берем код УКТВЭД последней партии (но с 2018г. бухгалтерия  требует, чтобы в таких случаях заводился отдельный код товара).

            WHERE -- Для некоторых предприятий не показывать нули
				  (m.CompID = 7030 AND dd.Qty IS NOT NULL) OR m.CompID != 7030
            GROUP BY dd.ProdBarCode, pp.ProdBarCode, ird.ExtProdID, ird.ProdID, rp.Notes, dd.PriceCC_nt, pp.CstProdCode, dd.PriceCC_wt
            FOR XML PATH ('POSITION'), TYPE)
          FOR XML PATH ('PACKINGSEQUENCE'), TYPE)
      FOR XML PATH ('HEAD'), TYPE
      )
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    --JOIN dbo.r_OurValues ov WITH(NOLOCK) ON m.OurID = ov.OurID AND ov.VarName = 'GLNCode'
    JOIN dbo.r_Comps c WITH(NOLOCK) ON c.CompID = m.CompID
    LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
    LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
    LEFT JOIN dbo.at_t_InvLoad il WITH(NOLOCK) ON il.ChID = m.ChID
    LEFT JOIN dbo.at_r_Drivers rd WITH(NOLOCK) ON rd.DriverID = m.DriverID AND rd.DriverId != 0
    LEFT JOIN dbo.r_Codes4 rc4 WITH(NOLOCK) ON rc4.CodeID4 = m.CodeID4 AND rc4.CodeID4 != 0
    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    WHERE m.Chid = @ChID AND --c.GLNCode <> '' AND
    rca.GLNCode <> '' AND
    (ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    ISNULL(ir.OrderID,'') <> '' AND m.TaxDocID <> 0
    FOR XML PATH ('DESADV'))
    
    END;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ORDRSP (Подтверждение заказа)*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ELSE IF @DocType = 'ORDRSP'
  BEGIN
    SET @Out = (
    SELECT
      CAST(m.TaxDocID AS INT) 'NUMBER',
      CAST(m.TaxDocDate AS DATE) 'DATE',
      CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END 'ORDERNUMBER',
      irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'ORDERDATE',
      CAST(m.TaxDocDate AS DATE) 'DELIVERYDATE',
      CASE WHEN CAST(il.ExpDate AS TIME) <> '00:00:00' THEN LEFT(CAST(il.ExpDate AS TIME), 5) ELSE '00:00' END 'DELIVERYTIME',
      CAST(il.BoxQty AS INT) 'TOTALPACKAGES',
      CAST(il.PalQty AS INT) 'TOTALPACKAGESSPACE',
      CAST(il.CarQty AS INT) 'TRANSPORTQUANTITY',
      (
      SELECT COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) 'BUYER',
      COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SUPPLIER',
      COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'DELIVERYPLACE',
      COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SENDER',
      COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)')) 'RECIPIENT',
      @TOKEN 'EDIINTERCHANGEID',
        (
          SELECT ROW_NUMBER() OVER(ORDER BY ird.SrcPosID)'POSITIONNUMBER',
          ISNULL(dd.ProdBarCode, pp.ProdBarCode) 'PRODUCT',
          ird.ExtProdID 'PRODUCTIDBUYER',
          ird.ProdID 'PRODUCTIDSUPPLIER',
          ru.Notes 'ORDRSPUNIT',
          LEFT(rp.Notes, 70) 'DESCRIPTION',
				CASE
                    WHEN  @CompID=7138 THEN dd.PriceCC_nt * [dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				--'2019-04-22 15:58' rkv0 добавил проверку на пустой тег 'PRICE' (проблема с Розеткой)				
				ELSE 	ISNULL(dd.PriceCC_nt, 0) END'PRICE',
				CASE
                    WHEN  @CompID=7138 THEN dd.PriceCC_wt * [dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				--'2019-04-22 15:58' rkv0 добавил проверку на пустой тег 'PRICEWITHVAT' (проблема с Розеткой)				
				ELSE 	ISNULL(dd.PriceCC_wt, 0) END 'PRICEWITHVAT',
					dbo.zf_GetProdTaxPercent(ird.ProdID, m.DocDate) 'VAT',
          CASE WHEN dd.Qty IS NULL THEN 3 WHEN dd.Qty = ird.Qty THEN 1 ELSE 2 END 'PRODUCTTYPE',
		CASE
            WHEN  @CompID=7138 THEN ird.Qty/ [dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
		ELSE ird.Qty END 'ORDEREDQUANTITY',
          ISNULL(CASE
                    WHEN  @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				ELSE dd.Qty END, 0) 'ACCEPTEDQUANTITY'
          FROM (SELECT MIN(SrcPosID) SrcPosID, CAST(di.ProdID AS VARCHAR(20)) ProdID, irec.ExtProdID, SUM(Qty) Qty FROM dbo.t_IORecD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID WHERE ChID = @OrdChID GROUP BY CAST(di.ProdID AS VARCHAR(20)), irec.ExtProdID HAVING SUM(di.Qty) > 0) ird
          LEFT JOIN (SELECT ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20))) ProdID, irec.ExtProdID, tpp.ProdBarCode, SUM(Qty) Qty, di.PriceCC_nt, di.PriceCC_wt FROM dbo.t_InvD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = di.ProdID AND tpp.PPID = di.PPID WHERE ChID = @ChID GROUP BY irec.ExtProdID, tpp.ProdBarCode, ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20))), di.PriceCC_nt, di.PriceCC_wt) dd ON (dd.ProdID = ird.ProdID AND dd.ExtProdID IS NULL) OR (dd.ProdID = ird.ExtProdID AND dd.ExtProdID IS NOT NULL)
          LEFT JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = ird.ProdID
          LEFT JOIN dbo.r_Uni ru WITH(NOLOCK) ON ru.RefTypeID = 80021 AND ru.RefName = rp.UM AND ru.Notes IS NOT NULL AND ru.Notes != '' AND ru.RefID < 1000
          LEFT JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = rp.ProdID AND pp.PPID = (SELECT MAX(PPID) FROM dbo.t_PInP WITH(NOLOCK) WHERE ProdID = rp.ProdID AND NOT (ProdBarCode = '' OR ProdBarCode IS NULL))--если выстреливает 2 одинаковых кода товара, но с разными кодами УКТВЭД, берем код УКТВЭД последней партии (но с 2018г. бухгалтерия  требует, чтобы в таких случаях заводился отдельный код товара).

          FOR XML PATH ('POSITION'), TYPE)
      FOR XML PATH ('HEAD'), TYPE
      )
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    --JOIN dbo.r_OurValues ov WITH(NOLOCK) ON m.OurID = ov.OurID AND ov.VarName = 'GLNCode'
    JOIN dbo.r_Comps c WITH(NOLOCK) ON c.CompID = m.CompID    
    LEFT JOIN dbo.at_t_InvLoad il WITH(NOLOCK) ON il.ChID = m.ChID
    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    WHERE m.Chid = @ChID AND-- c.GLNCode <> '' AND
  --  rca.GLNCode <> '' AND
    (ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    ISNULL(ir.OrderID,'') <> '' AND m.TaxDocID <> 0
    FOR XML PATH ('ORDRSP'))

    END;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*COMDOC (Коммерческий документ: расходная накладная)*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [CHANGED] rkv0 '2020-10-21 19:05' изменил COMDOC на COMDOC_ROZETKA, т.к. эта расходная отправляется только на Розетку (также это будет использоваться для ограничения отправки расходных из инструмента F11 Exite).
  --ELSE IF @DocType = 'COMDOC'
  ELSE IF @DocType = 'COMDOC_ROZETKA'
  BEGIN
    SET @Out = (
    SELECT
      m.TaxDocID 'Заголовок/НомерДокументу',
      'Видаткова накладна' AS 'Заголовок/ТипДокументу',
      '006' AS 'Заголовок/КодТипуДокументу',
      CAST(m.TaxDocDate AS DATE) AS 'Заголовок/ДатаДокументу',
      CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END AS 'Заголовок/НомерЗамовлення',
      irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'Заголовок/ДатаЗамовлення',
      'Дніпропетровська обл. м. Синельникове' AS 'Заголовок/МісцеСкладання',
      REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(zc.ContrID,'-','@'),'/','#')),'@','-'),'#','/') AS 'Заголовок/ДокПідстава/НомерДокументу',
      'Договір' AS 'Заголовок/ДокПідстава/ТипДокументу',
      '001' AS 'Заголовок/ДокПідстава/КодТипуДокументу',
      CAST(zc.BDate AS DATE) AS 'Заголовок/ДокПідстава/ДатаДокументу',
      (SELECT
        (SELECT * FROM (SELECT 
--[CHANGED] rkv0 '2020-11-19 14:21' заявка #2421. Меняю теги для сети Розетка: убираю "Отримувач", меняю "Видправник" на "Продавець".
        --'Відправник' AS 'СтатусКонтрагента',
        'Продавець' AS 'СтатусКонтрагента',

        'Юридична' AS 'ВидОсоби',
        o.Note2 AS 'НазваКонтрагента',
        o.Code AS 'КодКонтрагента',
        o.TaxCode AS 'ІПН',
        305749 AS 'МФО',
        '2600530539322' AS 'ПоточРах',
        o.Phone AS 'Телефон',
        COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) AS 'GLN'
--[CHANGED] rkv0 '2020-11-19 14:21' заявка #2421. Меняю теги для сети Розетка: убираю "Отримувач", меняю "Видправник" на "Продавець".
/*
        UNION
        SELECT 
        'Отримувач' AS 'СтатусКонтрагента',
        'Юридична' AS 'ВидОсоби',
        RTRIM(CASE WHEN c.IsBranch = 1 THEN c.Contract2 ELSE c.Contract1 END) AS 'НазваКонтрагента',
        c.Code AS 'КодКонтрагента',
        c.TaxCode AS 'ІПН',
        rccc.BankID AS 'МФО',
        rccc.CompAccountCC AS 'ПоточРах',
        c.TaxPhone AS 'Телефон',
        COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) AS 'GLN'
*/    
        UNION
        SELECT 
        'Покупець' AS 'СтатусКонтрагента',
        'Юридична' AS 'ВидОсоби',
        RTRIM(CASE WHEN c.IsBranch = 1 THEN c.Contract2 ELSE c.Contract1 END) AS 'НазваКонтрагента',
        c.Code AS 'КодКонтрагента',
        c.TaxCode AS 'ІПН',
        rccc.BankID AS 'МФО',
        rccc.CompAccountCC AS 'ПоточРах',
        c.TaxPhone AS 'Телефон',
        COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) AS 'GLN'
        
        ) AS contragents

        FOR XML PATH ('Контрагент'), TYPE)
      FOR XML PATH ('Сторони'), TYPE
    ),
    (SELECT (
    (SELECT * FROM
      (SELECT 'Точка доставки' AS 'Параметр/@назва', 1 AS 'Параметр/@ІД', COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) AS 'Параметр'
      UNION
      SELECT 'Адреса доставки', 2, rca.CompAdd) params
      FOR XML PATH (''), TYPE))
    FOR XML PATH ('Параметри'), TYPE
    ),
    (SELECT (SELECT 
      ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS '@ІД',
      ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS 'НомПоз',
        (SELECT ROW_NUMBER() OVER(ORDER BY MAX(d0.PPID)) AS 'Штрихкод/@ІД',
        tpp.ProdBarCode AS 'Штрихкод'
        FROM dbo.t_InvD d0 WITH(NOLOCK)
        JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d0.ProdID AND tpp.PPID = d0.PPID
        WHERE d0.ChID = m.ChID AND d0.ProdID = dd.ProdID
        GROUP BY tpp.ProdBarCode
        FOR XML PATH (''), TYPE
        ),
      ec.ExtProdID AS 'АртикулПокупця',
      dd.ProdID AS 'АртикулПродавця',
      tpp.CstProdCode AS 'КодУКТЗЕД',
      p.Notes AS 'Найменування',

-- '2019-06-25 10:41' rkv0 добавил розетко-единицы в COMDOC.				
      --CAST(SUM(dd.Qty) AS NUMERIC(21,2)) AS 'ПрийнятаКількість',

      CASE WHEN RIGHT(SUBSTRING(CAST(SUM(ISNULL(CASE
                 WHEN  @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) 
			ELSE dd.Qty END,0)) AS varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))), 1) = '.' 
					 THEN SUBSTRING(CAST(SUM(ISNULL(
                 CASE 
                 WHEN  @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID)
				 ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))) + '0'
                 ELSE SUBSTRING(CAST(SUM(ISNULL(
                 CASE 
                 WHEN  @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID)
				 ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0)))))
            END  'ПрийнятаКількість',

      --p.UM AS 'ОдиницяВиміру',
      'шт' AS 'ОдиницяВиміру',

      --CAST(dd.PriceCC_nt AS NUMERIC(21,2)) AS 'БазоваЦіна',

    -- '2019-10-15 13:19' rkv0 делаю округление в одну строку (нет необходимости в длинных преобразованиях).
            CASE 
                 WHEN  @CompID=7138 THEN CAST(dd.PriceCC_nt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
			ELSE   dd.PriceCC_nt END 'БазоваЦіна',

/*            CASE WHEN RIGHT(SUBSTRING(CAST(
            CASE 
                 WHEN  @CompID=7138 THEN CAST(dd.PriceCC_nt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
			ELSE   dd.PriceCC_nt END AS varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt))), 1) = '.' 
                 THEN SUBSTRING(CAST(
                 CASE 
                 WHEN  @CompID=7138 THEN CAST(dd.PriceCC_nt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
				ELSE   dd.PriceCC_nt END as varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt))) + '0'
                 ELSE SUBSTRING(CAST(
                 CASE
                 WHEN  @CompID=7138 THEN CAST(dd.PriceCC_nt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
				ELSE   dd.PriceCC_nt END as varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt)))
            END 'БазоваЦіна',*/

      --CAST(dd.Tax AS NUMERIC(21,2)) AS 'ПДВ',

    -- '2019-10-15 13:19' rkv0 делаю округление в одну строку (нет необходимости в длинных преобразованиях).
            CASE 
                 WHEN  @CompID=7138 THEN cast(dd.Tax * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) as numeric(21,2))   
			ELSE dd.Tax END 'ПДВ',

/*                  CASE WHEN RIGHT(SUBSTRING(CAST(
            CASE 
                 WHEN  @CompID=7138 THEN cast(dd.Tax * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) as numeric(21,2))   
			ELSE   dd.Tax END AS varchar), 1, LEN(dd.Tax)+1 - PATINDEX('%[^0]%', REVERSE(dd.Tax))), 1) = '.' 
                 THEN SUBSTRING(CAST(
                 CASE
                 WHEN  @CompID=7138 THEN cast(dd.Tax * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) as numeric(21,2))   
				ELSE   dd.Tax END as varchar), 1, LEN(dd.Tax)+1 - PATINDEX('%[^0]%', REVERSE(dd.Tax))) + '0'
                 ELSE SUBSTRING(CAST(
                 CASE 
                     WHEN  @CompID=7138 THEN cast(dd.Tax * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) as numeric(21,2))   
				ELSE   dd.Tax END as varchar), 1, LEN(dd.Tax)+1 - PATINDEX('%[^0]%', REVERSE(dd.Tax)))
            END 'ПДВ',*/

      --CAST(dd.PriceCC_wt AS NUMERIC(21,2)) AS 'Ціна',
    -- '2019-10-15 13:19' rkv0 делаю округление в одну строку (нет необходимости в длинных преобразованиях).
            CASE 
                 WHEN  @CompID=7138 THEN CAST(dd.PriceCC_wt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
			ELSE dd.PriceCC_wt END 'Ціна',

/*                        CASE WHEN RIGHT(SUBSTRING(CAST(
            CASE 
                 WHEN  @CompID=7138 THEN CAST(dd.PriceCC_wt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
			ELSE   dd.PriceCC_wt END AS varchar), 1, LEN(dd.PriceCC_wt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_wt))), 1) = '.' 
                 THEN SUBSTRING(CAST(
                 CASE
                 WHEN  @CompID=7138 THEN CAST(dd.PriceCC_wt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
				ELSE   dd.PriceCC_wt END as varchar), 1, LEN(dd.PriceCC_wt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_wt))) + '0'
                 ELSE SUBSTRING(CAST(
                 CASE 
					 WHEN  @CompID=7138 THEN CAST(dd.PriceCC_wt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
				ELSE   dd.PriceCC_wt END as varchar), 1, LEN(dd.PriceCC_wt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_wt)))
            END 'Ціна',*/

      CAST(SUM(dd.SumCC_nt) AS NUMERIC(21,2)) AS 'ВсьогоПоРядку/СумаБезПДВ',

      CAST(SUM(dd.TaxSum) AS NUMERIC(21,2)) AS 'ВсьогоПоРядку/СумаПДВ',

      CAST(SUM(dd.SumCC_wt) AS NUMERIC(21,2)) AS 'ВсьогоПоРядку/Сума'

      FROM dbo.t_InvD dd WITH(NOLOCK)
      JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = dd.prodid
      JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = dd.ProdID AND tpp.PPID = dd.PPID
      LEFT JOIN dbo.at_r_CompOurTerms rcot WITH(NOLOCK) ON rcot.CompID = m.CompID AND rcot.OurID = m.OurID
      LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID=p.ProdID AND ec.CompID = rcot.BCompCode
      WHERE dd.ChID = m.ChID
      -- '2019-10-16 15:50' rkv0 убираем группировку по 3-м полям: dd.SumCC_nt, dd.TaxSum, dd.SumCC_wt
      GROUP BY ec.ExtProdID, dd.ProdID, tpp.CstProdCode, p.Notes, p.UM, dd.PriceCC_nt, dd.Tax, dd.PriceCC_wt/*, dd.SumCC_nt, dd.TaxSum, dd.SumCC_wt*/
    FOR XML PATH ('Рядок'), TYPE)
    FOR XML PATH ('Таблиця'), TYPE
    ),
    (SELECT CAST(SUM(SumCC_nt) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'ВсьогоПоДокументу/СумаБезПДВ',
    (SELECT CAST(SUM(TaxSum) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'ВсьогоПоДокументу/ПДВ',
    (SELECT CAST(SUM(SumCC_wt) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'ВсьогоПоДокументу/Сума'
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    CROSS APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) c
    LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
    LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    LEFT JOIN dbo.r_CompsCC rccc WITH(NOLOCK) ON rccc.CompID = m.CompID AND rccc.DefaultAccount = 1
    WHERE m.ChID = @ChID AND
    rca.GLNCode <> '' AND
    (ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    m.TaxDocID <> 0 AND
    ir.OrderID IS NOT NULL AND ir.OrderID != ''
    FOR XML PATH ('ЕлектроннийДокумент'))
    
    END;  
  

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*COMDOC_METRO (Коммерческий документ: товарная накладная document_invoice)*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ELSE IF @DocType = 'COMDOC_METRO' --товарная накладная (Document Invoice) - в EDI используется только сетью METRO
    BEGIN
    
	DECLARE @SQL_Select NVARCHAR(MAX), @OutByDynamicSQLRecadvNumber VARCHAR(50)

	SET @SQL_Select = 'SELECT @outs = (SELECT aerf.ID FROM [s-ppc.const.alef.ua].[Alef_Elit].[dbo].[at_EDI_reg_files] aerf WHERE Notes LIKE m.OrderID + ''%'' AND aerf.doctype = 5000 AND aerf.RetailersID = 17)'
					+ ' FROM dbo.t_Inv m WITH(NOLOCK) '
					+ ' WHERE m.ChID = ' + CAST(@ChID AS VARCHAR(10))

	EXEC sp_executesql @SQL_Select, N'@outs VARCHAR(50) OUT', @OutByDynamicSQLRecadvNumber OUT 
	
	SET @Out = (
    SELECT
	  'DocumentInvoice' AS '@class', --атрибут class
      --tag 'Invoice-Header'
      
      -- '2019-12-13 13:46' rkv0 добавляю к номеру товарной накладной 3 рандомных числа (миллисекунды) для возможности повторной отправки товарной (один и тот же номер они не примут).
      --CAST(m.DocID AS VARCHAR(16)) + '-' + right(CONVERT(varchar,GETDATE(),114),3) AS 'Invoice-Header/InvoiceNumber', --InvoiceNumber - номер документа DocID(Len  <= 15)
      -- [CHANGED] '2020-07-08 18:02' rkv0 убираем нули (письмо от Гали Танцюры: "сеть МЕТРО не принимает на подпись товарные с нулями в начале").
      --RIGHT('0000000000' + (SELECT
      (SELECT
      CASE 
        WHEN (SELECT COUNT(*) FROM #invnum WHERE InvNum LIKE (cast(m.DocID as varchar(16)) + '%')) = 0 THEN CAST(m.DocID AS varchar(16))
        --SELECT COUNT(*) FROM #invnum WHERE InvNum LIKE (cast('3275957' as varchar(16)) + '%')
        ELSE
        (SELECT CAST(m.DocID AS varchar(16)) + '-' + CAST(COUNT(*) AS varchar(100)) FROM #invnum WHERE InvNum LIKE (cast(m.DocID as varchar(16)) + '%'))
        END)
        AS 'Invoice-Header/InvoiceNumber', --InvoiceNumber - номер документа DocID(Len  <= 15)
      
      CAST(m.DocDate AS DATE) AS 'Invoice-Header/InvoiceDate', --InvoiceDate - дата документа (CCYY-MM-DD) DocDate
	  'UAH' AS 'Invoice-Header/InvoiceCurrency', --Валюта
	  CONVERT(date, getdate()) AS 'Invoice-Header/InvoicePostDate', --Дата отправки документа
	  LEFT(CONVERT(time, getdate()),5) AS 'Invoice-Header/InvoicePostTime', --Время отправки документа
	  'TN' AS 'Invoice-Header/DocumentFunctionCode', --Код типа документа (TN - товарная накладная, CTN - корректировочня товарная накладная)
 	  CASE WHEN m.CompID = 7001 THEN 24479 WHEN m.CompID = 7003 THEN 24535 ELSE 0 END  AS 'Invoice-Header/ContractNumber', --№ договора поставки (24535 - алкоголь, 24479 -  вода).
	  --tag 'Invoice-Reference'
	 m.OrderID 'Invoice-Reference/Order/BuyerOrderNumber', --Номер заказа (восьмизначное число, поле не может содержать только нули)
	 m.TaxDocID 'Invoice-Reference/TaxInvoice/TaxInvoiceNumber', --Номер налоговой накладной
	 CAST(m.TaxDocDate AS DATE) 'Invoice-Reference/TaxInvoice/TaxInvoiceDate', --Дата налоговой накладной (дата налоговой накладной должна совпадать с датой товарной накладной)
	 m.TaxDocID 'Invoice-Reference/DespatchAdvice/DespatchAdviceNumber', --Номер уведомления об отгрузке
	 --Maslov Oleg '2019-11-14 15:43:02.967' Перевел на динамику, так как возникала ошибка, когда простые пользователи пытались использовать инструмент по отправке документов.
	 --(SELECT aerf.ID FROM [s-ppc.const.alef.ua].[Alef_Elit].[dbo].[at_EDI_reg_files] aerf WHERE Notes = m.OrderID AND aerf.doctype = 5000 AND aerf.RetailersID = 17) 'Invoice-Reference/ReceivingAdvice/ReceivingAdviceNumber', --Номер уведомления о приеме
	  ISNULL(@OutByDynamicSQLRecadvNumber, '') 'Invoice-Reference/ReceivingAdvice/ReceivingAdviceNumber', --Номер уведомления о приеме
	  --tag 'Invoice-Parties'
	  --покупатель
     --[CHANGED] rkv0 '2020-11-10 19:46' изменил тег sender-buyer (для подвязки документов в цепочку). ##RE-433##
     --COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)'), ir.GLNCode)  AS 'Invoice-Parties/Buyer/ILN', --GLN покупателя [0-9](13) (можно взять здесь: at_t_IORecX)
     COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'), ir.GLNCode)  AS 'Invoice-Parties/Buyer/ILN', --GLN покупателя [0-9](13) (можно взять здесь: at_t_IORecX)
	 c.TaxCode AS 'Invoice-Parties/Buyer/TaxID', --Налоговый идентификационный номер покупателя
	 c.Code AS 'Invoice-Parties/Buyer/UtilizationRegisterNumber', --ЄДРПОУ покупателя (не должен превышать 8 знаков)
	 c.Contract1 AS 'Invoice-Parties/Buyer/Name', --Название покупателя
	 [c].[Address] AS 'Invoice-Parties/Buyer/StreetAndNumber', --Улица и номер дома покупателя
	 c.City AS 'Invoice-Parties/Buyer/CityName', --Город покупателя
	 c.PostIndex AS 'Invoice-Parties/Buyer/PostalCode', --Почтовый код покупателя
	 '804' AS 'Invoice-Parties/Buyer/Country', --Код страны покупателя (код ISO 3166) --https://www.iso.org/obp/ui/#search/code/
	 c.Phone1 AS 'Invoice-Parties/Buyer/PhoneNumber', --Телефон покупателя
	 --продавец
     COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode)  AS 'Invoice-Parties/Seller/ILN', --GLN продавца [0-9](13) (можно взять здесь: at_t_IORecX)
	 o.TaxCode AS 'Invoice-Parties/Seller/TaxID', --Налоговый идентификационный номер продавца
	 zc.ContrID AS 'Invoice-Parties/Seller/CodeByBuyer', --Код продавца (значение поля должно быть 5-значным числом)
	 o.Code AS 'Invoice-Parties/Seller/UtilizationRegisterNumber', --ЄДРПОУ продавца (не должен превышать 8 знаков)
	 o.OurName AS 'Invoice-Parties/Seller/Name', --Название продавца
	 [o].[Address] AS 'Invoice-Parties/Seller/StreetAndNumber', --Улица и номер дома продавца
	 o.City AS 'Invoice-Parties/Seller/CityName', --Город продавца
	 o.PostIndex AS 'Invoice-Parties/Seller/PostalCode', --Почтовый код продавца
	 '804' AS 'Invoice-Parties/Seller/Country', --Код страны продавца (код ISO 3166)
	 o.Phone AS 'Invoice-Parties/Seller/PhoneNumber', --Телефон продавца
     COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) AS 'Invoice-Parties/DeliveryPoint/ILN', --GLN точки доставки [0-9](13) (можно взять здесь: at_t_IORecX)
     
     -- '2019-11-28 13:30' rkv0 прописываем константой "77" - доставка только на этот РЦ в Киеве (на магазины Василенко делает заказы через КПК). 
     --COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPOINT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPOINT)[1]', 'VARCHAR(13)'), rca.GLNCode) AS 'Invoice-Parties/DeliveryPoint/DeliveryPlace', --Код точки доставки (len < 2)
     '77' AS 'Invoice-Parties/DeliveryPoint/DeliveryPlace', --Код точки доставки (len < 2); РЦ в Киеве; GLN: 4820086639309, Local 77 DFNF BBXD FM Kyiv, Адрес: 08330 Київська обл., Бориспільський р-н, с. Дударків вул. Незалежності, 2/2. rkv0 Захардкодил '77', т.к. тяжело это парсить из поля GLNName (ни разу еще не менялось).
     
     -- '2019-11-28 14:10' rkv0 добавляю тег Invoicee ILN
     COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'), ir.GLNCode)  AS 'Invoice-Parties/Invoicee/ILN', --GLN для выставления счета [0-9](13) (можно взять здесь: at_t_IORecX)
     
     COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'), ir.GLNCode)  AS 'Invoice-Parties/Payer/ILN', --GLN плательщика [0-9](13) (можно взять здесь: at_t_IORecX)

      --tag 'Invoice-Lines' (перечень товаров с количеством и ценами)
      (SELECT 
      ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS 'Line-Item/LineNumber', --Номер позиции
      tpp.ProdBarCode AS 'Line-Item/EAN', --Штрих-код [0-9](14)
      ec.ExtProdID AS 'Line-Item/BuyerItemCode', --Код, идентифицирующий товар у покупателя, поле цифровое, не может содержать точки и только нули
      dd.ProdID AS 'Line-Item/SupplierItemCode',--Код, идентифицирующий товар у продавца
      tpp.CstProdCode AS 'Line-Item/ExternalItemCode', --Код товара согласно УКТ ВЭД
      --[FIXED] rkv0 '2020-11-13 10:47' для сети METRO делаю замену символа "+" на пустоту "".
      --p.Notes AS 'Line-Item/ItemDescription', --Описание товара (системой не допускаются знаки („+"; " ' "; „:" )
      REPLACE(p.Notes,'+', '') AS 'Line-Item/ItemDescription', --Описание товара (системой не допускаются знаки („+"; " ' "; „:" )
      CAST(SUM(dd.Qty) AS NUMERIC(21,3)) AS 'Line-Item/InvoiceQuantity', --Количество товара по накладной (3 знака после запятой!)
      'PCE' AS 'Line-Item/UnitOfMeasure', --Единицы измерения
      CAST(dd.PriceCC_nt AS NUMERIC(21,2)) AS 'Line-Item/InvoiceUnitNetPrice', --Цена одной единицы без НДС
      CAST(20 as NUMERIC(21,2)) AS 'Line-Item/TaxRate', --Ставка НДС
      'S' AS 'Line-Item/TaxCategoryCode', --Код категория НДС: "E" (освобожден) – освобожден от уплаты налога, "S" (стандарт) – стандартный налог
      CAST(SUM(dd.TaxSum) AS NUMERIC(21,2)) AS 'Line-Item/TaxAmount', --Сумма налога
      CAST(SUM(dd.SumCC_nt) AS NUMERIC(21,2)) AS 'Line-Item/NetAmount' --Сумма без НДС,
	       
      FROM dbo.t_InvD dd WITH(NOLOCK)

      JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = dd.prodid
      JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = dd.ProdID AND tpp.PPID = dd.PPID
      LEFT JOIN dbo.at_r_CompOurTerms rcot WITH(NOLOCK) ON rcot.CompID = m.CompID AND rcot.OurID = m.OurID
      LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID=p.ProdID AND ec.CompID = rcot.BCompCode
      WHERE dd.ChID = m.ChID
      -- '2019-10-16 15:50' rkv0 убираем группировку по полю: dd.SumCC_wt
      GROUP BY ec.ExtProdID, dd.ProdID, tpp.CstProdCode, p.Notes, p.UM, dd.PriceCC_nt, tpp.ProdBarCode, dd.TaxSum, dd.SumCC_nt /*dd.SumCC_wt*/
    
    FOR XML PATH ('Line'), TYPE, ROOT ('Invoice-Lines')),

    --tag 'Invoice-Summary'
    -- '2019-12-11 19:17' rkv0 изменил CAST(MAX(SrcPosID) AS int) на COUNT(ChID) 
    --(SELECT CAST(MAX(SrcPosID) AS int) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/TotalLines', --Количество строк в документе
    -- [FIXED] rkv0 '2020-09-28 10:55' TotalLines считать надо по количеству строк в расходной.
    --(SELECT count(distinct ProdID) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/TotalLines', --Количество строк в документе
    (SELECT count(*) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/TotalLines', --Количество строк в документе
    (SELECT CAST(SUM(SumCC_nt) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/TotalNetAmount', --Общая сумма без НДС
    (SELECT CAST(SUM(TaxSum) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/TotalTaxAmount', --Сумма НДС
    (SELECT CAST(SUM(SumCC_wt) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/TotalGrossAmount', --Общая сумма с НДС
    CAST(20 as decimal(19,2)) AS 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxRate', --Размер налога
    'S' AS 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxCategoryCode', --Код категория НДС: "E" (освобожден) – освобожден от уплаты налога, "S" (стандарт) – стандартный налог
    (SELECT CAST(SUM(TaxSum) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxAmount', --Сумма налога для каждой категории налога
    (SELECT CAST(SUM(SumCC_nt) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxableAmount' --Налогооблагаемая сумма по выбранной категории налога

    FROM dbo.t_Inv m WITH(NOLOCK)

    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    CROSS APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) c
    LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
    LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    LEFT JOIN dbo.r_CompsCC rccc WITH(NOLOCK) ON rccc.CompID = m.CompID AND rccc.DefaultAccount = 1
    

    WHERE m.ChID = @ChID AND
    rca.GLNCode <> '' AND
    (ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    m.TaxDocID <> 0 AND
    ir.OrderID IS NOT NULL AND ir.OrderID != ''
    FOR XML PATH ('Document-Invoice'))

    END;
  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*PACKAGE_METRO (XML для архива)*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ELSE IF @DocType = 'PACKAGE_METRO' ----создает package.xml для documentpacket (отправка пакета для сети Metro).

    BEGIN
    
    SET @Out = (
    SELECT
    'optional название правила проверки, сейчас только METROUZD' as 'comment()', --добавляем комментарий (см. выше)
    'METROUZD' as 'processingRule', --<!-- optional название правила проверки, сейчас только METROUZD-->
    
    --вставляем №DECLAR
    (SELECT 
    'атрибуты crypted  signed signExternal опциональны, и сейчас не используются, понадобятся при дальнейших доработках' as 'comment()', --добавляем комментарий (см. выше)
    'false' as 'document/@crypted',
    'true' as 'document/@signed',
    'false' as 'document/@signExternal',

    -- '2019-12-11 18:34' rkv0 добавил DISTINCT для возможности повторной отправки DECLAR.
    (SELECT DISTINCT REPLACE([FileName], 'xml', 'p7s') 
    FROM at_z_FilesExchange 
    WHERE FileName LIKE '%J12%' 
    AND FileData.value('(./DECLAR/DECLARBODY/HNUM)[1]', 'varchar(10)') = (SELECT TaxDocID FROM t_inv WHERE CompID IN (7001,7003) AND ChID = @ChID)
    AND FileData.value('(./DECLAR/DECLARBODY/HFILL)[1]', 'varchar(10)') = (SELECT REPLACE(dbo.zf_DateToStr(TaxDocDate), '.', '') FROM t_inv WHERE CompID IN (7001,7003) AND ChID = @ChID)) as 'document/documentFileName'

    FOR XML PATH (''), TYPE), --TYPE – возвращает сформированные XML данные с типом XML, если параметр TYPE не указан, данные возвращаются с типом NVARCHAR(MAX).

    --вставляем №COMDOC
    'true' as 'document/@crypted',
    'true' as 'document/@signed',
    'false' as 'document/@signExternal',
    
    (SELECT REPLACE([FileName], 'xml', 'p7s') 
    FROM at_z_FilesExchange 
    WHERE FileName LIKE '%documentinvoice%' 
    AND FileData.value('(./Document-Invoice/Invoice-Reference/Order/BuyerOrderNumber)[1]', 'varchar(13)') = 
    (
    SELECT OrderID FROM t_inv WHERE CompID IN (7001,7003) AND ChID = @ChID
    )
    -- '2019-12-11 18:31' rkv0 выбираем последнюю chid на случай повторной отправки documentinvoice
    AND ChID = (SELECT MAX(ChID) FROM at_z_FilesExchange WHERE FileName LIKE '%documentinvoice%' 
    AND FileData.value('(./Document-Invoice/Invoice-Reference/Order/BuyerOrderNumber)[1]', 'varchar(13)') = 
    (
    SELECT OrderID FROM t_inv WHERE CompID IN (7001,7003) AND ChID = @ChID
    ) 
    )) as 'document/documentFileName'


    FOR XML PATH ('packet'), TYPE    
    )

    END;

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DECLAR (Коммерческий документ: налоговая накладная)*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ELSE IF @DocType = 'DECLAR'
        EXEC [dbo].[ap_EXITE_TaxDoc] @ChID = @ChID, @DocCode = @DocCode, @IsConsolidated = 0, @Out = @Out OUT;
         
  IF @DocType = 'DESADV'
    SET @Out = @Desadv
END;























GO
