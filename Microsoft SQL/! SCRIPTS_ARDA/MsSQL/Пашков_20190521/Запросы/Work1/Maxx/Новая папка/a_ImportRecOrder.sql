CREATE PROCEDURE a_ImportRecOrder @Server nvarchar(64), @DBName nvarchar(64), @User nvarchar(64), @Pass nvarchar(64), @OrderID nvarchar(64) AS
BEGIN

  SET NOCOUNT ON

  IF OBJECT_ID('tempdb..#tmp_Table') IS NOT NULL DROP TABLE #tmp_Table
  CREATE TABLE #tmp_Table (OurID tinyint, StockID int, OrdDocID int, ExpDate smalldatetime, CompID int, SecID int, ProdID int, Um varchar(50), PQty float)
  DECLARE @OurID int, @StockID int, @ExpDate smalldatetime, @CompID int, @OrdDocID int, @SecID int, @ProdID int, @Um varchar(50), @Qty float
  DECLARE @PrevDocID int, @NewDocID int, @PosID int, @SQL nvarchar(4000)

  SELECT @SQL='INSERT INTO #tmp_Table(OurID, StockID, OrdDocID, ExpDate, CompID, SecID, ProdID, Um, PQty) '+
              'SELECT OurID, StockID, DocID AS OrdDocID, ExpDate, CompID, SecID, ProdID, Um, PQty FROM OPENROWSET(''SQLOLEDB'', '''
              +@Server+'''; '''+@User+'''; '''+@Pass+
              ''', ''SELECT OurID, StockID, DocID, DocDate AS ExpDate, CompID, SecID, ProdID, Um, Sum(Qty) AS PQty FROM '+@DBName+'.dbo.t_EORec m INNER JOIN '+@DBName+'.dbo.t_EORecD d ON d.ChID=m.ChID WHERE m.DocID='+@OrderID+' GROUP BY OurID, StockID, DocID, DocDate, CompID, SecID, ProdID, Um '')'

  EXECUTE(@SQL)


  SELECT DISTINCT @OurID=OurID, @StockID=StockID, @OrdDocID=OrdDocID, @ExpDate=ExpDate, @CompID=CompID
  FROM #tmp_Table

  SELECT @NewDocID=ISNULL(Max(DocID), 0)+1 FROM a_Rec

  INSERT INTO SmartStock.dbo.a_Rec(OurID, StockID, DocID, DocDate, OrdDocID, CompID, Notes, IsReadyForCopying)
  VALUES(@OurID, @StockID, @NewDocID, @ExpDate, @OrdDocID, @CompID, '', 0)

  SET @PosID=1
  DECLARE InsertRows CURSOR FAST_FORWARD FOR
  SELECT SecID, ProdID, Um, PQty
  FROM #tmp_Table
  OPEN InsertRows
  FETCH NEXT FROM InsertRows INTO @SecID, @ProdID, @Um, @Qty
  WHILE @@FETCH_STATUS = 0
    BEGIN

      INSERT INTO a_RecD(DocID, PosID, SecID, ProdID, Um, PQty)
      VALUES(@NewDocID, @PosID, @SecID, @ProdID, @Um, @Qty)

      SET @PosID=@PosID+1

      FETCH NEXT FROM InsertRows INTO @SecID, @ProdID, @Um, @Qty

    END
  CLOSE InsertRows
  DEALLOCATE InsertRows

  SELECT @NewDocID

END
GO
