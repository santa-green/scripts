USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_Workflow_Create_PACKAGE_METRO]    Script Date: 08.12.2020 10:40:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_Workflow_Create_PACKAGE_METRO]
AS    
BEGIN
/*
EXEC [dbo].[ap_Workflow_Create_PACKAGE_METRO]
*/
--Создает packageDescription.xml для архива documentpacket(...).zip (только для сети Metro).
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).


DECLARE @OrderID VARCHAR(128)
DECLARE @InID INT
DECLARE @OutID INT
DECLARE @Err VARCHAR(250)

--[CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).
--DECLARE Package CURSOR FOR
DECLARE Cursor_Package CURSOR LOCAL FAST_FORWARD FOR

SELECT reg.Notes /*SUBSTRING(reg.Notes, 0, charindex(' ',reg.Notes))*/ 'OrderID', m.ChID 
FROM at_EDI_reg_files reg
JOIN [s-sql-d4].[elit].dbo.t_Inv m ON m.OrderID = reg.Notes /*SUBSTRING(reg.Notes, 0, charindex(' ',reg.Notes))*/
WHERE [Status] = 30 --20 - COMDOC_METRO создан, 30 - DECLAR для METRO создан, 31 - packageDescription.xml создан; см. детально статусы в "Схма работы по ЭДО" (--https://docs.google.com/spreadsheets/d/1b-ClkSN1vQrUGF0FYoVzaxbV_eNyJ491U6wOWs1HhUg/edit?skip_itp2_check=true&pli=1#gid=1241195131&range=C2)
    AND reg.Notes != 0 /*SUBSTRING(reg.Notes, 0, charindex(' ',reg.Notes)) != 0*/
    AND DocType = 5000 --RECADV
    AND DocDate > '2019-11-24'
    AND InsertData > '2019-11-24'
    AND RetailersID = 17 --сеть Metro
    AND m.CompID IN (7001,7003) --сеть Metro

OPEN Cursor_Package
FETCH NEXT FROM Cursor_Package INTO @OrderID, @InID

WHILE @@FETCH_STATUS = 0
BEGIN
	
	EXECUTE('Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''PACKAGE_METRO'', @DocCode = 11012, @ChID = ?, @OutChID = ? OUTPUT, @ErrMsg = ? OUTPUT', @InID, @OutID OUTPUT, @Err OUTPUT) AT [s-sql-d4] 
	
	
	UPDATE at_EDI_reg_files
		SET [Status] = 31 
		   ,LastUpdateData = GETDATE()
    WHERE [Status] IN (30)
      AND DocType = 5000 --RECADV
      AND InsertData > '2019-11-24'
      AND RetailersID = 17 --сеть Metro
      AND @OrderID = Notes --SUBSTRING(Notes, 0, charindex(' ',Notes))

go_on:
	FETCH NEXT FROM Cursor_Package INTO @OrderID, @InID
END

CLOSE Cursor_Package
DEALLOCATE Cursor_Package


END






GO
