SELECT * FROM elit.dbo.r_users where UserName  in ('sw','cev','sma1','rav8','vis3','viv1','pas7','mad','401','302','222','220','201','501','502','301','181')
SELECT * FROM elitR.dbo.r_users where UserName  in ('sw','cev','sma1','rav8','vis3','viv1','pas7','mad','401','302','222','220','201','501','502','301','181')


SELECT u.UserID, CAST(u.UserName as varchar(10)) UserName, CAST(e.EmpName as varchar(60)) EmpName, u.EmpID, u.Active,  u.BDate, u.EDate, u.UseOpenAge 
FROM r_Users u
JOIN r_Emps e ON e.EmpID = u.EmpID
WHERE UserName  in ('sw','cev','sma1','rav8','vis3','viv1','pas7','mad','401','302','222','220','201','501','502','301','181')
ORDER BY 2 desc


SELECT s.name AS [schema_name], dp1.name AS [owner_name]
FROM sys.schemas AS s
  INNER JOIN sys.database_principals AS dp1 ON dp1.principal_id = s.principal_id
  where s.name = 'vis3'

  ALTER AUTHORIZATION ON SCHEMA::[vis3] TO [dbo]




IF OBJECT_ID (N'tempdb..#tempww', N'U') IS NOT NULL DROP TABLE #tempww
CREATE TABLE #tempww 
(
    LoginName nvarchar(max),
    DBname nvarchar(max),
    Username nvarchar(max), 
    AliasName nvarchar(max)
)

INSERT INTO #tempww 
EXEC master..sp_msloginmappings 

-- display results
SELECT * 
FROM   #tempww where Username = 'pas7'
ORDER BY dbname, username

USE ElitR_test1
SELECT s.name AS [schema_name], dp1.name AS [owner_name], 'USE '+db_name()+'; ALTER AUTHORIZATION ON SCHEMA::['+ s.name +'] TO [dbo]'
FROM sys.schemas AS s  INNER JOIN sys.database_principals AS dp1 ON dp1.principal_id = s.principal_id
WHERE dp1.name = 'pas7'


DROP USER [pas7]


SELECT *, 'USE '+t.DBname+'; ALTER AUTHORIZATION ON SCHEMA::['+ t.LoginName +'] TO [dbo]' 'script' FROM   #tempww t
join (SELECT s.name AS [schema_name], dp1.name AS [owner_name]
FROM sys.schemas AS s  INNER JOIN sys.database_principals AS dp1 ON dp1.principal_id = s.principal_id
) sp on sp.[owner_name] = t.Username
where t.Username = 'pas7'
ORDER BY 2


SELECT s.name AS [schema_name], dp1.name AS [owner_name], 'USE '+db_name()+'; ALTER AUTHORIZATION ON SCHEMA::['+ s.name +'] TO [dbo]'
FROM ElitR_test1.dbo.sys.schemas AS s  INNER JOIN ElitR_test1.dbo.sys.database_principals AS dp1 ON dp1.principal_id = s.principal_id
WHERE dp1.name = 'pas7'

/*
ElitR
ElitR_test
ElitR_test_spp
ElitR_test1
ElitR_test2
*/

SELECT * FROM sys.schemas ORDER BY 1
SELECT * FROM sys.database_principals ORDER BY 2


SELECT * FROM sys.schemas where principal_id = 127
