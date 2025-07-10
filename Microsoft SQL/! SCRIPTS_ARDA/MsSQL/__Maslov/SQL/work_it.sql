/*

SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[t_VenExcessPPID](@DocCode int, @ChID bigint, @OurID int, @DocID bigint, @StockID int, @CompID int, @DocDate smalldatetime, @RateMC numeric(21, 9), @CurrID int, @ProdID int, @PPID int OUTPUT)
AS
/* Возвращает партию приходования излишка */
BEGIN

SELECT * FROM t_pinp WHERE PPDesc = 'Инвентаризация'
*/
BEGIN TRAN;

DECLARE @DocCode int = 11022,
        @ChID bigint = 3989, @OurID int = 6, @DocID bigint = 600002241,
		@StockID int = 1257, @CompID int = 108, @DocDate smalldatetime = '2019-05-31 00:00:00',
		@RateMC numeric(21, 9) = 1, @CurrID int = 980, @ProdID int = 801500, @PPID INT
  
  DECLARE @VenExcessPP int, @VenExcessPPCost int
  DECLARE @LastPPID int
  SELECT @VenExcessPP = dbo.zf_Var('t_VenExcessPP')
  SELECT @VenExcessPPCost = dbo.zf_Var('t_VenExcessPPCost')

  SELECT @VenExcessPP
  SELECT @VenExcessPPCost

  --SELECT * FROM dbo.z_Vars WHERE VarName = 't_VenExcessPP'

  IF @VenExcessPP > 2
    BEGIN
      RAISERROR ('Некорректный метод приходования излишков инвентаризации', 18, 1)
	  GOTO the_end
      --RETURN
    END

  IF @VenExcessPP = 1 OR @VenExcessPP = 2 AND @VenExcessPPCost = 1
    SELECT TOP 1 @LastPPID = PPID FROM dbo.tf_ProdRecs(@OurID, @StockID, @ProdID)

  /* Максимальная партия с остатком */
  IF @VenExcessPP = 0
    BEGIN
      SELECT @PPID = MAX(PPID) FROM t_Rem WHERE OurID = @OurID AND StockID = @StockID AND ProdID = @ProdID AND Qty - AccQty > 0
      IF @PPID IS NULL OR @PPID = 0
        BEGIN
          SELECT @PPID = dbo.tf_NewPPID(@ProdID)
		  SELECT @PPID, 44
          IF @PPID IS NULL GOTO Error
        END
	  GOTO the_end
      --RETURN
    END

  /* Партия последнего прихода */
  IF @VenExcessPP = 1
    BEGIN
      SELECT @PPID = ISNULL(MAX(PPID), 0) FROM dbo.tf_ProdRecs(@OurID, @StockID, @ProdID)
      WHERE DocDate <= @DocDate
	  GOTO the_end
      --RETURN
    END

  /* Новая партия */
  DECLARE @CostCC numeric(21, 9), @CostAC numeric(21, 9)

  /* Нулевая себестоимость */
  IF @VenExcessPPCost = 0
    BEGIN
      SELECT
        @CostCC = 0,
        @CostAC = 0
    END
  /* Себестоимость последнего прихода */
  ELSE IF @VenExcessPPCost = 1
    BEGIN
      SELECT
        @CostAC = CostAC,
        @CostCC = CostCC,
        @CurrID = CurrID
      FROM
        t_pInP WITH(NOLOCK)
      WHERE
        ProdID = @ProdID AND PPID = @LastPPID
    END
  /* Средневзвешенная себестоимость */
  ELSE IF @VenExcessPPCost = 2
    BEGIN
      DECLARE @SumQty numeric(21, 9)
      SELECT
        @CostAC = SUM(CostAC * Qty),
        @CostCC = SUM(CostCC * Qty),
        @SumQty = SUM(Qty)
      FROM
        t_Rem r WITH(NOLOCK), t_pInP p WITH(NOLOCK)
      WHERE
        r.OurID = @OurID AND
        r.StockID = @StockID AND
        r.ProdID = @ProdID AND
        r.ProdID = p.ProdID AND
        r.PPID = p.PPID

      SELECT @SumQty = ISNULL(@SumQty, 0)
      IF @SumQty = 0
        SELECT @CostAC = 0, @CostCC = 0
      ELSE
        SELECT @CostAC = dbo.zf_RoundPriceRec(@CostAC / @SumQty), @CostCC = dbo.zf_RoundPriceRec(@CostCC / @SumQty)
    END

  SELECT @CostCC = ISNULL(@CostCC, 0), @CostAC = ISNULL(@CostAC, 0)

  SELECT @PPID = dbo.tf_NewPPID(@ProdID)
  IF @PPID IS NULL GOTO Error
  INSERT INTO t_PInP (ProdID, PPID, PPDesc, PriceMC_In, PriceMC, Priority, ProdDate, CurrID, CompID, Article, CostAC, PPWeight, PriceCC_In, CostCC, PPDelay, IsCommission)
  VALUES (@ProdID, @PPID, 'Излишек инвентаризации', @CostAC, 0, 0, @DocDate, @CurrID, @CompID, '', @CostAC, 0, @CostCC, @CostCC, 0, 0)
  SELECT @ProdID, @PPID, 'Излишек инвентаризации', @CostAC, 0, 0, @DocDate, @CurrID, @CompID, '', @CostAC, 0, @CostCC, @CostCC, 0, 0
  GOTO the_end
  --RETURN

  

GOTO the_end

Error:
  SET @PPID = 0
  RAISERROR('Новый номер партии для таблицы t_pInP находится вне допустимого диапазона', 18, 1)

the_end:
SELECT * FROM t_PInP WHERE ProdID = @ProdID

ROLLBACK TRAN;
/*
END
GO
*/
























/*


/*

USE [ElitR]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[t_VenCalculate] 
(
    @ChID BIGINT,
    @SrcPosID INT 
)
AS
BEGIN
setuser 'taa12'
SELECT * FROM t_pinp
SELECT suser_name()
SELECT * FROM t_Ven WHERE ChID = 3989
SELECT * FROM t_VenA WHERE ChID = 3989
*/
BEGIN TRAN;

  DECLARE 
    @OurID int, @StockID int, @DocDate smalldatetime, 
    @ProdID int, @TQty decimal(21,9), @KursMC decimal(21,9),  
    @TNewQty decimal(21,9), @PPID int, @CurrID int, 
    @UM varchar(10), @Qty decimal(21,9), @TZQty decimal(21,9),
    @DSrcPosID INT, @DSum decimal(21,9), @PPQty decimal(21,9), 
    @TSumCC decimal(21,9), @TSumMC decimal(21,9), 
    @CostCC decimal(21,9), @CostMC decimal(21,9), 
    @KursCC decimal(21,9), @TPQty decimal(21,9), 
    @TPSumCC decimal(21,9), @TPSumMC decimal(21,9), 
    @NewQty decimal(21,9), @TaxPercent NUMERIC(21,9),
    @DocID BIGINT, @CompID INT,
	@ChID BIGINT = 3989,
    @SrcPosID INT = 27 

  SELECT 
      @OurID = OurID, @StockID = StockID, 
      @DocDate = DocDate, @KursMC = KursMC,
      @DocID = DocID, @CompID = CompID
  FROM t_Ven WHERE ChID = @ChID
  SELECT
      @CurrID = dbo.zf_GetCurrMC()

  SELECT @ProdID = ProdID FROM t_VenA a WHERE a.TSrcPosID = @SrcPosID AND a.ChID = @ChID

  /* Сохранение ранее созданных партий */
  /* Это для того чтобы не плодить партии, если несколько раз запускается перерасчет */
  SELECT 
      pp.ProdID, pp.PPID
  INTO #PrevPPs
  FROM t_VenD d WITH (NOLOCK)
  INNER JOIN t_PInP pp WITH (NOLOCK) ON d.DetProdID = pp.ProdID AND d.PPID = pp.PPID
  WHERE ChID = @ChID AND 
        d.NewQty - d.Qty > 0 AND  
        pp.PPDesc = 'Излишек инвентаризации' AND 
        pp.ProdDate = @DocDate AND
        d.DetProdID = @ProdID

  /* Убираем старый расчет */
  DELETE FROM t_VenD
  WHERE ChID = @ChID AND DetProdID = @ProdID
  SELECT '64', @PPID 
  SELECT a.ProdID, r.PPID, r.Qty
  INTO #RemD
  FROM t_VenA a 
  INNER JOIN dbo.zf_t_CalcRemByDateDate(NULL, @DocDate) r
    ON a.ProdID = r.ProdID AND r.Qty <> 0 AND 
       r.OurID = @OurID AND r.StockID = @StockID
  WHERE a.ChID = @ChID AND a.TSrcPosID = @SrcPosID

  SELECT @TNewQty = TNewQty, @UM = UM
  FROM t_VenA WHERE ChID = @ChID AND TSrcPosID = @SrcPosID

  SELECT 
      @TQty = ISNULL(SUM(r.Qty), 0), 
      @TSumMC = ISNULL(SUM(r.Qty * pp.CostAC), 0), 
      @TSumCC = ISNULL(SUM(r.Qty * pp.CostCC), 0)
  FROM #RemD r 
  INNER JOIN t_PInP pp ON r.ProdID = pp.ProdID AND r.PPID = pp.PPID 
  WHERE r.ProdID = @ProdID

  SELECT 
      @TPQty = ISNULL(SUM(r.Qty), 0), 
      @TPSumMC = ISNULL(SUM(r.Qty * pp.CostAC), 0), 
      @TPSumCC = ISNULL(SUM(r.Qty * pp.CostCC), 0)
  FROM #RemD r 
  INNER JOIN t_PInP pp ON r.ProdID = pp.ProdID AND r.PPID = pp.PPID 
  WHERE r.ProdID = @ProdID AND r.Qty > 0    
  SELECT '91', @PPID
  SELECT 
      @TZQty = /*ISNULL(SUM( - r.Qty), 0) 
  FROM #RemD r 
  WHERE r.ProdID = @ProdID AND r.Qty < 0
  AND r.PPID =*/ 0    

  SELECT  @Qty = @TPQty - @TNewQty
  IF @Qty < 0
    SELECT @Qty = 0

  SELECT @TaxPercent = dbo.zf_GetProdExpTax(@ProdID, @OurID, @DocDate)

  DECLARE VenDCursor CURSOR FAST_FORWARD 
  FOR 
  SELECT 
      r.PPID, r.Qty, pp.CostCC
  FROM #RemD r 
  INNER JOIN t_PInP pp  ON r.ProdID = pp.ProdID AND r.PPID = pp.PPID 
  WHERE r.ProdID = @ProdID AND 
        (r.Qty > 0 OR (r.Qty < 0 /*AND r.PPID <> 0*/))
  ORDER BY SIGN(r.Qty), pp.ProdDate, pp.PPID

  OPEN VenDCursor
  FETCH NEXT FROM VenDCursor
  INTO @PPID, @PPQty, @CostCC
  WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT
        @NewQty = CASE 
                    WHEN @Qty < @PPQty 
                    THEN @PPQty - @Qty
                    ELSE 0
                  END  
      SELECT 
          @DSrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 
      FROM t_VenD 
      WHERE ChID = @ChID AND DetProdID = @ProdID 
	  
      INSERT INTO t_VenD
        (
          ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, 
          PriceCC_nt, PriceCC_wt, Tax, TaxSum, 
          SumCC_nt, SumCC_wt, NewQty, 
          NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID 
        )
      SELECT 
          @ChID, @ProdID, @DSrcPosID, @PPID, @UM, @PPQty, 
          dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @CostCC, dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), @PPQty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
          @PPQty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @PPQty * @CostCC, @NewQty, 
          @NewQty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @NewQty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
          @NewQty * @CostCC, 1

      SELECT 
          @ChID, @ProdID, @DSrcPosID, @PPID, @UM, @PPQty, 
          dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @CostCC, dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), @PPQty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
          @PPQty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @PPQty * @CostCC, @NewQty, 
          @NewQty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @NewQty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
          @NewQty * @CostCC, 1 
SELECT '150', @PPID
      IF @PPQty > 0
      SELECT 
          @Qty = @Qty + @NewQty - @PPQty

      FETCH NEXT FROM VenDCursor
      INTO @PPID, @PPQty, @CostCC        
    END
  CLOSE VenDCursor
  DEALLOCATE VenDCursor

    IF @TNewQty > @TPQty OR @TZQty > 0
      BEGIN
        SELECT 
            @CostCC = 0, 
            @CostMC = 0

        IF @TQty > 0
        SELECT 
            @CostMC = @TPSumMC / @TPQty, 
            @CostCC = @TPSumCC / @TPQty
        ELSE 
        SELECT TOP 1 
            @CostMC = CostAC, 
            @CostCC = CostCC
        FROM t_PInP 
        WHERE ProdID = @ProdID AND PPID = dbo.zf_GetSPPID(@OurID, @StockID, @DocDate, @ProdID)

        IF @CostCC = 0
        SELECT
            @CostCC = RecStdPriceCC, 
            @CostMC = RecStdPriceCC / @KursMC
        FROM r_Prods
        WHERE ProdID = @ProdID
		SELECT '184', @PPID
        SELECT
            @PPID = NULL

        SELECT 
            @PPID = PPID
        FROM #PrevPPs
        WHERE ProdID = @ProdID

        IF @PPID IS NULL
          BEGIN
		      SELECT 11022, @ChID, @OurID, @DocID, @StockID, @CompID, @DocDate, 1, 980, @ProdID         
              EXEC t_VenExcessPPID 11022, @ChID, @OurID, @DocID, @StockID, @CompID, @DocDate, 1, 980, @ProdID, @PPID OUTPUT
              SELECT @CostCC = CostCC FROM t_PInP WITH(NOLOCK) WHERE ProdID = @ProdID AND PPID = @PPID 
			   SELECT * FROM t_PInP WITH(NOLOCK) WHERE ProdID = @ProdID AND PPID = @PPID 
          END
        ELSE
          BEGIN
            UPDATE t_PInP
            SET
                PriceMC = @CostMC, 
                CostAC = @CostMC, 
                PriceCC_In = @CostCC, 
                CostCC = @CostCC            
            WHERE ProdID = @ProdID AND PPID = @PPID
          END

        SELECT 
            @Qty = 
            CASE WHEN @TNewQty > @TPQty
                THEN @TNewQty - @TPQty 
                ELSE 0
            END

        SELECT 
            @DSrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 
        FROM t_VenD 
        WHERE ChID = @ChID AND DetProdID = @ProdID 
 SELECT '220', @PPID    
 SELECT @CostCC, @TaxPercent, @TZQty, @Qty, @PPID, @ProdID
 SELECT * FROM t_PInP WITH(NOLOCK)
WHERE ProdID = 801500
        INSERT INTO t_VenD
        (
            ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, 
            PriceCC_nt, PriceCC_wt, Tax, TaxSum, 
            SumCC_nt, SumCC_wt, NewQty, 
            NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID 
        )
        SELECT 
            @ChID, @ProdID, @DSrcPosID, @PPID, @UM, - @TZQty, 
            dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @CostCC, dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), - @TZQty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
            - @TZQty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), - @TZQty * @CostCC, @Qty, 
            @Qty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @Qty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
            @Qty * @CostCC, 1
SELECT '235'


		SELECT 
            @ChID, @ProdID, @DSrcPosID, @PPID, @UM, - @TZQty, 
            dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @CostCC, dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), - @TZQty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
            - @TZQty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), - @TZQty * @CostCC, @Qty, 
            @Qty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @Qty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
            @Qty * @CostCC, 1 
      END

      SELECT 
          @DSum = ISNULL(SUM(NewSumCC_wt - SumCC_wt), 0) 
      FROM t_VenD
      WHERE ChID = @ChID AND DetProdID = @ProdID

 SELECT '251'     
      
	  SELECT @TQty, 
          dbo.zf_GetPrice_nt(@TSumCC, @TaxPercent), 
          dbo.zf_GetIncludedTax(@TSumCC, @TaxPercent), 
          @TSumCC, 
          dbo.zf_GetPrice_nt(@TSumCC + @DSum, @TaxPercent), 
          dbo.zf_GetIncludedTax(@TSumCC + @DSum, @TaxPercent), 
          @TSumCC + @DSum
SELECT '259'	  
	  UPDATE t_VenA
      SET 
          TQty = @TQty, 
          TSumCC_nt = dbo.zf_GetPrice_nt(@TSumCC, @TaxPercent), 
          TTaxSum = dbo.zf_GetIncludedTax(@TSumCC, @TaxPercent), 
          TSumCC_wt = @TSumCC, 
          TNewSumCC_nt = dbo.zf_GetPrice_nt(@TSumCC + @DSum, @TaxPercent), 
          TNewTaxSum = dbo.zf_GetIncludedTax(@TSumCC + @DSum, @TaxPercent), 
          TNewSumCC_wt = @TSumCC + @DSum
      WHERE ChID = @ChID AND ProdID = @ProdID

SELECT '271'
ROLLBACK TRAN;
	 
	 BEGIN TRAN;
	 DECLARE @PPID INT
	 EXEC t_VenExcessPPID 11022,3989,6,600002241,1257,108,'2019-05-31 00:00:00',1,980,801500, @PPID OUTPUT
	 SELECT @PPID
	 SELECT * FROM t_PInP WITH(NOLOCK) WHERE ProdID = 801500 AND PPID = @PPID 
	 ROLLBACK TRAN;
	 /*
END
GO
*/
*/