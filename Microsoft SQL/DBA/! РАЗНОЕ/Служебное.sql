SELECT DB_NAME(dbid) AS DBName,
COUNT(dbid) AS NumberOfConnections,
loginame
FROM    sys.sysprocesses
GROUP BY dbid, loginame
ORDER BY DB_NAME(dbid)

select * from sys.databases

SELECT SERVERPROPERTY('COLLATION')
Sp_databases
sp_helpsort
select SERVERPROPERTY('connection')
SELECT SERVERPROPERTY('EDITION')
SELECT SERVERPROPERTY('IsIntegratedSecurityOnly')--If the result is 0, it means that both authentications are enabled. If it is 1, only Windows Authentication is enabled. 