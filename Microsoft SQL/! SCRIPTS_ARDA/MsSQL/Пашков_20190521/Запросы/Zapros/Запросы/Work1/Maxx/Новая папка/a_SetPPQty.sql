CREATE PROCEDURE dbo.a_SetPPQty(@AChID int) AS
BEGIN

SET NOCOUNT ON

SELECT DISTINCT
a_OrderD.ChID, a_OrderD.ProdID, China2006.dbo.t_AccD.PPID, a_OrderD.SecID, China2006.dbo.t_AccD.Qty, a_OrderD.FQty, China2006.dbo.t_AccD.PriceCC_wt
INTO #_TmpTable
FROM a_Order WITH (NOLOCK)
INNER JOIN a_OrderD WITH (NOLOCK) ON a_OrderD.ChID=a_Order.ChID 
INNER JOIN China2006.dbo.t_Acc WITH (NOLOCK) ON China2006.dbo.t_Acc.ChID=a_Order.AccChID 
INNER JOIN China2006.dbo.t_AccD WITH (NOLOCK) ON China2006.dbo.t_AccD.ChID=China2006.dbo.t_Acc.ChID AND China2006.dbo.t_AccD.ProdID=a_OrderD.ProdID AND China2006.dbo.t_AccD.SecID=a_OrderD.SecID
WHERE a_Order.ChID=@AChID

DECLARE @AProdID int, @APPID int, @ASecID int, @AQty float, @AFQty float, @APPQty float
DECLARE ACheckExeq CURSOR FAST_FORWARD FOR
SELECT
  ChID, ProdID, SecID, Sum(Qty) AS Qty, FQty
FROM #_TmpTable
GROUP BY ChID, ProdID, SecID, FQty

OPEN ACheckExeq
FETCH NEXT FROM ACheckExeq INTO @AChID, @AProdID, @ASecID, @AQty, @AFQty
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @APPQty=@AFQty
	DECLARE ASetPPQty CURSOR FAST_FORWARD FOR
	SELECT
	  PPID, Qty
	FROM #_TmpTable
	WHERE ChID=@AChID AND ProdID=@AProdID AND SecID=@ASecID
	ORDER BY PPID
	OPEN ASetPPQty
	FETCH NEXT FROM ASetPPQty INTO @APPID, @AQty
	WHILE @@FETCH_STATUS = 0
	BEGIN
	  IF @APPQty>@AQty 
		SET @AFQty=@AQty
	  ELSE
		SET @AFQty=@APPQty
	  SET @APPQty=CASE WHEN @APPQty-@AQty<0 THEN 0 ELSE @APPQty-@AQty END
	  UPDATE #_TmpTable SET FQty=@AFQty WHERE ChID=@AChID AND ProdID=@AProdID AND PPID=@APPID AND SecID=@ASecID

	  FETCH NEXT FROM ASetPPQty INTO @APPID, @AQty
	END
	CLOSE ASetPPQty
	DEALLOCATE ASetPPQty

	FETCH NEXT FROM ACheckExeq INTO @AChID, @AProdID, @ASecID, @AQty, @AFQty
END
CLOSE ACheckExeq
DEALLOCATE ACheckExeq

INSERT INTO a_OrderP(ChID, SecID, ProdID, PPID, FQty, PriceCC_wt)
SELECT ChID, SecID, ProdID, PPID, FQty, PriceCC_wt 
FROM #_TmpTable

DROP TABLE #_TmpTable

END
GO
