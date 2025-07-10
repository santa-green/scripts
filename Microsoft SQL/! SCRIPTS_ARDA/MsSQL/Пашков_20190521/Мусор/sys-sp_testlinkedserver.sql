
--BEGIN TRY  
--    exec sp_testlinkedserver CP4_DP 
--   print 'ok'
--END TRY  
--BEGIN CATCH 
--SELECT  
--    ERROR_NUMBER() AS ErrorNumber  
--    ,ERROR_SEVERITY() AS ErrorSeverity  
--    ,ERROR_STATE() AS ErrorState  
--    ,ERROR_PROCEDURE() AS ErrorProcedure  
--    ,ERROR_LINE() AS ErrorLine  
--    ,ERROR_MESSAGE() AS ErrorMessage; 
--END CATCH 

  exec  sys.sp_testlinkedserver [CP1_DP]

BEGIN TRY  
    exec sp_testlinkedserver CP4_DP 
    print 'ok'    
    IF EXISTS (	select top 1 ReplicaEventID from [CP4_DP].elitv_O.dbo.z_replicain WITH (NOLOCK) where status = 2 order by replicaeventid )--Dnepr Vintage 192.168.70.2
      UPDATE _CheckReplica
		SET ReplicaEventID = (select top 1 ReplicaEventID from [CP4_DP].elitv_O.dbo.z_replicain WITH (NOLOCK) where status = 2 ), -- нарушение синхронизации
			CheckDateTime = GETDATE()
		WHERE ServerName = 's-marketa5'
	ELSE
	  UPDATE _CheckReplica
		SET ReplicaEventID = 1, -- 1 все ок
			CheckDateTime = GETDATE()
		WHERE ServerName = 's-marketa5'
END TRY  
BEGIN CATCH 
SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
    
    UPDATE _CheckReplica
		SET ReplicaEventID = 0, -- 0 нет связи с сервером
			CheckDateTime = GETDATE()
		WHERE ServerName = 's-marketa5' 
END CATCH  


EXEC test...sp_executesql N'SELECT * FROM [CP4_DP].master.dbo.sysusers'
SELECT @@ERROR

EXEC test...sp_executesql N'exec sp_testlinkedserver CP4_DP'
SELECT @@ERROR

BEGIN TRY  
    exec sp_testlinkedserver CP4_DP 
    --EXEC test...sp_executesql N'exec sp_testlinkedserver CP4_DP'
    print 'ok'    
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