 SET XACT_ABORT ON  

BEGIN TRAN

DECLARE @ChID INT

EXEC z_NewChID 'r_ProdMPCh', @ChID OUTPUT

INSERT r_ProdMPCh
(ChID, ChDate, ChTime, ProdID, PLID, OldCurrID, OldPriceMC, CurrID, PriceMC, UserID)
SELECT 
 ROW_NUMBER() OVER (ORDER BY d.ProdID) + @ChID - 1 ChID, 
 dbo.zf_GetDate(GETDATE()) ChDate, GETDATE() ChTime, d.ProdID, d.PLID, mp.CurrID OldCurrID, mp.PriceMC OldPriceMC, mp.CurrID, d.NewPriceAC PriceMC, ru.UserID
FROM r_ProdMP mp
JOIN t_SEstD d WITH(NOLOCK) ON d.ProdID = mp.ProdID AND d.PLID = mp.PLID
JOIN t_SEst m WITH(NOLOCK) ON m.ChID = d.ChID
JOIN r_Users ru WITH(NOLOCK) ON ru.EmpID = d.EmpID
WHERE m.DocDate = dbo.zf_GetDate(GETDATE()) AND (mp.PriceMC != d.NewPriceAC)

UPDATE mp
SET mp.PriceMC = d.NewPriceAC
FROM r_ProdMP mp
JOIN t_SEstD d WITH(NOLOCK) ON d.ProdID = mp.ProdID AND d.PLID = mp.PLID
JOIN t_SEst m WITH(NOLOCK) ON m.ChID = d.ChID
WHERE m.DocDate = dbo.zf_GetDate(GETDATE()) AND (mp.PriceMC != d.NewPriceAC)

IF @@TRANCOUNT > 0 
  COMMIT
