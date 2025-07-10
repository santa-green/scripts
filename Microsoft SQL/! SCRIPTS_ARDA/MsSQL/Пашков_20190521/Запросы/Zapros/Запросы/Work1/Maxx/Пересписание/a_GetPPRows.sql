CREATE FUNCTION dbo.a_GetPPRows(@OurID smallint, @StockID smallint, @ProdID int, @TQty float)
RETURNS @Result Table (RowID int, PPID int, Qty float)
AS
BEGIN 

  DECLARE @RowID int, @PPID int, @PPQty float
  SET @RowID=0
  DECLARE PPs CURSOR FAST_FORWARD FOR
    SELECT b.PPID, b.Qty
    FROM s_Rem b INNER JOIN s_PInP pp ON pp.ProdID=b.ProdID AND pp.PPID=b.PPID
    WHERE b.OurID=@OurID AND b.StockID=@StockID AND b.ProdID=@ProdID AND b.Qty>0
    ORDER BY pp.PPID
  OPEN PPs
  FETCH NEXT FROM PPs INTO @PPID, @PPQty
  WHILE @@FETCH_STATUS = 0
   BEGIN

     IF ((@TQty>0) AND (@TQty<=@PPQty))
       BEGIN
         INSERT INTO @Result(RowID, PPID, Qty)
         VALUES(@RowID, @PPID, @TQty)
         SET @TQty=0
         BREAK
       END
     ELSE
       BEGIN
         INSERT INTO @Result(RowID, PPID, Qty)
         VALUES(@RowID, @PPID, @PPQty)
         SET @TQty=@TQty-@PPQty
         SET @RowID=@RowID+1
       END
    FETCH NEXT FROM PPs INTO @PPID, @PPQty
  END
  CLOSE PPs
  DEALLOCATE PPs

  IF @TQty<>0
    INSERT INTO @Result(RowID, PPID, Qty)
    VALUES(@RowID, @PPID, @TQty)

RETURN
END