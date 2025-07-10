
-- если у величилась сумма ид реплик
IF (SELECT ISNULL(SUM(ReplicaEventID), 0 ) FROM _CheckReplica WHERE ServerName != 'Sum_ID') 
	- (SELECT ISNULL(ReplicaEventID, 0 ) FROM _CheckReplica WHERE ServerName = 'Sum_ID') > 10
BEGIN
  --Отправка почтового сообщения если упала синхронизация
  BEGIN TRY 
  	DECLARE @subject varchar(250), @body varchar(max), @tableHTML  NVARCHAR(MAX) 
	SET @subject = 'Тревога!!! Упала синхронизация '
	
	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'main',  
	@recipients = 'pashkovv@const.dp.ua; vintagednepr2@const.dp.ua',  
	@subject = @subject,
	@body = '',  
	@body_format = 'TEXT'
	,@query = 'SELECT * FROM ElitR.dbo._CheckReplica';
  END TRY  
  BEGIN CATCH
    SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
  END CATCH  
END

-- обновление Sum_ID
UPDATE _CheckReplica
	  SET ReplicaEventID = cast((SELECT SUM(ISNULL(ReplicaEventID, 0 )) FROM _CheckReplica WHERE ServerName != 'Sum_ID') as int), -- сумма ид реплик
			CheckDateTime = GETDATE()
	  WHERE ServerName = 'Sum_ID'
	  
	  
	  SELECT * FROM _CheckReplica WHERE ServerName = 'Sum_ID'