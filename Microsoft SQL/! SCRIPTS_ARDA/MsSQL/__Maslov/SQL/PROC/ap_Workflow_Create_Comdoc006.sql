ALTER PROCEDURE [dbo].[ap_Workflow_Create_Comdoc006]    
AS    
BEGIN
/*
EXEC [dbo].[ap_Workflow_Create_Comdoc006]
*/
--Создать Comdoc006 на основании принятого статуса.

DECLARE @OrderID VARCHAR(128)
DECLARE @InID INT
DECLARE @OutID INT
DECLARE @Err VARCHAR(250)

DECLARE Comdoc CURSOR FOR
SELECT DISTINCT reg.ID, (SELECT ChID FROM [S-SQL-D4].ELIT.dbo.t_Inv WHERE OrderID = reg.ID)
FROM at_EDI_reg_files reg
WHERE Status = 3
  AND DocType = 24000
  AND Notes LIKE 'DESADV%'
  AND InsertData > '2019-10-21'
  AND RetailersID = 17154

OPEN Comdoc
FETCH NEXT FROM Comdoc INTO @OrderID, @InID

WHILE @@FETCH_STATUS = 0
BEGIN
	
	--Если пришел еще один статус по этому заказу с меткой DESADV.
	--Грубо говоря, убираем появление дублей.
	IF EXISTS(
				SELECT 1 FROM at_EDI_reg_files
							WHERE ID = @OrderID
							  AND DocType = 24000
							  AND Notes LIKE 'DESADV%'
							  AND InsertData > '2019-10-21'
							  AND RetailersID = 17154
							  AND Status = 10
             )
	BEGIN
		UPDATE at_EDI_reg_files
			SET Status = 11
			   ,LastUpdateData = GETDATE()
		WHERE ID = @OrderID
		  AND DocType = 24000
		  AND Notes LIKE 'DESADV%'
		  AND InsertData > '2019-10-21'
		  AND RetailersID = 17154
		  AND Status = 3

		GOTO go_on
	END;

	EXECUTE('Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''COMDOC'', @DocCode = 11012, @ChID = ?, @OutChID = ? OUTPUT, @ErrMsg = ? OUTPUT', @InID, @OutID OUTPUT, @Err OUTPUT) AT [s-sql-d4] 
	
	UPDATE at_EDI_reg_files
		SET Status = 10
		   ,LastUpdateData = GETDATE()
		   ,Notes += ' ' + CASE WHEN @Err IS NOT NULL OR LEN(@Err) > 0
							     THEN @Err
							     ELSE CAST(@OutID AS VARCHAR) END
	WHERE ID = @OrderID
	  AND DocType = 24000
	  AND Notes LIKE 'DESADV%'
	  AND InsertData > '2019-10-21'
	  AND RetailersID = 17154
	  AND Status = 3
go_on:
	FETCH NEXT FROM Comdoc INTO @OrderID, @InID
END

CLOSE Comdoc
DEALLOCATE Comdoc


END