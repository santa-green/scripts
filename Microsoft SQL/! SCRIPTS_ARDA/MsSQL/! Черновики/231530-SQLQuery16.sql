--#region INFO
/*
t_Sale – Продажа товара оператором: Заголовок; На ElitR сюда попадают все продажи с магазинов и ресторана. Это конечная точка.
t_SaleD – Детальная часть к тому, что сверху.
t_SalePays – Продажа товара оператором: Оплата; Здесь подробности оплаты по продаже (нал, безнал, сдача).
t_Sale_R – Здесь, по идее, хранятся продажи RKeeper (промежуточная таблица между кипером и ElitR).
t_SaleDLV - Продажа товара оператором: Сборы по товару; акциз.
r_DBIs – Список баз данных и их диапазоны ChID.
r_DeskG - Группы столиков.
r_Desks - Столики и группы.
t_MonRec - Прием наличных денег на склад.
*/
--#endregion INFO

--#region CHANGELOG
--[ADDED] '2021-05-17 16:02' rkv0 добавил проверку на IS NULL
--#endregion CHANGELOG

BEGIN
--#region Проверка синхронизации ркипера (t_sale_r) и базы (t_sale)
IF OBJECT_ID (N'tempdb..##GlobalTempTable', N'U') IS NOT NULL
	DROP TABLE ##GlobalTempTable

;WITH s2_CTE
AS
(
	SELECT *                         
	,      (SELECT cast(sum(qty) as numeric(21,9))
	FROM t_sale_r r with (nolock)
	where r.Docid = s1.Docid
		and r.OurID = s1.OurID)       'Tqty_R'
	,      (SELECT cast(sum(SumCC_wt) as numeric(21,9))
	FROM t_sale_r r with (nolock)
	where r.Docid = s1.Docid
		and r.OurID = s1.OurID)       'TSumCC_wt_R'
	,      (SELECT sum(qty)
	FROM t_saleD d with (nolock)
	where d.chid = (SELECT chid
		FROM t_sale r with (nolock)
		where r.Docid = s1.Docid
			and r.OurID = s1.OurID) ) 'Tqty'
	,      (SELECT sum(RealSum)
	FROM t_saleD d with (nolock)
	where d.chid = (SELECT chid
		FROM t_sale r with (nolock)
		where r.Docid = s1.Docid
			and r.OurID = s1.OurID) ) 'TRealSum'
	,      (SELECT sum(SumCC_wt)
	FROM t_SalePays d with (nolock)
	where d.chid = (SELECT chid
		FROM t_sale r with (nolock)
		where r.Docid = s1.Docid
			and r.OurID = s1.OurID) ) 'TSalePays'
	,      (SELECT sum(SumAC)
	FROM t_MonRec r with (nolock)
	where r.Docid = s1.Docid
		and r.OurID = s1.OurID)       'TSumAC_MonRec'
	FROM (SELECT distinct Docid
	,                     OurID
	FROM t_sale_r with (nolock)
	where Docdate >= DATEADD(day, -15, dbo.zf_GetDate(getdate())) ) s1
)

SELECT *
	INTO ##GlobalTempTable
FROM s2_CTE
WHERE round(Tqty_R , 3) <> round(Tqty , 3)
	or round(TSumCC_wt_R , 2) <> round(TRealSum , 2)
	or round(TSumCC_wt_R , 2) <> round(TSalePays , 2)
	or round(TSumCC_wt_R , 2) <> round(TSumAC_MonRec , 2)
	--[ADDED] '2021-05-17 16:02' rkv0 добавил проверку на IS NULL
	or Tqty_R IS NULL
	or Tqty IS NULL
	or TRealSum IS NULL

IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL
	DROP TABLE #TMP

SELECT *
	INTO #TMP
FROM ##GlobalTempTable

SELECT *
FROM #TMP
--#endregion Проверка синхронизации ркипера (t_sale_r) и базы (t_sale)

--#region скрипт формирования таблицы в HTML автоматический
--IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP

DECLARE @TableName_AUTO NVARCHAR(MAX) = '#TMP'

DECLARE @Head_AUTO NVARCHAR(MAX) = NULL
SELECT @Head_AUTO = ISNULL(@Head_AUTO,'') + '<th>' + COLUMN_NAME + '</th>'
FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
WHERE TABLE_NAME =(SELECT name
	FROM tempdb.sys.tables
	where object_id = OBJECT_ID('tempdb..' + @TableName_AUTO) )
ORDER BY ORDINAL_POSITION

DECLARE @Fields NVARCHAR(MAX) = NULL
SELECT @Fields = ISNULL(@Fields,'') + CASE WHEN @Fields IS NULL THEN ''
                                                                ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' AS td'
FROM [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
WHERE TABLE_NAME = (SELECT name
	FROM tempdb.sys.tables
	WHERE object_id = OBJECT_ID('tempdb..' + @TableName_AUTO) )
ORDER BY ORDINAL_POSITION

SELECT @Head_AUTO
SELECT @Fields

DECLARE @SQL NVARCHAR(4000);
DECLARE @result NVARCHAR(MAX)
SET @SQL = 'SELECT @result = (
SELECT '+ @Fields +' FROM #TMP t FOR XML RAW(''tr''), ELEMENTS
)';
SELECT @SQL
EXEC sp_executesql           @SQL
,                            N'@result NVARCHAR(MAX) output'
,                  @result = @result OUTPUT
SELECT @result

DECLARE @body_AUTO NVARCHAR(MAX)
SET @body_AUTO = N'<table  border="1" ><tr>' + @Head_AUTO + '</tr>' + @result + N'</table>'

SELECT @body_AUTO
--#endregion скрипт формирования таблицы в HTML автоматический

--Если временную таблицу #temptable не пустая
IF EXISTS (SELECT top 1 1 FROM ##GlobalTempTable)
--#region Отправка почтового сообщения
BEGIN

  BEGIN TRY 
		DECLARE @body_str NVARCHAR(max) = '<p>Отправлено [S-SQL-D4] JOB ELITR ImportSalesFromRK Checking шаг 3 (проверка синхронизации ркипера (t_sale_r) и базы (t_sale))</p>'
		SET @body_AUTO = '<p>В таблице номера чеков в которых не совпадают количество или суммы:</p>'
					   + @body_AUTO
					   + '<br> 
						<br> 
						'
					   + @body_str

		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'arda',
		@from_address = '<support_arda@const.dp.ua>',
		@recipients = 'support_arda@const.dp.ua;',    
		--@copy_recipients  = 'support_arda@const.dp.ua;',   
		@body = @body_AUTO,  
		@subject = 'Найдены номера чеков в которых не совпадают количество или суммы #job',
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
--#endregion Отправка почтового сообщения

DROP TABLE ##GlobalTempTable

END; --#1 IF (CONVERT

