select * from sys.sql_logins

SELECT * FROM sys.sysusers 

SELECT * FROM sys.database_principals

select * from master.dbo.syslogins, ElitR.dbo.sysusers where master.dbo.syslogins.sid = ElitR.dbo.sysusers.sid

SELECT * FROM ElitR.dbo.sysusers where islogin = 1