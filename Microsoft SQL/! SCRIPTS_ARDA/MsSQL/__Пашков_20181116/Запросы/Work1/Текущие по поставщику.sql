use otdata 
declare @p int 
set @p=3
select r.prodid ,r.prodname, r.um, sum (t.qty)as 'Текущие остатки'
from t_rem t inner join r_prods r on t.prodid = r.prodid 
 	inner join t_pinp tp on t.prodid = tp.prodid 
where tp.compid =@p and t.ppid = tp.ppid
group by r.prodid , r.um,r.prodname