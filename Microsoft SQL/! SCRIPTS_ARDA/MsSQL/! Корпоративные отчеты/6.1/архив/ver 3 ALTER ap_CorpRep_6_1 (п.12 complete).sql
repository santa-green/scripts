/*ALTER PROCEDURE [dbo].[ap_CorpRep_6_1] 
(
   @BDate SMALLDATETIME
  ,@EDate SMALLDATETIME
)
AS*/
------------------------------------------------------------

BEGIN
  SET NOCOUNT ON
    BEGIN --блок объявления переменных
        DECLARE
--1,2,3,4,5...начинаем объявлять...

        /*Общее*/
         @OurID VARCHAR(MAX)   = '1-5,11'-- внутрення фирма (Общий фильтр)
        ,@PCatID_alcohol VARCHAR(MAX) = '1-100' --код категории (Складские запасы (Алкоголь))
        ,@PCatID_ads VARCHAR(MAX) = '500' --код категории (Складские запасы (Реклама))
        ,@PLID VARCHAR(MAX) = '106' --прайс-лист
        ,@CurCurs as numeric(10,2) = (select dbo.zf_GetRateMC(dbo.zf_GetCurrCC()))
        
        /*Группы*/

		,@PGrID1_sales VARCHAR(MAX)  = '1,3,4,5,6' --код группы 1 (Объем продаж)
		,@PGrID1_alcohol VARCHAR(MAX)  = '1,3,4,5,6' --код группы 1 (Складские запасы (Алкоголь))
		,@PGrID1_ads VARCHAR(MAX)  = '1,3,4,5,6' --код группы 1 (Складские запасы (Реклама))

        /*Признаки*/

        --Признак 1
		,@CodeID1_sales VARCHAR(MAX) = '50-79' --(Объем продаж)
		,@CodeID1_license VARCHAR(MAX) = '2024' --(Лицензия)
		,@CodeID1_brand VARCHAR(MAX) = '2002-2005,2008-2023,2025-2042,2044-2099,2101-3001' --(Расходы бренда)
		,@CodeID1_credit VARCHAR(MAX) = '2043' --(Проценты по кредитам)
		,@CodeID1_distrProfit VARCHAR(MAX) = '2100' --(Курсовая прибыль от поставщиков)
		,@CodeID1_deptExp VARCHAR(MAX) = '2002-2005,2008-2023,2025-2042,2044-2099,2101-3001' --(Расходы общих отделов)
		,@CodeID1_distrShipments VARCHAR(MAX) = '3' --(Прибыль от отгрузки дистрибьюций)
		,@CodeID1_distrExpProject VARCHAR(MAX) = '2002-2005,2008-2023,2025-2042,2044-2099,2101-3001' --(Расходы дистрибьюций на проект)
		,@CodeID1_distrExp VARCHAR(MAX) = '2002-2005,2008-2023,2025-2042,2044-2099,2101-3001' --(Общие расходы дистрибьюций бизнеса)

        --Признак 2
		,@CodeID2_distrShipments VARCHAR(MAX) = '200' --(Прибыль от отгрузки дистрибьюций)

        --Признак 3
		,@CodeID3_distrShipments VARCHAR(MAX) = '141,143' --(Прибыль от отгрузки дистрибьюций)

        --Признак 4
		,@CodeID4_brand VARCHAR(MAX) = '2000-2029,2100-3000' --(Расходы бренда)
		,@CodeID4_license VARCHAR(MAX) = '2000-2029,2100-3000' --(Лицензия)
		,@CodeID4_credit VARCHAR(MAX) = '2000-2029,2100-3000' --(Проценты по кредитам)
		,@CodeID4_distrProfit VARCHAR(MAX) = '2000-2029,2100-3000' --(Курсовая прибыль от поставщиков)
		,@CodeID4_deptExp VARCHAR(MAX) = '2000-2029,2100-3000' --(Расходы общих отделов)
		,@CodeID4_distrExpProject VARCHAR(MAX) = '2030-2099' --(Расходы дистрибьюций на проект)
		,@CodeID4_distrExp VARCHAR(MAX) = '2030-2099' --(Общие расходы дистрибьюций бизнеса)

        --Признак 5
		,@CodeID5_brand VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(Расходы бренда)
		,@CodeID5_license VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(Лицензия)
		,@CodeID5_credit VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(Проценты по кредитам)
		,@CodeID5_distrProfit VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(Курсовая прибыль от поставщиков)
		,@CodeID5_deptExp VARCHAR(MAX) = '2006,2007,2008,2010,2018,2022' --(Расходы общих отделов)
		,@CodeID5_distrShipments VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(Прибыль от отгрузки дистрибьюций)
		,@CodeID5_distrExpProject VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(Расходы дистрибьюций на проект)
		,@CodeID5_distrExp VARCHAR(MAX) = '2006,2007,2008,2010,2018'; --(Общие расходы дистрибьюций бизнеса)
    END;

------------------------ТЕСТИРОВАНИЕ------------------------
/*
EXEC ap_CorpRep_6_1 '20180601','20180630'   
*/
--** TEST BEGIN
BEGIN --** блок для теста.
DECLARE @BDate SMALLDATETIME = '20180601';
DECLARE @EDate SMALLDATETIME = '20180630';

--** Тест для INSERT (BEGIN)
DELETE FROM #result WHERE PartID = 14
INSERT INTO #result SELECT * FROM (
SELECT 14 'PartID',0 Style,'Лицензии' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
    /*Расход (Факт) - Приход товара*/          
    /*SELECT rp.PGrID1, SUM(0-(d.Qty * t_PInP_146.CostMC)) 'SumMC'
    FROM av_t_Rec m WITH (NOLOCK)
        JOIN r_Ours r_Ours_22 WITH (NOLOCK) ON (r_Ours_22.OurID = m.OurID)
        JOIN r_Codes1 r_Codes1_42 WITH (NOLOCK) ON (r_Codes1_42.CodeID1 = m.CodeID1)
        JOIN r_Codes4 r_Codes4_72 WITH (NOLOCK) ON (r_Codes4_72.CodeID4 = m.CodeID4)
        JOIN r_Codes5 r_Codes5_82 WITH (NOLOCK) ON (r_Codes5_82.CodeID5 = m.CodeID5)
        JOIN av_t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_Deps r_Deps_241 WITH (NOLOCK) ON (r_Deps_241.DepID = m.DepID) -- r_Deps Справочник подразделений
        JOIN t_PInP t_PInP_146 WITH (NOLOCK) ON (t_PInP_146.PPID = d.PPID) AND (t_PInP_146.ProdID = d.ProdID)  
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = t_PInP_146.ProdID
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
    GROUP BY rp.PGrID1
    
    UNION ALL
    /*Расход (Факт) - Приход денег по предприятиям*/          
    SELECT rp.PGrID1, SUM(0-(m.SumAC / m.KursMC)) 'SumMC'
    FROM c_CompRec m WITH (NOLOCK) 
        JOIN r_Ours r_Ours_22 WITH (NOLOCK) ON (r_Ours_22.OurID = m.OurID)
        JOIN r_Codes1 r_Codes1_42 WITH (NOLOCK) ON (r_Codes1_42.CodeID1 = m.CodeID1)
        JOIN r_Codes4 r_Codes4_72 WITH (NOLOCK) ON (r_Codes4_72.CodeID4 = m.CodeID4)
        JOIN r_Codes5 r_Codes5_82 WITH (NOLOCK) ON (r_Codes5_82.CodeID5 = m.CodeID5)
        JOIN r_Deps r_Deps_241 WITH (NOLOCK) ON (r_Deps_241.DepID = m.DepID) -- r_Deps Справочник подразделений
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = t_PInP_146.ProdID
        JOIN r_ProdG1 rpg WITH(NOLOCK) ON (rpg.PGrID1 = rp.PGrID1)
        JOIN t_PInP t_PInP_146 WITH (NOLOCK) ON (t_PInP_146.PPID = rp.PPID) AND (t_PInP_146.ProdID = rp.ProdID)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
    GROUP BY rp.PGrID1
    
    UNION ALL
    /*Расход (Факт) - Прием наличных денег на склад*/          
    SELECT rp.PGrID1, SUM(0-(m.SumAC / m.KursMC)) 'SumMC'
    FROM av_t_MonRec m WITH (NOLOCK) 
        JOIN r_Ours r_Ours_22 WITH (NOLOCK) ON (r_Ours_22.OurID = m.OurID)
        JOIN r_Codes1 r_Codes1_42 WITH (NOLOCK) ON (r_Codes1_42.CodeID1 = m.CodeID1)
        JOIN r_Codes4 r_Codes4_72 WITH (NOLOCK) ON (r_Codes4_72.CodeID4 = m.CodeID4)
        JOIN r_Codes5 r_Codes5_82 WITH (NOLOCK) ON (r_Codes5_82.CodeID5 = m.CodeID5)
        JOIN av_t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN t_PInP t_PInP_146 WITH (NOLOCK) ON (t_PInP_146.PPID = d.PPID) AND (t_PInP_146.ProdID = d.ProdID)  
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = t_PInP_146.ProdID
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
    GROUP BY rp.PGrID1

    UNION ALL
    /*Расход (Факт) - Возврат товара от получателя*/          
    SELECT rp.PGrID1, SUM(0-(d.Qty * t_PInP_146.CostMC)) 'SumMC'
    FROM av_t_Ret m WITH (NOLOCK) 
        JOIN r_Ours r_Ours_22 WITH (NOLOCK) ON (r_Ours_22.OurID = m.OurID)
        JOIN r_Codes1 r_Codes1_42 WITH (NOLOCK) ON (r_Codes1_42.CodeID1 = m.CodeID1)
        JOIN r_Codes4 r_Codes4_72 WITH (NOLOCK) ON (r_Codes4_72.CodeID4 = m.CodeID4)
        JOIN r_Codes5 r_Codes5_82 WITH (NOLOCK) ON (r_Codes5_82.CodeID5 = m.CodeID5)
        JOIN av_t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN t_PInP t_PInP_146 WITH (NOLOCK) ON (t_PInP_146.PPID = d.PPID) AND (t_PInP_146.ProdID = d.ProdID)  
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = t_PInP_146.ProdID
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
    GROUP BY rp.PGrID1*/

    --UNION ALL
    /*Расход (Факт) - Расход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(m.SumAC * m.KursCC) 'SumMC'
    FROM av_c_CompExp m WITH (NOLOCK) 
        JOIN r_Ours r_Ours_22 WITH (NOLOCK) ON (r_Ours_22.OurID = m.OurID)
        JOIN r_Codes1 r_Codes1_42 WITH (NOLOCK) ON (r_Codes1_42.CodeID1 = m.CodeID1)
        JOIN r_Codes4 r_Codes4_72 WITH (NOLOCK) ON (r_Codes4_72.CodeID4 = m.CodeID4)
        JOIN r_Codes5 r_Codes5_82 WITH (NOLOCK) ON (r_Codes5_82.CodeID5 = m.CodeID5)
        JOIN r_Deps r_Deps_324 WITH (NOLOCK) ON (r_Deps_324.DepID = m.DepID)  
--        JOIN av_t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
--        JOIN t_PInP t_PInP_146 WITH (NOLOCK) ON (t_PInP_146.PPID = d.PPID) AND (t_PInP_146.ProdID = d.ProdID)  
--        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = t_PInP_146.ProdID
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
    GROUP BY rpg1.PGrID1
    
) AS SumMC
  
GROUP BY PGrID1
) AS m14

SELECT PartID '№', PartIDName 'Данные', [5],[4],[6],[3],[1],[100] FROM #result 
PIVOT ( 
MAX(TOTALS) FOR PGrID1 IN ([5],[4],[6],[3],[1],[100]) 
) as pvt
ORDER BY 1

END;
--** Тест для INSERT (END)

--создаем временную таблицу
IF 1 = 1 
BEGIN

IF OBJECT_ID('tempdb..#result', 'U') IS NOT NULL DROP TABLE #result;
CREATE TABLE #result (
     PartID TINYINT
    ,Style TINYINT
    ,PartIDName VARCHAR(max)
    ,PGrID1 TINYINT
    ,TOTALS NUMERIC(21,9)
    );

--1---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Объем продаж, в бут. (шт.)

INSERT INTO #result SELECT * FROM (
  SELECT 1 'PartID',0 Style,'Объем продаж, в бут. (шт.)' 'PartIDName', PGrID1, ROUND(SUM(TQty),0) 'TOTALS' FROM (
    /*Накладные - Расходная накладная*/    
    SELECT r_Prods_112.PGrID1, SUM(t_InvD_8.Qty) 'TQty' 
    FROM av_t_Inv t_Inv_7 WITH(NOLOCK)
    INNER JOIN av_t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID)
    INNER JOIN t_PInP t_PInP_111 WITH(NOLOCK) ON (t_InvD_8.PPID=t_PInP_111.PPID AND t_InvD_8.ProdID=t_PInP_111.ProdID)
    INNER JOIN r_Prods r_Prods_112 WITH(NOLOCK) ON (t_PInP_111.ProdID=r_Prods_112.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_132 WITH(NOLOCK) ON (r_Prods_112.ProdID=r_ProdMP_132.ProdID AND 106=r_ProdMP_132.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_112.PGrID1

      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](r_Prods_112.PGrID1,@PGrID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Inv_7.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Inv_7.OurID,@OurID,',')) = 1
      AND t_Inv_7.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_112.PGrID1

UNION ALL
  
    /*Расход - Расходный документ*/    
    SELECT r_Prods_116.PGrID1, SUM(t_ExpD_10.Qty) 'TQty'
    FROM av_t_Exp t_Exp_9 WITH(NOLOCK)
    INNER JOIN av_t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID)
    INNER JOIN t_PInP t_PInP_115 WITH(NOLOCK) ON (t_ExpD_10.PPID=t_PInP_115.PPID AND t_ExpD_10.ProdID=t_PInP_115.ProdID)
    INNER JOIN r_Prods r_Prods_116 WITH(NOLOCK) ON (t_PInP_115.ProdID=r_Prods_116.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_133 WITH(NOLOCK) ON (r_Prods_116.ProdID=r_ProdMP_133.ProdID AND 106=r_ProdMP_133.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_116.PGrID1

      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](r_Prods_116.PGrID1,@PGrID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Exp_9.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Exp_9.OurID,@OurID,',')) = 1
      AND t_Exp_9.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_116.PGrID1

UNION ALL

    /*Возврат от получателя - Возврат товара от получателя*/
    SELECT r_Prods_80.PGrID1, -SUM(t_RetD_4.Qty) 'TQty' 
    FROM av_t_Ret t_Ret_3 WITH(NOLOCK) 
    INNER JOIN av_t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID)
    INNER JOIN t_PInP t_PInP_79 WITH(NOLOCK) ON (t_RetD_4.PPID=t_PInP_79.PPID AND t_RetD_4.ProdID=t_PInP_79.ProdID)
    INNER JOIN r_Prods r_Prods_80 WITH(NOLOCK) ON (t_PInP_79.ProdID=r_Prods_80.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_124 WITH(NOLOCK) ON (r_Prods_80.ProdID=r_ProdMP_124.ProdID AND 106=r_ProdMP_124.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_80.PGrID1

      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](r_Prods_80.PGrID1,@PGrID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Ret_3.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Ret_3.OurID,@OurID,',')) = 1
      AND t_Ret_3.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_80.PGrID1

) AS salesQty  
GROUP BY PGrID1
) AS m1
           
--2---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Объем продаж, $ в ценах отгрузки

INSERT INTO #result SELECT * FROM (
SELECT 2 'PartID',0 Style,'Объем продаж, $ в ценах отгрузки' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
    /*Накладные - Расходная накладная*/    
    SELECT r_Prods_112.PGrID1, SUM(t_InvD_8.SumCC_wt / t_Inv_7.KursMC) 'SumMC'
    FROM av_t_Inv t_Inv_7 WITH(NOLOCK)
    INNER JOIN av_t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID)
    INNER JOIN t_PInP t_PInP_111 WITH(NOLOCK) ON (t_InvD_8.PPID=t_PInP_111.PPID AND t_InvD_8.ProdID=t_PInP_111.ProdID)
    INNER JOIN r_Prods r_Prods_112 WITH(NOLOCK) ON (t_PInP_111.ProdID=r_Prods_112.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_132 WITH(NOLOCK) ON (r_Prods_112.ProdID=r_ProdMP_132.ProdID AND 106=r_ProdMP_132.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_112.PGrID1

      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](r_Prods_112.PGrID1,@PGrID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Inv_7.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Inv_7.OurID,@OurID,',')) = 1
      AND t_Inv_7.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_112.PGrID1

UNION ALL
  
    /*Расход - Расходный документ*/    
    SELECT r_Prods_116.PGrID1, SUM(t_ExpD_10.SumCC_wt / t_Exp_9.KursMC) 'SumMC'
    FROM av_t_Exp t_Exp_9 WITH(NOLOCK)
    INNER JOIN av_t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID)
    INNER JOIN t_PInP t_PInP_115 WITH(NOLOCK) ON (t_ExpD_10.PPID=t_PInP_115.PPID AND t_ExpD_10.ProdID=t_PInP_115.ProdID)
    INNER JOIN r_Prods r_Prods_116 WITH(NOLOCK) ON (t_PInP_115.ProdID=r_Prods_116.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_133 WITH(NOLOCK) ON (r_Prods_116.ProdID=r_ProdMP_133.ProdID AND 106=r_ProdMP_133.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_116.PGrID1

      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](r_Prods_116.PGrID1,@PGrID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Exp_9.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Exp_9.OurID,@OurID,',')) = 1
      AND t_Exp_9.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_116.PGrID1

UNION ALL

    /*Возврат от получателя - Возврат товара от получателя*/
    SELECT r_Prods_80.PGrID1, -SUM(t_RetD_4.SumCC_wt / t_Ret_3.KursMC) 'SumMC'
    FROM av_t_Ret t_Ret_3 WITH(NOLOCK) 
    INNER JOIN av_t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID)
    INNER JOIN t_PInP t_PInP_79 WITH(NOLOCK) ON (t_RetD_4.PPID=t_PInP_79.PPID AND t_RetD_4.ProdID=t_PInP_79.ProdID)
    INNER JOIN r_Prods r_Prods_80 WITH(NOLOCK) ON (t_PInP_79.ProdID=r_Prods_80.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_124 WITH(NOLOCK) ON (r_Prods_80.ProdID=r_ProdMP_124.ProdID AND 106=r_ProdMP_124.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_80.PGrID1

      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](r_Prods_80.PGrID1,@PGrID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Ret_3.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Ret_3.OurID,@OurID,',')) = 1
      AND t_Ret_3.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_80.PGrID1

) AS salesSumMC  
GROUP BY PGrID1
) AS m2

                         
--3---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Доля в продажах,%

INSERT INTO #result SELECT * FROM (
SELECT 3 'PartID', 0 Style,'Доля в продажах,%' 'PartIDName', PGrID1, 
ROUND(TOTALS / (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 2 AND PGrID1 <> 100) * 100, 0) 'TOTALS'
FROM #result
WHERE PartID = 2
) AS m3


/*Пункты 5 и 4 меняем местами, т.к. 4-й считается из 5-го.*/
--5---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Объем продаж по себестоимости $

INSERT INTO #result SELECT * FROM (
SELECT 5 'PartID',0 Style,'Объем продаж по себестоимости $' 'PartIDName', PGrID1, ROUND(SUM(SumMC_Cost),0) 'SumMC_Cost' FROM (
    /*Накладные - Расходная накладная*/    
    SELECT r_Prods_112.PGrID1, SUM(t_InvD_8.Qty * t_PInP_111.CostMC) 'SumMC_Cost'
    FROM av_t_Inv t_Inv_7 WITH(NOLOCK)
    INNER JOIN av_t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID)
    INNER JOIN t_PInP t_PInP_111 WITH(NOLOCK) ON (t_InvD_8.PPID=t_PInP_111.PPID AND t_InvD_8.ProdID=t_PInP_111.ProdID)
    INNER JOIN r_Prods r_Prods_112 WITH(NOLOCK) ON (t_PInP_111.ProdID=r_Prods_112.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_132 WITH(NOLOCK) ON (r_Prods_112.ProdID=r_ProdMP_132.ProdID AND 106=r_ProdMP_132.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_112.PGrID1

      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](r_Prods_112.PGrID1,@PGrID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Inv_7.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Inv_7.OurID,@OurID,',')) = 1
      AND t_Inv_7.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_112.PGrID1

UNION ALL
  
    /*Расход - Расходный документ*/    
    SELECT r_Prods_116.PGrID1, SUM(t_ExpD_10.Qty * t_PInP_115.CostMC) 'SumMC_Cost'
    FROM av_t_Exp t_Exp_9 WITH(NOLOCK)
    INNER JOIN av_t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID)
    INNER JOIN t_PInP t_PInP_115 WITH(NOLOCK) ON (t_ExpD_10.PPID=t_PInP_115.PPID AND t_ExpD_10.ProdID=t_PInP_115.ProdID)
    INNER JOIN r_Prods r_Prods_116 WITH(NOLOCK) ON (t_PInP_115.ProdID=r_Prods_116.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_133 WITH(NOLOCK) ON (r_Prods_116.ProdID=r_ProdMP_133.ProdID AND 106=r_ProdMP_133.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_116.PGrID1

      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](r_Prods_116.PGrID1,@PGrID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Exp_9.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Exp_9.OurID,@OurID,',')) = 1
      AND t_Exp_9.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_116.PGrID1

UNION ALL

    /*Возврат от получателя - Возврат товара от получателя*/
    SELECT r_Prods_80.PGrID1, -SUM(t_RetD_4.Qty * t_PInP_79.CostMC) 'SumMC_Cost'
    FROM av_t_Ret t_Ret_3 WITH(NOLOCK) 
    INNER JOIN av_t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID)
    INNER JOIN t_PInP t_PInP_79 WITH(NOLOCK) ON (t_RetD_4.PPID=t_PInP_79.PPID AND t_RetD_4.ProdID=t_PInP_79.ProdID)
    INNER JOIN r_Prods r_Prods_80 WITH(NOLOCK) ON (t_PInP_79.ProdID=r_Prods_80.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_124 WITH(NOLOCK) ON (r_Prods_80.ProdID=r_ProdMP_124.ProdID AND 106=r_ProdMP_124.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_80.PGrID1

      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](r_Prods_80.PGrID1,@PGrID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Ret_3.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Ret_3.OurID,@OurID,',')) = 1
      AND t_Ret_3.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_80.PGrID1

) AS SumMC_Cost  
GROUP BY PGrID1
) AS m5

/*Пункты 5 и 4 меняем местами, т.к. 4-й считается из 5-го.*/
--4---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--% общей наценки

INSERT INTO #result SELECT * FROM (
SELECT 4 'PartID', 0 Style,'% общей наценки' 'PartIDName', r2.PGrID1, ROUND(((r2.TOTALS / r5.TOTALS - 1) * 100),0) 'TOTALS' FROM #result r2,#result r5 WHERE r2.PGrID1 = r5.PGrID1 AND r2.PartID = 2 and r5.PartID = 5
) AS m4

--6---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ср. цена продажи 1 бут. ($)

INSERT INTO #result SELECT * FROM (
SELECT 6 'PartID', 0 Style,'ср. цена продажи 1 бут. ($)' 'PartIDName', r2.PGrID1, ROUND((r2.TOTALS / r1.TOTALS),2) 'TOTALS' FROM #result r2,#result r1 WHERE r2.PGrID1 = r1.PGrID1 AND r2.PartID = 2 and r1.PartID = 1
) AS m6


--7---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ср. цена продажи 1 бут. ($)

INSERT INTO #result SELECT * FROM (
SELECT 7 'PartID', 0 Style,'ср. с/с 1 бут. ($)' 'PartIDName', r1.PGrID1, ROUND((r5.TOTALS / r1.TOTALS),2) 'TOTALS' FROM #result r5,#result r1 WHERE r5.PGrID1 = r1.PGrID1 AND r5.PartID = 5 and r1.PartID = 1
) AS m7

--8---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Складские запасы (Алкоголь), в бут. (шт.)

INSERT INTO #result SELECT * FROM (
SELECT 8 'PartID',0 Style,'Складские запасы (Алкоголь), в бут. (шт.)' 'PartIDName', PGrID1, ROUND(SUM(SumQty),0) 'SumQty' FROM (
          
          /*Остатки на конец периода*/          
          SELECT rp.PGrID1, SUM(m.Qty) 'SumQty'
          FROM dbo.af_CalcRemDByRemIM (@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](rp.PGrID1,@PGrID1_alcohol,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](rp.PCatID,@PCatID_alcohol,',')) = 1
          GROUP BY rp.PGrID1
) AS SumQty  
GROUP BY PGrID1
) AS m8

--9---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Складские запасы (Алкоголь), в ценах себ-сти

INSERT INTO #result SELECT * FROM (
SELECT 9 'PartID',0 Style,'Складские запасы (Алкоголь), в ценах себ-сти' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
          /*Остатки на конец периода*/          
          SELECT rp.PGrID1, SUM(m.Qty * tp.CostMC) 'SumMC'
          FROM dbo.af_CalcRemDByRemIM (@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](rp.PGrID1,@PGrID1_alcohol,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](rp.PCatID,@PCatID_alcohol,',')) = 1
          GROUP BY rp.PGrID1

) AS SumMC  
GROUP BY PGrID1
) AS m9


--10---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Складские запасы (Реклама), в ценах себ-сти

INSERT INTO #result SELECT * FROM (
SELECT 10 'PartID',0 Style,'Складские запасы (Реклама), в ценах себ-сти' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
          /*Остатки на конец периода*/          
          SELECT rp.PGrID1, SUM(m.Qty * tp.CostMC) 'SumMC'
          FROM dbo.af_CalcRemDByRemIM (@EDate) m
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = m.ProdID AND tp.PPID = m.PPID
      WHERE
      (SELECT [dbo].[zf_MatchFilterInt](rp.PGrID1,@PGrID1_ads,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](rp.PCatID,@PCatID_ads,',')) = 1
          GROUP BY rp.PGrID1

) AS SumQty  
GROUP BY PGrID1
) AS m10

--11---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Оборачиваемость складских запасов (Алкоголь), мес

IF OBJECT_ID('tempdb..#result_temp', 'U') IS NOT NULL DROP TABLE #result_temp;
    SELECT TOP 0 * INTO #result_temp FROM #result;

    INSERT INTO #result_temp SELECT * FROM ( --#result_temp - промежуточная таблица.
    SELECT 11 'PartID',0 Style,'Оборачиваемость складских запасов (Алкоголь), мес' 'PartIDName', PGrID1, ROUND(SUM(SumQty),0) / 2 'SumQty' 
    FROM (
              /*Остатки (количество) на начало периода*/          
              SELECT rp.PGrID1, SUM(m.Qty) 'SumQty'
              FROM dbo.af_CalcRemDByRemIM (@BDate) m
              JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          WHERE
          (SELECT [dbo].[zf_MatchFilterInt](rp.PGrID1,@PGrID1_alcohol,',')) = 1
          AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
          AND (SELECT [dbo].[zf_MatchFilterInt](rp.PCatID,@PCatID_alcohol,',')) = 1
              GROUP BY rp.PGrID1
          UNION ALL
              /*Остатки (количество) на конец периода*/          
              SELECT rp.PGrID1, SUM(m.Qty) 'SumQty'
              FROM dbo.af_CalcRemDByRemIM (@EDate) m
              JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = m.ProdID
          WHERE
          (SELECT [dbo].[zf_MatchFilterInt](rp.PGrID1,@PGrID1_alcohol,',')) = 1
          AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
          AND (SELECT [dbo].[zf_MatchFilterInt](rp.PCatID,@PCatID_alcohol,',')) = 1
              GROUP BY rp.PGrID1
    ) AS r11_temp
    GROUP BY PGrID1
    ) AS m11_temp

    INSERT INTO #result SELECT * FROM (
    SELECT 11 'PartID', 0 Style,'Оборачиваемость складских запасов (Алкоголь), мес' 'PartIDName', r11.PGrID1, ROUND((r11.TOTALS / r1.TOTALS),0) 'TOTALS' 
    FROM #result_temp r11, #result r1 
    WHERE r11.PGrID1 = r1.PGrID1 AND r11.PartID = 11 and r1.PartID = 1
    ) AS m11

--12---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Прибыль от отгрузки

INSERT INTO #result SELECT * FROM (
SELECT 12 'PartID', 0 Style,'Прибыль от отгрузки' 'PartIDName', r2.PGrID1, ROUND((r2.TOTALS - r5.TOTALS),0) 'TOTALS' FROM #result r2,#result r5 WHERE r2.PGrID1 = r5.PGrID1 AND r2.PartID = 2 and r5.PartID = 5
) AS m4

--13---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Расходы бренда
--к этому пункту вернемся позже..

--RESULT----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Добавляем Итого

INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (1, 0, 'Объем продаж, в бут. (шт.)', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 1)) 
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (2, 0, 'Объем продаж, $ в ценах отгрузки', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 2))             
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (3, 0, 'Доля в продажах,%', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 3))         

/*Пункты 5 и 4 меняем местами, т.к. 4-й считается из 5-го.*/
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (5, 0, 'Объем продаж по себестоимости $', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 5))                        
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (4, 0, '% общей наценки', 100, (SELECT ((SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 2) / (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 5) - 1) * 100))         

INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (6, 0, 'ср. цена продажи 1 бут. ($)', 100, (SELECT ( (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 2) / (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 1) )))         
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (7, 0, 'ср. с/с 1 бут. ($)', 100, (SELECT ( (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 5) / (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 1) )))         
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (8, 0, 'Складские запасы (Алкоголь), в бут. (шт.)', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 8))                        
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (9, 0, 'Складские запасы (Алкоголь), в ценах себ-сти', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 9))                        
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (10, 0, 'Складские запасы (Реклама), в ценах себ-сти', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 10))
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (11, 0, 'Оборачиваемость складских запасов (Алкоголь), мес', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 11))                          
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (12, 0, 'Прибыль от отгрузки', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 12))                          
--к п.13 этому пункту вернемся позже..
INSERT INTO #result (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (14, 0, 'Лицензии', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM #result WHERE PartID = 14))                          


--Делаем разворот                                               
SELECT PartID '№', PartIDName 'Данные', [5],[4],[6],[3],[1],[100] FROM #result 
PIVOT ( 
MAX(TOTALS) FOR PGrID1 IN ([5],[4],[6],[3],[1],[100]) 
) as pvt
ORDER BY 1
--END для теста.
END;
--END процедуры.
END;



GO
