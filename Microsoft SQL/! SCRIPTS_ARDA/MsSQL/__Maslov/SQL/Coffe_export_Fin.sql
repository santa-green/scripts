--BEGIN TRAN;
DECLARE @BDate smalldatetime
SET @BDate = '2018-08-24'

INSERT dbo.t_zRep
SELECT (ChID + 10000) ChID,DocDate,DocTime,CRID,OperID,OurID,DocID,FacID,FinID,ZRepNum,SumCC_wt,Sum_A,Sum_B,Sum_C,Sum_D,RetSum_A,RetSum_B,RetSum_C,RetSum_D,SumCash,SumCard,SumCredit,SumCheque,SumOther,RetSumCash,RetSumCard,RetSumCredit,RetSumCheque,RetSumOther,SumMonRec,SumMonExp,SumRem,Notes,Sum_E,Sum_F,RetSum_E,RetSum_F,Tax_A,Tax_B,Tax_C,Tax_D,Tax_E,Tax_F,RetTax_A,RetTax_B,RetTax_C,RetTax_D,RetTax_E,RetTax_F FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_zRep where doctime > @BDate

INSERT dbo.t_CRRet	-- it is empty
SELECT ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CRID, OperID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, CreditID, DCardID, SrcDocID, SrcDocDate, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DocTime, TaxDocID, TaxDocDate, DepID, null ClientID, null InDocID, null DeclNum, null DeclDate, null DeskCode, null BLineID, TRealSum, TLevySum, null RemSChId FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_CRRet where DocDate > @BDate

INSERT dbo.t_CRRetDLV -- it is empty
SELECT * FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_CRRetDLV

INSERT dbo.t_CRRetD -- it is empty
SELECT * FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_CRRetD
WHERE ChID in (SELECT ChID  FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_CRRet where DocDate > @BDate)

INSERT dbo.t_MonRec
SELECT (ChID + 100000) ChID,OurID,AccountAC,DocDate,DocID,StockID,CompID,CompAccountAC,CurrID,KursMC,KursCC,SumAC,Subject,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,EmpID,StateCode,DepID FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_MonRec  where DocDate > @BDate

INSERT dbo.t_Sale
SELECT (ChID + 600000) ChID, (70000 + DocID) DocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, Notes, CRID, OperID, CreditID, DocTime, TaxDocID, TaxDocDate, DCardID, EmpID, IntDocID, CashSumCC, ChangeSumCC, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DeskCode, Visitors, TPurSumCC_nt, TPurTaxSum, TPurSumCC_wt, DocCreateTime, DepID, 0 ClientID, 0 InDocID, 0 ExpTime, 0 DeclNum, 0 DeclDate, 0 BLineID, TRealSum, TLevySum, 0 RemSChId FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_Sale  where DocDate > @BDate
ORDER BY 1

 --be carefull. This must write only after t_Sale.
INSERT dbo.t_SaleD
SELECT (ChID + 600000) ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, Discount, 0 DepID, 0 IsFiscal, 0 SubStockID, 0 OutQty, EmpID, CreateTime, ModifyTime, TaxTypeID, RealPrice, RealSum 
FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_SaleD  
where chid in (SELECT ChID FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_Sale  where DocDate > @BDate)
ORDER BY 1

INSERT dbo.t_SaleDLV -- it is empty
SELECT * FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_SaleDLV

INSERT dbo.t_MonIntRec -- it is empty in dates bigger than '2018-08-24'
SELECT * FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_MonIntRec where DocDate > @BDate

INSERT dbo.t_MonIntExp -- it is empty in dates bigger than '2018-08-24'. Last record was at '2018-08-24'
SELECT * FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_MonIntExp where DocDate > @BDate

--SELECT * FROM [S-ELIT-DP\MSSQLSERVER2].ElitCP1_test2.dbo.t_CRRet  where DocDate > '2018-08-24' ORDER BY DocDate desc
--SELECT * FROM dbo.t_CRRetDLV order by 3 desc
--SELECT * FROM dbo.t_Sale where chid > 70002365 and  chid < 79002365 order by 3 desc
--ROLLBACK TRAN;
