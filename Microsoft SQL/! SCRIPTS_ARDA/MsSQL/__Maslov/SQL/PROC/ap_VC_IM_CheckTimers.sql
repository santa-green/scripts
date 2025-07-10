ALTER PROCEDURE [dbo].[ap_VC_IM_CheckTimers] @api_l VARCHAR(500) = '', @key VARCHAR(500) = '', @RegionID INT = -1, @admin_adress VARCHAR(500) = '', @Test INT = 0
AS
BEGIN
/*
Проверка таймеров товаров в интернет-магазине (дальше ИМ).

Brevis descriptio
Скрипт выкачивает метаполя по всем акционным товарам. Если до нужного метаполя
ТРИЖДЫ не получилось достучатся, то его ставим на обновление (устанавливаем
статус 5) и переходим к следующему товару.

*/

/*
EXEC ap_VC_IM_CheckTimers @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 1, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1

--'2020-03-20 10:29:33.300' Старый блок процедур. Он использовался в те времена, когда ИМ был разделен на три сайта.
EXEC ap_VC_IM_CheckTimers @api_l = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID = 1, @admin_adress = 'vintagemarket-dp.myshopify.com', @Test = 1
EXEC ap_VC_IM_CheckTimers @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1
EXEC ap_VC_IM_CheckTimers @api_l = '822ee75ea06b63718ec6422bd0b77748', @key = 'c2bb7455131d0c407d241170acd20e58', @RegionID = 5, @admin_adress = 'vintagemarket-kh.myshopify.com', @Test = 1
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[FIXED] Maslov Oleg '2019-11-25 10:19:52.007' Выносим процедуру в отдельный шаг джоба, потому что если запускать ее из другой процедуры, то она начинает вытягивать не те данные.
--[FIXED] Maslov Oleg '2020-01-09 10:51:48.488' При работе процедуры в джобе ответ, который возвращает API, режется до 512 символов.
			--то есть по умолчанию стоит "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
--[CHANGED] Maslov Oleg '2020-01-29 11:29:33.828' Перевод процедуры на версию API '2020-01'.
--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Если сейчас НЕ 3 или 4 часа утра И время выделенное для региона не попадает в промежуток, то выход. 
IF NOT (
		   (SELECT DATEPART(HOUR, GETDATE() )) IN (3,4)
		   AND (   (SELECT DATEPART(MINUTE, GETDATE() )) BETWEEN 0 AND 9 AND @RegionID = 1
				OR (SELECT DATEPART(MINUTE, GETDATE() )) BETWEEN 20 AND 29 AND @RegionID = 2
				OR (SELECT DATEPART(MINUTE, GETDATE() )) BETWEEN 40 AND 49 AND @RegionID = 5       
			   )
		)
	AND @Test = 0
BEGIN
	RETURN
END;

--Ниже идет предварительная настройка временных таблиц и объявление переменных.

--Maslov Oleg '2020-01-09 10:51:48.488' При работе процедуры в джобе ответ, который возвращает API, режется до 512 символов.
    --то есть по умолчанию стоит "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
SET TEXTSIZE 2147483647;
SET NOCOUNT ON

IF @api_l = '' OR @key = '' OR @RegionID = -1
BEGIN
	RETURN;
END;

IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(XML VARCHAR(MAX))

IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
CREATE TABLE #shopi_ids
(ShopifyID BIGINT
,ProdID BIGINT)

DECLARE @temp TABLE (res VARCHAR(MAX))

DECLARE	@URI VARCHAR(3000)
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

--И еще демонизм. Потому что потому.
IF @Test = 1
BEGIN
	SET @for_proxy = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000014DBC39169721A1CC037D82C2C82AF60EA2DB4A2727EDD9040D5AFD5A589187C )))
END;

DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)

DECLARE @SQL_Select NVARCHAR(MAX), @table_id INT, @IM_table VARCHAR(100), @av VARCHAR(100), @outs VARCHAR(50)

--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
SELECT @IM_table = 'r_ShopifyProds'--(SELECT RefName FROM r_Uni WHERE RefTypeID = 1000000015 AND RefID = @RegionID)
      ,@table_id = (SELECT OBJECT_ID('tempdb..#shopi_ids') )

--Выбираем все акционные товары в таблице с нулевым статусом.
SET @SQL_Select = 'INSERT INTO '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ' SELECT ShopifyID, ProdID FROM '
				+ @IM_table
				--+ ' WHERE ProdID =  602145'
				+ ' WHERE DiscountActive = 1 AND UpdateState = 0'

EXEC sp_executesql @SQL_Select

DECLARE @ShopifyID BIGINT = NULL
	   ,@EndDate DATE = NULL
	   ,@try_counter INT = 0

WHILE (SELECT COUNT(*) FROM #shopi_ids)	!= 0 
BEGIN
	
	IF @ShopifyID IS NULL --Если первый проход.
	   OR NOT EXISTS(SELECT 1 FROM #shopi_ids WHERE ShopifyID = @ShopifyID) --Если предыдущий товар ушел из таблицы, то берем следующий.
	BEGIN
		SELECT @ShopifyID = (SELECT TOP 1 ShopifyID FROM #shopi_ids), @try_counter = 0
	END;	

	--Maslov Oleg '2020-01-29 11:29:33.828' Перевод процедуры на версию API '2020-01'.
	--Формируем особый URL-адрес, который достанет метаполя товара.  
	SELECT 
	       --@URI = @site + '/admin/api/2019-04/products/'
	       @URI = @site + '/admin/api/2020-01/products/'
				+ CAST(@ShopifyID AS VARCHAR (50))
				+ '/metafields.xml'
		  ,@methodName = 'GET'
		  ,@proxy = '2' 
		  ,@proxySettings = '10.1.0.16:8080'

	--Здесь вытягивается ID метаполя.
	IF 1 = 1
	BEGIN
			IF 	@methodName = ''
			BEGIN
				select FailPoINT = 'Method Name must be set'
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
			EXEC 	@hResult = sp_OAMethod @objectID, 'send', null
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

	--Дальше обрабатываем полученный ответ. И получаем ID метаполя товара.
	INSERT INTO #xml
	SELECT * FROM @temp

	DECLARE @metaf TABLE (MetaFields XML)

	INSERT INTO @metaf
	SELECT CAST(XML AS XML) FROM #xml

	--Вытягиваем из метаполя дату, которая сейчас установлена в ИМ.
	SELECT @EndDate = CAST( REPLACE( CAST (mt.query('data(value)') AS VARCHAR(20)), '-', '' ) AS DATE)
	FROM @metaf m CROSS APPLY m.MetaFields.nodes('metafields/metafield') met(mt)
	WHERE (CAST (mt.query('data(key)') AS VARCHAR(100)) ) = 'discountDeadline'
	  AND (CAST ( (CAST (mt.query('data(owner-id )') AS VARCHAR(100)) ) AS BIGINT) ) = @ShopifyID
	
	--Если дата есть, то проверяем совпадает ли она с датой в базе.
	  --Если даты совпадают, то удаляем товар из временной таблицы и устанавливаем счетчик в ноль.
	IF @EndDate IS NOT NULL
	BEGIN
		IF EXISTS(SELECT 1
				  FROM #shopi_ids m
				  JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID(@RegionID)
				  WHERE m.ShopifyID = @ShopifyID
				    AND @EndDate != CAST( DATEADD(DAY, 1, rpmp.EDate) AS DATE)
				 )
		BEGIN
			SET @SQL_Select = 'UPDATE '
							+ @IM_table
							+ ' SET UpdateState = 5 WHERE ShopifyID = '
							+ CAST(@ShopifyID AS VARCHAR(20))

			EXEC sp_executesql @SQL_Select
		END;

		DELETE #shopi_ids WHERE ShopifyID = @ShopifyID
		SELECT @EndDate = NULL, @try_counter = 0
	END;
	
	--Если даты не совпадают (не получилось достать метаполе), то увеличиваем счетчик попыток на 1 и пробуем снова достать метаполе.
	IF EXISTS(SELECT 1 FROM #shopi_ids WHERE ShopifyID = @ShopifyID)
	BEGIN
		SET @try_counter = @try_counter + 1
		
		--После трех попыток "достучаться" до метаполя ставим товару статус 5 и
		--переходим к следующему товару.
		IF @try_counter >= 3
		BEGIN
		    SET @SQL_Select = 'UPDATE '
							+ @IM_table
							+ ' SET UpdateState = 5 WHERE ShopifyID = '
							+ CAST(@ShopifyID AS VARCHAR(20))

			EXEC sp_executesql @SQL_Select

			DELETE #shopi_ids WHERE ShopifyID = @ShopifyID
		END;
	END;	

	DELETE #xml
	DELETE @temp
	DELETE @metaf
	
	--Раскомментировать блок, чтобы отслеживать прогресс.
	--DECLARE  @str VARCHAR(30) = (SELECT CAST(COUNT(*) AS VARCHAR(10)) FROM #shopi_ids)
    --RAISERROR ('%s ', 10,1,@str) WITH NOWAIT
END

global_destroy:
IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml

END;