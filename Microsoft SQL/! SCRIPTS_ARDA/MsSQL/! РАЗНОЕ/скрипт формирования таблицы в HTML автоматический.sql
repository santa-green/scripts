
	IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP

	SELECT * 
	 INTO #TMP	
	from (
select 1013 CompID, 2 CompAddID,110 TerrID
UNION ALL select 1023 CompID, 1 CompAddID,110 TerrID
UNION ALL select 1062 CompID, 2 CompAddID,118 TerrID
UNION ALL select 1065 CompID, 6 CompAddID,110 TerrID
UNION ALL select 1065 CompID, 5 CompAddID,110 TerrID
UNION ALL select 1065 CompID, 2 CompAddID,110 TerrID
UNION ALL select 1065 CompID, 7 CompAddID,110 TerrID
UNION ALL select 1083 CompID, 2 CompAddID,110 TerrID
UNION ALL select 1097 CompID, 3 CompAddID,102 TerrID
UNION ALL select 1097 CompID, 4 CompAddID,102 TerrID
UNION ALL select 1101 CompID, 2 CompAddID,109 TerrID
UNION ALL select 1107 CompID, 4 CompAddID,110 TerrID
) s1

SELECT * FROM #TMP



---------скрипт формировани€ таблицы в HTML автоматический----------------------
--IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP

DECLARE @TableName_AUTO NVARCHAR(MAX) = '#TMP'

DECLARE @Head_AUTO NVARCHAR(MAX) = null
SELECT @Head_AUTO = isnull(@Head_AUTO,'') + '<th>' + COLUMN_NAME + '</th>'
FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
WHERE TABLE_NAME =(select name from tempdb.sys.tables where object_id =  OBJECT_ID('tempdb..' + @TableName_AUTO) ) ORDER BY ORDINAL_POSITION

DECLARE @Fields NVARCHAR(MAX) = null
SELECT @Fields = isnull(@Fields,'') + case when @Fields is null then '' else ',' end + QUOTENAME(COLUMN_NAME) + ' AS td'
FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
WHERE TABLE_NAME =(select name from tempdb.sys.tables where object_id =  OBJECT_ID('tempdb..' + @TableName_AUTO) ) ORDER BY ORDINAL_POSITION

SELECT @Head_AUTO
SELECT @Fields

DECLARE @SQL nvarchar(4000);
DECLARE @result NVARCHAR(MAX)
SET @SQL = 'SELECT @result = (
SELECT '+ @Fields +' FROM #TMP t FOR XML RAW(''tr''), ELEMENTS
)';
select @SQL
EXEC sp_executesql @SQL, N'@result NVARCHAR(MAX) output', @result = @result output
select @result

DECLARE @body_AUTO NVARCHAR(MAX)
SET @body_AUTO = N'<table  border="1" ><tr>' + @Head_AUTO + '</tr>' + @result + N'</table>'

SELECT @body_AUTO
---------скрипт формировани€ таблицы в HTML автоматический----------------------

SELECT * FROM #TMP

  BEGIN TRY 
	DECLARE @subject varchar(250), @tableHTML  NVARCHAR(MAX) 
	SET @subject = '¬нимание!!! Ќа складе 1200 отрицательные остатки.Ёто нарушает работу интернет магазина'
	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'arda',
	@recipients = 'pashkovv@const.dp.ua',--дл€ теста  
	--@recipients = 'rovnyagina@const.dp.ua;', 
	--@copy_recipients = 'support_arda@const.dp.ua',  
	@subject = @subject,
	@body = @body_AUTO,  
	@body_format = 'HTML'
	-------------------,@query = 'SELECT * FROM tempdb..#TOrders; SELECT * FROM tempdb..#TOrdersD'; 
  END TRY  
  BEGIN CATCH
    SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
  END CATCH  

