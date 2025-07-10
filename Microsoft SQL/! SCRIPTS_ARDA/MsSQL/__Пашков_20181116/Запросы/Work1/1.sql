use otdata
select t.chid , td.prodid , td.qty 
from t_saled td inner join t_sale t on td.chid = t.chid
where t.docdate = convert (datetime, '2005-05-08',102 )
order  by  td.prodid