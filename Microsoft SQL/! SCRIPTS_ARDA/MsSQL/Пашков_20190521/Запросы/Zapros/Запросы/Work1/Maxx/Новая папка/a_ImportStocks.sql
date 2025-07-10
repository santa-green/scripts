
CREATE PROCEDURE [dbo].[a_ImportStocks] 
@Server nvarchar(64), @DBName nvarchar(64), 
@User nvarchar(64), @Pass nvarchar(64)
AS BEGIN
DECLARE @SQL nvarchar(2048)



SELECT @SQL='UPDATE c set c.StockName=u.StockName '+
'FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT StockID, StockName '+
'FROM '+@DBName+'.dbo.r_Stocks '') u '+
'INNER JOIN r_Stocks c ON c.StockID=u.StockID'

EXECUTE(@SQL)

SELECT @SQL='INSERT INTO r_Stocks(StockID, StockName) '+
'SELECT * FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT StockID, StockName '+
'FROM '+@DBName+'.dbo.r_Stocks '') '+
'WHERE StockID NOT IN (SELECT StockID FROM r_Stocks) '

EXECUTE(@SQL)

END

GO
