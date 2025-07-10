DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='COMDOC_PUZO', @DocCode=11012, @ChID=200460947,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token, @xml;

SELECT * FROM at_sendxml ORDER BY datesend DESC --для Велике Пузо.
SELECT * FROM at_sendxml WHERE ChID = 200440000 ORDER BY datesend DESC --для Велике Пузо.
SELECT DateCreate, DateSend, [XML], Notes FROM at_sendxml WHERE ChID = 200459306 ORDER BY datesend DESC --для Велике Пузо.

SELECT * FROM r_Comps WHERE CodeID2 = 810 and compid in (61480, 73385, 73388) --[ap_OP_Importt_Inv802][ap_OP_SendXML802]      
SELECT * FROM t_Inv WHERE compid in (61480, 73385, 73388) ORDER BY DocDate DESC
SELECT OrderID, * FROM t_Inv WHERE ChID = 200440000
SELECT * FROM r_uni WHERE reftypeid = 80019 and RefID = 73385
SELECT * FROM r_uni WHERE reftypeid = 80019 and RefID = 61480
SELECT * FROM r_comps WHERE CompID in (61480, 73385, 73388)
--TRAN
BEGIN
BEGIN TRAN
SELECT * FROM r_uni WHERE reftypeid = 80019 and RefID = 61480
insert into r_Uni VALUES(80019, 61480, 'ТЕСТ_пузо_Бриг', 'COMDOC_PUZO')
SELECT * FROM r_uni WHERE reftypeid = 80019 and RefID = 61480
ROLLBACK TRAN
END;
SELECT * FROM r_uni WHERE reftypeid = 80021
--av_c_PlanRec	Планирование: Доходы: Детали (Группировка по реквизитам)

--80019	73385	ТЕСТ_пузо	COMDOC_ROZETKA
DECLARE @xml XML, @token INT; EXEC [ap_EXITE_ExportDoc] @DocType='COMDOC_PUZO', @DocCode=11012, @ChID=200460944,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; SELECT @token 'Token', @xml 'XML';
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*xml*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
/*200460991
200460942
200460953
200460950
200460944*/
DECLARE @DocCode INT = 11012
DECLARE @ChID INT = 200460944 --ген 200459306 --для сравнения: Розетка 200434564
DECLARE @OrdChID INT = dbo.af_GetParentChID(@DocCode, @ChID, 11221)


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


    SELECT
      m.TaxDocID 'Заголовок/НомерДокументу',
      'Видаткова накладна' AS 'Заголовок/ТипДокументу',
      '006' AS 'Заголовок/КодТипуДокументу',
      CAST(m.TaxDocDate AS DATE) AS 'Заголовок/ДатаДокументу',
      CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END AS 'Заголовок/НомерЗамовлення',
      --irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'Заголовок/ДатаЗамовлення',
      CAST(ir.DocDate AS DATE) AS 'Заголовок/ДатаЗамовлення',
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
        o.Phone AS 'Телефон'
        --COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) AS 'GLN'
        --0 AS 'GLN' --номера GLN нет, т.к. не работаем через провайдера.
   
        UNION

        SELECT 
        'Покупець' AS 'СтатусКонтрагента',
        'Юридична' AS 'ВидОсоби',
        RTRIM(CASE WHEN c.IsBranch = 1 THEN c.Contract2 ELSE c.Contract1 END) AS 'НазваКонтрагента',
        c.Code AS 'КодКонтрагента',
        c.TaxCode AS 'ІПН',
        rccc.BankID AS 'МФО',
        rccc.CompAccountCC AS 'ПоточРах',
        c.TaxPhone AS 'Телефон'
        --COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) AS 'GLN'
        --0 AS 'GLN' --номера GLN нет, т.к. не работаем через провайдера.

        
        ) AS contragents

        FOR XML PATH ('Контрагент'), TYPE)
      FOR XML PATH ('Сторони'), TYPE
    ),
    (SELECT (
    (SELECT * FROM
/*      --(SELECT 'Точка доставки' AS 'Параметр/@назва', 1 AS 'Параметр/@ІД', COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) AS 'Параметр'
      (SELECT 'Точка доставки' AS 'Параметр/@назва', 1 AS 'Параметр/@ІД', '0' AS 'Параметр' --номера GLN нет, т.к. не работаем через провайдера.
      UNION
      SELECT 'Адреса доставки', 2, rca.CompAdd) params*/
      (SELECT 'Адреса доставки' AS 'Параметр/@назва', 1 AS 'Параметр/@ІД', rca.CompAdd AS 'Параметр') as params --номера GLN нет, т.к. не работаем через провайдера.
      FOR XML PATH (''), TYPE))
    FOR XML PATH ('Параметри'), TYPE
    ),
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*ДЕТАЛЬНАЯ ЧАСТЬ*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.[Address]
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    CROSS APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) c
    LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
    LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
    --JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    LEFT JOIN dbo.r_CompsCC rccc WITH(NOLOCK) ON rccc.CompID = m.CompID AND rccc.DefaultAccount = 1
    WHERE 1 = 1
        AND m.ChID = @ChID
        --AND rca.GLNCode <> ''
        --AND (ISNULL(ir.GLNCode, '') <> '' /*OR irx.XMLData IS NOT NULL*/)
        --AND m.TaxDocID <> 0
        AND ir.OrderID IS NOT NULL
        AND ir.OrderID != ''
    FOR XML PATH ('ЕлектроннийДокумент')
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*TEST без деталей*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF 1 = 0
BEGIN
DECLARE @DocCode INT = 11012
DECLARE @ChID INT = 200460990 --для сравнения: Розетка 200434564
DECLARE @OrdChID INT = dbo.af_GetParentChID(@DocCode, @ChID, 11221)
--SELECT @OrdChID

    SELECT * FROM dbo.t_Inv m WITH(NOLOCK)
        JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.[Address]
        JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
        JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
        CROSS APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) c
        LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
        LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
        --JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID --at_t_IORecX	Заказ внутренний: Формирование: Доп инфо (XML)
        LEFT JOIN dbo.r_CompsCC rccc WITH(NOLOCK) ON rccc.CompID = m.CompID AND rccc.DefaultAccount = 1
        --WHERE m.ChID = @ChID
    WHERE 1 = 1
        AND m.ChID = @ChID
        --AND rca.GLNCode <> ''
        --AND (ISNULL(ir.GLNCode, '') <> '' /*OR irx.XMLData IS NOT NULL*/)
        --AND m.TaxDocID <> 0
        AND ir.OrderID IS NOT NULL
        AND ir.OrderID != ''
END;


/*DECLARE @DocCode INT = 11012
DECLARE @ChID INT = 200434564 --для сравнения: Розетка 200434564
DECLARE @OrdChID INT = dbo.af_GetParentChID(@DocCode, @ChID, 11221)
SELECT @OrdChID
SELECT * FROM at_t_IORecX irx WHERE irx.ChID = 102292317*/