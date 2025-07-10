USE Alef_Elit
GO

-- Скрипт для очистки БД Оптимум на уровне партнеров, РСО и ГО от исторических и служебных данных.
-- Запускается еженедельно, на выходных, во время минимальной загрузки сервера.
stop


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
    DBCC SHRINKFILE('Mobile_Blank')
    DBCC SHRINKFILE('Mobile_Blank_log')
    DBCC SHRINKFILE('[Alef_Elit]')
	DBCC SHRINKDATABASE(0) 
    exec dm_reindexdb