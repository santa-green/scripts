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
		@description=N'Очистка  и оптимизация БД AlefElit', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'Support_arda', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Очистка  и оптимизация БД AlefElit]    Script Date: 16.09.2021 17:42:12 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Очистка  и оптимизация БД AlefElit', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- Скрипт для очистки БД Оптимум на уровне партнеров, РСО и ГО от исторических и служебных данных.
-- Запускается еженедельно, на выходных, во время минимальной загрузки сервера.



-- Содержимое:
-- 1. Чистка таблицы Pda_state
-- 2. Чистка таблицы DS_ActionsLog
-- 3. Чистка таблиц DS_DocAttachments и DS_EventsAttachments
-- 4. Чистка таблицы ds_synclog
-- 5. Чистка таблицы треков ds_track
-- 6. Удаление накопившихся неактивных записей Forest_Sons
-- 7. Удаление информации по второстепенным таблицам:
--	  - удаление накопившихся сообщений
--	  - файлы обновления
--	  - неактивные цены
--	  - неактивные рекомендованные позиции
--	  - устаревшие балансы
--	  - устаревшие события
--	  - удаление неактивных файлов обновления моб.части
-- 8. Оптимизация БД системными процедурами DBCC SHRINKDATABASE(0) exec dm_reindexdb
-- 9. Удаление неактивных маршрутов

-- =======================================
--  1. Чистка таблицы Pda_state. Чистим только по неактивным ТП, т.к. чистить по дате нельзя, иначе синхронизация пойдет в полную по тем таблицам, что почистим.
--  TFS130619 - 24.08.2015 вычищаем ненужные записис в pda_state
	delete  pda
	from PDA_State as pda
	where pda.MobId in (select mob.Mobid from mobiles as mob with(nolock)	
			where isnull(mob.MasterFid,0) = 0)
					 
	GO

--  2. Чистка таблицы DS_ActionsLog. 
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

--  3. Чистка таблиц DS_DocAttachments и DS_EventsAttachments. Вложения документа "Фотография" и событий
	delete DS_DocAttachments where DocAttachDate < getdate() - 120
	delete DS_EventsAttachments where changedate < getdate() - 120
	
--  4. Чистка таблицы ds_synclog
	truncate table ds_synclog

--  5. Треки
	Delete from ds_tracks where pointdate < getdate() - 90
	truncate table DS_TracksDetails

--  6. Удаление накопившихся неактивных записей Forest_Sons
	exec DM_Forest_RegenSons

--  7. Удаление информации по второстепенным таблицам:
	-- удаление накопившихся сообщений
	delete DS_Messages where MessageDate < getdate() - 60
	delete DS_Messages_History where MessageDate < getdate() - 60
	delete DS_Messages_Temp
	delete DS_Messages_HistoryTemp
	-- неактивные цены
	delete DS_ITEMS_PRICES where ActiveFlag = 0	
	-- неактивные рекомендованные позиции
	delete DS_FacesItems where activeflag = 0
	-- устаревшие балансы
	delete DS_Balance where bdate < getdate() - 90
	delete DS_BalanceDocument where ActiveFlag = 0
	delete DS_BalanceDocumentDebts where ActiveFlag = 0
	-- устаревшие события
	delete DS_Events where EventDate < getdate() - 90
	delete DS_EventsAttributes where ChangeDate < getdate() - 60
	-- удаление неактивных файлов обновления моб.части
	delete DS_UpdateFiles where ActiveFlag = 0

-- 9. Удаление неактивных маршрутов
	delete from DS_RoutePoints where routeid in (select routeid from DS_RouteHeaders where activeflag=0) 
	delete from DS_RouteObjects where routeid in (select routeid from DS_RouteHeaders where activeflag=0) 
	delete from DS_RoutePointsAttributes where routeid in (select routeid from DS_RouteHeaders where activeflag=0) 
	delete from DS_RouteAttributes where routeid in (select routeid from DS_RouteHeaders where activeflag=0)
	

	delete from DS_RouteHeaders where activeflag=0 

--  8. Оптимизация БД системными процедурами 
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


