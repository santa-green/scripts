
ALTER PROCEDURE [dbo].[t_SaleMenu](@ChID int, @CRID int, @PCatID int, @PGrID int, @OurID int, @StockID int, @SecID int)
/* ¬озвращает меню дл€ торговых модулей */
AS
BEGIN
  CREATE TABLE #SaleMenu(
    ProdID int,
    ProdName varchar(200),
    UM varchar(10),
    PriceCC_wt numeric(21, 9),
    IsDecQty bit,
    PriceWithTax bit,
    BarCode varchar(42),
    Qty numeric(21, 9)
  )

  IF @PCatID IS NULL
    INSERT INTO #SaleMenu(ProdID, ProdName, UM, PriceCC_wt, IsDecQty, PriceWithTax, BarCode, Qty)
    SELECT p.ProdID, p.ProdName, p.UM, 0, p.IsDecQty, p.PriceWithTax, m.BarCode, m.Qty
    FROM r_Prods p WITH(NOLOCK), r_ProdMQ m WITH(NOLOCK)
    WHERE p.ProdID = m.ProdID AND p.UM = m.UM
    AND p.ProdID <> 0
  ELSE
    IF (@PGrID IS NULL)
      INSERT INTO #SaleMenu(ProdID, ProdName, UM, PriceCC_wt, IsDecQty, PriceWithTax, BarCode, Qty)
      SELECT p.ProdID, p.ProdName, p.UM, 0, p.IsDecQty, p.PriceWithTax, m.BarCode, m.Qty
      FROM r_Prods p WITH(NOLOCK), r_ProdMQ m WITH(NOLOCK)
      WHERE p.ProdID = m.ProdID AND p.UM = m.UM AND PCatID = @PCatID
      AND p.ProdID <> 0
    ELSE
      INSERT INTO #SaleMenu(ProdID, ProdName, UM, PriceCC_wt, IsDecQty, PriceWithTax, BarCode, Qty)
      SELECT p.ProdID, p.ProdName, p.UM, 0, p.IsDecQty, p.PriceWithTax, m.BarCode, m.Qty
      FROM r_Prods p WITH(NOLOCK), r_ProdMQ m WITH(NOLOCK)
      WHERE p.ProdID = m.ProdID AND p.UM = m.UM AND PCatID = @PCatID AND PGrID = @PGrID
      AND p.ProdID <> 0
		 UNION 
      SELECT m.SubProdID, p.ProdName, p.UM, 0, p.IsDecQty, p.PriceWithTax, mq.BarCode, mq.Qty
      FROM it_ComplexMenu m WITH(NOLOCK), r_Prods p WITH(NOLOCK), r_ProdMQ mq WITH(NOLOCK)
      WHERE m.SubProdID = p.ProdID AND p.ProdID = mq.ProdID AND p.UM = mq.UM AND m.ProdID = @PCatID AND m.SrcPosID = @PGrID
      AND p.ProdID <> 0
  
  DECLARE ProdCursor CURSOR  FAST_FORWARD FOR
  SELECT BarCode, Qty FROM #SaleMenu

  DECLARE @BarCode varchar(42)
  DECLARE @PLID int
  DECLARE @PriceCC_wt numeric(21, 9)
  DECLARE @Qty numeric(21, 9)
  DEClARE @AResult int
  DECLARE @Msg varchar(200)

  OPEN ProdCursor
  FETCH NEXT FROM ProdCursor INTO @BarCode, @Qty

  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC t_GetSaleParams /*1011, */@ChID, @CRID, @BarCode, @Qty, 0, @PriceCC_wt OUTPUT, @PLID OUTPUT, @AResult OUTPUT/*, @Msg OUTPUT*/
      IF @AResult = 1
        UPDATE #SaleMenu
        SET PriceCC_wt = @PriceCC_wt
        WHERE BarCode = @BarCode

      FETCH NEXT FROM ProdCursor INTO @BarCode, @Qty
    END

  CLOSE ProdCursor
  DEALLOCATE ProdCursor
  DELETE FROM #SaleMenu WHERE PriceCC_wt <= 0
  /*IF dbo.zf_Var('t_SaleHideZeroRems') = '1' DELETE FROM #SaleMenu WHERE (dbo.tf_GetRemTotal(@OurID, @StockID, @SecID, ProdID) <= 0)*/
  
  SELECT * FROM #SaleMenu m
  INNER JOIN r_Prods p WITH(NOLOCK) ON p.ProdID = m.ProdID 
  INNER JOIN r_ProdMP mp WITH(NOLOCK) ON p.ProdID = mp.ProdID
  INNER JOIN r_Stocks s WITH(NOLOCK) ON mp.PLID = s.PLID  
  WHERE 
	s.StockID = @StockID AND mp.InUse = 1
	AND p.ProdID <> (CASE WHEN (DATEPART(dw, GETDATE()) <> 4) AND  @StockID = 1310 THEN 605734 ELSE 0 END )
ORDER BY m.ProdName
  DROP TABLE #SaleMenu
END
