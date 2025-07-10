CREATE PROCEDURE dbo.a_ImportPicOrder(@Server nvarchar(64), @DBName nvarchar(64), @User nvarchar(64), @Pass nvarchar(64), @OrderID nvarchar(64)) AS
BEGIN

  SET NOCOUNT ON

  DECLARE @OurID tinyint, @StockID int, @OrdDocID int, @PickDocID int, @PickDate smalldatetime, @CompID int, @PosID int, @SecID int, @ProdID int, @Um nvarchar(50), @Qty float
  DECLARE @SQL nvarchar(4000), @NewDocID int
  DECLARE @TaskQty tinyint, @TaskRowCount tinyint

  IF OBJECT_ID('tempdb..#tmp_Table') IS NOT NULL DROP TABLE #tmp_Table
  CREATE TABLE #tmp_Table (OurID tinyint, StockID int, OrdDocID int, PickDocID int, PickDate smalldatetime, CompID int, PosID int, SecID int, ProdID int, Um nvarchar(50), Qty float)

  SELECT @SQL='INSERT INTO #tmp_Table (OurID, StockID, OrdDocID, PickDocID, PickDate, CompID, PosID, SecID, ProdID, Um, Qty) SELECT OurID, StockID, DocID AS OrdDocID, DocID AS PickDocID, DocDate AS PickDate, CompID, SrcPosID AS PosID, SecID, ProdID, Um, Qty FROM OPENROWSET(''SQLOLEDB'', '''+@Server+'''; '''+@User+'''; '''+@Pass+''',''SELECT OurID, StockID, DocID, DocID, DocDate, CompID, SrcPosID, SecID, ProdID, Um, Qty FROM '+@DBName+'.dbo.t_Acc m INNER JOIN '+@DBName+'.dbo.t_AccD d ON d.ChID=m.ChID WHERE m.DocID='+@OrderID+''')'
  EXEC(@SQL)

    SELECT @OurID=OurID, @StockID=StockID, @OrdDocID=OrdDocID, @PickDocID=PickDocID, @PickDate=PickDate, @CompID=CompID
    FROM #tmp_Table

	SELECT @NewDocID=ISNULL(Max(DocID), 0)+1 FROM a_Order
	INSERT INTO dbo.a_Order(OurID, DocID, OrdDocID, PickDocID, PickDate, StockID, CompID, Notes, IsReadyForCopying)
	VALUES (@OurID, @NewDocID, @OrdDocID, @PickDocID, @PickDate, @StockID, @CompID, NULL, 0)

	DECLARE InsertRows CURSOR FAST_FORWARD FOR
	SELECT PosID, SecID, ProdID, Um, Qty
	FROM #tmp_Table
	WHERE OrdDocID=@OrdDocID
	ORDER BY PosID
	OPEN InsertRows
	FETCH NEXT FROM InsertRows INTO @PosID, @SecID, @ProdID, @Um, @Qty
	WHILE @@FETCH_STATUS = 0
		BEGIN

		      INSERT INTO a_OrderD(DocID, PosID, PallID, QID, SecID, DestSecID, ProdID, Um, PQty, FQty, IsProceed)
		      VALUES(@NewDocID, @PosID, 0, 0, @SecID, 1, @ProdID, @Um, @Qty, 0, 0)

		      FETCH NEXT FROM InsertRows INTO @PosID, @SecID, @ProdID, @Um, @Qty

		    END
	CLOSE InsertRows
	DEALLOCATE InsertRows

  SELECT @NewDocID

END
GO
