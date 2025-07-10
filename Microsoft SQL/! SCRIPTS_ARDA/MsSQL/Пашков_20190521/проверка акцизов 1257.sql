--проверка на разницу между суммами и акцизом в документе 
SELECT m.ChID, m.DocID, m.TRealSum, m.TSumCC_wt, (m.TRealSum - m.TSumCC_wt) ls, m.TLevySum, abs((m.TRealSum - m.TSumCC_wt) - m.TLevySum) as razn, *
FROM t_Sale m WITH(NOLOCK)
WHERE m.StockID = 1315
--and m.ChID = 5380 
and DocDate between '2016-10-01' and '2016-10-31'
and abs((m.TRealSum - m.TSumCC_wt) - m.TLevySum) >0.05




--INSERT t_SaleDLV
SELECT   m.ChID, d.SrcPosID, p.LevyID, (RealSum - SumCC_wt) LevySum --, d.ProdID,  RealSum, SumCC_wt,  l.LevySum dlv  , * 
FROM t_Sale m WITH(NOLOCK)
LEFT JOIN t_SaleD d WITH(NOLOCK) ON m.ChID = d.ChID
LEFT JOIN t_SaleDLV l WITH(NOLOCK) ON l.ChID = m.ChID
LEFT JOIN r_ProdLV p WITH(NOLOCK) ON p.ProdID = d.ProdID
WHERE DocDate between '2016-10-01' and '2016-10-31' --период за который добавляется акциз
and m.StockID = 1315 and p.LevyID = 1
--and d.ChID = 5273
and 
--and l.LevySum is null
order by d.ProdID


--select * from t_SaleDLV

--TAU1_INS_t_SaleDLV
--TRel2_Upd_t_Sale - добавил себя pvm0 в этот тригер

SELECT * FROM t_Sale WHERE ChID = 100379640
SELECT * FROM t_SaleD WHERE ChID = 100379640
SELECT * FROM t_SaleDLV WHERE ChID = 100379640


SELECT d.ChID, d.Prodid,   d.RealSum, d.SumCC_wt, l.LevySum,l.LevySum - (d.RealSum - d.SumCC_wt) as ls, SumCC_nt,TaxSum,(d.RealSum/l.LevySum) as a
FROM  t_Sale m WITH(NOLOCK)
JOIN  t_SaleD d WITH(NOLOCK) ON m.ChID = d.ChID
JOIN t_SaleDLV l WITH(NOLOCK) ON l.ChID = d.ChID and l.SrcPosID = d.SrcPosID
WHERE m.DocDate between '2016-10-01' and '2016-10-31' and
--d.ChID = 100379640 and 
 m.StockID = 1315 --and p.LevyID = 1
 and m.CRID = 154
order by ls ,m.DocDate, d.ChID

SELECT * FROM t_Sale m
WHERE m.DocDate between '2016-10-01' and '2016-10-31' and
 m.StockID = 1315 
 and m.CRID = 154
 --and TRealSum = 42

--выборка как в ркипере
SELECT   max(m.DocID) DocID, max(d.ProdID) ProdID, sum(d.RealSum) RealSum, sum(isnull(l.LevySum,0)) LevySum, sum(d.TaxSum) TaxSum, max(d.ChID) ChID
FROM t_Sale m
JOIN t_SaleD d on m.ChID = d.ChID
left JOIN t_SaleDLV l WITH(NOLOCK) ON l.ChID = d.ChID and l.SrcPosID = d.SrcPosID
WHERE m.DocDate between '2016-10-01' and '2016-10-31' and
 m.StockID = 1315 
 and m.CRID = 154
 and d.ProdID in (605424)
 --and DocID = 127547
 group by m.DocID, d.ProdID
 order by m.DocID, d.ProdID 
 
