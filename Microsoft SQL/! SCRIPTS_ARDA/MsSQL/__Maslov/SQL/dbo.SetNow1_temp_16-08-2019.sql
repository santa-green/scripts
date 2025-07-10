/*
SELECT TOP 1000 * FROM DS_SyncLog
WHERE MobID = -832216110
ORDER BY logdate dESC


SELECT DISTINCT  TOP 1000 LogText FROM DS_SyncLog
WHERE MobID = -832216110 AND N >= 168191
--ORDER BY logdate dESC

SELECT TOP 100 * FROM DS_ActionsLog
WHERE MasterfID = 1087251--ObjectID = -832216110
ORDER BY LogDate DESC

SELECT * FROM DS_NowSync
WHERE MobId = -832216110
ORDER BY dat1 DESC

SELECT * FROM mobcommands

SELECT * FROM mobiles
WHERE MobId = -832216110

-832216110
EXEC SetNow -832216110,98,0,0,0

BEGIN TRAN;
EXEC SetNow -832216110,57,0,0,0
--EXEC SetNow -832216110,59,0,0,0
ROLLBACK TRAN;


D_Get_Documents
D_Get_ITEms
D_Get_Amounts


SELECT TOP 100 * FROM DS_ObjectsAttributes
--WHERE AttrValueId is not null --= 305665
--WHERE AttrId = 30 AND AttrValueId = 305665
ORDER BY Changedate DESC

SELECT * FROM DS_Objects_pTypes

SELECT * FROM DS_ObjDocTypes

SELECT TOP 100 * FROM _tAItems_temp

SELECT * FROM DS_Attributes
WHERE AttrID = 769

SELECT * FROM DS_FACES

SELECT * FROM [dbo].[DS_AttributesValues]
WHERE AttrValueName = 'Арда Трейдинг'


SELECT * FROM DS_SalesRules_Objects

SELECT * FROM DS_ObjectsAttributes_Exclude

SELECT * FROM [dbo].[DS_ObjectsAttributes_Cash]

SELECT TOP 300 * FROM DS_SyncLog
WHERE MobID = -832216110
ORDER BY logdate dESC

SELECT TOP 100 * FROM DS_ActionsLog
WHERE MasterfID = 1087251--ObjectID = -832216110
ORDER BY LogDate DESC

SELECT * FROM DS_NowSync
WHERE MobId = -832216110
ORDER BY dat1 DESC

SELECT * FROM mobcommands

SELECT * FROM mobiles
WHERE MobId = -832216110

SELECT TOP 100 * FROM PDA_state
WHERE MobId = -832216110 --AND Type = 57
ORDER BY SendDate DESC

SELECT DISTINCT Type FROM PDA_state

SELECT * FROM DS_UnitItems

SELECT * FROM Ds_Items
WHERE iID = 1006444

SELECT * FROM DS_SchemeObjects


		select distinct OA_Itm.id as iid, OA_Itm.AttrValueID
		From DS_ObjectsAttributes_Cash as OA_Itm -- значения товара

		--moa0 20-08-2019 14:18 пытаемся ускорить синхронизацию
		WHERE OA_Itm.Changedate > '20190701'

SELECT * FROM DS_Items
WHERE activeFlag = 1

SELECT SUM(Amount) FROM DS_Amounts
WHERE 1000090 = StoreID

SELECT * FROM DS_FACES
WHERE fShortName = 'Днепр 004'
*/
--USE [Alef_Elit]
--GO
--/****** Object:  StoredProcedure [dbo].[SetNow]    Script Date: 16.08.2019 9:26:12 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER OFF
--GO
---- Last Edit: 12.03.2008 19:15
---832216110,57,0,0,0
--ALTER procedure [dbo].[SetNow](
DECLARE @Testing INT = 1

DECLARE @Exec_Sql varchar(max) 

IF @Testing = 1 RAISERROR('Начало скрипта в %s', 10,1) WITH NOWAIT
PRINT CONVERT( varchar, getdate(), 121) + N' Начало скрипта' 

IF @Testing = 1
BEGIN --найти позиции начала строк
	DECLARE @Running_Sql varchar(max) = (SELECT text ln FROM ::fn_get_sql((SELECT sql_handle FROM master.dbo.sysprocesses sp WHERE  spid = @@spid)))

	IF OBJECT_ID (N'tempdb..#linenum', N'U') IS NOT NULL DROP TABLE #linenum
	SELECT ROW_NUMBER()OVER(ORDER BY number) n , number
	into #linenum
	FROM (
		SELECT ROW_NUMBER()OVER(ORDER BY(SELECT 1)) number
		FROM 
		 (SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s1
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s2
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s3
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s4
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s5
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s6
	) gen
	where number BETWEEN 1 AND LEN(@Running_Sql) AND SUBSTRING(@Running_Sql,number,1)=char(13)

	--SELECT * FROM #linenum
END


declare
  @MobId		Int = -832216110,
  @TableId		Int = 57,
  @CommandCase	Int = 0,
  @Mode			Int = 0,
  @RecType		Int = 0
--As

declare @SyncDate		    dateTime
       ,@SyncDateOld    dateTime
       ,@Er             int
       ,@SQLtext        nvarchar(4000)
       ,@MobIDchar      varchar(50)
       ,@RecordFlag     int
       ,@Mode1          int
       ,@alwaysSyncFlag int

IF @Testing = 1 select @Exec_Sql = 'RAISERROR ('''+ CONVERT( varchar, getdate(), 121) + ' Выполнена строка ' + cast((SELECT (SELECT min(n) FROM #linenum where number > sp.stmt_start/2 ) FROM master.dbo.sysprocesses sp WHERE  spid = @@spid) as varchar)  +''', 10,1) WITH NOWAIT' ;exec (@Exec_Sql)


exec dbo.CL_S_Session_ID_Mobile_Set @MobId

IF @Testing = 1 select @Exec_Sql = 'RAISERROR ('''+ CONVERT( varchar, getdate(), 121) + ' Выполнена строка ' + cast((SELECT (SELECT min(n) FROM #linenum where number > sp.stmt_start/2 ) FROM master.dbo.sysprocesses sp WHERE  spid = @@spid) as varchar)  +''', 10,1) WITH NOWAIT' ;exec (@Exec_Sql)


-- Ставим признак в CONTEXT_INFO  ? не возвращать резалтесетов с ошибками     
exec dbo.DM_Session_ErrDisabled_Set

IF @Testing = 1 select @Exec_Sql = 'RAISERROR ('''+ CONVERT( varchar, getdate(), 121) + ' Выполнена строка ' + cast((SELECT (SELECT min(n) FROM #linenum where number > sp.stmt_start/2 ) FROM master.dbo.sysprocesses sp WHERE  spid = @@spid) as varchar)  +''', 10,1) WITH NOWAIT' ;exec (@Exec_Sql)

-- TASK 7266 - фильтр по OwnerDistID
Declare @OwnerDistID Int
SET @OwnerDistID = dbo.Get_DistID() 

Set @er = -1000
If @recType Is Null
	Set @RecType = 0
-- Запоминаем дату конца синхронизации из общей таблицы параметров
Select @syncDate = dat2 From mSync_Date Where mobID = @mobID
-- Для оптимума
Select @mobIDchar = mobIDchar From Mobiles Where mobID = @mobID And OwnerDistID = @OwnerDistID
-- Полная перезапись
If @CommandCase = 1 
	Delete From mSyncTable 
	Where	MobId	= @MobId 
	And		TableId	= @TableId
-- Проверка есть ли запись для данной мурзилки в mSyncTable, если ее нет то вставка
If Not Exists ( Select * From MSyncTable Where MobId = @MobId  And TableId = @TableId ) 
Begin
	Insert Into MSyncTable ( mobid , tableID , syncdate , syncdateOld ) 
		Values ( @mobid , @tableID , '01.01.01' , '01.01.01' )
	Set @CommandCase = 1
End
-- Проставляем для данной таблицы дату конца синхронизации
Update	MSyncTable 
Set		SyncDate = @SyncDate  
Where	mobId	= @mobId  
And		tableid	= @tableID
If @@error <> 0 
Begin
	SELECT 91
End
--Запоминаем дату начала синхронизации для данной таблицы
Select	@SyncDateOld	= SyncDateOld 
From	MSyncTable 
Where	MobId	= @mobId 
And		TableId	= @TableId
If  @SyncDateOld Is Null
Begin
	SELECT 92
End
--Если такая дата, то включается режим полной перезаписи
If @SyncDateOld = '01.01.01'  
	Set @CommandCase = 1
	IF @Testing = 1 select @Exec_Sql = 'RAISERROR ('''+ CONVERT( varchar, getdate(), 121) + ' Выполнена строка ' + cast((SELECT (SELECT min(n) FROM #linenum where number > sp.stmt_start/2 ) FROM master.dbo.sysprocesses sp WHERE  spid = @@spid) as varchar)  +''', 10,1) WITH NOWAIT' ;exec (@Exec_Sql)

-- Подставляем значения в таблицу параметров
Exec DM_Set_NowSync
	@dat1		= @syncdateOld, 
	@dat2		= @syncdate, 
	@MobIdChar	= @mobIDchar, 
	@CommandCase= @commandcase,
	@Mode		= @mode,
	@RecType	= @recType
If @@error <> 0
Begin
	SELECT 93
End
IF @Testing = 1 select @Exec_Sql = 'RAISERROR ('''+ CONVERT( varchar, getdate(), 121) + ' Выполнена строка ' + cast((SELECT (SELECT min(n) FROM #linenum where number > sp.stmt_start/2 ) FROM master.dbo.sysprocesses sp WHERE  spid = @@spid) as varchar)  +''', 10,1) WITH NOWAIT' ;exec (@Exec_Sql)

--Режим посылки ------------------------------------
--Ищется процедура соответствующаяя данной таблице
Select	@SQLtext	= commandText,
		@Mode1		= mode 
From	mobcommands 
Where	tableID	= @tableID  
And		recType	= @recType
If @mode1 < @mode 
	Set @er = -1000 
Else 
Begin
	If IsNull ( @sqltext , '' ) = '' 
		Set @Er = 96
	Else 
	Begin
		Set @Er = 0
		----------------
		-- ИСПОЛНЕНИЕ --
		----------------
		IF @Testing = 1 select @Exec_Sql = 'RAISERROR ('''+ CONVERT( varchar, getdate(), 121) + ' Выполнена строка ' + cast((SELECT (SELECT min(n) FROM #linenum where number > sp.stmt_start/2 ) FROM master.dbo.sysprocesses sp WHERE  spid = @@spid) as varchar)  +''', 10,1) WITH NOWAIT' ;exec (@Exec_Sql)

		Exec @Er = @SQLtext

		IF @Testing = 1 select @Exec_Sql = 'RAISERROR ('''+ CONVERT( varchar, getdate(), 121) + ' Выполнена строка ' + cast((SELECT (SELECT min(n) FROM #linenum where number > sp.stmt_start/2 ) FROM master.dbo.sysprocesses sp WHERE  spid = @@spid) as varchar)  +''', 10,1) WITH NOWAIT' ;exec (@Exec_Sql)

	    If @Er >= 0 Or @@error <> 0   
		Begin
			If @Er = 0 And  @@error <> 0 -- Процедура не вернула ничего осознанного
				Set @Er = 94 -- Кривая процедура
       		SELECT @Er
	    End
	End
End

exec dbo.DM_Get_MobId @CommandCase = @CommandCase out

-- Общая для моды 1 ( Режим обработки подтверждения приема-посылки)

select	@alwaysSyncFlag = alwaysSyncFlag
from	mobTables
where	tableid = @tableid

if @mode = 1 
begin 
	update	mSyncTable 
	set		syncdateOld		= syncdate,
			LocalSyncFlag	= @alwaysSyncFlag
	where	mobid	= @mobid 
	and		tableid = @tableid

	if @@error <> 0 
	begin
       	SELECT 95
	end
end

-- код возврата D_Get_ = -1000 свидетельствует о том что процедура ничего не вернула, 
-- передавать нечего
If @er = -1000 Or @Er > 0 
Begin
	-- обновим дату последней передачи этой таблицы (необходимо, 
	-- т.к. используется EndDate при записи новых данных)
	update mSyncTable 
	set	syncdateOld		= syncdate ,
		LocalSyncFlag	= @alwaysSyncFlag
	Where	mobid	= @mobid
	and		tableid	= @tableid
	If @@error <> 0 
	Begin
       	SELECT 95
    End
	-- и эмулируем для МАС пустой RecordSet
	Select * From mobTables Where tableID = 9898
End

-- Подача сигнала о полной перезаписи в МАС, т.е. если код возврата <-1000  то Мас передает данные в режиме полной перезаписи
If @CommandCase = 1 And @Er < 0 
	Set @Er = @Er - 1000

	SELECT @Er
--SELECT @er
--35084
