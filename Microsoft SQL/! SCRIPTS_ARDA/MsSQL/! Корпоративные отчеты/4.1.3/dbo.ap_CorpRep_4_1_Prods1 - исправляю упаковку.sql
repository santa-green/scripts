USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_CorpRep_4_1_Prods]    Script Date: 20.06.2019 15:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_CorpRep_4_1_Prods] (
  @BDate SMALLDATETIME,
  @EDate SMALLDATETIME,
  @PartID TINYINT,
  @Ours VARCHAR(MAX),
  @PCats VARCHAR(MAX),
  @Codes1_1 VARCHAR(MAX),
  @Codes1_2 VARCHAR(MAX))
AS
BEGIN
  SET NOCOUNT ON
/*HISTORY*/
-- '2019-04-24 11:21' rkv0 Part1 меняем условие отображения 777777 ("нет движения" в PascalScript)
-- '2019-04-24 11:38' rkv0 Part2 меняем условие отображения 777777 ("нет движения" в PascalScript)
-- '2019-05-14 16:07' rkv0 отключаю условие "не показывать нулевые остатки"
--rkv0 '2019-05-21 15:21' сортируем по проеткам вместо ORDER BY ESumMC DESC
-- rkv0 '2019-05-23 11:45' временно убираю условие для теста HAVING (ROUND(SUM(ESumMC),0) <> 0)
-- rkv0 '2019-06-19 14:01' меняю сортировку в каждом модуле на сортировку по наименованию проекта и внутри проекта по наименованию группы/товара от А до Я согласно заявке Танцюры Галины от 19.06.2019.
--rkv0 '2019-06-19 14:45' убираю округление, т.к. это было актуально для предыдущего отчета 4.1 (там цифры были больше).



/*
  1 - Анализ остатков ТМЦ (алкоголь)... Сортировка:  ORDER BY SortESumMC DESC,TurnRatio DESC,ESumMC DESC (по убыванию: сумма остатков на по проекту + сумма остатков на по группе + оборот товара, год)
  2 - Анализ остатков ТМЦ (упаковка)... Сортировка: ORDER BY ESumMC DESC (по убыванию: остатки на по группе).
  3 - Группы товаров, по которым оборачиваемость превышает 12 месяцев. Сортировка: ORDER BY rpg1.Notes,TurnRatio DESC,ESumMC DESC (по возрастанию в алфавитном порядке название проекта + по убыванию оборот товара, год + сумма остатков на по группе)
  4 - Группы товаров, по которым нет продаж. Сортировка: ORDER BY rpg1.Notes,ESumMC DESC (по возрастанию в алфавитном порядке название проекта + по убыванию сумма остатков на по группе)
  5 - Группы товаров, по которым возврат превышает продажу. Сортировка: ORDER BY rpg1.Notes,rp.ProdName (по возрастанию в алфавитном порядке название проекта + по возрастанию в алфавитном порядке название группы)
*/

/*
--4.1.2  
  EXEC ap_CorpRep_4_1_Prods '20180101','20181231',1,'1-5,11','1-100','',''
--4.1.3 
  EXEC ap_CorpRep_4_1_Prods '20180101','20181231',2,'1-5,11','700','81-99','50-79,2000-3000'
--4.1.1
  EXEC ap_CorpRep_4_1_Prods '20180101','20181231',3,'1-5,11','1-100','',''

  EXEC ap_CorpRep_4_1_Prods '20180101','20181231',4,'1-5,11','1-100','50-79',''
  EXEC ap_CorpRep_4_1_Prods '20180101','20181231',5,'1-5,11','1-100','50-79',''
*/

  
  SET @BDate = @BDate - 1     
  
  --1------------------------------------------------------------------------------------------------------------
  IF @PartID = 1
  BEGIN
    CREATE TABLE #TCR_4_1
    (GPGrName1 VARCHAR(200),
     ProdName VARCHAR(200),
     InvSumMC NUMERIC(21,9),
     InvQty NUMERIC(21,9),
     ESumMC NUMERIC(21,9),
     EQty NUMERIC(21,9),
     TurnRatio NUMERIC(21,9))
     
    CREATE INDEX GPGrName1 ON #TCR_4_1 (GPGrName1 ASC) 
                    
    INSERT #TCR_4_1
    (GPGrName1, ProdName, InvSumMC, InvQty, ESumMC, EQty, TurnRatio)                    
    SELECT 
     rpg1.Notes GPGrName1, rp.ProdName, SUM(InvSumMC) InvSumMC, SUM(InvQty) InvQty,SUM(ESumMC) ESumMC,SUM(EQty) EQty,
     ((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)) TurnRatio
    FROM (
          --"На начало"
          SELECT rp.PGrID1, rp.ProdID,SUM(m.Qty * tp.CostMC) BSumMC,SUM(m.Qty) BQty,0 InvSumMC,0 InvQty,0 ESumMC,0 EQty
          FROM dbo.af_CalcRemDByRemIM (@BDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND m.StockID NOT BETWEEN 800 AND 899          
          GROUP BY rp.PGrID1, rp.ProdID
          
          UNION ALL
          --Сумма отгрузок за период          
          --Расходная накладная          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_InvD d WITH(NOLOCK)
          JOIN t_Inv m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))            
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID
          
          /*UNION ALL
          --Расходный документ          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_ExpD d WITH(NOLOCK)
          JOIN t_Exp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))                        
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID   

          UNION ALL          
          --Расходный документ в ценах прихода          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_EppD d WITH(NOLOCK)
          JOIN t_Epp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))                        
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID                    

          UNION ALL
          --Продажа товара оператором          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_SaleD d WITH(NOLOCK)
          JOIN t_Sale m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))                        
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID*/ 
		  
          UNION ALL
          --Возврат товара от получателя          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,-SUM(d.Qty*tp.CostMC) InvSumMC,-SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_RetD d WITH(NOLOCK)
          JOIN t_Ret m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))                        
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID

          /*UNION ALL
          --Возврат товара по чеку          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,-SUM(d.Qty*tp.CostMC) InvSumMC,-SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_CRRetD d WITH(NOLOCK)
          JOIN t_CRRet m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))                        
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID*/

          UNION ALL
          --Остатки на конец периода          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,0 InvSumMC,0 InvQty,SUM(m.Qty * tp.CostMC) ESumMC,SUM(m.Qty) EQty
          FROM dbo.af_CalcRemDByRemIM (@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC'))) 
            AND m.StockID NOT BETWEEN 800 AND 899                       
          GROUP BY rp.PGrID1, rp.ProdID ) q
    JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = q.PGrID1
    JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = q.ProdID                                                                    
    GROUP BY rpg1.Notes,rp.ProdName

/*    HAVING ((ROUND(SUM(BSumMC),0) <> 0)
        OR (ROUND(SUM(BQty),0) <> 0)    
        OR (ROUND(SUM(InvSumMC),0) <> 0)
        OR (ROUND(SUM(InvQty),0) <> 0)
        --OR (ROUND(SUM(ESumMC),0) <> 0)
        OR (ROUND(SUM(EQty),0) <> 0))*/
--rkv0 '2019-06-19 14:45' убираю округление, т.к. это было актуально для предыдущего отчета 4.1 (там цифры были больше).

            HAVING SUM(BSumMC) <> 0
        OR SUM(BQty) <> 0    
        OR SUM(InvSumMC) <> 0
        OR SUM(InvQty) <> 0
        --OR (ROUND(SUM(ESumMC),0) <> 0)
        OR SUM(EQty) <> 0

		-- '2019-05-14 16:07' rkv0 отключаю условие "не показывать нулевые остатки"
       --AND ROUND(SUM(ESumMC),0) <> 0        
    
    SELECT 
     GPGrName1,ProdName,InvSumMC,InvQty,ESumMC,EQty,
	 -- '2019-04-24 11:21' rkv0 меняем условие отображения 777777 ("нет движения" в PascalScript)
     --(CASE WHEN (TurnRatio IS NULL OR TurnRatio < 0) THEN 777777 
     (CASE WHEN (InvSumMC = 0 AND InvQty = 0 OR InvSumMC IS NULL AND InvQty IS NULL) THEN 777777 
           WHEN TurnRatio BETWEEN 0 AND 1 THEN ROUND(TurnRatio,1) ELSE ROUND(TurnRatio,0) END) TurnRatio,
     (ESumMC / (SELECT (CASE SUM(ESumMC) WHEN 0 THEN NULL ELSE SUM(ESumMC) END) FROM #TCR_4_1 WHERE GPGrName1 = t1.GPGrName1)) * 100 EndPercent,
     (InvSumMC / (SELECT (CASE SUM(InvSumMC) WHEN 0 THEN NULL ELSE SUM(InvSumMC) END) FROM #TCR_4_1 WHERE GPGrName1 = t1.GPGrName1)) * 100 InvPercent,
     ((SELECT SUM(ESumMC) FROM #TCR_4_1 WHERE GPGrName1 = t1.GPGrName1) / (SELECT (CASE SUM(ESumMC) WHEN 0 THEN NULL ELSE SUM(ESumMC) END) FROM #TCR_4_1)) * 100 GEndPercent,     
     ((SELECT SUM(InvSumMC) FROM #TCR_4_1 WHERE GPGrName1 = t1.GPGrName1) / (SELECT (CASE SUM(InvSumMC) WHEN 0 THEN NULL ELSE SUM(InvSumMC) END) FROM #TCR_4_1)) * 100 GInvPercent,
     (SELECT SUM(ESumMC) FROM #TCR_4_1 WHERE GPGrName1 = t1.GPGrName1) SortESumMC
    FROM #TCR_4_1 t1
    -- rkv0 '2019-06-19 11:50' меняю сортировку в каждом модуле на сортировку по наименованию проекта и внутри проекта по наименованию группы/товара от А до Я согласно заявке Танцюры Галины от 19.06.2019.
    --ORDER BY SortESumMC DESC,TurnRatio DESC,ESumMC DESC
    ORDER BY GPGrName1, ProdName
    DROP TABLE #TCR_4_1                         
  END
  
  --2------------------------------------------------------------------------------------------

  ELSE IF @PartID = 2
  BEGIN                  
    SELECT 
     rpg1.Notes GPGrName1,rp.ProdName,SUM(BSumMC) BSumMC,SUM(BQty) BQty,SUM(RecSumMC) RecSumMC,SUM(RecQty) RecQty,
     SUM(InvSumMC) InvSumMC,SUM(InvQty) InvQty,SUM(ESumMC) ESumMC,SUM(EQty) EQty,
	 -- '2019-04-24 11:38' rkv0 меняем условие отображения 777777 ("нет движения" в PascalScript)
     --(CASE WHEN ((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)) IS NULL
     --            OR ((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)) < 0
     (CASE WHEN (SUM(InvSumMC) = 0 AND SUM(InvQty) = 0 OR SUM(InvSumMC) IS NULL AND SUM(InvQty) IS NULL)
           THEN 777777
           WHEN ((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)) BETWEEN 0 AND 1 
           THEN ROUND(((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)),1)
           ELSE ROUND(((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)),0) END) TurnRatio
    FROM (
          --"На начало"
          SELECT rp.PGrID1, rp.ProdID,SUM(m.Qty * tp.CostMC) BSumMC,SUM(m.Qty) BQty,0 RecSumMC,0 RecQty,0 InvSumMC,0 InvQty,0 ESumMC,0 EQty
          FROM dbo.af_CalcRemDByRemIM (@BDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID

          UNION ALL
          --Приход за период
          --Приход товара          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) RecSumMC,SUM(d.Qty) RecQty,0 InvSumMC,0 InvQty,0 ESumMC,0 EQty
          FROM t_RecD d WITH(NOLOCK)
          JOIN t_Rec m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID  
          
          UNION ALL
          --Списание за период
          --Расходный документ          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,0 RecSumMC,0 RecQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_ExpD d WITH(NOLOCK)
          JOIN t_Exp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
 AND (@Codes1_2 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_2,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID

          UNION ALL
          --Расходный документ в ценах прихода          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,0 RecSumMC,0 RecQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_EppD d WITH(NOLOCK)
          JOIN t_Epp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_2 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_2,'r_Codes1')))             
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID

          UNION ALL
          --Остатки на конец периода          
          --На конец          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,0 RecSumMC,0 RecQty,0 InvSumMC,0 InvQty,SUM(m.Qty * tp.CostMC) ESumMC,SUM(m.Qty) EQty
          FROM dbo.af_CalcRemDByRemIM (@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND m.StockID NOT BETWEEN 800 AND 899                        
          GROUP BY rp.PGrID1, rp.ProdID ) q
    JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = q.PGrID1
    JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = q.ProdID                                                                    
    GROUP BY rpg1.Notes,rp.ProdName
    -- rkv0 '2019-05-23 11:45' временно убираю условие для теста HAVING (ROUND(SUM(ESumMC),0) <> 0)
    --HAVING (ROUND(SUM(ESumMC),0) <> 0) 
    --rkv0 '2019-05-21 15:21' сортируем по проеткам вместо ORDER BY ESumMC DESC
    -- rkv0 '2019-06-19 11:50' меняю сортировку в каждом модуле на сортировку по наименованию проекта и внутри проекта по наименованию группы/товара от А до Я согласно заявке Танцюры Галины от 19.06.2019.
    --ORDER BY rpg1.Notes, ESumMC DESC
    ORDER BY rpg1.Notes,rp.ProdName
  END
  
  --3----------------------------------------------------------------------------------------------------
  ELSE IF @PartID = 3
  BEGIN                  
    SELECT 
     rpg1.Notes GPGrName1,rp.ProdName,SUM(InvSumMC) InvSumMC,SUM(InvQty) InvQty,SUM(ESumMC) ESumMC,SUM(EQty) EQty,
     ((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)) TurnRatio
    FROM (
          --"На начало"
          SELECT rp.PGrID1, rp.ProdID,SUM(m.Qty * tp.CostMC) BSumMC,SUM(m.Qty) BQty,0 InvSumMC,0 InvQty,0 ESumMC,0 EQty
          FROM dbo.af_CalcRemDByRemIM (@BDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))  
            AND m.StockID NOT BETWEEN 800 AND 899                      
          GROUP BY rp.PGrID1, rp.ProdID
          
          UNION ALL
          --Сумма отгрузок за период
          --Расходная накладная          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_InvD d WITH(NOLOCK)
          JOIN t_Inv m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID
          
          /*UNION ALL
          --Расходный документ
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_ExpD d WITH(NOLOCK)
          JOIN t_Exp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID    
          
          UNION ALL
          --Расходный документ в ценах прихода
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_EppD d WITH(NOLOCK)
          JOIN t_Epp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID                   

          UNION ALL
          --Продажа товара оператором          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_SaleD d WITH(NOLOCK)
          JOIN t_Sale m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID*/

          UNION ALL
          --Возврат товара от получателя          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,-SUM(d.Qty*tp.CostMC) InvSumMC,-SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_RetD d WITH(NOLOCK)
          JOIN t_Ret m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID

          /*UNION ALL
          --Возврат товара по чеку          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,-SUM(d.Qty*tp.CostMC) InvSumMC,-SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_CRRetD d WITH(NOLOCK)
          JOIN t_CRRet m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID*/

          UNION ALL
          --Остатки на конец периода          
          --На конец          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,0 InvSumMC,0 InvQty,SUM(m.Qty * tp.CostMC) ESumMC,SUM(m.Qty) EQty
          FROM dbo.af_CalcRemDByRemIM (@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))  
            AND m.StockID NOT BETWEEN 800 AND 899                      
          GROUP BY rp.PGrID1, rp.ProdID ) q
    JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = q.PGrID1
    JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = q.ProdID                                                                    
    GROUP BY rpg1.Notes,rp.ProdName
 
     HAVING ((ROUND(SUM(BSumMC),0) <> 0)
        OR (ROUND(SUM(BQty),0) <> 0)    
        OR (ROUND(SUM(InvSumMC),0) <> 0)
        OR (ROUND(SUM(InvQty),0) <> 0)
        OR (ROUND(SUM(ESumMC),0) <> 0)
        OR (ROUND(SUM(EQty),0) <> 0))
       AND ROUND(SUM(ESumMC),0) <> 0
       AND ((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)) > 1

       -- rkv0 '2019-06-19 11:50' меняю сортировку в каждом модуле на сортировку по наименованию проекта и внутри проекта по наименованию группы/товара от А до Я согласно заявке Танцюры Галины от 19.06.2019.
    --ORDER BY rpg1.Notes,TurnRatio DESC,ESumMC DESC      
    ORDER BY rpg1.Notes,rp.ProdName

  END
  
  --4----------------------------------------------------------------------------
  ELSE IF @PartID = 4
  BEGIN                  
    SELECT 
     rpg1.Notes GPGrName1,rp.ProdName,SUM(InvSumMC) InvSumMC,SUM(InvQty) InvQty,SUM(ESumMC) ESumMC,SUM(EQty) EQty,
     ((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)) TurnRatio
    FROM (
          --На начало
          SELECT rp.PGrID1, rp.ProdID,SUM(m.Qty * tp.CostMC) BSumMC,SUM(m.Qty) BQty,0 InvSumMC,0 InvQty,0 ESumMC,0 EQty
          FROM dbo.af_CalcRemDByRemIM (@BDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))      
            AND m.StockID NOT BETWEEN 800 AND 899                  
          GROUP BY rp.PGrID1, rp.ProdID

          UNION ALL
          --Сумма отгрузок за период
          --Расходная накладная          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_InvD d WITH(NOLOCK)
          JOIN t_Inv m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID
          
          /*UNION ALL
          --Расходный документ       
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_ExpD d WITH(NOLOCK)
          JOIN t_Exp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID  
          
          UNION ALL
          --Расходный документ в ценах прихода      
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_EppD d WITH(NOLOCK)
          JOIN t_Epp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID                    

          UNION ALL
          --Продажа товара оператором          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_SaleD d WITH(NOLOCK)
          JOIN t_Sale m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID*/

          UNION ALL
          --Возврат товара от получателя          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,-SUM(d.Qty*tp.CostMC) InvSumMC,-SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_RetD d WITH(NOLOCK)
          JOIN t_Ret m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID

          /*UNION ALL
          --Возврат товара по чеку          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,-SUM(d.Qty*tp.CostMC) InvSumMC,-SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_CRRetD d WITH(NOLOCK)
          JOIN t_CRRet m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (@Codes1_1 = '' OR m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Codes1_1,'r_Codes1')))              
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID*/

          UNION ALL
          --Остатки на конец периода          
          --На конец          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,0 InvSumMC,0 InvQty,SUM(m.Qty * tp.CostMC) ESumMC,SUM(m.Qty) EQty
          FROM dbo.af_CalcRemDByRemIM (@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND m.StockID NOT BETWEEN 800 AND 899                        
          GROUP BY rp.PGrID1, rp.ProdID ) q
    JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = q.PGrID1
    JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = q.ProdID                                                                    
    GROUP BY rpg1.Notes,rp.ProdName
    HAVING ((ROUND(SUM(BSumMC),0) <> 0)
        OR (ROUND(SUM(BQty),0) <> 0)    
        --OR (ROUND(SUM(InvSumMC),0) <> 0)
        OR (ROUND(SUM(InvQty),0) <> 0)
        OR (ROUND(SUM(ESumMC),0) <> 0)
        OR (ROUND(SUM(EQty),0) <> 0))
    --rkv0 '2019-06-19 14:45' убираю округление InvSumMC, т.к. это было актуально для предыдущего отчета 4.1 (там цифры были больше).
       AND SUM(InvSumMC) = 0
       --AND (ROUND(SUM(ESumMC),0) <> 0)
       --rkv0 '2019-06-19 16:40' убрал условие "сумма не равна 0" по заявке Танцюры.
       --AND SUM(ESumMC) <> 0
    -- rkv0 '2019-06-19 11:50' меняю сортировку в каждом модуле на сортировку по наименованию проекта и внутри проекта по наименованию группы/товара от А до Я согласно заявке Танцюры Галины от 19.06.2019.
    --ORDER BY rpg1.Notes,ESumMC DESC   
    ORDER BY rpg1.Notes,rp.ProdName

  END

  --5----------------------------------------------------------------------------
  ELSE IF @PartID = 5
  BEGIN                  
    SELECT 
     rpg1.Notes GPGrName1,rp.ProdName,SUM(InvSumMC) InvSumMC,SUM(InvQty) InvQty,SUM(ESumMC) ESumMC,SUM(EQty) EQty,
     ((ROUND(SUM(BQty),0) + ROUND(SUM(EQty),0)) / 2 / (CASE ROUND(SUM(InvQty),0) WHEN 0 THEN NULL ELSE ROUND(SUM(InvQty),0) END)) TurnRatio
    FROM (
          --На начало
          SELECT rp.PGrID1, rp.ProdID,SUM(m.Qty * tp.CostMC) BSumMC,SUM(m.Qty) BQty,0 InvSumMC,0 InvQty,0 ESumMC,0 EQty
          FROM dbo.af_CalcRemDByRemIM (@BDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC'))) 
            AND m.StockID NOT BETWEEN 800 AND 899                       
          GROUP BY rp.PGrID1, rp.ProdID

          UNION ALL
          --Сумма отгрузок за период
          --Расходная накладная          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_InvD d WITH(NOLOCK)
          JOIN t_Inv m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID

          /*UNION ALL
          --Продажа товара оператором          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,SUM(d.Qty*tp.CostMC) InvSumMC,SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_SaleD d WITH(NOLOCK)
          JOIN t_Sale m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID*/

          UNION ALL
          --Возврат товара от получателя          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,-SUM(d.Qty*tp.CostMC) InvSumMC,-SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_RetD d WITH(NOLOCK)
          JOIN t_Ret m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID

          /*UNION ALL
          --Возврат товара по чеку          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,-SUM(d.Qty*tp.CostMC) InvSumMC,-SUM(d.Qty) InvQty,0 ESumMC,0 EQty
          FROM t_CRRetD d WITH(NOLOCK)
          JOIN t_CRRet m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
            AND m.StockID NOT BETWEEN 800 AND 899              
          GROUP BY rp.PGrID1, rp.ProdID*/

          UNION ALL
          --Остатки на конец периода          
          --На конец          
          SELECT rp.PGrID1, rp.ProdID,0 BSumMC,0 BQty,0 InvSumMC,0 InvQty,SUM(m.Qty * tp.CostMC) ESumMC,SUM(m.Qty) EQty
          FROM dbo.af_CalcRemDByRemIM (@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC'))) 
            AND m.StockID NOT BETWEEN 800 AND 899                       
          GROUP BY rp.PGrID1, rp.ProdID ) q
    JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = q.PGrID1
    JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = q.ProdID                                                                    
    GROUP BY rpg1.Notes,rp.ProdName

    HAVING ((ROUND(SUM(BSumMC),0) <> 0)
        OR (ROUND(SUM(BQty),0) <> 0)    
        OR (ROUND(SUM(InvSumMC),0) <> 0)
        OR (ROUND(SUM(InvQty),0) <> 0)
        OR (ROUND(SUM(ESumMC),0) <> 0)
        OR (ROUND(SUM(EQty),0) <> 0))
       AND (ROUND(SUM(InvSumMC),0) < 0)

    ORDER BY rpg1.Notes,rp.ProdName        
  END
END




GO
