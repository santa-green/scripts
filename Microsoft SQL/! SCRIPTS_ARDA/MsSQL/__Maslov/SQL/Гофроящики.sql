--если есть "Гофроящики", у которых нет ед. измерения "ящ." в виде упаковок
IF EXISTS (
SELECT rp.ProdID FROM r_Prods rp
JOIN r_ProdMQ rpmq WITH(NOLOCK) ON rp.ProdID = rpmq.ProdID
WHERE rp.ProdName LIKE '%Гофроящик%' 
AND rpmq.UM NOT IN ('ящ.')
AND rp.ProdID NOT IN (SELECT rpmq.ProdID FROM r_Prods rp
JOIN r_ProdMQ rpmq WITH(NOLOCK) ON rp.ProdID = rpmq.ProdID
WHERE rp.ProdName LIKE '%Гофроящик%' AND rpmq.UM IN ('ящ.'))
			)
BEGIN
  --Отправка почтового сообщения
  BEGIN TRY 
	DECLARE @subject varchar(250), @body varchar(max), @tableHTML  NVARCHAR(MAX) 
	SET @subject = 'Гофроящик, в котором отсутсвует ед. изм. "ящ."'
	SET @tableHTML =  
		N'</table>' +  
		N'<H1>Гофроящики</H1>' +  
		N'<table border="1">' +
		N'<tr><th>ProdID</th><th>ProdName</th>' +  
		CAST ( ( 
		SELECT td=rp.ProdID,'',td=rp.ProdName FROM r_Prods rp
		JOIN r_ProdMQ rpmq WITH(NOLOCK) ON rp.ProdID = rpmq.ProdID
		WHERE rp.ProdName LIKE '%Гофроящик%' 
		AND rpmq.UM NOT IN ('ящ.')
		AND rp.ProdID NOT IN (SELECT rpmq.ProdID FROM r_Prods rp
		JOIN r_ProdMQ rpmq WITH(NOLOCK) ON rp.ProdID = rpmq.ProdID
		WHERE rp.ProdName LIKE '%Гофроящик%' AND rpmq.UM IN ('ящ.'))
		ORDER BY rp.ProdID FOR XML PATH('tr'), TYPE) AS NVARCHAR(MAX) ) +  
		N'</table>' ;  
	select @tableHTML
	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'main',
	--@recipients = 'maslov@const.dp.ua',--для теста  
	@recipients = 'maslov@const.dp.ua', 
	@copy_recipients = 'pashkovv@const.dp.ua',--; rovnyagina@const.dp.ua; reshetnyak@const.dp.ua;strigakova@const.dp.ua', 
	@subject = @subject,
	@body = @tableHTML,  
	@body_format = 'HTML'
	-------------------,@query = 'SELECT * FROM tempdb..#TOrders; SELECT * FROM tempdb..#TOrdersD'; 
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


/*
--запускать процедуру в интервале времени
IF (CONVERT (time, GETDATE()) > '17:00:00' 
    AND CONVERT (time, GETDATE()) < '18:00:00') 
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



--запускать процедуру в интервале времени
IF (CONVERT (time, GETDATE()) > '09:00:00' 
    AND CONVERT (time, GETDATE()) < '18:00:00') 
    AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- с Пн по Пт
BEGIN

--если есть отрицательные остатки по партиям по складу 1200 то отправить почту
IF EXISTS (SELECT 1 FROM t_Rem WITH (NOLOCK) WHERE OurID = 6 and StockID = 1200 and Qty < 0)
  --Отправка почтового сообщения
  BEGIN TRY 
	DECLARE @subject varchar(250), @body varchar(max), @tableHTML  NVARCHAR(MAX) 
	SET @subject = 'Внимание!!! На складе 1200 отрицательные остатки.Это нарушает работу интернет магазина'
	SET @tableHTML =  
		N'</table>' +  
		N'<H1>Текущие остатки</H1>' +  
		N'<table border="1">' +
		N'<tr><th>OurID</th><th>StockID</th>' +  
		N'<th>SecID</th><th>ProdID</th><th>PPID</th>' +  
		N'<th>Qty</th><th>AccQty</th><th>ProdName</th></tr>' +  
		CAST ( ( SELECT  td=r.OurID, '', td=r.StockID,'', td=r.SecID, '',td=r.ProdID, '',td=r.PPID,'', td=r.Qty,'', td=r.AccQty 
		,'',td=(SELECT top 1 ProdName FROM r_Prods p WITH (NOLOCK) where p.ProdID = r.ProdID)
		FROM t_Rem r WITH (NOLOCK) where OurID = 6 and StockID = 1200 and Qty < 0 ORDER BY ProdID,PPID FOR XML PATH('tr'), TYPE) AS NVARCHAR(MAX) ) +  
		N'</table>' ;  
	select @tableHTML
	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'main',
	--@recipients = 'pashkovv@const.dp.ua',--для теста  
	@recipients = 'zadorozhniy@const.dp.ua;trushliakova@const.dp.ua', 
	@copy_recipients = 'pashkovv@const.dp.ua; rovnyagina@const.dp.ua; reshetnyak@const.dp.ua;strigakova@const.dp.ua', 
	@subject = @subject,
	@body = @tableHTML,  
	@body_format = 'HTML'
	-------------------,@query = 'SELECT * FROM tempdb..#TOrders; SELECT * FROM tempdb..#TOrdersD'; 
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
*/