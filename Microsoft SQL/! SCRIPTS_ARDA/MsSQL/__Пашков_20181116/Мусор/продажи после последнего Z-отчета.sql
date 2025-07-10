SELECT  dbo.tf_LastZRep(220)

SELECT dbo.tf_CRShiftBegin(220)

  DECLARE @LastZRep smalldatetime
  SELECT @LastZRep = dbo.tf_LastZRep(220)  
SELECT * FROM t_Sale WITH(NOLOCK) WHERE CRID = 220 AND DocTime >= @LastZRep ORDER BY DocTime ASC



  --DECLARE @LastZRep smalldatetime  --DECLARE @SaleDocTime smalldatetime  --DECLARE @CRRetDocTime smalldatetime  --SELECT @LastZRep = dbo.tf_LastZRep(@CRID)  --SELECT TOP 1 @SaleDocTime = DocTime FROM t_Sale WITH(NOLOCK) WHERE CRID = @CRID AND DocTime >= @LastZRep ORDER BY DocTime ASC  --SELECT TOP 1 @CRRetDocTime = DocTime FROM t_CRRet WITH(NOLOCK) WHERE CRID = @CRID AND DocTime >= @LastZRep ORDER BY DocTime ASC  --RETURN (CASE WHEN @SaleDocTime <= @CRRetDocTime OR @CRRetDocTime IS NULL THEN @SaleDocTime ELSE @CRRetDocTime END)