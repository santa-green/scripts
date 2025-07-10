--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] '2020-02-27 11:47' rvk0 добавил отправку email.
-- [CHANGED] '2020-02-28 17:49' rkv0 меняю на немного другую проверку.

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

--записть во временную таблицу ##GlobalTempTable 
SELECT *
 INTO ##GlobalTempTable

-- [CHANGED] '2020-02-28 17:49' rkv0 меняю на немного другую проверку.
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
/*FROM (

SELECT rc.CompID 'Предприятие', rc.TaxPayer 'Плательщик НДС', rc.taxcode 'Налоговый код', m.* FROM Elit.dbo.r_Comps rc
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
	) s1*/



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
/*ВАРИАНТ №2: (actual)  pdv_actual.csv -> pdv_utf16_actual.csv*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--rkv0 '2020-02-25 15:37' вариант №2 можно использовать только для теста, т.к. с сайта https://data.gov.ua/en/dataset/db391c93-1e68-43c9-bd85-7c6a8427b114 выкачивается файл полугодичной давности.
--https://data.gov.ua/dataset/95d06529-0367-48da-96dd-c6eb9beeedf3/resource/e5af2194-f78d-46df-9de0-7eeb4155c0e6/download/pdv_actual_28-08-2019.csv
/*BEGIN
EXEC master..xp_cmdshell  'powershell.exe " Get-Content \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_actual.csv -Encoding  UTF8 | Set-Content -Encoding Unicode \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16_actual.csv";'
--чтение из файла штрихкод комбайна
IF OBJECT_ID (N'tempdb..#temp_actual', N'U') IS NOT NULL DROP TABLE #temp_actual
CREATE TABLE #temp_actual ([name] NVARCHAR(MAX) null, kod_pdv NVARCHAR(MAX) null, dat_reestr NVARCHAR(MAX) null, dat_term NVARCHAR(MAX) null)
bulk insert #temp_actual from [\\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16_actual.csv] with (DATAFILETYPE  = 'widechar', CODEPAGE = 'RAW' , FIELDTERMINATOR = '";"', rowterminator ='"\n', FIRSTROW = 2) 
SELECT * FROM #temp_actual WHERE kod_pdv LIKE '%417375926542%'

/*ПРОВЕРКА!*/
SELECT rc.CompID, rc.TaxPayer, rc.taxcode, m.* FROM r_Comps rc
LEFT JOIN #temp_actual m ON m.kod_pdv = rc.TaxCode
WHERE [name] IS NOT NULL AND TaxPayer = 0
END;
*/


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--https://uk.wikipedia.org/wiki/%D0%86%D0%B4%D0%B5%D0%BD%D1%82%D0%B8%D1%84%D1%96%D0%BA%D0%B0%D1%86%D1%96%D0%B9%D0%BD%D0%B8%D0%B9_%D0%BD%D0%BE%D0%BC%D0%B5%D1%80_%D1%84%D1%96%D0%B7%D0%B8%D1%87%D0%BD%D0%BE%D1%97_%D0%BE%D1%81%D0%BE%D0%B1%D0%B8
--Індивідуальний податковий номер (ИНН) / Налоговый код = r_comps.TaxCode = #temp.kod_pdv
--Плательщик НДС (12 разрядов для юрлиц, 10 - для физлиц) = r_comps.TaxRegNo
--Код ОКПО/ЕДРПОУ (8 разрядов) = r_comps.Code
--реєстраційний номер облікової картки платника податків (РНОКПП).
--10-разрядный регистрационный номер учетной карточки налогоплательщика — для физлиц