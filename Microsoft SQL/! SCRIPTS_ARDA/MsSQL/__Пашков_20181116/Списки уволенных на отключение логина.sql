DECLARE @DBName sysname, @SQL nvarchar(2048)
DECLARE DB CURSOR FAST_FORWARD LOCAL FOR
SELECT QUOTENAME(name) DBName
FROM master.sys.databases
WHERE database_id > 4
AND name NOT LIKE '%copy%'
AND name NOT LIKE '%test%'
AND name NOT LIKE '%tmp%'
AND name NOT LIKE '%[0-9][0-9][0-9][0-9]%'
AND State = 0

OPEN DB
FETCH NEXT FROM DB INTO @DBName
WHILE @@FETCH_STATUS = 0
BEGIN
  SET @SQL = '
IF EXISTS (SELECT * FROM ' + @DBName + '.sys.tables WHERE name = ''r_Emps'' AND schema_id = 1)
BEGIN
  DECLARE @Name sysname, @SQLText nvarchar(512)

  DECLARE DenyLogin CURSOR FOR
  SELECT ru.UserName
  FROM ' + @DBName + '.dbo.r_Users ru WITH(NOLOCK)
  JOIN ' + @DBName + '.dbo.r_Emps re WITH(NOLOCK) On re.EmpID = ru.EmpID
  JOIN master.sys.sql_logins sl ON sl.name = ru.UserName
    WHERE re.EmpName like ''%Уволен%'' AND sl.is_disabled = 0 AND ru.UserName not in (''sw'',''cev'',''sma1'',''rav8'',''vis3'',''viv1'',''pas7'',''mad'',''401'',''302'')

  OPEN DenyLogin
  FETCH NEXT FROM DenyLogin INTO @Name
  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @SQLText = ''ALTER LOGIN ''+@Name+'' DISABLE''
    
    --EXEC sp_ExecuteSQL @SQLText
    
    SELECT @SQLText
    PRINT ''LOGIN ''+@Name+'' IS DISABLED''

    FETCH NEXT FROM DenyLogin INTO @name
  END
  CLOSE DenyLogin
  DEALLOCATE DenyLogin
END'

--SELECT  @SQL

  EXEC sp_ExecuteSQL @SQL

  FETCH NEXT FROM DB INTO @DBName
END
CLOSE DB
DEALLOCATE DB
