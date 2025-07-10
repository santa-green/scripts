USE [Elit_TEST]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[af_CamparyClientsFromDelivery] (
	@tmp_DeliveryCampary VARCHAR(MAX)
	)
RETURNS @out TABLE (
	OutletID INT NOT NULL
	,OutletName VARCHAR(401) NULL
	,OutletAddress VARCHAR(200) NULL
	,ClientID INT NOT NULL
	,ClientName VARCHAR(200) NOT NULL
	)
AS
BEGIN
/*
DECLARE @tmp_DeliveryCampary VARCHAR(200)
set @tmp_DeliveryCampary = 'tmp_CamparyDelivery4'

IF OBJECT_ID (N'dbo.tmp_CamparyClients4', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients4
SELECT * 
 INTO dbo.tmp_CamparyClients4 
FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery4')

IF OBJECT_ID (N'dbo.tmp_CamparyClients11', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients11
SELECT * 
 INTO dbo.tmp_CamparyClients11 
FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery11')

IF OBJECT_ID (N'dbo.tmp_CamparyClients27', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients27
SELECT * 
 INTO dbo.tmp_CamparyClients27 
FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery27')

IF OBJECT_ID (N'dbo.tmp_CamparyClients85', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients85
SELECT * 
 INTO dbo.tmp_CamparyClients85
 FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery85')

IF OBJECT_ID (N'dbo.tmp_CamparyClients220', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyClients220
SELECT * 
 INTO dbo.tmp_CamparyClients220 
FROM [dbo].[af_CamparyClientsFromDelivery] ('tmp_CamparyDelivery220')
*/

IF @tmp_DeliveryCampary = 'tmp_CamparyDelivery4'
BEGIN

INSERT @out 
  SELECT OutletID, OutletName, OutletAddress , ClientID, ClientName FROM		
(SELECT
	m.OutletID OutletID, 
	s.StockName OutletName, 
	s.StockName OutletAddress,
	s.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery4) m
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID = CAST(REPLACE(m.OutletID, 'S-','') AS INT)
JOIN r_Comps c WITH(NOLOCK)ON s.CompID = c.CompID
WHERE CHARINDEX ('S-', m.OutletID) != 0

UNION

SELECT
	m.OutletID OutletID, 
	c.CompName+' '+c.Address OutletName, 
	c.Address OutletAddress,
	c.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery4) m
JOIN r_Comps c WITH(NOLOCK) ON c.ChID = CAST(m.OutletID AS INT)
WHERE CHARINDEX ('S-', m.OutletID) = 0
) big

END --@tmp_DeliveryCampary = 'tmp_CamparyDelivery4'

IF @tmp_DeliveryCampary = 'tmp_CamparyDelivery11'
BEGIN

INSERT @out 
  SELECT OutletID, OutletName, OutletAddress , ClientID, ClientName FROM		
(SELECT
	m.OutletID OutletID, 
	s.StockName OutletName, 
	s.StockName OutletAddress,
	s.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery11) m
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID = CAST(REPLACE(m.OutletID, 'S-','') AS INT)
JOIN r_Comps c WITH(NOLOCK)ON s.CompID = c.CompID
WHERE CHARINDEX ('S-', m.OutletID) != 0

UNION

SELECT
	m.OutletID OutletID, 
	c.CompName+' '+c.Address OutletName, 
	c.Address OutletAddress,
	c.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery11) m
JOIN r_Comps c WITH(NOLOCK) ON c.ChID = CAST(m.OutletID AS INT)
WHERE CHARINDEX ('S-', m.OutletID) = 0
) big

END --@tmp_DeliveryCampary = 'tmp_CamparyDelivery11'

IF @tmp_DeliveryCampary = 'tmp_CamparyDelivery27'
BEGIN

INSERT @out 
  SELECT OutletID, OutletName, OutletAddress , ClientID, ClientName FROM	
(SELECT
	m.OutletID OutletID, 
	s.StockName OutletName, 
	s.StockName OutletAddress,
	s.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery27) m
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID = CAST(REPLACE(m.OutletID, 'S-','') AS INT)
JOIN r_Comps c WITH(NOLOCK)ON s.CompID = c.CompID
WHERE CHARINDEX ('S-', m.OutletID) != 0

UNION

SELECT
	m.OutletID OutletID, 
	c.CompName+' '+c.Address OutletName, 
	c.Address OutletAddress,
	c.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery27) m
JOIN r_Comps c WITH(NOLOCK) ON c.ChID = CAST(m.OutletID AS INT)
WHERE CHARINDEX ('S-', m.OutletID) = 0
) big

END --@tmp_DeliveryCampary = 'tmp_CamparyDelivery27'

IF @tmp_DeliveryCampary = 'tmp_CamparyDelivery85'
BEGIN

INSERT @out 
  SELECT OutletID, OutletName, OutletAddress , ClientID, ClientName FROM		
(SELECT
	m.OutletID OutletID, 
	s.StockName OutletName, 
	s.StockName OutletAddress,
	s.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery85) m
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID = CAST(REPLACE(m.OutletID, 'S-','') AS INT)
JOIN r_Comps c WITH(NOLOCK)ON s.CompID = c.CompID
WHERE CHARINDEX ('S-', m.OutletID) != 0

UNION

SELECT
	m.OutletID OutletID, 
	c.CompName+' '+c.Address OutletName, 
	c.Address OutletAddress,
	c.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery85) m
JOIN r_Comps c WITH(NOLOCK) ON c.ChID = CAST(m.OutletID AS INT)
WHERE CHARINDEX ('S-', m.OutletID) = 0
) big

END --@tmp_DeliveryCampary = 'tmp_CamparyDelivery85'

IF @tmp_DeliveryCampary = 'tmp_CamparyDelivery220'
BEGIN

INSERT @out 
  SELECT OutletID, OutletName, OutletAddress , ClientID, ClientName FROM
(SELECT
	m.OutletID OutletID, 
	s.StockName OutletName, 
	s.StockName OutletAddress,
	s.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery220) m
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID = CAST(REPLACE(m.OutletID, 'S-','') AS INT)
JOIN r_Comps c WITH(NOLOCK)ON s.CompID = c.CompID
WHERE CHARINDEX ('S-', m.OutletID) != 0

UNION

SELECT
	m.OutletID OutletID, 
	c.CompName+' '+c.Address OutletName, 
	c.Address OutletAddress,
	c.CompID ClientID, 
	c.CompName ClientName
FROM (SELECT DISTINCT OutletID FROM dbo.tmp_CamparyDelivery220) m
JOIN r_Comps c WITH(NOLOCK) ON c.ChID = CAST(m.OutletID AS INT)
WHERE CHARINDEX ('S-', m.OutletID) = 0
) big

END --@tmp_DeliveryCampary = 'tmp_CamparyDelivery220'

	RETURN
END