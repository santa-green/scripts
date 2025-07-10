IF OBJECT_ID (N'tempdb..#elda',N'U') IS NOT NULL DROP TABLE #elda
CREATE TABLE #elda
(XML VARCHAR(MAX))

    DECLARE
	@URI VARCHAR(2000),
	@methodName VARCHAR(50),
	@requestBody VARCHAR(8000),
	@responseText VARCHAR(8000),
	@proxy VARCHAR(50), 
	@proxySettings VARCHAR(50)


SELECT 
	@URI = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/orders.xml',
	--@URI = 'https://vintagemarket-dev.myshopify.com/admin/orders.xml',
	@methodName = 'GET',
	@requestBody = '<request></request>',
	@proxy = '2', 
	@proxySettings = 'http://10.1.0.16:8080'
	
	DECLARE @obj int 
    DECLARE @hr  int 
    DECLARE @msg VARCHAR(max) 
	DECLARE @source varchar(255), @desc varchar(255)   

	EXEC @hr = sp_OACreate 'MSXML2.XMLHTTP', @obj OUT
	--EXEC @hr = sp_OACreate 'MSXML2.ServerXMLHTTP', @obj OUT
    --EXEC @hr = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @obj OUT
    if @hr <> 0 begin set @Msg = 'sp_OACreate MSXML2.XMLHttp.3.0 failed' goto eh end

    exec @hr = sp_OAMethod @obj, 'open', NULL, @methodName, @URI, false
    if @hr <>0 begin set @msg = 'sp_OAMethod Open failed' goto eh end
/*
    exec @hr = sp_OAMethod @obj, 'setRequestHeader', NULL, 'Content-Type', 'application/json'
    if @hr <>0 begin set @msg = 'sp_OAMethod setRequestHeader failed' goto eh end


EXEC @hr = sp_OAMethod @obj, 'setProxy', NULL,  @proxy, @proxySettings
IF @hr <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @obj, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hr), 
		source = @source, 
		description = @desc,
		FailPoint = 'SetProxy'
	goto eh

END
*/
    EXEC @hr = sp_OAMethod @obj, SEND, NULL, ''
    IF 	@hr <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @obj, @source OUT, @desc OUT 
			SELECT 	hResult = convert(varbinary(4), @hr), 
				source = @source, 
				description = @desc,
				FailPoint = 'Send failed',
				MedthodName = @methodName
			goto eh
		END

INSERT INTO #elda
     EXEC @hr=sp_OAGetProperty @Obj,'ResponseText'
    
    SELECT * FROM #elda

    exec @hr = sp_OADestroy @obj

    

    eh:
	exec @hr = sp_OADestroy @obj