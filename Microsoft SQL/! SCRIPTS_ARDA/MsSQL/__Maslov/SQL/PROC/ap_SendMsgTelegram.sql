ALTER PROCEDURE [dbo].[ap_SendMsgTelegram] @chat_id VARCHAR(200), @text VARCHAR(500)
AS
BEGIN

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
	@login_proxy VARCHAR(200) = 'CONST\vintageshopify',
	@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000068D4AB26848B654D3149C9EC9E19CBD586F805D3F10AFE5B9C9F516E87CE330A )))

SELECT
	 @URL = 'https://api.telegram.org/bot959378230:AAGfuMJqo7wJD9LxMSQGt92PQIcFNsCABRc/sendMessage?chat_id='
	 + @chat_id + '&text=' + @text
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
EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'application/json'
--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'X-Shopify-Access-Token', @key
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

-- Get response text
INSERT INTO @temp
    EXEC sp_OAGetProperty @objectID, 'responseText'

SELECT * FROM @temp

destroy:
	EXEC sp_OADestroy @objectID

END;