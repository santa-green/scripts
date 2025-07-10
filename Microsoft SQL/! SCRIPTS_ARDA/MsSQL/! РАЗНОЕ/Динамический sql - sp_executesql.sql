DECLARE @compid int = 7001
DECLARE @sqlCommand nvarchar(1000) = 'select * from r_comps WHERE compid = @compid'
EXEC sp_executesql @sqlCommand, N'@compid int', @compid = 7003

