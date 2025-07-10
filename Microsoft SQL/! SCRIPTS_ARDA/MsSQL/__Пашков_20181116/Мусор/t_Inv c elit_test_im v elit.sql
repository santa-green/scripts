SELECT SrcDocID,* FROM  [S-SQL-D4].Elit_test_IM.dbo.t_Inv where CompID =10791 and SrcDocID in ('131725','131855','131871','131883') ORDER BY 2


101543557,101543559,101543560,101543561

DECLARE @DocID int ,@ChID int ,@ChIDtest int = 101543561 

set @ChID = (select max(ChID)+1 from t_Inv)
set @DocID = (select max(DocID)+1 from t_Inv)

insert t_Inv
SELECT @ChID ChID, @DocID DocID, @DocID IntDocID, DocDate, KursMC, OurID, StockID, CompID,
 CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, PayDelay, EmpID, Notes,
  TaxDocID, TaxDocDate, MorePrc, SrcDocID, SrcDocDate, LetAttor, CurrID,
   TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, InDocID,
    Address, DelivID, KursCC, TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, OrderID, 
    DriverID, CompAddID, LinkID, TerrID, PayConditionID 
    FROM  [S-SQL-D4].Elit_test_IM.dbo.t_Inv where chid = @ChIDtest
    
insert t_Invd
SELECT @ChID ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt,
 Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_wt 
 FROM  [S-SQL-D4].Elit_test_IM.dbo.t_Invd where chid = @ChIDtest


