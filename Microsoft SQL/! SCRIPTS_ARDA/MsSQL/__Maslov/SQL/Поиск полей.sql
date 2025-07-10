DECLARE @field VARCHAR(256)
SET @field = '%WPID%'

select TABLE_NAME, DATA_TYPE, zt.TableDesc
from INFORMATION_SCHEMA.COLUMNS as m
JOIN z_Tables zt ON m.TABLE_NAME = zt.TableName
where COLUMN_NAME like @field
order by 1;

/*
SELECT * FROM z_Tables
WHERE TableName = 'iv_SpecD'
*/