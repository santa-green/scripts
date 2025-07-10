--Размер таблиц в базе данных
IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL DROP TABLE #temp
CREATE TABLE #temp (
table_name sysname ,
row_count INT,
reserved_size VARCHAR(50),
data_size VARCHAR(50),
index_size VARCHAR(50),
unused_size VARCHAR(50))
SET NOCOUNT ON
INSERT #temp
EXEC sp_msforeachtable 'sp_spaceused ''?'''
SELECT a.table_name,
a.row_count,
COUNT(*) AS col_count,
CAST(REPLACE(a.data_size, ' KB', '') AS integer) as 'data_size, KB'
--,
--max(t.TableDesc) as 'Описание таблицы'
FROM #temp a
INNER JOIN information_schema.columns b
ON a.table_name collate database_default
= b.table_name collate database_default
--LEFT JOIN z_Tables t ON t.TableName = a.table_name
GROUP BY a.table_name, a.row_count, a.data_size
ORDER BY 1, CAST(REPLACE(a.data_size, ' KB', '') AS integer) DESC
--DROP TABLE #temp

/*
SELECT * FROM #temp order by 2 desc

SELECT a.table_name,
a.row_count,
COUNT(*) AS col_count,
CAST(REPLACE(a.data_size, ' KB', '') AS integer) as 'data_size, KB',
max(t.TableDesc) as 'Описание таблицы'
FROM #temp a
INNER JOIN information_schema.columns b
ON a.table_name collate database_default
= b.table_name collate database_default
LEFT JOIN z_Tables t ON t.TableName = a.table_name

where a.table_name like '%tsd%'

GROUP BY a.table_name, a.row_count, a.data_size
ORDER BY 1, CAST(REPLACE(a.data_size, ' KB', '') AS integer) DESC
*/