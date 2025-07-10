SELECT * FROM ALEF_EDI_GLN_OT WHERE ZEC_KOD_KLN_OT = 7031
SELECT * FROM [s-sql-d4].[elit].dbo.r_comps WHERE compid = 7031
SELECT *, (SELECT compname FROM [s-sql-d4].[elit].dbo.r_comps WHERE compid = m.ZEC_KOD_KLN_OT) 'CompName' FROM ALEF_EDI_GLN_OT m
SELECT dbo.af_GetOnlyNum(compid) 'NewCompID', * FROM r_comps m
select dbo.af_GetOnlyNum('')

SET STATISTICS TIME ON
SELECT TOP(100) * FROM ALEF_EDI_GLN_OT
CROSS APPLY ALEF_EDI_GLN_SETI

SELECT * FROM ALEF_EDI_GLN_OT
CROSS APPLY ALEF_EDI_GLN_SETI
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE COMPUTER
GO
--begin tran
SELECT * FROM 
Product p
--CROSS APPLY
join Laptop l ON p.model = l.model
;
--commit tran
--dbcc opentran
--SELECT * FROM sys.dm_exec_sessions
--SELECT DATABASEPROPERTYEX('computer','useraccess') 
--ALTER DATABASE COMPUTER SET MULTI_USER with rollback immediate
--ALTER DATABASE COMPUTER SET single_user with rollback immediate

--SELECT DB_NAME(database_id) [DATABASE_NAME] 
--FROM sys.change_tracking_databases;
--GO

--ALTER TABLE dbo.Product
--ENABLE CHANGE_TRACKING
--WITH (TRACK_COLUMNS_UPDATED = OFF);

--GO
--insert into Product values ('b', 1111, 'pc') 
--SELECT ct.model, ct.SYS_CHANGE_OPERATION, c.model
--FROM CHANGETABLE(CHANGES dbo.Product, 0) ct
--JOIN dbo.Product c ON c.model = ct.model;

--SELECT * FROM CHANGETABLE(CHANGES dbo.Product, 0) ct

SELECT * FROM 
Product, Laptop;