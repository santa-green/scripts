USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EDI_METRO_Recadv_Status_Update]    Script Date: 01.12.2020 16:11:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_EDI_METRO_Recadv_Status_Update]
AS

BEGIN
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Берем в таблице [s-sql-d4].dbo.at_z_FilesExchange отправленные счета INVOICE со статусом 403, парсим из xml №заказа, 
--по этому №заказа ищем RECADV в [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files
--Обновляем статус RECADV на [Status] = 9.
--EXEC [dbo].[ap_EDI_METRO_Recadv_Status_Update]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).
--rvk0 '2019-12-05 16:01' Запуск процедуры для обновления статуса RECADV сразу после отправки INVOICE отделом учета. 

DECLARE @OrderID VARCHAR(30)
DECLARE @ChID VARCHAR(30)

--[CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).
--DECLARE RECADV CURSOR FOR
DECLARE Cursor_RECADV CURSOR LOCAL FAST_FORWARD FOR

SELECT OrderID, ChID FROM [s-sql-d4].[elit].dbo.[av_z_FilesExchange_Metro]
/* Вьюха:
SELECT ChID, FileTypeID, [FileName], DocID, DocDate, DocTime, OurID, StateCode, FileData.value('(INVOICE/ORDERNUMBER)[1]','varchar(30)') 'OrderID' FROM at_z_FilesExchange fe WITH (NOLOCK)
WHERE [fileName] LIKE '%[_]invoice%'--все счета INVOICE
    AND FileData.value('(INVOICE/HEAD/BUYER)[1]','varchar(30)') IN (SELECT GLN FROM at_gln WITH (NOLOCK) WHERE RetailersID = 17) --все файлы по сети METRO
    AND StateCode = 403 --из отправленных на ftp счетов
    AND DocDate >= '20191201'*/

OPEN Cursor_RECADV
FETCH NEXT FROM Cursor_RECADV INTO @OrderID, @ChID

WHILE @@FETCH_STATUS = 0
BEGIN
    
    UPDATE [s-sql-d4].[elit].dbo.[av_z_FilesExchange_Metro] SET StateCode = 503 WHERE ChID = @ChID  --статус 503 - отправленный (для сети METRO). 
        	
	UPDATE at_EDI_reg_files
		SET [Status] = 9 
		   ,LastUpdateData = GETDATE()
    WHERE Notes = @OrderID
      AND [Status] IN (10,11,15,16)
      AND DocType = 5000 --RECADV
      AND InsertData >= '20191201'
      AND RetailersID = 17 --сеть Metro

    SELECT * FROM at_EDI_reg_files WHERE Notes = @OrderID AND [Status] IN (9) AND DocType = 5000 AND InsertData >= '20191201' AND RetailersID = 17

    FETCH NEXT FROM Cursor_RECADV INTO @OrderID, @ChID
END;

CLOSE Cursor_RECADV
DEALLOCATE Cursor_RECADV

END;






GO
