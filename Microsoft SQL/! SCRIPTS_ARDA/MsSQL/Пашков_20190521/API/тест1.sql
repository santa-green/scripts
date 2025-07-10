
DECLARE
	@URI varchar(2000),
	@methodName varchar(50),
	@requestBody varchar(8000),
	@responseText xml, --varchar(max),
	@proxy varchar(50), 
	@proxySettings varchar(50)

	IF OBJECT_ID (N'dbo.t_responseText', N'U') IS NOT NULL DROP TABLE dbo.t_responseText
	create table t_responseText (n INT IDENTITY, responsexml xml,responseText varchar(max) )


SELECT 
	--@URI = 'https://{username}:{password}@vintagemarket-dev.myshopify.com/admin/orders.xml',
	@URI = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/orders.xml',
	--@URI = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/products.xml',
	@methodName = 'GET',
	@requestBody = '',
	@proxy = '2', 
	@proxySettings = '10.1.0.16:8080'
	

DECLARE @objectID int
DECLARE @hResult int
DECLARE @source varchar(255), @desc varchar(255)

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
			FailPoint = 'Create failed',
			MedthodName = @methodName
	goto destroy
	return
END

/*open the destination URI with Specified method*/
EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URI, 'false'
IF @hResult <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hResult), 
		source = @source, 
		description = @desc,
		FailPoint = 'Open failed',
		MedthodName = @methodName
	goto destroy
	return
END

/*set credintails*/
--EXEC @hResult = sp_OAMethod @objectID, 'SetCredentials', null, 'pashkovv@const.dp.ua', 'shopifypashkovv703148',0--'HTTPREQUEST_SETCREDENTIALS_FOR_SERVER'
EXEC @hResult = sp_OAMethod @objectID, 'SetCredentials', null, '4a31bd883165bfd2bb8932c6287e7b9c', '6bab3199775c589f2922cd5bdb48a10b',0--'HTTPREQUEST_SETCREDENTIALS_FOR_SERVER'
IF @hResult <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hResult), 
		source = @source, 
		description = @desc,
		FailPoint = 'SetCredentials failed',
		MedthodName = @methodName
	goto destroy
	return
END

 /*set request headers*/
EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'text/xml'
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

declare @len int
set @len = len(@requestBody)
EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Length', @len
IF @hResult <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hResult), 
		source = @source, 
		description = @desc,
		FailPoint = 'SetRequestHeader failed: Content-Length',
		MedthodName = @methodName
	goto destroy
	return
END

EXEC @hResult = sp_OAMethod @objectID, 'setProxy', NULL,  @proxy, @proxySettings
IF @hResult <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hResult), 
		source = @source, 
		description = @desc,
		FailPoint = 'SetProxy'
	goto destroy
	return
END

/*sp_OAMethod usage:  ObjPointer int IN, MethodName varchar IN [, @returnval <any> OUT [, additional IN, OUT, or BOTH params]]*/
/*set credintails*/
EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null,'const\vintagednepr1', 'dnepr20191',1
IF @hResult <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hResult), 
		source = @source, 
		description = @desc,
		FailPoint = 'setProxyCredentials failed',
		MedthodName = @methodName
	goto destroy
	return
END

-- send the request
select 	requestBody = @requestBody
EXEC 	@hResult = sp_OAMethod @objectID, 'send', null--, @requestBody
IF 	@hResult <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hResult), 
		source = @source, 
		description = @desc,
		FailPoint = 'Send failed',
		MedthodName = @methodName
	goto destroy
	return
END


declare @statusText varchar(1000), @status varchar(1000)
-- Get status text
exec sp_OAGetProperty @objectID, 'StatusText', @statusText out 
exec sp_OAGetProperty @objectID, 'Status', @status out 
select hResult=@hResult, status=@status, statusText=@statusText, methodName=@methodName


-- Get response text
insert t_responseText (responseText) 
exec sp_OAGetProperty @objectID, 'responseText'--, @responseText out 
--select responseText=@responseText
--select @responseText
SELECT * FROM t_responseText

IF @hResult <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hResult), 
		source = @source, 
		description = @desc,
		FailPoint = 'ResponseText failed',
		MedthodName = @methodName
	goto destroy
	return
END

destroy:
	exec sp_OADestroy @objectID




