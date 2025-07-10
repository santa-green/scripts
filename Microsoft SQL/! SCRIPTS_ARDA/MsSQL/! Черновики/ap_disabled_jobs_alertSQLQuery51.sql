USE msdb
GO
alter proc ap_disabled_jobs_alert
as
begin

DECLARE @job_name_date varchar(max)

SELECT @job_name_date = (COALESCE(@job_name_date + ', ', '')) + [name] + ' ' + CONVERT(varchar, date_modified, 120)
FROM msdb.dbo.sysjobs
WHERE [enabled] = 0
	and [name] not like '%*OFF*%'

SELECT @job_name_date
DECLARE @server_name varchar(max) = (SELECT @@SERVERNAME)

IF DATEPART(MINUTE, GETDATE()) BETWEEN 0 AND 59
BEGIN
	IF EXISTS ( SELECT TOP 1 1
		FROM msdb.dbo.sysjobs
		WHERE [enabled] = 0
			and [name] not like '%*OFF*%' )
	BEGIN
		
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*@body_html*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    DECLARE @head_html varchar(max) = NULL
    DECLARE @table varchar(max) = 'jobs_disabled_event_log'
    SELECT @head_html = ISNULL(@head_html, '') + '<th>' + COLUMN_NAME + '</th>'
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = (SELECT [name]
	    FROM sys.tables
	    WHERE object_id = OBJECT_ID('msdb..' + @table))
    ORDER BY ORDINAL_POSITION
    --select @head_html

    DECLARE @fields_html varchar(max) = NULL
    SELECT @fields_html = ISNULL(@fields_html, '') + CASE WHEN @fields_html IS NULL THEN ''
                                                                                    ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td'
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = (SELECT [name]
	    FROM sys.tables
	    WHERE object_id = OBJECT_ID('msdb..' + @table))
    ORDER BY ORDINAL_POSITION
    --select @fields_html

    DECLARE @SQL NVARCHAR(4000);
    DECLARE @result NVARCHAR(MAX)
    SET @SQL = 'SELECT @result = (
                SELECT TOP(10) '+ @fields_html +' FROM ' + @table + ' t ORDER BY action_timestamp DESC FOR XML RAW(''tr''), ELEMENTS
                )';
    select @SQL
    EXEC sp_executesql           @SQL
    ,                            N'@result NVARCHAR(MAX) output'
    ,                  @result = @result OUTPUT

    DECLARE @body_html NVARCHAR(MAX)
    SET @body_html = N'<table  bordercolor=#FF0000 border="5"><tr>' + @Head_html + '</tr>' + @result + N'</table>'
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*@body_html*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
        DECLARE @subject varchar(max) = 'Внимание! Отключены джобы: ' + '[' + @server_name + '] - ' + @job_name_date
		DECLARE @body varchar(max)
		SELECT @body = '<p style="font-size: 14; color: IndianRed"><b>' + 'Внимание! Отключены джобы: ' + '</b></p>'
		+ '<p style="font-size: 12; color: red">' + @job_name_date + '</p>'
		+ '<p style="font-size: 12; color: gray"><i>[для администратора БД] Отправлено [S-PPC] _[dba]_Jobs status monitor / Disabled jobs notification</i></p>'
        + @body_html

		SELECT @subject
		EXEC msdb.dbo.sp_send_dbmail @profile_name       = 'arda'
		,                            @from_address       = '<support_arda@const.dp.ua>'
		,                            @recipients         = 'support_arda@const.dp.ua'
		--,                            @recipients         = 'rumyantsev@const.dp.ua'
		,                            @subject            = @subject
		,                            @body               = @body
		,                            @body_format        = 'HTML'
		,                            @append_query_error = 1
		,                            @importance         = 'high'
	END;

    DECLARE @old_status BIT, @new_status BIT, @job_name VARCHAR(1024)

END;

--alter TRIGGER [dbo].Alert_on_job_disabled

--create table msdb.dbo.jobs_disabled_event_log (
--    login_name varchar(100),
--    job_name varchar(100),
--    job_status varchar(30),
--    action_timestamp datetime)
--SELECT TOP(10) * FROM msdb.dbo.jobs_disabled_event_log ORDER BY action_timestamp DESC

end;