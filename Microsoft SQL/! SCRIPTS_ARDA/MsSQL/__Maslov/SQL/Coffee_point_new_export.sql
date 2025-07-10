--Скрипт вытягивает основные таблицы из Кофе поинта в МОСТ-сити
--и заливает их в выбранную базу.
--BEGIN TRAN;
DECLARE @BDiap INT = 1700000000,
		@EDiap INT = 1799999999;

DISABLE TRIGGER ALL ON t_Sale;
INSERT t_Sale
SELECT ChID, DocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, Notes, CRID, OperID, CreditID, DocTime, 0, null, (SELECT TOP 1 DCardID FROM [DP_CP1_MOST].FFood_sample.dbo.r_DCards AS rdc WHERE rdc.ChID = ts.DCardChID), EmpID, IntDocID, CashSumCC, ChangeSumCC, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DeskCode, Visitors, TPurSumCC_nt, TPurTaxSum, TPurSumCC_wt, DocCreateTime, 0,       0,          0,    null,    null,     null,    0,    TRealSum, TLevySum, 0 
FROM [DP_CP1_MOST].FFood_sample.dbo.t_Sale AS ts WHERE ts.ChID BETWEEN @BDiap AND @EDiap
AND ts.ChID not in (SELECT m.ChID FROM t_Sale m);
ENABLE TRIGGER ALL ON t_Sale;

DISABLE TRIGGER ALL ON t_SaleD;
INSERT t_SaleD
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, Discount,     0,        0,          0,      0, EmpID, CreateTime, ModifyTime, TaxTypeID, RealPrice, RealSum 
FROM [DP_CP1_MOST].FFood_sample.dbo.t_SaleD tsd WHERE tsd.ChID BETWEEN @BDiap AND @EDiap
AND tsd.ChID not in (SELECT m.ChID FROM t_SaleD m);
ENABLE TRIGGER ALL ON t_SaleD;

DISABLE TRIGGER ALL ON t_SalePays;
INSERT t_SalePays
SELECT ChID, SrcPosID, PayFormCode, SumCC_wt, Notes, POSPayID, POSPayDocID, POSPayRRN, 0
FROM [DP_CP1_MOST].FFood_sample.dbo.t_SalePays tsp WHERE tsp.ChID BETWEEN @BDiap AND @EDiap
AND tsp.ChID not in (SELECT m.ChID FROM t_SalePays m);
ENABLE TRIGGER ALL ON t_SalePays;

INSERT t_SaleDLV
SELECT ChID, SrcPosID, LevyID, LevySum
FROM [DP_CP1_MOST].FFood_sample.dbo.t_SaleDLV tsdlv WHERE tsdlv.ChID BETWEEN @BDiap AND @EDiap
AND tsdlv.ChID not in (SELECT m.ChID FROM t_SaleDLV m);

/*INSERT z_DocDC
SELECT DocCode, ChID, (SELECT TOP 1 DCardID FROM [DP_CP1_MOST].FFood_sample.dbo.r_DCards AS rdc WHERE rdc.ChID = zd.DCardChID) FROM [DP_CP1_MOST].FFood_sample.dbo.z_DocDC AS zd WHERE ChID BETWEEN @BDiap AND @EDiap;
*/
INSERT t_zRep
SELECT ChID, DocDate, DocTime, CRID, OperID, OurID, DocID, FacID, FinID, ZRepNum, SumCC_wt, Sum_A, Sum_B, Sum_C, Sum_D, RetSum_A, RetSum_B, RetSum_C, RetSum_D, SumCash, SumCard, SumCredit, SumCheque, SumOther, RetSumCash, RetSumCard, RetSumCredit, RetSumCheque, RetSumOther, SumMonRec, SumMonExp, SumRem, Notes, Sum_E, Sum_F, RetSum_E, RetSum_F, Tax_A, Tax_B, Tax_C, Tax_D, Tax_E, Tax_F, RetTax_A, RetTax_B, RetTax_C, RetTax_D, RetTax_E, RetTax_F
FROM [DP_CP1_MOST].FFood_sample.dbo.t_zRep tzr WHERE tzr.ChID BETWEEN @BDiap AND @EDiap
AND tzr.ChID NOT IN (SELECT m.ChID FROM t_zRep m);

/*INSERT t_CRRet
SELECT ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CRID, OperID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, CreditID, (SELECT TOP 1 DCardID FROM [DP_CP1_MOST].FFood_sample.dbo.r_DCards AS rdc WHERE rdc.ChID = tcrr.DCardChID), SrcDocID, SrcDocDate, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DocTime,        0,       null,     0,        0,       0,    null,     null,        0,       0, TRealSum, TLevySum, null FROM [DP_CP1_MOST].FFood_sample.dbo.t_CRRet AS tcrr WHERE ChID BETWEEN @BDiap AND @EDiap;

INSERT t_CRRetDLV
SELECT ChID, SrcPosID, LevyID, LevySum FROM [DP_CP1_MOST].FFood_sample.dbo.t_CRRetDLV WHERE ChID BETWEEN @BDiap AND @EDiap;

INSERT t_CRRetD
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, SaleSrcPosID, EmpID, CreateTime, ModifyTime, TaxTypeID, RealPrice, RealSum FROM [DP_CP1_MOST].FFood_sample.dbo.t_CRRetD WHERE ChID BETWEEN @BDiap AND @EDiap;
*/
INSERT t_MonRec
SELECT ChID, OurID, AccountAC, DocDate, DocID, StockID, CompID, CompAccountAC, CurrID, KursMC, KursCC, SumAC, Subject, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, StateCode, 0
FROM [DP_CP1_MOST].FFood_sample.dbo.t_MonRec tmr WHERE tmr.ChID BETWEEN @BDiap AND @EDiap
AND tmr.ChID NOT IN (SELECT m.ChID FROM t_MonRec m);


INSERT t_MonIntRec
SELECT ChID, OurID, CRID, DocDate, DocTime, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, SumCC, Notes, OperID, StateCode, DocID, IntDocID
FROM [DP_CP1_MOST].FFood_sample.dbo.t_MonIntRec tmir WHERE tmir.ChID BETWEEN @BDiap AND @EDiap
AND tmir.ChID NOT IN (SELECT m.ChID FROM t_MonIntRec m);

INSERT t_MonIntExp
SELECT ChID, OurID, CRID, DocDate, DocTime, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, SumCC, Notes, OperID, StateCode, DocID, IntDocID
FROM [DP_CP1_MOST].FFood_sample.dbo.t_MonIntExp tmie WHERE tmie.ChID BETWEEN @BDiap AND @EDiap
AND tmie.ChID NOT IN (SELECT m.ChID FROM t_MonIntExp m);


--SELECT TOP 1 * FROM t_MonIntExp ORDER BY 1 DESC; 
--SELECT top 1 * FROM t_Sale WHERE DCardID NOT IN ('<Нет дисконтной карты>')
--SELECT top 1 * FROM [DP_CP1_MOST].FFood_sample.dbo.t_Sale

--SELECT top 1 * FROM z_DocDC
--SELECT top 1 * FROM [DP_CP1_MOST].FFood_sample.dbo.z_DocDC

--SELECT * FROM [DP_CP1_MOST].FFood_sample.dbo.t_MonRec
--ElitR_test2
--ROLLBACK TRAN;