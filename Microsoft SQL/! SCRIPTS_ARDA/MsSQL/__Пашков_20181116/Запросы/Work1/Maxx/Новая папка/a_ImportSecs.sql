
CREATE PROCEDURE [dbo].[a_ImportSecs] 
@Server nvarchar(64), @DBName nvarchar(64), 
@User nvarchar(64), @Pass nvarchar(64)
AS BEGIN
DECLARE @SQL nvarchar(2048)



SELECT @SQL='UPDATE c set c.SecName=u.SecName '+
'FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT SecID, SecName '+
'FROM '+@DBName+'.dbo.r_Secs '') u '+
'INNER JOIN r_Secs c ON c.SecID=u.SecID'

EXECUTE(@SQL)

SELECT @SQL='INSERT INTO r_Secs(SecID, SecName, InUse, SecBarCode, '+ 
'Line, Floor, AddSection, Length, Width, Height, StockID, RoutID) '+
'SELECT SecID, SecName, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0 '+
'FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT SecID, SecName '+
'FROM '+@DBName+'.dbo.r_Secs '') '+
'WHERE SecID NOT IN (SELECT SecID FROM r_Secs) '

EXECUTE(@SQL)

END

GO
