--Выбросить пользователей из базы
DECLARE @BaseName varchar(50) = 'ElitR_TEST_IM'

USE master
DECLARE @DBID int, @SPID int, @Cmd varchar(8000) 

SELECT * FROM master.dbo.sysprocesses sp WHERE dbid=(SELECT database_id FROM master.sys.databases where name = @BaseName )

   -------------------------------------------------------------------------------
    -- Выбрасываем пользователей
    -------------------------------------------------------------------------------
    DECLARE KillAll CURSOR FAST_FORWARD LOCAL FOR
      SELECT spid FROM master.dbo.sysprocesses sp 
        WHERE dbid=(SELECT database_id FROM master.sys.databases where name = @BaseName )
    OPEN KillAll
    FETCH NEXT FROM KillAll INTO @SPID
    WHILE @@FETCH_STATUS = 0 BEGIN
      SET @Cmd='KILL ' + CAST(@SPID AS varchar)
      EXEC(@Cmd)
      FETCH NEXT FROM KillAll INTO @SPID
    END
    CLOSE KillAll
    DEALLOCATE KillAll
    
SELECT * FROM master.dbo.sysprocesses sp WHERE dbid=(SELECT database_id FROM master.sys.databases where name = @BaseName )
