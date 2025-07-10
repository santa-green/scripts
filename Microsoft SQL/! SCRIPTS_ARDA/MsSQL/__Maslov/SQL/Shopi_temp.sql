IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(XML VARCHAR(MAX))

IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
CREATE TABLE #shopi_ids
(ShopifyID BIGINT
,ShopifyInventoryID BIGINT)

DECLARE @temp TABLE (res VARCHAR(MAX))

DECLARE @Shopify_inventory_ID BIGINT
	   ,@Qty INT

DECLARE
	@URL VARCHAR(MAX),
	@methodName VARCHAR(50),
	@proxy VARCHAR(50), 
	@proxySettings VARCHAR(50),
	@objectID INT,
	@hResult INT,
	@source VARCHAR(255),
	@desc VARCHAR(255),
	@ids VARCHAR(MAX),
	--@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000068D4AB26848B654D3149C9EC9E19CBD586F805D3F10AFE5B9C9F516E87CE330A ))),
	@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x010000005EDD038C9720FD48CF6404E050191A8AD74778B091B24135EB0DFEDA1B09977D ))),
	--@shopify_stock_id VARCHAR(50) = '19817496689', --kiev
	@shopify_stock_id VARCHAR(50) = '21980545121', --dnepr
	--==========================================================================
	--Далее выбираем ИМ, в котором будем работать.
	--==========================================================================
	--@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d'--dnepr = 1
	@site VARCHAR(3000) = 'https://vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d'--dnepr = 1

DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)


DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR
SELECT ShopifyID--, ProdID
FROM r_ShopifyProdsDp q WITH(NOLOCK)
WHERE ShopifyID NOT IN (2117703532641, 2117682888801, 2117709725793)
--SELECT Shopify_inventory_ID, Qty FROM #rems 

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @Shopify_inventory_ID
WHILE @@FETCH_STATUS = 0
BEGIN
		
			SELECT --2453975859313
				@URL = @site + '/admin/api/2019-04/products/'
					   + CAST(@Shopify_inventory_ID AS VARCHAR(50))
					   +'/metafields.json',
					   --+'.json',
					   --+'/metafields.xml?key=discountDeadline&namespace=global&value=2010-01-10&value_type=string',
					   --+'/metafields.json?key=discountDeadline&namespace=global&value=2010-01-10&value_type=string',
					   --+'/metafields.json?{"metafield":{"key"="discountDeadline","namespace"="global","value"="2010-01-01","value_type"="string"}}',
				@methodName = 'POST'
				,@proxy = '2'
				,@proxySettings = '10.1.0.16:8080'
			--SELECT @URL
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

			-- set request headers
			--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'application/x-www-form-urlencoded'
			--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'application/json'
			EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'X-Shopify-Access-Token', @key
			EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'application/json'
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
			
			/*set credINTails*/
			EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, 'CONST\vintageshopify', @for_proxy, 1
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
			
--Здесь формируется XML, который будет вложен в URL-запрос.
--DECLARE @put VARCHAR(8000) = '<metafield><namespace>global</namespace><key>discountDeadline</key><value>2010-01-01</value><value-type>string</value-type></metafield>'
DECLARE @put VARCHAR(8000) = '{"metafield":{"namespace":"global","key":"discountDeadline","value":"2010-01-01","value_type":"string"}}'
--DECLARE @put VARCHAR(8000) = '{metafield:{key=discountDeadline,namespace=global,value=2010-01-01,value_type=string}}'
--DECLARE @put VARCHAR(8000) = '{"key"="discountDeadline","namespace"="global","value"="2010-01-01","value_type"="string"}'
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

	FETCH NEXT FROM CURSOR1 INTO @Shopify_inventory_ID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

SELECT * FROM #xml
/*
SELECT CONVERT(VARCHAR, GETDATE(), 23)
{"metafield":{"id":5676996362337,"namespace":"global","key":"discountDeadline","value":"2010-01-01","value_type":"string","description":null,"owner_id":2117715853409,"created_at":"2019-06-07T14:56:11+03:00","updated_at":"2019-06-07T14:56:11+03:00","owner_resource":"product","admin_graphql_api_id":"gid:\/\/shopify\/Metafield\/5676996362337"}}SELECT * FROM r_ShopifyProdsDp WHERE updatestate = 1
*/