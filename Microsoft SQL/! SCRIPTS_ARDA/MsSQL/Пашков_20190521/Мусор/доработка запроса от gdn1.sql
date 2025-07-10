setuser 'gdn1'

select * from t_Inv where DocID in(3008536,3008540,3008541,3008544,3007824,3007832,3007833,3007850,3007888,3006367,3006368,3006369,3006375,3006285,3006301,3006360,3007686,3007688,3007690,3007692,3007695,3007696,3007040,3007120,3007374)
--select SUM(TSumCC) from t_Inv where DocID in(3008536,3008540,3008541,3008544,3007824,3007832,3007833,3007850,3007888,3006367,3006368,3006369,3006375,3006285,3006301,3006360,3007686,3007688,3007690,3007692,3007695,3007696,3007040,3007120,3007374)


begin tran

declare @ChId int,  @DocID int, @ChId2 int,  @DocID2 int


 
   SELECT @ChId = ISNULL(MAX(CHID),0)+1 from t_Inv 
   SELECT @DocID = ISNULL(MAX(DocID),0) +1 from t_Inv 
  
 
 INSERT t_Inv (ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, PayDelay, EmpID, Notes, TaxDocID, TaxDocDate, MorePrc, SrcDocID, SrcDocDate, LetAttor, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, TSpendSumCC, TRouteSumCC, StateCode, InDocID, Address, DelivID, KursCC, TSumCC, DepID, SrcTaxDocID, SrcTaxDocDate, OrderID, DriverID, CompAddID, LinkID, TerrID, PayConditionID)
        select @ChId ChID, @DocID DocID, @DocID IntDocID, '2017-01-10' DocDate, 27 KursMC, 1 OurID, 4 StockID, 7004 CompID, 63 CodeID1, 18 CodeID2, 4 CodeID3, 102  CodeID4, 0 CodeID5, 0 Discount, 95 PayDelay, 547 EmpID, '' Notes, 2984 TaxDocID, 2017-01-10 TaxDocDate, 0 MorePrc, null SrcDocID, null SrcDocDate, null LetAttor, 2 CurrID, 
        --sum(TSumCC_nt) 
        0 TSumCC_nt, --для устранения дублирования
        --sum(TTaxSum) 
        0 TTaxSum, --для устранения дублирования
        --sum(TSumCC_wt) 
        0 TSumCC_wt, sum(TSpendSumCC) TSpendSumCC, 0 TRouteSumCC, 190 StateCode, 1124946033 InDocID, '' Address, 201 DelivID, 1 KursCC, 
        --sum(TSumCC)
        0 TSumCC, --для устранения дублирования
        0 DepID, 0 SrcTaxDocID, null SrcTaxDocDate, '' OrderID, 1451 DriverID, 14 CompAddID, 0 LinkID, 0 TerrID, 1 PayConditionID
        from t_Inv where DocID in (3008536,3008540,3008541,3008544,3007824,3007832,3007833,3007850,3007888,3006367,3006368,3006369,3006375,3006285,3006301,3006360,3007686,3007688,3007690,3007692,3007695,3007696,3007040,3007120,3007374)
         and CompID=7004 and DocDate  between '2018-01-01' and '2018-01-10'
        
      
     select  b.ChId, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_wt from t_InvD a join t_Inv b  on a.ChID=b.ChID where   
          b.DocID in (3008536,3008540,3008541,3008544,3007824,3007832,3007833,3007850,3007888,3006367,3006368,3006369,3006375,3006285,3006301,3006360,3007686,3007688,3007690,3007692,3007695,3007696,3007040,3007120,3007374)  
          and CompID=7004 and DocDate  between '2018-01-01' and '2018-01-10' 
         
      INSERT t_InvD (ChID, a.SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_wt)   
          select @ChId ChId, ROW_NUMBER() over (order by ProdID, PPID ,Qty) SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_wt from t_InvD a join t_Inv b  on a.ChID=b.ChID where   
          b.DocID in (3008536,3008540,3008541,3008544,3007824,3007832,3007833,3007850,3007888,3006367,3006368,3006369,3006375,3006285,3006301,3006360,3007686,3007688,3007690,3007692,3007695,3007696,3007040,3007120,3007374)  
          and CompID=7004 and DocDate  between '2018-01-01' and '2018-01-10'



SELECT * FROM t_Inv WHERE ChiD = @ChId
SELECT * FROM t_InvD WHERE ChiD = @ChId
--SELECT SUM(TSumCC) FROM t_Inv WHERE ChiD = @ChId

          
         rollback tran
 
   --SELECT @ChId2 = ISNULL(MAX(CHID),0)+1 from b_TExp 
   --SELECT @DocID2 = ISNULL(MAX(DocID),0) +1 from b_TExp 
          
   --       select  top 1 * from  b_TExp
          
 --INSERT  b_TExp 
 --SELECT    ChID,DocID,IntDocID,DocDate,KursMC,OurID,CompID,SumCC_nt,TaxSum,SumCC_wt,Notes,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,GOperID,GTranID,DocType,GTSum_wt,GTTaxSum,GTAccID,PosType,TaxType,TaxCredit,StateCode,GPosID,GTCorrSum_wt,GTCorrTaxSum,IsCorrection,GTAdvAccID,GTAdvSum_wt,GTCorrAdvSum_wt,GTAdvTaxSum,GTCorrAdvTaxSum,SumCC_nt_20,TaxSum_20,SumCC_nt_0,TaxSum_0,SumCC_nt_Free,TaxSum_Free,SumCC_nt_No,TaxSum_No,TaxCorrType
 -- FROM  t_Inv  where DocID=3008541
  
 --     EXEC a
