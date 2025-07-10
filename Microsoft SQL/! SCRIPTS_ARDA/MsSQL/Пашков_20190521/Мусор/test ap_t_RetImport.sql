-- ap_t_RetImport


DECLARE  @DocID INT = 3013330
,@MSG NVARCHAR(250)

BEGIN
	IF OBJECT_ID (N'tempdb..#TempRetImport', N'U') IS NOT NULL DROP TABLE #TempRetImport

	CREATE TABLE #TempRetImport
	(
	ID int,
	SrcPosID int,
	ProdId int,
	Qty_Ret int,
	Qtu_Inv int,
	SrcPocID_Ret int,
	ChId int,
	Docid int,
	New_qty int,
	Real_Qty int,
	PPID int
	)
 
 SELECT * FROM at_t_RetImport where  docid = @DocID --and  ProdID = 4149
  SELECT * FROM at_t_RetImport ORDER BY 1,2,3
 
BEGIN TRAN


	INSERT #TempRetImport  (ID, SrcPosID, ProdId, Qty_Ret, Qtu_Inv, SrcPocID_Ret, ChId, Docid, New_qty,  Real_Qty, PPID)
		SELECT ROW_NUMBER() OVER(ORDER BY MAX(a.prodid))  [SID],  SrcPosID, c.prodID , a.qty , c.Qty , c.SrcPosID,c.ChID, a.DocID ,
		CASE WHEN c.qty>=a.qty THEN a.qty WHEN SUM(c.Qty)< a.qty THEN c.qty  WHEN   SUM(c.Qty)< a.qty THEN a.qty-c.Qty  END newqty, 0 Real_Qty
		, 0 PPID
		FROM at_t_RetImport a   
		JOIN Elit.dbo.t_Inv b on a.docid=b.docid
		JOIN Elit.dbo.t_InvD c on c.ChID=b.ChID and c.ProdID=a.prodid
		WHERE
		(a.DocID=@docid) AND
		EXISTS (SELECT ProdID FROM at_t_RetImport WHERE  ProdID =c.ProdID /*AND (C.Qty>Qty or c.Qty+c.Qty>Qty )*/) 
		--NOT EXISTS (Select * from at_t_RetImport   )
		GROUP BY SrcPosID, c.prodID , a.qty , c.Qty , c.SrcPosID,c.ChID,a.docid

	--для отладки	
	SELECT * FROM #TempRetImport -- where   ProdID = 4149
	
	--IF EXISTS (SELECT*FROM  #TempRetImport WHERE  Qty_Ret<Qtu_Inv )
	--BEGIN
	--	UPDATE  t
	--	SET Real_Qty=Qty_Ret
	--	FROM #TempRetImport t
	--	WHERE   Qty_Ret<Qtu_Inv  
	--END   


	--IF EXISTS (SELECT*FROM  #TempRetImport WHERE  Qty_Ret>Qtu_Inv )
	--BEGIN
	--	UPDATE  t
	--	SET Real_Qty=Qtu_Inv
	--	FROM #TempRetImport t
	--	WHERE  Qty_Ret>Qtu_Inv and Exists(SELECT MAX(SrcPosID) FROM #TempRetImport WHERE New_qty+Real_Qty=Qty_Ret  )
	    
	--	Update t
	--	set Real_Qty=Qty_Ret-Qtu_Inv
	--	from #TempRetImport t
	--	where  Qty_Ret>Qtu_Inv and SrcPosID in (SELECT  MAX(SrcPosID) FROM #TempRetImport WHERE Qty_Ret>Qtu_Inv )
	--END
 

	 /*Блок распределения количества возврата товара по позициям из РН*/
	DECLARE @ProdID INT, @TQty NUMERIC(21,9)
	DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ProdID, min(Qty_Ret) Qty_Ret FROM #TempRetImport WITH (NOLOCK) GROUP BY ProdID 

	OPEN CURSOR1
		FETCH NEXT FROM CURSOR1 INTO @ProdID,@TQty
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Script
		
		DECLARE @Qtu_Inv INT, @SrcPosID int
		DECLARE CURSOR2 CURSOR LOCAL FAST_FORWARD
		FOR 
		SELECT SrcPosID, Qtu_Inv FROM #TempRetImport WITH (NOLOCK) WHERE ProdID = @ProdID ORDER BY 1
		
		OPEN CURSOR2
			FETCH NEXT FROM CURSOR2 INTO @SrcPosID, @Qtu_Inv
		WHILE @@FETCH_STATUS = 0 AND @TQty > 0
		BEGIN
			--Script
			
			SELECT @ProdID, @SrcPosID, @Qtu_Inv 
			IF @Qtu_Inv <= @TQty 
			BEGIN
				update #TempRetImport 
				set Real_Qty = @Qtu_Inv 
				where ProdID = @ProdID and SrcPosID = @SrcPosID
			END
			ELSE
			BEGIN
				update #TempRetImport 
				set Real_Qty = @TQty 
				where ProdID = @ProdID and SrcPosID = @SrcPosID

			END
			
			set @TQty = @TQty - @Qtu_Inv
			
			FETCH NEXT FROM CURSOR2	INTO @SrcPosID, @Qtu_Inv
		END
		CLOSE CURSOR2
		DEALLOCATE CURSOR2
		
		
		FETCH NEXT FROM CURSOR1 INTO @ProdID,@TQty
	END
	CLOSE CURSOR1
	DEALLOCATE CURSOR1
 
--для отладки	
SELECT ProdID FROM #TempRetImport WITH (NOLOCK) GROUP BY ProdID 
   
    --обновить партии из РН
	UPDATE t
	set t.PPID = c.PPID
	FROM #TempRetImport t
	JOIN Elit.dbo.t_InvD c on c.ChID=t.ChID and c.ProdID=t.prodid  and c.SrcPosID = t.SrcPosID 

	--для отладки	
	SELECT * FROM #TempRetImport  where   ProdID = 3499
 

	/*Блок создания ВТП*/
	DECLARE @ChID_Ret INT, @DocID_Ret INT, @DocDate_Ret SMALLDATETIME 

	SET @ChID_Ret = (SELECT MAX(ChID) + 1 FROM t_Ret)
	SET @DocID_Ret = (SELECT ISNULL(MAX(DocID),0) + 1 FROM t_Ret r WHERE r.OurID = 1 /*(SELECT top 1 OurID FROM Elit.dbo.t_Inv WHERE DocID = @DocID)*/ )
	set @DocDate_Ret = ISNULL((SELECT MIN(Date_Ret) FROM at_t_RetImport WHERE DocID = @DocID), GETDATE())

	INSERT dbo.t_Ret 
		SELECT top 1 
		--ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, SrcDocID, SrcDocDate, PayDelay, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, InDocID, TaxDocID, TaxDocDate, Address, DelivID, KursCC, TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, DriverID, CompAddID, LinkID, TerrID
		@ChID_Ret ChID ,@DocID_Ret DocID ,DocID IntDocID, @DocDate_Ret  DocDate
		,KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, 
		ISNULL(Notes,'') + ' Создано инструментом ВТП из РН' Notes, 
		Discount, SrcDocID, SrcDocDate, PayDelay, CurrID, 0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 0 TSpendSumCC, 0 TRouteSumCC, StateCode, InDocID, TaxDocID, TaxDocDate, Address, DelivID, KursCC, 0 TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, DriverID, CompAddID, LinkID, TerrID --, MorePrc,   LetAttor,  OrderID, PayConditionID 
		FROM Elit.dbo.t_Inv i
		WHERE DocID = @DocID and i.OurID = 1 
		
SELECT 
--ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
@ChID_Ret ChID, t.SrcPosID, t.ProdID, t.PPID, d.UM, t.Real_Qty Qty, d.PriceCC_nt, (d.PriceCC_nt * t.Real_Qty) SumCC_nt, d.Tax, (d.Tax * t.Real_Qty) TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.Real_Qty) SumCC_wt, d.BarCode, d.SecID
FROM Elit.dbo.t_Inv i
JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
JOIN #TempRetImport t ON t.Docid =i.DocID AND t.ProdId = d.ProdID AND t.SrcPosID = d.SrcPosID
where i.DocID = @DocID
 
 
	INSERT t_RetD 
		SELECT 
		--ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
		@ChID_Ret ChID, t.SrcPosID, t.ProdID, t.PPID, d.UM, t.Real_Qty Qty, d.PriceCC_nt, (d.PriceCC_nt * t.Real_Qty) SumCC_nt, d.Tax, (d.Tax * t.Real_Qty) TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.Real_Qty) SumCC_wt, d.BarCode, d.SecID
		FROM Elit.dbo.t_Inv i
		JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
		JOIN #TempRetImport t ON t.Docid =i.DocID AND t.ProdId = d.ProdID AND t.SrcPosID = d.SrcPosID
		where i.DocID = @DocID
    
	--IF @@TRANCOUNT > 0
	--  COMMIT
	--ELSE
	--BEGIN
	--  RAISERROR ('ВНИМАНИЕ!!! Работа инструмента завершилась ошибкой!', 18, 1)

	--END 

	--для отладки
	SELECT * FROM t_Ret  where ChID = (SELECT MAX(ChID) FROM t_Ret)
	SELECT * FROM t_RetD  where ChID = (SELECT MAX(ChID) FROM t_Ret)

	SET @MSG = 'Создался новый документ: возврат товара от получателя. №' + CAST(@DocID_Ret as Varchar(30)) + ' из РН №' + CAST(@DocID as Varchar(30))

 	  ROLLBACK tran
END;


--CREATE TABLE at_t_RetImport (DocId	int Null ,ProdID int Null ,Qty	int Null ,Date_Ret	smalldatetime  Null )

/*
SELECT IntDocID,sum(d.Qty) Qty FROM t_Ret m
JOIN t_RetD d ON d.ChID = m.ChID
WHERE m.DocDate = '2017-12-08' and IntDocID = 1105084
group by IntDocID
ORDER BY 1

SELECT * FROM t_Retd
  where DocDate = '2017-12-08' and IntDocID = 1105084

SELECT * FROM t_Ret ORDER BY 4 desc

 InDocID = 1105084






SELECT * FROM Elit.dbo.t_Inv

SELECT * FROM Elit.dbo.t_Inv m
JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
WHERE m.DocID = 1109792 and d.ProdID = 4149
ORDER BY 1

*/







--GO




--BEGIN TRAN

--DECLARE @DocID INT = 976979


--DECLARE @ChID_Ret INT, @DocID_Ret INT, @DocDate_Ret SMALLDATETIME 


--SET @ChID_Ret = (SELECT MAX(ChID) + 1 FROM ElitDistr_TEST.dbo.t_Ret)
--SET @DocID_Ret = (SELECT ISNULL(MAX(DocID),0) + 1 FROM ElitDistr_TEST.dbo.t_Ret r WHERE r.OurID = (SELECT top 1 OurID FROM t_Inv WHERE DocID = @DocID) )
--set @DocDate_Ret = ISNULL((SELECT MIN(Date_Ret) FROM Elit_TEST_KPK.dbo.at_t_RetImport WHERE DocID = @DocID), GETDATE())


--INSERT ElitDistr_TEST.dbo.t_Ret 
--	SELECT top 1 
--	--ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, SrcDocID, SrcDocDate, PayDelay, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, InDocID, TaxDocID, TaxDocDate, Address, DelivID, KursCC, TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, DriverID, CompAddID, LinkID, TerrID
--	  @ChID_Ret ChID ,@DocID_Ret DocID ,IntDocID, @DocDate_Ret  DocDate
--	 ,KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, SrcDocID, SrcDocDate, PayDelay, CurrID, 0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 0 TSpendSumCC, 0 TRouteSumCC, StateCode, InDocID, TaxDocID, TaxDocDate, Address, DelivID, KursCC, 0 TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, DriverID, CompAddID, LinkID, TerrID --, MorePrc,   LetAttor,  OrderID, PayConditionID 
--	FROM t_Inv i
--	WHERE DocID = @DocID


--INSERT ElitDistr_TEST.dbo.t_RetD 
--	SELECT 
--	--ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_wt
--	--ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
--	@ChID_Ret ChID, t.SrcPosID, t.ProdID, t.PPID, d.UM, t.Real_Qty Qty, d.PriceCC_nt, (d.PriceCC_nt * t.Real_Qty) SumCC_nt, d.Tax, (d.Tax * t.Real_Qty) TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.Real_Qty) SumCC_wt, d.BarCode, d.SecID
--	FROM t_Inv i
--	JOIN t_InvD d ON d.ChID = i.ChID
--	JOIN #TempRetImport t ON t.Docid =i.DocID AND t.ProdId = d.ProdID AND t.SrcPosID = d.SrcPosID
--	where i.DocID = @DocID
	
	
--SELECT * FROM ElitDistr_TEST.dbo.t_Ret  where ChID = (SELECT MAX(ChID) FROM ElitDistr_TEST.dbo.t_Ret)
--SELECT * FROM ElitDistr_TEST.dbo.t_RetD  where ChID = (SELECT MAX(ChID) FROM ElitDistr_TEST.dbo.t_Ret)

----SELECT * FROM #TempRetImport  

--ROLLBACK TRAN

--	--SELECT  *
--	----ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_wt
--	----@ChID_Ret ChID, t.SrcPosID, t.ProdID, t.PPID, d.UM, t.Real_Qty Qty, d.PriceCC_nt, (d.PriceCC_nt * t.Real_Qty) SumCC_nt, d.Tax, d.TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.Real_Qty) SumCC_wt, d.BarCode, d.SecID, d.PurPriceCC_wt
--	--FROM t_Inv i
--	--JOIN t_InvD d ON d.ChID = i.ChID
--	--JOIN #TempRetImport t ON t.Docid =i.DocID AND t.ProdId = d.ProdID AND t.SrcPosID = d.SrcPosID
--	--where i.DocID = 976979
	
--	--a_tRetD_CheckFieldValues_IU
--	--TRel1_Ins_t_RetD