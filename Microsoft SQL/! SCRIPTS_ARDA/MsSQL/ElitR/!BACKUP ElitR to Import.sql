  USE master
  
  DECLARE @BkDate varchar(10)=CONVERT(varchar(10), GETDATE(), 120)
  DECLARE @BkTime varchar(8)=REPLACE(CONVERT(varchar(100), GETDATE(), 114), ':', '-')
  DECLARE @LocalPath varchar(MAX)='E:\OT38ElitServer\Import\Backup'
            
  DECLARE @DBName sysname = 'ElitR' -- ElitDistr
  DECLARE @Cmd varchar(8000)
  DECLARE @BkpFileName varchar(MAX)
  DECLARE @BkpFilePath varchar(MAX)

    -------------------------------------------------------------------------------
    -- Резервное копирование
    -------------------------------------------------------------------------------
  
    SET @BkpFileName = @DBName + '_backup_' + @BkDate + '_' + @BkTime + '.bak'
  
    SET @BkpFilePath = @LocalPath + '\' + @BkpFileName
  
	DECLARE  @SPID_str VARCHAR(30) = CAST(@@spid AS VARCHAR(30))
	RAISERROR ('spid %s ', 10,1,@SPID_str) WITH NOWAIT
  
    BACKUP DATABASE @DBName TO DISK = @BkpFilePath
      WITH INIT, NOUNLOAD, NAME = @BkpFileName, SKIP, STATS=10, NOFORMAT, COMPRESSION, COPY_ONLY
      

select @BkpFilePath, @DBName
  
