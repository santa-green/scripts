USE [DBA_DATABASE]
GO
/****** Object:  StoredProcedure [dbo].[p_1011_Disk_Space]    Script Date: 24.01.2019 17:37:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_1011_Disk_Space]
-- EXEC [DBA_DATABASE].[dbo].[p_1011_Disk_Space] @PrecentFree = 100, @SERVER_NAME = 'S-SQL-AGRO'
(
	@SERVER_NAME nvarchar(128) = @@SERVERNAME,
	@PrecentFree tinyint = 10
)
AS
BEGIN
	SET NOCOUNT ON
	--====== Начало подсчета времени ==
	DECLARE @Time datetime2
	SELECT @Time = CurrectDateTime
	FROM [DBA_DATABASE].[dbo].[GetDate]
	--=================================

	DECLARE @SQL_EXECUTE nvarchar(255) = N'powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@SERVER_NAME,'''') +
										'-Class Win32_Volume -Filter ''DriveType = 3'' | select name,capacity,freespace | foreach{$_.name+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"' -- переменная для cmdshell
	DECLARE @POST_TIME date = GetDate() -- время сбора данных

	-- Создаем временное хранилище для результатов cmdshell
	if object_id('tempdb..#output_cmdshell') is not null DROP TABLE #output_cmdshell
	CREATE TABLE #output_cmdshell
	(
	  line varchar(255)
	)

	-- Закидываем полученные данные в хранилище
	INSERT #output_cmdshell
	EXEC xp_cmdshell @SQL_EXECUTE

	if object_id('tempdb..#check_result') is not null DROP TABLE #check_result
	CREATE TABLE #check_result
	(
		[DiskName] nchar(3),
		[Total_space (MB)] decimal(15,2),
		[Free_space (MB)] decimal(15,2),
		[Free_Percent (%)] AS (([Free_space (MB)]*(100.0))/[Total_space (MB)])
	)
	-- Делаем вставку в логирую таблицу
	INSERT #check_result([DiskName], [Total_space (MB)], [Free_space (MB)])
		SELECT
			rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) AS [DiskName]
			,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1
			,(CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as decimal(15,2)),0) AS [capacity(MB)]
			,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1
			,(CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as decimal(15,2)),0) AS [freespace(MB)]
		from #output_cmdshell
		where line like '[A-Z][:]%'
		order by [DiskName]

	IF EXISTS(SELECT 1 FROM #check_result cr WHERE cr.[Free_Percent (%)] < @PrecentFree)
	BEGIN
		DECLARE @Noticc nvarchar(256) = ''
		SELECT @Noticc = @Noticc + CASE
								   WHEN cr.[Free_Percent (%)] < @PrecentFree THEN '[' + @SERVER_NAME + '](' + cr.DiskName + ') '
								   ELSE ''
								   END
		FROM #check_result cr
		SET @Noticc = @Noticc + ' have less than a specified percentage of free space (' + CAST(@PrecentFree AS nvarchar) + ')' + char(13)

		EXEC [dbo].[p_1013_Send_Mail] @CodeMes = 0, @Notic = @Noticc
	END

	INSERT [DBA_DATABASE].[dbo].[Disk_Space]([PostTime], [SERVERNAME], [DiskName], [Total_space (MB)], [Free_space (MB)], [Free_Percent (%)])
		SELECT
			@POST_TIME,
			@SERVER_NAME,
			cr.DiskName,
			cr.[Total_space (MB)],
			cr.[Free_space (MB)],
			cr.[Free_Percent (%)]
		FROM #check_result cr

	-- Убиваем временное хранилище
	DROP TABLE #output_cmdshell
	DROP TABLE #check_result

	--============================================================ Окончание подсчета времени ===========================
	DECLARE @Duration bigint
	SELECT @Duration = datediff(ms, @Time, CurrectDateTime)
	FROM [DBA_DATABASE].[dbo].[GetDate]
	EXEC [DBA_DATABASE].[dbo].[p_9999_Maintenance_Session] @Code = 1011, @DurationMS = @Duration, @DB_Name = @SERVER_NAME
	--===================================================================================================================
END

GO
