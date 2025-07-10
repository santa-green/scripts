USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_SendEmailEDI]    Script Date: 25.08.2021 11:01:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_SendEmailEDI] @DocType INT = -1, @delay INT = 0, @text VARCHAR(500) = '', @test tinyint = 0
AS
BEGIN

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
/*
Отправка email по следующим параметрам @DocType INT =:
5000 --For recadv email. Для сети METRO (rpmq.UM = 'метро/един.').
5001 - Для RECADV email (сеть Сильпо).
7007 --For comdoc_007 email.
7012 --For comdoc_012 email.
8000 --For Declar RPL (квитанции налоговых накладных).
644505 --For FTP messages.
24000 --For status.
7009 --For comdoc_009 (акт несоответствия для сети Сильпо / Invoice Matching).

Коды взяты условно-произвольно из старой xml спецификации EDIN: что-то взять по номерам пунктов, например, пункт № 5 "Уведомление о приеме" (взяли 5 * 1000 - получили 5000); аналогично 24. Статус (24 * 1000 = 24000).
При необходимости взять новый код, берем порядковый номер из содержания из этого файла (или ну свое усмотрение): 
\\s-elit-dp\F\ОТДЕЛ АВТОМАТИЗАЦИИ\! ЭДО (электронный документооборот)\EDI провайдеры\ООО АТС\! РАЗНОЕ\СИСТЕМНАЯ ИНТЕГРАЦИЯ - EDI_XML_Specification_UA_EDIN_.pdf
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [FIXED] '2020-03-11 11:08' rkv0 вместо "," нужно ";"
-- [ADDED] Maslov Oleg '2020-08-03 13:42:42.286' Дополнительная проверка суммы возврата перед отправкой сообщения на случай, если суммы совпадают.
-- [CHANGED] rkv0 '2020-08-21 14:01' изменил адрес на arda_servicedesk@const.dp.ua (сразу в заявки).
-- [CHANGED] rkv0 '2020-10-27 17:14' изменил обратно на support_arda@const.dp.ua (учет будет отправлять на Розетку РН через печатку).
-- [ADDED] rkv0 '2020-10-27 18:35' добавляю данные к письму (заявка #380).
-- [ADDED] rkv0 '2020-11-30 17:07' добавляю данные по позициям и бутылкам; сеть Розетка (заявка #1876).
-- [FIXED] rkv0 '2020-12-02 16:27' добавил блок, который не отправляет email уведомление до тех пор, пока не будет получен RECADV по этому заказу.
-- [ADDED] rkv0 '2020-12-07 12:34' добавил блок отправки уведомления по новому RECADV для сети Сильпо. После получения RECADV нужно отправлять документ CONTRL (схема Invoice-Matching).
-- [ADDED] rkv0 '2020-12-08 20:05' добавил детализацию по товарам к основному уведомлению (Танцюра #2887).
-- [ADDED] rkv0 '2020-12-09 12:16' добавил дополнительную инфо об отвязанных кодах; сеть Розетка (заявка #2984).
-- [ADDED] rkv0 '2021-01-21 12:04' добавил поправку на розетко-единицы.
-- [ADDED] rkv0 '2021-07-16 14:23' добавил обработку comdoc_009 для сети Сильпо / Invoice-Matching.
-- [CHANGED] rkv0 '2021-08-02 12:55' изменил блок отправки (##RE-9756##): добавить ссылку на документ, тема: № и дата накладной.
--[CHANGED] rkv0 '2021-08-09 14:17' изменил Понизовную на Алгсин (##RE-9975##).
--[FIXED] rkv0 '2021-08-12 10:17' добавил допусловие в JOIN по InsertData. 


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
exec [dbo].[ap_SendEmailEDI] @doctype = 8000
*/

	/*
	Here trash can:
	EXEC dbo.ap_SendEmailEDI 644505
	EXEC dbo.ap_AddRecadvID OrderID, RecadvID

	9863577638028
	SELECT * FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where CompID = (SELECT TOP 1 ZEC_KOD_KLN_OT FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = '9863577638028')
	Отдел автоматизации Арда-Трейдинг – служба поддержки <support_arda@const.dp.ua>
	
	9863569647762 - Вересень ПЛЮС


	INSERT INTO dbo.at_EDI_reg_files (ID, RetailersID, DocType, FileName, InsertData, LastUpdateData, Status, DocSum, CompID)
    SELECT ID, NULL, DocType, FileName, InsertData, LastUpdateData, Status, DocSum, CompID FROM dbo.at_EDI_reg_files_

	SELECT * FROM t_ret
	SELECT RetailersID FROM at_GLN WHERE GLN = 9863577638028
	SELECT * FROM r_Comps WHERE CompID = 64030
	SELECT TOP 1 ZEC_KOD_KLN_OT FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = 4820086630009
	SELECT * FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = 4820086630009
	
	DECLARE @ans VARCHAR(100), @SQL_Select NVARCHAR(MAX)
	set @SQL_Select = 'SELECT @out = (SELECT ISNULL((SUM (TSumCC_wt)),0) FROM t_Ret WHERE SrcTaxDocID = 6 AND SrcTaxDocDate = ''2017-11-01'' AND DocDate = ''2019-03-06'')'
	EXEC SP_EXECUTESQL @SQL_Select, N'@out VARCHAR(200) OUT', @ans OUT
	SELECT @ans
	
	SELECT ISNULL((SUM (TSumCC_wt)),0) FROM t_Ret WHERE SrcTaxDocID = 1932 AND SrcTaxDocDate = '2018-11-07' AND DocDate = '2019-03-06'
	SELECT * FROM t_Ret WHERE SrcTaxDocID = 1932 AND SrcTaxDocDate = '2018-11-07' AND DocDate = '2019-03-06'
	
	SELECT DATEDIFF(d, InsertData, GETDATE()) FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = 4
	*/

IF @DocType = -1
BEGIN
	RETURN
END;

  SET NOCOUNT ON --Variable block near.
	DECLARE @ChID INT, @Status INT
	DECLARE @CompID VARCHAR(100)
	        ,@DocID VARCHAR(100)
			,@Note VARCHAR(500)
			,@ans VARCHAR(100)
			,@SQL_Select NVARCHAR(MAX)
			,@subject VARCHAR(250)
			,@msg VARCHAR(max)
			--,@rec VARCHAR(250) = 'maslov@const.dp.ua' --for test things
			,@rec VARCHAR(250) = ''
			,@temp VARCHAR(100) = ''
            ,@xml varchar(max)
            ,@body varchar(max)
            ,@id varchar(128)
            ,@date date
            ,@docsum numeric(21, 9)
            ,@hyperlink varchar(max)
            ,@edi_guid varchar(100)
            ,@filename varchar(255)
            ,@Notes varchar(100);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*For recadv email. Для сети METRO (rpmq.UM = 'метро/един.')*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @DocType = 5000 --For recadv email. Для сети METRO (rpmq.UM = 'метро/един.').
BEGIN

DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 5000 AND [Status] = 11 AND InsertData < (DATEADD(DAY, -1, GETDATE()))

	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	

	SELECT @DocID = ID, @Status = [Status]
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE ChID = @ChID

	--Send message.
			  BEGIN TRY 
					
					--Table for other members of message.
					IF OBJECT_ID (N'tempdb..#Emails', N'U') IS NOT NULL DROP TABLE #Emails
						CREATE TABLE #Emails (Email VARCHAR(250), GLN VARCHAR(100))

					INSERT #Emails --Add emails, if didn`t find it.
						SELECT 'vasilenkov@const.dp.ua', '7001'
					--UNION ALL SELECT 'email', 'compid'
				
					SELECT @rec = 'support_arda@const.dp.ua; '  
					+ ISNULL((SELECT Email FROM #Emails WHERE GLN = (SELECT TOP 1 CompID FROM t_Inv WHERE OrderID = @DocID)), '')

				IF @Status = 11
				BEGIN
					SET @msg = 'В EDI пришло уведомление о приеме. Номер документа в EDI: ' + @DocID + '. ChID = ' + @ChID
							 + '. <p>Не сходится количество товара. Лог: e:\Exite\logs\Import_Recadv_reg_use.log </p>'
							 + '<p>Отправлено [S-PPC] JOB Workflow шаг 2 (Import_Recadv / Import_Recadv_reg_use.ps1) ap_SendEmailEDI</p>'
					UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET [Status] = 16 WHERE ChID = @ChID
				END;
				
				SET @subject = 'Уведомление о приеме в EDI.'

				EXEC msdb.dbo.sp_send_dbmail  
				@profile_name = 'arda',
				@from_address = '<support_arda@const.dp.ua>',
				@recipients = @rec,
				@subject = @subject,
				@body = @msg,  
				@body_format = 'HTML',
                @append_query_error = 1

			 
			  END TRY  
			  BEGIN CATCH
				SELECT  
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage; 
			  END CATCH
		
		FETCH NEXT FROM DocsLoop INTO @ChID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

	DECLARE DocsLoop2 CURSOR LOCAL FAST_FORWARD --Second chance. Waiting, when quantity will be equal.
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 5000 AND ([Status] = 16 OR [Status] = 11)

	OPEN DocsLoop2
		FETCH NEXT FROM DocsLoop2 INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	

	IF (SELECT DocSum FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) = (SELECT SUM(d.Qty / ISNULL(rpmq.Qty, 1) ) FROM t_Inv m JOIN t_InvD d ON d.ChID = m.ChID JOIN r_ProdMQ rpmq ON rpmq.ProdID = d.ProdID WHERE rpmq.UM = 'метро/един.' AND m.OrderID = (SELECT Notes FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) )
	BEGIN
		UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET [Status] = 10, LastUpdateData = GETDATE() WHERE ChID = @ChID
	END;

		FETCH NEXT FROM DocsLoop2 INTO @ChID
	END
	CLOSE DocsLoop2
	DEALLOCATE DocsLoop2 
END;-- if doctype = 5000

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*For comdoc_007 email*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @DocType = 7007 --For comdoc_007 email.
BEGIN

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 7007 AND Status = 11

	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	
			  SELECT @DocID = ID
			  FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
			  WHERE ChID = @ChID
			  
			  SET @Note = 'Суммы не сходятся.'
			  SET @msg = 'В EDI пришла приходная накладная. Номер документа в EDI: ' + @DocID + '. <p>' + @Note + '</p>'
			  + '<p>Отправлено [S-PPC] JOB Workflow шаг 5 (Import_Export_Comdoc_007 / Import_Comdoc_007.ps1) ap_SendEmailEDI</p>'
			  UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 19, LastUpdateData = GETDATE() WHERE ChID = @ChID

			  --Send message.
			  BEGIN TRY 

				SET @subject = 'Новая приходная накладная в EDI.'

				EXEC msdb.dbo.sp_send_dbmail  
				@profile_name = 'arda',
				@from_address = '<support_arda@const.dp.ua>',
				@recipients = 'support_arda@const.dp.ua;',
				@subject = @subject,
				@body = @msg,  
				@body_format = 'HTML',
                @append_query_error = 1
			 
			  END TRY  
			  BEGIN CATCH
				SELECT  
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage; 
			  END CATCH
		
		FETCH NEXT FROM DocsLoop INTO @ChID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

	--Second chance. Waiting, when sums will be equal.
	DECLARE CheckLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 7007 AND Status = 19

	OPEN CheckLoop
		FETCH NEXT FROM CheckLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	

	SET @SQL_Select = 'SELECT @out = (SELECT ISNULL((SUM (TSumCC_wt)),0) FROM t_Inv WHERE ' + (SELECT Notes FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID)  + ' AND TaxDocID != 0' + ')'
	EXEC SP_EXECUTESQL @SQL_Select, N'@out VARCHAR(200) OUT', @ans OUT

		IF (SELECT DocSum FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) = @ans
		BEGIN
		UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 20, LastUpdateData = GETDATE() WHERE ChID = @ChID
		END;
		
		ELSE
		BEGIN
		UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET LastUpdateData = GETDATE() WHERE ChID = @ChID
		END;
		
		FETCH NEXT FROM CheckLoop INTO @ChID
	END
	CLOSE CheckLoop
	DEALLOCATE CheckLoop 
END; -- if doctype = 7007

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*For comdoc_012 email*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @DocType = 7012 --For comdoc_012 email.
BEGIN

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 7012 AND [Status] BETWEEN 9 AND 16 AND InsertData < (DATEADD(DAY, @delay, GETDATE()))

	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	
	
	SELECT @CompID = CompID, @DocID = ID, @Status = [Status]
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE ChID = @ChID

				SET @temp = ISNULL
							(
								(
								  (SELECT top 1 (SELECT (SELECT isnull(EMail,'') mail FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
								  FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where CompID = @CompID)
			       				)
							,'')

				IF @temp=''
				BEGIN
					--Table for other members of message.
					IF OBJECT_ID (N'tempdb..#GLNs', N'U') IS NOT NULL DROP TABLE #GLNs
						CREATE TABLE #GLNs (Email VARCHAR(250), GLN VARCHAR(100))

					INSERT #GLNs
						SELECT '', '64030'
					--UNION ALL SELECT 'email', 'compid'
				
					SELECT @rec = 'support_arda@const.dp.ua;'  
					--+ (SELECT Email FROM #GLNs WHERE GLN = 1) 
				END;

				ELSE
				BEGIN			
					SET @rec = 'support_arda@const.dp.ua; ' + @temp						   
			    END;

				--[ADDED] Maslov Oleg '2020-08-03 13:42:42.286' Дополнительная проверка суммы возврата перед отправкой сообщения на случай, если суммы совпадают.
				SET @SQL_Select = 'SELECT @out = (SELECT ISNULL((SUM (TSumCC_wt)),0) FROM t_Ret WHERE ' + (SELECT Notes FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID)  + ' AND TaxDocID != 0' + ')'
				EXEC SP_EXECUTESQL @SQL_Select, N'@out VARCHAR(100) OUT', @ans OUT
				
				IF (SELECT DocSum FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) = CAST(@ans AS NUMERIC(21,9))
				BEGIN
					SET @Status = 10
				END;

				IF @Status = 10
				BEGIN
					SET @Note = 'Суммы сходятся.'
					SET @msg = 'В EDI пришла возвратная накладная. Номер документа в EDI: ' + @DocID + '. <p>' + @Note + '</p>'
					+ '<p> Нужно ли подписывать?</p>'
					+ '<p>UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 20 WHERE ChID = ' + CAST(@ChID AS VARCHAR) +'</p>'
				    + '<p>Отправлено [S-PPC] JOB Workflow шаг 6 (Import_Comdoc_012 / Import_Comdoc_012_Email_reg_use.ps1) ap_SendEmailEDI</p>'
					UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 19, LastUpdateData = GETDATE() WHERE ChID = @ChID
				END;

				ELSE IF @Status = 12
				BEGIN
					SET @Note = 'Суммы не сходятся, в базе нет налогового номера накладной.'
					SET @msg = 'В EDI пришла возвратная накладная. Номер документа в EDI: ' + @DocID + '. <p>' + @Note + '</p>'
					+ '<p> Нужно ли подписывать?</p>'
					+ '<p>Отправлено [S-PPC] JOB Workflow шаг 6 (Import_Comdoc_012 / Import_Comdoc_012_Email_reg_use.ps1) ap_SendEmailEDI</p>'
					UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 18, LastUpdateData = GETDATE() WHERE ChID = @ChID
				END;

				ELSE
				BEGIN
					SET @Note = 'Суммы не сходятся.'
					SET @msg = 'В EDI пришла возвратная накладная. Номер документа в EDI: ' + @DocID + '. <p>' + @Note + '</p>'
					+ '<p> Нужно ли подписывать?</p>'
					+ '<p>Отправленно [S-PPC] JOB Workflow шаг 6 (Import_Comdoc_012) ap_SendEmailEDI</p>'
					UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 17, LastUpdateData = GETDATE() WHERE ChID = @ChID
				END;
				
				--If you don`t need to sign 012 comdoc for retailer, add him near.
				IF (SELECT TOP 1 RetailersID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) = 16072
				BEGIN
					UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET [Status] = 41, LastUpdateData = GETDATE() WHERE ChID = @ChID
				END;

			  --Send message.
			  BEGIN TRY 

				SET @subject = 'Новая возвратная накладная в EDI.'

				EXEC msdb.dbo.sp_send_dbmail  
				@profile_name = 'arda',
				@from_address = '<support_arda@const.dp.ua>',
				@recipients = @rec,
				@subject = @subject,
				@body = @msg,  
				@body_format = 'HTML',
                @append_query_error = 1
			 
			  END TRY  
			  BEGIN CATCH
				SELECT  
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage; 
			  END CATCH
		
		FETCH NEXT FROM DocsLoop INTO @ChID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop
	
	--Second chance. Waiting, when sums will be equal.
	DECLARE CheckLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 7012 AND ([Status] = 18 OR [Status] = 12)
		  AND ( (SELECT DATEDIFF(d, LastUpdateData, GETDATE())) >= 7) --Time at days, when 012 comdoc will have second chanse.

	OPEN CheckLoop
		FETCH NEXT FROM CheckLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	

	SET @SQL_Select = 'SELECT @out = (SELECT ISNULL((SUM (TSumCC_wt)),0) FROM t_Ret WHERE ' + (SELECT Notes FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID)  + ' AND TaxDocID != 0' + ')'
	EXEC SP_EXECUTESQL @SQL_Select, N'@out VARCHAR(100) OUT', @ans OUT

		IF (SELECT DocSum FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) = CAST(@ans AS NUMERIC(21,9))
		BEGIN
			UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET [Status] = 19, LastUpdateData = GETDATE() WHERE ChID = @ChID
		END;
		
		ELSE
		BEGIN
			UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET LastUpdateData = GETDATE() WHERE ChID = @ChID
		END;
		
		FETCH NEXT FROM CheckLoop INTO @ChID
	END
	CLOSE CheckLoop
	DEALLOCATE CheckLoop 
END; -- if doctype = 7012

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Для comdoc_012 email (Фудком).*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @DocType = 70121 --Для comdoc_012 email (Фудком).
BEGIN
/*
UPDATE [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] SET [Status] = 0 WHERE doctype = 70121 and InsertData >= '20210101' and chid in (83515);
EXEC [dbo].[ap_SendEmailEDI] @doctype = 70121
*/
    
    DECLARE cursor_foodcom_email CURSOR LOCAL FAST_FORWARD FOR
    SELECT ChID
    FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files]
    WHERE doctype = 70121
	    and [Status] = 10
	    and InsertData >= '20210101';
    
    OPEN cursor_foodcom_email
    
    FETCH NEXT FROM cursor_foodcom_email INTO @chid
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @filename = (SELECT [Filename] FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE Chid = @ChID);
            SET @edi_guid = (SELECT PString FROM dbo.[af_SplitString] (@filename, '_') WHERE PString like '%-%');
            SET @id = (SELECT ID FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE Chid = @ChID);
            SET @date = (SELECT convert(date, InsertData, 104) FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE Chid = @ChID);            
            SET @docsum = (SELECT DocSum FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE Chid = @ChID);
            SET @hyperlink = 'https://edo-v2.edi-n.com/app/#/service/edi/view/' + @edi_guid + '/comdoc/nakladnapovernennya';
            SET @subject = 'Новая возвратная накладная в EDI по Фудком № ' + CAST(@id AS varchar) + ' от ' + CONVERT(varchar, @date, 104);
			SET @msg = '<p style="font-size: 12; color: gray"><i>[для администратора БД] Отправлено [S-PPC] JOB Workflow шаг 11 (Check_Comdoc_012 / Import_Comdoc_012_Email_notification.ps1)</i></p>'
            
            /*HTML*/
            IF OBJECT_ID('tempdb..#html', 'U') IS NOT NULL DROP TABLE #html
            SELECT 
                ID 'Номер возвратной накладной', 
                CONVERT(varchar, InsertData, 104) as 'Дата', 
                DocSum as 'Итого сумма с НДС, грн', 
                @hyperlink as 'Ссылка на документ на сайте EDIN', 
                'Сеть: Велика Кишеня, #Накладная на возврат, Номер: ' + ID + ',' as 'Поиск через фильтр в EDIN'
                INTO #html 
                FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE doctype = 70121 and ChID = @ChID;

            DECLARE @head_html varchar(max) = NULL
            DECLARE @table varchar(max) = '#html'
            SELECT @head_html = ISNULL(@head_html, '') + '<th>' + COLUMN_NAME + '</th>' FROM tempdb.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = (SELECT [name] FROM tempdb.sys.tables WHERE object_id = OBJECT_ID('tempdb..' + @table)) ORDER BY ORDINAL_POSITION

            DECLARE @fields_html varchar(max) = NULL
            SELECT @fields_html = ISNULL(@fields_html, '') + CASE WHEN @fields_html IS NULL THEN '' ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td' FROM tempdb.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = (SELECT [name] FROM tempdb.sys.tables WHERE object_id = OBJECT_ID('tempdb..' + @table)) ORDER BY ORDINAL_POSITION

            DECLARE @SQL NVARCHAR(4000);
            DECLARE @result NVARCHAR(MAX)
            SET @SQL = 'SELECT @result = (
            SELECT '+ @fields_html +' FROM #html t FOR XML RAW(''tr''), ELEMENTS
            )';
            EXEC sp_executesql @SQL, N'@result NVARCHAR(MAX) output', @result = @result OUTPUT

            DECLARE @body_html NVARCHAR(MAX)
            SET @body_html = N'<table  bordercolor=#48d9bf border="5"><tr>' + @Head_html + '</tr>' + @result + N'</table>'
            SET @body = @body_html + @msg

            EXEC msdb.dbo.sp_send_dbmail  
                 @profile_name = 'arda'
                ,@from_address = '<support_arda@const.dp.ua>'
                ,@recipients = 'tancyura@const.dp.ua;vasilenkov@const.dp.ua;volotovskiy@const.dp.ua'
                --,@recipients = 'rumyantsev@const.dp.ua'
                ,@copy_recipients  = 'support_arda@const.dp.ua;rumyantsev@const.dp.ua' --rumyantsev@const.dp.ua оставить, т.к. есть проблемы с правилами в outlook.
                ,@subject = @subject
                ,@body = @body
                ,@body_format = 'HTML'
                ,@append_query_error = 1;
            
            --Status = 14 - email уведомление отправлено.
            UPDATE [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] SET [Status] = 14 WHERE doctype = 70121 and ChID = @chid;
            FETCH NEXT FROM cursor_foodcom_email INTO @chid;
        END;
    CLOSE cursor_foodcom_email;
    DEALLOCATE cursor_foodcom_email;


END; -- if doctype = 70121

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*For Declar RPL (квитанции налоговых накладных)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @DocType = 8000 --For Declar RPL (квитанции налоговых накладных).
BEGIN
--exec [dbo].[ap_SendEmailEDI] @doctype = 8000, @test = 1
    DECLARE @recipients varchar(max) = CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua' ELSE 'algsin@const.dp.ua;bibik@const.dp.ua;tancyura@const.dp.ua' END
    DECLARE @copy_recipients varchar(max) = CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua' ELSE 'support_arda@const.dp.ua' END

    DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 

	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].[Alef_Elit].[dbo].[at_EDI_reg_files]
	WHERE DocType = 8000
	  AND [Status] IN (1)				    --Новый статус

	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	

            --Отправка почтового сообщения
			BEGIN TRY 
			  SET @subject = 'ДФС отклонила отправленную через EDI налоговую № ' + CAST( (SELECT reverse(substring(reverse(ID),2,len(ID))) FROM [S-PPC.CONST.ALEF.UA].[Alef_Elit].[dbo].[at_EDI_reg_files] WHERE ChID = @ChID) AS VARCHAR)
			  SET @msg = '<p style="font-size: 12;color:gray"><i>'
                        + (SELECT TOP 1 [FileName] FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg WHERE ChID = @ChID ORDER BY ChID DESC) +
                        + '<br> Отправлено [S-PPC] JOB Workflow шаг 3 (Import_RPL / Import_Rpl_Email_reg_use.ps1)
                        </i></p>'

			  --SET @sql = 
     --         SELECT AER_RPL_DATE, AER_TAX_ID FROM [S-PPC.CONST.ALEF.UA].[Alef_Elit].[dbo].[at_EDI_reg_files] reg
     --         JOIN [S-PPC.CONST.ALEF.UA].[Alef_Elit].[dbo].[ALEF_EDI_RPL] rpl ON rpl.AER_RPL_ID = reg.ID
     --         WHERE ChID = @ChID
            
--если compid найден.
IF EXISTS (
        SELECT TOP 1 1
        FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
        JOIN [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.[av_EDI_ALEF_EDI_RPL] rpl ON rpl.AER_RPL_ID = reg.ID
        JOIN [s-sql-d4].[elit].dbo.r_comps rc ON rc.Compid = CAST(reg.CompID as varchar(20))
        WHERE reg.ChID = @ChID
        )
            BEGIN
                SET @xml = CAST((
                SELECT 
                    reg.CompID 'td', ' ',
                    rc.CompShort 'td', ' ',
                    rpl.AER_TAX_ID 'td', ' ',
                    rpl.AER_TAX_DATE 'td', ' ',
                    reg.Notes 'td', ' '
                FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
                --[FIXED] rkv0 '2021-08-12 10:17' добавил допусловие в JOIN по InsertData. 
                --JOIN [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.[av_EDI_ALEF_EDI_RPL] rpl ON rpl.AER_RPL_ID = reg.ID
                JOIN [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.[av_EDI_ALEF_EDI_RPL] rpl ON (rpl.AER_RPL_ID = reg.ID AND cast(reg.InsertData as date) = cast(rpl.AER_AUDIT_DATE as date))
                JOIN [s-sql-d4].[elit].dbo.r_comps rc ON rc.CompID = CAST(reg.CompID as varchar(20))
                WHERE reg.ChID = @ChID
                FOR XML PATH ('tr'), ELEMENTS
                ) as nvarchar(max))

            --https://htmlcolorcodes.com/
            SET @body = '<html>
                <head>
                <style>
                    table{border: 2px solid blue, border-collapse: collapse; background-color: #ffe166 } th,td{text-align: center}
                </style>
                </head>
                <body>
                <table border = "3" bordercolor=" #ffe166 "> 
                    <tr>
                        <th> № предприятия </th> 
                        <th> Контора </th>
                        <th> № налоговой </th>
                        <th> Дата налоговой </th>
                        <th> Причина </th>
                    </tr>'
            END;

--если compid не найден, вместо него вставляем code (код ЕДРПОУ).
ELSE
            BEGIN
                SET @xml = CAST((
                SELECT TOP 1
                    reg.CompID 'td', ' ',
                    rc.CompShort 'td', ' ',
                    rpl.AER_TAX_ID 'td', ' ',
                    rpl.AER_TAX_DATE 'td', ' ',
                    reg.Notes 'td', ' '
                FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
                JOIN [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.[av_EDI_ALEF_EDI_RPL] rpl ON rpl.AER_RPL_ID = reg.ID
                JOIN [s-sql-d4].[elit].dbo.r_comps rc ON rc.Code = CAST(reg.CompID as varchar(20))
                WHERE reg.ChID = @ChID
                FOR XML PATH ('tr'), ELEMENTS
                ) as nvarchar(max))

            --https://htmlcolorcodes.com/
            SET @body = '<html>
                <head>
                <style>
                    table{border: 2px solid blue, border-collapse: collapse; background-color: #ffe166 } th,td{text-align: center}
                </style>
                </head>
                <body>
                <table border = "3" bordercolor=" #ffe166 "> 
                    <tr>
                        <th> Код ЕДРПОУ </th> 
                        <th> Контора </th>
                        <th> № налоговой </th>
                        <th> Дата налоговой </th>
                        <th> Причина </th>
                    </tr>'
            END;            



            SET @body = @body + @xml + '</table>' + @msg + '</body> </html>'


			  EXEC msdb.dbo.sp_send_dbmail  
			  @profile_name = 'arda',  
			  @recipients = @recipients,  
			  --@recipients = 'rumyantsev@const.dp.ua',
              --[CHANGED] rkv0 '2021-08-09 14:17' изменил Понизовную на Алгсин (##RE-9975##).
              --@copy_recipients = 'ponyzovnaya@const.dp.ua;bibik@const.dp.ua;tancyura@const.dp.ua',
              @copy_recipients = @copy_recipients,
			  @subject = @subject,
			  @body = @body,  
			  @body_format = 'HTML',
              @append_query_error = 1,
              @importance = 'high'
               
			END TRY  
			BEGIN CATCH
			  SELECT  
			  ERROR_NUMBER() AS ErrorNumber  
			  ,ERROR_SEVERITY() AS ErrorSeverity  
			  ,ERROR_STATE() AS ErrorState  
			  ,ERROR_PROCEDURE() AS ErrorProcedure  
			  ,ERROR_LINE() AS ErrorLine  
			  ,ERROR_MESSAGE() AS ErrorMessage; 
			END CATCH
			
			UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
			SET [Status] = 4
			   ,LastUpdateData = GETDATE()
			WHERE ChID = @ChID
		
		FETCH NEXT FROM DocsLoop INTO @ChID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

END; -- if doctype = 8000

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*For FTP messages*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @DocType = 644505 --For FTP messages.
BEGIN
				BEGIN TRY 
				
				SET @msg = '<p>Файл: ' + @text + ' не был отправлен на FTP.</p>' 
						 + '<p>Отправлено [S-PPC] JOB Workflow шаг 14-15 (SendToFtp, SendToFTP_autosend) ap_SendEmailEDI</p>' +
                         'Лог хранится на s-ppc: e:\Exite\logs\Send_2_FTP_autosend_modify_logs.log'
							
				SET @subject = 'Ошибка при отправке на FTP (EDI).'

				EXEC msdb.dbo.sp_send_dbmail  
				@profile_name = 'arda',
				@from_address = '<support_arda@const.dp.ua>',
				@recipients = 'support_arda@const.dp.ua;',
				@subject = @subject,
				@body = @msg,  
				@body_format = 'HTML',
                @append_query_error = 1  

			  END TRY  
			  BEGIN CATCH
				SELECT  
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage; 
			  END CATCH

END; -- if doctype = 644505

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*For status (Rozetka)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @DocType = 24000 --For status (Rozetka).
BEGIN

/*
update TOP(1) [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files set [status] = 3 WHERE chid = 72623 and doctype = 24000 and id = 'РОЗ01088936'
update TOP(1) [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files set [status] = 3 WHERE chid = 72400 and doctype = 24000 and id = 'РОЗ01088864'
SELECT * FROM  [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE /*doctype = 24000 and id = 'РОЗ01088864' and */ chid = 73299 ORDER BY lastupdatedata DESC
exec [dbo].[ap_SendEmailEDI] @doctype = 24000
*/

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 

	SELECT ChID, ID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 24000
	  AND [Status] IN (3,4)				--Новый статус
	  AND Notes LIKE 'COMDOC%'			--Только по COMDOC
	  AND Notes NOT LIKE '%успешно%'	--Если пришло что-то кроме хороших статусов.
	  AND RetailersID = 17154			--Розетка
    
	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID, @ID
	WHILE @@FETCH_STATUS = 0 --0 - The FETCH statement was successful.
    BEGIN	

      SET @filename = (SELECT TOP(1) REC_FILENAME FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV WITH(NOLOCK) WHERE REC_ORD_ID = @ID ORDER BY REC_AUDIT_DATE DESC);
      SET @edi_guid = (SELECT SUBSTRING(PString, 1, LEN(Pstring) - 4 /*.xml*/) from dbo.[af_SplitString] (@filename, '_') WHERE Pstring like '%-%');
      SET @hyperlink = 'https://edo-v2.edi-n.com/app/#/service/edi/view/' + @edi_guid + '/recadv';
      DECLARE @orderid varchar(128) = (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID)
        -- [FIXED] rkv0 '2020-12-02 16:27' добавил блок, который не отправляет email уведомление до тех пор, пока не будет получен RECADV по этому заказу.
        IF NOT EXISTS (SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                    WHERE m.REC_ORD_ID = @orderid)
        BEGIN
            FETCH NEXT FROM DocsLoop INTO @ChID, @ID
            CONTINUE
        END;

            --Отправка почтового сообщения
			BEGIN TRY 

            -- [ADDED] rkv0 '2020-10-27 18:35' добавляю данные к письму (заявка #380).
/*			  DECLARE @query varchar(max) = 
                    'SET NOCOUNT ON; SELECT TOP(1) ti.CompID ''№ предприятия'', rc.CompName ''Контора'', ti.TaxDocID ''№ налоговой'', ti.TaxDocDate ''Дата налоговой'', ti.OrderID ''№ заказа'', ti.DocID ''№ документа'', ti.TSumCC_wt ''Сумма с НДС, грн'' FROM t_Inv ti
                    JOIN r_Comps rc ON rc.CompID = ti.Compid
                    WHERE ti.OrderID = ' + '''' + cast(@orderid as varchar) + '''';*/
            
            --SET @subject = 'Статус по заказу ' + CAST( (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) AS VARCHAR)
			  SET @subject = 'РОЗЕТКА - Статус по заказу ' + CAST( @orderid AS VARCHAR) + ' => ' + (SELECT TOP 1 Notes
			                          FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
			                            	WHERE ChID = @ChID
			                          ORDER BY ChID DESC)

			  SET @msg = '<p style="font-size: 12;color:gray"><i>Отправлено [S-PPC] JOB Workflow шаг 1 (Import_Status / Import_Status_reg_use.ps1)</i></p>'
            
            SET @xml = CAST((
               SELECT TOP(1)
                     ti.CompID 'td', ' ' --№ предприятия
                    ,rc.CompName 'td', ' ' --Контора
                    ,ti.TaxDocID 'td', ' ' --№ налоговой
                    ,CONVERT(varchar, ti.TaxDocDate, 104) 'td', ' ' --Дата налоговой --https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
                    ,ti.OrderID 'td', ' ' --№ заказа
                    ,ti.DocID 'td', ' ' --№ документа в Бизнесе
                    ,ti.TSumCC_wt 'td', ' ' --Сумма с НДС, грн
-- [ADDED] rkv0 '2020-11-30 17:07' добавляю данные по позициям и бутылкам; сеть Розетка (заявка #1876).
                    --,(SELECT SUM(REP_DELIVER_QTY) FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                    --    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                    --    WHERE m.REC_ORD_ID = @orderid) 'td', ' ' --Отправлено бутылок (recadv), шт.
                    ,(SELECT CAST(SUM(Qty) as int) FROM t_inv m
                    JOIN t_InvD d ON m.ChID = d.ChID WHERE m.OrderID = @orderid) 'td', ' ' --Отправлено бутылок (РН), шт.

                    ,(SELECT COUNT(SrcPosID) FROM t_inv m
                        JOIN t_InvD d ON m.ChID = d.ChID WHERE m.OrderID = @orderid) 'td', ' ' --Отправлено позиций (РН), шт.
                    , '==>>' 'td', ' '
                    
/*                    ,ISNULL((SELECT SUM(REP_DELIVER_QTY) FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                    WHERE m.REC_ORD_ID = @orderid), 0) 'td', ' ' --Отправлено бутылок, шт. (recadv)
*/
                        ,ISNULL(
                        (SELECT SUM(CAST(aerp.REP_DELIVER_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID) AS int))
                        FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
                        JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
                        JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
                        RIGHT JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
                        JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
                        JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
                        JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
                        WHERE ti.orderid = @orderid
                        group by aer.REC_ORD_ID), 0
                        ) 'td', ' ' --Отправлено бутылок, шт. (recadv)

/*                    ,ISNULL((SELECT SUM(REP_ACCEPT_QTY) FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                        JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                        WHERE m.REC_ORD_ID = @orderid), 0) 'td', ' ' --Принято бутылок, шт. (recadv)
*/                   
                        ,ISNULL(
                        (SELECT SUM(CAST(aerp.REP_ACCEPT_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID) AS int))
                        FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
                        JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
                        JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
                        RIGHT JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
                        JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
                        JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
                        JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
                        WHERE ti.orderid = @orderid
                        group by aer.REC_ORD_ID), 0
                        ) 'td', ' ' --Принято бутылок, шт. (recadv)
                    
                    ,(SELECT COUNT(REP_POS_ID) FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                        JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                        WHERE m.REC_ORD_ID = @orderid) 'td', ' ' --Принято позиций (recadv)
                    ,@hyperlink 'td', ''


                    FROM t_Inv ti
                    JOIN r_Comps rc ON rc.CompID = ti.Compid
                    JOIN t_InvD tid ON ti.ChID = tid.ChID
                    WHERE ti.OrderID = @orderid
                    FOR XML PATH('tr'), ELEMENTS)
                as nvarchar(max)
                ) 

            --https://htmlcolorcodes.com/
            SET @body = '<html> 
                <head>
                <style>
                    table{border: 2px solid blue, border-collapse: collapse; background-color:   #ffcefd  } th,td{text-align: center}
                    caption { background-color:  #bf76ce ; color: white; font-weight: bold;}
                </style>
                </head>
                <body>
                <table border = "3" bordercolor=" #FF5733 "> 
                    <tr>
                        <th> № предприятия </th> 
                        <th> Контора </th>
                        <th> № налоговой </th>
                        <th> Дата налоговой </th>
                        <th> № заказа </th>
                        <th> № документа в Бизнесе </th>
                        <th> Сумма с НДС, грн </th>
                        <th><font color="#5e9572"> Отправлено бутылок, шт. </font> <font color="#595959"><i>(текущая РН в базе)</i></font></th></th>
                        <th><font color="#5e9572"> Отправлено позиций, шт. </font> <font color="#595959"><i>(текущая РН в базе)</i></font></th></th>
                        <th> ==>> </th>
                        <th><font color="#C70039"> Отправлено бутылок, шт. </font> <font color="#595959"><i>(уведомление о приеме от сети)</i></font></th>
                        <th><font color="#C70039"> Принято бутылок, шт. </font> <font color="#595959"><i>(уведомление о приеме от сети)</i></font></th>
                        <th><font color="#C70039"> Принято позиций </font> <font color="#595959"><i>(уведомление о приеме от сети)</i></font></th>
                        <th><font color="#7688df"> Ссылка на документ в EDI </font> <font color="#7688df"><i>(уведомление о приеме от сети)</i></font></th>
                    </tr>'
                    
-- [ADDED] rkv0 '2020-12-08 20:05' добавил детализацию по товарам к основному уведомлению (Танцюра #2887).
            DECLARE @xml2 varchar(max)
            SET @xml2 = cast((
                SELECT 
                '===>>>' 'td', ' ' --УВЕДОМЛЕНИЕ О ПРИЕМЕ
                ,aer.REC_ORD_ID 'td', ' ' --Номер заказа
                ,ti.CompID  'td', ' ' --Предприятие
                ,aerp.REP_POS_KOD  'td', ' ' --Код сети
                -- [ADDED] rkv0 '2021-01-21 12:04' добавил поправку на розетко-единицы.
                -- ,aerp.REP_ACCEPT_QTY 'td', ' ' --Принято, бут.
                --,aerp.REP_DELIVER_QTY  'td', ' ' --Отправлено, бут.
                ,CAST(aerp.REP_ACCEPT_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID) AS int) 'td', ' ' --Принято, бут.
                ,CAST(aerp.REP_DELIVER_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID) AS int) 'td', ' ' --Отправлено, бут.
                ,'===>>>'  'td', ' ' --РАСХОДНАЯ (детали)
                ,tid.SrcPosID 'td', ' ' --№ п/п
                ,tid.Prodid  'td', ' ' --Наш код
                ,rp.ExtProdID  'td', ' ' --Внешний код
                ,ps.ProdName  'td', ' ' --Товар
                ,CAST(tid.Qty AS int) 'td', ' ' --Количество, бут.
                ,'===>>>'  'td', ' ' --ВОЗВРАТЫ
                ,CASE WHEN CAST((tid.Qty - aerp.REP_ACCEPT_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID)) as int) = 0 THEN 0 ELSE CAST((tid.Qty - aerp.REP_ACCEPT_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID)) as int) END 'td', ' '  --Вернули, бут.
                    
                FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
                JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
                JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
                RIGHT JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
                JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
                JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
                JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
                    
                WHERE ti.orderid = @orderid
                ORDER BY tid.SrcPosID ASC
                FOR XML PATH('tr'), ELEMENTS)
            as nvarchar(max)
            )

            DECLARE @body2 varchar(max)
            set @body2 = '
            <br> <br>
            <table border = "2" bordercolor=" #4451a4 ">
            <caption> ДЕТАЛЬНО </caption>
            <tr>
                <th><font color=" #0023ff "> УВЕДОМЛЕНИЕ О ПРИЕМЕ </font></th>
                <th><font color=" #0023ff "> Номер заказа </font> </th>
                <th><font color=" #0023ff "> Предприятие </font> </th>
                <th><font color=" #0023ff "> Код сети </font> </th>
                <th><font color=" #0023ff "> Принято, бут. </font> </th>
                <th><font color=" #0023ff "> Отправлено, бут. </font> </th>
                <th><font color=" #3c7057 "> РАСХОДНАЯ (детали) </font> </th>
                <th><font color=" #3c7057 "> № п/п </font> </th>
                <th><font color=" #3c7057 "> Наш код </font> </th>
                <th><font color=" #3c7057 "> Внешний код </font> </th>
                <th><font color=" #3c7057 "> Товар </font> </th>
                <th><font color=" #3c7057 "> Количество, бут. </font> </th>
                <th><font color=" #ff2821 "> ВОЗВРАТЫ </font> </th>
                <th><font color=" #ff2821 "> Вернули, бут. </font> </th>
            </tr>'
-- [ADDED] rkv0 '2020-12-09 12:16' добавил дополнительную инфо об отвязанных кодах; сеть Розетка (заявка #2984).
           IF EXISTS (SELECT --если есть позиции в расходной, по которым были отвязаны внешние коды.
                     d.SrcPosID  'td', ' '
                    ,d.ProdID  'td', ' '
                FROM t_Inv m WITH(NOLOCK)   
                JOIN t_InvD d WITH(NOLOCK) ON m.ChID = d.ChID
                LEFT JOIN r_ProdEC re ON re.ProdID = d.ProdID and m.CompID = re.CompID
                WHERE m.OrderID = @orderid AND re.ProdID IS NULL)
            BEGIN
           
               DECLARE @xml3 varchar(max)
                SET @xml3 = cast((
                    SELECT 
                         d.SrcPosID  'td', ' '
                        ,d.ProdID  'td', ' '
                    FROM t_Inv m WITH(NOLOCK)   
                    JOIN t_InvD d WITH(NOLOCK) ON m.ChID = d.ChID
                    LEFT JOIN r_ProdEC re ON re.ProdID = d.ProdID and m.CompID = re.CompID
                    WHERE m.OrderID = @orderid AND re.ProdID IS NULL
                    FOR XML PATH('tr'), ELEMENTS)
                as nvarchar(max)
                )

                DECLARE @body3 varchar(max)
                set @body3 = '
                <br> <br>
                <table border = "2" bordercolor=" #4451a4 ">
                <caption> Код был отвязан! Данная позиция не отображается в таблице! </caption>
                <tr>
                    <th><font color=" #0023ff "> Порядковый номер позиции в расходной </font></th>
                    <th><font color=" #0023ff "> Наш код товара </font> </th>
                </tr>'
            SET @body = @body + @xml + '</table>' + @body2 + @xml2 + '</table>' + @body3 + @xml3 + '</table>' + @msg + '</body> </html>'
            GOTO send_mail
            END;

            SET @body = @body + @xml + '</table>' + @body2 + @xml2 + '</table>' + @msg + '</body> </html>'

              send_mail:
              EXEC msdb.dbo.sp_send_dbmail  
			   @profile_name = 'arda'
              -- [FIXED] '2020-03-11 11:08' rkv0 вместо "," нужно ";"
--[CHANGED] rkv0 '2020-08-21 14:01' изменил адрес на arda_servicedesk@const.dp.ua (сразу в заявки).
--[CHANGED] rkv0 '2020-10-27 17:14' изменил обратно на support_arda@const.dp.ua (учет будет отправлять на Розетку РН через печатку).

			  --,@recipients = 'rumyantsev@const.dp.ua'
			  ,@recipients = 'jarmola@const.dp.ua;tancyura@const.dp.ua;gubiu@const.dp.ua'
              ,@copy_recipients = 'support_arda@const.dp.ua'

			  ,@subject = @subject
			  ,@body = @body
			  ,@body_format = 'HTML'
-- [ADDED] rkv0 '2020-10-27 18:35' добавляю данные к письму (заявка #380).
              --,@query = @query
              --,@query_result_header = 1 --include column headers. type bit. 1 by default.
              --,@attach_query_result_as_file = 1 --type bit, with a default of 0 (message body).
              --,@query_attachment_filename = 'Данные по заказу в нашей базе.csv' --nvarchar(255); ignored when attach_query_result is 0; arbitrary filename by default.
              --,@execute_query_database = 'Elit' --only applicable if @query is specified.
              --,@query_result_separator = '; ' --type char(1). Defaults to ' ' (space).
              ,@append_query_error = 1 --bit, with a default of 0. includes the query error message in the body of the e-mail message.
              --,@query_result_no_padding = 1


			END TRY  
			BEGIN CATCH
			  SELECT  
			  ERROR_NUMBER() AS ErrorNumber  
			  ,ERROR_SEVERITY() AS ErrorSeverity  
			  ,ERROR_STATE() AS ErrorState  
			  ,ERROR_PROCEDURE() AS ErrorProcedure  
			  ,ERROR_LINE() AS ErrorLine  
			  ,ERROR_MESSAGE() AS ErrorMessage; 
			END CATCH
			
			UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
			SET [Status] = 10
			   ,LastUpdateData = GETDATE()
			WHERE ChID = @ChID
        FETCH NEXT FROM DocsLoop INTO @ChID, @ID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

END; -- if doctype = 24000 (status; Rozetka)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Для RECADV email (сеть Сильпо)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- [ADDED] rkv0 '2020-12-07 12:34' добавил блок отправки уведомления по новому RECADV для сети Сильпо. После получения RECADV нужно отправлять документ CONTRL (схема Invoice-Matching).
-- [CHANGED] rkv0 '2021-08-02 12:55' изменил блок отправки (##RE-9756##): добавить ссылку на документ, тема: № и дата накладной.
IF @DocType = 5001 --5001 - Для RECADV email (сеть Сильпо).
BEGIN

DECLARE Cursor_RECADV CURSOR LOCAL FAST_FORWARD FOR 
/*
exec [dbo].[ap_SendEmailEDI] @doctype = 5001
*/
        
    SELECT Chid
    FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
    WHERE 1 = 1 
    AND DocType = 5000
    AND [status] in (10, 11, 15) --при импорте RECADV им назначаются статусы здесь: Import_Recadv_reg_use.ps1
    AND RetailersID = 14 -- сеть Сильпо (Фоззи).

	OPEN Cursor_RECADV
		FETCH NEXT FROM Cursor_RECADV INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	

	    SELECT @DocID = ID, @Status = [Status]
	    FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	    WHERE ChID = @ChID	   
        
        SET @filename = (SELECT [Filename] FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE chid = @ChID);
        --select @filename 
        SET @edi_guid = (SELECT SUBSTRING(PString, 1, LEN(Pstring) - 4 /*.xml*/) from dbo.[af_SplitString] (@filename, '_') WHERE Pstring like '%-%');
        --select @edi_guid 
        SET @hyperlink = 'https://edo-v2.edi-n.com/app/#/service/edi/view/' + @edi_guid + '/recadv/fozzy';
        --select @hyperlink 

        SELECT @Orderid = Notes FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID
        SELECT @Orderid

        DECLARE @taxdocid varchar(max) 
        SELECT @taxdocid = TaxDocID FROM t_Inv WHERE OrderID = @Orderid
        --select @taxdocid

        DECLARE @taxdocdate varchar(max) 
        SELECT @taxdocdate = CONVERT(varchar, TaxDocDate, 104) FROM t_Inv WHERE OrderID = @Orderid
        --select @taxdocdate

            --Отправка почтового сообщения
			  BEGIN TRY 
					
				IF @Status in (10, 11, 15)
				    BEGIN
					    SET @msg = '<p>' + @hyperlink + '</p>'
                                    + '<p> Номер расходной: ' + @taxdocid + '</p>' 
                                    + '<p> Дата расходной: ' + @taxdocdate + '</p>'
			                        + '<p style="font-size: 12;color:gray"><i> Отправлено [S-PPC] JOB Workflow шаг Check_Recadv </i></p>'

					    --UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET [Status] = 16 WHERE ChID = @ChID --16 - отправлен email, 17 - отправлен contrl.
				    END;
				
				    SET @subject = 'Новое уведомление о приеме в EDI по сети Сильпо (Фоззи) по заказу № ' + CAST(@DocID as varchar)

				    EXEC msdb.dbo.sp_send_dbmail  
				      @profile_name = 'arda'
				    , @from_address = '<support_arda@const.dp.ua>'
			        --,@recipients = 'rumyantsev@const.dp.ua'
			        , @recipients = 'tancyura@const.dp.ua; gubiu@const.dp.ua;pravdivayav@const.dp.ua;chal@const.dp.ua'
                    , @copy_recipients = 'support_arda@const.dp.ua'
				    , @subject = @subject
				    , @body = @msg
				    , @body_format = 'HTML'
                    , @append_query_error = 1

			 
			      END TRY  
			      BEGIN CATCH
				    SELECT  
				    ERROR_NUMBER() AS ErrorNumber  
				    ,ERROR_SEVERITY() AS ErrorSeverity  
				    ,ERROR_STATE() AS ErrorState  
				    ,ERROR_PROCEDURE() AS ErrorProcedure  
				    ,ERROR_LINE() AS ErrorLine  
				    ,ERROR_MESSAGE() AS ErrorMessage; 
			      END CATCH
		
		FETCH NEXT FROM Cursor_RECADV INTO @ChID
	END
	CLOSE Cursor_RECADV
	DEALLOCATE Cursor_RECADV

END;-- if doctype = 5001

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*For comdoc_009 (Сильпо / Invoice matching)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] rkv0 '2021-07-16 14:23' добавил обработку comdoc_009 для сети Сильпо / Invoice-Matching.

IF @DocType = 7009 --For Сильпо / Invoice matching.
BEGIN

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
    SELECT ChID, ID, Notes
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 7009
	  AND [Status] IN (3)		--Новый статус
	  AND RetailersID = 14		--Сильпо
    
	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID, @ID, @Notes
	WHILE @@FETCH_STATUS = 0 --0 - The FETCH statement was successful.
    BEGIN	

      SET @filename = (SELECT [Filename] FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE chid = @ChID);
      --select @filename 
      SET @edi_guid = (SELECT SUBSTRING(PString, 1, LEN(Pstring) /*.xml*/) from dbo.[af_SplitString] (@filename, '_') WHERE Pstring like '%-%');
      --select @edi_guid 
      SET @hyperlink = 'https://edo-v2.edi-n.com/app/#/service/edi/view/' + @edi_guid + '/comdoc/aktnevidpovidnosty/fozzy';
      --select @hyperlink 

            --Отправка почтового сообщения
			BEGIN TRY 
			  SET @subject = 'СИЛЬПО (Invoice Matching) - Акт несоответствия ' + substring(@notes, CHARINDEX('№', @notes), 100) + ' по накладной № ' + @ID
			  SET @msg = '<p>' + @hyperlink + '</p>' 
              + '<p style="font-size: 14;color:red">ИНСТРУКЦИЯ: После получения Акта несоответствия необходимо отправить повторно новый документ Уведомление об отгрузке (desadv) с необходимыми изменениями. После обработки сетью будет отправлен  документ Уведомление о приеме (recadv), если все корректно, или же снова Акт несоответствия, если такие несоответствия будут выявлены.</p>'
              + '<p style="font-size: 12;color:gray"><i>[для администратора БД] Отправлено [S-PPC] JOB Workflow шаг (Import_Comdoc_009 / Import_Comdoc_009_reg_use.ps1)</i></p>'
                
              SET @body = @msg
              
              EXEC msdb.dbo.sp_send_dbmail  
			   @profile_name = 'arda'
			  --,@recipients = 'rumyantsev@const.dp.ua'
			  ,@recipients = 'jarmola@const.dp.ua;tancyura@const.dp.ua;gubiu@const.dp.ua'
              ,@copy_recipients = 'support_arda@const.dp.ua'
			  ,@subject = @subject
			  ,@body = @body
			  ,@importance = 'high'
			  ,@body_format = 'HTML'
              --,@query = @query
              --,@query_result_header = 1 --include column headers. type bit. 1 by default.
              --,@attach_query_result_as_file = 1 --type bit, with a default of 0 (message body).
              --,@query_attachment_filename = 'Данные по заказу в нашей базе.csv' --nvarchar(255); ignored when attach_query_result is 0; arbitrary filename by default.
              --,@execute_query_database = 'Elit' --only applicable if @query is specified.
              --,@query_result_separator = '; ' --type char(1). Defaults to ' ' (space).
              --,@append_query_error = 1 --bit, with a default of 0. includes the query error message in the body of the e-mail message.
              --,@query_result_no_padding = 1

			END TRY  
			BEGIN CATCH
			  SELECT  
			  ERROR_NUMBER() AS ErrorNumber  
			  ,ERROR_SEVERITY() AS ErrorSeverity  
			  ,ERROR_STATE() AS ErrorState  
			  ,ERROR_PROCEDURE() AS ErrorProcedure  
			  ,ERROR_LINE() AS ErrorLine  
			  ,ERROR_MESSAGE() AS ErrorMessage; 
			END CATCH
			
			UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
			SET [Status] = 10
			   ,LastUpdateData = GETDATE()
			WHERE ChID = @ChID
        FETCH NEXT FROM DocsLoop INTO @ChID, @ID, @Notes
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

END; 









END  






GO
