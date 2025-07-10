use otdata
select td.prodid , sum (td.qty )
from t_sale t inner join t_saled td on t.chid = td.chid
where t.docdate between '18/01/2006'and '18/01/2006' and td.prodid = 424
group by td.prodid 
  