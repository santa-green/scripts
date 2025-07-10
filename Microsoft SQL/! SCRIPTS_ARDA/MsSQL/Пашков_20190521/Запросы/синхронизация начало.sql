select r4.prodid
from [s-sql-d4].ElitVintage.dbo.r_prods r4 left join r_Prods r on r4.prodid =r.ProdID
where r.ProdID is null
order by r4.prodid

select r4.* 
from [s-sql-d4].ElitVintage.dbo.r_prodMP r4 left join r_ProdMP r on r4.prodid =r.ProdID
where r.ProdID is null


select r4.* 
from [s-sql-d4].ElitVintage.dbo.r_prodMQ r4 left join r_ProdMQ r on r4.prodid =r.ProdID
where r.ProdID is null


select t4.*
from [s-sql-d4].ElitVintage.dbo.t_pinp t4 left join t_pinp r on t4.prodid =r.ProdID
where r.ProdID is null and t4.ppid = 0
order  by t4.prodid


