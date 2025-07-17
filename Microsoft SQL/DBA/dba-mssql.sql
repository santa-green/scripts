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

