ALTER PROCEDURE [dbo].[ap_VC_Sync_Email] (@Test INT = 0, @Email VARCHAR(50) = '')
AS
BEGIN
/*
@Test = 0 - рабочий режим;
@Test = 1 - отправка сообщения на почту указанную в @Email;
@Test = 2 - не отправляем сообщения, вывод всех частей письма;
*/

/*
EXEC ap_VC_Sync_Email @Test = 2
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ADDED] Maslov Oleg '2020-04-14 10:53:11.746' Добавил название процедуры, от которой приходят сообщения.
--[FIXED] Maslov Oleg '2020-04-29 10:22:17.493' Теперь если какая-нибудь из частей будет равна NULL, то все тело письма не превратиться в пустоту.
--[ADDED] Maslov Olege '2020-04-29 10:36:04.975' Если к заказу привязан промокод, то он отправляется в письме.
--[ADDED] Maslov Oleg '2020-05-14 18:06:28.004' Добавил Задорожнего в рассылку заказов Днепра.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET NOCOUNT ON 

--Если новых заказов нет, то выход. 
IF NOT EXISTS (SELECT 1 FROM t_IMOrders WHERE Status = 3)
BEGIN
  RETURN;
END;
 
--Variable block near.
DECLARE @subject VARCHAR(250) = ''
 	   ,@rec VARCHAR(250) = ''
       ,@tableHTML NVARCHAR(MAX) = N''
       ,@tempHTML NVARCHAR(MAX) = N''
	   ,@RegionID INT = 0	

DECLARE @ShopifyOrderID BIGINT
DECLARE SendMsg CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT DISTINCT ShopifyOrderID FROM t_IMOrders WHERE Status = 3

OPEN SendMsg
	FETCH NEXT FROM SendMsg INTO @ShopifyOrderID
WHILE @@FETCH_STATUS = 0	 
BEGIN
		IF @Test = 0
		BEGIN
			--Статус 4 - это значит, что мы пытались отправить сообщение о заказе.
			UPDATE t_IMOrders SET Status = 4 WHERE ShopifyOrderID = @ShopifyOrderID
		END;


		SELECT @subject = 'Новый заказ в интернет-магазине № '
						+ CAST( (SELECT TOP 1 DocID - (10000000*RegionID) - 1000000 FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID) AS VARCHAR(10))
						+ ' #ИМ_Заказ'
			  ,@tableHTML = N'<p><b>№ заказа на сайте: </b>' + CAST( (SELECT TOP 1 DocID - (10000000*RegionID) - 1000000 FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID) AS VARCHAR(10)) + N';</p>'
						  + N'<p><b>ФИО: </b>' + (SELECT TOP 1 Recipient FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID) + N';</p>'
					      + N'<p><b>Адрес: </b>' + (SELECT TOP 1 Address FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID) + N';</p>'
					      + N'<p><b>Дата: </b>' + (SELECT TOP 1 CONVERT( VARCHAR(10), DocDate, 104) FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID) + N'.</p>'
						  --[ADDED] Maslov Olege '2020-04-29 10:36:04.975' Если к заказу привязан промокод, то он отправляется в письме.
						  + CASE WHEN (SELECT TOP 1 ShopifyDiscCodes FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID) != ''
									THEN N'<p><b>На заказ действует промокод: </b>' + (SELECT TOP 1 ShopifyDiscCodes FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID) + N';</p>'
									ELSE N'' END
			  --Для тестов.
			  --,@rec = 'maslov@const.dp.ua'
			  ,@rec = CASE @Test
							 WHEN 0 THEN 'vintage.market.order@gmail.com;support_arda@const.dp.ua'
							 WHEN 1 THEN @Email
							 ELSE '' END

		SELECT @tableHTML = @tableHTML
						  + N'<p><b>Весь заказ:</b></p>'
						  + N'<table border="1"><tr>'
						  + N'<th>Код товара</th><th>Наименование</th><th>Кол-во</th></tr>'
						  + CAST ( (SELECT td = CAST(d.ProdID AS VARCHAR), ''
								    	   ,td = rp.ProdName, ''
								    	   ,td = CAST( SUM(d.Qty) AS VARCHAR), ''
								    FROM t_IMOrdersD d
								    LEFT JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
								    WHERE d.DocID IN (SELECT DocID FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID)
								    GROUP BY d.ProdID, rp.ProdName
									ORDER BY d.ProdID ASC, SUM(d.Qty) ASC
								    FOR XML PATH('tr'), TYPE
								   )
								   AS NVARCHAR(MAX)
								 )
						  + N'</table>';
		
		IF @Test = 2
		BEGIN
			SELECT 'Заголовок', @tableHTML
		END;

		--Если в заказе есть доля Днепра.
		IF EXISTS(SELECT 1 FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID AND RegionID = 1)
		BEGIN
			
			SELECT @RegionID = 1
				  --[ADDED] Maslov Oleg '2020-05-14 18:06:28.004' Добавил Задорожнего в рассылку заказов Днепра.
				  ,@rec = @rec + CASE @Test WHEN 0 THEN ';trushliakova@const.dp.ua;vintagednepr1@const.dp.ua;zadorozhniy@const.dp.ua' ELSE '' END
			
			--[FIXED] Maslov Oleg '2020-04-29 10:22:17.493' Теперь если какая-нибудь из частей будет равна NULL, то все тело письма не превратиться в пустоту.
			SELECT @tempHTML = N'<table border="1"><tr>'
							 + N'<th>Код товара</th><th>Наименование</th><th>Кол-во</th><th>Хранилище</th></tr>'
							 + CAST ( ( SELECT td= CAST(d.ProdID AS VARCHAR), '',
							 				   td= rp.ProdName, '',
							 				   td= SUBSTRING(CAST(d.Qty AS VARCHAR), 1, CHARINDEX('.', CAST(d.Qty AS VARCHAR))-1 ), '',
							 				   td= ru.RefName + CASE WHEN ru.RefID = 6
							 				   							THEN ' (1200)'
							 				   						  WHEN ru.RefID = 3
							 				   							THEN ' (1201)'
							 				   						  ELSE '' END      
							 				   FROM at_t_IORes m
							 				   JOIN t_IMOrders timo WITH(NOLOCK) ON timo.DocID = m.DocID
							 				   JOIN at_t_IOResD d WITH(NOLOCK) ON d.ChID = m.ChID
							 				   JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
							 				   JOIN r_Uni ru WITH(NOLOCK) ON ru.RefID = d.StorageID AND ru.RefTypeID = 1000000003
							 				   WHERE m.DocID = (SELECT DocID FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID AND RegionID = @RegionID)
							 				   ORDER BY d.ProdID, d.Qty
							 				   FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) )
							 + N'</table>';

			SELECT @tableHTML = @tableHTML 
							  + N'<p> </p><p><b>Часть Днепра в "Заказе внутреннем: Резерве" № '
							  + (SELECT CAST(DocID AS NVARCHAR) FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID AND RegionID = @RegionID)
							  + N':</b></p>'
							  + ISNULL(@tempHTML, N'<p>Ошибка! Детальная часть пустая.</p>');
		    
			SET @tempHTML = N'';
		END;

		IF @Test = 2
		BEGIN
			SELECT 'После Днепра', @tableHTML
		END;

		--Если в заказе есть доля Киева.
		IF EXISTS(SELECT 1 FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID AND RegionID = 2)
		BEGIN
			
			SELECT @RegionID = 2
				  ,@rec = @rec + CASE @Test WHEN 0 THEN ';kuzmuk@const.dp.ua' ELSE '' END
			
			SELECT @tempHTML = N'<table border="1"><tr>'
							 + N'<th>Код товара</th><th>Наименование</th><th>Кол-во</th></tr>'
							 + CAST ( ( SELECT td= CAST(d.ProdID AS VARCHAR), '',
											   td= rp.ProdName, '',
											   td= SUBSTRING(CAST(d.Qty AS VARCHAR), 1, CHARINDEX('.', CAST(d.Qty AS VARCHAR))-1 ), ''   
											  FROM at_t_IORes m
											  JOIN t_IMOrders timo WITH(NOLOCK) ON timo.DocID = m.DocID
											  JOIN at_t_IOResD d WITH(NOLOCK) ON d.ChID = m.ChID
											  JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
											  JOIN r_Uni ru WITH(NOLOCK) ON ru.RefID = d.StorageID AND ru.RefTypeID = 1000000003
											  WHERE m.DocID = (SELECT DocID FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID AND RegionID = @RegionID)
											  ORDER BY d.ProdID, d.Qty
											  FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) )  
							 + N'</table>';

			SELECT @tableHTML = @tableHTML
							  + N'<p> </p><p><b>Часть Киева в "Заказе внутреннем: Резерве" № '
							  + (SELECT CAST(DocID AS NVARCHAR) FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID AND RegionID = @RegionID)
							  + N':</b></p>'
							  + ISNULL(@tempHTML, N'<p>Ошибка! Детальная часть пустая.</p>');
			
			SET @tempHTML = N'';				    
		END;
		
		IF @Test = 2
		BEGIN
			SELECT 'После Киева', @tableHTML
		END;

		--Если в заказе есть доля Харькова.
		IF EXISTS(SELECT 1 FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID AND RegionID = 5)
		BEGIN

			SELECT @RegionID = 5
			      ,@rec = @rec + CASE @Test WHEN 0 THEN ';pogrebnyak@const.dp.ua;vintageharkov1@const.dp.ua' ELSE '' END
			
			SELECT @tempHTML = N'<table border="1"><tr>'
							 + N'<th>Код товара</th><th>Наименование</th><th>Кол-во</th></tr>'
							 + CAST ( ( SELECT td= CAST(d.ProdID AS VARCHAR), '',
											   td= rp.ProdName, '',
											   td= SUBSTRING(CAST(d.Qty AS VARCHAR), 1, CHARINDEX('.', CAST(d.Qty AS VARCHAR))-1 ), ''   
											  FROM at_t_IORes m
											  JOIN t_IMOrders timo WITH(NOLOCK) ON timo.DocID = m.DocID
											  JOIN at_t_IOResD d WITH(NOLOCK) ON d.ChID = m.ChID
											  JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
											  JOIN r_Uni ru WITH(NOLOCK) ON ru.RefID = d.StorageID AND ru.RefTypeID = 1000000003
											  WHERE m.DocID = (SELECT DocID FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID AND RegionID = @RegionID)
											  ORDER BY d.ProdID, d.Qty
											  FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) )  
							 + N'</table>';

			SELECT @tableHTML = @tableHTML
							  + N'<p> </p><p><b>Часть Харькова в "Заказе внутреннем: Резерве" № '
							  + (SELECT CAST(DocID AS NVARCHAR) FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID AND RegionID = @RegionID)
							  + N':</b></p>'
							  + ISNULL(@tempHTML, N'<p>Ошибка! Детальная часть пустая.</p>');
			
			SET @tempHTML = N'';  
		END;

		IF @Test = 2
		BEGIN
			SELECT 'После Харькова', @tableHTML
		END;

		SELECT @tableHTML = @tableHTML
						  + N'<p><b>Свободные остатки перед созданием заказа:</b></p>'
						  + N'<table border="1"><tr>'
						  + N'<th>Код товара</th><th>Наименование</th><th>Скл. 1200</th><th>Скл. 1200 рез.</th><th>Скл. 1201</th><th>Скл. 1201 рез.</th><th>Скл. 730</th><th>Скл. 730 рез.</th><th>Скл. 731</th><th>Скл. 731 рез.</th><th>Скл. 1252</th><th>Скл. 1252 рез.</th>'
						  + N'</tr>'
						  + CAST ( (SELECT td = CAST(d.ProdID AS VARCHAR), ''
								    	  ,td = rp.ProdName, ''
										  --1200
								    	  ,td = ISNULL(SUBSTRING(CAST( (tDp0.Qty-tDp0.AccQty) AS VARCHAR), 1, CHARINDEX('.', CAST((tDp0.Qty-tDp0.AccQty) AS VARCHAR))-1 ), '0'), '' 
								    	  ,td = ISNULL(SUBSTRING(CAST(tDp0.AccQty AS VARCHAR), 1, CHARINDEX('.', CAST(tDp0.AccQty AS VARCHAR))-1 ), '0'), '' 
										  --1201
								    	  ,td = ISNULL(SUBSTRING(CAST( (tDp1.Qty-tDp1.AccQty) AS VARCHAR), 1, CHARINDEX('.', CAST( (tDp1.Qty-tDp1.AccQty) AS VARCHAR))-1 ), '0'), '' 
								    	  ,td = ISNULL(SUBSTRING(CAST(tDp1.AccQty AS VARCHAR), 1, CHARINDEX('.', CAST(tDp1.AccQty AS VARCHAR))-1 ), '0'), '' 
										  --730
								    	  ,td = ISNULL(SUBSTRING(CAST( (tKv0.Qty-tKv0.AccQty) AS VARCHAR), 1, CHARINDEX('.', CAST( (tKv0.Qty-tKv0.AccQty) AS VARCHAR))-1 ), '0'), '' 
								    	  ,td = ISNULL(SUBSTRING(CAST(tKv0.AccQty AS VARCHAR), 1, CHARINDEX('.', CAST(tKv0.AccQty AS VARCHAR))-1 ), '0'), '' 
										  --731
								    	  ,td = ISNULL(SUBSTRING(CAST( (tKv1.Qty-tKv1.AccQty) AS VARCHAR), 1, CHARINDEX('.', CAST( (tKv1.Qty-tKv1.AccQty) AS VARCHAR))-1 ), '0'), '' 
								    	  ,td = ISNULL(SUBSTRING(CAST(tKv1.AccQty AS VARCHAR), 1, CHARINDEX('.', CAST(tKv1.AccQty AS VARCHAR))-1 ), '0'), ''
										  --1252
								    	  ,td = ISNULL(SUBSTRING(CAST( (tKh0.Qty-tKh0.AccQty) AS VARCHAR), 1, CHARINDEX('.', CAST( (tKh0.Qty-tKh0.AccQty) AS VARCHAR))-1 ), '0'), '' 
								    	  ,td = ISNULL(SUBSTRING(CAST(tKh0.AccQty AS VARCHAR), 1, CHARINDEX('.', CAST(tKh0.AccQty AS VARCHAR))-1 ), '0'), '' 
									FROM (SELECT DISTINCT ProdID FROM t_IMOrdersD WHERE DocID IN (SELECT DocID FROM t_IMOrders WHERE ShopifyOrderID = @ShopifyOrderID) ) d
									LEFT JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
									LEFT JOIN _t_RemIM tDp0 WITH(NOLOCK) ON tDp0.ProdID = d.ProdID AND tDp0.StockID = 1200
									LEFT JOIN _t_RemIM tDp1 WITH(NOLOCK) ON tDp1.ProdID = d.ProdID AND tDp1.StockID = 1201
									LEFT JOIN _t_RemIM tKv0 WITH(NOLOCK) ON tKv0.ProdID = d.ProdID AND tKv0.StockID = 730
									LEFT JOIN _t_RemIM tKv1 WITH(NOLOCK) ON tKv1.ProdID = d.ProdID AND tKv1.StockID = 731
									LEFT JOIN _t_RemIM tKh0 WITH(NOLOCK) ON tKh0.ProdID = d.ProdID AND tKh0.StockID = 1252
									ORDER BY d.ProdID
								    FOR XML PATH('tr'), TYPE
								   )
								   AS NVARCHAR(MAX)
								 )
						  + N'</table>'
						  --[ADDED] Maslov Oleg '2020-04-14 10:53:11.746' Добавил название процедуры, от которой приходят сообщения.
						  --+ N'<p>Отправленно от [ElitR].[dbo].[ap_VC_Sync_Email]</p>';
						  + N'<p>Отправленно от [ap_VC_Sync_Email]</p>';
		
		IF @Test = 2
		BEGIN
			SELECT 'После добавления остатков', @tableHTML
		END;
		
		IF @Test != 2
		BEGIN		
			--Отправка почтового сообщения
			BEGIN TRY

				EXEC msdb.dbo.sp_send_dbmail  
				@profile_name = 'arda',  
				@recipients = @rec,  
				@subject = @subject,
				@body = @tableHTML,  
				@body_format = 'HTML'
				--,@query = 'SELECT * FROM tempdb..#TOrders; SELECT * FROM tempdb..#TOrdersD';

				--Если сообщение отправлено и ошибок нет, то устанавливаем статус 1.
				UPDATE t_IMOrders SET Status = 1 WHERE ShopifyOrderID = @ShopifyOrderID

			END TRY  
			BEGIN CATCH

				SELECT ERROR_NUMBER() AS ErrorNumber  
					  ,ERROR_SEVERITY() AS ErrorSeverity  
					  ,ERROR_STATE() AS ErrorState  
					  ,ERROR_PROCEDURE() AS ErrorProcedure  
					  ,ERROR_LINE() AS ErrorLine  
					  ,ERROR_MESSAGE() AS ErrorMessage; 

			END CATCH
	    END;

	FETCH NEXT FROM SendMsg INTO @ShopifyOrderID
END
CLOSE SendMsg
DEALLOCATE SendMsg


END