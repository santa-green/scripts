-- principals.
SELECT name, type_desc 
FROM sys.server_principals;

SELECT name, type_desc 
FROM sys.database_principals;


-- Batch-enable CDC on all user tables in the database.
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += '
EXEC sys.sp_cdc_enable_table 
    @source_schema = N''' + s.name + ''', 
    @source_name = N''' + t.name + ''', 
    @role_name = NULL;
'
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0
AND t.name NOT LIKE 'cdc[_]%'; -- Exclude CDC system tables

select @sql;

EXEC sp_executesql @sql;

-- columns with PK:
SELECT
  s.name  AS schema_name,
  t.name  AS table_name,
  c.name  AS column_name,
  ic.key_ordinal,
  kc.type
FROM sys.key_constraints kc
JOIN sys.indexes        i  ON kc.parent_object_id = i.object_id AND kc.unique_index_id = i.index_id
JOIN sys.index_columns  ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns        c  ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables         t  ON t.object_id = kc.parent_object_id
JOIN sys.schemas        s  ON s.schema_id = t.schema_id
WHERE kc.type = 'PK'
ORDER BY s.name, t.name, ic.key_ordinal;


