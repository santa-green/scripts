IF OBJECT_ID (N'tempdb..#object_roles', N'U') IS NOT NULL DROP TABLE #object_roles
CREATE TABLE #object_roles
( Owner VARCHAR(250),
  Object VARCHAR(250),
  Grantee VARCHAR(250),
  Grantor VARCHAR(250),
  ProtectType VARCHAR(250),
  Action VARCHAR(250),
  Columns VARCHAR(250)
  )

INSERT #object_roles EXEC sp_helprotect @name = NULL /*object name*/, @username = NULL /*user login name*/

SELECT
m.Object,
m.Action,
m.Grantee 'Role',
m.ProtectType,
us.name
FROM #object_roles m
JOIN sys.database_principals r WITH (NOLOCK) ON r.name = m.Grantee
JOIN sys.database_role_members mems WITH (NOLOCK) ON mems.role_principal_id = r.principal_id
JOIN sys.database_principals us WITH (NOLOCK) ON us.principal_id = mems.member_principal_id
WHERE m.Object = 't_Inv'