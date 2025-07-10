--импорт из xml файла
DECLARE @xml XML
SET @xml = ( SELECT * FROM OPENROWSET (BULK '\\s-sql-d4\OT38ElitServer\Import\XML\dfs\28010037029549J1201009100000170010420182801.XML ', SINGLE_CLOB) AS xml )

--INSERT at_SendXML (xml)
select @xml xml

SELECT * FROM at_SendXML

SET @xml = ( SELECT top 1  xml FROM  dbo.at_SendXML where id = 3 )

SELECT 
T.c.value('@TAB', 'varchar(max)') AS TAB  
,T.c.value('@LINE', 'varchar(max)') AS LINE  
,T.c.value('@NAME', 'varchar(max)') AS NAME  
,T.c.value('VALUE[1]', 'varchar(max)') AS VALUE  
 --INTO NOTARIUS 
FROM   @xml.nodes('/CARD/DOCUMENT/ROW') T(c)
ORDER BY 1,2

--DECLARE @SQL_query nvarchar(max) = 'SET NOCOUNT ON; SELECT top 1  cast(xml as varchar(4000)) FROM  Elit_TEST_LOG.dbo.at_SendXML where id = 2; SET NOCOUNT OFF;'
--	EXEC msdb.dbo.sp_send_dbmail  
--	@profile_name = 'main',  
--	@recipients = 'pashkovv@const.dp.ua',  
--	@body = '',  
--	@subject = 'Тема',
--	@body_format = 'HTML', 
--	@query = @SQL_query,
--	@query_result_header=0,
--	@exclude_query_output=1,
--	@attach_query_result_as_file= 1
--	;


SELECT ChID, COUNT(ChID) FROM t_Invd
group by ChID
ORDER BY 2 desc


SELECT * FROM t_Inv
WHERE ChiD in (200003990,101543765,200020531,200022784,200007003,200008356,101401335,101315360,101321735,200004020,200100352)
ORDER BY 1