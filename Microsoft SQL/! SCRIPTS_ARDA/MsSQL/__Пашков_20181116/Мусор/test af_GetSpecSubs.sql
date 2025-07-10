--ALTER FUNCTION [dbo].[af_GetSpecSubs]
--SELECT * FROM t_SRec ORDER BY DocDate desc
--SELECT * FROM t_SRecA where chid= 11466 ORDER BY 1
--SELECT * FROM t_SRecA  ORDER BY 1
--select * from dbo.af_GetSpecSubs(12, 1202, 1312, '2017-06-12' , 605403, 1)
--delete t_SRecA where chid= 1 and SrcPosID=5
--pvm0 23-11-2017 добавил условие выбора по фирме
--pvm0 23-11-2017 добавил условие при котором только положительный остаток учитывается
--OurID	StockID	SubStockID	EDate	ProdID	Qty
--6	1257	1257	2018-01-16 00:00:00	603752	7.000000000
BEGIN TRAN
	INSERT t_SRecA (ChID, SrcPosID, ProdID, PPID, UM, Qty, SetCostCC, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
           Extra, PriceCC, NewPriceCC_nt, NewSumCC_nt, NewTax, NewTaxSum, NewPriceCC_wt, NewSumCC_wt, AChID, BarCode, SecID)             
	SELECT 11464, 8, 603752, 0, 'порц', 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1460571, 26, 1     

--ChID	SrcPosID	ProdID	PPID	UM	Qty	SetCostCC	SetValue1	SetValue2	SetValue3	PriceCC_nt	SumCC_nt	Tax	TaxSum	PriceCC_wt	SumCC_wt	Extra	PriceCC	NewPriceCC_nt	NewSumCC_nt	NewTax	NewTaxSum	NewPriceCC_wt	NewSumCC_wt	AChID	BarCode	SecID
--11467	1	603752	0	порц	7.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	0.000000000	146057	26	1

--2018-01-16 00:00:00	6	1257	1	603752

DECLARE 
	@OurID INT =6, 
	@StockID INT =1257,
    @SubStockID INT =1257, 
	@DocDate SMALLDATETIME = '20180116', 
	@ProdID INT = 603752, 
	@Qty NUMERIC(21,9) = 7,
	
	@LayQty NUMERIC(21,9) 

SELECT (SELECT SUM(Qty - AccQty) FROM dbo.af_CalcRemD_F(@DocDate,@OurID,@SubStockID,1,@ProdID)) af_CalcRemD_F_603752

	
	DECLARE @SpecOut TABLE (ProdID INT, Qty NUMERIC(21,9))
	DECLARE @Spec TABLE (ProdID INT, Qty NUMERIC(21,9))
	DECLARE @SpecChID INT, @RemQty NUMERIC(21,9), @UseSubItems BIT

	SELECT TOP 1 @SpecChID = ChID
	FROM it_Spec WITH(NOLOCK)
	WHERE StockID = @StockID AND DocDate <= @DocDate AND ProdID = @ProdID
	AND OurID = @OurID --pvm0 23-11-2017 добавил условие выбора по фирме
	ORDER BY DocDate DESC, DocID DESC

	--норма закладки
	SELECT top 1 @LayQty = LayQty FROM it_SpecParams d WITH(NOLOCK) WHERE ChID = @SpecChID
	SELECT @LayQty = ISNULL(@LayQty,1)
	--коррекция колицества по норме закладки  
	SELECT @Qty = @Qty * @LayQty
	
SELECT @Qty Qty 
SELECT @LayQty LayQty 
	
SELECT *
FROM it_Spec WITH(NOLOCK)
WHERE StockID = @StockID AND DocDate <= @DocDate AND ProdID = @ProdID
ORDER BY DocDate DESC, DocID DESC
		
SELECT  @SpecChID SpecChID 

	IF @SpecChID IS NULL 
      INSERT @Spec (ProdID, Qty)
	  VALUES (@ProdID, @Qty)
	ELSE
	/* Вычисление остатка товара-параметра */
	BEGIN 
	select @DocDate DocDate,@OurID OurID,@SubStockID SubStockID,1,@ProdID ProdID
      SET @RemQty = ISNULL((SELECT SUM(Qty - AccQty)
                            FROM dbo.af_CalcRemD_F(@DocDate,@OurID,@SubStockID,1,@ProdID) /*dbo.zf_t_CalcRemByDateDate(NULL, @DocDate)*/
                            /*WHERE OurID = @OurID AND StockID = @SubStockID AND ProdID = @ProdID*/
                            /*HAVING ISNULL(SUM(Qty - AccQty),0) > 0*/),0)
select @RemQty RemQty

      IF @RemQty > @Qty
	    SELECT @RemQty = @Qty 
		
	  IF @RemQty > 0 --pvm0 23-11-2017 добавил условие при котором только положительный остаток учитывается
		SELECT @Qty = @Qty - @RemQty 

select @Qty Qty
			
	  IF @RemQty > 0
	    INSERT @Spec (ProdID, Qty)
	    VALUES (@ProdID, @RemQty)
	    
--SELECT * FROM @Spec
		
	  IF @Qty > 0
	  BEGIN
	  /* Раскрутка на составляющие по Калькуляционной карте */
	 	DECLARE SRecD CURSOR LOCAL FAST_FORWARD FOR 
	 	SELECT ProdID, @Qty * SUM(Qty) Qty, UseSubItems
		FROM it_SpecD d WITH(NOLOCK)
		WHERE ChID = @SpecChID
		GROUP BY ProdID, UseSubItems 

select 'DECLARE SRecD CURSOR LOCAL FAST_FORWARD FOR '
SELECT ProdID, @Qty * SUM(Qty) Qty, UseSubItems
FROM it_SpecD d WITH(NOLOCK)
WHERE ChID = @SpecChID
GROUP BY ProdID, UseSubItems 
					
		OPEN SRecD
		FETCH NEXT FROM SRecD INTO @ProdID, @Qty, @UseSubItems
		WHILE @@FETCH_STATUS = 0
		BEGIN
		  IF @UseSubItems = 0
		  BEGIN
		    INSERT @Spec (ProdID, Qty)
			VALUES (@ProdID, @Qty)
			
select 	@ProdID ProdID_0, @Qty Qty_0
		
		  END
		  ELSE
		  BEGIN
			INSERT @Spec (ProdID, Qty)	
			SELECT ProdID, Qty
			FROM af_GetSpecSubs(@OurID, @SubStockID, @SubStockID, @DocDate, @ProdID, @Qty)	
			
SELECT ProdID ProdID_1, Qty Qty_1
FROM af_GetSpecSubs(@OurID, @SubStockID, @SubStockID, @DocDate, @ProdID, @Qty)	
				
		  END
		  
		  FETCH NEXT FROM SRecD INTO @ProdID, @Qty, @UseSubItems
		END
		CLOSE SRecD
		DEALLOCATE SRecD
      END
		
	  INSERT @SpecOut (ProdID, Qty)
	  SELECT ProdID, SUM(Qty)
	  FROM @Spec
	  GROUP BY ProdID
	END
SELECT * FROM @SpecOut

ROLLBACK TRAN