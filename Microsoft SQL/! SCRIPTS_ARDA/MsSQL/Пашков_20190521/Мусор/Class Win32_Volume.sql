DECLARE  @SERVER_NAME nvarchar(255) = 'S-SQL-d1'

	DECLARE @SQL_EXECUTE nvarchar(255) = N'powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@SERVER_NAME,'''') +
										'-Class Win32_Volume -Filter ''DriveType = 3'' | select name,capacity,freespace | foreach{$_.name+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"' -- переменная для cmdshell

		--DECLARE @SQL_EXECUTE nvarchar(255) = N'powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@SERVER_NAME,'''') +
		--								' Get-ChildItem -Path e:\OT38ElitServer\Import\test\* -Filter *.sql -Recurse  | Select-String -pattern "sp_OACreate" ";'
		--select @SQL_EXECUTE SQL_EXECUTE

	-- Создаем временное хранилище для результатов cmdshell
	if object_id('tempdb..#output_cmdshell') is not null DROP TABLE #output_cmdshell
	CREATE TABLE #output_cmdshell
	(
	  line varchar(255)
	)

	-- Закидываем полученные данные в хранилище
	INSERT #output_cmdshell
	EXEC xp_cmdshell @SQL_EXECUTE

	--SELECT * FROM #output_cmdshell

			SELECT
			rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) AS [DiskName]
			,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1
			,(CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as decimal(15,2)),0) AS [capacity(MB)]
			,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1
			,(CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as decimal(15,2)),0) AS [freespace(MB)]
		from #output_cmdshell
		where line like '[A-Z][:]%'
		order by [DiskName]

--EXEC xp_cmdshell 'powershell.exe -c "Get-WmiObject -List -ComputerName ''S-sql-d4'''
/*
EXEC xp_cmdshell 'powershell.exe -c "Get-WmiObject -ComputerName ''S-sql-d4'' -Class Win32_Volume'
*/
