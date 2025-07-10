alter PROCEDURE [dbo].[ap_Workflow_Create_CONTRL]    
AS    
BEGIN

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--Формирует "Отчет об отгрузке" (CONTRL) через процедуру Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''CONTRL'... (для сети СИЛЬПО).
--Обновляет статусы в реестре at_EDI_reg_files
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--...

DECLARE @OutID INT
DECLARE @Err VARCHAR(250)
DECLARE @t_inv_ChID INT
DECLARE @recadv_ChID INT
DECLARE @OrderID varchar(250)

DECLARE Cursor_RECADV CURSOR LOCAL FAST_FORWARD FOR 

        SELECT Chid, Notes
        FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
        WHERE 1 = 1 
        AND DocType = 5000
        AND [status] in (10, 11, 15) --при импорте RECADV им назначаются статусы здесь: Import_Recadv_reg_use.ps1
        AND RetailersID = 14 -- сеть Сильпо (Фоззи).

	OPEN Cursor_RECADV
		FETCH NEXT FROM Cursor_RECADV INTO @recadv_ChID, @Orderid
	WHILE @@FETCH_STATUS = 0		 
	BEGIN
        SELECT @t_inv_ChID = (SELECT Chid FROM [S-SQL-D4].[ELIT].dbo.t_inv WITH(NOLOCK) WHERE Orderid = @Orderid AND TaxDocID != 0)
		EXECUTE('Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''CONTRL'', @DocCode = 11012, @ChID = ?, @OutChID = ? OUTPUT, @ErrMsg = ? OUTPUT', @t_inv_ChID, @OutID OUTPUT, @Err OUTPUT) AT [s-sql-d4]
		UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET [Status] = 16 WHERE ChID = @recadv_ChID --16 - отправлен email, 17 - отправлен contrl.
        
		FETCH NEXT FROM Cursor_RECADV INTO @recadv_ChID, @Orderid
	END;
	CLOSE Cursor_RECADV
	DEALLOCATE Cursor_RECADV

END;

GO






