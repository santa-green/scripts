DECLARE @temp TABLE (res VARCHAR(MAX))

DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)

DECLARE
	@URL VARCHAR(3000),
	@methodName VARCHAR(50),
	@proxy VARCHAR(50), 
	@proxySettings VARCHAR(50),
	@objectID INT,
	@hResult INT,
	@source VARCHAR(255),
	@desc VARCHAR(255),
	@chat_id VARCHAR(20),
	@login_proxy VARCHAR(200) = 'CONST\vintageshopify',
	--For me! ME! ME!
	--@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x010000002C85481F0A9F7EAE67C353072D5A1851279B137125EFEB7DCCB78295E293E1EC ))),
	@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000014DBC39169721A1CC037D82C2C82AF60EA2DB4A2727EDD9040D5AFD5A589187C ))),
	--@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID INT = 1--dnepr = 1
	--@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com',
	@api_l VARCHAR(500) = '4a31bd883165bfd2bb8932c6287e7b9c', @key VARCHAR(500) = '6bab3199775c589f2922cd5bdb48a10b', @RegionID INT = 2--kiev = 2


SELECT
	 --@URL = 'https://api.telegram.org/bot959378230:AAGfuMJqo7wJD9LxMSQGt92PQIcFNsCABRc/getMe'
	 --@URL = 'https://api.telegram.org/bot959378230:AAGfuMJqo7wJD9LxMSQGt92PQIcFNsCABRc/sendMessage?chat_id=724380520&text=рускии'
	 @URL = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2020-01/inventory_levels.json?location_ids=34782150769'
	 --@URL = @site + '/admin/api/2019-04/orders.json'
	,@methodName = 'GET'
	,@proxy = '2'
	,@proxySettings = '10.1.0.16:8080'

IF 	@methodName = ''
BEGIN
	select FailPoINT = 'Method Name must be set'
	RETURN
END 

--Создаем объект, для запроса.
EXEC 	@hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT

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

-- set request headers
--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'application/json'
EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'X-Shopify-Access-Token', @key
IF @hResult <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hResult), 
		source = @source, 
		description = @desc,
		FailPoint = 'SetRequestHeader failed: Content-Type',
		MedthodName = @methodName
	goto destroy
	return
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

SELECT @statusText, @status

DECLARE @link VARCHAR(8000)
--EXEC @hResult = sp_OAMethod @objectID, 'getAllResponseHeaders', @link OUT
EXEC @hResult = sp_OAMethod @objectID, 'getResponseHeader', @link OUT, 'Link'

-- Get response text
INSERT INTO @temp
    EXEC sp_OAGetProperty @objectID, 'responseText'

SELECT * FROM @temp

DECLARE @MyHierarchy Hierarchy  
INSERT INTO @myHierarchy 
select * from af_JSON_Parse((SELECT * FROM @temp))

SELECT * FROM @MyHierarchy
SELECT @link

destroy:
	EXEC sp_OADestroy @objectID

