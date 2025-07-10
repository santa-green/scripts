USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_block_notify]    Script Date: 16.08.2021 17:19:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_block_notify] @test bit = NULL
--Другая процедура по проверке блокировок: ap_SendEmail_do_Blocked (шаг 1).
--@Testing = null обычный режим, @Testing = 1 с выводом доп информации для отладки, 
--@Testing = 2 безопасный режим (без изменений в базе), @Testing = 3 безопасный режим с выводом доп информации для отладки
as
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[FIXED] rkv0 '2021-08-03 17:34' не тянуло адреса из ElitR.

begin
	SET NOCOUNT ON
    --/*FOR TEST*/ EXEC [dbo].[ap_block_notify] @test = 1
    DECLARE @recipients varchar(max)
    SET @recipients = (SELECT CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua' ELSE 'support_arda@const.dp.ua;tancyura@const.dp.ua;khiluk@const.dp.ua' END)
    SELECT @recipients

	--#region tempdb..block_notify
	IF OBJECT_ID('tempdb..block_notify', 'U') IS NOT NULL
		DROP TABLE tempdb..block_notify

    SELECT * INTO tempdb..block_notify
    FROM (SELECT spid                             
    --,            [status] + CONVERT(varchar, GETDATE(), 113) as [status]                         
    ,            [status] as [status]                         
    ,            CONVERT(CHAR(3), blocked)         AS blocked
    ,            loginame --dvv4, moa0                                                                                                                                                                                                                                                                                
    ,            SUBSTRING([program_name] ,1,25)   AS program
    ,            SUBSTRING(DB_NAME(p.dbid),1,20)   AS [database]
    ,            SUBSTRING(hostname, 1, 12)        AS host
    ,            cmd                              
    ,            sys.fn_varbintohexstr (waittype )    waittype --,cast(waittype as varchar) waittype
    ,            cast(t.[text] as varchar(250))       text
    ,            waittime / 1000       'Wait Time, s'
    FROM        sys.sysprocesses                    p
    CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t
    /*test*/ WHERE ( ([status] != 'sleeping' AND @test = 1) OR
    --WHERE (
    
		    (
			    spid IN (SELECT blocked
			    FROM sys.sysprocesses
			    WHERE blocked <> 0)
			    AND blocked = 0)
		    or (blocked <> 0))
	    AND ( [dbo].[zf_MatchFilterInt](p.dbid, '1,10,14',',') = 1)) m

	    SELECT *
	    FROM tempdb..block_notify

	    IF @test = 1 WAITFOR DELAY '00:00:03'
	    ELSE WAITFOR DELAY '00:00:30'
    
    IF NOT EXISTS (SELECT 1 FROM        sys.sysprocesses                    p
        CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t
    --WHERE CASE WHEN @test = 1 THEN [status] != 'sleeping' OR
    /*test*/ WHERE ( ([status] != 'sleeping' AND @test = 1) OR
    --WHERE (
		        (
			        spid IN (SELECT blocked
			        FROM sys.sysprocesses
			        WHERE blocked <> 0)
			        AND blocked = 0)
		        or (blocked <> 0))
	        AND ( [dbo].[zf_MatchFilterInt](p.dbid, '1,10,14',',') = 1))
        BEGIN
            RETURN
        END;

    INSERT INTO tempdb..block_notify
    SELECT spid                             
    --,            current_timestamp 'Метка записи'
    --,            [status] + CONVERT(varchar, GETDATE(), 113) as [status]                         
    ,            [status] as [status]                         
    ,            CONVERT(CHAR(3), blocked)         AS blocked
    ,            loginame                         
    ,            SUBSTRING([program_name] ,1,25)   AS program
    ,            SUBSTRING(DB_NAME(p.dbid),1,20)   AS [database]
    ,            SUBSTRING(hostname, 1, 12)        AS host
    ,            cmd                              
    ,            sys.fn_varbintohexstr (waittype )    waittype --,cast(waittype as varchar) waittype
    ,            cast(t.[text] as varchar(250))       text
    ,            waittime / 1000       'Wait Time, s'
    FROM        sys.sysprocesses                    p
    CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t
    /*test*/ WHERE ( ([status] != 'sleeping' AND @test = 1) OR
    --WHERE (
		    (
			    spid IN (SELECT blocked
			    FROM sys.sysprocesses
			    WHERE blocked <> 0)
			    AND blocked = 0)
		    or (blocked <> 0))
	    AND ( [dbo].[zf_MatchFilterInt](p.dbid, '1,10,14',',') = 1)

    SELECT *
    FROM tempdb..block_notify
	    --#endregion tempdb..block_notify


	--#region Отправка HTML
    SELECT spid, count(spid), loginame, [database]
    FROM tempdb..block_notify
    group by spid, loginame, [database]
    having count(spid) > 1
	
    IF EXISTS (SELECT 1
    FROM tempdb..block_notify
    group by spid, loginame, [database]
    having count(spid) > 1
        )
	BEGIN
		DECLARE @subject varchar(max) = 'Блокировки с интервалом 30 секунд'
		DECLARE @body varchar(max)
		DECLARE @msg varchar(max) = 'Hello'
		SET @msg = '<p style="font-size: 14; color: red"> Если знак "+" в поле Кто блокирует -> этот сотрудник блокирует остальных! </p>' +
        '<p style="font-size: 12; color: gray"><i>[для администратора БД] Отправлено [S-PPC] JOB "ELIT Blocked" шаг 2 
            (Уведомление о долгой блокировке / [ap_block_notify] )</i></p>'

        IF OBJECT_ID('tempdb..#html_init', 'U') IS NOT NULL
	        DROP TABLE #html_init
        IF OBJECT_ID('tempdb..#html', 'U') IS NOT NULL
	        DROP TABLE #html

SELECT 
       spid
,      [status] 
,      loginame                         
,      [database]                       
	INTO #html_init
FROM      tempdb..block_notify          m
group by spid, [status], loginame, [database]
having count(spid) > 1

SELECT * FROM #html_init

SELECT
    m.spid,
    m.[status],
    m.loginame,
    CONVERT(CHAR(3), sp.blocked) 'Кем заблокирован: spid',
    CASE WHEN sp.blocked = 0 THEN '+' ELSE '-' END 'КТО БЛОКИРУЕТ',
    [database],
    ISNULL(gui.EmpID, 9999)           'Код сотрудника',
    ISNULL(gui.EmpName, '[нет инфо]') 'ФИО',
    --[FIXED] rkv0 '2021-08-03 17:34' не тянуло адреса из ElitR.
    --(SELECT EMail FROM r_Emps WHERE EmpID = (SELECT EmpID FROM af_GetUserInfo(m.loginame))) 'email'
    COALESCE(
    (SELECT EMail FROM r_Emps WHERE EmpID = (SELECT EmpID FROM af_GetUserInfo(m.loginame))), 
    (SELECT EMail FROM ElitR.dbo.r_Emps WHERE EmpID = (SELECT EmpID FROM af_GetUserInfo(m.loginame))) 
    ) 'email'
INTO #html
FROM #html_init m
LEFT JOIN dbo.af_GetUserInfo('ALL_USERS') gui ON gui.UserName = m.loginame
JOIN sys.sysprocesses sp ON sp.spid = m.spid

SELECT * FROM #html

	DECLARE @head_html varchar(max) = NULL
	DECLARE @table varchar(max) = '#html'
		
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
        SELECT '+ @fields_html +' FROM #html t FOR XML RAW(''tr''), ELEMENTS
        )';
    SELECT @SQL
	EXEC sp_executesql           @SQL
	,                            N'@result NVARCHAR(MAX) output'
	,                  @result = @result OUTPUT

	DECLARE @body_html NVARCHAR(MAX)
	SET @body_html = N'<table  bordercolor=#eaa665 border="4"><tr>' + @Head_html + '</tr>' + @result + N'</table>'
	SET @body = @body_html + @msg

    DECLARE @copy_recipients varchar(max)
    SET @copy_recipients = (SELECT CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua'
                                                  ELSE (SELECT SUBSTRING((SELECT DISTINCT ';' + EMail as [text()]
	    FROM #html
	    WHERE EMail <> '' for XML PATH('')),2,65535)) END)
    SELECT @copy_recipients

	EXEC msdb.dbo.sp_send_dbmail @profile_name       = 'arda'
	,                            @from_address       = '<support_arda@const.dp.ua>'
	,                            @recipients         = @recipients
	,                            @copy_recipients    = @copy_recipients
	,                            @subject            = @subject
	,                            @body               = @body
	,                            @body_format        = 'HTML'
	,                            @append_query_error = 1
	,                            @importance         = 'high'

	END
--#endregion Отправка HTML

end





GO
