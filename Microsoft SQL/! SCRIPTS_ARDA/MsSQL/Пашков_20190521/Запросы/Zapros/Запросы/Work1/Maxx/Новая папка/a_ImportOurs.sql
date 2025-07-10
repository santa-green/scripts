
CREATE PROCEDURE [dbo].[a_ImportOurs] 
@Server nvarchar(64), @DBName nvarchar(64), 
@User nvarchar(64), @Pass nvarchar(64)
AS BEGIN
DECLARE @SQL nvarchar(2048)



SELECT @SQL='UPDATE c set c.OurName=u.OurName '+
'FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT OurID, OurName '+
'FROM '+@DBName+'.dbo.r_Ours '') u '+
'INNER JOIN r_Ours c ON c.OurID=u.OurID'

EXECUTE(@SQL)

SELECT @SQL='INSERT INTO r_Ours(OurID, OurName) '+
'SELECT * FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT OurID, OurName '+
'FROM '+@DBName+'.dbo.r_Ours '') '+
'WHERE OurID NOT IN (SELECT OurID FROM r_Ours) '

EXECUTE(@SQL)

END

GO
