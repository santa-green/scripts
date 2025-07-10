ALTER PROCEDURE [dbo].[ap_Check_job_IM] @job_name VARCHAR(200)
AS
BEGIN
/*
EXEC ap_Check_job_IM 'ELITR VC_Sync_Dp'
*/
--DECLARE @job_name VARCHAR(20) = 'ELITR VC_Sync_Dp'--'test'

IF (SELECT CAST(VarValue AS INT) FROM z_Vars WHERE VarName = @job_name) != 10
   AND ( SELECT DATEPART(MINUTE,GETDATE()) ) BETWEEN 0 AND 10
   AND ( SELECT DATEPART(HOUR,GETDATE()) ) = 0 
BEGIN
  UPDATE z_Vars SET VarValue = '10' WHERE VarName = @job_name
END;

IF (SELECT enabled FROM msdb.dbo.SysJobs WHERE name = @job_name) = 0
   AND ( ( ( SELECT DATEPART(MINUTE,GETDATE()) ) BETWEEN 0 AND 10 ) OR ( ( SELECT DATEPART(MINUTE,GETDATE()) ) BETWEEN 30 AND 40 ))
BEGIN
   EXEC msdb.dbo.sp_update_job  
    @job_name = @job_name,  
    @enabled = 1;  
END;

IF (SELECT COUNT(*)--j.name, instance_id, step_id, step_name,  run_date, run_time, run_duration,run_status, sql_message_id, sql_severity, message
	FROM msdb.dbo.SysJobHistory jsh WITH (NOLOCK)
	JOIN msdb.dbo.SysJobs j WITH (NOLOCK) ON jsh.job_id = j.job_id
	WHERE j.name = @job_name
	  AND jsh.step_id BETWEEN 1 AND (SELECT MAX(step_id) FROM msdb.dbo.SysJobHistory WHERE job_id = (SELECT job_id FROM msdb.dbo.SysJobs WHERE name = @job_name) )
	  AND CAST(jsh.run_date AS VARCHAR(50)) = (SELECT CONVERT(VARCHAR, GETDATE(), 112) )
	  AND jsh.run_status = 0
	--ORDER BY instance_id DESC
    ) > (SELECT CAST(VarValue AS INT) FROM z_Vars WHERE VarName = @job_name)
BEGIN

   BEGIN TRY 
	DECLARE @subject VARCHAR(250), @body VARCHAR(max), @msg VARCHAR(MAX) 
	SET @subject = 'Ошибка выполнения джоба ' + @job_name
	SET @msg = '<p>Внимание!!! Количество ошибок в шагах джоба '
			 + @job_name
			 + ' превысило '
			 + (SELECT VarValue FROM z_Vars WHERE VarName = @job_name)
			 + '.</p>'
			 + '<p>Джоб отключен и будет запущен в '
			 --+ (SELECT SUBSTRING( CONVERT(VARCHAR, DATEADD(MINUTE,40,GETDATE()), 108), 1, 4) + '0')
			 + (SELECT CASE WHEN (SELECT DATEPART(MINUTE,GETDATE() ) ) BETWEEN 0 AND 29
							THEN CAST(DATEPART(HOUR,GETDATE() ) AS VARCHAR(2)) + ':40'
							ELSE CAST( ( DATEPART(HOUR,GETDATE() ) + 1) AS VARCHAR(2)) + ':10'END)
			 + '.</p>'
			 + '<p>P.S. Если это сообщение приходит не первый раз за день, то стоит обратиться в службу ИТ, чтобы они разблокировали учетку.</p>'
			 + '<p>Отправлено [S-SQL-D4] JOB ELITR VC_Sync_check шаг 2 (Проверка джоба нового ИМ (Днепр))</p>';  

	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'main',
	@from_address = '<support_arda@const.dp.ua>',
	@recipients = 'maslov@const.dp.ua',--для теста  
	--@recipients = 'support_arda@const.dp.ua', 
	--@copy_recipients = 'rovnyagina@const.dp.ua; reshetnyak@const.dp.ua;strigakova@const.dp.ua;support_arda@const.dp.ua',  
	@subject = @subject,
	@body = @msg,  
	@body_format = 'HTML'

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

  UPDATE z_Vars SET VarValue = CAST( (CAST(VarValue AS INT) + 5)  AS VARCHAR(10) ) WHERE VarName = @job_name
   
  EXEC msdb.dbo.sp_update_job  
    @job_name = @job_name,  
    @enabled = 0; 
END;

/*
EXEC msdb.dbo.sp_update_job  
    @job_name = 'test',  
    @enabled = 1;  
GO 

EXEC msdb.dbo.SysJobServers  
    @job_name = 'ELITR VC_Sync_Dp'
GO

SELECT * FROM msdb.dbo.SysJobServers
WHERE job_id = (SELECT job_id FROM msdb.dbo.SysJobs WHERE name = 'test')

SELECT * FROM msdb.dbo.SysJobs
WHERE name = 'ELITR VC_Sync_Dp'
*/
END