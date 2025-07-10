--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] '2020-02-27 11:47' rvk0 добавил отправку email

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ВАРИАНТ №1: (full) pdv.csv -> pdv_utf16.csv*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
--Реестр здесь https://cabinet.tax.gov.ua/ws/api/public/registers/export/pdv
--преобразовываем utf-8 в utf-16.
EXEC master..xp_cmdshell  'powershell.exe " Get-Content \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv.csv -Encoding  UTF8 | Set-Content -Encoding Unicode \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16.csv";'
--импорт данных из файла в временную таблицу.
IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL DROP TABLE #temp
CREATE TABLE #temp ([name] NVARCHAR(MAX) null, kod_pdv NVARCHAR(MAX) null, dat_reestr NVARCHAR(MAX) null, dat_anul NVARCHAR(MAX) null, c_anul NVARCHAR (MAX) null, c_oper NVARCHAR(MAX) null, d_reestr_sg NVARCHAR(MAX) null, kved NVARCHAR(MAX) null,d_anul_sg NVARCHAR(MAX) null, d_pdv_sg NVARCHAR(MAX) null)
bulk insert #temp from [\\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16.csv] with (DATAFILETYPE  = 'widechar', CODEPAGE = 'RAW' , FIELDTERMINATOR = ';', rowterminator =';\n', FIRSTROW = 2) 
--END;

BEGIN
IF OBJECT_ID (N'tempdb..##GlobalTempTable', N'U') IS NOT NULL DROP TABLE ##GlobalTempTable


SELECT * FROM #temp WHERE kod_pdv = '432523626553'
SELECT * FROM r_comps WHERE TaxCode = '432523626553'
SELECT top 100 * FROM #temp WHERE dat_reestr = '2020-02-25' ORDER BY dat_reestr DESC
SELECT * FROM r_comps WHERE CompName like '%АГРО%'

--ПРОВЕРКА ФИЗИКИ (comptype 1)
SELECT TaxPayer, CompType, Code, TaxCode, CompID, CompName, CompShort, CodeID2, t.kod_pdv, t.dat_reestr, t.dat_anul, t.[name] FROM r_comps rc
JOIN #temp t ON rc.Code = t.kod_pdv
WHERE TaxPayer = 0
    AND CompType = 1 
    AND EXISTS 
        (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())
    AND dat_anul IS NULL
UNION ALL
--ПРОВЕРКА ЮРИКИ (comptype 0)
SELECT TaxPayer, CompType, Code, TaxCode, CompID, CompName, CompShort, CodeID2, t.kod_pdv, t.dat_reestr, t.dat_anul, t.[name] FROM r_comps rc
JOIN #temp t ON LEFT(rc.Code,7) = LEFT(t.kod_pdv,7)
WHERE TaxPayer = 0
    AND CompType = 0 
    AND EXISTS 
        (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())
    AND dat_anul IS NULL
ORDER BY dat_reestr DESC

SELECT kod_pdv, COUNT(*) FROM #temp GROUP BY kod_pdv HAVING COUNT(*) > 1
SELECT * FROM #temp WHERE kod_pdv IN ('1111111111','123456789016','123456789018','209881415413','218826904840','2430113188','2459119114','300112411084','305627115402','315291315085','9926215195') ORDER BY kod_pdv DESC







SELECT * FROM #temp WHERE kod_pdv is null
SELECT TaxCode, COUNT(TAXCODE) FROM r_Comps GROUP BY TaxCode HAVING COUNT(*) > 1
SELECT * FROM r_Comps WHERE TaxCode = '410869004616'
SELECT Code 'ЕДРПОУ', TaxCode 'ИНН', * FROM r_Comps WHERE compid = 71639 --taxcode = '432523626553'
SELECT Code 'ЕДРПОУ', TaxCode 'ИНН', * FROM r_Comps WHERE code IN('X'/*eng*/, 'Х'/*eng*/, '0') --Нет ЕДРПОУ
SELECT taxpayer, Code 'ЕДРПОУ', TaxCode 'ИНН', * FROM r_Comps WHERE TaxCode IN('X'/*eng*/, 'Х'/*eng*/, '0') and code NOT IN ('X'/*eng*/, 'Х'/*eng*/, '0') and TaxPayer = 1 --нет ИНН, а галочка "плательщик НДС" стоит
SELECT taxpayer, Code 'ЕДРПОУ', TaxCode 'ИНН', * FROM r_Comps WHERE TaxCode NOT IN('X'/*eng*/, 'Х'/*eng*/, '0') and code NOT IN ('X'/*eng*/, 'Х'/*eng*/, '0') and TaxPayer = 0 --нет ИНН, а галочка "плательщик НДС" стоит


--записть во временную таблицу ##GlobalTempTable 
SELECT *
 INTO ##GlobalTempTable
FROM (

SELECT rc.CompID 'Предприятие', rc.TaxPayer 'Плательщик НДС', rc.taxcode 'Налоговый код', m.* FROM Elit.dbo.r_Comps rc
--LEFT JOIN Elit.dbo._PDV m ON (SELECT CASE WHEN ISNUMERIC(m.kod_pdv) = 1 THEN CAST(m.kod_pdv AS bigint) ELSE 0 END) = (SELECT CASE WHEN ISNUMERIC(rc.TaxCode) = 1 THEN CAST(rc.TaxCode AS bigint) ELSE 0 END)
--LEFT JOIN Elit.dbo._PDV m ON m.kod_pdv = rc.TaxCode
LEFT JOIN #temp m ON m.kod_pdv = 
CASE 
    WHEN LEFT(rc.TaxCode,2) = '00' THEN SUBSTRING(rc.TaxCode,3,255) 
    WHEN LEFT(rc.TaxCode,1) = '0' THEN SUBSTRING(rc.TaxCode,2,255) 
ELSE rc.TaxCode END
WHERE EXISTS (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())
AND (
(TaxPayer = 0 AND kod_pdv IS NOT NULL AND dat_anul IS NULL)
OR (TaxPayer = 1 AND kod_pdv IS NOT NULL AND dat_anul IS NOT NULL)
OR (TaxPayer = 1 AND kod_pdv IS NULL )
)
	) s1
ORDER BY 1,3 DESC;


	IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP
    SELECT * INTO #TMP FROM ##GlobalTempTable 

--    SELECT * FROM #TMP

-- [ADDED] '2020-02-27 11:47' rvk0 добавил отправку email    
---------скрипт формирования таблицы в HTML автоматический----------------------
--IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP

DECLARE @TableName_AUTO NVARCHAR(MAX) = '#TMP'

DECLARE @Head_AUTO NVARCHAR(MAX) = null
SELECT @Head_AUTO = isnull(@Head_AUTO,'') + '<th>' + COLUMN_NAME + '</th>'
FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
WHERE TABLE_NAME =(select name from tempdb.sys.tables where object_id =  OBJECT_ID('tempdb..' + @TableName_AUTO) ) ORDER BY ORDINAL_POSITION

DECLARE @Fields NVARCHAR(MAX) = null
SELECT @Fields = isnull(@Fields,'') + case when @Fields is null then '' else ',' end + QUOTENAME(COLUMN_NAME) + ' AS td'
FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
WHERE TABLE_NAME =(select name from tempdb.sys.tables where object_id =  OBJECT_ID('tempdb..' + @TableName_AUTO) ) ORDER BY ORDINAL_POSITION

SELECT @Head_AUTO
SELECT @Fields

DECLARE @SQL nvarchar(4000);
DECLARE @result NVARCHAR(MAX)
SET @SQL = 'SELECT @result = (
SELECT '+ @Fields +' FROM #TMP t FOR XML RAW(''tr''), ELEMENTS
)';
select @SQL
EXEC sp_executesql @SQL, N'@result NVARCHAR(MAX) output', @result = @result output
select @result

DECLARE @body_AUTO NVARCHAR(MAX)
SET @body_AUTO = N'<table  border="1" ><tr>' + @Head_AUTO + '</tr>' + @result + N'</table>'

SELECT @body_AUTO
---------скрипт формирования таблицы в HTML автоматический----------------------

/*
SELECT * FROM ##GlobalTempTable

SELECT  CostAC*1.05 min_Price,* FROM t_rem r
				Join t_pinp pp on pp.ProdID = r.ProdID and pp.PPID = r.PPID
				where r.prodid = 802402 
				 and Qty <> 0 and r.PPID <> 0 and OurID = 6
				and r.StockID in (730,731,1200,1201,1245,1252,1257)
				ORDER BY ProdDate desc

DECLARE @chck_table INT = (SELECT OBJECT_ID('tempdb..##GlobalTempTable') )
SELECT @chck_table
DECLARE @SQL_query nvarchar(max) = 'SELECT * FROM ' + (select name from tempdb.sys.tables where object_id = @chck_table)
SELECT @SQL_query
*/
--Если временную таблицу #temptable не пустая
IF EXISTS (SELECT top 1 1 FROM ##GlobalTempTable)
BEGIN

  --Отправка почтового сообщения
  BEGIN TRY 
        DECLARE @subject nvarchar(max) = 'Сверка с реестром ДФС по плательщикам НДС: ' + CONVERT(varchar(10), GETDATE(), 112) + ' ' + LEFT(CAST(getdate() AS time),5);
        DECLARE @SQL_query nvarchar(max) = 'SELECT * FROM ##GlobalTempTable'
		DECLARE @body_str nvarchar(max) = '<br><br><br> <b><i>Отправлено [S-SQL-D4] JOB ELIT_VAT_Tax_Payers_CHECK</i></b>';
		set @body_AUTO = '<p>Имеем следующую картину:</p>' + @body_AUTO + @body_str

		SELECT @SQL_query
		EXEC msdb.dbo.sp_send_dbmail  
		 @profile_name = 'arda'
		,@from_address = '<support_arda@const.dp.ua>'
		,@recipients = 'tancyura@const.dp.ua' --'rumyantsev@const.dp.ua'
		,@copy_recipients  = 'support_arda@const.dp.ua'   
		,@body = @body_AUTO
		,@subject = @subject
		,@body_format = 'HTML'--'HTML'
		,@query = @SQL_query
		,@append_query_error = 1
		,@query_no_truncate= 0 -- не усекать запрос
		,@attach_query_result_as_file= 1 -- 1 возвращается результирующий набор запроса как прикрепленный файл
        ,@query_attachment_filename = 'result-set.txt'
		,@query_result_header = 1 --Указывает, включают ли результаты запроса заголовки столбцов.
		;

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
END --#2 IF EXISTS 

DROP TABLE ##GlobalTempTable

END --#1 IF (CONVERT



/*ТЕСТ*/
--SELECT * FROM #temp WHERE [name] LIKE '%417375926542%' 
--SELECT * FROM #temp WHERE kod_pdv LIKE '%ПРОДМАРКЕТ ТРЕЙД%'
--SELECT * FROM r_Comps WHERE TaxCode LIKE '%417375926542%'
--SELECT DISTINCT len(kod_pdv) FROM #temp
--SELECT * FROM #temp WHERE len(kod_pdv) > 12
--select * from #TEMP order by KOD_PDV desc 
--SELECT * FROM #temp where ISNUMERIC(KOD_PDV) = 0 ORDER BY kod_pdv DESC
--SELECT * FROM r_Comps ORDER BY TaxCode





----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--https://uk.wikipedia.org/wiki/%D0%86%D0%B4%D0%B5%D0%BD%D1%82%D0%B8%D1%84%D1%96%D0%BA%D0%B0%D1%86%D1%96%D0%B9%D0%BD%D0%B8%D0%B9_%D0%BD%D0%BE%D0%BC%D0%B5%D1%80_%D1%84%D1%96%D0%B7%D0%B8%D1%87%D0%BD%D0%BE%D1%97_%D0%BE%D1%81%D0%BE%D0%B1%D0%B8
--Індивідуальний податковий номер (ИНН) / Налоговый код = r_comps.TaxCode = #temp.kod_pdv
--Плательщик НДС (12 разрядов для юрлиц, 10 - для физлиц) = r_comps.TaxRegNo
--Код ОКПО/ЕДРПОУ (8 разрядов) = r_comps.Code
--реєстраційний номер облікової картки платника податків (РНОКПП).
--10-разрядный регистрационный номер учетной карточки налогоплательщика — для физлиц

/*--ДУБЛИ ЕСЛИ ОСТАВИТЬ 7 СИМВОЛОВ ДЛЯ КОДОВ У КОТОРЫХ 8 СИМВОЛОВ
SELECT Code7,count(*) FROM (
	SELECT Code,left(Code,7) Code7 FROM r_comps where len(Code) = 8 
	and chid in (SELECT max(chid) chid FROM r_comps where len(Code) = 8 group by Code)
) gr1 group by Code7
having count(*) > 1*/


/*ДОПОЛНИТЕЛЬНЫЕ ПРОВЕРКИ*/
    --Проверка на количество символов в коде ЕДРПОУ (для юрлиц - 8 цифр).
    SELECT * FROM r_Comps rc WHERE LEN(CODE) != 8 AND CompType = 0
        AND EXISTS 
        (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())

    --Проверка на количество символов в коде ИНН (для физлиц - 10 цифр).
    SELECT * FROM r_Comps rc 
    WHERE 
        LEN(CODE) != 10      
        AND CompType = 1
--        AND ISNUMERIC(CODE) = 1
        AND EXISTS 
        (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())

            --Проверка на количество символов в серии и № паспорта.
    SELECT * FROM r_Comps rc 
    WHERE 
        ISNUMERIC(CODE) = 0
        AND LEN(CODE) != 8      
        AND CompType = 1
        AND EXISTS 
        (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())




    SELECT COUNT(*) FROM #temp
    SELECT COUNT(*) FROM #temp WHERE /*CAST(dat_reestr AS date) >= getdate() AND*/ ISDATE(dat_reestr) = 1
    SELECT CAST(dat_reestr AS date),* FROM #temp WHERE /*CAST(dat_reestr AS date) >= getdate() AND*/ ISDATE(dat_reestr) = 1
    SELECT CAST(dat_reestr AS date),* FROM #temp WHERE CAST(dat_reestr AS date) >= getdate() AND ISDATE(dat_reestr) = 1
    SELECT TOP 100 * FROM #temp WHERE dat_reestr <= CAST(GETDATE() AS nvarchar(MAX)) AND ISDATE(dat_reestr) = 1 --ORDER BY dat_reestr DESC
    SELECT TOP 1741 * FROM #temp WHERE ISDATE(dat_reestr) = 1 AND CAST(dat_reestr AS date) <= GETDATE()  --ORDER BY dat_reestr DESC
    SELECT CAST(dat_reestr AS date), * FROM #temp WHERE kod_pdv = '55818426138' and CAST(dat_reestr AS date) <= CAST(GETDATE() AS date)  AND ISDATE(dat_reestr) = 1 --ORDER BY kod_pdv
    SELECT * FROM #temp WHERE  /*kod_pdv = '55818426138' AND*/ ISDATE(dat_reestr) = 1  AND CAST(dat_reestr AS date) <= GETDATE() --ORDER BY kod_pdv
    SELECT * FROM #temp WHERE ISDATE(dat_reestr) = 0 and CAST(dat_reestr AS date) <= GETDATE()  and kod_pdv = '55818426138'--ORDER BY kod_pdv
    SELECT * FROM #temp WHERE  Convert(Date, dat_reestr) >= getdate() AND ISDATE(dat_reestr) = 1
    SELECT * FROM #temp WHERE  ISDATE(dat_reestr) = 1 and Convert(Date, dat_reestr) >= getdate() 
    SELECT * FROM #temp WHERE CAST('2020-02-28' AS date) >= getdate() AND ISDATE(dat_reestr) = 1
    select (Convert(Date, '2018-04-01'))
    SELECT CAST('1997-07-23' AS date)
    SELECT CAST(GETDATE() AS date)
    SELECT * FROM #temp WHERE ISNUMERIC(KOD_PDV) = 1 AND CAST(kod_pdv as bigint) > 0