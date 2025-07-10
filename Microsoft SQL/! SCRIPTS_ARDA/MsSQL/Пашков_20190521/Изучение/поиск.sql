set statistics time off
GO
IF OBJECT_ID('tempdb..#T') IS NOT NULL DROP TABLE #T
GO

select TOp 1000000 ISNULL(v1.name, '')+ ' ' + ISNULL(v2.name, '') as name, CAST('' AS char(10)) as test
into #T
from master.dbo.spt_values v1, master.dbo.spt_values v2

set statistics time on
GO



DECLARE @s varchar(200) = UPPER ('SYSDEVICES STATUS')

select * from #T
WHERE name LIKE '%' + @s + '%'

select * from #T
WHERE 
(
	name LIKE '%' + @s + '%'
	OR name LIKE '%' + @s
	OR name LIKE @s + '%'
)

select * from #T
WHERE 
(
	name LIKE '%' + @s + '%'
	OR name LIKE '%' + @s
	OR name LIKE @s + '%'
)
AND name LIKE '%' + @s + '%'

select * from #T
WHERE 
(
	name LIKE '%' + @s + '%'
	OR name LIKE '%' + @s
	OR name LIKE @s + '%'
)
AND name LIKE '%' + @s + '%' COLLATE Latin1_General_BIN

select * from #T
WHERE UPPER (name) LIKE '%' + @s + '%' COLLATE Latin1_General_BIN

select * from #T
WHERE PATINDEX ('%' + @s + '%',UPPER (name) COLLATE Latin1_General_BIN) != 0

 
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

(строк обработано: 1000000)
SQL Server parse and compile time: 
   CPU time = 1844 ms, elapsed time = 1874 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(строк обработано: 30)

 SQL Server Execution Times:
   CPU time = 6625 ms,  elapsed time = 6669 ms.

(строк обработано: 30)

 SQL Server Execution Times:
   CPU time = 3500 ms,  elapsed time = 3516 ms.

(строк обработано: 27)

 SQL Server Execution Times:
   CPU time = 656 ms,  elapsed time = 668 ms.

*/