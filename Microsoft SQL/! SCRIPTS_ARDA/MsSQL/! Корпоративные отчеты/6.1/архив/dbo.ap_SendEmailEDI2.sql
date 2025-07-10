USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_SendEmailEDI]    Script Date: 21.01.2020 18:05:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_SendEmailEDI] @DocType INT = -1, @delay INT = 0, @text VARCHAR(500) = ''
AS
BEGIN

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

IF @DocType = 5000 --For recadv email.
BEGIN

DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 5000 AND Status = 11 AND InsertData < (DATEADD(DAY, -1, GETDATE()))

	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	

	SELECT @DocID = ID, @Status = Status
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
					UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 16 WHERE ChID = @ChID
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
	WHERE DocType = 5000 AND (Status = 16 OR Status = 11)

	OPEN DocsLoop2
		FETCH NEXT FROM DocsLoop2 INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	

	IF (SELECT DocSum FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) = (SELECT SUM(d.Qty / ISNULL(rpmq.Qty, 1) ) FROM t_Inv m JOIN t_InvD d ON d.ChID = m.ChID JOIN r_ProdMQ rpmq ON rpmq.ProdID = d.ProdID WHERE rpmq.UM = 'метро/един.' AND m.OrderID = (SELECT Notes FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) )
	BEGIN
		UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 10, LastUpdateData = GETDATE() WHERE ChID = @ChID
	END;

		FETCH NEXT FROM DocsLoop2 INTO @ChID
	END
	CLOSE DocsLoop2
	DEALLOCATE DocsLoop2 
END;-- if doctype = 5000

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

IF @DocType = 7012 --For comdoc_012 email.
BEGIN

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 7012 AND Status BETWEEN 9 AND 16 AND InsertData < (DATEADD(DAY, @delay, GETDATE()))

	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	
	
	SELECT @CompID = CompID, @DocID = ID, @Status = Status
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE ChID = @ChID

				SET @temp = (
							  (SELECT top 1 (SELECT (SELECT isnull(EMail,'') mail FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
							  FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where CompID = @CompID)
			       		    )

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
					UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 41, LastUpdateData = GETDATE() WHERE ChID = @ChID
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
	WHERE DocType = 7012 AND (Status = 18 OR Status = 12)
		  AND ( (SELECT DATEDIFF(d, LastUpdateData, GETDATE())) >= 7) --Time at days, when 012 comdoc will have second chanse.

	OPEN CheckLoop
		FETCH NEXT FROM CheckLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	

	SET @SQL_Select = 'SELECT @out = (SELECT ISNULL((SUM (TSumCC_wt)),0) FROM t_Ret WHERE ' + (SELECT Notes FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID)  + ' AND TaxDocID != 0' + ')'
	EXEC SP_EXECUTESQL @SQL_Select, N'@out VARCHAR(200) OUT', @ans OUT

		IF (SELECT DocSum FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) = @ans
		BEGIN
		UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files SET Status = 19, LastUpdateData = GETDATE() WHERE ChID = @ChID
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

IF @DocType = 8000 --For Declar RPL.
BEGIN

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 8000
	  AND Status IN (1)				    --Новый статус

	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	
			--Отправка почтового сообщения
			BEGIN TRY 
			  SET @subject = 'Пришла не принятая налоговая квитанция ' + CAST( (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) AS VARCHAR)
			  SET @msg = '<p>' + (SELECT TOP 1 FileName
			                          FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
			                            	WHERE ChID = @ChID
			                          ORDER BY ChID DESC) + '</p>'
			            + '<p>Отправлено [S-PPC] JOB Workflow шаг 1 (Import_Status / Import_Status_reg_use.ps1)</p>'
			
			  EXEC msdb.dbo.sp_send_dbmail  
			  @profile_name = 'arda',  
			  @recipients = 'support_arda@const.dp.ua',  
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
			
			UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
			SET Status = 4
			   ,LastUpdateData = GETDATE()
			WHERE ChID = @ChID
		
		FETCH NEXT FROM DocsLoop INTO @ChID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

END; -- if doctype = 8000

IF @DocType = 24000 --For status.
BEGIN

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 24000
	  AND Status IN (3,4)				--Новый статус
	  AND Notes LIKE 'COMDOC%'			--Только по COMDOC
	  AND Notes NOT LIKE '%успешно%'	--Если пришло что-то кроме хороших статусов.
	  AND RetailersID = 17154			--Розетка

	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	
			--Отправка почтового сообщения
			BEGIN TRY 
			  SET @subject = 'Статус по заказу ' + CAST( (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) AS VARCHAR)
			  SET @msg = '<p>' + (SELECT TOP 1 Notes
			                          FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
			                            	WHERE ChID = @ChID
			                          ORDER BY ChID DESC) + '</p>'
			            + '<p>Отправлено [S-PPC] JOB Workflow шаг 1 (Import_Status / Import_Status_reg_use.ps1)</p>'
			
			  EXEC msdb.dbo.sp_send_dbmail  
			  @profile_name = 'arda',  
			  @recipients = 'jarmola@const.dp.ua, tancyura@const.dp.ua',  
              @copy_recipients = 'support_arda@const.dp.ua', 
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
			
			UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
			SET Status = 10
			   ,LastUpdateData = GETDATE()
			WHERE ChID = @ChID
		
		FETCH NEXT FROM DocsLoop INTO @ChID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

END; -- if doctype = 24000

IF @DocType = 644505 --For FTP messages.
BEGIN
				BEGIN TRY 
				
				SET @msg = '<p>Файл: ' + @text + ' не был отправлен на FTP.</p>' 
						 + '<p>Отправлено [S-PPC] JOB Workflow шаг 14-15 (SendToFtp, SendToFTP_autosend) ap_SendEmailEDI</p>'
							
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

END  





GO
