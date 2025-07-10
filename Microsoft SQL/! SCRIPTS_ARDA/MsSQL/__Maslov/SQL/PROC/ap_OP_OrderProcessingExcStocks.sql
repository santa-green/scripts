ALTER PROCEDURE [dbo].[ap_OP_OrderProcessingExcStocks](@AChID INT, @FromStockID INT, @StockID INT, @WithAcc BIT) AS BEGIN
/*
EXEC ap_OP_OrderProcessingExcStocks 102159889, 220, 30, 1
*/

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @ExcChID INT
DECLARE @ExcDocID INT
DECLARE @ContractChID INT
-- Параметры ЗФ
DECLARE @IOOurID INT, @IODate smalldatetime
SELECT @IOOurID=OurID, @IODate=DocDate FROM t_IORec WHERE ChID=@AChID
-- Валюта
DECLARE @CurrID SMALLINT=dbo.zf_GetCurrCC()
-- Курс
DECLARE @KursMC NUMERIC(21,9)=dbo.zf_GetRateMC(@CurrID)
-- Цены для перемещения
DECLARE @PLID INT=106
-- Метод списания
DECLARE @t_PP TINYINT=dbo.zf_Var('t_PP')
-- Контракт
EXEC dbo.ap_GetContract 11221, @AChID, @ContractChID OUTPUT

-- Таблица для дефицитного товара
DECLARE @DefProds TABLE (ChID INT, ProdID INT, UM VARCHAR(10), BarCode VARCHAR(42), DefQty NUMERIC(21,9))

-- Получаем дефицитный товар
INSERT INTO @DefProds
  SELECT 
    m.ChID, d.ProdID, d.UM, d.BarCode,
    SUM(d.Qty)-ISNULL((SELECT SUM(Qty) FROM dbo.af_GetPPIDsByContract(@t_PP, @ContractChID, 0, @IODate, m.OurID, @StockID, d.ProdID, 100000)), 0)
  FROM
    t_IORec m WITH(NOLOCK) INNER JOIN 
    t_IORecD d WITH(NOLOCK) ON d.ChID=m.ChID
  WHERE m.ChID=@AChID
  GROUP BY m.ChID, m.OurID, d.SecID, d.ProdID, d.UM, d.BarCode

--Если есть счета, в которых есть товар из заказа.
IF EXISTS(SELECT 1
				FROM t_Acc m 
				JOIN t_AccD d WITH(NOLOCK) ON d.ChID = m.ChID
				--Только счета со статусом StateCode = 105.
				WHERE m.StateCode = 105
				  AND m.StockID  = @StockID
				  AND d.ProdID IN (SELECT DISTINCT ProdID FROM @DefProds WHERE DefQty > 0
								  )
				  AND d.Qty > 0
		  )
	AND @WithAcc = 1
BEGIN 	  
	  --Записываем найденное количество.
	  UPDATE DefProds
	  SET DefQty = DefQty - Acc.Qty
	  FROM @DefProds DefProds
	  JOIN (SELECT d.ProdID, SUM(d.Qty) AS Qty
				FROM t_Acc m 
				JOIN t_AccD d WITH(NOLOCK) ON d.ChID = m.ChID
				--Только счета со статусом StateCode = 105.
				WHERE m.StateCode = 105
				  AND m.StockID  = @StockID
				  AND d.ProdID IN (SELECT DISTINCT ProdID FROM @DefProds WHERE DefQty > 0
								  )
				  AND d.Qty > 0
			 GROUP BY d.ProdID
		  ) Acc ON Acc.ProdID = DefProds.ProdID
	  WHERE DefProds.DefQty > 0
END;

-- Удаляем недефицит
DELETE FROM @DefProds WHERE DefQty<=0
-- Если нечего перемещать - на выход
IF NOT EXISTS(SELECT * FROM @DefProds) RETURN

-- Параметры для перемещения

EXEC dbo.z_NewChID 't_Exc', @ExcChID OUT
EXEC dbo.z_NewDocID 11021, 't_Exc', @IOOurID, @ExcDocID OUT
PRINT @AChID
PRINT @ExcChID
PRINT @ExcDocID
PRINT @CurrID
PRINT @t_PP
PRINT @ContractChID
PRINT @IODate
BEGIN TRAN
  -- Шапка перемещения
  INSERT dbo.t_Exc(ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, NewStockID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, SrcDocID, SrcDocDate, CompID, Discount, CurrID, StateCode, FwdID, DriverID)
    SELECT DISTINCT /*Top 1*/ @ExcChID ChID, @ExcDocID DocID, IntDocID, DocDate, KursMC, OurID, @FromStockID AS 'StockID', m.StockID NewStockID, 40 CodeID1, 18 CodeID2, 1 CodeID3, 0 CodeID4, 0 CodeID5, EmpID
							 ,SUBSTRING(Notes + ' Автоматически - ap_OP_OrderProcessingExcStocks ' + CAST(@StockID AS VARCHAR(10)) + ' ' + CAST(@FromStockID AS VARCHAR(10) ),1,250) AS 'Notes'
							 ,DocID SrcDocID, DocDate SrcDocDate, 0 CompID, 0 Discount, @CurrID CurrID, 127 StateCode, 0 FwdID, 0 DriverID
    FROM t_IORec m WITH(NOLOCK)
		 INNER JOIN @DefProds d ON d.ChID=m.ChID 
		 CROSS APPLY dbo.af_GetPPIDsByContract(@t_PP, @ContractChID, 1, m.DocDate, m.OurID, @FromStockID, d.ProdID, d.DefQty) pp
    WHERE m.ChID=@AChID
	--order by pp.StockID 
	--and pp.StockID not in (18,20) -- По просьбе Кельман исключил склад.
    
  -- Детальная часть перемещения
  INSERT dbo.t_ExcD (ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, NewSecID)
   	SELECT 
       @ExcChID, ROW_NUMBER() OVER(ORDER BY f.SrcPosID), d.ProdID, f.PPID, UM, f.Qty
      ,dbo.zf_GetProdPrice_nt(ISNULL(mp.PriceMC*@KursMC, 0), d.ProdID, @IODate) PriceCC_nt
      ,dbo.zf_GetProdPrice_nt(ISNULL(mp.PriceMC*@KursMC, 0), d.ProdID, @IODate)*f.Qty SumCC_nt
      ,dbo.zf_GetProdPrice_wtTax(ISNULL(mp.PriceMC*@KursMC, 0), d.ProdID, @IODate) Tax
      ,dbo.zf_GetProdPrice_wtTax(ISNULL(mp.PriceMC*@KursMC, 0), d.ProdID, @IODate)*f.Qty TaxSum
      ,ISNULL(mp.PriceMC*@KursMC, 0) PriceCC_wt, ISNULL(mp.PriceMC*@KursMC, 0)*f.Qty SumCC_wt, d.BarCode, 1 SecID, 1 NewSecID
    FROM @DefProds d
	   LEFT JOIN dbo.r_ProdMP mp WITH(NOLOCK) ON mp.ProdID=d.ProdID AND mp.PLID=@PLID
	   CROSS APPLY dbo.af_GetPPIDsByContract(@t_PP, @ContractChID, 1, @IODate, @IOOurID, @FromStockID, d.ProdID, d.DefQty) f 
  
  -- Связываем ЗФ с перемещением, ЗФ - основополагающий
  EXEC ap_LinkCreate @PDocCode=11221, @PChID=@AChID, @СDocCode=11021, @СChID=@ExcChID

IF @@TRANCOUNT>0 COMMIT

END