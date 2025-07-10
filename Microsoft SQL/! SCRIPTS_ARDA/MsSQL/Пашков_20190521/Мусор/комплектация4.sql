	--EXECUTE ip_SRecASpecCalc
		--@OurID = 12, @StockID = 1202, @SubStockID = 1207, 
		--@DocDate = '2016-12-09', @KursMC = 27, @AChID = 100336667, 
		--@ProdID = 607152, @PPID = 16, @Qty = 3
		
		
		
--EXECUTE ip_SRecDSpecCalc
--	@OurID = 12, @StockID = 1202, @SubStockID = 1207, 
--	@DocDate = '2016-12-09', @AChID = 100336667, @ProdID = 607152, 
--	@Qty = 3

DECLARE
	@OurID int, @StockID int, @SubStockID int, 
	@DocDate smalldatetime, @AChID int, @ProdID int, 
	@Qty numeric(21,9), @UseSubItems bit = 1,

	@SubSrcPosID int, @SubPPID int, 
	@SubPPQty numeric(21,9), @SubBarCode varchar(42), 
	@SubUM varchar(10), @SubPriceCC numeric(21,9), 
	@SubSecID int, @SpecChID int, @AProdID int,
  @KursMC numeric(21,9)

SELECT 
	@SubUM = UM
FROM r_Prods WITH (NOLOCK)
WHERE
	ProdID = 607152
--SELECT 	 UM FROM r_Prods WITH (NOLOCK)WHERE	ProdID = 607152
UM
@SubUM = 'кг'

	
SELECT 
	@SubBarCode = BarCode
FROM r_ProdMQ WITH (NOLOCK)
WHERE 
	ProdID = @ProdID AND UM = @SubUM

--SELECT 	 BarCode FROM r_ProdMQ WITH (NOLOCK) WHERE  	ProdID = 607152 AND UM = 'кг'
BarCode
@SubBarCode = 607152
	
SELECT
	@AProdID = ProdID
FROM t_SRecA WITH (NOLOCK)
WHERE 
	AChID = @AChID AND ProdID = @ProdID
	AND @StockID = @SubStockID
	
SELECT	ProdID FROM t_SRecA WITH (NOLOCK) WHERE 	AChID = 100336667 AND ProdID = 607152 	AND 1202 = 1207
@AProdID = null	
	
SELECT
  @KursMC = KursMC  
FROM t_SRec WITH(NOLOCK)
WHERE EXISTS(SELECT * FROM t_SRecA WHERE t_SRecA.ChID = t_SRec.ChID AND t_SRecA.AChID = @AChID)

SELECT   KursMC  FROM t_SRec WITH(NOLOCK) WHERE EXISTS(SELECT * FROM t_SRecA WHERE t_SRecA.ChID = t_SRec.ChID AND t_SRecA.AChID = 100336667)
@KursMC =27

IF @UseSubItems = 1
	SELECT TOP 1
		 ChID
	FROM it_Spec WITH (NOLOCK)
	WHERE 
		OurID = 12 and
		StockID = 1202 --Калькуляционна карта отвязана от Фирмы
		AND DocDate <= '2016-12-09' 
		AND ProdID = 607152
	ORDER BY 
		DocDate DESC, DocID DESC
@SpecChID =	12376	
		
IF @SpecChID IS NULL
	SELECT 
		@UseSubItems = 0

/* Списание товара по FIFO и последней партии прихода */
WHILE @Qty > 0 
BEGIN 
	SELECT 
		@SubPPQty = NULL 
	SELECT TOP 1 
		@SubPPID = r.PPID, 
		@SubPPQty = (r.Qty - r.AccQty) - ISNULL(sra.Qty,0) , 
		@SubSecID = r.SecID
	FROM t_Rem r WITH (NOLOCK)
	JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = r.ProdID AND tp.PPID = r.PPID
	LEFT JOIN t_SRecA sra WITH(NOLOCK) ON sra.ProdID = r.ProdID /*Отнимается остаток, сформированый этим же документом*/
										  AND sra.PPID = r.PPID 
										  AND sra.ChID = (SELECT ChID FROM t_SRecA WHERE AChID = @AChID)
	WHERE 
		r.OurID = @OurID AND r.StockID = @SubStockID 
		AND r.ProdID = @ProdID
		AND (r.Qty - r.AccQty) - ISNULL(sra.Qty,0) > 0
		AND (r.ProdID <> @AProdID OR @AProdID IS NULL)
		AND tp.ProdDate <= @DocDate
	ORDER BY 
		tp.Priority, r.SecID 

	IF @SubPPQty > @Qty
	SELECT 
		@SubPPQty = @Qty 
	SELECT 
		@Qty = @Qty - ISNULL(@SubPPQty, 0) 
		
	IF @SubPPQty IS NULL
	BEGIN
		IF @UseSubItems = 0
		SELECT 
			@SubPPID = dbo.if_GetSPPID(@OurID, @SubStockID, @DocDate, @ProdID), 
			@SubSecID = 1, 
			@SubPPQty = @Qty, @Qty = 0 
		ELSE
		BEGIN
			/* Раскрутка на составляющие по Калькуляционной карте */
			DECLARE SRecD CURSOR LOCAL FAST_FORWARD
			FOR 
			SELECT
				ProdID, @Qty * SUM(Qty) Qty, UseSubItems
			FROM it_SpecD d WITH (NOLOCK)
			WHERE 
				ChID = @SpecChID
			GROUP BY 
				ProdID, UseSubItems 
			
			OPEN SRecD
				FETCH NEXT FROM SRecD 
				INTO @ProdID, @Qty, @UseSubItems
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXECUTE ip_SRecDSpecCalc
					@OurID = @OurID, @StockID = @SubStockID, @SubStockID = @SubStockID, 
					@DocDate = @DocDate, @AChID = @AChID, @ProdID = @ProdID, 
					@Qty = @Qty, @UseSubItems = @UseSubItems

				FETCH NEXT FROM SRecD 
				INTO @ProdID, @Qty, @UseSubItems
			END
			CLOSE SRecD
			DEALLOCATE SRecD

			SELECT @Qty = 0
		END
	END
	IF @SubPPQty IS NOT NULL
	BEGIN
		SELECT 
			@SubPriceCC = @KursMC * CostMC 
		FROM t_PInP WITH (NOLOCK)
		WHERE 
			ProdID = @ProdID AND PPID = @SubPPID 

		SELECT 
			@SubSrcPosID = ISNULL(MAX(SubSrcPosID), 0) + 1 
		FROM t_SRecD WITH (NOLOCK) WHERE AChID = @AChID 

		INSERT INTO t_SRecD
		(
			AChID, SubSrcPosID, SubProdID, 
			SubPPID, SubUM, SubQty, 
			SubPriceCC_nt, SubSumCC_nt, 
			SubTax, SubTaxSum, 
			SubPriceCC_wt, SubSumCC_wt, 
			SubNewPriceCC_nt, SubNewSumCC_nt, 
			SubNewTax, SubNewTaxSum, 
			SubNewPriceCC_wt, SubNewSumCC_wt, 
			SubSecID, SubBarCode
		)
		SELECT
			@AChID, @SubSrcPosID, @ProdID, 
			@SubPPID, @SubUM, @SubPPQty, 
			@SubPriceCC, @SubPriceCC * @SubPPQty, 
			0, 0, 
			@SubPriceCC, @SubPriceCC * @SubPPQty, 
			@SubPriceCC, @SubPriceCC * @SubPPQty, 
			0, 0, 
			@SubPriceCC, @SubPriceCC * @SubPPQty, 
			@SubSecID, @SubBarCode
	END
END