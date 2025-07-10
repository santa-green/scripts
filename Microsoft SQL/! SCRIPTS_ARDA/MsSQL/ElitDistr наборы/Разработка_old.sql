-- поиск РН по которым можно вернуть товар
USE ElitR
--блок загрузки справочников
IF 1=0
BEGIN 
	IF OBJECT_ID (N'tempdb..#TempRet', N'U') IS NOT NULL DROP TABLE #TempRet
	CREATE TABLE #TempRet ( N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdIDMA_RealPrice NUMERIC(21,9), ChID INT, DocID INT, TaxDocID INT, TaxDocDate SMALLDATETIME, ProdID INT, PPID INT, QtyInv NUMERIC(21,9), vozv_Elit NUMERIC(21,9), vozv_ElitDistr NUMERIC(21,9), QtyRet NUMERIC(21,9), rem NUMERIC(21,9), abs_razn NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, SrcPosID_Inv INT, Pos_Medoc INT, sumQtyInv INT)
	
	IF OBJECT_ID (N'tempdb..#TempRetFinal', N'U') IS NOT NULL DROP TABLE #TempRetFinal
	CREATE TABLE #TempRetFinal ( N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdIDMA_RealPrice NUMERIC(21,9), ChID INT, DocID INT, TaxDocID INT, TaxDocDate SMALLDATETIME, ProdID INT, PPID INT, QtyInv NUMERIC(21,9), vozv_Elit NUMERIC(21,9), vozv_ElitDistr NUMERIC(21,9), QtyRet NUMERIC(21,9), rem NUMERIC(21,9), abs_razn NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, SrcPosID_Inv INT, Pos_Medoc INT, sumQtyInv INT)

	IF OBJECT_ID (N'tempdb..#TempFindProdElit', N'U') IS NOT NULL DROP TABLE #TempFindProdElit
	CREATE TABLE #TempFindProdElit (N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdID_Elit INT, DNN SMALLDATETIME, NNN INT, ProdName VARCHAR(250), UM VARCHAR(50), Pos INT, TQty NUMERIC(21,9), Price NUMERIC(21,9), SumCC NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, rating INT )

	IF OBJECT_ID (N'tempdb..#TempFindProdElitAll', N'U') IS NOT NULL DROP TABLE #TempFindProdElitAll
	CREATE TABLE #TempFindProdElitAll (N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdID_Elit INT, DNN SMALLDATETIME, NNN INT, ProdName VARCHAR(250), UM VARCHAR(50), Pos INT, TQty NUMERIC(21,9), Price NUMERIC(21,9), SumCC NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, rating INT )

	IF OBJECT_ID (N'tempdb..#TempFindProdElitAll_tmp', N'U') IS NOT NULL DROP TABLE #TempFindProdElitAll_tmp
	CREATE TABLE #TempFindProdElitAll_tmp (N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdID_Elit INT, DNN SMALLDATETIME, NNN INT, ProdName VARCHAR(250), UM VARCHAR(50), Pos INT, TQty NUMERIC(21,9), Price NUMERIC(21,9), SumCC NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, rating INT )

	--загружаем справочник по наборам
	IF OBJECT_ID (N'tempdb..#ProdIdNabor', N'U') IS NOT NULL DROP TABLE #ProdIdNabor
	CREATE TABLE #ProdIdNabor(ProdIDMA int null, ProdID int null, ProdIdNabor int null, ProdName varchar(250))
	INSERT #ProdIdNabor
		SELECT distinct * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Справочник_наборов.xlsx' , 'select * from [Лист1$]') as ex;
	SELECT * FROM #ProdIdNabor
	
	--загрузка приходов во временные таблицы
	IF OBJECT_ID (N'tempdb..#Rec1', N'U') IS NOT NULL DROP TABLE #Rec1
	CREATE TABLE #Rec1 (ProdID int null, PPID int null, TQty numeric(21,9) null, Price numeric(21,9) null)
	INSERT #Rec1
	SELECT r.ProdID, r.PPID, ISNULL(TRem.TQty,0), r.Price 
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\import_t_Rec-ElitDistr.xlsx' , 'select * from [Основной товар$]') as R
	LEFT JOIN (SELECT ProdID, PPID, SUM(Qty) TQty FROM ElitDistr.dbo.t_Rem where OurID = 1 and StockID = 20 group by ProdID, PPID) TRem on TRem.ProdID = r.ProdID and TRem.PPID = r.PPID
	WHERE r.ProdID IS NOT NULL and r.PPID <> 0 and r.Price  > 0
	--SELECT distinct ProdID FROM #Rec1 ORDER BY 1,2 --30916
	--SELECT * FROM #Rec1 where ProdID in (31970,32465,33436) ORDER BY 1

/*
	--загружаем справочник с медка реестр налоговых накладных
	IF OBJECT_ID (N'at_t_Medoc', N'U') IS NOT NULL DROP TABLE at_t_Medoc
	SELECT * 
	 INTO at_t_Medoc	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок.xlsx' , 'select * from [Лист1$]') as ex;
	--SELECT * FROM at_t_Medoc
	
	--загружаем справочник с медка по возвратам
	IF OBJECT_ID (N'at_t_Medoc_RET', N'U') IS NOT NULL DROP TABLE at_t_Medoc_RET
	SELECT * 
	 INTO at_t_Medoc_RET	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_Возвраты.xlsx' , 'select * from [Лист1$]') as ex;
    --SELECT * FROM at_t_Medoc_RET
*/	
	--загружаем справочник с медка реестр налоговых накладных
	IF OBJECT_ID (N'tempdb..#Medoc', N'U') IS NOT NULL DROP TABLE #Medoc
	SELECT * 
	 INTO #Medoc	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок.xlsx' , 'select * from [Лист1$]') as ex;
	--SELECT * FROM #Medoc
	
	--загружаем справочник с медка по возвратам
	IF OBJECT_ID (N'tempdb..#Medoc_RET', N'U') IS NOT NULL DROP TABLE #Medoc_RET
	SELECT * 
	 INTO #Medoc_RET	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_Возвраты.xlsx' , 'select * from [Лист1$]') as ex;
    --SELECT * FROM #Medoc_RET

	--таблица исключений РН
	--  IF OBJECT_ID (N'tempdb..#NotInv', N'U') IS NOT NULL DROP TABLE #NotInv
	--	CREATE TABLE #NotInv (Num INT IDENTITY(1,1) NOT NULL ,TaxDocID INT null, TaxDocDate SMALLDATETIME null, ProdID INT NULL, Qty NUMERIC(21,9))
	--	INSERT #NotInv
	--	--="union all select "&C4&",'"&ТЕКСТ(D4;"ГГГГ-ММ-ДД")&"',"&H4&","&L4&""
	--	select 10109,'2017-10-31',31959,37
	--	union all select 2832,'2017-05-11',32111,1
	--	union all select 344,'2017-08-01',23774,20
	--	union all select 344,'2017-08-01',31957,24
	--	union all select 344,'2017-08-01',32993,12
	--	union all select 3614,'2017-04-11',3499,7
	--	union all select 3614,'2017-04-11',32655,39
	--	union all select 3614,'2017-04-11',31828,1
	--	union all select 3806,'2018-03-13',33255,3
	--	union all select 4398,'2017-11-14',33715,1
	--	union all select 4504,'2017-10-13',4149,5
	--	union all select 5036,'2017-05-16',32301,10
	--	union all select 513,'2018-02-02',32387,11
	--	union all select 5165,'2017-06-16',32236,1
	--	union all select 5355,'2018-03-16',28240,23
	--	union all select 6779,'2017-11-21',3499,12
	--	union all select 7092,'2017-07-21',32048,6
	--	union all select 7397,'2017-12-22',3499,10
	--	union all select 7397,'2017-12-22',30767,24
	--	union all select 7397,'2017-12-22',26136,31
	--	union all select 7500,'2017-05-23',28241,23
	--	union all select 7500,'2017-05-23',28574,4
	--	union all select 8248,'2017-04-24',31451,3
	--	union all select 8612,'2017-12-27',32573,4
	--	union all select 9624,'2017-12-29',32791,9
	--	union all select 9631,'2017-12-29',32993,11
	--	union all select 9798,'2017-09-29',32610,1
	--	union all select 9810,'2017-10-31',33300,4
			
	--	SELECT * FROM #NotInv
    
    
END

--расчет для комплектации
IF 1=0
BEGIN

DECLARE @Testing INT = 0 --  1-отладка   0-не выводить доп. результыты
DECLARE @BDate SMALLDATETIME = '2018-05-16'
DECLARE @EDate SMALLDATETIME = '2018-05-31'
DECLARE @BDateInv SMALLDATETIME = '2017-03-01' --начало периода поиска по РН
DECLARE @EDateInv SMALLDATETIME = '2018-05-15' --конец периода поиска по РН
--DECLARE @LastDayMount SMALLDATETIME = '2018-03-31' --последний день предыдущего месяца
DECLARE @ProdIDMA INT 
DECLARE @ProdID_Elit INT
DECLARE @FindProdID_Elit INT
DECLARE @ProdIDMA_Qty NUMERIC(21,9)
DECLARE @ProdIDMA_RetQty NUMERIC(21,9)
DECLARE @ProdIDMA_RealPrice NUMERIC(21,9)
DECLARE @ProdIDMA_SumQty NUMERIC(21,9) 
DECLARE @PPID_Inv INT 


--формируем список товаров в ElitR по которым ищем продажи
DECLARE @ChIDTable TABLE(ChID int NULL) 
INSERT INTO @ChIDTable 
	--SELECT max(num) FROM #NotInv group by ProdID --для ручного подбора возвратов
	SELECT AValue FROM dbo.zf_FilterToTable('600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600267,600299,600712,600712,600721,600721,600731,600732,600742,600743,600744,600745,600757,600757,600758,600758,600758,600760,600760,600773,600773,600816,600816,600816,600832,600839,600839,600840,600840,600882,600883,600883,600884,600884,600884,600884,600884,600885,600885,600887,600891,600891,600892,600895,600895,600987,601070,601070,601078,601085,601085,601085,601085,601086,601095,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602507,602563,602563,602563,602564,602564,602669,602669,602755,602755,603053,603053,603053,603928,603936,603975,604603,604851,604979,604980,604980,800084,800084,800164,800164,800164,800165,800165,800594,800594,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,801952,802174,802185,802375,802376,802394,802399,802402,802408,802412,802412,802424,802424,802471,802484,802485,802486,802489,802489,802490,802490,802511,802650,802651,802656,802657,802705,802705,802751,802751,802752,802982,803013,803013,803016')
	--WHERE AValue in (601116,600132,600133) -- для отладки 600773
--SELECT * FROM @ChIDTable

--обнуляем времменые таблицы и переменные
DELETE #TempRet	
DELETE #TempRetFinal	
DELETE #TempFindProdElit
DELETE #TempFindProdElitAll
DELETE #TempFindProdElitAll_tmp
SET @ProdIDMA_SumQty = 0

--курсор по товарам в ElitR (выборка всех вариантов для возвратов)
DECLARE kalc CURSOR FOR
SELECT DISTINCT ChID FROM @ChIDTable ORDER BY 1
OPEN kalc
FETCH NEXT FROM kalc INTO @ProdIDMA 
 WHILE @@FETCH_STATUS = 0    		 
  BEGIN 
  
  IF 1=1
  BEGIN
	--кол проданных товаров которое будем возращать
	SELECT @ProdIDMA_Qty = ISNULL(sum(ds.Qty),0), @ProdIDMA_RealPrice = MIN(ds.RealPrice) FROM t_Sale ms JOIN t_SaleD ds ON ds.ChID = ms.ChID
	WHERE ds.ProdID in (@ProdIDMA) and ms.DocDate between @BDate and @EDate and ms.CodeID1 = 63 and ms.CodeID3 <> 89 and ms.OurID = 6
	
	--кол возращенных товаров 
	SELECT @ProdIDMA_RetQty = ISNULL(sum(ds.Qty),0) FROM t_CRRet ms JOIN t_CRRetD ds ON ds.ChID = ms.ChID
	WHERE ds.ProdID in (@ProdIDMA) and ms.DocDate between @BDate and @EDate and ms.CodeID1 = 63 and ms.CodeID3 <> 89 and ms.OurID = 6
	
	--для отладки
	IF @Testing = 1
	SELECT @ProdIDMA_Qty ProdIDMA_Qty ,@ProdIDMA_RetQty ProdIDMA_RetQty, @ProdIDMA_RealPrice ProdIDMA_RealPrice
		
	--отнять возвраты
	SET @ProdIDMA_Qty = @ProdIDMA_Qty - @ProdIDMA_RetQty
	
	--КОРРЕКЦИЯ КОЛИЧЕСТВА ПРОДАЖ 
	--IF @ProdIDMA = 600712 SET @ProdIDMA_Qty = @ProdIDMA_Qty - 1
	
	--общее кол проданных товаров которое будем возращать (для контроля расчета)
	SELECT @ProdIDMA_SumQty = @ProdIDMA_SumQty + @ProdIDMA_Qty
	
	IF @Testing = 1 SELECT @ProdIDMA_Qty ProdIDMA_Qty
	
	--подбор в базе МЕДОК элитовских товаров по которым будет возврат
	INSERT INTO #TempFindProdElit
		SELECT  ROW_NUMBER()OVER(ORDER BY ProdName,Pos) N, @ProdIDMA ProdIDMA, @ProdIDMA_Qty ProdIDMA_Qty, (SELECT top 1 p1.ProdID FROM Elit.dbo.r_Prods p1 where p1.Notes = un.ProdName) ProdID_Elit, 
		DNN,NNN, ProdName,UM,Pos , SUM(Qty) TQty, 
		--MAX(Price) Price, SUM(Qty) * MAX(Price) SumCC, 
		@ProdIDMA_RealPrice Price, SUM(Qty) * @ProdIDMA_RealPrice SumCC, 
		0 QtyRealRet,  0 CodeID2 , 0 rating FROM (
			SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
			FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA))) 
			AND  SEND_DPA_DATE < @EDateInv AND  SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая
		UNION ALL
			SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
			FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA)))
			AND  SEND_DPA_DATE < @EDateInv AND  SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая
		) un 
		GROUP BY DNN,NNN, ProdName,UM,Pos 
		HAVING SUM(Qty) > 0 
		AND 10797 = (SELECT top 1 CompID FROM Elit.dbo.t_Inv i WHERE i.TaxDocDate = DNN and i.TaxDocID = NNN)--только РН которые по предприятию 10797
		ORDER BY ProdID_Elit,DNN,NNN,ProdIDMA,Price,TQty desc
	
	--для отладки	
    IF @ProdIDMA in (600072)  SELECT * FROM #TempFindProdElit where ProdIDMA in (600072)
    
--проверка по количеству для одиночного товара
--SELECT @ProdIDMA,(SELECT SUM(TQty) FROM #TempFindProdElit) сумма_возвр, @ProdIDMA_Qty сумма_продаж     
IF ISNULL((SELECT SUM(TQty) FROM #TempFindProdElit),0) < @ProdIDMA_Qty
BEGIN
	SELECT 'Ошибка, количество возвратов меньше продаж!!!', @ProdIDMA,(SELECT SUM(TQty) FROM #TempFindProdElit) сумма_возвр, @ProdIDMA_Qty сумма_продаж 
	SELECT * FROM #TempFindProdElit where ProdIDMA = @ProdIDMA
	SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA)
	RAISERROR('Ошибка, количество возвратов меньше продаж!!!', 10, 1) WITH NOWAIT
END
	
	INSERT #TempFindProdElitAll
		SELECT * FROM #TempFindProdElit
	DELETE #TempFindProdElit
	/*
	
	DECLARE @ProdID_Elit_Find INT = 32237
	DECLARE @EDateInv2 SMALLDATETIME = '2018-05-15' --конец периода поиска по РН
	
		SELECT  ROW_NUMBER()OVER(ORDER BY ProdName,Pos) N
			, (SELECT top 1 p1.ProdID FROM Elit.dbo.r_Prods p1 where p1.Notes = un.ProdName) ProdID_Elit, 
			DNN,NNN, ProdName,UM,Pos , SUM(Qty) TQty 
		FROM (
			SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
			FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (@ProdID_Elit_Find)) 
			AND  SEND_DPA_DATE < @EDateInv2 AND  SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая
		UNION ALL
			SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
			FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (@ProdID_Elit_Find)) 
			AND  SEND_DPA_DATE < @EDateInv2 AND  SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая
		) un 
		GROUP BY DNN,NNN, ProdName,UM,Pos 
		HAVING SUM(Qty) > 0 
		AND 10797 = (SELECT top 1 CompID FROM Elit.dbo.t_Inv i WHERE i.TaxDocDate = DNN and i.TaxDocID = NNN)--только РН которые по предприятию 10797
		and NNN = 2832
		ORDER BY ProdID_Elit,DNN,NNN,TQty desc



	
	--600732-28241
				SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
			FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600732))) 
			AND  SEND_DPA_DATE < '2018-05-15' AND  SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая
		UNION ALL
			SELECT  TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
			FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600732)))
			AND  SEND_DPA_DATE < '20180515' AND  SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая
and N2_11 = 2832

			SELECT SEND_DPA_DATE, TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
			FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600732)))
			and N2_11 = 2832
--802376-32237
				SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
			FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (802376))) 
			AND  SEND_DPA_DATE < '2018-05-15' AND  SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая
		UNION ALL
			SELECT  TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
			FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (802376)))
			AND  SEND_DPA_DATE < '20180515' AND  SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая
and N2_11 = 2832

SELECT * FROM #TempRetFinal where ProdID = 32237
SELECT * FROM #TempFindProdElitAll where ProdID_Elit = 32237	
SELECT * FROM #TempFindProdElitAll_tmp where ProdID_Elit = 32237


		SELECT * FROM (
		SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
		FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600072))) 
		AND  SEND_DPA_DATE is not null
		UNION ALL
		SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
		FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600072)))
		AND  SEND_DPA_DATE is not null
		) s1 WHERE 10797 = (SELECT top 1 CompID FROM Elit.dbo.t_Inv i WHERE i.TaxDocDate = DNN and i.TaxDocID = NNN)--только РН которые по предприятию 10797
		--and NNN = 8248
		--and prodname  = 'Вино Luis Felipe Edwards. Совіньон Блан Резерва 2014 біле 0,75*12'
		ORDER BY DNN,NNN, ProdName,UM,Pos
		
		SELECT * FROM (
		SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
		FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (601085))) 
		AND  SEND_DPA_DATE is not null
		UNION ALL
		SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
		,*
		FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (601085)))
		AND  SEND_DPA_DATE is not null
		) s1 WHERE 10797 = (SELECT top 1 CompID FROM Elit.dbo.t_Inv i WHERE i.TaxDocDate = DNN and i.TaxDocID = NNN)--только РН которые по предприятию 10797
		and NNN = 8248
		--and prodname  = 'Вино Luis Felipe Edwards. Совіньон Блан Резерва 2014 біле 0,75*12'
		ORDER BY DNN,NNN, ProdName,UM,Pos
		
		SELECT SEND_DPA_DATE,* FROM #Medoc_RET where SEND_DPA_DATE is null
		SELECT SEND_DPA_DATE,* FROM #Medoc where SEND_DPA_DATE is null

	
			SELECT  ROW_NUMBER()OVER(ORDER BY ProdName,Pos) N, 600891 ProdIDMA, 111 ProdIDMA_Qty, (SELECT top 1 p1.ProdID FROM Elit.dbo.r_Prods p1 where p1.Notes = un.ProdName) ProdID_Elit, 
		DNN,NNN, ProdName,UM,Pos , SUM(Qty) TQty, MAX(Price) Price, SUM(Qty) * MAX(Price) SumCC, 0 QtyRealRet,  0 CodeID2 , 0 rating FROM (
			SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
			FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600891))) 
			--AND  SEND_DPA_DATE is not null
		UNION ALL
			SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
			FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600891)))
			--AND  SEND_DPA_DATE is not null
		) un 
		GROUP BY DNN,NNN, ProdName,UM,Pos 
		HAVING SUM(Qty) > 0 
		AND 10797 = (SELECT top 1 CompID FROM Elit.dbo.t_Inv i WHERE i.TaxDocDate = DNN and i.TaxDocID = NNN)--только РН которые по предприятию 10797
		and NNN = 3711
		ORDER BY ProdID_Elit,DNN,NNN,ProdIDMA,Price,TQty desc
		
			SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
			FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600891)))
			--AND  SEND_DPA_DATE is not null
			and N2_11 = 3711

SELECT * FROM (
			SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
			FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600891))) 
			--AND  SEND_DPA_DATE is not null
		UNION ALL
			SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
			FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600891)))
			--AND  SEND_DPA_DATE is not null
			) s2
where NNN = 3711
		
		
		--SELECT d.* FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = 9798 and m.TaxDocDate = '2017-09-29 00:00:00' and d.ProdID = 32784-- and d.SrcPosID = Pos
		SELECT d.* FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = 8248 and m.TaxDocDate = '2017-04-24 00:00:00' and d.ProdID = 31451-- and d.SrcPosID = Pos
		SELECT d.* FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = 8248 and m.TaxDocDate = '2017-04-24 00:00:00' and d.ProdID = 32045-- and d.SrcPosID = Pos
		
		SELECT  p1.ProdID FROM Elit.dbo.r_Prods p1 where p1.Notes = 'Вино Luis Felipe Edwards. Совіньон Блан Резерва 2014 біле 0,75*12'
		SELECT  p1.ProdID FROM Elit.dbo.r_Prods p1 where p1.Notes = 'Вино Luis Felipe Edwards. Совіньон Блан Резерва 2015 біле 0,75*12'
		
N	ProdIDMA	ProdIDMA_Qty	ProdIDMA_RealPrice	ChID	DocID	TaxDocID	TaxDocDate	ProdID	PPID	QtyInv	vozv_Elit	vozv_ElitDistr	QtyRet	rem	abs_razn	QtyRealRet	CodeID2	SrcPosID_Inv	Pos_Medoc	sumQtyInv
1	601085	21.000000000	111.750000000	200003990	1109792	8248	2017-04-24 00:00:00	31451	0	NULL	NULL	NULL	NULL	NULL	NULL	21.000000000	44	0	1358	NULL
	*/
	--SELECT 'для отладки TempFindProdElit'
	--SELECT * FROM #TempFindProdElit	
	--SELECT distinct ProdIDMA FROM #TempFindProdElitAll	
	--SELECT distinct ProdID_Elit FROM #TempFindProdElitAll_tmp m where m.QtyRealRet > 0
	--SELECT * FROM #TempFindProdElitAll_tmp m where m.QtyRealRet > 0 ORDER BY ProdIDMA,ProdID_Elit,rating
    

      
	FETCH NEXT FROM kalc INTO @ProdIDMA 
  END
  
  END
CLOSE kalc
DEALLOCATE kalc


--Определения рейтинга для РН
--SELECT * FROM #TempFindProdElitAll 
UPDATE #TempFindProdElitAll
SET rating = ISNULL((SELECT count_prod FROM (SELECT DNN, NNN, COUNT(*) count_prod FROM (SELECT DNN, NNN,ProdID_Elit FROM #TempFindProdElitAll group by DNN, NNN, ProdID_Elit)s1 group by DNN, NNN)gr where gr.DNN = #TempFindProdElitAll.DNN and gr.NNN = #TempFindProdElitAll.NNN),0)


--курсор по товарам в ElitR (поик оптимальных товаров и РН с которых будет возврат)
DECLARE kalc2 CURSOR FOR
SELECT DISTINCT ChID FROM @ChIDTable ORDER BY 1
OPEN kalc2
FETCH NEXT FROM kalc2 INTO @ProdIDMA 
 WHILE @@FETCH_STATUS = 0    		 
  BEGIN 
	
	SET @ProdIDMA_Qty = ISNULL((SELECT top 1  ProdIDMA_Qty FROM #TempFindProdElitAll WHERE ProdIDMA = @ProdIDMA),0)
	
	--SELECT * FROM #TempFindProdElit
	DELETE #TempFindProdElit
	
	INSERT #TempFindProdElit 
		SELECT * FROM #TempFindProdElitAll WHERE ProdIDMA = @ProdIDMA
	
	--SELECT distinct ProdIDMA FROM #TempFindProdElitAll_tmp	
	--SELECT * FROM #TempFindProdElitAll_tmp	
	
--подбор РН по которым будут возвраты
IF 1=1
BEGIN
	DECLARE @QtyRet NUMERIC(21,9), @SrcPosID INT, @TQty NUMERIC(21,9), @N_next INT, @TQty_posN NUMERIC(21,9)
	
	--курсор по элитовским товарам
	DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD FOR 
		SELECT distinct ProdID_Elit FROM #TempFindProdElit WITH (NOLOCK) ORDER BY 1
	OPEN CURSOR1
		FETCH NEXT FROM CURSOR1 INTO @ProdID_Elit
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Script
		SELECT @QtyRet = 0, @TQty = @ProdIDMA_Qty  
		
		--SELECT * FROM #TempFindProdElitAll WITH (NOLOCK) WHERE ProdID_Elit = 28241 ORDER BY rating desc, TQty desc
		--SELECT * FROM #TempFindProdElitAll WITH (NOLOCK) WHERE ProdIDMA = 600742 ORDER BY rating desc, TQty desc
		
		--для отладки
		--IF @ProdID_Elit = 31451 SELECT '' 'test1 31451',N N_, TQty TQty_,* FROM #TempFindProdElit WITH (NOLOCK) WHERE ProdID_Elit = @ProdID_Elit ORDER BY rating desc, TQty desc
		
		--курсор по позициям в элитовском товаре
		DECLARE CURSOR2 CURSOR LOCAL FAST_FORWARD FOR 
			SELECT N, TQty FROM #TempFindProdElit WITH (NOLOCK) WHERE ProdID_Elit = @ProdID_Elit ORDER BY rating desc, TQty desc -- сортировка по рейтингу РН и количеству
		OPEN CURSOR2
			FETCH NEXT FROM CURSOR2 INTO @SrcPosID, @QtyRet
		WHILE @@FETCH_STATUS = 0 AND @TQty > 0
		BEGIN
			--Script
			--если QtyRealRet еще не обновляли
			IF (SELECT top 1 QtyRealRet FROM #TempFindProdElit WHERE N = @SrcPosID and ProdID_Elit = @ProdID_Elit) <= 0 
				IF @QtyRet <= @TQty --если кол позиции меньше или равно оставщемуся кол для распределения
				BEGIN
					UPDATE #TempFindProdElit 
					SET QtyRealRet = @QtyRet 
					,CodeID2 = CASE WHEN TQty = @QtyRet THEN 19 ELSE 44 END --определить признак 2 по позициям
					WHERE N = @SrcPosID and ProdID_Elit = @ProdID_Elit
					
					SET @TQty = @TQty - @QtyRet
				END
				ELSE
				BEGIN 
					--если есть позиции с меньшим или равным количеством
					SET @N_next = (SELECT top 1 N FROM #TempFindProdElit WHERE ProdID_Elit = @ProdID_Elit and TQty <= @TQty and QtyRealRet = 0 ORDER BY TQty DESC,rating DESC )
					SET @TQty_posN = (SELECT top 1 TQty FROM #TempFindProdElit WHERE N = @N_next)
					IF  @N_next IS NOT NULL
					BEGIN
						--распределить по меньшим позициям
						UPDATE #TempFindProdElit 
						SET QtyRealRet = @TQty_posN --
						,CodeID2 = CASE WHEN TQty = @TQty_posN THEN 19 ELSE 44 END --определить признак 2 по позициям
						WHERE N = @N_next
						
						SET @TQty = @TQty - ISNULL(@TQty_posN,0)
					END
					ELSE --тогда взять остаток из текущей позиции
					BEGIN
						UPDATE #TempFindProdElit 
						SET QtyRealRet = @TQty 
						,CodeID2 = CASE WHEN TQty = @TQty THEN 19 ELSE 44 END --определить признак 2 по позициям
						WHERE N = @SrcPosID and ProdID_Elit = @ProdID_Elit
						
						SET @TQty = 0
					END

				END
			
			FETCH NEXT FROM CURSOR2	INTO @SrcPosID, @QtyRet
		END
		CLOSE CURSOR2
		DEALLOCATE CURSOR2

		--для отладки
		--IF @ProdID_Elit = 31451 SELECT '' 'test2 31451',N N_, TQty TQty_,* FROM #TempFindProdElit WITH (NOLOCK) WHERE ProdID_Elit = @ProdID_Elit ORDER BY rating desc, TQty desc

		FETCH NEXT FROM CURSOR1	INTO @ProdID_Elit
	END
	CLOSE CURSOR1
	DEALLOCATE CURSOR1

  END
	
	--для отладки
	IF @Testing = 1
	BEGIN
		SELECT 'для отладки выбора товара'
		SELECT *
		,(SELECT TOP 1 TQty  FROM #Rec1 r WHERE r.ProdID = gr.ProdID_Elit and gr.Sum_QtyRealRet <= TQty ORDER BY r.Price ) TQty 
		,(SELECT TOP 1 Price  FROM #Rec1 r WHERE r.ProdID = gr.ProdID_Elit and gr.Sum_QtyRealRet <= TQty ORDER BY r.Price ) Price 
		FROM (
			SELECT ProdID_Elit, SUM(QtyRealRet) Sum_QtyRealRet, COUNT(QtyRealRet) Count_QtyRealRet 
			FROM #TempFindProdElit t
			WHERE t.QtyRealRet <> 0 
			GROUP BY ProdID_Elit
		) gr
		WHERE (SELECT TOP 1 TQty  FROM #Rec1 r WHERE r.ProdID = gr.ProdID_Elit and gr.Sum_QtyRealRet <= TQty ORDER BY r.Price ) >= Sum_QtyRealRet
		and Sum_QtyRealRet >= @ProdIDMA_Qty
		--and ProdID_Elit IN (SELECT distinct ProdID FROM #ProdIdNabor) -- участвуют только товары из справочников наборов
		ORDER BY Price
	END	
	
	--выбрать один товар c минимальной ценой
	SELECT top 1 @FindProdID_Elit = ProdID_Elit FROM (
	SELECT *
	,(SELECT TOP 1 TQty  FROM #Rec1 r WHERE r.ProdID = gr.ProdID_Elit and gr.Sum_QtyRealRet <= TQty ORDER BY r.Price ) TQty 
	,(SELECT TOP 1 Price  FROM #Rec1 r WHERE r.ProdID = gr.ProdID_Elit and gr.Sum_QtyRealRet <= TQty ORDER BY r.Price ) Price 
	FROM (
		SELECT ProdID_Elit, SUM(QtyRealRet) Sum_QtyRealRet, COUNT(QtyRealRet) Count_QtyRealRet 
		FROM #TempFindProdElit t
		WHERE t.QtyRealRet <> 0 
		GROUP BY ProdID_Elit
	) gr
	WHERE (SELECT TOP 1 TQty  FROM #Rec1 r WHERE r.ProdID = gr.ProdID_Elit and gr.Sum_QtyRealRet <= TQty ORDER BY r.Price ) >= Sum_QtyRealRet
	and Sum_QtyRealRet >= @ProdIDMA_Qty
	--and ProdID_Elit IN (SELECT distinct ProdID FROM #ProdIdNabor) -- участвуют только товары из справочников наборов
	) s1
	ORDER BY Price
	
	--для отладки
	IF @Testing = 1
	BEGIN
		SELECT  @FindProdID_Elit FindProdID_Elit	 
		SELECT * FROM #TempFindProdElit WHERE QtyRealRet > 0 and ProdID_Elit = @FindProdID_Elit

		SELECT *
		,(SELECT TOP 1 TQty  FROM #Rec1 r WHERE r.ProdID = gr.ProdID_Elit and gr.Sum_QtyRealRet <= TQty ORDER BY r.Price ) TQty 
		,(SELECT TOP 1 Price  FROM #Rec1 r WHERE r.ProdID = gr.ProdID_Elit and gr.Sum_QtyRealRet <= TQty ORDER BY r.Price ) Price 
		FROM (
			SELECT ProdID_Elit, SUM(QtyRealRet) Sum_QtyRealRet, COUNT(QtyRealRet) Count_QtyRealRet 
			FROM #TempFindProdElitAll_tmp t
			WHERE t.QtyRealRet <> 0 
			and ProdIDMA = 600773
			GROUP BY ProdID_Elit
		) gr
		WHERE (SELECT TOP 1 TQty  FROM #Rec1 r WHERE r.ProdID = gr.ProdID_Elit and gr.Sum_QtyRealRet <= TQty ORDER BY r.Price ) >= Sum_QtyRealRet
		and Sum_QtyRealRet >= @ProdIDMA_Qty

		SELECT * 
		FROM #TempFindProdElitAll_tmp t
		WHERE t.QtyRealRet <> 0 
		--ORDER BY 2,3
		and ProdIDMA = 601773

		--600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600267,600299,600712,600712,600721,600721,600731,600732,600742,600743,600744,600745,600757,600757,600758,600758,600758,600760,600760,600773,600773,600816,600816,600816,600832,600839,600839,600840,600840,600882,600883,600883,600884,600884,600884,600884,600884,600885,600885,600887,600891,600891,600892,600895,600895,600987,601070,601070,601078,601085,601085,601085,601085,601086,601095,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602507,602563,602563,602563,602564,602564,602669,602669,602755,602755,603053,603053,603053,603928,603936,603975,604603,604851,604979,604980,604980,800084,800084,800164,800164,800164,800165,800165,800594,800594,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,801952,802174,802185,802375,802376,802394,802399,802402,802408,802412,802412,802424,802424,802471,802484,802485,802486,802489,802489,802490,802490,802511,802650,802651,802656,802657,802705,802705,802751,802751,802752,802982,803013,803013,803016')

	END

--SELECT ChID FROM Elit.dbo.t_Inv WHERE TaxDocID = 358 and TaxDocDate = '2017-06-01'

	INSERT #TempRetFinal
		SELECT ROW_NUMBER()OVER(ORDER BY ProdID_Elit) N, @ProdIDMA ProdIDMA, @ProdIDMA_Qty ProdIDMA_Qty, Price ProdIDMA_RealPrice, 
			(SELECT top 1 ChID FROM Elit.dbo.t_Inv WHERE TaxDocID = NNN and TaxDocDate = DNN) ChID, 
			(SELECT top 1 DocID FROM Elit.dbo.t_Inv WHERE TaxDocID = NNN and TaxDocDate = DNN) DocID, 
			NNN TaxDocID, DNN TaxDocDate, ProdID_Elit ProdID, 
			(SELECT top 1 PPID FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = NNN and m.TaxDocDate = DNN and d.ProdID = ProdID_Elit and d.SrcPosID = Pos) PPID,
			(SELECT top 1 d.Qty FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = NNN and m.TaxDocDate = DNN and d.ProdID = ProdID_Elit and d.SrcPosID = Pos) QtyInv, 
			NULL vozv_Elit, NULL vozv_ElitDistr, TQty QtyRet, NULL rem, NULL abs_razn, 
			QtyRealRet QtyRealRet, CodeID2 CodeID2, 
			(SELECT top 1 d.SrcPosID FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = NNN and m.TaxDocDate = DNN and d.ProdID = ProdID_Elit and d.SrcPosID = Pos) SrcPosID_Inv,
			 Pos Pos_Medoc, NULL sumQtyInv
		FROM #TempFindProdElit 
		WHERE QtyRealRet > 0 and ProdID_Elit = @FindProdID_Elit 

	INSERT #TempFindProdElitAll_tmp
		SELECT * FROM #TempFindProdElit WHERE QtyRealRet > 0 and ProdID_Elit = @FindProdID_Elit
		
	DELETE #TempFindProdElit	  

	FETCH NEXT FROM kalc2 INTO @ProdIDMA 
  END
CLOSE kalc2
DEALLOCATE kalc2


/*
SELECT d.* FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = 9798 and m.TaxDocDate = '2017-09-29 00:00:00' and d.ProdID = 32784-- and d.SrcPosID = Pos
--SELECT d.* FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = 2832 and m.TaxDocDate = '2017-05-11 00:00:00' and d.ProdID = 24412-- and d.SrcPosID = Pos
--SELECT d.* FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = 3929 and m.TaxDocDate = '2018-03-13 00:00:00' and d.ProdID = 3499-- and d.SrcPosID = Pos
--SELECT d.* FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = 2832 and m.TaxDocDate = '2017-05-11' and d.ProdID = 31441-- and d.SrcPosID = Pos
--SELECT * FROM #TempRetFinal where PPID =0
--SELECT * FROM #TempRetFinal ORDER BY  PPID 
--SELECT * FROM #TempRetFinal where ProdID = 3499-- and PPID is null
--SELECT * FROM #TempRetFinal where ProdID = 24412-- and PPID is null
SELECT * FROM #TempRetFinal where ProdID = 32784-- and PPID is null
ORDER BY ChID,ProdID
SELECT top 1 PPID FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID 
	WHERE m.TaxDocID = 2832 and m.TaxDocDate = '2017-05-11' and d.ProdID = 31441 and d.Qty = 4
SELECT * FROM  #TempRetFinal m WHERE m.TaxDocID = @cur3_TaxDocID and m.TaxDocDate = @cur3_TaxDocDate and m.ProdID = @cur3_ProdID and m.QtyRealRet = @cur3_QtyRealRet and m.SrcPosID_Inv = @cur3_SrcPosID_Inv  
SELECT * FROM #TempFindProdElitAll_tmp WHERE ProdID_Elit = 32784
*/
/*поиск не найденных партий*/
--BEGIN TRAN
IF 1=1
BEGIN
DECLARE @cur3_ProdID INT,@cur3_TaxDocID INT,@cur3_TaxDocDate SMALLDATETIME,@cur3_QtyRealRet NUMERIC(21,9),@cur3_PPID INT,@cur3_SrcPosID_Inv INT
DECLARE CURSOR3 CURSOR LOCAL FAST_FORWARD
FOR 
	SELECT TaxDocID, TaxDocDate, ProdID, QtyRealRet,Pos_Medoc FROM #TempRetFinal  WITH (NOLOCK) WHERE PPID IS NULL ORDER BY  TaxDocDate,TaxDocID,ProdID,QtyRealRet
OPEN CURSOR3
	FETCH NEXT FROM CURSOR3	INTO @cur3_TaxDocID,@cur3_TaxDocDate,@cur3_ProdID,@cur3_QtyRealRet,@cur3_SrcPosID_Inv
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	--IF @cur3_ProdID = 24412
	--BEGIN
	--	SELECT @cur3_TaxDocID cur3_TaxDocID,@cur3_TaxDocDate cur3_TaxDocDate,@cur3_ProdID cur3_ProdID,@cur3_QtyRealRet cur3_QtyRealRet,@cur3_SrcPosID_Inv cur3_SrcPosID_Inv  
	--END
	
	SET @cur3_PPID = (SELECT top 1 PPID FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID 
	WHERE m.TaxDocID = @cur3_TaxDocID and m.TaxDocDate = @cur3_TaxDocDate and d.ProdID = @cur3_ProdID and d.Qty = @cur3_QtyRealRet)

	--IF @cur3_ProdID = 24412 SELECT @cur3_PPID cur3_PPID

	IF @cur3_PPID IS NOT NULL
	BEGIN
		--IF @cur3_ProdID = 24412 SELECT @cur3_PPID cur3_PPID_IS_NOT_NULL
		
		UPDATE m 
		SET PPID = @cur3_PPID, SrcPosID_Inv = (SELECT top 1 d.SrcPosID FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID 
												WHERE m.TaxDocID = @cur3_TaxDocID and m.TaxDocDate = @cur3_TaxDocDate and d.ProdID = @cur3_ProdID and d.Qty = @cur3_QtyRealRet)
		FROM #TempRetFinal m WHERE m.TaxDocID = @cur3_TaxDocID and m.TaxDocDate = @cur3_TaxDocDate and m.ProdID = @cur3_ProdID and m.QtyRealRet = @cur3_QtyRealRet and m.Pos_Medoc = @cur3_SrcPosID_Inv  
	END
	ELSE
	BEGIN
		--IF @cur3_ProdID = 24412 SELECT @cur3_PPID cur3_PPID_else
	
		UPDATE t 
		SET PPID = ISNULL((SELECT top 1 PPID FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID 
							WHERE m.TaxDocID = @cur3_TaxDocID and m.TaxDocDate = @cur3_TaxDocDate and d.ProdID = @cur3_ProdID and d.Qty > @cur3_QtyRealRet ORDER BY d.Qty desc),0)
			, SrcPosID_Inv = ISNULL((SELECT top 1 d.SrcPosID FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID 
							WHERE m.TaxDocID = @cur3_TaxDocID and m.TaxDocDate = @cur3_TaxDocDate and d.ProdID = @cur3_ProdID and d.Qty > @cur3_QtyRealRet ORDER BY d.Qty desc),0)							
		FROM #TempRetFinal t WHERE t.TaxDocID = @cur3_TaxDocID and t.TaxDocDate = @cur3_TaxDocDate and t.ProdID = @cur3_ProdID 
		and t.QtyRealRet = @cur3_QtyRealRet and t.Pos_Medoc = @cur3_SrcPosID_Inv 
	END
	
	--IF @cur3_ProdID = 24412 SELECT * FROM #TempRetFinal where ProdID = 24412
	
	FETCH NEXT FROM CURSOR3	INTO @cur3_TaxDocID,@cur3_TaxDocDate,@cur3_ProdID,@cur3_QtyRealRet,@cur3_SrcPosID_Inv
END
CLOSE CURSOR3
DEALLOCATE CURSOR3
END
/*
SELECT * FROM #TempRetFinal where ProdID = 32445
SELECT * FROM #TempRetFinal where PPID is null
SELECT * FROM #TempRetFinal where PPID = 0
SELECT * FROM #TempRetFinal ORDER BY  PPID 
--SELECT d.* FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = 2832 and m.TaxDocDate = '2017-05-11 00:00:00' and d.ProdID = 24412-- and d.SrcPosID = Pos
SELECT d.* FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID WHERE m.TaxDocID = 8248 and m.TaxDocDate = '2017-04-24 00:00:00' and d.ProdID = 31451-- and d.SrcPosID = Pos
SELECT * FROM #TempRetFinal where ProdID = 31451-- and PPID is null
*/
--ROLLBACK TRAN


--SELECT * FROM #TempFindProdElitAll_tmp ORDER BY ProdIDMA,rating desc
--SELECT top 1 * FROM #Rec1

--SELECT top 1 ProdIdNabor FROM #ProdIdNabor pn where pn.ProdIDMA = (SELECT top 1 ExtProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and CompID = 10793  and ec.ProdID = 32465)

	--для отладки
	--IF @Testing = 1
	BEGIN
		SELECT * FROM #TempRetFinal

		SELECT 'для файла: После_обработки_наборов.xlsx '
		SELECT ProdIDMA, ProdIdNabor, SUM(QtyRet) QtyRet, ProdId, MIN(PriceShop) PriceShop , MIN(Price) Price FROM (
			SELECT ProdIDMA ProdIDMA, 
			
			ISNULL(  (SELECT top 1 ProdIdNabor FROM #ProdIdNabor pn where pn.ProdIDMA = (SELECT top 1 ExtProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and CompID = 10793  and ec.ProdID = trf.ProdID)),
				ISNULL( (SELECT top 1 ProdIdNabor FROM #ProdIdNabor pn where pn.ProdIDMA = (SELECT top 1 ExtProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and CompID in (10790,10791,10793)  and ec.ProdID = trf.ProdID)),
					(SELECT top 1 ProdIdNabor FROM #ProdIdNabor pn where pn.ProdID = trf.ProdID) )  ) ProdIdNabor,
			--(SELECT top 1 ProdIdNabor FROM #ProdIdNabor pn where pn.ProdID = trf.ProdID)	ProdIdNabor,
				QtyRealRet QtyRet,	ProdID ProdId, trf.PPID,	ProdIDMA_RealPrice PriceShop,	ProdIDMA_RealPrice/1.05/1.2 Price
			FROM #TempRetFinal trf	
		) gr
		group by ProdIDMA, ProdIdNabor, ProdId
		ORDER BY ProdIDMA--, ProdIdNabor
	END

--проверка по общему количеству
IF (SELECT SUM(QtyRealRet) FROM #TempRetFinal) <> @ProdIDMA_SumQty
BEGIN
	SELECT 'Ошибка, не сходится общее количество возвратов!!!', (SELECT SUM(QtyRealRet) FROM #TempRetFinal) сумма_возвр, @ProdIDMA_SumQty сумма_продаж 
	RAISERROR('Ошибка, не сходится общее количество возвратов!!!', 10, 1) WITH NOWAIT
END

/*
SELECT top 1 N FROM #TempFindProdElit WHERE ProdID_Elit = 26133 and TQty <= 2 ORDER BY TQty DESC

SELECT N, TQty FROM #TempFindProdElit WITH (NOLOCK) WHERE ProdID_Elit = 26133 ORDER BY 1

SELECT * FROM #TempRetFinal	

SELECT 'для файла: После_обработки_наборов.xlsx '
SELECT ProdIDMA, ProdIdNabor, SUM(QtyRet) QtyRet, ProdId, MIN(PriceShop) PriceShop , MIN(Price) Price FROM (
	SELECT ProdIDMA ProdIDMA, (SELECT top 1 ProdIdNabor FROM #ProdIdNabor pn where pn.ProdID = trf.ProdID)	ProdIdNabor,	QtyRealRet QtyRet,	ProdID ProdId, trf.PPID,	ProdIDMA_RealPrice PriceShop,	ProdIDMA_RealPrice/1.05/1.2 Price
	FROM #TempRetFinal trf	
) gr
group by ProdIDMA, ProdIdNabor, ProdId
ORDER BY ProdIdNabor


--проверка по общему количеству
IF (SELECT SUM(QtyRealRet) FROM #TempRetFinal) <> @ProdIDMA_SumQty
BEGIN
	SELECT 'Ошибка, не сходится общее количество возвратов!!!'
	RAISERROR('Ошибка, не сходится общее количество возвратов!!!', 18, 1)
END
*/

/*
SELECT * FROM  Elit.dbo.t_Inv m
JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
WHERE m.OurID = 1 and m.CompID = 10797 --and m.StateCode = 191 --только отправленые налоговые
--and m.DocDate between '2017-04-01' and @EDateInv --последний день предыдущего месяца
and d.ProdID in (32551)
and m.TaxDocID = 5651 
--and d.Qty > 0

SELECT * FROM #TempRetFinal where  ProdID = 3499

			SELECT dr.* FROM ElitDistr.dbo.t_Ret mr
			JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = 3614
			and mr.SrcTaxDocDate= '2017-04-11'
			and dr.ProdID = 3499
			--and dr.PPID = 144
			--GROUP BY dr.ProdID, dr.PPID
			
				SELECT * FROM ElitDistr.dbo.t_Ret WHERE ChID = 3449
				SELECT * FROM ElitDistr.dbo.t_RetD WHERE ChID = 3449
			
			
			SELECT * FROM Elit.dbo.t_Ret mr
			JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 --and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = 3614
			and mr.SrcTaxDocDate= '2017-04-11'
			and dr.ProdID = 3499
			--and dr.PPID = 144
			--GROUP BY dr.ProdID, dr.PPID
			
			
			
SELECT  ROW_NUMBER()OVER(ORDER BY ProdName,Pos) N, 600135 ProdIDMA, (SELECT top 1 p1.ProdID FROM Elit.dbo.r_Prods p1 where p1.Notes = un.ProdName) ProdID_Elit, 
DNN,NNN, ProdName,UM,Pos , SUM(Qty) TQty, MAX(Price) Price, SUM(Qty) * MAX(Price) SumCC, 0 QtyRealRet,  0 CodeID2 FROM (
	SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
	FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600135))) 
UNION ALL
	SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
	FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600135)))
) un 
GROUP BY DNN,NNN, ProdName,UM,Pos 
HAVING SUM(Qty) > 0 
ORDER BY ProdID_Elit,DNN,NNN,ProdIDMA,Price,TQty desc
			
*/
END

--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################

--SELECT top 1 ProdIdNabor FROM #ProdIdNabor pn where pn.ProdIDMA = (SELECT top 1 ExtProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and CompID in (10793)  and ec.ProdID = 32467)
--SELECT top 1 ProdIdNabor FROM #ProdIdNabor pn where pn.ProdID = 31927
--Возвраты
IF 1=0
BEGIN
BEGIN TRAN

DECLARE @DocDate SMALLDATETIME = '2018-05-16' --дата возврата (два раза в месяц)

	--добавить отсутствующие партии в t_PInP из elit для возвратов
	INSERT ElitDistr.dbo.t_PInP (ProdID,PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,DLSDate,IsCommission,CostMC,PriceAC_In,IsCert,FEAProdID,ProdBarCode,PPHumidity,PPImpurity,CustDocNum,CustDocDate)
		SELECT p.ProdID,p.PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,DLSDate,IsCommission,CostMC,PriceAC_In,IsCert,CstProdCode,ProdBarCode,PPHumidity,PPImpurity,CustDocNum,CstDocDate 
		FROM [Elit].dbo.t_PInP p
		join #TempRetFinal exc on exc.ProdID = p.ProdID and exc.PPID = p.PPID 
		where not EXISTS ( SELECT * FROM ElitDistr.dbo.t_PInP dp where  dp.ProdID = p.ProdID and dp.PPID = p.PPID )
	
	--добавить отсутствующие предприятия из elit для возвратов
	INSERT ElitDistr.dbo.r_Comps
		SELECT * FROM Elit.dbo.r_Comps m1 WHERE m1.CompID NOT IN (SELECT CompID FROM ElitDistr.dbo.r_Comps m2 where m2.CompID = m1.CompID)
	--SELECT * FROM ElitDistr.dbo.r_CompsAdd  WHERE CompID = 10797
	--SELECT * FROM Elit.dbo.r_CompsAdd  WHERE CompID = 10797

	--добавить отсутствующие адреса из elit для возвратов
	INSERT ElitDistr.dbo.r_CompsAdd
		SELECT * FROM Elit.dbo.r_CompsAdd m1 WHERE m1.CompAdd NOT IN (SELECT CompAdd FROM ElitDistr.dbo.r_CompsAdd m2 where m2.CompID = m1.CompID)
	--SELECT * FROM ElitDistr.dbo.r_CompsAdd  WHERE CompID = 10797
	--SELECT * FROM Elit.dbo.r_CompsAdd  WHERE CompID = 10797

	--добавить отсутствующие внешние коды из elit 
	INSERT ElitDistr.dbo.r_ProdEC
		SELECT e.ProdID, e.CompID, e.ExtProdID, null ExtProdName, null ExtBarCode FROM Elit.dbo.r_ProdEC e
		JOIN (
		SELECT ProdID, CompID FROM Elit.dbo.r_ProdEC
		except
		SELECT ProdID, CompID FROM ElitDistr.dbo.r_ProdEC
		)ex ON ex.CompID = e.CompID and ex.ProdID = e.ProdID

	/*
	SELECT * FROM Elit.dbo.r_ProdEC e
	JOIN ElitDistr.dbo.r_ProdEC ed on ed.ProdID = e.ProdID and ed.CompID = e.CompID and ed.ExtProdID <> e.ExtProdID
	--where e.ProdID = 33697
	*/
	
	--изменить неправельные внешние коды из elit 
	update ed set ed.ExtProdID = e.ExtProdID FROM Elit.dbo.r_ProdEC e
	JOIN ElitDistr.dbo.r_ProdEC ed on ed.ProdID = e.ProdID and ed.CompID = e.CompID and ed.ExtProdID <> e.ExtProdID

	/*
	SELECT ProdID, CompID, ExtProdID FROM Elit.dbo.r_ProdEC
	except
	SELECT ProdID, CompID, ExtProdID FROM ElitDistr.dbo.r_ProdEC
	*/

DECLARE @MSG NVARCHAR(250)
DECLARE @ChID_Inv INT, @CodeID2 INT
DECLARE @ChID_Ret INT, @DocID_Ret INT, @DocDate_Ret SMALLDATETIME 

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD FOR 
	SELECT distinct ChID, CodeID2 FROM #TempRetFinal WITH (NOLOCK) GROUP BY ChID, CodeID2 ORDER BY 1, 2

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ChID_Inv, @CodeID2
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	--SELECT * FROM #TempRetFinal where ChID = @ChID_Inv and CodeID2 =  @CodeID2
	
	/*Блок создания ВТП с признаком2 */
	--IF EXISTS (SELECT top 1 1 FROM #TempRetFinal WHERE ChID = @ChID_Inv and CodeID2 =  @CodeID2)
	--BEGIN
		SET @ChID_Ret = (SELECT MAX(ChID) + 1 FROM ElitDistr.dbo.t_Ret)
		SET @DocID_Ret = (SELECT ISNULL(MAX(DocID),0) + 1 FROM ElitDistr.dbo.t_Ret r WHERE r.OurID = 1 /*(SELECT top 1 OurID FROM Elit.dbo.t_Inv WHERE DocID = @DocID)*/ )
		SET @DocDate_Ret = @DocDate --ISNULL((SELECT MIN(@DocDate) FROM #TempRetFinal WHERE ChID = @ChID_Inv and CodeID2 =  @CodeID2), dbo.zf_GetDate(GETDATE()) )

	--для отладки
	--select @ChID_Inv ChID_Inv, @ChID_Ret ChID_Ret
	IF 1=0--@Testing = 2
		SELECT top 1 
		--ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, SrcDocID, SrcDocDate, PayDelay, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, InDocID, TaxDocID, TaxDocDate, Address, DelivID, KursCC, TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, DriverID, CompAddID, LinkID, TerrID
		@ChID_Ret ChID ,@DocID_Ret DocID ,DocID IntDocID, @DocDate_Ret  DocDate
		,KursMC, 
		1 OurID, 20 StockID, 10797 CompID, 63 CodeID1, @CodeID2 CodeID2, 
		CodeID3, CodeID4, CodeID5, EmpID, 
		ISNULL(Notes,'') + CASE WHEN @CodeID2 = 19 THEN ' Возврат ' ELSE ' Корректировка ' END + '- Создано для медок' Notes, 
		Discount, 
		TaxDocID as SrcDocID, TaxDocDate as SrcDocDate, 
		PayDelay, CurrID, 0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 0 TSpendSumCC, 0 TRouteSumCC, 190 StateCode, InDocID, 
		0 TaxDocID, @DocDate_Ret TaxDocDate, 
		Address, DelivID, KursCC, 0 TSumCC, DepID, 
		TaxDocID as SrcTaxDocID, TaxDocDate as SrcTaxDocDate, 
		DriverID, CompAddID, LinkID, TerrID --, MorePrc,   LetAttor,  OrderID, PayConditionID 
		FROM Elit.dbo.t_Inv i
		WHERE i.ChID = @ChID_Inv and i.OurID = 1 
			
		INSERT ElitDistr.dbo.t_Ret 
			SELECT top 1 
			--ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, SrcDocID, SrcDocDate, PayDelay, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, InDocID, TaxDocID, TaxDocDate, Address, DelivID, KursCC, TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, DriverID, CompAddID, LinkID, TerrID
			@ChID_Ret ChID ,@DocID_Ret DocID ,DocID IntDocID, @DocDate_Ret  DocDate
			,KursMC, 
			1 OurID, 20 StockID, 10797 CompID, 63 CodeID1, @CodeID2 CodeID2, 
			CodeID3, CodeID4, CodeID5, EmpID, 
			ISNULL(Notes,'') + CASE WHEN @CodeID2 = 19 THEN ' Возврат ' ELSE ' Корректировка ' END + '- Создано новым скриптом' Notes, 
			Discount, 
			TaxDocID as SrcDocID, TaxDocDate as SrcDocDate, 
			PayDelay, CurrID, 0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 0 TSpendSumCC, 0 TRouteSumCC, 190 StateCode, InDocID, 
			0 TaxDocID, @DocDate_Ret TaxDocDate, 
			Address, DelivID, KursCC, 0 TSumCC, DepID, 
			TaxDocID as SrcTaxDocID, TaxDocDate as SrcTaxDocDate, 
			DriverID, CompAddID, LinkID, TerrID --, MorePrc,   LetAttor,  OrderID, PayConditionID 
			FROM Elit.dbo.t_Inv i
			WHERE i.ChID = @ChID_Inv and i.OurID = 1 
			
		INSERT ElitDistr.dbo.t_RetD 
		
			SELECT max(ChID), max(Pos_Medoc), ProdID, max(PPID), max(UM), sum(Qty), max(PriceCC_nt), (sum(Qty) * max(PriceCC_nt)) SumCC_nt, max(Tax), (sum(Qty) * max(Tax)) TaxSum, max(PriceCC_wt), (sum(Qty) * max(PriceCC_wt)) SumCC_wt, max(BarCode), max(SecID) FROM (
			SELECT 
			--ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
			@ChID_Ret ChID, 
			--t.SrcPosID_Inv, 
			t.Pos_Medoc, -- теперь позиция из медка вставляется в возврат
			t.ProdID, t.PPID, d.UM, t.QtyRealRet Qty, d.PriceCC_nt, 
			(d.PriceCC_nt * t.QtyRealRet) SumCC_nt, d.Tax, (d.Tax * t.QtyRealRet) TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.QtyRealRet) SumCC_wt, d.BarCode, d.SecID
			FROM Elit.dbo.t_Inv i
			JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
			JOIN #TempRetFinal t ON t.ChID =i.ChID AND t.ProdId = d.ProdID AND t.SrcPosID_Inv = d.SrcPosID
			where i.ChID = @ChID_Inv AND t.CodeID2 = @CodeID2 AND t.QtyRealRet > 0
			) gr group by ProdID 

/*			--для отладки
			SELECT max(ChID), max(SrcPosID_Inv), ProdID, max(PPID), max(UM), sum(Qty), max(PriceCC_nt), (sum(Qty) * max(PriceCC_nt)) SumCC_nt, max(Tax), (sum(Qty) * max(Tax)) TaxSum, max(PriceCC_wt), (sum(Qty) * max(PriceCC_wt)) SumCC_wt, max(BarCode), max(SecID) FROM (
			SELECT 
			--ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
			1 ChID, t.SrcPosID_Inv, t.ProdID, t.PPID, d.UM, t.QtyRealRet Qty, d.PriceCC_nt, (d.PriceCC_nt * t.QtyRealRet) SumCC_nt, d.Tax, (d.Tax * t.QtyRealRet) TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.QtyRealRet) SumCC_wt, d.BarCode, d.SecID
			FROM Elit.dbo.t_Inv i
			JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
			JOIN #TempRetFinal t ON t.ChID =i.ChID AND t.ProdId = d.ProdID AND t.SrcPosID_Inv = d.SrcPosID
			where i.ChID = 200110591 AND t.CodeID2 = 19 AND t.QtyRealRet > 0
			) gr group by ProdID
*/
	--SELECT 'Создался новый документ: возврат товара от получателя. №' + CAST(@DocID_Ret as Varchar(30)) + ' из РН №' + CAST((SELECT top 1 DocID FROM  Elit.dbo.t_Inv i where i.ChID = @ChID_Inv) as Varchar(30))
	
	--SELECT * FROM ElitDistr.dbo.t_Ret WHERE ChID = @ChID_Ret
	--SELECT * FROM ElitDistr.dbo.t_RetD WHERE ChID = @ChID_Ret
	
		--SELECT * FROM #TempRetFinal ORDER BY 1, 2
		SELECT * FROM #TempRetFinal 
		where ProdID = 28241
		ORDER BY 1, 2

	
	FETCH NEXT FROM CURSOR1 INTO @ChID_Inv, @CodeID2
END
CLOSE CURSOR1
DEALLOCATE CURSOR1



--для отладки
SELECT COUNT(*) 'итого возвратов' FROM ElitDistr.dbo.t_Ret WHERE DocDate = @DocDate
SELECT SUM(Qty) 'итого количество возвратов' FROM ElitDistr.dbo.t_RetD WHERE ChID in (SELECT ChID FROM ElitDistr.dbo.t_Ret WHERE DocDate = @DocDate)
SELECT * FROM ElitDistr.dbo.t_Ret WHERE DocDate = @DocDate
SELECT * FROM ElitDistr.dbo.t_RetD WHERE ChID in (SELECT ChID FROM ElitDistr.dbo.t_Ret WHERE DocDate = @DocDate)

ROLLBACK

IF @@TRANCOUNT > 0
  COMMIT
ELSE
BEGIN
  RAISERROR ('ВНИМАНИЕ!!! Работа инструмента завершилась ошибкой!', 10, 1)
  ROLLBACK
END 


END




/*
BEGIN TRAN

INSERT ElitDistr.dbo.t_Ret 
			SELECT top 1 
			--ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, SrcDocID, SrcDocDate, PayDelay, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, InDocID, TaxDocID, TaxDocDate, Address, DelivID, KursCC, TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, DriverID, CompAddID, LinkID, TerrID
			4906 ChID ,784903 DocID ,DocID IntDocID, '2018-04-01'  DocDate
			,KursMC, 
			1 OurID, 20 StockID, 10797 CompID, 63 CodeID1, 19 CodeID2, 
			CodeID3, CodeID4, CodeID5, EmpID, 
			ISNULL(Notes,'') + CASE WHEN 19 = 19 THEN ' Возврат ' ELSE ' Корректировка ' END + '- Создано новым скриптом' Notes, 
			Discount, 
			TaxDocID as SrcDocID, TaxDocDate as SrcDocDate, 
			PayDelay, CurrID, 0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 0 TSpendSumCC, 0 TRouteSumCC, 190 StateCode, InDocID, 
			0 TaxDocID, '2018-04-01' TaxDocDate, 
			Address, DelivID, KursCC, 0 TSumCC, DepID, 
			TaxDocID as SrcTaxDocID, TaxDocDate as SrcTaxDocDate, 
			DriverID, CompAddID, LinkID, TerrID --, MorePrc,   LetAttor,  OrderID, PayConditionID 
			FROM Elit.dbo.t_Inv i
			WHERE i.ChID = 200043028 and i.OurID = 1 


			SELECT * FROM  Elit.dbo.t_Inv i
			WHERE i.ChID = 200043028 and i.OurID = 1 

ROLLBACK TRAN


--количество товаров которое участвует в накладной
SELECT DNN, NNN, COUNT(*) count_prod FROM (
SELECT DNN, NNN,ProdID_Elit FROM #TempFindProdElitAll group by DNN, NNN, ProdID_Elit
)s1 group by DNN, NNN
ORDER BY 3 desc


SELECT * FROM #TempRetFinal where ChID = 200020530 and ProdID = 3499

SELECT max(ChID), max(SrcPosID_Inv), ProdID, max(PPID), max(UM), sum(Qty), max(PriceCC_nt), (sum(Qty) * max(PriceCC_nt)) SumCC_nt, max(Tax), (sum(Qty) * max(Tax)) TaxSum, max(PriceCC_wt), (sum(Qty) * max(PriceCC_wt)) SumCC_wt, max(BarCode), max(SecID) FROM (
SELECT 
--ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
1 ChID, t.SrcPosID_Inv, t.ProdID, t.PPID, d.UM, t.QtyRealRet Qty, d.PriceCC_nt, (d.PriceCC_nt * t.QtyRealRet) SumCC_nt, d.Tax, (d.Tax * t.QtyRealRet) TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.QtyRealRet) SumCC_wt, d.BarCode, d.SecID
FROM Elit.dbo.t_Inv i
JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
JOIN #TempRetFinal t ON t.ChID =i.ChID AND t.ProdId = d.ProdID AND t.SrcPosID_Inv = d.SrcPosID
where i.ChID = 200020530 AND t.CodeID2 = 19 AND t.QtyRealRet > 0
) gr group by ProdID 

SELECT * FROM Elit.dbo.t_Inv i
JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
JOIN #TempRetFinal t ON t.ChID =i.ChID AND t.ProdId = d.ProdID AND t.SrcPosID_Inv = d.SrcPosID
where i.ChID = 200020530 and d.ProdID = 3499

SELECT d.* FROM Elit.dbo.t_Inv i
JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
JOIN #TempRetFinal t ON t.ChID =i.ChID AND t.ProdId = d.ProdID AND t.SrcPosID_Inv = d.SrcPosID
ORDER BY 1,2,3,4

101534178	19
200020530	1	3499	137
200020530	2	3499	140
*/
--SELECT DocID, TaxDocDate, TaxDocID FROM #TempRetFinal	group BY DocID, TaxDocDate, TaxDocID ORDER BY 1,2

/*
--1. вытягиваем продажи в ElitR за 15 дней по кодам товаров которые участвуют в наборах
USE ElitR
--SELECT d.ProdID ProdIDMA, sum(d.Qty) tqty FROM t_Sale m
SELECT d.* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE 
--d.ProdID in (600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600267,600299,600712,600712,600721,600721,600731,600732,600742,600743,600744,600745,600757,600757,600758,600758,600758,600760,600760,600773,600773,600816,600816,600816,600832,600839,600839,600840,600840,600882,600883,600883,600884,600884,600884,600884,600884,600885,600885,600887,600891,600891,600892,600895,600895,600987,601070,601070,601078,601085,601085,601085,601085,601086,601095,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602507,602563,602563,602563,602564,602564,602669,602669,602755,602755,603053,603053,603053,603928,603936,603975,604603,604851,604979,604980,604980,800084,800084,800164,800164,800164,800165,800165,800594,800594,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,801952,802174,802185,802375,802376,802394,802399,802402,802408,802412,802412,802424,802424,802471,802484,802485,802486,802489,802489,802490,802490,802511,802650,802651,802656,802657,802705,802705,802751,802751,802752,802982,803013,803013,803016) 
d.ProdID in (600072) 
and m.DocDate between '2018-04-01' and '2018-04-15'
and m.CodeID1 = 63 
and m. CodeID3 <> 89
and m.OurID = 6
group by d.ProdID
ORDER BY 1
--ProdID	tqty
--600072	71.000000000
SELECT sum(ds.Qty) tqty FROM t_Sale ms JOIN t_SaleD ds ON ds.ChID = ms.ChID
WHERE ds.ProdID in (600712) and ms.DocDate between '2018-04-01' and '2018-04-15' and ms.CodeID1 = 63 and ms.CodeID3 <> 89 and ms.OurID = 6

--2. находим элитовские кода
SELECT distinct ec.ProdID , ec.ExtProdID
, (SELECT SUM(Qty) FROM ElitDistr.dbo.t_rem rem where rem.ProdID = ec.ProdID and rem.StockID = 20 and rem.OurID = 1 ) rem

FROM elit.dbo.r_ProdEC ec
where 
ISNUMERIC(ExtProdID)=1
and cast(ExtProdID as bigint) in (
600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600299,600712,600721,600731,600732,600742,600743,600744,600745,600757,600758,600760,600773,600816,600832,600840,600882,600883,600884,600885,600887,600891,600892,600895,601070,601078,601085,601086,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602563,602564,602669,602755,603053,603928,603936,604603,604851,604979,604980,800084,800164,800165,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,802174,802375,802376,802394,802399,802402,802408,802412,802424,802471,802484,802485,802486,802489,802490,802511,802650,802651,802656,802657,802705,802751,802982,803013,803016
--600712
)
ORDER BY 2
--ProdID
--4668
--30767
SELECT distinct ec.ProdID FROM elit.dbo.r_ProdEC ec
where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600712)
*/

----d.RealPrice минимальную
--SELECT d.ProdID, d.Qty, d.RealPrice, d.* FROM t_Sale m
--JOIN t_SaleD d ON d.ChID = m.ChID
--JOIN r_Prods p ON p.ProdID = d.ProdID
--WHERE 
----d.ProdID in (600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600267,600299,600712,600712,600721,600721,600731,600732,600742,600743,600744,600745,600757,600757,600758,600758,600758,600760,600760,600773,600773,600816,600816,600816,600832,600839,600839,600840,600840,600882,600883,600883,600884,600884,600884,600884,600884,600885,600885,600887,600891,600891,600892,600895,600895,600987,601070,601070,601078,601085,601085,601085,601085,601086,601095,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602507,602563,602563,602563,602564,602564,602669,602669,602755,602755,603053,603053,603053,603928,603936,603975,604603,604851,604979,604980,604980,800084,800084,800164,800164,800164,800165,800165,800594,800594,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,801952,802174,802185,802375,802376,802394,802399,802402,802408,802412,802412,802424,802424,802471,802484,802485,802486,802489,802489,802490,802490,802511,802650,802651,802656,802657,802705,802705,802751,802751,802752,802982,803013,803013,803016) 
--d.ProdID in (600712) 
--and m.DocDate between '2018-04-01' and '2018-04-15'
--and m.CodeID1 = 63 
--and m. CodeID3 <> 89
--and m.OurID = 6


----3. поиск РН по которым можно вернуть товар
--SELECT *, ISNULL(QtyInv,0) - ISNULL(vozv_Elit,0) - ISNULL(vozv_ElitDistr,0) as QtyRet 
--, (SELECT SUM(Qty) FROM ElitDistr.dbo.t_rem rem where rem.ProdID = s1.ProdID and rem.StockID = 20 and rem.OurID = 1 ) rem
--FROM (
--SELECT m.ChID, m.DocID,m.TaxDocID, m.TaxDocDate,d.ProdID, d.PPID, d.Qty QtyInv
--,(
--SELECT sum(dr.Qty) vozv_Elit FROM Elit.dbo.t_Ret mr
--JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
--WHERE mr.OurID = 1 and mr.CompID = 10797
--and mr.SrcTaxDocID = m.TaxDocID 
--and mr.SrcTaxDocDate= m.TaxDocDate
--and dr.ProdID = d.ProdID
--and dr.PPID = d.PPID
--GROUP BY dr.ProdID, dr.PPID
-- ) as vozv_Elit
-- ,(
--SELECT sum(dr.Qty) vozv_ElitDistr FROM ElitDistr.dbo.t_Ret mr
--JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
--WHERE mr.OurID = 1 and mr.CompID = 10797
--and mr.SrcTaxDocID = m.TaxDocID 
--and mr.SrcTaxDocDate= m.TaxDocDate
--and dr.ProdID = d.ProdID
--and dr.PPID = d.PPID
--GROUP BY dr.ProdID, dr.PPID
-- ) as vozv_ElitDistr
---- ,d.*, m.* 
--FROM Elit.dbo.t_Inv m
--JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
--WHERE m.OurID = 1 and m.CompID = 10797
--and m.DocDate between '2017-04-01' and '2018-03-31' --последний день предыдущего месяца
--and d.ProdID in (28578,30551,31134,32060,32791)
--and d.Qty > 0
----ORDER BY m.TaxDocDate,m.TaxDocID
--) s1
--where (ISNULL(QtyInv,0) - ISNULL(vozv_Elit,0) - ISNULL(vozv_ElitDistr,0)) > 0
----ORDER BY TaxDocDate
--ORDER BY ISNULL(vozv_Elit,0) + ISNULL(vozv_ElitDistr,0),10 desc



--DECLARE @ProdIDMA int = 600712
----600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600299,600712,600721,600731,600732,600742,600743,600744,600745,600757,600758,600760,600773,600816,600832,600840,600882,600883,600884,600885,600887,600891,600892,600895,601070,601078,601085,601086,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602563,602564,602669,602755,603053,603928,603936,604603,604851,604979,604980,800084,800164,800165,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,802174,802375,802376,802394,802399,802402,802408,802412,802424,802471,802484,802485,802486,802489,802490,802511,802650,802651,802656,802657,802705,802751,802982,803013,803016


--(SELECT sum(ISNULL(QtyInv,0) - ISNULL(vozv_Elit,0) - ISNULL(vozv_ElitDistr,0)) as TQtyRet 
--FROM (
--	SELECT m.ChID, m.DocID,m.TaxDocID, m.TaxDocDate,d.ProdID, d.PPID, d.Qty QtyInv
--	,(
--	SELECT sum(dr.Qty) vozv_Elit FROM Elit.dbo.t_Ret mr
--	JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
--	WHERE mr.OurID = 1 and mr.CompID = 10797
--	and mr.SrcTaxDocID = m.TaxDocID 
--	and mr.SrcTaxDocDate= m.TaxDocDate
--	and dr.ProdID = d.ProdID
--	and dr.PPID = d.PPID
--	GROUP BY dr.ProdID, dr.PPID
--	 ) as vozv_Elit
--	 ,(
--	SELECT sum(dr.Qty) vozv_ElitDistr FROM ElitDistr.dbo.t_Ret mr
--	JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
--	WHERE mr.OurID = 1 and mr.CompID = 10797
--	and mr.SrcTaxDocID = m.TaxDocID 
--	and mr.SrcTaxDocDate= m.TaxDocDate
--	and dr.ProdID = d.ProdID
--	and dr.PPID = d.PPID
--	GROUP BY dr.ProdID, dr.PPID
--	 ) as vozv_ElitDistr
--	-- ,d.*, m.* 
--	FROM Elit.dbo.t_Inv m
--	JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
--	WHERE m.OurID = 1 and m.CompID = 10797
--	and m.DocDate between '2017-04-01' and '2018-03-31' --последний день предыдущего месяца
--	and d.ProdID = 32060
--	and d.Qty > 0
--) s2 where (ISNULL(QtyInv,0) - ISNULL(vozv_Elit,0) - ISNULL(vozv_ElitDistr,0)) > 0
--) p1

