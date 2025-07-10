USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_ELIT_VAT_Tax_Payers_CHECK]    Script Date: 16.08.2021 10:59:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ap_ELIT_VAT_Tax_Payers_CHECK] @test bit = 0
AS 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*��������� �������� ������������ �� ����������� ������ ��� ������� �������������/��������������� ������������� ����������� ���*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN --���������.
    SET NOCOUNT ON

DECLARE @recipients varchar(max)
SELECT @recipients = CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua' ELSE 'tancyura@const.dp.ua' END
DECLARE @copy_recipients varchar(max)
SELECT @copy_recipients = CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua' ELSE 'support_arda@const.dp.ua;bibik@const.dp.ua' END

/*
--��� ������������ (��� �������� email).
EXEC [dbo].[ap_ELIT_VAT_Tax_Payers_CHECK] @test = 1
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] '2020-02-27 11:47' rvk0 ������� �������� email
-- [CHANGED] '2020-02-28 17:49' rkv0 ������ �������� �� 3-� ������: �������, ������, �������������� ��������.
-- [ADDED] '2020-03-02 15:13' rkv0 �������� ��� ��������� �����-������� ���.
-- [ADDED] '2020-03-05 10:05' rkv0 �������� � �������� ����� ������.
-- [CHANGED] '2020-03-05 14:36' rvk0 ������� ������� � ���� LastUpdated
-- [ADDED] '2020-03-05 15:53' rvk0 ������� RowID
-- [ADDED] '2020-03-06 11:48' rvk0 ������� timestamp (��� ���������)
-- [CHANGED] '2020-03-23 11:38' rvk0 ������� UNION ALL ->> UNION.
-- [CHANGED] rkv0 '2020-09-09 14:59' � 2020�. (������������ �� ���-https://uteka.ua/publication/news-14-ezhednevnyj-buxgalterskij-obzor-39-individualnyj-nalogovyj-nomer-platelshhika-nds-u-flp) ��� ������������ ��� ������������ 12 ����.
-- [FIXED] rkv0 '2020-09-22 19:55' ������ NULL �� '-'
-- [ADDED] rkv0 '2020-09-23 17:43' ������� ����������� �� ���� ����������� (�������� ������, �� ����, ������� �������� ������).
-- [ADDED] rkv0 '2020-09-24 14:07' ������� ����������� �� ���� ��������� (�������� ������, �� ����, ������� �������� ������).
-- [FIXED] rkv0 '2020-09-25 17:02' ������� ����� ��� ������ � ������������� ������, �.�. ��� ������ ����������� � ����������.
-- [CHANGED] rkv0 '2020-11-19 11:24' ������� ���������� �������.
-- [ADDED] '2021-03-10 15:55' rkv0 ������� ������ ��� ���� kod_pdv.


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* [1] ���������� �������, ��������������, ������� � �������: (full) pdv.csv -> pdv_utf16.csv, ������ ������ � tempdb..Vat_check_result*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @test = 0
BEGIN --������ ������� � ������� Vat_check.
SELECT 'not a test..'
    --������ ����� https://cabinet.tax.gov.ua/ws/api/public/registers/export/pdv
    ----��������������� utf-8 � utf-16.
    EXEC master..xp_cmdshell  'powershell.exe " Get-Content \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv.csv -Encoding  UTF8 | Set-Content -Encoding Unicode \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16.csv";'
    --������ ������ �� ����� � ��������� �������.
    IF OBJECT_ID (N'tempdb..Vat_check', N'U') IS NOT NULL DROP TABLE tempdb..Vat_check
    CREATE TABLE tempdb..Vat_check (
          [name] NVARCHAR(4000) null
        , kod_pdv NVARCHAR(100) not null
        , dat_reestr NVARCHAR(4000) null
        , dat_anul NVARCHAR(4000) null
        , c_anul NVARCHAR(4000) null
        , c_oper NVARCHAR(4000) null
        , d_reestr_sg NVARCHAR(4000) null
        , kved NVARCHAR(4000) null
        , d_anul_sg NVARCHAR(4000) null
        , d_pdv_sg NVARCHAR(4000) null
        )

    bulk insert tempdb..Vat_check from [\\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16.csv] with (DATAFILETYPE  = 'widechar', CODEPAGE = 'RAW' , FIELDTERMINATOR = ';', rowterminator =';\n', FIRSTROW = 2) 
    -- [FIXED] rkv0 '2020-09-25 17:02' ������� ����� ��� ������ � ������������� ������, �.�. ��� ������ ����������� � ����������.
    DELETE FROM tempdb..Vat_check WHERE ISDATE(DAT_REESTR) = 0 OR (ISDATE(dat_anul) = 0 AND dat_anul IS NOT NULL)

    create INDEX ix_VAT_CHECK_kod_pdv ON tempdb..Vat_check(kod_pdv)
END;--������ ������� � ������� Vat_check.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* [2] ���� ��������*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [CHANGED] '2020-02-28 17:49' rkv0 ������ �������� �� 3-� ������: �������, ������, �������������� ��������.
--�������� � �������������� ������� tempdb..Vat_check_result 

BEGIN --���� ��������.
    IF OBJECT_ID (N'tempdb..Vat_check_result', N'U') IS NOT NULL DROP TABLE tempdb..Vat_check_result;
    --[FIXED] rkv0 '2020-09-22 19:55' ������ NULL �� '-'
    SELECT TaxPayer, CompType, Code, TaxCode, CompID, CompName, CompShort, CompGrID2, CompGrName2, kod_pdv, dat_reestr, ISNULL(dat_anul, '-') dat_anul, [name]
     INTO tempdb..Vat_check_result
    FROM (

    --�������� ������� (comptype 1)
    SELECT rc.TaxPayer, rc.CompType, rc.Code, rc.TaxCode, rc.CompID, rc.CompName, rc.CompShort, r2.CompGrID2, r2.CompGrName2, t.kod_pdv, t.dat_reestr, t.dat_anul, t.[name] FROM Elit.dbo.r_comps rc
    --[CHANGED] rkv0 '2020-09-09 14:59' � 2020�. (������������ �� ���-https://uteka.ua/publication/news-14-ezhednevnyj-buxgalterskij-obzor-39-individualnyj-nalogovyj-nomer-platelshhika-nds-u-flp) ��� ������������ ��� ������������ 12 ����.
    JOIN tempdb..Vat_check t ON rc.Code = LEFT(t.kod_pdv,10) --r_Comps.Code - ���, tempdb..Vat_check.kod_pdv - � ������������� ����������� ���.
    JOIN Elit.dbo.r_CompGrs2 r2 ON r2.CompGrID2 = rc.CompGrID2
    WHERE rc.TaxPayer = 0 --�������� "����� ������": ������� "���������� ���".
        AND rc.CompType = 1 --�������� "����� ������": "��� �����������".
        AND EXISTS 
            (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE()) --�������� "��������": "�����������" �������, �������� ���� > �������.
        AND t.dat_anul IS NULL
        -- [ADDED] rkv0 '2020-09-23 17:43' ������� ����������� �� ���� ����������� (�������� ������, �� ����, ������� �������� ������).
        AND ISDATE(t.dat_reestr) = 1 
        AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) >= cast(t.dat_reestr as date)


    -- [CHANGED] '2020-03-23 11:38' rvk0 ������� UNION ALL ->> UNION.
    --UNION ALL
    UNION
    --�������� ������ (comptype 0)
    SELECT rc.TaxPayer, rc.CompType, rc.Code, rc.TaxCode, rc.CompID, rc.CompName, rc.CompShort, r2.CompGrID2, r2.CompGrName2, t.kod_pdv, t.dat_reestr, t.dat_anul, t.[name] FROM Elit.dbo.r_comps rc
    JOIN tempdb..Vat_check t ON LEFT(rc.Code,7) = LEFT(t.kod_pdv,7)
    JOIN Elit.dbo.r_CompGrs2 r2 ON r2.CompGrID2 = rc.CompGrID2
    WHERE rc.TaxPayer = 0
        AND rc.CompType = 0 
        AND EXISTS 
            (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())
        AND t.dat_anul IS NULL
        -- [ADDED] rkv0 '2020-09-23 17:43' ������� ����������� �� ���� ����������� (�������� ������, �� ����, ������� �������� ������).
        AND ISDATE(t.dat_reestr) = 1 
        AND DATEADD(DAY,1, CAST(GETDATE() AS DATE)) >= cast(t.dat_reestr as date)

    -- [CHANGED] '2020-03-23 11:38' rvk0 ������� UNION ALL ->> UNION.
    --UNION ALL
    UNION
    --�������������� ��������
    SELECT rc.TaxPayer, rc.CompType, rc.Code, rc.TaxCode, rc.CompID, rc.CompName, rc.CompShort, r2.CompGrID2, r2.CompGrName2, t.kod_pdv, t.dat_reestr, t.dat_anul, t.[name] FROM Elit.dbo.r_comps rc
    JOIN Elit.dbo.r_CompGrs2 r2 ON r2.CompGrID2 = rc.CompGrID2
    LEFT JOIN tempdb..Vat_check t ON t.kod_pdv = 
    CASE 
        WHEN LEFT(rc.TaxCode,2) = '00' THEN SUBSTRING(rc.TaxCode,3,255) 
        WHEN LEFT(rc.TaxCode,1) = '0' THEN SUBSTRING(rc.TaxCode,2,255) 
    ELSE rc.TaxCode END
    WHERE EXISTS (SELECT * FROM Elit.dbo.at_z_Contracts atz WHERE atz.CompID = rc.CompID AND atz.OurID IN (1,3) AND atz.ContrTypeID = 1 AND atz.EDate >= GETDATE())
    AND (
    (rc.TaxPayer = 0 AND t.kod_pdv IS NOT NULL AND t.dat_anul IS NULL)
    OR (rc.TaxPayer = 1 AND t.kod_pdv IS NOT NULL AND t.dat_anul IS NOT NULL)
    OR (rc.TaxPayer = 1 AND t.kod_pdv IS NULL ))
    -- [ADDED] rkv0 '2020-09-24 14:07' ������� ����������� �� ���� ��������� (�������� ������, �� ����, ������� �������� ������).
    AND ISDATE(t.dat_anul) = 1 
    AND DATEADD(DAY,1, CAST(GETDATE() AS DATE)) >= cast(t.dat_anul as date)

	    ) s1
    ORDER BY dat_reestr DESC;
END;--���� ��������.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* [3] ���� �������� email*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN --�������� email.
	    IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP
        --SELECT * INTO #TMP FROM tempdb..Vat_check_result 
        SELECT '>>>>>>' '���� ���� ������', TaxPayer '���������� ���', CompType '��� ����������� (0-��,1-���)', Code '��� ����', TaxCode '��������� ���', CompID '� �����������', CompName '��� ����������� / ���', CompShort '������� ��� ����������� / ���', CompGrID2 '������ ����������� 2', CompGrName2 '��� ������ ����������� 2', '>>>>>>' '������ ���', kod_pdv '��� ����������� ���', dat_reestr '���� �����������/������� ����������� ������������� ���', dat_anul '���� ��������� ������������� ���', [name] '������������ ����������� / ���' INTO #TMP FROM tempdb..Vat_check_result 


    --SELECT * FROM #TMP

    -- [ADDED] '2020-02-27 11:47' rvk0 ������� �������� email    
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /* [3.1] ������ ������������ ������� � HTML ��������������*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP

    DECLARE @TableName_AUTO NVARCHAR(4000) = '#TMP'

    DECLARE @Head_AUTO NVARCHAR(4000) = null
    SELECT @Head_AUTO = isnull(@Head_AUTO,'') + '<th>' + COLUMN_NAME + '</th>'
    FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE TABLE_NAME =(select name from tempdb.sys.tables where object_id =  OBJECT_ID('tempdb..' + @TableName_AUTO) ) ORDER BY ORDINAL_POSITION

    DECLARE @Fields NVARCHAR(4000) = null
    SELECT @Fields = isnull(@Fields,'') + case when @Fields is null then '' else ',' end + QUOTENAME(COLUMN_NAME) + ' AS td'
    FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE TABLE_NAME =(select name from tempdb.sys.tables where object_id =  OBJECT_ID('tempdb..' + @TableName_AUTO) ) ORDER BY ORDINAL_POSITION

    SELECT @Head_AUTO
    SELECT @Fields

    DECLARE @SQL nvarchar(4000);
    DECLARE @result NVARCHAR(4000)
    SET @SQL = 'SELECT @result = (
    SELECT '+ @Fields +' FROM #TMP t FOR XML RAW(''tr''), ELEMENTS
    )';
    select @SQL
    EXEC sp_executesql @SQL, N'@result NVARCHAR(4000) output', @result = @result output
    select @result

    DECLARE @body_AUTO NVARCHAR(4000)
    --[CHANGED] rkv0 '2020-11-19 11:24' ������� ���������� �������.
    --SET @body_AUTO = N'<table  border="2" bordercolor = "red" ><tr>' + @Head_AUTO + '</tr>' + @result + N'</table>'
    SET @body_AUTO = N'<head><style> table{border: 2px solid red, border-collapse: collapse; background-color:   #565656  } th{text-align: center; background-color:  #78aeca } td{text-align: center;  background-color:  #9addff } </style></head>
    <table> <tr>' + @Head_AUTO + '</tr>' + @result + N'</table>'

    SELECT @body_AUTO

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /* [3.2] ������������ email */
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        IF EXISTS (SELECT top 1 1 FROM tempdb..Vat_check_result)
        BEGIN --������������ email.

          --�������� ��������� ���������
          BEGIN TRY 
                DECLARE @subject NVARCHAR(4000) = '������ � �������� ��� �� ������������ ���: ' + CONVERT(varchar(10), GETDATE(), 112) + ' ' + LEFT(CAST(getdate() AS time),5);
                --DECLARE @SQL_query NVARCHAR(4000) = 'SELECT * FROM tempdb..Vat_check_result'
		        DECLARE @body_str NVARCHAR(4000) = '<br><br><br> <b><i>���������� [S-SQL-D4] JOB ELIT_VAT_Tax_Payers_CHECK</i></b>';
		        set @body_AUTO = '<p style="font-size: 15;color:blue"><i>����� ��, �� ����:</i></p>' + @body_AUTO + '<p style="font-size: 10;color:gray">' + @body_str + '</p>'


		        --SELECT @SQL_query
		        EXEC msdb.dbo.sp_send_dbmail  
		         @profile_name = 'arda'
		        ,@from_address = '<support_arda@const.dp.ua>'
		        --,@recipients = @recipients
		        ,@recipients = 'rumyantsev@const.dp.ua' --��� �����
        -- [ADDED] '2020-03-05 10:05' rkv0 �������� � �������� ����� ������.
		        --,@copy_recipients  = @copy_recipients
		        ,@body = @body_AUTO
		        ,@subject = @subject
		        ,@body_format = 'HTML'--'HTML'
		        --,@query = @SQL_query
		        --,@append_query_error = 1
		        --,@query_no_truncate= 0 -- �� ������� ������
		        --,@attach_query_result_as_file= 1 -- 1 ������������ �������������� ����� ������� ��� ������������� ����
                --,@query_attachment_filename = 'result-set.txt'
		        --,@query_result_header = 1 --���������, �������� �� ���������� ������� ��������� ��������.
                ,@importance = 'high'
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
        END --������������ email.

    DROP TABLE tempdb..Vat_check_result

END; --�������� email.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* [4] LOG UPDATE*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN --���������� ����.
    BEGIN TRY

    IF OBJECT_ID (N'tempdb..Elit_VAT_log', N'U') IS NULL
        BEGIN --�������� Elit_VAT_log.
            SELECT TOP(0) * INTO tempdb..Elit_VAT_log FROM tempdb..Vat_check
    -- [CHANGED] '2020-03-05 14:36' rvk0 ������� ������� � ���� LastUpdated - ��. getdate()
    -- ALTER TABLE tempdb..Elit_VAT_log ADD LastUpdated smalldatetime NOT NULL DEFAULT getdate()
            ALTER TABLE tempdb..Elit_VAT_log ADD LastUpdated datetime NOT NULL, CONSTRAINT df_ELIT_VAT_log_LastUpdated DEFAULT CONVERT(varchar, getdate(), 120) FOR LastUpdated
        -- [ADDED] '2020-03-05 15:53' rvk0 ������� RowID
            ALTER TABLE tempdb..Elit_VAT_log ADD RowID uniqueidentifier NOT NULL, CONSTRAINT df_ELIT_VAT_log_RowID DEFAULT NEWSEQUENTIALID() FOR RowID --NEWSEQUENTIALID-https://docs.microsoft.com/en-us/sql/t-sql/functions/newsequentialid-transact-sql?view=sql-server-ver15
    -- [ADDED] '2020-03-06 11:48' rkv0 ������� timestamp (��� ���������)
            ALTER TABLE tempdb..Elit_VAT_log ADD Time_stamp datetime NOT NULL, CONSTRAINT df_ELIT_VAT_log_timestamp DEFAULT CURRENT_TIMESTAMP FOR Time_stamp
        -- [ADDED] '2021-03-10 15:55' rkv0 ������� ������ ��� ���� kod_pdv.
        CREATE INDEX ix_Elit_VAT_CHECK_kod_pdv ON tempdb..Elit_VAT_log(kod_pdv)

        END; --�������� Elit_VAT_log.

    IF OBJECT_ID('tempdb..#except_vat_check', 'U') IS NOT NULL DROP TABLE #except_vat_check
    ;WITH except_cte as (
        SELECT [name], kod_pdv, dat_reestr, dat_anul, c_anul, c_oper, d_reestr_sg, kved, d_anul_sg, d_pdv_sg FROM tempdb..Vat_check
        EXCEPT
        SELECT [name], kod_pdv, dat_reestr, dat_anul, c_anul, c_oper, d_reestr_sg, kved, d_anul_sg, d_pdv_sg FROM tempdb..Elit_VAT_log
    )
    SELECT [name], kod_pdv, dat_reestr, dat_anul, c_anul, c_oper, d_reestr_sg, kved, d_anul_sg, d_pdv_sg 
    INTO #except_vat_check 
    FROM except_cte

    INSERT INTO tempdb..Elit_VAT_log ([name], kod_pdv, dat_reestr, dat_anul, c_anul, c_oper, d_reestr_sg, kved, d_anul_sg, d_pdv_sg)
    SELECT [name], kod_pdv, dat_reestr, dat_anul, c_anul, c_oper, d_reestr_sg, kved, d_anul_sg, d_pdv_sg 
    FROM #except_vat_check
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
END; --���������� ����.

END; --���������.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* [5] �������������� �������: (actual)  pdv_actual.csv -> pdv_utf16_actual.csv*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--rkv0 '2020-02-25 15:37' ������� �2 ����� ������������ ������ ��� �����, �.�. � ����� https://data.gov.ua/en/dataset/db391c93-1e68-43c9-bd85-7c6a8427b114 ������������ ���� ������������ ��������.
--https://data.gov.ua/dataset/95d06529-0367-48da-96dd-c6eb9beeedf3/resource/e5af2194-f78d-46df-9de0-7eeb4155c0e6/download/pdv_actual_28-08-2019.csv
/*BEGIN
EXEC master..xp_cmdshell  'powershell.exe " Get-Content \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_actual.csv -Encoding  UTF8 | Set-Content -Encoding Unicode \\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16_actual.csv";'
--������ �� ����� �������� ��������
IF OBJECT_ID (N'tempdb..#temp_actual', N'U') IS NOT NULL DROP TABLE #temp_actual
CREATE TABLE #temp_actual ([name] NVARCHAR(4000) null, kod_pdv NVARCHAR(4000) null, dat_reestr NVARCHAR(4000) null, dat_term NVARCHAR(4000) null)
bulk insert #temp_actual from [\\s-sql-d4\OT38ElitServer\Import\temp\pdv\pdv_utf16_actual.csv] with (DATAFILETYPE  = 'widechar', CODEPAGE = 'RAW' , FIELDTERMINATOR = '";"', rowterminator ='"\n', FIRSTROW = 2) 
SELECT * FROM #temp_actual WHERE kod_pdv LIKE '%417375926542%'
/*��������!*/
SELECT rc.CompID, rc.TaxPayer, rc.taxcode, m.* FROM r_Comps rc
LEFT JOIN #temp_actual m ON m.kod_pdv = rc.TaxCode
WHERE [name] IS NOT NULL AND TaxPayer = 0
END;
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* [6] �������������� ����������*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--https://uk.wikipedia.org/wiki/%D0%86%D0%B4%D0%B5%D0%BD%D1%82%D0%B8%D1%84%D1%96%D0%BA%D0%B0%D1%86%D1%96%D0%B9%D0%BD%D0%B8%D0%B9_%D0%BD%D0%BE%D0%BC%D0%B5%D1%80_%D1%84%D1%96%D0%B7%D0%B8%D1%87%D0%BD%D0%BE%D1%97_%D0%BE%D1%81%D0%BE%D0%B1%D0%B8
--������������� ���������� ����� (���) / ��������� ��� = elit.dbo.r_comps.TaxCode = tempdb..Vat_check.kod_pdv
--���������� ��� (12 �������� ��� �����, 10 - ��� ������) = r_comps.TaxRegNo
--��� ����/������ (8 ��������) = r_comps.Code
--������������ ����� ������� ������ �������� ������� (������).
--10-��������� ��������������� ����� ������� �������� ����������������� � ��� ������

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* [7] TEST*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*SELECT * FROM tempdb..Vat_check WHERE [name] LIKE '%417375926542%' 
SELECT * FROM tempdb..Vat_check WHERE kod_pdv LIKE '%���������� �����%'
SELECT * FROM tempdb..r_Comps WHERE TaxCode LIKE '%417375926542%'
SELECT DISTINCT len(kod_pdv) FROM tempdb..Vat_check
SELECT * FROM tempdb..Vat_check WHERE len(kod_pdv) > 12
select * from tempdb..Vat_check order by KOD_PDV desc 
SELECT * FROM tempdb..Vat_check where ISNUMERIC(KOD_PDV) = 0 ORDER BY kod_pdv DESC
SELECT * FROM elit.dbo.r_Comps ORDER BY TaxCode
SELECT * FROM tempdb..Vat_check WHERE kod_pdv = '277211827780'
SELECT * FROM tempdb..Vat_check_result
UPDATE tempdb..Vat_check_result SET dat_anul = '-' WHERE dat_anul IS NULL
SELECT * FROM tempdb..Vat_check_result
*/


















GO
