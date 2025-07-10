ALTER PROCEDURE [dbo].[ap_VC_IM_CheckProc] @api_l VARCHAR(500) = '', @key VARCHAR(500) = '', @RegionID INT = -1, @admin_adress VARCHAR(500) = '', @Test INT = 0
AS
BEGIN
/*
Проверка цен, поиск товаров на удаление, обновления таймеров, поиск несовпадений кодов товаров, проверка остатков
в интернет-магазине (ИМ тут и дальше).

Brevis descriptio
В этой процедуре скачивается информация по всем товарам, после чего она сравнивается
с ценой в реестре и если они не совпадают, то ставится статус перезаписи.
Дальше проверяется корректность кода товара (всегда прав ИМ). Если в ИМ один код,
а в таблице товаров другой, то товар получает статус 7 и с этого момента не 
учавствует в обновлении цен и остатков. Как только в таблице товаров будет установлен
правильный код товара и статус будет установлен в 0, то все будет работать.
После проверяем InventoryID, который используется для слива остатков.
Каждый день за полчаса до полуночи, если нужно, выравниваем остатки в интернет-магазине.

LOL:
сообщение: 1205, уровень: 13, состояние: 45, процедура: TRel2_Upd_t_SaleC, строка: 105 [строка начала пакета: 69]
Транзакция (идентификатор процесса 78) вызвала взаимоблокировку ресурсов блокировка с другим процессом и стала жертвой взаимоблокировки. Запустите транзакцию повторно.
*/

/*
EXEC ap_VC_IM_CheckProc @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 1, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1
EXEC ap_VC_IM_CheckProc @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1
EXEC ap_VC_IM_CheckProc @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 5, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1

--'2020-03-20 10:29:33.300' Старый блок процедур. Он использовался в те времена, когда ИМ был разделен на три сайта.
EXEC ap_VC_IM_CheckProc @api_l = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID = 1, @admin_adress = 'vintagemarket-dp.myshopify.com', @Test = 1
EXEC ap_VC_IM_CheckProc @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1
EXEC ap_VC_IM_CheckProc @api_l = '822ee75ea06b63718ec6422bd0b77748', @key = 'c2bb7455131d0c407d241170acd20e58', @RegionID = 5, @admin_adress = 'vintagemarket-kh.myshopify.com', @Test = 1
*/

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ADDED] Maslov Oleg '2019-11-18 09:31:10.537' Ускоряем работу джоба. Сокращаем количество проверок в половину.
--[ADDED] Maslov Oleg '2019-11-25 10:16:25.536' Теперь будем проверять таймера всех активных акционных товаров несколько раз в день в отдельном шаге джоба.
--[FIXED] Maslov Oleg '2020-01-09 10:51:48.488' При работе процедуры в джобе ответ, который возвращает API, режется до 512 символов.
			--то есть по умолчанию стоит "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
--[CHANGED] Maslov Oleg '2020-01-29 09:14:23.842' Перевод процедуры на версию API '2020-01'. Здесь два места!
--[CHANGED] Maslov Oleg '2020-02-19 10:17:14.817' Убираем из проверки дубликаты. WHERE UpdateState != 9
--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
--[CHANGED] Maslov Oleg '2020-04-06 10:10:22.447' Остатки на складах все чаще не совпадают. Значит нужно увеличить количество проверок.
--[FIXED] Maslov Oleg '2020-05-07 13:50:36.333' Пока не знаю почему, но старый метод получения "VariantID" выдает ошибку (Target string size is too small to represent the XML instance). Перешел на новый.
--[FIXED] Maslov Oleg '2020-05-08 14:50:26.444' Внезапно в ИМ появился товар у которого количество null, что, естественно, ломает нам шаг проверки. 
--[CHANGED] Maslov Oleg '2020-06-05 09:31:47.160' Теперь в случае не совпадения кода товара в базе и в ИМ, берем за основу код товара из ИМ и ставми его в базу.
--[CHANGED] Maslov Oleg '2020-07-01 10:54:56.605' Перенос API-запроса в процедуру.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF (@api_l = '' OR @key = '' OR @RegionID = -1 OR @admin_adress = '')
   --[ADDED] Maslov Oleg '2019-11-18 09:31:10.537' Ускоряем работу джоба. Сокращаем количество проверок в половину.
   OR (   DATEPART(MINUTE, GETDATE()) BETWEEN 10 AND 19
	   OR DATEPART(MINUTE, GETDATE()) BETWEEN 30 AND 39
	   OR DATEPART(MINUTE, GETDATE()) BETWEEN 50 AND 59
	  )
   AND @Test = 0
BEGIN
	RETURN;
END;

--Ниже идет предварительная настройка временных таблиц и объявление переменных.

--[FIXED] Maslov Oleg '2020-01-09 10:51:48.488' При работе процедуры в джобе ответ, который возвращает API, режется до 512 символов.
				--то есть по умолчанию стоит "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
SET TEXTSIZE 2147483647;
SET NOCOUNT ON

IF OBJECT_ID (N'tempdb..#shopify_prods_info',N'U') IS NOT NULL DROP TABLE #shopify_prods_info
CREATE TABLE #shopify_prods_info
(ShopifyID BIGINT
,ShopifyInvID BIGINT
,Price NUMERIC(21,9)
,ProdID INT
,ShopifyQty NUMERIC(21,9))

DECLARE @temp TABLE (res VARCHAR(MAX))

DECLARE @ShopifyID BIGINT
	   ,@Price NUMERIC(21, 9)
	   ,@MetafieldID BIGINT
	   ,@EndDate DATE

DECLARE @SQL_Select NVARCHAR(MAX), @table_id INT, @IM_table VARCHAR(100), @QtyRow VARCHAR(5)

--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
SELECT @table_id = (SELECT OBJECT_ID('tempdb..#shopify_prods_info') )
	  ,@IM_table = 'r_ShopifyProds'--(SELECT RefName FROM r_Uni WHERE RefTypeID = 1000000015 AND RefID = @RegionID)
	  ,@QtyRow = (SELECT RefName FROM r_Uni WHERE RefTypeID = 1000000015 AND RefID = @RegionID)

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

--Все тот же демонизм. Фыр-фыр.
IF @Test != 0
BEGIN
	SET @for_proxy = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x010000006F172BCB88E67FBA563BEF67FB02F5319B61CD88F32C063328550C861DE6E0CD)))
END;

DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000), @link VARCHAR(8000), @answer VARCHAR(MAX)

DECLARE @f INT = 0
WHILE(@f != 2)
BEGIN
--Формируем особый URL-адрес, который достанет первые товары. 
SELECT @URI = CASE WHEN @f = 0
					THEN @site
					     --Достаем определенные поля товаров.
					     + '/admin/api/2020-01/products.xml?limit=250;fields=id,variants,created-at'
					ELSE @URI END
	  ,@methodName = 'GET'
	  ,@proxy = '2' 
	  ,@proxySettings = '10.1.0.16:8080'
    
	--[CHANGED] Maslov Oleg '2020-07-01 10:54:56.605' Перенос API-запроса в процедуру.
	EXEC ap_Shopify_API_query @URI = @URI
						     ,@QueryMethod = @methodName
						     ,@API_creds = @key
						     ,@LoginProxy = @login_proxy
						     ,@ForProxy = @for_proxy
							 ,@NeedLinkF = 1
						     ,@Status		= @status OUT
						     ,@StatusText	= @statusText OUT
						     ,@Link			= @link OUT
						     ,@Answer		= @answer OUT

	INSERT INTO @temp
	SELECT @answer

	/*
	IF 1 = 1
	BEGIN
			IF 	@methodName = ''
			BEGIN
				SELECT FailPoINT = 'Method Name must be set'
				RETURN
			END 

			EXEC 	@hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT

			IF @hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'Create failed',
						MedthodName = @methodName
				GOTO global_destroy
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
				GOTO global_destroy
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
				GOTO global_destroy
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
				GOTO global_destroy
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
				GOTO global_destroy
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
				GOTO global_destroy
				RETURN
			END

			-- Get status text
			EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText out 
			EXEC sp_OAGetProperty @objectID, 'Status', @status out 

			--Достаем из заголовка ссылки.
			EXEC @hResult = sp_OAMethod @objectID, 'getResponseHeader', @link OUT, 'Link'
			IF 	@hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
					source = @source, 
					description = @desc,
					FailPoINT = 'HEADER',
					MedthodName = @methodName
				GOTO global_destroy
				RETURN
			END

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
				GOTO global_destroy
				RETURN
			END
	END;
	*/
	--Если нет ссылки на страницу "дальше".
	IF (SELECT CHARINDEX('rel="next"', @link)) = 0
	BEGIN
		SET @f = 2
	END;
	ELSE
	BEGIN
		SELECT @f = 1
			   --Если ссылка на страницу "дальше" есть, то достаем ее.
			  ,@URI = SUBSTRING(PString,CHARINDEX('https://', PString), CHARINDEX('>; rel="next"', PString) - CHARINDEX('https://', PString)) FROM af_SplitString(@link, ',') WHERE PString LIKE '%rel="next"%'
	END;
END;


--[CHANGED] Maslov Oleg '2020-01-29 09:14:23.842' Перевод процедуры на версию API '2020-01'.
/*
--Это способ, которым раньше вытягивались товары. Эх... Это было удобнее, чем то, что подсунили вместо него.
--Вычисляем количество страниц.
/*
Description:
У Shopify существует ограниечение по количеству записей, которое можно достать.
По умолчанию можно достать только 50 записей. В этом скрипте ограниечние было 
поднято до 250 (потолок Shopify).
Поэтому ниже вычисляется количество страниц (раз), которые будут обработаны.
*/
IF @count - 250 > 0
BEGIN
	SET @count = CEILING(@count/250)
END;
ELSE
BEGIN
	SET @count = 1
END;

WHILE(@count>0)
BEGIN
--Формируем особый URL-адрес, который будет доставать 250 товаров по странице. 
SELECT @URI = @site
			  --Достаем определенные поля товаров.
			  + '/admin/api/2019-04/products.xml?limit=250;fields=id,variants,created-at;page='
			  --Страница.
			  + CAST(@count AS VARCHAR (5))

IF 1 = 1
BEGIN
		IF 	@methodName = ''
		BEGIN
			SELECT FailPoINT = 'Method Name must be set'
			RETURN
		END 

		EXEC 	@hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT

		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = convert(varbinary(4), @hResult), 
					source = @source, 
					description = @desc,
					FailPoINT = 'Create failed',
					MedthodName = @methodName
			GOTO global_destroy
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
			GOTO global_destroy
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
			GOTO global_destroy
			RETURN
		END

		/*Устанавливаем логин и пароль для прокси-сервера.*/
		EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, @login_proxy, @for_proxy,1
		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = convert(varbinary(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'setProxyCredentials failed',
				MedthodName = @methodName
			GOTO global_destroy
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
			GOTO global_destroy
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
			GOTO global_destroy
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
			GOTO global_destroy
			RETURN
		END
END;

SELECT @count = @count -1
END;
*/

--Удаляем мусор.
UPDATE @temp SET res = REPLACE(res, '<?xml version="1.0" encoding="UTF-8"?>', '');

--Дальше обрабатываем полученный ответ. И получаем цены товаров.
DECLARE @prods TABLE (ProdInfo XML)

INSERT INTO @prods
SELECT CAST(res AS XML) FROM @temp
--SELECT * FROM @prods

DELETE @temp 
DECLARE @Qty_on_stock TABLE (ShopifyInvID BIGINT, Qty NUMERIC(21,9))

--[CHANGED] Maslov Oleg '2020-04-06 10:10:22.447' Остатки на складах все чаще не совпадают. Значит нужно увеличить количество проверок.
IF (	(SELECT DATEPART(HOUR, GETDATE() )) IN (12,18,23)
		AND (SELECT DATEPART(MINUTE, GETDATE() )) BETWEEN 20 AND 29
   )
   OR @Test = 1
BEGIN
	/*
	А здесь будем вытягивать товары со складов. Все 2000+ товаров.
	Зачем? Чтобы узнать сколько товара на остатках на складе.
	Плюс ко всему это особенный случай, так как страницу в формате XML вытянуть не получается, только JSON.
	Почему? Не знаю. Вопрос к Shopify. Нельзя и все (возвращает ошибку 404, если попробовать вытянуть XML).
	Это было проблемой, так как у "Microsoft Server 2008" нет стандартных методов работы с JSON.
	*/
	SET @f = 0
	WHILE(@f != 2)
	BEGIN
	--Формируем особый URL-адрес, который достанет первые товары. 
	SELECT @URI = CASE WHEN @f = 0
						THEN @site
							 --Достаем определенные поля товаров.
							 + '/admin/api/2020-01/inventory_levels.json?location_ids='
							 + CASE @key WHEN '6bab3199775c589f2922cd5bdb48a10b'
											THEN (SELECT RefName FROM r_Uni WHERE RefTypeID = 1000000016 AND RefID = @RegionID)
										 WHEN 'f61cd35b8e1ab1a377abd1c9f5a0e28d' --Dnepr
											THEN '21980545121'
										 WHEN 'c2bb7455131d0c407d241170acd20e58' --Kharkov
											THEN '28498624589'
										 ELSE '0' END
						ELSE @URI END
		  ,@methodName = 'GET'
		  ,@proxy = '2' 
		  ,@proxySettings = '10.1.0.16:8080'

		--[CHANGED] Maslov Oleg '2020-07-01 10:54:56.605' Перенос API-запроса в процедуру.
		EXEC ap_Shopify_API_query @URI = @URI
								 ,@QueryMethod = @methodName
								 ,@API_creds = @key
								 ,@LoginProxy = @login_proxy
								 ,@ForProxy = @for_proxy
								 ,@NeedLinkF = 1
								 ,@Status		= @status OUT
								 ,@StatusText	= @statusText OUT
								 ,@Link			= @link OUT
								 ,@Answer		= @answer OUT

		INSERT INTO @temp
		SELECT @answer

		/*
		IF 1 = 1
		BEGIN
				IF 	@methodName = ''
				BEGIN
					SELECT FailPoINT = 'Method Name must be set'
					RETURN
				END 

				EXEC 	@hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT

				IF @hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
							source = @source, 
							description = @desc,
							FailPoINT = 'Create failed',
							MedthodName = @methodName
					GOTO global_destroy
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
					GOTO global_destroy
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
					GOTO global_destroy
					RETURN
				END

				/*Устанавливаем логин и пароль для прокси-сервера.*/
				EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, @login_proxy, @for_proxy,1
				IF @hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'setProxyCredentials failed',
						MedthodName = @methodName
					GOTO global_destroy
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
					GOTO global_destroy
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
					GOTO global_destroy
					RETURN
				END

				-- Get status text
				EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText out 
				EXEC sp_OAGetProperty @objectID, 'Status', @status out 

				--Достаем из заголовка ссылки.
				EXEC @hResult = sp_OAMethod @objectID, 'getResponseHeader', @link OUT, 'Link'
				IF 	@hResult <> 0
				BEGIN
					EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
					SELECT 	hResult = convert(varbinary(4), @hResult), 
						source = @source, 
						description = @desc,
						FailPoINT = 'HEADER',
						MedthodName = @methodName
					GOTO global_destroy
					RETURN
				END

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
					GOTO global_destroy
					RETURN
				END
		END;
		*/

		--Если нет ссылки на страницу "дальше".
		IF (SELECT CHARINDEX('rel="next"', @link)) = 0
		BEGIN
			SET @f = 2
		END;
		ELSE
		BEGIN
			SELECT @f = 1
				   --Если ссылка на страницу "дальше" есть, то достаем ее.
				  ,@URI = SUBSTRING(PString,CHARINDEX('https://', PString), CHARINDEX('>; rel="next"', PString) - CHARINDEX('https://', PString)) FROM af_SplitString(@link, ',') WHERE PString LIKE '%rel="next"%'
		END;
	END;

	--Обработка JSON. Ничего сложного, но на всякий случай...
	--Hierarchy - это созданный тип данных специально для JSON. По факту это просто временная
	--таблица, а Hierarchy просто однозначно определяет ее структуру.
	DECLARE @json_sting VARCHAR(MAX), @parent_ID INT
	DECLARE @JSON Hierarchy

	--Внешний цикл (или курсор, называйте как хотите) достает по одному JSON, который удалось получить.
	DECLARE JSON_PROC CURSOR LOCAL FAST_FORWARD 
	FOR 
	SELECT res FROM @temp

	OPEN JSON_PROC
		FETCH NEXT FROM JSON_PROC INTO @json_sting
	WHILE @@FETCH_STATUS = 0	 
	BEGIN
			DELETE @JSON
			INSERT INTO @JSON
			--Именно в функции af_JSON_Parse происходит парсинг строки JSON и она превращается в таблицу.
			SELECT * FROM af_JSON_Parse(@json_sting)

			DECLARE JSON_NORMALIZATION CURSOR LOCAL FAST_FORWARD 
			FOR 
			SELECT DISTINCT parent_ID FROM @JSON
		
			OPEN JSON_NORMALIZATION
				FETCH NEXT FROM JSON_NORMALIZATION INTO @parent_ID
			WHILE @@FETCH_STATUS = 0	 
			BEGIN
				
					INSERT INTO @Qty_on_stock(ShopifyInvID, Qty)
					SELECT ISNULL( (SELECT CAST(StringValue AS BIGINT) FROM @JSON WHERE NAME = 'inventory_item_id' AND parent_ID = @parent_ID), -1)
						  --[FIXED] Maslov Oleg '2020-05-08 14:50:26.444' Внезапно в ИМ появился товар у которого количество null, что, естественно, ломает нам шаг проверки. 
						  --,ISNULL( (SELECT CAST(StringValue AS NUMERIC(21,9)) FROM @JSON WHERE NAME = 'available' AND parent_ID = @parent_ID), -1)
						  ,ISNULL( (SELECT CASE WHEN StringValue = 'null' THEN -1 ELSE CAST(StringValue AS NUMERIC(21,9)) END FROM @JSON WHERE NAME = 'available' AND parent_ID = @parent_ID), -1)

				FETCH NEXT FROM JSON_NORMALIZATION INTO @parent_ID
			END
			CLOSE JSON_NORMALIZATION
			DEALLOCATE JSON_NORMALIZATION

		FETCH NEXT FROM JSON_PROC INTO @json_sting
	END
	CLOSE JSON_PROC
	DEALLOCATE JSON_PROC

	DELETE @Qty_on_stock WHERE ShopifyInvID = -1

END;

INSERT INTO #shopify_prods_info (ShopifyID, ShopifyInvID, Price, ProdID, ShopifyQty)
SELECT q1.ShopifyID, q1.Shopify_inventory_ID, q1.Price, q1.ProdID, ISNULL(qos.Qty, 0)
FROM
(
	SELECT CAST( CAST (pr.query('data(id)') AS VARCHAR(20)) AS BIGINT) 'ShopifyID'
		  --[FIXED] Maslov Oleg '2020-05-07 13:50:36.333' Пока не знаю почему, но старый метод получения "VariantID" выдает ошибку (Target string size is too small to represent the XML instance). Перешел на новый.
		  --,CAST( CAST (pr.query('data(variants/variant/inventory-item-id)') AS VARCHAR(20)) AS BIGINT)'Shopify_inventory_ID'
		  ,prods.pr.value('(variants/variant/inventory-item-id)[1]', 'bigint') AS 'Shopify_inventory_ID'
		  --[FIXED] Maslov Oleg '2020-05-07 13:50:36.333' Пока не знаю почему, но старый метод получения "VariantID" выдает ошибку (Target string size is too small to represent the XML instance). Перешел на новый.
		  --,CAST( CAST (pr.query('data(variants/variant/price)') AS VARCHAR(20)) AS NUMERIC(21,9)) 'Price'
		  ,prods.pr.value('(variants/variant/price)[1]', 'numeric(21,9)') AS 'Price'
		  ,CASE WHEN CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(10)) LIKE '%[^0-9]%' 
				THEN 0
				ELSE CAST( (CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(10)) ) AS INT) END 'ProdID'	  
	FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr)
) q1
LEFT JOIN @Qty_on_stock qos ON qos.ShopifyInvID = q1.Shopify_inventory_ID

--Временный IF. Можно будет убрать, когда окончательно перейдем один сайт.
IF @RegionID = 2 OR @key != '6bab3199775c589f2922cd5bdb48a10b'
BEGIN

DELETE @temp 
--Далее достаем общее количество товаров на сайте (особенный URL запрос).
SELECT 
       --@URI = @site + '/admin/api/2019-04/products/count.xml'
       @URI = @site + '/admin/api/2020-01/products/count.xml'
	  ,@methodName = 'GET'
	  ,@proxy = '2' 
	  ,@proxySettings = '10.1.0.16:8080'

--[CHANGED] Maslov Oleg '2020-07-01 10:54:56.605' Перенос API-запроса в процедуру.
EXEC ap_Shopify_API_query @URI = @URI
					     ,@QueryMethod = @methodName
					     ,@API_creds = @key
					     ,@LoginProxy = @login_proxy
					     ,@ForProxy = @for_proxy
					     ,@Status		= @status OUT
					     ,@StatusText	= @statusText OUT
					     ,@Link			= @link OUT
					     ,@Answer		= @answer OUT

INSERT INTO @temp
SELECT @answer

/*
--GET request	
IF 1 = 1
BEGIN
		IF 	@methodName = ''
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
			GOTO global_destroy
			RETURN
		END

		-- open the destination URL with Specified method
		EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URI, 'false'
		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = convert(varbinary(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'Open failed',
				MedthodName = @methodName
			GOTO global_destroy
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
			GOTO global_destroy
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
			GOTO global_destroy
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
			GOTO global_destroy
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
			GOTO global_destroy
			RETURN
		END

		-- Get status text
		EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText out 
		EXEC sp_OAGetProperty @objectID, 'Status', @status out 

		-- Get response text
		INSERT INTO @temp
			 EXEC sp_OAGetProperty @objectID, 'responseText'
		
		--Если ошибка.
		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = convert(varbinary(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'ResponseText failed',
				MedthodName = @methodName
			GOTO global_destroy
			RETURN
		END
END;
--end of get request
*/

--Достаем значение из запроса.
SELECT @count = CAST(SUBSTRING(res, CHARINDEX('<count type="integer">', res) + LEN('<count type="integer">'), CHARINDEX('</count>', res) - (CHARINDEX('<count type="integer">', res) + LEN('<count type="integer">')) ) AS FLOAT)
FROM @temp
DELETE @temp

--Если количество товаров не сходится с текущим, записанным в справочнике универсальном,
--то обновляем количество товара в справочнике универсальном.
IF ( (SELECT CAST( SUBSTRING(RefName,1,CHARINDEX('_IM',RefName)-1) AS FLOAT) FROM r_Uni WHERE RefTypeID = 1000000014 AND RefID = @RegionID) -  @count) <> 0
BEGIN
	UPDATE r_Uni
	SET RefName = CAST( @count AS VARCHAR(20) ) + SUBSTRING(RefName,CHARINDEX('_IM',RefName),LEN(RefName)), Notes = CONVERT(VARCHAR, GETDATE(), 120)
	WHERE RefTypeID = 1000000014 AND RefID = @RegionID 
END;

--Старый способ (до появления обработки JSON) записи информации от товарах.
--INSERT INTO #shopify_prods_info (ShopifyID, ShopifyInvID, Price, ProdID, ShopifyQty)
--SELECT CAST( CAST (pr.query('data(id)') AS VARCHAR(20)) AS BIGINT) 'ShopifyID'
--	  ,CAST( CAST (pr.query('data(variants/variant/inventory-item-id)') AS VARCHAR(20)) AS BIGINT)'Shopify_inventory_ID'
--	  ,CAST( CAST (pr.query('data(variants/variant/price)') AS VARCHAR(20)) AS NUMERIC(21,9)) 'Price'
--	  ,CASE WHEN CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(10)) LIKE '%[^0-9]%' 
--			THEN 0
--			ELSE CAST( (CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(10)) ) AS INT) END 'ProdID'	  
--	  ,CAST (CAST (pr.query('data(variants/variant/inventory-quantity)') AS VARCHAR(20)) AS NUMERIC(21,9)) 'Shopify_qty'
--FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr)

--Если вытянуть ничего не удалось, то выход.
IF NOT EXISTS(SELECT TOP 1 1 FROM #shopify_prods_info)
BEGIN
	RETURN
END;

SET @SQL_Select =
				  --Если цена не совпадает, то обновить цену.
				  'UPDATE m SET UpdateDate = GETDATE(), UpdateState = 1 FROM '
				+ @IM_table 
				+ ' m WHERE m.UpdateState = 0 AND m.ProdID IN (SELECT p.ProdID FROM '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ' p JOIN (SELECT ShopifyID, ProdID, CASE WHEN DiscountActive = 1 THEN DiscountPrice ELSE Price END ''Price'' FROM '
				+ @IM_table
				--[CHANGED] Maslov Oleg '2020-02-19 10:17:14.817' Убираем из проверки дубликаты. WHERE UpdateState != 9
				+ ' WITH(NOLOCK) WHERE UpdateState NOT IN (7,9,10)) m ON m.ShopifyID = p.ShopifyID WHERE p.Price != m.Price); '
				--Если товар был удален из ИМ.
				+ 'IF EXISTS(SELECT 1 FROM '
				+ @IM_table
				+ ' WHERE ShopifyID NOT IN (SELECT ShopifyID FROM '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ')) BEGIN UPDATE '
				+ @IM_table
				+ ' SET UpdateDate = GETDATE(), UpdateState = 666 WHERE ShopifyID NOT IN (SELECT ShopifyID FROM '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ' ) AND ProdID != 0 AND UpdateState != 6 END;'
				--Проверяем совпадает ли код товара в ИМ и в таблице.
				--[CHANGED] Maslov Oleg '2020-06-05 09:31:47.160' Теперь в случае не совпадения кода товара в базе и в ИМ, берем за основу код товара из ИМ и ставми его в базу.
				--+ ' UPDATE m SET UpdateDate = GETDATE(), UpdateState = 7 FROM '
				+ ' UPDATE m SET UpdateDate = GETDATE(), ProdID = spi.ProdID FROM '
				+ @IM_table
				+ ' AS m JOIN '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ' spi ON spi.ShopifyID = m.ShopifyID WHERE m.ProdID != spi.ProdID AND m.UpdateState NOT IN (-1,6,10);'
				--Проверяем InventoryID Shopify. Это ID товара на складе в ИМ.
				+ ' UPDATE m SET ShopifyInvID = spi.ShopifyInvID FROM '
				+ @IM_table
				+ ' AS m JOIN '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ' spi ON spi.ShopifyID = m.ShopifyID WHERE m.ShopifyInvID != spi.ShopifyInvID AND m.ProdID != 0;'

EXEC sp_executesql @SQL_Select

END;

--Каждый день за полчаса до полуночи, если нужно, выравниваем остатки в интернет-магазине.
IF (	(SELECT DATEPART(HOUR, GETDATE() )) IN (12,18,23)
		AND (SELECT DATEPART(MINUTE, GETDATE() )) BETWEEN 20 AND 29
		--AND @RegionID != 2 
   )
   OR @Test = 1
BEGIN
	SET @SQL_Select = 'UPDATE '
				    + @IM_table
				    + ' SET UpdateDate = GETDATE(), UpdateState = ' + CAST((30 + @RegionID) AS VARCHAR(2)) + ' FROM '
				    + (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				    + ' ids JOIN '
				    + @IM_table
				    --Когда ИМ был разделен на три сайта, то можно было работать по ShopifyID товара. При переходе ShopifyID уже не корректно использовать.
				    --+ ' q WITH(NOLOCK) ON q.ShopifyID = ids.ShopifyID WHERE ids.ShopifyQty - q.Qty != 0 AND q.UpdateState = 0'
				    --+ ' q WITH(NOLOCK) ON q.ProdID = ids.ProdID WHERE ids.ShopifyQty - q.Qty != 0 AND q.UpdateState = 0'
				    + ' q WITH(NOLOCK) ON q.ShopifyID = ids.ShopifyID WHERE ids.ShopifyQty - q.' + @QtyRow + ' != 0 AND q.UpdateState = 0'
				   
	EXEC sp_executesql @SQL_Select
END;

--Каждый день в три часа утра обновляем таймеры на акционных товарах.
--[ADDED] Maslov Oleg '2019-11-25 10:16:25.536' Теперь будем проверять таймера всех активных акционных товаров несколько раз в день в отдельном шаге джоба.
/*
IF (SELECT DATEPART(HOUR, GETDATE() )) IN (3/*,5,16,20*/)
   AND (SELECT DATEPART(MINUTE, GETDATE() )) BETWEEN 0 AND 9
BEGIN

	SET @SQL_Select = 'UPDATE '
				    + @IM_table 
				    + ' SET UpdateDate = GETDATE(), UpdateState = 5 WHERE UpdateState = 0 AND DiscountActive = 1'
				   
	EXEC sp_executesql @SQL_Select

	--UPDATE r_ShopifyProdsDp SET UpdateDate = GETDATE(), UpdateState = 5 WHERE UpdateState = 0 AND DiscountActive = 1
END;
*/
/*
--Если цена в ИМ и в реестре не совпадает, то обновить цену.
UPDATE m SET UpdateDate = GETDATE(), UpdateState = 1
FROM r_ShopifyProdsDp m
WHERE m.UpdateState = 0
  AND m.ProdID IN (SELECT ProdID FROM #shopify_prods_info p
								 JOIN (SELECT ShopifyID, ProdID, CASE WHEN DiscountActive = 1 THEN DiscountPrice ELSE Price END 'Price' FROM r_ShopifyProdsDp WITH(NOLOCK)) m ON m.ShopifyID = p.ShopifyID
								 WHERE p.Price != m.Price)

--Удаляем товары, которые не были найдены в ИМ.
IF EXISTS(SELECT 1 FROM r_ShopifyProdsDp WHERE ProdID NOT IN (SELECT CAST( CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(20)) AS BIGINT) 'ProdID'	FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr) ))
BEGIN
	UPDATE r_ShopifyProdsDp SET UpdateDate = GETDATE(), UpdateState = 666 WHERE UpdateState = 0 AND ProdID NOT IN (SELECT CAST( CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(20)) AS BIGINT) 'ProdID'	FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr) )
	--DELETE r_ShopifyProdsDp
	--WHERE ProdID NOT IN (
	--SELECT CAST( CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(20)) AS BIGINT) 'ProdID'
	--FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr) )
END;
*/


global_destroy:
	EXEC sp_OADestroy @objectID

IF OBJECT_ID (N'tempdb..#shopify_prods_info',N'U') IS NOT NULL DROP TABLE #shopify_prods_info

END