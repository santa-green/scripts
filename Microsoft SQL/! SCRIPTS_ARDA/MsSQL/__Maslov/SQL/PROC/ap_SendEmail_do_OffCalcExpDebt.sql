ALTER PROCEDURE [dbo].[ap_SendEmail_do_OffCalcExpDebt] @ChID INT = -1, @DocCode INT = -1, @WebServiceID INT = -1, @Testing INT = 0
AS
BEGIN
/*Процедура отправляет сообщение по электронной почте для исключения предприятия из проверки дебиторской задолженности.*/
	
--Pashkovv '2019-09-09 13:47:05.855' если фирма 3 то отправляем письма Капустину


/*
SETUSER 'CORP\cluster'
EXEC ap_SendEmail_do_OffCalcExpDebt @ChID = 101498650, @DocCode = 666004, @WebServiceID = 3, @Testing = 0

SELECT * FROM r_Codes4 where CodeID4 in (0,1,2,3,4,5,6,7,8,9,10,12,13,14,15,16,17,18,19,50)
*/

	PRINT 'Enter ap_SendEmail_do_OffCalcExpDebt'
	IF @ChID = -1 OR @DocCode = -1 OR @WebServiceID = -1
	BEGIN
		RETURN
	END;

	PRINT 'First IF passed'
	
	IF (SELECT CodeID4 FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @ChID) NOT IN (3, 4, 8, 9, 15) AND @Testing = 0
	BEGIN
		DECLARE @CodeID4 VARCHAR(10) = (SELECT CAST(CodeID4 AS VARCHAR(10)) FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @ChID)
		PRINT 'Check CodeID4. ChID - ' + CAST(@ChID AS VARCHAR(20)) + '; Testing - ' + CAST(@Testing AS VARCHAR(20)) + '; CodeID4 - ' + @CodeID4
		RETURN
	END;

	PRINT 'PASSED check for 3 IN codeid4'

	DECLARE @OurID INT = (SELECT OurID FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @ChID)
	DECLARE @CompID INT = (SELECT CompID FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @ChID)
	DECLARE @CompName VARCHAR(250) = (SELECT CompName FROM r_Comps WITH (NOLOCK) WHERE CompID = @CompID)
	DECLARE @DeliveryAddress VARCHAR(500) = (SELECT Address FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @ChID)
	DECLARE @DocDateV VARCHAR(20) = (SELECT CONVERT( VARCHAR, DocDate, 104) FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @ChID)
	DECLARE @DocDateV_1 VARCHAR(20) = (SELECT CONVERT( VARCHAR, DATEADD(day,-1,DocDate), 104) FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @ChID)
	DECLARE @DelAfterDate_DELIVERY DATETIME = (SELECT DATEADD(DAY ,1,DocDate) FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @ChID)
	DECLARE @DocID_tRec VARCHAR(100) = (SELECT CAST(ParentDocID AS VARCHAR(100)) FROM z_DocLinks WHERE ParentDocCode = 11221 AND ChildDocCode = 666004 AND ChildChID = @ChID)
	DECLARE @CompGrID2_Comps_DELIVERY INT = (SELECT (SELECT TOP 1 CompGrID2 FROM r_Comps c WITH (NOLOCK) WHERE c.CompID = m.CompID) FROM  at_t_IORes m WITH (NOLOCK) WHERE ChID = @ChID )
	DECLARE @CompGrID2_DELIVERY INT = (SELECT (SELECT TOP 1 CompGrID2 FROM r_CompsAdd c WITH (NOLOCK) WHERE c.CompID = m.CompID and c.CompAddID = m.CompAddID) FROM  at_t_IORes m WITH (NOLOCK) WHERE ChID = @ChID )
	DECLARE @OurID_DELIVERY INT = (SELECT OurID FROM  at_t_IORes m WITH (NOLOCK) WHERE ChID = @ChID)
	DECLARE @CompID_DELIVERY INT = (SELECT CompID FROM  at_t_IORes m WITH (NOLOCK) WHERE ChID = @ChID)
	DECLARE @STOCKID_DELIVERY INT = (SELECT StockID FROM  at_t_IORes m WITH (NOLOCK) WHERE ChID = @ChID)
	DECLARE @DOCID_DELIVERY INT = (SELECT DocID FROM  at_t_IORes m WITH (NOLOCK) WHERE ChID = @ChID)		   
	DECLARE @TERRID_DELIVERY INT = (SELECT (SELECT TOP 1 TerrID FROM r_CompsAdd c WITH (NOLOCK) WHERE c.CompID = m.CompID AND c.CompAddID = m.CompAddID) FROM  at_t_IORes m WITH (NOLOCK) WHERE ChID = @ChID )		   
	DECLARE @CompGrName2_Comps_DELIVERY VARCHAR(250) = ISNULL((SELECT TOP 1 CompGrName2 FROM r_CompGrs2 gr2 WHERE gr2.CompGrID2 = @CompGrID2_Comps_DELIVERY),'не найдена группа 2')		 
	DECLARE @CompGrName2_DELIVERY VARCHAR(250) = ISNULL((SELECT TOP 1 CompGrName2 FROM r_CompGrs2 gr2 WHERE gr2.CompGrID2 = @CompGrID2_DELIVERY),'не найдена группа 2')	
	DECLARE @PayForm VARCHAR(10) = CASE WHEN (SELECT CodeID3 FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @ChID) = 4
										THEN 'б/нал.'
										ELSE 'нал.' END
	DECLARE @PayDelay INT = (SELECT PayDelay + 2 FROM dbo.at_r_CompOurTerms WHERE OurID = @OurID AND CompID = @CompID)
	DECLARE @PayDelay2 INT = (SELECT PayDelay2 + 2 FROM dbo.at_r_CompOurTerms WHERE OurID = @OurID AND CompID = @CompID)
	DECLARE @MaxCredit NUMERIC(21,9) = 0
	DECLARE @MaxCredit2 NUMERIC(21,9) = 0
	DECLARE @SumFullReceivables1 NUMERIC(21,9) = 0
	DECLARE @SumFullReceivables2 NUMERIC(21,9) = 0
	DECLARE @SumOverdueReceivables VARCHAR(100) = (SELECT REPLACE( CAST( CAST( TSumCC AS NUMERIC(21,2)) AS VARCHAR(50)), '.', ',') FROM af_GetCompDelayBalance(GETDATE(), @CompID, 0) WHERE OurID = @OurID)

	SELECT @MaxCredit = CASE WHEN EXISTS (SELECT ISNULL(MaxCredit, 0) FROM dbo.at_r_CompOurTerms WHERE OurID = @OurID AND CompID = @CompID)
							 THEN (SELECT ISNULL(MaxCredit, 0) FROM dbo.at_r_CompOurTerms WHERE OurID = @OurID AND CompID = @CompID)
							 ELSE 0 END
		  ,@MaxCredit2 = CASE WHEN EXISTS (SELECT ISNULL(MaxCredit2, 0) FROM dbo.at_r_CompOurTerms WHERE OurID = @OurID AND CompID = @CompID)
							  THEN (SELECT ISNULL(MaxCredit2, 0) FROM dbo.at_r_CompOurTerms WHERE OurID = @OurID AND CompID = @CompID)
							  ELSE 0 END
		  ,@SumFullReceivables1 = CASE WHEN EXISTS (SELECT ISNULL(TSumCC, 0) FROM [dbo].[af_GetCompDelayBalance](DATEADD(DAY,@PayDelay,CAST(GETDATE() AS DATE) ),@CompID ,1) WHERE OurID = @OurID )
									   THEN (SELECT ISNULL(TSumCC, 0) FROM [dbo].[af_GetCompDelayBalance](DATEADD(DAY,@PayDelay,CAST(GETDATE() AS DATE) ),@CompID ,1) WHERE OurID = @OurID )
									   ELSE 0 END
		  ,@SumFullReceivables2 = CASE WHEN EXISTS (SELECT ISNULL(TSumCC, 0) FROM [dbo].[af_GetCompDelayBalance](DATEADD(DAY,@PayDelay2,CAST(GETDATE() AS DATE) ),@CompID ,2) WHERE OurID = @OurID )
									   THEN (SELECT ISNULL(TSumCC, 0) FROM [dbo].[af_GetCompDelayBalance](DATEADD(DAY,@PayDelay2,CAST(GETDATE() AS DATE) ),@CompID ,2) WHERE OurID = @OurID )
									   ELSE 0 END
	
	PRINT 'All var set'

	/*ВКЛЮЧИТЬ ОПОВЕЩЕНИЕ*/
	IF  1 = 1
	BEGIN
	  DECLARE @query VARCHAR(255) = 'SELECT ChID, DocID, DocDate, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, ExpDate, NotDate, TSumCC_wt, StateCode, Address, InDocID, OrderID, CompAddID
	  								 FROM Elit.dbo.at_t_IORes  with (nolock) WHERE ChID = ' + CAST(@ChID AS VARCHAR(10)) ;
	  DECLARE @recipients NVARCHAR(MAX), @copy_recipients NVARCHAR(MAX), @tableHTML  NVARCHAR(MAX), @subject VARCHAR(250), @body VARCHAR(MAX)
	  
	  IF @Testing = 1
	  BEGIN
	  	SET @recipients = 'maslov@const.dp.ua'
	  	SET @copy_recipients = ''
	  END;
	  ELSE
	  BEGIN
		IF @OurID = 3 --для кофейщиков (главный Капустин)
		BEGIN
			--Pashkovv '2019-09-09 13:47:05.855' если фирма 3 то отправляем письма Капустину
	  		SET @recipients = isnull((SELECT Notes FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680124  AND RefID = @CompGrID2_Comps_DELIVERY),'')
			SET @copy_recipients = (SELECT Notes FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680124 AND RefID = 0) -- доступ ко всем складам
		END
		ELSE
		BEGIN
	  		SET @recipients = (SELECT Notes FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680122 AND RefID = @CompGrID2_Comps_DELIVERY)
	  		SET @copy_recipients = (SELECT Notes FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680122 AND RefID = 0) -- доступ ко всем складам
		END

	  END;
	  
	  --Отправка почтового сообщения
	  BEGIN TRY 
		SET @subject = 'БлокировкаПр4!!! ' + CAST(@CompID AS VARCHAR(20)) + '. ф' +  CAST(@OurID as varchar(10)) + ' ЗР ' + (SELECT CAST(DocID as varchar(10)) FROM  at_t_IORes m WITH (NOLOCK) WHERE ChID = @ChID ) + ' заблокирован.' 
		SET @tableHTML = 
		N'<!DOCTYPE html>
		<html lang="ru">
		<head>
			<meta charset="windows-1251">
		</head>
		<body>
			<h2>Заказ заблокирован. Причина: "'
			+ ( SELECT CodeName4 FROM r_Codes4 WHERE CodeID4 IN (SELECT CodeID4 FROM at_t_IORes m WITH (NOLOCK) WHERE ChID = @ChID) )
			+'".</h2>
			<hr>'
			+'<p><b>Фирма:</b> '+ CAST(@OurID AS VARCHAR(10)) + '</p>'
			+'<p><b>Имя предприятия:</b> '+ @CompName + '</p>'
			+'<p><b>Адрес доставки:</b> '+ @DeliveryAddress + '</p>'
			+'<p><b>Группа предприятий 2 (для предприятия):</b> '+ CAST(@CompGrID2_Comps_DELIVERY AS VARCHAR(10)) + ' - ' + @CompGrName2_Comps_DELIVERY + '</p>'
			+'<p><b>Группа предприятий 2 (для точки):</b> '+ CAST(@CompGrID2_DELIVERY AS VARCHAR(10)) + ' - ' + @CompGrName2_DELIVERY + '</p>'
			+'<p><b>Номер заказа (ЗФ):</b> '+ @DocID_tRec + '</p>'
			+'<p><b>Дата заказа:</b> '+ @DocDateV + '</p>'
			+'<p><b>Форма расчета в заказе:</b> '+ @PayForm + '</p>'
			+'<p><b>Сумма общей ДЗ:</b> '
										 + (SELECT REPLACE( CAST( CAST( (@MaxCredit + @MaxCredit2 + @SumFullReceivables1 + @SumFullReceivables2) AS NUMERIC(21,2)) AS VARCHAR(50)), '.', ',') )
										 +' грн. (из них по б/нал: '
										 + REPLACE( CAST( CAST( (@MaxCredit + @SumFullReceivables1) AS NUMERIC(21,2)) AS VARCHAR(50)), '.', ',')
										 +' грн. (ТК - '
										 + REPLACE( CAST( CAST( (@MaxCredit) AS NUMERIC(21,2)) AS VARCHAR(50)), '.', ',')
										 +' грн.); по нал.: '
										 + REPLACE( CAST( CAST( (@MaxCredit2 + @SumFullReceivables2) AS NUMERIC(21,2)) AS VARCHAR(50)), '.', ',')
										 +' грн. (ТК - '
										 + REPLACE( CAST( CAST( (@MaxCredit2) AS NUMERIC(21,2)) AS VARCHAR(50)), '.', ',')
										 +' грн.))'
										 +'</p>'
			+'<p><b>Сумма просроч.ДЗ:</b> '+ @SumOverdueReceivables +' грн.</p>'
			+'<br/>'
			+'<p><b>Триггер необходимо снимать не ранее 10:00 в день обработки заказа: </b> '+ @DocDateV_1 +'</p>'
			--+'<p><b>EmailTo:</b> '+ @recipients +'</p>'
			+'<br/><br/>'

			--Курсор для формирования ссылок снятия проверки на предприятии.
			--Ссылки формируются на основе "Справочника универсального" номер 6680123
			DECLARE @ID INT, @URLName NVARCHAR(250), @URLs NVARCHAR(MAX) = '', @GUID VARCHAR(50) =  ''

			IF @Testing = 0
			BEGIN					
			
				SET @GUID = NEWID()

				INSERT at_WEB_Run_Script (GUID,CountRun,MaxCountRun,CreateDate,DelAfterDate,RunScript,MSG_True,DocCode, DocChID, WebServiceID, AnswerID)
				SELECT @GUID  'GUID'
					  ,0 CountRun
					  ,0 MaxCountRun
					  ,GETDATE() CreateDate
					  ,@DelAfterDate_DELIVERY DelAfterDate
					  ,'EXEC [dbo].[ap_Check_OffCalcExpDebt] @GUID = ''' + @GUID + '''' RunScript
					  ,''
					  ,@DocCode DocCode
					  ,@ChID DocChID
					  ,1000 + @WebServiceID
					  ,0 AnswerID
			END;

			SET @URLs = @URLs
					  + '<a href="http://arda.pp.ua:8000/api/default.aspx?' 
					  + @GUID
					  + '"><b>Проверка снятия триггера по просроченной ДЗ предприятия '
					  + CAST(@CompID AS VARCHAR(20))
					  + '</b></a><br/><br/>'
			
			SET @GUID = ''
			
			DECLARE URLName CURSOR LOCAL FAST_FORWARD 
			FOR 
			SELECT RefID, CAST(RefID AS VARCHAR(10)) + ' ' + RefName FROM r_Uni WHERE RefTypeID = 6680123 ORDER BY RefID
			
			OPEN URLName
					FETCH NEXT FROM URLName INTO @ID, @URLName
				WHILE @@FETCH_STATUS = 0	 
				BEGIN
						IF @Testing = 0
						BEGIN					
						
							SET @GUID = NEWID()

							INSERT at_WEB_Run_Script (GUID,CountRun,MaxCountRun,CreateDate,DelAfterDate,RunScript,MSG_True,DocCode, DocChID, WebServiceID, AnswerID)
							SELECT @GUID  'GUID'
								  ,0 CountRun
								  ,1 MaxCountRun
								  ,GETDATE() CreateDate
								  ,@DelAfterDate_DELIVERY DelAfterDate
								  ,'EXEC [dbo].[ap_OffCalcExpDebt] @CompIDs = ''' + CAST(@CompID AS VARCHAR(10)) + '''' RunScript
								  ,'Предприятие ' + CAST(@CompID AS VARCHAR(10)) + ' исключено из проверки дебиторской задолженности. Проверка будет активирована в 10:00.'
								  ,@DocCode DocCode
								  ,@ChID DocChID
								  ,@WebServiceID
								  ,@ID AnswerID
						END;

						SET @URLs = @URLs
								  + '<a href="http://arda.pp.ua:8000/api/default.aspx?' 
								  + @GUID
								  + '"><b>'
								  + @URLName
								  + '</b></a><br/><br/>'
					FETCH NEXT FROM URLName INTO @ID, @URLName
				END
			CLOSE URLName
			DEALLOCATE URLName

		SET @tableHTML = @tableHTML + @URLs +
		'</body>
		</html>'
 
			--<br/><br/>
			--<hr>
			--<br/><br/>
			--<a href="http://s-ppc.const.alef.ua:8000/api/default.aspx?' 
			--+ @GUID + '">Разблокировать заказ (для корпоративной сети)</a><br/><br/>
			--<br/><br/>
			--<a href="http://193.200.33.199:8000/api/default.aspx?' 
			--+ @GUID + '">Разблокировать заказ (для мобильных телефонов)</a><br/><br/>
			--<br/>
			
			DECLARE @temp_mail VARCHAR(200) = (SELECT CASE WHEN @CompGrID2_Comps_DELIVERY = 2031 OR @CompGrID2_Comps_DELIVERY = 2075
															   THEN 'linskiy@const.dp.ua'
														   WHEN @CompGrID2_Comps_DELIVERY IN (2030,2049,2065,2077,2093)
														       THEN 'simonov@const.dp.ua'
														   ELSE 'tumaliieva@const.dp.ua' END)

			EXEC msdb.dbo.sp_send_dbmail  
			 @profile_name = 'arda'			
			--,@recipients = 'support_arda@const.dp.ua'
			--,@recipients = @temp_mail
			,@recipients = @recipients
			,@copy_recipients = @copy_recipients
			,@subject = @subject
			,@body = @tableHTML
			,@body_format = 'HTML'
			--,@append_query_error = 1
			--,@query = @query
			--,@attach_query_result_as_file = 1 --Указывает, возвращается ли результирующий набор запроса как прикрепленный файл.
			--,@query_result_header = 0 --Указывает, включают ли результаты запроса заголовки столбцов.
			,@from_address = 'support_arda@const.dp.ua' --«адрес отправителя» сообщения электронной почты

		  END TRY  
		  BEGIN CATCH
			SELECT  
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage; 

			PRINT 'Mail ERROR'
		  END CATCH  
	  
	  IF @Testing = 0
	  BEGIN

	  	--отправка в телеграмм 
		BEGIN TRY
		
			DECLARE @textMsg VARCHAR(MAX) =  @subject + ' ' + @CompName + '%0A' 
				+ '<b>Триггер необходимо снимать не ранее 10:00 в день обработки заказа: </b> '+ @DocDateV_1 + '%0A' 
				+ REPLACE( REPLACE( REPLACE(@URLs,'<b>',''), '</b>', ''), '<br/>','%0A' ) + '&parse_mode=HTML'
				--+ cast(@DOCID_DELIVERY as varchar(10)) + ' CompID = ' + cast(@CompID_DELIVERY as varchar(10))+ '%0A'
				--+ '<a href="http://arda.pp.ua:8000/api/default.aspx?'+ @GUID + '"> Разблокировать заказ</a>' + '&parse_mode=HTML'/*+ ' HTML: '+ @tableHTML*/)
		
			EXEC [dbo].[ap_SendMsgTelegram] @chat_id = '724380520', @text = @textMsg --Отдел
				, @hesh = 0x01000000887282ED105D411FD0F958207330BEEFB97FE9B4C4285AF201C8757F6F26BC0E;

			--EXEC [dbo].[ap_SendMsgTelegram] @chat_id = '989837495', @text = @textMsg --Пашков Владимир
			--	, @hesh = 0x01000000887282ED105D411FD0F958207330BEEFB97FE9B4C4285AF201C8757F6F26BC0E;

			EXEC [dbo].[ap_SendMsgTelegram] @chat_id = '953348637', @text = @textMsg --Коцуренко Саша
				, @hesh = 0x01000000887282ED105D411FD0F958207330BEEFB97FE9B4C4285AF201C8757F6F26BC0E;
			

--для фирмы 1 RefTypeID = 6680122
			IF  @OurID = 1 AND @CompGrID2_Comps_DELIVERY IN (SELECT RefID FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680122 AND Notes like '%linskiy@const.dp.ua%')--@CompGrID2_Comps_DELIVERY = 2031 OR @CompGrID2_Comps_DELIVERY = 2075
			BEGIN			
				EXEC [dbo].[ap_SendMsgTelegram] @chat_id = '760856523', @text = @textMsg --Линский Павел
					, @hesh = 0x01000000887282ED105D411FD0F958207330BEEFB97FE9B4C4285AF201C8757F6F26BC0E;
			END;

			IF @OurID = 1 AND @CompGrID2_Comps_DELIVERY IN (SELECT RefID FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680122 AND Notes like '%martynenkon@const.dp.ua%')--(2034,2043,2064,2081,2091)
			BEGIN			
				EXEC [dbo].[ap_SendMsgTelegram] @chat_id = '625628089', @text = @textMsg --Мартыненко Наталия Викторовна
					, @hesh = 0x01000000887282ED105D411FD0F958207330BEEFB97FE9B4C4285AF201C8757F6F26BC0E;
			END;

			IF @OurID = 1 AND @CompGrID2_Comps_DELIVERY IN (SELECT RefID FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680122 AND Notes like '%trofimov@const.dp.ua%')--(2036,2063,2071,2083,2090)
			BEGIN			
				EXEC [dbo].[ap_SendMsgTelegram] @chat_id = '904846421', @text = @textMsg --Трофимов Петр Вадимович
					, @hesh = 0x01000000887282ED105D411FD0F958207330BEEFB97FE9B4C4285AF201C8757F6F26BC0E;
			END;

			IF @OurID = 1 AND @CompGrID2_Comps_DELIVERY IN (SELECT RefID FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680122 AND Notes like '%bichkova@const.dp.ua%')--(2035,2079,2084,2088,2089,2092,2094,2096)
			BEGIN			
				EXEC [dbo].[ap_SendMsgTelegram] @chat_id = '537788932', @text = @textMsg --Бычкова Алена Геннадьевна
					, @hesh = 0x01000000887282ED105D411FD0F958207330BEEFB97FE9B4C4285AF201C8757F6F26BC0E;
			END;
			
--для фирмы 3 RefTypeID = 6680124
			IF @OurID = 3 --AND @CompGrID2_Comps_DELIVERY IN (SELECT RefID FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680124 AND Notes like '%kapustin@const.dp.ua%' )
			BEGIN			
				EXEC [dbo].[ap_SendMsgTelegram] @chat_id = '460529079', @text = @textMsg --Капустин Илья
					, @hesh = 0x01000000887282ED105D411FD0F958207330BEEFB97FE9B4C4285AF201C8757F6F26BC0E;
			END;

			IF @OurID = 3 AND @CompGrID2_Comps_DELIVERY IN (SELECT RefID FROM r_Uni WITH (NOLOCK) WHERE RefTypeID = 6680124 AND Notes like '%avramenkoap@const.dp.ua%' )
			BEGIN			
				EXEC [dbo].[ap_SendMsgTelegram] @chat_id = '469642523', @text = @textMsg --Авраменко Антон
					, @hesh = 0x01000000887282ED105D411FD0F958207330BEEFB97FE9B4C4285AF201C8757F6F26BC0E;
			END;
						
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

	  END;		
	
	END
END;