/*
Поиск и удаление дубликатов в интернет-магазине. 
*/

BEGIN

--Ниже идет предварительная настройка временных таблиц и объявление переменных.
DECLARE
	@URL VARCHAR(3000),
	@methodName VARCHAR(50),
	@proxy VARCHAR(50), 
	@proxySettings VARCHAR(50),
	@objectID INT,
	@hResult INT,
	@source VARCHAR(255),
	@desc VARCHAR(255),
	@count FLOAT,
	@login_proxy VARCHAR(200) = 'CONST\vintageshopify',
	@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100),DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x010000001AAC8CC41F68E4DC5B79401A45857F68AC81E49F56BCF21E5C57FCCB57C11E75 ))),
	--==========================================================================
	--Далее выбираем ИМ, в котором будем работать.
	--==========================================================================
	--@site VARCHAR(3000) = 'https://5023473df124058d09f41d9be664b065:a2039145b0d1a36620e09121aa1f933e@vintagemarket-kh.myshopify.com', @api_l VARCHAR(500) = '5023473df124058d09f41d9be664b065', @key VARCHAR(500) = 'a2039145b0d1a36620e09121aa1f933e'--kharkov = 5
	@site VARCHAR(3000) = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com', @api_l VARCHAR(500) = '4a31bd883165bfd2bb8932c6287e7b9c', @key VARCHAR(500) = '6bab3199775c589f2922cd5bdb48a10b'--kiev = 2
	--@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d'--dnepr = 1

DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)

IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(XML VARCHAR(MAX))

DECLARE @temp TABLE (res VARCHAR(MAX))

SELECT
	--Достаем общее количество товаров.
	 @URL = @site + '/admin/api/2019-04/products/count.xml'
	,@methodName = 'GET'
	,@proxy = '2' 
	,@proxySettings = '10.1.0.16:8080'

--GET request	
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
			GOTO total_destroy
			RETURN
		END

		-- open the destination URI with Specified method
		EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URL, 'false'
		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = convert(varbinary(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'Open failed',
				MedthodName = @methodName
			GOTO total_destroy
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
			GOTO total_destroy
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
			GOTO total_destroy
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
			GOTO total_destroy
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
			GOTO total_destroy
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
			GOTO total_destroy
			RETURN
		END
END;
--end of get request

--Достаем значение из запроса.
SELECT @count = CAST(SUBSTRING(res, CHARINDEX('<count type="integer">', res) + LEN('<count type="integer">'), CHARINDEX('</count>', res) - (CHARINDEX('<count type="integer">', res) + LEN('<count type="integer">')) ) AS FLOAT)
FROM @temp
DELETE @temp

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
SELECT @URL = @site + '/admin/api/2019-04/products.xml?limit=250;fields=id,variants,created-at;page=' + CAST(@count AS VARCHAR (5))

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
			GOTO total_destroy
			RETURN
		END

		-- open the destination URI with Specified method
		EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URL, 'false'
		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = convert(varbinary(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'Open failed',
				MedthodName = @methodName
			GOTO total_destroy
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
			GOTO total_destroy
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
			GOTO total_destroy
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
			GOTO total_destroy
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
			GOTO total_destroy
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
			GOTO total_destroy
			RETURN
		END
END;

SELECT @count = @count -1
END;

--Удаляем мусор.
UPDATE @temp SET res = REPLACE(res, '<?xml version="1.0" encoding="UTF-8"?>', '');

INSERT INTO #xml
SELECT * FROM @temp

END;

DECLARE @prods TABLE (ProdInfo XML)

INSERT INTO @prods
SELECT CAST(XML AS XML) FROM #xml
 
--SELECT * FROM @prods

DECLARE @double_products TABLE (ProdID INT)

--Дальше обрабатываем полученный ответ. Создаем CTE.
;WITH
Dublicates AS (SELECT q.ProdID
, ROW_NUMBER() OVER(PARTITION BY q.ProdID ORDER BY q.ProdID) number_of_dublicates
FROM (SELECT CAST (pr.query('data(id)') AS VARCHAR(20)) 'ShopifyID'
	  ,CAST( (CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(10)) ) AS INT) 'ProdID'
FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr)
	 ) q
			  )

--Находим дубликаты.
INSERT INTO @double_products
SELECT ProdID FROM Dublicates WHERE number_of_dublicates > 1

SELECT COUNT(ProdID) FROM @double_products
SELECT * FROM @double_products

IF 1 = 0
BEGIN
DELETE #xml

DECLARE @ProdID INT

--Объвляем курсор, который будет удалять дубликаты ShopifyID которых больше, чем у оригинала.
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT ProdID FROM @double_products

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ProdID
WHILE @@FETCH_STATUS = 0	 
BEGIN
		
SELECT
	--Формируем запрос удаления дубликата.
	@URL = @site
		   + '/admin/api/2019-04/products/'
		   + (SELECT CAST(MIN(ShopifyID) AS VARCHAR(20)) FROM r_ShopifyProdsDp WHERE ProdID = @ProdID)
		   + '.xml',
	@methodName = 'DELETE'
	,@proxy = '2'
	,@proxySettings = '10.1.0.16:8080'

--SELECT @URL
	

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
	GOTO destroy
	RETURN
END

-- open the destination URI with Specified method
EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URL, 'false'
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
	GOTO destroy
	RETURN
END


-- Get status text
EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText out 
EXEC sp_OAGetProperty @objectID, 'Status', @status out 
--select hResult=@hResult, status=@status, statusText=@statusText, methodName=@methodName

-- Get response text
INSERT INTO #xml
     EXEC sp_OAGetProperty @objectID, 'responseText'--, @responseText out

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

	FETCH NEXT FROM CURSOR1 INTO @ProdID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

SELECT * FROM #xml

END;

total_destroy:
	EXEC sp_OADestroy @objectID