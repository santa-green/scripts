--INSERT t_SaleDLV
SELECT  m.ChID, d.SrcPosID, p.LevyID, (RealSum - SumCC_wt) LevySum-- , d.ProdID, RealSum, l.LevySum ls, m.TLevySum, *
FROM t_Sale m WITH(NOLOCK)
LEFT JOIN t_SaleD d WITH(NOLOCK) ON m.ChID = d.ChID
LEFT JOIN t_SaleDLV l WITH(NOLOCK) ON l.ChID = m.ChID
LEFT JOIN r_ProdLV p WITH(NOLOCK) ON p.ProdID = d.ProdID
WHERE DocDate between '2017-01-01' and '2017-01-31'
and m.StockID = 1260 and p.LevyID = 1
--and d.ChID = 4378
and l.LevySum is null
order by DocDate

--select * from t_SaleDLV

--TAU1_INS_t_SaleDLV
--TRel2_Upd_t_Sale - добавил себя pvm0 в этот тригер

select p.ProdID, LevyID,* from r_Prods p
LEFT JOIN r_ProdLV l WITH(NOLOCK) ON p.ProdID = l.ProdID
where p.ProdID in (605424,607276,607277,607336,607337,607339,607340,607341,607342)

