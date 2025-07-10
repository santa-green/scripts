
declare

  @CRID int = 300,
  @SaleSumCash numeric(19, 9)  ,
  @SaleSumCCard numeric(19, 9)  ,
  @SaleSumCredit numeric(19, 9)  ,
  @SaleSumCheque numeric(19, 9)  ,
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

BEGIN


	SELECT 
		@IsFiscal = ISNULL(@IsFiscal, 1)
		

	SELECT
		@IsFiscal = NULLIF(@IsFiscal, 0)
		

  DECLARE @LastZRep smalldatetime, @Time smalldatetime
  SET @Time = '2016-12-02 20:50:36.653'--GetDate()
  SELECT @LastZRep = '2016-12-01 23:00:36.653'--ISNULL((SELECT TOP 1 DocTime FROM t_zRep WHERE CRID = @CRID ORDER BY DocTime DESC), '1900-01-01 00:00:00')

  /* Доработка по Excellio 550 - исключение из проверки баланса - акцизных товаров (пока не доработают протокол) kaa0 20150422 */
  IF EXISTS (SELECT * FROM r_Crs WITH(NOLOCK) WHERE CRID = @CRID AND CashType = 15)
  BEGIN
    SELECT @SaleSumCash = ROUND(ISNULL(Sum(d.RealSum), 0), 2) 
    FROM t_Sale m WITH(NOLOCK)
    JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_SalePays WITH(NOLOCK) WHERE PayFormCode = 1 AND ChID = m.ChID)
	  AND NOT EXISTS (SELECT * FROM t_SaleDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID)

    SELECT @SaleSumCCard = ROUND(ISNULL(Sum(d.RealSum), 0), 2)
    FROM t_Sale m WITH(NOLOCK)
    JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_SalePays WITH(NOLOCK) WHERE PayFormCode = 2 AND ChID = m.ChID)
	  AND NOT EXISTS (SELECT * FROM t_SaleDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID) 

    SELECT @SumRetCash = ROUND(ISNULL(Sum(d.RealSum), 0), 2) 
    FROM t_CRRet m WITH(NOLOCK)
    JOIN t_CRRetD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_CRRetPays WITH(NOLOCK) WHERE PayFormCode = 1 AND ChID = m.ChID)
	  -- pvm0 02-12-2016 закоментил для устранения несовподения балансов 
	  --AND NOT EXISTS (SELECT * FROM t_CRRetDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID)	  	    SELECT @SumRetCCard = ROUND(ISNULL(Sum(d.RealSum), 0), 2)
    FROM t_CRRet m WITH(NOLOCK)
    JOIN t_CRRetD d WITH(NOLOCK) ON d.ChID = m.ChID
    WHERE m.DocTime BETWEEN @LastZRep AND @Time 
      AND m.CRID = @CRID 
	  AND EXISTS (SELECT * FROM t_CRRetPays WITH(NOLOCK) WHERE PayFormCode = 2 AND ChID = m.ChID)
	  -- pvm0 02-12-2016 закоментил для устранения несовподения балансов 
	  --AND NOT EXISTS (SELECT * FROM t_CRRetDLV WITH(NOLOCK) WHERE ChID = d.ChID AND SrcPosID = d.SrcPosID) 
  END
  ELSE
  BEGIN
    SELECT @SaleSumCash = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
    FROM t_Sale m, t_SalePays d 
    WHERE 
	  m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 1
	  AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)
	
    SELECT @SaleSumCCard = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
    FROM t_Sale m, t_SalePays d 
    WHERE 
	  m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 2
	  AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)
  END
	
  SELECT @SaleSumCredit = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_Sale m, t_SalePays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 3
	AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)
	
  SELECT @SaleSumCheque = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_Sale m, t_SalePays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 4
	AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)
	
  SELECT @SaleSumOther = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_Sale m, t_SalePays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode NOT IN (1, 2, 3, 4)
	AND d.IsFiscal = ISNULL(@IsFiscal, d.IsFiscal)
	
  SELECT @SumRetCash = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 1
	
  SELECT @SumRetCCard = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 2
	
  SELECT @SumRetCredit = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 3
	
  SELECT @SumRetCheque = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode = 4
	
  SELECT @SumRetOther = ROUND(ISNULL(Sum(d.SumCC_wt), 0), 2) 
  FROM t_CRRet m, t_CRRetPays d 
  WHERE 
	m.ChID = d.ChID AND m.DocTime BETWEEN @LastZRep AND @Time AND m.CRID = @CRID AND d.PayFormCode NOT IN (1, 2, 3, 4)
	
  SELECT @SaleSumCash = @SaleSumCash - @SumRetCash
  SELECT @SaleSumCCard = @SaleSumCCard - @SumRetCCard
  SELECT @SaleSumCredit = @SaleSumCredit - @SumRetCredit
  SELECT @SaleSumCheque = @SaleSumCheque - @SumRetCheque
  SELECT @SaleSumOther = @SaleSumOther - @SumRetOther
  SELECT @MRec = ISNULL(Sum(SumCC), 0) FROM t_MonIntRec WHERE DocTime BETWEEN @LastZRep AND @Time AND CRID = @CRID  
  SELECT @MExp = ISNULL(Sum(SumCC), 0) FROM t_MonIntExp WHERE DocTime BETWEEN @LastZRep AND @Time AND CRID = @CRID
  SELECT @SumCash = @SaleSumCash + @MRec - @MExp
  
    SELECT    @MRec AS 'Служебные вносы',    @MExp AS 'Служебные выносы',    @SaleSumCash AS 'Выручка (наличные)',    @SaleSumCCard AS 'Выручка (платежные карты)',    @SaleSumCredit AS 'Выручка (кредит)',    @SaleSumCheque AS 'Выручка (чеки)',    @SaleSumOther AS 'Выручка (другое)',    (@SaleSumCCard + @SaleSumCredit + @SaleSumCheque + @SaleSumOther) AS 'Выручка (безналичные оплаты)',    @SumCash AS 'Наличность в кассе'
  
  
END