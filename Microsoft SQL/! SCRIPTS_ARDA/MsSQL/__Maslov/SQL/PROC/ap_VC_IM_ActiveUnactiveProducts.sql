ALTER PROCEDURE [dbo].[ap_VC_IM_ActiveUnactiveProducts] @api_l VARCHAR(500) = '', @key VARCHAR(500) = '', @RegionID INT = -1, @admin_adress VARCHAR(500) = '', @Test INT = 0
AS
BEGIN
/*
Включаем/выключаем товары в интернет-магазине (ИМ тут и дальше).

Brevis descriptio
В начале работы скрипта идет проверка на необходимость включать или выключать товары
(UpdateState = 2; 2 - значит, что нужно обновить активность товара).
Этот скрипт запускается не через Powershell потому что его работа не зависит от ответа,
который отправляет Shopify.

*/

/*
EXEC ap_VC_IM_ActiveUnactiveProducts @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1

--'2020-03-20 10:29:33.300' Старый блок процедур. Он использовался в те времена, когда ИМ был разделен на три сайта.
EXEC ap_VC_IM_ActiveUnactiveProducts @api_l = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID = 1, @admin_adress = 'vintagemarket-dp.myshopify.com', @Test = 1
EXEC ap_VC_IM_ActiveUnactiveProducts @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1
EXEC ap_VC_IM_ActiveUnactiveProducts @api_l = '822ee75ea06b63718ec6422bd0b77748', @key = 'c2bb7455131d0c407d241170acd20e58', @RegionID = 5, @admin_adress = 'vintagemarket-kh.myshopify.com', @Test = 1
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] Maslov Oleg '2020-01-29 09:50:59.126' Перевод процедуры на версию API '2020-01'.
--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Ниже идет предварительная настройка временных таблиц и объявление переменных.
SET NOCOUNT ON

IF @api_l = '' OR @key = '' OR @RegionID = -1 OR @admin_adress = ''
BEGIN
	RETURN;
END;

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
	   --,@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID INT = 1--dnepr = 1
	   ,@site VARCHAR(3000) = 'https://' + @api_l + ':' + @key + '@' + @admin_adress

--Кукла Вуду для убунту.
IF @Test != 0
BEGIN
	SET @for_proxy = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000014DBC39169721A1CC037D82C2C82AF60EA2DB4A2727EDD9040D5AFD5A589187C)))
END;

DECLARE @SQL_Select NVARCHAR(MAX), @table_id INT, @IM_table VARCHAR(100), @outs VARCHAR(50)

SELECT @IM_table = 'r_ShopifyProds'--(SELECT RefName FROM r_Uni WHERE RefTypeID = 1000000015 AND RefID = @RegionID)

SET @SQL_Select = 'SELECT @out = COUNT(*) FROM '
				+ @IM_table
				+ ' m WHERE m.UpdateState = 2'

EXEC sp_executesql @SQL_Select, N'@out VARCHAR(50) OUT', @outs OUT  

IF  /*Если не нужно включать/выключать товары, то выход.
	(SELECT COUNT(*)
	 FROM r_ShopifyProdsDp m
		WHERE m.UpdateState = 2) <= 0*/
    (SELECT CAST(@outs AS INT) ) <= 0
BEGIN
	RETURN
END;

IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(XML VARCHAR(MAX))

IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
CREATE TABLE #shopi_ids
(ShopifyID BIGINT
,IsActive BIT)

SELECT @table_id = (SELECT OBJECT_ID('tempdb..#shopi_ids') )

SET @SQL_Select = 'INSERT INTO '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ' SELECT ShopifyID, IsActive FROM '
				+ @IM_table
				+ ' WHERE UpdateState = 2'

EXEC sp_executesql @SQL_Select

DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)

DECLARE @ShopifyID BIGINT
	   ,@ActiveFlag BIT
	   ,@put VARCHAR(8000)
--Далее создаем курсор, который будет включать/выключать товары с помощью PUT.
DECLARE ActDeactProds CURSOR LOCAL FAST_FORWARD 
FOR
SELECT TOP 200 ShopifyID, IsActive
FROM #shopi_ids
--FROM r_ShopifyProdsDp WITH(NOLOCK)
--WHERE UpdateState = 2

OPEN ActDeactProds
	FETCH NEXT FROM ActDeactProds INTO @ShopifyID, @ActiveFlag
WHILE @@FETCH_STATUS = 0	 
BEGIN

--Maslov Oleg '2020-01-29 09:50:59.126' Перевод процедуры на версию API '2020-01'.
--Берем определенный товар.
SELECT
	 --@URL = @site + '/admin/api/2019-04/products/'
	 @URL = @site + '/admin/api/2020-01/products/'
		  + CAST(@ShopifyID AS VARCHAR(50)) + '.xml'
	,@methodName = 'PUT'
	,@proxy = '2'
	,@proxySettings = '10.1.0.16:8080'

IF 	@methodName = ''
BEGIN
	select FailPoINT = 'Method Name must be set'
	RETURN
END 
--Создаем запрос в API Shopify и вытягиваем ответ.
IF 1 = 1
BEGIN
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

	--Устанавливаем данные для входа.
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

	-- Хэдер, который обозначает, что содержимое является кодом xml.
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
	EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, @login_proxy, @for_proxy,1
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

	--Здесь формируется XML, который будет вложен в URL-запрос.
	IF @ActiveFlag = 0
		BEGIN
			--Выключаем товар.
			SET @put = '<product><published-at type="dateTime" nil="true"/></product>'
		END;

	ELSE IF @ActiveFlag = 1
		BEGIN
			--Включаем товар.
			SET @put = '<product><published-at type="dateTime">'+
					   + (SELECT CONVERT(VARCHAR(50), GETDATE(), 126))
					   + '+03:00'
					   +'</published-at></product>'
		END;

	--Отправляем запрос.
	EXEC @hResult = sp_OAMethod @objectID, 'send', null, @put
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

	-----------------------------------Log block--------------------------------------------------
	SET @SQL_Select = 'SELECT @out = ProdID FROM '
		+ @IM_table
		+ ' WHERE ShopifyID = '
		+ (SELECT CAST(@ShopifyID AS VARCHAR(100)) )

	EXEC sp_executesql @SQL_Select, N'@out VARCHAR(50) OUT', @outs OUT 

	DECLARE @Value VARCHAR(4000) = @put
	DECLARE @ProdID_log INT = (SELECT CAST(@outs AS INT) )
	EXEC ap_VC_IM_Logs @RegionID = @RegionID, @UpdateState = 2, @ProdID = @ProdID_log, @Value = @Value, @Status = @status, @StatusText = @statusText
	-----------------------------------Log block--------------------------------------------------

	IF (SELECT CAST(@status AS INT)) = 200
	BEGIN
		SET @SQL_Select = 'UPDATE '
						+ @IM_table
						+ ' SET UpdateDate = GETDATE(), UpdateState = 0	WHERE ShopifyID = '
						+ (SELECT CAST(@ShopifyID AS VARCHAR(100)) )

		EXEC sp_executesql @SQL_Select 
		--UPDATE r_ShopifyProdsDp SET UpdateDate = GETDATE(), UpdateState = 0 WHERE ShopifyID = @ShopifyID
	END;

	-- Get response text
	INSERT INTO #xml
		 EXEC sp_OAGetProperty @objectID, 'responseText'

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
END;

	FETCH NEXT FROM ActDeactProds INTO @ShopifyID, @ActiveFlag
END
CLOSE ActDeactProds
DEALLOCATE ActDeactProds

IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml

END