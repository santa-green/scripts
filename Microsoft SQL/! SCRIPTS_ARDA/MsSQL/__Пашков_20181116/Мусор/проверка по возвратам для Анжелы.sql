-- поиск –Ќ по которым можно вернуть товар
USE ElitR
DECLARE @BDate SMALLDATETIME = '2018-04-01'
DECLARE @EDate SMALLDATETIME = '2018-04-15'
DECLARE @LastDayMount SMALLDATETIME = '2018-03-31' --последний день предыдущего мес€ца
DECLARE @ProdIDMA INT = 600832   --600712 600721 600757 600758 600760 600773 600816 600832 600840 600882
DECLARE @ProdID_Elit INT
DECLARE @ProdIDMA_Qty NUMERIC(21,9)
DECLARE @ProdIDMA_RealPrice NUMERIC(21,9)

IF OBJECT_ID (N'tempdb..#TempRet', N'U') IS NOT NULL DROP TABLE #TempRet
CREATE TABLE #TempRet ( N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdIDMA_RealPrice NUMERIC(21,9), ChID INT, DocID INT, TaxDocID INT, TaxDocDate SMALLDATETIME, ProdID INT, PPID INT, QtyInv NUMERIC(21,9), vozv_Elit NUMERIC(21,9), vozv_ElitDistr NUMERIC(21,9), QtyRet NUMERIC(21,9), rem NUMERIC(21,9), abs_razn NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT)

IF OBJECT_ID (N'tempdb..#TempRetFinal', N'U') IS NOT NULL DROP TABLE #TempRetFinal
CREATE TABLE #TempRetFinal ( N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdIDMA_RealPrice NUMERIC(21,9), ChID INT, DocID INT, TaxDocID INT, TaxDocDate SMALLDATETIME, ProdID INT, PPID INT, QtyInv NUMERIC(21,9), vozv_Elit NUMERIC(21,9), vozv_ElitDistr NUMERIC(21,9), QtyRet NUMERIC(21,9), rem NUMERIC(21,9), abs_razn NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT)

----загружаем справочник по наборам
--IF OBJECT_ID (N'tempdb..#ProdIdNabor', N'U') IS NOT NULL DROP TABLE #ProdIdNabor
--CREATE TABLE #ProdIdNabor(ProdIDMA int null, ProdID int null, ProdIdNabor int null, ProdName varchar(250))
--INSERT #ProdIdNabor
--	SELECT distinct * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\—правочник_наборов.xlsx' , 'select * from [Ћист1$]') as ex;


DECLARE @ChIDTable TABLE(ChID int NULL) 
INSERT INTO @ChIDTable 
	SELECT AValue FROM dbo.zf_FilterToTable('28241,28957,28978,29054,31324,31348,31853,31910,31927,31965,32317,32551,32573,32595,32655')
	--WHERE AValue in (28241) -- дл€ отладки
--SELECT * FROM @ChIDTable


DECLARE kalc CURSOR FOR
SELECT DISTINCT ChID FROM @ChIDTable ORDER BY 1
OPEN kalc
FETCH NEXT FROM kalc INTO @ProdIDMA 
 WHILE @@FETCH_STATUS = 0    		 
  BEGIN  
	----кол проданных товаров которое будем возращать
	--SELECT @ProdIDMA_Qty = ISNULL(sum(ds.Qty),0), @ProdIDMA_RealPrice = MIN(ds.RealPrice) FROM t_Sale ms JOIN t_SaleD ds ON ds.ChID = ms.ChID
	--WHERE ds.ProdID in (@ProdIDMA) and ms.DocDate between @BDate and @EDate and ms.CodeID1 = 63 and ms.CodeID3 <> 89 and ms.OurID = 6
	----SELECT @ProdIDMA_Qty ProdIDMA_Qty ,@ProdIDMA_RealPrice ProdIDMA_RealPrice
	
	---- ќ––≈ ÷»я ѕ–ќƒј∆ 
	--IF @ProdIDMA = 600712 SET @ProdIDMA_Qty = @ProdIDMA_Qty - 1
	
	----подбор элитовского товара по которому будет возврат
	--SELECT top 1 @ProdID_Elit = ProdID FROM (
	--SELECT ProdID
	--,sum(ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0)  - ISNULL(vozv_ElitDistr1,0)) sum_QtyRet
	--,sum(ISNULL(vozv_Elit1,0)) sum_vozv_Elit1  
	--,sum(ISNULL(vozv_ElitDistr1,0)) sum_vozv_ElitDistr1
	--,sum(ISNULL(vozv_Elit1_count,0)) + sum(ISNULL(vozv_ElitDistr1_count,0)) sum_vozv_count  
	--,count(ProdID)  sum_QtyInv1_count  
	--FROM (
	--	SELECT d1.ProdID, d1.PPID, d1.Qty QtyInv1
	--	,(
	--	SELECT sum(dr.Qty) vozv_Elit FROM Elit.dbo.t_Ret mr
	--	JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
	--	WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
	--	and mr.SrcTaxDocID = m1.TaxDocID 
	--	and mr.SrcTaxDocDate= m1.TaxDocDate
	--	and dr.ProdID = d1.ProdID
	--	and dr.PPID = d1.PPID
	--	GROUP BY dr.ProdID, dr.PPID
	--	 ) as vozv_Elit1
	--	 ,(
	--	SELECT sum(dr.Qty) vozv_ElitDistr FROM ElitDistr.dbo.t_Ret mr
	--	JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
	--	WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
	--	and mr.SrcTaxDocID = m1.TaxDocID 
	--	and mr.SrcTaxDocDate= m1.TaxDocDate
	--	and dr.ProdID = d1.ProdID
	--	and dr.PPID = d1.PPID
	--	GROUP BY dr.ProdID, dr.PPID
	--	 ) as vozv_ElitDistr1
	--	,(
	--	SELECT count(dr.Qty) vozv_Elit1_count FROM Elit.dbo.t_Ret mr
	--	JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
	--	WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
	--	and mr.SrcTaxDocID = m1.TaxDocID 
	--	and mr.SrcTaxDocDate= m1.TaxDocDate
	--	and dr.ProdID = d1.ProdID
	--	and dr.PPID = d1.PPID
	--	GROUP BY dr.ProdID, dr.PPID
	--	 ) as vozv_Elit1_count
	--	 ,(
	--	SELECT count(dr.Qty) vozv_ElitDistr1_count FROM ElitDistr.dbo.t_Ret mr
	--	JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
	--	WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
	--	and mr.SrcTaxDocID = m1.TaxDocID 
	--	and mr.SrcTaxDocDate= m1.TaxDocDate
	--	and dr.ProdID = d1.ProdID
	--	and dr.PPID = d1.PPID
	--	GROUP BY dr.ProdID, dr.PPID
	--	 ) as vozv_ElitDistr1_count
	--	FROM Elit.dbo.t_Inv m1
	--	JOIN Elit.dbo.t_InvD d1 ON d1.ChID = m1.ChID
	--	WHERE m1.OurID = 1 and m1.CompID = 10797 and m1.StateCode = 191 --только отправленые налоговые
	--	and m1.DocDate between '2017-04-01' and @LastDayMount --последний день предыдущего мес€ца
	--	and d1.ProdID in (SELECT distinct ec.ProdID FROM elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA))
	--	and d1.ProdID in (SELECT distinct ProdID FROM #ProdIdNabor) -- только те товары что есть в справочнике наборов
	--	and d1.Qty > 0
	--) p1 
	--where (ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0) - ISNULL(vozv_ElitDistr1,0)) > 0
	--group by ProdID
	--having sum(ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0)  - ISNULL(vozv_ElitDistr1,0))  >= @ProdIDMA_Qty
	--)gr1
	--ORDER BY sum_vozv_count, sum_QtyRet,sum_QtyInv1_count
	----SELECT @ProdID_Elit 'ProdID_Elit-выбрали этот товар в элитке'

	----дл€ отладки
	--SELECT ProdID
	--,sum(ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0)  - ISNULL(vozv_ElitDistr1,0)) sum_QtyRet
	--,sum(ISNULL(vozv_Elit1,0)) sum_vozv_Elit1  
	--,sum(ISNULL(vozv_ElitDistr1,0)) sum_vozv_ElitDistr1
	--,sum(ISNULL(vozv_Elit1_count,0)) + sum(ISNULL(vozv_ElitDistr1_count,0)) sum_vozv_count  
	--,count(ProdID)  sum_QtyInv1_count  
	--FROM (
	--	SELECT d1.ProdID, d1.PPID, d1.Qty QtyInv1
	--	,(
	--	SELECT sum(dr.Qty) vozv_Elit FROM Elit.dbo.t_Ret mr
	--	JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
	--	WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
	--	and mr.SrcTaxDocID = m1.TaxDocID 
	--	and mr.SrcTaxDocDate= m1.TaxDocDate
	--	and dr.ProdID = d1.ProdID
	--	and dr.PPID = d1.PPID
	--	GROUP BY dr.ProdID, dr.PPID
	--	 ) as vozv_Elit1
	--	 ,(
	--	SELECT sum(dr.Qty) vozv_ElitDistr FROM ElitDistr.dbo.t_Ret mr
	--	JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
	--	WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
	--	and mr.SrcTaxDocID = m1.TaxDocID 
	--	and mr.SrcTaxDocDate= m1.TaxDocDate
	--	and dr.ProdID = d1.ProdID
	--	and dr.PPID = d1.PPID
	--	GROUP BY dr.ProdID, dr.PPID
	--	 ) as vozv_ElitDistr1
	--	,(
	--	SELECT count(dr.Qty) vozv_Elit1_count FROM Elit.dbo.t_Ret mr
	--	JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
	--	WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
	--	and mr.SrcTaxDocID = m1.TaxDocID 
	--	and mr.SrcTaxDocDate= m1.TaxDocDate
	--	and dr.ProdID = d1.ProdID
	--	and dr.PPID = d1.PPID
	--	GROUP BY dr.ProdID, dr.PPID
	--	 ) as vozv_Elit1_count
	--	 ,(
	--	SELECT count(dr.Qty) vozv_ElitDistr1_count FROM ElitDistr.dbo.t_Ret mr
	--	JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
	--	WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
	--	and mr.SrcTaxDocID = m1.TaxDocID 
	--	and mr.SrcTaxDocDate= m1.TaxDocDate
	--	and dr.ProdID = d1.ProdID
	--	and dr.PPID = d1.PPID
	--	GROUP BY dr.ProdID, dr.PPID
	--	 ) as vozv_ElitDistr1_count
	--	FROM Elit.dbo.t_Inv m1
	--	JOIN Elit.dbo.t_InvD d1 ON d1.ChID = m1.ChID
	--	WHERE m1.OurID = 1 and m1.CompID = 10797 and m1.StateCode = 191 --только отправленые налоговые
	--	and m1.DocDate between '2017-04-01' and '2018-03-31' --последний день предыдущего мес€ца
	--	and d1.ProdID in (SELECT distinct ec.ProdID FROM elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA))
	--	and d1.Qty > 0
	--) p1 
	--where (ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0) - ISNULL(vozv_ElitDistr1,0)) > 0
	--group by ProdID
	--having sum(ISNULL(QtyInv1,0) - ISNULL(vozv_Elit1,0)  - ISNULL(vozv_ElitDistr1,0))  >= @ProdIDMA_Qty
	--ORDER BY sum_vozv_count, sum_QtyRet,sum_QtyInv1_count

SELECT @ProdID_Elit = @ProdIDMA

	--список –Ќ по которым делать возврат
	--INSERT INTO #TempRet (N, ProdIDMA, ProdIDMA_Qty, ProdIDMA_RealPrice, ChID, DocID, TaxDocID, TaxDocDate, ProdID, /*PPID,*/ QtyInv, vozv_Elit, vozv_ElitDistr, QtyRet, rem, abs_razn, QtyRealRet, CodeID2)
		SELECT 
		ROW_NUMBER()OVER(ORDER BY ProdID, ISNULL(vozv_Elit,0) + ISNULL(vozv_ElitDistr,0), ABS( QtyRet - ProdIDMA_Qty) , QtyRet desc) N,
		*, abs(QtyRet - ProdIDMA_Qty) abs_razn , 0 QtyRealRet, 0 CodeID2 FROM (
			SELECT 
			@ProdIDMA ProdIDMA
			, (
			SELECT sum(ds.Qty) FROM t_Sale ms JOIN t_SaleD ds ON ds.ChID = ms.ChID
			WHERE ds.ProdID in (@ProdIDMA) and ms.DocDate between @BDate and @EDate and ms.CodeID1 = 63 and ms.CodeID3 <> 89 and ms.OurID = 6
			 ) ProdIDMA_Qty
			, @ProdIDMA_RealPrice ProdIDMA_RealPrice
			, *, ISNULL(QtyInv,0) - ISNULL(vozv_Elit,0) - ISNULL(vozv_ElitDistr,0) as QtyRet 
			, (SELECT SUM(Qty) FROM ElitDistr.dbo.t_rem rem where rem.ProdID = s1.ProdID and rem.StockID = 20 and rem.OurID = 1 ) rem
			FROM (
			SELECT m.ChID, m.DocID,m.TaxDocID, m.TaxDocDate,d.ProdID, /*d.PPID,*/ d.Qty QtyInv
			,(
			SELECT sum(dr.Qty) vozv_Elit FROM Elit.dbo.t_Ret mr
			JOIN Elit.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m.TaxDocID 
			and mr.SrcTaxDocDate= m.TaxDocDate
			and dr.ProdID = d.ProdID
			--and dr.PPID = d.PPID
			GROUP BY dr.ProdID--, dr.PPID
			 ) as vozv_Elit
			 ,(
			SELECT sum(dr.Qty) vozv_ElitDistr FROM ElitDistr.dbo.t_Ret mr
			JOIN ElitDistr.dbo.t_RetD dr ON dr.ChID = mr.ChID
			WHERE mr.OurID = 1 and mr.CompID = 10797 and mr.StateCode = 191 --только отправленые налоговые
			and mr.SrcTaxDocID = m.TaxDocID 
			and mr.SrcTaxDocDate= m.TaxDocDate
			and dr.ProdID = d.ProdID
			--and dr.PPID = d.PPID
			GROUP BY dr.ProdID--, dr.PPID
			 ) as vozv_ElitDistr
			FROM Elit.dbo.t_Inv m
			JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
			WHERE m.OurID = 1 and m.CompID = 10797 and m.StateCode = 191 --только отправленые налоговые
			and m.DocDate between '2017-04-01' and @LastDayMount --последний день предыдущего мес€ца
			and d.ProdID in (@ProdID_Elit)
			and d.Qty > 0
			and m.TaxDocID = 8248
			--ORDER BY m.TaxDocDate,m.TaxDocID
			) s1
		where (ISNULL(QtyInv,0) - ISNULL(vozv_Elit,0) - ISNULL(vozv_ElitDistr,0)) > 0
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
			,CodeID2 = CASE WHEN QtyRet = @QtyRet THEN 19 ELSE 44 END --определить признак 2 по позици€м
			WHERE N = @SrcPosID
		END
		ELSE
			UPDATE #TempRet 
			SET QtyRealRet = @TQty 
			,CodeID2 = CASE WHEN QtyRet = @TQty THEN 19 ELSE 44 END --определить признак 2 по позици€м
			WHERE N = @SrcPosID
		
		SET @TQty = @TQty - @QtyRet
		
		FETCH NEXT FROM CURSOR2	INTO @SrcPosID, @QtyRet
	END
	CLOSE CURSOR2
	DEALLOCATE CURSOR2


	--SELECT * FROM #TempRet	
	
	--INSERT INTO #TempRetFinal (N, ProdIDMA, ProdIDMA_Qty, ProdIDMA_RealPrice, ChID, DocID, TaxDocID, TaxDocDate, ProdID, PPID, QtyInv, vozv_Elit, vozv_ElitDistr, QtyRet, rem, abs_razn, QtyRealRet, CodeID2)
	--	SELECT * FROM #TempRet WHERE QtyRealRet <> 0
	
	--DELETE #TempRet	
	     
      
     FETCH NEXT FROM kalc INTO @ProdIDMA 
  END
CLOSE kalc
DEALLOCATE kalc



--SELECT * FROM #TempRetFinal	

--SELECT ProdIDMA, ProdIdNabor, SUM(QtyRet) QtyRet, ProdId, MIN(PriceShop) PriceShop , MIN(Price) Price FROM (
--	SELECT ProdIDMA ProdIDMA, (SELECT top 1 ProdIdNabor FROM #ProdIdNabor pn where pn.ProdID = trf.ProdID)	ProdIdNabor,	QtyRealRet QtyRet,	ProdID ProdId, trf.PPID,	ProdIDMA_RealPrice PriceShop,	ProdIDMA_RealPrice/1.05/1.2 Price
--	FROM #TempRetFinal trf	
--) gr
--group by ProdIDMA, ProdIdNabor, ProdId
--ORDER BY ProdIdNabor

--SELECT DocID, TaxDocDate, TaxDocID FROM #TempRetFinal	group BY DocID, TaxDocDate, TaxDocID ORDER BY 1,2

/*
--1. выт€гиваем продажи в ElitR за 15 дней по кодам товаров которые участвуют в наборах
USE ElitR
SELECT d.ProdID ProdIDMA, sum(d.Qty) tqty FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE 
d.ProdID in (600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600267,600299,600712,600712,600721,600721,600731,600732,600742,600743,600744,600745,600757,600757,600758,600758,600758,600760,600760,600773,600773,600816,600816,600816,600832,600839,600839,600840,600840,600882,600883,600883,600884,600884,600884,600884,600884,600885,600885,600887,600891,600891,600892,600895,600895,600987,601070,601070,601078,601085,601085,601085,601085,601086,601095,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602507,602563,602563,602563,602564,602564,602669,602669,602755,602755,603053,603053,603053,603928,603936,603975,604603,604851,604979,604980,604980,800084,800084,800164,800164,800164,800165,800165,800594,800594,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,801952,802174,802185,802375,802376,802394,802399,802402,802408,802412,802412,802424,802424,802471,802484,802485,802486,802489,802489,802490,802490,802511,802650,802651,802656,802657,802705,802705,802751,802751,802752,802982,803013,803013,803016) 
--d.ProdID in (600712) 
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


----3. поиск –Ќ по которым можно вернуть товар
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
--and m.DocDate between '2017-04-01' and '2018-03-31' --последний день предыдущего мес€ца
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
--	and m.DocDate between '2017-04-01' and '2018-03-31' --последний день предыдущего мес€ца
--	and d.ProdID = 32060
--	and d.Qty > 0
--) s2 where (ISNULL(QtyInv,0) - ISNULL(vozv_Elit,0) - ISNULL(vozv_ElitDistr,0)) > 0
--) p1

