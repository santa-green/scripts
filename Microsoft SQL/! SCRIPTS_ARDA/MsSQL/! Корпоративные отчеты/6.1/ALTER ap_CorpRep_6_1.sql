ALTER PROCEDURE [dbo].[ap_CorpRep_6_1] 
(
   @BDate SMALLDATETIME
  ,@EDate SMALLDATETIME
)
AS
------------------------------------------------------------

BEGIN
  SET NOCOUNT ON
--********* Тест для INSERT (BEGIN)
--EXEC ap_CorpRep_6_1 '20180601','20180630'

    BEGIN --блок объявления переменных
        DECLARE
--1,2,3,4,5...начинаем объявлять...

        /*Общее*/
         @OurID VARCHAR(MAX)   = '1-5,11'-- внутрення фирма (Общий фильтр)
        ,@PCatID_alcohol VARCHAR(MAX) = '1-100' --код категории (Складские запасы (Алкоголь))
        ,@PCatID_ads VARCHAR(MAX) = '500' --код категории (Складские запасы (Реклама))
        ,@PLID VARCHAR(MAX) = '106' --прайс-лист
        ,@CurCurs as numeric(10,2) = (select dbo.zf_GetRateMC(dbo.zf_GetCurrCC())) --на 31.01.2020 курс $ 25
        
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

/*BEGIN --** блок для теста (+захватить блок переменных выше).
/*DECLARE @BDate SMALLDATETIME = '20180601';
DECLARE @EDate SMALLDATETIME = '20180630';*/
--0
--DELETE FROM temp_corp_6_1 WHERE PartID IN (26)

SELECT PartID '№', PartIDName 'Данные', [5],[4],[6],[3],[1],[100] FROM temp_corp_6_1 
PIVOT ( 
MAX(TOTALS) FOR PGrID1 IN ([5],[4],[6],[3],[1],[100]) 
) as pvt
ORDER BY 1

END;
--********* Тест для INSERT (END)
*/
IF 1 = 1 
BEGIN

--создаем временную таблицу
IF OBJECT_ID('Elit..temp_corp_6_1', 'U') IS NOT NULL DROP TABLE temp_corp_6_1;
CREATE TABLE temp_corp_6_1 (
     PartID TINYINT
    ,Style TINYINT
    ,PartIDName VARCHAR(max)
    ,PGrID1 TINYINT
    ,TOTALS NUMERIC(21,9)
    );

--1---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Объем продаж, в бут. (шт.)

INSERT INTO temp_corp_6_1 SELECT * FROM (
  SELECT 1 'PartID',0 Style,'Объем продаж, в бут. (шт.)' 'PartIDName', PGrID1, ROUND(SUM(TQty),0) 'TOTALS' FROM (
    /*Накладные - Расходная накладная*/    
    SELECT r_Prods_112.PGrID1, SUM(t_InvD_8.Qty) 'TQty' 
    FROM t_Inv t_Inv_7 WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
    INNER JOIN t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID) --t_InvD	Расходная накладная: Товар view: av_t_InvD
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
    FROM t_Exp t_Exp_9 WITH(NOLOCK) --t_Exp	Расходный документ: Заголовок view: av_t_Exp
    INNER JOIN t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID) --t_ExpD	Расходный документ: Товар view: av_t_ExpD
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
    FROM t_Ret t_Ret_3 WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок view: av_t_Ret
    INNER JOIN t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID) --t_RetD	Возврат товара от получателя: Товар view: av_t_RetD
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
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (1, 0, 'Объем продаж, в бут. (шт.)', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 1)) 
           
--2---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Объем продаж, $ в ценах отгрузки

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 2 'PartID',0 Style,'Объем продаж, $ в ценах отгрузки' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
    /*Накладные - Расходная накладная*/    
    SELECT r_Prods_112.PGrID1, SUM(t_InvD_8.SumCC_wt / t_Inv_7.KursMC) 'SumMC'
    FROM t_Inv t_Inv_7 WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
    INNER JOIN t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID) --t_InvD	Расходная накладная: Товар view: av_t_InvD
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
    FROM t_Exp t_Exp_9 WITH(NOLOCK) --t_Exp	Расходный документ: Заголовок view: av_t_Exp
    INNER JOIN t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID) --t_ExpD	Расходный документ: Товар view: av_t_ExpD
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
    FROM t_Ret t_Ret_3 WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок view: av_t_Ret
    INNER JOIN t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID) --t_RetD	Возврат товара от получателя: Товар view: av_t_RetD
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
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (2, 0, 'Объем продаж, $ в ценах отгрузки', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 2))             
                         
--3---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Доля в продажах,%

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 3 'PartID', 0 Style,'Доля в продажах,%' 'PartIDName', PGrID1, 
ROUND(TOTALS / (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 2 AND PGrID1 <> 100) * 100, 0) 'TOTALS'
FROM temp_corp_6_1
WHERE PartID = 2
) AS m3
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (3, 0, 'Доля в продажах,%', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 3))         


/*Пункты 5 и 4 меняем местами, т.к. 4-й считается из 5-го.*/
--5---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Объем продаж по себестоимости $

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 5 'PartID',0 Style,'Объем продаж по себестоимости $' 'PartIDName', PGrID1, ROUND(SUM(SumMC_Cost),0) 'SumMC_Cost' FROM (
    /*Накладные - Расходная накладная*/    
    SELECT r_Prods_112.PGrID1, SUM(t_InvD_8.Qty * t_PInP_111.CostMC) 'SumMC_Cost'
    FROM t_Inv t_Inv_7 WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
    INNER JOIN t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID) --t_InvD	Расходная накладная: Товар view: av_t_InvD
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
    FROM t_Exp t_Exp_9 WITH(NOLOCK) --t_Exp	Расходный документ: Заголовок view: av_t_Exp
    INNER JOIN t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID) --t_ExpD	Расходный документ: Товар view: av_t_ExpD
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
    FROM t_Ret t_Ret_3 WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок view: av_t_Ret
    INNER JOIN t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID) --t_RetD	Возврат товара от получателя: Товар view: av_t_RetD
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
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (5, 0, 'Объем продаж по себестоимости $', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 5))                        


/*Пункты 5 и 4 меняем местами, т.к. 4-й считается из 5-го.*/
--4---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--% общей наценки

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 4 'PartID', 0 Style,'% общей наценки' 'PartIDName', r2.PGrID1, ROUND(((r2.TOTALS / r16.TOTALS - 1) * 100),0) 'TOTALS' FROM temp_corp_6_1 r2,temp_corp_6_1 r16 WHERE r2.PGrID1 = r16.PGrID1 AND r2.PartID = 2 and r16.PartID = 5
) AS m4
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (4, 0, '% общей наценки', 100, (SELECT ((SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 2) / (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 5) - 1) * 100))         


--6---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ср. цена продажи 1 бут. ($)

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 6 'PartID', 0 Style,'ср. цена продажи 1 бут. ($)' 'PartIDName', r2.PGrID1, ROUND((r2.TOTALS / r1.TOTALS),2) 'TOTALS' FROM temp_corp_6_1 r2,temp_corp_6_1 r1 WHERE r2.PGrID1 = r1.PGrID1 AND r2.PartID = 2 and r1.PartID = 1
) AS m6
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (6, 0, 'ср. цена продажи 1 бут. ($)', 100, (SELECT ( (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 2) / (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 1) )))         


--7---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ср. цена продажи 1 бут. ($)

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 7 'PartID', 0 Style,'ср. с/с 1 бут. ($)' 'PartIDName', r1.PGrID1, ROUND((r5.TOTALS / r1.TOTALS),2) 'TOTALS' FROM temp_corp_6_1 r5,temp_corp_6_1 r1 WHERE r5.PGrID1 = r1.PGrID1 AND r5.PartID = 5 and r1.PartID = 1
) AS m7
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (7, 0, 'ср. с/с 1 бут. ($)', 100, (SELECT ( (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 5) / (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 1) )))         

--8---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Складские запасы (Алкоголь), в бут. (шт.)

INSERT INTO temp_corp_6_1 SELECT * FROM (
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
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (8, 0, 'Складские запасы (Алкоголь), в бут. (шт.)', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 8))                        

--9---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Складские запасы (Алкоголь), в ценах себ-сти

INSERT INTO temp_corp_6_1 SELECT * FROM (
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
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (9, 0, 'Складские запасы (Алкоголь), в ценах себ-сти', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 9))                        


--10---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Складские запасы (Реклама), в ценах себ-сти

INSERT INTO temp_corp_6_1 SELECT * FROM (
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
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (10, 0, 'Складские запасы (Реклама), в ценах себ-сти', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 10))

--11---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Оборачиваемость складских запасов (Алкоголь), мес

IF OBJECT_ID('Elit..temp_corp_6_1_temp', 'U') IS NOT NULL DROP TABLE temp_corp_6_1_temp;
    SELECT TOP 0 * INTO temp_corp_6_1_temp FROM temp_corp_6_1;

    INSERT INTO temp_corp_6_1_temp SELECT * FROM ( --temp_corp_6_1_temp - промежуточная таблица.
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

    INSERT INTO temp_corp_6_1 SELECT * FROM (
    SELECT 11 'PartID', 0 Style,'Оборачиваемость складских запасов (Алкоголь), мес' 'PartIDName', r11.PGrID1, ROUND((r11.TOTALS / r1.TOTALS),1) 'TOTALS' 
    FROM temp_corp_6_1_temp r11, temp_corp_6_1 r1 
    WHERE r11.PGrID1 = r1.PGrID1 AND r11.PartID = 11 and r1.PartID = 1
    ) AS m11
    
    INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (11, 0, 'Оборачиваемость складских запасов (Алкоголь), мес', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 11))                          

--12---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Прибыль от отгрузки

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 12 'PartID', 0 Style,'Прибыль от отгрузки' 'PartIDName', r2.PGrID1, ROUND((r2.TOTALS - r5.TOTALS),0) 'TOTALS' FROM temp_corp_6_1 r2,temp_corp_6_1 r5 WHERE r2.PGrID1 = r5.PGrID1 AND r2.PartID = 2 and r5.PartID = 5
) AS m12
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (12, 0, 'Прибыль от отгрузки', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 12))

--13---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Расходы бренда

--таблицу temp_corp_6_1_BRAND используем как промежуточную, где берем значение поля TOTALS (PGrID1 = 1) и распределяем на остальные группы. 
--Танцюра: Расходы, которые попадают на пр.5=2012 нужно перераспределить между остальными проектами в процентном соотношении по объёмам продаж (п.2). 
--По проекту 2012 оставляем только ту сумму, что получилась после распределения, а на другие проекты добавляем суммы, которые получились по распределению, к суммам по анализатору.

IF OBJECT_ID('Elit..temp_corp_6_1_BRAND', 'U') IS NOT NULL DROP TABLE temp_corp_6_1_BRAND;
    SELECT TOP 0 * INTO temp_corp_6_1_BRAND FROM temp_corp_6_1;

INSERT INTO temp_corp_6_1_BRAND SELECT * FROM ( 
SELECT 13 'PartID', 0 Style, 'Расходы бренда' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
    /*Расход (Факт) - Расход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(m.SumAC / m.KursMC) 'SumMC'
    FROM c_CompExp m WITH (NOLOCK) --c_CompExp	Расход денег по предприятиям view: av_c_CompExp
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(0-(m.SumAC / m.KursMC)) 'SumMC'
    FROM c_CompRec m WITH (NOLOCK) --c_CompRec	Приход денег по предприятиям view: av_c_CompRec
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Расход)*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Приход)*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	Нов Партия
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходная накладная*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Inv m WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
        JOIN t_InvD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Exp m WITH(NOLOCK)
        JOIN t_ExpD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ в ценах прихода*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Epp m WITH(NOLOCK) --t_Epp	Расходный документ в ценах прихода: Заголовок
        JOIN t_EppD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход товара*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Rec m WITH(NOLOCK) --t_Rec	Приход товара: Заголовок
        JOIN t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RecD	Приход товара: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

        UNION ALL
    /*Расход (Факт) - Возврат товара от получателя*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Ret m WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок
        JOIN t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RetD	Возврат товара от получателя: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Возврат товара поставщику*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_CRet m WITH(NOLOCK) --t_CRet	Возврат товара поставщику: Заголовок
        JOIN t_CRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRetD	Возврат товара поставщику: Товары
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_brand,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1
   
) AS SumMC
  
GROUP BY PGrID1
) AS m14

SELECT * INTO #tc61 FROM (
SELECT 
    r2.TOTALS / (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 2 AND PGrID1 = 100) * (SELECT TOTALS FROM temp_corp_6_1_BRAND WHERE PartID = 13 AND PGrID1 = 1) AS SumToDistr
    , r2.PGrID1
FROM temp_corp_6_1 r2, temp_corp_6_1 rt
WHERE (r2.PartID = 2 AND rt.PartID = 2) AND (r2.PGrID1 = rt.PGrID1) AND rt.PGrID1 <> 100
) AS tc61

UPDATE m
SET TOTALS += ISNULL(t.SumToDistr,0)
FROM temp_corp_6_1_BRAND m
JOIN #tc61 AS t ON t.PGrID1 = m.PGrID1
WHERE m.PGrID1 != 1

UPDATE m
SET TOTALS = t.SumToDistr
FROM temp_corp_6_1_BRAND m
JOIN #tc61 as t ON t.PGrID1 = m.PGrID1
WHERE m.PGrID1 = 1

INSERT INTO temp_corp_6_1 
SELECT * FROM temp_corp_6_1_BRAND
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (13, 0, 'Расходы бренда', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 13))


--14---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Лицензии

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 14 'PartID', 0 Style, 'Лицензии' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
    /*Расход (Факт) - Расход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(m.SumAC / m.KursMC) 'SumMC'
    FROM c_CompExp m WITH (NOLOCK) --c_CompExp	Расход денег по предприятиям view: av_c_CompExp
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(0-(m.SumAC / m.KursMC)) 'SumMC'
    FROM c_CompRec m WITH (NOLOCK) --c_CompRec	Приход денег по предприятиям view: av_c_CompRec
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Расход)*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Приход)*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	Нов Партия
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходная накладная*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Inv m WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
        JOIN t_InvD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Exp m WITH(NOLOCK)
        JOIN t_ExpD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ в ценах прихода*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Epp m WITH(NOLOCK) --t_Epp	Расходный документ в ценах прихода: Заголовок
        JOIN t_EppD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход товара*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Rec m WITH(NOLOCK) --t_Rec	Приход товара: Заголовок
        JOIN t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RecD	Приход товара: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

        UNION ALL
    /*Расход (Факт) - Возврат товара от получателя*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Ret m WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок
        JOIN t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RetD	Возврат товара от получателя: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Возврат товара поставщику*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_CRet m WITH(NOLOCK) --t_CRet	Возврат товара поставщику: Заголовок
        JOIN t_CRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRetD	Возврат товара поставщику: Товары
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_license,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1
   
) AS SumMC
  
GROUP BY PGrID1
) AS m14
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (14, 0, 'Лицензии', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 14))                          

--15---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Проценты по кредитам

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 15 'PartID', 0 Style, 'Проценты по кредитам' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
    /*Расход (Факт) - Расход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(m.SumAC / m.KursMC) 'SumMC'
    FROM c_CompExp m WITH (NOLOCK) --c_CompExp	Расход денег по предприятиям view: av_c_CompExp
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(0-(m.SumAC / m.KursMC)) 'SumMC'
    FROM c_CompRec m WITH (NOLOCK) --c_CompRec	Приход денег по предприятиям view: av_c_CompRec
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Расход)*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Приход)*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	Нов Партия
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходная накладная*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Inv m WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
        JOIN t_InvD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Exp m WITH(NOLOCK)
        JOIN t_ExpD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ в ценах прихода*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Epp m WITH(NOLOCK) --t_Epp	Расходный документ в ценах прихода: Заголовок
        JOIN t_EppD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход товара*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Rec m WITH(NOLOCK) --t_Rec	Приход товара: Заголовок
        JOIN t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RecD	Приход товара: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

        UNION ALL
    /*Расход (Факт) - Возврат товара от получателя*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Ret m WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок
        JOIN t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RetD	Возврат товара от получателя: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Возврат товара поставщику*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_CRet m WITH(NOLOCK) --t_CRet	Возврат товара поставщику: Заголовок
        JOIN t_CRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRetD	Возврат товара поставщику: Товары
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_credit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1
   
) AS SumMC
  
GROUP BY PGrID1
) AS m15
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (15, 0, 'Проценты по кредитам', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 15))                          

--16---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Курсовая прибыль от поставщиков

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 16 'PartID', 0 Style, 'Курсовая прибыль от поставщиков' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
    /*Расход (Факт) - Расход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(m.SumAC / m.KursMC) 'SumMC'
    FROM c_CompExp m WITH (NOLOCK) --c_CompExp	Расход денег по предприятиям view: av_c_CompExp
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(0-(m.SumAC / m.KursMC)) 'SumMC'
    FROM c_CompRec m WITH (NOLOCK) --c_CompRec	Приход денег по предприятиям view: av_c_CompRec
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Расход)*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Приход)*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	Нов Партия
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходная накладная*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Inv m WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
        JOIN t_InvD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Exp m WITH(NOLOCK)
        JOIN t_ExpD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ в ценах прихода*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Epp m WITH(NOLOCK) --t_Epp	Расходный документ в ценах прихода: Заголовок
        JOIN t_EppD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход товара*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Rec m WITH(NOLOCK) --t_Rec	Приход товара: Заголовок
        JOIN t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RecD	Приход товара: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

        UNION ALL
    /*Расход (Факт) - Возврат товара от получателя*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Ret m WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок
        JOIN t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RetD	Возврат товара от получателя: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Возврат товара поставщику*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_CRet m WITH(NOLOCK) --t_CRet	Возврат товара поставщику: Заголовок
        JOIN t_CRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRetD	Возврат товара поставщику: Товары
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrProfit,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1
   
) AS SumMC
  
GROUP BY PGrID1
) AS m16
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (16, 0, 'Курсовая прибыль от поставщиков', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 16))                         

--17---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Операционная прибыль

BEGIN --Вставка '0'
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 16 AND PGrID1 = 1) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (16, 0, 'Курсовая прибыль от поставщиков', 1, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 16 AND PGrID1 = 3) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (16, 0, 'Курсовая прибыль от поставщиков', 3, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 16 AND PGrID1 = 4) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (16, 0, 'Курсовая прибыль от поставщиков', 4, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 16 AND PGrID1 = 5) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (16, 0, 'Курсовая прибыль от поставщиков', 5, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 16 AND PGrID1 = 6) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (16, 0, 'Курсовая прибыль от поставщиков', 6, 0)
END;

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 17 'PartID', 0 Style,'Операционная прибыль' 'PartIDName', r12.PGrID1, ROUND((ISNULL(r12.TOTALS,0) - ISNULL(r13.TOTALS,0) - ISNULL(r14.TOTALS,0) - ISNULL(r15.TOTALS,0) - ISNULL(r16.TOTALS,0)),0) 'TOTALS' 
FROM temp_corp_6_1 r12, temp_corp_6_1 r13, temp_corp_6_1 r14, temp_corp_6_1 r15, temp_corp_6_1 r16
WHERE (r12.PGrID1 = r13.PGrID1 AND r12.PartID = 12 AND r13.PartID = 13)
    AND (r13.PGrID1 = r14.PGrID1 AND r13.PartID = 13 AND r14.PartID = 14)
    AND (r14.PGrID1 = r15.PGrID1 AND r14.PartID = 14 AND r15.PartID = 15)
    AND (r15.PGrID1 = r16.PGrID1 AND r15.PartID = 15 AND r16.PartID = 16)
    AND r12.PGrID1 <> 100
) AS m17
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (17, 0, 'Операционная прибыль', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 17))                         

--18---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Операционная прибыль на 1 бут. (шт.)

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 18 'PartID', 0 Style,'Операционная прибыль на 1 бут. (шт.)' 'PartIDName', r1.PGrID1, ROUND((r17.TOTALS / r1.TOTALS),2) 'TOTALS' FROM temp_corp_6_1 r17,temp_corp_6_1 r1 WHERE r17.PGrID1 = r1.PGrID1 AND r17.PartID = 17 and r1.PartID = 1
) AS m18
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (18, 0, 'Операционная прибыль на 1 бут. (шт.)', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 18))                         

--19---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Расходы общих отделов

--"Расходы общих отделов" (анализатор ID449)
IF OBJECT_ID('Elit..temp_corp_6_1_ID449', 'U') IS NOT NULL DROP TABLE temp_corp_6_1_ID449;
    SELECT TOP 0 TOTALS INTO temp_corp_6_1_ID449 FROM temp_corp_6_1;

INSERT INTO temp_corp_6_1_ID449 SELECT * FROM ( 
SELECT ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
    /*Расход (Факт) - Расход денег по предприятиям*/          
    SELECT SUM(m.SumAC / m.KursMC) 'SumMC', 
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM c_CompExp m WITH (NOLOCK) --c_CompExp	Расход денег по предприятиям view: av_c_CompExp
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Приход денег по предприятиям*/          
    SELECT SUM(0-(m.SumAC / m.KursMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM c_CompRec m WITH (NOLOCK) --c_CompRec	Приход денег по предприятиям view: av_c_CompRec
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Расход)*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_ProdG rpg WITH (NOLOCK) ON (rpg.PGrID = rp.PGrID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd4.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate
         
    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Приход)*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	Нов Партия
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG rpg WITH (NOLOCK) ON (rpg.PGrID = rp.PGrID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Codes2 rcd2 WITH (NOLOCK) ON (rcd2.CodeID2 = rpg.CodeID2)
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd4.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Расходная накладная*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Inv m WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
        JOIN t_InvD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Расходный документ*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Exp m WITH(NOLOCK)
        JOIN t_ExpD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Расходный документ в ценах прихода*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Epp m WITH(NOLOCK) --t_Epp	Расходный документ в ценах прихода: Заголовок
        JOIN t_EppD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Приход товара*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Rec m WITH(NOLOCK) --t_Rec	Приход товара: Заголовок
        JOIN t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RecD	Приход товара: Товар
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Возврат товара от получателя*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Ret m WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок
        JOIN t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RetD	Возврат товара от получателя: Товар
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Возврат товара поставщику*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_CRet m WITH(NOLOCK) --t_CRet	Возврат товара поставщику: Заголовок
        JOIN t_CRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRetD	Возврат товара поставщику: Товары
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Возврат товара по чеку*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_CRRet m WITH(NOLOCK) --t_CRRet	Возврат товара по чеку: Заголовок
        JOIN t_CRRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRRetD	Возврат товара по чеку: Товар
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
   
    UNION ALL
    /*Расход (Факт) - Продажа товара оператором*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Sale m WITH(NOLOCK) --t_Sale	Продажа товара оператором: Заголовок
        JOIN t_SaleD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_SaleD	Продажа товара оператором: Продажи товара
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

) AS SumMC  
GROUP BY CodeID1, CodeID4, CodeID5, OurID, DocDate
) AS m449
DECLARE @ID449 BIGINT = (SELECT SUM(TOTALS) FROM temp_corp_6_1_ID449)

--Итого по п.2
DECLARE @totalp2 BIGINT = (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 2 AND PGrID1 = 100)

--"Объем продаж, $ в ценах отгрузки" с фильтром, как в п.2, только без групп 1 (анализатор ID257)
IF OBJECT_ID('Elit..temp_corp_6_1_ID257', 'U') IS NOT NULL DROP TABLE temp_corp_6_1_ID257;
    SELECT TOP 0 * INTO temp_corp_6_1_ID257 FROM temp_corp_6_1;

INSERT INTO temp_corp_6_1_ID257 SELECT * FROM (
SELECT 191 'PartID', 0 Style, 'Объем продаж, $ в ценах отгрузки - без групп 1 (ID257)' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
    /*Накладные - Расходная накладная*/    
    SELECT r_Prods_112.PGrID1, SUM(t_InvD_8.SumCC_wt / t_Inv_7.KursMC) 'SumMC'
    FROM t_Inv t_Inv_7 WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
    INNER JOIN t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID) --t_InvD	Расходная накладная: Товар view: av_t_InvD
    INNER JOIN t_PInP t_PInP_111 WITH(NOLOCK) ON (t_InvD_8.PPID=t_PInP_111.PPID AND t_InvD_8.ProdID=t_PInP_111.ProdID)
    INNER JOIN r_Prods r_Prods_112 WITH(NOLOCK) ON (t_PInP_111.ProdID=r_Prods_112.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_132 WITH(NOLOCK) ON (r_Prods_112.ProdID=r_ProdMP_132.ProdID AND 106=r_ProdMP_132.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_112.PGrID1

      WHERE
      --(SELECT [dbo].[zf_MatchFilterInt](r_Prods_112.PGrID1,@PGrID1_sales,',')) = 1
      (SELECT [dbo].[zf_MatchFilterInt](t_Inv_7.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Inv_7.OurID,@OurID,',')) = 1
      AND t_Inv_7.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_112.PGrID1

UNION ALL
  
    /*Расход - Расходный документ*/    
    SELECT r_Prods_116.PGrID1, SUM(t_ExpD_10.SumCC_wt / t_Exp_9.KursMC) 'SumMC'
    FROM t_Exp t_Exp_9 WITH(NOLOCK) --t_Exp	Расходный документ: Заголовок view: av_t_Exp
    INNER JOIN t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID) --t_ExpD	Расходный документ: Товар view: av_t_ExpD
    INNER JOIN t_PInP t_PInP_115 WITH(NOLOCK) ON (t_ExpD_10.PPID=t_PInP_115.PPID AND t_ExpD_10.ProdID=t_PInP_115.ProdID)
    INNER JOIN r_Prods r_Prods_116 WITH(NOLOCK) ON (t_PInP_115.ProdID=r_Prods_116.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_133 WITH(NOLOCK) ON (r_Prods_116.ProdID=r_ProdMP_133.ProdID AND 106=r_ProdMP_133.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_116.PGrID1

      WHERE
      --(SELECT [dbo].[zf_MatchFilterInt](r_Prods_116.PGrID1,@PGrID1_sales,',')) = 1
      (SELECT [dbo].[zf_MatchFilterInt](t_Exp_9.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Exp_9.OurID,@OurID,',')) = 1
      AND t_Exp_9.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_116.PGrID1

UNION ALL

    /*Возврат от получателя - Возврат товара от получателя*/
    SELECT r_Prods_80.PGrID1, -SUM(t_RetD_4.SumCC_wt / t_Ret_3.KursMC) 'SumMC'
    FROM t_Ret t_Ret_3 WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок view: av_t_Ret
    INNER JOIN t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID) --t_RetD	Возврат товара от получателя: Товар view: av_t_RetD
    INNER JOIN t_PInP t_PInP_79 WITH(NOLOCK) ON (t_RetD_4.PPID=t_PInP_79.PPID AND t_RetD_4.ProdID=t_PInP_79.ProdID)
    INNER JOIN r_Prods r_Prods_80 WITH(NOLOCK) ON (t_PInP_79.ProdID=r_Prods_80.ProdID)
    LEFT JOIN r_ProdMP r_ProdMP_124 WITH(NOLOCK) ON (r_Prods_80.ProdID=r_ProdMP_124.ProdID AND 106=r_ProdMP_124.PLID)
    INNER JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = r_Prods_80.PGrID1

      WHERE
      --(SELECT [dbo].[zf_MatchFilterInt](r_Prods_80.PGrID1,@PGrID1_sales,',')) = 1
      (SELECT [dbo].[zf_MatchFilterInt](t_Ret_3.CodeID1,@CodeID1_sales,',')) = 1
      AND (SELECT [dbo].[zf_MatchFilterInt](t_Ret_3.OurID,@OurID,',')) = 1
      AND t_Ret_3.DocDate BETWEEN @BDate AND @EDate 
      GROUP BY r_Prods_80.PGrID1

) AS salesSumMC  
GROUP BY PGrID1
) AS m191
DECLARE @ID257 BIGINT = (SELECT SUM(TOTALS) FROM temp_corp_6_1_ID257)

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 19 'PartID', 0 Style, 'Расходы общих отделов' 'PartIDName', PGrID1, ROUND(((TOTALS  * (CAST(@totalp2 AS float) / @ID257 * @ID449)) / 100),0) 'TOTALS' 
FROM temp_corp_6_1
WHERE PartID = 3
) AS m19

--20---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Чистая прибыль с учетом расходов общих отделов

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 20 'PartID', 0 Style,'Чистая прибыль с учетом расходов общих отделов' 'PartIDName', r17.PGrID1, ROUND((r17.TOTALS - r19.TOTALS),0) 'TOTALS' FROM temp_corp_6_1 r17,temp_corp_6_1 r19 WHERE r17.PGrID1 = r19.PGrID1 AND r17.PartID = 17 and r19.PartID = 19
) AS m20
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (20, 0, 'Чистая прибыль с учетом расходов общих отделов', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 20))                         

--21---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Прибыль от отгрузки дистрибьюций
INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 21 'PartID', 0 Style, 'Прибыль от отгрузки дистрибьюций' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
    /*Расход (Факт) - Расход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(m.SumAC / m.KursMC) 'SumMC'
    FROM c_CompExp m WITH (NOLOCK) --c_CompExp	Расход денег по предприятиям view: av_c_CompExp
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(0-(m.SumAC / m.KursMC)) 'SumMC'
    FROM c_CompRec m WITH (NOLOCK) --c_CompRec	Приход денег по предприятиям view: av_c_CompRec
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Расход)*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG rpg WITH (NOLOCK) ON (rpg.PGrID = rp.PGrID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Codes2 rcd2 WITH (NOLOCK) ON (rcd2.CodeID2 = rpg.CodeID2)
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)

    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd2.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    --/*Расход (Факт) - Переоценка цен прихода (Приход)*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	Нов Партия
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG rpg WITH (NOLOCK) ON (rpg.PGrID = rp.PGrID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Codes2 rcd2 WITH (NOLOCK) ON (rcd2.CodeID2 = rpg.CodeID2)
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)

    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd2.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходная накладная*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Inv m WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
        JOIN t_InvD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Exp m WITH(NOLOCK)
        JOIN t_ExpD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ в ценах прихода*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Epp m WITH(NOLOCK) --t_Epp	Расходный документ в ценах прихода: Заголовок
        JOIN t_EppD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход товара*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Rec m WITH(NOLOCK) --t_Rec	Приход товара: Заголовок
        JOIN t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RecD	Приход товара: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY rpg1.PGrID1

        UNION ALL
    /*Расход (Факт) - Возврат товара от получателя*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Ret m WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок
        JOIN t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RetD	Возврат товара от получателя: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Возврат товара поставщику*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_CRet m WITH(NOLOCK) --t_CRet	Возврат товара поставщику: Заголовок
        JOIN t_CRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRetD	Возврат товара поставщику: Товары
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Возврат товара по чеку*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_CRRet m WITH(NOLOCK) --t_CRRet	Возврат товара по чеку: Заголовок
        JOIN t_CRRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRRetD	Возврат товара по чеку: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY rpg1.PGrID1
   
    UNION ALL
    /*Расход (Факт) - Продажа товара оператором*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Sale m WITH(NOLOCK) --t_Sale	Продажа товара оператором: Заголовок
        JOIN t_SaleD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_SaleD	Продажа товара оператором: Продажи товара
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID2,@CodeID2_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID3,@CodeID3_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrShipments,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY rpg1.PGrID1

) AS SumMC
  
GROUP BY PGrID1
) AS m21
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (21, 0, 'Прибыль от отгрузки дистрибьюций', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 21))                         


--22---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Расходы дистрибьюций на проект

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 22 'PartID', 0 Style, 'Расходы дистрибьюций на проект' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
    /*Расход (Факт) - Расход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(m.SumAC / m.KursMC) 'SumMC'
    FROM c_CompExp m WITH (NOLOCK) --c_CompExp	Расход денег по предприятиям view: av_c_CompExp
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход денег по предприятиям*/          
    SELECT rpg1.PGrID1, SUM(0-(m.SumAC / m.KursMC)) 'SumMC'
    FROM c_CompRec m WITH (NOLOCK) --c_CompRec	Приход денег по предприятиям view: av_c_CompRec
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    --/*Расход (Факт) - Переоценка цен прихода (Расход)*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)

    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd4.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    --/*Расход (Факт) - Переоценка цен прихода (Приход)*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	Нов Партия
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)

    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd4.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходная накладная*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Inv m WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
        JOIN t_InvD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Exp m WITH(NOLOCK)
        JOIN t_ExpD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Расходный документ в ценах прихода*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Epp m WITH(NOLOCK) --t_Epp	Расходный документ в ценах прихода: Заголовок
        JOIN t_EppD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Приход товара*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Rec m WITH(NOLOCK) --t_Rec	Приход товара: Заголовок
        JOIN t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RecD	Приход товара: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

        UNION ALL
    /*Расход (Факт) - Возврат товара от получателя*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_Ret m WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок
        JOIN t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RetD	Возврат товара от получателя: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Возврат товара поставщику*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_CRet m WITH(NOLOCK) --t_CRet	Возврат товара поставщику: Заголовок
        JOIN t_CRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRetD	Возврат товара поставщику: Товары
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

    UNION ALL
    /*Расход (Факт) - Возврат товара по чеку*/ 
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'
    FROM t_CRRet m WITH(NOLOCK) --t_CRRet	Возврат товара по чеку: Заголовок
        JOIN t_CRRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRRetD	Возврат товара по чеку: Товар
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1
   
    UNION ALL
    /*Расход (Факт) - Продажа товара оператором*/ 
    SELECT rpg1.PGrID1, SUM(d.Qty * tpi.CostMC) 'SumMC'
    FROM t_Sale m WITH(NOLOCK) --t_Sale	Продажа товара оператором: Заголовок
        JOIN t_SaleD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_SaleD	Продажа товара оператором: Продажи товара
        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        m.DocDate BETWEEN @BDate AND @EDate 
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExpProject,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY rpg1.PGrID1

) AS SumMC
  
GROUP BY PGrID1
) AS m22
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (22, 0, 'Расходы дистрибьюций на проект', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 22))                         


--23---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Общие расходы дистрибьюций

--Итого по п.2 (562880)
--DECLARE @totalp2 BIGINT = (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 2 AND PGrID1 = 100)

--@ID257 (2159599)
--DECLARE @ID257 BIGINT = (SELECT SUM(TOTALS) FROM temp_corp_6_1_ID257)

--@ID449_23 - только с другими признаками.
IF OBJECT_ID('Elit..temp_corp_6_1_ID449_23', 'U') IS NOT NULL DROP TABLE temp_corp_6_1_ID449_23;
    SELECT TOP 0 TOTALS INTO temp_corp_6_1_ID449_23 FROM temp_corp_6_1;

INSERT INTO temp_corp_6_1_ID449_23 SELECT * FROM ( 
SELECT ROUND(SUM(SumMC),0) 'SumMC' FROM (
          
    /*Расход (Факт) - Расход денег по предприятиям*/          
    SELECT SUM(m.SumAC / m.KursMC) 'SumMC', 
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM c_CompExp m WITH (NOLOCK) --c_CompExp	Расход денег по предприятиям view: av_c_CompExp
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Приход денег по предприятиям*/          
    SELECT SUM(0-(m.SumAC / m.KursMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM c_CompRec m WITH (NOLOCK) --c_CompRec	Приход денег по предприятиям view: av_c_CompRec
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Расход)*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_ProdG rpg WITH (NOLOCK) ON (rpg.PGrID = rp.PGrID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd4.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate
         
    UNION ALL
    /*Расход (Факт) - Переоценка цен прихода (Приход)*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate
    FROM t_Est m WITH (NOLOCK) --t_Est	Переоценка цен прихода: Заголовок view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	Переоценка цен прихода: Товар av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	Нов Партия
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG rpg WITH (NOLOCK) ON (rpg.PGrID = rp.PGrID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	Справочник товаров: Подгруппа 1
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Codes2 rcd2 WITH (NOLOCK) ON (rcd2.CodeID2 = rpg.CodeID2)
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd4.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND (rp.PCatID BETWEEN 600 AND 699) --эта строка взята из расчета Анализатора.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --эта строка взята из расчета Анализатора.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--эта строка взята из расчета Анализатора.
    GROUP BY rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Расходная накладная*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Inv m WITH(NOLOCK) --t_Inv	Расходная накладная: Заголовок view: av_t_Inv
        JOIN t_InvD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Расходный документ*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Exp m WITH(NOLOCK)
        JOIN t_ExpD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Расходный документ в ценах прихода*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Epp m WITH(NOLOCK) --t_Epp	Расходный документ в ценах прихода: Заголовок
        JOIN t_EppD d WITH (NOLOCK) ON (m.ChID = d.ChID)
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Приход товара*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Rec m WITH(NOLOCK) --t_Rec	Приход товара: Заголовок
        JOIN t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RecD	Приход товара: Товар
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Возврат товара от получателя*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Ret m WITH(NOLOCK) --t_Ret	Возврат товара от получателя: Заголовок
        JOIN t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RetD	Возврат товара от получателя: Товар
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Возврат товара поставщику*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_CRet m WITH(NOLOCK) --t_CRet	Возврат товара поставщику: Заголовок
        JOIN t_CRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRetD	Возврат товара поставщику: Товары
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*Расход (Факт) - Возврат товара по чеку*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_CRRet m WITH(NOLOCK) --t_CRRet	Возврат товара по чеку: Заголовок
        JOIN t_CRRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRRetD	Возврат товара по чеку: Товар
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
   
    UNION ALL
    /*Расход (Факт) - Продажа товара оператором*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Sale m WITH(NOLOCK) --t_Sale	Продажа товара оператором: Заголовок
        JOIN t_SaleD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_SaleD	Продажа товара оператором: Продажи товара
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_distrExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --эта строка взята из расчета Анализатора.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

) AS SumMC  
GROUP BY CodeID1, CodeID4, CodeID5, OurID, DocDate
) AS m449
DECLARE @ID449_23 BIGINT = (SELECT SUM(TOTALS) FROM temp_corp_6_1_ID449_23)

--@total23
DECLARE @total23 BIGINT = CAST(@totalp2 AS float) / @ID257 * @ID449_23

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 23 'PartID', 0 Style, 'Общие расходы дистрибьюций' 'PartIDName', PGrID1, ROUND((TOTALS / CAST(@totalp2 AS float) * @total23),0) 'TOTALS' 
FROM temp_corp_6_1
WHERE PartID = 2
) AS m23


--24---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Прибыль/убыток дистрибьюции

BEGIN --Вставка '0'
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 21 AND PGrID1 = 1) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (21, 0, 'Прибыль от отгрузки дистрибьюций', 1, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 21 AND PGrID1 = 3) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (21, 0, 'Прибыль от отгрузки дистрибьюций', 3, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 21 AND PGrID1 = 4) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (21, 0, 'Прибыль от отгрузки дистрибьюций', 4, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 21 AND PGrID1 = 5) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (21, 0, 'Прибыль от отгрузки дистрибьюций', 5, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 21 AND PGrID1 = 6) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (21, 0, 'Прибыль от отгрузки дистрибьюций', 6, 0)

IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 22 AND PGrID1 = 1) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (22, 0, 'Расходы дистрибьюций на проект', 1, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 22 AND PGrID1 = 3) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (22, 0, 'Расходы дистрибьюций на проект', 3, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 22 AND PGrID1 = 4) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (22, 0, 'Расходы дистрибьюций на проект', 4, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 22 AND PGrID1 = 5) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (22, 0, 'Расходы дистрибьюций на проект', 5, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 22 AND PGrID1 = 6) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (22, 0, 'Расходы дистрибьюций на проект', 6, 0)

IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 23 AND PGrID1 = 1) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (23, 0, 'Общие расходы дистрибьюций', 1, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 23 AND PGrID1 = 3) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (23, 0, 'Общие расходы дистрибьюций', 3, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 23 AND PGrID1 = 4) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (23, 0, 'Общие расходы дистрибьюций', 4, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 23 AND PGrID1 = 5) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (23, 0, 'Общие расходы дистрибьюций', 5, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 23 AND PGrID1 = 6) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (23, 0, 'Общие расходы дистрибьюций', 6, 0)
END;

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 24 'PartID', 0 Style,'Прибыль/убыток дистрибьюции' 'PartIDName', r21.PGrID1, ROUND((ISNULL(r21.TOTALS,0) - ISNULL(r22.TOTALS,0) - ISNULL(r23.TOTALS,0)),0) 'TOTALS' 
FROM temp_corp_6_1 r21, temp_corp_6_1 r22, temp_corp_6_1 r23
WHERE (r21.PGrID1 = r22.PGrID1 AND r21.PartID = 21 AND r22.PartID = 22)
    AND (r22.PGrID1 = r23.PGrID1 AND r22.PartID = 22 AND r23.PartID = 23)
    AND r21.PGrID1 <> 100
) AS m24
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (24, 0, 'Прибыль/убыток дистрибьюции', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 24))                         

--25---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Чистая прибыль с учетом результата дистрибьюций

BEGIN --Вставка '0'
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 20 AND PGrID1 = 1) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (20, 0, 'Прибыль от отгрузки дистрибьюций', 1, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 20 AND PGrID1 = 3) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (20, 0, 'Прибыль от отгрузки дистрибьюций', 3, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 20 AND PGrID1 = 4) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (20, 0, 'Прибыль от отгрузки дистрибьюций', 4, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 20 AND PGrID1 = 5) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (20, 0, 'Прибыль от отгрузки дистрибьюций', 5, 0)
IF NOT EXISTS (SELECT * FROM temp_corp_6_1 WHERE PartID = 20 AND PGrID1 = 6) INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (20, 0, 'Прибыль от отгрузки дистрибьюций', 6, 0)
END;

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 25 'PartID', 0 Style,'Чистая прибыль с учетом результата дистрибьюций' 'PartIDName', r20.PGrID1, ROUND((ISNULL(r20.TOTALS,0) - ISNULL(r22.TOTALS,0) - ISNULL(r23.TOTALS,0)),0) 'TOTALS' 
FROM temp_corp_6_1 r20, temp_corp_6_1 r22, temp_corp_6_1 r23
WHERE (r20.PGrID1 = r22.PGrID1 AND r20.PartID = 20 AND r22.PartID = 22)
    AND (r22.PGrID1 = r23.PGrID1 AND r22.PartID = 22 AND r23.PartID = 23)
    AND r20.PGrID1 <> 100
) AS m25
INSERT INTO temp_corp_6_1 (PartID, Style, PartIDName, PGrID1, TOTALS) VALUES (25, 0, 'Чистая прибыль с учетом результата дистрибьюций', 100, (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 25))


--26---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--доля в прибыли %

INSERT INTO temp_corp_6_1 SELECT * FROM (
SELECT 26 'PartID', 0 Style, 'доля в прибыли %' 'PartIDName', PGrID1, ROUND(cast(TOTALS as float) / (SELECT SUM(TOTALS) 'TOTALS' FROM temp_corp_6_1 WHERE PartID = 25 AND PGrID1 = 100) * 100,0) 'TOTALS' 
FROM temp_corp_6_1
WHERE PartID = 25
) AS m26

--RESULT----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Делаем разворот                                               
SELECT PartID '№', PartIDName 'Данные', [5],[4],[6],[3],[1],[100] FROM temp_corp_6_1 
PIVOT ( 
MAX(TOTALS) FOR PGrID1 IN ([5],[4],[6],[3],[1],[100]) 
) as pvt
ORDER BY 1
--END для теста.
END;
--END процедуры.
END;



GO