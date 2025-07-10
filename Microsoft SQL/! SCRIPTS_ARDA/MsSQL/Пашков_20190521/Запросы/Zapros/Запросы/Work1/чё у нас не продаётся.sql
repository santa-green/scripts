use otdata
select r.prodid, r.prodname
from r_prods r
inner join t_rem t on r.prodid=t.prodid
full join t_crsaled d on r.prodid=d.prodid
where t.qty >0.5 and d.prodid is null
order by r.prodid