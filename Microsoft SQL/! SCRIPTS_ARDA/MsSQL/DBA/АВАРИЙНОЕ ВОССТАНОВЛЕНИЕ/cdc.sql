--https://www.sqlshack.com/how-to-track-changes-in-sql-server/

--First we will create a new Filegroup using the ALTER DATABASE ADD FILEGROUP SQL statement: 
USE [master]
GO
ALTER DATABASE [Alef_Elit] ADD FILEGROUP [CDC]
GO

--Once the Filegroup is created, a new database file will be created in this filegroup using ALTER DATABASE ADD FILE SQL statement: 
ALTER DATABASE [Alef_Elit] ADD FILE ( NAME = N'[Alef_Elit]', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\[Alef_Elit].ndf' , SIZE = 2048MB , FILEGROWTH = 128MB ) TO FILEGROUP [CDC]
GO

--To make the CDC Filegroup as the default filegroup, we will use the MODIFY FILEGROUP statement below: 
USE [Alef_Elit]
GO
ALTER DATABASE [Alef_Elit] MODIFY FILEGROUP [CDC] DEFAULT
GO

USE [Alef_Elit]
GO
EXEC sys.sp_cdc_enable_db 
--EXEC sys.sp_cdc_disable_db 
GO

USE [Alef_Elit]
GO
ALTER DATABASE [Alef_Elit] MODIFY FILEGROUP [primary] DEFAULT
GO


USE master 
GO 
SELECT [name], database_id, is_cdc_enabled  
FROM sys.databases
WHERE is_cdc_enabled = 1    
GO 
/*
The cdc.captured_columns contains the list of captured columns. 
The cdc.change_tables contains list of database tables with CDC enabled on it. 
The cdc.ddl_history contains the history of the DDL changes applied on the tracked table. 
The cdc.index_columns contains the tracked table’s indexes. 
And the cdc.lsn_time_mapping that maps LSN number. 
*/

--Now we will enable the Change Data Capture on the table’s level. As the CDC is a table-level feature, you need to enable it on each table you need to track and capture its DML changes. 
USE [Alef_Elit]
GO

EXEC sys.sp_cdc_enable_table   
@source_schema = N'dbo',
@source_name   = N'ALEF_EDI_GLN_SETI',
@role_name     = NULL,
@filegroup_name = N'CDC',
@supports_net_changes = 0
GO

SELECT [name], is_tracked_by_cdc  
FROM sys.tables 
WHERE is_tracked_by_cdc=1
GO   

SELECT * FROM [cdc].[change_tables] 
SELECT * FROM [cdc].[captured_columns]
SELECT * FROM [cdc].[dbo_ALEF_EDI_GLN_OT_CT]
SELECT * FROM [cdc].[dbo_ALEF_EDI_GLN_SETI_CT]
-- 1 delete
-- 2 insert
-- 3 update (before)
-- 4 update (after)