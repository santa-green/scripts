USE Alef_Elit_TEST
GO

DBCC SHRINKDATABASE('Alef_Elit_TEST', TABULAR) --(TABULAR) option is an undocumented feature, so it could change in future.
DBCC SHRINKFILE('Mobile_Blank')
SELECT DB_ID()
SELECT * FROM sys.database_files 

SELECT DB_NAME() AS DbName, 
    name AS FileName, 
    type_desc,
    size/128.0 AS CurrentSizeMB,  
    size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB
FROM sys.database_files
WHERE type IN (0,1);

exec sp_spaceused 'alef_edi_gln_ot'