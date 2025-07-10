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

BEGIN
/*
*/
    UPDATE [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] SET [Status] = 0 WHERE doctype = 70121 and InsertData >= '20210101' and chid in (75882, 79042);

    DECLARE @id varchar(128);
    DECLARE @date date;
    DECLARE @docsum numeric(21, 9);
    DECLARE @hyperlink varchar(max);
    DECLARE @edi_guid varchar(100);
    DECLARE @filename varchar(255);
    
    DECLARE cursor_foodcom_email CURSOR LOCAL FAST_FORWARD FOR
    SELECT ChID FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE doctype = 70121 and [Status] = 0 and InsertData >= '20210101';
    
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
            
            SELECT * FROM #html WITH(NOLOCK) 

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
                --,@recipients = 'tancyura@const.dp.ua;vasilenkov@const.dp.ua;volotovskiy@const.dp.ua'
                ,@recipients = 'rumyantsev@const.dp.ua'
                --,@copy_recipients  = 'support_arda@const.dp.ua;rumyantsev@const.dp.ua' --rumyantsev@const.dp.ua оставить, т.к. есть проблемы с правилами в outlook.
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
