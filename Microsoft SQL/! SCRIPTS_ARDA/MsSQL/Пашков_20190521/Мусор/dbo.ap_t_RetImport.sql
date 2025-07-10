ALTER PROCEDURE [dbo].[ap_t_RetImport] @DocID INT, @MSG NVARCHAR(250) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

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
			IF @Qtu_Inv <= @TQty 
				update #TempRetImport 
				set Real_Qty = @Qtu_Inv 
				where ProdID = @ProdID and SrcPosID = @SrcPosID
			ELSE
				update #TempRetImport 
				set Real_Qty = @TQty 
				where ProdID = @ProdID and SrcPosID = @SrcPosID
			
			SET @TQty = @TQty - @Qtu_Inv
			
			FETCH NEXT FROM CURSOR2	INTO @SrcPosID, @Qtu_Inv
		END
		CLOSE CURSOR2
		DEALLOCATE CURSOR2
		
		FETCH NEXT FROM CURSOR1 INTO @ProdID,@TQty
	END
	CLOSE CURSOR1
	DEALLOCATE CURSOR1
	
	    
    --обновить партии из РН
	UPDATE t
	set t.PPID = c.PPID
	FROM #TempRetImport t
	JOIN Elit.dbo.t_InvD c on c.ChID=t.ChID and c.ProdID=t.prodid  and c.SrcPosID = t.SrcPosID 

	--для отладки	
	--SELECT * FROM #TempRetImport  

	/*Блок создания ВТП*/
	DECLARE @ChID_Ret INT, @DocID_Ret INT, @DocDate_Ret SMALLDATETIME 

	SET @ChID_Ret = (SELECT MAX(ChID) + 1 FROM t_Ret)
	SET @DocID_Ret = (SELECT ISNULL(MAX(DocID),0) + 1 FROM t_Ret r WHERE r.OurID = (SELECT top 1 OurID FROM Elit.dbo.t_Inv WHERE DocID = @DocID) )
	set @DocDate_Ret = ISNULL((SELECT MIN(Date_Ret) FROM at_t_RetImport WHERE DocID = @DocID), dbo.zf_GetDate(GETDATE()) )

	INSERT dbo.t_Ret 
		SELECT top 1 
		--ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, SrcDocID, SrcDocDate, PayDelay, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, InDocID, TaxDocID, TaxDocDate, Address, DelivID, KursCC, TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, DriverID, CompAddID, LinkID, TerrID
		@ChID_Ret ChID ,@DocID_Ret DocID ,DocID IntDocID, @DocDate_Ret  DocDate
		,KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, 
		ISNULL(Notes,'') + ' Создано инструментом ВТП из РН' Notes, 
		Discount, SrcDocID, SrcDocDate, PayDelay, CurrID, 0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 0 TSpendSumCC, 0 TRouteSumCC, StateCode, InDocID, TaxDocID, TaxDocDate, Address, DelivID, KursCC, 0 TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, DriverID, CompAddID, LinkID, TerrID --, MorePrc,   LetAttor,  OrderID, PayConditionID 
		FROM Elit.dbo.t_Inv i
		WHERE DocID = @DocID

	INSERT t_RetD 
		SELECT 
		--ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID
		@ChID_Ret ChID, t.SrcPosID, t.ProdID, t.PPID, d.UM, t.Real_Qty Qty, d.PriceCC_nt, (d.PriceCC_nt * t.Real_Qty) SumCC_nt, d.Tax, (d.Tax * t.Real_Qty) TaxSum, d.PriceCC_wt, (d.PriceCC_wt * t.Real_Qty) SumCC_wt, d.BarCode, d.SecID
		FROM Elit.dbo.t_Inv i
		JOIN Elit.dbo.t_InvD d ON d.ChID = i.ChID
		JOIN #TempRetImport t ON t.Docid =i.DocID AND t.ProdId = d.ProdID AND t.SrcPosID = d.SrcPosID
		where i.DocID = @DocID
    
	IF @@TRANCOUNT > 0
	  COMMIT
	ELSE
	BEGIN
	  RAISERROR ('ВНИМАНИЕ!!! Работа инструмента завершилась ошибкой!', 18, 1)
	  ROLLBACK
	END 

	SET @MSG = 'Создался новый документ: возврат товара от получателя. №' + CAST(@DocID_Ret as Varchar(30)) + ' из РН №' + CAST(@DocID as Varchar(30))

END;









GO
