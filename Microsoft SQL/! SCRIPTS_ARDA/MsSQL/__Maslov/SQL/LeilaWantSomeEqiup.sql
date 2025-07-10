DECLARE
 @ContrTypeID VARCHAR(256) = '3,9'		-- Тип договора
,@OurID VARCHAR(256) = '3'				-- Фирма
,@EDate SMALLDATETIME = '2020-02-28'	-- Дата окончания договора

DECLARE @contracts TABLE
(OurID INT,
 CompGrName2 VARCHAR(250),
 CompID INT,
 CompName VARCHAR(500),
 BDate SMALLDATETIME,
 EDate SMALLDATETIME,
 ContrTypeID INT,
 RefName VARCHAR(250),
 ContrID VARCHAR(250),
 Qty INT
)

INSERT INTO @contracts
SELECT m.OurID, rcg2.CompGrName2, m.CompID, rc.CompName, m.BDate, m.EDate, m.ContrTypeID, ru.RefName, m.ContrID, SUM(tr.Qty) 'Qty'
FROM at_z_Contracts m
JOIN r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID
JOIN r_Stocks rs WITH(NOLOCK) ON rs.CompID = rc.CompID
JOIN t_Rem tr WITH(NOLOCK) ON tr.StockID = rs.StockID
JOIN r_CompGrs2 rcg2 WITH(NOLOCK) ON rcg2.CompGrID2 = rc.CompGrID2
JOIN r_Uni ru WITH(NOLOCK) ON ru.RefID = m.ContrTypeID AND ru.RefTypeID = 6660110
WHERE m.ContrTypeID IN (SELECT AValue FROM zf_FilterToTable(@ContrTypeID))
AND m.OurID IN (SELECT AValue FROM zf_FilterToTable(@OurID))
AND m.EDate < @EDate
AND m.ChID != 71895
--AND m.CompID = 57510
GROUP BY m.OurID, rcg2.CompGrName2, m.CompID, rc.CompName, m.BDate, m.EDate, m.ContrTypeID, ru.RefName, m.ContrID

;WITH
Dublicates AS (SELECT CompID
, ROW_NUMBER() OVER(PARTITION BY CompID ORDER BY EDate DESC) number_of_dublicates
FROM @contracts)

DELETE FROM Dublicates WHERE number_of_dublicates > 1

--SELECT * FROM Dublicates WHERE number_of_dublicates > 1


SELECT * FROM @contracts
/*
SELECT * FROM t_rem

SELECT * FROM r_Comps
WHERE CompID = 9995

SELECT * FROM r_Stocks
WHERE StockID IN (9995, 5044)

SELECT * FROM r_CompContacts

SELECT * FROM at_z_Contracts m
WHERE m.CompID = 57510

SELECT * FROM r_Comps
WHERE CompID = 57510

SELECT * FROM z_Tables ORDER BY TableDesc;


DECLARE @contracts TABLE
(DocID INT,
 OurID INT,
 CompGrName2 VARCHAR(250),
 CompID INT,
 CompName VARCHAR(500),
 BDate SMALLDATETIME,
 EDate SMALLDATETIME,
 ContrTypeID INT,
 ContrTypeName VARCHAR(250),
 ContrID VARCHAR(250),
 StockID INT,
 CompAdd VARCHAR(350),
 ProdID INT,
 ProdName VARCHAR(250),
 Qty INT
)

INSERT INTO @contracts
SELECT * FROM
(
SELECT
       m.DocID
       ,m.OurID
       ,rcg2.CompGrName2
       ,m.CompID
       ,rc.CompName
       ,m.BDate
       ,m.EDate
       ,m.ContrTypeID
       ,ru.RefName AS 'ContrTypeName'
       ,m.ContrID
       ,rs.StockID
       ,rs.CompAdd
       ,tr.ProdID       
       ,rp.ProdName
       ,SUM(tr.Qty) 'Qty'
FROM at_z_Contracts m
JOIN r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID
JOIN r_Stocks rs WITH(NOLOCK) ON rs.CompID = rc.CompID
JOIN t_Rem tr WITH(NOLOCK) ON tr.StockID = rs.StockID AND tr.OurID = m.OurID
JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = tr.ProdID
JOIN r_CompGrs2 rcg2 WITH(NOLOCK) ON rcg2.CompGrID2 = rc.CompGrID2
JOIN r_Uni ru WITH(NOLOCK) ON ru.RefID = m.ContrTypeID AND ru.RefTypeID = 6660110
WHERE m.BDate >= '20000101'--%REPORT_BEGINDATE%
AND m.EDate <= '20200228'--%REPORT_ENDDATE%
AND m.ChID != 71895
GROUP BY m.DocID, m.OurID, rcg2.CompGrName2, m.CompID, rc.CompName, m.BDate, m.EDate, m.ContrTypeID, ru.RefName, m.ContrID, rs.StockID, rs.CompAdd, tr.ProdID, rp.ProdName
) AS q
WHERE q.CompID = 61996

;WITH
Dublicates AS (SELECT CompID, ProdID, ContrTypeID
, ROW_NUMBER() OVER(PARTITION BY CompID, ProdID, ContrTypeID ORDER BY EDate DESC) number_of_dublicates
FROM @contracts)

DELETE FROM Dublicates WHERE number_of_dublicates > 1

SELECT * FROM @contracts

*/