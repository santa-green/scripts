--«амен€ем название базы и пошагово запускаем.

--Turn off the suspect flag on the database and set it to EMERGENCY
EXEC sp_resetstatus 'RK7_SQL';
ALTER DATABASE RK7_SQL SET EMERGENCY

--Perform a consistency check on the master database
DBCC CHECKDB ('RK7_SQL')

--Bring the database into the Single User mode and roll back the previous transactions
ALTER DATABASE RK7_SQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE
--Take a complete backup of the database
--Attempt the Database Repair allowing some data loss
DBCC CHECKDB ('RK7_SQL', REPAIR_ALLOW_DATA_LOSS)

--Bring the database into the Multi-User mode
ALTER DATABASE database_name SET MULTI_USER

--Refresh the database server and verify the connectivity of database