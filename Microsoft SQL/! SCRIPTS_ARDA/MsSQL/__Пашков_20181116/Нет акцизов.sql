--INSERT t_SaleDLV
SELECT  m.ChID, d.SrcPosID, p.LevyID, (RealSum - SumCC_wt) LevySum --, d.ProdID, RealSum, l.LevySum ls, m.TLevySum, *
FROM t_Sale m WITH(NOLOCK)
LEFT JOIN t_SaleD d WITH(NOLOCK) ON m.ChID = d.ChID
LEFT JOIN t_SaleDLV l WITH(NOLOCK) ON l.ChID = m.ChID
LEFT JOIN r_ProdLV p WITH(NOLOCK) ON p.ProdID = d.ProdID
WHERE DocDate >= '2016-09-25' and m.StockID = 1260 and p.LevyID = 1
--and d.ChID = 4378
and l.LevySum is null
order by DocDate

--select * from t_SaleDLV

--TAU1_INS_t_SaleDLV
--TRel2_Upd_t_Sale - добавил себя pvm0 в этот тригер
