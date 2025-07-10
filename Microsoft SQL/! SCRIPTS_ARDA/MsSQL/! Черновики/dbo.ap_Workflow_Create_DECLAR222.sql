USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_Workflow_Create_DECLAR]    Script Date: 01.04.2021 11:05:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_Workflow_Create_DECLAR]    
AS    
BEGIN

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--Формирует налоговую накладную DECLAR через процедуру Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''DECLAR'... (курсор собираем исходя из того, на основании чего формируется налоговая по каждой сети).
--Обновляет статусы в реестре at_EDI_reg_files
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ADDED] 2018-10-31 15.51 pvm0 Добавил для ограничивания только по фирме 1
--[ADDED] pvm0 '2018-10-31 18.13' добавил розетку 982.
--[ADDED] moa0 '2019-10-21 17:20:36.622' Добавил переменную @Mode для работы в старом режиме и в новом (создание DECLAR для Розетки). 
--[ADDED] moa0 '2019-10-21 17:23:15.048' Для отправки DECLAR по Розетке на основании подписаного Розеткой COMDOC 006.
--[ADDED] rkv0 '2019-11-13 11:23' Для отправки DELCAR по Metro на основании расходной в Бизнесе (т.к. отправляем пакетом все вместе comdoc+declar+package).
--[CHANGED] rkv0 '2020-05-15 15:35' изменил поле с varchar(40) на varchar(255), т.к. после перехода на новую платформу edin 2.0, названия статусных файлов стали длиннее (лепят GUID в название).
--[CHANGED] rkv0 '2020-06-26 09:54' для подстраховки (если провайдер отправит старые  статусы) фильтруем по свежей дате.
--[CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).
--[CHANGED] '2020-10-05 17:25' rkv0 убираю лишние сети из списка: 501 Фуршет - неактуально (почти нет COMDOC); 503 - Metro - отдельный сценарий; 982 - Розетка - отдельный сценарий; '2020-02-25 11:13' 506 ЕКО-МАРКЕТ (сейчас от них поступают только заказы); '2019-11-04 16:41' 505 ООО "Група Рітейлу України" (не работаем уже);

	
--[CHANGED] rkv0 '2020-05-15 15:35' изменил поле с varchar(40) на varchar(255), т.к. после перехода на новую платформу edin 2.0, названия статусных файлов стали длиннее (лепят GUID в название).
--	DECLARE @FN varchar(40)
	DECLARE @FN varchar(255)
	DECLARE @InID INT
	DECLARE @OutID INT
	DECLARE @Err VARCHAR(250)
	DECLARE @Mode INT

    --[CHANGED] '2020-07-09 15:40' rkv0 изменил тип курсора (для небольшого количества записей используем LOCAL FAST_FORWARD, для большого - LOCAL FORWARD_ONLY STATIC).
	--DECLARE cur CURSOR FOR
	DECLARE Cursor_DECLAR CURSOR LOCAL FAST_FORWARD FOR
	
    SELECT AES_FileName,
	(select chid from [s-sql-d4].Elit.dbo.t_Inv where 
	TaxDocID in  (select AEI_INV_ID from [s-sql-d4].Elit.dbo.avz_EDI_Invoices where AEI_DOC_ID = AES_DocNumber) and
	TaxDocDate in  (select AEI_INV_DATE from [s-sql-d4].Elit.dbo.avz_EDI_Invoices where AEI_DOC_ID = AES_DocNumber)
	--[ADDED] 2018-10-31 15.51 pvm0 Добавил для ограничивания только по фирме 1
    AND OurID = 1)
	--[ADDED] moa0 '2019-10-21 17:20:36.622' Добавил переменную @Mode для работы в старом режиме и в новом (создание DECLAR для Розетки). 
	,1
	FROM dbo.ALEF_EDI_STATUS
	WHERE 1 = 1
    and AES_MessageClass = 'COMDOC'
	and (AES_Description like 'Накладна%' or AES_Description like '%обновлен успешно%')
	and AES_OurStatus = 0
    --[CHANGED] rkv0 '2020-06-26 09:54' для подстраховки (если провайдер отправит старые  статусы) фильтруем по свежей дате.
	--and AES_Date >='2018-05-05'
	and AES_Date >='2020-06-26'
	--[ADDED] pvm0 '2018-10-31 18.13' добавил розетку 982.
    --[CHANGED] '2020-10-05 17:25' rkv0 убираю лишние сети из списка: 501 Фуршет - неактуально (почти нет COMDOC); 503 - Metro - отдельный сценарий; 982 - Розетка - отдельный сценарий; '2020-02-25 11:13' 506 ЕКО-МАРКЕТ (сейчас от них поступают только заказы); '2019-11-04 16:41' 505 ООО "Група Рітейлу України" (не работаем уже);
	--and exists (select * from dbo.ALEF_EDI_GLN_SETI where EGS_GLN_ID = AES_FromGLN and EGS_GLN_SETI_ID in (501,502,503,610,621,982)) 
	and exists (select * from dbo.ALEF_EDI_GLN_SETI where EGS_GLN_ID = AES_FromGLN and EGS_GLN_SETI_ID in (502,610,621)) --610 - Таврия, 502 - Фудком (Велика Кишеня), 621 - Новус. 
	
--[ADDED] moa0 '2019-10-21 17:23:15.048' Для отправки DECLAR по Розетке на основании подписаного Розеткой COMDOC 006.
	UNION ALL
--[CHANGED] rkv0 '2020-05-15 15:35' изменил поле с varchar(40) на varchar(255), т.к. после перехода на новую платформу edin 2.0, названия статусных файлов стали длиннее (лепят GUID в название).
--SELECT CAST(reg.ChID AS VARCHAR(40))
	SELECT CAST(reg.ChID AS VARCHAR(255))
		  ,(SELECT ChID FROM [s-sql-d4].Elit.dbo.t_Inv WHERE OrderID = reg.ID AND TaxDocID != 0)
		  ,2
	FROM at_EDI_reg_files reg
	WHERE [Status] IN (10,11)		-- 10 - Готов к созданию DECLAR; 11 - принудительно создать DECLAR.
	  AND RetailersID = 17154	--Номер сети Розетка.
	  AND DocType = 7006		--Тип документа COMDOC 006

--[ADDED] rkv0 '2019-11-13 11:23' Для отправки DELCAR по Metro на основании расходной в Бизнесе (т.к. отправляем пакетом все вместе comdoc+declar+package).
    UNION ALL
--[CHANGED] rkv0 '2020-05-15 15:35' изменил поле с varchar(40) на varchar(255), т.к. после перехода на новую платформу edin 2.0, названия статусных файлов стали длиннее (лепят GUID в название).
--    SELECT CAST(reg.ChID AS VARCHAR(40))
    SELECT CAST(reg.ChID AS VARCHAR(255))
	    ,(SELECT MAX(ChID) FROM [s-sql-d4].Elit.dbo.t_Inv WHERE OrderID = reg.Notes) --= SUBSTRING(reg.Notes, 0, charindex(' ',reg.Notes)) AND TaxDocID != 0 AND SUBSTRING(reg.Notes, 0, charindex(' ',reg.Notes)) != 0)
	    ,2
    FROM at_EDI_reg_files reg
    WHERE [Status] IN (20,21)		-- 20 - Готов к созданию DECLAR; 21 - принудительно создать DECLAR.
    AND RetailersID = 17	--Номер сети Metro.
    AND DocType = 5000		--Тип документа RECADV
 
	OPEN Cursor_DECLAR
	FETCH NEXT FROM Cursor_DECLAR INTO @FN, @InID, @Mode

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
        IF @Mode = 1
		BEGIN
			EXECUTE('Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''DECLAR'', @DocCode = 11012, @ChID = ?, @OutChID = ? OUTPUT, @ErrMsg = ? OUTPUT',@InID,@OutID OUTPUT,@Err OUTPUT) AT [s-sql-d4] 
			
			UPDATE dbo.ALEF_EDI_STATUS
			set
			AES_OurStatus = 1,
			AES_CHID = @OutID
			WHERE AES_FileName = @FN
			and @OutID > 0;
		END;
		
		ELSE IF @Mode = 2 --Для Розетки и Metro.
		BEGIN
				EXECUTE('Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''DECLAR'', @DocCode = 11012, @ChID = ?, @OutChID = ? OUTPUT, @ErrMsg = ? OUTPUT',@InID,@OutID OUTPUT,@Err OUTPUT) AT [s-sql-d4] 

				UPDATE at_EDI_reg_files
				SET [Status] = 30
				   --,Notes += ' ' + CAST(@OutID AS VARCHAR)
				   ,LastUpdateData = GETDATE()
				WHERE ChID = CAST(@FN AS INT)
		END;

		
		FETCH NEXT FROM Cursor_DECLAR INTO @FN, @InID, @Mode
	END;

	CLOSE Cursor_DECLAR
	DEALLOCATE Cursor_DECLAR


END















GO
