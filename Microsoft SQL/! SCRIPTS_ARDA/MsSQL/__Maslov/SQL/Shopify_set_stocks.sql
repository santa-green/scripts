IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(XML VARCHAR(MAX))

DECLARE @ShopifyID BIGINT = 2117679775841
	   ,@VariantID BIGINT = 19878420578401

DECLARE
	@URL VARCHAR(3000),
	@methodName VARCHAR(50) = 'PUT',
	@proxy VARCHAR(50), 
	@proxySettings VARCHAR(50),
	@objectID INT,
	@hResult INT,
	@source VARCHAR(255),
	@desc VARCHAR(255),
	--@site VARCHAR(3000) = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com', @key VARCHAR(500) = '6bab3199775c589f2922cd5bdb48a10b', @api_l VARCHAR(500) = '4a31bd883165bfd2bb8932c6287e7b9c'
	@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7'

--DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
--FOR
--SELECT ShopifyID, VariantID FROM r_ShopifyProdsDp WHERE Price != 0
--SELECT ShopifyID, VariantID FROM r_ShopifyProdsDp WHERE ProdID = 602364
----SELECT Shopify_inventory_ID, Qty FROM #rems

--OPEN CURSOR1
--	FETCH NEXT FROM CURSOR1 INTO @ShopifyID, @VariantID
--WHILE @@FETCH_STATUS = 0	 
--BEGIN

SELECT --2453975859313
	@URL = @site + '/admin/api/2019-04/products/'
			+ CAST(@ShopifyID AS VARCHAR(50)) + '/variants/' + CAST(@VariantID AS VARCHAR(50)) + '.xml'
	--,@proxy = '2', 
	--@proxySettings = 'http://10.1.0.16:8080'

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

-- send the request
--select 	requestBody = @requestBody
DECLARE @put VARCHAR(8000) = '<inventory-management>shopify</inventory-management> '
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

declare @statusText VARCHAR(1000), @status VARCHAR(1000)
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

--	FETCH NEXT FROM CURSOR1 INTO @ShopifyID, @VariantID, @Price, @DiscountPrice
--END
--CLOSE CURSOR1
--DEALLOCATE CURSOR1

SELECT * FROM #xml