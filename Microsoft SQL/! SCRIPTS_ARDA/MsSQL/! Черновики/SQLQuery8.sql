IF @DocType = 24000 --For status.
BEGIN

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 24000
	  AND [Status] IN (3,4)				--Новый статус
	  AND Notes LIKE 'COMDOC%'			--Только по COMDOC
	  AND Notes NOT LIKE '%успешно%'	--Если пришло что-то кроме хороших статусов.
	  AND RetailersID = 17154			--Розетка
    
	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	
            DECLARE @orderid varchar(128) = (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID)       
            --Отправка почтового сообщения
			BEGIN TRY 
            -- [ADDED] rkv0 '2020-10-27 18:35' добавляю данные к письму (заявка #380).
/*			  DECLARE @query varchar(max) = 
                    'SET NOCOUNT ON; SELECT TOP(1) ti.CompID ''№ предприятия'', rc.CompName ''Контора'', ti.TaxDocID ''№ налоговой'', ti.TaxDocDate ''Дата налоговой'', ti.OrderID ''№ заказа'', ti.DocID ''№ документа'', ti.TSumCC_wt ''Сумма с НДС, грн'' FROM t_Inv ti
                    JOIN r_Comps rc ON rc.CompID = ti.Compid
                    WHERE ti.OrderID = ' + '''' + cast(@orderid as varchar) + '''';
*/            
            --SET @subject = 'Статус по заказу ' + CAST( (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) AS VARCHAR)
			  SET @subject = 'РОЗЕТКА - Статус по заказу ' + CAST( @orderid AS VARCHAR) + ' => ' + (SELECT TOP 1 Notes
			                          FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
			                            	WHERE ChID = @ChID
			                          ORDER BY ChID DESC)

			  SET @msg = '<p style="font-size: 12;color:gray"><i>Отправлено [S-PPC] JOB Workflow шаг 1 (Import_Status / Import_Status_reg_use.ps1)</i></p>'
            
            DECLARE @xml varchar(max)
            SET @xml = CAST((
               SELECT 
                    ti.CompID 'td', ' ',
                    rc.CompName 'td', ' ',
                    ti.TaxDocID 'td', ' ',
                    CONVERT(varchar, ti.TaxDocDate, 104) 'td', ' ', --https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
                    ti.OrderID 'td', ' ',
                    ti.DocID 'td', ' ',
                    ti.TSumCC_wt 'td', ' '
                    FROM t_Inv ti
                    JOIN r_Comps rc ON rc.CompID = ti.Compid
                    WHERE ti.OrderID = @orderid
                    FOR XML PATH('tr'), ELEMENTS)
                as nvarchar(max)
                ) 

            DECLARE @body varchar(max) --https://htmlcolorcodes.com/
            SET @body = '<html>
                <head>
                <style>
                    table{border: 2px solid blue, border-collapse: collapse; background-color: #f1f1c1} th,td{text-align: center}
                </style>
                </head>
                <body>
                <table border = "3" bordercolor="#ec7f34"> 
                    <tr>
                        <th> № предприятия </th> 
                        <th> Контора </th>
                        <th> № налоговой </th>
                        <th> Дата налоговой </th>
                        <th> № заказа </th>
                        <th> № документа в Бизнесе </th>
                        <th> Сумма с НДС </th>
                    </tr>'

            SET @body = @body + @xml + '</table>' + @msg + '</body> </html>'


              EXEC msdb.dbo.sp_send_dbmail  
			   @profile_name = 'arda'
              -- [FIXED] '2020-03-11 11:08' rkv0 вместо "," нужно ";"
			  ,@recipients = 'jarmola@const.dp.ua;tancyura@const.dp.ua'
			  --,@recipients = 'rumyantsev@const.dp.ua'
--[CHANGED] rkv0 '2020-08-21 14:01' изменил адрес на arda_servicedesk@const.dp.ua (сразу в заявки).
--[CHANGED] rkv0 '2020-10-27 17:14' изменил обратно на support_arda@const.dp.ua (учет будет отправлять на Розетку РН через печатку).
              ,@copy_recipients = 'support_arda@const.dp.ua'
              --@copy_recipients = 'arda_servicedesk@const.dp.ua', 
			  ,@subject = @subject
			  ,@body = @body
			  ,@body_format = 'HTML'
-- [ADDED] rkv0 '2020-10-27 18:35' добавляю данные к письму (заявка #380).
              --,@query = @query
              --,@query_result_header = 1 --include column headers. type bit. 1 by default.
              --,@attach_query_result_as_file = 1 --type bit, with a default of 0 (message body).
              --,@query_attachment_filename = 'Данные по заказу в нашей базе' --nvarchar(255); ignored when attach_query_result is 0; arbitrary filename by default.
              --,@execute_query_database = 'Elit' --only applicable if @query is specified.
              --,@query_result_separator = '--' --type char(1). Defaults to ' ' (space).
              ,@append_query_error = 1 --bit, with a default of 0. includes the query error message in the body of the e-mail message.


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
		
		FETCH NEXT FROM DocsLoop INTO @ChID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

END; -- if doctype = 24000
