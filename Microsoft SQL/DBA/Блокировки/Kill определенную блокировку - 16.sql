USE master

--Обзор подключенных пользователей 
SELECT name, database_id, recovery_model,*
FROM master.sys.databases

    -------------------------------------------------------------------------------
    -- Выбрасываем пользователей
    -------------------------------------------------------------------------------
    DECLARE @database_id int = 10 --Ввести номер базы по которой отключить пользователей

    SELECT * FROM sysprocesses sp WHERE dbid = @database_id and spid = 138 
    
    
    DECLARE @Cmd varchar(8000) 
    DECLARE @SPID int 
    DECLARE KillAll CURSOR FAST_FORWARD LOCAL FOR
      SELECT spid FROM sysprocesses sp WHERE dbid = @database_id and spid = 138 
    OPEN KillAll
    FETCH NEXT FROM KillAll INTO @SPID
    WHILE @@FETCH_STATUS = 0 BEGIN
      SET @Cmd='KILL ' + CAST(@SPID AS varchar)
      EXEC(@Cmd)
      FETCH NEXT FROM KillAll INTO @SPID
    END
    CLOSE KillAll
    DEALLOCATE KillAll