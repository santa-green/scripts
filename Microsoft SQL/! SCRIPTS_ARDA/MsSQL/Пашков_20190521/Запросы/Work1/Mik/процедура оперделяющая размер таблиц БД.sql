CREATE PROCEDURE _it_TableSpaces
AS
SET NOCOUNT ON

CREATE TABLE #TableSpaces 
(
  name sysname, 
  rows int, 
  reserved nvarchar(250),
  data nvarchar(250),
  index_size nvarchar(250),
  unused  nvarchar(250)
)

DECLARE @TableName sysname

DECLARE MyCur CURSOR LOCAL FAST_FORWARD FOR
SELECT u.name + '.' + o.name
FROM sysobjects o inner join sysusers u ON o.uid = u.uid
WHERE xtype = 'U'

OPEN MyCur
FETCH NEXT FROM MyCur INTO @TableName
WHILE @@FETCH_STATUS = 0
  BEGIN
    INSERT INTO #TableSpaces 
    EXEC sp_spaceused @TableName, 'true'
    FETCH NEXT FROM MyCur INTO @TableName
  END

CLOSE MyCur
DEALLOCATE MyCur

SELECT *
FROM #TableSpaces 
ORDER BY LEN(reserved) DESC, reserved DESC

SELECT *
FROM #TableSpaces 
ORDER BY LEN(data) DESC, data DESC

SELECT *
FROM #TableSpaces 
ORDER BY LEN(index_size) DESC, index_size DESC

SELECT *
FROM #TableSpaces 
ORDER BY LEN(unused) DESC, unused DESC

SELECT *
FROM #TableSpaces 
ORDER BY rows DESC