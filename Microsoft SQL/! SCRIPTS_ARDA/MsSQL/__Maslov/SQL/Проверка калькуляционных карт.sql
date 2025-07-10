IF OBJECT_ID (N'tempdb..#LastCard', N'U') IS NOT NULL DROP TABLE #LastCard
select * into #LastCard from (SELECT * FROM(SELECT *
, ROW_NUMBER() OVER(PARTITION BY isp.OurID, isp.ProdID, isp.StockID ORDER BY DocDate desc) position
FROM it_Spec isp
)s
WHERE position = 1
) s1


SELECT * 
FROM #LastCard lc
JOIN it_SpecParams ispp ON lc.ChID = ispp.ChID
WHERE lc.DocDate != ispp.ProdDate and lc.OurID != 9 --and lc.DocDate >= '20180101' --and lc.ProdID = 605158
ORDER BY DocDate desc
--SELECT * FROM it_SpecParams where  ChID = 17656


SELECT * 
FROM #LastCard lc
JOIN it_SpecParams ispp ON lc.ChID = ispp.ChID
WHERE lc.StockID != ispp.StockID and lc.OurID != 9 --and lc.DocDate >= '20180101' --and lc.ProdID = 605158
ORDER BY DocDate desc

;WITH
OutQtyD AS (SELECT lc.ChID,lc.DocID, lc.DocDate, SUM(ivspd.OutQty) SumOutQty
FROM #LastCard lc
JOIN it_SpecD ispd ON lc.ChID = ispd.ChID
JOIN iv_SpecD ivspd ON ispd.ProdID = ivspd.ProdID and lc.ChID = ivspd.ChID
GROUP BY lc.ChID, lc.DocID, lc.DocDate)

SELECT lc.ChID, DocID, IntDocID, DocDate, OurID, EmpID, ProdID, UM, OutQty, OutUM, lc.StockID, position, LayUM, LayQty, ProdDate
FROM #LastCard lc
JOIN it_SpecParams ispp ON lc.ChID = ispp.ChID
WHERE NOT EXISTS(SELECT * FROM #LastCard WHERE ispp.LayUM IN ('%порц%')) 
and lc.OutQty != ispp.LayQty
and lc.OurID != 9 --and lc.DocDate >= '20180101'
union
SELECT lc.ChID, lc.DocID, IntDocID, lc.DocDate, lc.OurID, EmpID, ProdID, UM, OutQty, OutUM, lc.StockID, position, LayUM, LayQty, ProdDate
FROM #LastCard lc
JOIN it_SpecParams ispp ON lc.ChID = ispp.ChID
JOIN OutQtyD oqd ON lc.ChID = oqd.ChID
WHERE EXISTS(SELECT * FROM #LastCard WHERE ispp.LayUM IN ('порц'))
and ((lc.OutQty != ispp.LayQty) OR ( (lc.OutQty - oqd.SumOutQty) <= 10)
								OR ( (lc.OutQty - oqd.SumOutQty) < 0 and (lc.OutQty - oqd.SumOutQty) >= -10)
								OR (oqd.SumOutQty != lc.OutQty))
and lc.OurID != 9 --and lc.DocDate >= '20180101'

SELECT * 
FROM (
SELECT lc.ChID,lc.DocID, lc.DocDate, SUM(ispd.Qty) qty, SUM(ivspd.GrossQty) brutto, lc.OurID
FROM #LastCard lc
JOIN it_SpecD ispd ON lc.ChID = ispd.ChID
JOIN iv_SpecD ivspd ON ispd.ProdID = ivspd.ProdID and lc.ChID = ivspd.ChID
GROUP BY lc.ChID, lc.DocID, lc.DocDate, lc.OurID)s1
WHERE s1.qty != s1.brutto --and s1.DocDate >= '20180101'
and s1.OurID != 9

SELECT * 
FROM #LastCard lc
JOIN it_SpecParams ispp ON lc.ChID = ispp.ChID
WHERE EXISTS(SELECT * FROM #LastCard JOIN it_SpecParams ispp ON lc.ChID = ispp.ChID WHERE ispp.LayUM = 'порц')
	  and lc.OurID != 9 --and lc.DocDate >= '20180101' --and lc.ProdID = 605158
	  and ispp.LayQty != 1
UNION
SELECT * 
FROM #LastCard lc
JOIN it_SpecParams ispp ON lc.ChID = ispp.ChID
WHERE NOT EXISTS(SELECT * FROM #LastCard JOIN it_SpecParams ispp ON lc.ChID = ispp.ChID WHERE ispp.LayUM = 'порц')
	  and lc.OutUM != ispp.LayUM and lc.OurID != 9 -- and lc.DocDate >= '20180101' --and lc.ProdID = 605158

/*
SELECT ProdID, COUNT(ProdID) FROM it_Spec group by ProdID order by 2 desc
SELECT * FROM it_Spec where ProdID = 605158 and OurID = 12 order by  StockID, DocDate desc
17656
SELECT * FROM (
SELECT *
, ROW_NUMBER() OVER(PARTITION BY isp.OurID, isp.ProdID, isp.StockID ORDER BY DocDate desc) position
FROM it_Spec isp) ty
where ProdID = 605158 and OurID = 12 and position = 1
*/