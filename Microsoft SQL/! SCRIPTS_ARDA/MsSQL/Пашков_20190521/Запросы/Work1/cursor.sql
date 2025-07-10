USE OtdataM7

SET NOCOUNT ON

DECLARE @OldProdID INT, @NewProdID INT, @I INT, @X INT, @START INT, @END INT
SET  @START = 258464
SET  @END = 258480

WHILE @START <= @END
BEGIN 
SET @OldProdID = @START
SET @NewProdID = @START -232615

--PRINT 'перенос данных во временные таблицы'
--PRINT 'входящие остатки'
SELECT IDENTITY (INT,1,1) NUM, ChID, OurID, StockID, @NewProdID AS ProdID, PPID, SecID, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, KursMC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Notes
INTO _Temp_t_zInP
FROM t_zInP
WHERE ProdID = @OldProdID

--PRINT 'приход в магазин'
SELECT IDENTITY (INT,1,1) AS NUM, ChID, SrcPosID, @NewProdID AS ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, CostSum, CostCC, Extra, PriceCC, BarCode, SecID
INTO _Temp_t_RecD
FROM t_RecD
WHERE ProdID = @OldProdID

--PRINT 'возврат в магазин'
SELECT IDENTITY (INT,1,1) AS NUM, ChID, SrcPosID, @NewProdID AS ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxID, SecID
INTO _Temp_t_CRRetD
FROM t_CRRetD
WHERE ProdID = @OldProdID

--PRINT 'расход магазина'
SELECT IDENTITY (INT,1,1) AS NUM, ChID, SrcPosID, @NewProdID AS ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
INTO _Temp_t_ExpD
FROM t_ExpD
WHERE ProdID = @OldProdID

--PRINT 'продажа товара'
SELECT IDENTITY (INT,1,1) AS NUM, ChID, SrcPosID, @NewProdID AS ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxID, SecID
INTO _Temp_t_SaleC
FROM t_SaleC
WHERE ProdID = @OldProdID

SELECT IDENTITY (INT,1,1) AS NUM, ChID, SrcPosID, @NewProdID AS ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxID, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID
INTO _Temp_t_SaleD
FROM t_SaleD
WHERE ProdID = @OldProdID

--PRINT 'продажа через торговый сервер'
SELECT IDENTITY (INT,1,1) AS NUM, ChID, SrcPosID, @NewProdID AS ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxID, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID
INTO _Temp_t_CRSaleD
FROM t_CRSaleD
WHERE ProdID = @OldProdID

--PRINT 'расход в ЦП'
SELECT IDENTITY (INT,1,1) AS NUM, ChID, SrcPosID, @NewProdID AS ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
INTO _Temp_t_EppD
FROM t_EppD
WHERE ProdID = @OldProdID

--PRINT 'возврат поставщику'
SELECT IDENTITY (INT,1,1) AS NUM, ChID, SrcPosID, @NewProdID AS ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
INTO _Temp_t_CRetD
FROM t_CRetD
WHERE ProdID = @OldProdID

--PRINT 'перемещение в магазине'
SELECT IDENTITY (INT,1,1) AS NUM, ChID, SrcPosID, @NewProdID AS ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, NewSecID
INTO _Temp_t_ExcD
FROM t_ExcD
WHERE ProdID = @OldProdID

--PRINT 'инвентаризация магазина'
SELECT IDENTITY (INT,1,1) AS NUM, ChID, @NewProdID AS DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt, PriceCC_wt, Tax, TaxSum, SumCC_nt, SumCC_wt, NewQty, NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID
INTO _Temp_t_VenD
FROM t_VenD
WHERE DetProdID = @OldProdID

SELECT IDENTITY (INT,1,1) AS NUM, ChID, @NewProdID AS ProdID, UM, TQty, TNewQty, TSumCC_nt, TTaxSum, TSumCC_wt, TNewSumCC_nt, TNewTaxSum, TNewSumCC_wt, BarCode, Norma1, TSrcPosID
INTO _Temp_t_VenA
FROM t_VenA
WHERE ProdID = @OldProdID

--PRINT 'кассовый ордер расхода (приход)'
SELECT IDENTITY (INT,1,1) AS NUM, p.ChID, p.SrcPosID, p.PChID, p.PaySumCC
INTO _Temp_t_RecPO
FROM t_RecD r
INNER JOIN t_RecPO p ON r.CHID=p.CHID AND r.SrcPosID=p.SrcPosID
WHERE r.ProdID = @OldProdID

--PRINT 'кассовый ордер расхода (возврат)'
SELECT IDENTITY (INT,1,1) AS NUM, p.ChID, p.SrcPosID, p.PChID, p.PaySumCC
INTO _Temp_t_RecPR
FROM t_RecD r
INNER JOIN t_RecPR p ON r.CHID=p.CHID AND r.SrcPosID=p.SrcPosID
WHERE r.ProdID = @OldProdID

--PRINT 'справочник товаров'
SELECT @NewProdID AS ChID, @NewProdID AS ProdID, ProdName, UM, Country, Notes, PCatID, PGrID, Article1, Article2, Article3, Weight, Age, TaxPercent, PriceWithTax, Note1, Note2, Note3, MinPriceMC, MaxPriceMC, MinRem, CstDty, CstPrc, CstExc, StdExtraR, StdExtraE, MaxExtra, MinExtra, UseAlts, UseCrts, PGrID1, PGrID2, PGrID3, PGrAID, PBGrID, RExpSet, EExpSet, InRems, IsDecQty, File1, File2, File3, AutoSet, Extra1, Extra2, Extra3, Extra4, Extra5, Norma1, Norma2, Norma3, Norma4, Norma5, RecMinPriceCC, RecMaxPriceCC, RecStdPriceCC, RecRemQty, InStopList
INTO _Temp_r_Prods
FROM r_Prods
WHERE ProdID = @OldProdID

SELECT @NewProdID AS ProdID, UM, Qty, Weight, Notes, BarCode, ProdBarCode, PLID
INTO _Temp_r_ProdMQ
FROM r_ProdMQ
WHERE ProdID = @OldProdID

SELECT @NewProdID AS ProdID, PLID, PriceMC, Notes, CurrID
INTO _Temp_r_ProdMP
FROM r_ProdMP
WHERE ProdID = @OldProdID

--PRINT 'справочник партий'
SELECT @NewProdID AS ProdID, PPID, PPDesc, PriceMC_In, PriceMC, Priority, ProdDate, CurrID, CompID, Article, CostAC, PPWeight, File1, File2, File3, PriceCC_In, CostCC, PPDelay, ProdPPDate
INTO _Temp_t_PInP
FROM t_PInP
WHERE ProdID = @OldProdID

--PRINT 'удаление данных из документов'
--PRINT 'кассовый ордер расхода (приход)'
DECLARE Delete_t_RecPO CURSOR
FOR SELECT *
FROM t_RecPO
INNER JOIN _Temp_t_RecPO ON t_RecPO.CHID=_Temp_t_RecPO.CHID AND t_RecPO.SrcPosID=_Temp_t_RecPO.SrcPosID
OPEN Delete_t_RecPO
FETCH NEXT FROM Delete_t_RecPO
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_RecPO
WHERE CURRENT OF Delete_t_RecPO
FETCH NEXT FROM Delete_t_RecPO
END
CLOSE Delete_t_RecPO
DEALLOCATE Delete_t_RecPO

--PRINT 'кассовый ордер расхода (возврат)'
DECLARE Delete_t_RecPR CURSOR
FOR SELECT *
FROM t_RecPR
INNER JOIN _Temp_t_RecPR ON t_RecPR.CHID=_Temp_t_RecPR.CHID AND t_RecPR.SrcPosID=_Temp_t_RecPR.SrcPosID
OPEN Delete_t_RecPR
FETCH NEXT FROM Delete_t_RecPR
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_RecPR
WHERE CURRENT OF Delete_t_RecPR
FETCH NEXT FROM Delete_t_RecPR
END
CLOSE Delete_t_RecPR
DEALLOCATE Delete_t_RecPR

--PRINT 'входящие остатки'
DECLARE Delete_t_zInP CURSOR
FOR SELECT *
FROM t_zInP
WHERE ProdID = @OldProdID
OPEN Delete_t_zInP
FETCH NEXT FROM Delete_t_zInP
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_zInP
WHERE CURRENT OF Delete_t_zInP
FETCH NEXT FROM Delete_t_zInP
END
CLOSE Delete_t_zInP
DEALLOCATE Delete_t_zInP

--PRINT 'приход в магазин'
DECLARE Delete_t_RecD CURSOR
FOR SELECT *
FROM t_RecD
WHERE ProdID = @OldProdID
OPEN Delete_t_RecD
FETCH NEXT FROM Delete_t_RecD
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_RecD
WHERE CURRENT OF Delete_t_RecD
FETCH NEXT FROM Delete_t_RecD
END
CLOSE Delete_t_RecD
DEALLOCATE Delete_t_RecD

--PRINT 'возврат в магазин'
DECLARE Delete_t_CRRetD CURSOR
FOR SELECT *
FROM t_CRRetD
WHERE ProdID = @OldProdID
OPEN Delete_t_CRRetD
FETCH NEXT FROM Delete_t_CRRetD
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_CRRetD
WHERE CURRENT OF Delete_t_CRRetD
FETCH NEXT FROM Delete_t_CRRetD
END
CLOSE Delete_t_CRRetD
DEALLOCATE Delete_t_CRRetD

--PRINT 'расход магазина'
DECLARE Delete_t_ExpD CURSOR
FOR SELECT *
FROM t_ExpD
WHERE ProdID = @OldProdID
OPEN Delete_t_ExpD
FETCH NEXT FROM Delete_t_ExpD
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_ExpD
WHERE CURRENT OF Delete_t_ExpD
FETCH NEXT FROM Delete_t_ExpD
END
CLOSE Delete_t_ExpD
DEALLOCATE Delete_t_ExpD

--PRINT 'продажа товара'
DECLARE Delete_t_SaleC CURSOR
FOR SELECT *
FROM t_SaleC
WHERE ProdID = @OldProdID
OPEN Delete_t_SaleC
FETCH NEXT FROM Delete_t_SaleC
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_SaleC
WHERE CURRENT OF Delete_t_SaleC
FETCH NEXT FROM Delete_t_SaleC
END
CLOSE Delete_t_SaleC
DEALLOCATE Delete_t_SaleC

DECLARE Delete_t_SaleD CURSOR
FOR SELECT *
FROM t_SaleD
WHERE ProdID = @OldProdID
OPEN Delete_t_SaleD
FETCH NEXT FROM Delete_t_SaleD
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_SaleD
WHERE CURRENT OF Delete_t_SaleD
FETCH NEXT FROM Delete_t_SaleD
END
CLOSE Delete_t_SaleD
DEALLOCATE Delete_t_SaleD

--PRINT 'продажа через торговый сервер'
DECLARE Delete_t_CRSaleD CURSOR
FOR SELECT *
FROM t_CRSaleD
WHERE ProdID = @OldProdID
OPEN Delete_t_CRSaleD
FETCH NEXT FROM Delete_t_CRSaleD
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_CRSaleD
WHERE CURRENT OF Delete_t_CRSaleD
FETCH NEXT FROM Delete_t_CRSaleD
END
CLOSE Delete_t_CRSaleD
DEALLOCATE Delete_t_CRSaleD

--PRINT 'расход в ЦП'
DECLARE Delete_t_EppD CURSOR
FOR SELECT *
FROM t_EppD
WHERE ProdID = @OldProdID
OPEN Delete_t_EppD
FETCH NEXT FROM Delete_t_EppD
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_EppD
WHERE CURRENT OF Delete_t_EppD
FETCH NEXT FROM Delete_t_EppD
END
CLOSE Delete_t_EppD
DEALLOCATE Delete_t_EppD

--PRINT 'возврат поставщику'
DECLARE Delete_t_CRetD CURSOR
FOR SELECT *
FROM t_CRetD
WHERE ProdID = @OldProdID
OPEN Delete_t_CRetD
FETCH NEXT FROM Delete_t_CRetD
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_CRetD
WHERE CURRENT OF Delete_t_CRetD
FETCH NEXT FROM Delete_t_CRetD
END
CLOSE Delete_t_CRetD
DEALLOCATE Delete_t_CRetD

--PRINT 'перемещение в магазине'
DECLARE Delete_t_ExcD CURSOR
FOR SELECT *
FROM t_ExcD
WHERE ProdID = @OldProdID
OPEN Delete_t_ExcD
FETCH NEXT FROM Delete_t_ExcD
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_ExcD
WHERE CURRENT OF Delete_t_ExcD
FETCH NEXT FROM Delete_t_ExcD
END
CLOSE Delete_t_ExcD
DEALLOCATE Delete_t_ExcD

--PRINT 'инвентаризация магазина'
DECLARE Delete_t_VenD CURSOR
FOR SELECT *
FROM t_VenD
WHERE DetProdID = @OldProdID
OPEN Delete_t_VenD
FETCH NEXT FROM Delete_t_VenD
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_VenD
WHERE CURRENT OF Delete_t_VenD
FETCH NEXT FROM Delete_t_VenD
END
CLOSE Delete_t_VenD
DEALLOCATE Delete_t_VenD

DECLARE Delete_t_VenA CURSOR
FOR SELECT *
FROM t_VenA
WHERE ProdID = @OldProdID
OPEN Delete_t_VenA
FETCH NEXT FROM Delete_t_VenA
WHILE @@Fetch_Status = 0
BEGIN
DELETE FROM t_VenA
WHERE CURRENT OF Delete_t_VenA
FETCH NEXT FROM Delete_t_VenA
END
CLOSE Delete_t_VenA
DEALLOCATE Delete_t_VenA

--PRINT 'обновление старого названия'
UPDATE r_Prods
SET ProdName = CONVERT (VARCHAR, ProdID) + '_' + ProdName
WHERE ProdID = @OldProdID

--PRINT 'обновление старого сканкода'
DECLARE Update_BarCode CURSOR FOR
SELECT ProdID
FROM r_ProdMQ
WHERE ProdID = @OldProdID
FOR UPDATE OF BarCode
OPEN Update_BarCode
FETCH NEXT FROM Update_BarCode
WHILE @@Fetch_Status = 0
BEGIN
UPDATE r_ProdMQ
SET BarCode = CONVERT (VARCHAR, ProdID) + '__' + UM
WHERE CURRENT OF Update_BarCode
FETCH NEXT FROM Update_BarCode
END
CLOSE Update_BarCode
DEALLOCATE Update_BarCode

--PRINT 'создание новой карточки'
INSERT INTO r_Prods
SELECT *
FROM _Temp_r_Prods

INSERT INTO r_Prods_R
SELECT ProdID
FROM _Temp_r_Prods

INSERT INTO r_ProdMQ
SELECT *
FROM _Temp_r_ProdMQ

INSERT INTO r_ProdMP
SELECT *
FROM _Temp_r_ProdMP

--PRINT 'перенос партий'
INSERT INTO t_PInP
SELECT *
FROM _Temp_t_PInP

INSERT INTO t_PInP_T
SELECT ProdID, PPID
FROM _Temp_t_PInP

--PRINT 'заполнение документов'
--PRINT 'входящие остатки'
SELECT @I = MAX (NUM)
FROM _Temp_t_zInP
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_zInP 
SELECT ChID, OurID, StockID, ProdID, PPID, SecID, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, KursMC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Notes
FROM _Temp_t_zInP
WHERE _Temp_t_zInP.NUM = @X
SET @X = @X+1
END

--PRINT 'приход в магазин'
SELECT @I = MAX (NUM)
FROM _Temp_t_RecD
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_RecD 
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, CostSum, CostCC, Extra, PriceCC, BarCode, SecID
FROM _Temp_t_RecD
WHERE _Temp_t_RecD.NUM = @X
SET @X = @X+1
END

--PRINT 'возврат в магазин'
SELECT @I = MAX (NUM)
FROM _Temp_t_CRRetD
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_CRRetD
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxID, SecID
FROM _Temp_t_CRRetD
WHERE _Temp_t_CRRetD.NUM = @X
SET @X = @X+1
END

--PRINT 'расход магазина'
SELECT @I = MAX (NUM)
FROM _Temp_t_ExpD
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_ExpD 
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
FROM _Temp_t_ExpD
WHERE _Temp_t_ExpD.NUM = @X
SET @X = @X+1
END

--PRINT 'продажа товара'
SELECT @I = MAX (NUM)
FROM _Temp_t_SaleD
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_SaleD 
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxID, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID
FROM _Temp_t_SaleD
WHERE _Temp_t_SaleD.NUM = @X
SET @X = @X+1
END

SELECT @I = MAX (NUM)
FROM _Temp_t_SaleC
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_SaleC 
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxID, SecID
FROM _Temp_t_SaleC
WHERE _Temp_t_SaleC.NUM = @X
SET @X = @X+1
END

/*--PRINT 'продажа через торговый сервер'
SELECT @I = MAX (NUM)
FROM _Temp_t_CRSaleD
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_CRSaleD 
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxID, SecID, SaleTime, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID
FROM _Temp_t_CRSaleD
WHERE _Temp_t_CRSaleD.NUM = @X
SET @X = @X+1
END*/

--PRINT 'расход в ЦП'
SELECT @I = MAX (NUM)
FROM _Temp_t_EppD
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_EppD 
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
FROM _Temp_t_EppD
WHERE _Temp_t_EppD.NUM = @X
SET @X = @X+1
END

--PRINT 'возврат поставщику'
SELECT @I = MAX (NUM)
FROM _Temp_t_CRetD
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_CRetD 
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
FROM _Temp_t_CRetD
WHERE _Temp_t_CRetD.NUM = @X
SET @X = @X+1
END

--PRINT 'перемещение в магазине'
SELECT @I = MAX (NUM)
FROM _Temp_t_ExcD
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_ExcD 
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, NewSecID
FROM _Temp_t_ExcD
WHERE _Temp_t_ExcD.NUM = @X
SET @X = @X+1
END

--PRINT 'инвентаризация магазина'
SELECT @I = MAX (NUM)
FROM _Temp_t_VenA
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_VenA 
SELECT ChID, ProdID, UM, TQty, TNewQty, TSumCC_nt, TTaxSum, TSumCC_wt, TNewSumCC_nt, TNewTaxSum, TNewSumCC_wt, BarCode, Norma1, TSrcPosID
FROM _Temp_t_VenA
WHERE _Temp_t_VenA.NUM = @X
SET @X = @X+1
END

SELECT @I = MAX (NUM)
FROM _Temp_t_VenD
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_VenD 
SELECT ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt, PriceCC_wt, Tax, TaxSum, SumCC_nt, SumCC_wt, NewQty, NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID
FROM _Temp_t_VenD
WHERE _Temp_t_VenD.NUM = @X
SET @X = @X+1
END

--PRINT 'кассовый ордер расхода (приход)'
SELECT @I = MAX (NUM)
FROM _Temp_t_RecPO
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_RecPO
SELECT ChID, SrcPosID, PChID, PaySumCC
FROM _Temp_t_RecPO
WHERE _Temp_t_RecPO.NUM = @X
SET @X = @X+1
END

--PRINT 'кассовый ордер расхода (возврат)'
SELECT @I = MAX (NUM)
FROM _Temp_t_RecPR
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO t_RecPR
SELECT ChID, SrcPosID, PChID, PaySumCC
FROM _Temp_t_RecPR
WHERE _Temp_t_RecPR.NUM = @X
SET @X = @X+1
END

DROP TABLE _Temp_t_zInP
DROP TABLE _Temp_t_RecD
DROP TABLE _Temp_t_RecPO
DROP TABLE _Temp_t_RecPR
DROP TABLE _Temp_t_CRRetD
DROP TABLE _Temp_t_ExpD
DROP TABLE _Temp_t_SaleC
DROP TABLE _Temp_t_SaleD
DROP TABLE _Temp_t_CRSaleD
DROP TABLE _Temp_t_EppD
DROP TABLE _Temp_t_CRetD
DROP TABLE _Temp_t_ExcD
DROP TABLE _Temp_t_VenD
DROP TABLE _Temp_t_VenA
DROP TABLE _Temp_r_Prods
DROP TABLE _Temp_r_ProdMQ
DROP TABLE _Temp_r_ProdMP
DROP TABLE _Temp_t_PInP

PRINT @START
SET @START = @START + 1
END
