--поиск в РН партий без кода Уктевэд
--(налоговые которые формируются в Alef_Elit.dbo.ap_Workflow_Create_Declar джоб Workflow шаг Create_Declar)

SELECT distinct d.ProdID, d.PPID FROM t_Inv m
JOIN t_InvD d on d.ChID = m.ChID
JOIN t_PInP pp on pp.ProdID = d.ProdID and d.PPID = pp.PPID
WHERE m.DocDate > '2019-01-01'
and pp.CstProdCode = ''
and TaxDocID <> 0
and m.CompID in (SELECT CompID FROM r_Comps where CodeID2 in (502,505,506,621,610,503,501,982))

/*
SELECT * FROM r_Comps where CompID in (7144,7001,7002,7003)
SELECT CompID FROM r_Comps where CodeID2 in (502,505,506,621,610,503,501,982)
*/

