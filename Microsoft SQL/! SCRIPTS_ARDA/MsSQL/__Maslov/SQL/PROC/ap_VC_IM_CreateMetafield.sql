ALTER PROCEDURE [dbo].[ap_VC_IM_CreateMetafield] @key VARCHAR(500) = '', @RegionID INT = -1, @admin_adress VARCHAR(500) = '', @ShopifyID BIGINT = -1, @Test INT = 0
AS
BEGIN
/*
Создаем метаполе для возможности устанавливать таймер окончания акции.

Brevis descriptio
Процедура создает метаполе для опрделенного товара методом POST. ID товара нужно брать
от Shopify. Их можно найти в соответсвующих таблицах в базе ElitR.

*/

/*
EXEC ap_VC_IM_CreateMetafield @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @ShopifyID = 3764869693517, @Test = 1

--'2020-03-20 10:29:33.300' Старый блок процедур. Он использовался в те времена, когда ИМ был разделен на три сайта.
EXEC ap_VC_IM_CreateMetafield @key = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID = 1, @admin_adress = 'vintagemarket-dp.myshopify.com', @ShopifyID = 2143482708065, @Test = 1
EXEC ap_VC_IM_CreateMetafield @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @ShopifyID = 3764869693517, @Test = 1
EXEC ap_VC_IM_CreateMetafield @key = 'c2bb7455131d0c407d241170acd20e58', @RegionID = 5, @admin_adress = 'vintagemarket-kh.myshopify.com', @ShopifyID = 3764740685901, @Test = 1
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] Maslov Oleg '2020-01-29 16:31:27.206' Перевод процедуры на версию API '2020-01'.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Ниже идет предварительная настройка временных таблиц и объявление переменных.
SET NOCOUNT ON

IF @RegionID = -1 OR @ShopifyID = -1 OR @admin_adress = ''
BEGIN
	RETURN;
END;

DECLARE @temp TABLE (Metafield XML)

DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)

DECLARE	@URL VARCHAR(3000)
	   ,@methodName VARCHAR(50)
	   ,@proxy VARCHAR(50)
	   ,@proxySettings VARCHAR(50)
	   ,@objectID INT
	   ,@hResult INT
	   ,@source VARCHAR(255)
	   ,@desc VARCHAR(255)
	   ,@login_proxy VARCHAR(200) = 'CONST\vintageshopify'
	   ,@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000068D4AB26848B654D3149C9EC9E19CBD586F805D3F10AFE5B9C9F516E87CE330A )))
	   --,@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID INT = 1,--dnepr = 1
	   ,@site_s VARCHAR(3000) = 'https://' + @admin_adress

--Демонизм никогда не выйдет из моды.
IF @Test = 1
BEGIN
	SET @for_proxy = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000014DBC39169721A1CC037D82C2C82AF60EA2DB4A2727EDD9040D5AFD5A589187C)))
END;

DECLARE @SQL_Select NVARCHAR(MAX), @outs VARCHAR(50)

--[CHANGED] Maslov Oleg '2020-01-29 16:31:27.206' Перевод процедуры на версию API '2020-01'.
--Специальный запрос для создания метаполя.
SELECT
	--@URL = @site_s + '/admin/api/2019-04/products/'
	@URL = @site_s + '/admin/api/2020-01/products/'
		 + CAST(@ShopifyID AS VARCHAR(50))
		 +'/metafields.json'
	,@methodName = 'POST'
	,@proxy = '2'
	,@proxySettings = '10.1.0.16:8080'

--SELECT @URL

--Блок отправки запроса в API и получения ответа.
IF 1 = 1
BEGIN
	IF 	@methodName = ''
	BEGIN
		SELECT FailPoINT = 'Method Name must be set'
		RETURN
	END 

	EXEC @hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT

	IF @hResult <> 0
	BEGIN
		EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
		SELECT 	hResult = convert(varbinary(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'Create failed',
				MedthodName = @methodName
		GOTO curs_destroy
		RETURN
	END

	-- open the destination URI with Specified method
	EXEC @hResult = sp_OAMethod @objectID, 'open', NULL, @methodName, @URL, 'false'
	IF @hResult <> 0
	BEGIN
		EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
		SELECT 	hResult = convert(varbinary(4), @hResult), 
			source = @source, 
			description = @desc,
			FailPoINT = 'Open failed',
			MedthodName = @methodName
		GOTO curs_destroy
		RETURN
	END

	-- Особый хэдер URL-запроса для Shopify, для того, чтобы обойти аутентификацию.
	EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'X-Shopify-Access-Token', @key
	-- Хэдер, который обозначает, что этот запрос нужно обработать как json.
	EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'application/json'
	IF @hResult <> 0
	BEGIN
		EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
		SELECT 	hResult = convert(varbinary(4), @hResult), 
			source = @source, 
			description = @desc,
			FailPoINT = 'SetRequestHeader failed: Content-Type',
			MedthodName = @methodName
		GOTO curs_destroy
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
		GOTO curs_destroy
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
		GOTO curs_destroy
		RETURN
	END

	--Здесь формируются данные, который будут вложены в URL-запрос.
	DECLARE @put VARCHAR(8000) = '{"metafield":{"namespace":"global","key":"discountDeadline","value":"2010-01-01","value_type":"string"}}'

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
		GOTO curs_destroy
		RETURN
	END

	-- Get status text
	EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText OUT 
	EXEC sp_OAGetProperty @objectID, 'Status', @status OUT 

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
		GOTO curs_destroy
		RETURN
	END

	curs_destroy:
		EXEC sp_OADestroy @objectID
END;

END