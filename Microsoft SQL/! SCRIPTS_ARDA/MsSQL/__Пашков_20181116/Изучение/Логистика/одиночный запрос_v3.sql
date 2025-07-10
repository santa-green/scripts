DECLARE	-- укажите параметры
		 @StockID VARCHAR(MAX) = '4,304' -- склады на которые делается заказ
		,@PCatID VARCHAR(MAX) = '1-100' --код категории 
		,@PGrID1 VARCHAR(MAX) = '' --код группы 1
		,@ProdID VARCHAR(MAX) = '' --код товаров

-- определение дат
SET DATEFIRST 1 --установить первый день недели понедельник
DECLARE  @WeekID INT = DATEPART(week, GETDATE()) -- день недели
		,@BeginDate DATE = DATEADD(MONTH , -2 ,dbo.zf_GetDate( GETDATE() )) --Дата начала выборки, на 2 месяца меньше текушей
		,@EndDate DATE = dbo.zf_GetDate( GETDATE() ) --Дата конца выборки, текущая дата
		 
--SELECT @BeginDate BeginDate,  @EndDate EndDate, @WeekID WeekID

/*блок выборок*/
;WITH 
	 Rem218_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 218 GROUP BY ProdID )
	,Rem220_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 220 GROUP BY ProdID )
	,Rem_CTE AS( SELECT ProdID, SUM(Qty) SumQty FROM t_rem m WITH(NOLOCK) WHERE  StockID in ( select AValue from zf_FilterToTable(@StockID) ) GROUP BY ProdID )
	,gr_t_Ret_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) )	and m.CodeID1 <> 100 GROUP BY d.ProdID
					)
	,gr_t_Inv_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 GROUP BY d.ProdID
					)
	,gr_t_Exp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 GROUP BY d.ProdID
					)
	,gr_t_Epp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 GROUP BY d.ProdID
					)


SELECT *
,CASE WHEN Остаток_на_ЦС_бр < Кратный_Факт_заказ THEN Остаток_на_ЦС_бр ELSE Кратный_Факт_заказ END as 'Кор_Кратный_Факт_заказ' 
, (CASE WHEN Остаток_на_ЦС_бр < Кратный_Факт_заказ THEN Остаток_на_ЦС_бр ELSE Кратный_Факт_заказ END ) / Остаток_на_ЦС_бр as 'Процент_от_остатка'
FROM (		
	SELECT *
	,(isnull((round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике),0)) as 'кратный_Заказ_по_прогнозу' --'кратный_Заказ_по_прогнозу' = ОКРУГЛ(Заказ_по_прогнозу/Кол_в_ящике;0)*Кол_в_ящике
	,(CASE WHEN (Остаток_на_ЦС_бр - (isnull((round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике),0)) ) > 0 THEN (round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике) ELSE Остаток_на_ЦС_бр END) as 'Факт_заказ' --'Факт_заказ' = =ЕСЛИ(Остаток_на_ЦС - кратный_Заказ_по_прогнозу >0;кратный_Заказ_по_прогнозу;Остаток_на_ЦС)
	,(isnull((round( ((CASE WHEN (Остаток_на_ЦС_бр - (isnull((round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике),0)) ) > 0 THEN (round(Заказ_по_прогнозу / Кол_в_ящике,0) * Кол_в_ящике) ELSE Остаток_на_ЦС_бр END)) / Кол_в_ящике,0) * Кол_в_ящике),0)) as 'Кратный_Факт_заказ' --'Кратный_Факт_заказ' 
	FROM (
		 
		SELECT ProdID, PCatID, PCatName, ProdName, PGrID1, PGrName1, Кол_в_ящике, SumQty_t_Ret, SumQty_t_Inv, SumQty_t_Exp, SumQty_t_Epp,
		Остаток_на_ЦС_бр, Резерв_на_ЦС, Остаток220_бр,Резерв220, Остаток218_бр, Резерв218, Остаток, Расход, kof 
		,(Расход / 8 * kof * 4) as 'Прогноз'  --'Прогноз'
		,(isnull(((Остаток - (Расход / 8 * kof * 4))),0)) as 'Дефицит'  --  Остаток - Прогноз = Дефицит
		, case when (isnull(((Остаток - (Расход / 8 * kof * 4))),0)) > 0 then 0 else (isnull(((Остаток - (Расход / 8 * kof * 4))),0)) * -1 end as 'Заказ_по_прогнозу' --'Заказ по прогнозу' = ЕСЛИ('Дефицит'>0;0;'Дефицит'*-1)
		FROM ( 
		   
			--текущие остатки по центральному (220,218) складу с которого отгружать
			SELECT gr.ProdID,  gr.SumQty_AccQty 'Остаток_на_ЦС_бр', p.PCatID, r_ProdC.PCatName, p.ProdName, p.PGrID1, r_ProdG1.PGrName1 , isnull(mq.Qty,1) 'Кол_в_ящике',
			gr_t_Ret.SumQty SumQty_t_Ret,gr_t_Inv.SumQty SumQty_t_Inv ,gr_t_Exp.SumQty SumQty_t_Exp,gr_t_Epp.SumQty SumQty_t_Epp, 
			gr_t_Rem.SumQty 'Остаток' , gr_t_Rem218.SumQty_AccQty 'Остаток218_бр' , gr_t_Rem220.SumQty_AccQty 'Остаток220_бр',
			gr.SumAccQty 'Резерв_на_ЦС' , gr_t_Rem218.SumAccQty 'Резерв218' , gr_t_Rem220.SumAccQty 'Резерв220'
			, (ISNULL(gr_t_Inv.SumQty,0) + ISNULL(gr_t_Exp.SumQty,0)  + ISNULL(gr_t_Epp.SumQty,0) - ISNULL(gr_t_Ret.SumQty,0))  'Расход'
			,dbo.af_GetPercentsForPCatIDImport(p.PCatID,@WeekID) kof
			FROM (
				SELECT ProdID,  SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK)
				WHERE  StockID in (220,218)
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

			WHERE ((0 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PCatID,@PCatID,',')) = 1 and 1 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ))
			  AND ((0 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PGrID1,@PGrID1,',')) = 1 and 1 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ))
			  AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
			  AND gr.SumQty_AccQty > 0

			) v1
		) v2
	) v3
ORDER BY 'Факт_заказ' desc
--ORDER BY 5 desc

