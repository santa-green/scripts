CREATE PROCEDURE dbo.a_SelectPicOrders(@Server nvarchar(64), @DBName nvarchar(64), @User nvarchar(64), @Pass nvarchar(64), @DocList nvarchar(4000)) AS
BEGIN

  SET NOCOUNT ON

  DECLARE @OurID tinyint, @StockID int, @OrdDocID int, @PickDocID int, @PickDate smalldatetime, @CompID int, @PosID int, @SecID int, @ProdID int, @Um nvarchar(50), @Qty float
  DECLARE @SQL nvarchar(4000), @NewDocID int
  DECLARE @TaskQty tinyint, @TaskRowCount tinyint

  IF OBJECT_ID('tempdb..#tmp_Table') IS NOT NULL DROP TABLE #tmp_Table
  CREATE TABLE #tmp_Table (OurID tinyint, StockID int, OrdDocID int, PickDocID int, PickDate smalldatetime, CompID int, PosID int, SecID int, ProdID int, Um nvarchar(50), Qty float)

  SELECT @SQL='INSERT INTO #tmp_Table (OrdDocID) SELECT DocID AS OrdDocID FROM OPENROWSET(''SQLOLEDB'', '''+@Server+'''; '''+@User+'''; '''+@Pass+''',''SELECT DocID FROM '+@DBName+'.dbo.t_Acc WHERE '+@DocList+''')'
  EXEC(@SQL)

  SELECT OrdDocID FROM #tmp_Table

END

GO
