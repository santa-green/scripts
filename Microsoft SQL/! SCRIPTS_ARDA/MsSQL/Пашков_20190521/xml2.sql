
DECLARE @ID INT
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT ID FROM dbo.at_SendXML WITH (NOLOCK)
WHERE [Status] = 0 OR [Status] IS NULL OR [Status] != 50

OPEN CURSOR1 
FETCH NEXT FROM CURSOR1 INTO @ID
WHILE @@FETCH_STATUS = 0
BEGIN

	UPDATE dbo.at_SendXML SET [Status] = 10 WHERE ID = @ID --файл взят в работу на отправку

	IF OBJECT_ID('tempdb.dbo.##temp') IS NOT NULL    DROP TABLE ##temp

	SELECT top 1 xml val
	 INTO ##temp
	FROM dbo.at_SendXML WHERE ID = @ID

	--  SELECT * FROM dbo.at_SendXML
	--  SELECT * FROM ##temp

	--определение CompID
	DECLARE @xml XML, @Str_CompID varchar(20), @attachment_filename varchar(50),@subject varchar(250)
	SET @xml = (SELECT top 1  xml FROM  dbo.at_SendXML where id = @ID)
	SELECT top 1  @Str_CompID = t.c.value('VALUE[1]', 'INT')
	FROM @xml.nodes('CARD/DOCUMENT/ROW[@NAME = "TAB1_A12"]') t(c)
	--  SELECT  @Str_CompID 

	SET @attachment_filename = @Str_CompID + '_' + cast(isnull((SELECT top 1 chid FROM  dbo.at_SendXML where id = @ID),0) as varchar) + '.xml'
	SET @subject = 'Автоматическая отправка файла: ' + @Str_CompID + '_' + cast(isnull((SELECT top 1 chid FROM  dbo.at_SendXML where id = @ID),0) as varchar)

	--DECLARE @sql NVARCHAR(4000) = 'bcp "SELECT * FROM ##temp" queryout "\\s-sql-d4.corp.local\OT38ElitServer\Import\XML\' + cast(@ID as varchar) + '.xml" -S ' + @@servername + ' -T -w -r -t'
	--EXEC sys.xp_cmdshell @sql

	BEGIN TRY  
		DECLARE @SQL_query nvarchar(max) = 'SET NOCOUNT ON; SELECT val FROM ##temp; SET NOCOUNT OFF;'
		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'main',  
		@recipients = 'pashkovv@const.dp.ua',  
		@body = '',  
		@subject = @subject,
		@body_format = 'HTML'
		,@query = @SQL_query
		,@query_result_header=0
		--,@exclude_query_output=1
		,@query_no_truncate= 1 -- не усекать запрос
		,@query_attachment_filename= @attachment_filename
		--,@file_attachments='\\s-sql-d4.corp.local\OT38ElitServer\Import\XML\test.xml',
		,@attach_query_result_as_file= 1 -- 1 возвращается результирующий набор запроса как прикрепленный файл
		;
		
		UPDATE dbo.at_SendXML SET [Status] = 50 WHERE ID = @ID --Успешно отправлен
		UPDATE dbo.at_SendXML SET Notes = 'Файл отправлен.' WHERE ID = @ID --отчет в примечание
	END TRY  
	BEGIN CATCH 
		UPDATE dbo.at_SendXML SET [Status] = 20 WHERE ID = @ID --ошибка при отправке
		UPDATE dbo.at_SendXML SET Notes = CAST(ERROR_MESSAGE() as varchar(230)) + CAST(ERROR_NUMBER() as varchar(20)) WHERE ID = @ID --ошибку в примечание
		
		SELECT  
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage; 
	END CATCH
		
	IF OBJECT_ID('tempdb.dbo.##temp') IS NOT NULL   DROP TABLE ##temp
		
	FETCH NEXT FROM CURSOR1	INTO @ID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1


