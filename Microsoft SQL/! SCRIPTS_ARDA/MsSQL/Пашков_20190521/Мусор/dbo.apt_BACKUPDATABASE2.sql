
CREATE PROC [dbo].[apt_BACKUPDATABASE] @LocalPath varchar(MAX) = 'D:\Install\Arhiv\FFood601', @DBName SYSNAME  = 'FFood601', @StoragePath varchar(MAX) = '\\s-elit-dp\F\arhiv-lan\'
AS
  /* Создание архива */
	DECLARE @BkDate varchar(10)=CONVERT(varchar(10), GETDATE(), 120)
	DECLARE @BkTime varchar(8)=REPLACE(CONVERT(varchar(100), GETDATE(), 114), ':', '-')
	DECLARE @Cmd varchar(8000)
	DECLARE @BkpFileName varchar(MAX)
	DECLARE @BkpFilePath varchar(MAX)

    -------------------------------------------------------------------------------
    -- Резервное копирование
    -------------------------------------------------------------------------------
  
    SET @BkpFileName = @DBName + '_backup_' + @BkDate + '_' + @BkTime + '.bak'
  
    SET @BkpFilePath = @LocalPath + '\' + @BkpFileName
  
	--DECLARE  @SPID_str VARCHAR(30) = CAST(@@spid AS VARCHAR(30))
	--RAISERROR ('spid %s ', 10,1,@SPID_str) WITH NOWAIT

	--создать каталог для хранения архивов	
	SET @Cmd='MD ' + @LocalPath
	SELECT GETDATE() DateStart,@Cmd Command;    
	EXEC xp_CMDShell @Cmd--, no_output
		
	--создать бекап
    BACKUP DATABASE @DBName TO DISK = @BkpFilePath
      WITH INIT, NOUNLOAD, NAME = @BkpFileName, SKIP, STATS=10, NOFORMAT
      

	IF @StoragePath IS NOT null
		SELECT @StoragePath = @StoragePath + CAST(SERVERPROPERTY('MachineName') AS varchar) + '\' + @BkDate


select @BkpFilePath, @DBName




	--SET @Cmd='MD ' + @StoragePath
	--SELECT GETDATE() DateStart,@Cmd Command;    
	--EXEC xp_CMDShell @Cmd--, no_output
	
	--создать архив из бекапа
	----SET @Cmd = '"C:\Program Files\7-Zip\7z.exe" a -bd -y -ssw -m0=lzma2:d48m -mmt12 -w -xr!*Export\* ' + @StoragePath + '\' +@BkpFileName + '.7z '+@BkpFilePath+' > '+@LocalPath+'\log.log'
	SET @Cmd = '"C:\Program Files\7-Zip\7z.exe" a -bd -y -ssw  -mmt12 -w ' + @LocalPath + '\' +@BkpFileName + '.7z '+@BkpFilePath+' > '+@LocalPath+'\log.log'
	SELECT GETDATE() DateStart,@Cmd Command;    
	EXEC xp_CMDShell @Cmd--, no_output


    --SET @Cmd='XCOPY /Y /I ' + @BkpFilePath + ' ' + @StoragePath + '\'
    --SELECT GETDATE() DateStart,@Cmd Command;    
    --EXEC xp_CMDShell @Cmd--, no_output

	--Удалить бекап  
    SET @Cmd='DEL ' + @BkpFilePath
    SELECT GETDATE() DateStart,@Cmd Command;    
    EXEC xp_CMDShell @Cmd--, no_output  

GO
