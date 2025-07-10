alter PROC usp_table (@table nvarchar(max))
as
begin
    DECLARE @sql NVARCHAR(MAX);

    SET @table = N'[S-SQL-D4].' + DB_NAME() + '.dbo.' + QUOTENAME(@table);
    SET @sql = N'SELECT top(10) * FROM ' + @table + ' WITH(NOLOCK)';
    EXEC sp_executesql @sql, N'@table nvarchar(max)', @table = @table;
end;

exec usp_table 'r_compsadd; drop table #t --'
exec usp_table 'r_compsadd'
select top(15) * into #t from r_CompsAdd
SELECT * FROM #t WITH(NOLOCK) 
DECLARE @table nvarchar(max)
SET @table = 'r_compsadd'
select QUOTENAME(@table) 
SELECT top(10) * FROM QUOTENAME(@table) WITH(NOLOCK)
SELECT top(10) * FROM [r_CompsAdd] WITH(NOLOCK)