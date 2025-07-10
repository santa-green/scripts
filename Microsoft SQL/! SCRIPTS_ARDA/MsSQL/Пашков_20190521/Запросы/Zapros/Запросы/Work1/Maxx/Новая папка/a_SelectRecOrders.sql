CREATE PROCEDURE a_SelectRecOrders(@Server nvarchar(64), @DBName nvarchar(64), @User nvarchar(64), @Pass nvarchar(64), @DocList nvarchar(4000)) AS
BEGIN

  SET NOCOUNT ON

  IF OBJECT_ID('tempdb..#tmp_Table') IS NOT NULL DROP TABLE #tmp_Table
  CREATE TABLE #tmp_Table (DocID int)
  DECLARE @SQL nvarchar(4000)

  SELECT @SQL='INSERT INTO #tmp_Table(DocID) SELECT DocID FROM OPENROWSET(''SQLOLEDB'', '''+@Server+'''; '''+@User+'''; '''+@Pass+''', ''SELECT DocID FROM '+@DBName+'.dbo.t_EORec WHERE '+@DocList+''')'
  EXECUTE(@SQL)

  SELECT DocID FROM #tmp_Table

END

GO
