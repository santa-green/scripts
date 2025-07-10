
DECLARE @some DATETIME = '2019-02-01'

--SELECT DAY(@some)

--SELECT *
--	  ,q.Qty*q.PriceCC_wt 'SumCC_wt'
--	  ,dbo.zf_GetIncludedTax(q.PriceCC_wt, dbo.zf_CorrectProdTax(11015, q.OurID, q.CompID, q.ProdID, q.PPID, q.DocDate) ) 'Tax'
--	  ,q.Qty*(dbo.zf_GetIncludedTax(q.PriceCC_wt, dbo.zf_CorrectProdTax(11015, q.OurID, q.CompID, q.ProdID, q.PPID, q.DocDate) ) ) 'TaxSum'
--	  ,q.PriceCC_wt - dbo.zf_GetIncludedTax(q.PriceCC_wt, dbo.zf_CorrectProdTax(11015, q.OurID, q.CompID, q.ProdID, q.PPID, q.DocDate) ) 'PriceCC_nt'
--	  ,q.Qty*(q.PriceCC_wt - dbo.zf_GetIncludedTax(q.PriceCC_wt, dbo.zf_CorrectProdTax(11015, q.OurID, q.CompID, q.ProdID, q.PPID, q.DocDate) ) ) 'SumCC_nt'
--FROM
--	(
--SELECT m.ChID, m.DocID, m.DocDate, m.OurID, m.CompID, m.CurrID, m.KursCC, d.PPID, d.ProdID, d.Qty
--	  ,CASE WHEN m.CurrID = 1 THEN rpmp.PriceMC ELSE rpmp.PriceMC*rc.KursMC END 'PriceCC_wt'
--FROM t_Exp m
--JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
--JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = d.ProdID AND rpmp.PLID = 106
--JOIN r_Currs rc WITH(NOLOCK) ON rc.CurrID = m.CurrID
--WHERE m.CodeID1 = 50
--      AND
--	  ( 
--		(DAY(@some) <= 5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, @some)-1, 0)) AND @some )
--		)
--		OR
--		(DAY(@some) > 5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, @some), 0)) AND @some )
--		)
--	  )
--	) q
--ORDER BY q.DocDate DESC
/*
SELECT m.ChID, m.DocDate, m.CurrID, m.KursCC, d.ProdID, d.PriceCC_nt, d.Qty
	  ,CASE WHEN m.CurrID = 1 THEN rpmp.PriceMC ELSE rpmp.PriceMC*28 END
FROM t_Exp m
JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = d.ProdID AND rpmp.PLID = 106
WHERE CodeID1 = 50
      AND
	  ( 
		(DAY(GETDATE()) <=5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)) AND GETDATE() )
		)
		OR
		(DAY(GETDATE()) >=5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) AND GETDATE() )
		)
	  )
ORDER BY m.DocDate DESC, m.ChID
*/

BEGIN TRAN;

SELECT m.*, d.*
FROM t_Exp m
JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = d.ProdID AND rpmp.PLID = 106
JOIN r_Currs rc WITH(NOLOCK) ON rc.CurrID = m.CurrID
WHERE m.CodeID1 = 50
      AND
	  ( 
		(DAY(@some) <= 5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, @some)-1, 0)) AND @some )
		)
		OR
		(DAY(@some) > 5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, @some), 0)) AND @some )
		)
	  )
ORDER BY m.DocDate

UPDATE t_ExpD SET PriceCC_wt = q.PriceCC_wt, SumCC_wt = q.Qty*q.PriceCC_wt
				 ,Tax = dbo.zf_GetIncludedTax(q.PriceCC_wt, dbo.zf_CorrectProdTax(11015, q.OurID, q.CompID, q.ProdID, q.PPID, q.DocDate) )
				 ,TaxSum = q.Qty*(dbo.zf_GetIncludedTax(q.PriceCC_wt, dbo.zf_CorrectProdTax(11015, q.OurID, q.CompID, q.ProdID, q.PPID, q.DocDate) ) )
				 ,PriceCC_nt = q.PriceCC_wt - dbo.zf_GetIncludedTax(q.PriceCC_wt, dbo.zf_CorrectProdTax(11015, q.OurID, q.CompID, q.ProdID, q.PPID, q.DocDate) )
				 ,SumCC_nt = q.Qty*(q.PriceCC_wt - dbo.zf_GetIncludedTax(q.PriceCC_wt, dbo.zf_CorrectProdTax(11015, q.OurID, q.CompID, q.ProdID, q.PPID, q.DocDate) ) )
FROM
	(
SELECT m.ChID, m.DocID, m.DocDate, m.OurID, m.CompID, m.CurrID, m.KursCC, d.PPID, d.ProdID, d.Qty, d.SrcPosID
	  ,CASE WHEN m.CurrID = 1 THEN rpmp.PriceMC ELSE rpmp.PriceMC*rc.KursMC END 'PriceCC_wt'
FROM t_Exp m
JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = d.ProdID AND rpmp.PLID = 106
JOIN r_Currs rc WITH(NOLOCK) ON rc.CurrID = m.CurrID
WHERE m.CodeID1 = 50
      AND
	  ( 
		(DAY(@some) <= 5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, @some)-1, 0)) AND @some )
		)
		OR
		(DAY(@some) > 5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, @some), 0)) AND @some )
		)
	  )
	) q
WHERE t_ExpD.ChID = q.ChID AND t_ExpD.ProdID = q.ProdID AND t_ExpD.SrcPosID = q.SrcPosID

SELECT m.*, d.*
FROM t_Exp m
JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = d.ProdID AND rpmp.PLID = 106
JOIN r_Currs rc WITH(NOLOCK) ON rc.CurrID = m.CurrID
WHERE m.CodeID1 = 50
      AND
	  ( 
		(DAY(@some) <= 5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, @some)-1, 0)) AND @some )
		)
		OR
		(DAY(@some) > 5 AND (m.DocDate BETWEEN (DATEADD(MONTH, DATEDIFF(MONTH, 0, @some), 0)) AND @some )
		)
	  )
ORDER BY m.DocDate
--SELECT d.PriceCC_nt, *
--FROM t_Exp m
--JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
--JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = d.ProdID AND rpmp.PLID = 106
--WHERE m.DocID = 266380 AND d.ProdID = 31443

ROLLBACK TRAN;


--SELECT dbo.zf_GetTax(375.70, dbo.zf_CorrectProdTax(11015, 1, 14054, 31443, 103, '20190204 00:00')) + 375.70

--SELECT dbo.zf_CorrectProdTax(11015, 1, 14054, 31443, 103, '20190204 00:00')
--SELECT 441.04 - dbo.zf_GetIncludedTax(441.04, dbo.zf_CorrectProdTax(11015, 1, 14054, 31443, 103, '20190204 00:00') )

--SELECT *, PriceMC*28 FROM r_ProdMP WHERE ProdID = 31443

--select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
/*
dbo.ap_SendEmailDiscounts
ALEF_WEB_ZAM_AKCIA_BY_COMPID
SELECT dbo.zf_CorrectProdTax(11015, 1, 14054, 26135, 0, '20190204 00:00')

SELECT * FROM t_rem
SELECT * FROM z_Tables ORDER BY 4;
SELECT * FROM r_Currs

SELECT * FROM t_Exp WHERE Discount != 0 AND CodeID1 = 50

31878 0.96
Меняем "Цена, ВС"
*/