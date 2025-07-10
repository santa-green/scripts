  --Восстановить базу Elit_test из бекапа
  
  /* поиск backups Elit
IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable
CREATE TABLE #temptable(line nvarchar(max))
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\E\Backup\S-SQL-D4\* -Filter Elit_backup*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\G\S-SQL-D4\* -Filter Elit_backup*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\Backup\S-SQL-D4\* -Filter Elit_backup*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\S-SQL-D4\* -Filter Elit_backup*.bak -Recurse | %{$_.FullName}";'
SELECT *,SUBSTRING (line,CHARINDEX('Elit_backup_',line)+12,10) FROM #temptable where line is not null ORDER BY SUBSTRING (line,CHARINDEX('Elit_backup_',line),100) desc
  */
  /* поиск backups ElitR
IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable
CREATE TABLE #temptable(line nvarchar(max))
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\E\Backup\S-SQL-D4\* -Filter ElitR_backup*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\G\S-SQL-D4\* -Filter ElitR_backup*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\Backup\S-SQL-D4\* -Filter ElitR_backup*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\S-SQL-D4\* -Filter ElitR_backup*.bak -Recurse | %{$_.FullName}";'
SELECT *,SUBSTRING (line,CHARINDEX('ElitR_backup_',line)+13,10) дата_архива FROM #temptable where line is not null ORDER BY SUBSTRING (line,CHARINDEX('ElitR_backup_',line),100) desc
  */

  USE master

  set nocount on

  DECLARE @BkpFileName varchar(MAX)='\\s-sql-backup.corp.local\F\Backup\S-SQL-D4\2018\2018-05-25\Elit_backup_2018-05-25_22-49-04.bak'
  DECLARE @DBName sysname = 'Elit_TEST' -- 
  DECLARE @Cmd varchar(8000)

--RESTORE VERIFYONLY FROM DISK = @BkpFileName --проверить бекап

-- просмотреть подключеных пользователей к  базе
  DECLARE @DBID int, @SPID int
SELECT db_name(dbid) as db_name,spid,loginame, status,hostname, program_name, nt_domain, nt_username,login_time, last_batch, * 
	FROM master.dbo.sysprocesses sp WHERE dbid=(SELECT database_id FROM master.sys.databases where name = @DBName and name <> 'master' )

/*
  --выбросить пользователей из  базы
   
    DECLARE @SPID int, @Cmd varchar(8000), @db_name varchar(250) = 'Elit_TEST'
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

  
--DECLARE  @SPID_str VARCHAR(30) = CAST(@@spid AS VARCHAR(30))
--RAISERROR ('spid %s ', 10,1,@SPID_str) WITH NOWAIT
  
DECLARE @s varchar(max) 
set @s = 'DECLARE @spid_restore int = ' + cast(@@spid as varchar(20)) + '
DECLARE @BREAK int = 1000 -- прекратить после истечении этого времени, сек
DECLARE @str varchar(50), @percent varchar(50)
DECLARE @DateStart datetime = GETDATE()
WHILE exists (select top 1 percent_complete from sys.dm_exec_requests where session_id in  (@spid_restore))    		 
BEGIN
	set @str = CONVERT( varchar, GETDATE(), 120)   
	--RAISERROR (''дата проверки %s'', 10,1,@str) WITH NOWAIT
	IF DATEDIFF ( second , @DateStart , Cast (GETDATE() as DATETIME) ) > @BREAK  BREAK
	--skript
	set @percent = cast((select top 1 percent_complete from sys.dm_exec_requests where session_id in  (@spid_restore)) as varchar(30))
	RAISERROR (''Выполнено %s в %s'', 10,1,@percent,@str) WITH NOWAIT

	WAITFOR DELAY ''00:00:05''
END 
'
RAISERROR ('%s', 10,1,@s) WITH NOWAIT


  
   
RESTORE DATABASE @DBName FROM DISK = @BkpFileName;    


/*
select * from sys.dm_exec_requests where session_id in  (382)

--для просмотра процента выполнения запроса
DECLARE @spid_restore int = 83
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
