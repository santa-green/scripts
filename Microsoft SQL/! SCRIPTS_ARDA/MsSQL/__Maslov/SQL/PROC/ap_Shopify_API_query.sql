ALTER PROCEDURE [dbo].[ap_Shopify_API_query] @URI VARCHAR(3000), @QueryMethod VARCHAR(50), @API_creds VARCHAR(2000) = '', @LoginProxy VARCHAR(200), @ForProxy VARCHAR(100), @NeedLinkF BIT = 0, @PutText VARCHAR(MAX) = '', @Test INT = 0, @Status VARCHAR(1000) OUTPUT, @StatusText VARCHAR(1000) OUTPUT, @Link VARCHAR(8000) OUTPUT, @Answer VARCHAR(MAX) OUTPUT
AS
BEGIN
/*
��������� �������� API-������� ��������� ��� ������ � Shopify.

� �������� ���, ������ ��� "X-Shopify-Access-Token" ���� ������ � Shopify.
���� ����� "Link", ������ �����, ���� �������� ��� Shopify.

@URI - �����, �� ������� ����� ������ ������;
@QueryMethod - ����� ������� (GET,PUT,POST) P.S. �� ��������, ����� ��� ���� ��� � DELETE, �� �� ���� �� ������������;
@API_creds - ���������� ���� ��� �������������� � Shopify;
@LoginProxy - ����� ��� proxy;
@NeedLinkF - ���� ����� ������ �� ������, �� 1 (���� ����� ������ ����� ��������, �� ����� ����� �������� ��� "Link");
@PutText - ���� ��� PUT-������, �� � ��� ���������� ����� ���������� ��, ��� ������ ���� ����������;
@Test - 1 - ����� ������� ���������� � �����;
@Status OUTPUT - ������ ������ �� API (��������);
@StatusText OUTPUT - ������ ������ �� API (���������);
@Link OUTPUT - ���� ����� ����� ������, �� ������������ ��� ����� � ���� ����������;
@Answer OUTPUT - ����� API.
*/

/*

DECLARE @OutStatus VARCHAR(1000), @OutStatusText VARCHAR(1000), @OutLink VARCHAR(8000), @OutAnswer VARCHAR(MAX)
DECLARE @kyky VARCHAR(100) = 'asd'
	   ,@API_creds VARCHAR(2000) = --'4a31bd883165bfd2bb8932c6287e7b9c' + '</login>' + 
								   '6bab3199775c589f2922cd5bdb48a10b'

EXEC ap_Shopify_API_query @URI = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2020-01/orders.xml'
						 ,@QueryMethod = 'GET'
						 ,@API_creds = @API_creds
						 ,@LoginProxy = 'CONST\vintageshopify'
						 ,@ForProxy = @kyky
						 ,@NeedLinkF = 0
						 ,@PutText = ''
						 ,@Test = 1
						 ,@Status		= @OutStatus OUT
						 ,@StatusText	= @OutStatusText OUT
						 ,@Link			= @OutLink OUT
						 ,@Answer		= @OutAnswer OUT

SELECT @OutStatus AS '@OutStatus', @OutStatusText AS '@OutStatusText', @OutLink AS '@OutLink', @OutAnswer AS '@OutAnswer'

*/
	
	--�������� ������������ ������ REST API.
	IF (@QueryMethod IS NULL)
	   OR (@QueryMethod = '')
	   OR (@QueryMethod NOT IN ('GET','PUT','POST','DELETE','get','put','post','delete'))
	BEGIN
		RAISERROR('[dbo].[ap_Shopify_API_query] @QueryMethod is NULL, empty or incorrect. Try again!', 18, 1)
		RETURN
	END;
	
	--�������� @ForProxy �� �������.
	--��� ���������� ����� ����������� ����������, ��� ��� ������������ �� ���� ����� �������� � ���������� ������� ������ @LoginProxy.
	IF @ForProxy IS NULL OR (@ForProxy = '')
	BEGIN
		RAISERROR('[dbo].[ap_Shopify_API_query] @ForProxy is NULL or empty. Try again!', 18, 1)
		RETURN	
	END;

	--�������� ������ ��� ������ "PUT".
	IF (@QueryMethod IN ('PUT','put'))
	   AND ( (@PutText IS NULL) OR (@PutText = '') )
	BEGIN
		RAISERROR('[dbo].[ap_Shopify_API_query] @PutText must be set if API method is "PUT". Try again!', 18, 1)
		RETURN	
	END;

	--������ ���� ����������� � ���, ��� ������ ���� ����������.
	--� �� ����� ����� ����������� �� ���������� � ������ "if else".
	SELECT @Status = '', @StatusText = '', @Link = '', @Answer = ''

	DECLARE @ProxyParamNum VARCHAR(50) = '2'
		   ,@ProxyServer VARCHAR(50) = '10.1.0.16:8080'
		   ,@APILogin VARCHAR(500) = CASE WHEN CHARINDEX('</login>', @API_creds) != 0 THEN SUBSTRING(@API_creds, 1, CHARINDEX('</login>', @API_creds)-1 ) ELSE '' END
		   ,@APIKey VARCHAR(500) = CASE WHEN CHARINDEX('</login>', @API_creds) != 0 THEN SUBSTRING(@API_creds, CHARINDEX('</login>', @API_creds) + LEN('</login>'), LEN(@API_creds) ) ELSE @API_creds END
		   ,@objectID INT
		   ,@hResult INT
		   ,@source VARCHAR(255)
		   ,@desc VARCHAR(255)
		
	IF @Test = 1
	BEGIN
		SELECT @URI AS '@URI', @QueryMethod AS '@QueryMethod'
			  ,@API_creds AS '@API_creds'
			  ,@LoginProxy AS '@LoginProxy'
			  ,@NeedLinkF AS '@NeedLinkF'
			  ,@PutText AS '@PutText'
			  ,@APILogin AS '@APILogin'
			  ,@APIKey AS '@APIKey'
		RETURN
	END;
		   	
	--������� ��� ������.
	DECLARE @temp TABLE (res VARCHAR(MAX))
	
	--������� ������, ��� �������.
	EXEC @hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT

	IF @hResult <> 0
	BEGIN
		EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
		SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'Create failed',
				MedthodName = @QueryMethod,
				@URI AS '@URI'
		GOTO destroy
		RETURN
	END

	-- open the destination URI with Specified method
	EXEC @hResult = sp_OAMethod @objectID, 'open', NULL, @QueryMethod, @URI, 'false'
	IF @hResult <> 0
	BEGIN
		EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
		SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
			source = @source, 
			description = @desc,
			FailPoINT = 'Open failed',
			MedthodName = @QueryMethod,
			@URI AS '@URI'
		GOTO destroy
		RETURN
	END

	IF (@QueryMethod IN ('PUT','put'))
	BEGIN
		--set Credentials
		EXEC @hResult = sp_OAMethod @objectID, 'SetCredentials', NULL, @APILogin, @APIKey, 0
		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'SetCredentials failed',
				MedthodName = @QueryMethod,
				@URI AS '@URI'
			GOTO destroy
			RETURN
		END

		-- set request headers
		EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', NULL, 'Content-Type', 'text/xml'
		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'SetRequestHeader failed: Content-Type',
				MedthodName = @QueryMethod,
				@URI AS '@URI'
			GOTO destroy
			RETURN
		END
	END;
	ELSE
	BEGIN
		-- ������ ����� URL-������� ��� Shopify, ��� ����, ����� ������ ��������������.
		EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', NULL, 'X-Shopify-Access-Token', @APIKey
		IF @hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'SetRequestHeader failed: Content-Type',
				MedthodName = @QueryMethod,
				@URI AS '@URI'
			GOTO destroy
			RETURN
		END
	END;


	/*������������� ����� � ������ ��� ������-�������.*/
	EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', NULL, @LoginProxy, @ForProxy, 1
	IF @hResult <> 0
	BEGIN
		EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
		SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
			source = @source, 
			description = @desc,
			FailPoINT = 'setProxyCredentials failed',
			MedthodName = @QueryMethod,
			@URI AS '@URI'
		GOTO destroy
		RETURN
	END

	--������ ���, ����� URL-������ ����� ����� ������-������.
	EXEC @hResult = sp_OAMethod @objectID, 'setProxy', NULL,  @ProxyParamNum, @ProxyServer
	IF @hResult <> 0
	BEGIN
		EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
		SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
			source = @source, 
			description = @desc,
			FailPoINT = 'SetProxy',
			MedthodName = @QueryMethod,
			@URI AS '@URI'
		GOTO destroy
		RETURN
	END

	IF (@QueryMethod IN ('PUT','put'))
	BEGIN
		--���������� ������.
		EXEC @hResult = sp_OAMethod @objectID, 'send', NULL, @PutText
		IF 	@hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'Send failed',
				MedthodName = @QueryMethod,
				@URI AS '@URI'
			GOTO destroy
			RETURN
		END
	END;
	ELSE
	BEGIN
		--���������� ������.
		EXEC @hResult = sp_OAMethod @objectID, 'send', NULL
		IF 	@hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'Send failed',
				MedthodName = @QueryMethod,
				@URI AS '@URI'
			GOTO destroy
			RETURN
		END
	END;


	-- Get status text
	EXEC sp_OAGetProperty @objectID, 'StatusText', @StatusText OUT 
	EXEC sp_OAGetProperty @objectID, 'Status', @Status OUT

	--������ �� ��������� �������� �� ������ ����� � �� ������ ��� ����.
	--������� ���� ���� ���� �� ��������� �� ����� �������� ������, ���� ��� ����� �� �������.
	IF @NeedLinkF = 1
	BEGIN	
		--������� �� ��������� ������.
		EXEC @hResult = sp_OAMethod @objectID, 'getResponseHeader', @Link OUT, 'Link'
		IF 	@hResult <> 0
		BEGIN
			EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
			SELECT hResult = CONVERT(VARBINARY(4), @hResult), 
				source = @source, 
				description = @desc,
				FailPoINT = 'Link in header',
				MedthodName = @QueryMethod,
				@URI AS '@URI'
			GOTO destroy
			RETURN
		END
	END;

	-- Get response text
	INSERT INTO @temp
		EXEC sp_OAGetProperty @objectID, 'responseText'

	--� ������ � @temp �� ����� ������� ������ ����� ������, �� ���� ��.
	IF (SELECT COUNT(*) FROM @temp) > 1
	BEGIN
		RAISERROR('[dbo].[ap_Shopify_API_query] In @temp more then 1 row. WTF?!', 18, 1)
		SET @Answer = 'In @temp more then 1 row.'
		GOTO destroy
	END;

	--�����.
	SET @Answer = (SELECT TOP 1 res FROM @temp)

	--���� ������.
	IF @hResult <> 0
	BEGIN
		EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
		SELECT 	hResult = CONVERT(VARBINARY(4), @hResult), 
			source = @source, 
			description = @desc,
			FailPoINT = 'ResponseText failed',
			MedthodName = @QueryMethod,
			@URI AS '@URI'
		GOTO destroy
		RETURN
	END

destroy:
	EXEC sp_OADestroy @objectID

END;