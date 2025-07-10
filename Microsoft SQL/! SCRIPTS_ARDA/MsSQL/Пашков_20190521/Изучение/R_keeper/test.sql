BEGIN TRAN 



DECLARE 
   @CARDCODE VARCHAR(250), 
   @SaleChID INT, 
   @CHECKNUM INT, 
   @TRealSum NUMERIC(21,9), 
   @DocCreateTime SMALLDATETIME, 
   @LogID INT, 
   @DBiID INT = dbo.zf_Var('OT_DBiID')
   
   
DECLARE CUR_CHECKNUM CURSOR FOR
	SELECT s.ChID, s.DocCreateTime, s.TRealSum, r.CARDCODE, r.CHECKNUM FROM t_sale s
	JOIN t_rkeeper_CHECKNUM_CARDCODE r ON r.CHECKNUM = s.DocID
	WHERE r.IMPORT = 0

OPEN CUR_CHECKNUM
FETCH NEXT FROM CUR_CHECKNUM INTO @SaleChID, @DocCreateTime, @TRealSum, @CARDCODE, @CHECKNUM
WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRAN DCard
	IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 11035 AND ChID = @SaleChID AND DCardID = @CARDCODE)
		INSERT dbo.z_DocDC (DocCode, ChID, DCardID) VALUES (11035, @SaleChID, @CARDCODE) 


--SELECT * FROM dbo.z_DocDC where ChID = @SaleChID and DCardID = @CARDCODE
		                            
	SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscRec WHERE DBiID = @DBiID

	INSERT dbo.z_LogDiscRec
		(LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, logdate ,BonusType, DBiID)
	VALUES 
		(@LogID, @CARDCODE, 0, 11035, @SaleChID, 1, 122,  @TRealSum, @DocCreateTime, 0, @DBiID)
	
	UPDATE t_rkeeper_CHECKNUM_CARDCODE
	SET IMPORT = 1, DateTime = GETDATE()
	WHERE CHECKNUM = @CHECKNUM AND CARDCODE = @CARDCODE 
		
	COMMIT TRAN DCard  

--SELECT * FROM dbo.z_LogDiscRec where LogID = @LogID

	FETCH NEXT FROM CUR_CHECKNUM INTO @SaleChID, @DocCreateTime, @TRealSum, @CARDCODE, @CHECKNUM
END
CLOSE CUR_CHECKNUM
DEALLOCATE CUR_CHECKNUM


SELECT * FROM  dbo.t_rkeeper_CHECKNUM_CARDCODE 
	
SELECT s.ChID, s.DocID,s.DocCreateTime, s.TRealSum, r.CARDCODE, * FROM t_sale s
join t_rkeeper_CHECKNUM_CARDCODE r on r.CHECKNUM = s.DocID



ROLLBACK TRAN 

/*

delete top(500) dbo.t_rkeeper_CHECKNUM_CARDCODE 
 
              SELECT @DiscCode = 122               
              
              BEGIN                                        
                /* Пишем в лог предоставления скидки по ДК только неакционные товары, скидка по которым = скидке ДК */            
                IF (NOT EXISTS (SELECT * 
                                FROM dbo.r_ProdMP WITH(NOLOCK) 
                                WHERE ProdID = @ProdID AND PLID = @PLID AND PromoPriceCC > 0 
                                  AND dbo.zf_GetDate(GETDATE()) BETWEEN BDate AND EDate)
                    AND 
                    NOT EXISTS (SELECT * 
                                FROM dbo.r_DCards WITH(NOLOCK) 
                                WHERE DCardID = @DCardID AND Discount != ROUND((1 - (@OrdPrice / @PurPrice))  * 100, 0)))
                BEGIN
                  IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = @DCardID)
                    INSERT dbo.z_DocDC 
                    (DocCode, ChID, DCardID)
                    VALUES
                    (11035, @SaleChID, @DCardID)                             
              
                  SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscExp WHERE DBiID = @DBiID           
            
                  INSERT dbo.z_LogDiscExp
                  (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, Discount, DBiID)
                  VALUES 
                  (@LogID, @DCardID, 1, 1011, @SaleChID, @SaleSrcPosID, @DiscCode, 0, ROUND((1 - (@OrdPrice / @PurPrice))  * 100, 0), @DBiID)               
                END
                /* По акционным товарам или товарам, скидка на которые не соответствует скидке в свойствах ДК - лог предоставления скидки не привязываем к ДК */
                ELSE                            
                BEGIN
                  IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = '<Нет дисконтной карты>')
                    INSERT dbo.z_DocDC 
                    (DocCode, ChID, DCardID)
                    VALUES
                    (1011, @SaleChID, '<Нет дисконтной карты>')                 
                
                  SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscExp WHERE DBiID = @DBiID           
             
                  INSERT dbo.z_LogDiscExp
                  (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, Discount, DBiID)
                  VALUES 
                  (@LogID, '<Нет дисконтной карты>', 1, 1011, @SaleChID, @SaleSrcPosID, 0, 0, (1 - (@OrdPrice / @PurPrice))  * 100, @DBiID)                                              
                END
              END                             
              
              /* Начисляем бонусы на ДК */
              IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 1011 AND ChID = @SaleChID AND DCardID = @DCardID)
                INSERT dbo.z_DocDC 
                (DocCode, ChID, DCardID)
                VALUES
                (1011, @SaleChID, @DCardID)                  
              
              SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscRec WHERE DBiID = @DBiID
              
              INSERT dbo.z_LogDiscRec
              (LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, logdate ,BonusType, DBiID)
              VALUES 
              (@LogID, @DCardID, 1, 1011, @SaleChID, @SaleSrcPosID, @DiscCode, @OrdPrice * @Qty,GETDATE(), 0, @DBiID)      
              
              */        
