USE master

--����� ������������ ������������� 
SELECT name, database_id, recovery_model,*
FROM master.sys.databases

    -------------------------------------------------------------------------------
    -- ����������� �������������
    -------------------------------------------------------------------------------
    DECLARE @database_id int = 27 --������ ����� ���� �� ������� ��������� �������������
		SELECT loginame, program_name, hostname,* FROM sysprocesses sp WHERE dbid = @database_id
    
    DECLARE @Cmd varchar(8000) 
    DECLARE @SPID int 
    DECLARE KillAll CURSOR FAST_FORWARD LOCAL FOR
      SELECT spid FROM sysprocesses sp WHERE dbid = @database_id
    OPEN KillAll
    FETCH NEXT FROM KillAll INTO @SPID
    WHILE @@FETCH_STATUS = 0 BEGIN
      SET @Cmd='KILL ' + CAST(@SPID AS varchar)
      EXEC(@Cmd)
      FETCH NEXT FROM KillAll INTO @SPID
    END
    CLOSE KillAll
    DEALLOCATE KillAll