SELECT * FROM r_Desks
SELECT * FROM r_DeskG

insert r_Desks
SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Desks where DeskCode not in (SELECT DeskCode FROM r_Desks)



SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Deskg
except
SELECT * FROM r_DeskG
ORDER BY 2

SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Deskg d4 ORDER BY 2
SELECT * FROM r_DeskG dm ORDER BY 2


SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Deskg d4 
join r_DeskG dm on dm.DeskGCode = d4.DeskGCode
where dm.DeskGCode in (116,117,118)

BEGIN TRAN


update dm 
set dm.DeskGName = d4.DeskGName, dm.Notes = d4.Notes
FROM [S-SQL-D4].ElitR.dbo.r_Deskg d4 
join r_DeskG dm on dm.DeskGCode = d4.DeskGCode



ROLLBACK TRAN



SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Desks
except
SELECT * FROM r_Desks
ORDER BY 2

SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Desks d4 ORDER BY 2
SELECT * FROM r_Desks dm ORDER BY 2


SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Desks d4 
join r_Desks dm on dm.DeskCode = d4.DeskCode
--where dm.DeskGCode in (116,117,118)


BEGIN TRAN


update dm 
set dm.DeskName = d4.DeskName, dm.Notes = d4.Notes
FROM [S-SQL-D4].ElitR.dbo.r_Desks d4 
join r_Desks dm on dm.DeskCode = d4.DeskCode

SELECT DeskCode, DeskName, Notes FROM [S-SQL-D4].ElitR.dbo.r_Desks
except
SELECT DeskCode, DeskName, Notes FROM r_Desks
ORDER BY 2

ROLLBACK TRAN

SELECT DeskCode, DeskName, Notes FROM r_Desks
except
SELECT DeskCode, DeskName, Notes FROM [S-SQL-D4].ElitR.dbo.r_Desks


ORDER BY 2