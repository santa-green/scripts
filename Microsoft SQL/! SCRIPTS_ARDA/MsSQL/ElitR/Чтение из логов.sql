SELECT * FROM z_Tables where TableDesc like '%вес%'

SELECT * FROM z_LogScale where ScaleID = 62
ORDER BY DocTime desc

exec master..xp_cmdshell 'type /?'
exec master..xp_cmdshell 'type E:\OT38ElitServer\Log\test2.log'
exec master..xp_cmdshell 'type \\s-sql-d4\OT38ElitServer\Log\test2.log'
exec master..xp_cmdshell 'type \\10.1.0.164\GMSServer\LogsScale\SCALEID_63_20171024.log'



bulk insert tempdb..#temp from [\\s-sql-d4\OT38ElitServer\Log\test2.log] with ( CODEPAGE = 1251 , rowterminator ='>') 





SELECT SQLText FROM OPENROWSET(BULK N'E:\OT38ElitServer\Log\test2.log', SINGLE_CLOB) AS Document(SQLText)

SELECT * FROM OPENROWSET(BULK N'E:\OT38ElitServer\Log\test2.log', SINGLE_CLOB) as ttt


SELECT  * INTO #temp FROM  OPENROWSET(BULK N'E:\OT38ElitServer\Log\test2.log', SINGLE_CLOB) as ttt
SELECT * FROM #temp

--Допустим есть процедура в которой мы объявили переменную

DECLARE @myquery VARCHAR(2000)
DECLARE @result int
declare @cmd  VARCHAR(2000);
declare @query VARCHAR(2000);
declare @FileName VARCHAR(2000);
SET @FileName = 'E:\OT38ElitServer\Log\test2.log';
SELECT @query = SQLText FROM OPENROWSET(BULK N'E:\OT38ElitServer\Import\test\bh__rec.txt', SINGLE_CLOB) AS Document(SQLText)
set @cmd = 'bcp.exe "' + @query + '" queryout "' + @FileName + '" -c  -r "\n"  -T -S s-sql-d4';
SELECT @cmd
EXEC @result = master..xp_cmdshell @cmd;

SELECT @result

IF (@result = 0)
   SELECT 'Успешно'
ELSE
   SELECT N'Ошибка' 


go

--declare @FileName VARCHAR(2000);
--SET @FileName = 'E:\OT38ElitServer\Log\test2.log';

IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL DROP TABLE #temp
--CREATE TABLE #temp (f1 NVARCHAR(250) null,f2 NVARCHAR(250) null,f3 NVARCHAR(250) null,f4 NVARCHAR(250) null )
--CREATE TABLE #temp (f1 NVARCHAR(250) null,f2 NVARCHAR(250) null,f3 NVARCHAR(250) )
--CREATE TABLE #temp (f1 NVARCHAR(250) null,f2 NVARCHAR(250) null )
CREATE TABLE #temp (f1 NVARCHAR(max) null)

bulk insert tempdb..#temp from [\\s-sql-d4\OT38ElitServer\Log\test2.log] with ( CODEPAGE = 1251 , FIELDTERMINATOR = ':') 
SELECT * FROM #temp



--чтение из файла штрихкод комбайна
DECLARE @FileName VARCHAR(2000);
SET @FileName = '\\s-sql-d4\OT38ElitServer\Import\test\20598__snt.txt';
IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL DROP TABLE #temp
CREATE TABLE #temp (f1 NVARCHAR(250) null,f2 NVARCHAR(250) null,f3 NVARCHAR(250) null,f4 NVARCHAR(250) null ,f5 NVARCHAR(250) null)
--bulk insert #temp from [\\s-sql-d4\OT38ElitServer\Import\test\20598__snt.txt] with ( CODEPAGE = 1251 , FIELDTERMINATOR = '#;#') 
--bulk insert #temp from [\\s-sql-d4\OT38ElitServer\Import\test\600000546 Кока-Кола Бевериджиз Украина__rec.txt] with ( CODEPAGE = 1251 , FIELDTERMINATOR = '#;#') 
--bulk insert #temp from [\\s-sql-d4\OT38ElitServer\Import\test\test4.txt] with ( CODEPAGE = 1251 , FIELDTERMINATOR = '#;#') 
--bulk insert #temp from [\\s-sql-d4\OT38ElitServer\Import\test\test4.txt] with ( CODEPAGE = 1251 ) 
--bulk insert #temp from [\\s-sql-d4\OT38ElitServer\Import\test\test4.txt] with ( CODEPAGE = 'RAW' ) 
--bulk insert #temp from [\\s-sql-d4\OT38ElitServer\Import\test\test4.txt] with ( CODEPAGE = 'ACP' ) 
--bulk insert #temp from [\\s-sql-d4\OT38ElitServer\Import\test\test4.txt] with ( DATAFILETYPE  = 'widechar'  ) 
bulk insert #temp from [\\s-sql-d4\OT38ElitServer\Import\test\20598__snt.txt] with ( DATAFILETYPE  = 'widechar' , FIELDTERMINATOR = '#;#' ) 
SELECT * FROM #temp


DECLARE @SQLStr nvarchar(500), @Params nvarchar(500), @Pos int, @File nvarchar(max), @subject nvarchar(max)SET @File = N'\\s-sql-d4\OT38ElitServer\Import\test\20598__snt.txt'SELECT @SQLStr = N'bulk insert #temp from [' + @File + '] with ( DATAFILETYPE  = ''widechar'' , FIELDTERMINATOR = ''#;#'' )'EXECUTE sp_executesql @SQLStrSELECT * FROM #temp
	--SELECT @Params = N''--EXECUTE sp_executesql @SQLStr, @Params,  @Pos OUTPUT
--запись в файл штрихкод комбайна
DECLARE @myquery VARCHAR(2000)
DECLARE @result int
declare @cmd  VARCHAR(2000);
declare @query VARCHAR(2000);
declare @FileName VARCHAR(2000);
SET @FileName = 'E:\OT38ElitServer\Import\test\test5.txt';
SELECT @query = SQLText FROM OPENROWSET(BULK N'E:\OT38ElitServer\Import\test\bh__rec.txt', SINGLE_CLOB) AS Document(SQLText)
SELECT @query
set @cmd = 'bcp.exe "' + @query + '" queryout "' + @FileName + '" -c  -C 65000  -r "\n"  -T -S s-sql-d4';
SELECT @cmd
EXEC @result = master..xp_cmdshell @cmd;

SELECT @result

IF (@result = 0)
   SELECT 'Успешно'
ELSE
   SELECT N'Ошибка' 
   

SELECT * FROM it_TSD_doc_head

SELECT cast(p.ProdID as char(6))+'-'+cast(p.UAProdName as varchar(250)) + '#;#' +cast(mq.BarCode as varchar(14)) + '#;#' +cast(d.Count_doc as varchar(10)) + '#;#' +cast(g.Good_price as varchar(14)) + '#;#' +cast(d.Count_real as varchar(14))  FROM ElitR.dbo.it_TSD_doc_head h join ElitR.dbo.it_TSD_doc_details d on d.Id_doc = h.Id_doc join ElitR.dbo.r_Prods p on p.ProdID = d.Id_good left join ElitR.dbo.it_TSD_goods g on g.Id_good = d.Id_good left join ElitR.dbo.it_TSD_barcode mq on mq.Id_good = d.Id_good where h.sklad_in_id = 1257 and h.Id_doc in (22099)


--или 

SELECT  SQLText FROM OPENROWSET(BULK N'E:\OT38ElitServer\Log\test2.log', SINGLE_CLOB) AS Document(SQLText)
SELECT  CHARINDEX('Программирование товаров завершено, экспортировано артикулов', SQLText) FROM OPENROWSET(BULK N'E:\OT38ElitServer\Log\test2.log', SINGLE_CLOB) AS Document(SQLText)
SELECT  CHARINDEX(' ', SQLText, 404 + 62) FROM OPENROWSET(BULK N'E:\OT38ElitServer\Log\test2.log', SINGLE_CLOB) AS Document(SQLText)
SELECT  SUBSTRING (SQLText, 404 + 61 , 5) FROM OPENROWSET(BULK N'E:\OT38ElitServer\Log\test2.log', SINGLE_CLOB) AS Document(SQLText)
SELECT  len('Программирование товаров завершено, экспортировано артикулов')


EXECUTE AS LOGIN = 'CONST\pashkovv';
REVERT 


--SELECT CHARINDEX('Программирование товаров завершено, экспортировано артикулов', SQLText) FROM OPENROWSET(BULK @File, SINGLE_CLOB) AS Document(SQLText)

--DECLARE @result int
--DECLARE @File nvarchar(max)= N'\\10.1.0.164\GMSServer\LogsScale\SCALEID_63_' + CONVERT(varchar(10), GETDATE(), 112) + '.log'
--SELECT @File = '\\10.1.0.164\GMSServer\LogsScale\SCALEID_63_20171022.log'
--DECLARE @SQL nvarchar(4000)--SET @SQL = N'SELECT CHARINDEX(''Программирование товаров завершено, экспортировано артикулов'', SQLText) FROM OPENROWSET(BULK ''' + @File + ''', SINGLE_CLOB) AS Document(SQLText)'--SELECT @SQL
--EXEC @result = sp_executesql @SQL


--SELECT @result

--IF (@result = 0)
--   SELECT 'Успешно'
--ELSE
--   SELECT N'Ошибка'

--запускать процедуру в интервале времени
IF (CONVERT (time, GETDATE()) > '10:50:00' 
    AND CONVERT (time, GETDATE()) < '11:50:00')
BEGIN	DECLARE @SQLStr nvarchar(500), @Params nvarchar(500), @Pos int, @File nvarchar(max), @subject nvarchar(max)		--Лог-файл Днепра	SET @File = N'\\10.1.0.164\GMSServer\LogsScale\SCALEID_62_' + CONVERT(varchar(10), GETDATE(), 112) + '.log'    SET @subject = 'Внимание!!! Ошибка с весами Днепра. Лог-файл: ' + @File	SELECT @SQLStr = N'SELECT @Pos = CHARINDEX(''Программирование товаров завершено, экспортировано артикулов'', SQLText) FROM OPENROWSET(BULK ''' + @File + ''', SINGLE_CLOB) AS Document(SQLText)'	SELECT @Params = N'@Pos int OUTPUT'		EXECUTE sp_executesql @SQLStr, @Params,  @Pos OUTPUT	--если лог не прошел проверку то отправить письмо на почту	IF ISNULL(@Pos, 0)= 0  	BEGIN
		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'main',
		@recipients = 'pashkovv@const.dp.ua;vintagednepr2@const.dp.ua', 
		@subject = @subject,
		@body = '',  
		@body_format = 'HTML'
	END		--############################################################################################################	--Лог-файл Киева	SET @File = N'\\10.1.0.164\GMSServer\LogsScale\SCALEID_63_' + CONVERT(varchar(10), GETDATE(), 112) + '.log'    SET @subject = 'Внимание!!! Ошибка с весами Киева. Лог-файл: ' + @File	SELECT @SQLStr = N'SELECT @Pos = CHARINDEX(''Программирование товаров завершено, экспортировано артикулов'', SQLText) FROM OPENROWSET(BULK ''' + @File + ''', SINGLE_CLOB) AS Document(SQLText)'	SELECT @Params = N'@Pos int OUTPUT'		EXECUTE sp_executesql @SQLStr, @Params,  @Pos OUTPUT	--если лог не прошел проверку то отправить письмо на почту	IF ISNULL(@Pos, 0)= 0  	BEGIN
		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'main',
		@recipients = 'pashkovv@const.dp.ua;vintagednepr2@const.dp.ua', 
		@subject = @subject,
		@body = '',  
		@body_format = 'HTML'
	ENDEND


 
 
   BEGIN TRY 

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
  
 