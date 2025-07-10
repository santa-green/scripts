CREATE PROCEDURE a_ImportComps @Server nvarchar(64), @DBName nvarchar(64), @User nvarchar(64), @Pass nvarchar(64)
AS
BEGIN

DECLARE @SQL nvarchar(2048)

DELETE FROM r_Comps

SELECT @SQL='INSERT INTO r_Comps(CompID, CompName, Notes) '+
'SELECT * FROM OPENROWSET(''SQLOLEDB'', '''
+@Server+'''; '''+@User+'''; '''+@Pass+
''', ''EXECUTE '+@DBName+'.dbo.a_GetComps'')'
EXECUTE(@SQL)

END
GO
