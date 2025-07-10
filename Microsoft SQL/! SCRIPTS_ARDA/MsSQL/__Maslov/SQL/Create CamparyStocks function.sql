SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[af_CamparyClients](
@StockID VARCHAR(MAX)
,@DayPeriod INT
,@EDate smalldatetime
,@PGrID1 VARCHAR(MAX)
,@NotInCompID VARCHAR(MAX)
)
RETURNS @out TABLE (OutletID INT NOT NULL, OutletName VARCHAR(401) NULL, OutletAddress VARCHAR(200) NULL, ClientID INT NOT NULL, ClientName VARCHAR(200) NOT NULL) 
AS
BEGIN
/*
SELECT * FROM [dbo].[af_CamparyClients]('220,320', 45, null, '20-26', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204,10797')

IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE tmp_CamparyClients4
SELECT * 
 INTO dbo.tmp_CamparyClients4 
FROM [dbo].[af_CamparyClients]('4,304,23,323', 45, null, '20-26', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204,10797')

IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE tmp_CamparyClients11
SELECT * 
 INTO dbo.tmp_CamparyClients11
FROM [dbo].[af_CamparyClients]('11,311', 45, null, '20-26', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204,10797')

IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE tmp_CamparyClients27
SELECT * 
 INTO dbo.tmp_CamparyClients27
FROM [dbo].[af_CamparyClients]('27,327', 45, null, '20-26', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204,10797')

IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE tmp_CamparyClients85
SELECT * 
 INTO dbo.tmp_CamparyClients85
FROM [dbo].[af_CamparyClients]('85,385', 45, null, '20-26', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204,10797')


IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE tmp_CamparyClients220
SELECT * 
 INTO dbo.tmp_CamparyClients220 
FROM [dbo].[af_CamparyClients]('220,320', 45, null, '20-26', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204,10797')



IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE tmp_CamparyClients220
SELECT * 
 INTO dbo.tmp_CamparyClients220 
FROM [dbo].[af_CamparyClients]('220,320', 45, null, '20-26', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204,10797')


SELECT AValue from zf_FilterToTable('4,304,23,323')
*/

DECLARE @BDate smalldatetime
IF @EDate IS NULL SET @EDate = dbo.zf_GetDate(GETDATE())
IF @DayPeriod IS NULL SET @BDate = '1900-01-01' ELSE SET @BDate = DATEADD(day ,-@DayPeriod,dbo.zf_GetDate(@EDate)) 

IF CHARINDEX ('220', @StockID) = 0 AND CHARINDEX ('320', @StockID) = 0
BEGIN

INSERT @out 
  SELECT OutletID, OutletName, OutletAddress, ClientID, ClientName FROM (

SELECT DISTINCT
c.ChID OutletID,c.CompName+' '+c.Address OutletName,
c.Address OutletAddress,c.CompID ClientID, c.CompName ClientName
FROM t_Rec t WITH(NOLOCK)
JOIN t_RecD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
JOIN r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND t.DocDate BETWEEN @BDate AND @EDate
UNION
SELECT DISTINCT
c.ChID OutletID,c.CompName+' '+c.Address OutletName,
c.Address OutletAddress,c.CompID ClientID, c.CompName ClientName
FROM t_Inv t WITH(NOLOCK)
JOIN t_InvD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
JOIN r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND t.DocDate BETWEEN @BDate AND @EDate
UNION 
SELECT DISTINCT
c.ChID OutletID,c.CompName+' '+c.Address OutletName,
c.Address OutletAddress,c.CompID ClientID, c.CompName ClientName
FROM t_Exp t WITH(NOLOCK)
JOIN t_ExpD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
JOIN r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND t.DocDate BETWEEN @BDate AND @EDate
     UNION 
SELECT DISTINCT
c.ChID OutletID,c.CompName+' '+c.Address OutletName,
c.Address OutletAddress,c.CompID ClientID, c.CompName ClientName
FROM t_Ret t WITH(NOLOCK)
JOIN t_RetD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
JOIN r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND t.DocDate BETWEEN @BDate AND @EDate
     UNION 
      SELECT DISTINCT
c.ChID OutletID,c.CompName+' '+c.Address OutletName,
c.Address OutletAddress,c.CompID ClientID, c.CompName ClientName
FROM t_CRet t WITH(NOLOCK)
JOIN t_CRetD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
JOIN r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND t.DocDate BETWEEN @BDate AND @EDate
UNION 
SELECT DISTINCT
c.ChID OutletID,c.CompName+' '+c.Address OutletName,
c.Address OutletAddress,c.CompID ClientID, c.CompName ClientName
FROM r_Comps c WITH(NOLOCK)
WHERE c.CompID IN (SELECT AValue from zf_FilterToTable(@NotInCompID))
) d
ORDER BY OutletID
END --IF CHARINDEX ('220', @StockID) = 0 AND CHARINDEX ('320', @StockID) = 0

ELSE
BEGIN
INSERT @out 
  SELECT OutletID, OutletName, OutletAddress, ClientID, ClientName FROM (
SELECT  DISTINCT
c.ChID OutletID,c.CompName+' '+c.Address OutletName,
c.Address OutletAddress,c.CompID ClientID, c.CompName ClientName
FROM r_Comps c WITH(NOLOCK)
WHERE c.CompID IN (SELECT AValue from zf_FilterToTable(@NotInCompID))
) kiev
END -- else end

RETURN
END
