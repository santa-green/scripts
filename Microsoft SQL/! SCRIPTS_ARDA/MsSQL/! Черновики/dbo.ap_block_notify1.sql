USE Elit
GO
/****** Object:  StoredProcedure [dbo].[ap_block_notify]    Script Date: 26.05.2021 12:33:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_block_notify]
--Другая процедура по проверке блокировок: ap_SendEmail_do_Blocked (шаг 1).
as
begin
	SET NOCOUNT ON

	--#region tempdb..block_notify
	IF OBJECT_ID('tempdb..block_notify', 'U') IS NOT NULL
		DROP TABLE tempdb..block_notify

    SELECT * INTO tempdb..block_notify
    FROM (SELECT spid                             
    --FROM (SELECT TOP(3) spid                             
    ,            [status] + CONVERT(varchar, GETDATE(), 113) as [status]                         
    ,            CONVERT(CHAR(3), blocked)         AS blocked
    ,            loginame                         
    ,            SUBSTRING([program_name] ,1,25)   AS program
    ,            SUBSTRING(DB_NAME(p.dbid),1,20)   AS [database]
    ,            SUBSTRING(hostname, 1, 12)        AS host
    ,            cmd                              
    ,            sys.fn_varbintohexstr (waittype )    waittype --,cast(waittype as varchar) waittype
    ,            cast(t.[text] as varchar(250))       text
    FROM        sys.sysprocesses                    p
    CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t
    --test
    WHERE (
    --WHERE ( [status] != 'sleeping' OR
		    (
			    spid IN (SELECT blocked
			    FROM sys.sysprocesses
			    WHERE blocked <> 0)
			    AND blocked = 0)
		    or (blocked <> 0))
	    AND ( [dbo].[zf_MatchFilterInt](p.dbid, '1,10,14',',') = 1)) m

	    SELECT *
	    FROM tempdb..block_notify

	    WAITFOR DELAY '00:00:10'

    INSERT INTO tempdb..block_notify
    SELECT spid                             
    --SELECT TOP(3) spid                             
    --,            current_timestamp 'Метка записи'
    ,            [status] + CONVERT(varchar, GETDATE(), 113) as [status]                         
    ,            CONVERT(CHAR(3), blocked)         AS blocked
    ,            loginame                         
    ,            SUBSTRING([program_name] ,1,25)   AS program
    ,            SUBSTRING(DB_NAME(p.dbid),1,20)   AS [database]
    ,            SUBSTRING(hostname, 1, 12)        AS host
    ,            cmd                              
    ,            sys.fn_varbintohexstr (waittype )    waittype --,cast(waittype as varchar) waittype
    ,            cast(t.[text] as varchar(250))       text
    FROM        sys.sysprocesses                    p
    CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t
    --test
    WHERE (
    --WHERE ( [status] != 'sleeping' OR
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
	IF EXISTS (SELECT TOP 1 1 FROM tempdb..block_notify
        )
	BEGIN
		DECLARE @subject varchar(max) = 'Держат блокировку более 10 секунд'
		DECLARE @body varchar(max)
		DECLARE @msg varchar(max) = 'Hello'
		SET @msg = '<p style="font-size: 12; color: gray"><i>[для администратора БД] Отправлено [S-PPC] JOB "ELIT Blocked" шаг 2 (Уведомление о долгой блокировке / ap_tempdb..block_notify )</i></p>'

        IF OBJECT_ID('tempdb..#html', 'U') IS NOT NULL
	        DROP TABLE #html

SELECT spid
,      CASE 
            WHEN [status] like '%suspended%' THEN 'ЖЕРТВА!' 
            WHEN [status] like '%sleeping%' THEN 'ХИЩНИК!'
            ELSE '-'
       END 'КТО КОГО'                        
,      [status] 
,      blocked                          
,      loginame                         
,      ISNULL(rem.EmpID, 9999)           'Код сотрудника'
,      ISNULL(rem.EmpName, '[нет инфо]') 'ФИО'
,      program                          
,      [database]                       
,      host                             
,      cmd                              
,      waittype                         
,      [text]                           
	INTO #html
FROM      tempdb..block_notify          m  
LEFT JOIN [s-sql-d4].[Elit].dbo.r_Users ru  ON ru.UserName = m.loginame
LEFT JOIN [s-sql-d4].[Elit].dbo.r_emps  rem ON ru.EmpID = rem.EmpID
LEFT JOIN [s-sql-d4].[ElitR].dbo.r_Users rur  ON rur.UserName = m.loginame
LEFT JOIN [s-sql-d4].[ElitR].dbo.r_emps  remr ON rur.EmpID = remr.EmpID

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
	EXEC sp_executesql           @SQL
	,                            N'@result NVARCHAR(MAX) output'
	,                  @result = @result OUTPUT

	DECLARE @body_html NVARCHAR(MAX)
	SET @body_html = N'<table  bordercolor=#eaa665 border="4"><tr>' + @Head_html + '</tr>' + @result + N'</table>'
	SET @body = @body_html + @msg

	EXEC msdb.dbo.sp_send_dbmail @profile_name       = 'arda'
	,                            @from_address       = '<support_arda@const.dp.ua>'
	,                            @recipients         = 'rumyantsev@const.dp.ua'
	,                            @subject            = @subject
	,                            @body               = @body
	,                            @body_format        = 'HTML'
	,                            @append_query_error = 1
	,                            @importance         = 'high'

	END
--#endregion Отправка HTML

end


GO
