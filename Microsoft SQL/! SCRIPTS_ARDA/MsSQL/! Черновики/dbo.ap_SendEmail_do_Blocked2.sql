USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_SendEmail_do_Blocked]    Script Date: 23.06.2021 12:33:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_SendEmail_do_Blocked] @DB_IDs varchar(250) = '',  @Testing INT = 0
AS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ADDED] rkv0 '2021-06-23 12:33' добавил фио.

/*
exec ap_SendEmail_do_Blocked @DB_IDs = null,  @Testing = 0
exec ap_SendEmail_do_Blocked @DB_IDs = '10,14',  @Testing = 1
*/
IF 1=1
BEGIN
-- Проверка блокировок в базе
IF OBJECT_ID (N'tempdb..##GlobalTempTable_blocked', N'U') IS NOT NULL DROP TABLE ##GlobalTempTable_blocked

SELECT 
    spid
    ,[status]
    ,CONVERT(CHAR(3), blocked) AS blocked
    ,loginame
    --[ADDED] rkv0 '2021-06-23 12:33' добавил фио.
    ,ISNULL(gui.EmpName, '[нет инфо]') 'ФИО'
    ,SUBSTRING([program_name] ,1,25) AS program
    ,SUBSTRING(DB_NAME(p.dbid),1,20) AS [database]
    ,SUBSTRING(hostname, 1, 12) AS host
    ,cmd
    ,sys.fn_varbintohexstr (waittype ) waittype --,cast(waittype as varchar) waittype
	,cast(t.[text] as varchar(250)) text
 INTO ##GlobalTempTable_blocked
  FROM sys.sysprocesses p
    CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t
    --[ADDED] rkv0 '2021-06-23 12:33' добавил фио.
    JOIN dbo.af_GetUserInfo('ALL_USERS') gui ON gui.UserName = p.loginame
  WHERE ( (spid IN (SELECT blocked FROM sys.sysprocesses WHERE blocked <> 0) AND blocked = 0)  or (blocked <> 0) )
       AND ( [dbo].[zf_MatchFilterInt](p.dbid, @DB_IDs,',') = 1) 


	IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP

	SELECT *
	 INTO #TMP	
	FROM ##GlobalTempTable_blocked 

IF @Testing = 1 SELECT * FROM #TMP

---------скрипт формирования таблицы в HTML автоматический----------------------
--IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP

DECLARE @TableName_AUTO NVARCHAR(MAX) = '#TMP'

DECLARE @Head_AUTO NVARCHAR(MAX) = NULL
SELECT @Head_AUTO = ISNULL(@Head_AUTO,'') + '<th>' + COLUMN_NAME + '</th>'
FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
WHERE TABLE_NAME =(SELECT name FROM tempdb.sys.tables where object_id =  OBJECT_ID('tempdb..' + @TableName_AUTO) ) ORDER BY ORDINAL_POSITION

DECLARE @Fields NVARCHAR(MAX) = NULL
SELECT @Fields = ISNULL(@Fields,'') + CASE WHEN @Fields IS NULL THEN '' ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' AS td'
FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
WHERE TABLE_NAME = (SELECT name FROM tempdb.sys.tables WHERE object_id =  OBJECT_ID('tempdb..' + @TableName_AUTO) ) ORDER BY ORDINAL_POSITION

IF @Testing = 1 SELECT @Head_AUTO '@Head_AUTO'
IF @Testing = 1 SELECT @Fields '@Fields'

DECLARE @SQL NVARCHAR(4000);
DECLARE @result NVARCHAR(MAX)
SET @SQL = 'SELECT @result = (
SELECT '+ @Fields +' FROM #TMP t FOR XML RAW(''tr''), ELEMENTS
)';
IF @Testing = 1 SELECT @SQL '@SQL'
EXEC sp_executesql @SQL, N'@result NVARCHAR(MAX) output', @result = @result OUTPUT
IF @Testing = 1 SELECT @result '@result'

DECLARE @body_AUTO NVARCHAR(MAX)
SET @body_AUTO = N'<table  border="1" ><tr>' + @Head_AUTO + '</tr>' + @result + N'</table>'

IF @Testing = 1 SELECT @body_AUTO '@body_AUTO'
---------скрипт формирования таблицы в HTML автоматический----------------------

--Если временную таблицу #temptable не пустая
IF EXISTS (SELECT top 1 1 FROM ##GlobalTempTable_blocked where text not in ('xp_sqlagent_enum_jobs'))
BEGIN

  --Отправка почтового сообщения
  BEGIN TRY 
		DECLARE @body_str NVARCHAR(max) = '<p>Отправлено [S-SQL-D4] JOB ELIT Blocked шаг 1</p>'
		SET @body_AUTO = '<p>Блокировки в базе</p>'
					   + @body_AUTO
					   + '<br>
					   exec ap_SendEmail_do_Blocked @DB_IDs = ''1,10,14'',  @Testing = 1
					   '
					   + @body_str

		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'arda',
		@from_address = '<support_arda@const.dp.ua>',
		@recipients = 'support_arda@const.dp.ua;',    
		--@copy_recipients  = 'support_arda@const.dp.ua;',   
		@body = @body_AUTO,  
		@subject = 'Блокировки в базе #job',
		@body_format = 'HTML'--'HTML'
		--,@query = @SQL_query
		--,@append_query_error = 1
		--,@query_no_truncate= 0 -- не усекать запрос
		--,@attach_query_result_as_file= 1 -- 1 возвращается результирующий набор запроса как прикрепленный файл
		--,@query_result_header = 1 --Указывает, включают ли результаты запроса заголовки столбцов.
		;

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
END --#2 IF EXISTS 

DROP TABLE ##GlobalTempTable_blocked

END --#1 IF (CONVERT





GO
