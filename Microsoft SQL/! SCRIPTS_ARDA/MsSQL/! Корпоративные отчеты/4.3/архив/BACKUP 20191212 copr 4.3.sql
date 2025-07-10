CREATE PROCEDURE [dbo].[ap_CorpRep_4_3_TEST] (@BDate SMALLDATETIME,@EDate SMALLDATETIME,@PartID TINYINT,
                                        @Ours VARCHAR(1000),@PCats VARCHAR(1000),@FinBDate SMALLDATETIME)
AS
BEGIN

/*
EXEC [dbo].[ap_CorpRep_4_3_TEST] '20181101','20191031',2, '1-5,11','500,501','20180401'
*/

  SET NOCOUNT ON
  
  SET @BDate = (@BDate - 1)
  
  IF @PartID = 1
  BEGIN
    SELECT GPGrName1,SUM(ESumMC) ESumMC,SUM(EQty) EQty 
    FROM (                           
          SELECT 
            (CASE WHEN rpg1.PGrName1 LIKE 'Алеф-Эксклюзив проект%' THEN 'Алеф-Эксклюзив проект'
                  WHEN rpg1.PGrName1 LIKE 'Бакарди-Мартини проект%' THEN 'Бакарди-Мартини проект'
                  WHEN rpg1.PGrName1 LIKE 'Барная группа проект%' THEN 'Барная группа проект'
                  WHEN rpg1.PGrName1 LIKE 'Вeam Global проект%' THEN 'Вeam Global проект'
                  WHEN rpg1.PGrName1 LIKE 'Виски-Коньяк проект%' THEN 'Виски-Коньяк проект'           
                  WHEN rpg1.PGrName1 LIKE 'Водка STOLETOV%' THEN 'Водка STOLETOV проект' 
                  WHEN rpg1.PGrName1 LIKE 'Комплекс-Бар проект%' THEN 'Комплекс-Бар проект'                      
                  WHEN rpg1.PGrName1 LIKE 'Крепкий алкоголь проект%' THEN 'Крепкий алкоголь проект (прочий ассорт.)'           
                  WHEN rpg1.PGrName1 LIKE 'С&C - Evian проект%' THEN 'С&C - BF - Evian проект'
                  ELSE rpg1.PGrName1 END) GPGrName1,SUM(ESumMC) ESumMC,SUM(EQty) EQty
          FROM (
                /* Остатки на конец периода */          
                SELECT rp.PGrID1,SUM(m.Qty * tp.CostMC) ESumMC,SUM(m.Qty) EQty
                FROM dbo.af_CalcRemDByRemIM(@EDate) m
                JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
                JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
                WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
                  AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))                
                GROUP BY rp.PGrID1 ) q
          JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = q.PGrID1
          GROUP BY rpg1.PGrName1                                                                   
          HAVING (ROUND(SUM(ESumMC),0) <> 0) OR (ROUND(SUM(EQty),0) <> 0) ) q
    GROUP BY GPGrName1
    ORDER BY GPGrName1                                      
  END
  
  --2------------------------------------------------------------------------------------------
  IF @PartID = 2
  BEGIN
    CREATE TABLE #Part2 
    (GPGrName1 VARCHAR(250),PGrID2 INT,BBSumMC NUMERIC(21,9),BBQty NUMERIC(21,9),
     ABSumMC NUMERIC(21,9),ABQty NUMERIC(21,9),RecSumMC NUMERIC(21,9),RecQty NUMERIC(21,9),
     BInvSumMC NUMERIC(21,9),BInvQty NUMERIC(21,9),AInvSumMC NUMERIC(21,9),AInvQty NUMERIC(21,9),
     BESumMC NUMERIC(21,9),BEQty NUMERIC(21,9),AESumMC NUMERIC(21,9),AEQty NUMERIC(21,9))
    
    CREATE NONCLUSTERED INDEX GPGrName1 ON #Part2 (GPGrName1 ASC)
    CREATE NONCLUSTERED INDEX PGrID2 ON #Part2 (PGrID2 ASC)    
                       
    INSERT #Part2                    
    SELECT 
     (CASE WHEN rpg1.PGrName1 LIKE 'Алеф-Эксклюзив проект%' THEN 'Алеф-Эксклюзив проект'
           WHEN rpg1.PGrName1 LIKE 'Бакарди-Мартини проект%' THEN 'Бакарди-Мартини проект'
           WHEN rpg1.PGrName1 LIKE 'Барная группа проект%' THEN 'Барная группа проект'
           WHEN rpg1.PGrName1 LIKE 'Вeam Global проект%' THEN 'Вeam Global проект'
           WHEN rpg1.PGrName1 LIKE 'Виски-Коньяк проект%' THEN 'Виски-Коньяк проект'           
           WHEN rpg1.PGrName1 LIKE 'Водка STOLETOV%' THEN 'Водка STOLETOV проект' 
           WHEN rpg1.PGrName1 LIKE 'Комплекс-Бар проект%' THEN 'Комплекс-Бар проект'                      
           WHEN rpg1.PGrName1 LIKE 'Крепкий алкоголь проект%' THEN 'Крепкий алкоголь проект (прочий ассорт.)'           
           WHEN rpg1.PGrName1 LIKE 'С&C - Evian проект%' THEN 'С&C - BF - Evian проект'
           ELSE rpg1.PGrName1 END) GPGrName1,PGrID2,
     SUM(BBSumMC) BBSumMC,SUM(BBQty) BBQty,SUM(ABSumMC) ABSumMC,SUM(ABQty) ABQty,
     SUM(RecSumMC) RecSumMC,SUM(RecQty) RecQty,SUM(BInvSumMC) BInvSumMC,SUM(BInvQty) BInvQty,SUM(AInvSumMC) AInvSumMC,SUM(AInvQty) AInvQty,
     SUM(BESumMC) BESumMC,SUM(BEQty) BEQty,SUM(AESumMC) AESumMC,SUM(AEQty) AEQty
    FROM (
          /* На начало */
          SELECT 
           rp.PGrID1,rp.PGrID2,SUM(m.Qty * tp.CostMC) BBSumMC,SUM(m.Qty) BBQty,0 ABSumMC, 0 ABQty,
           0 RecSumMC,0 RecQty,0 BInvSumMC,0 BInvQty,0 AInvSumMC,0 AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM dbo.af_CalcRemDByRemIM(@BDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE tp.ProdDate < @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
          GROUP BY rp.PGrID1,rp.PGrID2
          
          UNION ALL
          
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,SUM(m.Qty * tp.CostMC) ABSumMC,SUM(m.Qty) ABQty,
           0 RecSumMC,0 RecQty,0 BInvSumMC,0 BInvQty,0 AInvSumMC,0 AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM dbo.af_CalcRemDByRemIM(@BDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE tp.ProdDate >= @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
          GROUP BY rp.PGrID1,rp.PGrID2          
          
          UNION ALL
          /* Приход */
          --Приход товара          
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,SUM(d.Qty*tp.CostMC) RecSumMC,SUM(d.Qty) RecQty,
           0 BInvSumMC,0 BInvQty,0 AInvSumMC,0 AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM t_RecD d WITH(NOLOCK)
          JOIN t_Rec m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
          GROUP BY rp.PGrID1,rp.PGrID2

          UNION ALL
          --Возврат товара от получателя          
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,SUM(d.Qty*tp.CostMC) RecSumMC,SUM(d.Qty) RecQty,
           0 BInvSumMC,0 BInvQty,0 AInvSumMC,0 AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM t_RetD d WITH(NOLOCK)
          JOIN t_Ret m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
          GROUP BY rp.PGrID1,rp.PGrID2 
          
          UNION ALL
          /* Расход */
          --Расходная накладная          
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,
           SUM(d.Qty*tp.CostMC) BInvSumMC,SUM(d.Qty) BInvQty,0 AInvSumMC,0 AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM t_InvD d WITH(NOLOCK)
          JOIN t_Inv m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE tp.ProdDate < @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
          GROUP BY rp.PGrID1,rp.PGrID2
          
          UNION ALL
          --Расходная накладная                    
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,
           0 BInvSumMC,0 BInvQty,SUM(d.Qty*tp.CostMC) AInvSumMC,SUM(d.Qty) AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM t_InvD d WITH(NOLOCK)
          JOIN t_Inv m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE tp.ProdDate >= @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
          GROUP BY rp.PGrID1,rp.PGrID2          

          UNION ALL
          --Расходный документ          
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,
           SUM(d.Qty*tp.CostMC) BInvSumMC,SUM(d.Qty) BInvQty,0 AInvSumMC,0 AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM t_ExpD d WITH(NOLOCK)
          JOIN t_Exp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE tp.ProdDate < @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
          GROUP BY rp.PGrID1,rp.PGrID2

          UNION ALL
          --Расходный документ          
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,
           0 BInvSumMC,0 BInvQty,SUM(d.Qty*tp.CostMC) AInvSumMC,SUM(d.Qty) AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM t_ExpD d WITH(NOLOCK)
          JOIN t_Exp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE tp.ProdDate >= @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
          GROUP BY rp.PGrID1,rp.PGrID2  
                  
          UNION ALL
          
          --Расходный документ в ценах прихода          
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,
           SUM(d.Qty*tp.CostMC) BInvSumMC,SUM(d.Qty) BInvQty,0 AInvSumMC,0 AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM t_EppD d WITH(NOLOCK)
          JOIN t_Epp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE tp.ProdDate < @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
          GROUP BY rp.PGrID1,rp.PGrID2         
                  
          UNION ALL
          
          --Расходный документ в ценах прихода          
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,
           0 BInvSumMC,0 BInvQty,SUM(d.Qty*tp.CostMC) AInvSumMC,SUM(d.Qty) AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
          FROM t_EppD d WITH(NOLOCK)
          JOIN t_Epp m WITH(NOLOCK) ON m.ChID = d.ChID    
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          WHERE tp.ProdDate >= @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
            AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
          GROUP BY rp.PGrID1,rp.PGrID2              

          UNION ALL
          /* Комплектация товара */
          -- '2019-12-12 15:33' rkv0 добавляю в формулу документ "Комплектация товара" (со знаком "-")    
        --SELECT * FROM [s-sql-d4].[elit].dbo.z_tables WHERE tableDesc LIKE 'комплектация товара%'
        --t_SRec Комплектация товара: Заголовок
        --t_SRecD Комплектация товара: Составляющие
        --Комплектация товара Составляющие (до)  
        SELECT  
         rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,
         0 BInvSumMC,0 BInvQty,SUM(0-(t_SRecD.SubQty * tp.CostMC)) AInvSumMC,SUM(0-(t_SRecD.SubQty)) AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
        FROM av_t_SRec m WITH(NOLOCK)
        JOIN r_Ours rou WITH(NOLOCK) ON (rou.OurID=m.OurID)
        --JOIN r_Stocks r_Stocks_256 WITH(NOLOCK) ON (r_Stocks_256.StockID=m.StockID)
        JOIN av_t_SRecA t_SRecA_243 WITH(NOLOCK) ON (t_SRecA_243.ChID=m.ChID)
        JOIN av_t_SRecD t_SRecD WITH(NOLOCK) ON (t_SRecD.AChID=t_SRecA_243.AChID)
        JOIN t_PInP tp WITH(NOLOCK) ON (tp.PPID=t_SRecD.SubPPID AND tp.ProdID=t_SRecD.SubProdID)
        JOIN r_Prods rp WITH(NOLOCK) ON (rp.ProdID=tp.ProdID)
        --JOIN at_r_ProdG4 at_r_ProdG4_253 WITH(NOLOCK) ON (at_r_ProdG4_253.PGrID4=rp.PGrID4)
        --JOIN at_r_ProdG5 at_r_ProdG5_254 WITH(NOLOCK) ON (at_r_ProdG5_254.PGrID5=rp.PGrID5)
        --JOIN at_r_ProdsAmort at_r_ProdsAmort_248 WITH(NOLOCK) ON (at_r_ProdsAmort_248.AmortID=rp.AmortID)
        --JOIN r_ProdC r_ProdC_249 WITH(NOLOCK) ON (r_ProdC_249.PCatID=rp.PCatID)
        --JOIN r_ProdG r_ProdG_247 WITH(NOLOCK) ON (r_ProdG_247.PGrID=rp.PGrID)
        --JOIN r_ProdG1 r_ProdG1_250 WITH(NOLOCK) ON (r_ProdG1_250.PGrID1=rp.PGrID1)
        --JOIN r_ProdG2 r_ProdG2_251 WITH(NOLOCK) ON (r_ProdG2_251.PGrID2=rp.PGrID2)
        --JOIN r_ProdG3 r_ProdG3_252 WITH(NOLOCK) ON (r_ProdG3_252.PGrID3=rp.PGrID3)
        --JOIN r_Deps r_Deps_257 WITH(NOLOCK) ON (r_Deps_257.DepID=r_Stocks_256.DepID)
        --JOIN r_StockGs r_StockGs_258 WITH(NOLOCK) ON (r_StockGs_258.StockGID=r_Stocks_256.StockGID)
        WHERE tp.ProdDate < @FinBDate
        AND(@Ours = '' OR rou.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
        AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
        AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
        GROUP BY rp.PGrID1,rp.PGrID2
        --Комплектация товара Составляющие (после)  
        UNION ALL
        SELECT  
        rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,
        0 BInvSumMC,0 BInvQty,SUM(0-(t_SRecD.SubQty * tp.CostMC)) AInvSumMC,SUM(0-(t_SRecD.SubQty)) AInvQty,0 BESumMC,0 BEQty,0 AESumMC,0 AEQty
        FROM av_t_SRec m WITH(NOLOCK)
        JOIN r_Ours rou WITH(NOLOCK) ON (rou.OurID=m.OurID)
        --JOIN r_Stocks r_Stocks_256 WITH(NOLOCK) ON (r_Stocks_256.StockID=m.StockID)
        JOIN av_t_SRecA t_SRecA_243 WITH(NOLOCK) ON (t_SRecA_243.ChID=m.ChID)
        JOIN av_t_SRecD t_SRecD WITH(NOLOCK) ON (t_SRecD.AChID=t_SRecA_243.AChID)
        JOIN t_PInP tp WITH(NOLOCK) ON (tp.PPID=t_SRecD.SubPPID AND tp.ProdID=t_SRecD.SubProdID)
        JOIN r_Prods rp WITH(NOLOCK) ON (rp.ProdID=tp.ProdID)
        --JOIN at_r_ProdG4 at_r_ProdG4_253 WITH(NOLOCK) ON (at_r_ProdG4_253.PGrID4=rp.PGrID4)
        --JOIN at_r_ProdG5 at_r_ProdG5_254 WITH(NOLOCK) ON (at_r_ProdG5_254.PGrID5=rp.PGrID5)
        --JOIN at_r_ProdsAmort at_r_ProdsAmort_248 WITH(NOLOCK) ON (at_r_ProdsAmort_248.AmortID=rp.AmortID)
        --JOIN r_ProdC r_ProdC_249 WITH(NOLOCK) ON (r_ProdC_249.PCatID=rp.PCatID)
        --JOIN r_ProdG r_ProdG_247 WITH(NOLOCK) ON (r_ProdG_247.PGrID=rp.PGrID)
        --JOIN r_ProdG1 r_ProdG1_250 WITH(NOLOCK) ON (r_ProdG1_250.PGrID1=rp.PGrID1)
        --JOIN r_ProdG2 r_ProdG2_251 WITH(NOLOCK) ON (r_ProdG2_251.PGrID2=rp.PGrID2)
        --JOIN r_ProdG3 r_ProdG3_252 WITH(NOLOCK) ON (r_ProdG3_252.PGrID3=rp.PGrID3)
        --JOIN r_Deps r_Deps_257 WITH(NOLOCK) ON (r_Deps_257.DepID=r_Stocks_256.DepID)
        --JOIN r_StockGs r_StockGs_258 WITH(NOLOCK) ON (r_StockGs_258.StockGID=r_Stocks_256.StockGID)
        WHERE tp.ProdDate >= @FinBDate
        AND(@Ours = '' OR rou.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
        AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))
        AND (m.DocDate BETWEEN @BDate + 1 AND @EDate)
        GROUP BY rp.PGrID1,rp.PGrID2
        
          UNION ALL
          /* Остатки на конец периода */               
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,0 BInvSumMC,0 BInvQty,
           0 AInvSumMC,0 AInvQty,SUM(m.Qty * tp.CostMC) BESumMC,SUM(m.Qty) BEQty,0 AESumMC,0 AEQty
          FROM dbo.af_CalcRemDByRemIM(@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE tp.ProdDate < @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))          
          GROUP BY rp.PGrID1,rp.PGrID2 
          
          UNION ALL
          /* Остатки на конец периода */               
          SELECT 
           rp.PGrID1,rp.PGrID2,0 BBSumMC,0 BBQty,0 ABSumMC,0 ABQty,0 RecSumMC,0 RecQty,0 BInvSumMC,0 BInvQty,
           0 AInvSumMC,0 AInvQty,0 BESumMC,0 BEQty,SUM(m.Qty * tp.CostMC) AESumMC,SUM(m.Qty) AEQty
          FROM dbo.af_CalcRemDByRemIM(@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
          WHERE tp.ProdDate >= @FinBDate
            AND (@Ours = '' OR m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@Ours,'r_Ours'))) 
            AND (@PCats = '' OR rp.PCatID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@PCats,'r_ProdC')))          
          GROUP BY rp.PGrID1,rp.PGrID2 ) q
    JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = q.PGrID1
    GROUP BY rpg1.PGrName1,PGrID2
    HAVING (ROUND(SUM(BBSumMC),0) <> 0)
        OR (ROUND(SUM(BBQty),0) <> 0)    
        OR (ROUND(SUM(ABSumMC),0) <> 0)
        OR (ROUND(SUM(ABQty),0) <> 0)            
        OR (ROUND(SUM(RecSumMC),0) <> 0)    
        OR (ROUND(SUM(RecQty),0) <> 0)        
        OR (ROUND(SUM(BInvSumMC),0) <> 0)
        OR (ROUND(SUM(BInvQty),0) <> 0)
        OR (ROUND(SUM(AInvSumMC),0) <> 0)
        OR (ROUND(SUM(AInvQty),0) <> 0)              
        OR (ROUND(SUM(BESumMC),0) <> 0)
        OR (ROUND(SUM(BEQty),0) <> 0)        
        OR (ROUND(SUM(AESumMC),0) <> 0)
        OR (ROUND(SUM(AEQty),0) <> 0)                
    
    SELECT 
     GPGrName1,rpg2.PGrName2,SUM(BBSumMC) BBSumMC,SUM(BBQty) BBQty,SUM(ABSumMC) ABSumMC,SUM(ABQty) ABQty,
     SUM(RecSumMC) RecSumMC,SUM(RecQty) RecQty,SUM(BInvSumMC) BInvSumMC,SUM(BInvQty) BInvQty,SUM(AInvSumMC) AInvSumMC,SUM(AInvQty) AInvQty,
     SUM(BESumMC) BESumMC,SUM(BEQty) BEQty,SUM(AESumMC) AESumMC,SUM(AEQty) AEQty,
     --(SUM(BEQty) / (SELECT (CASE SUM(BEQty) WHEN 0 THEN NULL ELSE SUM(BEQty) END) FROM #Part2 WHERE GPGrName1 = t2.GPGrName1)) * 100 BEndPercent,
     --(SUM(AEQty) / (SELECT (CASE SUM(AEQty) WHEN 0 THEN NULL ELSE SUM(AEQty) END) FROM #Part2 WHERE GPGrName1 = t2.GPGrName1)) * 100 AEndPercent
	 --08.02.2019/rkv0 комментим 2 строки (исходник) и меняем количество на сумму
	 (SUM(BESumMC) / (SELECT (CASE SUM(BESumMC) WHEN 0 THEN NULL ELSE SUM(BESumMC) END) FROM #Part2 WHERE GPGrName1 = t2.GPGrName1)) * 100 BEndPercent,
     (SUM(AESumMC) / (SELECT (CASE SUM(AESumMC) WHEN 0 THEN NULL ELSE SUM(AESumMC) END) FROM #Part2 WHERE GPGrName1 = t2.GPGrName1)) * 100 AEndPercent
    FROM #Part2 t2
    JOIN r_ProdG2 rpg2 WITH(NOLOCK) ON rpg2.PGrID2 = t2.PGrID2
    GROUP BY GPGrName1,rpg2.PGrName2
    ORDER BY GPGrName1 DESC
    
    DROP TABLE #Part2                      
  END
END  
 

            




GO
