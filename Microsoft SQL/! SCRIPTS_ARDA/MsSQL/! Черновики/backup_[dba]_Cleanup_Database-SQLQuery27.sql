USE [msdb]
GO

/****** Object:  Job [_[dba]_Cleanup_Database]    Script Date: 16.09.2021 17:42:11 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 16.09.2021 17:42:11 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'_[dba]_Cleanup_Database', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'�������  � ����������� �� AlefElit', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'Support_arda', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [�������  � ����������� �� AlefElit]    Script Date: 16.09.2021 17:42:12 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'�������  � ����������� �� AlefElit', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- ������ ��� ������� �� ������� �� ������ ���������, ��� � �� �� ������������ � ��������� ������.
-- ����������� �����������, �� ��������, �� ����� ����������� �������� �������.



-- ����������:
-- 1. ������ ������� Pda_state
-- 2. ������ ������� DS_ActionsLog
-- 3. ������ ������ DS_DocAttachments � DS_EventsAttachments
-- 4. ������ ������� ds_synclog
-- 5. ������ ������� ������ ds_track
-- 6. �������� ������������ ���������� ������� Forest_Sons
-- 7. �������� ���������� �� �������������� ��������:
--	  - �������� ������������ ���������
--	  - ����� ����������
--	  - ���������� ����
--	  - ���������� ��������������� �������
--	  - ���������� �������
--	  - ���������� �������
--	  - �������� ���������� ������ ���������� ���.�����
-- 8. ����������� �� ���������� ����������� DBCC SHRINKDATABASE(0) exec dm_reindexdb
-- 9. �������� ���������� ���������

-- =======================================
--  1. ������ ������� Pda_state. ������ ������ �� ���������� ��, �.�. ������� �� ���� ������, ����� ������������� ������ � ������ �� ��� ��������, ��� ��������.
--  TFS130619 - 24.08.2015 �������� �������� ������� � pda_state
	delete  pda
	from PDA_State as pda
	where pda.MobId in (select mob.Mobid from mobiles as mob with(nolock)	
			where isnull(mob.MasterFid,0) = 0)
					 
	GO

--  2. ������ ������� DS_ActionsLog. 
	begin tran

	Declare @i int 
	Declare @row int 
	Declare @StartDate Datetime
	Declare @EndDate Datetime
	Declare @MidDate Datetime

	Set @i =0
	Set @row =0 

	Set @EndDate = DateAdd(dd, -60, getdate());
	Select @StartDate = min(logdate), @i=count(*) from ds_actionslog where logdate<=@EndDate;

	/*
	Select @StartDate , @EndDate, @i 
	Select * from Ds_actionslog where logdate between @StartDate and @EndDate
	*/

	Select row_number() OVER(ORDER BY logdate) as row, logdate
	into #tmp
	from ds_actionslog where logdate between @StartDate and @EndDate

	while @i>0
	Begin 
		   set @row=@row+1000;
		   select @MidDate=logdate from #tmp where row = @row;
		   --select @MidDate, @i, @row
		   delete from DS_ActionsLog where LogDate<=@MidDate;
		   If @i<1000 delete from DS_ActionsLog where LogDate<=@EndDate;
		   set @i=@i-1000;
	End

	drop table #tmp
	Select * from Ds_actionslog where logdate between @StartDate and @EndDate

	commit

--  3. ������ ������ DS_DocAttachments � DS_EventsAttachments. �������� ��������� "����������" � �������
	delete DS_DocAttachments where DocAttachDate < getdate() - 120
	delete DS_EventsAttachments where changedate < getdate() - 120
	
--  4. ������ ������� ds_synclog
	truncate table ds_synclog

--  5. �����
	Delete from ds_tracks where pointdate < getdate() - 90
	truncate table DS_TracksDetails

--  6. �������� ������������ ���������� ������� Forest_Sons
	exec DM_Forest_RegenSons

--  7. �������� ���������� �� �������������� ��������:
	-- �������� ������������ ���������
	delete DS_Messages where MessageDate < getdate() - 60
	delete DS_Messages_History where MessageDate < getdate() - 60
	delete DS_Messages_Temp
	delete DS_Messages_HistoryTemp
	-- ���������� ����
	delete DS_ITEMS_PRICES where ActiveFlag = 0	
	-- ���������� ��������������� �������
	delete DS_FacesItems where activeflag = 0
	-- ���������� �������
	delete DS_Balance where bdate < getdate() - 90
	delete DS_BalanceDocument where ActiveFlag = 0
	delete DS_BalanceDocumentDebts where ActiveFlag = 0
	-- ���������� �������
	delete DS_Events where EventDate < getdate() - 90
	delete DS_EventsAttributes where ChangeDate < getdate() - 60
	-- �������� ���������� ������ ���������� ���.�����
	delete DS_UpdateFiles where ActiveFlag = 0

-- 9. �������� ���������� ���������
	delete from DS_RoutePoints where routeid in (select routeid from DS_RouteHeaders where activeflag=0) 
	delete from DS_RouteObjects where routeid in (select routeid from DS_RouteHeaders where activeflag=0) 
	delete from DS_RoutePointsAttributes where routeid in (select routeid from DS_RouteHeaders where activeflag=0) 
	delete from DS_RouteAttributes where routeid in (select routeid from DS_RouteHeaders where activeflag=0)
	

	delete from DS_RouteHeaders where activeflag=0 

--  8. ����������� �� ���������� ����������� 
	DBCC SHRINKDATABASE(0) exec dm_reindexdb', 
		@database_name=N'Alef_Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Week step', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20180111, 
		@active_end_date=99991231, 
		@active_start_time=40000, 
		@active_end_time=235959, 
		@schedule_uid=N'6f8d901b-02de-4e77-a5b4-2fce743b81e7'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


