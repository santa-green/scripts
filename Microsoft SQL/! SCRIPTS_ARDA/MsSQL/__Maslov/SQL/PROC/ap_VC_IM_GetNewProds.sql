ALTER PROCEDURE [dbo].[ap_VC_IM_GetNewProds] @api_l VARCHAR(500) = '', @key VARCHAR(500) = '', @RegionID INT = -1, @admin_adress VARCHAR(500) = '', @ShopifyProdID VARCHAR(50) = '', @Test INT = 0
AS
BEGIN
/*
Достаем новые товары из интренет-магазина, если они есть.

Brevis descriptio
Если на сайте появились новые товары, то добавляем их в реестр товара, при этом
значение активности, цена, количество и статус установлены в ноль. А еще добавляем им метаполе
для таймера, если товар станет акционным.

*/

/*
EXEC ap_VC_IM_GetNewProds @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1

--'2020-03-20 10:29:33.300' Старый блок процедур. Он использовался в те времена, когда ИМ был разделен на три сайта.
EXEC ap_VC_IM_GetNewProds @api_l = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID = 1, @admin_adress = 'vintagemarket-dp.myshopify.com', @Test = 1
EXEC ap_VC_IM_GetNewProds @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1
EXEC ap_VC_IM_GetNewProds @api_l = '822ee75ea06b63718ec6422bd0b77748', @key = 'c2bb7455131d0c407d241170acd20e58', @RegionID = 5, @admin_adress = 'vintagemarket-kh.myshopify.com', @Test = 1

EXEC ap_VC_IM_GetNewProds @api_l = 'ae2cd8b5024636640b29d6c8a7c5e1b7'
                        , @key = 'f61cd35b8e1ab1a377abd1c9f5a0e28d'
						, @RegionID = 1
						, @admin_adress = 'vintagemarket-dp.myshopify.com'
						, @ShopifyProdID = '2143479300193'
						, @Test = 1

*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[FIXED] Maslov Oleg '2020-01-09 10:51:48.488' При работе процедуры в джобе ответ, который возвращает API, режется до 512 символов.
    --то есть по умолчанию стоит "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
--[CHANGED] Maslov Oleg '2020-01-29 16:50:45.759' Перевод процедуры на версию API '2020-01'.
--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Ниже идет предварительная настройка временных таблиц и объявление переменных.

--[FIXED] Maslov Oleg '2020-01-09 10:51:48.488' При работе процедуры в джобе ответ, который возвращает API, режется до 512 символов.
    --то есть по умолчанию стоит "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
SET TEXTSIZE 2147483647;
SET NOCOUNT ON

IF @api_l = '' OR @key = '' OR @RegionID = -1 AND @admin_adress = ''
BEGIN
	RETURN;
END;

IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(Prods XML)

IF OBJECT_ID (N'tempdb..#new_prods',N'U') IS NOT NULL DROP TABLE #new_prods
CREATE TABLE #new_prods
(	ShopifyID BIGINT,
    ShopifyInvID BIGINT,
	ProdID BIGINT,
	IsActive BIT,
	Price NUMERIC(21, 9),
	DiscountPrice NUMERIC(21, 9),
	DiscountActive BIT,
	QtyDp NUMERIC(21, 9),
	QtyKv NUMERIC(21, 9),
	QtyKh NUMERIC(21, 9),
	--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
	--Qty NUMERIC(21, 9),
	--AccQty NUMERIC(21, 9),
	CreateDate SMALLDATETIME,
	UpdateDate SMALLDATETIME,
	UpdateState INT)

DECLARE @temp TABLE (TempRow VARCHAR(MAX))

DECLARE @ShopifyID BIGINT

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
	   ,@site VARCHAR(3000) = 'https://' + @api_l + ':' + @key + '@' + @admin_adress
	   ,@site_s VARCHAR(3000) = 'https://' + @admin_adress

--Et spiritus... Ancer! Crus! Vox! Socer!!! *ХЛОП* (И тишина)
IF @Test != 0
BEGIN
	SET @for_proxy = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000014DBC39169721A1CC037D82C2C82AF60EA2DB4A2727EDD9040D5AFD5A589187C)))
END;

DECLARE @SQL_Select NVARCHAR(MAX), @table_id INT, @IM_table VARCHAR(100), @outs VARCHAR(50)

--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
SELECT @IM_table = 'r_ShopifyProds'--(SELECT RefName FROM r_Uni WHERE RefTypeID = 1000000015 AND RefID = @RegionID)
--SELECT @IM_table 

SET @SQL_Select = 'IF EXISTS(SELECT TOP 1 1 FROM '
				+ @IM_table
				+ ') BEGIN SELECT TOP 1 @out = CAST(ShopifyID AS VARCHAR(50)) FROM '
				+ @IM_table
				+ ' ORDER BY ShopifyID DESC END; ELSE BEGIN SELECT @out = 0 END;'

EXEC sp_executesql @SQL_Select, N'@out VARCHAR(50) OUT', @outs OUT   

--[CHANGED] Maslov Oleg '2020-01-29 16:50:45.759' Перевод процедуры на версию API '2020-01'.
SELECT
	   --@URL = @site + '/admin/api/2019-04/products.xml?limit=250;fields=id,variants,created-at;since_id='
	   @URL = @site + '/admin/api/2020-01/products.xml?limit=250;fields=id,variants,created-at;since_id='
			+ @outs
			--Вытягиваем ShopifyID последнего товара.
			--+ (SELECT TOP 1 CAST(ShopifyID AS VARCHAR(50)) FROM r_ShopifyProdsDp ORDER BY ShopifyID DESC)
	  ,@methodName = 'GET'
	  ,@proxy = '2'
	  ,@proxySettings = '10.1.0.16:8080'

--Для контроля в тестовом режиме.
IF @Test = 1
BEGIN
	SELECT @URL

	SELECT 
	       @URL = @site + '/admin/api/2020-01/products/'
	            + @ShopifyProdID
				+ '.xml?limit=250;fields=id,variants,created-at'
	SELECT @URL
END;

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
		GOTO destroy
		RETURN
	END

	-- Get status text
	EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText out 
	EXEC sp_OAGetProperty @objectID, 'Status', @status out 
	--select hResult=@hResult, status=@status, statusText=@statusText, methodName=@methodName

	-- Get response text
	INSERT INTO @temp
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

END;

UPDATE @temp SET TempRow = CASE WHEN @Test = 1
								 THEN '<products> ' + REPLACE(TempRow, '<?xml version="1.0" encoding="UTF-8"?>', '') + '</products>'
								 ELSE REPLACE(TempRow, '<?xml version="1.0" encoding="UTF-8"?>', '') END;

--Если новых товаров нет, то выход.
IF (SELECT LEN(TempRow) FROM @temp) <= 30
BEGIN
 RETURN
END;

INSERT INTO #xml
SELECT * FROM @temp

DECLARE @prods TABLE (ProdInfo XML)

INSERT INTO @prods
SELECT CAST(Prods AS XML) FROM #xml

--Здесь новый товар записывается в реестр.
--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
--INSERT INTO #new_prods (ShopifyID, ShopifyInvID, ProdID, IsActive, Price, DiscountPrice, DiscountActive, Qty, AccQty, CreateDate, UpdateDate, UpdateState)
INSERT INTO #new_prods (ShopifyID, ShopifyInvID, ProdID, IsActive, Price, DiscountPrice, DiscountActive, QtyDp, QtyKv, QtyKh, CreateDate, UpdateDate, UpdateState)
SELECT CAST (pr.query('data(id)') AS VARCHAR(20)) 'ShopifyID'
	  ,0
	  ,CASE WHEN CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(10)) LIKE '%[^0-9]%' 
			THEN 0
			ELSE CAST( (CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(10)) ) AS INT) END 'ProdID'
	  ,0,0,0,0,0,0,0
	  ,CAST ( SUBSTRING( (CAST (pr.query('data(created-at)') AS VARCHAR(100)) ), 1,CHARINDEX('T', (CAST (pr.query('data(created-at)') AS VARCHAR(100)) ) ) - 1 ) AS DATE) 'DocDate'
	  ,GETDATE()
	  ,CASE WHEN CAST (pr.query('data(variants/variant/sku)') AS VARCHAR(10)) LIKE '%[^0-9]%' 
			THEN -1
			ELSE 4 END 'UpdateState'
FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr) --) q

IF @Test != 0
BEGIN
	SELECT * FROM #new_prods

	GOTO destroy
END;

SELECT @table_id = (SELECT OBJECT_ID('tempdb..#new_prods') )

SET @SQL_Select = 'INSERT INTO '
				+ @IM_table 
				+ ' (ShopifyID, ShopifyInvID, ProdID, IsActive, Price, DiscountPrice, DiscountActive, QtyDp, QtyKv, QtyKh, CreateDate, UpdateDate, UpdateState)'
				+ ' SELECT ShopifyID, ShopifyInvID, ProdID, IsActive, Price, DiscountPrice, DiscountActive, QtyDp, QtyKv, QtyKh, CreateDate, UpdateDate, UpdateState FROM '
				--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
				--+ ' (ShopifyID, ShopifyInvID, ProdID, IsActive, Price, DiscountPrice, DiscountActive, Qty, AccQty, CreateDate, UpdateDate, UpdateState)'
				--+ ' SELECT ShopifyID, ShopifyInvID, ProdID, IsActive, Price, DiscountPrice, DiscountActive, Qty, AccQty, CreateDate, UpdateDate, UpdateState FROM '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)

EXEC sp_executesql @SQL_Select  

--Создаем метаполе, которое будет использоваться при установке акции.
DECLARE CREATEMETAFIELD CURSOR LOCAL FAST_FORWARD 
FOR
SELECT ShopifyID
FROM #new_prods
WHERE UpdateState != -1
--FROM r_ShopifyProdsDp WITH(NOLOCK)
--WHERE UpdateState = 4 

OPEN CREATEMETAFIELD
	FETCH NEXT FROM CREATEMETAFIELD INTO @ShopifyID
WHILE @@FETCH_STATUS = 0
BEGIN
		EXEC ap_VC_IM_CreateMetafield @key = @key, @RegionID = @RegionID,  @admin_adress =  @admin_adress, @ShopifyID = @ShopifyID
		
		SET @SQL_Select = 'UPDATE '
				+ @IM_table
				+ ' SET UpdateDate = GETDATE(), UpdateState = 0	WHERE ShopifyID = '
				+ (SELECT CAST(@ShopifyID AS VARCHAR(100)) )

		EXEC sp_executesql @SQL_Select 

	FETCH NEXT FROM CREATEMETAFIELD INTO @ShopifyID
END
CLOSE CREATEMETAFIELD
DEALLOCATE CREATEMETAFIELD

destroy:
	EXEC sp_OADestroy @objectID
	IF OBJECT_ID (N'tempdb..#new_prods',N'U') IS NOT NULL DROP TABLE #new_prods
	IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml

END