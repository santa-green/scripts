IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(Orders VARCHAR(MAX))

DECLARE @temp TABLE (res VARCHAR(MAX))

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
	--@site VARCHAR(3000) = 'https://5023473df124058d09f41d9be664b065:a2039145b0d1a36620e09121aa1f933e@vintagemarket-dev.myshopify.com', @api_l VARCHAR(500) = '5023473df124058d09f41d9be664b065', @key VARCHAR(500) = 'a2039145b0d1a36620e09121aa1f933e', @RegionID INT = 5--kharkov = 5
	--@site VARCHAR(3000) = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com', @api_l VARCHAR(500) = '4a31bd883165bfd2bb8932c6287e7b9c', @key VARCHAR(500) = '6bab3199775c589f2922cd5bdb48a10b', @RegionID INT = 2--kiev = 2
	@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID INT = 1--dnepr = 1

DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)

SELECT --2453975859313
	@URL = @site + '/admin/api/2019-04/orders/count.xml'
	,@methodName = 'GET'
	,@proxy = '2', 
	@proxySettings = 'http://10.1.0.16:8080'

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
		/*
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
		*/
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
			GOTO destroy
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
			GOTO destroy
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
SELECT @URL = @site + '/admin/api/2019-04/orders.xml?limit=250;page=' + CAST(@count AS VARCHAR (5))

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
		/*
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
		*/
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
			GOTO destroy
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
			GOTO destroy
			RETURN
		END
END;

SELECT @count = @count -1
END;
UPDATE @temp SET res = REPLACE(res, '<?xml version="1.0" encoding="UTF-8"?>', '');

DECLARE @start_patern VARCHAR(256) = '<orders type="array">'
	   ,@end_patern VARCHAR(256) = '</orders>'
	   ,@some VARCHAR(MAX)
	   
SELECT @some = COALESCE(@some + '', '') + res FROM @temp

   
--WHILE(EXISTS(SELECT 1 FROM @temp WHERE CHARINDEX(@start_patern, res) != 0 AND CHARINDEX(@end_patern, res) != 0))
WHILE(CHARINDEX(@start_patern, @some) != 0 AND CHARINDEX(@end_patern, @some) != 0)
BEGIN
	SELECT @some = REPLACE(@some,@start_patern,'')
	SELECT @some = REPLACE(@some,@end_patern,'')
END;

SELECT @some = '<orders type="array">' + @some + '</orders>'
INSERT INTO #xml
SELECT @some

DECLARE @orders TABLE (Orders XML)

INSERT INTO @orders
SELECT CAST(Orders AS XML) FROM #xml

INSERT INTO t_IMOrders
SELECT CAST ( CAST (ord.query('data(order-number)') AS VARCHAR(20)) AS INT) + (@RegionID * 10000000) 'DocID'
	  ,CAST ( SUBSTRING( (CAST (ord.query('data(created-at)') AS VARCHAR(100)) ), 1,CHARINDEX('+', (CAST (ord.query('data(created-at)') AS VARCHAR(100)) ) ) - 1 ) AS SMALLDATETIME) 'DocDate'
	  ,CAST ( SUBSTRING( (CAST (ord.query('data(created-at)') AS VARCHAR(100)) ), 1,CHARINDEX('+', (CAST (ord.query('data(created-at)') AS VARCHAR(100)) ) ) - 1 ) AS SMALLDATETIME) 'ExpDate'
	  ,'00:00-23:59' 'ExpTime'
	  ,0 'ClientID'
	  --,CAST( CAST (ord.query('data(customer/id)') AS VARCHAR(20)) AS BIGINT) 'ClientID'
	  ,CAST (ord.query('data(shipping-address/country)') AS VARCHAR(1000))
		+ ', ' + CAST (ord.query('data(shipping-address/city)') AS VARCHAR(1000))
		+ ', ' + CAST (ord.query('data(shipping-address/address1)') AS VARCHAR(1000))
		+ ', ' + CAST (ord.query('data(shipping-address/address2)') AS VARCHAR(1000))
		+ ', ' + CAST (ord.query('data(shipping-address/zip)') AS VARCHAR(1000)) 'Address'
	  ,'' 'Notes'
	  ,24 'PayFormCode'
	  ,CAST (ord.query('data(customer/last-name)') AS VARCHAR(20)) + ' ' + CAST (ord.query('data(customer/first-name)') AS VARCHAR(20)) 'Recipient'
	  ,CAST (ord.query('data(customer/default-address/phone)') AS VARCHAR(50)) 'Phone'
	  ,CAST (ord.query('data(shipping-lines/shipping-line/code)') AS VARCHAR(50)) 'DeliveryType'
	  ,CAST( CAST ( CAST (ord.query('data(shipping-lines/shipping-line/price)') AS VARCHAR(100)) AS FLOAT) AS NUMERIC(21,2)) 'DeliveryPriceCC'
	  --,CAST (ord.query('data(shipping-lines/shipping-line/price)') AS VARCHAR(50)) 'DeliveryPriceCC'
	  ,1 'RegionID'
	  ,1 'CompType'
	  ,'' 'Code'
	  ,'<Нет дисконтной карты>' 'DCardID'
	  --,CAST( (CAST (ord.query('data(variants/variant/sku)') AS VARCHAR(10)) ) AS INT) 'ProdID'
	  ,CAST (ord.query('data(id)') AS VARCHAR(50)) 'ShopifyOrderID'
	  ,GETDATE()
	  ,0
FROM @orders ord CROSS APPLY ord.Orders.nodes('orders/order') orders(ord)

DECLARE @DocID VARCHAR(3000)
	   ,@ProdID VARCHAR(3000)
	   ,@Qty VARCHAR(3000)
	   ,@PurPrice VARCHAR(3000)
	   ,@Discount VARCHAR(3000)
	   ,@RemSchID INT
	   ,@IsVIP INT
	   ,@PosID INT = 1
	   ,@Flag BIT = 0

DECLARE @for_insert TABLE
  (DocID INT,
   PosID INT, 
   ProdID INT, 
   Qty INT, 
   PurPrice NUMERIC(21,9),
   Discount NUMERIC(21,9), 
   RemSchID VARCHAR(10),   
   IsVIP TINYINT)

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT CAST (ord.query('data(order-number)') AS VARCHAR(20)) 'DocID'
	  ,CAST (ord.query('data(line-items/line-item/sku)') AS VARCHAR(8000)) 'ProdID'
	  ,CAST (ord.query('data(line-items/line-item/quantity)') AS VARCHAR(8000)) 'Qty'
	  ,CAST (ord.query('data(line-items/line-item/price)') AS VARCHAR(8000)) 'PurPrice'
	  ,'_' 'Discount'
	  ,2 'RemSchID' --ОПТ = 1 или РОЗница = 2
	  ,0 'IsVIP'
FROM @orders ord CROSS APPLY ord.Orders.nodes('orders/order') orders(ord)
WHERE (CAST (ord.query('data(order-number)') AS VARCHAR(20))) != 1007

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @DocID, @ProdID, @Qty, @PurPrice, @Discount, @RemSchID, @IsVIP
WHILE @@FETCH_STATUS = 0	 
BEGIN
	
	WHILE(@Flag = 0)
	BEGIN
		IF (SELECT CHARINDEX(' ', @ProdID) ) != 0
		BEGIN

		INSERT INTO @for_insert (DocID, PosID, ProdID, Qty, PurPrice, Discount, RemSchID, IsVIP)
		SELECT CAST(@DocID AS INT) + (@RegionID * 10000000), @PosID, CAST(SUBSTRING(@ProdID, 1, CHARINDEX(' ', @ProdID)) AS INT), CAST(SUBSTRING(@Qty, 1, CHARINDEX(' ', @Qty)) AS INT), CAST(SUBSTRING(@PurPrice, 1, CHARINDEX(' ', @PurPrice)) AS NUMERIC(21,9)), 0, @RemSchID, @IsVIP
		
		SELECT @ProdID = SUBSTRING(@ProdID,CHARINDEX(' ', @ProdID) + 1, LEN(@ProdID))
			  ,@Qty = SUBSTRING(@Qty,CHARINDEX(' ', @Qty) + 1, LEN(@Qty))
			  ,@PurPrice = SUBSTRING(@PurPrice,CHARINDEX(' ', @PurPrice) + 1, LEN(@PurPrice))
			  ,@PosID = @PosID + 1
		END;

		ELSE
		BEGIN
		INSERT INTO @for_insert (DocID, PosID, ProdID, Qty, PurPrice, Discount, RemSchID, IsVIP)
		SELECT CAST(@DocID AS INT) + (@RegionID * 10000000), @PosID, CAST(@ProdID AS INT), CAST(@Qty AS INT), CAST(@PurPrice AS NUMERIC(21,9)), 0, @RemSchID, @IsVIP
		SELECT @Flag = 1, @PosID = 1
		END;
	END;
	
	SET @Flag = 0	
	FETCH NEXT FROM CURSOR1 INTO @DocID, @ProdID, @Qty, @PurPrice, @Discount, @RemSchID, @IsVIP
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

INSERT INTO t_IMOrdersD
SELECT * FROM @for_insert


destroy:
	EXEC sp_OADestroy @objectID

/*
IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(Orders XML)
DECLARE @temp TABLE (KEK VARCHAR(MAX))

DECLARE
	@URL VARCHAR(3000),
	@methodName VARCHAR(50),
	@proxy VARCHAR(50), 
	@proxySettings VARCHAR(50),
	@objectID INT,
	@hResult INT,
	@source VARCHAR(255),
	@desc VARCHAR(255)


SELECT --2453975859313
	 @URL = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2019-04/orders.xml'
	,@methodName = 'GET'
	,@proxy = '2', 
	@proxySettings = 'http://10.1.0.16:8080'

	

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
EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'X-Shopify-Access-Token', '6bab3199775c589f2922cd5bdb48a10b'
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
/*set credINTails
EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null,'const\vintagednepr1', 'dnepr20191',1
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
*/
-- send the request
--select 	requestBody = @requestBody
--DECLARE @put VARCHAR(256) = '<product><title>Long Island Iced Tea1</title></product>'
DECLARE @put VARCHAR(256) = '{ "location_id": 20630667377, "inventory_item_id": 22093349290097, "available": 7}'
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
select hResult=@hResult, status=@status, statusText=@statusText, methodName=@methodName

-- Get response text
INSERT INTO @temp
    EXEC sp_OAGetProperty @objectID, 'responseText'--, @responseText out

INSERT INTO #xml
	SELECT REPLACE(KEK, '<?xml version="1.0" encoding="UTF-8"?>', '') FROM @temp

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

INSERT INTO t_IMOrders
SELECT CAST ( CAST (ord.query('data(order-number)') AS VARCHAR(20)) AS INT) 'DocID'
	  ,CAST ( SUBSTRING( (CAST (ord.query('data(created-at)') AS VARCHAR(100)) ), 1,CHARINDEX('+', (CAST (ord.query('data(created-at)') AS VARCHAR(100)) ) ) - 1 ) AS SMALLDATETIME) 'DocDate'
	  ,CAST ( SUBSTRING( (CAST (ord.query('data(created-at)') AS VARCHAR(100)) ), 1,CHARINDEX('+', (CAST (ord.query('data(created-at)') AS VARCHAR(100)) ) ) - 1 ) AS SMALLDATETIME) 'ExpDate'
	  ,'00:00-23:00' 'ExpTime'
	  ,CAST( CAST (ord.query('data(customer/id)') AS VARCHAR(20)) AS BIGINT) 'ClientID'
	  ,CAST (ord.query('data(shipping-address/country)') AS VARCHAR(1000))
		+ ', ' + CAST (ord.query('data(shipping-address/city)') AS VARCHAR(1000))
		+ ', ' + CAST (ord.query('data(shipping-address/address1)') AS VARCHAR(1000))
		+ ', ' + CAST (ord.query('data(shipping-address/address2)') AS VARCHAR(1000))
		+ ', ' + CAST (ord.query('data(shipping-address/zip)') AS VARCHAR(1000)) 'Address'
	  ,'_' 'Notes'
	  ,24 'PayFormCode'
	  ,CAST (ord.query('data(customer/last-name)') AS VARCHAR(20)) + ' ' + CAST (ord.query('data(customer/first-name)') AS VARCHAR(20)) 'Recipient'
	  ,CAST (ord.query('data(customer/default-address/phone)') AS VARCHAR(50)) 'Phone'
	  ,CAST (ord.query('data(shipping-lines/shipping-line/code)') AS VARCHAR(50)) 'DeliveryType'
	  ,CAST( CAST ( CAST (ord.query('data(shipping-lines/shipping-line/price)') AS VARCHAR(100)) AS FLOAT) AS NUMERIC(21,2)) 'DeliveryPriceCC'
	  --,CAST (ord.query('data(shipping-lines/shipping-line/price)') AS VARCHAR(50)) 'DeliveryPriceCC'
	  ,1 'RegionID'
	  ,1 'CompType'
	  ,'' 'Code'
	  ,'<Нет дисконтной карты>' 'DCardID'
	  --,CAST( (CAST (ord.query('data(variants/variant/sku)') AS VARCHAR(10)) ) AS INT) 'ProdID'
	  ,GETDATE()
	  ,0
FROM #xml ord CROSS APPLY ord.Orders.nodes('orders/order') orders(ord)

DECLARE @DocID VARCHAR(3000)
	   ,@ProdID VARCHAR(3000)
	   ,@Qty VARCHAR(3000)
	   ,@PurPrice VARCHAR(3000)
	   ,@Discount VARCHAR(3000)
	   ,@RemSchID INT
	   ,@IsVIP INT
	   ,@PosID INT = 1
	   ,@Flag BIT

DECLARE @for_insert TABLE
  (DocID INT,
   PosID INT, 
   ProdID INT, 
   Qty INT, 
   PurPrice NUMERIC(21,9),
   Discount NUMERIC(21,9), 
   RemSchID VARCHAR(10),   
   IsVIP TINYINT)

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT CAST (ord.query('data(order-number)') AS VARCHAR(20)) 'DocID'
	  ,CAST (ord.query('data(line-items/line-item/sku)') AS VARCHAR(8000)) 'ProdID'
	  ,CAST (ord.query('data(line-items/line-item/quantity)') AS VARCHAR(8000)) 'Qty'
	  ,CAST (ord.query('data(line-items/line-item/price)') AS VARCHAR(8000)) 'PurPrice'
	  ,'_' 'Discount'
	  ,2 'RemSchID' --ОПТ = 1 или РОЗница = 2
	  ,0 'IsVIP'
FROM #xml ord CROSS APPLY ord.Orders.nodes('orders/order') orders(ord)
WHERE (CAST (ord.query('data(order-number)') AS VARCHAR(20))) != 1007

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @DocID, @ProdID, @Qty, @PurPrice, @Discount, @RemSchID, @IsVIP
WHILE @@FETCH_STATUS = 0	 
BEGIN
	
	WHILE(@Flag = 0)
	BEGIN
		IF (SELECT CHARINDEX(' ', @ProdID) ) != 0
		BEGIN

		INSERT INTO @for_insert (DocID, PosID, ProdID, Qty, PurPrice, Discount, RemSchID, IsVIP)
		SELECT CAST(@DocID AS INT), @PosID, CAST(SUBSTRING(@ProdID, 1, CHARINDEX(' ', @ProdID)) AS INT), CAST(SUBSTRING(@Qty, 1, CHARINDEX(' ', @Qty)) AS INT), CAST(SUBSTRING(@PurPrice, 1, CHARINDEX(' ', @PurPrice)) AS NUMERIC(21,9)), 0, @RemSchID, @IsVIP
		
		SELECT @ProdID = SUBSTRING(@ProdID,CHARINDEX(' ', @ProdID) + 1, LEN(@ProdID))
			  ,@Qty = SUBSTRING(@Qty,CHARINDEX(' ', @Qty) + 1, LEN(@Qty))
			  ,@PurPrice = SUBSTRING(@PurPrice,CHARINDEX(' ', @PurPrice) + 1, LEN(@PurPrice))
			  ,@PosID = @PosID + 1
		END;

		ELSE
		BEGIN
		INSERT INTO @for_insert (DocID, PosID, ProdID, Qty, PurPrice, Discount, RemSchID, IsVIP)
		SELECT CAST(@DocID AS INT), @PosID, CAST(@ProdID AS INT), CAST(@Qty AS INT), CAST(@PurPrice AS NUMERIC(21,9)), 0, @RemSchID, @IsVIP
		SELECT @Flag = 1, @PosID = 1
		END;
	END;
	
	SET @Flag = 0	
	FETCH NEXT FROM CURSOR1 INTO @DocID, @ProdID, @Qty, @PurPrice, @Discount, @RemSchID, @IsVIP
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

INSERT INTO t_IMOrdersD
SELECT * FROM @for_insert

SELECT * FROM t_IMOrders
SELECT * FROM t_IMOrdersD
--DELETE t_IMOrdersD

destroy:
	EXEC sp_OADestroy @objectID


https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2019-04/locations.
https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2019-04/inventory_levels.json?location_ids=20640170097


https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com/admin/api/2019-04/orders.xml
https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com/admin/api/2019-04/orders.xml?created_at_min=2019-05-23T10:36:56+03:00
  CREATE TABLE #TOrders
  (DocID INT, 
   DocDate SMALLDATETIME, 
   ExpDate SMALLDATETIME,
   ExpTime VARCHAR(250), 
   ClientID INT, 
   [Address] VARCHAR(250),
   Notes VARCHAR(250), 
   PayFormCode INT, 
   Recipient VARCHAR(250),
   Phone VARCHAR(250),
   DeliveryType VARCHAR(10), 
   DeliveryPriceCC NUMERIC(21,2),
   RegionID INT, 
   CompType TINYINT, 
   Code VARCHAR(20),
   DCardID VARCHAR(250),
   PRIMARY KEY CLUSTERED(DocID)) 

  CREATE TABLE #TOrdersD
  (DocID INT,
   PosID INT, 
   ProdID INT, 
   Qty INT, 
   PurPrice NUMERIC(21,9),
   Discount NUMERIC(21,9), 
   RemSchID VARCHAR(10),   
   IsVIP TINYINT,
   PRIMARY KEY CLUSTERED(DocID, PosID))


SELECT * FROM #xml
*/