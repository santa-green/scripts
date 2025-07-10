--3 загрузка из шаблона
--доработать чтоб смотрело на остатки
USE ElitDistr

IF OBJECT_ID (N'tempdb..#tmp', N'U') IS NOT NULL DROP TABLE #tmp
CREATE TABLE #TMP(
ProdIDMA int  null,
ProdIdNabor int  null,
QtyRet numeric(21,9) null,
ProdId int  null,
PriceShop numeric(21,9) null,
Price numeric(21,9) null,
PBGrID int null,
)
INSERT #TMP
--SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\После_обработки_наборов.xlsx' , 'select * from [Лист1$]');
SELECT ex.ProdIDMA, ex.ProdIdNabor, ex.QtyRet, ex.ProdId, ex.PriceShop, ex.Price, case when ex.PBGrID IS NULL then (SELECT top 1 p.PBGrID FROM r_Prods p where p.ProdID = ex.ProdId) else ex.PBGrID end as PBGrID_p 
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\После_обработки_наборов.xlsx' , 'select * from [Лист1$]') as ex
WHERE ProdIDMA IS NOT NULL
SELECT * FROM #TMP --where ProdIdNabor in (30986,634148)
ORDER BY 1

--подготовка для комплектации
IF OBJECT_ID ('tempdb..#komplekt', 'U') IS NOT NULL   DROP TABLE #komplekt;
CREATE TABLE #komplekt(
ProdIdNabor int  null,
ProdID1 int  null,
PPID1 int  null,
ProdID2 int  null,
PPID2 int  null,
QtySRec numeric(21,9) null,
Price numeric(21,9) null,
Price1 numeric(21,9) null,
Price_optim numeric(21,9) null,
Price2 numeric(21,9) null,
)
--    SELECT * FROM #komplekt 

--загрузка приходов во временные таблицы
IF OBJECT_ID (N'tempdb..#Rec1', N'U') IS NOT NULL DROP TABLE #Rec1
CREATE TABLE #Rec1 (ProdID int null, PPID int null, TQty numeric(21,9) null, Price numeric(21,9) null)
INSERT #Rec1
SELECT r.ProdID, r.PPID, ISNULL(TRem.TQty,0), r.Price 
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Основной товар$]') as R
LEFT JOIN (SELECT ProdID, PPID, SUM(Qty) TQty FROM t_Rem where OurID = 1 and StockID = 20 group by ProdID, PPID) TRem on TRem.ProdID = r.ProdID and TRem.PPID = r.PPID
WHERE r.ProdID IS NOT NULL and r.PPID <> 0 and r.Price  > 0
SELECT * FROM #Rec1 ORDER BY 1,2 --30916

IF OBJECT_ID (N'tempdb..#Rec2', N'U') IS NOT NULL DROP TABLE #Rec2
CREATE TABLE #Rec2 (ProdID int null, PPID int null, TQty numeric(21,9) null, Price numeric(21,9) null)
INSERT #Rec2
SELECT r.ProdID, r.PPID, ISNULL(TRem.TQty,0), r.Price 
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Мусор$]') as R
LEFT JOIN (SELECT ProdID, PPID, SUM(Qty) TQty FROM t_Rem where OurID = 1 and StockID = 20 group by ProdID, PPID) TRem on TRem.ProdID = r.ProdID and TRem.PPID = r.PPID
WHERE r.ProdID IS NOT NULL and r.PPID <> 0 and r.Price  > 0
SELECT * FROM #Rec2 ORDER BY 1,2


IF 1=1 --обновить PBGrID 
--BEGIN

--EXEC sp_rename 'r_ProdMQ', 'r_ProdMQ_tmp';

--EXEC sp_rename 'r_ProdMQ_', 'r_ProdMQ';

--update r_Prods_ set PBGrID = 67 where ProdID = 600885
--update r_Prods_ set PBGrID = 65 where ProdID = 600886
--update r_Prods_ set PBGrID = 67 where ProdID = 600888
--update r_Prods_ set PBGrID = 65 where ProdID = 600889


--EXEC sp_rename 'r_ProdMQ', 'r_ProdMQ_';

--EXEC sp_rename 'r_ProdMQ_tmp', 'r_ProdMQ';

--END



DELETE #komplekt

DECLARE @ProdID1 int,@PPID1 int,@ProdID2 int,@PPID2 int,@QtySRec numeric(21,9),@Rasch numeric (21,9)
DECLARE @ProdIDMA INT,@ProdIdNabor INT ,@QtyRet INT,@ProdId INT ,@PriceShop NUMERIC(21,9),@Price NUMERIC (21,9),@PBGrID int, @Price1 NUMERIC (21,9)
DECLARE CURSOR1 CURSOR --LOCAL FAST_FORWARD
FOR 
SELECT ProdIDMA,ProdIdNabor,QtyRet,ProdId,PriceShop,Price,PBGrID FROM #tmp WITH (NOLOCK)
--SELECT top 2 ProdIDMA,ProdIdNabor,QtyRet,ProdId,PriceShop,Price,PBGrID FROM #tmp where ProdIdNabor in (634153,634154)

OPEN CURSOR1
FETCH NEXT FROM CURSOR1 INTO @ProdIDMA,@ProdIdNabor,@QtyRet,@ProdId,@PriceShop,@Price,@PBGrID
WHILE @@FETCH_STATUS = 0
BEGIN
--0 обнуление 
	SELECT @ProdID1  = NULL,@PPID1  = NULL,@ProdID2  = NULL,@PPID2  = NULL,@QtySRec  = NULL
	
--1 ProdIdNabor = @ProdIdNabor

--2 ProdID1
	SET @ProdID1 = @ProdId
	
--3 PPID1 выбрать партию с максимальным количеством
	--SET @PPID1 = (SELECT top 1 PPID FROM #Rec1 r where ProdId = @ProdId and r.TQty >= @QtyRet ORDER BY TQty desc)
--3 PPID1 выбрать партию с минимальной ценой
	SET @PPID1 = (SELECT top 1 PPID FROM #Rec1 r where ProdId = @ProdId and r.TQty >= @QtyRet ORDER BY Price)
	
	IF @PPID1 is null 
		SET @PPID1 = (SELECT top 1 PPID FROM #Rec1 r where ProdId = @ProdId ORDER BY TQty desc)
		--   SELECT  PPID , * FROM #Rec1 r where ProdId = 26135 ORDER BY TQty desc
	
	--уменьшаем остаток
	UPDATE #Rec1
	SET TQty = TQty - @QtyRet
	WHERE ProdId = @ProdId AND PPID = @PPID1
	
--4 ProdID2 и PPID2 
	SELECT top 1 @Price1 = Price FROM #Rec1 r where r.ProdID = @ProdID1 and r.PPID = @PPID1

	--SELECT * FROM #Rec1 r where r.ProdID = 26135 and r.PPID = 1159

	SELECT top(1) @ProdID2 = r.ProdID, @PPID2 = r.PPID  FROM #Rec2 r
	JOIN r_Prods p on p.ProdID = r.ProdID and p.PBGrID = @PBGrID
	where r.Price < (@Price - @Price1) --цена меньше максимальной
		and r.TQty >= @QtyRet --остаток товара больше запрашиваемого
	ORDER BY abs(r.Price - ((@Price - @Price1)/2))/*разница между ценой прихода и оптимальной расчетной ценой*/, r.Price desc, TQty desc, PPID

	--уменьшаем остаток
	UPDATE #Rec2
	SET TQty = TQty - @QtyRet
	WHERE ProdID = @ProdID2 AND PPID = @PPID2
	
IF @PPID1 is null OR @ProdID2 is null OR @PPID2 is null --and @ProdIdNabor in ( 634001)  and 1=1 --для отладки
BEGIN
	SELECT @ProdIdNabor ProdIdNabor
	SELECT @QtyRet 'запрашиваемый остаток товара'
	SELECT @Price1 Price1 
	SELECT @ProdID1 ProdID1, @PPID1 PPID1, @ProdID2 ProdID2, @PPID2 PPID2
	
	SELECT r.ProdID ProdID2, r.PPID PPID2,abs(r.Price - ((@Price - @Price1)/2)) price_razn, (@Price - @Price1)/2 Price_optim, *  FROM #Rec2 r
	JOIN r_Prods p on p.ProdID = r.ProdID and p.PBGrID = @PBGrID
	where r.Price < (@Price - @Price1) --цена меньше максимальной
		and r.TQty >= @QtyRet --остаток товара больше запрашиваемого
	ORDER BY abs(r.Price - ((@Price - @Price1)/2))/*разница между ценой прихода и оптимальной расчетной ценой*/, r.Price desc, TQty desc, PPID
	
		SELECT r.ProdID ProdID2, r.PPID PPID2,abs(r.Price - ((@Price - @Price1)/2)) price_razn, (@Price - @Price1)/2 Price_optim, r.Price 'r.Price', (@Price - @Price1) '< @Price - @Price1',*  FROM #Rec2 r
	JOIN r_Prods p on p.ProdID = r.ProdID and p.PBGrID = @PBGrID
	--where r.Price < (@Price - @Price1) --цена меньше максимальной
	--	and r.TQty >= @QtyRet --остаток товара больше запрашиваемого
	ORDER BY abs(r.Price - ((@Price - @Price1)/2))/*разница между ценой прихода и оптимальной расчетной ценой*/, r.Price desc, TQty desc, PPID
	
	SELECT 'PPID1 выбрать партию с максимальным количеством'
	SELECT  PPID,* FROM #Rec1 r where ProdId = @ProdId and r.TQty >= @QtyRet ORDER BY Price--TQty desc
END

--5 @QtySRec = @QtyRet
	SET @QtySRec = @QtyRet
	
	/* для отладки
	SELECT * FROM #Rec2 where ProdID = 30767 and PPID = 240
	
	update  #Rec2  set Price = 25.071031747000
	where ProdID = 30767 and PPID = 240
	*/
	
	INSERT #komplekt
	SELECT @ProdIdNabor ProdIdNabor,@ProdID1 ProdID1,@PPID1 PPID1,@ProdID2 ProdID2,@PPID2 PPID2,@QtySRec QtySRec,@Price Price,@Price1 Price1,
	  (@Price - @Price1)/2  Price_optim, (SELECT top 1 Price FROM #Rec2 r where r.ProdID = @ProdID2 and r.PPID = @PPID2) Price2
	  --abs( isnull((SELECT top 1 Price FROM #Rec2 r where r.ProdID = @ProdID1 and r.PPID = @PPID1),0)  - ((@Price - @Price1)/2) ) Price_optim
        
	FETCH NEXT FROM CURSOR1 INTO @ProdIDMA,@ProdIdNabor,@QtyRet,@ProdId,@PriceShop,@Price,@PBGrID
END

CLOSE CURSOR1
DEALLOCATE CURSOR1

SELECT * FROM #komplekt 

--очистить шаблон комплектации
UPDATE OPENQUERY (EXCEL_ED3, 'select * from [Лист1$]') 
SET [ProdIdNabor] = 'DEL',[ProdID1] = 'DEL',[PPID1] = 'DEL',[ProdID2] = 'DEL',[PPID2] = 'DEL',[QtySRec] = 'DEL'


INSERT OPENQUERY (EXCEL_ED3,'select * from [Лист1$]')
	SELECT ProdIdNabor,ProdID1,PPID1,ProdID2,PPID2,QtySRec 
	FROM #komplekt 

SELECT * FROM  OPENQUERY (EXCEL_ED3,'select * from [Лист1$] WHERE ProdIdNabor <> ''DEL'' ')
ORDER BY 1

/*

UPDATE OPENQUERY (EXCEL_ED3, 'select * from [Лист1$]') 
SET [ProdIdNabor] = null,[ProdID1] = null,[PPID1] = null,[ProdID2] = null,[PPID2] = null,[QtySRec] = null


INSERT OPENQUERY (EXCEL_ED3,'select * from [Лист1$]')
VALUES (1111,22,3,4,5,6)

INSERT OPENQUERY (EXCEL_ED3,'select * from [Лист1$]')
VALUES (9900099,null,null,null,null,null)

*/
--DELETE OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1;  Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Шаблон_комплектации.xlsx' , 'select * from [Лист1$]')

--INSERT OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; ReadOnly=0; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Шаблон_комплектации.xlsx' , 'select * from [Лист1$]')
--SELECT ProdIdNabor,ProdID1,PPID1,ProdID2,PPID2,QtySRec FROM #komplekt 

--SELECT * FROM  OPENQUERY (EXCEL_ED3,'select * from [Лист1$]')

--DELETE OPENQUERY (EXCEL_ED3,'select * from [Лист1$]')

/*
SELECT *, (SELECT top 1 ProdId FROM r_ProdEC where CompID = 10793 and ExtProdID = #TMP.ProdIDMA) new FROM #TMP
where ProdId <> (SELECT top 1 ProdId FROM r_ProdEC where CompID = 10793 and ExtProdID = #TMP.ProdIDMA)

SELECT * FROM r_ProdEC where ProdID = 32542 and CompID = 10793
SELECT * FROM r_ProdEC where cast(ExtProdID as int ) = 800165 and CompID = 10793
*/	


/*Удалить возвраты
SELECT * FROM t_Ret
WHERE DocDate = '2018-02-01'
ORDER BY DocDate desc

delete  t_Ret
WHERE DocDate = '2018-02-01'
*/


--SELECT * FROM #Rec1 r where ProdId = 31389 and r.TQty >= @QtyRet ORDER BY Price