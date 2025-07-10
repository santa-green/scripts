insert r_PCs
SELECT * FROM [s-sql-d4].elitr.dbo.r_PCs where PCCode not in (SELECT PCCode FROM r_PCs) and PCCode = 14