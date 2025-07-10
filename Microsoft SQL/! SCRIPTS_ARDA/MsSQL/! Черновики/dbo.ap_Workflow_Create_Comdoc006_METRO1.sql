USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_Workflow_Create_Comdoc006_METRO]    Script Date: 03.12.2020 14:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_Workflow_Create_Comdoc006_METRO]
AS    
BEGIN
/*
EXEC [dbo].[ap_Workflow_Create_Comdoc006_Metro]
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Создает Comdoc006 на основании RECADV (только для сети Metro).

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).

DECLARE @OrderID VARCHAR(128)
DECLARE @InID INT
DECLARE @OutID INT
DECLARE @Err VARCHAR(250)

--[CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).
--DECLARE Comdoc CURSOR FOR
DECLARE Comdoc CURSOR LOCAL FAST_FORWARD FOR

SELECT DISTINCT reg.Notes, m.ChID
FROM at_EDI_reg_files reg
JOIN [S-SQL-D4].ELIT.dbo.t_Inv m ON m.OrderID = reg.Notes
    --rkv0 '2019-12-05 17:13' меняю статусы (10,11,16) на (9): значит, что уже отправлен INVOICE отделом учета. 
    WHERE [Status] IN (8,9) --10 - количество сошлось, 11 - количество не сошлось, 15 - DELIVERYNOTENUMBER not found, 16 - ожидание корректировки расходной накладной, 30 - COMDOC_METRO сформирован, добавлен в таблицу at_z_FilesExchange (со статусом 502).
      AND DocType = 5000 --RECADV
      -- '2019-12-03 18:09' rvk0 даем 3 дня на возможные корректировки расходных учетом (нужно переделать на invoice). AND InsertData <= CONVERT(date, getdate() - 3)
      -- '2019-12-05 17:16'rvk0 убираю выдержку в 3 дня, т.к. изменился алгоритм отправки (Танцюра): формируем и отправляем товарную и налоговую после того, как отдел учета отправил INVOICE.
      AND InsertData > '2019-11-25' 
      AND DocDate > '2019-11-01'
      AND RetailersID = 17 --сеть Metro.
      AND m.CompID IN (7001,7003) --предприятия сети Metro.

OPEN Comdoc
FETCH NEXT FROM Comdoc INTO @OrderID, @InID

WHILE @@FETCH_STATUS = 0
BEGIN
	
    --IF EXISTS...документы со Status = 8
	--EXECUTE('Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''COMDOC_METRO'', @DocCode = 11012, @ChID = ?, @OutChID = ? OUTPUT, @ErrMsg = ? OUTPUT, @ResendMetro = 1', @InID, @OutID OUTPUT, @Err OUTPUT) AT [s-sql-d4] 
	EXECUTE('Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''COMDOC_METRO'', @DocCode = 11012, @ChID = ?, @OutChID = ? OUTPUT, @ErrMsg = ? OUTPUT', @InID, @OutID OUTPUT, @Err OUTPUT) AT [s-sql-d4] 
	--SELECT * FROM at_EDI_reg_files WHERE [FileName] like '%recadv%' and RetailersID = 17
	UPDATE at_EDI_reg_files
		SET [Status] = 20 
		   ,LastUpdateData = GETDATE()
/*		   ,Notes += ' ' + CASE WHEN @Err IS NOT NULL OR LEN(@Err) > 0
							     THEN @Err
							     ELSE CAST(@OutID AS VARCHAR) END*/
    WHERE Notes = @OrderID
    --rkv0 '2019-12-05 17:13' меняю статусы (10,11,16) на (9): значит, что уже отправлен INVOICE отделом учета. 
      AND [Status] IN (8,9)
      AND DocType = 5000 --RECADV
      AND InsertData > '2019-11-25'
      AND RetailersID = 17 --сеть Metro

go_on:
	FETCH NEXT FROM Comdoc INTO @OrderID, @InID
END

CLOSE Comdoc
DEALLOCATE Comdoc


END

/* --старый вариант, который был сделан под АТБ (видимо, для теста)
--[S-SQL-D4].[ELIT].[dbo].ap_EXITE_CreateMessage @MsgType = 'COMDOC', @DocCode = 11012, @ChID INT, @OutChID = @OutID, @ErrMsg = @Err
--@MsgType – название документа (например, DECLAR, COMDOC)
--@DocCode – код типа документа бизнеса (для РН - 11012)
--@ChID – код регистрации документа
--@OutChID – код регистрации сообщения в at_z_FilesExchange, если значение = 0, читать сообщение об ошибке @ErrMsg
--Выбрали уведомления о приеме со статусом 2
--Для каждого сформировали xml
--xml сохранили в файл
--статус 402 апдейт на 403
--статус 2 апдейт на 4

DECLARE @Inv INT
DECLARE @Date DATE
DECLARE @InID INT
DECLARE @OutID INT
DECLARE @Err VARCHAR(250)
DECLARE cur CURSOR FOR
SELECT REC_INV_ID, REC_INV_DATE, (SELECT ChID FROM [S-SQL-D4].ELIT.dbo.t_Inv WHERE OrderID = REC_ORD_ID and CodeID2 = 18 and TaxDocId = REC_INV_ID)
FROM dbo.ALEF_EDI_RECADV 
WHERE REC_SENDER = '4829900017590' and REC_STATUS = 2

OPEN cur
FETCH NEXT FROM cur INTO @Inv, @Date, @InID

WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE('Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''COMDOC'', @DocCode = 11012, @ChID = ?, @OutChID = ? OUTPUT, @ErrMsg = ? OUTPUT',@InID,@OutID OUTPUT,@Err OUTPUT) AT [s-sql-d4] 

	UPDATE dbo.ALEF_EDI_RECADV 
	set
	REC_STATUS = 4,
	REC_FILES_CHID = @OutID
	WHERE @Inv = REC_INV_ID
	and @Date = REC_INV_DATE
	and @OutID > 0;
	
	FETCH NEXT FROM cur INTO @Inv, @Date, @InID
END

CLOSE cur
DEALLOCATE cur
*/










GO
