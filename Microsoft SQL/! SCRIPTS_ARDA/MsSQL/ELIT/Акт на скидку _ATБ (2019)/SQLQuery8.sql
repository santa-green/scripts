declare @docdate datetime = '2020-01-31 00:00:00'
declare @AccChID int = 227

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
  
SELECT DISTINCT o.Note1, o.PostIndex PostIndex_1, o.City, o.Address, oas.EmpID, eoas.UAEmpLastName + ' ' + LEFT(eoas.UAEmpFirstName, 1) + '.' + LEFT(eoas.UAEmpParName,1) + '.' AS ShortUAEmpName,
occ.AccountCC, rb.BankName, rb.BankID, rb.City AS BankCity,
c.CompShort, c.PostIndex PostIndex_2, c.City AS C_City, c.Address AS C_Address, ccc.CompAccountCC AS C_AccountCC, rbc.BankName AS C_BankName,
rbc.BankID AS C_BankID, rbc.City AS C_BankCity,
zc.ContrID, zc.BDate, data.RefID AS ID, CAST(data.Notes AS NUMERIC(19,2)) AS [Percent],
CAST((SELECT DISTINCT rp.Notes + ',' AS 'data()'
FROM dbo.t_InvD d WITH(NOLOCK)
JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
WHERE d.ChID IN (SELECT ChID FROM T WHERE KuKaReKu = 11012)
AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rp.PGrID)
FOR XML PATH('')) AS VARCHAR(8000)) ProdNames,
(SELECT ISNULL(SUM(d.SumCC_wt), 0) FROM dbo.t_InvD d WITH(NOLOCK)
JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
WHERE d.ChID IN (SELECT ChID FROM T WHERE KuKaReKu = 11012)
AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rp.PGrID)                           
) - (SELECT ISNULL(SUM(d.SumCC_wt), 0) FROM dbo.t_RetD d WITH(NOLOCK)
JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
WHERE d.ChID IN (SELECT ChID FROM T WHERE KuKaReKu = 11003)
AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rp.PGrID)) AS ProdSum,
(SELECT ISNULL(SUM(d.TaxSum), 0) FROM dbo.t_InvD d WITH(NOLOCK)
JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
WHERE d.ChID IN (SELECT ChID FROM T WHERE KuKaReKu = 11012)
AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rp.PGrID)) - (SELECT ISNULL(SUM(d.TaxSum), 0) FROM dbo.t_RetD d WITH(NOLOCK)
JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
WHERE d.ChID IN (SELECT ChID FROM T WHERE KuKaReKu = 11003)
AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rp.PGrID)) ProdTaxSum,
CorrSumCC_wt, CorrTaxSum, ISNULL(zc.AddContrID,'_') AS AddContrID, zc.AddBDate                 
FROM dbo.t_Inv m WITH(NOLOCK)
JOIN dbo.r_Ours o WITH(NOLOCK) ON o.OurID = m.OurID
LEFT JOIN at_r_OurAccSector oas WITH(NOLOCK) ON oas.OurID = o.OurID AND oas.StockGID = 2031
LEFT JOIN r_Emps eoas WITH(NOLOCK) ON eoas.EmpID = oas.EmpID    
OUTER APPLY [dbo].[af_GetCompReqs](m.CompID, m.DocDate) c
JOIN dbo.r_OursCC occ WITH(NOLOCK) ON occ.ChID = @AccChID
JOIN dbo.r_Banks rb WITH(NOLOCK) ON rb.BankID = occ.BankID
JOIN dbo.r_CompsCC ccc WITH(NOLOCK) ON ccc.CompID = m.CompID AND ccc.DefaultAccount = 1
JOIN dbo.r_Banks rbc WITH(NOLOCK) ON rbc.BankID = ccc.BankID
JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028 AND zdl.ChildChID = m.ChID
JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
CROSS JOIN dbo.r_Uni AS data WITH(NOLOCK)
/* из реестра суммы */
JOIN (SELECT ID, -SUM(CorrSumCC_wt) CorrSumCC_wt, -SUM(CorrTaxSum) CorrTaxSum FROM (
SELECT data.RefID AS ID, ISNULL((SELECT SUM(dd.SumCC_wt) SumCC_wt FROM dbo.t_InvD dd WITH(NOLOCK) JOIN dbo.r_Prods rpp WITH(NOLOCK) ON rpp.ProdID = dd.ProdID WHERE dd.ChID = im.ChID AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rpp.PGrID)), 0) -
ISNULL((SELECT SUM(dd.SumCC_wt) SumCC_wt FROM dbo.t_RetD dd WITH(NOLOCK) JOIN dbo.r_Prods rpp WITH(NOLOCK) ON rpp.ProdID = dd.ProdID WHERE dd.ChID = rtm.ChID AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rpp.PGrID)), 0) CorrSumCC_wt,
ISNULL((SELECT SUM(dd.TaxSum) SumCC_wt FROM dbo.t_InvD dd WITH(NOLOCK) JOIN dbo.r_Prods rpp WITH(NOLOCK) ON rpp.ProdID = dd.ProdID WHERE dd.ChID = im.ChID AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rpp.PGrID)), 0) -
ISNULL((SELECT SUM(dd.TaxSum) SumCC_wt FROM dbo.t_RetD dd WITH(NOLOCK) JOIN dbo.r_Prods rpp WITH(NOLOCK) ON rpp.ProdID = dd.ProdID WHERE dd.ChID = rtm.ChID AND EXISTS(SELECT * FROM PGr WHERE [UID] = data.RefID AND PGrID = rpp.PGrID)), 0) CorrTaxSum
FROM dbo.t_Ret rtm WITH(NOLOCK)
LEFT JOIN dbo.t_Inv im WITH(NOLOCK) ON im.TaxDocID = rtm.TaxDocID AND im.OurID = rtm.OurID AND im.StockID = rtm.StockID AND im.CodeID2 = rtm.CodeID2 AND im.DocDate=rtm.DocDate AND rtm.CodeID2 IN (38) AND im.TaxDocID != 0
CROSS JOIN dbo.r_Uni AS data WITH(NOLOCK)
WHERE rtm.CompID = 7004
AND rtm.CodeID2 = 38
AND data.RefTypeID = 6660157
AND rtm.DocDate = (SELECT MAX(ADate) FROM dbo.zf_DatesBetween(dbo.zf_GetMonthLastDay(@DocDate) - 5, dbo.zf_GetMonthLastDay(@DocDate), 1))
) dt GROUP BY dt.ID) dt0 ON dt0.ID = data.RefID
WHERE m.DocDate = @DocDate
/*AND CAST(data.Notes AS NUMERIC(19,2))=16.81 */
AND data.RefID=1 /*Обратить внимание*/               
AND m.CodeID2 = 38
AND m.CompID = 7004
AND data.RefTypeID = 6660157;    
