--запрос по логистике версия 6_3 от 14.11.2018 11:30
DECLARE	-- укажите параметры
		 @StockID VARCHAR(MAX) = '23,323' -- склады на которые делается заказ
		,@StockID_ALL VARCHAR(MAX) = '4,304,11,311,27,327,85,385,23,323,220,320' -- все склады на которые делаются заказы
		,@PCatID VARCHAR(MAX) = '1-100' --код категории 
		,@PGrID1 VARCHAR(MAX) = '0,8,10-15,17,19,30-31,33-35,38-41,44,45,47-51,53-62,64-68,70-75,77-80,83-88,90,91,93,95-105,106-200' --код группы 1
		,@ProdID VARCHAR(MAX) = '' --код товаров
		,@AllProds int = 1		   -- если 1 то все товары, а если 0 то только те что на складах 220,218
		,@Months INT = 2

/*
1-7,9,16,76,92,94,32
0,8,10-15,17,19,30-31,33-35,38-41,44,45,47-51,53-62,64-68,70-75,77-80,83-88,90,91,93,95-105,106-200

*/		
/*
В версии 6_2 не выводятся позиции, в которых [Остаток 220],[Остаток 218] равен нулю.
В версии 6_3 исключили кофейщиков  AND m.CompID <> 79
*/

SET DATEFIRST 1 --установить первый день недели понедельник
DECLARE  @WeekID INT = DATEPART(week, GETDATE()) -- день недели
		,@BeginDate DATE --Дата начала выборки, на @month месяца меньше текушей
		,@EndDate DATE --Дата конца выборки

IF 1=1 --#Month2
BEGIN
SET @BeginDate = DATEADD(day , -@Months*28, dbo.zf_GetDate( GETDATE() ))
SET @EndDate = DATEADD(day, (-@Months+1)*28, dbo.zf_GetDate( GETDATE() ))

IF OBJECT_ID (N'tempdb..#Month2', N'U') IS NOT NULL DROP TABLE #Month2

/*блок выборок*/
;WITH 
	 Rem218_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 218 GROUP BY ProdID )
	,Rem220_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 220 GROUP BY ProdID )
	,Rem_CTE AS( SELECT ProdID, SUM(Qty) SumQty FROM t_rem m WITH(NOLOCK) WHERE  StockID in ( select AValue from zf_FilterToTable(@StockID) ) GROUP BY ProdID )
	
	--Возврат товара от получателя
	,gr_t_Ret_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	--Расходная накладная
	,gr_t_Inv_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	--Расходный документ
	,gr_t_Exp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	--Расходный документ в ценах прихода
	,gr_t_Epp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
					

	,gr_t_Ret220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
--сети
	,gr_t_Ret220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 )	and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
--расход общий
	,gr_t_Ret_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79
					GROUP BY d.ProdID
					)

SELECT ProdID, Остаток_на_ЦС_бр, PGrAID, PCatID, PCatName, ProdName, PGrID1, PGrName1, Кол_в_ящике, SumQty_t_Ret, SumQty_t_Inv, SumQty_t_Exp, SumQty_t_Epp, Остаток, Остаток218_бр, Остаток220_бр, Резерв_на_ЦС, Резерв218, Резерв220,Расход,Расход220320, Расход220320_seti,kof, Расход_общий
 INTO #Month2	
FROM (
--текущие остатки по центральному (220,218) складу с которого отгружать
			SELECT gr.ProdID,  ISNULL(gr.SumQty_AccQty,0) 'Остаток_на_ЦС_бр', p.PGrAID, p.PCatID, r_ProdC.PCatName, p.ProdName, p.PGrID1, r_ProdG1.PGrName1 , isnull(mq.Qty,1) 'Кол_в_ящике',
			gr_t_Ret.SumQty SumQty_t_Ret,gr_t_Inv.SumQty SumQty_t_Inv ,gr_t_Exp.SumQty SumQty_t_Exp,gr_t_Epp.SumQty SumQty_t_Epp, 
			ISNULL(gr_t_Rem.SumQty,0) 'Остаток' , gr_t_Rem218.SumQty_AccQty 'Остаток218_бр' , gr_t_Rem220.SumQty_AccQty 'Остаток220_бр',
			gr.SumAccQty 'Резерв_на_ЦС' , gr_t_Rem218.SumAccQty 'Резерв218' , gr_t_Rem220.SumAccQty 'Резерв220'
			, (ISNULL(gr_t_Inv.SumQty,0) + ISNULL(gr_t_Exp.SumQty,0)  + ISNULL(gr_t_Epp.SumQty,0) - ISNULL(gr_t_Ret.SumQty,0))  'Расход'
			, (ISNULL(gr_t_Inv220320.SumQty,0) + ISNULL(gr_t_Exp220320.SumQty,0)  + ISNULL(gr_t_Epp220320.SumQty,0) - ISNULL(gr_t_Ret220320.SumQty,0))  'Расход220320'
			, (ISNULL(gr_t_Inv220320_seti.SumQty,0) + ISNULL(gr_t_Exp220320_seti.SumQty,0)  + ISNULL(gr_t_Epp220320_seti.SumQty,0) - ISNULL(gr_t_Ret220320_seti.SumQty,0))  'Расход220320_seti'
			,dbo.af_GetPercentsForPCatIDImport(p.PCatID,@WeekID) kof
			, (ISNULL(gr_t_Inv_global.SumQty,0) + ISNULL(gr_t_Exp_global.SumQty,0)  + ISNULL(gr_t_Epp_global.SumQty,0) - ISNULL(gr_t_Ret_global.SumQty,0)) 'Расход_общий'
			FROM (
				SELECT ProdID,  SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK)
				WHERE  StockID in (220,218) or @AllProds = 1
				GROUP BY ProdID
				) gr 
			JOIN r_Prods p WITH(NOLOCK) ON p.ProdID = gr.ProdID
			JOIN r_ProdG1  WITH(NOLOCK) ON r_ProdG1.PGrID1 = p.PGrID1
			JOIN r_ProdC  WITH(NOLOCK) ON r_ProdC.PCatID = p.PCatID
			LEFT JOIN gr_t_Ret_CTE gr_t_Ret ON gr_t_Ret.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv_CTE gr_t_Inv ON gr_t_Inv.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp_CTE gr_t_Exp ON gr_t_Exp.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp_CTE gr_t_Epp ON gr_t_Epp.ProdID = p.ProdID
			LEFT JOIN Rem_CTE gr_t_Rem ON gr_t_Rem.ProdID = p.ProdID
			LEFT JOIN Rem218_CTE gr_t_Rem218 ON gr_t_Rem218.ProdID = p.ProdID
			LEFT JOIN Rem220_CTE gr_t_Rem220 ON gr_t_Rem220.ProdID = p.ProdID
			LEFT JOIN r_ProdMQ mq ON mq.ProdID = p.ProdID and mq.UM = 'ящ.'
			LEFT JOIN gr_t_Ret220320_CTE gr_t_Ret220320 ON gr_t_Ret220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv220320_CTE gr_t_Inv220320 ON gr_t_Inv220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp220320_CTE gr_t_Exp220320 ON gr_t_Exp220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp220320_CTE gr_t_Epp220320 ON gr_t_Epp220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Ret220320_seti_CTE gr_t_Ret220320_seti ON gr_t_Ret220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv220320_seti_CTE gr_t_Inv220320_seti ON gr_t_Inv220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp220320_seti_CTE gr_t_Exp220320_seti ON gr_t_Exp220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp220320_seti_CTE gr_t_Epp220320_seti ON gr_t_Epp220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Ret_CTE_global gr_t_Ret_global ON gr_t_Ret_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv_CTE_global gr_t_Inv_global ON gr_t_Inv_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp_CTE_global gr_t_Exp_global ON gr_t_Exp_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp_CTE_global gr_t_Epp_global ON gr_t_Epp_global.ProdID = p.ProdID

			WHERE ((0 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PCatID,@PCatID,',')) = 1 and 1 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ))
			  AND ((0 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PGrID1,@PGrID1,',')) = 1 and 1 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ))
			  AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
			  AND (gr.SumQty_AccQty > 0 or @AllProds = 1)
)big
END -- #Month2

IF 1=1 --#Month1
BEGIN
SET @Months = @Months - 1;
SET @BeginDate = DATEADD(day , -@Months*28, dbo.zf_GetDate( GETDATE() ))
SET @EndDate = DATEADD(day, (-@Months+1)*28, dbo.zf_GetDate( GETDATE() ))

IF OBJECT_ID (N'tempdb..#Month1', N'U') IS NOT NULL DROP TABLE #Month1

/*блок выборок*/
;WITH 
	 Rem218_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 218 GROUP BY ProdID )
	,Rem220_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 220 GROUP BY ProdID )
	,Rem_CTE AS( SELECT ProdID, SUM(Qty) SumQty FROM t_rem m WITH(NOLOCK) WHERE  StockID in ( select AValue from zf_FilterToTable(@StockID) ) GROUP BY ProdID )
	
	,gr_t_Ret_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
					

	,gr_t_Ret220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
--сети
	,gr_t_Ret220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 )	and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
--расход общий
	,gr_t_Ret_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)

SELECT ProdID, Остаток_на_ЦС_бр, PGrAID, PCatID, PCatName, ProdName, PGrID1, PGrName1, Кол_в_ящике, SumQty_t_Ret, SumQty_t_Inv, SumQty_t_Exp, SumQty_t_Epp, Остаток, Остаток218_бр, Остаток220_бр, Резерв_на_ЦС, Резерв218, Резерв220,Расход,Расход220320, Расход220320_seti,kof, Расход_общий
 INTO #Month1	
FROM (
--текущие остатки по центральному (220,218) складу с которого отгружать
			SELECT gr.ProdID,  ISNULL(gr.SumQty_AccQty,0) 'Остаток_на_ЦС_бр',p.PGrAID, p.PCatID, r_ProdC.PCatName, p.ProdName, p.PGrID1, r_ProdG1.PGrName1 , isnull(mq.Qty,1) 'Кол_в_ящике',
			gr_t_Ret.SumQty SumQty_t_Ret,gr_t_Inv.SumQty SumQty_t_Inv ,gr_t_Exp.SumQty SumQty_t_Exp,gr_t_Epp.SumQty SumQty_t_Epp, 
			ISNULL(gr_t_Rem.SumQty,0) 'Остаток' , gr_t_Rem218.SumQty_AccQty 'Остаток218_бр' , gr_t_Rem220.SumQty_AccQty 'Остаток220_бр',
			gr.SumAccQty 'Резерв_на_ЦС' , gr_t_Rem218.SumAccQty 'Резерв218' , gr_t_Rem220.SumAccQty 'Резерв220'
			, (ISNULL(gr_t_Inv.SumQty,0) + ISNULL(gr_t_Exp.SumQty,0)  + ISNULL(gr_t_Epp.SumQty,0) - ISNULL(gr_t_Ret.SumQty,0))  'Расход'
			, (ISNULL(gr_t_Inv220320.SumQty,0) + ISNULL(gr_t_Exp220320.SumQty,0)  + ISNULL(gr_t_Epp220320.SumQty,0) - ISNULL(gr_t_Ret220320.SumQty,0))  'Расход220320'
			, (ISNULL(gr_t_Inv220320_seti.SumQty,0) + ISNULL(gr_t_Exp220320_seti.SumQty,0)  + ISNULL(gr_t_Epp220320_seti.SumQty,0) - ISNULL(gr_t_Ret220320_seti.SumQty,0))  'Расход220320_seti'
			,dbo.af_GetPercentsForPCatIDImport(p.PCatID,@WeekID) kof
			, (ISNULL(gr_t_Inv_global.SumQty,0) + ISNULL(gr_t_Exp_global.SumQty,0)  + ISNULL(gr_t_Epp_global.SumQty,0) - ISNULL(gr_t_Ret_global.SumQty,0)) 'Расход_общий'
			FROM (
				SELECT ProdID,  SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK)
				WHERE  StockID in (220,218) or @AllProds = 1
				GROUP BY ProdID
				) gr 
			JOIN r_Prods p WITH(NOLOCK) ON p.ProdID = gr.ProdID
			JOIN r_ProdG1  WITH(NOLOCK) ON r_ProdG1.PGrID1 = p.PGrID1
			JOIN r_ProdC   WITH(NOLOCK) ON r_ProdC.PCatID = p.PCatID
			LEFT JOIN gr_t_Ret_CTE gr_t_Ret ON gr_t_Ret.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv_CTE gr_t_Inv ON gr_t_Inv.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp_CTE gr_t_Exp ON gr_t_Exp.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp_CTE gr_t_Epp ON gr_t_Epp.ProdID = p.ProdID
			LEFT JOIN Rem_CTE gr_t_Rem ON gr_t_Rem.ProdID = p.ProdID
			LEFT JOIN Rem218_CTE gr_t_Rem218 ON gr_t_Rem218.ProdID = p.ProdID
			LEFT JOIN Rem220_CTE gr_t_Rem220 ON gr_t_Rem220.ProdID = p.ProdID
			LEFT JOIN r_ProdMQ mq ON mq.ProdID = p.ProdID and mq.UM = 'ящ.'
			LEFT JOIN gr_t_Ret220320_CTE gr_t_Ret220320 ON gr_t_Ret220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv220320_CTE gr_t_Inv220320 ON gr_t_Inv220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp220320_CTE gr_t_Exp220320 ON gr_t_Exp220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp220320_CTE gr_t_Epp220320 ON gr_t_Epp220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Ret220320_seti_CTE gr_t_Ret220320_seti ON gr_t_Ret220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv220320_seti_CTE gr_t_Inv220320_seti ON gr_t_Inv220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp220320_seti_CTE gr_t_Exp220320_seti ON gr_t_Exp220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp220320_seti_CTE gr_t_Epp220320_seti ON gr_t_Epp220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Ret_CTE_global gr_t_Ret_global ON gr_t_Ret_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv_CTE_global gr_t_Inv_global ON gr_t_Inv_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp_CTE_global gr_t_Exp_global ON gr_t_Exp_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp_CTE_global gr_t_Epp_global ON gr_t_Epp_global.ProdID = p.ProdID

			WHERE ((0 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PCatID,@PCatID,',')) = 1 and 1 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ))
			  AND ((0 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PGrID1,@PGrID1,',')) = 1 and 1 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ))
			  AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
			  AND (gr.SumQty_AccQty > 0 or @AllProds = 1)
)big
END -- #Month1


--SELECT ProdID, PCatID, PCatName, ProdName, PGrID1, PGrName1, Кол_в_ящике, SumQty_t_Ret, SumQty_t_Inv, SumQty_t_Exp, SumQty_t_Epp, Остаток_на_ЦС_бр, Резерв_на_ЦС, Остаток220_бр, Резерв220, Остаток218_бр, Резерв218, Остаток, Расход_m1, Расход_m2, Расход220320_m1, Расход220320_m2, Расход220320_seti_m1, Расход220320_seti_m2, kof, Прогноз, Дефицит, Заказ_по_прогнозу, Доли_склада, кратный_Заказ_по_прогнозу, Факт_заказ, Кратный_Факт_заказ, Кор_Кратный_Факт_заказ, Процент_от_остатка 
SELECT PCatName 'Категория', PGrName1 'Проект', PGrAID 'Код группы альтернатив', ProdID 'Код товара', ProdName 'Наименование товара', Кол_в_ящике 'Кол в ящике', Остаток220_бр 'Остаток 220', Резерв220 'Резерв ЦС', Остаток218_бр 'Остаток 218', Остаток, Расход_m1 'Расход посл месяц', Расход_m2 'Расход пред месяц', Расход220320_seti_m1 'Расход СЕТИ посл месяц', Расход220320_seti_m2 'Расход СЕТИ пред месяц', /*Расход_сети_общий, */ROUND (Прогноз,0) 'Прогноз',  ROUND (Доли_склада,1) 'Доли склада', кратный_Заказ_по_прогнозу 'Заказ по прогнозу по ящ', Кор_Кратный_Факт_заказ 'Факт заказ'
FROM (
	SELECT *
	,CASE WHEN Остаток220_бр < Кратный_Факт_заказ THEN Остаток220_бр ELSE /*Кратный_Факт_заказ*/ CASE WHEN Кратный_Факт_заказ<0 THEN 0 ELSE Кратный_Факт_заказ END /*затычка, нужно продумать*/ END as 'Кор_Кратный_Факт_заказ' 
	, (CASE WHEN Остаток_на_ЦС_бр < Кратный_Факт_заказ THEN Остаток_на_ЦС_бр ELSE Кратный_Факт_заказ END ) / (case when [Остаток_на_ЦС_бр] = 0 then 1 else [Остаток_на_ЦС_бр] end)  as 'Процент_от_остатка'
	FROM (

		SELECT *
		,(isnull((round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике),0)) as 'кратный_Заказ_по_прогнозу' --'кратный_Заказ_по_прогнозу' = ОКРУГЛ(Заказ_по_прогнозу/Кол_в_ящике;0)*Кол_в_ящике
		,(CASE WHEN (Остаток_на_ЦС_бр - (isnull((round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике),0)) ) > 0 THEN (round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике) ELSE Остаток_на_ЦС_бр END) as 'Факт_заказ' --'Факт_заказ' = =ЕСЛИ(Остаток_на_ЦС - кратный_Заказ_по_прогнозу >0;кратный_Заказ_по_прогнозу;Остаток_на_ЦС)
		,(isnull((round( ((CASE WHEN (Остаток_на_ЦС_бр - (isnull((round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике),0)) ) > 0 THEN (round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике) ELSE Остаток_на_ЦС_бр END)) / Кол_в_ящике,0) * Кол_в_ящике),0)) as 'Кратный_Факт_заказ' --'Кратный_Факт_заказ' 
		FROM (
		 
			SELECT m1.ProdID, m1.PGrAID, m1.PCatID, m1.PCatName, m1.ProdName, m1.PGrID1, m1.PGrName1, m1.Кол_в_ящике, m1.SumQty_t_Ret, m1.SumQty_t_Inv, m1.SumQty_t_Exp, m1.SumQty_t_Epp,
			m1.Остаток_на_ЦС_бр, m1.Резерв_на_ЦС, ISNULL(m1.Остаток220_бр,0) Остаток220_бр,ISNULL(m1.Резерв220,0) Резерв220, ISNULL(m1.Остаток218_бр,0) Остаток218_бр, ISNULL(m1.Резерв218,0) Резерв218, m1.Остаток, 
			m1.Расход Расход_m1, m2.Расход Расход_m2
			,m1.Расход220320 Расход220320_m1, m2.Расход220320 Расход220320_m2
			,m1.Расход220320_seti Расход220320_seti_m1, m2.Расход220320_seti Расход220320_seti_m2
			, m1.kof	
			,((m1.Расход + m2.Расход) / 8 * m1.kof * 3) as 'Прогноз'  --'Прогноз'
			,(isnull((m1.Остаток - ((m1.Расход + m2.Расход) / 8 * m1.kof * 3) + m1.Расход220320_seti * 0.9),0)) as 'Дефицит'  --  Остаток - Прогноз = Дефицит
			, case when (isnull((m1.Остаток - ((m1.Расход + m2.Расход) / 8 * m1.kof * 3) /*+ m1.Расход220320_seti*0.9*/),0)) > 0 then 0 else (isnull((m1.Остаток - ((m1.Расход + m2.Расход) / 8 * m2.kof * 3) /*+ m1.Расход220320_seti*0.9*/),0)) * -1 end as 'Заказ_по_прогнозу' --'Заказ по прогнозу' = ЕСЛИ('Дефицит'>0;0;'Дефицит'*-1)
			, CASE WHEN m1.Расход = 0 or m1.Расход_общий = 0 THEN 0 ELSE(isnull(((m1.Расход/m1.Расход_общий)*100),0)) END AS 'Доли_склада'
			, ((m1.Расход220320_seti + m2.Расход220320_seti)/2) AS 'Расход_сети_общий'
			FROM #Month1 m1
			LEFT JOIN #Month2 m2 on m2.ProdID = m1.ProdID
			WHERE ISNULL(m1.Остаток220_бр,0) != 0 OR ISNULL(m1.Остаток218_бр,0) != 0
			   ) v1
		) v2
	) v3
--WHERE ProdID in (33537)

--SELECT Расход,Расход_общий FROM #Month1
--WHERE ProdID in (31959)
--WHERE CONVERT(int,v3.Остаток220_бр) in (0) and CONVERT(int,v3.Резерв220) in (0) and CONVERT(int,v3.Остаток218_бр) in (0) and CONVERT(int,v3.Кор_Кратный_Факт_заказ) not in (0)
ORDER BY 'Категория','Проект','Код группы альтернатив','Наименование товара'

/*
SELECT PCatIDi, (SELECT top 1 PCatName FROM r_ProdC pc WHERE pc.PCatID = PCatIDi) PCatName 
,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52],[53]  
FROM at_t_PCatIDImport 
PIVOT ( 
MAX(Percents)FOR WeekID IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52],[53]) 
)pvt
ORDER BY 2
*/