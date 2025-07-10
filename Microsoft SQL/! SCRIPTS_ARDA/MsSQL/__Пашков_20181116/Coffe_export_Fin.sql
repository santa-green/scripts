
BEGIN TRAN

DECLARE @ROLLBACK_TRAN  int = 1       -- 1 тестирование c откатом, выполнится ROLLBACK TRAN   0 рабочий режим, выполнится COMMIT TRAN

USE ElitR

--установить дату наборов
IF OBJECT_ID (N'tempdb..#D', N'U') IS NOT NULL DROP TABLE #D
CREATE TABLE #D (BDate SMALLDATETIME, EDate SMALLDATETIME)
INSERT #D 
 SELECT '20181004' BDate, --начало периода поиска по продажам в ElitR и дата создания всех документов
		'20181004' EDate  --конец периода поиска по продажам в ElitR
SELECT top 1 BDate, EDate FROM #D 


SELECT * FROM t_Sale where DocDate >= (SELECT top 1 BDate FROM #D) and OurID =12 and CRID = 10 ORDER BY 1 desc

SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_Sale  where docdate between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D) ORDER BY DocDate desc


INSERT dbo.t_Sale
	SELECT (ChID + 200000) ChID,(70000 + DocID) DocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, Notes, CRID, OperID, CreditID, DocTime, TaxDocID, TaxDocDate, DCardID, EmpID, IntDocID, CashSumCC, ChangeSumCC, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DeskCode, Visitors, TPurSumCC_nt, TPurTaxSum, TPurSumCC_wt, DocCreateTime, DepID, 0 ClientID, 0 InDocID, 0 ExpTime, 0 DeclNum, 0 DeclDate, 0 BLineID, TRealSum, TLevySum, 0 RemSChId 
	FROM [192.168.42.22].ElitCP1.dbo.t_Sale  where docdate between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D)
	ORDER BY 1 desc
--SELECT * FROM t_Sale where DocDate < (SELECT top 1 BDate FROM #D) and OurID =12 and CRID = 10 ORDER BY 1 desc

 --be carefull. This must write only after t_Sale.
INSERT dbo.t_SaleD
	SELECT (ChID + 200000) ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, Discount, 0 DepID, 0 IsFiscal, 0 SubStockID, 0 OutQty, EmpID, CreateTime, ModifyTime, TaxTypeID, RealPrice, RealSum 
	FROM [192.168.42.22].ElitCP1.dbo.t_SaleD  
	where chid in (SELECT ChID FROM [192.168.42.22].ElitCP1.dbo.t_Sale  where docdate between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D))
	ORDER BY 1

INSERT dbo.t_MonIntExp -- it is empty in dates bigger than '2018-08-24'. Last record was at '2018-08-24'
	SELECT (ChID + 10000 ) ChID, OurID, CRID, DocDate, DocTime, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, SumCC, Notes, OperID, StateCode, (DocID + 500) DocID, (IntDocID + 500) IntDocID 
	FROM [192.168.42.22].ElitCP1.dbo.t_MonIntExp where docdate between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D) ORDER BY 5 desc
--SELECT * FROM t_MonIntExp where DocDate < (SELECT top 1 BDate FROM #D) and OurID =12 and CRID = 10 ORDER BY 1 desc

INSERT dbo.t_zRep
	SELECT (ChID + 10000) ChID,DocDate,DocTime,CRID,OperID,OurID,(DocID + 600) DocID,FacID,FinID,ZRepNum,SumCC_wt,Sum_A,Sum_B,Sum_C,Sum_D,RetSum_A,RetSum_B,RetSum_C,RetSum_D,SumCash,SumCard,SumCredit,SumCheque,SumOther,RetSumCash,RetSumCard,RetSumCredit,RetSumCheque,RetSumOther,SumMonRec,SumMonExp,SumRem,Notes,Sum_E,Sum_F,RetSum_E,RetSum_F,Tax_A,Tax_B,Tax_C,Tax_D,Tax_E,Tax_F,RetTax_A,RetTax_B,RetTax_C,RetTax_D,RetTax_E,RetTax_F 
	FROM [192.168.42.22].ElitCP1.dbo.t_zRep where docdate between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D)
--SELECT * FROM  t_zRep where docdate < (SELECT top 1 BDate FROM #D) and CRID = 10 and OurID = 12 ORDER BY 1 desc


INSERT dbo.t_MonRec
	SELECT (ChID + 100000) ChID,OurID,AccountAC,DocDate,(70000 + DocID) DocID,StockID,CompID,CompAccountAC,CurrID,KursMC,KursCC,SumAC,Subject,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,EmpID,StateCode,DepID 
	FROM [192.168.42.22].ElitCP1.dbo.t_MonRec  where docdate between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D) ORDER BY 1 desc
--SELECT * FROM t_MonRec where DocDate < (SELECT top 1 BDate FROM #D) and OurID =12 and StockID = 1001 ORDER BY 1 desc

/*

	SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_MonRec  where docdate between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D) ORDER BY 1 
	SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_MonRec  where ChID in (70279179,70279180) 
	delete [192.168.42.22].ElitCP1.dbo.t_MonRec  where ChID in (70279179,70279180) 


SELECT * FROM t_Sale where docdate < (SELECT top 1 BDate FROM #D) and CRID = 10 and OurID = 12 ORDER BY 1 desc
SELECT * FROM t_Sale where 70318280 < chid and  79348280 > chid and OurID = 12 ORDER BY 1 desc
70348280
70284715
SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_Sale  where docdate between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D)
ORDER BY 1
SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_Sale where chid in (70283901,70283902,70283903)
delete [192.168.42.22].ElitCP1.dbo.t_Sale where chid in (70283901,70283902,70283903)
SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_Sale where chid in (70283905)
SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_Saled where chid in (70283905)
delete [192.168.42.22].ElitCP1.dbo.t_Sale where chid in (70283905)
update d
set CreateTime = dateadd(dd,-1,CreateTime), ModifyTime = dateadd(dd,-1,ModifyTime)
 FROM [192.168.42.22].ElitCP1.dbo.t_Saled d where chid in (70283905)
*/


/*
--INSERT dbo.t_SaleDLV -- it is empty
SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_SaleDLV

--INSERT dbo.t_MonIntRec -- it is empty in dates bigger than '2018-08-24'
	SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_MonIntRec where DocDate > (SELECT top 1 BDate FROM #D)
SELECT * FROM t_MonIntRec where/* DocDate > (SELECT top 1 BDate FROM #D)and*/ OurID =12 /*and StockID = 1001*/ ORDER BY 4 desc



--INSERT dbo.t_CRRet	-- it is empty
	SELECT ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CRID, OperID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, CreditID, DCardID, SrcDocID, SrcDocDate, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DocTime, TaxDocID, TaxDocDate, DepID, null ClientID, null InDocID, null DeclNum, null DeclDate, null DeskCode, null BLineID, TRealSum, TLevySum, null RemSChId 
	FROM [192.168.42.22].ElitCP1.dbo.t_CRRet where docdate between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D)

--INSERT dbo.t_CRRetDLV -- it is empty
	SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_CRRetDLV

--INSERT dbo.t_CRRetD -- it is empty
	SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_CRRetD
	WHERE ChID in (SELECT ChID  FROM [192.168.42.22].ElitCP1.dbo.t_CRRet where CreateTime between (SELECT top 1 BDate FROM #D) and (SELECT top 1 EDate FROM #D))


--SELECT * FROM [192.168.42.22].ElitCP1.dbo.t_CRRet  where DocDate > '2018-08-24' ORDER BY DocDate desc
--SELECT * FROM dbo.t_CRRetDLV order by 3 desc
--SELECT * FROM dbo.t_Sale where chid > 70002365 and  chid < 79002365 order by 3 desc

*/

SELECT * FROM t_Sale where DocDate >= (SELECT top 1 BDate FROM #D) and OurID =12 and CRID = 10 ORDER BY 1 desc


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
SELECT top 5 d.ProdID, COUNT (d.ProdID) FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
--LEFT JOIN t_SalePays sp ON sp.ChID = m.ChID
--LEFT JOIN t_MonRec mr ON mr.DocID = m.DocID and mr.OurID = m.OurID
WHERE m.OurID =12 and CRID = 10 and m.DocDate > '20180101' 
group by d.ProdID
ORDER BY COUNT (d.ProdID) desc


SELECT * FROM r_Prods where ProdID in (603796,603752,603778,605327,603829)
*/