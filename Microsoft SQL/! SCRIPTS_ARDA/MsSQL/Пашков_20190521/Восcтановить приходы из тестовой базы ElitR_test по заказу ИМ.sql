--Восcтановить приходы из тестовой базы ElitR_test по заказу ИМ
BEGIN TRAN


USE ElitR
DECLARE @DocID int = 158323 --Номер заказа ЗВР

select 'Востановление в ElitR'
SELECT * FROM t_Rec where InDocID = cast(@DocID as varchar)
SELECT * FROM t_RecD where ChID = (SELECT ChID FROM t_Rec where InDocID = cast(@DocID as varchar))

--ElitR_test
SELECT * FROM ElitR_test.dbo.t_Rec where InDocID = cast(@DocID as varchar)
SELECT * FROM ElitR_test.dbo.t_RecD where ChID = (SELECT ChID FROM ElitR_test.dbo.t_Rec where InDocID = cast(@DocID as varchar))


INSERT t_Rec
	SELECT ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, PayDelay, EmpID, Notes, SrcDocID, SrcDocDate, SrcTaxDocID, SrcTaxDocDate, TaxDocID, TaxDocDate, CurrID, 
	0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 0 TSpendSumCC, 0 TRouteSumCC, StateCode, KursCC, InDocID, DepID 
	FROM ElitR_test.dbo.t_Rec where InDocID = cast(@DocID as varchar)

INSERT t_RecD
	SELECT * FROM ElitR_test.dbo.t_RecD where ChID = (SELECT ChID FROM ElitR_test.dbo.t_Rec where InDocID = cast(@DocID as varchar))


SELECT * FROM t_Rec where InDocID = cast(@DocID as varchar)
SELECT * FROM t_RecD where ChID = (SELECT ChID FROM t_Rec where InDocID = cast(@DocID as varchar))


select 'Востановление в Elit расходной накладной'
SELECT * FROM elit.dbo.t_Inv where SrcDocID = cast(@DocID as varchar)
SELECT * FROM elit.dbo.t_InvD where ChID = (SELECT ChID FROM elit.dbo.t_Inv where SrcDocID = cast(@DocID as varchar))
	
--Elit_test
SELECT * FROM Elit_test.dbo.t_Inv where SrcDocID = cast(@DocID as varchar)
SELECT * FROM Elit_test.dbo.t_InvD where ChID = (SELECT ChID FROM Elit_test.dbo.t_Inv where SrcDocID = cast(@DocID as varchar))


INSERT elit.dbo.t_Inv
SELECT ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, PayDelay, EmpID, Notes, TaxDocID, TaxDocDate, MorePrc, SrcDocID, SrcDocDate, LetAttor, CurrID, 
0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 0 TSpendSumCC, 0 TRouteSumCC, StateCode, InDocID, Address, DelivID, KursCC, 0 TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, OrderID, DriverID, CompAddID, LinkID, TerrID, PayConditionID 
FROM Elit_test.dbo.t_Inv where SrcDocID = cast(@DocID as varchar)

INSERT elit.dbo.t_InvD
SELECT * FROM Elit_test.dbo.t_InvD where ChID = (SELECT ChID FROM Elit_test.dbo.t_Inv where SrcDocID = cast(@DocID as varchar))

SELECT * FROM elit.dbo.t_Inv where SrcDocID = cast(@DocID as varchar)
SELECT * FROM elit.dbo.t_InvD where ChID = (SELECT ChID FROM elit.dbo.t_Inv where SrcDocID = cast(@DocID as varchar))


ROLLBACK TRAN 
IF @@TRANCOUNT > 0 COMMIT TRAN