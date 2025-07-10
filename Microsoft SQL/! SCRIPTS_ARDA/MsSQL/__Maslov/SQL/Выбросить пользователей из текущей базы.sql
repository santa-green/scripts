-- просмотреть подключенных пользователей к текущей базе
DECLARE @DBID int, @SPID int, @Cmd varchar(8000) 
SELECT db_name(dbid) as db_name,spid,loginame, status,hostname, program_name, nt_domain, nt_username,login_time, last_batch, * 
	FROM master.dbo.sysprocesses sp WHERE dbid=(SELECT database_id FROM master.sys.databases where name = db_name() and name <> 'master' )
	
--SELECT db_name(dbid) as db_name,spid,loginame, status,hostname, program_name, nt_domain, nt_username,login_time, last_batch,  * FROM master.dbo.sysprocesses sp
--where spid = 672

/* выбросить пользователей из текущей базы
   
    DECLARE @DBID int, @SPID int, @Cmd varchar(8000), @db_name varchar(250),@SQL NVARCHAR(1024)
    SET @db_name = db_name() 
    USE master 
    DECLARE KillAll CURSOR FAST_FORWARD LOCAL FOR
      SELECT spid FROM master.dbo.sysprocesses sp 
        WHERE dbid =(SELECT database_id FROM master.sys.databases where name = @db_name and name <> 'master'  )
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


--    KILL 672


--exec sp_who2 

--SELECT * FROM sys.databases



 /*
 
  SELECT db_name(dbid),spid,* FROM master.dbo.sysprocesses sp 
        WHERE dbid=(SELECT database_id FROM master.sys.databases where name = db_name() and name <> 'master' )
        
     select db_name(4)
        
    DECLARE @db_name varchar(250),@SQL NVARCHAR(1024)
    SET @db_name = db_name()
    USE master 
		
    SET @SQL = 'USE ' + QUOTENAME (@db_name)
    SELECT @SQL
    
    EXEC (@SQL) -- USE ElitV_KIEV
    
    EXECUTE  (N'USE [ElitV_KIEV]') EXECUTE as user = 'pvm0'
  
      --, @db_name varchar(250),@SQL NVARCHAR(1024)
    --SET @db_name = db_name()
    
      --SET @SQL = 'USE ' + QUOTENAME (@db_name)
    --EXEC (@SQL)  
    */