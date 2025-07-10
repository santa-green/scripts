IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(XML VARCHAR(MAX))

DECLARE @Shopify_inventory_ID VARCHAR(20) --= '20226388885601'
	   ,@Qty INT --= 6

DECLARE
	@URL VARCHAR(3000),
	@methodName VARCHAR(50),
	@proxy VARCHAR(50), 
	@proxySettings VARCHAR(50),
	@objectID INT,
	@hResult INT,
	@source VARCHAR(255),
	@desc VARCHAR(255),
	--@shopify_stock_id VARCHAR(50) = '19817496689', --kiev
	@shopify_stock_id VARCHAR(50) = '21980545121', --dnepr
	--@site VARCHAR(3000) = 'https://5023473df124058d09f41d9be664b065:a2039145b0d1a36620e09121aa1f933e@vintagemarket-dev.myshopify.com', @api_l VARCHAR(500) = '5023473df124058d09f41d9be664b065', @key VARCHAR(500) = 'a2039145b0d1a36620e09121aa1f933e'--kharkov = 5
	--@site VARCHAR(3000) = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com', @api_l VARCHAR(500) = '4a31bd883165bfd2bb8932c6287e7b9c', @key VARCHAR(500) = '6bab3199775c589f2922cd5bdb48a10b'--kiev = 2
	@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d'--dnepr = 1

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR
SELECT ShopifyInventoryID, Qty--, ProdID
FROM r_ShopifyProdsDp WHERE Qty != 0 --ProdID = 802753
--SELECT Shopify_inventory_ID, Qty FROM #rems 

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @Shopify_inventory_ID, @Qty
WHILE @@FETCH_STATUS = 0
BEGIN
		
			SELECT --2453975859313
				@URL = @site + '/admin/api/2019-04/inventory_levels/set.json?location_id='
					   + @shopify_stock_id
					   + '&inventory_item_id=' + CAST(@Shopify_inventory_ID AS VARCHAR(50)) +'&available=' + CAST(@Qty AS VARCHAR(10)),
				@methodName = 'POST'
				,@proxy = '2', 
				@proxySettings = 'http://10.1.0.16:8080'

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
			EXEC @hResult = sp_OAMethod @objectID, 'SetCredentials', null, 'pashkovv@const.dp.ua', 'shopifypashkovv703148',0--'HTTPREQUEST_SETCREDENTIALS_FOR_SERVER'
			--EXEC @hResult = sp_OAMethod @objectID, 'SetCredentials', null, '4a31bd883165bfd2bb8932c6287e7b9c', '6bab3199775c589f2922cd5bdb48a10b',0--'HTTPREQUEST_SETCREDENTIALS_FOR_SERVER'
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
			--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'text/xml'
			--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'X-Shopify-Access-Token', 'Base:shopifypashkovv703148'
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
			
			/*set credINTails*/
			EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null,'const\vintagednepr1', 'dnepr20192',1
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
			--DECLARE @put VARCHAR(256) = '<product><title>Long Island Iced Tea1</title></product>'
			EXEC 	@hResult = sp_OAMethod @objectID, 'send', null--, @put
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

			declare @statusText VARCHAR(1000), @status VARCHAR(1000)
			-- Get status text
			EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText out 
			EXEC sp_OAGetProperty @objectID, 'Status', @status out 
			--select hResult=@hResult, status=@status, statusText=@statusText, methodName=@methodName

			-- Get response text
			INSERT INTO #xml
				 EXEC sp_OAGetProperty @objectID, 'responseText'--, @responseText out

			--SELECT * FROM #xml

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

	FETCH NEXT FROM CURSOR1 INTO @Shopify_inventory_ID, @Qty
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

SELECT * FROM #xml
/*
IF OBJECT_ID (N'tempdb..#rems',N'U') IS NOT NULL DROP TABLE #rems
CREATE TABLE #rems
(Shopify_inventory_ID VARCHAR(20),
 ProdID INT,
 Qty INT)


https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2019-04/products.xml?limit=250&page=1
https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2019-04/products/count.xml
https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2019-04/collects.xml
*/