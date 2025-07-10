SELECT * FROM t_saletemp where CRID = 104 and DeskCode = 1

SELECT ProdName, * FROM t_saletempd 
join r_prods on r_prods.ProdID = t_saletempd.ProdID 
where t_saletempd.ChID = 100197942 
and t_saletempd.ProdID in (SELECT ProdID FROM t_saletempd 
where ChID = 100197942
group by ProdID
having SUM(Qty) <>0)
order by 4


SELECT * FROM z_LogPrint where ChID = 100197942
order by 2 desc

SELECT ProdID FROM t_saletempd 
where ChID = 100197942
group by ProdID
having SUM(Qty) <>0

