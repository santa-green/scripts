ALTER PROCEDURE [dbo].[ap_VC_IM_SetDiscountTimer] @api_l VARCHAR(500) = '', @key VARCHAR(500) = '', @RegionID INT = -1, @admin_adress VARCHAR(500) = '', @Test INT = 0
AS
BEGIN
/*
Установка времени окончания акции по товару.

Brevis descriptio
Скрипт обновляет метаполе товара, которое называется discountDeadline - оно отвечает
за дату окончания акции товара. Скрипт вытягивает ID метаполя, после чего обновляет его.

*/

/*
EXEC ap_VC_IM_SetDiscountTimer @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1

--'2020-03-20 10:29:33.300' Старый блок процедур. Он использовался в те времена, когда ИМ был разделен на три сайта.
EXEC ap_VC_IM_SetDiscountTimer @api_l = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID = 1, @admin_adress = 'vintagemarket-dp.myshopify.com', @Test = 1
EXEC ap_VC_IM_SetDiscountTimer @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1
EXEC ap_VC_IM_SetDiscountTimer @api_l = '822ee75ea06b63718ec6422bd0b77748', @key = 'c2bb7455131d0c407d241170acd20e58', @RegionID = 5, @admin_adress = 'vintagemarket-kh.myshopify.com', @Test = 1
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[FIXED] Maslov Oleg '2020-01-09 10:51:48.488' При работе процедуры в джобе ответ, который возвращает API, режется до 512 символов.
     --то есть по умолчанию стоит "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
--[CHANGED] Maslov Oleg '2020-01-29 17:30:58.155' Перевод процедуры на версию API '2020-01'. Здесь два места!
--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Ниже идет предварительная настройка временных таблиц и объявление переменных.

--[FIXED] Maslov Oleg '2020-01-09 10:51:48.488' При работе процедуры в джобе ответ, который возвращает API, режется до 512 символов.
    --то есть по умолчанию стоит "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
SET TEXTSIZE 2147483647;
SET NOCOUNT ON

IF @api_l = '' OR @key = '' OR @RegionID = -1
BEGIN
	RETURN;
END;

DECLARE @URI VARCHAR(3000)
	   ,@methodName VARCHAR(50)
	   ,@proxy VARCHAR(50) 
	   ,@proxySettings VARCHAR(50)
	   ,@objectID INT
	   ,@hResult INT
	   ,@source VARCHAR(255)
	   ,@desc VARCHAR(255)
	   ,@count FLOAT
	   ,@login_proxy VARCHAR(200) = 'CONST\vintageshopify'
	   ,@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000068D4AB26848B654D3149C9EC9E19CBD586F805D3F10AFE5B9C9F516E87CE330A )))
	   --,@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID INT = 1--dnepr = 1
	   ,@site VARCHAR(3000) = 'https://' + @api_l + ':' + @key + '@' + @admin_adress

--Фигли-мигли, мазафака! И все работает как надо.
IF @Test = 1
BEGIN
	SET @for_proxy = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000014DBC39169721A1CC037D82C2C82AF60EA2DB4A2727EDD9040D5AFD5A589187C)))
END;

DECLARE @SQL_Select NVARCHAR(MAX), @table_id INT, @IM_table VARCHAR(100), @av VARCHAR(100), @outs VARCHAR(50)

--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
SELECT @IM_table = 'r_ShopifyProds'--(SELECT RefName FROM r_Uni WHERE RefTypeID = 1000000015 AND RefID = @RegionID)

SET @SQL_Select = 'IF (SELECT COUNT(*) FROM '
				+ @IM_table
				+ ' m WHERE m.UpdateState = 5) <= 0 BEGIN SELECT @out = 0 END;'

EXEC sp_executesql @SQL_Select, N'@out VARCHAR(50) OUT', @outs OUT 

IF 
/*Если по какой-либо причине был установлен UpdateState = 5.*/
--(SELECT COUNT(*) FROM r_ShopifyProdsDp WHERE UpdateState = 5) <= 0
(SELECT CAST(@outs AS INT) ) = 0
BEGIN
	RETURN
END;

IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(XML VARCHAR(MAX))

IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
CREATE TABLE #shopi_ids
(ShopifyID BIGINT)

SELECT @table_id = (SELECT OBJECT_ID('tempdb..#shopi_ids') )

SET @SQL_Select = 'INSERT INTO '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ' SELECT ShopifyID FROM '
				+ @IM_table
				+ ' WHERE UpdateState = 5'

EXEC sp_executesql @SQL_Select

DECLARE @temp TABLE (res VARCHAR(MAX))

DECLARE @ShopifyID BIGINT
	   ,@MetafieldID BIGINT
	   ,@EndDate SMALLDATETIME

DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)

--Далее работает курсор, который будет обнавлять дату окончания акции с помощью PUT.
DECLARE TIMER CURSOR LOCAL FAST_FORWARD 
FOR
--Ограничение по сто товаров за раз. Оно нужно, потому что по не исследованным причинам
--иногда вытягиваются не корректные ID метаполей.
SELECT TOP 100 ShopifyID
FROM #shopi_ids
--FROM r_ShopifyProdsDp
--WHERE UpdateState = 5
ORDER BY NEWID()

OPEN TIMER
	FETCH NEXT FROM TIMER INTO @ShopifyID
WHILE @@FETCH_STATUS = 0	 
BEGIN

	--Maslov Oleg '2020-01-29 17:30:58.155' Перевод процедуры на версию API '2020-01'.
	--Формируем особый URL-адрес, который достанет метаполя товара. 
	SELECT 
		   --@URI = @site + '/admin/api/2019-04/products/'
		   @URI = @site + '/admin/api/2020-01/products/'
				  + CAST(@ShopifyID AS VARCHAR (50))
				  +'/metafields.xml'
		  ,@methodName = 'GET'
		  ,@proxy = '2' 
		  ,@proxySettings = '10.1.0.16:8080'

	--Здесь вытягивается ID метаполя.
	IF 1 = 1
	BEGIN
			IF @methodName = ''
			BEGIN
				SELECT FailPoINT = 'Method Name must be set'
				RETURN
			END 

			--Создаем объект, для запроса.
			EXEC @hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT

			IF @hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'Create failed',
						MedthodName = @methodName
				GOTO meta_destroy
				RETURN
			END

			-- open the destination URI with Specified method
			EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URI, 'false'
			IF @hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
					source = @source, 
					description = @desc,
					FailPoINT = 'Open failed',
					MedthodName = @methodName
				GOTO meta_destroy
				RETURN
			END

			-- Особый хэдер URL-запроса для Shopify, для того, чтобы обойти аутентификацию.
			EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'X-Shopify-Access-Token', @key
			IF @hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
					source = @source, 
					description = @desc,
					FailPoINT = 'SetRequestHeader failed: Content-Type',
					MedthodName = @methodName
				GOTO meta_destroy
				RETURN
			END

			/*Устанавливаем логин и пароль для прокси-сервера.*/
			EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, @login_proxy, @for_proxy, 1
			IF @hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
					source = @source, 
					description = @desc,
					FailPoINT = 'setProxyCredentials failed',
					MedthodName = @methodName
				GOTO meta_destroy
				RETURN
			END

			--Делаем так, чтобы URL-запрос пошел через прокси-сервер.
			EXEC @hResult = sp_OAMethod @objectID, 'setProxy', NULL,  @proxy, @proxySettings
			IF @hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
					source = @source, 
					description = @desc,
					FailPoINT = 'SetProxy'
				GOTO meta_destroy
				RETURN
			END
		
			--Отправляем запрос.
			EXEC @hResult = sp_OAMethod @objectID, 'send', null
			IF 	@hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
					source = @source, 
					description = @desc,
					FailPoINT = 'Send failed',
					MedthodName = @methodName
				GOTO meta_destroy
				RETURN
			END

			-- Get status text
			EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText out 
			EXEC sp_OAGetProperty @objectID, 'Status', @status out

			-- Get response text
			INSERT INTO @temp
				 EXEC sp_OAGetProperty @objectID, 'responseText'

			IF @hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
					source = @source, 
					description = @desc,
					FailPoINT = 'ResponseText failed',
					MedthodName = @methodName
				GOTO meta_destroy
				RETURN
			END

			meta_destroy:
			EXEC sp_OADestroy @objectID
	END;

	--Удаляем мусор.
	UPDATE @temp SET res = REPLACE(res, '<?xml version="1.0" encoding="UTF-8"?>', '');

	--Дальше обрабатываем полученный ответ. И получаем VariantID для товара.
	INSERT INTO #xml
	SELECT * FROM @temp

	DECLARE @metaf TABLE (MetaFields XML)

	INSERT INTO @metaf
	SELECT CAST(XML AS XML) FROM #xml

	SELECT @MetafieldID = CAST( CAST (mt.query('data(id)') AS VARCHAR(20)) AS BIGINT)
	FROM @metaf m CROSS APPLY m.MetaFields.nodes('metafields/metafield') met(mt) --) q
	WHERE (CAST (mt.query('data(key)') AS VARCHAR(100)) ) = 'discountDeadline'

	--Не нашел метаполе? Сделай сам! Следующая проверка таймеров сделает все как надо.
	IF NOT EXISTS(	SELECT CAST( CAST (mt.query('data(id)') AS VARCHAR(20)) AS BIGINT)
					FROM @metaf m CROSS APPLY m.MetaFields.nodes('metafields/metafield') met(mt) --) q
					WHERE (CAST (mt.query('data(key)') AS VARCHAR(100)) ) = 'discountDeadline'
			     )
	BEGIN
	    --SELECT @key, @RegionID, @admin_adress, @ShopifyID, @Test

		EXEC ap_VC_IM_CreateMetafield @key = @key, @RegionID = @RegionID,  @admin_adress =  @admin_adress, @ShopifyID = @ShopifyID, @Test = @Test

		GOTO next_prod
	END;

	--Отладочная выборка. 
	--SELECT CAST( CAST (mt.query('data(id)') AS VARCHAR(20)) AS BIGINT)
	--	  --,@EndDate = CONVERT(SMALLDATETIME, CAST (mt.query('data(value)') AS VARCHAR(20)) )
	--	  ,(CAST (mt.query('data(key)') AS VARCHAR(100)) )
	--FROM @metaf m CROSS APPLY m.MetaFields.nodes('metafields/metafield') met(mt) --) q
	--WHERE (CAST (mt.query('data(key)') AS VARCHAR(100)) ) = 'discountDeadline'

				--Тестовое решение проблемы неккоректного ID метаполя.
				--IF (SELECT 1 FROM r_ShopifyProdsDp m
				--		JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID(@RegionID)
				--		WHERE m.ShopifyID = @ShopifyID
				--			  AND @EndDate NOT BETWEEN rpmp.BDate AND rpmp.EDate
				--	) = 1
				BEGIN --Начало выгрузки времени окончания акции
				
				--Берем определенный товар и его Metafield.
				DELETE #xml
				SELECT
					 --@URI = @site + '/admin/api/2019-04/products/'
					 @URI = @site + '/admin/api/2020-01/products/'
							+ CAST(@ShopifyID AS VARCHAR(50)) + '/metafields/' + CAST(@MetafieldID AS VARCHAR(50)) + '.xml'
					,@methodName = 'PUT'
					,@proxy = '2'
					,@proxySettings = '10.1.0.16:8080'

				IF @methodName = ''
				BEGIN
					SELECT FailPoINT = 'Method Name must be set'
					RETURN
				END 

				--Создаем объект, для запроса.
				EXEC @hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT


				IF @hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
							source = @source, 
							description = @desc,
							FailPoINT = 'Create failed',
							MedthodName = @methodName
					GOTO destroy
					RETURN
				END

				-- open the destination URI with Specified method
				EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URI, 'false'
				IF @hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'Open failed',
						MedthodName = @methodName
					GOTO destroy
					RETURN
				END

				--set Credentials
				EXEC @hResult = sp_OAMethod @objectID, 'SetCredentials', null, @api_l, @key, 0
				IF @hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'SetCredentials failed',
						MedthodName = @methodName
					GOTO destroy
					RETURN
				END

				-- set request headers
				EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'text/xml'
				IF @hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'SetRequestHeader failed: Content-Type',
						MedthodName = @methodName
					GOTO destroy
					RETURN
				END

				/*Устанавливаем логин и пароль для прокси-сервера.*/
				EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, @login_proxy, @for_proxy, 1
				IF @hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'setProxyCredentials failed',
						MedthodName = @methodName
					GOTO destroy
					RETURN
				END

				--Делаем так, чтобы URL-запрос пошел через прокси-сервер.
				EXEC @hResult = sp_OAMethod @objectID, 'setProxy', NULL,  @proxy, @proxySettings
				IF @hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'SetProxy'
					GOTO destroy
					RETURN
				END

				SET @SQL_Select = 'SELECT @out = CONVERT(VARCHAR, DATEADD(DAY, 1, rpmp.EDate), 23) FROM '
								+ @IM_table
								+ ' m JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID('
								+ (SELECT CAST(@RegionID AS VARCHAR (5) ) )
								+ ') WHERE m.ShopifyID = '
								+ (SELECT CAST(@ShopifyID AS VARCHAR (50) ) )

				EXEC sp_executesql @SQL_Select, N'@out VARCHAR(50) OUT', @outs OUT 

				--Здесь формируется XML, который будет вложен в URL-запрос.
				DECLARE @put VARCHAR(8000) = '<metafield><value>'
											 --+ (SELECT CONVERT(VARCHAR, DATEADD(DAY, 1, rpmp.EDate), 23) FROM r_ShopifyProdsDp m JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID(@RegionID) WHERE m.ShopifyID = @ShopifyID )
											 + CASE WHEN @Test = 1
													 THEN CONVERT(VARCHAR, DATEADD(DAY, 20, GETDATE()), 23)
													 ELSE @outs END
											 + '</value></metafield>'
				--Отправляем запрос.
				EXEC 	@hResult = sp_OAMethod @objectID, 'send', null, @put
				IF 	@hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'Send failed',
						MedthodName = @methodName
					GOTO destroy
					RETURN
				END

				-- Get status text
				EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText out 
				EXEC sp_OAGetProperty @objectID, 'Status', @status out 

				-- Get response text
				INSERT INTO #xml
					 EXEC sp_OAGetProperty @objectID, 'responseText'
			
				IF 
				   --Если статус отправки успешный.
				   (SELECT CAST(@status AS INT)) = 200
				   AND
				   --Если нет ошибок.
				   NOT EXISTS(SELECT 1 FROM #xml WHERE XML LIKE '%error%') 
				BEGIN
					SET @SQL_Select = 'UPDATE '
									+ @IM_table
									+ ' SET UpdateDate = GETDATE(), UpdateState = 0	WHERE ShopifyID = '
									+ (SELECT CAST(@ShopifyID AS VARCHAR(100)) )

					EXEC sp_executesql @SQL_Select

					--UPDATE r_ShopifyProdsDp SET UpdateDate = GETDATE(), UpdateState = 0 WHERE ShopifyID = @ShopifyID
				END;

				IF @hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'ResponseText failed',
						MedthodName = @methodName
					GOTO destroy
					RETURN
				END

				destroy:
					EXEC sp_OADestroy @objectID
				END;--Конец выгрузки времени окончания акции

	DELETE #xml
	DELETE @temp 
	DELETE @metaf
	SELECT @MetafieldID = 0
--Переходим в конец, если нужно было создать метаполе. В следующий раз таймер обновится.
next_prod:

	FETCH NEXT FROM TIMER INTO @ShopifyID
END
CLOSE TIMER
DEALLOCATE TIMER

global_destroy:
IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml

END;