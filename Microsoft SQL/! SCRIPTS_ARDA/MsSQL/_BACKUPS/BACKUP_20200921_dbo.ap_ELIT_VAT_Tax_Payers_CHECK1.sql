USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_ELIT_VAT_Tax_Payers_CHECK]    Script Date: 22.09.2020 17:14:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ap_ELIT_VAT_Tax_Payers_CHECK] (@testing int = 0)
AS 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Процедура проверки контрагентов на регистрацию нового или наличие просроченного/аннулированного свидетельства плательщика НДС*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN
    SET NOCOUNT ON
/*
--Для тестирования (без отправки email).
EXEC [dbo].[ap_ELIT_VAT_Tax_Payers_CHECK] @testing = 1
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] '2020-02-27 11:47' rvk0 добавил отправку email
-- [CHANGED] '2020-02-28 17:49' rkv0 делаем проверку из 3-х частей: физлица, юрлица, дополнительные проверки.
-- [ADDED] '2020-03-02 15:13' rkv0 добавляю лог изменений файла-реестра ДФС.
-- [ADDED] '2020-03-05 10:05' rkv0 добавляю в расслыку Бибик Анжелу.
-- [CHANGED] '2020-03-05 14:36' rvk0 добавил секунды в поле LastUpdated
-- [ADDED] '2020-03-05 15:53' rvk0 добавил RowID
-- [ADDED] '2020-03-06 11:48' rvk0 добавил timestamp (для сравнения)
-- [CHANGED] '2020-03-23 11:38' rvk0 изменил UNION ALL ->> UNION.
-- [CHANGED] rkv0 '2020-09-09 14:59' с 2020г. (нововведение от ДФС-https://uteka.ua/publication/news-14-ezhednevnyj-buxgalterskij-obzor-39-individualnyj-nalogovyj-nomer-platelshhika-nds-u-flp) для свидетельств НДС используется 12 цифр.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*СКАЧИВАНИЕ РЕЕСТРА, ПРЕОБРАЗОВАНИЕ, ЭКСПОРТ В ТАБЛИЦУ: (full) pdv.csv -> pdv_utf16.csv*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
--Реестр здесь https://cabinet.tax.gov.ua/ws/api/public/registers/export/pdv
----Преобразовываем utf-8 в utf-16.
EXEC master..xp_cmdshell  'powershell.exe " Get-Content \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv.csv -Encoding  UTF8 | Set-Content -Encoding Unicode \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16.csv";'
--импорт данных из файла в временную таблицу.
IF OBJECT_ID (N'tempdb..Vat_check', N'U') IS NOT NULL DROP TABLE tempdb..Vat_check
CREATE TABLE tempdb..Vat_check ([name] NVARCHAR(MAX) null, kod_pdv NVARCHAR(MAX) null, dat_reestr NVARCHAR(MAX) null, dat_anul NVARCHAR(MAX) null, c_anul NVARCHAR (MAX) null, c_oper NVARCHAR(MAX) null, d_reestr_sg NVARCHAR(MAX) null, kved NVARCHAR(MAX) null,d_anul_sg NVARCHAR(MAX) null, d_pdv_sg NVARCHAR(MAX) null)
bulk insert tempdb..Vat_check from [\\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16.csv] with (DATAFILETYPE  = 'widechar', CODEPAGE = 'RAW' , FIELDTERMINATOR = ';', rowterminator =';\n', FIRSTROW = 2) 
END;

BEGIN
IF OBJECT_ID (N'tempdb..Vat_check_result', N'U') IS NOT NULL DROP TABLE tempdb..Vat_check_result

-- [CHANGED] '2020-02-28 17:49' rkv0 делаем проверку из 3-х частей: физлица, юрлица, дополнительные проверки.
--записать в результирующую таблицу tempdb..Vat_check_result 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ПРОВЕРКИ*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT *
 INTO tempdb..Vat_check_result
FROM (

--ПРОВЕРКА ФИЗЛИЦА (comptype 1)
SELECT TaxPayer, CompType, Code, TaxCode, CompID, CompName, CompShort, CompGrID2, t.kod_pdv, t.dat_reestr, t.dat_anul, t.[name] FROM Elit.dbo.r_comps rc
--[CHANGED] rkv0 '2020-09-09 14:59' с 2020г. (нововведение от ДФС-https://uteka.ua/publication/news-14-ezhednevnyj-buxgalterskij-obzor-39-individualnyj-nalogovyj-nomer-platelshhika-nds-u-flp) для свидетельств НДС используется 12 цифр.
JOIN tempdb..Vat_check t ON rc.Code = LEFT(t.kod_pdv,10) --r_Comps.Code - ИНН, tempdb..Vat_check.kod_pdv - № свидетельства плательщика НДС.
WHERE TaxPayer = 0
    AND CompType = 1 
    AND EXISTS 
        (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())
    AND dat_anul IS NULL

-- [CHANGED] '2020-03-23 11:38' rvk0 изменил UNION ALL ->> UNION.
--UNION ALL
UNION
--ПРОВЕРКА ЮРЛИЦА (comptype 0)
SELECT TaxPayer, CompType, Code, TaxCode, CompID, CompName, CompShort, CompGrID2, t.kod_pdv, t.dat_reestr, t.dat_anul, t.[name] FROM elit.dbo.r_comps rc
JOIN tempdb..Vat_check t ON LEFT(rc.Code,7) = LEFT(t.kod_pdv,7)
WHERE TaxPayer = 0
    AND CompType = 0 
    AND EXISTS 
        (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())
    AND dat_anul IS NULL

-- [CHANGED] '2020-03-23 11:38' rvk0 изменил UNION ALL ->> UNION.
--UNION ALL
UNION
--ДОПОЛНИТЕЛЬНЫЕ ПРОВЕРКИ
SELECT TaxPayer, CompType, Code, TaxCode, CompID, CompName, CompShort, CompGrID2, t.kod_pdv, t.dat_reestr, t.dat_anul, t.[name] FROM elit.dbo.r_comps rc
LEFT JOIN tempdb..Vat_check t ON t.kod_pdv = 
CASE 
    WHEN LEFT(rc.TaxCode,2) = '00' THEN SUBSTRING(rc.TaxCode,3,255) 
    WHEN LEFT(rc.TaxCode,1) = '0' THEN SUBSTRING(rc.TaxCode,2,255) 
ELSE rc.TaxCode END
WHERE EXISTS (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())
AND (
(TaxPayer = 0 AND kod_pdv IS NOT NULL AND dat_anul IS NULL)
OR (TaxPayer = 1 AND kod_pdv IS NOT NULL AND dat_anul IS NOT NULL)
OR (TaxPayer = 1 AND kod_pdv IS NULL ))

	) s1
ORDER BY dat_reestr DESC;


IF @testing = 0
    BEGIN
	    IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP
        SELECT * INTO #TMP FROM tempdb..Vat_check_result 

    --SELECT * FROM #TMP

    -- [ADDED] '2020-02-27 11:47' rvk0 добавил отправку email    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*скрипт формирования таблицы в HTML автоматический*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*EMAIL*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        IF EXISTS (SELECT top 1 1 FROM tempdb..Vat_check_result)
        BEGIN

          --Отправка почтового сообщения
          BEGIN TRY 
                DECLARE @subject nvarchar(max) = 'Сверка с реестром ДФС по плательщикам НДС: ' + CONVERT(varchar(10), GETDATE(), 112) + ' ' + LEFT(CAST(getdate() AS time),5);
                DECLARE @SQL_query nvarchar(max) = 'SELECT * FROM tempdb..Vat_check_result'
		        DECLARE @body_str nvarchar(max) = '<br><br><br> <b><i>Отправлено [S-SQL-D4] JOB ELIT_VAT_Tax_Payers_CHECK</i></b>';
		        set @body_AUTO = '<p>Имеем следующую картину:</p>' + @body_AUTO + @body_str

		        SELECT @SQL_query
		        EXEC msdb.dbo.sp_send_dbmail  
		         @profile_name = 'arda'
		        ,@from_address = '<support_arda@const.dp.ua>'
		        ,@recipients = 'tancyura@const.dp.ua' --'rumyantsev@const.dp.ua'
        -- [ADDED] '2020-03-05 10:05' rkv0 добавляю в расслыку Бибик Анжелу.
		        ,@copy_recipients  = 'support_arda@const.dp.ua;bibik@const.dp.ua'   
		        --,@copy_recipients  = 'rumyantsev@const.dp.ua' --для теста   
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
    END; --@testing = 0

    DROP TABLE tempdb..Vat_check_result

END; --#1 IF (CONVERT

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*LOG UPDATE*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN TRY

IF OBJECT_ID (N'tempdb..Elit_VAT_log', N'U') IS NULL
    BEGIN
        SELECT TOP(0) * INTO tempdb..Elit_VAT_log FROM tempdb..Vat_check
-- [CHANGED] '2020-03-05 14:36' rvk0 добавил секунды в поле LastUpdated - см. getdate()
-- ALTER TABLE tempdb..Elit_VAT_log ADD LastUpdated smalldatetime NOT NULL DEFAULT getdate()
        ALTER TABLE tempdb..Elit_VAT_log ADD LastUpdated datetime NOT NULL, CONSTRAINT df_ELIT_VAT_log_LastUpdated DEFAULT CONVERT(varchar, getdate(), 120) FOR LastUpdated
-- [ADDED] '2020-03-05 15:53' rvk0 добавил RowID
        ALTER TABLE tempdb..Elit_VAT_log ADD RowID uniqueidentifier NOT NULL, CONSTRAINT df_ELIT_VAT_log_RowID DEFAULT NEWSEQUENTIALID() FOR RowID --NEWSEQUENTIALID-https://docs.microsoft.com/en-us/sql/t-sql/functions/newsequentialid-transact-sql?view=sql-server-ver15
-- [ADDED] '2020-03-06 11:48' rvk0 добавил timestamp (для сравнения)
        ALTER TABLE tempdb..Elit_VAT_log ADD Time_stamp datetime NOT NULL, CONSTRAINT df_ELIT_VAT_log_timestamp DEFAULT CURRENT_TIMESTAMP FOR Time_stamp
    END;

INSERT INTO tempdb..Elit_VAT_log ([name], kod_pdv, dat_reestr, dat_anul, c_anul, c_oper, d_reestr_sg, kved, d_anul_sg, d_pdv_sg)
SELECT * FROM (
    SELECT [name], kod_pdv, dat_reestr, dat_anul, c_anul, c_oper, d_reestr_sg, kved, d_anul_sg, d_pdv_sg FROM tempdb..Vat_check
    EXCEPT
    SELECT [name], kod_pdv, dat_reestr, dat_anul, c_anul, c_oper, d_reestr_sg, kved, d_anul_sg, d_pdv_sg FROM tempdb..Elit_VAT_log
) m
/*
SELECT top 100 * FROM tempdb..Elit_VAT_log ORDER BY lastupdated DESC
*/
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

/*ТЕСТ*/
--SELECT * FROM tempdb..Vat_check WHERE [name] LIKE '%417375926542%' 
--SELECT * FROM tempdb..Vat_check WHERE kod_pdv LIKE '%ПРОДМАРКЕТ ТРЕЙД%'
--SELECT * FROM tempdb..r_Comps WHERE TaxCode LIKE '%417375926542%'
--SELECT DISTINCT len(kod_pdv) FROM tempdb..Vat_check
--SELECT * FROM tempdb..Vat_check WHERE len(kod_pdv) > 12
--select * from tempdb..Vat_check order by KOD_PDV desc 
--SELECT * FROM tempdb..Vat_check where ISNUMERIC(KOD_PDV) = 0 ORDER BY kod_pdv DESC
--SELECT * FROM elit.dbo.r_Comps ORDER BY TaxCode


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*АЛЬТЕРНАТИВНЫЙ ВАРИАНТ: (actual)  pdv_actual.csv -> pdv_utf16_actual.csv*/
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
--Індивідуальний податковий номер (ИНН) / Налоговый код = elit.dbo.r_comps.TaxCode = tempdb..Vat_check.kod_pdv
--Плательщик НДС (12 разрядов для юрлиц, 10 - для физлиц) = r_comps.TaxRegNo
--Код ОКПО/ЕДРПОУ (8 разрядов) = r_comps.Code
--реєстраційний номер облікової картки платника податків (РНОКПП).
--10-разрядный регистрационный номер учетной карточки налогоплательщика — для физлиц

END




GO
