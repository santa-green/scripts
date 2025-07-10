
SELECT * FROM t_saletemp where CRID = 102

SELECT * FROM t_Sale where DocID = 100347787

SELECT * FROM t_Sale where ChID =  100412218


SELECT * FROM t_Saled where ChID =  100412218

SELECT * FROM t_Sale
join t_Saled on t_Sale.ChID = t_SaleD.ChID
where t_SaleD.ProdID =  600133 and CRID = 102
order by 1 desc

SELECT * FROM t_Sale where ChID =  100399936

-- insert t_Saled
SELECT 100412218 ChID, 2 SrcPosID, ProdID, 0 PPID, UM, 1 Qty, PriceCC_nt, SumCC_nt, 
Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, 
PLID, Discount, DepID, IsFiscal, SubStockID, OutQty, EmpID, CreateTime, ModifyTime, 
TaxTypeID, RealPrice, RealSum FROM t_Saled where ChID =  100407613 and SrcPosID = 1

SELECT * FROM t_MonRec where DocID =  100338696

SELECT * FROM t_MonRec where DocID =  100347787

SELECT * FROM t_MonRec where SumAC = 420
order by 4 desc

-- insert t_MonRec
SELECT (select max(ChID) + 1 from t_MonRec where ChID < 200000000) ChID, OurID,
 AccountAC, DocDate, 100347787 DocID, 1201 StockID, CompID, CompAccountAC, 
CurrID, KursMC, KursCC, SumAC, Subject, CodeID1, CodeID2, CodeID3, CodeID4, 
CodeID5, EmpID, StateCode, DepID FROM t_MonRec where chid = 100333111
