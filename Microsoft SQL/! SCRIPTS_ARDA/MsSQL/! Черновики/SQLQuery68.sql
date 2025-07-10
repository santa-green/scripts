USE msdb
GO

DECLARE @job_name_date varchar(max)

SELECT @job_name_date = (COALESCE(@job_name_date + ', ', '')) + [name] + ' ' + CONVERT(varchar, date_modified, 120)
FROM msdb.dbo.sysjobs
WHERE [enabled] = 0
	and [name] not like '%*OFF*%'

SELECT @job_name_date
DECLARE @server_name varchar(max) = (SELECT @@SERVERNAME)

IF DATEPART(MINUTE, GETDATE()) BETWEEN 20 AND 40
BEGIN
	IF EXISTS ( SELECT TOP 1 1
		FROM msdb.dbo.sysjobs
		WHERE [enabled] = 0
			and [name] not like '%*OFF*%' )
	BEGIN
		DECLARE @subject varchar(max) = 'Внимание! Отключены джобы: ' + '[' + @server_name + '] - ' + @job_name_date
		DECLARE @body varchar(max)
		SELECT @body = '<p style="font-size: 14; color: IndianRed"><b>' + 'Внимание! Отключены джобы: ' + '</b></p>'
		+ '<p style="font-size: 12; color: red">' + @job_name_date + '</p>'
		+ '<p style="font-size: 12; color: gray"><i>[для администратора БД] Отправлено [S-PPC] _[dba]_Jobs status monitor / Disabled jobs notification</i></p>'
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
END;