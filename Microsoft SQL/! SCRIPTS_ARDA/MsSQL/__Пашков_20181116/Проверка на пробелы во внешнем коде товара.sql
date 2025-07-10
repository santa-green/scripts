--запускать процедуру в интервале времени
IF (CONVERT (time, GETDATE()) > '17:00:00' 
    AND CONVERT (time, GETDATE()) < '18:0:00') 
    AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- с Пн по Пт
BEGIN

--если есть отрицательные остатки по партиям по складу 1200 то отправить почту
IF EXISTS (SELECT ProdID, CompID, ExtProdID FROM Elit.dbo.r_ProdEC ec where  ExtProdID like '% %')
  --Отправка почтового сообщения
  BEGIN TRY 
		DECLARE @SQL_query nvarchar(max) = 'SELECT ProdID ''Код товара'', CompID ''Предприятие'', ExtProdID ''Внешний код товара'' FROM Elit.dbo.r_ProdEC ec where  ExtProdID like ''% %'';'
		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'main',  
		@recipients = 'pashkovv@const.dp.ua;tumaliieva@const.dp.ua',  
		@body = '',  
		@subject = 'в поле внешний код справочника товаров есть пробелы',
		@body_format = 'TEXT'--'HTML'
		,@query = @SQL_query
		,@query_result_header=1
		--,@exclude_query_output=1
		,@query_no_truncate= 0 -- не усекать запрос
		--,@query_attachment_filename= @attachment_filename
		--,@file_attachments='\\s-sql-d4.corp.local\OT38ElitServer\Import\XML\test.xml',
		,@attach_query_result_as_file= 1 -- 1 возвращается результирующий набор запроса как прикрепленный файл
		;

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

END



