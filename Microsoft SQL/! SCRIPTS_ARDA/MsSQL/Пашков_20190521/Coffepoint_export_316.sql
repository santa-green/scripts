
BEGIN TRAN

DECLARE @ROLLBACK_TRAN  int = 1   -- 1 тестирование c откатом, выполнится ROLLBACK TRAN   0 рабочий режим, выполнится COMMIT TRAN

USE ElitR

--Скрипт вытягивает основные таблицы из Кофе поинта в МОСТ-сити
--и заливает их в выбранную базу.

DECLARE @BDiap INT = 1700000000,
		@EDiap INT = 1799999999;

--DISABLE TRIGGER ALL ON t_Sale;
INSERT t_Sale
	SELECT ChID, DocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, Notes, CRID, OperID, CreditID, DocTime, 0, null, (SELECT TOP 1 DCardID FROM [192.168.42.6].FFood601.dbo.r_DCards AS rdc WHERE rdc.ChID = ts.DCardChID), EmpID, IntDocID, CashSumCC, ChangeSumCC, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DeskCode, Visitors, TPurSumCC_nt, TPurTaxSum, TPurSumCC_wt, DocCreateTime, 0,       0,          0,    null,    null,     null,    0,    TRealSum, TLevySum, 0 
	FROM [192.168.42.6].FFood601.dbo.t_Sale AS ts WHERE ts.ChID BETWEEN @BDiap AND @EDiap
	AND ts.ChID not in (SELECT m.ChID FROM t_Sale m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
--ENABLE TRIGGER ALL ON t_Sale;

--DISABLE TRIGGER ALL ON t_SaleD;
INSERT t_SaleD
	SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, Discount,     0,        0,          0,      0, EmpID, CreateTime, ModifyTime, TaxTypeID, RealPrice, RealSum 
	FROM [192.168.42.6].FFood601.dbo.t_SaleD tsd WHERE tsd.ChID BETWEEN @BDiap AND @EDiap
	AND tsd.ChID not in (SELECT m.ChID FROM t_SaleD m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
--ENABLE TRIGGER ALL ON t_SaleD;

--DISABLE TRIGGER ALL ON t_SalePays;
INSERT t_SalePays
	SELECT ChID, SrcPosID, PayFormCode, SumCC_wt, Notes, POSPayID, POSPayDocID, POSPayRRN, 0
	FROM [192.168.42.6].FFood601.dbo.t_SalePays tsp WHERE tsp.ChID BETWEEN @BDiap AND @EDiap
	AND tsp.ChID not in (SELECT m.ChID FROM t_SalePays m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
--ENABLE TRIGGER ALL ON t_SalePays;

INSERT t_SaleDLV
	SELECT ChID, SrcPosID, LevyID, LevySum
	FROM [192.168.42.6].FFood601.dbo.t_SaleDLV tsdlv WHERE tsdlv.ChID BETWEEN @BDiap AND @EDiap
	AND tsdlv.ChID not in (SELECT m.ChID FROM t_SaleDLV m WHERE m.ChID BETWEEN @BDiap AND @EDiap);

INSERT t_zRep
	SELECT ChID, DocDate, DocTime, CRID, OperID, OurID, DocID, FacID, FinID, ZRepNum, SumCC_wt, Sum_A, Sum_B, Sum_C, Sum_D, RetSum_A, RetSum_B, RetSum_C, RetSum_D, SumCash, SumCard, SumCredit, SumCheque, SumOther, RetSumCash, RetSumCard, RetSumCredit, RetSumCheque, RetSumOther, SumMonRec, SumMonExp, SumRem, Notes, Sum_E, Sum_F, RetSum_E, RetSum_F, Tax_A, Tax_B, Tax_C, Tax_D, Tax_E, Tax_F, RetTax_A, RetTax_B, RetTax_C, RetTax_D, RetTax_E, RetTax_F
	FROM [192.168.42.6].FFood601.dbo.t_zRep tzr WHERE tzr.ChID BETWEEN @BDiap AND @EDiap
	AND tzr.ChID NOT IN (SELECT m.ChID FROM t_zRep m WHERE m.ChID BETWEEN @BDiap AND @EDiap);

INSERT t_MonRec
	SELECT ChID, OurID, AccountAC, DocDate, DocID, StockID, CompID, CompAccountAC, CurrID, KursMC, KursCC, SumAC, Subject, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, StateCode, 0
	FROM [192.168.42.6].FFood601.dbo.t_MonRec tmr WHERE tmr.ChID BETWEEN @BDiap AND @EDiap
	AND tmr.ChID NOT IN (SELECT m.ChID FROM t_MonRec m WHERE m.ChID BETWEEN @BDiap AND @EDiap);


INSERT t_MonIntRec
	SELECT ChID, OurID, CRID, DocDate, DocTime, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, SumCC, Notes, OperID, StateCode, DocID, IntDocID
	FROM [192.168.42.6].FFood601.dbo.t_MonIntRec tmir WHERE tmir.ChID BETWEEN @BDiap AND @EDiap
	AND tmir.ChID NOT IN (SELECT m.ChID FROM t_MonIntRec m WHERE m.ChID BETWEEN @BDiap AND @EDiap);

INSERT t_MonIntExp
	SELECT ChID, OurID, CRID, DocDate, DocTime, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, SumCC, Notes, OperID, StateCode, DocID, IntDocID
	FROM [192.168.42.6].FFood601.dbo.t_MonIntExp tmie WHERE tmie.ChID BETWEEN @BDiap AND @EDiap
	AND tmie.ChID NOT IN (SELECT m.ChID FROM t_MonIntExp m WHERE m.ChID BETWEEN @BDiap AND @EDiap);


/*INSERT t_CRRet
SELECT ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CRID, OperID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, CreditID, (SELECT TOP 1 DCardID FROM [192.168.42.6].FFood601.dbo.r_DCards AS rdc WHERE rdc.ChID = tcrr.DCardChID), SrcDocID, SrcDocDate, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DocTime,        0,       null,     0,        0,       0,    null,     null,        0,       0, TRealSum, TLevySum, null FROM [192.168.42.6].FFood601.dbo.t_CRRet AS tcrr WHERE ChID BETWEEN @BDiap AND @EDiap;

INSERT t_CRRetDLV
SELECT ChID, SrcPosID, LevyID, LevySum FROM [192.168.42.6].FFood601.dbo.t_CRRetDLV WHERE ChID BETWEEN @BDiap AND @EDiap;

INSERT t_CRRetD
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, SaleSrcPosID, EmpID, CreateTime, ModifyTime, TaxTypeID, RealPrice, RealSum FROM [192.168.42.6].FFood601.dbo.t_CRRetD WHERE ChID BETWEEN @BDiap AND @EDiap;
*/

/*INSERT z_DocDC
SELECT DocCode, ChID, (SELECT TOP 1 DCardID FROM [192.168.42.6].FFood601.dbo.r_DCards AS rdc WHERE rdc.ChID = zd.DCardChID) FROM [192.168.42.6].FFood601.dbo.z_DocDC AS zd WHERE ChID BETWEEN @BDiap AND @EDiap;
*/


IF @ROLLBACK_TRAN = 1 
BEGIN
	ROLLBACK TRAN   
END
ELSE
BEGIN
	IF @@TRANCOUNT > 0
	  COMMIT
	ELSE
	BEGIN
	  RAISERROR ('ВНИМАНИЕ!!! Работа инструмента завершилась ошибкой!', 10, 1)
	  ROLLBACK
	END   
END



/*
--top 5 самых продаваемых товаров с 20180101 
SELECT top 8 d.ProdID, COUNT (d.ProdID) FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
--LEFT JOIN t_SalePays sp ON sp.ChID = m.ChID
--LEFT JOIN t_MonRec mr ON mr.DocID = m.DocID and mr.OurID = m.OurID
WHERE m.OurID =12 and CRID = 10 and m.DocDate > '20180101' 
group by d.ProdID
ORDER BY COUNT (d.ProdID) desc


SELECT * FROM r_Prods where ProdID in (603796,603752,603778,605327,603829)
*/
/*
DECLARE @BDiap INT = 1700000000,
		@EDiap INT = 1799999999;

(SELECT * FROM t_Sale m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_SaleD m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_SalePays m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_SaleDLV m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_zRep m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_MonRec m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_MonIntRec m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_MonIntExp m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
*/