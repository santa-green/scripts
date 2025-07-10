--ALTER FUNCTION [dbo].[af_GetSpecSubs]

--select * from dbo.af_GetSpecSubs(12, 1202, 1312, '2017-06-12' , 605403, 1)

--оригинал

DECLARE 
	@OurID INT =12, 
	@StockID INT =1202,
    @SubStockID INT =1312, 
	@DocDate SMALLDATETIME = '2017-06-12', 
	@ProdID INT = 605403, 
	@Qty NUMERIC(21,9) = 1,
	
	@LayQty NUMERIC(21,9) 
	
	DECLARE @SpecOut TABLE (ProdID INT, Qty NUMERIC(21,9))
	DECLARE @Spec TABLE (ProdID INT, Qty NUMERIC(21,9))
	DECLARE @SpecChID INT, @RemQty NUMERIC(21,9), @UseSubItems BIT

--определяем последнюю рабочую калькуляционную карту
	SELECT TOP 1 @SpecChID = ChID
	FROM it_Spec WITH(NOLOCK)
	WHERE StockID = @StockID AND DocDate <= @DocDate AND ProdID = @ProdID
AND OurID = @OurID --pvm0 17-07-2017 добавил условие выбора по фирме
	ORDER BY DocDate DESC, DocID DESC
	
SELECT *
FROM it_Spec WITH(NOLOCK)
WHERE StockID = @StockID AND DocDate <= @DocDate AND ProdID = @ProdID
AND OurID = @OurID --pvm0 17-07-2017 добавил условие выбора по фирме
ORDER BY DocDate DESC, DocID DESC
		
SELECT  @SpecChID SpecChID 

	IF @SpecChID IS NULL 
      INSERT @Spec (ProdID, Qty)
	  VALUES (@ProdID, @Qty)
	ELSE
	/* Вычисление остатка товара-параметра */
	BEGIN 
      SET @RemQty = ISNULL((SELECT SUM(Qty - AccQty)
                            FROM dbo.af_CalcRemD_F(@DocDate,@OurID,@SubStockID,1,@ProdID) /*dbo.zf_t_CalcRemByDateDate(NULL, @DocDate)*/
                            /*WHERE OurID = @OurID AND StockID = @SubStockID AND ProdID = @ProdID*/
                            /*HAVING ISNULL(SUM(Qty - AccQty),0) > 0*/),0)
select @RemQty

      IF @RemQty > @Qty
	    SELECT @RemQty = @Qty 
		
	  SELECT @Qty = @Qty - @RemQty 

select @Qty
			
	  IF @RemQty > 0
	    INSERT @Spec (ProdID, Qty)
	    VALUES (@ProdID, @RemQty)
	    
SELECT * FROM @Spec
		
	  IF @Qty > 0
	  BEGIN
	  

	  SELECT top 1 @LayQty = LayQty FROM it_SpecParams d WITH(NOLOCK) WHERE ChID = @SpecChID
	  
	  SELECT @LayQty = 1  --ISNULL(@LayQty,1)

SELECT @LayQty LayQty 	  	  
		
	  /* Раскрутка на составляющие по Калькуляционной карте */
	 	DECLARE SRecD CURSOR LOCAL FAST_FORWARD FOR 
	 	SELECT ProdID, @Qty * SUM(Qty) / @LayQty Qty, UseSubItems
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

