ALTER PROCEDURE [dbo].[ap_GetEquipmentOnComp] (@BDate SMALLDATETIME = '1901-01-01', @EDate SMALLDATETIME = '1901-01-02')
AS
BEGIN

/*
EXEC ap_GetEquipmentOnComp @EDate = '2020-02-28'
*/

/*
Договор универсальный (ед. оборудования)
*/
DECLARE
 @ContrTypeID VARCHAR(256) = '3,9'		-- Тип договора
,@OurID VARCHAR(256) = '3'				-- Фирма

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
AND m.BDate >= @BDate
AND m.EDate <= @EDate
AND m.ChID != 71895
GROUP BY m.OurID, rcg2.CompGrName2, m.CompID, rc.CompName, m.BDate, m.EDate, m.ContrTypeID, ru.RefName, m.ContrID

;WITH
Dublicates AS (SELECT CompID
, ROW_NUMBER() OVER(PARTITION BY CompID ORDER BY EDate DESC) number_of_dublicates
FROM @contracts)

DELETE FROM Dublicates WHERE number_of_dublicates > 1

SELECT * FROM @contracts
END;