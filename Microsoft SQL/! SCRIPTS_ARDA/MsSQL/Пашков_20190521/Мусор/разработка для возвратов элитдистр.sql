-- поиск РН по которым можно вернуть товар
USE ElitR
--блок загрузки справочников
IF 1=0
BEGIN 
	IF OBJECT_ID (N'tempdb..#TempRet', N'U') IS NOT NULL DROP TABLE #TempRet
	CREATE TABLE #TempRet ( N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdIDMA_RealPrice NUMERIC(21,9), ChID INT, DocID INT, TaxDocID INT, TaxDocDate SMALLDATETIME, ProdID INT, PPID INT, QtyInv NUMERIC(21,9), vozv_Elit NUMERIC(21,9), vozv_ElitDistr NUMERIC(21,9), QtyRet NUMERIC(21,9), rem NUMERIC(21,9), abs_razn NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, SrcPosID_Inv INT, vozv_Medoc INT, sumQtyInv INT)

	IF OBJECT_ID (N'tempdb..#TempRetFinal', N'U') IS NOT NULL DROP TABLE #TempRetFinal
	CREATE TABLE #TempRetFinal ( N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdIDMA_RealPrice NUMERIC(21,9), ChID INT, DocID INT, TaxDocID INT, TaxDocDate SMALLDATETIME, ProdID INT, PPID INT, QtyInv NUMERIC(21,9), vozv_Elit NUMERIC(21,9), vozv_ElitDistr NUMERIC(21,9), QtyRet NUMERIC(21,9), rem NUMERIC(21,9), abs_razn NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, SrcPosID_Inv INT, vozv_Medoc INT, sumQtyInv INT)

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
	LEFT JOIN (SELECT ProdID, PPID, SUM(Qty) TQty FROM t_Rem where OurID = 1 and StockID = 20 group by ProdID, PPID) TRem on TRem.ProdID = r.ProdID and TRem.PPID = r.PPID
	WHERE r.ProdID IS NOT NULL and r.PPID <> 0 and r.Price  > 0
	--SELECT distinct ProdID FROM #Rec1 ORDER BY 1,2 --30916

	--загружаем справочник с медка по возвратам
	IF OBJECT_ID (N'tempdb..#Medoc_RET', N'U') IS NOT NULL DROP TABLE #Medoc_RET
	SELECT * 
	 INTO #Medoc_RET	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_Возвраты.xlsx' , 'select * from [Лист1$]') as ex;
    --SELECT * FROM #Medoc_RET

	--таблица исключений РН
	IF OBJECT_ID (N'tempdb..#NotInv', N'U') IS NOT NULL DROP TABLE #NotInv
	CREATE TABLE #NotInv (Num INT IDENTITY(1,1) NOT NULL ,TaxDocID INT null, TaxDocDate SMALLDATETIME null, ProdID INT NULL, Qty NUMERIC(21,9))
	INSERT #NotInv
	--="union all select "&C4&",'"&ТЕКСТ(D4;"ГГГГ-ММ-ДД")&"',"&H4&","&L4&""
	select 10109,'2017-10-31',31959,37
	union all select 2832,'2017-05-11',32111,1
	union all select 344,'2017-08-01',23774,20
	union all select 344,'2017-08-01',31957,24
	union all select 344,'2017-08-01',32993,12
	union all select 3614,'2017-04-11',3499,7
	union all select 3614,'2017-04-11',32655,39
	union all select 3614,'2017-04-11',31828,1
	union all select 3806,'2018-03-13',33255,3
	union all select 4398,'2017-11-14',33715,1
	union all select 4504,'2017-10-13',4149,5
	union all select 5036,'2017-05-16',32301,10
	union all select 513,'2018-02-02',32387,11
	union all select 5165,'2017-06-16',32236,1
	union all select 5355,'2018-03-16',28240,23
	union all select 6779,'2017-11-21',3499,12
	union all select 7092,'2017-07-21',32048,6
	union all select 7397,'2017-12-22',3499,10
	union all select 7397,'2017-12-22',30767,24
	union all select 7397,'2017-12-22',26136,31
	union all select 7500,'2017-05-23',28241,23
	union all select 7500,'2017-05-23',28574,4
	union all select 8248,'2017-04-24',31451,3
	union all select 8612,'2017-12-27',32573,4
	union all select 9624,'2017-12-29',32791,9
	union all select 9631,'2017-12-29',32993,11
	union all select 9798,'2017-09-29',32610,1
	union all select 9810,'2017-10-31',33300,4
		
	SELECT * FROM #NotInv
	    
    
END

--расчет для комплектации
IF 1=0
BEGIN

DECLARE @BDate SMALLDATETIME = '2018-04-01'
DECLARE @EDate SMALLDATETIME = '2018-04-15'
DECLARE @BDateInv SMALLDATETIME = '2017-03-01' --начало периода поиска по РН
DECLARE @EDateInv SMALLDATETIME = '2018-04-23' --конец периода поиска по РН
--DECLARE @LastDayMount SMALLDATETIME = '2018-03-31' --последний день предыдущего месяца
DECLARE @ProdIDMA INT --= 600832   --600712 600721 600757 600758 600760 600773 600816 600832 600840 600882
DECLARE @ProdID_Elit INT
DECLARE @ProdIDMA_Qty NUMERIC(21,9)
DECLARE @ProdIDMA_RealPrice NUMERIC(21,9)
DECLARE @ProdIDMA_SumQty NUMERIC(21,9) 

DECLARE @ChIDTable TABLE(ChID int NULL) 
INSERT INTO @ChIDTable 
	SELECT max(num) FROM #NotInv group by ProdID --для ручного подбора возвратов
	--SELECT AValue FROM dbo.zf_FilterToTable('600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600299,600712,600721,600731,600732,600742,600743,600744,600745,600757,600758,600760,600773,600816,600832,600840,600882,600883,600884,600885,600887,600891,600892,600895,601070,601078,601085,601086,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602563,602564,602669,602755,603053,603928,603936,604603,604851,604979,604980,800084,800164,800165,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,802174,802375,802376,802394,802399,802402,802408,802412,802424,802471,802484,802485,802486,802489,802490,802511,802650,802651,802656,802657,802705,802751,802982,803013,803016')
	--WHERE AValue in (601116) -- для отладки
--SELECT * FROM @ChIDTable
--ProdIDMA	ProdID	ProdIdNabor
--601116	3499	634070

DELETE #TempRet	
DELETE #TempRetFinal	
SET @ProdIDMA_SumQty = 0

DECLARE kalc CURSOR FOR
SELECT DISTINCT ChID FROM @ChIDTable ORDER BY 1
OPEN kalc
FETCH NEXT FROM kalc INTO @ProdIDMA 
 WHILE @@FETCH_STATUS = 0    		 
  BEGIN 
  
	IF 1=0
	BEGIN
	--кол проданных товаров которое будем возращать
	SELECT @ProdIDMA_Qty = ISNULL(sum(ds.Qty),0), @ProdIDMA_RealPrice = MIN(ds.RealPrice) FROM t_Sale ms JOIN t_SaleD ds ON ds.ChID = ms.ChID
	WHERE ds.ProdID in (@ProdIDMA) and ms.DocDate between @BDate and @EDate and ms.CodeID1 = 63 and ms.CodeID3 <> 89 and ms.OurID = 6
	--SELECT @ProdIDMA_Qty ProdIDMA_Qty ,@ProdIDMA_RealPrice ProdIDMA_RealPrice
	
	--КОРРЕКЦИЯ ПРОДАЖ 
	IF @ProdIDMA = 600712 SET @ProdIDMA_Qty = @ProdIDMA_Qty - 1
	
	--общее кол проданных товаров которое будем возращать (для контроля расчета)
	SELECT @ProdIDMA_SumQty = @ProdIDMA_SumQty + @ProdIDMA_Qty
	--SELECT @ProdIDMA_SumQty 
	
	--подбор элитовского товара по которому будет возврат
	SELECT top 1 @ProdID_Elit = ProdID FROM (
	SELECT ProdID
	,sum( ISNULL(QtyInv1,0) - CASE WHEN (ISNULL(vozv_Elit1,0)  +  ISNULL(vozv_ElitDistr1,0)) < vozv_Medoc THEN vozv_Medoc ELSE (ISNULL(vozv_Elit1,0)  +  ISNULL(vozv_ElitDistr1,0)) END ) sum_QtyRet
	,sum(ISNULL(vozv_Elit1,0)) sum_vozv_Elit1  
	,sum(ISNULL(vozv_ElitDistr1,0)) sum_vozv_ElitDistr1
	,sum(ISNULL(vozv_Elit1_count,0)) + sum(ISNULL(vozv_ElitDistr1_count,0)) sum_vozv_count  
	,count(ProdID)  sum_QtyInv1_count  
	FROM (
		SELECT d1.ProdID, d1.PPID, d1.Qty QtyInv1
			,(
			SELECT sum(dr.Qty) vozv_Elit FROM Elit.dbo.t_Ret mr
			JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m1.TaxDocID 
			and mr.SrcTaxDocDate= m1.TaxDocDate
			and dr.ProdID = d1.ProdID
			and dr.PPID = d1.PPID
			GROUP BY dr.ProdID, dr.PPID
			 ) as vozv_Elit1
			 ,(
			SELECT sum(dr.Qty) vozv_ElitDistr FROM ElitDistr.dbo.t_Ret mr
			JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m1.TaxDocID 
			and mr.SrcTaxDocDate= m1.TaxDocDate
			and dr.ProdID = d1.ProdID
			and dr.PPID = d1.PPID
			GROUP BY dr.ProdID, dr.PPID
			 ) as vozv_ElitDistr1
			,(
			SELECT count(dr.Qty) vozv_Elit1_count FROM Elit.dbo.t_Ret mr
			JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m1.TaxDocID 
			and mr.SrcTaxDocDate= m1.TaxDocDate
			and dr.ProdID = d1.ProdID
			and dr.PPID = d1.PPID
			GROUP BY dr.ProdID, dr.PPID
			 ) as vozv_Elit1_count
			 ,(
			SELECT count(dr.Qty) vozv_ElitDistr1_count FROM ElitDistr.dbo.t_Ret mr
			JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797-- and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m1.TaxDocID 
			and mr.SrcTaxDocDate= m1.TaxDocDate
			and dr.ProdID = d1.ProdID
			and dr.PPID = d1.PPID
			GROUP BY dr.ProdID, dr.PPID
			 ) as vozv_ElitDistr1_count
			/*,(SELECT SUM(medr.TAB1_A5)*-1 FROM #Medoc_RET medr 
			where medr.N2_11 = m1.TaxDocID 
			and medr.N2 = m1.TaxDocDate
			and medr.TAB1_A3 = (SELECT Notes FROM r_Prods  p where p.ProdID = d1.ProdID)
			group by medr.TAB1_A3)*/ ,0 as vozv_Medoc  
		FROM Elit.dbo.t_Inv m1
		JOIN Elit.dbo.t_InvD d1 ON d1.ChID = m1.ChID
		WHERE m1.OurID = 1 and m1.CompID = 10797 and m1.StateCode = 191 --только отправленые налоговые
		and m1.DocDate between @BDateInv and @EDateInv --последний день предыдущего месяца
		and d1.ProdID in (SELECT distinct ec.ProdID FROM elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA))
		and d1.ProdID in (SELECT distinct ProdID FROM #ProdIdNabor) -- только те товары что есть в справочнике наборов
		and d1.ProdID in (SELECT distinct ProdID FROM #Rec1) -- только те товары что есть в основном приходе
		and d1.Qty > 0
	) p1 
	where (ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0) - ISNULL(vozv_ElitDistr1,0)) > 0
	group by ProdID
	having sum(ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0)  - ISNULL(vozv_ElitDistr1,0))  >= @ProdIDMA_Qty
	)gr1
	ORDER BY sum_vozv_count, sum_QtyRet,sum_QtyInv1_count
	--SELECT @ProdID_Elit 'ProdID_Elit-выбрали этот товар в элитке'

	--для отладки (подбор элитовского товара по которому будет возврат)
	SELECT ProdID
	,sum( ISNULL(QtyInv1,0) - CASE WHEN (ISNULL(vozv_Elit1,0)  +  ISNULL(vozv_ElitDistr1,0)) < vozv_Medoc THEN vozv_Medoc ELSE (ISNULL(vozv_Elit1,0)  +  ISNULL(vozv_ElitDistr1,0)) END ) sum_QtyRet
	,sum(ISNULL(vozv_Elit1,0)) sum_vozv_Elit1  
	,sum(ISNULL(vozv_ElitDistr1,0)) sum_vozv_ElitDistr1
	,sum(ISNULL(vozv_Elit1_count,0)) + sum(ISNULL(vozv_ElitDistr1_count,0)) sum_vozv_count  
	,count(ProdID)  sum_QtyInv1_count  
	FROM (
		SELECT d1.ProdID, d1.PPID, d1.Qty QtyInv1
			,(
			SELECT sum(dr.Qty) vozv_Elit FROM Elit.dbo.t_Ret mr
			JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m1.TaxDocID 
			and mr.SrcTaxDocDate= m1.TaxDocDate
			and dr.ProdID = d1.ProdID
			and dr.PPID = d1.PPID
			GROUP BY dr.ProdID, dr.PPID
			 ) as vozv_Elit1
			 ,(
			SELECT sum(dr.Qty) vozv_ElitDistr FROM ElitDistr.dbo.t_Ret mr
			JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m1.TaxDocID 
			and mr.SrcTaxDocDate= m1.TaxDocDate
			and dr.ProdID = d1.ProdID
			and dr.PPID = d1.PPID
			GROUP BY dr.ProdID, dr.PPID
			 ) as vozv_ElitDistr1
			,(
			SELECT count(dr.Qty) vozv_Elit1_count FROM Elit.dbo.t_Ret mr
			JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m1.TaxDocID 
			and mr.SrcTaxDocDate= m1.TaxDocDate
			and dr.ProdID = d1.ProdID
			and dr.PPID = d1.PPID
			GROUP BY dr.ProdID, dr.PPID
			 ) as vozv_Elit1_count
			 ,(
			SELECT count(dr.Qty) vozv_ElitDistr1_count FROM ElitDistr.dbo.t_Ret mr
			JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m1.TaxDocID 
			and mr.SrcTaxDocDate= m1.TaxDocDate
			and dr.ProdID = d1.ProdID
			and dr.PPID = d1.PPID
			GROUP BY dr.ProdID, dr.PPID
			 ) as vozv_ElitDistr1_count
			/*,(SELECT SUM(medr.TAB1_A5)*-1 FROM #Medoc_RET medr 
			where medr.N2_11 = m1.TaxDocID 
			and medr.N2 = m1.TaxDocDate
			and medr.TAB1_A3 = (SELECT Notes FROM r_Prods  p where p.ProdID = d1.ProdID)
			group by medr.TAB1_A3)*/ ,0 as vozv_Medoc  
		FROM Elit.dbo.t_Inv m1
		JOIN Elit.dbo.t_InvD d1 ON d1.ChID = m1.ChID
		WHERE m1.OurID = 1 and m1.CompID = 10797 and m1.StateCode = 191 --только отправленые налоговые
		and m1.DocDate between @BDateInv and '2018-03-31' --последний день предыдущего месяца
		and d1.ProdID in (SELECT distinct ec.ProdID FROM elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA))
		and d1.ProdID in (SELECT distinct ProdID FROM #ProdIdNabor) -- только те товары что есть в справочнике наборов
		and d1.ProdID in (SELECT distinct ProdID FROM #Rec1) -- только те товары что есть в основном приходе
		and d1.Qty > 0
	) p1 
	where (ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0) - ISNULL(vozv_ElitDistr1,0)) > 0
	group by ProdID
	having sum(ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0)  - ISNULL(vozv_ElitDistr1,0))  >= @ProdIDMA_Qty
	ORDER BY sum_vozv_count, sum_QtyRet,sum_QtyInv1_count

	END
	
--для ручного подбора возвратов
SELECT  @ProdID_Elit = (SELECT ProdID FROM #NotInv where Num = @ProdIDMA)
SELECT  @ProdIDMA_Qty = (SELECT sum(Qty) FROM #NotInv i where i.ProdID = (SELECT ProdID FROM #NotInv where Num = @ProdIDMA))
SELECT @ProdID_Elit ProdID_Elit, @ProdIDMA_Qty ProdIDMA_Qty


	--список РН по которым делать возврат
	INSERT INTO #TempRet (N, ProdIDMA, ProdIDMA_Qty, ProdIDMA_RealPrice, ChID, DocID, TaxDocID, TaxDocDate, ProdID, PPID, QtyInv, vozv_Elit, vozv_ElitDistr, QtyRet, rem, abs_razn, QtyRealRet, CodeID2, SrcPosID_Inv, vozv_Medoc, sumQtyInv)
		SELECT 
			ROW_NUMBER()OVER(ORDER BY ProdID, ISNULL(vozv_Elit,0) + ISNULL(vozv_ElitDistr,0), ABS( QtyRet - ProdIDMA_Qty) , QtyRet desc) N,
			ProdIDMA, ProdIDMA_Qty, ProdIDMA_RealPrice, ChID, DocID, TaxDocID, TaxDocDate, ProdID, PPID, QtyInv, vozv_Elit, vozv_ElitDistr, QtyRet, rem,
			abs(QtyRet - ProdIDMA_Qty) abs_razn , 0 QtyRealRet, 0 CodeID2 , SrcPosID_Inv, vozv_Medoc, sumQtyInv 
		FROM (
			SELECT 
				@ProdIDMA ProdIDMA
				, (
				SELECT sum(ds.Qty) FROM t_Sale ms JOIN t_SaleD ds ON ds.ChID = ms.ChID
				WHERE ds.ProdID in (@ProdIDMA) and ms.DocDate between @BDate and @EDate and ms.CodeID1 = 63 and ms.CodeID3 <> 89 and ms.OurID = 6
				 ) ProdIDMA_Qty
				, @ProdIDMA_RealPrice ProdIDMA_RealPrice
				, ChID, DocID, TaxDocID, TaxDocDate, ProdID, PPID, QtyInv, vozv_Elit, vozv_ElitDistr
				, ISNULL(QtyInv,0) - ISNULL(vozv_Elit,0) - ISNULL(vozv_ElitDistr,0) as QtyRet 
				, (SELECT SUM(Qty) FROM ElitDistr.dbo.t_rem rem where rem.ProdID = s1.ProdID and rem.StockID = 20 and rem.OurID = 1 ) rem
				,SrcPosID_Inv, vozv_Medoc, sumQtyInv 
			FROM (
				SELECT 
					m.ChID, m.DocID,m.TaxDocID, m.TaxDocDate,d.ProdID, d.PPID, d.Qty QtyInv
					,(
					SELECT sum(dr.Qty) vozv_Elit FROM Elit.dbo.t_Ret mr
					JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
					WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
					and mr.SrcTaxDocID = m.TaxDocID 
					and mr.SrcTaxDocDate= m.TaxDocDate
					and dr.ProdID = d.ProdID
					and dr.PPID = d.PPID
					GROUP BY dr.ProdID, dr.PPID
					) as vozv_Elit
					,(
					SELECT sum(dr.Qty) vozv_ElitDistr FROM ElitDistr.dbo.t_Ret mr
					JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
					WHERE mr.OurID = 1 and mr.CompID = 10797 --and mr.StateCode = 191 --только отправленые налоговые
					and mr.SrcTaxDocID = m.TaxDocID 
					and mr.SrcTaxDocDate= m.TaxDocDate
					and dr.ProdID = d.ProdID
					and dr.PPID = d.PPID
					GROUP BY dr.ProdID, dr.PPID
					 ) as vozv_ElitDistr
					,d.SrcPosID SrcPosID_Inv
					
					--суммарный возврат из медка по налоговой накладной
					,(SELECT SUM(medr.TAB1_A5)*-1 FROM #Medoc_RET medr 
					where medr.N2_11 = m.TaxDocID 
					and medr.N2 = m.TaxDocDate
					and medr.TAB1_A3 = (SELECT Notes FROM ElitDistr.dbo.r_Prods  p where p.ProdID = d.ProdID)
					group by medr.TAB1_A3) as vozv_Medoc  
					
					--суммарное кол по налоговой накладной
					,(SELECT SUM(eid.Qty) FROM Elit.dbo.t_InvD eid where eid.ChID = d.ChID and eid.ProdID = d.ProdID) as sumQtyInv
	 
				FROM Elit.dbo.t_Inv m
				JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
				WHERE m.OurID = 1 and m.CompID = 10797 and m.StateCode = 191 --только отправленые налоговые
				and m.DocDate between @BDateInv and @EDateInv --последний день предыдущего месяца
				and d.ProdID in (@ProdID_Elit)
				and d.Qty > 0
				and Not EXISTS (SELECT top 1 1 FROM #NotInv  ni WHERE ni.TaxDocID = m.TaxDocID and ni.TaxDocDate = m.TaxDocDate ) --исключить некоторые налоговые накладные
				--ORDER BY m.TaxDocDate,m.TaxDocID
			) s1
		where (ISNULL(QtyInv,0) - ISNULL(vozv_Elit,0) - ISNULL(vozv_ElitDistr,0)) > 0
		and ISNULL(vozv_Medoc,0) < sumQtyInv
		
		--ORDER BY TaxDocDate
		--ORDER BY ISNULL(vozv_Elit,0) + ISNULL(vozv_ElitDistr,0),QtyRet desc
		)s2
		--where  TQtyRet > s2.ProdIDMA_Qty
		--ORDER BY ProdID, ISNULL(vozv_Elit,0) + ISNULL(vozv_ElitDistr,0), ABS( QtyRet - ProdIDMA_Qty) , QtyRet desc
	
	
	DECLARE @QtyRet NUMERIC(21,9), @SrcPosID INT, @TQty NUMERIC(21,9)
	SET @TQty = @ProdIDMA_Qty 
	
	DECLARE CURSOR2 CURSOR LOCAL FAST_FORWARD FOR 
		SELECT N, QtyRet FROM #TempRet WITH (NOLOCK) ORDER BY 1
	OPEN CURSOR2
		FETCH NEXT FROM CURSOR2 INTO @SrcPosID, @QtyRet
	WHILE @@FETCH_STATUS = 0 AND @TQty > 0
	BEGIN
		--Script
		IF @QtyRet <= @TQty 
		BEGIN
			UPDATE #TempRet 
			SET QtyRealRet = @QtyRet 
			,CodeID2 = CASE WHEN QtyRet = @QtyRet THEN 19 ELSE 44 END --определить признак 2 по позициям
			WHERE N = @SrcPosID
		END
		ELSE
			UPDATE #TempRet 
			SET QtyRealRet = @TQty 
			,CodeID2 = CASE WHEN QtyRet = @TQty THEN 19 ELSE 44 END --определить признак 2 по позициям
			WHERE N = @SrcPosID
		
		SET @TQty = @TQty - @QtyRet
		
		FETCH NEXT FROM CURSOR2	INTO @SrcPosID, @QtyRet
	END
	CLOSE CURSOR2
	DEALLOCATE CURSOR2


	SELECT * FROM #TempRet	
	
	INSERT INTO #TempRetFinal --(N, ProdIDMA, ProdIDMA_Qty, ProdIDMA_RealPrice, ChID, DocID, TaxDocID, TaxDocDate, ProdID, PPID, QtyInv, vozv_Elit, vozv_ElitDistr, QtyRet, rem, abs_razn, QtyRealRet, CodeID2, SrcPosID_Inv, vozv_Medoc)
		SELECT * FROM #TempRet WHERE QtyRealRet <> 0
	
	DELETE #TempRet	
	     
      
     FETCH NEXT FROM kalc INTO @ProdIDMA 
  END
CLOSE kalc
DEALLOCATE kalc



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
*/
END

--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--Возвраты
IF 1=0
BEGIN
BEGIN TRAN

DECLARE @DocDate SMALLDATETIME = '2018-04-01' --дата возврата (два раза в месяц)

	--добавить отсутствующие партии в t_PInP из elit для возвратов
	INSERT ElitDistr.dbo.t_PInP (ProdID,PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,DLSDate,IsCommission,CostMC,PriceAC_In,IsCert,FEAProdID,ProdBarCode,PPHumidity,PPImpurity,CustDocNum,CustDocDate)
		SELECT p.ProdID,p.PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,DLSDate,IsCommission,CostMC,PriceAC_In,IsCert,CstProdCode,ProdBarCode,PPHumidity,PPImpurity,CustDocNum,CstDocDate 
		FROM [Elit].dbo.t_PInP p
		join #TempRetFinal exc on exc.ProdID = p.ProdID and exc.PPID = p.PPID 
		where not EXISTS ( SELECT * FROM ElitDistr.dbo.t_PInP dp where  dp.ProdID = p.ProdID and dp.PPID = p.PPID )

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
		
			--SELECT 
			----ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
			--@ChID_Ret ChID, t.SrcPosID_Inv, t.ProdID, t.PPID, d.UM, t.QtyRealRet Qty, d.PriceCC_nt, (d.PriceCC_nt * t.QtyRealRet) SumCC_nt, d.Tax, (d.Tax * t.QtyRealRet) TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.QtyRealRet) SumCC_wt, d.BarCode, d.SecID
			--FROM Elit.dbo.t_Inv i
			--JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
			--JOIN #TempRetFinal t ON t.ChID =i.ChID AND t.ProdId = d.ProdID AND t.SrcPosID_Inv = d.SrcPosID
			--where i.ChID = @ChID_Inv AND t.CodeID2 = @CodeID2 AND t.QtyRealRet > 0
	--END
			--для отладки
			SELECT max(ChID), max(SrcPosID_Inv), ProdID, max(PPID), max(UM), sum(Qty), max(PriceCC_nt), (sum(Qty) * max(PriceCC_nt)) SumCC_nt, max(Tax), (sum(Qty) * max(Tax)) TaxSum, max(PriceCC_wt), (sum(Qty) * max(PriceCC_wt)) SumCC_wt, max(BarCode), max(SecID) FROM (
			SELECT 
			--ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
			@ChID_Ret ChID, t.SrcPosID_Inv, t.ProdID, t.PPID, d.UM, t.QtyRealRet Qty, d.PriceCC_nt, (d.PriceCC_nt * t.QtyRealRet) SumCC_nt, d.Tax, (d.Tax * t.QtyRealRet) TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.QtyRealRet) SumCC_wt, d.BarCode, d.SecID
			FROM Elit.dbo.t_Inv i
			JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
			JOIN #TempRetFinal t ON t.ChID =i.ChID AND t.ProdId = d.ProdID AND t.SrcPosID_Inv = d.SrcPosID
			where i.ChID = @ChID_Inv AND t.CodeID2 = @CodeID2 AND t.QtyRealRet > 0
			) gr group by ProdID 

	SELECT 'Создался новый документ: возврат товара от получателя. №' + CAST(@DocID_Ret as Varchar(30)) + ' из РН №' + CAST((SELECT top 1 DocID FROM  Elit.dbo.t_Inv i where i.ChID = @ChID_Inv) as Varchar(30))
	
	SELECT * FROM ElitDistr.dbo.t_Ret WHERE ChID = @ChID_Ret
	SELECT * FROM ElitDistr.dbo.t_RetD WHERE ChID = @ChID_Ret
	
	
	FETCH NEXT FROM CURSOR1 INTO @ChID_Inv, @CodeID2
END
CLOSE CURSOR1
DEALLOCATE CURSOR1


--для отладки
--ROLLBACK

IF @@TRANCOUNT > 0
  COMMIT
ELSE
BEGIN
  RAISERROR ('ВНИМАНИЕ!!! Работа инструмента завершилась ошибкой!', 18, 1)
  ROLLBACK
END 


END





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

