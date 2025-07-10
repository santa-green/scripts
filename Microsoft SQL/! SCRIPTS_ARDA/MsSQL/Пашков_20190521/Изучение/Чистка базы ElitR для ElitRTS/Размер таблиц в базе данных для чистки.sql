-- Размер таблиц в базе данных
DECLARE @pagesizeKB bigint
SELECT @pagesizeKB = low / 1024 FROM master.dbo.spt_values
WHERE number = 1 AND type = 'E'

SELECT
  table_name = OBJECT_NAME(o.id),
  rows = i1.rowcnt,
  reservedKB = (ISNULL(SUM(i1.reserved), 0) + ISNULL(SUM(i2.reserved), 0)) * @pagesizeKB,
  dataKB = (ISNULL(SUM(i1.dpages), 0) + ISNULL(SUM(i2.used), 0)) * @pagesizeKB,
  index_sizeKB = ((ISNULL(SUM(i1.used), 0) + ISNULL(SUM(i2.used), 0))
    - (ISNULL(SUM(i1.dpages), 0) + ISNULL(SUM(i2.used), 0))) * @pagesizeKB,
  unusedKB = ((ISNULL(SUM(i1.reserved), 0) + ISNULL(SUM(i2.reserved), 0))
    - (ISNULL(SUM(i1.used), 0) + ISNULL(SUM(i2.used), 0))) * @pagesizeKB,
    max(t.TableDesc) as 'Описание таблицы'
FROM sysobjects o
LEFT OUTER JOIN sysindexes i1 ON i1.id = o.id AND i1.indid < 2
LEFT OUTER JOIN sysindexes i2 ON i2.id = o.id AND i2.indid = 255
LEFT JOIN z_Tables t ON t.TableName = OBJECT_NAME(o.id)
WHERE OBJECTPROPERTY(o.id, N'IsUserTable') = 1 --same as: o.xtype = 'IsView'
OR (OBJECTPROPERTY(o.id, N'IsView') = 1 AND OBJECTPROPERTY(o.id, N'IsIndexed') = 1)
GROUP BY o.id, i1.rowcnt

--having  i1.rowcnt <> 0
ORDER BY 1
--ORDER BY 3 DESC