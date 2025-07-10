CREATE  PROCEDURE [dbo].[a_SetTermSync] 
@Server nvarchar(64), @DBName nvarchar(64), 
@User nvarchar(64), @Pass nvarchar(64), @StockList varchar(256)
AS
BEGIN

DECLARE @SQL nvarchar(2048), @Filter nvarchar(1024)
SELECT @FILTER=CASE WHEN @StockList in ('','()') THEN ''
	ELSE ' AND '+@StockList END

SELECT @SQL='UPDATE r_Prods SET ForTermSync=1 '+
'WHERE ProdID IN'+
'(SELECT * FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT DISTINCT ProdID FROM '+@DBName+'.dbo.t_Rem '+
'WHERE Qty>0 '+@Filter+'''))'
EXECUTE(@SQL)

END
GO
