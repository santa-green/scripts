USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EDI_add_GLN_auto]    Script Date: 09.08.2021 15:56:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ap_EDI_add_GLN_auto] @test int = 0
as
begin
/*
--Для теста.
EXEC dbo.[ap_EDI_add_GLN_auto] @test = 1
*/
SELECT DB_NAME() 'db'
DECLARE @body varchar(max)
DECLARE @recipients varchar(max) = CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua'
                                                       ELSE 'support_arda@const.dp.ua' END

--#region Логи и триггера
/*
SELECT * FROM gln_add_log_ALEF_EDI_GLN_OT
SELECT * FROM gln_add_log_ALEF_EDI_GLN_SETI
SELECT * FROM [s-sql-d4].[elit].dbo.base_gln_change_log

r_CompValues - [base_gln_change_log_IUD]
ALEF_EDI_GLN_OT - [gln_add_log_ALEF_EDI_GLN_OT_IUD]
ALEF_EDI_GLN_SETI - [gln_add_log_ALEF_EDI_GLN_SETI_IUD]
*/
--#endregion Логи и триггера

--#region [0] CHANGELOG

--#endregion [0] CHANGELOG

--#region [1] Формирование базовой таблицы с GLN.
BEGIN

    IF OBJECT_ID (N'tempdb..#GLN_info', N'U') IS NOT NULL
	    DROP TABLE #GLN_info

    SELECT TOP(1) 
           LTRIM(RTRIM(REPLACE(rc.GLNCode, CHAR(9), '')))  'GLN_address_CODE'
    ,      (SELECT VarValue FROM [s-sql-d4].[elit].dbo.r_CompValues WHERE CompID = rc.CompID and VarName = 'base_gln')  'GLN_base_CODE'
    ,      rc.CompAddID 'CompAddID'
    ,      rc.CompGrID2 'CompGrID2'
    ,      rc.CompID 'COMP_ID'
    ,      (SELECT CodeID2 FROM [s-sql-d4].[elit].dbo.r_comps WHERE compid = rc.CompID) 'CodeID2'
    INTO #GLN_info
    FROM      [s-sql-d4].[elit].dbo.r_CompsAdd                      rc
    LEFT JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT ag ON (
			    rc.CompID = ag.ZEC_KOD_KLN_OT
			    and rc.GLNCode = ag.ZEC_KOD_ADD)
    WHERE rc.GLNCode not in ('', '0')
	    and ag.ZEC_KOD_ADD IS NULL
        and rc.compid NOT BETWEEN 10790 AND 10795 --фильтруем Винтаж.
    
    SELECT * FROM #GLN_info

    --Проверки.
    IF NOT EXISTS (SELECT TOP 1 1 FROM #GLN_info)
        BEGIN
            SELECT 'Новинок нет..'
            PRINT 'Новинок нет..'
            RETURN
        END;
    IF EXISTS (SELECT TOP 1 1 FROM #GLN_info WHERE GLN_base_CODE IS NULL)
        BEGIN
        SELECT 'Не установлен базовый GLN!'
        DECLARE @gln_address varchar(max) = (SELECT GLN_address_CODE FROM #GLN_info)
        SELECT @body = '<p>Для адреса доставки GLN ' + cast(@gln_address as varchar) + ' не установлен базовый GLN! </p>' +
                        '<p style="font-size: 12; color: gray"><i>Job: GLN_AUTO_ADD</i></p>'
        EXEC msdb.dbo.sp_send_dbmail  
            @profile_name = 'arda',
            @from_address = '<support_arda@const.dp.ua>',
            @recipients = @recipients,
            @subject = 'Не установлен базовый GLN !',
            @body = @body,  
            @body_format = 'HTML',
            @append_query_error = 1
        RETURN
        END;

END;

--#endregion [1] Формирование базовой таблицы с GLN.

--#region [2] Добавить базовый GLN (ручной режим).

IF 1 = 0
BEGIN
    SELECT * FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_NUMBER = '4516791618' --базовый GLN (ZEO_ZEC_BASE) можно взять здесь.
    INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) 
    VALUES (7031,'BASE_GLN','9863577638028') --(!) меняем параметры здесь.       
END;

--#endregion [2] Добавить базовый GLN (ручной режим).

--#region [3] ДОБАВЛЕНИЕ НОВОГО АДРЕСА

BEGIN TRAN
    BEGIN

    --#region [3.1] ТАБЛИЦА №1 - ALEF_EDI_GLN_OT
    SELECT 'ДОБАВЛЕНИЕ НОВОГО АДРЕСА' '[3]'
    SELECT 'ТАБЛИЦА №1 - SELECT: ALEF_EDI_GLN_OT' '[3.1]'
    INSERT INTO dbo.ALEF_EDI_GLN_OT
	    --OUTPUT inserted.*
    SELECT (SELECT GLN_base_CODE
    FROM #GLN_info)    'ZEC_KOD_BASE'
    ,      (SELECT GLN_address_CODE
    FROM #GLN_info)    'ZEC_KOD_ADD'
    ,      (SELECT COMP_ID
    FROM #GLN_info)    'ZEC_KOD_KLN_OT'
    ,      (SELECT CompAddID
    FROM #GLN_info)    'ZEC_KOD_ADD_OT'
    ,      CASE (
	    SELECT CompGrID2
	    FROM #GLN_info
	    ) WHEN 2030 then (CASE WHEN (SELECT DepID
		    FROM [S-SQL-D4].[ELIT].dbo.av_at_r_CompOurTerms1 WITH(NOLOCK)
		    WHERE compid = (SELECT COMP_ID
			    FROM #GLN_info)) = 10000 THEN 30 --склад общий Киев (если подразделение в Условиях работы(АТ) = 10000)
	                              ELSE 220 --склад НАЦСЕТЕЙ Киев
	    END)
          WHEN 2031 then 4 --склад общий Днепр
          WHEN 2034 then 23 --склад общий Одесса
          WHEN 2035 then 27 --склад общий Львов
          WHEN 2036 then 11 --склад общий Харьков
          WHEN 2048 then 85 --склад общий Черкассы
          WHEN 2048 then 85 --склад общий Черкассы
          WHEN 2081 then 23 --склад общий Одесса (Эпицентр Николаев)
          WHEN 2032 then 4 --склад общий Днепр
                    ELSE CASE WHEN (SELECT GLN_base_CODE
		    FROM #GLN_info) = '9864066918782' then 30 --склад общий Киев (не нацсети) для Легиона.
	                          WHEN (SELECT GLN_base_CODE
		    FROM #GLN_info) = '9864066980598' then 11 --склад общий Харьков (Гведеон/Семья).
	                          WHEN (SELECT GLN_base_CODE
		    FROM #GLN_info) = '9864232279860' then 30 --склад общий Киев (для Ридо Групп (Пчелка).
	                          WHEN (SELECT GLN_base_CODE
		    FROM #GLN_info) = '9864232419938' then 23 --склад общий Одесса (Модерн-Ритейл).
	    end end 'ZEC_KOD_SKLAD_OT'
    ,      1    'ZEC_STATUS'
    --#endregion [3.1] ТАБЛИЦА №1 - ALEF_EDI_GLN_OT

    --#region [3.2] ТАБЛИЦА №2 - ALEF_EDI_GLN_SETI
    SELECT 'ТАБЛИЦА №2 - SELECT: ALEF_EDI_GLN_SETI' '[3.2]'

    ;WITH union_cte
    as
    (
	    SELECT (SELECT GLN_address_CODE
	    FROM #GLN_info)         'EGS_GLN_ID'
	    ,      (SELECT Adress
	    FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK)
	    where GLN = (SELECT GLN_address_CODE
		    FROM #GLN_info))    'EGS_GLN_NAME' --ищем в справочнике предприятий адрес доставки на вкладке Адреса доставки
	    ,      case when (Select CodeID2
		    FROM #GLN_info) = 0 then 998
	                     else (Select CodeID2
		    FROM #GLN_info) end 'EGS_GLN_SETI_ID' -- ищем в справочнике предприятий на вкладке Дополнительно поле Код признака 2
	    ,      null      'EGS_STATUS'

	    UNION ALL

	    SELECT (SELECT GLN_base_CODE
	    FROM #GLN_info)         'EGS_GLN_ID'
	    ,      (SELECT GLNName
	    FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK)
	    where GLN = (Select GLN_base_CODE
		    FROM #GLN_info))    'EGS_GLN_NAME'
	    ,      case when (SELECT CodeID2
		    FROM #GLN_info) = 0 then 998
	                     else (SELECT CodeID2
		    FROM #GLN_info) end 'EGS_GLN_SETI_ID'
	    ,      null      'EGS_STATUS'
    )
    INSERT INTO dbo.ALEF_EDI_GLN_SETI
	    --OUTPUT inserted.*
    SELECT EGS_GLN_ID, EGS_GLN_NAME, EGS_GLN_SETI_ID, EGS_STATUS
    FROM union_cte
    where EGS_GLN_ID not in (
	    SELECT EGS_GLN_ID
	    FROM dbo.ALEF_EDI_GLN_SETI WITH(NOLOCK)
	    where EGS_GLN_SETI_ID = (SELECT CASE WHEN (SELECT CodeID2
			    FROM #GLN_info) = 0                 then 998
		                                     else (SELECT CodeID2
			    FROM #GLN_info) end)
	    )
    --#endregion [3.2] ТАБЛИЦА №2 - ALEF_EDI_GLN_SETI

   
--#region Отправка email
    --#region @body_html (#GLN_info)
        DECLARE @head_html varchar(max) = NULL
        DECLARE @table varchar(max) = '#GLN_info'
        SELECT @head_html = ISNULL(@head_html, '') + '<th>' + COLUMN_NAME + '</th>'
        FROM tempdb.INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = (SELECT [name]
	        FROM tempdb.sys.tables
	        WHERE object_id = OBJECT_ID('tempdb..' + @table))
        ORDER BY ORDINAL_POSITION

        DECLARE @fields_html varchar(max) = NULL
        SELECT @fields_html = ISNULL(@fields_html, '') + CASE WHEN @fields_html IS NULL THEN ''
                                                                                        ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td'
        FROM tempdb.INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = (SELECT [name]
	        FROM tempdb.sys.tables
	        WHERE object_id = OBJECT_ID('tempdb..' + @table))
        ORDER BY ORDINAL_POSITION

        DECLARE @SQL NVARCHAR(4000);
        DECLARE @result NVARCHAR(MAX)
        SET @SQL = 'SELECT @result = (
                    SELECT '+ @fields_html +' FROM ' + @table + ' t FOR XML RAW(''tr''), ELEMENTS
                    )';
        EXEC sp_executesql           @SQL
        ,                            N'@result NVARCHAR(MAX) output'
        ,                  @result = @result OUTPUT

        DECLARE @body_html NVARCHAR(MAX)
        SET @body_html = N'<table  bordercolor=#72b4f3 border="5"><tr>' + @Head_html + '</tr>' + @result + N'</table>'
        DECLARE @msg varchar(max)
        SET @msg = '<p style="font-size: 12; color: gray"><i>[для администратора БД] Отправлено [S-PPC] JOB GLN_AUTO_ADD (GLN auto addition / EXEC dbo.ap_EDI_add_GLN_auto)</i></p>'
    --#endregion @body_html (#GLN_info)

    --#region @body_html_2 (gln_add_log_ALEF_EDI_GLN_OT)
        DECLARE @head_html_2 varchar(max) = NULL
        DECLARE @table_2 varchar(max) = 'gln_add_log_ALEF_EDI_GLN_OT'
        SELECT @head_html_2 = ISNULL(@head_html_2, '') + '<th>' + COLUMN_NAME + '</th>'
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = (SELECT [name]
	        FROM sys.tables
	        WHERE object_id = OBJECT_ID('Alef_Elit..' + @table_2))
        ORDER BY ORDINAL_POSITION

        DECLARE @fields_html_2 varchar(max) = NULL
        SELECT @fields_html_2 = ISNULL(@fields_html_2, '') + CASE WHEN @fields_html_2 IS NULL THEN ''
                                                                                        ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td'
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = (SELECT [name]
	        FROM sys.tables
	        WHERE object_id = OBJECT_ID('Alef_Elit..' + @table_2))
        ORDER BY ORDINAL_POSITION

        DECLARE @SQL_2 NVARCHAR(4000);
        DECLARE @result_2 NVARCHAR(MAX)
        SET @SQL_2 = 'SELECT @result_2 = (
                    SELECT TOP(10) '+ @fields_html_2 +' FROM ' + @table_2 + ' t ORDER BY log_timestamp DESC FOR XML RAW(''tr''), ELEMENTS
                    )';
        select @SQL_2
        EXEC sp_executesql           @SQL_2
        ,                            N'@result_2 NVARCHAR(MAX) output'
        ,                  @result_2 = @result_2 OUTPUT

        DECLARE @body_html_2 NVARCHAR(MAX)
        SET @body_html_2 = N'<table  bordercolor=#95c89d  border="5"><tr>' + @Head_html_2 + '</tr>' + @result_2 + N'</table>'
        DECLARE @msg_2 varchar(max)
        SET @msg_2 = '<p style="font-size: 14; color: green">Топ 10 последних изменений в логе ' + @table_2 + ':</p>'
    --#endregion @body_html_2 (gln_add_log_ALEF_EDI_GLN_OT)

    --#region @body_html_3 (gln_add_log_ALEF_EDI_GLN_SETI)
        DECLARE @head_html_3 varchar(max) = NULL
        DECLARE @table_3 varchar(max) = 'gln_add_log_ALEF_EDI_GLN_SETI'
        SELECT @head_html_3 = ISNULL(@head_html_3, '') + '<th>' + COLUMN_NAME + '</th>'
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = (SELECT [name]
	        FROM sys.tables
	        WHERE object_id = OBJECT_ID('Alef_Elit..' + @table_3))
        ORDER BY ORDINAL_POSITION

        DECLARE @fields_html_3 varchar(max) = NULL
        SELECT @fields_html_3 = ISNULL(@fields_html_3, '') + CASE WHEN @fields_html_3 IS NULL THEN ''
                                                                                        ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td'
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = (SELECT [name]
	        FROM sys.tables
	        WHERE object_id = OBJECT_ID('Alef_Elit..' + @table_3))
        ORDER BY ORDINAL_POSITION

        DECLARE @SQL_3 NVARCHAR(4000);
        DECLARE @result_3 NVARCHAR(MAX)
        SET @SQL_3 = 'SELECT @result_3 = (
                    SELECT TOP(10) '+ @fields_html_3 +' FROM ' + @table_3 + ' t ORDER BY log_timestamp DESC FOR XML RAW(''tr''), ELEMENTS
                    )';
        select @SQL_3
        EXEC sp_executesql           @SQL_3
        ,                            N'@result_3 NVARCHAR(MAX) output'
        ,                  @result_3 = @result_3 OUTPUT

        DECLARE @body_html_3 NVARCHAR(MAX)
        SET @body_html_3 = N'<table  bordercolor=#95c89d  border="5"><tr>' + @Head_html_3 + '</tr>' + @result_3 + N'</table>'
        DECLARE @msg_3 varchar(max)
        SET @msg_3 = '<p style="font-size: 14; color: green">Топ 10 последних изменений в логе ' + @table_3 + ':</p>'
    --#endregion @body_html_3 (gln_add_log_ALEF_EDI_GLN_SETI)
    
    --#region @body_html_4 ([s-sql-d4].[elit].dbo.base_gln_change_log)
    DECLARE @head_html_4 varchar(max) = NULL
    DECLARE @table_4 varchar(max) = 'base_gln_change_log'
    SELECT @head_html_4 = ISNULL(@head_html_4, '') + '<th>' + COLUMN_NAME + '</th>'
    FROM [s-sql-d4].Elit.INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = (SELECT [name]
	    FROM [s-sql-d4].Elit.sys.tables
	    WHERE [name] = @table_4)
    ORDER BY ORDINAL_POSITION
    SELECT @head_html_4

    DECLARE @fields_html_4 varchar(max) = NULL
    SELECT @fields_html_4 = ISNULL(@fields_html_4, '') + CASE WHEN @fields_html_4 IS NULL THEN ''
                                                                                    ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td'
    FROM [s-sql-d4].Elit.INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = (SELECT [name]
	    FROM [s-sql-d4].Elit.sys.tables
	    WHERE [name] = @table_4)
    ORDER BY ORDINAL_POSITION
    SELECT @fields_html_4

    DECLARE @SQL_4 NVARCHAR(4000);
    DECLARE @result_4 NVARCHAR(MAX)
    SET @SQL_4 = 'SELECT @result_4 = (
                SELECT TOP(10) '+ @fields_html_4 +' FROM [s-sql-d4].Elit.dbo.' + @table_4 + ' t ORDER BY log_timestamp DESC FOR XML RAW(''tr''), ELEMENTS
                )';
    select @SQL_4
    EXEC sp_executesql           @SQL_4
    ,                            N'@result_4 NVARCHAR(MAX) output'
    ,                  @result_4 = @result_4 OUTPUT

    DECLARE @body_html_4 NVARCHAR(MAX)
    SET @body_html_4 = N'<table  bordercolor=#e83838   border="5"><tr>' + @Head_html_4 + '</tr>' + @result_4 + N'</table>'
    select @body_html_4
    DECLARE @msg_4 varchar(max)
    SET @msg_4 = '<p style="font-size: 14; color: red">Топ 10 последних изменений в логе [d4]' + @table_4 + ':</p>'
--#endregion @body_html_4 ([s-sql-d4].[elit].dbo.base_gln_change_log)

    SET @body = @body_html + @msg + @msg_2 + @body_html_2 + @msg_3 + @body_html_3 + + @msg_4 + @body_html_4

    EXEC msdb.dbo.sp_send_dbmail  
        @profile_name = 'arda',
        @from_address = '<support_arda@const.dp.ua>',
        @recipients = @recipients,
        @subject = 'Добавлен новый GLN в базу (джоб GLN_AUTO_ADD)',
        @body = @body,  
        @body_format = 'HTML',
        @append_query_error = 1
--#endregion Отправка email

    END;
COMMIT TRAN

--#endregion [3] ДОБАВЛЕНИЕ НОВОГО АДРЕСА

--#region [4] Проверка на подвязку кодов.

/*
CREATE TABLE ALEF_EDI_EXTCODES_CHECK (NewCompID int, EmailStatus bit)
ALTER TABLE ALEF_EDI_EXTCODES_CHECK  ALTER COLUMN NewCompid int not NULL
ALTER TABLE ALEF_EDI_EXTCODES_CHECK  ADD CONSTRAINT UC_COMPID UNIQUE (NewCompID)
ALTER TABLE ALEF_EDI_EXTCODES_CHECK  ADD CONSTRAINT PK_COMPID PRIMARY KEY (NewCompID)
*/

IF (SELECT COMP_ID FROM #GLN_info) IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT TOP 1 1 FROM [s-sql-d4].[elit].dbo.r_prodec WHERE compid = (SELECT COMP_ID FROM #GLN_info))
        AND
        NOT EXISTS (SELECT TOP 1 1 FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_EXTCODES_CHECK WHERE NewCompID = (SELECT COMP_ID FROM #GLN_info))
    BEGIN

        DECLARE @subject varchar(max) = 'Новое предприятие в EDI. Не подвязаны внешние коды по новому предприятию EDI: ' + 
            CAST((SELECT COMP_ID FROM #GLN_info) AS varchar)
        EXEC msdb.dbo.sp_send_dbmail @profile_name       = 'arda'
        ,                            @from_address       = '<support_arda@const.dp.ua>'
        ,                            @recipients         = 'tumaliieva@const.dp.ua'
        ,                            @copy_recipients    = 'support_arda@const.dp.ua'
        ,                            @subject            = @subject
        ,                            @body               = 'Это автоматическое уведомление [Добавление GLN_auto.sql]'
        --,                            @body_format        = 'HTML'
        ,                            @append_query_error = 1

        INSERT INTO ALEF_EDI_EXTCODES_CHECK SELECT COMP_ID, 1 FROM #GLN_info; --Статус 1 - email отправлен.

    END;
END;
--#endregion [4A] Проверка на подвязку кодов.

--#region [5] ФИНАЛЬНАЯ ПРОВЕРКА НА ДУБЛИ
-- [ADDED] '2020-04-21 16:33' rkv0 добавлена дополнительная проверка на дубликаты (их не должно быть).

--Вариант №1.
/*
DECLARE @query nvarchar(max) 
SET @query = 'SELECT CompID,GLNCode,count(*) ''dubli'' FROM  [S-SQL-D4].Elit.dbo.r_CompsAdd where GLNCode <> '''' group by CompID,GLNCode having count(*) > 1'
SET @query = 'IF NOT EXISTS (' + @query + ') SELECT ''SUCCESS - Дубликатов нет.'' ELSE ' + @query
EXEC (@query)
*/

--Вариант №2.
IF NOT EXISTS (SELECT TOP 1 1
	FROM [S-SQL-D4].Elit.dbo.r_CompsAdd
	where GLNCode <> ''
	group by CompID
	,        GLNCode
	having count(*) > 1)
	SELECT 'SUCCESS - Дубликатов нет.'
ELSE 
    BEGIN
        IF OBJECT_ID('tempdb..#address_duplicate', 'U') IS NOT NULL DROP TABLE #address_duplicate
        SELECT 'Найдены дубликаты.'
        SELECT CompID  
	    ,       GLNCode 
	    ,       count(*) 'Дубликаты'
	    INTO #address_duplicate
        FROM [S-SQL-D4].Elit.dbo.r_CompsAdd
	    where GLNCode <> ''
	    group by CompID
	    ,        GLNCode
	    having count(*) > 1
	    ORDER BY CompID DESC

        SELECT * FROM #address_duplicate

    --#region @body_html_5 (проверка на дубликаты)
    DECLARE @head_html_5 varchar(max) = NULL
    DECLARE @table_5 varchar(max) = 'tempdb..#address_duplicate'
    SELECT @head_html_5 = ISNULL(@head_html_5, '') + '<th>' + COLUMN_NAME + '</th>'
    FROM tempdb.INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = (SELECT [name]
	    FROM tempdb.sys.tables
	    WHERE object_id = OBJECT_ID(@table_5, 'U'))
    ORDER BY ORDINAL_POSITION
    SELECT @head_html_5

    DECLARE @fields_html_5 varchar(max) = NULL
    SELECT @fields_html_5 = ISNULL(@fields_html_5, '') + CASE WHEN @fields_html_5 IS NULL THEN ''
                                                                                    ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td'
    FROM tempdb.INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = (SELECT [name]
	    FROM tempdb.sys.tables
	    WHERE object_id = OBJECT_ID(@table_5, 'U'))
    ORDER BY ORDINAL_POSITION
    SELECT @fields_html_5

    DECLARE @SQL_5 NVARCHAR(4000);
    DECLARE @result_5 NVARCHAR(MAX)
    SET @SQL_5 = 'SELECT @result_5 = (
                SELECT TOP(10) '+ @fields_html_5 +' FROM ' + @table_5 + ' t FOR XML RAW(''tr''), ELEMENTS
                )';
    select @SQL_5
    EXEC sp_executesql           @SQL_5
    ,                            N'@result_5 NVARCHAR(MAX) output'
    ,                  @result_5 = @result_5 OUTPUT

    DECLARE @body_html_5 NVARCHAR(MAX)
    SET @body_html_5 = N'<table  bordercolor=#F08080   border="5"><tr>' + @Head_html_5 + '</tr>' + @result_5 + N'</table>'
    select @body_html_5

        EXEC msdb.dbo.sp_send_dbmail  
            @profile_name = 'arda',
            @from_address = '<support_arda@const.dp.ua>',
            @recipients = @recipients,
            @subject = 'Найдены дубликаты в адресах доставки r_CompsAdd ! (ДЖОБ GLN_AUTO_ADD)',
            @body = @body_html_5,  
            @body_format = 'HTML',
            @append_query_error = 1
    --#endregion @body_html_5 (проверка на дубликаты)
    END;
--#endregion [5] ФИНАЛЬНАЯ ПРОВЕРКА НА ДУБЛИ

--#region [6] Перезаливка заказа (ручной режим).
--TRAN

/*
IF 1 = 0
BEGIN
    BEGIN TRAN
    
    --DECLARE @glncode varchar(30) = '9864232440321'
    --SELECT * FROM ALEF_EDI_ORDERS_2 m WHERE m.ZEO_ZEC_ADD = @glncode
    --SELECT * FROM ALEF_EDI_ORDERS_2 m WHERE m.ZEO_ZEC_ADD = @glncode

        --DECLARE @order varchar(max) = '323658'
        DECLARE @ZEO_ORDER_ID varchar(max) = (SELECT ZEO_ORDER_ID FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_NUMBER = @order)
        SELECT * FROM ALEF_EDI_ORDERS_CHANGES WHERE EOC_ORDER_ID = @ZEO_ORDER_ID

        INSERT INTO ALEF_EDI_ORDERS_CHANGES (EOC_ORDER_ID, EOC_CH_DATE,EOC_TYPE, EOC_POS, EOC_CH_DATA, EOC_COMMITTED, EOC_EMP)
        VALUES 
        (@ZEO_ORDER_ID, CURRENT_TIMESTAMP, 1, 0, '2021-12-31', 0, 7277) --изменение даты.
        ,(@ZEO_ORDER_ID, CURRENT_TIMESTAMP, 200, 0, '0', 0, 7277) --перезаливка.

        SELECT * FROM ALEF_EDI_ORDERS_CHANGES WHERE EOC_ORDER_ID = @ZEO_ORDER_ID
    ROLLBACK TRAN
END;
*/

--#endregion [8] Перезаливка заказа (ручной режим).

--#region [7] Проверка несовпадения кодов в адресах доставки r_CompsAdd и таблице ALEF_EDI_GLN_OT.
IF EXISTS (
	SELECT TOP 1 1
	FROM [s-sql-d4].[elit].dbo.r_CompsAdd rc
	JOIN ALEF_EDI_GLN_OT                  ag ON (
				rc.CompID = ag.ZEC_KOD_KLN_OT
				and rc.GLNCode = ag.ZEC_KOD_ADD)
	WHERE rc.GLNCode not in ('', '0')
		and rc.CompAddID <> ag.ZEC_KOD_ADD_OT
		--добавляем исключения (здесь коды переподвязаны из-за новых адресов - старый удалять нельзя).
		and CompID NOT IN (7013,65867,71520,71522,71527)
		and GLNCode NOT IN ('4820069609916', '9864066921706', '9864066921713', '9864066921720', '9864066921744', '9864066921751', '9864066921768', '9864066934928', '9864066950836', '9864066998999', '9864232153122', '9864232169635', '9864232190936', '9864232210207', '9864232264736', '9864232266822', '9864232283584', '9864232291466', '9864232303220', '9864232322979', '9864232331537', '9864232335580', '9864232350422', '9864232354420', '9864232356936', '9864232368380', '9864232399377', '9864232428572', '9864232440413')
	)
BEGIN
	EXEC msdb.dbo.sp_send_dbmail @profile_name       = 'arda'
	,                            @from_address       = '<support_arda@const.dp.ua>'
	,                            @recipients         = @recipients
	,                            @subject            = 'Обнаружены несовпадения кодов в адресах доставки r_CompsAdd и таблице ALEF_EDI_GLN_OT'
	,                            @body               = 'Job: GLN_AUTO_ADD'
	,                            @body_format        = 'HTML'
	,                            @append_query_error = 1
END;
--#endregion [7] Проверка несовпадения кодов в адресах доставки r_CompsAdd и таблице ALEF_EDI_GLN_OT.

end;

GO
