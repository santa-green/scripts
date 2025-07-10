use otdata
select r.prodid, p.prodname, r.pricemc, t.qty
from r_prodmp r--, t_rem t
inner join r_prods p on r.prodid=p.prodid
inner join t_rem t on r.prodid=t.prodid
where (pricemc-(convert(int,r.pricemc)))<0.10 and r.plid=0 and r.pricemc<>0 and t.qty<>0
order by p.prodname
