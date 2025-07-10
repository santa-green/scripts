USE [ElitVintage_TEST]
GO
/****** Object:  UserDefinedFunction [dbo].[tf_GetDCardInfo]    Script Date: 01/30/2013 14:16:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[tf_GetDCardInfo](@DocCode int, @ChID int, @DCardID varchar(250), @DCTypeGCode int)
/* Возвращает информацию по дисконтной карте */
RETURNS varchar(2000) AS
Begin
  DECLARE @s varchar(2000)
  SET @s = ''
  SELECT
    @s =
 --     'Номер бонусной карты: ' +  CONVERT(varchar(20),DCardID,104) + CHAR(10) +  
							
      CASE WHEN ClientName IS NULL THEN '' 
						ELSE  'ФИО клиента: ' + UPPER(RTRIM(ClientName)) + CHAR(10)  END +  
						
      CASE WHEN SumBonus IS NULL THEN '' 
						ELSE 'Покупок на сумму: ' + CONVERT(varchar(20),  CAST(FLOOR(SumBonus) as numeric(21,0)),  104) + ' грн '
						                         + CONVERT(varchar(20),  REVERSE(LEFT(REVERSE(CAST((SumBonus) AS numeric(21,2))),2)),104) + ' коп' + CHAR(10) END +
	  'Действующая скидка: ' + 	CASE WHEN SumBonus <200 THEN CONVERT(varchar(20),CAST(FLOOR(0) AS numeric(21,0)),  104) +' % '+ CHAR(10) 
											ELSE CONVERT(varchar(20),CAST(FLOOR(Discount) AS numeric(21,0)),  104) +' % '+ CHAR(10) 
											END +  
						
						                         
      CASE WHEN Discount =  10 THEN  '' ELSE 'Сумма до'+  
						CASE 
						WHEN SumBonus <  200   THEN  ' 3% '
						WHEN SumBonus <  2000  THEN  ' 5% '
						WHEN SumBonus <  10000 THEN  ' 7% '
						WHEN SumBonus <  20000 THEN  ' 10% '
						 
						END + 
      
						 'скидки: ' + CASE WHEN SumBonus <  200 THEN CONVERT(varchar(20),  CAST(FLOOR(  200-SumBonus) AS numeric(21,0)),  104) + ' грн ' 
																   + CONVERT(varchar(20),  REVERSE(LEFT(REVERSE(CAST((  200-SumBonus) AS numeric(21,2))),2)),104) + ' коп' + CHAR(10)
										  WHEN SumBonus <  2000 THEN CONVERT(varchar(20),  CAST(FLOOR( 2000-SumBonus) AS numeric(21,0)),  104) + ' грн ' 
																   + CONVERT(varchar(20),  REVERSE(LEFT(REVERSE(CAST(( 2000-SumBonus) AS numeric(21,2))),2)),104) + ' коп' + CHAR(10)
										  WHEN SumBonus < 10000 THEN CONVERT(varchar(20),  CAST(FLOOR(10000-SumBonus) AS numeric(21,0)),  104) + ' грн ' 
																   + CONVERT(varchar(20),  REVERSE(LEFT(REVERSE(CAST((10000-SumBonus) AS numeric(21,2))),2)),104) + ' коп' + CHAR(10)
										  WHEN SumBonus < 20000 THEN CONVERT(varchar(20),  CAST(FLOOR(20000-SumBonus) AS numeric(21,0)),  104) + ' грн '
																   + CONVERT(varchar(20),  REVERSE(LEFT(REVERSE(CAST((20000-SumBonus) AS numeric(21,2))),2)),104) + ' коп' + CHAR(10)
										  END
										  END +
	     
	   'Кредитный лимит: ' + CASE WHEN IsCrdCard = 0 THEN  UPPER(RTRIM('не установлен'))+  CHAR(13)
											WHEN IsCrdCard = 1 THEN UPPER(RTRIM('установлен'))+  CHAR(13) 
											END  											            
  FROM r_DCards c, r_DCTypes t
  WHERE c.DCTypeCode = t.DCTypeCode AND c.DCardID = @DCardID      

  /* Доступная сумма для оплаты */
  IF EXISTS(SELECT TOP 1 1 FROM r_PayForms WHERE DCTypeGCode = @DCTypeGCode AND DCTypeGCode <> 0)
    BEGIN
      DECLARE @PayFormCode int
      DECLARE @SumBonus numeric(21, 2)
      SELECT TOP 1 @PayFormCode = PayFormCode FROM r_PayForms WHERE DCTypeGCode = @DCTypeGCode
      SELECT @SumBonus = ROUND(ISNULL(SUM(dbo.tf_GetDCardPaySum(@DocCode, @ChID, d.DCardID, @PayFormCode)), 0), 2) FROM z_DocDC d, r_DCards r WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DocCode = @DocCode AND d.ChID = @ChID AND d.DCardID = r.DCardID AND r.DCTypeCode = t.DCTypeCode AND t.DCTypeGCode = @DCTypeGCode
      SELECT
        @s = @s + CHAR(10) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + CHAR(13) +
        REPLICATE(CHAR(10) + CHAR(13), 5 - (LEN(@s) - LEN(REPLACE(@s, CHAR(10) + CHAR(13), ''))) / 2) +
        '==============================' + CHAR(10) + CHAR(13) +
        'Общая доступная сумма: ' + CAST(@SumBonus AS varchar(50)) + CHAR(10) + CHAR(13) +
        '=============================='
    END
  RETURN @s
End 

