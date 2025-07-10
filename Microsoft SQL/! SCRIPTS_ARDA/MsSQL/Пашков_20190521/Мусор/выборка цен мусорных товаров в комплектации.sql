--выборка цен мусорных товаров в комплектации 

IF OBJECT_ID ('tempdb..#komplekt', 'U') IS NOT NULL   DROP TABLE #komplekt;

CREATE TABLE #komplekt(
ProdID int not null,
ProdID1 int not null,
PPID1 int not null,
ProdID2 int not null,
PPID2 int not null,
Qty numeric(21,9) null,

)

insert #komplekt
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Шаблон_комплектации.xlsx' , 'select * from [Комплектация$]');

SELECT * FROM  #komplekt

SELECT k.* ,t.price FROM #komplekt k
join #TMP t on t.prodid = k.ProdID2 and t.ppid = k.PPID2
ORDER BY 1



IF OBJECT_ID (N'tempdb..#tmp', N'U') IS NOT NULL DROP TABLE #tmp
CREATE TABLE #tmp (ProdID int null, PPID int null, Qty numeric(21,9) null, Price numeric(21,9) null)
--create table #tmp (ProdID int null, PPID int null)
--SELECT * FROM #tmp
--SELECT distinct * FROM #tmp

--загрузка из шаблона
INSERT #tmp
SELECT ProdID, PPID, Qty, Price 
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Основной товар$]');
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Мусор$]');
SELECT * FROM #TMP