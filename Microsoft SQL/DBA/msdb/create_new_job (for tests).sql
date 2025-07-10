USE [msdb]
GO

/****** Object:  Job [[*OFF*] TEST Kirl]    Script Date: 19.07.2021 17:03:34 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 19.07.2021 17:03:34 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'TEST', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=3, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'for tests.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'RumyantsevK', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [sql]    Script Date: 19.07.2021 17:03:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sql', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE msdb
GO

BEGIN TRAN
    --WAITFOR TIME ''16:50''
    --WAITFOR DELAY ''00:00:05''
    --EXEC msdb.dbo.sp_update_job @job_name = N''EXITE_SYNC_EDI'', @enabled = 0
    --EXEC msdb.dbo.sp_send_dbmail @profile_name = ''arda'' ,@recipients = ''rumyantsev@const.dp.ua'' ,@subject = ''EXITE_SYNC_EDI disabled!''
    EXEC msdb.dbo.sp_update_job @job_name = N''EXITE_SYNC_EDI'', @enabled = 1
    EXEC msdb.dbo.sp_send_dbmail @profile_name = ''arda'' ,@recipients = ''rumyantsev@const.dp.ua'' ,@subject = ''EXITE_SYNC_EDI enabled back''
COMMIT TRAN', 
		@database_name=N'Alef_Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'TEST#1', 
		@enabled=1, 
		@freq_type=1, 
		@freq_interval=0, 
		@freq_subday_type=0, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20210719, 
		@active_end_date=99991231, 
		@active_start_time=170400, 
		@active_end_time=235959, 
		@schedule_uid=N'1639200d-23d8-45e1-b268-b882443ea9b9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


