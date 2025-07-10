  --Восстановить базу Elit_test из бекапа
  
  /* 
--поиск backups Elit по новому c 20190722
IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable
CREATE TABLE #temptable(line nvarchar(max))
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\E\Backup\S-SQL-D4\* -Filter S-SQL-D4_Elit_FULL_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\E\Backup\S-SQL-D4\* -Filter S-SQL-D4_Elit_DIFF_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\G\S-SQL-D4\* -Filter S-SQL-D4_Elit_FULL_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\G\S-SQL-D4\* -Filter S-SQL-D4_Elit_DIFF_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\Backup\S-SQL-D4\* -Filter S-SQL-D4_Elit_FULL_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\Backup\S-SQL-D4\* -Filter S-SQL-D4_Elit_DIFF_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\S-SQL-D4\* -Filter S-SQL-D4_Elit_FULL_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\S-SQL-D4\* -Filter S-SQL-D4_Elit_DIFF_*.bak -Recurse | %{$_.FullName}";'
SELECT *,SUBSTRING (line,CHARINDEX('S-SQL-D4_Elit_',line)+19,15),SUBSTRING (line,CHARINDEX('S-SQL-D4_Elit_',line)+14,4) FROM #temptable where line is not null ORDER BY 2 desc


--поиск backups Elit
IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable
CREATE TABLE #temptable(line nvarchar(max))
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\E\Backup\S-SQL-D4\* -Filter S-SQL-D4_Elit_FULL_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\E\Backup\S-SQL-D4\* -Filter Elit_backup*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\G\S-SQL-D4\* -Filter Elit_backup*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\Backup\S-SQL-D4\* -Filter Elit_backup*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\S-SQL-D4\* -Filter Elit_backup*.bak -Recurse | %{$_.FullName}";'
SELECT *,SUBSTRING (line,CHARINDEX('Elit_backup_',line)+12,10) FROM #temptable where line is not null ORDER BY SUBSTRING (line,CHARINDEX('Elit_backup_',line),100) desc

  */
  /* 

--поиск backups ElitR по новому  c 20190722
IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable
CREATE TABLE #temptable(line nvarchar(max))
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\E\Backup\S-SQL-D4\* -Filter S-SQL-D4_ElitR_FULL_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\E\Backup\S-SQL-D4\* -Filter S-SQL-D4_ElitR_DIFF_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\G\S-SQL-D4\* -Filter S-SQL-D4_ElitR_FULL_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\G\S-SQL-D4\* -Filter S-SQL-D4_ElitR_DIFF_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\Backup\S-SQL-D4\* -Filter S-SQL-D4_ElitR_FULL_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\Backup\S-SQL-D4\* -Filter S-SQL-D4_ElitR_DIFF_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\S-SQL-D4\* -Filter S-SQL-D4_ElitR_FULL_*.bak -Recurse | %{$_.FullName}";'
INSERT #temptable(line)	EXEC master..xp_cmdshell  'powershell.exe " Get-ChildItem -Path \\s-sql-backup.corp.local\F\S-SQL-D4\* -Filter S-SQL-D4_ElitR_DIFF_*.bak -Recurse | %{$_.FullName}";'
SELECT *,SUBSTRING (line,CHARINDEX('S-SQL-D4_ElitR_',line)+20,15),SUBSTRING (line,CHARINDEX('S-SQL-D4_ElitR_',line)+15,4) FROM #temptable where line is not null ORDER BY 2 desc


--поиск backups ElitR
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

  IF OBJECT_ID (N'tempdb..#D', N'U') IS NOT NULL DROP TABLE #D
  CREATE TABLE #D (DBName sysname,BkpFileNameFULL varchar(MAX),BkpFileNameDIFF varchar(MAX))
  INSERT #D 
		SELECT 
		'ElitR_316_test2' DBName
		,'\\s-sql-backup.corp.local\E\Backup\S-SQL-D4\ElitR\FULL\S-SQL-D4_ElitR_FULL_20191002_014326.bak' BkpFileNameFULL
		,'\\s-sql-backup.corp.local\E\Backup\S-SQL-D4\ElitR\DIFF\S-SQL-D4_ElitR_DIFF_20191004_004100.bak' BkpFileNameDIFF
  SELECT * FROM #D


--RESTORE VERIFYONLY FROM DISK = @BkpFileName --проверить бекап

-- просмотреть подключеных пользователей к  базе
  DECLARE @DBID int, @SPID int
  SELECT db_name(dbid) as db_name,spid,loginame, status,hostname, program_name, nt_domain, nt_username,login_time, last_batch, * 
	FROM master.dbo.sysprocesses sp WHERE dbid=(SELECT database_id FROM master.sys.databases where name = (SELECT DBName FROM #D) and name <> 'master' )

/*
  --выбросить пользователей из  базы
   
    DECLARE @SPID int, @Cmd varchar(8000), @db_name varchar(250) = (SELECT DBName FROM #D)
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

--Если есть только FULL бэкап, то выключить этот блок и запустить восстановление разностной копии базы.
--При этом ОБЯЗАТЕЛЬНО ВСТАВИТЬ НАЗВАНИЕ ФАЙЛА БЭКАПА И В BkpFileNameFULL И В BkpFileNameDIFF.
IF 1 = 1
BEGIN
	--восстановить полную копию базы
	DECLARE @Cmd_FULL varchar(8000) = 'RESTORE DATABASE [' + (SELECT DBName FROM #D) + '] FROM DISK = ''' + (SELECT BkpFileNameFULL FROM #D) + ''' WITH NORECOVERY'  
	select @Cmd_FULL
	EXEC (@Cmd_FULL)
END;


--восстановить разностную копию базы
DECLARE @Cmd_DIFF varchar(8000) =  'RESTORE DATABASE [' + (SELECT DBName FROM #D) + '] FROM DISK = ''' + (SELECT BkpFileNameDIFF FROM #D) + ''' WITH RECOVERY'  
select @Cmd_DIFF
EXEC (@Cmd_DIFF)

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
