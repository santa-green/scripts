  USE master
  
  DECLARE @BkDate varchar(10)=CONVERT(varchar(10), GETDATE(), 120)
  DECLARE @BkTime varchar(8)=REPLACE(CONVERT(varchar(100), GETDATE(), 114), ':', '-')
  DECLARE @LocalPath varchar(MAX)='D:\Install\Arhiv'
            
  DECLARE @DBName sysname = 'FFood601' -- ElitDistr
  DECLARE @Cmd varchar(8000)
  DECLARE @BkpFileName varchar(MAX)
  DECLARE @BkpFilePath varchar(MAX)

    -------------------------------------------------------------------------------
    -- –езервное копирование
    -------------------------------------------------------------------------------
  
    SET @BkpFileName = @DBName + '_backup_' + @BkDate + '_' + @BkTime + '.bak'
  
    SET @BkpFilePath = @LocalPath + '\' + @BkpFileName
  
	DECLARE  @SPID_str VARCHAR(30) = CAST(@@spid AS VARCHAR(30))
	RAISERROR ('spid %s ', 10,1,@SPID_str) WITH NOWAIT
  
    BACKUP DATABASE @DBName TO DISK = @BkpFilePath
      WITH INIT, NOUNLOAD, NAME = @BkpFileName, SKIP, STATS=10, NOFORMAT
      

select @BkpFilePath, @DBName
  

/*
select * from sys.dm_exec_requests where session_id in  (382)

--дл€ просмотра процента выполнени€ запроса
DECLARE @spid_restore int = 387
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
	RAISERROR ('¬ыполнено %s в %s', 10,1,@percent,@str) WITH NOWAIT

	WAITFOR DELAY '00:00:05'
END 


select percent_complete, estimated_completion_time, total_elapsed_time, st.text, * 
from sys.dm_exec_requests req
cross apply sys.dm_exec_sql_text ( req.sql_handle ) st
where req.session_id != @@spid and req.session_id = 530
*/
