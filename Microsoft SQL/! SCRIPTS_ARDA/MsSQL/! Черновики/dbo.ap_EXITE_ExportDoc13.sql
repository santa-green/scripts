USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EXITE_ExportDoc]    Script Date: 20.08.2021 17:03:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[ap_EXITE_ExportDoc] @DocType VARCHAR(20)
,                                     @DocCode INT         = 11012
,                                     @ChID INT           
,                                     @Out XML             OUT
,                                     @TOKEN INT           OUT
AS

--#region DESCRIPTION
/*
ПРОЦЕДУРА ВЫГРУЗКИ ДОКУМЕНТА EXITE ПО ЕГО ТИПУ @DOCTYPE И КОДУ РЕГИСТРАЦИИ @CHID
--XML СПЕЦИФИКАЦИЯ--https://wiki.edin.ua/uk/latest/XML/XML-structure.html#comdoc-006

При изменении версии налоговой изменить надо следующее:
Номер версии ([ap_EXITE_TaxDoc])
Имя схемы ([ap_EXITE_TaxDoc]).
@DocType='PACKAGE_METRO'ap_EXITE_ExportDoc
Название файла (ap_EXITE_CreateMessage).
ps скрипты: Export_Declar_new_logs.ps1, Export_Declar_new_logs_METRO.ps1

Для медка другая процедура (там другая спецификация): [ap_Export_J1201012]
*/
--#endregion DESCRIPTION
--#region ТЕСТ
/*
DECLARE @xml XML, @token INT; EXEC ap_EXITE_ExportDoc @DocType='DECLAR', @DocCode=11012, @ChID=200373969,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token 'Token', @xml 'XML';
DECLARE @xml XML, @token INT; EXEC ap_EXITE_ExportDoc @DocType='INVOICE', @DocCode=11012, @ChID=200430088,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token 'Token', @xml 'XML';
DECLARE @xml XML, @token INT; EXEC ap_EXITE_ExportDoc @DocType='PACKAGE_METRO', @DocCode=11012, @ChID=200479794,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token 'Token', @xml 'XML';
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='ORDRSP', @DocCode=11012, @ChID=200497472,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;

DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='ORDRSP', @DocCode=11012, @ChID=200495043 /*СИЛЬПО*/,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='ORDRSP', @DocCode=11012, @ChID=200503225 /*ФУДКОМ*/,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
SELECT * FROM at_t_InvLoad WHERE chid = '200495043'
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='DESADV', @DocCode=11012, @ChID=200519842,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='COMDOC_ROZETKA', @DocCode=11012, @ChID=200533707,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
DECLARE @xml XML, @token INT; EXEC ap_EXITE_ExportDoc @DocType='COMDOC_METRO', @DocCode=11012, @ChID=200532466,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token 'Token', @xml 'XML';
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='COMDOC_PUZO', @DocCode=11012, @ChID=200460947,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='IFTMIN', @DocCode=11012, @ChID=200468496,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='CONTRL', @DocCode=11012, @ChID=200479574,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
*/
--#endregion ТЕСТ
--#region CHANGELOG
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
-- [FIXED] rkv0 '2020-11-13 10:47' для сети METRO делаю замену символа "+" на пустоту "".
-- [CHANGED] rkv0 '2020-11-19 14:21' заявка #2421. Меняю теги для сети Розетка: убираю "Отримувач", меняю "Видправник" на "Продавець".
-- [ADDED] rkv0 '2020-12-02 18:24' добавляю 2 тега для сети СИЛЬПО: ORDRSPNUMBER (Строка (16)-Номер подтверждения заказа), ORDRSPDATE(Дата (ГГГГ-ММ-ДД)-Дата подтверждения заказа).
-- [CHANGED] rkv0 '2020-12-03 17:19' сделал этот тег = 1 по умолчанию, т.к. он является optional для всех сетей, кроме Сильпо (для Invoice Matching - он mandatory).
-- [ADDED] rkv0 '2020-12-03 17:35' добавил отдельную ветку по тегу TRANSPORTID для Сильпо и остальных сетей.
-- [ADDED] rkv0 '2020-12-03 17:46' теперь этот тег является обязательным для сети Сильпо, поэтому делаю его для всех сетей сразу.
-- [ADDED] rkv0 '2020-12-03 18:08' джойним еще 2 таблицы для добавления тега CAMPAIGNNUMBER (обязательный тег для Сильпо).
-- [ADDED] rkv0 '2020-12-03 18:08' добавил теги: TIME, CURRENCY, INFO, CAMPAIGNNUMBER (обязательные для Сильпо)
-- [ADDED] rkv0 '2020-12-02 18:24' добавляю 2 тега для сети СИЛЬПО: ORDRSPNUMBER (Строка (16)-Номер подтверждения заказа), ORDRSPDATE(Дата (ГГГГ-ММ-ДД)-Дата подтверждения заказа).
-- [ADDED] rkv0 '2020-12-03 18:30' добавил тег INVOICEPARTNER (GLN платника). Обязательный для Сильпо.
-- [ADDED] rkv0 '2020-12-04 13:37' добавил новый документ IFTMIN (Инструкция по транспортировке) для сети Сильпо (Фоззи).
-- [ADDED] rkv0 '2020-12-07 18:48' добавил новый документ CONTRL (Отчет об отгрузке) для сети Сильпо (Фоззи).
-- [ADDED] rkv0 '2021-01-16 16:37' добавил для сети "Велике Пузо".
-- [CHANGED] rkv0 '2021-03-04 18:50' переместил блок для формирования номера товарной накладной в блок ELSE IF @DocType = 'COMDOC_METRO' (был в шапке данной процедуры). Заявка ##RE-5406##
-- [FIXED] '2021-03-11 15:57' rkv0 изменил varchar на int.
--[ADDED] '2021-03-16 12:47' rkv0 добавил в условие DocSum != 0 (для отсекания нулевых RECADV, которые высылает METRO).
--[FIXED] '2021-03-17 17:21' rkv0 изменил условие для нового формата налоговой (для исключения наложения файлов старой и новой версии).
-- [CHANGED] '2021-03-24 15:28' rkv0 изменил тег SENDER.
--[ADDED] rkv0 '2021-05-31 10:59' для предприятий 7004, 7144, 7001, 7003, 7142 тянем дату с поля "Погрузка" (заявка #7260).
--[ADDED] '2021-08-17 17:42' rkv0 добавил проверку на отвязаные коды (##RE-9698##).


--#endregion CHANGELOG
--#region PROCEDURE
BEGIN

	--#region Блок объявления переменных
	SET NOCOUNT ON
	DECLARE @CompID    INT          
	,       @CompName  VARCHAR(250) 
	,       @CompAddID INT          
	,       @DocID     INT          
	,       @Msg       VARCHAR(250) 
	,       @Msg1      VARCHAR(250) 
	,       @TblName   VARCHAR(250)  = (SELECT TableName
	FROM dbo.z_Tables
	WHERE TableCode = @DocCode * 1000 + 1)
	,       @TblNameD  VARCHAR(250)  = (SELECT TableName
	FROM dbo.z_Tables
	WHERE TableCode = @DocCode * 1000 + 2)
	,       @SQL       NVARCHAR(MAX)
	,       @O         VARCHAR(250) 

	EXEC dbo.z_DocLookup 'CompID'
	,                    @DocCode
	,                    @ChID
	,                    @CompID OUT
	EXEC dbo.z_DocLookup 'CompAddID'
	,                    @DocCode
	,                    @ChID
	,                    @CompAddID OUT
	EXEC dbo.z_DocLookup 'DocID'
	,                    @DocCode
	,                    @ChID
	,                    @DocID OUT

	SELECT @CompName = CompName
	FROM dbo.r_Comps WITH(NOLOCK)
	WHERE CompID = @CompID
	OPTION(FAST 1)

	SET @TOKEN = CAST(LEFT(CAST(@CompID AS VARCHAR(250)) + '000000000', 9) AS INT) + ISNULL(CAST((SELECT TOP 1 VarValue
	FROM dbo.r_CompValues WITH(NOLOCK)
	WHERE VarName = 'EDIINTERCHANGEID'
		AND CompID = @CompID) AS INT),0) + 1
	--#endregion Блок объявления переменных
	--#region Блок проверок
    --[ADDED] '2021-08-17 17:42' rkv0 добавил проверку на отвязаные коды (##RE-9698##).
    IF @DocType IN ('ORDRSP', 'DESADV', 'INVOICE')
    AND EXISTS (
    SELECT 1
    FROM      elit_test..t_InvD tid
    JOIN      t_inv             ti  ON ti.ChID = tid.ChID
    LEFT JOIN r_prodec          pr  ON ti.compid = pr.compid
		    and tid.ProdID = pr.prodid
    WHERE tid.ChID = @ChID
	    and (
		    pr.extprodid IN ('', '0')
		    OR pr.prodid IS NULL)
    )
	BEGIN
        DECLARE @prod_list varchar(max)
        SELECT @prod_list = COALESCE(@prod_list + ', ' , '') + CAST(tid.prodid AS varchar)
        FROM      elit_test..t_InvD tid
        JOIN      t_inv             ti  ON ti.ChID = tid.ChID
        LEFT JOIN r_prodec          pr  ON ti.compid = pr.compid
		        and tid.ProdID = pr.prodid
        WHERE tid.ChID = @ChID
	        and (
		        pr.extprodid IN ('', '0')
		        OR pr.prodid IS NULL)
        --SELECT @prod_list
		RAISERROR('[dbo].[ap_EXITE_ExportDoc] По товарам (%s) отсутствует артикул покупателя в Справочнике товаров / Внешние коды по данному предприятию!»', 18, 1, @prod_list)
		RETURN
	END;
    
    IF NOT EXISTS(SELECT *
		FROM dbo.r_Uni WITH(NOLOCK)
		WHERE RefTypeID = 80019
			AND RefID = @CompID)
	BEGIN
		RAISERROR('[dbo].[ap_EXITE_ExportDoc] Для данного контрагента "%s" (%u) невозможно отправить сообщение "%s", 
    так как для него не заполнен "Список допустимых сообщений" (Справочник универсальный "80019").', 18, 1, @CompName, @CompID, @DocType)
		RETURN
	END

	SET @Out = NULL
	SET @SQL = N'SELECT TOP 1 @O = 1 FROM dbo.' + @TblNameD + N' WHERE ChID = @C AND Qty = 0 OPTION(FAST 1)'
	EXEC sp_executesql @SQL
	,                  N'@O INT OUT, @C INT'
	,                  @O OUT
	,                  @ChID

	IF @Out IS NOT NULL
	BEGIN
		RAISERROR('[dbo].[ap_EXITE_ExportDoc] В документе %u присутствует товар с количеством = 0. Экспорт отменён.', 18, 1, @DocID)
		RETURN
	END

	SET @Out = NULL
	SET @SQL = N'SELECT TOP 1 @O = 1 FROM dbo.' + @TblName + N' WHERE ChID = @C AND TaxDocID = 0 OPTION(FAST 1)'
	EXEC sp_executesql @SQL
	,                  N'@O INT OUT, @C INT'
	,                  @O OUT
	,                  @ChID
	IF @Out IS NOT NULL
	BEGIN
		RAISERROR('[dbo].[ap_EXITE_ExportDoc] В документе %u не установлен номер налоговой накладной. Экспорт отменён.', 18, 1, @DocID)
		RETURN
	END

	IF @DocType = 'INVOICE'
		AND @DocCode = 11012
	BEGIN
		IF EXISTS(SELECT *
			FROM dbo.t_Inv m 
			JOIN r_Comps   rc ON rc.CompID = m.ChID
			WHERE m.ChID = @ChID
				AND rc.Code = '32049199'
				AND NOT (
					m.SrcDocID IS NOT NULL
					AND (
						m.SrcDocID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
						OR m.SrcDocID LIKE '[0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')))
		BEGIN
			RAISERROR('[dbo].[ap_EXITE_ExportDoc] В накладной %u не установлен номер "Зелёной марки". Экспорт отменён.', 18, 1, @DocID)
			RETURN
		END
	END
	ELSE IF @DocType IN ('DESADV', 'ORDRSP')
			AND @DocCode = 11012
		BEGIN
			IF EXISTS(SELECT *
				FROM dbo.t_Inv m 
				JOIN r_Comps   rc ON rc.CompID = m.ChID
				WHERE m.ChID = @ChID
					AND rc.Code IN ('36387249','38916558'))
				AND NOT EXISTS(SELECT *
				FROM dbo.at_t_InvLoad
				WHERE ChID = @ChID
					AND BoxQty IS NOT NULL
					AND ISNUMERIC(BoxQty) = 1
					AND PalQty IS NOT NULL
					AND ISNUMERIC(PalQty) = 1
					AND CarQty IS NOT NULL
					AND ISNUMERIC(CarQty) = 1)
			BEGIN
				RAISERROR('[dbo].[ap_EXITE_ExportDoc] В накладной %u не заполонена логистическая информация. Экспорт отменён.', 18, 1, @DocID)
				RETURN
			END
		END

	IF @DocCode = 11012
		AND EXISTS(SELECT *
		FROM dbo.t_InvD d               
		JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d.ProdID
				AND tpp.PPID = d.PPID
		WHERE ChID = @ChID
			AND (
				tpp.ProdBarCode = ''
				OR tpp.ProdBarCode IS NULL))
	BEGIN
		SELECT @Msg = d.ProdID
		,      @Msg1 = d.PPID
		FROM dbo.t_InvD d               
		JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d.ProdID
				AND tpp.PPID = d.PPID
		WHERE ChID = @ChID
			AND (
				tpp.ProdBarCode = ''
				OR tpp.ProdBarCode IS NULL)
		RAISERROR('[dbo].[ap_EXITE_ExportDoc] В накладной %u для товара %s в партии %s не заполнено поле "Штрих-код производителя". Экспорт отменён.', 18, 1, @DocID, @Msg, @Msg1)
		RETURN
	END

	IF EXISTS(SELECT *
		FROM dbo.r_Uni WITH(NOLOCK)
		WHERE RefTypeID = 80019
			AND RefID = @CompID)
		IF NOT EXISTS(SELECT *
			FROM dbo.r_Uni WITH(NOLOCK)
			WHERE RefTypeID = 80019
				AND RefID = @CompID
				AND Notes LIKE '%' + @DocType + '%')
		BEGIN
			RAISERROR('[dbo].[ap_EXITE_ExportDoc] Для данного контрагента "%s" (%u) невозможно отправить сообщение "%s", так как контрагент не принимает сообщений такого типа. 
        Список допустимых сообщений можно уточнить, нажав на кнопку "?" окна параметров инструмента (потребуется Adobe Reader).', 18, 1, @CompName, @CompID, @DocType)
			RETURN
		END

	DECLARE @OrdChID INT = dbo.af_GetParentChID(@DocCode, @ChID, 11221)
/*ВРЕМЕННО для отправки одного документа*/ IF SUSER_NAME() NOT IN ('CORP\rumyantsev')
/*ВРЕМЕННО для отправки одного документа*/ BEGIN
	IF @DocCode = 11012
        IF NOT EXISTS(SELECT *
			FROM (SELECT CAST(di.ProdID AS VARCHAR(20)) ProdID
			,            irec.ExtProdID                
			FROM      dbo.t_IORecD di WITH(NOLOCK)  
			LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID
					AND irec.CompID = @CompID
			WHERE ChID = @OrdChID
			GROUP BY di.ProdID
			,        irec.ExtProdID
			HAVING SUM(di.Qty) > 0)                                              ird
			JOIN (SELECT ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20))) ProdID
				,        irec.ExtProdID                                        
				,        tpp.ProdBarCode                                       
				,        SUM(Qty)                                               Qty
				FROM      dbo.t_InvD   di WITH(NOLOCK)  
				LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID
						AND irec.CompID = @CompID
				JOIN      dbo.t_PInP   tpp WITH(NOLOCK)  ON tpp.ProdID = di.ProdID
						AND tpp.PPID = di.PPID
				WHERE ChID = @ChID
				GROUP BY irec.ExtProdID
				,        tpp.ProdBarCode
				,        ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20)))) dd  ON (
						dd.ProdID = ird.ProdID
						AND dd.ExtProdID IS NULL)
					OR (
						dd.ProdID = ird.ExtProdID
						AND dd.ExtProdID IS NOT NULL))
		BEGIN
			RAISERROR('[dbo].[ap_EXITE_ExportDoc] Накладная %u не содержит какого-либо заказанного контрагентом товара. Экспорт отменён.', 18, 1, @DocID)
			RETURN
		END
/*ВРЕМЕННО для отправки одного документа*/ END;
	--#endregion Блок проверок

	--#region INVOICE (счет-фактура)
	IF @DocType = 'INVOICE'
	BEGIN
		/* Документ INVOICE */
		SET @Out = (
		SELECT 380                                                      'DOCUMENTNAME'
		,      CAST(m.TaxDocID AS INT)                                  'NUMBER'
		,      CAST(m.TaxDocDate AS DATE)                               'DATE'
		,      CAST(m.TaxDocDate AS DATE)                               'DELIVERYDATE'
		,      NULL                                                     'DELIVERYTIME'
		,      'UAH'                                                    'CURRENCY'
		,      CASE WHEN ir.OrderID LIKE '%[_]non-alc'
			OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '')
		                                 ELSE ir.OrderID END            'ORDERNUMBER'
		,      irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'ORDERDATE'
		,      CAST(m.TaxDocID AS INT)                                  'DELIVERYNOTENUMBER'
		,      CAST(m.TaxDocDate AS DATE)                               'DELIVERYNOTEDATE'
		,      CASE WHEN c.Code = '32049199'
			AND m.SrcDocID IS NOT NULL
			AND (
				m.SrcDocID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				OR m.SrcDocID LIKE '[0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')
			AND m.SrcDocID != ir.OrderID THEN m.SrcDocID END            'PAYMENTORDERNUMBER'
		,      zc.ContrID                                               'CAMPAIGNNUMBER'
		,      LTRIM(RTRIM(o.TaxCode))                                  'FISCALNUMBER'
		,      LTRIM(RTRIM(o.Code))                                     'REGISTRATIONNUMBER'
		,      ISNULL((SELECT SUM(SumCC_nt)
		FROM dbo.t_InvD WITH(NOLOCK)
		WHERE ChID = m.ChID),0)                                         'GOODSTOTALAMOUNT'
		,      ISNULL((SELECT SUM(SumCC_nt)
		FROM dbo.t_InvD WITH(NOLOCK)
		WHERE ChID = m.ChID),0)                                         'POSITIONSAMOUNT'
		,      ISNULL((SELECT SUM(TaxSum)
		FROM dbo.t_InvD WITH(NOLOCK)
		WHERE ChID = m.ChID),0)                                         'VATSUM'
		,      ISNULL((SELECT SUM(SumCC_wt)
		FROM dbo.t_InvD WITH(NOLOCK)
		WHERE ChID = m.ChID),0)                                         'INVOICETOTALAMOUNT'
		,      ISNULL((SELECT SUM(SumCC_nt)
		FROM dbo.t_InvD WITH(NOLOCK)
		WHERE ChID = m.ChID
			AND Tax > 0),0)                                             'TAXABLEAMOUNT'
		,      CAST(ISNULL((SELECT SUM(TaxSum)
		FROM dbo.t_InvD WITH(NOLOCK)
		WHERE ChID = m.ChID
			AND Tax > 0) / (SELECT SUM(SumCC_nt)
		FROM dbo.t_InvD WITH(NOLOCK)
		WHERE ChID = m.ChID
			AND Tax > 0),0) * 100 AS INT)                               'VAT'
		,      (
		SELECT COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode)            'SUPPLIER'
		,      COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'))                              'BUYER'
		,      COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'DELIVERYPLACE'
		,      COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode)            'CONSEGNOR'
		,      COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'CONSIGNEE'
		,      COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), ir.GLNCode)          'SENDER'
		,      COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)'))                            'RECIPIENT'
		,      @TOKEN                                                                                                                                                    'EDIINTERCHANGEID'
		,      (
		SELECT ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID))                'POSITIONNUMBER'
		,      tpp.ProdBarCode                                             'PRODUCT'
		,      dd.ProdID                                                   'PRODUCTIDSUPPLIER'
		,      irec.ExtProdID                                              'PRODUCTIDBUYER'
		,      SUM(dd.Qty)                                                 'INVOICEDQUANTITY'
		,
		--[ADDED] '2020-04-24 17:25' rkv0 добавляем единицы измерения.
		       CASE WHEN p.UM = 'шт.' THEN 'PCE'
		                              ELSE 'PCE' END                       'INVOICEUNIT'
		,      dd.PriceCC_nt                                               'UNITPRICE'
		,      dd.PriceCC_wt                                               'GROSSPRICE'
		,      SUM(dd.SumCC_nt)                                            'AMOUNT'
		,      LEFT(p.Notes, 70)                                           'DESCRIPTION'
		,      203                                                         'AMOUNTTYPE'
		,      7                                                           'TAX/FUNCTION'
		,      'VAT'                                                       'TAX/TAXTYPECODE'
		,      CAST(dbo.zf_GetProdTaxPercent(dd.ProdID, m.DocDate) AS INT) 'TAX/TAXRATE'
		,      SUM(dd.TaxSum)                                              'TAX/TAXAMOUNT'
		,      'S'                                                         'TAX/CATEGORY'
		FROM      dbo.t_InvD   dd WITH(NOLOCK)  
		JOIN      dbo.r_Prods  p WITH(NOLOCK)    ON p.ProdID = dd.prodid
		JOIN      dbo.t_PInP   tpp WITH(NOLOCK)  ON tpp.ProdID = dd.ProdID
				AND tpp.PPID = dd.PPID
		LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = dd.ProdID
				AND irec.CompID = @CompID
		WHERE dd.ChID = @ChID
		GROUP BY tpp.ProdBarCode
		,        p.Notes
		,        dd.ProdID
		,        irec.ExtProdID
		,        dd.PriceCC_nt
		,        dd.PriceCC_wt
		,        p.UM
		FOR XML PATH ('POSITION'), TYPE)                                                                                                                                
		FOR XML PATH ('HEAD'), TYPE
		)                                                           
		FROM      dbo.t_Inv          m WITH(NOLOCK)  
		JOIN      dbo.r_CompsAdd     rca WITH(NOLOCK) ON rca.CompID = m.CompID
				AND rca.CompAdd = m.[Address]
		JOIN      dbo.t_IORec        ir WITH(NOLOCK)  ON @OrdChID = ir.Chid
		JOIN      dbo.r_Ours         o WITH(NOLOCK)   ON m.OurID = o.OurID
		--JOIN dbo.r_OurValues ov WITH(NOLOCK) ON m.OurID = ov.OurID AND ov.VarName = 'GLNCode'
		JOIN      dbo.r_Comps        c WITH(NOLOCK)   ON c.CompID = m.CompID
		LEFT JOIN dbo.z_DocLinks     zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID
				AND zdl.ChildDocCode = 11012
				AND zdl.ParentDocCode = 666028
		LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK)  ON zc.ChID = zdl.ParentChID
		JOIN      dbo.at_t_IORecX    irx WITH(NOLOCK) ON irx.ChID = @OrdChID
		WHERE m.ChID = @ChID
			AND
			--c.GLNCode <> '' AND
			rca.GLNCode <> ''
			AND (
				ISNULL(ir.GLNCode, '') <> ''
				OR irx.XMLData IS NOT NULL)
			AND m.TaxDocID <> 0
			AND ir.OrderID IS NOT NULL
			AND ir.OrderID != ''
		FOR XML PATH ('INVOICE'))
	END;
	--#endregion INVOICE (счет-фактура)
	--#region DESADV (Уведомление об отгрузке)
	ELSE IF @DocType = 'DESADV'
		BEGIN
			SET @Out = (
			SELECT
			-- '2019-10-15 16:50' rkv0 меняю подстановку № уведомления-№ заказа на №уведомления-№расходной
			--CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END 'NUMBER',
			  CAST(m.TaxDocID AS INT)                                                                        'NUMBER'
			, CAST(m.TaxDocDate AS DATE)                                                                     'DATE'
			--[ADDED] rkv0 '2021-05-31 10:59' для предприятий 7004, 7144, 7001, 7003, 7142 тянем дату с поля "Погрузка" (заявка #7260).
			--, CAST(m.TaxDocDate AS DATE)                                                                     'DELIVERYDATE'
			, CASE WHEN m.Compid in (7004, 7144, 7001, 7003, 7142) THEN CAST(il.ExpDate as date)
			                                                       ELSE CAST(m.TaxDocDate AS date) END       'DELIVERYDATE'
			, CASE WHEN CAST(il.ExpDate AS TIME) <> '00:00:00' THEN LEFT(CAST(il.ExpDate AS TIME), 5) END    'DELIVERYTIME'
			, --ExpDate = expected date.
			  CASE WHEN ir.OrderID LIKE '%[_]non-alc'
				OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '')
			                                 ELSE ir.OrderID END                                             'ORDERNUMBER'
			, irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)')                                       AS 'ORDERDATE'
			,
			-- [ADDED] rkv0 '2020-12-02 18:24' добавляю 2 тега для сети СИЛЬПО: ORDRSPNUMBER (Строка (16)-Номер подтверждения заказа), ORDRSPDATE(Дата (ГГГГ-ММ-ДД)-Дата подтверждения заказа).
			--https://wiki.edi-n.com/uk/latest/XML/Fozzy_XML-structure.html
			  CAST(m.TaxDocID AS INT)                                                                        'ORDRSPNUMBER'
			, CAST(m.TaxDocDate AS DATE)                                                                     'ORDRSPDATE'
			, CAST(m.TaxDocID AS INT)                                                                        'DELIVERYNOTENUMBER'
			, CAST(m.TaxDocDate AS DATE)                                                                     'DELIVERYNOTEDATE'
			, m.DocID                                                                                        'SUPPLIERORDERNUMBER'
			, CAST(m.DocDate AS DATE)                                                                        'SUPPLIERORDERDATE'
			, CAST(il.BoxQty AS INT)                                                                         'TOTALPACKAGES'
			, --количество ящиков.
			  CAST(il.PalQty AS INT)                                                                         'TOTALPALLETS'
			, --количество паллет.
			  zc.ContrID                                                                                     'CAMPAIGNNUMBER'
			, --Номер договору на поставку

			--[CHANGED] rkv0 '2020-12-03 17:19' сделал этот тег = 1 по умолчанию, т.к. он является optional для всех сетей, кроме Сильпо (для Invoice Matching - он mandatory).
			--CAST(il.CarQty AS INT) 'TRANSPORTQUANTITY', --количество транспортных средств.
			-- [CHANGED] '2021-03-12 17:56' rkv0 для Сильпо захардкодил 1 (всегда будет 1 машины).
			--ISNULL(CAST(il.CarQty AS INT), 1) 'TRANSPORTQUANTITY', --(тег обязательный для Сильпо) Загальна кількість машин; кількість повідомлень про відвантаження в межах одного замовлення покупця(число >1 або =1).
			  CASE WHEN m.Compid in (7142) THEN 1
			                               ELSE NULL END                                                     'TRANSPORTQUANTITY'
			, --(тег обязательный для Сильпо) Загальна кількість машин; кількість повідомлень про відвантаження в межах одного замовлення покупця(число >1 або =1).
			  rd.CarName                                                                                     'TRANSPORTMARK'
			,
			-- [ADDED] rkv0 '2020-12-03 17:35' добавил отдельную ветку по тегу TRANSPORTID для Сильпо и остальных сетей.
			--rd.CarNo 'TRANSPORTID', --(тег обязательный только для Сильпо) Порядковий номер транспортного засобу/повідомленя про відвантаження (число < або = TRANSPORTQUANTITY й не може бути більше)
			-- [FIXED] '2021-03-11 15:57' rkv0 изменил varchar на int.
			--CASE WHEN m.Compid in (7142) THEN ISNULL(CAST(il.CarQty AS varchar), 1) ELSE rd.CarNo END 'TRANSPORTID', --(тег обязательный только для Сильпо) Порядковий номер транспортного засобу/повідомленя про відвантаження (число < або = TRANSPORTQUANTITY й не може бути більше)
/*
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='DESADV', @DocCode=11012, @ChID=200461388,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='DESADV', @DocCode=11012, @ChID=200478804,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
*/
			-- [CHANGED] '2021-03-12 17:56' rkv0 для Сильпо захардкодил 1 (всегда будет 1 машины).
			--CASE WHEN m.Compid in (7142) THEN ISNULL(CAST(left(il.CarQty, 1) AS varchar), 1) ELSE CAST(rd.CarNo AS varchar) END 'TRANSPORTID', --(тег обязательный только для Сильпо) Порядковий номер транспортного засобу/повідомленя про відвантаження (число < або = TRANSPORTQUANTITY й не може бути більше)
			  CASE WHEN m.Compid in (7142) THEN 1
			                               ELSE NULL END                                                     'TRANSPORTID'
			, --(тег обязательный только для Сильпо) Порядковий номер транспортного засобу/повідомленя про відвантаження (число < або = TRANSPORTQUANTITY й не може бути більше)
			  rd.DriverName                                                                                  'TRANSPORTERNAME'
			, 30                                                                                             'TRANSPORTTYPE'
			, 31                                                                                             'TRANSPORTERTYPE'
			, rc4.CodeName4                                                                                  'CARRIERNAME'
			, CASE WHEN rc4.Notes LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				OR rc4.Notes LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' THEN rc4.Notes END    'CARRIERINN'
			, (
			SELECT COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode)            'SUPPLIER'
			,      COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'))                              'BUYER'
			,      COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'DELIVERYPLACE'
			,      COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), ir.GLNCode)          'SENDER'
			,      COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)'))                            'RECIPIENT'
			,      @TOKEN                                                                                                                                                    'EDIINTERCHANGEID'
			,      (
			SELECT 1                         'HIERARCHICALID'
			, --Номер ієрархії упаковки
			       (
			SELECT ROW_NUMBER() OVER(ORDER BY MAX(ird.SrcPosID))                                                                                                        'POSITIONNUMBER'
			,      ISNULL(dd.ProdBarCode, pp.ProdBarCode)                                                                                                               'PRODUCT'
			,      ird.ProdID                                                                                                                                           'PRODUCTIDSUPPLIER'
			,      ird.ExtProdID                                                                                                                                        'PRODUCTIDBUYER'
			,

			-- [ADDED] rvk0 '2020-07-30 15:05' добавил код УКТВЭД (для сети Розетка - он обязательный). + добавить в группировку GROUP BY
			       CASE WHEN @compid in (7136, 7138) THEN pp.CstProdCode END                                                                                         as 'CUSTOMSTARIFFNUMBER'
			,      CASE WHEN RIGHT(SUBSTRING(CAST(SUM(ISNULL(CASE WHEN @CompID=7138 THEN dd.Qty/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                                                                    ELSE dd.Qty END,0)) AS varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))), 1) = '.' THEN SUBSTRING(CAST(SUM(ISNULL(
				CASE WHEN @CompID=7138 THEN dd.Qty/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                       ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))) + '0'
			                                                                                                                                                                                                           ELSE SUBSTRING(CAST(SUM(ISNULL(
				CASE WHEN @CompID=7138 THEN dd.Qty/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                       ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))) END    'DELIVEREDQUANTITY'
			,

			--            SUM(ird.Qty) 'ORDEREDQUANTITY',
			       CASE WHEN RIGHT(SUBSTRING(CAST(
				CASE WHEN @CompID=7138 THEN SUM(ird.Qty)/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                       ELSE SUM(ird.Qty) END AS varchar ), 1, LEN(SUM(ird.Qty))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ird.Qty)))), 1) = '.' THEN SUBSTRING(CAST(
				CASE WHEN @CompID=7138 THEN SUM(ird.Qty)/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                       ELSE SUM(ird.Qty) END AS varchar), 1, LEN(SUM(ird.Qty))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ird.Qty)))) + '0'
			                                                                                                                                             ELSE SUBSTRING(CAST(
				CASE WHEN @CompID=7138 THEN SUM(ird.Qty)/[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                       ELSE SUM(ird.Qty) END AS varchar), 1, LEN(SUM(ird.Qty))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ird.Qty)))) END                       'ORDEREDQUANTITY'
			,

			--            SUM(dd.SumCC_nt) 'AMOUNT',
			       CASE WHEN RIGHT(SUBSTRING(CAST(
				CASE WHEN @CompID=7138 THEN SUM(dd.SumCC_nt)*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                       ELSE SUM(dd.SumCC_nt) END AS varchar ), 1, LEN(SUM(dd.SumCC_nt))+1 - PATINDEX('%[^0]%', REVERSE(SUM(dd.SumCC_nt)))), 1) = '.' THEN SUBSTRING(CAST
				(CASE WHEN @CompID=7138 THEN SUM(dd.SumCC_nt)*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                        ELSE SUM(dd.SumCC_nt) END AS varchar), 1, LEN(SUM(dd.SumCC_nt))+1 - PATINDEX('%[^0]%', REVERSE(SUM(dd.SumCC_nt)))) + '0'
			                                                                                                                                                         ELSE SUBSTRING(CAST
				(CASE WHEN @CompID=7138 THEN SUM(dd.SumCC_nt)*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                        ELSE SUM(dd.SumCC_nt) END AS varchar), 1, LEN(SUM(dd.SumCC_nt))+1 - PATINDEX('%[^0]%', REVERSE(SUM(dd.SumCC_nt)))) END          'AMOUNT'
			,

			--            dd.PriceCC_nt 'PRICE',
			       CASE WHEN RIGHT(SUBSTRING(CAST(
				CASE WHEN @CompID=7138 THEN dd.PriceCC_nt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                       ELSE dd.PriceCC_nt END AS varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt))), 1) = '.' THEN SUBSTRING(CAST(
				CASE WHEN @CompID=7138 THEN dd.PriceCC_nt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                       ELSE dd.PriceCC_nt END as varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt))) + '0'
			                                                                                                                                               ELSE SUBSTRING(CAST(
				CASE WHEN @CompID=7138 THEN dd.PriceCC_nt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                       ELSE dd.PriceCC_nt END as varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt))) END                    'PRICE'
			,

			-- [ADDED] Maslov Oleg '2020-08-04 15:02:50.675' Добавил поле "Цена продукту c ПДВ" (для сети Розетка - он обязательный, ВНЕЗАПНО). И добавил его (dd.PriceCC_wt) в группировку GROUP BY.
			       CASE WHEN @compid in (7136, 7138) THEN CASE WHEN RIGHT(SUBSTRING(CAST(
					CASE WHEN @CompID=7138 THEN dd.PriceCC_wt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
					                       ELSE dd.PriceCC_wt END AS varchar), 1, LEN(dd.PriceCC_wt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_wt))), 1) = '.' THEN SUBSTRING(CAST(
					CASE WHEN @CompID=7138 THEN dd.PriceCC_wt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
					                       ELSE dd.PriceCC_wt END as varchar), 1, LEN(dd.PriceCC_wt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_wt))) + '0'
				                                                                                                                                               ELSE SUBSTRING(CAST(
					CASE WHEN @CompID=7138 THEN dd.PriceCC_wt*[dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
					                       ELSE dd.PriceCC_wt END as varchar), 1, LEN(dd.PriceCC_wt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_wt))) END END         AS 'PRICEWITHVAT'
			,

			-- [ADDED] Maslov Oleg '2020-08-04 15:05:34.538' Добавил поле "Ставка податку (ПДВ,%)" (для сети Розетка - он обязательный, ВНЕЗАПНО).
			--CASE WHEN @compid in (7136, 7138) THEN CAST(FLOOR(dbo.zf_GetProdTaxPercent(ird.ProdID, GETDATE())) AS VARCHAR) END AS 'TAXRATE',
			-- [ADDED] rkv0 '2020-12-03 17:46' теперь этот тег является обязательным для сети Сильпо, поэтому делаю его для всех сетей сразу.
			       CAST(FLOOR(dbo.zf_GetProdTaxPercent(ird.ProdID, GETDATE())) AS VARCHAR)                                                                           AS 'TAXRATE'
			,      LEFT(rp.Notes, 70)                                                                                                                                   'DESCRIPTION'
			FROM         (SELECT MIN(SrcPosID)                  SrcPosID
			,                    CAST(di.ProdID AS VARCHAR(20)) ProdID
			,                    irec.ExtProdID                
			,                    SUM(Qty)                       Qty
			FROM      dbo.t_IORecD di WITH(NOLOCK)  
			LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID
					AND irec.CompID = @CompID --Заказ внутренний: Формирование: Товар (! если на момент формирования DESADV будет отвязан код товара, то эта позиция не попадет в уведомление).
			WHERE ChID = @OrdChID
			GROUP BY di.ProdID
			,        irec.ExtProdID
			HAVING SUM(di.Qty) > 0
			)                                    ird            
			LEFT JOIN    (SELECT ISNULL(irec.ExtProdID
				,CAST(di.ProdID AS VARCHAR(20)))  ProdID
				,                irec.ExtProdID  
				,                tpp.ProdBarCode 
				,                SUM(Qty)         Qty
				,                PriceCC_nt      
				,                PriceCC_wt      
				,                SUM(di.SumCC_nt) SumCC_nt
				FROM      dbo.t_InvD   di WITH(NOLOCK)  
				LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID
						AND irec.CompID = @CompID
				JOIN      dbo.t_PInP   tpp WITH(NOLOCK)  ON tpp.ProdID = di.ProdID
						AND tpp.PPID = di.PPID
				WHERE ChID = @ChID
				GROUP BY irec.ExtProdID
				,        tpp.ProdBarCode
				,        PriceCC_nt
				,        PriceCC_wt
				,        ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20)))
				)                                dd              ON (
						dd.ProdID = ird.ProdID
						AND dd.ExtProdID IS NULL)
					OR (
						dd.ProdID = ird.ExtProdID
						AND dd.ExtProdID IS NOT NULL)
			JOIN         dbo.r_Prods             rp WITH(NOLOCK) ON rp.ProdID = ird.ProdID
			LEFT JOIN    dbo.t_PInP              pp WITH(NOLOCK) ON pp.ProdID = rp.ProdID
					AND pp.PPID = (SELECT MAX(PPID)
					FROM dbo.t_PInP WITH(NOLOCK)                
					WHERE ProdID = rp.ProdID
						AND NOT (
							ProdBarCode = ''
							OR ProdBarCode IS NULL))--если выстреливает 2 одинаковых кода товара, но с разными кодами УКТВЭД, берем код УКТВЭД последней партии (но с 2018г. бухгалтерия  требует, чтобы в таких случаях заводился отдельный код товара).

			WHERE -- Для некоторых предприятий не показывать нули
				(
					m.CompID = 7030
					AND dd.Qty IS NOT NULL)
				OR m.CompID != 7030 --7030	Эко Общество с ограниченной ответственностью  ( магазин Экомаркет)
			GROUP BY dd.ProdBarCode
			,        pp.ProdBarCode
			,        ird.ExtProdID
			,        ird.ProdID
			,        rp.Notes
			,        dd.PriceCC_nt
			,        pp.CstProdCode
			,        dd.PriceCC_wt
			FOR XML PATH ('POSITION'), TYPE)
			FOR XML PATH ('PACKINGSEQUENCE'), TYPE)                                                                                                                         
			FOR XML PATH ('HEAD'), TYPE
			)                                                                                            
			FROM      dbo.t_Inv          m WITH(NOLOCK)    
			JOIN      dbo.r_CompsAdd     rca WITH(NOLOCK)   ON rca.CompID = m.CompID
					AND rca.CompAdd = m.[Address]
			JOIN      dbo.t_IORec        ir WITH(NOLOCK)    ON @OrdChID = ir.Chid --Заказ внутренний: Формирование: Заголовок
			JOIN      dbo.r_Ours         o WITH(NOLOCK)     ON m.OurID = o.OurID
			--JOIN dbo.r_OurValues ov WITH(NOLOCK) ON m.OurID = ov.OurID AND ov.VarName = 'GLNCode'
			JOIN      dbo.r_Comps        c WITH(NOLOCK)     ON c.CompID = m.CompID
			LEFT JOIN dbo.z_DocLinks     zdl WITH(NOLOCK)   ON zdl.ChildChID = m.ChID
					AND zdl.ChildDocCode = 11012
					AND zdl.ParentDocCode = 666028
			LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK)    ON zc.ChID = zdl.ParentChID --at_z_Contracts	Договор универсальный
			LEFT JOIN dbo.at_t_InvLoad   il WITH(NOLOCK)    ON il.ChID = m.ChID --at_t_InvLoad = Расходная накладная: Детали погрузки
			LEFT JOIN dbo.at_r_Drivers   rd WITH(NOLOCK)    ON rd.DriverID = m.DriverID
					AND rd.DriverId != 0 --at_r_Drivers	Справочник водителей
			LEFT JOIN dbo.r_Codes4       [rc4] WITH(NOLOCK) ON [rc4].CodeID4 = m.CodeID4
					AND [rc4].CodeID4 != 0 --r_Codes4	Справочник признаков 4 (rc4 =>-https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/choose-an-encryption-algorithm?view=sql-server-ver15)
			JOIN      dbo.at_t_IORecX    irx WITH(NOLOCK)   ON irx.ChID = @OrdChID --Заказ внутренний: Формирование: Доп инфо (XML)
			WHERE m.Chid = @ChID
				AND --c.GLNCode <> '' AND
				rca.GLNCode <> ''
				AND (
					ISNULL(ir.GLNCode, '') <> ''
					OR irx.XMLData IS NOT NULL)
				AND ISNULL(ir.OrderID,'') <> ''
				AND m.TaxDocID <> 0
			FOR XML PATH ('DESADV'))

		END;
		--#endregion DESADV (Уведомление об отгрузке)
	--#region ORDRSP (Подтверждение заказа)
	ELSE IF @DocType = 'ORDRSP'
		BEGIN
			SET @Out = (
			SELECT CAST(m.TaxDocID AS INT)                                              'NUMBER'
			,      CAST(m.TaxDocDate AS DATE)                                           'DATE'
			,

			--[ADDED] rkv0 '2020-12-03 18:08' добавил теги: TIME, CURRENCY, INFO, CAMPAIGNNUMBER (обязательные для Сильпо)
				    LEFT(CONVERT(time, getdate()),5)                                  AS 'TIME'
			, --Время отправки документа
				    'UAH'                                                             AS 'CURRENCY'
			, --Валюта
				    CASE WHEN m.Compid in (7142) THEN 'Поставка для сети Сильпо'
				                                ELSE NULL END                        AS 'INFO'
			, --Вільний текст
				    zc.ContrID                                                           'CAMPAIGNNUMBER'
			, --Номер договору на поставку

				    CASE WHEN ir.OrderID LIKE '%[_]non-alc'
				OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '')
				                                ELSE ir.OrderID END                        'ORDERNUMBER'
			,      irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)')             AS 'ORDERDATE'
			,      CAST(m.TaxDocDate AS DATE)                                           'DELIVERYDATE'
			,      CASE WHEN CAST(il.ExpDate AS TIME) <> '00:00:00' THEN LEFT(CAST(il.ExpDate AS TIME), 5)
				                                                    ELSE '00:00' END    'DELIVERYTIME'
			,      CAST(il.BoxQty AS INT)                                               'TOTALPACKAGES'
			,      CAST(il.PalQty AS INT)                                               'TOTALPACKAGESSPACE'
			,      CAST(il.CarQty AS INT)                                               'TRANSPORTQUANTITY'
			,      (
			SELECT COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'))                                'BUYER'
			,      COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode)              'SUPPLIER'
			,      COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode)   'DELIVERYPLACE'
			,

			-- [ADDED] rkv0 '2020-12-03 18:30' добавил тег INVOICEPARTNER (GLN платника). Обязательный для Сильпо.
				    COALESCE(irx.XMLData.value('(./HEAD/INVOICEPARTNER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/INVOICEPARTNER)[1]', 'VARCHAR(13)'), rca.GLNCode) 'INVOICEPARTNER'
			,      COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), ir.GLNCode)            'SENDER'
			,      COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)'))                              'RECIPIENT'
			,      @TOKEN                                                                                                                                                      'EDIINTERCHANGEID'
			,      (
			SELECT ROW_NUMBER() OVER(ORDER BY ird.SrcPosID)                    'POSITIONNUMBER'
			,      ISNULL(dd.ProdBarCode, pp.ProdBarCode)                      'PRODUCT'
			,      ird.ExtProdID                                               'PRODUCTIDBUYER'
			,      ird.ProdID                                                  'PRODUCTIDSUPPLIER'
			,      ru.Notes                                                    'ORDRSPUNIT'
			,      LEFT(rp.Notes, 70)                                          'DESCRIPTION'
			,      CASE WHEN @CompID=7138 THEN dd.PriceCC_nt * [dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
			--'2019-04-22 15:58' rkv0 добавил проверку на пустой тег 'PRICE' (проблема с Розеткой)
				                            ELSE ISNULL(dd.PriceCC_nt, 0) END    'PRICE'
			,      CASE WHEN @CompID=7138 THEN dd.PriceCC_wt * [dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
			--'2019-04-22 15:58' rkv0 добавил проверку на пустой тег 'PRICEWITHVAT' (проблема с Розеткой)
				                            ELSE ISNULL(dd.PriceCC_wt, 0) END    'PRICEWITHVAT'
			,      dbo.zf_GetProdTaxPercent(ird.ProdID, m.DocDate)             'VAT'
			,      CASE WHEN dd.Qty IS NULL   THEN 3
				        WHEN dd.Qty = ird.Qty THEN 1
				                                ELSE 2 END                       'PRODUCTTYPE'
			,      CASE WHEN @CompID=7138 THEN ird.Qty/ [dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                            ELSE ird.Qty END                     'ORDEREDQUANTITY'
			,      ISNULL(CASE WHEN @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](ird.ProdID)
				                                    ELSE dd.Qty END, 0)           'ACCEPTEDQUANTITY'
			,
			--[ADDED] rkv0 '2020-12-03 18:36' добавил тег (обязательный для Сильпо).
				    '1'                                                      AS 'MINIMUMORDERQUANTITY' --поставим везде 1.

			FROM         (SELECT MIN(SrcPosID)                  SrcPosID
			,                    CAST(di.ProdID AS VARCHAR(20)) ProdID
			,                    irec.ExtProdID                
			,                    SUM(Qty)                       Qty
			FROM      dbo.t_IORecD di WITH(NOLOCK)  
			LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID
					AND irec.CompID = @CompID
			WHERE ChID = @OrdChID
			GROUP BY CAST(di.ProdID AS VARCHAR(20))
			,        irec.ExtProdID
			HAVING SUM(di.Qty) > 0)              ird            
			LEFT JOIN    (SELECT ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20))) ProdID
				,                irec.ExtProdID                                        
				,                tpp.ProdBarCode                                       
				,                SUM(Qty)                                               Qty
				,                di.PriceCC_nt                                         
				,                di.PriceCC_wt                                         
				FROM      dbo.t_InvD   di WITH(NOLOCK)  
				LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID
						AND irec.CompID = @CompID
				JOIN      dbo.t_PInP   tpp WITH(NOLOCK)  ON tpp.ProdID = di.ProdID
						AND tpp.PPID = di.PPID
				WHERE ChID = @ChID
				GROUP BY irec.ExtProdID
				,        tpp.ProdBarCode
				,        ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20)))
				,        di.PriceCC_nt
				,        di.PriceCC_wt)          dd              ON (
						dd.ProdID = ird.ProdID
						AND dd.ExtProdID IS NULL)
					OR (
						dd.ProdID = ird.ExtProdID
						AND dd.ExtProdID IS NOT NULL)
			LEFT JOIN    dbo.r_Prods             rp WITH(NOLOCK) ON rp.ProdID = ird.ProdID
			LEFT JOIN    dbo.r_Uni               ru WITH(NOLOCK) ON ru.RefTypeID = 80021
					AND ru.RefName = rp.UM
					AND ru.Notes IS NOT NULL
					AND ru.Notes != ''
					AND ru.RefID < 1000
			LEFT JOIN    dbo.t_PInP              pp WITH(NOLOCK) ON pp.ProdID = rp.ProdID
					AND pp.PPID = (SELECT MAX(PPID)
					FROM dbo.t_PInP WITH(NOLOCK)                
					WHERE ProdID = rp.ProdID
						AND NOT (
							ProdBarCode = ''
							OR ProdBarCode IS NULL))--если выстреливает 2 одинаковых кода товара, но с разными кодами УКТВЭД, берем код УКТВЭД последней партии (но с 2018г. бухгалтерия  требует, чтобы в таких случаях заводился отдельный код товара).

			FOR XML PATH ('POSITION'), TYPE)                                                                                                                                  
			FOR XML PATH ('HEAD'), TYPE
			)                                                                       
			FROM      dbo.t_Inv          m WITH(NOLOCK)  
			JOIN      dbo.r_CompsAdd     rca WITH(NOLOCK) ON rca.CompID = m.CompID
					AND rca.CompAdd = m.[Address]
			JOIN      dbo.t_IORec        ir WITH(NOLOCK)  ON @OrdChID = ir.Chid
			JOIN      dbo.r_Ours         o WITH(NOLOCK)   ON m.OurID = o.OurID
			--JOIN dbo.r_OurValues ov WITH(NOLOCK) ON m.OurID = ov.OurID AND ov.VarName = 'GLNCode'
			JOIN      dbo.r_Comps        c WITH(NOLOCK)   ON c.CompID = m.CompID
			LEFT JOIN dbo.at_t_InvLoad   il WITH(NOLOCK)  ON il.ChID = m.ChID
			JOIN      dbo.at_t_IORecX    irx WITH(NOLOCK) ON irx.ChID = @OrdChID
			--[ADDED] rkv0 '2020-12-03 18:08' джойним еще 2 таблицы для добавления тега CAMPAIGNNUMBER (обязательный тег для Сильпо).
			LEFT JOIN dbo.z_DocLinks     zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID
					AND zdl.ChildDocCode = 11012
					AND zdl.ParentDocCode = 666028 --ParentDocCode	Код гл. документа
			LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK)  ON zc.ChID = zdl.ParentChID --at_z_Contracts	Договор универсальный

			WHERE m.Chid = @ChID
				AND-- c.GLNCode <> '' AND
				--  rca.GLNCode <> '' AND
				(
					ISNULL(ir.GLNCode, '') <> ''
					OR irx.XMLData IS NOT NULL)
				AND ISNULL(ir.OrderID,'') <> ''
				AND m.TaxDocID <> 0
			FOR XML PATH ('ORDRSP'))

		END;
		--#endregion ORDRSP (Подтверждение заказа)
    --#region COMDOC_GLADKIY (Коммерческий документ: расходная накладная для сети Велике Пузо)
    ELSE IF @DocType = 'COMDOC_GLADKIY'
        BEGIN
            SET @Out = (
            SELECT '001767'                  AS 'Stock/@DistCode' --Код поставщика предоставляется сетью – 6 символов.
            ,      (select OurName + ' ' + [Address]
            from r_Ours
            WHERE OurID = 1)                 AS 'Stock/@DistName' --название поставщика.
            ,      (SELECT CompAddDesc
            from r_CompsAdd
            WHERE CompAddID = @CompAddID
	            and CompID = @compid)        AS 'Stock/@StockCode' --код Магазина/Маркета/Склада, на который осуществляется доставка – предоставляется сетью.
            ,      (SELECT CompAdd
            from r_CompsAdd
            WHERE CompAddID = @CompAddID
	            and CompID = @compid)        AS 'Stock/@StockName' --название магазина/склада.
            --DOCUMENT - сам документ отгрузки.
            ,      (SELECT 'Delivery'               AS 'DOCUMENT/@Name' --Тип документа. На данный момент только «Delivery».
            ,              (SELECT Docid
            FROM t_Inv
            WHERE ChID = @chid)                     AS 'DOCUMENT/@Number' --Номер документа в базе поставщика. Номер должен соответствовать номеру в печатном документе!
            ,              (SELECT CONVERT(varchar, DocDate, 112)
            FROM t_Inv
            WHERE ChID = @chid)                     AS 'DOCUMENT/@Date' --Дата доставки (!) товара в магазин. Дата в формате «YYYYMMDD».
            ,              (SELECT TaxDocID
            FROM t_Inv
            WHERE ChID = @chid)                     AS 'DOCUMENT/@TaxNum' --Номер налоговой накладной.
            ,              (SELECT CONVERT(varchar, DocDate, 112)
            FROM t_Inv
            WHERE ChID = @chid)                     AS 'DOCUMENT/@TaxDate' --Дата налоговой накладной «YYYYMMDD».
            ,              0                        AS 'DOCUMENT/@Type' --тип учета.(Бухгалтерский - "1", Управленческий - "0").
            --ITEM – Строка табличной части документа
            ,              (
            SELECT td.ProdID                             AS 'ITEM/@Code' --Код товара в базе поставщика. Поле обязательно к заполнению!
            ,      rp.Notes                              AS 'ITEM/@Name' --Название товара в базе поставщика.
            ,      CAST(td.Qty AS int)                   AS 'ITEM/@Num' --Количество.
            ,      CAST(rp.[Weight] AS numeric(21,2))    AS 'ITEM/@Weight' --Вес НЕТТО за единицу товара(уп./шт./кг./л.)
            ,      0                                     AS 'ITEM/@IsWeight' --Признак весового товара (0 - штучный, 1 - Весовой);
            ,      1                                     AS 'ITEM/@Unit' --со слов Гали, всегда тут ставим 1, т.к. продаем бутылки поштучно.
            --, ProdID AS 'ITEM/@NumInBox' --Количество штук товара в упаковке, если Unit=0.
            ,      CAST(td.PriceCC_nt AS numeric(21, 4)) AS 'ITEM/@Price' --Цена БЕЗ НДС единицы товара (уп./шт./кг./л., см. Unit).
            ,      tp.ProdBarCode                        AS 'ITEM/@BarCode' --Штрих код товара, если есть.
            --, td.PriceCC_nt AS 'ITEM/@MRC' --МРЦ (минимальная рекомендованная цена(только для сигарет и т.п.). Не понятно, что за цена, с Галей решили поставить PriceCC_nt (пока вообще уберу).
            FROM t_InvD  td
            JOIN r_prods rp ON td.ProdID = rp.ProdID
            JOIN t_PInP  tp ON tp.PPID = td.PPID
		            and tp.ProdID = td.ProdID
            WHERE td.ChID = 200504921
            ORDER BY td.SrcPosID --Порядок товара должен быть таким же, как в печатной форме документа.
            FOR XML PATH (''), TYPE, ROOT('TABLE')) AS 'DOCUMENT' --DOCUMENT - сам документ отгрузки. --TABLE - тег начала и конца табличной части документа.
            FOR XML PATH('DOCUMENTS'), TYPE) AS 'Stock' --DOCUMENTS - Все документы помещаются внутри данного тега. --Stock – шапка файла обмена, содержит информацию о поставщике и адресе доставки. Один файл может содержать один такой тег.
            FOR XML PATH ('DATA')/*, TYPE*/ --DATA - корневой тег.
            )
        END;
--#endregion COMDOC_GLADKIY (Коммерческий документ: расходная накладная для сети Велике Пузо)
	--#region COMDOC_ROZETKA (Коммерческий документ: расходная накладная для сети Розетка)
	-- [CHANGED] rkv0 '2020-10-21 19:05' изменил COMDOC на COMDOC_ROZETKA, т.к. эта расходная отправляется только на Розетку (также это будет использоваться для ограничения отправки расходных из инструмента F11 Exite).
	--ELSE IF @DocType = 'COMDOC'
	ELSE IF @DocType = 'COMDOC_ROZETKA'
		BEGIN
			SET @Out = (
			SELECT m.TaxDocID                                                                                            'Заголовок/НомерДокументу'
			,      'Видаткова накладна'                                                                               AS 'Заголовок/ТипДокументу'
			,      '006'                                                                                              AS 'Заголовок/КодТипуДокументу'
			,      CAST(m.TaxDocDate AS DATE)                                                                         AS 'Заголовок/ДатаДокументу'
			,      CASE WHEN ir.OrderID LIKE '%[_]non-alc'
				OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '')
					                            ELSE ir.OrderID END                                                      AS 'Заголовок/НомерЗамовлення'
			,      irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)')                                              AS 'Заголовок/ДатаЗамовлення'
			,      'Дніпропетровська обл. м. Синельникове'                                                            AS 'Заголовок/МісцеСкладання'
			,      REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(zc.ContrID,'-','@'),'/','#')),'@','-'),'#','/') AS 'Заголовок/ДокПідстава/НомерДокументу'
			,      'Договір'                                                                                          AS 'Заголовок/ДокПідстава/ТипДокументу'
			,      '001'                                                                                              AS 'Заголовок/ДокПідстава/КодТипуДокументу'
			,      CAST(zc.BDate AS DATE)                                                                             AS 'Заголовок/ДокПідстава/ДатаДокументу'
			,      (SELECT (SELECT *
			FROM (SELECT
			--[CHANGED] rkv0 '2020-11-19 14:21' заявка #2421. Меняю теги для сети Розетка: убираю "Отримувач", меняю "Видправник" на "Продавець".
			--'Відправник' AS 'СтатусКонтрагента',
				'Продавець'                                                                                                                                    AS 'СтатусКонтрагента'
			, 'Юридична'                                                                                                                                     AS 'ВидОсоби'
			, o.Note2                                                                                                                                        AS 'НазваКонтрагента'
			, o.Code                                                                                                                                         AS 'КодКонтрагента'
			, o.TaxCode                                                                                                                                      AS 'ІПН'
			, 305749                                                                                                                                         AS 'МФО'
			, '2600530539322'                                                                                                                                AS 'ПоточРах'
			, o.Phone                                                                                                                                        AS 'Телефон'
			, COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) AS 'GLN'
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
			SELECT 'Покупець'                                                                                                                   AS 'СтатусКонтрагента'
			,      'Юридична'                                                                                                                   AS 'ВидОсоби'
			,      RTRIM(CASE WHEN c.IsBranch = 1 THEN c.Contract2
					                                ELSE c.Contract1 END)                                                                         AS 'НазваКонтрагента'
			,      c.Code                                                                                                                       AS 'КодКонтрагента'
			,      c.TaxCode                                                                                                                    AS 'ІПН'
			,      rccc.BankID                                                                                                                  AS 'МФО'
			,      rccc.CompAccountCC                                                                                                           AS 'ПоточРах'
			,      c.TaxPhone                                                                                                                   AS 'Телефон'
			,      COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) AS 'GLN'

			) AS contragents

			FOR XML PATH ('Контрагент'), TYPE)
			FOR XML PATH ('Сторони'), TYPE
			)                                                                                                        
			,      (SELECT (
			(SELECT *
			FROM (SELECT 'Точка доставки'                                                                                                                                          AS 'Параметр/@назва'
			,            1                                                                                                                                                         AS 'Параметр/@ІД'
			,            COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) AS 'Параметр'
			UNION
			SELECT 'Адреса доставки'
			,      2
			,      rca.CompAdd) params
			FOR XML PATH (''), TYPE))
			FOR XML PATH ('Параметри'), TYPE
			)                                                                                                        
			,      (SELECT (SELECT ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID))                                                                                      AS '@ІД'
			,                      ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID))                                                                                      AS 'НомПоз'
			,                      (SELECT ROW_NUMBER() OVER(ORDER BY MAX(d0.PPID)) AS 'Штрихкод/@ІД'
			,                              tpp.ProdBarCode                          AS 'Штрихкод'
			FROM dbo.t_InvD d0 WITH(NOLOCK) 
			JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d0.ProdID
					AND tpp.PPID = d0.PPID
			WHERE d0.ChID = m.ChID
				AND d0.ProdID = dd.ProdID
			GROUP BY tpp.ProdBarCode
			FOR XML PATH (''), TYPE
			)                                                                                                                                                       
			,                      ec.ExtProdID                                                                                                                      AS 'АртикулПокупця'
			,                      dd.ProdID                                                                                                                         AS 'АртикулПродавця'
			,                      tpp.CstProdCode                                                                                                                   AS 'КодУКТЗЕД'
			,                      p.Notes                                                                                                                           AS 'Найменування'
			,

			-- '2019-06-25 10:41' rkv0 добавил розетко-единицы в COMDOC.
			--CAST(SUM(dd.Qty) AS NUMERIC(21,2)) AS 'ПрийнятаКількість',

					                CASE WHEN RIGHT(SUBSTRING(CAST(SUM(ISNULL(CASE WHEN @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID)
						                                                                            ELSE dd.Qty END,0)) AS varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))), 1) = '.' THEN SUBSTRING(CAST(SUM(ISNULL(
				CASE WHEN @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID)
						                ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))) + '0'
					                                                                                                                                                                                                                    ELSE SUBSTRING(CAST(SUM(ISNULL(
				CASE WHEN @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID)
						                ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))) END    'ПрийнятаКількість'
			,

			--p.UM AS 'ОдиницяВиміру',
					                'шт'                                                                                                                              AS 'ОдиницяВиміру'
			,

			--CAST(dd.PriceCC_nt AS NUMERIC(21,2)) AS 'БазоваЦіна',

			-- '2019-10-15 13:19' rkv0 делаю округление в одну строку (нет необходимости в длинных преобразованиях).
					                CASE WHEN @CompID=7138 THEN CAST(dd.PriceCC_nt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
					                                        ELSE dd.PriceCC_nt END                                                                                        'БазоваЦіна'
			,

			-- '2019-10-15 13:19' rkv0 делаю округление в одну строку (нет необходимости в длинных преобразованиях).
					                CASE WHEN @CompID=7138 THEN cast(dd.Tax * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) as numeric(21,2))
					                                        ELSE dd.Tax END                                                                                               'ПДВ'
			,

			-- '2019-10-15 13:19' rkv0 делаю округление в одну строку (нет необходимости в длинных преобразованиях).
					                CASE WHEN @CompID=7138 THEN CAST(dd.PriceCC_wt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
					                                        ELSE dd.PriceCC_wt END                                                                                        'Ціна'
			,                      CAST(SUM(dd.SumCC_nt) AS NUMERIC(21,2))                                                                                           AS 'ВсьогоПоРядку/СумаБезПДВ'
			,                      CAST(SUM(dd.TaxSum) AS NUMERIC(21,2))                                                                                             AS 'ВсьогоПоРядку/СумаПДВ'
			,                      CAST(SUM(dd.SumCC_wt) AS NUMERIC(21,2))                                                                                           AS 'ВсьогоПоРядку/Сума'

			FROM      dbo.t_InvD            dd WITH(NOLOCK)  
			JOIN      dbo.r_Prods           p WITH(NOLOCK)    ON p.ProdID = dd.prodid
			JOIN      dbo.t_PInP            tpp WITH(NOLOCK)  ON tpp.ProdID = dd.ProdID
					AND tpp.PPID = dd.PPID
			LEFT JOIN dbo.at_r_CompOurTerms rcot WITH(NOLOCK) ON rcot.CompID = m.CompID
					AND rcot.OurID = m.OurID
			LEFT JOIN dbo.r_ProdEC          ec WITH(NOLOCK)   ON ec.ProdID=p.ProdID
					AND ec.CompID = rcot.BCompCode
			WHERE dd.ChID = m.ChID
			-- '2019-10-16 15:50' rkv0 убираем группировку по 3-м полям: dd.SumCC_nt, dd.TaxSum, dd.SumCC_wt
			GROUP BY ec.ExtProdID
			,        dd.ProdID
			,        tpp.CstProdCode
			,        p.Notes
			,        p.UM
			,        dd.PriceCC_nt
			,        dd.Tax
			,        dd.PriceCC_wt/*, dd.SumCC_nt, dd.TaxSum, dd.SumCC_wt*/
			FOR XML PATH ('Рядок'), TYPE)
			FOR XML PATH ('Таблиця'), TYPE
			)                                                                                                        
			,      (SELECT CAST(SUM(SumCC_nt) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                      AS 'ВсьогоПоДокументу/СумаБезПДВ'
			,      (SELECT CAST(SUM(TaxSum) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                      AS 'ВсьогоПоДокументу/ПДВ'
			,      (SELECT CAST(SUM(SumCC_wt) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                      AS 'ВсьогоПоДокументу/Сума'
			FROM        dbo.t_Inv                                      m WITH(NOLOCK)   
			JOIN        dbo.r_CompsAdd                                 rca WITH(NOLOCK)  ON rca.CompID = m.CompID
					AND rca.CompAdd = m.Address
			JOIN        dbo.t_IORec                                    ir WITH(NOLOCK)   ON @OrdChID = ir.Chid
			JOIN        dbo.r_Ours                                     o WITH(NOLOCK)    ON m.OurID = o.OurID
			CROSS APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) c                
			LEFT JOIN   dbo.z_DocLinks                                 zdl WITH(NOLOCK)  ON zdl.ChildChID = m.ChID
					AND zdl.ChildDocCode = 11012
					AND zdl.ParentDocCode = 666028
			LEFT JOIN   dbo.at_z_Contracts                             zc WITH(NOLOCK)   ON zc.ChID = zdl.ParentChID
			JOIN        dbo.at_t_IORecX                                irx WITH(NOLOCK)  ON irx.ChID = @OrdChID
			LEFT JOIN   dbo.r_CompsCC                                  rccc WITH(NOLOCK) ON rccc.CompID = m.CompID
					AND rccc.DefaultAccount = 1
			WHERE m.ChID = @ChID
				AND rca.GLNCode <> ''
				AND (
					ISNULL(ir.GLNCode, '') <> ''
					OR irx.XMLData IS NOT NULL)
				AND m.TaxDocID <> 0
				AND ir.OrderID IS NOT NULL
				AND ir.OrderID != ''
			FOR XML PATH ('ЕлектроннийДокумент'))

		END;
		--#endregion COMDOC_ROZETKA (Коммерческий документ: расходная накладная для сети Розетка)
	--#region COMDOC_PUZO (Коммерческий документ: расходная накладная для сети Велике Пузо)
	-- [ADDED] rkv0 '2021-01-16 16:37' добавил для сети "Велике Пузо".
	ELSE IF @DocType = 'COMDOC_PUZO'
		BEGIN
			SET @Out = (SELECT m.TaxDocID                                                                                            'Заголовок/НомерДокументу'
			,                  'Видаткова накладна'                                                                               AS 'Заголовок/ТипДокументу'
			,                  '006'                                                                                              AS 'Заголовок/КодТипуДокументу'
			,                  CAST(m.TaxDocDate AS DATE)                                                                         AS 'Заголовок/ДатаДокументу'
			,                  CASE WHEN ir.OrderID LIKE '%[_]non-alc'
				OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '')
						                        ELSE ir.OrderID END                                                                  AS 'Заголовок/НомерЗамовлення'
			,
			--irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'Заголовок/ДатаЗамовлення',
						        CAST(ir.DocDate AS DATE)                                                                           AS 'Заголовок/ДатаЗамовлення'
			,                  'Дніпропетровська обл. м. Синельникове'                                                            AS 'Заголовок/МісцеСкладання'
			,                  REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(zc.ContrID,'-','@'),'/','#')),'@','-'),'#','/') AS 'Заголовок/ДокПідстава/НомерДокументу'
			,                  'Договір'                                                                                          AS 'Заголовок/ДокПідстава/ТипДокументу'
			,                  '001'                                                                                              AS 'Заголовок/ДокПідстава/КодТипуДокументу'
			,                  CAST(zc.BDate AS DATE)                                                                             AS 'Заголовок/ДокПідстава/ДатаДокументу'
			,                  (SELECT (SELECT *
			FROM (SELECT
			--[CHANGED] rkv0 '2020-11-19 14:21' заявка #2421. Меняю теги для сети Розетка: убираю "Отримувач", меняю "Видправник" на "Продавець".
			--'Відправник' AS 'СтатусКонтрагента',
				'Продавець'     AS 'СтатусКонтрагента'
			, 'Юридична'      AS 'ВидОсоби'
			, o.Note2         AS 'НазваКонтрагента'
			, o.Code          AS 'КодКонтрагента'
			, o.TaxCode       AS 'ІПН'
			, 305749          AS 'МФО'
			, '2600530539322' AS 'ПоточРах'
			, o.Phone         AS 'Телефон'
			--COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) AS 'GLN'
			--0 AS 'GLN' --номера GLN нет, т.к. не работаем через провайдера.

			UNION

			SELECT 'Покупець'                                           AS 'СтатусКонтрагента'
			,      'Юридична'                                           AS 'ВидОсоби'
			,      RTRIM(CASE WHEN c.IsBranch = 1 THEN c.Contract2
						                            ELSE c.Contract1 END) AS 'НазваКонтрагента'
			,      c.Code                                               AS 'КодКонтрагента'
			,      c.TaxCode                                            AS 'ІПН'
			,      rccc.BankID                                          AS 'МФО'
			,      rccc.CompAccountCC                                   AS 'ПоточРах'
			,      c.TaxPhone                                           AS 'Телефон'
			--COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) AS 'GLN'
			--0 AS 'GLN' --номера GLN нет, т.к. не работаем через провайдера.
			) AS contragents

			FOR XML PATH ('Контрагент'), TYPE)
			FOR XML PATH ('Сторони'), TYPE
			)                                                                                                                    
			,                  (SELECT (
			(SELECT *
			FROM
/*      --(SELECT 'Точка доставки' AS 'Параметр/@назва', 1 AS 'Параметр/@ІД', COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) AS 'Параметр'
(SELECT 'Точка доставки' AS 'Параметр/@назва', 1 AS 'Параметр/@ІД', '0' AS 'Параметр' --номера GLN нет, т.к. не работаем через провайдера.
UNION
SELECT 'Адреса доставки', 2, rca.CompAdd) params*/ (SELECT 'Адреса доставки' AS 'Параметр/@назва'
			,                                        1                 AS 'Параметр/@ІД'
			,                                        rca.CompAdd       AS 'Параметр') as params --номера GLN нет, т.к. не работаем через провайдера.
			FOR XML PATH (''), TYPE))
			FOR XML PATH ('Параметри'), TYPE
			)                                                                                                                    
			,
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			/*ДЕТАЛЬНАЯ ЧАСТЬ*/
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						        (SELECT (SELECT ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID))                                                                          AS '@ІД'
			,                                  ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID))                                                                          AS 'НомПоз'
			,                                  (SELECT ROW_NUMBER() OVER(ORDER BY MAX(d0.PPID)) AS 'Штрихкод/@ІД'
			,                                          tpp.ProdBarCode                          AS 'Штрихкод'
			FROM dbo.t_InvD d0 WITH(NOLOCK) 
			JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d0.ProdID
					AND tpp.PPID = d0.PPID
			WHERE d0.ChID = m.ChID
				AND d0.ProdID = dd.ProdID
			GROUP BY tpp.ProdBarCode
			FOR XML PATH (''), TYPE
			)                                                                                                                                                       
			,                                  ec.ExtProdID                                                                                                          AS 'АртикулПокупця'
			,                                  dd.ProdID                                                                                                             AS 'АртикулПродавця'
			,                                  tpp.CstProdCode                                                                                                       AS 'КодУКТЗЕД'
			,                                  p.Notes                                                                                                               AS 'Найменування'
			,

			-- '2019-06-25 10:41' rkv0 добавил розетко-единицы в COMDOC.
			--CAST(SUM(dd.Qty) AS NUMERIC(21,2)) AS 'ПрийнятаКількість',

						                        CASE WHEN RIGHT(SUBSTRING(CAST(SUM(ISNULL(CASE WHEN @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID)
							                                                                                    ELSE dd.Qty END,0)) AS varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))), 1) = '.' THEN SUBSTRING(CAST(SUM(ISNULL(
				CASE WHEN @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID)
							            ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))) + '0'
						                                                                                                                                                                                                                            ELSE SUBSTRING(CAST(SUM(ISNULL(
				CASE WHEN @CompID=7138 THEN dd.Qty/ [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID)
							            ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))) END    'ПрийнятаКількість'
			,

			--p.UM AS 'ОдиницяВиміру',
						                        'шт'                                                                                                                  AS 'ОдиницяВиміру'
			,

			--CAST(dd.PriceCC_nt AS NUMERIC(21,2)) AS 'БазоваЦіна',

			-- '2019-10-15 13:19' rkv0 делаю округление в одну строку (нет необходимости в длинных преобразованиях).
						                        CASE WHEN @CompID=7138 THEN CAST(dd.PriceCC_nt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
						                                                ELSE dd.PriceCC_nt END                                                                            'БазоваЦіна'
			,

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
						                        CASE WHEN @CompID=7138 THEN cast(dd.Tax * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) as numeric(21,2))
						                                                ELSE dd.Tax END                                                                                   'ПДВ'
			,

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
						                        CASE WHEN @CompID=7138 THEN CAST(dd.PriceCC_wt * [dbo].[af_GetQtyPack_ROZETKA](dd.ProdID) AS numeric(21,2))
						                                                ELSE dd.PriceCC_wt END                                                                            'Ціна'
			,

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

						                        CAST(SUM(dd.SumCC_nt) AS NUMERIC(21,2))                                                                               AS 'ВсьогоПоРядку/СумаБезПДВ'
			,                                  CAST(SUM(dd.TaxSum) AS NUMERIC(21,2))                                                                                 AS 'ВсьогоПоРядку/СумаПДВ'
			,                                  CAST(SUM(dd.SumCC_wt) AS NUMERIC(21,2))                                                                               AS 'ВсьогоПоРядку/Сума'

			FROM      dbo.t_InvD            dd WITH(NOLOCK)  
			JOIN      dbo.r_Prods           p WITH(NOLOCK)    ON p.ProdID = dd.prodid
			JOIN      dbo.t_PInP            tpp WITH(NOLOCK)  ON tpp.ProdID = dd.ProdID
					AND tpp.PPID = dd.PPID
			LEFT JOIN dbo.at_r_CompOurTerms rcot WITH(NOLOCK) ON rcot.CompID = m.CompID
					AND rcot.OurID = m.OurID
			LEFT JOIN dbo.r_ProdEC          ec WITH(NOLOCK)   ON ec.ProdID=p.ProdID
					AND ec.CompID = rcot.BCompCode
			WHERE dd.ChID = m.ChID
			-- '2019-10-16 15:50' rkv0 убираем группировку по 3-м полям: dd.SumCC_nt, dd.TaxSum, dd.SumCC_wt
			GROUP BY ec.ExtProdID
			,        dd.ProdID
			,        tpp.CstProdCode
			,        p.Notes
			,        p.UM
			,        dd.PriceCC_nt
			,        dd.Tax
			,        dd.PriceCC_wt/*, dd.SumCC_nt, dd.TaxSum, dd.SumCC_wt*/
			FOR XML PATH ('Рядок'), TYPE)
			FOR XML PATH ('Таблиця'), TYPE
			)                                                                                                                    
			,                  (SELECT CAST(SUM(SumCC_nt) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                                  AS 'ВсьогоПоДокументу/СумаБезПДВ'
			,                  (SELECT CAST(SUM(TaxSum) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                                  AS 'ВсьогоПоДокументу/ПДВ'
			,                  (SELECT CAST(SUM(SumCC_wt) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                                  AS 'ВсьогоПоДокументу/Сума'
			FROM        dbo.t_Inv                                      m WITH(NOLOCK)   
			JOIN        dbo.r_CompsAdd                                 rca WITH(NOLOCK)  ON rca.CompID = m.CompID
					AND rca.CompAdd = m.[Address]
			JOIN        dbo.t_IORec                                    ir WITH(NOLOCK)   ON @OrdChID = ir.Chid
			JOIN        dbo.r_Ours                                     o WITH(NOLOCK)    ON m.OurID = o.OurID
			CROSS APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) c                
			LEFT JOIN   dbo.z_DocLinks                                 zdl WITH(NOLOCK)  ON zdl.ChildChID = m.ChID
					AND zdl.ChildDocCode = 11012
					AND zdl.ParentDocCode = 666028
			LEFT JOIN   dbo.at_z_Contracts                             zc WITH(NOLOCK)   ON zc.ChID = zdl.ParentChID
			--JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
			LEFT JOIN   dbo.r_CompsCC                                  rccc WITH(NOLOCK) ON rccc.CompID = m.CompID
					AND rccc.DefaultAccount = 1
			WHERE 1 = 1
				AND m.ChID = @ChID
				--AND rca.GLNCode <> ''
				--AND (ISNULL(ir.GLNCode, '') <> '' /*OR irx.XMLData IS NOT NULL*/)
				--AND m.TaxDocID <> 0
				AND ir.OrderID IS NOT NULL
				AND ir.OrderID != ''
			FOR XML PATH ('ЕлектроннийДокумент'))
		END;
		--#endregion COMDOC_PUZO (Коммерческий документ: расходная накладная для сети Велике Пузо)
	--#region COMDOC_METRO (Коммерческий документ: товарная накладная document_invoice)
	ELSE IF @DocType = 'COMDOC_METRO' --товарная накладная (Document Invoice) - в EDI используется только сетью METRO
		BEGIN

			-- [CHANGED] rkv0 '2021-03-04 18:50' переместил блок для формирования номера товарной накладной в блок ELSE IF @DocType = 'COMDOC_METRO' (был в шапке данной процедуры). Заявка ##RE-5406##
			IF OBJECT_ID('tempdb.dbo.#invnum' ,'U') IS NOT NULL
				DROP TABLE #invnum
			SELECT * INTO #invnum
			FROM (
			SELECT FileData.value('(./Document-Invoice/Invoice-Header/InvoiceNumber)[1]','varchar(16)') 'InvNum'
			FROM at_z_filesexchange
			WHERE [FileName] like '%documentinvoice%'
			) AS invnum

			DECLARE @SQL_Select                  NVARCHAR(MAX)
			,       @OutByDynamicSQLRecadvNumber VARCHAR(50)
			--[ADDED] '2021-03-16 12:47' rkv0 добавил в условие DocSum != 0 (для отсекания нулевых RECADV, которые высылает METRO).
			SET @SQL_Select = 'SELECT @outs = (SELECT aerf.ID FROM [s-ppc.const.alef.ua].[Alef_Elit].[dbo].[at_EDI_reg_files] aerf WHERE DocSum != 0 and Notes LIKE m.OrderID + ''%'' AND aerf.doctype = 5000 AND aerf.RetailersID = 17)'
			+ ' FROM dbo.t_Inv m WITH(NOLOCK) '
			+ ' WHERE m.ChID = ' + CAST(@ChID AS VARCHAR(10))

			EXEC sp_executesql @SQL_Select
			,                  N'@outs VARCHAR(50) OUT'
			,                  @OutByDynamicSQLRecadvNumber OUT

			SET @Out = (
			SELECT 'DocumentInvoice'                                                                                                                                         AS '@class'
			, --атрибут class
			--tag 'Invoice-Header'

			-- '2019-12-13 13:46' rkv0 добавляю к номеру товарной накладной 3 рандомных числа (миллисекунды) для возможности повторной отправки товарной (один и тот же номер они не примут).
			--CAST(m.DocID AS VARCHAR(16)) + '-' + right(CONVERT(varchar,GETDATE(),114),3) AS 'Invoice-Header/InvoiceNumber', --InvoiceNumber - номер документа DocID(Len  <= 15)
			-- [CHANGED] '2020-07-08 18:02' rkv0 убираем нули (письмо от Гали Танцюры: "сеть МЕТРО не принимает на подпись товарные с нулями в начале").
			--RIGHT('0000000000' + (SELECT
					(SELECT CASE WHEN (SELECT COUNT(*)
				FROM #invnum
				WHERE InvNum LIKE (cast(m.DocID as varchar(16)) + '%')) = 0 THEN CAST(m.DocID AS varchar(16))
			--SELECT COUNT(*) FROM #invnum WHERE InvNum LIKE (cast('3275957' as varchar(16)) + '%')
							                                                ELSE (SELECT CAST(m.DocID AS varchar(16)) + '-' + CAST(COUNT(*) AS varchar(100))
				FROM #invnum
				WHERE InvNum LIKE (cast(m.DocID as varchar(16)) + '%')) END)                                                                                                
			AS                                                                                                                                                                  'Invoice-Header/InvoiceNumber'
			, --InvoiceNumber - номер документа DocID(Len  <= 15)

					CAST(m.DocDate AS DATE)                                                                                                                                   AS 'Invoice-Header/InvoiceDate'
			, --InvoiceDate - дата документа (CCYY-MM-DD) DocDate
					'UAH'                                                                                                                                                     AS 'Invoice-Header/InvoiceCurrency'
			, --Валюта
					CONVERT(date, getdate())                                                                                                                                  AS 'Invoice-Header/InvoicePostDate'
			, --Дата отправки документа
					LEFT(CONVERT(time, getdate()),5)                                                                                                                          AS 'Invoice-Header/InvoicePostTime'
			, --Время отправки документа
					'TN'                                                                                                                                                      AS 'Invoice-Header/DocumentFunctionCode'
			, --Код типа документа (TN - товарная накладная, CTN - корректировочня товарная накладная)
					CASE WHEN m.CompID = 7001 THEN 24479
						WHEN m.CompID = 7003 THEN 24535
							                    ELSE 0 END                                                                                                                      AS 'Invoice-Header/ContractNumber'
			, --№ договора поставки (24535 - алкоголь, 24479 -  вода).
			--tag 'Invoice-Reference'
					m.OrderID                                                                                                                                                    'Invoice-Reference/Order/BuyerOrderNumber'
			, --Номер заказа (восьмизначное число, поле не может содержать только нули)
					m.TaxDocID                                                                                                                                                   'Invoice-Reference/TaxInvoice/TaxInvoiceNumber'
			, --Номер налоговой накладной
					CAST(m.TaxDocDate AS DATE)                                                                                                                                   'Invoice-Reference/TaxInvoice/TaxInvoiceDate'
			, --Дата налоговой накладной (дата налоговой накладной должна совпадать с датой товарной накладной)
					m.TaxDocID                                                                                                                                                   'Invoice-Reference/DespatchAdvice/DespatchAdviceNumber'
			, --Номер уведомления об отгрузке
			--Maslov Oleg '2019-11-14 15:43:02.967' Перевел на динамику, так как возникала ошибка, когда простые пользователи пытались использовать инструмент по отправке документов.
			--(SELECT aerf.ID FROM [s-ppc.const.alef.ua].[Alef_Elit].[dbo].[at_EDI_reg_files] aerf WHERE Notes = m.OrderID AND aerf.doctype = 5000 AND aerf.RetailersID = 17) 'Invoice-Reference/ReceivingAdvice/ReceivingAdviceNumber', --Номер уведомления о приеме
					ISNULL(@OutByDynamicSQLRecadvNumber, '')                                                                                                                     'Invoice-Reference/ReceivingAdvice/ReceivingAdviceNumber'
			, --Номер уведомления о приеме
			--tag 'Invoice-Parties'
			--покупатель
					COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)'), ir.GLNCode)                AS 'Invoice-Parties/Buyer/ILN'
			, --GLN покупателя [0-9](13) (можно взять здесь: at_t_IORecX)
					c.TaxCode                                                                                                                                                 AS 'Invoice-Parties/Buyer/TaxID'
			, --Налоговый идентификационный номер покупателя
					c.Code                                                                                                                                                    AS 'Invoice-Parties/Buyer/UtilizationRegisterNumber'
			, --ЄДРПОУ покупателя (не должен превышать 8 знаков)
					c.Contract1                                                                                                                                               AS 'Invoice-Parties/Buyer/Name'
			, --Название покупателя
					[c].[Address]                                                                                                                                             AS 'Invoice-Parties/Buyer/StreetAndNumber'
			, --Улица и номер дома покупателя
					c.City                                                                                                                                                    AS 'Invoice-Parties/Buyer/CityName'
			, --Город покупателя
					c.PostIndex                                                                                                                                               AS 'Invoice-Parties/Buyer/PostalCode'
			, --Почтовый код покупателя
					'804'                                                                                                                                                     AS 'Invoice-Parties/Buyer/Country'
			, --Код страны покупателя (код ISO 3166) --https://www.iso.org/obp/ui/#search/code/
					c.Phone1                                                                                                                                                  AS 'Invoice-Parties/Buyer/PhoneNumber'
			, --Телефон покупателя
			--продавец
					COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode)            AS 'Invoice-Parties/Seller/ILN'
			, --GLN продавца [0-9](13) (можно взять здесь: at_t_IORecX)
					o.TaxCode                                                                                                                                                 AS 'Invoice-Parties/Seller/TaxID'
			, --Налоговый идентификационный номер продавца
					zc.ContrID                                                                                                                                                AS 'Invoice-Parties/Seller/CodeByBuyer'
			, --Код продавца (значение поля должно быть 5-значным числом)
					o.Code                                                                                                                                                    AS 'Invoice-Parties/Seller/UtilizationRegisterNumber'
			, --ЄДРПОУ продавца (не должен превышать 8 знаков)
					o.OurName                                                                                                                                                 AS 'Invoice-Parties/Seller/Name'
			, --Название продавца
					[o].[Address]                                                                                                                                             AS 'Invoice-Parties/Seller/StreetAndNumber'
			, --Улица и номер дома продавца
					o.City                                                                                                                                                    AS 'Invoice-Parties/Seller/CityName'
			, --Город продавца
					o.PostIndex                                                                                                                                               AS 'Invoice-Parties/Seller/PostalCode'
			, --Почтовый код продавца
					'804'                                                                                                                                                     AS 'Invoice-Parties/Seller/Country'
			, --Код страны продавца (код ISO 3166)
					o.Phone                                                                                                                                                   AS 'Invoice-Parties/Seller/PhoneNumber'
			, --Телефон продавца
					COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) AS 'Invoice-Parties/DeliveryPoint/ILN'
			, --GLN точки доставки [0-9](13) (можно взять здесь: at_t_IORecX)

			-- '2019-11-28 13:30' rkv0 прописываем константой "77" - доставка только на этот РЦ в Киеве (на магазины Василенко делает заказы через КПК).
			--COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPOINT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPOINT)[1]', 'VARCHAR(13)'), rca.GLNCode) AS 'Invoice-Parties/DeliveryPoint/DeliveryPlace', --Код точки доставки (len < 2)
					'77'                                                                                                                                                      AS 'Invoice-Parties/DeliveryPoint/DeliveryPlace'
			, --Код точки доставки (len < 2); РЦ в Киеве; GLN: 4820086639309, Local 77 DFNF BBXD FM Kyiv, Адрес: 08330 Київська обл., Бориспільський р-н, с. Дударків вул. Незалежності, 2/2. rkv0 Захардкодил '77', т.к. тяжело это парсить из поля GLNName (ни разу еще не менялось).

			-- '2019-11-28 14:10' rkv0 добавляю тег Invoicee ILN
					COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'), ir.GLNCode)                  AS 'Invoice-Parties/Invoicee/ILN'
			, --GLN для выставления счета [0-9](13) (можно взять здесь: at_t_IORecX)

					COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'), ir.GLNCode)                  AS 'Invoice-Parties/Payer/ILN'
			, --GLN плательщика [0-9](13) (можно взять здесь: at_t_IORecX)

			--tag 'Invoice-Lines' (перечень товаров с количеством и ценами)
					(SELECT ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS 'Line-Item/LineNumber'
			, --Номер позиции
							tpp.ProdBarCode                              AS 'Line-Item/EAN'
			, --Штрих-код [0-9](14)
							ec.ExtProdID                                 AS 'Line-Item/BuyerItemCode'
			, --Код, идентифицирующий товар у покупателя, поле цифровое, не может содержать точки и только нули
							dd.ProdID                                    AS 'Line-Item/SupplierItemCode'
			,--Код, идентифицирующий товар у продавца
							tpp.CstProdCode                              AS 'Line-Item/ExternalItemCode'
			, --Код товара согласно УКТ ВЭД
			--[FIXED] rkv0 '2020-11-13 10:47' для сети METRO делаю замену символа "+" на пустоту "".
			--p.Notes AS 'Line-Item/ItemDescription', --Описание товара (системой не допускаются знаки („+"; " ' "; „:" )
							REPLACE(p.Notes,'+', '')                     AS 'Line-Item/ItemDescription'
			, --Описание товара (системой не допускаются знаки („+"; " ' "; „:" )
							CAST(SUM(dd.Qty) AS NUMERIC(21,3))           AS 'Line-Item/InvoiceQuantity'
			, --Количество товара по накладной (3 знака после запятой!)
							'PCE'                                        AS 'Line-Item/UnitOfMeasure'
			, --Единицы измерения
							CAST(dd.PriceCC_nt AS NUMERIC(21,2))         AS 'Line-Item/InvoiceUnitNetPrice'
			, --Цена одной единицы без НДС
							CAST(20 as NUMERIC(21,2))                    AS 'Line-Item/TaxRate'
			, --Ставка НДС
							'S'                                          AS 'Line-Item/TaxCategoryCode'
			, --Код категория НДС: "E" (освобожден) – освобожден от уплаты налога, "S" (стандарт) – стандартный налог
							CAST(SUM(dd.TaxSum) AS NUMERIC(21,2))        AS 'Line-Item/TaxAmount'
			, --Сумма налога
							CAST(SUM(dd.SumCC_nt) AS NUMERIC(21,2))      AS 'Line-Item/NetAmount' --Сумма без НДС,

			FROM      dbo.t_InvD            dd WITH(NOLOCK)  

			JOIN      dbo.r_Prods           p WITH(NOLOCK)    ON p.ProdID = dd.prodid
			JOIN      dbo.t_PInP            tpp WITH(NOLOCK)  ON tpp.ProdID = dd.ProdID
					AND tpp.PPID = dd.PPID
			LEFT JOIN dbo.at_r_CompOurTerms rcot WITH(NOLOCK) ON rcot.CompID = m.CompID
					AND rcot.OurID = m.OurID
			LEFT JOIN dbo.r_ProdEC          ec WITH(NOLOCK)   ON ec.ProdID=p.ProdID
					AND ec.CompID = rcot.BCompCode
			WHERE dd.ChID = m.ChID
			-- '2019-10-16 15:50' rkv0 убираем группировку по полю: dd.SumCC_wt
			GROUP BY ec.ExtProdID
			,        dd.ProdID
			,        tpp.CstProdCode
			,        p.Notes
			,        p.UM
			,        dd.PriceCC_nt
			,        tpp.ProdBarCode
			,        dd.TaxSum
			,        dd.SumCC_nt /*dd.SumCC_wt*/

			FOR XML PATH ('Line'), TYPE, ROOT ('Invoice-Lines'))                                                                                                            
			,

			--tag 'Invoice-Summary'
			-- '2019-12-11 19:17' rkv0 изменил CAST(MAX(SrcPosID) AS int) на COUNT(ChID)
			--(SELECT CAST(MAX(SrcPosID) AS int) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/TotalLines', --Количество строк в документе
			-- [FIXED] rkv0 '2020-09-28 10:55' TotalLines считать надо по количеству строк в расходной.
			--(SELECT count(distinct ProdID) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS 'Invoice-Summary/TotalLines', --Количество строк в документе
					(SELECT count(*)
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                                                                             AS 'Invoice-Summary/TotalLines'
			, --Количество строк в документе
					(SELECT CAST(SUM(SumCC_nt) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                                                                             AS 'Invoice-Summary/TotalNetAmount'
			, --Общая сумма без НДС
					(SELECT CAST(SUM(TaxSum) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                                                                             AS 'Invoice-Summary/TotalTaxAmount'
			, --Сумма НДС
					(SELECT CAST(SUM(SumCC_wt) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                                                                             AS 'Invoice-Summary/TotalGrossAmount'
			, --Общая сумма с НДС
					CAST(20 as decimal(19,2))                                                                                                                                 AS 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxRate'
			, --Размер налога
					'S'                                                                                                                                                       AS 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxCategoryCode'
			, --Код категория НДС: "E" (освобожден) – освобожден от уплаты налога, "S" (стандарт) – стандартный налог
					(SELECT CAST(SUM(TaxSum) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                                                                             AS 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxAmount'
			, --Сумма налога для каждой категории налога
					(SELECT CAST(SUM(SumCC_nt) AS NUMERIC(21,2))
			FROM dbo.t_InvD WITH(NOLOCK)
			WHERE ChID = m.ChID)                                                                                                                                             AS 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxableAmount' --Налогооблагаемая сумма по выбранной категории налога

			FROM        dbo.t_Inv                                      m WITH(NOLOCK)   

			JOIN        dbo.r_CompsAdd                                 rca WITH(NOLOCK)  ON rca.CompID = m.CompID
					AND rca.CompAdd = m.Address
			JOIN        dbo.t_IORec                                    ir WITH(NOLOCK)   ON @OrdChID = ir.Chid
			JOIN        dbo.r_Ours                                     o WITH(NOLOCK)    ON m.OurID = o.OurID
			CROSS APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) c                
			LEFT JOIN   dbo.z_DocLinks                                 zdl WITH(NOLOCK)  ON zdl.ChildChID = m.ChID
					AND zdl.ChildDocCode = 11012
					AND zdl.ParentDocCode = 666028
			LEFT JOIN   dbo.at_z_Contracts                             zc WITH(NOLOCK)   ON zc.ChID = zdl.ParentChID
			JOIN        dbo.at_t_IORecX                                irx WITH(NOLOCK)  ON irx.ChID = @OrdChID
			LEFT JOIN   dbo.r_CompsCC                                  rccc WITH(NOLOCK) ON rccc.CompID = m.CompID
					AND rccc.DefaultAccount = 1


			WHERE m.ChID = @ChID
				AND rca.GLNCode <> ''
				AND (
					ISNULL(ir.GLNCode, '') <> ''
					OR irx.XMLData IS NOT NULL)
				AND m.TaxDocID <> 0
				AND ir.OrderID IS NOT NULL
				AND ir.OrderID != ''
			FOR XML PATH ('Document-Invoice'))

		END;
		--#endregion COMDOC_METRO (Коммерческий документ: товарная накладная document_invoice)
	--#region PACKAGE_METRO (XML для архива)
	ELSE IF @DocType = 'PACKAGE_METRO' ----создает package.xml для documentpacket (отправка пакета для сети Metro).
		BEGIN

			SET @Out = (
			SELECT 'optional название правила проверки, сейчас только METROUZD' as 'comment()'
			, --добавляем комментарий (см. выше)
					'METROUZD'                                                   as 'processingRule'
			, --<!-- optional название правила проверки, сейчас только METROUZD-->

			--вставляем №DECLAR
					(SELECT 'атрибуты crypted  signed signExternal опциональны, и сейчас не используются, понадобятся при дальнейших доработках' as 'comment()'
			, --добавляем комментарий (см. выше)
							'false'                                                                                                              as 'document/@crypted'
			,              'true'                                                                                                               as 'document/@signed'
			,              'false'                                                                                                              as 'document/@signExternal'
			,

			-- '2019-12-11 18:34' rkv0 добавил DISTINCT для возможности повторной отправки DECLAR.
							(SELECT DISTINCT REPLACE([FileName], 'xml', 'p7s')
			FROM at_z_FilesExchange
			--[FIXED] '2021-03-17 17:21' rkv0 изменил условие для нового формата налоговой (для исключения наложения файлов старой и новой версии).
			--WHERE [FileName] LIKE '%J12%'
			WHERE [FileName] LIKE '%J1201012%'
				AND FileData.value('(./DECLAR/DECLARBODY/HNUM)[1]', 'varchar(10)') = (SELECT TaxDocID
				FROM t_inv
				WHERE CompID IN (7001,7003)
					AND ChID = @ChID)
				AND FileData.value('(./DECLAR/DECLARBODY/HFILL)[1]', 'varchar(10)') = (SELECT REPLACE(dbo.zf_DateToStr(TaxDocDate), '.', '')
				FROM t_inv
				WHERE CompID IN (7001,7003)
					AND ChID = @ChID))                                                                                                          as 'document/documentFileName'

			FOR XML PATH (''), TYPE)                                           
			, --TYPE – возвращает сформированные XML данные с типом XML, если параметр TYPE не указан, данные возвращаются с типом NVARCHAR(MAX).

			--вставляем №COMDOC
					'true'                                                       as 'document/@crypted'
			,      'true'                                                       as 'document/@signed'
			,      'false'                                                      as 'document/@signExternal'
			,      (SELECT REPLACE([FileName], 'xml', 'p7s')
			FROM at_z_FilesExchange
			WHERE [FileName] LIKE '%documentinvoice%'
				AND FileData.value('(./Document-Invoice/Invoice-Reference/Order/BuyerOrderNumber)[1]', 'varchar(13)') =
				(
				SELECT OrderID
				FROM t_inv
				WHERE CompID IN (7001,7003)
					AND ChID = @ChID
				)
				-- '2019-12-11 18:31' rkv0 выбираем последнюю chid на случай повторной отправки documentinvoice
				AND ChID = (SELECT MAX(ChID)
				FROM at_z_FilesExchange
				WHERE [FileName] LIKE '%documentinvoice%'
					AND FileData.value('(./Document-Invoice/Invoice-Reference/Order/BuyerOrderNumber)[1]', 'varchar(13)') =
					(
					SELECT OrderID
					FROM t_inv
					WHERE CompID IN (7001,7003)
						AND ChID = @ChID
					)
				))                                                              as 'document/documentFileName'


			FOR XML PATH ('packet'), TYPE
			)

		END;
		--#endregion PACKAGE_METRO (XML для архива)
	--#region DECLAR (Коммерческий документ: налоговая накладная)
	ELSE IF @DocType = 'DECLAR'
			EXEC [dbo].[ap_EXITE_TaxDoc] @ChID           = @ChID
			,                            @DocCode        = @DocCode
			,                            @IsConsolidated = 0
			,                            @Out            = @Out OUT;
		--#endregion DECLAR (Коммерческий документ: налоговая накладная)
    --#region IFTMIN (Инструкция по транспортировке)
    -- [ADDED] rkv0 '2020-12-04 13:37' добавил новый документ IFTMIN (Инструкция по транспортировке) для сети Сильпо (Фоззи).
    --Спецификация здесь:--https://wiki.edi-n.com/uk/latest/XML/Fozzy_XML-structure.html#iftmin
    ELSE IF @DocType = 'IFTMIN'
	    BEGIN

		    SET @Out = (
		    SELECT
		    --IFTMIN - Початок документа
			    '1_1'                                                                                                                           AS 'NUMBER' --Номер документа; повинен бути наступного формату X_Y, де Х — це порядковий номер машини, яка їде по замовленню Y — це загальна кількість машин, яка поїде по замовленню (MIN - 1, MAX - 99). Х повинен < або = Y. Наприклад 2_5.
		    , CAST(m.TaxDocDate AS DATE)                                                                                                      AS 'DATE' --Дата документа
		    , CAST(m.TaxDocDate AS DATE)                                                                                                      AS 'DELIVERYDATE' --Дата поставки
		    , CASE WHEN CAST(il.ExpDate AS TIME) <> '00:00:00' THEN LEFT(CAST(il.ExpDate AS TIME), 5) END                                     AS 'DELIVERYTIME' --Час доставки
		    , 'O'                                                                                                                             AS 'DOCTYPE' --Тип документа: O - оригінал, R - заміна

		    --DOCUMENT - Дані про документи (початок блоку)
		    --DOCITEM - Дані про документ (початок блоку)
		    , (SELECT 'ON'       AS 'DOCTYPE' --Допустиме значення «ON» - IFTMIN робиться на базі замовлення
		    ,         ir.OrderID AS 'DOCNUMBER' --Номер замовлення
		    FROM dbo.t_Inv   m WITH(NOLOCK) 
		    JOIN dbo.t_IORec ir WITH(NOLOCK) ON ir.Chid = @OrdChID --Заказ внутренний: Формирование: Заголовок
		    WHERE m.chid = @ChID
		    FOR XML PATH ('DOCITEM'), ROOT ('DOCUMENT'), TYPE) --Дані про документ (закінчення блоку), Дані про документи (закінчення блоку).

		    --HEAD Початок основного блоку
		    , (SELECT COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'))                      AS 'CONSIGNOR' --GLN вантажовідправника (постачальника)
		    ,         COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) AS 'DELIVERYPLACE' --GLN місця доставки
		    ,         COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'))                      AS 'SENDER' --GLN відправника повідомлення
		    ,         COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)'))                            AS 'RECIPIENT' --GLN одержувача повідомлення

		    --POSITIONS Товарні позиції (початок блоку)
		    ,         (SELECT '1' /*пока хардкодим, больше одного пока не встречалось*/ AS 'POSITIONNUMBER' --Номер позиції
		    --,'201' /*пока хардкодим, нужны допполя в РН*/ AS 'PACKAGETYPE' --Тип упаковки «(Тип палет: 09 – зворотний піддон; 200 – палета ISO 0 – 1/2 EURO Pallet; 201 – палета ISO 1 – 1/1 EURO Pallet)»
		    ,                 ISNULL((SELECT PalType
		    FROM at_t_InvLoad
		    WHERE ChID = @ChID), '200')                                                 AS 'PACKAGETYPE' --Тип упаковки «(Тип палет: 09 – зворотний піддон; 200 – палета ISO 0 – 1/2 EURO Pallet; 201 – палета ISO 1 – 1/1 EURO Pallet)»
		    --,'1' /*пока хардкодим, нужны допполя в РН*/ AS 'PACKAGEQUANTITY' --Кількість упаковок (=фактическое количество паллет).
		    ,                 (SELECT PalQty
		    FROM at_t_InvLoad
		    WHERE ChID = @ChID)                                                         AS 'PACKAGEQUANTITY' --Кількість упаковок (=фактическое количество паллет).
		    --,'6' /*пока хардкодим, нужны допполя в РН*/ AS 'PACKAGEWIGHT' --Вага
		    ,                 ISNULL((SELECT CarPayload
		    FROM at_t_InvLoad
		    WHERE ChID = @ChID), 20)                                                    AS 'PACKAGEWIGHT' --Вага
		    --,'16' /*пока хардкодим, нужны допполя в РН*/ AS 'MAXPACKAGEQUANTITY' --Максимальна кількість упаковок
		    ,                 ISNULL((SELECT PalQtyMAX
		    FROM at_t_InvLoad
		    WHERE ChID = @ChID), 32)                                                    AS 'MAXPACKAGEQUANTITY' --Максимальна кількість упаковок
		    FOR XML PATH ('POSITIONS'), TYPE) --Товарні позиції (закінчення блоку)                                                                                             

		    FROM dbo.t_Inv       m WITH(NOLOCK)  
		    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID --Заказ внутренний: Формирование: Доп инфо (XML)
		    JOIN dbo.r_CompsAdd  rca WITH(NOLOCK) ON rca.CompID = m.CompID
				    AND rca.CompAdd = m.[Address]
		    WHERE m.Chid = @ChID
		    FOR XML PATH ('HEAD'), TYPE) --Закінчення основного блоку                                                                        

		    FROM      t_inv        m WITH(NOLOCK) 
		    LEFT JOIN at_t_InvLoad il WITH(NOLOCK) ON il.ChID = m.ChID --at_t_InvLoad = Расходная накладная: Детали погрузки
		    WHERE m.chid = @ChID
		    FOR XML PATH ('IFTMIN'), TYPE --Закінчення документа
		    )

	    END;
	    --#endregion IFTMIN (Инструкция по транспортировке)
	--#region CONTRL (Отчет об отгрузке)
	-- [ADDED] rkv0 '2020-12-07 18:48' добавил новый документ CONTRL (Отчет об отгрузке) для сети Сильпо (Фоззи).
	--Спецификация здесь:-https://wiki.edi-n.com/uk/latest/XML/Fozzy_XML-structure.html#contrl
/*
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='CONTRL', @DocCode=11012, @ChID=200478804,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;
*/
	ELSE IF @DocType = 'CONTRL'
		BEGIN

			/* Получение данных recadv. */
			--Номер RECADV.
			BEGIN
				DECLARE @query_number_recadv NVARCHAR(MAX)
				DECLARE @OutByDynamicSQLRecadvNumber_Silpo VARCHAR(50)
				SET @query_number_recadv = 'SELECT @outs = (
SELECT ID ''Номер RECADV'' FROM [s-ppc.const.alef.ua].[Alef_Elit].[dbo].[at_EDI_reg_files] aerf
WHERE 1 = 1 
AND Notes = (SELECT OrderID FROM dbo.t_Inv m WITH(NOLOCK) WHERE m.TaxDocID != 0 and m.chid = ' + CAST(@chid as varchar) + ')
AND aerf.doctype = 5000 
AND aerf.RetailersID = 14
AND chid = (SELECT max(chid) FROM [s-ppc.const.alef.ua].[Alef_Elit].[dbo].[at_EDI_reg_files] WHERE Notes = (SELECT OrderID FROM dbo.t_Inv m WITH(NOLOCK) WHERE m.TaxDocID != 0 and m.chid = ' + CAST(@chid as varchar) + ') )
)'
				EXEC sp_executesql @query_number_recadv
				,                  N'@outs VARCHAR(50) OUT'
				,                  @OutByDynamicSQLRecadvNumber_Silpo OUT
			--SELECT @OutByDynamicSQLRecadvNumber_Silpo
			END;

			--Дата RECADV (или добавлять xml поле в alef_edi_recadv и вытягивать с тега, или внести поправку на InsertData -1 день: если отправляют desadv вечером, recadv придет утром...).
			BEGIN
				DECLARE @query_date                      NVARCHAR(MAX)
				,       @OutByDynamicSQLRecadvDate_Silpo date
				SET @query_date = 'SELECT @outs = (
SELECT convert(date, InsertData, 102) ''Дата RECADV'' FROM [s-ppc.const.alef.ua].[Alef_Elit].[dbo].[at_EDI_reg_files] aerf
WHERE 1 = 1 
AND Notes = (SELECT OrderID FROM dbo.t_Inv m WITH(NOLOCK) WHERE m.TaxDocID != 0 and m.chid = ' + CAST(@chid as varchar) + ')
AND aerf.doctype = 5000 
AND aerf.RetailersID = 14
AND chid = (SELECT max(chid) FROM [s-ppc.const.alef.ua].[Alef_Elit].[dbo].[at_EDI_reg_files] WHERE Notes = (SELECT OrderID FROM dbo.t_Inv m WITH(NOLOCK) WHERE m.TaxDocID != 0 and m.chid = ' + CAST(@chid as varchar) + ') )
)'
				EXEC sp_executesql @query_date
				,                  N'@outs date OUT'
				,                  @OutByDynamicSQLRecadvDate_Silpo OUT
			--SELECT @OutByDynamicSQLRecadvDate_Silpo
			END;

			SET @Out = (
			SELECT
			--CONTRL - Початок документа
				ISNULL(@OutByDynamicSQLRecadvNumber_Silpo, 'n/a')                                                                                            AS 'NUMBER' --Номер документу основи (повідомлення про прийом RECADV)
			, cast(GETDATE() as date)                                                                                                                      AS 'DATE' --Дата документа
			, ISNULL(@OutByDynamicSQLRecadvDate_Silpo, '01-01-1900')                                                                                       AS 'RECADVDATE' --Дата документа RECADV
			, irx.XMLData.value('(./ORDER/NUMBER)[1]', 'VARCHAR(50)')                                                                                      AS 'ORDERNUMBER' --Номер замовлення (документа ORDER)
			, irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(50)')                                                                                        AS 'ORDERDATE' --Дата замовлення (документа ORDER)
			-- [CHANGED] '2021-03-24 15:28' rkv0 изменил тег SENDER.
			--, COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'varchar(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'varchar(13)')) AS 'SENDER' --GLN одержувача (з Повідомлення про прийом)
			, COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'varchar(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'varchar(13)'))           AS 'SENDER' --GLN одержувача (з Повідомлення про прийом)
			, COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'varchar(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'varchar(13)')) AS 'DELIVERYPLACE' --GLN місця доставки
			, COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'))                 AS 'RECIPIENT' --GLN одержувача документу (покупця)
			, COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'))           AS 'SUPPLIER' --GLN відправника документу (постачальника)
			, COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)'))                 AS 'BUYER' --GLN покупця
			, '1'                                                                                                                                          AS 'ACTION' --Статусне поле; допустиме значення лише «1»

			FROM dbo.t_Inv       m WITH(NOLOCK)  
			JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID --Заказ внутренний: Формирование: Доп инфо (XML)
			WHERE m.Chid = @ChID
			FOR XML PATH ('CONTRL'), TYPE --Закінчення документа
			)

		END;
--#endregion CONTRL (Отчет об отгрузке)

END;
--#endregion PROCEDURE







GO
