DECLARE @parents VARCHAR(MAX) 
	   ,@name VARCHAR(256) = 'tester'

DECLARE @role TABLE (ParentRole VARCHAR(500), ChildRole VARCHAR(500), UserName VARCHAR(50) )

INSERT INTO @role
SELECT CASE WHEN EXISTS (SELECT * FROM sys.database_role_members ex WHERE ex.member_principal_id = m.role_principal_id)
			THEN (SELECT CASE WHEN (SELECT COUNT(ex1.role_principal_id) FROM sys.database_role_members ex1 WHERE ex1.member_principal_id = m.role_principal_id) > 1
								   THEN (SELECT SUBSTRING( (SELECT painfo.name + '; ' as [text()]
								         FROM sys.database_role_members ex1
										 JOIN sys.database_principals painfo ON ex1.role_principal_id = painfo.principal_id
										 WHERE m.role_principal_id = ex1.member_principal_id 
										 FOR XML PATH('')), 1,65535)
										 )--end of forming parent role
								   ELSE (SELECT painfo.name
										 FROM sys.database_role_members ex1
										 JOIN sys.database_principals painfo ON ex1.role_principal_id = painfo.principal_id
										 WHERE m.role_principal_id = ex1.member_principal_id
										)
								   END
				 )
			ELSE '-'
			END 'ParentRole'
      ,chinfo.name 'ChildRole'
      ,us.name 'User'
FROM sys.database_role_members m
JOIN sys.database_principals us ON m.member_principal_id = us.principal_id
JOIN sys.database_principals chinfo ON m.role_principal_id = chinfo.principal_id
WHERE us.name = @name


SELECT ChildRole, UserName FROM @role
EXCEPT
SELECT /*zr.RoleCode
	  ,*/zr.RoleName
	  ,ru.UserName
	  --,re.EmpName
FROM z_RoleUsers m
JOIN z_Roles zr WITH(NOLOCK) ON zr.RoleCode = m.RoleCode
JOIN r_Users ru WITH(NOLOCK) ON ru.UserID = m.UserCode
JOIN r_Emps re WITH(NOLOCK) ON re.EmpID = ru.EmpID
WHERE ru.UserName = @name

SELECT /*zr.RoleCode
	  ,*/zr.RoleName
	  ,ru.UserName
	  --,re.EmpName
FROM z_RoleUsers m
JOIN z_Roles zr WITH(NOLOCK) ON zr.RoleCode = m.RoleCode
JOIN r_Users ru WITH(NOLOCK) ON ru.UserID = m.UserCode
JOIN r_Emps re WITH(NOLOCK) ON re.EmpID = ru.EmpID
WHERE ru.UserName = @name
EXCEPT
SELECT ChildRole, UserName FROM @role


--SELECT SUBSTRING( (SELECT ex1.role_principal_id + ', ' as [text()] FROM sys.database_role_members ex1 WHERE ex1.member_principal_id = m.role_principal_id FOR XML PATH('')), 1,65535)
/*
SELECT *
FROM sys.database_principals
ORDER BY 1

EXEC sp_helpuser 'tlr'

EXEC sp_helprolemember 'db_datareader';
EXEC sp_helprolemember 'Полный доступ'; 

		SELECT DbRole = g.name, MemberName = u.name
			FROM sys.database_principals u, sys.database_principals g, sys.database_role_members m
			WHERE g.principal_id = m.role_principal_id
				AND u.principal_id = m.member_principal_id

SELECT DbChildRole = g.name, MemberName = u.name
FROM sys.database_principals u, sys.database_principals g, sys.database_role_members m
WHERE (g.principal_id = m.role_principal_id AND g.principal_id NOT IN (SELECT principal_id FROM sys.database_principals WHERE name LIKE 'db_%'))
  AND u.principal_id = m.member_principal_id


--16384,16385,16386,16387,16389,16390,16391,16392,16393
SELECT Parent_name = pinfo.name, Child_name = chinfo.name 
FROM sys.database_role_members m
JOIN sys.database_principals pinfo ON m.role_principal_id = pinfo.principal_id
JOIN sys.database_principals chinfo ON m.member_principal_id = chinfo.principal_id
WHERE m.member_principal_id IN (SELECT DISTINCT role_principal_id FROM sys.database_role_members)

SELECT * FROM sys.database_role_members


DECLARE @result NVARCHAR(max) 

SELECT @result = COALESCE(@result + ', ', '') + GrTMName FROM at_TMGr

SELECT @result
*/