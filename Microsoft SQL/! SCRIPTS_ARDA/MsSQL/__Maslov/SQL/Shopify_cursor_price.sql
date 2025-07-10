IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(XML VARCHAR(MAX))

IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
CREATE TABLE #shopi_ids
(ShopifyID BIGINT
,VariantID BIGINT)

DECLARE @temp TABLE (res VARCHAR(MAX))

DECLARE @ShopifyID BIGINT
	   ,@VariantID BIGINT
	   ,@Price NUMERIC(21, 9)
	   ,@DiscountPrice NUMERIC(21, 9)

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
	@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100),DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000013E17F3D297295630D0E69148FF43BC03C062E3DCBD06A1A121E308E40BAB847 ))),
	--@site VARCHAR(3000) = 'https://5023473df124058d09f41d9be664b065:a2039145b0d1a36620e09121aa1f933e@vintagemarket-kh.myshopify.com', @api_l VARCHAR(500) = '5023473df124058d09f41d9be664b065', @key VARCHAR(500) = 'a2039145b0d1a36620e09121aa1f933e'--kharkov = 5
	--@site VARCHAR(3000) = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com', @api_l VARCHAR(500) = '4a31bd883165bfd2bb8932c6287e7b9c', @key VARCHAR(500) = '6bab3199775c589f2922cd5bdb48a10b'--kiev = 2
	@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d'--dnepr = 1
DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)

SELECT --2453975859313
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

		--здесь выбери тот объект, который у тебя будет работать
		--EXEC 	@hResult = sp_OACreate 'MSXML2.ServerXMLHTTP.4.0', @objectID OUT
		EXEC 	@hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT
		--EXEC 	@hResult = sp_OACreate 'MSXML2.ServerXMLHttp', @objectID OUT
		--EXEC 	@hResult = sp_OACreate 'Microsoft.XMLHTTP', @objectID OUT
		--EXEC 	@hResult = sp_OACreate 'MSXML2.XMLHTTP', @objectID OUT

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
		EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URL, 'false'
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

		-- set request headers
		--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'text/xml'
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

		/*set credINTails*/
		EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null,'CONST\vintageshopify', @for_proxy,1
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

		--Set proxy
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
		
		-- send the request
		--select 	requestBody = @requestBody
		--DECLARE @put VARCHAR(256) = '<product><title>Long Island Iced Tea1</title></product>'
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
--end of get request

--<?xml version="1.0" encoding="UTF-8"?> <count type="integer">482</count> 
SELECT @count = CAST(SUBSTRING(res, CHARINDEX('<count type="integer">', res) + LEN('<count type="integer">'), CHARINDEX('</count>', res) - (CHARINDEX('<count type="integer">', res) + LEN('<count type="integer">')) ) AS FLOAT)
FROM @temp
DELETE @temp

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
SELECT @URL = @site + '/admin/api/2019-04/products.xml?limit=250;page=' + CAST(@count AS VARCHAR (5))

IF 1 = 1
BEGIN
		IF 	@methodName = ''
		BEGIN
			select FailPoINT = 'Method Name must be set'
			RETURN
		END 

		--здесь выбери тот объект, который у тебя будет работать
		--EXEC 	@hResult = sp_OACreate 'MSXML2.ServerXMLHTTP.4.0', @objectID OUT
		EXEC 	@hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT
		--EXEC 	@hResult = sp_OACreate 'MSXML2.ServerXMLHttp', @objectID OUT
		--EXEC 	@hResult = sp_OACreate 'Microsoft.XMLHTTP', @objectID OUT
		--EXEC 	@hResult = sp_OACreate 'MSXML2.XMLHTTP', @objectID OUT

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
		EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URL, 'false'
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

		-- set request headers
		--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'text/xml'
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
		/*
		declare @len INT
		set @len = len(@requestBody)
		EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Length', @len
		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = convert(varbinary(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'SetRequestHeader failed: Content-Length',
				MedthodName = @methodName
			GOTO destroy
			RETURN
		END
		*/
		/*set credINTails*/
		EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null,'CONST\vintageshopify', @for_proxy,1
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

		--Set proxy
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
		
		-- send the request
		--select 	requestBody = @requestBody
		--DECLARE @put VARCHAR(256) = '<product><title>Long Island Iced Tea1</title></product>'
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
UPDATE @temp SET res = REPLACE(res, '<?xml version="1.0" encoding="UTF-8"?>', '');

DECLARE @start_patern VARCHAR(256) = '<body-html>'
	   ,@end_patern VARCHAR(256) = '</body-html>'
	   ,@some VARCHAR(MAX)
	   
SELECT @some = COALESCE(@some + '', '') + res FROM @temp

   
--WHILE(EXISTS(SELECT 1 FROM @temp WHERE CHARINDEX(@start_patern, res) != 0 AND CHARINDEX(@end_patern, res) != 0))
WHILE(CHARINDEX(@start_patern, @some) != 0 AND CHARINDEX(@end_patern, @some) != 0)
BEGIN
--UPDATE @temp SET res = REPLACE(res, SUBSTRING(res, CHARINDEX(@start_patern, res), (CHARINDEX(@end_patern, res) - CHARINDEX(@start_patern, res)) + LEN(@end_patern) ), '')
SELECT @some = REPLACE(@some, SUBSTRING(@some, CHARINDEX(@start_patern, @some), (CHARINDEX(@end_patern, @some) - CHARINDEX(@start_patern, @some)) + LEN(@end_patern) ), '') 
	IF CHARINDEX('</products>', @some) != 0 OR CHARINDEX('<products type="array">', @some) != 0
	BEGIN	
	SELECT @some = REPLACE(@some,'<products type="array">','')
	SELECT @some = REPLACE(@some,'</products>','')
	END;
END;

SELECT @some = '<products type="array">' + @some + '</products>'
INSERT INTO #xml
SELECT @some

DECLARE @prods TABLE (ProdInfo XML)

INSERT INTO @prods
SELECT CAST(XML AS XML) FROM #xml
SELECT * FROM @prods

INSERT INTO #shopi_ids
SELECT CAST( CAST (pr.query('data(id)') AS VARCHAR(20)) AS BIGINT) 'ShopifyID'
	  ,CAST( CAST (pr.query('data(variants/variant/id)') AS VARCHAR(20)) AS BIGINT) 'VariantID'
FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr) --) q

--SELECT * FROM #shopi_ids

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR
SELECT m.ShopifyID, m.VariantID, d.Price, d.DiscountPrice
FROM #shopi_ids m 
JOIN r_ShopifyProdsDp d WITH(NOLOCK) ON d.ShopifyID = m.ShopifyID
WHERE d.Price != 0
--SELECT Shopify_inventory_ID, Qty FROM #rems

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ShopifyID, @VariantID, @Price, @DiscountPrice
WHILE @@FETCH_STATUS = 0	 
BEGIN

SELECT --2453975859313
	 @URL = @site + '/admin/api/2019-04/products/'
			+ CAST(@ShopifyID AS VARCHAR(50)) + '/variants/' + CAST(@VariantID AS VARCHAR(50)) + '.xml'
	,@methodName = 'PUT'
	,@proxy = '2'
	,@proxySettings = '10.1.0.16:8080'

IF 	@methodName = ''
BEGIN
	select FailPoINT = 'Method Name must be set'
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

--set Credentials
EXEC @hResult = sp_OAMethod @objectID, 'SetCredentials', null, @api_l, @key,0--'HTTPREQUEST_SETCREDENTIALS_FOR_SERVER'
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
--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'X-Shopify-Access-Token', '6bab3199775c589f2922cd5bdb48a10b'
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

EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null,'const\vintageshopify', @for_proxy,1
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

--Set proxy
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

-- send the request
--select 	requestBody = @requestBody
DECLARE @put VARCHAR(8000) = '<variant><price type="decimal">'
							 + CAST(ROUND( (CASE WHEN EXISTS(SELECT 1 FROM r_ShopifyProdsDp WHERE ShopifyID = @ShopifyID AND DiscountActive = 1) THEN @DiscountPrice ELSE @Price END), 2) AS VARCHAR(20))
							 + '</price><compare-at-price type="decimal">'
							 + CAST(ROUND( (CASE WHEN EXISTS(SELECT 1 FROM r_ShopifyProdsDp WHERE ShopifyID = @ShopifyID AND DiscountActive = 1) THEN @Price ELSE 0 END), 2) AS VARCHAR(20))
							 + '</compare-at-price> </variant>'
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

	FETCH NEXT FROM CURSOR1 INTO @ShopifyID, @VariantID, @Price, @DiscountPrice
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

SELECT * FROM #xml

global_destroy:
	EXEC sp_OADestroy @objectID