  Восстановить базу ElitR_test из бекапа
  
  USE master

  DECLARE @BkpFileName varchar(MAX)='E:\OT38ElitServer\Import\Backup\ElitR_backup_2018-11-07_10-02-56.bak'
  DECLARE @DBName sysname = 'ElitR_test' -- 
  DECLARE @Cmd varchar(8000)

--RESTORE VERIFYONLY FROM DISK = @BkpFileName --проверить бекап

-- просмотреть подключеных пользователей к  базе
  DECLARE @DBID int, @SPID int
SELECT db_name(dbid) as db_name,spid,loginame, status,hostname, program_name, nt_domain, nt_username,login_time, last_batch, * 
	FROM master.dbo.sysprocesses sp WHERE dbid=(SELECT database_id FROM master.sys.databases where name = @DBName and name <> 'master' )

/*
  --выбросить пользователей из  базы
   
    DECLARE @SPID int, @Cmd varchar(8000), @db_name varchar(250) = 'ElitR_test'
    DECLARE KillAll CURSOR FAST_FORWARD LOCAL FOR
      SELECT spid FROM master.dbo.sysprocesses sp WHERE dbid =(SELECT database_id FROM master.sys.databases where name = @db_name and name <> 'master'  )
    OPEN KillAll
    FETCH NEXT FROM KillAll INTO @SPID
    WHILE @@FETCH_STATUS = 0 BEGIN
      SET @Cmd='KILL ' + CAST(@SPID AS varchar)
      EXEC(@Cmd)
      FETCH NEXT FROM KillAll INTO @SPID
    END
    CLOSE KillAll
    DEALLOCATE KillAll
*/
    -------------------------------------------------------------------------------
    -- Востановить базу данных
    -------------------------------------------------------------------------------

  
DECLARE  @SPID_str VARCHAR(30) = CAST(@@spid AS VARCHAR(30))
RAISERROR ('spid %s ', 10,1,@SPID_str) WITH NOWAIT
  
select @@spid
  
   
RESTORE DATABASE @DBName FROM DISK = @BkpFileName;    


/*
select * from sys.dm_exec_requests where session_id in  (382)

--для просмотра процента выполнения запроса
DECLARE @spid_restore int = 382
DECLARE @BREAK int = 1000 -- прекратить после истечении этого времени, сек
DECLARE @str varchar(50), @percent varchar(50)
DECLARE @DateStart datetime = GETDATE()
WHILE exists (select top 1 percent_complete from sys.dm_exec_requests where session_id in  (@spid_restore))    		 
BEGIN
	set @str = CONVERT( varchar, GETDATE(), 120)   
	--RAISERROR ('дата проверки %s', 10,1,@str) WITH NOWAIT
	IF DATEDIFF ( second , @DateStart , Cast (GETDATE() as DATETIME) ) > @BREAK  BREAK
	--skript
	set @percent = cast((select top 1 percent_complete from sys.dm_exec_requests where session_id in  (@spid_restore)) as varchar(30))
	RAISERROR ('Выполнено %s в %s', 10,1,@percent,@str) WITH NOWAIT

	WAITFOR DELAY '00:00:05'
END 


select percent_complete, estimated_completion_time, total_elapsed_time, st.text, * 
from sys.dm_exec_requests req
cross apply sys.dm_exec_sql_text ( req.sql_handle ) st
where req.session_id != @@spid and req.session_id = 530
*/
