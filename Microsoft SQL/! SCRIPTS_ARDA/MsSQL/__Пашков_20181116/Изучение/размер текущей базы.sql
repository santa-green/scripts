--размер текущей базы

declare @id	int			-- The object id that takes up space
		,@type	character(2) -- The object type.
		,@pages	bigint			-- Working variable for size calc.
		,@dbname sysname
		,@dbsize bigint
		,@logsize bigint
		,@reservedpages  bigint
		,@usedpages  bigint
		,@rowCount bigint

	select @dbsize = sum(convert(bigint,case when status & 64 = 0 then size else 0 end))
		, @logsize = sum(convert(bigint,case when status & 64 <> 0 then size else 0 end))
		from dbo.sysfiles

	select @reservedpages = sum(a.total_pages),
		@usedpages = sum(a.used_pages),
		@pages = sum(
				CASE
					-- XML-Index and FT-Index internal tables are not considered "data", but is part of "index_size"
					When it.internal_type IN (202,204,211,212,213,214,215,216) Then 0
					When a.type <> 1 Then a.used_pages
					When p.index_id < 2 Then a.data_pages
					Else 0
				END
			)
	from sys.partitions p join sys.allocation_units a on p.partition_id = a.container_id
		left join sys.internal_tables it on p.object_id = it.object_id

	/* unallocated space could not be negative */
	select 
		database_name = db_name(),
		database_size = ltrim(str((convert (dec (15,2),@dbsize) + convert (dec (15,2),@logsize)) 
			* 8192 / 1048576,15,2) + ' MB'),
		'unallocated space' = ltrim(str((case when @dbsize >= @reservedpages then
			(convert (dec (15,2),@dbsize) - convert (dec (15,2),@reservedpages)) 
			* 8192 / 1048576 else 0 end),15,2) + ' MB')

	/*
	**  Now calculate the summary data.
	**  reserved: sum(reserved) where indid in (0, 1, 255)
	** data: sum(data_pages) + sum(text_used)
	** index: sum(used) where indid in (0, 1, 255) - data
	** unused: sum(reserved) - sum(used) where indid in (0, 1, 255)
	*/
	select
		reserved = ltrim(str(@reservedpages * 8192 / 1024.,15,0) + ' KB'),
		data = ltrim(str(@pages * 8192 / 1024.,15,0) + ' KB'),
		index_size = ltrim(str((@usedpages - @pages) * 8192 / 1024.,15,0) + ' KB'),
		unused = ltrim(str((@reservedpages - @usedpages) * 8192 / 1024.,15,0) + ' KB')

