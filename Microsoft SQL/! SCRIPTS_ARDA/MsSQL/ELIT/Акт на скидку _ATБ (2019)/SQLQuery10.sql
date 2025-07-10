declare @docdate datetime = '2020-01-31 00:00:00'


;WITH PGr AS (
SELECT DISTINCT rupp.RefID AS [UID], rpp.PGrID
FROM dbo.r_Prods rpp WITH(NOLOCK)
JOIN dbo.r_Uni AS rupp WITH(NOLOCK) ON dbo.zf_MatchFilterInt(rpp.PGrID, rupp.RefName, ',') = 1
WHERE rupp.RefTypeID = 6660157),
T AS (SELECT 11012 AS KuKaReKu, m.ChID
FROM dbo.t_Inv m WITH(NOLOCK)
WHERE m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)
AND m.CodeID1 = 63
AND m.CodeID2 = 18
AND m.CompID = 7004
UNION
SELECT 11003, m.ChID
FROM dbo.t_Ret m WITH(NOLOCK)
WHERE m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)
AND m.CodeID1 = 63
AND m.CodeID2 = 19
AND m.CompID = 7004)  

SELECT * FROM PgR


(SELECT dd.SumCC_wt SumCC_wt FROM dbo.t_InvD dd WITH(NOLOCK) 
JOIN dbo.r_Prods rpp WITH(NOLOCK) ON rpp.ProdID = dd.ProdID 
WHERE dd.ChID = im.ChID AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rpp.PGrID))



--SELECT * FROM (
--SELECT ID, -(CorrSumCC_wt) CorrSumCC_wt, -(CorrTaxSum) CorrTaxSum FROM (
SELECT data.RefID AS ID, 

ISNULL(
(SELECT dd.SumCC_wt SumCC_wt FROM dbo.t_InvD dd WITH(NOLOCK) 
JOIN dbo.r_Prods rpp WITH(NOLOCK) ON rpp.ProdID = dd.ProdID WHERE dd.ChID = im.ChID AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rpp.PGrID))
, 0)

- ISNULL((SELECT SUM(dd.SumCC_wt) SumCC_wt FROM dbo.t_RetD dd WITH(NOLOCK) JOIN dbo.r_Prods rpp WITH(NOLOCK) ON rpp.ProdID = dd.ProdID WHERE dd.ChID = rtm.ChID AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rpp.PGrID)), 0) CorrSumCC_wt,

ISNULL((SELECT SUM(dd.TaxSum) SumCC_wt FROM dbo.t_InvD dd WITH(NOLOCK) JOIN dbo.r_Prods rpp WITH(NOLOCK) ON rpp.ProdID = dd.ProdID WHERE dd.ChID = im.ChID AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rpp.PGrID)), 0) -
ISNULL((SELECT SUM(dd.TaxSum) SumCC_wt FROM dbo.t_RetD dd WITH(NOLOCK) JOIN dbo.r_Prods rpp WITH(NOLOCK) ON rpp.ProdID = dd.ProdID WHERE dd.ChID = rtm.ChID AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rpp.PGrID)), 0) CorrTaxSum

FROM dbo.t_Ret rtm WITH(NOLOCK)
LEFT JOIN dbo.t_Inv im WITH(NOLOCK) ON im.TaxDocID = rtm.TaxDocID AND im.OurID = rtm.OurID AND im.StockID = rtm.StockID AND im.CodeID2 = rtm.CodeID2 AND im.DocDate=rtm.DocDate AND rtm.CodeID2 IN (38) AND im.TaxDocID != 0
CROSS JOIN dbo.r_Uni AS data WITH(NOLOCK)
WHERE rtm.CompID = 7004
AND rtm.CodeID2 = 38
AND data.RefTypeID = 6660157
AND rtm.DocDate = (SELECT MAX(ADate) FROM dbo.zf_DatesBetween(dbo.zf_GetMonthLastDay(@DocDate) - 5, dbo.zf_GetMonthLastDay(@DocDate), 1))
--) dt 

--GROUP BY dt.ID) dt0