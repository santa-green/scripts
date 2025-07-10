CREATE PROCEDURE dbo.I_ReExpSInvRow(@ChID int) AS
BEGIN

SET NOCOUNT ON

IF OBJECT_ID('tempdb..#tmp_InvD') IS NOT NULL DROP TABLE #tmp_InvD
CREATE TABLE #tmp_InvD (ChID int, SrcPosID smallint, ProdID int, PPID int, UM varchar (10) COLLATE Cyrillic_General_CI_AS, Qty numeric(21, 9), PriceCC_nt numeric(21, 9), SumCC_nt numeric(21, 9), Tax numeric(21, 9), TaxSum numeric(21, 9), PriceCC_wt numeric(21, 9), SumCC_wt numeric(21, 9), CONSTRAINT [_pk_#tmp_InvD] PRIMARY KEY  NONCLUSTERED (ChID, SrcPosID))

DECLARE @ShiftCount int
SET @ShiftCount=0

DECLARE @OurID int, @StockID int, @SrcPosID int, @ProdID int, @Qty float

SELECT TOP 1 
  @OurID=m.OurID, @StockID=m.StockID, @SrcPosID=d.SrcPosID, @ProdID=d.ProdID, @Qty=d.Qty
FROM s_Inv m INNER JOIN s_InvD d ON d.ChID=m.ChID AND m.ChID=@ChID
WHERE (d.PPID=0 OR ISNULL((SELECT Sum(Qty) FROM s_Rem r WHERE r.OurID=m.OurID AND r.StockID=m.StockID AND r.ProdID=d.ProdID AND r.PPID=d.PPID), 0)<0)
AND EXISTS(SELECT * FROM s_Rem r WHERE r.OurID=m.OurID AND r.StockID=m.StockID AND r.ProdID=d.ProdID AND r.Qty>0)
ORDER BY d.SrcPosID

DELETE FROM #tmp_InvD

INSERT INTO #tmp_InvD(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt)
SELECT
  @ChID, @SrcPosID+pp.RowID, d.ProdID, pp.PPID, UM, pp.Qty, PriceCC_nt, ROUND(pp.Qty*PriceCC_nt, 5), Tax, ROUND(pp.Qty*Tax, 5), PriceCC_wt, ROUND(pp.Qty*PriceCC_wt, 2)
FROM s_InvD d WITH (NOLOCK), dbo.a_GetPPRows(@OurID, @StockID, @ProdID, @Qty) pp, s_PInP p WITH (NOLOCK)
WHERE d.ChID=@ChID AND d.SrcPosID=@SrcPosID AND p.ProdID=d.ProdID AND p.PPID=pp.PPID

DELETE FROM s_InvD WHERE ChID=@ChID AND SrcPosID=@SrcPosID

SELECT @ShiftCount=Count(*) FROM dbo.a_GetPPRows(@OurID, @StockID, @ProdID, @Qty)
IF @ShiftCount>1
  UPDATE s_InvD
    SET SrcPosID=SrcPosID+@ShiftCount-1
  WHERE ChID=@ChID AND SrcPosID>@SrcPosID

DECLARE InsRows CURSOR FAST_FORWARD FOR
SELECT ChID, SrcPosID
FROM #tmp_InvD
ORDER BY SrcPosID
OPEN InsRows
FETCH NEXT FROM InsRows INTO @ChID, @SrcPosID
WHILE @@FETCH_STATUS = 0
  BEGIN

    INSERT INTO s_InvD(ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt)
    SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt 
    FROM #tmp_InvD
    WHERE ChID=@ChID AND SrcPosID=@SrcPosID
    
    FETCH NEXT FROM InsRows INTO @ChID, @SrcPosID
  END
CLOSE InsRows
DEALLOCATE InsRows

DROP TABLE #tmp_InvD

END
GO
