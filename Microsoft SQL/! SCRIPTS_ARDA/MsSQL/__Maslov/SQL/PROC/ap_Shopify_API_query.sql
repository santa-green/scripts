ALTER PROCEDURE [dbo].[ap_Shopify_API_query] @URI VARCHAR(3000), @QueryMethod VARCHAR(50), @API_creds VARCHAR(2000) = '', @LoginProxy VARCHAR(200), @ForProxy VARCHAR(100), @NeedLinkF BIT = 0, @PutText VARCHAR(MAX) = '', @Test INT = 0, @Status VARCHAR(1000) OUTPUT, @StatusText VARCHAR(1000) OUTPUT, @Link VARCHAR(8000) OUTPUT, @Answer VARCHAR(MAX) OUTPUT
AS
BEGIN
/*
Процедура создания API-запроса заточеная для работы с Shopify.

А заточена она, потому что "X-Shopify-Access-Token" есть только в Shopify.
Плюс хэдер "Link", скорей всего, тоже уникален для Shopify.

@URI - адрес, на который будет сделан запрос;
@QueryMethod - метод запроса (GET,PUT,POST) P.S. По хорошему, кроме тех трех еще и DELETE, но он нами не используется;
@API_creds - уникальный ключ для аутентификации в Shopify;
@LoginProxy - логин для proxy;
@NeedLinkF - если нужна ссылка из хэдера, то 1 (если будет больше одной страницы, то нужно будет получать тег "Link");
@PutText - если это PUT-запрос, то в эту переменную будем вкладывать то, что должно быть отправлено;
@Test - 1 - вывод входных переменных и выход;
@Status OUTPUT - статус ответа от API (числовой);
@StatusText OUTPUT - статус ответа от API (текстовый);
@Link OUTPUT - если нужна будет ссылка, то возвращаться она будет в этой переменной;
@Answer OUTPUT - ответ API.
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
	
	--Проверка корректности метода REST API.
	IF (@QueryMethod IS NULL)
	   OR (@QueryMethod = '')
	   OR (@QueryMethod NOT IN ('GET','PUT','POST','DELETE','get','put','post','delete'))
	BEGIN
		RAISERROR('[dbo].[ap_Shopify_API_query] @QueryMethod is NULL, empty or incorrect. Try again!', 18, 1)
		RETURN
	END;
	
	--Проверка @ForProxy на пустоту.
	--Эту переменную нужно максимально ограничить, так как неправильный ее ввод может привести к блокировке учетной записи @LoginProxy.
	IF @ForProxy IS NULL OR (@ForProxy = '')
	BEGIN
		RAISERROR('[dbo].[ap_Shopify_API_query] @ForProxy is NULL or empty. Try again!', 18, 1)
		RETURN	
	END;

	--Проверка текста для метода "PUT".
	IF (@QueryMethod IN ('PUT','put'))
	   AND ( (@PutText IS NULL) OR (@PutText = '') )
	BEGIN
		RAISERROR('[dbo].[ap_Shopify_API_query] @PutText must be set if API method is "PUT". Try again!', 18, 1)
		RETURN	
	END;

	--Теперь есть уверенность в том, что внутри этих переменных.
	--И не нужно будет прописывать их назначение в блоках "if else".
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
		   	
	--Таблица для ответа.
	DECLARE @temp TABLE (res VARCHAR(MAX))
	
	--Создаем объект, для запроса.
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
		-- Особый хэдер URL-запроса для Shopify, для того, чтобы обойти аутентификацию.
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


	/*Устанавливаем логин и пароль для прокси-сервера.*/
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

	--Делаем так, чтобы URL-запрос пошел через прокси-сервер.
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
		--Отправляем запрос.
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
		--Отправляем запрос.
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

	--Ссылка на следующую страницу не всегда нужна и не всегда она есть.
	--Поэтому если этот блок не выключать он будет выдавать ошибку, хотя это будет не ошибкой.
	IF @NeedLinkF = 1
	BEGIN	
		--Достаем из заголовка ссылки.
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

	--В теории в @temp не может попасть больше одной строки, но мало ли.
	IF (SELECT COUNT(*) FROM @temp) > 1
	BEGIN
		RAISERROR('[dbo].[ap_Shopify_API_query] In @temp more then 1 row. WTF?!', 18, 1)
		SET @Answer = 'In @temp more then 1 row.'
		GOTO destroy
	END;

	--Ответ.
	SET @Answer = (SELECT TOP 1 res FROM @temp)

	--Если ошибка.
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