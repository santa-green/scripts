--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*sp_executesql*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @orderid nvarchar(128) = 'ÐÎÇ01062340'
DECLARE @chid nvarchar(max)
DECLARE @sql_string nvarchar(max) = N'SELECT @chid_out = max(chid) FROM t_inv WHERE orderid = @orderid'

execute sp_executesql    @sql_string
                    , N'@orderid nvarchar(max), @chid_out nvarchar(max) OUTPUT'
                    , @orderid = @orderid
                    , @chid_out = @chid OUTPUT
SELECT @chid;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*sql injection*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[Ïðèìåð 1]
--÷åðåç EXEC(@sql);
--sql injection!
DECLARE @foo nvarchar(64) = N'string''; SELECT top 1 * FROM dbo.t_inv; --'''
DECLARE @sql nvarchar(max) = N'SELECT * FROM dbo.t_inv WHERE orderid = ''' + @foo + '''';
select @sql
EXEC(@sql);
--go


--[Ïðèìåð 2]
--÷åðåç sp_executesql…;
DECLARE @foo nvarchar(64) = N'string''; SELECT top 1 * FROM dbo.t_inv; --'''
DECLARE @sql nvarchar(max) = N'SELECT * FROM dbo.t_inv WHERE orderid = @foo;';
select @sql
select @foo
--go
EXEC sp_executesql @sql, N'@foo nvarchar(64)', @foo;


--[Ïðèìåð 3]
--quotename…;
    DECLARE @table varchar(max) = 'r_comps; SELECT 1'
    DECLARE @sql NVARCHAR(MAX);

    SET @table = N'[S-SQL-D4].' + DB_NAME() + '.dbo.' + QUOTENAME(@table);
    SET @sql = N'SELECT top(10) * FROM ' + @table + ' WITH(NOLOCK)';
    EXEC sp_executesql @sql, N'@table nvarchar(max)', @table = @table;
