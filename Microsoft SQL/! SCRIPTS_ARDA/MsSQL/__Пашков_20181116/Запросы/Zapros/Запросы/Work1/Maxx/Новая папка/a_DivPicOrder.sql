CREATE PROCEDURE dbo.a_DivPicOrder(@DocID int, @TaskQty tinyint) AS
BEGIN

  SET NOCOUNT ON

  DECLARE @TaskDesc nvarchar(255)
  DECLARE @PosID int, @SecID int, @PQty float, @ProdID int, @ClassName nvarchar(255),
                @NewQID int, @WNewQID int, @WFlag bit, @RFlag bit, @TaskRowCount tinyint, @RowCount int
  
  SELECT @TaskDesc='Сборка заказа №'+CAST(OrdDocID AS nvarchar(255)) FROM a_Order WHERE DocID=@DocID

  UPDATE a_OrderD SET QID=0 WHERE DocID=@DocID

  SET @WFlag=0 
  SET @RFlag=0
  SET @RowCount=(SELECT ISNULL(Count(PosID),0) FROM a_OrderD d WHERE DocID=@DocID)
  IF  ABS(Round(@RowCount/@TaskQty,1)-Round(@RowCount/@TaskQty,0))>0 SET @TaskRowCount=Round(@RowCount/@TaskQty,0)+1 
  ELSE SET @TaskRowCount=Round(@RowCount/@TaskQty,0)
  SET @RowCount=@TaskRowCount

  DECLARE ADivOrders CURSOR FAST_FORWARD FOR
    SELECT d.DocID, d.PosID, d.SecID, d.PQty, d.ProdID, p.ClassName
    FROM a_OrderD d INNER JOIN r_Prods p ON p.ProdID=d.ProdID
    WHERE d.DocID=@DocID 
    ORDER BY d.SecID, d.ProdID, p.ClassName
     OPEN ADivOrders
     FETCH NEXT FROM ADivOrders INTO @DocID, @PosID, @SecID, @PQty, @ProdID, @ClassName

   WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @SecID in (SELECT SecID FROM r_Secs s WHERE InUse=1 AND StockID=1 AND  Right(SecID,1)<>1 )

          BEGIN
           IF @WFlag=0 
             BEGIN
                 SET @WNewQID=(SELECT ISNULL(Max(QID),0)+1 FROM a_Queue)
                 INSERT INTO a_Queue(QID, Priority, TaskType, IsAutoEmpSel, EmpID, Status, StartTime, FinishTime, Notes)
                  VALUES(@WNewQID, 0, 2, 0, 0, 0, NULL, NULL, @TaskDesc)
              END
            UPDATE a_OrderD SET QID=@WNewQID WHERE DocID=@DocID AND PosID=@PosID 
            SET @WFlag=1
           END

       ELSE
  
      BEGIN
        IF (@RFlag=0)
         BEGIN
             SET @NewQID=(SELECT ISNULL(Max(QID),0)+1 FROM a_Queue)
             INSERT INTO a_Queue(QID, Priority, TaskType, IsAutoEmpSel, EmpID, Status, StartTime, FinishTime, Notes)
             VALUES(@NewQID, 0, 2, 0, 0, 0, NULL, NULL, @TaskDesc)
         END
        UPDATE a_OrderD SET QID=@NewQID WHERE DocID=@DocID AND PosID=@PosID 
        SET @RowCount=@RowCount-1
        IF @RowCount<>0 SET @RFlag=1
        ELSE 
         BEGIN
           SET @RFlag=0
           SET @RowCount=@TaskRowCount
         END
      END

     FETCH NEXT FROM ADivOrders INTO @DocID, @PosID, @SecID, @PQty, @ProdID, @ClassName
    END
  CLOSE ADivOrders
  DEALLOCATE ADivOrders

END
GO
