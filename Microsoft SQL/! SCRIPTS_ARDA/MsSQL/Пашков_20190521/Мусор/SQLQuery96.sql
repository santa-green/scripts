IF OBJECT_ID (N'tempdb..#tmp', N'U') IS NOT NULL DROP TABLE #tmp
--SELECT  * into #tmp FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; HDR=No; readonly=true; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\После_обработки_наборов.xlsx' , 'select * from [Лист1$]');
SELECT  * into #tmp FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; Mode=Read; ReadOnly=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\После_обработки_наборов.xlsx' , 'select * from [Лист1$]');
--SELECT  * into #tmp FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Mode=Read;Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\После_обработки_наборов.xlsx' , 'select * from [Лист1$]');
--select top 1 * from #tmp
select * from #tmp

SELECT  * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\После_обработки_наборов.xlsx' , 'select * from [Лист1$]');
SELECT  * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\После_обработки_наборов.xlsx' , 'select 1 as test');

SELECT  * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', ' Database=\\s-sql-d4\OT38ElitServer\Import\base_Arda.accdb' , 'SELECT 1');
--SELECT  * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', ' Data Source=\\s-sql-d4\OT38ElitServer\Import\base_Arda.accdb; Persist Security Info=False;' , 'SELECT 1');
SELECT  * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Access 12.0; DataSource=\\s-sql-d4\OT38ElitServer\Import\base_Arda.accdb' , 'SELECT 1');


SELECT * FROM OPENQUERY([S-ELIT-DP\TK],'SELECT name, database_id, create_date FROM sys.databases ')

SELECT * from openquery(EXCEL_ED2,'select * from [Лист1$]')

INSERT OPENQUERY (EXCEL_ED2,'select * from [Лист1$]')
--VALUES (1,2,3,7,5,6,7);
VALUES (111);