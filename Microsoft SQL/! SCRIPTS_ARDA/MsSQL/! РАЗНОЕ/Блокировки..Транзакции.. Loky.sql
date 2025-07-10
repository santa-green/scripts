--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--DBCC USEROPTIONS
DBCC OPENTRAN

--setuser 'tester'
ROLLBACK
--select SUSER_SNAME()
IF OBJECT_ID('dbo.Loky', 'U') IS NOT NULL DROP TABLE Loky
SELECT TOP 10 CompID INTO Loky FROM r_Comps
SELECT * FROM Loky

BEGIN TRAN TEST1
update Loky set CompID += 1000
WHERE CompID = (SELECT Compid FROM Loky WHERE CompID = 5)
/*alter table Loky
  add TmpField int null*/
SELECT @@TRANCOUNT
  --alter table Loky
--  drop column TmpField
--INSERT INTO Loky (CompID) VALUES(333)
SELECT * FROM Loky --WITH (TABLOCKX)--, HOLDLOCK)
dbcc opentran
--ROLLBACK
COMMIT TRAN TEST1

/*IF OBJECT_ID('dbo.Loky2', 'U') IS NOT NULL DROP TABLE Loky2
SELECT top (0) * INTO Loky2 FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_ORDERS_REPORT_SEQ
SELECT * FROM Loky2*/

SELECT -- используйте *, чтобы вывести все доступные атрибуты
request_session_id AS spid,
resource_type AS restype,
resource_database_id AS dbid,
DB_NAME(resource_database_id) AS dbname,
resource_description AS res,
resource_associated_entity_id AS resid,
request_mode AS mode,
request_status AS status
FROM sys.dm_tran_locks
WHERE DB_NAME(resource_database_id) IN ('Elit_TEST')

SELECT OBJECT_NAME(1946554814)
SELECT name, object_id, type_desc  
FROM sys.objects  
WHERE name = OBJECT_NAME(1946554814);

SELECT -- используйте *, чтобы вывести все доступные атрибуты
session_id AS spid,
connect_time,
last_read,
last_write,
most_recent_sql_handle
FROM sys.dm_exec_connections
WHERE session_id IN(162);
SELECT * FROM sys.dm_exec_connections  WHERE session_id IN(162);

SELECT -- используйте *, чтобы вывести все доступные атрибуты
session_id AS spid,
blocking_session_id,
command,
sql_handle,
database_id,
wait_type,
wait_time,
wait_resource
FROM sys.dm_exec_requests
WHERE blocking_session_id > 0;