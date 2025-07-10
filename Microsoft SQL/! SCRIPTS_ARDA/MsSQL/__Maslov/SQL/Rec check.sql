SELECT m.DocID 'Номер', m.DocDate 'Дата', m.OurID 'Фирма', m.StockID 'Склад', d.ProdID 'Код товара', tp.PPID 'Партия', tp.ProdDate 'Дата товара'
FROM t_Rec m
JOIN t_RecD d WITH (NOLOCK) ON d.ChID = m.ChID
JOIN t_PInP tp WITH (NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
WHERE m.DocDate <> tp.ProdDate
	  AND m.CompID != 80
	  AND m.DocDate > '20190301' --AND m.DocDate < '20190331'	  
ORDER BY 2

/*
SELECT * FROM t_Rec
WHERE ChID = 34336

SELECT top 10 * FROM t_RecD
*/



--запускать в интервале времени
IF (CONVERT (time, GETDATE()) > '03:00:00' AND CONVERT (time, GETDATE()) < '03:59:00') AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- с Пн по Пт 
	OR 1 = 1
--#1 IF (CONVERT
BEGIN

--Если дата локумента (DocDate) в "Приход товара" не равна дате товара (ProdDate) в партии товара
IF EXISTS (SELECT TOP 1 1
				FROM t_Rec m
				JOIN t_RecD d WITH (NOLOCK) ON d.ChID = m.ChID
				JOIN t_PInP tp WITH (NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
					WHERE m.DocDate != tp.ProdDate
						  AND m.CompID != 80
						  AND m.DocDate > '20190301'
		   )
--#2 IF EXISTS
BEGIN

  --Отправка почтового сообщения
  BEGIN TRY 
		DECLARE @SQL_query nvarchar(max) = 'USE ElitR; SELECT CAST((''Номер'' + CHAR(9) + ''Дата'' + CHAR(9) + ''Фирма'' + CHAR(9) + ''Склад'' + CHAR(9) + ''Код товара'' + CHAR(9) + ''Партия'' + CHAR(9) + ''Дата товара'') AS VARCHAR(80)) UNION ALL SELECT CAST( (CAST(m.DocID AS VARCHAR(50)) + CHAR(9) + CONVERT(VARCHAR, m.DocDate, 20) + CHAR(9) + CAST(m.OurID  AS VARCHAR(50))+ CHAR(9) + CAST(m.StockID AS VARCHAR(50)) + CHAR(9) + CAST(d.ProdID AS VARCHAR(50)) + CHAR(9) + CAST(tp.PPID AS VARCHAR(50)) + CHAR(9) + CONVERT(VARCHAR, tp.ProdDate, 20)) AS VARCHAR(80)) FROM t_Rec AS m JOIN t_RecD d WITH (NOLOCK) ON d.ChID = m.ChID JOIN t_PInP tp WITH (NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID WHERE m.DocDate <> tp.ProdDate AND m.CompID <> 80 AND m.DocDate > ''20190301'''
		DECLARE @body_str nvarchar(max) = 'В документе "Приход товара" обнаружены расхождение даты документа и даты партии товара, детали во вложеном файле.' + char(13)
										+ 'Документы с предприятием 80 исключены.' + char(13) 
										+ 'Отправленно [S-SQL-D4] JOB ELITR Checking шаг 9 (Проверка "Приход товара")'
		select @body_str

		SELECT @SQL_query
		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'main',
		@from_address = '<support_arda@const.dp.ua>',
		--@recipients = 'rovnyagina@const.dp.ua; support_arda@const.dp.ua',  
		@recipients = 'maslov@const.dp.ua',   
		@body = @body_str,  
		@subject = 'Проверка "Приход товара"',
		@body_format = 'TEXT'--'HTML'
		,@query = @SQL_query
		,@query_result_header=0
		,@query_no_truncate= 0 -- не усекать запрос
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
END --#2 IF EXISTS 

END --#1 IF (CONVERT