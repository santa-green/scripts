--OurID	StockID	SubStockID	EDate	ProdID	Qty
--6	1257	1257	2018-01-18 00:00:00	603752	4.000000000

--OurID	StockID	SubStockID	EDate	ProdID	Qty
--6	1257	1257	2018-01-16 00:00:00	603752	7.000000000

--SELECT * FROM dbo.af_GetSpecSubs(@OurID, @StockID, @SubStockID, @EDate , @ProdID, @Qty)
SELECT * FROM dbo.af_GetSpecSubs(6, 1257, 1257, '2018-01-18' , 603752, 4)
SELECT * FROM dbo.af_GetSpecSubs(6, 1257, 1257, '2018-01-16' , 603752, 7)
SELECT * FROM dbo.af_GetSpecSubs(6, 1257, 1257, '2018-01-16' , 603752, 7)
SELECT ss.ProdID SubProdID, rp.UM SubUM, mq.BarCode SubBarCode, ss.Qty SubQty
FROM t_SRecA a WITH(NOLOCK)
OUTER  APPLY dbo.af_GetSpecSubs(6, 1257, 1257, '2018-01-16' , 603752, 7) ss
JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = ss.ProdID
LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
WHERE a.AChID = 146050
ORDER BY a.SrcPosID, ss.ProdID

SELECT * FROM dbo.tf_GetRem
SELECT dbo.tf_GetRemTotal(6, 1257, 1, 605833) rem_605833


BEGIN TRAN

SELECT (SELECT SUM(Qty - AccQty) FROM dbo.af_CalcRemD_F('2018-01-16',6,1257,1,603752)) af_CalcRemD_F_603752

SELECT * FROM dbo.af_GetSpecSubs(6, 1257, 1257, '2018-01-16' , 603752, 7)

	INSERT t_SRecA (ChID, SrcPosID, ProdID, PPID, UM, Qty, SetCostCC, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
           Extra, PriceCC, NewPriceCC_nt, NewSumCC_nt, NewTax, NewTaxSum, NewPriceCC_wt, NewSumCC_wt, AChID, BarCode, SecID)             
	SELECT 11466, 8, 603752, 0, 'порц', 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1460571, 26, 1   
	
SELECT (SELECT SUM(Qty - AccQty) FROM dbo.af_CalcRemD_F('2018-01-16',6,1257,1,603752)) af_CalcRemD_F_603752
	  
SELECT * FROM dbo.af_GetSpecSubs(6, 1257, 1257, '2018-01-16' , 603752, 7)

ROLLBACK TRAN


BEGIN TRAN

SELECT (SELECT SUM(Qty - AccQty) FROM dbo.af_CalcRemD_F('2018-01-18',6,1257,1,603752)) af_CalcRemD_F_603752

SELECT * FROM dbo.af_GetSpecSubs(6, 1257, 1257, '2018-01-18' , 603752, 7)

	INSERT t_SRecA (ChID, SrcPosID, ProdID, PPID, UM, Qty, SetCostCC, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
           Extra, PriceCC, NewPriceCC_nt, NewSumCC_nt, NewTax, NewTaxSum, NewPriceCC_wt, NewSumCC_wt, AChID, BarCode, SecID)             
	SELECT 11466, 8, 603752, 0, 'порц', 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1460571, 26, 1   
	
SELECT (SELECT SUM(Qty - AccQty) FROM dbo.af_CalcRemD_F('2018-01-18',6,1257,1,603752)) af_CalcRemD_F_603752
	  
SELECT * FROM dbo.af_GetSpecSubs(6, 1257, 1257, '2018-01-18' , 603752, 7)

ROLLBACK TRAN