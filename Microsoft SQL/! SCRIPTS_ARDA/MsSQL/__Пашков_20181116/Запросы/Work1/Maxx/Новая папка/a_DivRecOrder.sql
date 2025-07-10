CREATE PROCEDURE dbo.a_DivRecOrder(@DocID int, @TaskQty tinyint) AS
BEGIN

  SET NOCOUNT ON

  DECLARE @NewQID int, @NewPosID int, @i int, @TaskDesc nvarchar(255)

  DELETE FROM a_RecR WHERE DocID=@DocID

  SELECT @TaskDesc='Прием товара по заказу №'+CAST(OrdDocID AS nvarchar(255)) FROM a_Rec WHERE DocID=@DocID

  SET @i=0
  WHILE @i<@TaskQty
    BEGIN

      SET @NewQID=(SELECT ISNULL(Max(QID),0)+1 FROM a_Queue)
      INSERT INTO a_Queue(QID, Priority, TaskType, IsAutoEmpSel, EmpID, Status, StartTime, FinishTime, Notes)
      VALUES(@NewQID, 0, 1, 0, 0, 0, NULL, NULL, @TaskDesc)

      SET @NewPosID=(SELECT ISNULL(Max(PosID),0)+1 FROM a_RecR WHERE DocID=@DocID)
      INSERT INTO a_RecR(DocID, PosID, QID, SecID, PallID, ProdID, Um, FQty, WQty, BQty, PickDateTime)
      VALUES(@DocID, @NewPosID, @NewQID, 1, 0, 0, NULL, 0, 0, 0, 0)

      SET @i=@i+1

    END

END
GO
