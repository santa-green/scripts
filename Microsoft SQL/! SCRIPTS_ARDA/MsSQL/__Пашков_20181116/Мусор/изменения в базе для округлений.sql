--изменения в базе для округлений  CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9))
--1
ALTER FUNCTION [dbo].[zf_GetChequeSumCC_wt](@ChID int)/* Возвращает сумму чека */RETURNS numeric(21, 9)BEGIN  DECLARE @SumCC_wt numeric(21, 9)  SELECT    @SumCC_wt = SUM(dbo.zf_Round(PriceCC_wt * Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)) ))  FROM t_SaleTempD WITH(NOLOCK)  WHERE ChID = @ChID  RETURN @SumCC_wtEND

GO--2
ALTER PROCEDURE [dbo].[t_DiscUpdateCancels](@DocCode int, @ChID int, @SrcPosID int, @PriceCC_wt numeric(21, 9))/* Изменяет цены и суммы для отмен данной позиции */ASBEGIN  IF @PriceCC_wt IS NULL    SELECT @PriceCC_wt = PriceCC_wt FROM dbo.tf_DiscDoc(@DocCode, @ChID) WHERE SrcPosID = @SrcPosID  DECLARE @SumCC_wt numeric(21, 9)  DECLARE @SrcPosID1 int  DECLARE @Qty numeric(21, 9)  DECLARE CancelsCursor CURSOR FAST_FORWARD FOR  SELECT SrcPosID, Qty FROM dbo.tf_DiscDoc(@DocCode, @ChID) WHERE CSrcPosID = @SrcPosID AND SrcPosID <> @SrcPosID  OPEN CancelsCursor  FETCH NEXT FROM CancelsCursor  INTO @SrcPosID1, @Qty  WHILE @@FETCH_STATUS = 0    BEGIN      SELECT @SumCC_wt = dbo.zf_Round(@PriceCC_wt * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))      EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID1, @PriceCC_wt, @SumCC_wt      FETCH NEXT FROM CancelsCursor      INTO @SrcPosID1, @Qty    END  CLOSE CancelsCursor  DEALLOCATE CancelsCursorENDGO--3ALTER PROCEDURE [dbo].[t_CorrectSalePrice](@DocCode int, @ChID int,
  @ProdID int, @RateMC numeric(21, 9), @Qty numeric(21, 9), @AllowZeroPrice bit, @PriceCC_wt numeric(21, 9) OUTPUT)
/* Корректирует цену продажи с учетом ограничений */
AS
BEGIN
  DECLARE @MinSalePrice numeric(21, 9)
  DECLARE @MaxSalePrice numeric(21, 9)
  SELECT @MinSalePrice = dbo.zf_RoundPriceSale(IndRetPriceCC * 1), @MaxSalePrice = dbo.zf_RoundPriceSale(MaxPriceMC * 1) FROM r_Prods WITH(NOLOCK) WHERE ProdID = @ProdID

  IF @DocCode = 1011 AND (SELECT TOP 1 CashType FROM t_SaleTemp s, r_CRs c WITH(NOLOCK) WHERE s.CRID = c.CRID AND s.ChID = @ChID) <> 8
    BEGIN
      IF @MinSalePrice = 0
        SET @MinSalePrice = CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9))
      IF (@Qty > 0) AND (dbo.zf_RoundPriceSale(@MinSalePrice * @Qty) < CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))
        SET @MinSalePrice = dbo.zf_RoundPriceSale(CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)) / @Qty)
    END

  IF @AllowZeroPrice = 1 
    SELECT @MinSalePrice = 0

  IF @PriceCC_wt > @MaxSalePrice AND @MaxSalePrice <> 0
    SET @PriceCC_wt = @MaxSalePrice

  IF @PriceCC_wt < @MinSalePrice
    SET @PriceCC_wt = @MinSalePrice
END

GO--4
ALTER FUNCTION [dbo].[tf_GetDCardPaySum](@DocCode int, @ChID int, @DCardID varchar(250), @PayFormCode int)/* Возвращает максимальну сумму для оплаты дисконтной картой */RETURNS numeric(21, 9) ASBEGIN  DECLARE @AutoCalcSum int  DECLARE @MaxSum numeric(21, 9)  SELECT @AutoCalcSum = AutoCalcSum FROM r_PayForms WITH(NOLOCK) WHERE PayFormCode = @PayFormCode  SELECT @MaxSum = CASE @AutoCalcSum    WHEN 0 THEN 0    WHEN 1 THEN (SELECT SumBonus FROM r_DCards WITH(NOLOCK) WHERE DCardID = @DCardID)    WHEN 2 THEN (SELECT SumCC FROM r_DCards WITH(NOLOCK) WHERE DCardID = @DCardID)    WHEN 3 THEN (SELECT Value1 FROM r_DCards WITH(NOLOCK) WHERE DCardID = @DCardID)    WHEN 4 THEN (SELECT Value2 FROM r_DCards WITH(NOLOCK) WHERE DCardID = @DCardID)    WHEN 5 THEN (SELECT Value3 FROM r_DCards WITH(NOLOCK) WHERE DCardID = @DCardID)    WHEN 6 THEN (SELECT t.InitSum FROM r_DCards d WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DCTypeCode = t.DCTypeCode AND d.DCardID = @DCardID)    WHEN 7 THEN (SELECT t.Value1 FROM r_DCards d WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DCTypeCode = t.DCTypeCode AND d.DCardID = @DCardID)    WHEN 8 THEN (SELECT t.Value2 FROM r_DCards d WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DCTypeCode = t.DCTypeCode AND d.DCardID = @DCardID)    WHEN 9 THEN (SELECT t.Value3 FROM r_DCards d WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DCTypeCode = t.DCTypeCode AND d.DCardID = @DCardID)    WHEN 10 THEN ISNULL((SELECT SUM(SumBonus) FROM z_LogDiscRec WITH(NOLOCK) WHERE DCardID = @DCardID), 0) - ISNULL((SELECT SUM(SumBonus) FROM z_LogDiscExp WITH(NOLOCK) WHERE DCardID = @DCardID), 0)    WHEN 11 THEN (SELECT SUM(SumBonus) FROM z_LogDiscExp WITH(NOLOCK) WHERE DocCode = @DocCode AND ChID = @ChID AND DCardID = @DCardID)    WHEN 12 THEN (CASE @DocCode WHEN 1011 THEN dbo.zf_GetChequeSumCC_wt(@ChID) WHEN 11004 THEN dbo.zf_GetRetChequeSumCC_wt(@ChID) ELSE 0 END)  END  RETURN ISNULL(dbo.zf_Round(@MaxSum, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)) ), 0)END GO--5ALTER FUNCTION [dbo].[tf_GetCostSum](@DocCode int, @ChID int, @SrcPosID int)/* Рассчитывает затраты для указаной позиции документа */RETURNS numeric(21, 9) ASBEGIN DECLARE @DocSum numeric(21, 9) DECLARE @Cost  numeric(21, 9) DECLARE @ACostSum numeric(21, 9) /* Приход товара */ IF @DocCode = 11002   BEGIN    IF NOT EXISTS(SELECT TOP 1 1 FROM r_Prods r, r_ProdBG b WHERE r.PBGrID=b.PBGrID AND b.Tare=0 AND r.ProdID = (SELECT ProdID FROM t_RecD WHERE SrcPosID = @SrcPosID AND (ChID = @ChID))) RETURN NULL   SET @Cost = (SELECT SumCC_wt FROM t_RecD WHERE ChID = @ChID AND SrcPosID = @SrcPosID )   SET @DocSum = (SELECT SUM (SumCC_wt)  FROM ((t_RecD m INNER JOIN r_Prods r ON r.ProdID=m.ProdID) INNER JOIN r_ProdBG b ON b.PBGrID=r.PBGrID) WHERE Tare = 0 AND m.ChID = @ChID)   SET @ACostSum = (SELECT TSpendSumCC + TRouteSumCC FROM t_Rec WHERE ChID = @ChID)  END /* Формирование себестоимости */ ELSE IF @DocCode = 11040   BEGIN   IF NOT EXISTS(SELECT TOP 1 1 FROM r_Prods r, r_ProdBG b WHERE r.PBGrID=b.PBGrID AND b.Tare=0 AND r.ProdID = (SELECT ProdID FROM t_CosD WHERE SrcPosID = @SrcPosID AND (ChID = @ChID))) RETURN NULL   SET @Cost = (SELECT SumCC_wt FROM t_CosD WHERE ChID = @ChID AND SrcPosID = @SrcPosID )   SET @DocSum = (SELECT SUM (SumCC_wt)  FROM ((t_CosD m INNER JOIN r_Prods r ON r.ProdID=m.ProdID) INNER JOIN r_ProdBG b ON b.PBGrID=r.PBGrID) WHERE Tare = 0 AND m.ChID = @ChID)   SET @ACostSum = (SELECT TSpendSumCC FROM t_Cos WHERE ChID = @ChID)  END /* ТМЦ: Приход по накладной */ ELSE IF @DocCode = 14102   BEGIN    IF NOT EXISTS(SELECT TOP 1 1 FROM r_Prods r, r_ProdBG b WHERE r.PBGrID=b.PBGrID AND b.Tare=0 AND r.ProdID = (SELECT ProdID FROM b_RecD WHERE SrcPosID = @SrcPosID AND (ChID = @ChID))) RETURN NULL   SET @Cost = (SELECT SumCC_nt FROM b_RecD WHERE ChID = @ChID AND SrcPosID = @SrcPosID )   SET @DocSum = (SELECT SUM (SumCC_nt)  FROM ((b_RecD m INNER JOIN r_Prods r ON r.ProdID=m.ProdID) INNER JOIN r_ProdBG b ON b.PBGrID=r.PBGrID) WHERE Tare = 0 AND m.ChID = @ChID)   SET @ACostSum = (SELECT TranCC + MoreCC FROM b_Rec WHERE ChID = @ChID)  END RETURN dbo.zf_Round((@Cost / @DocSum) * @ACostSum, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)) )ENDGO--6ALTER PROCEDURE [dbo].[t_DiscGetPosPrice](@DocCode int, @ChID int, @SrcPosID smallint, @PriceCC_wt numeric(21, 9) OUTPUT, @SumCC_wt numeric (21, 9) OUTPUT)
/* Возвращает цену и сумму по позиции с учетом предоставленных скидок */
AS
BEGIN
  DECLARE @ProdID int
  DECLARE @RateMC numeric(21, 9)
  DECLARE @Qty numeric(21, 9)
  DECLARE @CSrcPosID int
  DECLARE @SumBonus numeric(21, 9)
  DECLARE @Discount numeric(21, 9)
  DECLARE @AllowZeroPrice bit

  SELECT
    @ProdID = ProdID,
    @PriceCC_wt = PurPriceCC_wt,
    @SumCC_wt = PurPriceCC_wt * Qty,
    @Qty = Qty,
    @RateMC = RateMC,
    @CSrcPosID = CSrcPosID
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) WHERE SrcPosID = @SrcPosID

  IF (@Qty < 0)
    BEGIN
      /* В случае отмены берем цену из оригинальной позиции (с учетом скидки), вычисляем сумму и больше ничего не пересчитываем */
      SELECT
        @PriceCC_wt = PriceCC_wt
      FROM dbo.tf_DiscDoc(@DocCode, @ChID) WHERE SrcPosID = @CSrcPosID

      SET @SumCC_wt = dbo.zf_RoundPriceSale(@PriceCC_wt * @Qty)
      RETURN
    END

  IF dbo.zf_Var('t_SumDiscountMethod') = 0
    BEGIN
      DECLARE SumCursor CURSOR FAST_FORWARD FOR 
      SELECT SumBonus, Discount FROM z_LogDiscExp e JOIN r_Discs d ON e.DiscCode = d.DiscCode WHERE e.DocCode = @DocCode AND e.ChID = @ChID AND e.SrcPosID = @SrcPosID ORDER BY d.Priority

      OPEN SumCursor
      FETCH NEXT FROM SumCursor INTO @SumBonus, @Discount 
      WHILE @@FETCH_STATUS = 0
        BEGIN
          SELECT @SumCC_wt = dbo.zf_GetPriceWithDiscountNoRound(@SumCC_wt - @SumBonus, @Discount)
          FETCH NEXT FROM SumCursor INTO @SumBonus, @Discount 
        END

      CLOSE SumCursor
      DEALLOCATE SumCursor 
    END
  ELSE
    SELECT @SumCC_wt = dbo.zf_GetPriceWithDiscountNoRound(@SumCC_wt, ISNULL(SUM(Discount), 0)) - ISNULL(SUM(SumBonus), 0) FROM z_LogDiscExp WITH(NOLOCK) WHERE DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID
  IF @Qty <> 0
    SET @PriceCC_wt = dbo.zf_RoundPriceSale(@SumCC_wt / @Qty)

  SELECT @AllowZeroPrice = AllowZeroPrice FROM t_SaleTempD WHERE ChID = @ChID And SrcPosID = @SrcPosID
  EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt OUTPUT

  SET @SumCC_wt = dbo.zf_Round(@PriceCC_wt * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))
END

GO--7
ALTER PROCEDURE [dbo].[t_SaleCRCheque](@ChID int)/* Возвращает набор данных, по которому печатается чек. */ASBEGIN  SET NOCOUNT ON  DECLARE @UseProdNotes bit  DECLARE @GroupProds bit  DECLARE @TaxPayer bit  DECLARE @GroupSrcPosID_Table table(SrcPosID int NOT NULL, GroupField int NOT NULL, IsBonus bit NOT NULL)  SELECT @UseProdNotes = c.UseProdNotes, @GroupProds = c.GroupProds, @TaxPayer = o.TaxPayer  FROM t_SaleTemp m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_Ours o WITH(NOLOCK)  WHERE m.ChID = @ChID AND c.CRID = m.CRID AND m.OurID = o.OurID  /*    Обработка возможности группировки товаров в чеке    Для весовых товаров, если включена группировка и товар может быть сгруппирован без ошибок округления, он группируется, если нет, то    группировка производится по SrcPosID (т.е. фактически весовой товар по кол-ву позиций будет соответствовать тому, что на экране)  */  IF @GroupProds = 1    INSERT INTO @GroupSrcPosID_Table(SrcPosID, GroupField, IsBonus)    SELECT DISTINCT m.SrcPosID, CASE WHEN d.Sum1 = d.Sum2 THEN 0 ELSE m.CSrcPosID END, 0    FROM t_SaleTempD m WITH(NOLOCK) INNER JOIN (      SELECT ChID, ProdID, PLID, TaxTypeID, RealQty, PriceCC_wt, RealBarCode, EmpID,        dbo.zf_Round(SUM(PriceCC_wt * Qty), CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9))) Sum1, SUM(dbo.zf_Round(PriceCC_wt * Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))) Sum2      FROM t_SaleTempD WITH(NOLOCK)      WHERE ChID = @ChID      GROUP BY ChID, ProdID, PLID, TaxTypeID, RealQty, PriceCC_wt, RealBarCode, EmpID) d ON        m.ChID = d.ChID AND m.ProdID = d.ProdID AND m.PLID = d.PLID AND m.TaxTypeID = d.TaxTypeID AND        m.RealQty = d.RealQty AND m.PriceCC_wt = d.PriceCC_wt AND m.RealBarCode = d.RealBarCode AND m.EmpID = d.EmpID    WHERE m.ChID = @ChID  ELSE    INSERT INTO @GroupSrcPosID_Table(SrcPosID, GroupField, IsBonus)    SELECT m.SrcPosID, m.CSrcPosID, 0    FROM t_SaleTempD m WITH(NOLOCK)    WHERE m.ChID = @ChID  SELECT MIN(d.SrcPosID) SrcPosID, d.ProdID, (CASE WHEN @TaxPayer = 1 THEN d.TaxTypeID ELSE 1 END) TaxTypeID,    d.PriceCC_wt TPriceCC_wt, SUM(d.Qty) TQty, (CASE @UseProdNotes WHEN 0 THEN p.ProdName ELSE p.Notes END) ProdName  FROM t_SaleTempD d WITH(NOLOCK), r_Prods p WITH(NOLOCK), @GroupSrcPosID_Table g  WHERE d.ChID = @ChID AND d.ProdID = p.ProdID AND d.SrcPosID = g.SrcPosID AND d.Qty <> 0  GROUP BY d.ProdID, p.ProdName, p.Notes, d.PLID, d.TaxTypeID, d.RealQty, d.PriceCC_wt, d.RealBarCode, g.GroupField, g.IsBonusENDGO--8ALTER PROCEDURE [dbo].[t_DiscUpdateDocPoses](@DocCode int, @ChID int, @UseDocDisc bit)
/* Изменяет позиции документа с учетом предоставленных позиционных скидок */
AS
BEGIN
  DECLARE @SrcPosID int, @CSrcPosID int
  DECLARE @AllowZeroPrice bit

  DECLARE DocCursor CURSOR FAST_FORWARD FOR
  SELECT SrcPosID, CSrcPosID
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
  WHERE Qty > 0 
  ORDER BY SrcPosID

  OPEN DocCursor

  FETCH NEXT FROM DocCursor
  INTO @SrcPosID, @CSrcPosID

  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

      FETCH NEXT FROM DocCursor
      INTO @SrcPosID, @CSrcPosID
    END

  CLOSE DocCursor
  DEALLOCATE DocCursor

  IF @UseDocDisc = 0 RETURN

  /* Применение скидки по чеку */

  DECLARE @Discount numeric(21, 9)
  DECLARE @DiscSumCC numeric(21, 9)
  DECLARE @DocSumCC numeric(21, 9)
  DECLARE @PosDiscSumCCReal numeric(21, 9)

  EXEC t_DiscGetDocDisc @DocCode, @ChID, @DiscSumCC OUTPUT
  SELECT
    @DocSumCC = SUM(SumCC_wt),
    @PosDiscSumCCReal = SUM(PurSumCC_wt - SumCC_wt)
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)

  /* Рассчитываем базовую скидку, которую в дальнейшем будем уточнять */
  IF @DocSumCC <> 0
    SELECT @Discount = @DiscSumCC / @DocSumCC * 100
  ELSE
    SET @Discount = 100

  DECLARE @DiscSumCCReal numeric(21, 9)
  DECLARE @PriceCC_wt numeric(21, 9)
  DECLARE @SumCC_wt numeric(21, 9)
  DECLARE @PriceCC_wt1 numeric(21, 9)
  DECLARE @SumCC_wt1 numeric(21, 9)
  DECLARE @Qty numeric(21, 9)
  DECLARE @RateMC numeric(21, 9)
  DECLARE @ProdID int

  DECLARE DocCursor1 CURSOR SCROLL FOR
  SELECT m.SrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, t.AllowZeroPrice
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m
  JOIN t_SaleTempD t ON t.ChID = @ChID AND t.SrcPosID = m.SrcPosID
  WHERE m.Qty > 0 
  ORDER BY m.SumCC_wt DESC, m.SrcPosID

  OPEN DocCursor1

  FETCH NEXT FROM DocCursor1
  INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT @PriceCC_wt1 = dbo.zf_GetPriceWithDiscount(@PriceCC_wt, @Discount)
      EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
      SELECT @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

      EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID, @PriceCC_wt1, @SumCC_wt1
      EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosID, @PriceCC_wt1

      FETCH NEXT FROM DocCursor1
      INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice
    END

  CLOSE DocCursor1

  SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal FROM dbo.tf_DiscDoc(@DocCode, @ChID)

  /* Если фактически предоставленная сумма скидки меньше расчетной, снижаем цены начиная с первой позиции пока не достигнем необходимой суммы скидки */
  IF @DiscSumCCReal < @DiscSumCC
    BEGIN
      OPEN DocCursor1

      FETCH NEXT FROM DocCursor1
      INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice

      WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal < @DiscSumCC)
        BEGIN
          SET @SumCC_wt1 = @SumCC_wt - (@DiscSumCC - @DiscSumCCReal)
          IF @SumCC_wt1 < 0
            SELECT @SumCC_wt1 = 0
          SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
          EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
          SELECT @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

          EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID, @PriceCC_wt1, @SumCC_wt1
          EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosID, @PriceCC_wt1
          SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal FROM dbo.tf_DiscDoc(@DocCode, @ChID)

          FETCH NEXT FROM DocCursor1
          INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice
        END
      CLOSE DocCursor1

    END

  /* Если фактически предоставленная сумма скидки больше расчетной, увеличиваем цены начиная с первой позиции пока не достигнем необходимой суммы скидки */
  IF @DiscSumCCReal > @DiscSumCC
    BEGIN
      OPEN DocCursor1

      FETCH NEXT FROM DocCursor1
      INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice

      WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal > @DiscSumCC)
        BEGIN
          SET @SumCC_wt1 = @SumCC_wt + (@DiscSumCCReal - @DiscSumCC)
          SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
          EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
          SELECT @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

          EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID, @PriceCC_wt1, @SumCC_wt1
          EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosID, @PriceCC_wt1
          SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal FROM dbo.tf_DiscDoc(@DocCode, @ChID)

          FETCH NEXT FROM DocCursor1
          INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice
        END
      CLOSE DocCursor1

    END

  DEALLOCATE DocCursor1
END

GO--9
ALTER PROCEDURE [dbo].[ip_ChequePosComplexMenu]
(
	@ChID int, @ProdID int, @PLID int
)
AS



DECLARE @CMProdID int

SELECT
	TOP 1 @CMProdID = cm.ProdID
FROM it_ComplexMenu cm WITH (NOLOCK)
INNER JOIN r_ProdMP mp WITH (NOLOCK) ON cm.ProdID = mp.ProdID AND mp.PLID = @PLID
WHERE
	cm.SubProdID = @ProdID
	AND cm.ProdID <> @ProdID

IF @CMProdID IS NULL
RETURN



SELECT 
	d.PLID, cm.ProdID, cm.SrcPosID CMPosID, cm.IsRelated, 
	d.SrcPosID, d.Qty, cm.MaxQty, cm.SubProdID, cm.DetQty,
	d.Qty * mp.PriceMC PriceSumCC
INTO #SaleTempDC
FROM t_SaleTempD d WITH (NOLOCK)
INNER JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
INNER JOIN r_ProdMP mp WITH (NOLOCK) ON d.ProdID = mp.ProdID AND d.PLID = mp.PLID
WHERE 
	d.ChID = @ChID AND cm.ProdID = @CMProdID
	



  /*Принимается Доп.Количество (DetQty) - это одна условная единица от Максимального количества (MaxQty). 
	Т.е. DetQty=2 занимает одну единицу от MaxQty*/
SELECT 
	m.PLID, m.ProdID, 
	CASE WHEN CASE WHEN MAX(MaxQty) >= 1 AND SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / ISNULL(NULLIF(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)),0), MAX(m.Qty)) > MAX(MaxQty)
				   THEN CAST(CEILING(SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / MAX(MaxQty)) AS numeric(21, 9)) 
				   ELSE CAST(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)) AS numeric(21, 9))
			  END < MAX(CMQty) /*Обработка, если количество порций сопутствующих товаров больше количества корзин основных блюд - использовать его*/
		 THEN MAX(CMQty) 
		 ELSE CASE WHEN MAX(MaxQty) >= 1 AND SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / ISNULL(NULLIF(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)),0), MAX(m.Qty)) > MAX(MaxQty)
				   THEN CAST(CEILING(SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / MAX(MaxQty)) AS numeric(21, 9)) 
				   ELSE CAST(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)) AS numeric(21, 9))
				END 
	END * mp.PriceMC CSumCC
INTO #CProdSums
FROM
(
	SELECT 
		d.PLID, d.ProdID, d.CMPosID, SUM(d.Qty) Qty, 
		MAX(d.MaxQty) MaxQty, IsRelated, t.CMQty
	FROM (SELECT 
			PLID, ProdID, CMPosID, CAST(CEILING(SUM(Qty)/MAX(DetQty)) AS numeric(21,9)) Qty, MAX(MaxQty) MaxQty, IsRelated /*Определяем количество условных едениц максимума по товарам*/
			FROM #SaleTempDC 
			GROUP BY PLID, ProdID, CMPosID, IsRelated, SubProdID
		  ) d
	INNER JOIN (SELECT 
					CMPosID, SUM(Qty) CMQty /*Определяем сумму условных едениц максимума по каждой категории. (Клиенту доступно по одной еденице из каждой категории)*/
				FROM (SELECT 
						CMPosID, CAST(CEILING(SUM(Qty)/MAX(DetQty)) AS numeric(21,9)) Qty /*Определяем количество условных едениц максимума по товарам*/
					  FROM #SaleTempDC 
					  GROUP BY CMPosID, SubProdID
					  ) tt 
				GROUP BY CMPosID
				) t ON t.CMPosID = d.CMPosID 
	GROUP BY
		d.PLID, d.CMPosID, IsRelated, d.ProdID/*, d.SubProdID, d.DetQty*/, t.CMQty
) m 
INNER JOIN r_ProdMP mp WITH (NOLOCK) ON m.ProdID = mp.ProdID AND m.PLID = mp.PLID
GROUP BY
	m.PLID, m.ProdID, mp.PriceMC


UPDATE d 
SET 
	d.PurSumCC_wt =   ROUND(cm.PriceSumCC / CASE WHEN IsRelated = 0 
											   THEN ISNULL(NULLIF(td.PriceSumCC - td.RelatedSum, 0),td.PriceSumCC) 
											   ELSE td.RelatedSum 
										  END  * CASE WHEN IsRelated = 0 
													  THEN cs.CSumCC - td.RelatedSum 
													  ELSE CASE WHEN td.PriceSumCC = td.RelatedSum 
																THEN cs.CSumCC 
																ELSE td.RelatedSum 
														   END 
												 END / d.Qty, 2)  * d.Qty, 
	d.PurPriceCC_wt = ROUND(cm.PriceSumCC / CASE WHEN IsRelated = 0 
											   THEN ISNULL(NULLIF(td.PriceSumCC - td.RelatedSum, 0),td.PriceSumCC) 
											   ELSE td.RelatedSum 
										  END  * CASE WHEN IsRelated = 0 
													  THEN cs.CSumCC - td.RelatedSum 
													  ELSE CASE WHEN td.PriceSumCC = td.RelatedSum 
																THEN cs.CSumCC 
																ELSE td.RelatedSum 
														   END 
												 END / d.Qty, 2) , 
	d.SumCC_wt =	  ROUND(cm.PriceSumCC / CASE WHEN IsRelated = 0 
											   THEN ISNULL(NULLIF(td.PriceSumCC - td.RelatedSum, 0),td.PriceSumCC) 
											   ELSE td.RelatedSum 
										  END  * CASE WHEN IsRelated = 0 
													  THEN cs.CSumCC - td.RelatedSum 
													  ELSE CASE WHEN td.PriceSumCC = td.RelatedSum 
																THEN cs.CSumCC 
																ELSE td.RelatedSum 
														   END 
												 END / d.Qty, 2)  * d.Qty, 
	d.PriceCC_wt =    ROUND(cm.PriceSumCC / CASE WHEN IsRelated = 0 
											   THEN ISNULL(NULLIF(td.PriceSumCC - td.RelatedSum, 0),td.PriceSumCC) 
											   ELSE td.RelatedSum 
										  END  * CASE WHEN IsRelated = 0 
													  THEN cs.CSumCC - td.RelatedSum 
													  ELSE CASE WHEN td.PriceSumCC = td.RelatedSum 
																THEN cs.CSumCC 
																ELSE td.RelatedSum 
														   END 
												 END / d.Qty, 2) 	
FROM t_SaleTempD d WITH (NOLOCK)
INNER JOIN #SaleTempDC cm ON d.SrcPosID = cm.SrcPosID
INNER JOIN #CProdSums cs ON d.PLID = cs.PLID AND cm.ProdID = cs.ProdID
INNER JOIN ( SELECT
				d.PLID, d.ProdID, SUM(d.PriceSumCC) PriceSumCC, SUM(CASE WHEN IsRelated = 1 THEN d.PriceSumCC ELSE 0 END) RelatedSum
			 FROM #SaleTempDC d
			 GROUP BY
				d.PLID, d.ProdID
			) td ON d.PLID = td.PLID AND cm.ProdID = td.ProdID 
WHERE 
	d.ChID = @ChID AND d.Qty <> 0
	
SELECT 
	d.PLID, cm.ProdID, d.ProdID DetProdID, 
	dbo.zf_Round(SUM(d.PriceCC_wt * d.Qty), CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9))) SumCC, 
	SUM(d.Qty) Qty
INTO #SaleTempGP
FROM t_SaleTempD d WITH (NOLOCK)
INNER JOIN #SaleTempDC cm ON d.SrcPosID = cm.SrcPosID
WHERE
	d.ChID = @ChID
GROUP BY 
	cm.ProdID, d.ProdID, d.PLID, d.BarCode, 
	d.TaxID, d.RealQty, d.PriceCC_wt

UPDATE d
SET
	d.PriceCC_wt = (p1.SumCC + c.DSumCC) / p1.Qty, 
	d.PurPriceCC_wt = (p1.SumCC + c.DSumCC) / p1.Qty, 
	d.SumCC_wt = (p1.SumCC + c.DSumCC) / p1.Qty * d.Qty, 
	d.PurSumCC_wt = (p1.SumCC + c.DSumCC) / p1.Qty * d.Qty
FROM
(
	SELECT
		ds.PLID, ds.ProdID,
		cs.CSumCC - SUM(ds.SumCC) DSumCC
	FROM
	#SaleTempGP ds
	INNER JOIN #CProdSums cs ON ds.PLID = cs.PLID AND ds.ProdID = cs.ProdID
	GROUP BY
		ds.PLID, ds.ProdID, cs.CSumCC
	HAVING 
		cs.CSumCC - SUM(ds.SumCC) <> 0
) c
INNER JOIN #SaleTempDC cm ON c.PLID = cm.PLID AND c.ProdID = cm.ProdID
INNER JOIN t_SaleTempD d WITH (NOLOCK) ON d.ChID = @ChID AND cm.SrcPosID = d.SrcPosID 
INNER JOIN 
			(
				SELECT
					TOP 1 PLID, DetProdID, SUM(SumCC) SumCC, SUM(Qty) Qty
				FROM #SaleTempGP
				GROUP BY
					PLID, DetProdID
				HAVING 
					SUM(Qty) <> 0
				ORDER BY
					SIGN(ABS(DetProdID - @ProdID)) DESC, SUM(Qty)
			) p1
ON d.ProdID = p1.DetProdID AND d.PLID = p1.PLID

GO--10
ALTER PROCEDURE [dbo].[t_DiscUpdateBonusPoses](@DocCode int, @ChID int, @DiscCode int)
/* Процедура предоставления бонуса на группу позиций */
AS
BEGIN
  DECLARE @SrcPosID int
  DECLARE @CSrcPosID int
  DECLARE @DCardID varchar(250)
  DECLARE @SumBonus numeric(21, 9)
  DECLARE @GroupSumBonus numeric(21, 9)
  DECLARE @Discount numeric(21, 9)
  DECLARE @DiscSumCC numeric(21, 9)
  DECLARE @DocSumCC numeric(21, 9)
  DECLARE @PosDiscSumCCReal numeric(21, 9)
  DECLARE @DiscSumCCReal numeric(21, 9)
  DECLARE @PriceCC_wt numeric(21, 9)
  DECLARE @SumCC_wt numeric(21, 9)
  DECLARE @PriceCC_wt1 numeric(21, 9)
  DECLARE @SumCC_wt1 numeric(21, 9)
  DECLARE @Qty numeric(21, 9)
  DECLARE @RateMC numeric(21, 9)
  DECLARE @ProdID int
  DECLARE @AllowZeroPrice bit

  IF NOT EXISTS(SELECT TOP 1 1 FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode) RETURN

  SELECT TOP 1 @SumBonus = SUM(ISNULL(GroupSumBonus, 0)), @Discount = MAX(ISNULL(GroupDiscount, 0)) FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode GROUP BY SrcPosID

  SELECT
    @DocSumCC = SUM(SumCC_wt),
    @PosDiscSumCCReal = SUM(PurSumCC_wt - SumCC_wt)
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
  WHERE CSrcPosID IN (SELECT SrcPosID FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)

  SET @DiscSumCC = @DocSumCC - dbo.zf_GetPriceWithDiscountNoRound(@DocSumCC - @SumBonus, @Discount)
  SET @Discount = @DiscSumCC / @DocSumCC * 100

  DECLARE UpdateGroupCursor CURSOR FAST_FORWARD FOR
  SELECT m.SrcPosID, m.CSrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, d.DCardID, d.GroupSumBonus, t.AllowZeroPrice
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m
  JOIN z_LogDiscExp d ON m.SrcPosID = d.SrcPosID
  JOIN t_SaleTempD t ON t.ChID = @ChID AND t.SrcPosID = m.SrcPosID
  WHERE d.DocCode = @DocCode AND d.ChID = @ChID AND d.DiscCode = @DiscCode
  ORDER BY m.SrcPosID, m.CSrcPosID

  OPEN UpdateGroupCursor

  FETCH NEXT FROM UpdateGroupCursor
  INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @PriceCC_wt1 = dbo.zf_GetPriceWithDiscount(@PriceCC_wt, @Discount)
      EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
      SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

      SET @SumCC_wt1 = @SumCC_wt - @SumCC_wt1
      IF @SumBonus <> 0 SET @SumCC_wt1 = dbo.zf_Round(@SumCC_wt1 * @GroupSumBonus / @SumBonus, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

      UPDATE z_LogDiscExp
      SET SumBonus = @SumCC_wt1
      WHERE DCardID = @DCardID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

      SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))
      EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID, @PriceCC_wt1, @SumCC_wt1
      EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosID, @PriceCC_wt1

      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice
    END

  CLOSE UpdateGroupCursor

  SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
  WHERE CSrcPosID IN (SELECT SrcPosID FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)

  /* Если фактически предоставленная сумма скидки не равна расчетной, изменяем цены начиная с первой позиции пока не достигнем необходимой суммы скидки */
  IF @DiscSumCCReal <> @DiscSumCC
    BEGIN
      OPEN UpdateGroupCursor

      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice

      WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal <> @DiscSumCC)
        BEGIN
          /* Если на позицию вообще не предоставилось скидки - не трогаем ее. Так бывает для полностью отмененных позиций */
          IF (SELECT ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0)
               FROM dbo.tf_DiscDoc(1011, @ChID) t
              INNER JOIN z_LogDiscExp e ON t.CSrcPosID = e.SrcPosID
              WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.DiscCode = @DiscCode AND
                     t.CSrcPosID = @CSrcPosID) <> 0
             BEGIN
              SET @SumCC_wt1 = @SumCC_wt + (@DiscSumCCReal - @DiscSumCC)
              IF @SumCC_wt1 < 0 SET @SumCC_wt1 = 0
              SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
              EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
              SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

              UPDATE z_LogDiscExp
              SET SumBonus = SumBonus + @SumCC_wt - @SumCC_wt1
              WHERE DCardID = @DCardID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

              EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

              SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal
              FROM dbo.tf_DiscDoc(@DocCode, @ChID)
              WHERE CSrcPosID IN (SELECT SrcPosID FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)
            END

          FETCH NEXT FROM UpdateGroupCursor
          INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice
        END
      CLOSE UpdateGroupCursor
    END

  /* Если фактически предоставленная сумма скидки оказалась больше расчетной, начинаем ее уменьшать, пока не войдем в пределы бонуса */
  IF @DiscSumCCReal > @DiscSumCC
    BEGIN
      DECLARE @DiscOffset numeric(21, 9)
      SET @DiscOffset = 0

      WHILE (@DiscSumCCReal > @DiscSumCC) AND (@DiscSumCCReal > 0)
        BEGIN
          OPEN UpdateGroupCursor

          FETCH NEXT FROM UpdateGroupCursor
          INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice

          WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal > @DiscSumCC)
            BEGIN
              /* Если на позицию вообще не предоставилось скидки - не трогаем ее. Так бывает для полностью отмененных позиций */
              IF (SELECT ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0)
                   FROM dbo.tf_DiscDoc(1011, @ChID) t
                  INNER JOIN z_LogDiscExp e ON t.CSrcPosID = e.SrcPosID
                  WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.DiscCode = @DiscCode AND
                          t.CSrcPosID = @CSrcPosID) <> 0
                 BEGIN
                  SET @SumCC_wt1 = @SumCC_wt + (@DiscSumCCReal - @DiscSumCC) + @DiscOffset
                  IF @SumCC_wt1 < 0 SET @SumCC_wt1 = 0
                  SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
                  EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
                  SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

                  UPDATE z_LogDiscExp
                  SET SumBonus = SumBonus + @SumCC_wt - @SumCC_wt1
                  WHERE DCardID = @DCardID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

                  EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

                  SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal
                  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
                  WHERE CSrcPosID IN (SELECT SrcPosID FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)
                END
              FETCH NEXT FROM UpdateGroupCursor
              INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice
            END
          CLOSE UpdateGroupCursor
          SET @DiscOffset = @DiscOffset + CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9))
        END
    END

  DEALLOCATE UpdateGroupCursor

  DECLARE UpdateGroupCursor CURSOR FAST_FORWARD FOR
  SELECT m.SrcPosID, m.CSrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, d.DCardID, d.GroupSumBonus
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m, z_LogDiscExp d
  WHERE m.SrcPosID = d.SrcPosID AND d.DocCode = @DocCode AND d.ChID = @ChID AND d.DiscCode = @DiscCode AND m.Qty < 0
  ORDER BY m.SrcPosID, m.CSrcPosID

  OPEN UpdateGroupCursor

  FETCH NEXT FROM UpdateGroupCursor
  INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus

  WHILE @@FETCH_STATUS = 0
    BEGIN
     IF (SELECT ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0)
         FROM dbo.tf_DiscDoc(1011, @ChID) t
         INNER JOIN z_LogDiscExp e ON t.CSrcPosID = e.SrcPosID
         WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.DiscCode = @DiscCode AND
           t.CSrcPosID = @CSrcPosID) <> 0 
    BEGIN    
          SELECT @SumBonus = dbo.zf_Round(e.SumBonus / t.Qty * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))
          FROM z_LogDiscExp e
          INNER JOIN dbo.tf_DiscDoc(1011, @ChID) t ON t.SrcPosID = e.SrcPosID
          WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.DiscCode = @DiscCode AND
          e.SrcPosID = @CSrcPosID

          UPDATE z_LogDiscExp
          SET SumBonus = @SumBonus
          WHERE DCardID = @DCardID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

          EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID
        END
      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus
    END

  CLOSE UpdateGroupCursor

  DEALLOCATE UpdateGroupCursor

END

GO--11
ALTER PROCEDURE [dbo].[t_DiscUpdateGroupPoses](@DocCode int, @ChID int, @DiscCode int)
/* Процедура предоставления скидки на группу позиций */
AS
BEGIN
  DECLARE @SrcPosID int
  DECLARE @CSrcPosID int
  DECLARE @DCardID varchar(250)
  DECLARE @SumBonus numeric(21, 9)
  DECLARE @GroupSumBonus numeric(21, 9)
  DECLARE @Discount numeric(21, 9)
  DECLARE @DiscSumCC numeric(21, 9)
  DECLARE @DocSumCC numeric(21, 9)
  DECLARE @PosDiscSumCCReal numeric(21, 9)
  DECLARE @DiscSumCCReal numeric(21, 9)
  DECLARE @PriceCC_wt numeric(21, 9)
  DECLARE @SumCC_wt numeric(21, 9)
  DECLARE @PriceCC_wt1 numeric(21, 9)
  DECLARE @SumCC_wt1 numeric(21, 9)
  DECLARE @Qty numeric(21, 9)
  DECLARE @RateMC numeric(21, 9)
  DECLARE @ProdID int
  DECLARE @AllowZeroPrice bit

  IF NOT EXISTS(SELECT TOP 1 1 FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode) RETURN

  UPDATE z_LogDiscExp SET SumBonus = 0, Discount = 0 WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode

  DECLARE UpdateGroupCursor CURSOR FAST_FORWARD FOR
  SELECT DISTINCT m.SrcPosID, m.CSrcPosID
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m, z_LogDiscExp d
  WHERE m.SrcPosID = d.SrcPosID AND d.DocCode = @DocCode AND d.ChID = @ChID AND d.DiscCode = @DiscCode
  ORDER BY m.SrcPosID, m.CSrcPosID

  OPEN UpdateGroupCursor

  FETCH NEXT FROM UpdateGroupCursor
  INTO @SrcPosID, @CSrcPosID

  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID
    END

  CLOSE UpdateGroupCursor
  DEALLOCATE UpdateGroupCursor

  SELECT TOP 1 @SumBonus = SUM(ISNULL(GroupSumBonus, 0)), @Discount = MAX(ISNULL(GroupDiscount, 0)) FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode GROUP BY SrcPosID

  SELECT
    @DocSumCC = SUM(SumCC_wt),
    @PosDiscSumCCReal = SUM(PurSumCC_wt - SumCC_wt)
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
  WHERE CSrcPosID IN (SELECT SrcPosID FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)

  SET @DiscSumCC = @DocSumCC - dbo.zf_GetPriceWithDiscountNoRound(@DocSumCC - @SumBonus, @Discount)
  SET @Discount = @DiscSumCC / @DocSumCC * 100

  DECLARE UpdateGroupCursor CURSOR FAST_FORWARD FOR

 SELECT m.SrcPosID, m.CSrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, d.DCardID, d.GroupSumBonus, t.AllowZeroPrice
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m
  JOIN z_LogDiscExp d ON m.SrcPosID = d.SrcPosID
  JOIN t_SaleTempD t ON t.ChID = @ChID AND t.SrcPosID = m.SrcPosID  
  WHERE d.DocCode = @DocCode AND d.ChID = @ChID AND d.DiscCode = @DiscCode
  ORDER BY m.SrcPosID, m.CSrcPosID

  OPEN UpdateGroupCursor

  FETCH NEXT FROM UpdateGroupCursor
  INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @PriceCC_wt1 = dbo.zf_GetPriceWithDiscount(@PriceCC_wt, @Discount)
      EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
      SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

      SET @SumCC_wt1 = @SumCC_wt - @SumCC_wt1
      IF @SumBonus <> 0 SET @SumCC_wt1 = dbo.zf_Round(@SumCC_wt1 * @GroupSumBonus / @SumBonus, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

      UPDATE z_LogDiscExp
      SET SumBonus = @SumCC_wt1
      WHERE DCardID = @DCardID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

      EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice
    END

  CLOSE UpdateGroupCursor

  SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
  WHERE CSrcPosID IN (SELECT SrcPosID FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)

  /* Если фактически предоставленная сумма скидки не равна расчетной, изменяем цены начиная с первой позиции пока не достигнем необходимой суммы скидки */
  IF @DiscSumCCReal <> @DiscSumCC
    BEGIN
      OPEN UpdateGroupCursor

      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice

      WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal <> @DiscSumCC)
        BEGIN
          /* Если на позицию вообще не предоставилось скидки - не трогаем ее. Так бывает для полностью отмененных позиций */
          IF (SELECT ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0)
        FROM dbo.tf_DiscDoc(1011, @ChID) t
              INNER JOIN z_LogDiscExp e ON t.CSrcPosID = e.SrcPosID
              WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.DiscCode = @DiscCode AND
            t.CSrcPosID = @CSrcPosID) <> 0
      BEGIN     
              SET @SumCC_wt1 = @SumCC_wt + (@DiscSumCCReal - @DiscSumCC)
              IF @SumCC_wt1 < 0 SET @SumCC_wt1 = 0
              SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
              EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
              SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

              UPDATE z_LogDiscExp
              SET SumBonus = SumBonus + @SumCC_wt - @SumCC_wt1
              WHERE DCardID = @DCardID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

              EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

              SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal
              FROM dbo.tf_DiscDoc(@DocCode, @ChID)
              WHERE CSrcPosID IN (SELECT SrcPosID FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)
            END

          FETCH NEXT FROM UpdateGroupCursor
          INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice
        END
      CLOSE UpdateGroupCursor
    END

  /* Если фактически предоставленная сумма скидки оказалась больше расчетной, начинаем ее уменьшать, пока не войдем в пределы бонуса */
  IF @DiscSumCCReal > @DiscSumCC
    BEGIN
      DECLARE @DiscOffset numeric(21, 9)
      SET @DiscOffset = 0

      WHILE (@DiscSumCCReal > @DiscSumCC) AND (@DiscSumCCReal > 0)
        BEGIN
          OPEN UpdateGroupCursor

          FETCH NEXT FROM UpdateGroupCursor
          INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice

          WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal > @DiscSumCC)
            BEGIN
              /* Если на позицию вообще не предоставилось скидки - не трогаем ее. Так бывает для полностью отмененных позиций */
              IF (SELECT ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0)
            FROM dbo.tf_DiscDoc(1011, @ChID) t
                  INNER JOIN z_LogDiscExp e ON t.CSrcPosID = e.SrcPosID
                  WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.DiscCode = @DiscCode AND
                t.CSrcPosID = @CSrcPosID) <> 0
          BEGIN             
                  SET @SumCC_wt1 = @SumCC_wt + (@DiscSumCCReal - @DiscSumCC) + @DiscOffset
                  IF @SumCC_wt1 < 0 SET @SumCC_wt1 = 0
                  SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
                  EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
                  SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))

                  UPDATE z_LogDiscExp
                  SET SumBonus = SumBonus + @SumCC_wt - @SumCC_wt1
                  WHERE DCardID = @DCardID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

                  EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

                  SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal
                  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
                  WHERE CSrcPosID IN (SELECT SrcPosID FROM z_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)
                END

              FETCH NEXT FROM UpdateGroupCursor
              INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus, @AllowZeroPrice
            END
          CLOSE UpdateGroupCursor
          SET @DiscOffset = @DiscOffset + CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9))
        END
    END

  DEALLOCATE UpdateGroupCursor

  DECLARE UpdateGroupCursor CURSOR FAST_FORWARD FOR
  SELECT m.SrcPosID, m.CSrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, d.DCardID, d.GroupSumBonus
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m, z_LogDiscExp d
  WHERE m.SrcPosID = d.SrcPosID AND d.DocCode = @DocCode AND d.ChID = @ChID AND d.DiscCode = @DiscCode AND m.Qty < 0
  ORDER BY m.SrcPosID, m.CSrcPosID

  OPEN UpdateGroupCursor

  FETCH NEXT FROM UpdateGroupCursor
  INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus

  WHILE @@FETCH_STATUS = 0
    BEGIN
     IF (SELECT ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0)
         FROM dbo.tf_DiscDoc(1011, @ChID) t
         INNER JOIN z_LogDiscExp e ON t.CSrcPosID = e.SrcPosID
         WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.DiscCode = @DiscCode AND
           t.CSrcPosID = @CSrcPosID) <> 0 
    BEGIN    
          SELECT @SumBonus = dbo.zf_Round(e.SumBonus / t.Qty * @Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))
          FROM z_LogDiscExp e
          INNER JOIN dbo.tf_DiscDoc(1011, @ChID) t ON t.SrcPosID = e.SrcPosID
          WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.DiscCode = @DiscCode AND
          e.SrcPosID = @CSrcPosID

          UPDATE z_LogDiscExp
          SET SumBonus = @SumBonus
          WHERE DCardID = @DCardID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

          EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID
        END
      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardID, @GroupSumBonus
    END

  CLOSE UpdateGroupCursor

  DEALLOCATE UpdateGroupCursor

END

GO--12
ALTER PROCEDURE [dbo].[t_SaleEmptyTempTable](@ATempChID int, @ADocChID int)
/* Производит списание товара и перенос продаж из временной таблицы в документ продажи */
AS
BEGIN
  DECLARE @ASrcPosID int
  DECLARE @AOldSrcPosID int
  DECLARE @ExecResult int
  DECLARE @ProdID int
  DECLARE @BarCode varchar(255)
  DECLARE @AMainUM varchar(40)
  DECLARE @ATaxTypeID int
  DECLARE @APriceCC_wt numeric(21, 13)
  DECLARE @ASumCC_wt numeric(21, 13)
  DECLARE @APurPriceCC_wt numeric(21, 13)
  DECLARE @APurSumCC_wt numeric(21, 13)
  DECLARE @Qty numeric(21, 13)
  DECLARE @APLID int
  DECLARE @IgnDisc int
  DECLARE @TRealQty numeric(21, 13)
  DECLARE @TIntQty numeric(21, 13)
  DECLARE @RealADiscount numeric(21, 13)
  DECLARE @appOurID int
  DECLARE @appStockID int
  DECLARE @appSecID int
  DECLARE @appCRID int
  DECLARE @EmpID int
  DECLARE @LogID int
  DECLARE @LogIDInt int
  DECLARE @SrcPosID int
  DECLARE @DiscCode int
  DECLARE @BonusType int
  DECLARE @SumBonus numeric(21, 9)
  DECLARE @DBiID int
  DECLARE @CreateTime datetime
  DECLARE @ModifyTime datetime

  DECLARE @GroupProds bit
  DECLARE @SrcPosID_Table table(SrcPosID int NOT NULL, GroupField int NOT NULL, IsBonus bit NOT NULL)

  DECLARE @BookingChID int
  DECLARE @UseBooking BIT

  SELECT @BookingChID = ChID FROM t_Booking WITH (NOLOCK) WHERE DocCode = 1011 AND DocChID = @ATempChID
  IF @BookingChID IS NULL
	SELECT @UseBooking = 0
  ELSE
	SELECT @UseBooking = 1

  /* Табличная переменная для обеспечения уникальности LogID. Учитывая BETWEEN при разбивке одной позиции на разные партии,
     через подзапрос COUNT(1) реализовать не получается, поскольку для подзапроса в таком случае не существует уникального ключа. см код */
  DECLARE @identity_table table
    (
     LogID int IDENTITY NOT NULL,
     DBiID int,
     DCardID varchar(250),
     TempBonus bit,
     DocCode int,
     ChID int,
     SrcPosID int,
     DiscCode int,
     SumBonus numeric(21, 9),
     Discount numeric(21, 9),
     LogDate smalldatetime,
     BonusType int,
     GroupSumBonus numeric(21, 9),
     GroupDiscount numeric(21, 9),
     SaleSrcPosID int
    )

  SET NOCOUNT ON
  SET XACT_ABORT ON

  BEGIN TRAN

  SELECT @ASrcPosID = ISNULL(MAX(SrcPosID) + 1, 1) FROM t_SaleD WHERE ChID = @ADocChID
  SELECT @DBiID = CAST(ISNULL(dbo.zf_Var('OT_DBiID'), 0) AS INT)

  /* Установка эксклюзивных блокировок на таблицы */
  SELECT TOP 1 1 FROM z_LogDiscRec a WITH (XLOCK, HOLDLOCK)
  INNER JOIN z_LogDiscExp b WITH (XLOCK, HOLDLOCK) ON 1=1
  WHERE a.DBiID = @DBiID AND b.DBiID = @DBiID

  SELECT @GroupProds = GroupProds
  FROM t_SaleTemp m WITH(NOLOCK), r_CRs c WITH(NOLOCK)
  WHERE c.CRID = m.CRID AND m.ChID = @ATempChID

  SELECT
    @appOurID = OurID,
    @appStockID = StockID,
    @appSecID = SecID,
    @appCRID = CRID
  FROM dbo.tf_SaleGetChequeParams(@ATempChID)
  IF @@ERROR <> 0 GOTO Error

  IF @UseBooking = 1
    UPDATE t_Booking SET DocCode = 11035, DocChID = @ADocChID WHERE ChID = @BookingChID 

  /* Перенос временных начислений */
  DECLARE appBonusCursor CURSOR FAST_FORWARD FOR
  SELECT DISTINCT m.LogID, m.SrcPosID, m.DiscCode, m.BonusType, m.SumBonus
  FROM z_LogDiscRec m, z_LogDiscRecTemp d
  WHERE m.DocCode = d.DocCode AND m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID AND
    m.DiscCode = d.DiscCode AND m.BonusType = d.BonusType AND m.DocCode = 1011 AND m.ChID = @ATempChID
  ORDER BY m.LogID

  OPEN appBonusCursor
  IF @@ERROR <> 0 GOTO Error

  FETCH NEXT FROM appBonusCursor
  INTO @LogID, @SrcPosID, @DiscCode, @BonusType, @SumBonus
  WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT @LogIDInt = ISNULL(MAX(LogID), 0) + 1 FROM z_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID
      INSERT INTO z_LogDiscRec(DBiID, DocCode, ChID, LogID, LogDate, DCardID, TempBonus, SrcPosID, DiscCode, SumBonus, BonusType, SaleSrcPosID)
      SELECT
        m.DBiID, m.DocCode, m.ChID,
        @LogIDInt + (
          SELECT COUNT(1)
          FROM z_LogDiscRecTemp d1
          WHERE d.DocCode = d1.DocCode AND d.ChID = d1.ChID AND d.SrcPosID = d1.SrcPosID AND d.DiscCode = d1.DiscCode AND d.BonusType = d1.BonusType AND d1.LogID < d.LogID AND DBiID = @DBiID),
        GETDATE(), m.DCardID, m.TempBonus, m.SrcPosID, m.DiscCode, d.SumBonus, m.BonusType, d.SaleSrcPosID
      FROM z_LogDiscRec m, z_LogDiscRecTemp d
      WHERE m.DocCode = d.DocCode AND m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID AND
        m.DiscCode = d.DiscCode AND m.BonusType = d.BonusType AND m.DocCode = 1011 AND m.ChID = @ATempChID AND m.LogID = @LogID
      IF @@ERROR <> 0 GOTO Error

      SELECT @LogIDInt = ISNULL(MAX(LogID), 0) + 1 FROM z_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID
      INSERT INTO z_LogDiscRec(DBiID, DocCode, ChID, LogID, LogDate, DCardID, TempBonus, SrcPosID, DiscCode, SumBonus, BonusType)
      SELECT m.DBiID, m.DocCode, m.ChID,
        @LogIDInt + (
          SELECT COUNT(1)
          FROM z_LogDiscRec
          WHERE DocCode = 1011 AND ChID = @ATempChID AND LogID < MAX(m.LogID) AND DBiID = @DBiID),
        GETDATE(), m.DCardID, m.TempBonus, m.SrcPosID, m.DiscCode, @SumBonus - SUM(m.SumBonus), m.BonusType
      FROM z_LogDiscRec m
      WHERE m.DocCode = 1011 AND m.ChID = @ATempChID AND m.LogID <> @LogID AND m.SrcPosID = @SrcPosID AND m.DiscCode = @DiscCode AND m.BonusType = @BonusType
      GROUP BY m.DBiID, m.DocCode, m.ChID, m.DCardID, m.TempBonus, m.SrcPosID, m.DiscCode, m.BonusType
      HAVING @SumBonus - SUM(m.SumBonus) <> 0
      IF @@ERROR <> 0 GOTO Error

      DELETE FROM z_LogDiscRec WHERE DocCode = 1011 AND ChID = @ATempChID AND LogID = @LogID
      IF @@ERROR <> 0 GOTO Error

      FETCH NEXT FROM appBonusCursor
      INTO @LogID, @SrcPosID, @DiscCode, @BonusType, @SumBonus
    END

  CLOSE appBonusCursor
  DEALLOCATE appBonusCursor

  DELETE FROM z_LogDiscRecTemp WHERE DocCode = 1011 AND ChID = @ATempChID
  IF @@ERROR <> 0 GOTO Error

  INSERT INTO @SrcPosID_Table(SrcPosID, GroupField, IsBonus)
  SELECT DISTINCT m.SrcPosID, m.SrcPosID, 1
  FROM t_SaleTempD m
  WHERE m.ChID = @ATempChID AND (
    EXISTS(SELECT TOP 1 1 FROM z_LogDiscRec WHERE DocCode = 1011 AND ChID = @ATempChID AND SrcPosID = m.CSrcPosID) OR
    EXISTS(SELECT TOP 1 1 FROM z_LogDiscExp WHERE DocCode = 1011 AND ChID = @ATempChID AND SrcPosID = m.CSrcPosID))

  /* Перенос позиций чека, на которые предоставлена скидка */
  DECLARE appClientT CURSOR LOCAL FAST_FORWARD FOR
  SELECT m.CSrcPosID, m.ProdID, m.RealBarCode, m.TaxTypeID, m.RealQty, SUM(ROUND(m.Qty * m.RealQty, 4)) Qty,
    SUM(m.SumCC_wt) SumCC_wt, SUM(m.PurSumCC_wt) PurSumCC_wt, SUM(m.Qty) AS TIntQty,
    m.PriceCC_wt / m.RealQty, m.PurPriceCC_wt / m.RealQty, m.PLID,
    p.UM, m.EmpID, MIN(m.CreateTime), MAX(m.ModifyTime)
  FROM t_SaleTempD m WITH(NOLOCK), r_Prods p WITH(NOLOCK)
  WHERE m.ProdID = p.ProdID AND m.ChID = @ATempChID AND m.SrcPosID IN (SELECT SrcPosID FROM @SrcPosID_Table)
  GROUP BY m.CSrcPosID, m.ProdID, m.RealBarCode, m.TaxTypeID, m.RealQty, m.PriceCC_wt, m.PurPriceCC_wt, m.PLID, p.UM, m.EmpID
  ORDER BY MIN(m.SrcPosID)

  OPEN appClientT
  IF @@ERROR <> 0 GOTO Error

  FETCH NEXT FROM appClientT
  INTO @SrcPosID, @ProdID, @BarCode, @ATaxTypeID, @TRealQty, @Qty, @ASumCC_wt, @APurSumCC_wt,
    @TIntQty, @APriceCC_wt, @APurPriceCC_wt, @APLID, @AMainUM, @EmpID, @CreateTime, @ModifyTime

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @AOldSrcPosID = @ASrcPosID
      EXECUTE @ExecResult = t_SaleInsertProd @ASrcPosID OUTPUT, @ProdID, @ATaxTypeID, @Qty,
              @APriceCC_wt, @ASumCC_wt, @APurPriceCC_wt, @APurSumCC_wt, @BarCode, @AMainUM,
              @ADocChID, @appOurID, @appStockID, @appSecID, @appCRID, 0, @APLID, @TRealQty, @TIntQty, @EmpID, @CreateTime, @ModifyTime
      IF (@@ERROR <> 0) OR (@ExecResult <> 1) GOTO Error

      /* Обновление номера позиции в таблице заказов */     
      IF @UseBooking = 1 AND @Qty > 0
        UPDATE t_BookingD SET DetSrcPosID = @ASrcPosID - 1 WHERE ChID = @BookingChID AND DetSrcPosID = @SrcPosID 

      /* Начисления */
      DELETE FROM @identity_table
      INSERT INTO @identity_table(DBiID, DocCode, ChID, DCardID, TempBonus, SrcPosID, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID)
      SELECT
        d.DBiID, 11035, @ADocChID, d.DCardID, dbo.tf_DiscTempAfterClose(d.DiscCode),
        md.SrcPosID, d.DiscCode, dbo.zf_Round(          (
             SELECT SUM(SumBonus) 
             FROM dbo.z_LogDiscRec e 
             INNER JOIN t_SaleTempD t ON e.SrcPosID = t.SrcPosID AND t.ChID = e.ChID
             WHERE t.ChID = m.ChID AND t.CSrcPosID = m.SrcPosID And e.DocCode = 1011 AND e.DiscCode = d.DiscCode AND e.BonusType = d.BonusType
          ) * md.Qty / @Qty, 0.00001), d.LogDate, d.BonusType, d.SaleSrcPosID
      FROM t_SaleTempD m WITH(NOLOCK), z_LogDiscRec d WITH(NOLOCK), t_SaleD md WITH(NOLOCK)
      WHERE m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID AND d.DocCode = 1011 AND
            m.ChID = @ATempChID AND m.SrcPosID = @SrcPosID AND md.ChID = @ADocChID AND md.SrcPosID BETWEEN @AOldSrcPosID AND @ASrcPosID
      IF @@ERROR <> 0 GOTO Error

      SELECT @LogIDInt = ISNULL(MAX(LogID), 0) + 1 FROM z_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID
      SELECT @LogIDInt = @LogIDInt - ISNULL(MIN(LogID), 0) FROM @identity_table /* identity постоянно растет, учитываем смещение */

      INSERT INTO z_LogDiscRec(DBiID, DocCode, ChID, LogID, DCardID, TempBonus, SrcPosID, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID)
      SELECT DBiID, DocCode, ChID, @LogIDInt + LogID, DCardID, TempBonus, SrcPosID, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID
      FROM @identity_table
      IF @@ERROR <> 0 GOTO Error

      /* Списания */
      DELETE FROM @identity_table
      INSERT INTO @identity_table(DBiID, DocCode, ChID, DCardID, TempBonus, SrcPosID, DiscCode, SumBonus, Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount)
      SELECT
        d.DBiID, 11035, @ADocChID, d.DCardID, d.TempBonus,
        md.SrcPosID, d.DiscCode, dbo.zf_Round(
          (
            SELECT SUM(SumBonus) 
            FROM z_LogDiscExp e 
            INNER JOIN t_SaleTempD t ON e.SrcPosID = t.SrcPosID AND t.ChID = e.ChID
            WHERE t.ChID = m.ChID AND t.CSrcPosID = m.SrcPosID And e.DocCode = 1011 AND e.DiscCode = d.DiscCode AND e.BonusType = d.BonusType
          ) * md.Qty / @Qty, 0.00001), d.Discount, d.LogDate, d.BonusType, d.GroupSumBonus, d.GroupDiscount
      FROM t_SaleTempD m WITH(NOLOCK), z_LogDiscExp d WITH(NOLOCK), t_SaleD md WITH(NOLOCK)
      WHERE m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID AND d.DocCode = 1011 AND
            m.ChID = @ATempChID AND m.SrcPosID = @SrcPosID AND md.ChID = @ADocChID AND md.SrcPosID BETWEEN @AOldSrcPosID AND @ASrcPosID
      IF @@ERROR <> 0 GOTO Error

      SELECT @LogIDInt = ISNULL(MAX(LogID), 0) + 1 FROM z_LogDiscExp WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID
      SELECT @LogIDInt = @LogIDInt - ISNULL(MIN(LogID), 0) FROM @identity_table /* identity постоянно растет, учитываем смещение */

      INSERT INTO z_LogDiscExp(DBiID, DocCode, ChID, LogID, DCardID, TempBonus, SrcPosID, DiscCode, SumBonus, Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount)
      SELECT DBiID, DocCode, ChID, @LogIDInt + LogID, DCardID, TempBonus, SrcPosID, DiscCode, SumBonus, Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount
      FROM @identity_table
      IF @@ERROR <> 0 GOTO Error

      FETCH NEXT FROM appClientT
      INTO @SrcPosID, @ProdID, @BarCode, @ATaxTypeID, @TRealQty, @Qty, @ASumCC_wt, @APurSumCC_wt,
        @TIntQty, @APriceCC_wt, @APurPriceCC_wt, @APLID, @AMainUM, @EmpID, @CreateTime, @ModifyTime
      IF @@ERROR <> 0 GOTO Error
    END

  CLOSE appClientT
  DEALLOCATE appClientT

  /* Перенос остальных позиций чека */
  IF (@GroupProds = 1) AND (@UseBooking = 0)
    INSERT INTO @SrcPosID_Table(SrcPosID, GroupField, IsBonus)
    SELECT DISTINCT m.SrcPosID, CASE WHEN d.Sum1 = d.Sum2 THEN 0 ELSE m.CSrcPosID END, 0
    FROM t_SaleTempD m WITH(NOLOCK) INNER JOIN (
      SELECT ChID, ProdID, PLID, TaxTypeID, RealQty, PriceCC_wt, RealBarCode, EmpID,
        dbo.zf_Round(SUM(PriceCC_wt * Qty), CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9))) Sum1, SUM(dbo.zf_Round(PriceCC_wt * Qty, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)))) Sum2
      FROM t_SaleTempD WITH(NOLOCK)
      WHERE ChID = @ATempChID
      GROUP BY ChID, ProdID, PLID, TaxTypeID, RealQty, PriceCC_wt, RealBarCode, EmpID) d ON
        m.ChID = d.ChID AND m.ProdID = d.ProdID AND m.PLID = d.PLID AND m.TaxTypeID = d.TaxTypeID AND
        m.RealQty = d.RealQty AND m.PriceCC_wt = d.PriceCC_wt AND m.RealBarCode = d.RealBarCode AND m.EmpID = d.EmpID
    WHERE m.ChID = @ATempChID AND m.SrcPosID NOT IN (SELECT SrcPosID FROM @SrcPosID_Table)
  ELSE
    INSERT INTO @SrcPosID_Table(SrcPosID, GroupField, IsBonus)
    SELECT DISTINCT m.SrcPosID, m.CSrcPosID, 0
    FROM t_SaleTempD m WITH(NOLOCK)
    WHERE m.ChID = @ATempChID AND m.SrcPosID NOT IN (SELECT SrcPosID FROM @SrcPosID_Table)

  DECLARE appClientT CURSOR LOCAL FAST_FORWARD FOR
  SELECT MIN(m.SrcPosID), m.ProdID, m.RealBarCode, m.TaxTypeID, m.RealQty, SUM(ROUND(m.Qty * m.RealQty, 4)) Qty,
    SUM(m.SumCC_wt) SumCC_wt, SUM(m.PurSumCC_wt) PurSumCC_wt, SUM(m.Qty) AS TIntQty,
    m.PriceCC_wt / m.RealQty, m.PurPriceCC_wt / m.RealQty, m.PLID,
    p.UM, m.EmpID, MIN(m.CreateTime), MAX(m.ModifyTime)
  FROM t_SaleTempD m WITH(NOLOCK), r_Prods p WITH(NOLOCK), @SrcPosID_Table g
  WHERE m.ProdID = p.ProdID AND g.SrcPosID = m.SrcPosID AND m.ChID = @ATempChID AND m.SrcPosID NOT IN (SELECT SrcPosID FROM @SrcPosID_Table WHERE IsBonus = 1)
  GROUP BY m.ProdID, m.RealBarCode, m.TaxTypeID, m.RealQty, m.PriceCC_wt, m.PurPriceCC_wt, m.PLID, p.UM, m.EmpID, g.GroupField
  ORDER BY MIN(m.SrcPosID)

  OPEN appClientT
  IF @@ERROR <> 0 GOTO Error

  FETCH NEXT FROM appClientT
  INTO @SrcPosID, @ProdID, @BarCode, @ATaxTypeID, @TRealQty, @Qty, @ASumCC_wt, @APurSumCC_wt, @TIntQty, @APriceCC_wt, @APurPriceCC_wt, @APLID, @AMainUM, @EmpID, @CreateTime, @ModifyTime

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @AOldSrcPosID = @ASrcPosID
      EXECUTE @ExecResult = t_SaleInsertProd @ASrcPosID OUTPUT, @ProdID, @ATaxTypeID, @Qty,
        @APriceCC_wt, @ASumCC_wt, @APurPriceCC_wt, @APurSumCC_wt, @BarCode, @AMainUM,
        @ADocChID, @appOurID, @appStockID, @appSecID, @appCRID, 0, @APLID, @TRealQty, @TIntQty, @EmpID, @CreateTime, @ModifyTime
      IF (@@ERROR <> 0) OR (@ExecResult <> 1) GOTO Error
      IF @UseBooking = 1 AND @Qty > 0
        UPDATE t_BookingD SET DetSrcPosID = @ASrcPosID - 1 WHERE ChID = @BookingChID AND DetSrcPosID = @SrcPosID 

      FETCH NEXT FROM appClientT
      INTO @SrcPosID, @ProdID, @BarCode, @ATaxTypeID, @TRealQty, @Qty, @ASumCC_wt, @APurSumCC_wt, @TIntQty, @APriceCC_wt, @APurPriceCC_wt, @APLID, @AMainUM, @EmpID, @CreateTime, @ModifyTime
      IF @@ERROR <> 0 GOTO Error
    END

  CLOSE appClientT
  DEALLOCATE appClientT

  /* Перенос отмен */
  INSERT INTO t_SaleC(SrcPosID, ChID, ProdID, BarCode, UM, Qty,
    PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, CReasonID, EmpID, CreateTime, ModifyTime)
  SELECT
    d.SrcPosID, @ADocChID, d.ProdID, d.RealBarCode, p.UM, d.Qty * d.RealQty Qty,
    dbo.zf_GetPrice_nt(d.PriceCC_wt / d.RealQty, dbo.zf_GetProdTaxPercent(p.ProdID, dbo.zf_GetDate(GetDate()))) PriceCC_nt,
    dbo.zf_GetPrice_nt(d.SumCC_wt, dbo.zf_GetProdTaxPercent(p.ProdID, dbo.zf_GetDate(GetDate()))) SumCC_nt,
    dbo.zf_GetIncludedTax(d.PriceCC_wt / d.RealQty, dbo.zf_GetProdTaxPercent(p.ProdID, dbo.zf_GetDate(GetDate()))) Tax,
    dbo.zf_GetIncludedTax(d.SumCC_wt, dbo.zf_GetProdTaxPercent(p.ProdID, dbo.zf_GetDate(GetDate()))) TaxSum,
    d.PriceCC_wt / d.RealQty,
    d.SumCC_wt, d.CReasonID, d.EmpID, d.CreateTime, d.ModifyTime
  FROM t_SaleTempD d WITH(NOLOCK), r_Prods p WITH(NOLOCK)
  WHERE p.ProdID = d.ProdID AND d.ChID = @ATempChID AND d.Qty <= 0
  IF @@ERROR <> 0 GOTO Error

  DELETE FROM t_SaleTempD WHERE ChID = @ATempChID
  IF @@ERROR <> 0 GOTO Error

  /* Применение оплат к дисконтным картам (подарочные сертификаты) */
  DECLARE appPaysCursor CURSOR LOCAL FAST_FORWARD FOR
  SELECT SrcPosID FROM t_SaleTempPays WHERE ChID = @ATempChID ORDER BY SrcPosID

  OPEN appPaysCursor
  FETCH NEXT FROM appPaysCursor INTO @ASrcPosID

  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC t_SaleSaveDCardPay 1011, @ATempChID, @ASrcPosID
      IF @@ERROR <> 0 GOTO Error
      FETCH NEXT FROM appPaysCursor INTO @ASrcPosID
    END
  CLOSE appPaysCursor
  DEALLOCATE appPaysCursor

  /* Перенос чековых начислений и списаний */
  /* Начисления */
  SELECT @LogIDInt = ISNULL(MAX(LogID), 0) + 1 FROM z_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID
  INSERT INTO z_LogDiscRec(DBiID, DocCode, ChID, LogID, DCardID, TempBonus, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID)
  SELECT m.DBiID, 11035, @ADocChID,
         @LogIDInt + (SELECT COUNT(1)
                     FROM z_LogDiscRec d1 WITH(NOLOCK)
                     WHERE m.ChID = d1.ChID AND SrcPosID IS NULL AND d1.DocCode = 1011 AND d1.logid < m.logid AND DBiID = @DBiID),
         DCardID, dbo.tf_DiscTempAfterClose(DiscCode), DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID
  FROM z_LogDiscRec m WITH(NOLOCK)
  WHERE DocCode = 1011 AND ChID = @ATempChID AND SrcPosID IS NULL
  IF @@ERROR <> 0 GOTO Error

  DELETE FROM z_LogDiscRec WHERE DocCode = 1011 AND ChID = @ATempChID
  IF @@ERROR <> 0 GOTO Error

  /* Списания */
  SELECT @LogIDInt = ISNULL(MAX(LogID), 0) + 1 FROM z_LogDiscExp WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID
  INSERT INTO z_LogDiscExp(m.DBiID, DocCode, ChID, LogID, DCardID, TempBonus, DiscCode, SumBonus, Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount)
  SELECT m.DBiID, 11035, @ADocChID,
         @LogIDInt + (SELECT COUNT(1)
                     FROM z_LogDiscExp d1 WITH(NOLOCK)
                     WHERE m.ChID = d1.ChID AND SrcPosID IS NULL AND d1.DocCode = 1011 AND d1.logid < m.logid AND DBiID = @DBiID),
         DCardID, TempBonus, DiscCode, SumBonus, Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount
  FROM z_LogDiscExp m WITH(NOLOCK)
  WHERE DocCode = 1011 AND ChID = @ATempChID AND SrcPosID IS NULL
  IF @@ERROR <> 0 GOTO Error

  DELETE FROM z_LogDiscExp WHERE DocCode = 1011 AND ChID = @ATempChID
  IF @@ERROR <> 0 GOTO Error

  DELETE FROM z_DocDC WHERE DocCode = 1011 AND ChID = @ATempChID
  IF @@ERROR <> 0 GOTO Error

  /* Перенос оплат */
  INSERT INTO t_SalePays(ChID, SrcPosID, PayFormCode, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes)
  SELECT @ADocChID, SrcPosID, PayFormCode, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes
  FROM t_SaleTempPays
  WHERE ChID = @ATempChID
  IF @@ERROR <> 0 GOTO Error

  /* Перенос данных по процессингу */
  INSERT INTO z_LogProcessings(DocCode, ChID, CardInfo, RRN, Status, Msg)
  SELECT 11035, @ADocChID, CardInfo, RRN, Status, Msg
  FROM z_LogProcessings
  WHERE DocCode = 1011 AND ChID = @ATempChID
  IF @@ERROR <> 0 GOTO Error

  DELETE FROM t_SaleTemp WHERE ChID = @ATempChID
  IF @@ERROR <> 0 GOTO Error

  /* Пересчет SrcPosID в t_BookingD */
  IF @UseBooking = 1
    BEGIN
      SET @ASrcPosID = 0
      UPDATE t_BookingD
        SET @ASrcPosID = SrcPosID = @ASrcPosID + 1
      FROM
        t_BookingD WHERE ChID = @BookingChID
    END
  COMMIT TRAN
  RETURN 1

Error:
  ROLLBACK TRAN
  CLOSE appBonusCursor
  DEALLOCATE appBonusCursor
  CLOSE appClientT
  DEALLOCATE appClientT
  CLOSE appPaysCursor
  DEALLOCATE appPaysCursor
  RETURN 2
END

GO
--##############################################################################
--13 для округления весового товара @SumCC_wt/@PriceCC_wt /*@Qty*/
ALTER PROCEDURE [dbo].[t_SaveChequePos](
  @SrcPosID int,
  @ChID int,
  @ProdID int,
  @TaxTypeID tinyint,
  @UM varchar(50),
  @Qty numeric(21,9),
  @RealQty numeric (21,9),
  @PriceCC_wt numeric(21,9),
  @PurPriceCC_wt numeric(21,9),
  @BarCode varchar(42),
  @RealBarCode varchar(42),
  @PLID tinyint,
  @UseToBarQty int,
  @CSrcPosID int,
  @PosStatus tinyint,
  @ServingTime smalldatetime,
  @ServingID int,
  @CReasonID int,
  @CanEditQty bit,
  @AllowQtyReduction bit,
  @EmpID int,
  @EmpName varchar(200),
  @Msg varchar(2000) OUTPUT,
  @Continue bit OUTPUT)
/* Сохраняет позицию чека во временную таблицу */
AS
BEGIN
  DECLARE @SumCC_wt numeric(21,9), @PurSumCC_wt numeric(21,9)
  DECLARE @OldQty numeric(21,9)
  SET @Msg = ''
  SET @Continue = 1

  /* Контроль отрицательных остатков */
  IF EXISTS(SELECT TOP 1 1 FROM sysobjects WHERE name = 'CK_t_Rem_AllowNegative')
    BEGIN
      DECLARE @OurID int
      DECLARE @StockID int
      DECLARE @SecID int

      SELECT @OurID = OurID, @StockID = StockID, @SecID = SecID FROM dbo.tf_SaleGetChequeParams(@ChID)

      IF dbo.tf_GetRem(@OurID, @StockID, @SecID, @ProdID, NULL) -
        ISNULL((
          SELECT SUM(Qty * RealQty)
          FROM t_SaleTemp m, t_SaleTempD d
          WHERE m.ChID = d.ChID AND d.ProdID = @ProdID AND m.OurID = @OurID AND
            m.StockID = @StockID AND NOT (m.ChID = @ChID AND d.SrcPosID = @SrcPosID)), 0) - @Qty * @RealQty < 0
        BEGIN
          SET @Msg = 'Недостаточно остатка товара для продажи'
          SET @Continue = 0
          RETURN
        END
    END

  EXEC t_DiscBeforeSavePos 1011, @ChID, @SrcPosID, @CSrcPosID, @ProdID, @BarCode, @Qty, @Msg OUTPUT, @Continue OUTPUT
  IF @Continue = 0 RETURN

  SET @SumCC_wt = dbo.zf_RoundPriceSale(@PriceCC_wt * @Qty)
  SET @PurSumCC_wt = dbo.zf_RoundPriceSale(@PurPriceCC_wt * @Qty)
  
  --Если количество дробное (остаток от деления на 1 <> 0) и округление в базе больше 0.01 то пересчитывать количество товара для округления
  IF (@Qty % 1 <> 0 ) AND (CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)) > 0.01)
  BEGIN
	--коррекция цены для округления
	SET @PriceCC_wt = @SumCC_wt / @Qty
    SET @PurSumCC_wt = @PurPriceCC_wt * @Qty  -- убрать округление
	SET @PurPriceCC_wt = @PurSumCC_wt / @Qty  
  END
  	
  IF @SrcPosID = -1
    BEGIN
      SELECT @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SaleTempD WHERE ChID = @ChID
      INSERT INTO t_SaleTempD (ChID, SrcPosID, ProdID, TaxTypeID, UM, Qty, RealQty, PriceCC_wt, SumCC_wt, PurPriceCC_wt, PurSumCC_wt,
        BarCode, RealBarCode, PLID, UseToBarQty, CSrcPosID, PosStatus, ServingTime, ServingID, CReasonID, CanEditQty, EmpID, EmpName)
      VALUES (@ChID, @SrcPosID, @ProdID, @TaxTypeID, @UM, @Qty, @RealQty, @PriceCC_wt, @SumCC_wt, @PurPriceCC_wt, @PurSumCC_wt,
        @BarCode, @RealBarCode, @PLID, @UseToBarQty, ISNULL(@CSrcPosID, @SrcPosID), @PosStatus, @ServingTime, @ServingID, @CReasonID, @CanEditQty, @EmpID, @EmpName)
    END
  ELSE
    BEGIN
      IF @SrcPosID IS NULL
        BEGIN
          RAISERROR('Позиция в базе данных отсутствует.', 16, 1)
          RETURN
        END

      IF @AllowQtyReduction <> 1
      BEGIN
        SELECT @OldQty = ISNULL(Qty, @Qty) FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID = @SrcPosID
        IF (@OldQty > @Qty)
          BEGIN
            IF @OldQty > 0
              SET @Msg = 'Запрещено уменьшение количества товара. Воспользуйтесь функцией отмены товара.'
            ELSE
              SET @Msg = 'Запрещено увеличение количества возвращаемого товара. Воспользуйтесь функцией отмены товара.'
            SET @Continue = 0
            RETURN
          END
      END

      UPDATE t_SaleTempD
      SET
        ProdID = @ProdID,
        TaxTypeID = @TaxTypeID,
        UM = @UM,
        Qty = @Qty,
        RealQty = @RealQty,
        PriceCC_wt = @PriceCC_wt,
        SumCC_wt = @SumCC_wt,
        PurPriceCC_wt = @PurPriceCC_wt,
        PurSumCC_wt = @PurSumCC_wt,
        BarCode = @BarCode,
        RealBarCode = @RealBarCode,
        PosStatus = @PosStatus,
        PLID = @PLID,
        UseToBarQty = @UseToBarQty,
        EmpID = @EmpID,
        EmpName = @EmpName,
        ModifyTime = GETDATE()
      WHERE ChID = @ChID AND SrcPosID = @SrcPosID
    END

  EXEC t_DiscAfterSavePos 1011, @ChID, @SrcPosID, @Msg OUTPUT, @Continue OUTPUT
         EXECUTE ip_ChequePosComplexMenu
         @ChID = @ChID, @ProdID = @ProdID, @PLID = @PLID

END

GO

--14 для округления весового товара при добавлении в чек
ALTER PROCEDURE [dbo].[t_DiscUpdateDocPosInt](@DocCode int, @ChID int, @SrcPosID int, @PriceCC_wt numeric(21, 9), @SumCC_wt numeric(21, 9))
/* Изменения цен и сумм в указанном документе */
AS 
  IF @DocCode = 1011 /* Служебные данные: Бизнес */
    --Если количество дробное (остаток от деления на 1 <> 0) и округление в базе больше 0.01 то пересчитывать количество товара для округления
    IF ((SELECT top 1 Qty FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID = @SrcPosID) % 1 <> 0 ) AND (CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9)) > 0.01)
    BEGIN
        UPDATE t_SaleTempD
        SET
		PriceCC_wt = @SumCC_wt / Qty,--пересчитывать цену по количеству товара для округления суммы
		SumCC_wt = @SumCC_wt
		WHERE ChID = @ChID AND SrcPosID = @SrcPosID  
    END
	ELSE
	BEGIN
		UPDATE t_SaleTempD
        SET
		PriceCC_wt = @PriceCC_wt,
		SumCC_wt = @SumCC_wt
		WHERE ChID = @ChID AND SrcPosID = @SrcPosID  
    END