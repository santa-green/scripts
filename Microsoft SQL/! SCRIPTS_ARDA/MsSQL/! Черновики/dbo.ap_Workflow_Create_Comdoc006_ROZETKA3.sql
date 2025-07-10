USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_Workflow_Create_Comdoc006_ROZETKA]    Script Date: 30.11.2020 18:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_Workflow_Create_Comdoc006_ROZETKA]
AS    
BEGIN
/*
EXEC [dbo].[ap_Workflow_Create_Comdoc006_ROZETKA]
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Создает Comdoc006 на основании принятого статуса (только для Розетки).

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).
-- [CHANGED] '2020-10-30 11:22' rkv0 изменил COMDOC на COMDOC_ROZETKA, т.к. это было изменено в ap_EXITE_ExportDoc (для инструмента F11-Exite).


DECLARE @OrderID VARCHAR(128)
DECLARE @InID INT
DECLARE @OutID INT
DECLARE @Err VARCHAR(250)

--[CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).
--DECLARE Comdoc CURSOR FOR
DECLARE Cursor_COMDOC_ROZETKA CURSOR LOCAL FAST_FORWARD FOR

SELECT 
      DISTINCT reg.ID
    , (SELECT ChID FROM [S-SQL-D4].ELIT.dbo.t_Inv WHERE TaxDocID != 0 AND OrderID = reg.ID)
FROM at_EDI_reg_files reg
WHERE [Status] = 3
  AND DocType = 24000
  AND Notes LIKE 'DESADV%'
  AND InsertData > '2019-10-21'
  AND RetailersID = 17154 --17154 - сеть Розетка

OPEN Cursor_COMDOC_ROZETKA
FETCH NEXT FROM Cursor_COMDOC_ROZETKA INTO @OrderID, @InID

WHILE @@FETCH_STATUS = 0
BEGIN
	
	--Если пришел еще один статус по этому заказу с меткой DESADV.
	--Грубо говоря, убираем появление дублей.
	IF EXISTS(
				SELECT 1 FROM at_EDI_reg_files
							WHERE 1 = 1
                              AND ID = @OrderID
							  AND DocType = 24000
							  AND Notes LIKE 'DESADV%'
							  AND InsertData > '2019-10-21'
							  AND RetailersID = 17154
							  AND [Status] = 10
             )
	BEGIN
		UPDATE at_EDI_reg_files
			SET [Status] = 11
			   ,LastUpdateData = GETDATE()
		WHERE 1 = 1 
          AND ID = @OrderID
		  AND DocType = 24000
		  AND Notes LIKE 'DESADV%'
		  AND InsertData > '2019-10-21'
		  AND RetailersID = 17154
		  AND [Status] = 3

		GOTO go_on
	END;
    -- [CHANGED] '2020-10-30 11:22' rkv0 изменил COMDOC на COMDOC_ROZETKA, т.к. это было изменено в ap_EXITE_ExportDoc (для инструмента F11-Exite).
	EXECUTE('Elit.dbo.ap_EXITE_CreateMessage 
          @MsgType = ''COMDOC_ROZETKA''
        , @DocCode = 11012
        , @ChID = ?
        , @OutChID = ? OUTPUT
        , @ErrMsg = ? OUTPUT'
        , @InID
        , @OutID OUTPUT
        , @Err OUTPUT)
    AT [s-sql-d4] 
	
	UPDATE at_EDI_reg_files
		SET [Status] = 10
		   ,LastUpdateData = GETDATE()
		   ,Notes += ' ' + CASE WHEN @Err IS NOT NULL OR LEN(@Err) > 0
							     THEN @Err
							     ELSE CAST(@OutID AS VARCHAR) END
	WHERE ID = @OrderID
	  AND DocType = 24000
	  AND Notes LIKE 'DESADV%'
	  AND InsertData > '2019-10-21'
	  AND RetailersID = 17154
	  AND [Status] = 3
go_on:
	FETCH NEXT FROM Cursor_COMDOC_ROZETKA INTO @OrderID, @InID
END;

CLOSE Cursor_COMDOC_ROZETKA
DEALLOCATE Cursor_COMDOC_ROZETKA


END;







GO
