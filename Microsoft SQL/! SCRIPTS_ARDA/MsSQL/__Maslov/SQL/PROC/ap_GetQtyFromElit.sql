ALTER PROCEDURE [dbo].[ap_GetQtyFromElitFor_t_EOExpD] @ChID INT = -1, @Testing INT = null 
AS
BEGIN

/*
setuser ''
setuser 'zov2'

EXEC ap_GetQtyFromElitFor_t_EOExpD @ChID = 30091, @Testing = 1
600008233
SELECT * FROM t_EOExp
WHERE DocID = 600008230

SELECT * FROM t_EOExp
WHERE StockID = 1201
ORDER BY DocDate DESC

SELECT * FROM r_ProdEC
WHERE ProdID = 804102 --804100,804101

SELECT * FROM r_ProdEC--Elit.dbo.r_ProdEC
WHERE ExtProdID = '27739'

SELECT DISTINCT TOP 100 m.DocID
FROM t_EOExpD d
JOIN r_ProdEC rec WITH(NOLOCK) ON rec.ProdID = d.ProdID
JOIN t_EOExp m WITH(NOLOCK) ON m.ChID = d.ChID
WHERE rec.ExtProdID IS NOT NULL AND m.CompID IN (80,81)--ProdID = 804101
--ORDER BY d.ChID DESC
*/

IF @ChID = -1
BEGIN
	RETURN
END;

IF @Testing = 1
BEGIN
	SELECT * FROM t_EOExpD
	WHERE ChID = @ChID

	BEGIN TRAN;
END;

DECLARE @StockGID INT, @StockID INT, @CompID INT

--определение группы складов
SET @StockGID = isnull((SELECT (SELECT StockGID FROM r_Stocks s WITH(NOLOCK) where s.StockID = m.StockID) FROM t_EOExp m WITH(NOLOCK) WHERE ChID = @ChID) ,0)
 
SELECT 
@CompID = CompID,--case when CompID in (81,181) then 10797 when CompID in (71,171) then 10798 else 0 end, 
@StockID =  case  
			when @StockGID in (2700,2800,2902,2903,2705,2901) then 4 --ƒнепр безнал
			--when @StockGID in (2700,2800,2902,2903,2705,2901) then 304 --ƒнепр нал
			when @StockGID in (2530,2708,2799,2707) then 30 -- иев безнал
			--when @StockGID in (2530,2708,2799,2707) then 330 -- иев нал
			when @StockGID in (2704,2709,2706) then 11 --’арьков безнал
			--when @StockGID in (2704,2709,2706) then 311 --’арьков нал
			else 0 end
FROM t_EOExp m WITH(NOLOCK) WHERE ChID = @ChID

DECLARE @SQL_q NVARCHAR(MAX)

SET @SQL_q = 'UPDATE d SET d.RecRackQty = Elit.dbo.tf_GetRem(1, '
				+ CAST(@StockID AS VARCHAR(20))
				+ ', 1, (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID), NULL), d.TransQty = Elit.dbo.tf_GetRem(1, 33, 1, (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID), NULL), d.Extra = (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID)'
				+ ' FROM t_EOExpD d JOIN t_EOExp m WITH(NOLOCK) ON m.ChID = d.ChID '
				+ ' WHERE d.ChID = '
				+ CAST(@ChID AS VARCHAR(20))
				+ ' AND (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID) IS NOT NULL'

EXEC sp_executesql @SQL_q

/*
UPDATE d SET	  
	  d.RecRackQty = Elit.dbo.tf_GetRem(1, @StockID, 1, (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID), NULL)
	 ,d.TransQty = Elit.dbo.tf_GetRem(1, 33, 1, (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID), NULL)
	 ,d.Extra = (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID)
FROM t_EOExpD d
JOIN t_EOExp m WITH(NOLOCK) ON m.ChID = d.ChID
--JOIN r_ProdEC rec WITH(NOLOCK) ON rec.ProdID = d.ProdID AND rec.CompID = 71--@CompID
WHERE d.ChID = @ChID
AND (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID) IS NOT NULL


SELECT Elit.dbo.tf_GetRem(1, @StockID, 1, CAST(rec.ExtProdID AS INT), NULL)
FROM t_EOExpD d
JOIN r_ProdEC rec WITH(NOLOCK) ON rec.ProdID = d.ProdID AND rec.CompID = @CompID
WHERE d.ChID = @ChID
*/

IF @Testing = 1
BEGIN
	SELECT * FROM t_EOExpD
	WHERE ChID = @ChID

	ROLLBACK TRAN;

SELECT d.ProdID
	  ,(SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID)
	  ,Elit.dbo.tf_GetRem(1, 4/*@StockID*/, 1, (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID), NULL)
	  ,Elit.dbo.tf_GetRem(1, 33, 1, (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID), NULL)
FROM t_EOExpD d
JOIN t_EOExp m WITH(NOLOCK) ON m.ChID = d.ChID
--JOIN r_ProdEC rec WITH(NOLOCK) ON rec.ProdID = d.ProdID AND rec.CompID = 71--@CompID
WHERE d.ChID = @ChID
AND (SELECT MAX(CAST(ExtProdID AS INT)) FROM r_ProdEC WHERE ProdID = d.ProdID AND CompID = m.CompID) IS NOT NULL

END;

END;