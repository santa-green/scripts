DECLARE @comp varchar(max) = '29265 '
IF ISNUMERIC(@comp) = 1 (SELECT * FROM r_comps WHERE compid = @comp) ELSE (SELECT * FROM r_comps WHERE compname like '%' + @comp + '%')

SELECT * FROM at_z_Contracts WHERE CompID = 29265
SELECT * FROM r_CompGrs2 WHERE CompGrID2 = 2048
SELECT * FROM r_comps WHERE CompID = 29265

SELECT TaxPayer, comptype, *
FROM r_comps rc
WHERE rc.TaxPayer = 0
	AND rc.CompType = 1
	AND EXISTS (SELECT TOP 1 1
	FROM Elit.dbo.at_z_Contracts atz
	WHERE atz.CompID = rc.CompID
		AND atz.OurID IN (1,3)
		AND atz.ContrTypeID = 1
		AND atz.EDate >= GETDATE())