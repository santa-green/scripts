DECLARE @count tinyint
WHILE 1 = 1
begin

    SELECT @count = COUNT(*) FROM (
    SELECT * FROM testFROM
    ) m

    if @count = 1
        begin
            EXEC msdb.dbo.sp_send_dbmail  
				    @profile_name = 'arda',
				    @from_address = '<support_arda@const.dp.ua>',
				    @recipients = 'rumyantsev@const.dp.ua',
				    @subject = 'check',
				    --@body = @msg,  
				    @body_format = 'HTML',
                    @append_query_error = 1;
            RETURN
        end
END;

    --DELETE TOP(1) FROM testFROM WHERE ChID = 200519354

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHECKPOINT 2021-07-28 15:20:13*/
--Job.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [msdb]
GO

/****** Object:  Job [ELIT_temp_59318_rProdEC]    Script Date: 28.07.2021 15:19:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [EDI]    Script Date: 28.07.2021 15:19:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'EDI' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'EDI'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'ELIT_temp_59318_rProdEC', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'EDI', 
		@owner_login_name=N'CORP\rumyantsev', 
		@notify_email_operator_name=N'RumyantsevK', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [check rProdEC]    Script Date: 28.07.2021 15:19:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'check rProdEC', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE Elit
GO

IF EXISTS (SELECT TOP 1 1 FROM r_ProdEC WHERE CompID = 59318)
BEGIN
    EXEC msdb.dbo.sp_send_dbmail  
	    @profile_name = ''arda'',
	    @from_address = ''<support_arda@const.dp.ua>'',
	    @recipients = ''arda_servicedesk@const.dp.ua'',
	    @copy_recipients = ''rumyantsev@const.dp.ua'',
	    @subject = ''##RE-9507## Ëויכא ןמהגÿחאכא ךמהû ןמ ÒÎÂ ÀËÜÔÀ "641" סועü 2 ראדא (59318)'',
	    --@body = @msg,  
	    @body_format = ''HTML'',
        @append_query_error = 1;
END;
', 
		@database_name=N'Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'15 min', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=4, 
		@freq_subday_interval=15, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210728, 
		@active_end_date=99991231, 
		@active_start_time=90000, 
		@active_end_time=210000, 
		@schedule_uid=N'c0eaeacb-3a72-4cf7-85dc-5ce47460e4dc'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


