
SELECT ProdID, PriceMC, PromoPriceCC, BDate FROM r_ProdMP where PLID in (85) and PromoPriceCC >0
except
SELECT ProdID, PriceMC, PromoPriceCC, BDate FROM r_ProdMP where PLID in (72) and PromoPriceCC >0 and ProdID in (SELECT ProdID FROM r_ProdMP where PLID in (85))
order by EDate desc


SELECT ProdID, PriceMC FROM r_ProdMP where PLID in (85)
except
SELECT ProdID, PriceMC FROM r_ProdMP where PLID in (72) and ProdID in (SELECT ProdID FROM r_ProdMP where PLID in (85))
except
SELECT ProdID, PriceMC FROM r_ProdMP where PLID in (85)

SELECT * FROM r_ProdMP where PLID in (72,85) and ProdID in (802599,802404,603020)
order by 1


ip_ImpToRecFromTerm
ip_ImpFromTSD
