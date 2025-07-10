
CREATE PROCEDURE [dbo].[a_ImportProds] 
@Server nvarchar(64), @DBName nvarchar(64), 
@User nvarchar(64), @Pass nvarchar(64), @ProdList nvarchar(1024)
AS BEGIN
DECLARE @SQL nvarchar(2048), @Filter nvarchar(1024)
SELECT @Filter=(CASE WHEN @ProdList IN ('()','') THEN ''
	ELSE ' WHERE '+@Prodlist END)



SELECT @SQL='UPDATE p set p.ProdName=u.ProdName, '+
'p.Article=u.Article, p.UM=u.UM, p.ClassName=u.ClassName '+
'FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT ProdID, ProdName, Article1 AS Article, UM, PGrName AS ClassName '+
'FROM '+@DBName+'.dbo.r_Prods p INNER JOIN '+@DBName+'.dbo.r_ProdG g '+
'ON p.PGrID=g.PGrID'+@Filter+''') u '+
'INNER JOIN r_Prods p ON p.ProdID=u.ProdID'

EXECUTE(@SQL)

SELECT @SQL='INSERT INTO r_Prods(ProdID, ProdName, Article, UM, ClassName) '+
'SELECT * FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT ProdID, ProdName, Article1 AS Article, UM, PGrName AS ClassName '+
'FROM '+@DBName+'.dbo.r_Prods p INNER JOIN '+@DBName+'.dbo.r_ProdG g '+
'ON p.PGrID=g.PGrID'+@Filter+''') '+
'WHERE ProdID NOT IN (SELECT ProdID FROM r_Prods) '

EXECUTE(@SQL)

SELECT @SQL='UPDATE mq set mq.BarCode=u.BarCode '+
'FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT ProdID, UM, BarCode '+
'FROM '+@DBName+'.dbo.r_ProdMQ'+@Filter+''') u '+
'INNER JOIN r_ProdMQ mq ON mq.ProdID=u.ProdID and mq.UM=u.UM '+
'WHERE mq.ProdID IN (SELECT ProdID FROM r_Prods) '+
'and u.BarCode NOT LIKE ''%[^0-9]%'''

EXECUTE(@SQL)

SELECT @SQL='INSERT INTO r_ProdMQ(ProdID, UM, BarCode) '+
'SELECT * FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT ProdID, UM, BarCode '+
'FROM '+@DBName+'.dbo.r_ProdMQ'+@Filter+''') u '+
'WHERE u.UM NOT IN (SELECT UM FROM r_ProdMQ mq WHERE mq.ProdID=u.ProdID) '+
'and u.ProdID IN (SELECT ProdID FROM r_Prods) '+
'and u.BarCode NOT LIKE ''%[^0-9]%'''

EXECUTE(@SQL)

END
GO
