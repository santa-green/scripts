IF EXISTS(SELECT * FROM sys.database_files WHERE file_id=1 AND (size-CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0)>100)
  DBCC SHRINKDATABASE ([ElitR_test_IM]) WITH NO_INFOMSGS
  
  EXEC sp_spaceused
  
select  CAST(FILEPROPERTY('OTData_D', 'SpaceUsed') AS int)

EXEC xp_cmdshell 'del E:\SQLData\MSSQL10_50.MSSQLSERVER\MSSQL\Backup\elitr-2017-02-10-13-41'
EXEC xp_cmdshell 'dir E:\SQLData\MSSQL10_50.MSSQLSERVER\MSSQL\Backup\'

EXEC xp_cmdshell 'dir E:\*.* /a:d'


EXEC xp_cmdshell 'copy E:\OT38ElitServer_backup.cmd e:\OT38ElitServer\Import\'

EXEC xp_cmdshell 'dir e:\OT38ElitServer\Import\'


EXEC xp_cmdshell 'del e:\OT38ElitServer\Import\ElitR.bak'


ap_SYS_1_Maintenance

ap_SYS_2_BackupDBs

ap_SYS_3_BackupReps

SELECT * FROM sysprocesses sp

SELECT  QUOTENAME('ElitR')

SELECT *, QUOTENAME(u.name) UserName, QUOTENAME(o.name) TableNameä
                FROM [ElitR].sys.tables o
                JOIN [ElitR].sys.schemas u ON u.schema_id=o.schema_id
                WHERE o.type='U' AND u.name<>'dbo'
                ORDER BY 1, 2
                
SELECT name FROM sys.tables 

exec sp_spaceused z_LogUpdate
             
             
SELECT * FROM z_Tables
             it_CancPriceD
             SELECT * FROM r_ProdMPCh

