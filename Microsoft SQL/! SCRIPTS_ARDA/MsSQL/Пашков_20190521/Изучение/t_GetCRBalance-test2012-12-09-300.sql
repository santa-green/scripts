declare @CRID int = 300,
  @SaleSumCash numeric(19, 9) ,
  @SaleSumCCard numeric(19, 9) ,
  @SaleSumCredit numeric(19, 9) ,
  @SaleSumCheque numeric(19, 9) ,
  @SaleSumOther numeric(19, 9)  ,
  @MRec numeric(19, 9)  ,
  @MExp numeric(19, 9)  ,
  @SumCash numeric(19, 9)  ,
  @SumRetCash numeric(19, 9)  ,
  @SumRetCCard numeric(19, 9)  ,
  @SumRetCredit numeric(19, 9)  ,
  @SumRetCheque numeric(19, 9)  ,
  @SumRetOther numeric(19, 9)  , 
  @IsFiscal bit = 1 /* 1 - только фискальное, 0 - все */

/* Возвращает баланс по кассе */
/* Добавлен параметр IsFiscal (по умолчанию true - для вызова процедуры из ТК в момент сверки )*/



	SELECT 
		@IsFiscal = ISNULL(@IsFiscal, 1)
		

	SELECT
		@IsFiscal = NULLIF(@IsFiscal, 0)
		

  DECLARE @LastZRep smalldatetime, @Time smalldatetime
  SET @Time = GetDate()
  SELECT @LastZRep = ISNULL((SELECT TOP 1 DocTime FROM t_zRep WHERE CRID = @CRID ORDER BY DocTime DESC), '1900-01-01 00:00:00')
  
  /* Доработка по Excellio 550 - исключение из проверки баланса - акцизных товаров (пока не доработают протокол) kaa0 20150422 */
  IF EXISTS (SELECT * FROM r_Crs WITH(NOLOCK) WHERE CRID = @CRID AND CashType = 15)
  BEGIN--CashType = 15
    SELECT @SaleSumCash = ROUND(ISNULL(Sum(d.RealSum), 0), 2) 
    FROM t_Sale m WITH(NOLOCK)
    JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_SalePays WITH(NOLOCK) WHERE PayFormCode = 1 AND ChID = m.ChID)
	  AND NOT EXISTS (SELECT * FROM t_SaleDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID)

print '@SaleSumCash' + str(@SaleSumCash,8,2)

    SELECT @SaleSumCCard = ROUND(ISNULL(Sum(d.RealSum), 0), 2)
    FROM t_Sale m WITH(NOLOCK)
    JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_SalePays WITH(NOLOCK) WHERE PayFormCode = 2 AND ChID = m.ChID)
	  AND NOT EXISTS (SELECT * FROM t_SaleDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID) 

print '@SaleSumCCard' + str(@SaleSumCCard,8,2)
print ' Возврат акцизных товаров попадает в сумму продаж '

    /* Возврат акцизных товаров попадает в сумму продаж */
    SELECT @SaleSumCash += ROUND(ISNULL(Sum(d.RealSum), 0), 2) 
    FROM t_CRRet m WITH(NOLOCK)
    JOIN t_CRRetD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_CRRetPays WITH(NOLOCK) WHERE PayFormCode = 1 AND ChID = m.ChID)
	  AND EXISTS (SELECT * FROM t_CRRetDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID)

print '@SaleSumCash' + str(@SaleSumCash,8,2)
	
    SELECT @SaleSumCCard += ROUND(ISNULL(Sum(d.RealSum), 0), 2)
    FROM t_CRRet m WITH(NOLOCK)
    JOIN t_CRRetD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_CRRetPays WITH(NOLOCK) WHERE PayFormCode = 2 AND ChID = m.ChID)
	  AND EXISTS (SELECT * FROM t_CRRetDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID) 

print '@SaleSumCCard' + str(@SaleSumCCard,8,2)
    
    SELECT @SumRetCash = ROUND(ISNULL(Sum(d.RealSum), 0), 2) 
    FROM t_CRRet m WITH(NOLOCK)
    JOIN t_CRRetD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_CRRetPays WITH(NOLOCK) WHERE PayFormCode = 1 AND ChID = m.ChID)
	  AND NOT EXISTS (SELECT * FROM t_CRRetDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID)

print '@SumRetCash' + str(@SumRetCash,8,2)	
	
    SELECT @SumRetCCard = ROUND(ISNULL(Sum(d.RealSum), 0), 2)
    FROM t_CRRet m WITH(NOLOCK)
    JOIN t_CRRetD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_CRRetPays WITH(NOLOCK) WHERE PayFormCode = 2 AND ChID = m.ChID)
	  AND NOT EXISTS (SELECT * FROM t_CRRetDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID)
	  
print '@SumRetCCard' + str(@SumRetCCard)	
	   
  END--CashType = 15
  ELSE--CashType = 15
  BEGIN--ELSE CashType = 15
  
    SELECT @SaleSumCash = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
    FROM t_Sale m, t_SalePays d 
    WHERE 
	  m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 1
	  AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)
	  
print '@SaleSumCash' + str(@SaleSumCash)
	
    SELECT @SaleSumCCard = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
    FROM t_Sale m, t_SalePays d 
    WHERE 
	  m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 2
	  AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)

print '@SaleSumCCard' + str(@SaleSumCCard)
	  
  END--ELSE CashType = 15
  
print '-------END-------'	

  SELECT @SaleSumCredit = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_Sale m, t_SalePays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 3
	AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)
	
print '@SaleSumCredit' + str(@SaleSumCredit)
	
  SELECT @SaleSumCheque = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_Sale m, t_SalePays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 4
	AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)

print '@SaleSumCheque' + str(@SaleSumCheque)
	
  SELECT @SaleSumOther = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_Sale m, t_SalePays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode NOT IN (1, 2, 3, 4)
	AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)

print '@SaleSumOther' + str(@SaleSumOther)
	
  SELECT @SumRetCash = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 1

print '@SumRetCash' + str(@SumRetCash,8,2)
	
  SELECT @SumRetCCard = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 2

print '@SumRetCCard' + str(@SumRetCCard,8,2)

  SELECT @SumRetCredit = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 3

print '@SumRetCredit' + str(@SumRetCredit)
	
  SELECT @SumRetCheque = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 4

print '@SumRetCheque' + str(@SumRetCheque)
	
  SELECT @SumRetOther = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode NOT IN (1, 2, 3, 4)

print '@@SumRetOther' + str(@SumRetOther)
	
  SELECT @SaleSumCash = @SaleSumCash - @SumRetCash
  SELECT @SaleSumCCard = @SaleSumCCard - @SumRetCCard
  SELECT @SaleSumCredit = @SaleSumCredit - @SumRetCredit
  SELECT @SaleSumCheque = @SaleSumCheque - @SumRetCheque
  SELECT @SaleSumOther = @SaleSumOther - @SumRetOther
  SELECT @MRec = ISNULL(Sum(SumCC), 0) FROM t_MonIntRec WHERE DocTime BETWEEN @LastZRep AND @Time AND CRID = @CRID  
  SELECT @MExp = ISNULL(Sum(SumCC), 0) FROM t_MonIntExp WHERE DocTime BETWEEN @LastZRep AND @Time AND CRID = @CRID
  SELECT @SumCash = @SaleSumCash + @MRec - @MExp

print '---------------------'  
print '@SaleSumCash' + str(@SaleSumCash,8,2)
print '@SaleSumCCard' + str(@SaleSumCCard,8,2)
print '@SaleSumCredit' + str(@SaleSumCredit,8,2) 
print '@SaleSumCheque' + str(@SaleSumCheque,8,2)
print '@SaleSumOther' + str(@SaleSumOther,8,2)
print '@MRec' + str(@MRec,8,2) 
print '@MExp' + str(@MExp,8,2)
print '@SumCash' + str(@SumCash,8,2)

/*09.12.2016 crid 300
@SaleSumCash 1034.03
@SaleSumCCard  177.96
 Возврат акцизных товаров попадает в сумму продаж 
@SaleSumCash 1421.03
@SaleSumCCard  177.96
@SumRetCash    0.00
@SumRetCCard         0
-------END-------
@SaleSumCredit         0
@SaleSumCheque         0
@SaleSumOther         0
@SumRetCash  387.00
@SumRetCCard    0.00
@SumRetCredit         0
@SumRetCheque         0
@@SumRetOther         0
---------------------
@SaleSumCash 1034.03
@SaleSumCCard  177.96
@SaleSumCredit    0.00
@SaleSumCheque    0.00
@SaleSumOther    0.00
@MRec  200.00
@MExp    0.00
@SumCash 1234.03
*/