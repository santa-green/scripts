--перенос продаж кассы c ElitR
USE ElitR

IF OBJECT_ID (N'tempdb..#P', N'U') IS NOT NULL DROP TABLE #P
CREATE TABLE #P (CRID int, DocDate SMALLDATETIME, LocalServerName varchar(250))
INSERT #P 
SELECT 181 CRID --номер кассы
	,'20190411' DocDate  --конец периода поиска по продажам в ElitR
	,'[s-marketa4].ElitRTS181.dbo.' LocalServerName  --путь к локальному серверу ElitR
SELECT * FROM #P 


SELECT * 
, (select TableName from z_Tables s WHERE s.TableCode= z.TableCode) 
, (select Tabledesc from z_Tables s WHERE s.TableCode= z.TableCode) 
FROM z_ReplicaTables z where ReplicaPubCode in (1200000000)
ORDER BY 2

SELECT * FROM r_CRs where CRID in (SELECT CRID FROM #P)

SELECT * FROM t_zRep where  CRID in (SELECT CRID FROM #P) ORDER BY DocDate desc
SELECT * FROM t_zRep where DocDate in (SELECT DocDate FROM #P) and CRID in (SELECT CRID FROM #P)



SELECT * FROM t_Sale where DocDate in (SELECT DocDate FROM #P) and CRID in (SELECT CRID FROM #P)

