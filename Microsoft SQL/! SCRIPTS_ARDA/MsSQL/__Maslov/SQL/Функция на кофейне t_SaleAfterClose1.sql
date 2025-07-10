USE [FFood601]
GO
/****** Object:  StoredProcedure [dbo].[t_SaleAfterClose]    Script Date: 10/05/2018 15:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[t_SaleAfterClose](
   @ChID bigint,
   @WPID int,                 /* Код рабочего места */
   @PersonID int,             /* Код клиента */
   @Continue bit OUTPUT,      /* Продолжать ли процедуру закрытия чека */
   @Msg varchar(2000) OUTPUT, /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */
   @Result int OUTPUT) /* Result AND (Not Continue) - Считать чек закрытым и не продолжать процедуру закрытия
                          Result AND Continue - Продолжить процедуру закрытия чека */
/* Процедура после закрытия чека */
AS
BEGIN
  DECLARE @DBiID int
  SET NOCOUNT ON
  SET @Msg = ''
  SET @Continue = CAST(1 AS bit)
  SET @Result = 1

  SELECT @DBiID = CAST(ISNULL(dbo.zf_Var('OT_DBiID'), 0) AS INT)
  DECLARE @Qty numeric(21, 13)

  DECLARE @DCardChID bigint
  DECLARE @InitSum numeric(21, 9)
  DECLARE @BonusType int
  DECLARE @DiscCode int

  DECLARE DiscCursor CURSOR FOR
  SELECT c.ChID, t.InitSum, p.Qty, ISNULL(p.BonusType, 0) AS BonusType
  FROM t_SaleD d, r_DCards c, r_DCTypes t 
  LEFT OUTER JOIN r_DCTypeP p ON t.DCTypeCode = p.DCTypeCode /* Для абонементов */
  WHERE d.BarCode = c.DCardID AND c.DCTypeCode = t.DCTypeCode AND d.ProdID = t.ProdID AND d.ChID = @ChID

  OPEN DiscCursor
  FETCH NEXT FROM DiscCursor
  INTO @DCardChID, @InitSum, @Qty, @BonusType

  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF @Qty IS NOT NULL /* Это абонемент. Нужно найти акцию для начисления бонусов */
        BEGIN
          SELECT @DiscCode  = 
            (
              SELECT TOP 1 m.DiscCode 
              FROM r_Discs m
              JOIN r_DiscDC d ON m.DiscCode = d.DiscCode
              WHERE d.DCTypeCode = (SELECT DCTypeCode FROM r_DCards WHERE ChID = @DCardChID)
              ORDER BY Priority  
            )

          IF @DiscCode is NULL
            SELECT @Msg = 'Чек закрыт успешно, однако бонусы для абонемента не были начислены корректно, т.к. не найдена акция дисконтной системы! Обратитесь к администратору.'
         END


      FETCH NEXT FROM DiscCursor
      INTO @DCardChID, @InitSum, @Qty, @BonusType
    END /* WHILE @@FETCH_STATUS = 0 */

  CLOSE DiscCursor
  DEALLOCATE DiscCursor

  if 1=1
  BEGIN
  /*-------------------------------------------------------------------------------------------------------------------------------------------------   */
  /* Установка признаков документа */
  IF (SELECT COUNT(*) 
      FROM t_Sale m WITH(NOLOCK)
      JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID AND m.ChID = @ChID
      WHERE p.Notes NOT LIKE 'Сдача') = 1
        UPDATE m
	    SET m.CodeID1 = 63, 
	        m.CodeID2 = 18, 
	        m.CodeID3 = CASE p.PayFormCode WHEN 1 THEN (CASE WHEN m.StockID IN (1201,1202,1315) THEN 81 
		         									         WHEN m.StockID IN (1257) THEN 73
		         									         WHEN m.StockID IN (1245) THEN 95 --харьков пр.Науки,15
		         									         WHEN m.StockID IN (1221,1222) THEN 82
		         									         WHEN m.StockID IN (1241) THEN 93
		         									         WHEN m.StockID IN (1243) THEN 94 -- киев генерала вататина 2т
		         									         WHEN m.StockID IN (1252) THEN 78
		         									         WHEN m.StockID IN (723) THEN 91
		         									         WHEN m.StockID IN (1001) THEN 75
													         WHEN m.StockID IN (1310,1314) THEN 84 END)    
	    							       WHEN 2 THEN 27 WHEN 5 THEN 70 ELSE 0 END
  	    FROM t_Sale m WITH(NOLOCK)
	    JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID AND p.ChID = @ChID
      ELSE
        UPDATE m
        SET m.CodeID1 = 63, m.CodeID2 = 18, m.CodeID3 = 83
	    FROM t_Sale m WITH(NOLOCK)
	    JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID AND p.ChID = @ChID
	   
	   /*Налоговые округление*/
	   UPDATE t_saled 
	   SET SumCC_nt = ROUND (SumCC_nt,2) , TaxSum= ROUND (SumCC_wt,2)- ROUND (SumCC_nt,2)  , SumCC_wt = ROUND (SumCC_wt,2)
	   FROM t_saled WHERE chid = @ChID
  /*-------------------------------------------------------------------------------------------------------------------------------------------------*/

    /* Создание оплаты */
  EXEC dbo.apt_SaleInsertMonRec @ChID = @ChID  	
  
  END



END


GO
