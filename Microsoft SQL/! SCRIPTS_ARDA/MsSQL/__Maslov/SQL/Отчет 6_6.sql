DECLARE @ABDate SMALLDATETIME = '20180401',
		@AEDate SMALLDATETIME = '20180830',                                  
        @AOurs VARCHAR(1000) = '1-6,11',
        @ACodes1 VARCHAR(1000) = '2000-3000',
        @ACodes5 VARCHAR(1000) = '2056-2062,2067',
        @Head INT = 0
  SET NOCOUNT ON
    
  DECLARE 
   @AMCount TINYINT,@AMaxMonthID TINYINT,@ATExtra NUMERIC(21,9),@AYearID SMALLINT,@ATotalText VARCHAR(100),
   @AUserID INT,@AMaxYearID SMALLINT,@AMonthID TINYINT,@ACodeID5 SMALLINT,@ACodeID1 SMALLINT, @ACodeID2 SMALLINT  
   
  SET @AUserID = dbo.zf_GetUserCode() 
  
     DECLARE 
     @Rep6_6 TABLE (CodeID5 SMALLINT,CodeID1 SMALLINT, CodeID2 SMALLINT,YearID SMALLINT,
                    MonthID TINYINT,SumMC NUMERIC(21,9))
  
    INSERT INTO @Rep6_6  
    SELECT
     CodeID5, CodeID1, CodeID2, YearID, MonthID,
     SUM(SumMC) SumMC
    FROM (
--Расходы итого
		  --1. Приход товара (План)
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (d.Qty * tp.CostMC)) SumMC
          FROM t_Rec m WITH(NOLOCK)
          JOIN t_RecD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID4 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate
          
          UNION ALL          
          --2. Возврат товара от получателя (План)
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (d.Qty * tp.CostMC)) SumMC
          FROM t_Ret m WITH(NOLOCK)
          JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate           
         
          UNION ALL          
          --3. Возврат товара поставщику (План)
          SELECT
           m.CodeID5,m.CodeID1, m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_CRet m WITH(NOLOCK)
          JOIN t_CRetD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate            
          
          UNION ALL
          --4. Расходная накладная (План)
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_Inv m WITH(NOLOCK)
          JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate          
         
          UNION ALL
          --5. Расходный документ (План)
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_Exp m WITH(NOLOCK)
          JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate          
          
          UNION ALL
          --6. Расходный документ в ценах прихода (План)
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0-(d.Qty * tp.CostMC)) SumMC
          FROM t_Epp m WITH(NOLOCK)
          JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate          
          
          UNION ALL
          --7. Переоценка цен приход (Приход) (План)
          SELECT
           rpg1.CodeID5 ,rpc.CodeID1,rpg.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (d.Qty * tp.CostMC)) SumMC
          FROM t_Est m WITH(NOLOCK)
          JOIN t_EstD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.NewPPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          JOIN r_ProdC rpc WITH(NOLOCK) ON rpc.PCatID = rp.PCatID
          JOIN r_ProdG rpg WITH(NOLOCK) ON rpg.PGrID=rp.PGrID
          JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1=rp.PGrID1
          WHERE m.OurID IN (14,15,16)
            AND rpc.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND rpg1.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY rpg1.CodeID5,rpg.CodeID2,rpc.CodeID1,DocDate                
          
          UNION ALL      
          --8. Приход денег по предприятиям (План)
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (m.SumAC / m.KursMC)) SumMC
          FROM c_CompRec m WITH(NOLOCK)
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,DocDate          
          
          UNION ALL
           --9. Расход денег по предприятиям (План)
           SELECT
           m.CodeID5,m.CodeID1, m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(m.SumAC / m.KursMC) SumMC
          FROM c_CompExp m WITH(NOLOCK)
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5, m.CodeID2, m.CodeID1,m.DocDate              
          
          UNION ALL
          --10. Приём наличных денег на склад (План) 
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (m.SumAC / m.KursMC)) SumMC
          FROM t_MonRec m WITH(NOLOCK)
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate 
          
          UNION ALL        
          --11. Переоценка цен приход (Расход) (План)
		  SELECT
           rpg1.CodeID5, rpc.CodeID1, 
           rpg.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_Est m WITH(NOLOCK)
          JOIN t_EstD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          JOIN r_ProdC rpc WITH(NOLOCK) ON rpc.PCatID = rp.PCatID
          JOIN r_ProdG rpg WITH(NOLOCK) ON rpg.PGrID=rp.PGrID
          JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1=rp.PGrID1
          WHERE m.OurID IN (14,15,16)
            AND rpc.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND rpg1.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY rpg1.CodeID5,rpg.CodeID2,rpc.CodeID1,m.DocDate          
          
          UNION ALL
          --12. Возврат товара по чеку (План)
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0- (d.Qty * tp.CostMC)) SumMC
          FROM t_CRRet m WITH(NOLOCK)
          JOIN t_CRRetD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate
          
          UNION ALL
          --13. Продажа товара оператором (План)
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_Sale m WITH(NOLOCK)
          JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE --m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
			m.OurID IN (14,15,16)
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate
          
          UNION ALL
          --14. Приход товара
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (d.Qty * tp.CostMC)) SumMC
          FROM t_Rec m WITH(NOLOCK)
          JOIN t_RecD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID4 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate
          
          UNION ALL
          --15. Возврат товара от получателя
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (d.Qty * tp.CostMC)) SumMC
          FROM t_Ret m WITH(NOLOCK)
          JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate           
         
          UNION ALL          
          --16. Возврат товара поставщику
          SELECT
           m.CodeID5,m.CodeID1, m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_CRet m WITH(NOLOCK)
          JOIN t_CRetD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate            
          
          UNION ALL
          --17. Расходная накладная
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_Inv m WITH(NOLOCK)
          JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate          
         
          UNION ALL
          --18. Расходный документ
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_Exp m WITH(NOLOCK)
          JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate          
          
          UNION ALL
          --19. Расходный документ в ценах прихода
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_Epp m WITH(NOLOCK)
          JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate          
          
          UNION ALL      
          --20. Переоценка цен приход (Приход)
          SELECT
           rpg1.CodeID5 ,rpc.CodeID1,rpg.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (d.Qty * tp.CostMC)) SumMC
          FROM t_Est m WITH(NOLOCK)
          JOIN t_EstD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.NewPPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          JOIN r_ProdC rpc WITH(NOLOCK) ON rpc.PCatID = rp.PCatID
          JOIN r_ProdG rpg WITH(NOLOCK) ON rpg.PGrID=rp.PGrID
          JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1=rp.PGrID1
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND rpc.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND rpg1.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY rpg1.CodeID5,rpg.CodeID2,rpc.CodeID1,DocDate                 
          
          UNION ALL
          --21. Приход денег по предприятиям
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (m.SumAC / m.KursMC)) SumMC
          FROM c_CompRec m WITH(NOLOCK)
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,DocDate          
          
          UNION ALL
           --22. Расход денег по предприятиям
           SELECT
           m.CodeID5,m.CodeID1, m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(m.SumAC / m.KursMC) SumMC
          FROM c_CompExp m WITH(NOLOCK)
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5, m.CodeID2, m.CodeID1,m.DocDate              
          
          UNION ALL          
          --23. Приём наличных денег на склад 
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (m.SumAC / m.KursMC)) SumMC
          FROM t_MonRec m WITH(NOLOCK)
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate 
          
          UNION ALL 
                 
          --24. Переоценка цен приход (Расход) 
          SELECT
           rpg1.CodeID5, rpc.CodeID1, 
           rpg.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_Est m WITH(NOLOCK)
          JOIN t_EstD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
          JOIN r_ProdC rpc WITH(NOLOCK) ON rpc.PCatID = rp.PCatID
          JOIN r_ProdG rpg WITH(NOLOCK) ON rpg.PGrID=rp.PGrID
          JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1=rp.PGrID1
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND rpc.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND rpg1.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY rpg1.CodeID5,rpg.CodeID2,rpc.CodeID1,m.DocDate         
          
          UNION ALL
          --25. Возврат товара по чеку
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(0 - (d.Qty * tp.CostMC)) SumMC
          FROM t_CRRet m WITH(NOLOCK)
          JOIN t_CRRetD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate
          
          UNION ALL
          --26. Продажа товара оператором
          SELECT
           m.CodeID5,m.CodeID1,m.CodeID2,
           DATEPART(YEAR,DocDate) YearID,
           DATEPART(MONTH,DocDate) MonthID,
           SUM(d.Qty * tp.CostMC) SumMC
          FROM t_Sale m WITH(NOLOCK)
          JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
          WHERE m.OurID IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@AOurs,'r_Ours'))
            AND m.CodeID1 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes1,'r_Codes1'))
            AND m.CodeID5 IN (SELECT AValue FROM dbo.af_FilterToTableByTable(@ACodes5,'r_Codes5'))
            AND m.DocDate BETWEEN @ABDate AND @AEDate
          GROUP BY m.CodeID5,m.CodeID2,m.CodeID1,m.DocDate
			) q      --end here
    GROUP BY CodeID5,CodeID1,CodeID2,YearID,MonthID
    ORDER BY CodeID5,CodeID1,CodeID2,YearID,MonthID,SumMC   

--Импорт недостающих строк по месяцам
    DECLARE Cur_1 CURSOR FOR
    SELECT DISTINCT YearID,MonthID
    FROM @Rep6_6
    WHERE MonthID BETWEEN 1 AND 12
    
    OPEN Cur_1
    FETCH NEXT FROM Cur_1 INTO @AYearID,@AMonthID
    WHILE @@FETCH_STATUS = 0
    BEGIN
      DECLARE Cur_2 CURSOR FOR
      SELECT DISTINCT CodeID5,CodeID1,CodeID2
      FROM @Rep6_6 
      
      OPEN Cur_2
      FETCH NEXT FROM Cur_2 INTO @ACodeID5,@ACodeID1,@ACodeID2
      WHILE @@FETCH_STATUS = 0
      BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 
                       FROM @Rep6_6 
                       WHERE CodeID5 = @ACodeID5 
                         AND CodeID1 = @ACodeID1
                         AND YearID = @AYearID 
                         AND MonthID = @AMonthID)
        BEGIN
          INSERT INTO @Rep6_6
          VALUES
          (@ACodeID5,@ACodeID1,@ACodeID2,@AYearID,@AMonthID,0)
        END
        FETCH NEXT FROM Cur_2 INTO @ACodeID5,@ACodeID1,@ACodeID2
      END
      CLOSE Cur_2
      DEALLOCATE Cur_2
      
      FETCH NEXT FROM Cur_1 INTO @AYearID,@AMonthID
    END
    CLOSE Cur_1
    DEALLOCATE Cur_1   
         
--Вычисление итоговых сумм 
    SELECT @AYearID = MIN(YearID) 
    FROM @Rep6_6
    
    SET @ATotalText = 'Итого '+CAST(@AYearID AS VARCHAR(4))+'-'+CAST((@AYearID + 1) AS VARCHAR(4))+' фин. год.'
    
    INSERT INTO @Rep6_6
    SELECT
     CodeID5,CodeID1, CodeID2,(@AYearID + 1) YearID,13 MonthID,SUM(SumMC) SumMC
    FROM @Rep6_6
    GROUP BY CodeID5,CodeID1,CodeID2
 
IF @Head = 0
BEGIN
SELECT	
     null, null,null,              
                CASE WHEN MonthID = 13 OR MonthID = 5  THEN (CASE WHEN MonthID = 5 THEN (dbo.af_GetMonthNameByMonth(MonthID)+ CAST(YearID AS VARCHAR(10))) ELSE @ATotalText END)
                ELSE (dbo.af_GetMonthNameByMonth(MonthID)+ ' ' + CAST(YearID AS VARCHAR(10))) END MName,
                null
    FROM @Rep6_6 t6
    ORDER BY MonthID
END
ELSE
BEGIN
    SELECT	
     rc5.Notes CodeNotes5, rc1.CodeName1,rc2.CodeName2,              
                CASE WHEN MonthID = 13 THEN @ATotalText ELSE (dbo.af_GetMonthNameByMonth(MonthID)+ ' ' + CAST(YearID AS VARCHAR(10))) END MName,
                SUM(SumMC) SumMC
    FROM @Rep6_6 t6
    JOIN r_Codes5 rc5 WITH(NOLOCK) ON rc5.CodeID5 = t6.CodeID5
    JOIN r_Codes1 rc1 WITH(NOLOCK) ON rc1.CodeID1 = t6.CodeID1
    JOIN r_Codes2 rc2 WITH(NOLOCK) ON rc2.CodeID2 = t6.CodeID2
    WHERE SumMC != 0
    GROUP BY rc5.Notes,rc1.CodeName1,rc2.CodeName2,MonthID,YearID--, rc5.CodeName5
    ORDER BY CodeNotes5,CodeName1,CodeName2,YearID,MonthID              
END
--SELECT [CodeName1], [CodeName2], [GMSSourceGroup], SUM([SumMC]) AS [SumMC] FROM [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov]
--WHERE [CodeName2] = 'Бытовая техника/амортизация/'
--GROUP BY [CodeName1], [CodeName2], [GMSSourceGroup]       
/*

SELECT * FROM r_ProdG1 WHERE StorageAreas = 'Комплекс-Бар'
SELECT * FROM r_Codes2



Drop Main [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov]
if exists(select 1 from [AzTempDB]..sysobjects where xtype = 'u' and name = 'v_038_00979_1_CONST\maslov') drop table [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov]
Create [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov]
CREATE TABLE [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([GMSSourceName] varchar(255), [DocDate] smalldatetime, [OurID] int, [OurName] varchar(255), [CodeID1] smallint, [CodeName1] varchar(255), [CodeID2] smallint, [Notes1] varchar(255), [CodeName2] varchar(255), [Notes2] varchar(255), [CodeID3] smallint, [CodeName3] varchar(255), [Notes3] varchar(255), [CodeID4] smallint, [CodeName4] varchar(255), [Notes4] varchar(255), [CodeID5] smallint, [CodeName5] varchar(255), [Notes5] varchar(255), [DDepID] smallint, [DDepName] varchar(255), [GMSSourceGroup] varchar(255), [SumCC] numeric(21, 9), [SumMC] numeric(21, 9), [SumMC_K] numeric(21, 9), [SumCurrDif] numeric(21, 9))


>>> Расход (План) - Приход товара:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) 
SELECT t_Rec_1.DocDate, t_Rec_1.OurID, r_Ours_22.OurName, t_Rec_1.CodeID1, r_Codes1_42.CodeName1, t_Rec_1.CodeID2, r_Codes1_42.Notes Notes1, r_Codes2_52.CodeName2, r_Codes2_52.Notes Notes2, t_Rec_1.CodeID3, r_Codes3_62.CodeName3, r_Codes3_62.Notes Notes3, t_Rec_1.CodeID4, r_Codes4_72.CodeName4, r_Codes4_72.Notes Notes4, t_Rec_1.CodeID5, r_Codes5_82.CodeName5, r_Codes5_82.Notes Notes5, t_Rec_1.DepID, r_Deps_264.DepName, ' Расход (План)', SUM(0-(t_RecD_145.Qty * t_PInP_146.CostCC)) SumCC, SUM(0-(t_RecD_145.Qty * t_PInP_146.CostMC)) SumMC, SUM(0-((t_RecD_145.Qty * t_PInP_146.CostCC) / 9)) SumMC_K, SUM(0-(t_RecD_145.Qty * ((t_PInP_146.CostCC / 9) - t_PInP_146.CostMC))) SumCurrDif FROM av_t_Rec t_Rec_1 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_42 WITH(NOLOCK) ON (r_Codes1_42.CodeID1=t_Rec_1.CodeID1)
JOIN r_Codes2 r_Codes2_52 WITH(NOLOCK) ON (r_Codes2_52.CodeID2=t_Rec_1.CodeID2)
JOIN r_Codes3 r_Codes3_62 WITH(NOLOCK) ON (r_Codes3_62.CodeID3=t_Rec_1.CodeID3)
JOIN r_Codes4 r_Codes4_72 WITH(NOLOCK) ON (r_Codes4_72.CodeID4=t_Rec_1.CodeID4)
JOIN r_Codes5 r_Codes5_82 WITH(NOLOCK) ON (r_Codes5_82.CodeID5=t_Rec_1.CodeID5)
JOIN r_Deps r_Deps_264 WITH(NOLOCK) ON (r_Deps_264.DepID=t_Rec_1.DepID)
JOIN r_Ours r_Ours_22 WITH(NOLOCK) ON (r_Ours_22.OurID=t_Rec_1.OurID)
JOIN r_Stocks r_Stocks_199 WITH(NOLOCK) ON (r_Stocks_199.StockID=t_Rec_1.StockID)
JOIN av_t_RecD t_RecD_145 WITH(NOLOCK) ON (t_RecD_145.ChID=t_Rec_1.ChID)
JOIN t_PInP t_PInP_146 WITH(NOLOCK) ON (t_PInP_146.PPID=t_RecD_145.PPID AND t_PInP_146.ProdID=t_RecD_145.ProdID)
JOIN r_Deps r_Deps_224 WITH(NOLOCK) ON (r_Deps_224.DepID=r_Stocks_199.DepID)
  WHERE  ((t_Rec_1.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Rec_1.CodeID5 BETWEEN 2056 AND 2062) OR (t_Rec_1.CodeID5 = 2067)) AND ((t_Rec_1.OurID BETWEEN 1 AND 6) OR (t_Rec_1.OurID = 11)) AND (t_Rec_1.DocDate BETWEEN '20180401' AND '20180430') AND (t_Rec_1.OurID IN (14,15,16)) GROUP BY t_Rec_1.DocDate, t_Rec_1.OurID, r_Ours_22.OurName, t_Rec_1.CodeID1, r_Codes1_42.CodeName1, t_Rec_1.CodeID2, r_Codes1_42.Notes, r_Codes2_52.CodeName2, r_Codes2_52.Notes, t_Rec_1.CodeID3, r_Codes3_62.CodeName3, r_Codes3_62.Notes, t_Rec_1.CodeID4, r_Codes4_72.CodeName4, r_Codes4_72.Notes, t_Rec_1.CodeID5, r_Codes5_82.CodeName5, r_Codes5_82.Notes, t_Rec_1.DepID, r_Deps_264.DepName


>>> Расход (План) - Возврат товара от получателя:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_Ret_2.DocDate, t_Ret_2.OurID, r_Ours_23.OurName, t_Ret_2.CodeID1, r_Codes1_43.CodeName1, t_Ret_2.CodeID2, r_Codes1_43.Notes Notes1, r_Codes2_53.CodeName2, r_Codes2_53.Notes Notes2, t_Ret_2.CodeID3, r_Codes3_63.CodeName3, r_Codes3_63.Notes Notes3, t_Ret_2.CodeID4, r_Codes4_73.CodeName4, r_Codes4_73.Notes Notes4, t_Ret_2.CodeID5, r_Codes5_83.CodeName5, r_Codes5_83.Notes Notes5, t_Ret_2.DepID, r_Deps_267.DepName, ' Расход (План)', SUM(0-(t_RetD_141.Qty * t_PInP_142.CostCC)) SumCC, SUM(0-(t_RetD_141.Qty * t_PInP_142.CostMC)) SumMC, SUM(0-((t_RetD_141.Qty * t_PInP_142.CostCC) / 9)) SumMC_K, SUM(0-(t_RetD_141.Qty * ((t_PInP_142.CostCC / 9) - (t_PInP_142.CostMC)))) SumCurrDif FROM av_t_Ret t_Ret_2 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_43 WITH(NOLOCK) ON (r_Codes1_43.CodeID1=t_Ret_2.CodeID1)
JOIN r_Codes2 r_Codes2_53 WITH(NOLOCK) ON (r_Codes2_53.CodeID2=t_Ret_2.CodeID2)
JOIN r_Codes3 r_Codes3_63 WITH(NOLOCK) ON (r_Codes3_63.CodeID3=t_Ret_2.CodeID3)
JOIN r_Codes4 r_Codes4_73 WITH(NOLOCK) ON (r_Codes4_73.CodeID4=t_Ret_2.CodeID4)
JOIN r_Codes5 r_Codes5_83 WITH(NOLOCK) ON (r_Codes5_83.CodeID5=t_Ret_2.CodeID5)
JOIN r_Deps r_Deps_267 WITH(NOLOCK) ON (r_Deps_267.DepID=t_Ret_2.DepID)
JOIN r_Ours r_Ours_23 WITH(NOLOCK) ON (r_Ours_23.OurID=t_Ret_2.OurID)
JOIN r_Stocks r_Stocks_195 WITH(NOLOCK) ON (r_Stocks_195.StockID=t_Ret_2.StockID)
JOIN av_t_RetD t_RetD_141 WITH(NOLOCK) ON (t_RetD_141.ChID=t_Ret_2.ChID)
JOIN t_PInP t_PInP_142 WITH(NOLOCK) ON (t_PInP_142.PPID=t_RetD_141.PPID AND t_PInP_142.ProdID=t_RetD_141.ProdID)
JOIN r_Deps r_Deps_225 WITH(NOLOCK) ON (r_Deps_225.DepID=r_Stocks_195.DepID)
  WHERE  ((t_Ret_2.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Ret_2.CodeID5 BETWEEN 2056 AND 2062) OR (t_Ret_2.CodeID5 = 2067)) AND ((t_Ret_2.OurID BETWEEN 1 AND 6) OR (t_Ret_2.OurID = 11)) AND (t_Ret_2.DocDate BETWEEN '20180401' AND '20180430') AND (t_Ret_2.OurID IN (14,15,16)) GROUP BY t_Ret_2.DocDate, t_Ret_2.OurID, r_Ours_23.OurName, t_Ret_2.CodeID1, r_Codes1_43.CodeName1, t_Ret_2.CodeID2, r_Codes1_43.Notes, r_Codes2_53.CodeName2, r_Codes2_53.Notes, t_Ret_2.CodeID3, r_Codes3_63.CodeName3, r_Codes3_63.Notes, t_Ret_2.CodeID4, r_Codes4_73.CodeName4, r_Codes4_73.Notes, t_Ret_2.CodeID5, r_Codes5_83.CodeName5, r_Codes5_83.Notes, t_Ret_2.DepID, r_Deps_267.DepName


>>> Расход (План) - Возврат товара поставщику:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_CRet_3.DocDate, t_CRet_3.OurID, r_Ours_24.OurName, t_CRet_3.CodeID1, r_Codes1_44.CodeName1, t_CRet_3.CodeID2, r_Codes1_44.Notes Notes1, r_Codes2_54.CodeName2, r_Codes2_54.Notes Notes2, t_CRet_3.CodeID3, r_Codes3_64.CodeName3, r_Codes3_64.Notes Notes3, t_CRet_3.CodeID4, r_Codes4_74.CodeName4, r_Codes4_74.Notes Notes4, t_CRet_3.CodeID5, r_Codes5_84.CodeName5, r_Codes5_84.Notes Notes5, 0, ' ', ' Расход (План)', SUM(t_CRetD_143.Qty * t_PInP_144.CostCC) SumCC, SUM(t_CRetD_143.Qty * t_PInP_144.CostMC) SumMC, SUM((t_CRetD_143.Qty * t_PInP_144.CostCC) / 9) SumMC_K, SUM(t_CRetD_143.Qty * ((t_PInP_144.CostCC / 9) - t_PInP_144.CostMC)) SumCurrDif FROM av_t_CRet t_CRet_3 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_44 WITH(NOLOCK) ON (r_Codes1_44.CodeID1=t_CRet_3.CodeID1)
JOIN r_Codes2 r_Codes2_54 WITH(NOLOCK) ON (r_Codes2_54.CodeID2=t_CRet_3.CodeID2)
JOIN r_Codes3 r_Codes3_64 WITH(NOLOCK) ON (r_Codes3_64.CodeID3=t_CRet_3.CodeID3)
JOIN r_Codes4 r_Codes4_74 WITH(NOLOCK) ON (r_Codes4_74.CodeID4=t_CRet_3.CodeID4)
JOIN r_Codes5 r_Codes5_84 WITH(NOLOCK) ON (r_Codes5_84.CodeID5=t_CRet_3.CodeID5)
JOIN r_Ours r_Ours_24 WITH(NOLOCK) ON (r_Ours_24.OurID=t_CRet_3.OurID)
JOIN r_Stocks r_Stocks_196 WITH(NOLOCK) ON (r_Stocks_196.StockID=t_CRet_3.StockID)
JOIN av_t_CRetD t_CRetD_143 WITH(NOLOCK) ON (t_CRetD_143.ChID=t_CRet_3.ChID)
JOIN t_PInP t_PInP_144 WITH(NOLOCK) ON (t_PInP_144.PPID=t_CRetD_143.PPID AND t_PInP_144.ProdID=t_CRetD_143.ProdID)
JOIN r_Deps r_Deps_226 WITH(NOLOCK) ON (r_Deps_226.DepID=r_Stocks_196.DepID)
  WHERE  ((t_CRet_3.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_CRet_3.CodeID5 BETWEEN 2056 AND 2062) OR (t_CRet_3.CodeID5 = 2067)) AND ((t_CRet_3.OurID BETWEEN 1 AND 6) OR (t_CRet_3.OurID = 11)) AND (t_CRet_3.DocDate BETWEEN '20180401' AND '20180430') AND (t_CRet_3.OurID IN (14,15,16)) GROUP BY t_CRet_3.DocDate, t_CRet_3.OurID, r_Ours_24.OurName, t_CRet_3.CodeID1, r_Codes1_44.CodeName1, t_CRet_3.CodeID2, r_Codes1_44.Notes, r_Codes2_54.CodeName2, r_Codes2_54.Notes, t_CRet_3.CodeID3, r_Codes3_64.CodeName3, r_Codes3_64.Notes, t_CRet_3.CodeID4, r_Codes4_74.CodeName4, r_Codes4_74.Notes, t_CRet_3.CodeID5, r_Codes5_84.CodeName5, r_Codes5_84.Notes


>>> Расход (План) - Расходная накладная:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_Inv_4.DocDate, t_Inv_4.OurID, r_Ours_25.OurName, t_Inv_4.CodeID1, r_Codes1_45.CodeName1, t_Inv_4.CodeID2, r_Codes1_45.Notes Notes1, r_Codes2_55.CodeName2, r_Codes2_55.Notes Notes2, t_Inv_4.CodeID3, r_Codes3_65.CodeName3, r_Codes3_65.Notes Notes3, t_Inv_4.CodeID4, r_Codes4_75.CodeName4, r_Codes4_75.Notes Notes4, t_Inv_4.CodeID5, r_Codes5_85.CodeName5, r_Codes5_85.Notes Notes5, t_Inv_4.DepID, r_Deps_297.DepName, ' Расход (План)', SUM(t_InvD_147.Qty * t_PInP_148.CostCC) SumCC, SUM(t_InvD_147.Qty * t_PInP_148.CostMC) SumMC, SUM((t_InvD_147.Qty * t_PInP_148.CostCC) / 9) SumMC_K, SUM(t_InvD_147.Qty * ((t_PInP_148.CostCC / 9) - t_PInP_148.CostMC)) SumCurrDif FROM av_t_Inv t_Inv_4 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_45 WITH(NOLOCK) ON (r_Codes1_45.CodeID1=t_Inv_4.CodeID1)
JOIN r_Codes2 r_Codes2_55 WITH(NOLOCK) ON (r_Codes2_55.CodeID2=t_Inv_4.CodeID2)
JOIN r_Codes3 r_Codes3_65 WITH(NOLOCK) ON (r_Codes3_65.CodeID3=t_Inv_4.CodeID3)
JOIN r_Codes4 r_Codes4_75 WITH(NOLOCK) ON (r_Codes4_75.CodeID4=t_Inv_4.CodeID4)
JOIN r_Codes5 r_Codes5_85 WITH(NOLOCK) ON (r_Codes5_85.CodeID5=t_Inv_4.CodeID5)
JOIN r_Deps r_Deps_297 WITH(NOLOCK) ON (r_Deps_297.DepID=t_Inv_4.DepID)
JOIN r_Ours r_Ours_25 WITH(NOLOCK) ON (r_Ours_25.OurID=t_Inv_4.OurID)
JOIN r_Stocks r_Stocks_201 WITH(NOLOCK) ON (r_Stocks_201.StockID=t_Inv_4.StockID)
JOIN av_t_InvD t_InvD_147 WITH(NOLOCK) ON (t_InvD_147.ChID=t_Inv_4.ChID)
JOIN t_PInP t_PInP_148 WITH(NOLOCK) ON (t_PInP_148.PPID=t_InvD_147.PPID AND t_PInP_148.ProdID=t_InvD_147.ProdID)
JOIN r_Deps r_Deps_227 WITH(NOLOCK) ON (r_Deps_227.DepID=r_Stocks_201.DepID)
  WHERE  ((t_Inv_4.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Inv_4.CodeID5 BETWEEN 2056 AND 2062) OR (t_Inv_4.CodeID5 = 2067)) AND ((t_Inv_4.OurID BETWEEN 1 AND 6) OR (t_Inv_4.OurID = 11)) AND (t_Inv_4.DocDate BETWEEN '20180401' AND '20180430') AND (t_Inv_4.OurID IN (14,15,16)) GROUP BY t_Inv_4.DocDate, t_Inv_4.OurID, r_Ours_25.OurName, t_Inv_4.CodeID1, r_Codes1_45.CodeName1, t_Inv_4.CodeID2, r_Codes1_45.Notes, r_Codes2_55.CodeName2, r_Codes2_55.Notes, t_Inv_4.CodeID3, r_Codes3_65.CodeName3, r_Codes3_65.Notes, t_Inv_4.CodeID4, r_Codes4_75.CodeName4, r_Codes4_75.Notes, t_Inv_4.CodeID5, r_Codes5_85.CodeName5, r_Codes5_85.Notes, t_Inv_4.DepID, r_Deps_297.DepName


>>> Расход (План) - Расходный документ:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_Exp_5.DocDate, t_Exp_5.OurID, r_Ours_26.OurName, t_Exp_5.CodeID1, r_Codes1_46.CodeName1, t_Exp_5.CodeID2, r_Codes1_46.Notes Notes1, r_Codes2_56.CodeName2, r_Codes2_56.Notes Notes2, t_Exp_5.CodeID3, r_Codes3_66.CodeName3, r_Codes3_66.Notes Notes3, t_Exp_5.CodeID4, r_Codes4_76.CodeName4, r_Codes4_76.Notes Notes4, t_Exp_5.CodeID5, r_Codes5_86.CodeName5, r_Codes5_86.Notes Notes5, t_Exp_5.DepID, r_Deps_320.DepName, ' Расход (План)', SUM(t_ExpD_149.Qty * t_PInP_150.CostCC) SumCC, SUM(t_ExpD_149.Qty * t_PInP_150.CostMC) SumMC, SUM((t_ExpD_149.Qty * t_PInP_150.CostCC) / 9) SumMC_K, SUM(t_ExpD_149.Qty * ((t_PInP_150.CostCC / 9) - t_PInP_150.CostMC)) SumCurrDif FROM av_t_Exp t_Exp_5 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_46 WITH(NOLOCK) ON (r_Codes1_46.CodeID1=t_Exp_5.CodeID1)
JOIN r_Codes2 r_Codes2_56 WITH(NOLOCK) ON (r_Codes2_56.CodeID2=t_Exp_5.CodeID2)
JOIN r_Codes3 r_Codes3_66 WITH(NOLOCK) ON (r_Codes3_66.CodeID3=t_Exp_5.CodeID3)
JOIN r_Codes4 r_Codes4_76 WITH(NOLOCK) ON (r_Codes4_76.CodeID4=t_Exp_5.CodeID4)
JOIN r_Codes5 r_Codes5_86 WITH(NOLOCK) ON (r_Codes5_86.CodeID5=t_Exp_5.CodeID5)
JOIN r_Deps r_Deps_320 WITH(NOLOCK) ON (r_Deps_320.DepID=t_Exp_5.DepID)
JOIN r_Ours r_Ours_26 WITH(NOLOCK) ON (r_Ours_26.OurID=t_Exp_5.OurID)
JOIN r_Stocks r_Stocks_202 WITH(NOLOCK) ON (r_Stocks_202.StockID=t_Exp_5.StockID)
JOIN av_t_ExpD t_ExpD_149 WITH(NOLOCK) ON (t_ExpD_149.ChID=t_Exp_5.ChID)
JOIN t_PInP t_PInP_150 WITH(NOLOCK) ON (t_PInP_150.PPID=t_ExpD_149.PPID AND t_PInP_150.ProdID=t_ExpD_149.ProdID)
JOIN r_Deps r_Deps_228 WITH(NOLOCK) ON (r_Deps_228.DepID=r_Stocks_202.DepID)
  WHERE  ((t_Exp_5.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Exp_5.CodeID5 BETWEEN 2056 AND 2062) OR (t_Exp_5.CodeID5 = 2067)) AND ((t_Exp_5.OurID BETWEEN 1 AND 6) OR (t_Exp_5.OurID = 11)) AND (t_Exp_5.DocDate BETWEEN '20180401' AND '20180430') AND (t_Exp_5.OurID IN (14,15,16)) GROUP BY t_Exp_5.DocDate, t_Exp_5.OurID, r_Ours_26.OurName, t_Exp_5.CodeID1, r_Codes1_46.CodeName1, t_Exp_5.CodeID2, r_Codes1_46.Notes, r_Codes2_56.CodeName2, r_Codes2_56.Notes, t_Exp_5.CodeID3, r_Codes3_66.CodeName3, r_Codes3_66.Notes, t_Exp_5.CodeID4, r_Codes4_76.CodeName4, r_Codes4_76.Notes, t_Exp_5.CodeID5, r_Codes5_86.CodeName5, r_Codes5_86.Notes, t_Exp_5.DepID, r_Deps_320.DepName


>>> Расход (План) - Расходный документ в ценах прихода:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_Epp_6.DocDate, t_Epp_6.OurID, r_Ours_27.OurName, t_Epp_6.CodeID1, r_Codes1_47.CodeName1, t_Epp_6.CodeID2, r_Codes1_47.Notes Notes1, r_Codes2_57.CodeName2, r_Codes2_57.Notes Notes2, t_Epp_6.CodeID3, r_Codes3_67.CodeName3, r_Codes3_67.Notes Notes3, t_Epp_6.CodeID4, r_Codes4_77.CodeName4, r_Codes4_77.Notes Notes4, t_Epp_6.CodeID5, r_Codes5_87.CodeName5, r_Codes5_87.Notes Notes5, t_Epp_6.DepID, r_Deps_325.DepName, ' Расход (План)', SUM(t_EppD_151.Qty * t_PInP_152.CostCC) SumCC, SUM(t_EppD_151.Qty * t_PInP_152.CostMC) SumMC, SUM((t_EppD_151.Qty * t_PInP_152.CostCC) / 9) SumMC_K, SUM(t_EppD_151.Qty * ((t_PInP_152.CostCC / 9) - t_PInP_152.CostMC)) SumCurrDif FROM av_t_Epp t_Epp_6 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_47 WITH(NOLOCK) ON (r_Codes1_47.CodeID1=t_Epp_6.CodeID1)
JOIN r_Codes2 r_Codes2_57 WITH(NOLOCK) ON (r_Codes2_57.CodeID2=t_Epp_6.CodeID2)
JOIN r_Codes3 r_Codes3_67 WITH(NOLOCK) ON (r_Codes3_67.CodeID3=t_Epp_6.CodeID3)
JOIN r_Codes4 r_Codes4_77 WITH(NOLOCK) ON (r_Codes4_77.CodeID4=t_Epp_6.CodeID4)
JOIN r_Codes5 r_Codes5_87 WITH(NOLOCK) ON (r_Codes5_87.CodeID5=t_Epp_6.CodeID5)
JOIN r_Deps r_Deps_325 WITH(NOLOCK) ON (r_Deps_325.DepID=t_Epp_6.DepID)
JOIN r_Ours r_Ours_27 WITH(NOLOCK) ON (r_Ours_27.OurID=t_Epp_6.OurID)
JOIN r_Stocks r_Stocks_203 WITH(NOLOCK) ON (r_Stocks_203.StockID=t_Epp_6.StockID)
JOIN av_t_EppD t_EppD_151 WITH(NOLOCK) ON (t_EppD_151.ChID=t_Epp_6.ChID)
JOIN t_PInP t_PInP_152 WITH(NOLOCK) ON (t_PInP_152.PPID=t_EppD_151.PPID AND t_PInP_152.ProdID=t_EppD_151.ProdID)
JOIN r_Deps r_Deps_229 WITH(NOLOCK) ON (r_Deps_229.DepID=r_Stocks_203.DepID)
  WHERE  ((t_Epp_6.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Epp_6.CodeID5 BETWEEN 2056 AND 2062) OR (t_Epp_6.CodeID5 = 2067)) AND ((t_Epp_6.OurID BETWEEN 1 AND 6) OR (t_Epp_6.OurID = 11)) AND (t_Epp_6.DocDate BETWEEN '20180401' AND '20180430') AND (t_Epp_6.OurID IN (14,15,16)) GROUP BY t_Epp_6.DocDate, t_Epp_6.OurID, r_Ours_27.OurName, t_Epp_6.CodeID1, r_Codes1_47.CodeName1, t_Epp_6.CodeID2, r_Codes1_47.Notes, r_Codes2_57.CodeName2, r_Codes2_57.Notes, t_Epp_6.CodeID3, r_Codes3_67.CodeName3, r_Codes3_67.Notes, t_Epp_6.CodeID4, r_Codes4_77.CodeName4, r_Codes4_77.Notes, t_Epp_6.CodeID5, r_Codes5_87.CodeName5, r_Codes5_87.Notes, t_Epp_6.DepID, r_Deps_325.DepName


>>> Расход (План) - Переоценка цен прихода (Приход):
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_Est_7.DocDate, t_Est_7.OurID, r_Ours_29.OurName, r_Codes1_183.CodeID1, r_Codes1_183.CodeName1, r_Codes2_184.CodeID2, r_Codes1_183.Notes Notes1, r_Codes2_184.CodeName2, r_Codes2_184.Notes Notes2, t_Est_7.CodeID3, r_Codes3_69.CodeName3, r_Codes3_69.Notes Notes3, r_Codes4_193.CodeID4, r_Codes4_193.CodeName4, r_Codes4_193.Notes Notes4, r_Codes5_185.CodeID5, r_Codes5_185.CodeName5, r_Codes5_185.Notes Notes5, r_Deps_230.DepID, r_Deps_230.DepName, ' Расход (План)', SUM(0-(t_EstD_153.Qty * t_PInP_154.CostCC)) SumCC, SUM(0-(t_EstD_153.Qty * t_PInP_154.CostMC)) SumMC, SUM(0-((t_EstD_153.Qty * t_PInP_154.CostCC) / 9)) SumMC_K, SUM(0-(t_EstD_153.Qty * ((t_PInP_154.CostCC / 9) - t_PInP_154.CostMC))) SumCurrDif FROM av_t_Est t_Est_7 WITH(NOLOCK)
JOIN r_Codes3 r_Codes3_69 WITH(NOLOCK) ON (r_Codes3_69.CodeID3=t_Est_7.CodeID3)
JOIN r_Ours r_Ours_29 WITH(NOLOCK) ON (r_Ours_29.OurID=t_Est_7.OurID)
JOIN r_Stocks r_Stocks_189 WITH(NOLOCK) ON (r_Stocks_189.StockID=t_Est_7.StockID)
JOIN av_t_EstD t_EstD_153 WITH(NOLOCK) ON (t_EstD_153.ChID=t_Est_7.ChID)
JOIN t_PInP t_PInP_154 WITH(NOLOCK) ON (t_PInP_154.PPID=t_EstD_153.NewPPID AND t_PInP_154.ProdID=t_EstD_153.ProdID)
JOIN r_Prods r_Prods_168 WITH(NOLOCK) ON (r_Prods_168.ProdID=t_PInP_154.ProdID)
JOIN r_ProdC r_ProdC_180 WITH(NOLOCK) ON (r_ProdC_180.PCatID=r_Prods_168.PCatID)
JOIN r_ProdG r_ProdG_181 WITH(NOLOCK) ON (r_ProdG_181.PGrID=r_Prods_168.PGrID)
JOIN r_ProdG1 r_ProdG1_182 WITH(NOLOCK) ON (r_ProdG1_182.PGrID1=r_Prods_168.PGrID1)
JOIN r_Codes5 r_Codes5_185 WITH(NOLOCK) ON (r_Codes5_185.CodeID5=r_ProdG1_182.CodeID5)
JOIN r_Codes2 r_Codes2_184 WITH(NOLOCK) ON (r_Codes2_184.CodeID2=r_ProdG_181.CodeID2)
JOIN r_Codes1 r_Codes1_183 WITH(NOLOCK) ON (r_Codes1_183.CodeID1=r_ProdC_180.CodeID1)
JOIN r_Deps r_Deps_230 WITH(NOLOCK) ON (r_Deps_230.DepID=r_Stocks_189.DepID)
JOIN r_StockGs r_StockGs_190 WITH(NOLOCK) ON (r_StockGs_190.StockGID=r_Stocks_189.StockGID)
JOIN r_Codes4 r_Codes4_193 WITH(NOLOCK) ON (r_Codes4_193.CodeID4=r_StockGs_190.StockGID)
  WHERE  ((r_Codes1_183.CodeID1 BETWEEN 2000 AND 3000)) AND ((r_Codes5_185.CodeID5 BETWEEN 2056 AND 2062) OR (r_Codes5_185.CodeID5 = 2067)) AND ((t_Est_7.OurID BETWEEN 1 AND 6) OR (t_Est_7.OurID = 11)) AND (t_Est_7.DocDate BETWEEN '20180401' AND '20180430') AND ((t_Est_7.OurID IN (14,15,16) AND (r_Prods_168.PCatID BETWEEN 600 AND 699) AND ((r_Prods_168.PGrID BETWEEN 9100 AND 9999) OR (r_Prods_168.PGrID BETWEEN 16000 AND 17000)))) GROUP BY t_Est_7.DocDate, t_Est_7.OurID, r_Ours_29.OurName, r_Codes1_183.CodeID1, r_Codes1_183.CodeName1, r_Codes2_184.CodeID2, r_Codes1_183.Notes, r_Codes2_184.CodeName2, r_Codes2_184.Notes, t_Est_7.CodeID3, r_Codes3_69.CodeName3, r_Codes3_69.Notes, r_Codes4_193.CodeID4, r_Codes4_193.CodeName4, r_Codes4_193.Notes, r_Codes5_185.CodeID5, r_Codes5_185.CodeName5, r_Codes5_185.Notes, r_Deps_230.DepID, r_Deps_230.DepName


>>> Расход (План) - Приход денег по предприятиям:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT c_CompRec_9.DocDate, c_CompRec_9.OurID, r_Ours_30.OurName, c_CompRec_9.CodeID1, r_Codes1_50.CodeName1, c_CompRec_9.CodeID2, r_Codes1_50.Notes Notes1, r_Codes2_60.CodeName2, r_Codes2_60.Notes Notes2, c_CompRec_9.CodeID3, r_Codes3_70.CodeName3, r_Codes3_70.Notes Notes3, c_CompRec_9.CodeID4, r_Codes4_80.CodeName4, r_Codes4_80.Notes Notes4, c_CompRec_9.CodeID5, r_Codes5_90.CodeName5, r_Codes5_90.Notes Notes5, c_CompRec_9.DepID, r_Deps_344.DepName, ' Расход (План)', SUM(0-(c_CompRec_9.SumAC * c_CompRec_9.KursCC)) SumCC, SUM(0-(c_CompRec_9.SumAC / c_CompRec_9.KursMC)) SumMC, SUM(0-((c_CompRec_9.SumAC * c_CompRec_9.KursCC) / 9)) SumMC_K, SUM(0-(((c_CompRec_9.SumAC * c_CompRec_9.KursCC) / c_CompRec_9.KursMC) - (c_CompRec_9.SumAC / c_CompRec_9.KursMC))) SumCurrDif FROM av_c_CompRec c_CompRec_9 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_50 WITH(NOLOCK) ON (r_Codes1_50.CodeID1=c_CompRec_9.CodeID1)
JOIN r_Codes2 r_Codes2_60 WITH(NOLOCK) ON (r_Codes2_60.CodeID2=c_CompRec_9.CodeID2)
JOIN r_Codes3 r_Codes3_70 WITH(NOLOCK) ON (r_Codes3_70.CodeID3=c_CompRec_9.CodeID3)
JOIN r_Codes4 r_Codes4_80 WITH(NOLOCK) ON (r_Codes4_80.CodeID4=c_CompRec_9.CodeID4)
JOIN r_Codes5 r_Codes5_90 WITH(NOLOCK) ON (r_Codes5_90.CodeID5=c_CompRec_9.CodeID5)
JOIN r_Deps r_Deps_344 WITH(NOLOCK) ON (r_Deps_344.DepID=c_CompRec_9.DepID)
JOIN r_Ours r_Ours_30 WITH(NOLOCK) ON (r_Ours_30.OurID=c_CompRec_9.OurID)
JOIN r_Stocks r_Stocks_198 WITH(NOLOCK) ON (r_Stocks_198.StockID=c_CompRec_9.StockID)
JOIN r_Deps r_Deps_231 WITH(NOLOCK) ON (r_Deps_231.DepID=r_Stocks_198.DepID)
  WHERE  ((c_CompRec_9.CodeID1 BETWEEN 2000 AND 3000)) AND ((c_CompRec_9.CodeID5 BETWEEN 2056 AND 2062) OR (c_CompRec_9.CodeID5 = 2067)) AND ((c_CompRec_9.OurID BETWEEN 1 AND 6) OR (c_CompRec_9.OurID = 11)) AND (c_CompRec_9.DocDate BETWEEN '20180401' AND '20180430') AND (c_CompRec_9.OurID IN  (14,15,16)) GROUP BY c_CompRec_9.DocDate, c_CompRec_9.OurID, r_Ours_30.OurName, c_CompRec_9.CodeID1, r_Codes1_50.CodeName1, c_CompRec_9.CodeID2, r_Codes1_50.Notes, r_Codes2_60.CodeName2, r_Codes2_60.Notes, c_CompRec_9.CodeID3, r_Codes3_70.CodeName3, r_Codes3_70.Notes, c_CompRec_9.CodeID4, r_Codes4_80.CodeName4, r_Codes4_80.Notes, c_CompRec_9.CodeID5, r_Codes5_90.CodeName5, r_Codes5_90.Notes, c_CompRec_9.DepID, r_Deps_344.DepName


>>> Расход (План) - Расход денег по предприятиям:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT c_CompExp_10.DocDate, c_CompExp_10.OurID, r_Ours_31.OurName, c_CompExp_10.CodeID1, r_Codes1_51.CodeName1, c_CompExp_10.CodeID2, r_Codes1_51.Notes Notes1, r_Codes2_61.CodeName2, r_Codes2_61.Notes Notes2, c_CompExp_10.CodeID3, r_Codes3_71.CodeName3, r_Codes3_71.Notes Notes3, c_CompExp_10.CodeID4, r_Codes4_81.CodeName4, r_Codes4_81.Notes Notes4, c_CompExp_10.CodeID5, r_Codes5_91.CodeName5, r_Codes5_91.Notes Notes5, c_CompExp_10.DepID, r_Deps_347.DepName, ' Расход (План)', SUM(c_CompExp_10.SumAC * c_CompExp_10.KursCC) SumCC, SUM(c_CompExp_10.SumAC / c_CompExp_10.KursMC) SumMC, SUM((c_CompExp_10.SumAC * c_CompExp_10.KursCC) / 9) SumMC_K, SUM(((c_CompExp_10.SumAC * c_CompExp_10.KursCC) / 9) - (c_CompExp_10.SumAC / c_CompExp_10.KursMC)) SumCurrDif FROM av_c_CompExp c_CompExp_10 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_51 WITH(NOLOCK) ON (r_Codes1_51.CodeID1=c_CompExp_10.CodeID1)
JOIN r_Codes2 r_Codes2_61 WITH(NOLOCK) ON (r_Codes2_61.CodeID2=c_CompExp_10.CodeID2)
JOIN r_Codes3 r_Codes3_71 WITH(NOLOCK) ON (r_Codes3_71.CodeID3=c_CompExp_10.CodeID3)
JOIN r_Codes4 r_Codes4_81 WITH(NOLOCK) ON (r_Codes4_81.CodeID4=c_CompExp_10.CodeID4)
JOIN r_Codes5 r_Codes5_91 WITH(NOLOCK) ON (r_Codes5_91.CodeID5=c_CompExp_10.CodeID5)
JOIN r_Deps r_Deps_347 WITH(NOLOCK) ON (r_Deps_347.DepID=c_CompExp_10.DepID)
JOIN r_Ours r_Ours_31 WITH(NOLOCK) ON (r_Ours_31.OurID=c_CompExp_10.OurID)
JOIN r_Stocks r_Stocks_200 WITH(NOLOCK) ON (r_Stocks_200.StockID=c_CompExp_10.StockID)
JOIN r_Deps r_Deps_232 WITH(NOLOCK) ON (r_Deps_232.DepID=r_Stocks_200.DepID)
  WHERE  ((c_CompExp_10.CodeID1 BETWEEN 2000 AND 3000)) AND ((c_CompExp_10.CodeID5 BETWEEN 2056 AND 2062) OR (c_CompExp_10.CodeID5 = 2067)) AND ((c_CompExp_10.OurID BETWEEN 1 AND 6) OR (c_CompExp_10.OurID = 11)) AND (c_CompExp_10.DocDate BETWEEN '20180401' AND '20180430') AND (c_CompExp_10.OurID IN (14,15,16)) GROUP BY c_CompExp_10.DocDate, c_CompExp_10.OurID, r_Ours_31.OurName, c_CompExp_10.CodeID1, r_Codes1_51.CodeName1, c_CompExp_10.CodeID2, r_Codes1_51.Notes, r_Codes2_61.CodeName2, r_Codes2_61.Notes, c_CompExp_10.CodeID3, r_Codes3_71.CodeName3, r_Codes3_71.Notes, c_CompExp_10.CodeID4, r_Codes4_81.CodeName4, r_Codes4_81.Notes, c_CompExp_10.CodeID5, r_Codes5_91.CodeName5, r_Codes5_91.Notes, c_CompExp_10.DepID, r_Deps_347.DepName


>>> Расход (План) - Прием наличных денег на склад:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_MonRec_11.DocDate, t_MonRec_11.OurID, r_Ours_28.OurName, t_MonRec_11.CodeID1, r_Codes1_48.CodeName1, t_MonRec_11.CodeID2, r_Codes1_48.Notes Notes1, r_Codes2_58.CodeName2, r_Codes2_58.Notes Notes2, t_MonRec_11.CodeID3, r_Codes3_68.CodeName3, r_Codes3_68.Notes Notes3, t_MonRec_11.CodeID4, r_Codes4_78.CodeName4, r_Codes4_78.Notes Notes4, t_MonRec_11.CodeID5, r_Codes5_88.CodeName5, r_Codes5_88.Notes Notes5, 0, ' ', ' Расход (План)', SUM(0-(t_MonRec_11.SumAC * t_MonRec_11.KursCC)) SumCC, SUM(0-(t_MonRec_11.SumAC / t_MonRec_11.KursMC)) SumMC, SUM(0-((t_MonRec_11.SumAC * t_MonRec_11.KursCC) / 9)) SumMC_K, SUM(0-(((t_MonRec_11.SumAC * t_MonRec_11.KursCC) / 9) - (t_MonRec_11.SumAC / t_MonRec_11.KursMC))) SumCurrDif FROM av_t_MonRec t_MonRec_11 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_48 WITH(NOLOCK) ON (r_Codes1_48.CodeID1=t_MonRec_11.CodeID1)
JOIN r_Codes2 r_Codes2_58 WITH(NOLOCK) ON (r_Codes2_58.CodeID2=t_MonRec_11.CodeID2)
JOIN r_Codes3 r_Codes3_68 WITH(NOLOCK) ON (r_Codes3_68.CodeID3=t_MonRec_11.CodeID3)
JOIN r_Codes4 r_Codes4_78 WITH(NOLOCK) ON (r_Codes4_78.CodeID4=t_MonRec_11.CodeID4)
JOIN r_Codes5 r_Codes5_88 WITH(NOLOCK) ON (r_Codes5_88.CodeID5=t_MonRec_11.CodeID5)
JOIN r_Ours r_Ours_28 WITH(NOLOCK) ON (r_Ours_28.OurID=t_MonRec_11.OurID)
JOIN r_Stocks r_Stocks_197 WITH(NOLOCK) ON (r_Stocks_197.StockID=t_MonRec_11.StockID)
JOIN r_Deps r_Deps_233 WITH(NOLOCK) ON (r_Deps_233.DepID=r_Stocks_197.DepID)
  WHERE  ((t_MonRec_11.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_MonRec_11.CodeID5 BETWEEN 2056 AND 2062) OR (t_MonRec_11.CodeID5 = 2067)) AND ((t_MonRec_11.OurID BETWEEN 1 AND 6) OR (t_MonRec_11.OurID = 11)) AND (t_MonRec_11.DocDate BETWEEN '20180401' AND '20180430') AND (t_MonRec_11.OurID IN (14,15,16)) GROUP BY t_MonRec_11.DocDate, t_MonRec_11.OurID, r_Ours_28.OurName, t_MonRec_11.CodeID1, r_Codes1_48.CodeName1, t_MonRec_11.CodeID2, r_Codes1_48.Notes, r_Codes2_58.CodeName2, r_Codes2_58.Notes, t_MonRec_11.CodeID3, r_Codes3_68.CodeName3, r_Codes3_68.Notes, t_MonRec_11.CodeID4, r_Codes4_78.CodeName4, r_Codes4_78.Notes, t_MonRec_11.CodeID5, r_Codes5_88.CodeName5, r_Codes5_88.Notes


>>> Расход (План) - Переоценка цен прихода (Расход):
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_Est_156.DocDate, t_Est_156.OurID, r_Ours_159.OurName, r_Codes1_186.CodeID1, r_Codes1_186.CodeName1, r_Codes2_187.CodeID2, r_Codes1_186.Notes Notes1, r_Codes2_187.CodeName2, r_Codes2_187.Notes Notes2, t_Est_156.CodeID3, r_Codes3_162.CodeName3, r_Codes3_162.Notes Notes3, r_Codes4_194.CodeID4, r_Codes4_194.CodeName4, r_Codes4_194.Notes Notes4, r_Codes5_188.CodeID5, r_Codes5_188.CodeName5, r_Codes5_188.Notes Notes5, r_Deps_234.DepID, r_Deps_234.DepName, ' Расход (План)', SUM(t_EstD_157.Qty * t_PInP_167.CostCC) SumCC, SUM(t_EstD_157.Qty * t_PInP_167.CostMC) SumMC, SUM((t_EstD_157.Qty * t_PInP_167.CostCC) / 9) SumMC_K, SUM(t_EstD_157.Qty * ((t_PInP_167.CostCC / 9) - t_PInP_167.CostMC)) SumCurrDif FROM av_t_Est t_Est_156 WITH(NOLOCK)
JOIN r_Codes3 r_Codes3_162 WITH(NOLOCK) ON (r_Codes3_162.CodeID3=t_Est_156.CodeID3)
JOIN r_Ours r_Ours_159 WITH(NOLOCK) ON (r_Ours_159.OurID=t_Est_156.OurID)
JOIN r_Stocks r_Stocks_191 WITH(NOLOCK) ON (r_Stocks_191.StockID=t_Est_156.StockID)
JOIN av_t_EstD t_EstD_157 WITH(NOLOCK) ON (t_EstD_157.ChID=t_Est_156.ChID)
JOIN t_PInP t_PInP_167 WITH(NOLOCK) ON (t_PInP_167.PPID=t_EstD_157.PPID AND t_PInP_167.ProdID=t_EstD_157.ProdID)
JOIN r_Prods r_Prods_172 WITH(NOLOCK) ON (r_Prods_172.ProdID=t_PInP_167.ProdID)
JOIN r_ProdC r_ProdC_173 WITH(NOLOCK) ON (r_ProdC_173.PCatID=r_Prods_172.PCatID)
JOIN r_ProdG r_ProdG_174 WITH(NOLOCK) ON (r_ProdG_174.PGrID=r_Prods_172.PGrID)
JOIN r_ProdG1 r_ProdG1_175 WITH(NOLOCK) ON (r_ProdG1_175.PGrID1=r_Prods_172.PGrID1)
JOIN r_Codes5 r_Codes5_188 WITH(NOLOCK) ON (r_Codes5_188.CodeID5=r_ProdG1_175.CodeID5)
JOIN r_Codes2 r_Codes2_187 WITH(NOLOCK) ON (r_Codes2_187.CodeID2=r_ProdG_174.CodeID2)
JOIN r_Codes1 r_Codes1_186 WITH(NOLOCK) ON (r_Codes1_186.CodeID1=r_ProdC_173.CodeID1)
JOIN r_Deps r_Deps_234 WITH(NOLOCK) ON (r_Deps_234.DepID=r_Stocks_191.DepID)
JOIN r_StockGs r_StockGs_192 WITH(NOLOCK) ON (r_StockGs_192.StockGID=r_Stocks_191.StockGID)
JOIN r_Codes4 r_Codes4_194 WITH(NOLOCK) ON (r_Codes4_194.CodeID4=r_StockGs_192.StockGID)
  WHERE  ((r_Codes1_186.CodeID1 BETWEEN 2000 AND 3000)) AND ((r_Codes5_188.CodeID5 BETWEEN 2056 AND 2062) OR (r_Codes5_188.CodeID5 = 2067)) AND ((t_Est_156.OurID BETWEEN 1 AND 6) OR (t_Est_156.OurID = 11)) AND (t_Est_156.DocDate BETWEEN '20180401' AND '20180430') AND ((t_Est_156.OurID IN (14,15,16) AND (r_Prods_172.PCatID BETWEEN 600 AND 699) AND ((r_Prods_172.PGrID BETWEEN 9100 AND 9999) OR (r_Prods_172.PGrID BETWEEN 16000 AND 17000)))) GROUP BY t_Est_156.DocDate, t_Est_156.OurID, r_Ours_159.OurName, r_Codes1_186.CodeID1, r_Codes1_186.CodeName1, r_Codes2_187.CodeID2, r_Codes1_186.Notes, r_Codes2_187.CodeName2, r_Codes2_187.Notes, t_Est_156.CodeID3, r_Codes3_162.CodeName3, r_Codes3_162.Notes, r_Codes4_194.CodeID4, r_Codes4_194.CodeName4, r_Codes4_194.Notes, r_Codes5_188.CodeID5, r_Codes5_188.CodeName5, r_Codes5_188.Notes, r_Deps_234.DepID, r_Deps_234.DepName


>>> Расход (План) - Возврат товара по чеку:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_CRRet_204.DocDate, t_CRRet_204.OurID, r_Ours_208.OurName, t_CRRet_204.CodeID1, r_Codes1_209.CodeName1, t_CRRet_204.CodeID2, r_Codes1_209.Notes Notes1, r_Codes2_210.CodeName2, r_Codes2_210.Notes Notes2, t_CRRet_204.CodeID3, r_Codes3_211.CodeName3, r_Codes3_211.Notes Notes3, t_CRRet_204.CodeID4, r_Codes4_212.CodeName4, r_Codes4_212.Notes Notes4, t_CRRet_204.CodeID5, r_Codes5_213.CodeName5, r_Codes5_213.Notes Notes5, 0, ' ', ' Расход (План)', SUM(0-(t_CRRetD_205.Qty * t_PInP_222.CostCC)) SumCC, SUM(0-(t_CRRetD_205.Qty * t_PInP_222.CostMC)) SumMC, SUM(0-(t_CRRetD_205.Qty * t_PInP_222.CostCC / 9)) SumMC_K, SUM(0-(t_CRRetD_205.Qty * (t_PInP_222.CostCC / 9 - t_PInP_222.CostMC))) SumCurrDif FROM av_t_CRRet t_CRRet_204 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_209 WITH(NOLOCK) ON (r_Codes1_209.CodeID1=t_CRRet_204.CodeID1)
JOIN r_Codes2 r_Codes2_210 WITH(NOLOCK) ON (r_Codes2_210.CodeID2=t_CRRet_204.CodeID2)
JOIN r_Codes3 r_Codes3_211 WITH(NOLOCK) ON (r_Codes3_211.CodeID3=t_CRRet_204.CodeID3)
JOIN r_Codes4 r_Codes4_212 WITH(NOLOCK) ON (r_Codes4_212.CodeID4=t_CRRet_204.CodeID4)
JOIN r_Codes5 r_Codes5_213 WITH(NOLOCK) ON (r_Codes5_213.CodeID5=t_CRRet_204.CodeID5)
JOIN r_Ours r_Ours_208 WITH(NOLOCK) ON (r_Ours_208.OurID=t_CRRet_204.OurID)
JOIN r_Stocks r_Stocks_214 WITH(NOLOCK) ON (r_Stocks_214.StockID=t_CRRet_204.StockID)
JOIN av_t_CRRetD t_CRRetD_205 WITH(NOLOCK) ON (t_CRRetD_205.ChID=t_CRRet_204.ChID)
JOIN t_PInP t_PInP_222 WITH(NOLOCK) ON (t_PInP_222.PPID=t_CRRetD_205.PPID AND t_PInP_222.ProdID=t_CRRetD_205.ProdID)
JOIN r_Deps r_Deps_235 WITH(NOLOCK) ON (r_Deps_235.DepID=r_Stocks_214.DepID)
  WHERE  ((t_CRRet_204.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_CRRet_204.CodeID5 BETWEEN 2056 AND 2062) OR (t_CRRet_204.CodeID5 = 2067)) AND ((t_CRRet_204.OurID BETWEEN 1 AND 6) OR (t_CRRet_204.OurID = 11)) AND (t_CRRet_204.DocDate BETWEEN '20180401' AND '20180430') AND (t_CRRet_204.OurID IN (14,15,16)) GROUP BY t_CRRet_204.DocDate, t_CRRet_204.OurID, r_Ours_208.OurName, t_CRRet_204.CodeID1, r_Codes1_209.CodeName1, t_CRRet_204.CodeID2, r_Codes1_209.Notes, r_Codes2_210.CodeName2, r_Codes2_210.Notes, t_CRRet_204.CodeID3, r_Codes3_211.CodeName3, r_Codes3_211.Notes, t_CRRet_204.CodeID4, r_Codes4_212.CodeName4, r_Codes4_212.Notes, t_CRRet_204.CodeID5, r_Codes5_213.CodeName5, r_Codes5_213.Notes


>>> Расход (План) - Продажа товара оператором:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_Sale_206.DocDate, t_Sale_206.OurID, r_Ours_215.OurName, t_Sale_206.CodeID1, r_Codes1_216.CodeName1, t_Sale_206.CodeID2, r_Codes1_216.Notes Notes1, r_Codes2_217.CodeName2, r_Codes2_217.Notes Notes2, t_Sale_206.CodeID3, r_Codes3_218.CodeName3, r_Codes3_218.Notes Notes3, t_Sale_206.CodeID4, r_Codes4_219.CodeName4, r_Codes4_219.Notes Notes4, t_Sale_206.CodeID5, r_Codes5_220.CodeName5, r_Codes5_220.Notes Notes5, 0, ' ', ' Расход (План)', SUM(t_SaleD_207.Qty * t_PInP_223.CostCC) SumCC, SUM(t_SaleD_207.Qty * t_PInP_223.CostMC) SumMC, SUM(t_SaleD_207.Qty * t_PInP_223.CostCC / 9) SumMC_K, SUM(t_SaleD_207.Qty * (t_PInP_223.CostCC / 9 - t_PInP_223.CostMC)) SumCurrDif FROM av_t_Sale t_Sale_206 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_216 WITH(NOLOCK) ON (r_Codes1_216.CodeID1=t_Sale_206.CodeID1)
JOIN r_Codes2 r_Codes2_217 WITH(NOLOCK) ON (r_Codes2_217.CodeID2=t_Sale_206.CodeID2)
JOIN r_Codes3 r_Codes3_218 WITH(NOLOCK) ON (r_Codes3_218.CodeID3=t_Sale_206.CodeID3)
JOIN r_Codes4 r_Codes4_219 WITH(NOLOCK) ON (r_Codes4_219.CodeID4=t_Sale_206.CodeID4)
JOIN r_Codes5 r_Codes5_220 WITH(NOLOCK) ON (r_Codes5_220.CodeID5=t_Sale_206.CodeID5)
JOIN r_Ours r_Ours_215 WITH(NOLOCK) ON (r_Ours_215.OurID=t_Sale_206.OurID)
JOIN r_Stocks r_Stocks_221 WITH(NOLOCK) ON (r_Stocks_221.StockID=t_Sale_206.StockID)
JOIN av_t_SaleD t_SaleD_207 WITH(NOLOCK) ON (t_SaleD_207.ChID=t_Sale_206.ChID)
JOIN t_PInP t_PInP_223 WITH(NOLOCK) ON (t_PInP_223.PPID=t_SaleD_207.PPID AND t_PInP_223.ProdID=t_SaleD_207.ProdID)
JOIN r_Deps r_Deps_236 WITH(NOLOCK) ON (r_Deps_236.DepID=r_Stocks_221.DepID)
  WHERE  ((t_Sale_206.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Sale_206.CodeID5 BETWEEN 2056 AND 2062) OR (t_Sale_206.CodeID5 = 2067)) AND ((t_Sale_206.OurID BETWEEN 1 AND 6) OR (t_Sale_206.OurID = 11)) AND (t_Sale_206.DocDate BETWEEN '20180401' AND '20180430') AND (t_Sale_206.OurID IN (14,15,16)) GROUP BY t_Sale_206.DocDate, t_Sale_206.OurID, r_Ours_215.OurName, t_Sale_206.CodeID1, r_Codes1_216.CodeName1, t_Sale_206.CodeID2, r_Codes1_216.Notes, r_Codes2_217.CodeName2, r_Codes2_217.Notes, t_Sale_206.CodeID3, r_Codes3_218.CodeName3, r_Codes3_218.Notes, t_Sale_206.CodeID4, r_Codes4_219.CodeName4, r_Codes4_219.Notes, t_Sale_206.CodeID5, r_Codes5_220.CodeName5, r_Codes5_220.Notes


>>> Расход (Факт) - Приход товара:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif])
SELECT t_Rec_1.DocDate, t_Rec_1.OurID, r_Ours_22.OurName, t_Rec_1.CodeID1, r_Codes1_42.CodeName1, t_Rec_1.CodeID2, r_Codes1_42.Notes Notes1, r_Codes2_52.CodeName2, r_Codes2_52.Notes Notes2, t_Rec_1.CodeID3, r_Codes3_62.CodeName3, r_Codes3_62.Notes Notes3, t_Rec_1.CodeID4, r_Codes4_72.CodeName4, r_Codes4_72.Notes Notes4, t_Rec_1.CodeID5, r_Codes5_82.CodeName5, r_Codes5_82.Notes Notes5, t_Rec_1.DepID, r_Deps_264.DepName, 'Расход (Факт)', SUM(0-(t_RecD_145.Qty * t_PInP_146.CostCC)) SumCC, SUM(0-(t_RecD_145.Qty * t_PInP_146.CostMC)) SumMC, SUM(0-((t_RecD_145.Qty * t_PInP_146.CostCC) / 9)) SumMC_K, SUM(0-(t_RecD_145.Qty * ((t_PInP_146.CostCC / 9) - t_PInP_146.CostMC))) SumCurrDif FROM av_t_Rec t_Rec_1 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_42 WITH(NOLOCK) ON (r_Codes1_42.CodeID1=t_Rec_1.CodeID1)
JOIN r_Codes2 r_Codes2_52 WITH(NOLOCK) ON (r_Codes2_52.CodeID2=t_Rec_1.CodeID2)
JOIN r_Codes3 r_Codes3_62 WITH(NOLOCK) ON (r_Codes3_62.CodeID3=t_Rec_1.CodeID3)
JOIN r_Codes4 r_Codes4_72 WITH(NOLOCK) ON (r_Codes4_72.CodeID4=t_Rec_1.CodeID4)
JOIN r_Codes5 r_Codes5_82 WITH(NOLOCK) ON (r_Codes5_82.CodeID5=t_Rec_1.CodeID5)
JOIN r_Deps r_Deps_264 WITH(NOLOCK) ON (r_Deps_264.DepID=t_Rec_1.DepID)
JOIN r_Ours r_Ours_22 WITH(NOLOCK) ON (r_Ours_22.OurID=t_Rec_1.OurID)
JOIN r_Stocks r_Stocks_199 WITH(NOLOCK) ON (r_Stocks_199.StockID=t_Rec_1.StockID)
JOIN av_t_RecD t_RecD_145 WITH(NOLOCK) ON (t_RecD_145.ChID=t_Rec_1.ChID)
JOIN t_PInP t_PInP_146 WITH(NOLOCK) ON (t_PInP_146.PPID=t_RecD_145.PPID AND t_PInP_146.ProdID=t_RecD_145.ProdID)
JOIN r_Deps r_Deps_224 WITH(NOLOCK) ON (r_Deps_224.DepID=r_Stocks_199.DepID)
  WHERE  ((t_Rec_1.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Rec_1.CodeID5 BETWEEN 2056 AND 2062) OR (t_Rec_1.CodeID5 = 2067)) AND ((t_Rec_1.OurID BETWEEN 1 AND 6) OR (t_Rec_1.OurID = 11)) AND (t_Rec_1.DocDate BETWEEN '20180401' AND '20180430') AND (t_Rec_1.OurID IN (1,11,2,3,5,6,4)) GROUP BY t_Rec_1.DocDate, t_Rec_1.OurID, r_Ours_22.OurName, t_Rec_1.CodeID1, r_Codes1_42.CodeName1, t_Rec_1.CodeID2, r_Codes1_42.Notes, r_Codes2_52.CodeName2, r_Codes2_52.Notes, t_Rec_1.CodeID3, r_Codes3_62.CodeName3, r_Codes3_62.Notes, t_Rec_1.CodeID4, r_Codes4_72.CodeName4, r_Codes4_72.Notes, t_Rec_1.CodeID5, r_Codes5_82.CodeName5, r_Codes5_82.Notes, t_Rec_1.DepID, r_Deps_264.DepName


>>> Расход (Факт) - Возврат товара от получателя:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) 
SELECT t_Ret_2.DocDate, t_Ret_2.OurID, r_Ours_23.OurName, t_Ret_2.CodeID1, r_Codes1_43.CodeName1, t_Ret_2.CodeID2, r_Codes1_43.Notes Notes1, r_Codes2_53.CodeName2, r_Codes2_53.Notes Notes2, t_Ret_2.CodeID3, r_Codes3_63.CodeName3, r_Codes3_63.Notes Notes3, t_Ret_2.CodeID4, r_Codes4_73.CodeName4, r_Codes4_73.Notes Notes4, t_Ret_2.CodeID5, r_Codes5_83.CodeName5, r_Codes5_83.Notes Notes5, t_Ret_2.DepID, r_Deps_267.DepName, 'Расход (Факт)', SUM(0-(t_RetD_141.Qty * t_PInP_142.CostCC)) SumCC, SUM(0-(t_RetD_141.Qty * t_PInP_142.CostMC)) SumMC, SUM(0-((t_RetD_141.Qty * t_PInP_142.CostCC) / 9)) SumMC_K, SUM(0-(t_RetD_141.Qty * ((t_PInP_142.CostCC / 9) - (t_PInP_142.CostMC)))) SumCurrDif FROM av_t_Ret t_Ret_2 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_43 WITH(NOLOCK) ON (r_Codes1_43.CodeID1=t_Ret_2.CodeID1)
JOIN r_Codes2 r_Codes2_53 WITH(NOLOCK) ON (r_Codes2_53.CodeID2=t_Ret_2.CodeID2)
JOIN r_Codes3 r_Codes3_63 WITH(NOLOCK) ON (r_Codes3_63.CodeID3=t_Ret_2.CodeID3)
JOIN r_Codes4 r_Codes4_73 WITH(NOLOCK) ON (r_Codes4_73.CodeID4=t_Ret_2.CodeID4)
JOIN r_Codes5 r_Codes5_83 WITH(NOLOCK) ON (r_Codes5_83.CodeID5=t_Ret_2.CodeID5)
JOIN r_Deps r_Deps_267 WITH(NOLOCK) ON (r_Deps_267.DepID=t_Ret_2.DepID)
JOIN r_Ours r_Ours_23 WITH(NOLOCK) ON (r_Ours_23.OurID=t_Ret_2.OurID)
JOIN r_Stocks r_Stocks_195 WITH(NOLOCK) ON (r_Stocks_195.StockID=t_Ret_2.StockID)
JOIN av_t_RetD t_RetD_141 WITH(NOLOCK) ON (t_RetD_141.ChID=t_Ret_2.ChID)
JOIN t_PInP t_PInP_142 WITH(NOLOCK) ON (t_PInP_142.PPID=t_RetD_141.PPID AND t_PInP_142.ProdID=t_RetD_141.ProdID)
JOIN r_Deps r_Deps_225 WITH(NOLOCK) ON (r_Deps_225.DepID=r_Stocks_195.DepID)
  WHERE  ((t_Ret_2.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Ret_2.CodeID5 BETWEEN 2056 AND 2062) OR (t_Ret_2.CodeID5 = 2067)) AND ((t_Ret_2.OurID BETWEEN 1 AND 6) OR (t_Ret_2.OurID = 11)) AND (t_Ret_2.DocDate BETWEEN '20180401' AND '20180430') AND (t_Ret_2.OurID IN (1,11,2,3,5,6,4)) GROUP BY t_Ret_2.DocDate, t_Ret_2.OurID, r_Ours_23.OurName, t_Ret_2.CodeID1, r_Codes1_43.CodeName1, t_Ret_2.CodeID2, r_Codes1_43.Notes, r_Codes2_53.CodeName2, r_Codes2_53.Notes, t_Ret_2.CodeID3, r_Codes3_63.CodeName3, r_Codes3_63.Notes, t_Ret_2.CodeID4, r_Codes4_73.CodeName4, r_Codes4_73.Notes, t_Ret_2.CodeID5, r_Codes5_83.CodeName5, r_Codes5_83.Notes, t_Ret_2.DepID, r_Deps_267.DepName


>>> Расход (Факт) - Возврат товара поставщику:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif])
SELECT t_CRet_3.DocDate, t_CRet_3.OurID, r_Ours_24.OurName, t_CRet_3.CodeID1, r_Codes1_44.CodeName1, t_CRet_3.CodeID2, r_Codes1_44.Notes Notes1, r_Codes2_54.CodeName2, r_Codes2_54.Notes Notes2, t_CRet_3.CodeID3, r_Codes3_64.CodeName3, r_Codes3_64.Notes Notes3, t_CRet_3.CodeID4, r_Codes4_74.CodeName4, r_Codes4_74.Notes Notes4, t_CRet_3.CodeID5, r_Codes5_84.CodeName5, r_Codes5_84.Notes Notes5, 0, ' ', 'Расход (Факт)', SUM(t_CRetD_143.Qty * t_PInP_144.CostCC) SumCC, SUM(t_CRetD_143.Qty * t_PInP_144.CostMC) SumMC, SUM((t_CRetD_143.Qty * t_PInP_144.CostCC) / 9) SumMC_K, SUM(t_CRetD_143.Qty * ((t_PInP_144.CostCC / 9) - t_PInP_144.CostMC)) SumCurrDif FROM av_t_CRet t_CRet_3 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_44 WITH(NOLOCK) ON (r_Codes1_44.CodeID1=t_CRet_3.CodeID1)
JOIN r_Codes2 r_Codes2_54 WITH(NOLOCK) ON (r_Codes2_54.CodeID2=t_CRet_3.CodeID2)
JOIN r_Codes3 r_Codes3_64 WITH(NOLOCK) ON (r_Codes3_64.CodeID3=t_CRet_3.CodeID3)
JOIN r_Codes4 r_Codes4_74 WITH(NOLOCK) ON (r_Codes4_74.CodeID4=t_CRet_3.CodeID4)
JOIN r_Codes5 r_Codes5_84 WITH(NOLOCK) ON (r_Codes5_84.CodeID5=t_CRet_3.CodeID5)
JOIN r_Ours r_Ours_24 WITH(NOLOCK) ON (r_Ours_24.OurID=t_CRet_3.OurID)
JOIN r_Stocks r_Stocks_196 WITH(NOLOCK) ON (r_Stocks_196.StockID=t_CRet_3.StockID)
JOIN av_t_CRetD t_CRetD_143 WITH(NOLOCK) ON (t_CRetD_143.ChID=t_CRet_3.ChID)
JOIN t_PInP t_PInP_144 WITH(NOLOCK) ON (t_PInP_144.PPID=t_CRetD_143.PPID AND t_PInP_144.ProdID=t_CRetD_143.ProdID)
JOIN r_Deps r_Deps_226 WITH(NOLOCK) ON (r_Deps_226.DepID=r_Stocks_196.DepID)
  WHERE  ((t_CRet_3.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_CRet_3.CodeID5 BETWEEN 2056 AND 2062) OR (t_CRet_3.CodeID5 = 2067)) AND ((t_CRet_3.OurID BETWEEN 1 AND 6) OR (t_CRet_3.OurID = 11)) AND (t_CRet_3.DocDate BETWEEN '20180401' AND '20180430') AND (t_CRet_3.OurID IN (1,11,2,3,5,6,4)) GROUP BY t_CRet_3.DocDate, t_CRet_3.OurID, r_Ours_24.OurName, t_CRet_3.CodeID1, r_Codes1_44.CodeName1, t_CRet_3.CodeID2, r_Codes1_44.Notes, r_Codes2_54.CodeName2, r_Codes2_54.Notes, t_CRet_3.CodeID3, r_Codes3_64.CodeName3, r_Codes3_64.Notes, t_CRet_3.CodeID4, r_Codes4_74.CodeName4, r_Codes4_74.Notes, t_CRet_3.CodeID5, r_Codes5_84.CodeName5, r_Codes5_84.Notes


>>> Расход (Факт) - Расходная накладная:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif])
SELECT t_Inv_4.DocDate, t_Inv_4.OurID, r_Ours_25.OurName, t_Inv_4.CodeID1, r_Codes1_45.CodeName1, t_Inv_4.CodeID2, r_Codes1_45.Notes Notes1, r_Codes2_55.CodeName2, r_Codes2_55.Notes Notes2, t_Inv_4.CodeID3, r_Codes3_65.CodeName3, r_Codes3_65.Notes Notes3, t_Inv_4.CodeID4, r_Codes4_75.CodeName4, r_Codes4_75.Notes Notes4, t_Inv_4.CodeID5, r_Codes5_85.CodeName5, r_Codes5_85.Notes Notes5, t_Inv_4.DepID, r_Deps_297.DepName, 'Расход (Факт)', SUM(t_InvD_147.Qty * t_PInP_148.CostCC) SumCC, SUM(t_InvD_147.Qty * t_PInP_148.CostMC) SumMC, SUM((t_InvD_147.Qty * t_PInP_148.CostCC) / 9) SumMC_K, SUM(t_InvD_147.Qty * ((t_PInP_148.CostCC / 9) - t_PInP_148.CostMC)) SumCurrDif FROM av_t_Inv t_Inv_4 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_45 WITH(NOLOCK) ON (r_Codes1_45.CodeID1=t_Inv_4.CodeID1)
JOIN r_Codes2 r_Codes2_55 WITH(NOLOCK) ON (r_Codes2_55.CodeID2=t_Inv_4.CodeID2)
JOIN r_Codes3 r_Codes3_65 WITH(NOLOCK) ON (r_Codes3_65.CodeID3=t_Inv_4.CodeID3)
JOIN r_Codes4 r_Codes4_75 WITH(NOLOCK) ON (r_Codes4_75.CodeID4=t_Inv_4.CodeID4)
JOIN r_Codes5 r_Codes5_85 WITH(NOLOCK) ON (r_Codes5_85.CodeID5=t_Inv_4.CodeID5)
JOIN r_Deps r_Deps_297 WITH(NOLOCK) ON (r_Deps_297.DepID=t_Inv_4.DepID)
JOIN r_Ours r_Ours_25 WITH(NOLOCK) ON (r_Ours_25.OurID=t_Inv_4.OurID)
JOIN r_Stocks r_Stocks_201 WITH(NOLOCK) ON (r_Stocks_201.StockID=t_Inv_4.StockID)
JOIN av_t_InvD t_InvD_147 WITH(NOLOCK) ON (t_InvD_147.ChID=t_Inv_4.ChID)
JOIN t_PInP t_PInP_148 WITH(NOLOCK) ON (t_PInP_148.PPID=t_InvD_147.PPID AND t_PInP_148.ProdID=t_InvD_147.ProdID)
JOIN r_Deps r_Deps_227 WITH(NOLOCK) ON (r_Deps_227.DepID=r_Stocks_201.DepID)
  WHERE  ((t_Inv_4.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Inv_4.CodeID5 BETWEEN 2056 AND 2062) OR (t_Inv_4.CodeID5 = 2067)) AND ((t_Inv_4.OurID BETWEEN 1 AND 6) OR (t_Inv_4.OurID = 11)) AND (t_Inv_4.DocDate BETWEEN '20180401' AND '20180430') AND (t_Inv_4.OurID IN (1,11,2,3,5,6,4)) GROUP BY t_Inv_4.DocDate, t_Inv_4.OurID, r_Ours_25.OurName, t_Inv_4.CodeID1, r_Codes1_45.CodeName1, t_Inv_4.CodeID2, r_Codes1_45.Notes, r_Codes2_55.CodeName2, r_Codes2_55.Notes, t_Inv_4.CodeID3, r_Codes3_65.CodeName3, r_Codes3_65.Notes, t_Inv_4.CodeID4, r_Codes4_75.CodeName4, r_Codes4_75.Notes, t_Inv_4.CodeID5, r_Codes5_85.CodeName5, r_Codes5_85.Notes, t_Inv_4.DepID, r_Deps_297.DepName


>>> Расход (Факт) - Расходный документ:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif])
SELECT t_Exp_5.DocDate, t_Exp_5.OurID, r_Ours_26.OurName, t_Exp_5.CodeID1, r_Codes1_46.CodeName1, t_Exp_5.CodeID2, r_Codes1_46.Notes Notes1, r_Codes2_56.CodeName2, r_Codes2_56.Notes Notes2, t_Exp_5.CodeID3, r_Codes3_66.CodeName3, r_Codes3_66.Notes Notes3, t_Exp_5.CodeID4, r_Codes4_76.CodeName4, r_Codes4_76.Notes Notes4, t_Exp_5.CodeID5, r_Codes5_86.CodeName5, r_Codes5_86.Notes Notes5, t_Exp_5.DepID, r_Deps_320.DepName, 'Расход (Факт)', SUM(t_ExpD_149.Qty * t_PInP_150.CostCC) SumCC, SUM(t_ExpD_149.Qty * t_PInP_150.CostMC) SumMC, SUM((t_ExpD_149.Qty * t_PInP_150.CostCC) / 9) SumMC_K, SUM(t_ExpD_149.Qty * ((t_PInP_150.CostCC / 9) - t_PInP_150.CostMC)) SumCurrDif FROM av_t_Exp t_Exp_5 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_46 WITH(NOLOCK) ON (r_Codes1_46.CodeID1=t_Exp_5.CodeID1)
JOIN r_Codes2 r_Codes2_56 WITH(NOLOCK) ON (r_Codes2_56.CodeID2=t_Exp_5.CodeID2)
JOIN r_Codes3 r_Codes3_66 WITH(NOLOCK) ON (r_Codes3_66.CodeID3=t_Exp_5.CodeID3)
JOIN r_Codes4 r_Codes4_76 WITH(NOLOCK) ON (r_Codes4_76.CodeID4=t_Exp_5.CodeID4)
JOIN r_Codes5 r_Codes5_86 WITH(NOLOCK) ON (r_Codes5_86.CodeID5=t_Exp_5.CodeID5)
JOIN r_Deps r_Deps_320 WITH(NOLOCK) ON (r_Deps_320.DepID=t_Exp_5.DepID)
JOIN r_Ours r_Ours_26 WITH(NOLOCK) ON (r_Ours_26.OurID=t_Exp_5.OurID)
JOIN r_Stocks r_Stocks_202 WITH(NOLOCK) ON (r_Stocks_202.StockID=t_Exp_5.StockID)
JOIN av_t_ExpD t_ExpD_149 WITH(NOLOCK) ON (t_ExpD_149.ChID=t_Exp_5.ChID)
JOIN t_PInP t_PInP_150 WITH(NOLOCK) ON (t_PInP_150.PPID=t_ExpD_149.PPID AND t_PInP_150.ProdID=t_ExpD_149.ProdID)
JOIN r_Deps r_Deps_228 WITH(NOLOCK) ON (r_Deps_228.DepID=r_Stocks_202.DepID)
  WHERE  ((t_Exp_5.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Exp_5.CodeID5 BETWEEN 2056 AND 2062) OR (t_Exp_5.CodeID5 = 2067)) AND ((t_Exp_5.OurID BETWEEN 1 AND 6) OR (t_Exp_5.OurID = 11)) AND (t_Exp_5.DocDate BETWEEN '20180401' AND '20180430') AND (t_Exp_5.OurID IN (1,11,2,3,5,6,4)) GROUP BY t_Exp_5.DocDate, t_Exp_5.OurID, r_Ours_26.OurName, t_Exp_5.CodeID1, r_Codes1_46.CodeName1, t_Exp_5.CodeID2, r_Codes1_46.Notes, r_Codes2_56.CodeName2, r_Codes2_56.Notes, t_Exp_5.CodeID3, r_Codes3_66.CodeName3, r_Codes3_66.Notes, t_Exp_5.CodeID4, r_Codes4_76.CodeName4, r_Codes4_76.Notes, t_Exp_5.CodeID5, r_Codes5_86.CodeName5, r_Codes5_86.Notes, t_Exp_5.DepID, r_Deps_320.DepName


>>> Расход (Факт) - Расходный документ в ценах прихода:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) 
SELECT t_Epp_6.DocDate, t_Epp_6.OurID, r_Ours_27.OurName, t_Epp_6.CodeID1, r_Codes1_47.CodeName1, t_Epp_6.CodeID2, r_Codes1_47.Notes Notes1, r_Codes2_57.CodeName2, r_Codes2_57.Notes Notes2, t_Epp_6.CodeID3, r_Codes3_67.CodeName3, r_Codes3_67.Notes Notes3, t_Epp_6.CodeID4, r_Codes4_77.CodeName4, r_Codes4_77.Notes Notes4, t_Epp_6.CodeID5, r_Codes5_87.CodeName5, r_Codes5_87.Notes Notes5, t_Epp_6.DepID, r_Deps_325.DepName, 'Расход (Факт)', SUM(t_EppD_151.Qty * t_PInP_152.CostCC) SumCC, SUM(t_EppD_151.Qty * t_PInP_152.CostMC) SumMC, SUM((t_EppD_151.Qty * t_PInP_152.CostCC) / 9) SumMC_K, SUM(t_EppD_151.Qty * ((t_PInP_152.CostCC / 9) - t_PInP_152.CostMC)) SumCurrDif FROM av_t_Epp t_Epp_6 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_47 WITH(NOLOCK) ON (r_Codes1_47.CodeID1=t_Epp_6.CodeID1)
JOIN r_Codes2 r_Codes2_57 WITH(NOLOCK) ON (r_Codes2_57.CodeID2=t_Epp_6.CodeID2)
JOIN r_Codes3 r_Codes3_67 WITH(NOLOCK) ON (r_Codes3_67.CodeID3=t_Epp_6.CodeID3)
JOIN r_Codes4 r_Codes4_77 WITH(NOLOCK) ON (r_Codes4_77.CodeID4=t_Epp_6.CodeID4)
JOIN r_Codes5 r_Codes5_87 WITH(NOLOCK) ON (r_Codes5_87.CodeID5=t_Epp_6.CodeID5)
JOIN r_Deps r_Deps_325 WITH(NOLOCK) ON (r_Deps_325.DepID=t_Epp_6.DepID)
JOIN r_Ours r_Ours_27 WITH(NOLOCK) ON (r_Ours_27.OurID=t_Epp_6.OurID)
JOIN r_Stocks r_Stocks_203 WITH(NOLOCK) ON (r_Stocks_203.StockID=t_Epp_6.StockID)
JOIN av_t_EppD t_EppD_151 WITH(NOLOCK) ON (t_EppD_151.ChID=t_Epp_6.ChID)
JOIN t_PInP t_PInP_152 WITH(NOLOCK) ON (t_PInP_152.PPID=t_EppD_151.PPID AND t_PInP_152.ProdID=t_EppD_151.ProdID)
JOIN r_Deps r_Deps_229 WITH(NOLOCK) ON (r_Deps_229.DepID=r_Stocks_203.DepID)
  WHERE  ((t_Epp_6.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Epp_6.CodeID5 BETWEEN 2056 AND 2062) OR (t_Epp_6.CodeID5 = 2067)) AND ((t_Epp_6.OurID BETWEEN 1 AND 6) OR (t_Epp_6.OurID = 11)) AND (t_Epp_6.DocDate BETWEEN '20180401' AND '20180430') AND (t_Epp_6.OurID IN (1,11,2,3,5,6,4)) GROUP BY t_Epp_6.DocDate, t_Epp_6.OurID, r_Ours_27.OurName, t_Epp_6.CodeID1, r_Codes1_47.CodeName1, t_Epp_6.CodeID2, r_Codes1_47.Notes, r_Codes2_57.CodeName2, r_Codes2_57.Notes, t_Epp_6.CodeID3, r_Codes3_67.CodeName3, r_Codes3_67.Notes, t_Epp_6.CodeID4, r_Codes4_77.CodeName4, r_Codes4_77.Notes, t_Epp_6.CodeID5, r_Codes5_87.CodeName5, r_Codes5_87.Notes, t_Epp_6.DepID, r_Deps_325.DepName


>>> Расход (Факт) - Переоценка цен прихода (Приход):
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif])
SELECT t_Est_7.DocDate, t_Est_7.OurID, r_Ours_29.OurName, r_Codes1_183.CodeID1, r_Codes1_183.CodeName1, r_Codes2_184.CodeID2, r_Codes1_183.Notes Notes1, r_Codes2_184.CodeName2, r_Codes2_184.Notes Notes2, t_Est_7.CodeID3, r_Codes3_69.CodeName3, r_Codes3_69.Notes Notes3, r_Codes4_193.CodeID4, r_Codes4_193.CodeName4, r_Codes4_193.Notes Notes4, r_Codes5_185.CodeID5, r_Codes5_185.CodeName5, r_Codes5_185.Notes Notes5, r_Deps_230.DepID, r_Deps_230.DepName, 'Расход (Факт)', SUM(0-(t_EstD_153.Qty * t_PInP_154.CostCC)) SumCC, SUM(0-(t_EstD_153.Qty * t_PInP_154.CostMC)) SumMC, SUM(0-((t_EstD_153.Qty * t_PInP_154.CostCC) / 9)) SumMC_K, SUM(0-(t_EstD_153.Qty * ((t_PInP_154.CostCC / 9) - t_PInP_154.CostMC))) SumCurrDif
FROM av_t_Est t_Est_7 WITH(NOLOCK)
JOIN r_Codes3 r_Codes3_69 WITH(NOLOCK) ON (r_Codes3_69.CodeID3=t_Est_7.CodeID3)
JOIN r_Ours r_Ours_29 WITH(NOLOCK) ON (r_Ours_29.OurID=t_Est_7.OurID)
JOIN r_Stocks r_Stocks_189 WITH(NOLOCK) ON (r_Stocks_189.StockID=t_Est_7.StockID)
JOIN av_t_EstD t_EstD_153 WITH(NOLOCK) ON (t_EstD_153.ChID=t_Est_7.ChID)
JOIN t_PInP t_PInP_154 WITH(NOLOCK) ON (t_PInP_154.PPID=t_EstD_153.NewPPID AND t_PInP_154.ProdID=t_EstD_153.ProdID)
JOIN r_Prods r_Prods_168 WITH(NOLOCK) ON (r_Prods_168.ProdID=t_PInP_154.ProdID)
JOIN r_ProdC r_ProdC_180 WITH(NOLOCK) ON (r_ProdC_180.PCatID=r_Prods_168.PCatID)
JOIN r_ProdG r_ProdG_181 WITH(NOLOCK) ON (r_ProdG_181.PGrID=r_Prods_168.PGrID)
JOIN r_ProdG1 r_ProdG1_182 WITH(NOLOCK) ON (r_ProdG1_182.PGrID1=r_Prods_168.PGrID1)
JOIN r_Codes5 r_Codes5_185 WITH(NOLOCK) ON (r_Codes5_185.CodeID5=r_ProdG1_182.CodeID5)
JOIN r_Codes2 r_Codes2_184 WITH(NOLOCK) ON (r_Codes2_184.CodeID2=r_ProdG_181.CodeID2)
JOIN r_Codes1 r_Codes1_183 WITH(NOLOCK) ON (r_Codes1_183.CodeID1=r_ProdC_180.CodeID1)
JOIN r_Deps r_Deps_230 WITH(NOLOCK) ON (r_Deps_230.DepID=r_Stocks_189.DepID)
JOIN r_StockGs r_StockGs_190 WITH(NOLOCK) ON (r_StockGs_190.StockGID=r_Stocks_189.StockGID)
JOIN r_Codes4 r_Codes4_193 WITH(NOLOCK) ON (r_Codes4_193.CodeID4=r_StockGs_190.StockGID)
  WHERE  ((r_Codes1_183.CodeID1 BETWEEN 2000 AND 3000)) AND ((r_Codes5_185.CodeID5 BETWEEN 2056 AND 2062) OR (r_Codes5_185.CodeID5 = 2067)) AND ((t_Est_7.OurID BETWEEN 1 AND 6) OR (t_Est_7.OurID = 11)) AND (t_Est_7.DocDate BETWEEN '20180401' AND '20180430') AND ((t_Est_7.OurID IN (1,11,2,3,5,6,4) AND (r_Prods_168.PCatID BETWEEN 600 AND 699) AND ((r_Prods_168.PGrID BETWEEN 9100 AND 9999) OR (r_Prods_168.PGrID BETWEEN 16000 AND 17000)))) GROUP BY t_Est_7.DocDate, t_Est_7.OurID, r_Ours_29.OurName, r_Codes1_183.CodeID1, r_Codes1_183.CodeName1, r_Codes2_184.CodeID2, r_Codes1_183.Notes, r_Codes2_184.CodeName2, r_Codes2_184.Notes, t_Est_7.CodeID3, r_Codes3_69.CodeName3, r_Codes3_69.Notes, r_Codes4_193.CodeID4, r_Codes4_193.CodeName4, r_Codes4_193.Notes, r_Codes5_185.CodeID5, r_Codes5_185.CodeName5, r_Codes5_185.Notes, r_Deps_230.DepID, r_Deps_230.DepName


>>> Расход (Факт) - Приход денег по предприятиям:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT c_CompRec_9.DocDate, c_CompRec_9.OurID, r_Ours_30.OurName, c_CompRec_9.CodeID1, r_Codes1_50.CodeName1, c_CompRec_9.CodeID2, r_Codes1_50.Notes Notes1, r_Codes2_60.CodeName2, r_Codes2_60.Notes Notes2, c_CompRec_9.CodeID3, r_Codes3_70.CodeName3, r_Codes3_70.Notes Notes3, c_CompRec_9.CodeID4, r_Codes4_80.CodeName4, r_Codes4_80.Notes Notes4, c_CompRec_9.CodeID5, r_Codes5_90.CodeName5, r_Codes5_90.Notes Notes5, c_CompRec_9.DepID, r_Deps_344.DepName, 'Расход (Факт)', SUM(0-(c_CompRec_9.SumAC * c_CompRec_9.KursCC)) SumCC, SUM(0-(c_CompRec_9.SumAC / c_CompRec_9.KursMC)) SumMC, SUM(0-((c_CompRec_9.SumAC * c_CompRec_9.KursCC) / 9)) SumMC_K, SUM(0-(((c_CompRec_9.SumAC * c_CompRec_9.KursCC) / c_CompRec_9.KursMC) - (c_CompRec_9.SumAC / c_CompRec_9.KursMC))) SumCurrDif FROM av_c_CompRec c_CompRec_9 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_50 WITH(NOLOCK) ON (r_Codes1_50.CodeID1=c_CompRec_9.CodeID1)
JOIN r_Codes2 r_Codes2_60 WITH(NOLOCK) ON (r_Codes2_60.CodeID2=c_CompRec_9.CodeID2)
JOIN r_Codes3 r_Codes3_70 WITH(NOLOCK) ON (r_Codes3_70.CodeID3=c_CompRec_9.CodeID3)
JOIN r_Codes4 r_Codes4_80 WITH(NOLOCK) ON (r_Codes4_80.CodeID4=c_CompRec_9.CodeID4)
JOIN r_Codes5 r_Codes5_90 WITH(NOLOCK) ON (r_Codes5_90.CodeID5=c_CompRec_9.CodeID5)
JOIN r_Deps r_Deps_344 WITH(NOLOCK) ON (r_Deps_344.DepID=c_CompRec_9.DepID)
JOIN r_Ours r_Ours_30 WITH(NOLOCK) ON (r_Ours_30.OurID=c_CompRec_9.OurID)
JOIN r_Stocks r_Stocks_198 WITH(NOLOCK) ON (r_Stocks_198.StockID=c_CompRec_9.StockID)
JOIN r_Deps r_Deps_231 WITH(NOLOCK) ON (r_Deps_231.DepID=r_Stocks_198.DepID)
  WHERE  ((c_CompRec_9.CodeID1 BETWEEN 2000 AND 3000)) AND ((c_CompRec_9.CodeID5 BETWEEN 2056 AND 2062) OR (c_CompRec_9.CodeID5 = 2067)) AND ((c_CompRec_9.OurID BETWEEN 1 AND 6) OR (c_CompRec_9.OurID = 11)) AND (c_CompRec_9.DocDate BETWEEN '20180401' AND '20180430') AND (c_CompRec_9.OurID IN (1,11,2,3,5,6,4)) GROUP BY c_CompRec_9.DocDate, c_CompRec_9.OurID, r_Ours_30.OurName, c_CompRec_9.CodeID1, r_Codes1_50.CodeName1, c_CompRec_9.CodeID2, r_Codes1_50.Notes, r_Codes2_60.CodeName2, r_Codes2_60.Notes, c_CompRec_9.CodeID3, r_Codes3_70.CodeName3, r_Codes3_70.Notes, c_CompRec_9.CodeID4, r_Codes4_80.CodeName4, r_Codes4_80.Notes, c_CompRec_9.CodeID5, r_Codes5_90.CodeName5, r_Codes5_90.Notes, c_CompRec_9.DepID, r_Deps_344.DepName


>>> Расход (Факт) - Расход денег по предприятиям:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT c_CompExp_10.DocDate, c_CompExp_10.OurID, r_Ours_31.OurName, c_CompExp_10.CodeID1, r_Codes1_51.CodeName1, c_CompExp_10.CodeID2, r_Codes1_51.Notes Notes1, r_Codes2_61.CodeName2, r_Codes2_61.Notes Notes2, c_CompExp_10.CodeID3, r_Codes3_71.CodeName3, r_Codes3_71.Notes Notes3, c_CompExp_10.CodeID4, r_Codes4_81.CodeName4, r_Codes4_81.Notes Notes4, c_CompExp_10.CodeID5, r_Codes5_91.CodeName5, r_Codes5_91.Notes Notes5, c_CompExp_10.DepID, r_Deps_347.DepName, 'Расход (Факт)', SUM(c_CompExp_10.SumAC * c_CompExp_10.KursCC) SumCC, SUM(c_CompExp_10.SumAC / c_CompExp_10.KursMC) SumMC, SUM((c_CompExp_10.SumAC * c_CompExp_10.KursCC) / 9) SumMC_K, SUM(((c_CompExp_10.SumAC * c_CompExp_10.KursCC) / 9) - (c_CompExp_10.SumAC / c_CompExp_10.KursMC)) SumCurrDif FROM av_c_CompExp c_CompExp_10 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_51 WITH(NOLOCK) ON (r_Codes1_51.CodeID1=c_CompExp_10.CodeID1)
JOIN r_Codes2 r_Codes2_61 WITH(NOLOCK) ON (r_Codes2_61.CodeID2=c_CompExp_10.CodeID2)
JOIN r_Codes3 r_Codes3_71 WITH(NOLOCK) ON (r_Codes3_71.CodeID3=c_CompExp_10.CodeID3)
JOIN r_Codes4 r_Codes4_81 WITH(NOLOCK) ON (r_Codes4_81.CodeID4=c_CompExp_10.CodeID4)
JOIN r_Codes5 r_Codes5_91 WITH(NOLOCK) ON (r_Codes5_91.CodeID5=c_CompExp_10.CodeID5)
JOIN r_Deps r_Deps_347 WITH(NOLOCK) ON (r_Deps_347.DepID=c_CompExp_10.DepID)
JOIN r_Ours r_Ours_31 WITH(NOLOCK) ON (r_Ours_31.OurID=c_CompExp_10.OurID)
JOIN r_Stocks r_Stocks_200 WITH(NOLOCK) ON (r_Stocks_200.StockID=c_CompExp_10.StockID)
JOIN r_Deps r_Deps_232 WITH(NOLOCK) ON (r_Deps_232.DepID=r_Stocks_200.DepID)
  WHERE  ((c_CompExp_10.CodeID1 BETWEEN 2000 AND 3000)) AND ((c_CompExp_10.CodeID5 BETWEEN 2056 AND 2062) OR (c_CompExp_10.CodeID5 = 2067)) AND ((c_CompExp_10.OurID BETWEEN 1 AND 6) OR (c_CompExp_10.OurID = 11)) AND (c_CompExp_10.DocDate BETWEEN '20180401' AND '20180430') AND (c_CompExp_10.OurID IN (1,11,2,3,5,6,4)) GROUP BY c_CompExp_10.DocDate, c_CompExp_10.OurID, r_Ours_31.OurName, c_CompExp_10.CodeID1, r_Codes1_51.CodeName1, c_CompExp_10.CodeID2, r_Codes1_51.Notes, r_Codes2_61.CodeName2, r_Codes2_61.Notes, c_CompExp_10.CodeID3, r_Codes3_71.CodeName3, r_Codes3_71.Notes, c_CompExp_10.CodeID4, r_Codes4_81.CodeName4, r_Codes4_81.Notes, c_CompExp_10.CodeID5, r_Codes5_91.CodeName5, r_Codes5_91.Notes, c_CompExp_10.DepID, r_Deps_347.DepName

>>> Расход (Факт) - Прием наличных денег на склад:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) SELECT t_MonRec_11.DocDate, t_MonRec_11.OurID, r_Ours_28.OurName, t_MonRec_11.CodeID1, r_Codes1_48.CodeName1, t_MonRec_11.CodeID2, r_Codes1_48.Notes Notes1, r_Codes2_58.CodeName2, r_Codes2_58.Notes Notes2, t_MonRec_11.CodeID3, r_Codes3_68.CodeName3, r_Codes3_68.Notes Notes3, t_MonRec_11.CodeID4, r_Codes4_78.CodeName4, r_Codes4_78.Notes Notes4, t_MonRec_11.CodeID5, r_Codes5_88.CodeName5, r_Codes5_88.Notes Notes5, 0, ' ', 'Расход (Факт)', SUM(0-(t_MonRec_11.SumAC * t_MonRec_11.KursCC)) SumCC, SUM(0-(t_MonRec_11.SumAC / t_MonRec_11.KursMC)) SumMC, SUM(0-((t_MonRec_11.SumAC * t_MonRec_11.KursCC) / 9)) SumMC_K, SUM(0-(((t_MonRec_11.SumAC * t_MonRec_11.KursCC) / 9) - (t_MonRec_11.SumAC / t_MonRec_11.KursMC))) SumCurrDif FROM av_t_MonRec t_MonRec_11 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_48 WITH(NOLOCK) ON (r_Codes1_48.CodeID1=t_MonRec_11.CodeID1)
JOIN r_Codes2 r_Codes2_58 WITH(NOLOCK) ON (r_Codes2_58.CodeID2=t_MonRec_11.CodeID2)
JOIN r_Codes3 r_Codes3_68 WITH(NOLOCK) ON (r_Codes3_68.CodeID3=t_MonRec_11.CodeID3)
JOIN r_Codes4 r_Codes4_78 WITH(NOLOCK) ON (r_Codes4_78.CodeID4=t_MonRec_11.CodeID4)
JOIN r_Codes5 r_Codes5_88 WITH(NOLOCK) ON (r_Codes5_88.CodeID5=t_MonRec_11.CodeID5)
JOIN r_Ours r_Ours_28 WITH(NOLOCK) ON (r_Ours_28.OurID=t_MonRec_11.OurID)
JOIN r_Stocks r_Stocks_197 WITH(NOLOCK) ON (r_Stocks_197.StockID=t_MonRec_11.StockID)
JOIN r_Deps r_Deps_233 WITH(NOLOCK) ON (r_Deps_233.DepID=r_Stocks_197.DepID)
  WHERE  ((t_MonRec_11.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_MonRec_11.CodeID5 BETWEEN 2056 AND 2062) OR (t_MonRec_11.CodeID5 = 2067)) AND ((t_MonRec_11.OurID BETWEEN 1 AND 6) OR (t_MonRec_11.OurID = 11)) AND (t_MonRec_11.DocDate BETWEEN '20180401' AND '20180430') AND (t_MonRec_11.OurID IN (1,11,2,3,5,6,4)) GROUP BY t_MonRec_11.DocDate, t_MonRec_11.OurID, r_Ours_28.OurName, t_MonRec_11.CodeID1, r_Codes1_48.CodeName1, t_MonRec_11.CodeID2, r_Codes1_48.Notes, r_Codes2_58.CodeName2, r_Codes2_58.Notes, t_MonRec_11.CodeID3, r_Codes3_68.CodeName3, r_Codes3_68.Notes, t_MonRec_11.CodeID4, r_Codes4_78.CodeName4, r_Codes4_78.Notes, t_MonRec_11.CodeID5, r_Codes5_88.CodeName5, r_Codes5_88.Notes


>>> Расход (Факт) - Переоценка цен прихода (Расход):
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif])
SELECT r_Codes1_186.CodeID1,r_Codes2_187.CodeID2, r_Codes5_188.CodeID5, 'Расход (Факт)', SUM(t_EstD_157.Qty * t_PInP_167.CostCC) SumCC, SUM(t_EstD_157.Qty * t_PInP_167.CostMC) SumMC, SUM((t_EstD_157.Qty * t_PInP_167.CostCC) / 9) SumMC_K, SUM(t_EstD_157.Qty * ((t_PInP_167.CostCC / 9) - t_PInP_167.CostMC)) SumCurrDif FROM av_t_Est t_Est_156 WITH(NOLOCK)
JOIN r_Codes3 r_Codes3_162 WITH(NOLOCK) ON (r_Codes3_162.CodeID3=t_Est_156.CodeID3)
JOIN r_Ours r_Ours_159 WITH(NOLOCK) ON (r_Ours_159.OurID=t_Est_156.OurID)
JOIN r_Stocks r_Stocks_191 WITH(NOLOCK) ON (r_Stocks_191.StockID=t_Est_156.StockID)
JOIN av_t_EstD t_EstD_157 WITH(NOLOCK) ON (t_EstD_157.ChID=t_Est_156.ChID)
JOIN t_PInP t_PInP_167 WITH(NOLOCK) ON (t_PInP_167.PPID=t_EstD_157.PPID AND t_PInP_167.ProdID=t_EstD_157.ProdID)
JOIN r_Prods r_Prods_172 WITH(NOLOCK) ON (r_Prods_172.ProdID=t_PInP_167.ProdID)
JOIN r_ProdC r_ProdC_173 WITH(NOLOCK) ON (r_ProdC_173.PCatID=r_Prods_172.PCatID)
JOIN r_ProdG r_ProdG_174 WITH(NOLOCK) ON (r_ProdG_174.PGrID=r_Prods_172.PGrID)
JOIN r_ProdG1 r_ProdG1_175 WITH(NOLOCK) ON (r_ProdG1_175.PGrID1=r_Prods_172.PGrID1)
JOIN r_Codes5 r_Codes5_188 WITH(NOLOCK) ON (r_Codes5_188.CodeID5=r_ProdG1_175.CodeID5)
JOIN r_Codes2 r_Codes2_187 WITH(NOLOCK) ON (r_Codes2_187.CodeID2=r_ProdG_174.CodeID2)
JOIN r_Codes1 r_Codes1_186 WITH(NOLOCK) ON (r_Codes1_186.CodeID1=r_ProdC_173.CodeID1)
JOIN r_Deps r_Deps_234 WITH(NOLOCK) ON (r_Deps_234.DepID=r_Stocks_191.DepID)
JOIN r_StockGs r_StockGs_192 WITH(NOLOCK) ON (r_StockGs_192.StockGID=r_Stocks_191.StockGID)
JOIN r_Codes4 r_Codes4_194 WITH(NOLOCK) ON (r_Codes4_194.CodeID4=r_StockGs_192.StockGID)
  WHERE  ((r_Codes1_186.CodeID1 BETWEEN 2000 AND 3000)) 
     AND ((r_Codes5_188.CodeID5 BETWEEN 2056 AND 2062) OR (r_Codes5_188.CodeID5 = 2067)) 
     AND ((t_Est_156.OurID BETWEEN 1 AND 6) OR (t_Est_156.OurID = 11)) 
     AND (t_Est_156.DocDate BETWEEN '20180401' AND '20180430') 
     AND ((t_Est_156.OurID IN (1,11,2,3,5,6,4) 
     AND (r_Prods_172.PCatID BETWEEN 600 AND 699) 
     AND ((r_Prods_172.PGrID BETWEEN 9100 AND 9999) OR (r_Prods_172.PGrID BETWEEN 16000 AND 17000)) )) GROUP BY t_Est_156.DocDate, t_Est_156.OurID, r_Ours_159.OurName, r_Codes1_186.CodeID1, r_Codes1_186.CodeName1, r_Codes2_187.CodeID2, r_Codes1_186.Notes, r_Codes2_187.CodeName2, r_Codes2_187.Notes, t_Est_156.CodeID3, r_Codes3_162.CodeName3, r_Codes3_162.Notes, r_Codes4_194.CodeID4, r_Codes4_194.CodeName4, r_Codes4_194.Notes, r_Codes5_188.CodeID5, r_Codes5_188.CodeName5, r_Codes5_188.Notes, r_Deps_234.DepID, r_Deps_234.DepName



>>> Расход (Факт) - Возврат товара по чеку:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif])
SELECT t_CRRet_204.DocDate, t_CRRet_204.OurID, r_Ours_208.OurName, t_CRRet_204.CodeID1, r_Codes1_209.CodeName1, t_CRRet_204.CodeID2, r_Codes1_209.Notes Notes1, r_Codes2_210.CodeName2, r_Codes2_210.Notes Notes2, t_CRRet_204.CodeID3, r_Codes3_211.CodeName3, r_Codes3_211.Notes Notes3, t_CRRet_204.CodeID4, r_Codes4_212.CodeName4, r_Codes4_212.Notes Notes4, t_CRRet_204.CodeID5, r_Codes5_213.CodeName5, r_Codes5_213.Notes Notes5, 0, ' ', 'Расход (Факт)', SUM(0-(t_CRRetD_205.Qty * t_PInP_222.CostCC)) SumCC, SUM(0-(t_CRRetD_205.Qty * t_PInP_222.CostMC)) SumMC, SUM(0-(t_CRRetD_205.Qty * t_PInP_222.CostCC / 9)) SumMC_K, SUM(0-(t_CRRetD_205.Qty * (t_PInP_222.CostCC / 9 - t_PInP_222.CostMC))) SumCurrDif FROM av_t_CRRet t_CRRet_204 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_209 WITH(NOLOCK) ON (r_Codes1_209.CodeID1=t_CRRet_204.CodeID1)
JOIN r_Codes2 r_Codes2_210 WITH(NOLOCK) ON (r_Codes2_210.CodeID2=t_CRRet_204.CodeID2)
JOIN r_Codes3 r_Codes3_211 WITH(NOLOCK) ON (r_Codes3_211.CodeID3=t_CRRet_204.CodeID3)
JOIN r_Codes4 r_Codes4_212 WITH(NOLOCK) ON (r_Codes4_212.CodeID4=t_CRRet_204.CodeID4)
JOIN r_Codes5 r_Codes5_213 WITH(NOLOCK) ON (r_Codes5_213.CodeID5=t_CRRet_204.CodeID5)
JOIN r_Ours r_Ours_208 WITH(NOLOCK) ON (r_Ours_208.OurID=t_CRRet_204.OurID)
JOIN r_Stocks r_Stocks_214 WITH(NOLOCK) ON (r_Stocks_214.StockID=t_CRRet_204.StockID)
JOIN av_t_CRRetD t_CRRetD_205 WITH(NOLOCK) ON (t_CRRetD_205.ChID=t_CRRet_204.ChID)
JOIN t_PInP t_PInP_222 WITH(NOLOCK) ON (t_PInP_222.PPID=t_CRRetD_205.PPID AND t_PInP_222.ProdID=t_CRRetD_205.ProdID)
JOIN r_Deps r_Deps_235 WITH(NOLOCK) ON (r_Deps_235.DepID=r_Stocks_214.DepID)
  WHERE  ((t_CRRet_204.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_CRRet_204.CodeID5 BETWEEN 2056 AND 2062) OR (t_CRRet_204.CodeID5 = 2067)) AND ((t_CRRet_204.OurID BETWEEN 1 AND 6) OR (t_CRRet_204.OurID = 11)) AND (t_CRRet_204.DocDate BETWEEN '20180401' AND '20180430') AND (t_CRRet_204.OurID IN (1,11,2,3,5,6,4)) GROUP BY t_CRRet_204.DocDate, t_CRRet_204.OurID, r_Ours_208.OurName, t_CRRet_204.CodeID1, r_Codes1_209.CodeName1, t_CRRet_204.CodeID2, r_Codes1_209.Notes, r_Codes2_210.CodeName2, r_Codes2_210.Notes, t_CRRet_204.CodeID3, r_Codes3_211.CodeName3, r_Codes3_211.Notes, t_CRRet_204.CodeID4, r_Codes4_212.CodeName4, r_Codes4_212.Notes, t_CRRet_204.CodeID5, r_Codes5_213.CodeName5, r_Codes5_213.Notes


>>> Расход (Факт) - Продажа товара оператором:
INSERT INTO [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov] ([DocDate], [OurID], [OurName], [CodeID1], [CodeName1], [CodeID2], [Notes1], [CodeName2], [Notes2], [CodeID3], [CodeName3], [Notes3], [CodeID4], [CodeName4], [Notes4], [CodeID5], [CodeName5], [Notes5], [DDepID], [DDepName], [GMSSourceGroup], [SumCC], [SumMC], [SumMC_K], [SumCurrDif]) 
SELECT t_Sale_206.DocDate, t_Sale_206.OurID, r_Ours_215.OurName, t_Sale_206.CodeID1, r_Codes1_216.CodeName1, t_Sale_206.CodeID2, r_Codes1_216.Notes Notes1, r_Codes2_217.CodeName2, r_Codes2_217.Notes Notes2, t_Sale_206.CodeID3, r_Codes3_218.CodeName3, r_Codes3_218.Notes Notes3, t_Sale_206.CodeID4, r_Codes4_219.CodeName4, r_Codes4_219.Notes Notes4, t_Sale_206.CodeID5, r_Codes5_220.CodeName5, r_Codes5_220.Notes Notes5, 0, ' ', 'Расход (Факт)', SUM(t_SaleD_207.Qty * t_PInP_223.CostCC) SumCC, SUM(t_SaleD_207.Qty * t_PInP_223.CostMC) SumMC, SUM(t_SaleD_207.Qty * t_PInP_223.CostCC / 9) SumMC_K, SUM(t_SaleD_207.Qty * (t_PInP_223.CostCC / 9 - t_PInP_223.CostMC)) SumCurrDif FROM av_t_Sale t_Sale_206 WITH(NOLOCK)
JOIN r_Codes1 r_Codes1_216 WITH(NOLOCK) ON (r_Codes1_216.CodeID1=t_Sale_206.CodeID1)
JOIN r_Codes2 r_Codes2_217 WITH(NOLOCK) ON (r_Codes2_217.CodeID2=t_Sale_206.CodeID2)
JOIN r_Codes3 r_Codes3_218 WITH(NOLOCK) ON (r_Codes3_218.CodeID3=t_Sale_206.CodeID3)
JOIN r_Codes4 r_Codes4_219 WITH(NOLOCK) ON (r_Codes4_219.CodeID4=t_Sale_206.CodeID4)
JOIN r_Codes5 r_Codes5_220 WITH(NOLOCK) ON (r_Codes5_220.CodeID5=t_Sale_206.CodeID5)
JOIN r_Ours r_Ours_215 WITH(NOLOCK) ON (r_Ours_215.OurID=t_Sale_206.OurID)
JOIN r_Stocks r_Stocks_221 WITH(NOLOCK) ON (r_Stocks_221.StockID=t_Sale_206.StockID)
JOIN av_t_SaleD t_SaleD_207 WITH(NOLOCK) ON (t_SaleD_207.ChID=t_Sale_206.ChID)
JOIN t_PInP t_PInP_223 WITH(NOLOCK) ON (t_PInP_223.PPID=t_SaleD_207.PPID AND t_PInP_223.ProdID=t_SaleD_207.ProdID)
JOIN r_Deps r_Deps_236 WITH(NOLOCK) ON (r_Deps_236.DepID=r_Stocks_221.DepID)
  WHERE  ((t_Sale_206.CodeID1 BETWEEN 2000 AND 3000)) AND ((t_Sale_206.CodeID5 BETWEEN 2056 AND 2062) OR (t_Sale_206.CodeID5 = 2067)) AND ((t_Sale_206.OurID BETWEEN 1 AND 6) OR (t_Sale_206.OurID = 11)) AND (t_Sale_206.DocDate BETWEEN '20180401' AND '20180430') AND (t_Sale_206.OurID IN (1,11,2,3,5,6,4)) GROUP BY t_Sale_206.DocDate, t_Sale_206.OurID, r_Ours_215.OurName, t_Sale_206.CodeID1, r_Codes1_216.CodeName1, t_Sale_206.CodeID2, r_Codes1_216.Notes, r_Codes2_217.CodeName2, r_Codes2_217.Notes, t_Sale_206.CodeID3, r_Codes3_218.CodeName3, r_Codes3_218.Notes, t_Sale_206.CodeID4, r_Codes4_219.CodeName4, r_Codes4_219.Notes, t_Sale_206.CodeID5, r_Codes5_220.CodeName5, r_Codes5_220.Notes

SELECT [CodeName1], [CodeName2], [GMSSourceGroup], SUM([SumMC]) AS [SumMC] FROM [AzTempDB].[CONST\maslov].[v_038_00979_1_CONST\maslov]
WHERE [CodeName2] = 'Бытовая техника/амортизация/'
GROUP BY [CodeName1], [CodeName2], [GMSSourceGroup]
*/