IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable
CREATE TABLE #temptable(line nvarchar(max))
INSERT #temptable(line)  EXEC master..xp_cmdshell  'wmic printer get name'
SELECT * FROM #temptable