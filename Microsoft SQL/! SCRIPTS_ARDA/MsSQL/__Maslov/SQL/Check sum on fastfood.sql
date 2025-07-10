

SELECT 
(SELECT SUM(SumAC) FROM t_MonRec WHERE DocID = m.DocID) One
,(SELECT SUM(SumCC_wt) FROM t_SalePays WHERE ChID = m.ChID) Two
,(SELECT SUM(TRealSum) FROM t_Sale WHERE ChID = m.ChID) Three
,*
 FROM t_Sale m
JOIN t_SaleD d on d.ChID = m.ChID
JOIN t_SalePays sp on sp.ChID = m.ChID
JOIN r_Prods p on p.ProdID = d.ProdID
WHERE (SELECT SUM(SumAC) FROM t_MonRec WHERE DocID = m.DocID) != (SELECT SUM(SumCC_wt) FROM t_SalePays WHERE ChID = m.ChID)
	  OR (SELECT SUM(SumCC_wt) FROM t_SalePays WHERE ChID = m.ChID) != (SELECT SUM(TRealSum) FROM t_Sale WHERE ChID = m.ChID)
--WHERE m.docid = 1700021972
ORDER BY DocDate

DECLARE @ChID bigint = 1700021972
	IF (SELECT SUM(SumAC) FROM t_MonRec WITH(NOLOCK) WHERE DocID = (SELECT top 1 m.DocID FROM t_Sale m WITH(NOLOCK) WHERE m.ChID = @ChID)) != (SELECT SUM(SumCC_wt) FROM t_SalePays WITH(NOLOCK) WHERE ChID = @ChID) OR (SELECT SUM(SumCC_wt) FROM t_SalePays WITH(NOLOCK) WHERE ChID = @ChID) != (SELECT SUM(TRealSum) FROM t_Sale WITH(NOLOCK) WHERE ChID = @ChID)
		BEGIN
		RAISERROR('[t_SaleAfterClose] ВНИМАНИЕ!!! Ошибка в суммах чека и оплаты. Обратитесь в техподдержку 067-560-45-92. support_arda@const.dp.ua!!!', 18, 1)
		END;
SELECT SUM(SumAC) FROM t_MonRec WHERE DocID = 1700021972
SELECT SUM(SumCC_wt) FROM t_SalePays WHERE ChID = 1700021972
SELECT SUM(TRealSum) FROM t_Sale WHERE ChID = 1700021972

/*
SELECT * FROM t_sale

BEGIN TRAN;

DISABLE TRIGGER ALL ON t_Sale;

UPDATE t_Sale
SET CurrID = 981 
WHERE ChID = 1700000006;


ENABLE TRIGGER ALL ON t_Sale;

RAISERROR('[t_SaleAfterClose] ВНИМАНИЕ!!! Ошибка в суммах чека и оплаты. Обратитесь в техподдержку 067-560-45-92. support_arda@const.dp.ua!!!', 18, 1)
SELECT * FROM t_sale
WHERE ChID = 1700000006
ROLLBACK TRAN;
*/