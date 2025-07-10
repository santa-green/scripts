ALTER PROCEDURE [dbo].[ap_VC_IM_SetPrice] @api_l VARCHAR(500) = '', @key VARCHAR(500) = '', @RegionID INT = -1, @admin_adress VARCHAR(500) = '', @Test INT = 0
AS
BEGIN
/*
��������� ��� �� ����� ��������-�������� (�� ��� � ������).

Brevis descriptio
� ������ ������ ������� ���� �������� �� ������������� ��������� ����.
���� ����� ����������� � ��������� �������: ���� ������� ���� � �� �� ����� (���������) ����
� ������, ���� ������� ��������� ���� � �� �� ��������� � �������� ����� � ������ (� ����� �������),
���� ������ ������ �� ������� ����� 1 (1 - ������, ��� ����� �������� ����), ���� �����
��������/��������� �����.
����� ������������ ��� ������ � �� ���� ������ ����������� �� �������� ������. ����� �����
� ������� ������ PUT �� API ����������� ���� �� ��.
���� ��� ���� ����:
<price> - ����, ������� ����� ������������ �� �����;
<compare-at-price> - � ������, ���� �� ����� ��������� �����, �� � ��� ���� ����������� ��������
����, � <price> - ���������.

*/

/*
EXEC ap_VC_IM_SetPrice @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 1, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1

--'2020-03-20 10:29:33.300' ������ ���� ��������. �� ������������� � �� �������, ����� �� ��� �������� �� ��� �����.
EXEC ap_VC_IM_SetPrice @api_l = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID = 1, @admin_adress = 'vintagemarket-dp.myshopify.com', @Test = 1
EXEC ap_VC_IM_SetPrice @api_l = '4a31bd883165bfd2bb8932c6287e7b9c', @key = '6bab3199775c589f2922cd5bdb48a10b', @RegionID = 2, @admin_adress = 'vintagemarket-dev.myshopify.com', @Test = 1
EXEC ap_VC_IM_SetPrice @api_l = '822ee75ea06b63718ec6422bd0b77748', @key = 'c2bb7455131d0c407d241170acd20e58', @RegionID = 5, @admin_adress = 'vintagemarket-kh.myshopify.com', @Test = 1
*/

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[FIXED] Maslov Oleg '2020-01-09 10:51:48.488' ��� ������ ��������� � ����� �����, ������� ���������� API, ������� �� 512 ��������.
			--�� ���� �� ��������� ����� "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
--[CHANGED] Maslov Oleg '2020-01-31 09:44:26.453' ������� ��������� �� ������ API '2020-01' (����� ��� �����).
--[FIXED] Maslov Oleg '2020-02-19 09:25:11.578' �������� ��������� �� �������� ���. AND m.UpdateState != 9
	--��� �������� ����� ���������� ���������, ��� ��� ��������� ������� ���������� ����� �������� ��������� ���. � ����� ��������� ����������� � "��������".
--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' ��������� �� ���� ����. � ������ � ��� �� ���� ������� ������ ����.
--[FIXED] Maslov Oleg '2020-05-07 13:50:36.333' ���� �� ���� ������, �� ������ ����� ��������� "VariantID" ������ ������ (Target string size is too small to represent the XML instance). ������� �� �����.
--[ADDED] Maslov Oleg '2020-05-20 17:46:42.475' ������� ���������� ������ � �����. ���� ����� ����� "Gift card". ��� ��� � ����� ������� ��������� ��� ���������� "variant", �������������� � "VariantID" ���� ���������.
											  --����� ������ �� ������ ������, ������ ��� ����� ������ "VariantID", ������� ��������� ��� ����, � ��������� ����������.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--���� ���� ��������������� ��������� ��������� ������ � ���������� ����������.

--[FIXED] Maslov Oleg '2020-01-09 10:51:48.488' ��� ������ ��������� � ����� �����, ������� ���������� API, ������� �� 512 ��������.
    --�� ���� �� ��������� ����� "SET TEXTSIZE 1024;" (1024/2 = 512 nchars).
SET TEXTSIZE 2147483647;
SET NOCOUNT ON

IF @api_l = '' OR @key = '' OR @RegionID = -1 AND @admin_adress = ''
BEGIN
	RETURN;
END;

DECLARE	@URI VARCHAR(3000)
	   ,@methodName VARCHAR(50)
	   ,@proxy VARCHAR(50)
	   ,@proxySettings VARCHAR(50)
	   ,@objectID INT
	   ,@hResult INT
	   ,@source VARCHAR(255)
	   ,@desc VARCHAR(255)
	   ,@count FLOAT
	   ,@login_proxy VARCHAR(200) = 'CONST\vintageshopify'
	   ,@for_proxy VARCHAR(100) = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x0100000068D4AB26848B654D3149C9EC9E19CBD586F805D3F10AFE5B9C9F516E87CE330A )))
	   --,@site VARCHAR(3000) = 'https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com', @api_l VARCHAR(500) = 'ae2cd8b5024636640b29d6c8a7c5e1b7', @key VARCHAR(500) = 'f61cd35b8e1ab1a377abd1c9f5a0e28d', @RegionID INT = 1--dnepr = 1
	   ,@site VARCHAR(3000) = 'https://' + @api_l + ':' + @key + '@' + @admin_adress

--������� ���������, ����� ��� ��������.
IF @Test != 0
BEGIN
	SET @for_proxy = (SELECT CONVERT(VARCHAR(100), DecryptByPassPhrase(ORIGINAL_LOGIN(), 0x010000006F172BCB88E67FBA563BEF67FB02F5319B61CD88F32C063328550C861DE6E0CD)))
END;

DECLARE @SQL_Select NVARCHAR(MAX), @table_id INT, @IM_table VARCHAR(100), @av VARCHAR(100), @outs VARCHAR(50)

--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' ��������� �� ���� ����. � ������ � ��� �� ���� ������� ������ ����.
SELECT @IM_table = 'r_ShopifyProds'--(SELECT RefName FROM r_Uni WHERE RefTypeID = 1000000015 AND RefID = @RegionID)

--[FIXED] Maslov Oleg '2020-02-19 09:25:11.578' �������� ��������� �� �������� ���. AND m.UpdateState != 9
	--��� �������� ����� ���������� ���������, ��� ��� ��������� ������� ���������� ����� �������� ��������� ���. � ����� ��������� ����������� � "��������".
SET @SQL_Select = 'IF (SELECT COUNT(*) FROM '
				+ @IM_table
				+ ' m JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID('
				+ (SELECT CAST(@RegionID AS VARCHAR (5) ) )
				+ ') WHERE (m.Price = 0 OR rpmp.PriceMC != m.Price) AND rpmp.PriceMC != 0 AND m.UpdateState != 9) <= 0 AND (SELECT COUNT(*) FROM '
				+ @IM_table
				+ ' m JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID('
				+ (SELECT CAST(@RegionID AS VARCHAR (5) ) )
				+ ') WHERE rpmp.PromoPriceCC != m.DiscountPrice AND rpmp.InUse = 1 AND m.UpdateState != 9) <= 0 AND (SELECT COUNT(*) FROM '
				+ @IM_table
				+ ' m WHERE m.UpdateState = 1) = 0 AND (SELECT COUNT(*) FROM (SELECT m.ProdID, m.DiscountActive, CASE WHEN (GETDATE() BETWEEN rpmp.BDate AND DATEADD(DAY, 1, rpmp.EDate)) THEN 1 ELSE 0 END DiscountActiveMP FROM '
				+ @IM_table
				+ ' m JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID('
				+ (SELECT CAST(@RegionID AS VARCHAR (5) ) )
				+ ')) AS q WHERE q.DiscountActiveMP != q.DiscountActive) <= 0 BEGIN SELECT @out = 0 END;'

EXEC sp_executesql @SQL_Select, N'@out VARCHAR(50) OUT', @outs OUT 
/*
IF  /*���� ���� � �� �� ��������� � ����� � ������ � ��� �� �������.*/
	(SELECT COUNT(*)
	FROM r_ShopifyProdsDp m
		JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID(@RegionID)
		WHERE (m.Price = 0 OR rpmp.PriceMC != m.Price) AND rpmp.PriceMC != 0) <= 0
	AND
	/*���� ��������� ���� �� ����� ��������� ���� � �� � ����� �������.*/
	(SELECT COUNT(*)
	 FROM r_ShopifyProdsDp m
		JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID(@RegionID)
		WHERE rpmp.PromoPriceCC != m.DiscountPrice AND rpmp.InUse = 1) <= 0
    AND
	/*���� �� �����-���� ������� ��� ���������� UpdateState = 1.*/
	(SELECT COUNT(*)
	 FROM r_ShopifyProdsDp m
		WHERE m.UpdateState = 1) = 0
	AND
	/*��������/��������� �����.*/
	(SELECT COUNT(*) FROM 
		(SELECT m.ProdID,
			    m.DiscountActive,
			    CASE WHEN (GETDATE() BETWEEN rpmp.BDate AND DATEADD(DAY, 1, rpmp.EDate)) THEN 1 ELSE 0 END DiscountActiveMP
		FROM r_ShopifyProdsDp m
		JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID(@RegionID)
		)q
		WHERE q.DiscountActiveMP != q.DiscountActive
	 ) <= 0*/
IF (SELECT CAST(@outs AS INT) ) = 0 AND @Test = 0
BEGIN
	RETURN
END;

IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
CREATE TABLE #xml
(XML VARCHAR(MAX))

IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
CREATE TABLE #shopi_ids
(ShopifyID BIGINT
,VariantID BIGINT
,Price NUMERIC(21, 9)
,DiscountPrice NUMERIC(21, 9))

SELECT @table_id = (SELECT OBJECT_ID('tempdb..#shopi_ids') )

DECLARE @temp TABLE (res VARCHAR(MAX))

DECLARE @ShopifyID BIGINT
	   ,@VariantID BIGINT
	   ,@Price NUMERIC(21, 9)
	   ,@DiscountPrice NUMERIC(21, 9)

SET @SQL_Select = 'UPDATE '
				+ @IM_table
				+ ' SET Price = rpmp.PriceMC, UpdateDate = GETDATE(), UpdateState = 1 FROM '
				+ @IM_table
				+ ' m JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID('
				+ (SELECT CAST(@RegionID AS VARCHAR (5) ) )
				+ ') WHERE (m.Price = 0 OR rpmp.PriceMC != m.Price) AND rpmp.PriceMC != 0 AND m.UpdateState = 0 AND m.ProdID != 0; UPDATE '
				+ @IM_table
				+ ' SET DiscountPrice = rpmp.PromoPriceCC, UpdateDate = GETDATE() FROM '
				+ @IM_table
				+ ' m JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID('
				+ (SELECT CAST(@RegionID AS VARCHAR (5) ) )
				+ ') WHERE rpmp.PromoPriceCC != m.DiscountPrice AND m.UpdateState = 0 AND m.ProdID != 0; UPDATE '
				+ @IM_table
				+ ' SET DiscountActive = q.DiscountActiveMP, UpdateDate = GETDATE(), UpdateState = 1 FROM (SELECT m.ProdID, m.DiscountActive, CASE WHEN (GETDATE() BETWEEN rpmp.BDate AND DATEADD(DAY, 1, rpmp.EDate)) THEN 1 ELSE 0 END DiscountActiveMP FROM '
				+ @IM_table
				+ ' m JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID('
				+ (SELECT CAST(@RegionID AS VARCHAR (5) ) )
				+ ')) AS q WHERE q.DiscountActiveMP != q.DiscountActive AND '
				+ @IM_table
				+ '.ProdID = q.ProdID AND '
				+ @IM_table
				+ '.UpdateState = 0 AND '
				+ @IM_table
				+ '.ProdID != 0;'

EXEC sp_executesql @SQL_Select 

/*���� ���� � �� �� ��������� � ����� � ������ � ��� �� �������, �� ��������� ���� � ������������� UpdateState = 1.
UPDATE r_ShopifyProdsDp SET Price = rpmp.PriceMC, UpdateDate = GETDATE(), UpdateState = 1
FROM r_ShopifyProdsDp m
	JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID(@RegionID)
	WHERE (m.Price = 0 OR rpmp.PriceMC != m.Price) AND rpmp.PriceMC != 0 AND m.UpdateState = 0*/

/*���� ��������� ���� �� ����� ��������� ���� � ��, �� ��������� ���� � ������������� UpdateState = 1.
UPDATE r_ShopifyProdsDp SET DiscountPrice = rpmp.PromoPriceCC, UpdateDate = GETDATE()
FROM r_ShopifyProdsDp m
	JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID(@RegionID)
	WHERE rpmp.PromoPriceCC != m.DiscountPrice AND m.UpdateState = 0*/

/*��������/��������� ����� � ������������� UpdateState = 1.
UPDATE r_ShopifyProdsDp SET DiscountActive = q.DiscountActiveMP, UpdateDate = GETDATE(), UpdateState = 1
FROM (SELECT m.ProdID,
			 m.DiscountActive,
			 CASE WHEN (GETDATE() BETWEEN rpmp.BDate AND DATEADD(DAY, 1, rpmp.EDate)) THEN 1 ELSE 0 END DiscountActiveMP
		FROM r_ShopifyProdsDp m
		JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = m.ProdID AND rpmp.PLID = dbo.af_IS_GetPLID(@RegionID)
	 )q
	 WHERE q.DiscountActiveMP != q.DiscountActive AND r_ShopifyProdsDp.ProdID = q.ProdID AND r_ShopifyProdsDp.UpdateState = 0
*/
DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000)

--Maslov Oleg '2020-01-31 09:44:26.453' ������� ��������� �� ������ API '2020-01'.
DECLARE @f INT = 0
WHILE(@f != 2)
BEGIN
--��������� ������ URL-�����, ������� �������� ������ 250 �������. 
SELECT @URI = CASE WHEN @f = 0
					THEN @site
					     --������� ������������ ���� �������.
					     + '/admin/api/2020-01/products.xml?limit=250;fields=id,variants,created-at'
					ELSE @URI END
	  ,@methodName = 'GET'
	  ,@proxy = '2' 
	  ,@proxySettings = '10.1.0.16:8080'

	IF 1 = 1
	BEGIN
			IF 	@methodName = ''
			BEGIN
				SELECT FailPoINT = 'Method Name must be set'
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
				GOTO global_destroy
				RETURN
			END

			-- open the destination URI with Specified method
			EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URI, 'false'
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

			-- ������ ����� URL-������� ��� Shopify, ��� ����, ����� ������ ��������������.
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

			/*������������� ����� � ������ ��� ������-�������.*/
			EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, @login_proxy, @for_proxy,1
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

			--������ ���, ����� URL-������ ����� ����� ������-������.
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
		
			--���������� ������.
			EXEC @hResult = sp_OAMethod @objectID, 'send', null
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

			--������� �� ��������� ������.
			DECLARE @link VARCHAR(8000)
			--EXEC @hResult = sp_OAMethod @objectID, 'getAllResponseHeaders', @link OUT
			EXEC @hResult = sp_OAMethod @objectID, 'getResponseHeader', @link OUT, 'Link'
			IF 	@hResult <> 0
			BEGIN
				EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT 
				SELECT 	hResult = convert(varbinary(4), @hResult), 
					source = @source, 
					description = @desc,
					FailPoINT = 'HEADER',
					MedthodName = @methodName
				GOTO global_destroy
				RETURN
			END

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

	--���� ��� ������ �� �������� "������".
	IF (SELECT CHARINDEX('rel="next"', @link)) = 0
	BEGIN
		SET @f = 2
	END;
	ELSE
	BEGIN
		SELECT @f = 1
			   --���� ������ �� �������� "������" ����, �� ������� ��.
			  ,@URI = SUBSTRING(PString,CHARINDEX('https://', PString), CHARINDEX('>; rel="next"', PString) - CHARINDEX('https://', PString)) FROM af_SplitString(@link, ',') WHERE PString LIKE '%rel="next"%'
	END;
END;


/*
--����� ������� ����� ���������� ������� �� ����� (��������� URL ������).
SELECT @URI = @site + '/admin/api/2019-04/products/count.xml'
	  ,@methodName = 'GET'
	  ,@proxy = '2' 
      ,@proxySettings = '10.1.0.16:8080'

--GET request	
IF 1 = 1
BEGIN
		IF 	@methodName = ''
		BEGIN
			SELECT FailPoINT = 'Method Name must be set'
			RETURN
		END 

		--������� ������, ��� �������.
		EXEC @hResult = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @objectID OUT

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

		-- open the destination URL with Specified method
		EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URI, 'false'
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

		-- ������ ����� URL-������� ��� Shopify, ��� ����, ����� ������ ��������������.
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

		/*������������� ����� � ������ ��� ������-�������.*/
		EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, @login_proxy, @for_proxy, 1
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

		--������ ���, ����� URL-������ ����� ����� ������-������.
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
		
		--���������� ������.
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
		
		--���� ������.
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

--������� �������� �� �������.
SELECT @count = CAST(SUBSTRING(res, CHARINDEX('<count type="integer">', res) + LEN('<count type="integer">'), CHARINDEX('</count>', res) - (CHARINDEX('<count type="integer">', res) + LEN('<count type="integer">')) ) AS FLOAT)
FROM @temp
DELETE @temp

--��������� ���������� �������.
/*
Description:
� Shopify ���������� ������������ �� ���������� �������, ������� ����� �������.
�� ��������� ����� ������� ������ 50 �������. � ���� ������� ����������� ���� 
������� �� 250 (������� Shopify).
������� ���� ����������� ���������� ������� (���), ������� ����� ����������.
*/
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
	--��������� ������ URL-�����, ������� ����� ��������� 250 ������� �� ��������. 
	SELECT @URI = @site
				--������� ������������ ���� �������.
				+ '/admin/api/2019-04/products.xml?limit=250;fields=id,variants,created-at;page='
				--��������.
				+ CAST(@count AS VARCHAR (5))

	IF 1 = 1
	BEGIN
			IF 	@methodName = ''
			BEGIN
				SELECT FailPoINT = 'Method Name must be set'
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
				GOTO global_destroy
				RETURN
			END

			-- open the destination URI with Specified method
			EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URI, 'false'
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

			-- ������ ����� URL-������� ��� Shopify, ��� ����, ����� ������ ��������������.
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

			/*������������� ����� � ������ ��� ������-�������.*/
			EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, @login_proxy, @for_proxy, 1
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

			--������ ���, ����� URL-������ ����� ����� ������-������.
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
		
			--���������� ������.
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
*/

--������� �����.
UPDATE @temp SET res = REPLACE(res, '<?xml version="1.0" encoding="UTF-8"?>', '');

--������ ������������ ���������� �����. � �������� VariantID ��� ������.
INSERT INTO #xml
SELECT * FROM @temp

DECLARE @prods TABLE (ProdInfo XML)

INSERT INTO @prods
SELECT CAST(XML AS XML) FROM #xml
SELECT * FROM @prods

INSERT INTO #shopi_ids
SELECT CAST( CAST (pr.query('data(id)') AS VARCHAR(20)) AS BIGINT) 'ShopifyID'
	  --[FIXED] Maslov Oleg '2020-05-07 13:50:36.333' ���� �� ���� ������, �� ������ ����� ��������� "VariantID" ������ ������ (Target string size is too small to represent the XML instance). ������� �� �����.
	  --,CAST( CAST (pr.query('data(variants/variant/id)') AS VARCHAR(20)) AS BIGINT) 'VariantID'
	  ,prods.pr.value('(variants/variant/id)[1]', 'bigint') AS 'VariantID'
	  ,0
	  ,0
FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr) --) q

IF @Test = 2
BEGIN
	
	SELECT CAST( CAST (pr.query('data(id)') AS VARCHAR(20)) AS BIGINT) 'ShopifyID'
		  --[FIXED] Maslov Oleg '2020-05-07 13:50:36.333' ���� �� ���� ������, �� ������ ����� ��������� "VariantID" ������ ������ (Target string size is too small to represent the XML instance). ������� �� �����.
		  ,pr.query('data(variants/variant/id)') 'VariantID'
		  ,prods.pr.value('(variants/variant/id)[1]', 'bigint') AS 'VariantID'
		  ,0
		  ,0
	FROM @prods p CROSS APPLY p.ProdInfo.nodes('products/product') prods(pr) --) q

	GOTO global_destroy

END;

SET @SQL_Select = 'DELETE '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ' WHERE ShopifyID NOT IN (SELECT ShopifyID FROM '
				+ @IM_table
				+ ' WHERE UpdateState = 1) UPDATE ids SET Price = q.Price, DiscountPrice = q.DiscountPrice FROM '
				+ (SELECT name FROM tempdb.sys.tables WHERE object_id = @table_id)
				+ ' ids JOIN '
				+ @IM_table
				+ ' q WITH(NOLOCK) ON q.ShopifyID = ids.ShopifyID'

EXEC sp_executesql @SQL_Select

--����� ������� ������, ������� ����� ��������� ���� � ������� PUT.
DECLARE PRICE CURSOR LOCAL FAST_FORWARD 
FOR
SELECT TOP 200 m.ShopifyID, m.VariantID, m.Price, m.DiscountPrice--d.Price, d.DiscountPrice
FROM #shopi_ids m 
--JOIN r_ShopifyProdsDp d WITH(NOLOCK) ON d.ShopifyID = m.ShopifyID
--WHERE UpdateState = 1

OPEN PRICE
	FETCH NEXT FROM PRICE INTO @ShopifyID, @VariantID, @Price, @DiscountPrice
WHILE @@FETCH_STATUS = 0	 
BEGIN

	--����� ������������ ����� � ��� Variant (��� �������� ����).
	SELECT 
	       --@URI = @site + '/admin/api/2019-04/products/'
	       @URI = @site + '/admin/api/2020-01/products/'
				+ CAST(@ShopifyID AS VARCHAR(50)) + '/variants/' + CAST(@VariantID AS VARCHAR(50)) + '.xml'
		  ,@methodName = 'PUT'
		  ,@proxy = '2'
		  ,@proxySettings = '10.1.0.16:8080'

	IF 	@methodName = ''
	BEGIN
		select FailPoINT = 'Method Name must be set'
		RETURN
	END 

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
	EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URI, 'false'
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
	EXEC @hResult = sp_OAMethod @objectID, 'SetCredentials', null, @api_l, @key, 0
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

	EXEC @hResult = sp_OAMethod @objectID, 'setCredentials', null, @login_proxy, @for_proxy, 1
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

	SET @SQL_Select = 'SELECT @out = ROUND( (CASE WHEN (SELECT DiscountActive FROM '
					+ @IM_table
					+ ' WHERE ShopifyID = '
					+ (SELECT CAST(@ShopifyID AS VARCHAR (50) ) )
					+ ' AND DiscountActive = 1) = 1 THEN '
					+ (SELECT CAST(@DiscountPrice AS VARCHAR (50) ) )
					+ ' ELSE '
					+ (SELECT CAST(@Price AS VARCHAR (50) ) )
					+ ' END), 2)'

	EXEC sp_executesql @SQL_Select, N'@out VARCHAR(50) OUT', @outs OUT 

	--����� ����������� XML, ������� ����� ������ � URL-������.
	DECLARE @put VARCHAR(8000) = '<variant><price type="decimal">'
							   --+ CAST(ROUND( (CASE WHEN (SELECT DiscountActive FROM r_ShopifyProdsDp WHERE ShopifyID = @ShopifyID AND DiscountActive = 1) = 1 THEN @DiscountPrice ELSE @Price END), 2) AS VARCHAR(20))
							   + @outs
							   + '</price><compare-at-price type="decimal">'
							   --+ CAST(ROUND( (CASE WHEN (SELECT DiscountActive FROM r_ShopifyProdsDp WHERE ShopifyID = @ShopifyID AND DiscountActive = 1) = 1 THEN @Price ELSE 0 END), 2) AS VARCHAR(20))
							   --+ '</compare-at-price> </variant>'

	SET @SQL_Select = 'SELECT @out = ROUND( (CASE WHEN (SELECT DiscountActive FROM '
					+ @IM_table
					+ ' WHERE ShopifyID = '
					+ (SELECT CAST(@ShopifyID AS VARCHAR (50) ) )
					+ ' AND DiscountActive = 1) = 1 THEN '
					+ (SELECT CAST(@Price AS VARCHAR (50) ) )
					+ ' ELSE 0 END), 2)'

	EXEC sp_executesql @SQL_Select, N'@out VARCHAR(50) OUT', @outs OUT 

	SET @put = @put + @outs + '</compare-at-price> </variant>'

	--���������� ������.
	EXEC @hResult = sp_OAMethod @objectID, 'send', NULL, @put
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

	-----------------------------------Log block--------------------------------------------------
	SET @SQL_Select = 'SELECT @out = ProdID FROM '
				    + @IM_table
				    + ' WHERE ShopifyID = '
				    + (SELECT CAST(@ShopifyID AS VARCHAR(100)) )

	EXEC sp_executesql @SQL_Select, N'@out VARCHAR(50) OUT', @outs OUT 

	DECLARE @Value VARCHAR(4000) = SUBSTRING(@put,1,4000)
	DECLARE @ProdID_log INT = (SELECT CAST(@outs AS INT) )
	EXEC ap_VC_IM_Logs @RegionID = @RegionID, @UpdateState = 1, @ProdID = @ProdID_log, @Value = @Value, @Status = @status, @StatusText = @statusText
	-----------------------------------Log block--------------------------------------------------

	SET @SQL_Select = 'IF '
					+ (SELECT CAST(@status AS VARCHAR(10) ))
					--���� � ������ ����� �� �������, �� ������ ������ ������ ���������� 0.
					+ ' = 200 AND (SELECT DiscountActive FROM '
					+ @IM_table
					+ ' WHERE ShopifyID = '
					+ (SELECT CAST(@ShopifyID AS VARCHAR (50) ) )
					+ ') = 0 BEGIN UPDATE '
					+ @IM_table
					+ ' SET UpdateDate = GETDATE(), UpdateState = 0 WHERE ShopifyID = '
					+ (SELECT CAST(@ShopifyID AS VARCHAR (50) ) )
					--���� ����� �� ������ �������, �� ���������� ��� �� ���������� �������.
					+ ' END; ELSE IF '
					+ (SELECT CAST(@status AS VARCHAR(10) ))
					+ ' = 200 AND (SELECT DiscountActive FROM '
					+ @IM_table
					+ ' WHERE ShopifyID = '
					+ (SELECT CAST(@ShopifyID AS VARCHAR (50) ) )
					+ ') = 1 BEGIN UPDATE '
					+ @IM_table
					+ ' SET UpdateDate = GETDATE(), UpdateState = 5	WHERE ShopifyID = '
					+ (SELECT CAST(@ShopifyID AS VARCHAR (50) ) )
					+ ' END;'

	EXEC sp_executesql @SQL_Select 
	/*
	IF (SELECT CAST(@status AS INT)) = 200 AND (SELECT DiscountActive FROM r_ShopifyProdsDp WHERE ShopifyID = @ShopifyID) = 0
	BEGIN
		UPDATE r_ShopifyProdsDp SET UpdateDate = GETDATE(), UpdateState = 0
			WHERE ShopifyID = @ShopifyID
	END;
	ELSE IF (SELECT CAST(@status AS INT)) = 200 AND (SELECT DiscountActive FROM r_ShopifyProdsDp WHERE ShopifyID = @ShopifyID) = 1
	BEGIN
		UPDATE r_ShopifyProdsDp SET UpdateDate = GETDATE(), UpdateState = 5
			WHERE ShopifyID = @ShopifyID
	END;
	*/
	-- Get response text
	INSERT INTO #xml
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

	destroy:
		EXEC sp_OADestroy @objectID

	FETCH NEXT FROM PRICE INTO @ShopifyID, @VariantID, @Price, @DiscountPrice
END
CLOSE PRICE
DEALLOCATE PRICE


global_destroy:
	EXEC sp_OADestroy @objectID
	IF OBJECT_ID (N'tempdb..#shopi_ids',N'U') IS NOT NULL DROP TABLE #shopi_ids
	IF OBJECT_ID (N'tempdb..#xml',N'U') IS NOT NULL DROP TABLE #xml
END