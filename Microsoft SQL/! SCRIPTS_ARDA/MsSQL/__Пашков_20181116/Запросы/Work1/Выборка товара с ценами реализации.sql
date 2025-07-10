use otdata
select r.prodid, r.prodname, p.pricemc
from r_prods r, r_prodmp p
where r.prodname like 'сигареты%' and r.prodid=p.prodid
order by r.prodname