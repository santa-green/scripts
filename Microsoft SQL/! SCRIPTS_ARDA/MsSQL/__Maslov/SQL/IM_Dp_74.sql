
use ElitV_DP --s-marketa

setuser 
setuser '501'

BEGIN TRAN
/*
600131
802657
802656
802442
802440
*/
--DELETE t_SaleTempD WHERE ChID = 1947 AND ProdID = 600131

exec t_DiscUpdateDocPoses 1011,1960,1
EXEC t_DiscUpdateCancels 1011, 1960, 1, 125.3
  --  DECLARE @DiscSumCC numeric(21, 9)
  --EXEC dbo.t_DiscGetDocDisc 1011, 1947, @DiscSumCC OUTPUT
  --SELECT @DiscSumCC
ROLLBACK TRAN

SELECT * FROM t_SaleTempD
--WHERE ChID = 1947--1958
WHERE ChID = 1960
--WHERE PriceCC_wt != PurPriceCC_wt

SELECT * FROM t_SaleTemp
WHERE ChID = 1960

  SELECT m.SrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, t.AllowZeroPrice, t.PurPriceCC_wt
  FROM dbo.tf_DiscDoc(1011, 1947) m
  JOIN t_SaleTempD t ON t.ChID = 1947 AND t.SrcPosID = m.SrcPosID
  WHERE m.Qty > 0 
  ORDER BY m.SumCC_wt DESC, m.SrcPosID

  SELECT ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - SUM(PurSumCC_wt - SumCC_wt) FROM dbo.tf_DiscDoc(1011, 1947)
  
      DECLARE @SrcPosIDFrom int
      DECLARE @SrcPosIDTo   int
      DECLARE @QtyFrom numeric(21,9)
      DECLARE @QtyTo   numeric(21,9)
      DECLARE @y numeric(21,9)
      DECLARE @x numeric(21,9)
      DECLARE @i int

      SELECT @QtyTo = MIN(Qty) FROM t_SaleTempD WHERE ChID = 1947 AND PriceCC_wt <> 0.01 HAVING MIN(Qty) = dbo.zf_Round(MIN(Qty), 1.00) /*целое*/
      SELECT @SrcPosIDTo = (SELECT TOP 1 SrcPosID FROM t_SaleTempD WHERE ChID = 1947 AND Qty = @QtyTo ORDER BY PriceCC_wt DESC)     
      
	  SELECT @QtyTo, @SrcPosIDTo

	  SELECT * FROM dbo.r_DCards WITH(NOLOCK) WHERE ChID=0
/*
1011	1947	1	NULL	NULL	599.500000000
*/
