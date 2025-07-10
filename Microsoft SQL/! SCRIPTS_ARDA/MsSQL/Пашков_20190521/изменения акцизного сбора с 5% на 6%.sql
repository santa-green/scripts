--изменения акцизного сбора с 5% на 6%
BEGIN TRAN

EXECUTE AS LOGIN = 'CORP\Cluster';

SELECT sum(TSumCC_nt), sum( TTaxSum), sum( TSumCC_wt), sum( TPurSumCC_nt), sum( TPurTaxSum), sum( TPurSumCC_wt), sum( TRealSum), sum( TLevySum) FROM t_Sale m
WHERE m.DocDate between '20170901' and '20170912'
and m.CRID = 502 
ORDER BY 1

SELECT sum(p.LevySum) FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
 JOIN t_SaleDLV p ON p.ChID = d.ChID and p.SrcPosID = d.SrcPosID
WHERE m.DocDate between '20170901' and '20170912'
and m.CRID = 502 
ORDER BY 1
--1384,490000000


update p 
set p.LevySum = p.LevySum * 1.188679245
FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
 JOIN t_SaleDLV p ON p.ChID = d.ChID and p.SrcPosID = d.SrcPosID
WHERE m.DocDate between '20170901' and '20170912'
and m.CRID = 502 

-- обновить заголовки 
exec ap_UpdateDocTotals
 
SELECT sum(p.LevySum) FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
 JOIN t_SaleDLV p ON p.ChID = d.ChID and p.SrcPosID = d.SrcPosID
WHERE m.DocDate between '20170901' and '20170912'
and m.CRID = 502 
ORDER BY 1
--1645.714527920

SELECT sum(TSumCC_nt), sum( TTaxSum), sum( TSumCC_wt), sum( TPurSumCC_nt), sum( TPurTaxSum), sum( TPurSumCC_wt), sum( TRealSum), sum( TLevySum) FROM t_Sale m
WHERE m.DocDate between '20170901' and '20170912'
and m.CRID = 502 
ORDER BY 1

REVERT

ROLLBACK TRAN



-- обновить заголовки  
--  ap_UpdateDocTotals

SELECT sum(TSumCC_nt), sum( TTaxSum), sum( TSumCC_wt), sum( TPurSumCC_nt), sum( TPurTaxSum), sum( TPurSumCC_wt), sum( TRealSum), sum( TLevySum) FROM t_Sale m
WHERE m.DocDate between '20170901' and '20170912'
and m.CRID = 502 
ORDER BY 1
-- sum(TSumCC_nt), sum( TTaxSum), sum( TSumCC_wt), sum( TPurSumCC_nt), sum( TPurTaxSum), sum( TPurSumCC_wt), sum( TRealSum), sum( TLevySum) FROM t_Sale m
--25944.351995080	5188.870304940	31133.222320000	33249.667500045	6419.178499995	39899.601000000	32517.752320000	1384.490000000

SELECT * FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
 JOIN t_SaleDLV p ON p.ChID = d.ChID
WHERE m.DocDate between '20170901' and '20170912'
and m.CRID = 502 
ORDER BY 1


SELECT p.* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
 JOIN t_SaleDLV p ON p.ChID = d.ChID and p.SrcPosID = d.SrcPosID
WHERE m.DocDate between '20170901' and '20170912'
and m.CRID = 502 
ORDER BY 1
--1384,490000000


SELECT p.* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
 JOIN t_SaleDLV p ON p.ChID = d.ChID and p.SrcPosID = d.SrcPosID
WHERE m.DocDate between '20170913' and '20170930'
and m.CRID = 502 
ORDER BY 1
--38949,650000000

