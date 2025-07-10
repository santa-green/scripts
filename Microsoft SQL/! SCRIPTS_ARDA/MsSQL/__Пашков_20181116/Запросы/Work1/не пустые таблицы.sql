create table #t (
  tab sysname,
  rows bigint
)

DECLARE count_table CURSOR FOR SELECT
  'insert into #t select ''' + TABLE_SCHEMA + '.' + TABLE_NAME + ''', count( 1) from ' + TABLE_SCHEMA + '.' + TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'

DECLARE @count_table NVARCHAR(1000)
OPEN count_table

FETCH NEXT FROM count_table INTO @count_table

WHILE @@FETCH_STATUS = 0 BEGIN
  PRINT @count_table
  EXEC(@count_table)
  FETCH NEXT FROM count_table INTO @count_table
END

CLOSE count_table
DEALLOCATE count_table

select * from #t where rows > 0 order by tab
--drop table #t