USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EXITE_TaxDoc]    Script Date: 04.03.2021 17:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[ap_EXITE_TaxDoc] @ChID INT, @DocCode INT = 0, @IsConsolidated BIT = 0, @Out XML OUT
AS
BEGIN
  /*
  DECLARE @Out XML; EXEC [dbo].[ap_EXITE_TaxDoc] @ChID = 200474295, @DocCode = 11012, @IsConsolidated = 0, @Out = @Out OUT; SELECT @Out 
  */
  SET NOCOUNT ON
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /*INFO*/
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  --Процедура формирования xml файла налоговой накладной.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [FIXED] rkv0 '2021-01-15 20:07' был разрыв цепочки, когда дата нашей расходной != дате их приходной (теперь тянется дата из xml их приходной).
--20181207 pvm0  переход на новую версию с 9 на 10 J1201010
--20190110 pvm0  изменен код с 2801 на 2810 <C_STI_ORIG>2810</C_STI_ORIG> (номер ДПI - ОФМС ВЕЛИКИХ ПЛАТНИКИВ)
--20190111 pvm0  изменен код с 1 на 10 <C_RAJ>10</C_RAJ> (номер ДПI - ОФМС ВЕЛИКИХ ПЛАТНИКИВ)
-- [CHANGED] '2020-07-08 18:10' rkv0 убираем нули (письмо от Гали Танцюры: "сеть МЕТРО не принимает на подпись товарные с нулями в начале").
-- [CHANGED] '2020-11-10 20:02' rkv0 для сети METRO меняю <SOFTWARE>COMDOC на <SOFTWARE>ORDER. ##RE-433##
-- [FIXED] rkv0 '2020-11-13 10:47' для сети METRO делаю замену символа "+" на пустоту "".
-- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
-- [FIXED] rkv0 '2021-01-27 16:55' прокастил дату для Розетки (берется из нашей расходной). 
-- [ADDED] rkv0 '2021-03-01 16:25' добавил новый тег согласно новой спецификации (заявка #5133).
-- [CHANGED] rkv0 '2021-03-01 17:03' изменил версию с 10 на 11: <xs:element name="C_DOC_SUB" type="xs:string" fixed="010"/> (заявка #5133).
-- [CHANGED] rkv0 '2021-03-01 17:37' изменил версию xsd 'J1201010.xsd' на 'J1201011.xsd' (заявка #5133).



/*
		(SELECT top 1 isnull(Notes,'') FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_REG>%')  AS 'C_REG', -- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
		(SELECT top 1 isnull(Notes,'') FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_RAJ>%')  AS 'C_RAJ', -- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
		(SELECT top 1 isnull(Notes,'') FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_STI_ORIG>%') AS 'C_STI_ORIG', -- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
*/
--[CHANGED] rkv0 '2021-01-05 17:19' изменил в справочнике (r_Uni - 6680138 - <C_RAJ>) '0' на '00' для большей наглядности (не влияет на регистрацию).

  --PRINT @ChID
  /*#-BeginDebug Chid
  DECLARE @ChID INT = (SELECT MAX(ChID) FRom t_Inv WHERE TaxDocID > 0  AND TSumCC_wt > 10000 AND CodeID2 = 58)
  DECLARE @IsConsolidated BIT = 0
  DECLARE @DocCode INT = 0
  #-EndDebug*/

  DECLARE @Ch TABLE (ChID INT)
  IF @IsConsolidated = 0
    INSERT @Ch
    VALUES (@ChID)
  ELSE
	BEGIN
		IF @DocCode = 11012
			INSERT @Ch
			SELECT m.ChID
			FROM dbo.t_Inv m WITH(NOLOCK)
			JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID
			WHERE EXISTS(SELECT * FROM dbo.t_Inv m0 WITH(NOLOCK) JOIN dbo.r_Comps rc0 WITH(NOLOCK) ON rc0.CompID=m0.CompID WHERE m0.ChID = @ChID AND m0.TaxDocID = m.TaxDocID AND rc0.Value1 = rc.Value1 AND m0.OurID = m.OurID AND dbo.zf_GetMonthFirstDay(m0.DocDate) = dbo.zf_GetMonthFirstDay(m.DocDate))
		ELSE IF @DocCode = 11003
			INSERT @Ch
			SELECT m.ChID
			FROM dbo.t_Ret m WITH(NOLOCK)
			JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID
			WHERE EXISTS(SELECT * FROM dbo.t_Ret m0 WITH(NOLOCK) JOIN dbo.r_Comps rc0 WITH(NOLOCK) ON rc0.CompID=m0.CompID WHERE m0.ChID = @ChID AND m0.TaxDocID = m.TaxDocID AND rc0.Value1 = rc.Value1 AND m0.OurID = m.OurID AND dbo.zf_GetMonthFirstDay(m0.DocDate) = dbo.zf_GetMonthFirstDay(m.DocDate))
	END
    
  IF (@DocCode = 11012 AND EXISTS(SELECT * FROM dbo.t_Inv WHERE ChID = @ChID AND DocDate < '20150101'))
			OR (@DocCode = 11003 AND EXISTS(SELECT * FROM dbo.t_Ret WHERE ChID = @ChID AND DocDate < '20150101'))
  BEGIN
    RAISERROR('Невозможно отправить налоговый документ в периоде до 01.01.2015 г. Операция отменена.
    ', 18, 1)
    RETURN
  END

    -- '2019-12-18 13:32' rkv0 времянка для сети METRO
    IF OBJECT_ID('tempdb.dbo.#invnum' ,'U') IS NOT NULL DROP TABLE #invnum
    SELECT * INTO #invnum FROM (
    SELECT FileData.value('(./Document-Invoice/Invoice-Header/InvoiceNumber)[1]','varchar(16)') 'InvNum' FROM at_z_filesexchange WHERE [FileName] like '%documentinvoice%'
    ) AS invnum

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*РАСХОДНАЯ НАКЛАДНАЯ*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	IF @DocCode = 11012 --Расходная накладная
	BEGIN  
		WITH TD (ROWNUM, RXXXXG3S, RXXXXG4,RXXXXG32,RXXXXG33, RXXXXG4S, RXXXXG105_2S, RXXXXG5, RXXXXG6,RXXXXG008, RXXXXG010,RXXXXG11_10, RXXXXG9) AS 
		(
			SELECT ROW_NUMBER() OVER(ORDER BY MAX(SrcPosID)) AS 'ROWNUM',
--[FIXED] rkv0 '2020-11-13 10:47' для сети METRO делаю замену символа "+" на пустоту "". ##RE-2297##
				--CAST(LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), p.Notes))) + '; GTIN:' + ISNULL(pp.ProdBarCode,'') + '; IDBY:' + ISNULL(ec.ExtProdID,'') AS VARCHAR(400)) AS 'RXXXXG3S',
				CASE WHEN mm.CompID in (7001, 7003) THEN
                    CAST(LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), REPLACE(p.Notes, '+', '')))) + '; GTIN:' + ISNULL(pp.ProdBarCode,'') + '; IDBY:' + ISNULL(ec.ExtProdID,'') AS VARCHAR(400))
                ELSE    
                    CAST(LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), p.Notes))) + '; GTIN:' + ISNULL(pp.ProdBarCode,'') + '; IDBY:' + ISNULL(ec.ExtProdID,'') AS VARCHAR(400))
                END AS 'RXXXXG3S',
				--NULLIF(pp.CstProdCode, '') AS 'RXXXXG4',
				Case When p.PGrID2 Between 0 and 401 or p.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'RXXXXG4',
				Case When p.ImpID = 1  THEN 1 end   AS 'RXXXXG32',
				Case When p.PGrID2 = 402 THEN pp.CstProdCode end AS 'RXXXXG33',
				rumq.RefName AS 'RXXXXG4S',
				REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'RXXXXG105_2S',
				CAST(SUM(dd.Qty) AS NUMERIC(21,2)) AS 'RXXXXG5',
				CAST(CASE mm.CodeID2 WHEN 58 THEN dd.PriceCC_wt ELSE dd.PriceCC_nt END AS NUMERIC(21,4)) AS 'RXXXXG6',
				20 as 'RXXXXG008',
				SUM(CAST(CASE mm.CodeID2 WHEN 58 THEN 0 ELSE dd.SumCC_nt END AS NUMERIC(21,2))) AS 'RXXXXG010',
				SUM(CAST(CASE mm.CodeID2 WHEN 58 THEN 0 ELSE dd.TaxSum END AS NUMERIC(21,2))) AS 'RXXXXG11_10', -- Сумма НДС
				SUM(CAST(CASE mm.CodeID2 WHEN 58 THEN dd.SumCC_wt ELSE 0 END AS NUMERIC(21,2))) AS 'RXXXXG9'
			FROM dbo.t_Inv mm WITH(NOLOCK)
			JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID=mm.ChID
			JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=dd.ProdID
			JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=dd.ProdID AND pp.PPID=dd.PPID
			LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.CompID = mm.CompID AND ec.ProdID = dd.ProdID
			JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = p.UM
			WHERE mm.ChID IN (SELECT ChID FROM @Ch)
			GROUP BY mm.TaxDocDate, LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), p.Notes))),
--[FIXED] rkv0 '2020-11-13 10:47' для сети METRO делаю замену символа "+" на пустоту "". ##RE-2297##
            LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), REPLACE(p.Notes, '+', '')))), mm.CompID,

			pp.CstProdCode, rumq.RefName, rumq.RefID, dd.PriceCC_wt, dd.PriceCC_nt,
			mm.CodeID2, pp.ProdBarCode, ec.ExtProdID,
			Case When p.PGrID2 Between 0 and 401 or p.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end,
			Case When p.ImpID = 1  THEN 1 end,
			Case When p.PGrID2 = 402 THEN pp.CstProdCode end
		)


		SELECT @Out = (SELECT
		(SELECT 
		dbo.af_GetFiltered(ro.Code) AS 'TIN',
		'J12' AS 'C_DOC',
		'010' AS 'C_DOC_SUB',
		-- [CHANGED] rkv0 '2021-03-01 17:03' изменил версию с 10 на 11: <xs:element name="C_DOC_SUB" type="xs:string" fixed="010"/> (заявка #5133).
        --10 AS 'C_DOC_VER', --pvm0 06,12,2018 сменил версию с 9 по 10
		11 AS 'C_DOC_VER', 
		0 AS 'C_DOC_TYPE',
		RIGHT('00000' + CAST(m.TaxDocID AS VARCHAR) + CAST(ISNULL((SELECT COUNT(*) FROM dbo.z_DocLinks zdlt WITH(NOLOCK) JOIN dbo.at_z_FilesExchange zfet WITH(NOLOCK) ON zfet.ChID = zdlt.ChildChID WHERE zdlt.ParentChID = m.ChID AND zdlt.ParentDocCode = 11012 AND zdlt.ChildDocCode = 666029 AND zfet.StateCode = 403),0) + 1 AS VARCHAR), 7) AS 'C_DOC_CNT',
		(SELECT top 1 isnull(Notes,'') FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_REG>%')  AS 'C_REG', -- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
		(SELECT top 1 isnull(Notes,'') FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_RAJ>%')  AS 'C_RAJ', -- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
		MONTH(m.TaxDocDate) AS 'PERIOD_MONTH',
		1 AS 'PERIOD_TYPE',
		YEAR(m.TaxDocDate) AS 'PERIOD_YEAR',
		(SELECT top 1 isnull(Notes,'') FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_STI_ORIG>%') AS 'C_STI_ORIG', -- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
		1 AS 'C_DOC_STAN',
		REPLACE(dbo.zf_DateToStr(m.TaxDocDate), '.', '') AS 'D_FILL',

		-- '2019-11-29 10:38' rkv0 для сети METRO вместо COMDOC подставляем № documentInvoice (товарная накладная).
        CASE WHEN m.CompID IN (7001,7003) THEN 
        -- '2019-12-18 11:41' rkv0 для сети METRO DocID подставляем по отдельному алгоритму (№документа - № по порядку)
        --'COMDOC:' + CAST((m.DocID) AS VARCHAR) + ';DATE:' + CONVERT(VARCHAR(10), m.TaxDocDate, 120)+';BY:' + irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)') +';SU:' + irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)') 
        -- [CHANGED] '2020-11-10 20:02' rkv0 для сети METRO меняю <SOFTWARE>COMDOC на <SOFTWARE>ORDER. ##RE-433##
        --'COMDOC:' + 
        'ORDER:' + CAST(m.OrderID as varchar)
                    /* Это уже история..
                    -- [CHANGED] '2020-07-08 18:10' rkv0 убираем нули (письмо от Гали Танцюры: "сеть МЕТРО не принимает на подпись товарные с нулями в начале").
                    RIGHT('0000000000' + (SELECT CASE 
                    WHEN (SELECT COUNT(*) FROM #invnum WHERE InvNum LIKE RIGHT(('00000000000' + cast(m.DocID as varchar(16))),10) + '%') = 1 THEN RIGHT(('00000000000' + cast(m.DocID as varchar(16))),10)
                    ELSE
                    --rvk0 '2020-01-30 17:57' убрал -1 из count.
                    (SELECT RIGHT(('00000000000' + cast(m.DocID as varchar(16))),10) + '-' + CAST(COUNT(*) AS varchar(100)) FROM #invnum WHERE InvNum LIKE RIGHT(('00000000000' + cast(m.DocID as varchar(16))),10) + '%')
                    END),10) + 
                    ';DATE:' + CONVERT(VARCHAR(10), m.TaxDocDate, 120)+';BY:' + irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)') +';SU:' + irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)') 
                    */
                    /* Это уже история..        
                    (SELECT CASE 
                    WHEN (SELECT COUNT(*) FROM #invnum WHERE InvNum LIKE cast(m.DocID as varchar(16)) + '%') = 1 THEN cast(m.DocID as varchar(16))
                    ELSE
                    --rvk0 '2020-01-30 17:57' убрал -1 из count.
                    (SELECT cast(m.DocID as varchar(16)) + '-' + CAST(COUNT(*) AS varchar(100)) FROM #invnum WHERE InvNum LIKE cast(m.DocID as varchar(16)) + '%')
                    END)*/
        + ';DATE:' + CONVERT(VARCHAR(10), m.TaxDocDate, 120)+';BY:' + irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)') +';SU:' + irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)') 


        --для остальных сетей
        ELSE
        -- [FIXED] rkv0 '2021-01-15 20:07' был разрыв цепочки, когда дата нашей расходной != дате их приходной (теперь тянется дата из xml их приходной).
/*        'COMDOC:' + CAST(ISNULL((SELECT MAX([AEI_DOC_ID]) FROM [dbo].[az_EDI_Invoices_] WITH(NOLOCK) WHERE [AEI_INV_ID] = m.TaxDocID AND [AEI_INV_DATE] = m.TaxDocDate), m.TaxDocID) AS VARCHAR) + ';DATE:' + CONVERT(VARCHAR(10), m.TaxDocDate, 120)+';BY:' + irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)') +';SU:' + irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)') 
        END AS 'SOFTWARE'*/
        --'COMDOC:' + CAST(ISNULL((SELECT MAX([AEI_DOC_ID]) FROM [dbo].[az_EDI_Invoices_] WITH(NOLOCK) WHERE [AEI_INV_ID] = m.TaxDocID AND [AEI_INV_DATE] = m.TaxDocDate), m.TaxDocID) AS VARCHAR) + ';DATE:' + CONVERT(VARCHAR(10), m.TaxDocDate, 120)+';BY:' + irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)') +';SU:' + irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)') 
        'COMDOC:' + CAST(ISNULL((SELECT MAX([AEI_DOC_ID]) FROM [dbo].[az_EDI_Invoices_] WITH(NOLOCK) WHERE [AEI_INV_ID] = m.TaxDocID AND [AEI_INV_DATE] = m.TaxDocDate), m.TaxDocID) AS VARCHAR) 
        -- [FIXED] rkv0 '2021-01-27 16:55' прокастил дату для Розетки (берется из нашей расходной). 
        --+ ';DATE:' + CAST(ISNULL((SELECT AEI_XML.value('(./ЕлектроннийДокумент/Заголовок/ДатаДокументу)[1]', 'varchar(100)') FROM [dbo].[az_EDI_Invoices_] WITH(NOLOCK) WHERE [AEI_INV_ID] = m.TaxDocID AND [AEI_INV_DATE] = m.TaxDocDate), m.TaxDocDate) AS varchar) 
        + ';DATE:' + CAST(ISNULL((SELECT AEI_XML.value('(./ЕлектроннийДокумент/Заголовок/ДатаДокументу)[1]', 'varchar(100)') FROM [dbo].[az_EDI_Invoices_] WITH(NOLOCK) WHERE [AEI_INV_ID] = m.TaxDocID AND [AEI_INV_DATE] = m.TaxDocDate), CAST(m.TaxDocDate AS date)) AS varchar) 
        +';BY:' + irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)') +';SU:' + irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)') 
        END AS 'SOFTWARE'

		FOR XML PATH('DECLARHEAD'), TYPE), --DECLARHEAD Завершення основного блоку
		(SELECT 
		CASE rc.TaxPayer WHEN 0 THEN 1 END AS 'HORIG1',
		CASE rc.TaxPayer WHEN 0 THEN '02' END AS 'HTYPR',
		REPLACE(dbo.zf_DateToStr(m.TaxDocDate), '.', '') AS 'HFILL',
		m.TaxDocID AS 'HNUM',
		ro.Note2 AS 'HNAMESEL',
		rc.TaxCompName AS 'HNAMEBUY',
		dbo.af_GetFiltered(ro.TaxCode) AS 'HKSEL',
		dbo.af_GetFiltered(ro.Code) AS 'HTINSEL',--налоговый номер продавца (37029549) 20181207 pvm0
        
        -- [ADDED] rkv0 '2021-03-01 16:25' добавил новый тег согласно новой спецификации (заявка #5133).
        '1' AS 'HKS', --(supplier - поставщик) для EDIN может быть только '1' (только юрлица).
            /*Новий реквізит «код», в якому зазначається ознака джерела податкового номера відповідно до реєстру, якому належить податковий номер особи (для продавця)*.
            1 – Єдиний державний реєстр підприємств та організацій України (ЄДРПОУ);
            2 – Державний реєстр фізичних осіб – платників податків (ДРФО);
            3 – реєстраційний (обліковий) номер платника податків, який присвоюється контролюючими органами (для платників податків, які не включені до ЄДРПОУ);
            4 – серія (за наявності) та номер паспорта (для фізичних осіб, які через свої релігійні переконання відмовляються вiд прийняття реєстраційного номера облікової картки платника податків та офіційно повідомили про це відповідний контролюючий орган i мають відмітку у паспорті).
            */
		
        dbo.af_GetFiltered(rc.TaxCode) AS 'HKBUY',
		dbo.af_GetFiltered(rc.Code) AS 'HTINBUY',----налоговый номер покупателя (36003603) 20181207 pvm0
        
        -- [ADDED] rkv0 '2021-03-01 16:25' добавил новый тег согласно новой спецификации (заявка #5133).
        dbo.af_GetCompKB(m.CompID) AS 'HKB', --(buyer - покупатель) аналогично тегу HKS (см. выше).
		
        CAST((SELECT SUM(CAST(dd.SumCC_wt AS NUMERIC(21,2))) FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID=mm.ChID WHERE mm.ChID IN (SELECT ChID FROM @Ch)) AS NUMERIC(21,2)) AS 'R04G11',	
		CAST((SELECT SUM(CAST(CASE mm.CodeID2 WHEN 58 THEN NULL ELSE dd.TaxSum END AS NUMERIC(21,2))) FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID=mm.ChID WHERE mm.ChID IN (SELECT ChID FROM @Ch)) AS NUMERIC(21,2)) AS 'R03G11',	
		CAST((SELECT SUM(CAST(CASE mm.CodeID2 WHEN 58 THEN NULL ELSE dd.TaxSum END AS NUMERIC(21,2))) FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID=mm.ChID WHERE mm.ChID IN (SELECT ChID FROM @Ch)) AS NUMERIC(21,2)) AS 'R03G7',
		CAST(NULLIF((SELECT SUM(RXXXXG010) FROM TD),0) AS NUMERIC(21,2)) AS 'R01G7',
		(SELECT ROWNUM AS 'RXXXXG3S/@ROWNUM', RXXXXG3S FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG4/@ROWNUM', RXXXXG4 FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG4S/@ROWNUM', RXXXXG4S FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG105_2S/@ROWNUM', RXXXXG105_2S FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG5/@ROWNUM', RXXXXG5 FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG6/@ROWNUM', RXXXXG6 FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG008/@ROWNUM', RXXXXG008 FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG010/@ROWNUM', RXXXXG010 FROM TD WHERE RXXXXG010 != 0 FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG11_10/@ROWNUM', RXXXXG11_10 FROM TD WHERE RXXXXG11_10 != 0 FOR XML PATH(''), TYPE), --Сумма НДС 20181207 pvm0
		(SELECT ROWNUM AS 'RXXXXG9/@ROWNUM', RXXXXG9 FROM TD WHERE RXXXXG9 != 0 FOR XML PATH(''), TYPE),
		LEFT(re.UAEmpFirstName, 1) + '.' + LEFT(re.UAEmpParName, 1) + '. ' + re.UAEmpLastName AS 'HBOS',
		re.TaxCode as 'HKBOS'
		FOR XML PATH('DECLARBODY'), TYPE)
		FROM dbo.t_Inv m WITH(NOLOCK)
		JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
		OUTER APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) rc
		JOIN dbo.at_r_OurMEDoc om WITH(NOLOCK) ON om.OurID = m.OurID AND   m.TaxDocDate BETWEEN om.BDate AND om.EDate  /* om.EmpID=5342*/
		JOIN dbo.r_Emps re WITH(NOLOCK) ON re.EmpID = om.EmpID
		JOIN dbo.z_DocLinks z WITH(NOLOCK) ON z.ChildDocCode = 11012 AND z.ParentDocCode = 666028 AND z.ChildChID = m.ChID
		JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = z.ParentChID
		JOIN dbo.r_Uni zcu WITH(NOLOCK) ON zcu.RefTypeID = 6660120 AND zcu.RefID = zc.OffTypeID
		JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = dbo.af_GetParentChID(11012, @ChID, 11221)
		WHERE m.ChID = @ChID
		FOR XML PATH('')) 
	
		;WITH XMLNAMESPACES ('http://www.w3.org/2001/XMLSchema-instance' as xsi)
        -- [CHANGED] rkv0 '2021-03-01 17:37' изменил версию xsd 'J1201010.xsd' на 'J1201011.xsd' (заявка #5133).
        --SELECT @Out = (select 'J1201010.xsd' AS '@xsi:noNamespaceSchemaLocation', @Out for xml path('DECLAR')); --DECLAR Початок документу
		SELECT @Out = (select 'J1201011.xsd' AS '@xsi:noNamespaceSchemaLocation', @Out for xml path('DECLAR')); --DECLAR Початок документу
	END 
    
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*ВОЗВРАТ ТОВАРА ОТ ПОЛУЧАТЕЛЯ*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	ELSE IF @DocCode = 11003 --Возврат товара от получателя
	BEGIN
    select 'test' /*УБРАТЬ И РАСКОММЕНТИТЬ ПОСЛЕ ФИНАЛЬНОЙ КОМПИЛЯЦИИ!!*/
		/*;WITH TD (ROWNUM, RXXXXG1D, RXXXXG2S, RXXXXG3S, RXXXXG4, RXXXXG32, RXXXXG33, RXXXXG4S, RXXXXG105_2S, RXXXXG5, RXXXXG6, RXXXXG7, RXXXXG8, RXXXXG9, _RXXXXG9) AS (
		SELECT
      ROW_NUMBER() OVER(ORDER BY MAX(rtd.ProdID), MAX(rtd.PPID)) ROWNUM, 
      REPLACE(dbo.zf_DateToStr(rtm.TaxDocDate), '.', '') [RXXXXG1D], 
      CASE WHEN rtm.CodeID2 IN (19,69,56) THEN 'Повернення' 
        WHEN rtm.CodeID2 IN (43,38) THEN 'Коригування за ціною' 
        WHEN rtm.CodeID2 IN (44,58) THEN 'Коригування за кількістю'
        ELSE ''
      END [RXXXXG2S],
      CAST(LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes))) + ' ;' +ISNULL(' GTIN:' + pp.ProdBarCode, '') + ';' + ISNULL(' IDBY:' + ec.ExtProdID, '') AS VARCHAR(400)) AS [RXXXXG3S],
      
	  --pp.CstProdCode [RXXXXG4],
	  Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'RXXXXG4',
	  Case When rp.ImpID = 1  THEN 1 end   AS 'RXXXXG32',
	  Case When rp.PGrID2 = 402 THEN pp.CstProdCode end AS 'RXXXXG33',

      rumq.RefName AS [RXXXXG4S],
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS [RXXXXG105_2S],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE SUM(ISNULL(id.Qty, 0)) - SUM(rtd.Qty) END AS NUMERIC(21,6)) [RXXXXG5], 
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE rtd.PriceCC_nt END AS NUMERIC(21,12)) [RXXXXG6],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN ISNULL(id.PriceCC_nt, 0) - rtd.PriceCC_nt ELSE 0 END AS NUMERIC(21,12)) [RXXXXG7],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN SUM(rtd.Qty) ELSE 0 END AS NUMERIC(21,6)) [RXXXXG8],
      CAST(SUM(ISNULL(id.Qty, 0)*ISNULL(id.PriceCC_nt, 0)) - SUM(rtd.Qty*rtd.PriceCC_nt) AS NUMERIC(21,2)) [RXXXXG9],
			CAST(SUM(ISNULL(id.Qty, 0)*ISNULL(id.Tax, 0)) - SUM(rtd.Qty*rtd.Tax) AS NUMERIC(21,2)) AS [_RXXXXG9]
    FROM dbo.t_Ret rtm WITH(NOLOCK)
    JOIN (SELECT ChID, ProdID, PPID, PriceCC_nt, Tax, SUM(Qty) Qty FROM dbo.t_RetD WITH(NOLOCK) GROUP BY ChID, ProdID, PPID, PriceCC_nt, Tax) rtd ON rtd.ChID = rtm.ChID
    LEFT JOIN dbo.t_Inv im WITH(NOLOCK) ON im.TaxDocID = rtm.TaxDocID AND im.OurID = rtm.OurID AND im.StockID = rtm.StockID AND im.CodeID2 = rtm.CodeID2 AND im.DocDate=rtm.DocDate AND rtm.CodeID2 IN (43,44,38)
    LEFT JOIN (SELECT ChID, ProdID, PPID, PriceCC_nt, Tax, SUM(Qty) Qty FROM dbo.t_InvD WITH(NOLOCK) GROUP BY ChID, ProdID, PPID, PriceCC_nt, Tax) id ON id.ChID = im.ChID AND id.ProdID = rtd.ProdID AND id.PPID = rtd.PPID
    JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = rtd.ProdID
		JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=rtd.ProdID AND pp.PPID=rtd.PPID
    LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rtm.CompID AND ec.ProdID = rp.ProdID
    JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = rp.UM
    WHERE rtm.ChID IN (SELECT ChID FROM @Ch)
    AND
    ((rtm.CodeID2 IN (43,38) AND rtd.PriceCC_nt <> ISNULL(id.PriceCC_nt,0)) OR
    (rtm.CodeID2 NOT IN (43,38) AND rtd.Qty <> ISNULL(id.Qty,0)))
    GROUP BY rtm.TaxDocDate, LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes))), pp.CstProdCode,
      rumq.RefName, rumq.RefID, rtm.CodeID2,
			pp.ProdBarCode, ec.ExtProdID,
    CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE rtd.PriceCC_nt END AS NUMERIC(21,12)),
    CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN ISNULL(id.PriceCC_nt, 0) - rtd.PriceCC_nt ELSE 0 END AS NUMERIC(21,12)),
	
	Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end,
	Case When rp.ImpID = 1  THEN 1 end,
	Case When rp.PGrID2 = 402 THEN pp.CstProdCode end
		)

		SELECT @Out = (SELECT
		(SELECT 
		dbo.af_GetFiltered(ro.Code) AS 'TIN',
		'J12' AS 'C_DOC',
		'012' AS 'C_DOC_SUB',
		7 AS 'C_DOC_VER',
		0 AS 'C_DOC_TYPE',
		RIGHT('00000' + CAST(m.TaxDocID AS VARCHAR) + CAST(ISNULL((SELECT COUNT(*) FROM dbo.z_DocLinks zdlt WITH(NOLOCK) JOIN dbo.at_z_FilesExchange zfet WITH(NOLOCK) ON zfet.ChID = zdlt.ChildChID WHERE zdlt.ParentChID = m.ChID AND zdlt.ParentDocCode = @DocCode AND zdlt.ChildDocCode = 666029 AND zfet.StateCode = 403),0) + 1 AS VARCHAR), 7) AS 'C_DOC_CNT',
		(SELECT top 1 isnull(Notes,'') FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_REG>%')  AS 'C_REG', -- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
		(SELECT top 1 isnull(Notes,'') FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_RAJ>%')  AS 'C_RAJ', -- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
		MONTH(m.TaxDocDate) AS 'PERIOD_MONTH',
		1 AS 'PERIOD_TYPE',
		YEAR(m.TaxDocDate) AS 'PERIOD_YEAR',
		(SELECT top 1 isnull(Notes,'') FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_STI_ORIG>%') AS 'C_STI_ORIG', -- [CHANGED] Pashkovv '2021-01-04 14:22' по заявке 3472 переделал способ получения тегов из универсального справочника 6680138
		1 AS 'C_DOC_STAN',
		REPLACE(dbo.zf_DateToStr(m.TaxDocDate), '.', '') AS 'D_FILL',
		'BY:' + irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)') +';SU:' + irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)') AS 'SOFTWARE'
		FOR XML PATH('DECLARHEAD'), TYPE),
		(SELECT 
		CASE WHEN rc.TaxPayer = 1 AND m.SrcTaxDocDate >'20150101' AND (SELECT SUM(RXXXXG9) FROM TD) < 0 THEN 1 END AS 'HERPN',
		CASE rc.TaxPayer WHEN 0 THEN 1 END AS 'HORIG1',
		CASE rc.TaxPayer WHEN 0 THEN '02' END AS 'HTYPR',
		m.TaxDocID AS 'HNUM',
		REPLACE(dbo.zf_DateToStr(m.TaxDocDate), '.', '') AS 'HFILL',
		REPLACE(dbo.zf_DateToStr(m.SrcTaxDocDate), '.', '') AS 'HPODFILL',
		LEFT(m.SrcTaxDocID,7) AS 'HPODNUM',
		REPLACE(dbo.zf_DateToStr(zc.BDate), '.', '') AS 'H01G1D',
		REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(zc.ContrID,'-','@'),'/','#')),'@','-'),'#','/') AS 'H01G2S',
		ro.Note2 AS 'HNAMESEL',
		rc.TaxCompName AS 'HNAMEBUY',
		dbo.af_GetFiltered(ro.TaxCode) AS 'HKSEL',
		dbo.af_GetFiltered(ro.Code) AS 'HTINSEL',--налоговый номер продавца (37029549)
		dbo.af_GetFiltered(rc.TaxCode) AS 'HKBUY',
		dbo.af_GetFiltered(rc.Code) AS 'HTINBUY',----налоговый номер покупателя (36003603)
		ro.[Address] + ', ' + ro.City + ', ' + ro.PostIndex AS 'HLOCSEL',
		rc.TaxAddress AS 'HLOCBUY',
		dbo.af_GetFiltered(ro.Phone) AS 'HTELSEL',
		rc.TaxPhone AS 'HTELBUY',
		zcu.RefName + '; COMDOC:' + CAST(ISNULL((SELECT MAX([AEI_DOC_ID]) FROM [dbo].[az_EDI_Invoices_] WITH(NOLOCK) WHERE [AEI_INV_ID] = m.SrcTaxDocID AND [AEI_INV_DATE] = m.SrcTaxDocDate), m.SrcTaxDocID) AS VARCHAR) + ';DATE:' + CONVERT(VARCHAR(10), m.SrcTaxDocDate, 120) + ';;' AS 'H02G1S',
		REPLACE(dbo.zf_DateToStr(zc.BDate), '.', '') AS 'H02G2D',
		REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(zc.ContrID,'-','@'),'/','#')),'@','-'),'#','/') AS 'H02G3S',
		(SELECT ROWNUM AS 'RXXXXG1D/@ROWNUM', RXXXXG1D FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG2S/@ROWNUM', RXXXXG2S FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG3S/@ROWNUM', RXXXXG3S FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG4/@ROWNUM', RXXXXG4 FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG4S/@ROWNUM', RXXXXG4S FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG105_2S/@ROWNUM', RXXXXG105_2S FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG5/@ROWNUM', RXXXXG5 FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG6/@ROWNUM', RXXXXG6 FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG7/@ROWNUM', RXXXXG7 FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG8/@ROWNUM', RXXXXG8 FROM TD FOR XML PATH(''), TYPE),
		(SELECT ROWNUM AS 'RXXXXG9/@ROWNUM', RXXXXG9 FROM TD FOR XML PATH(''), TYPE),
		CAST(NULLIF((SELECT SUM(RXXXXG9) FROM TD),0) AS NUMERIC(21,2)) AS 'R01G9',
		CAST(NULLIF((SELECT SUM(_RXXXXG9) FROM TD),0) AS NUMERIC(21,2)) AS 'R02G9',
		LEFT(re.UAEmpFirstName, 1) + '.' + LEFT(re.UAEmpParName, 1) + '. ' + re.UAEmpLastName AS 'H10G2S'
		FOR XML PATH('DECLARBODY'), TYPE)
		FROM dbo.t_Ret m WITH(NOLOCK)
    JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
    OUTER APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) rc
    JOIN dbo.at_r_OurMEDoc om WITH(NOLOCK) ON om.OurID = m.OurID AND  m.TaxDocDate BETWEEN om.BDate AND om.EDate /*om.EmpID=5342*/
    JOIN dbo.r_Emps re WITH(NOLOCK) ON re.EmpID = om.EmpID
    JOIN dbo.z_DocLinks z WITH(NOLOCK) ON z.ChildDocCode = 11003 AND z.ParentDocCode = 666028 AND z.ChildChID = m.ChID
		JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = z.ParentChID
		JOIN dbo.r_Uni zcu WITH(NOLOCK) ON zcu.RefTypeID = 6660120 AND zcu.RefID = zc.OffTypeID
		LEFT JOIN dbo.t_Inv ti WITH(NOLOCK) ON ti.TaxDocID = m.SrcTaxDocID AND ti.TaxDocDate = m.SrcTaxDocDate AND ti.OurID = m.OurID
		JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = dbo.af_GetParentChID(11012, ti.ChID, 11221)
    WHERE m.ChID = @ChID
		FOR XML PATH(''))

		;WITH XMLNAMESPACES ('http://www.w3.org/2001/XMLSchema-instance' as xsi)
		SELECT @Out = (select 'J1201209.xsd' AS '@xsi:noNamespaceSchemaLocation', @Out for xml path('DECLAR'));*/
	END;

	--Ref:http://stackoverflow.com/a/22454410/569436
	--https://connect.microsoft.com/SQLServer/feedbackdetail/view/476828/sqlxml-for-xml-path-elements-xsinil-xsi-nil-true-attribute-is-missing-when-other-attribute-is-generated-on-the-same-element# 
	
    while @Out.exist('//*[empty(text()) and empty(*) and empty(@xsi:nil)]') = 1
  set @Out.modify('declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
             insert (attribute xsi:nil {"true"}) into
             (//*[empty(text()) and empty(*) and empty(@xsi:nil)])[1]')
END;




















GO
