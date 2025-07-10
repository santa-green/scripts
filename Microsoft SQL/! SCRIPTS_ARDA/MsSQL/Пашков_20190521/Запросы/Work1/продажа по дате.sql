set dateformat dmy
use otdata
declare @p datetime
set @p='16/01/2006'
select left (t.docdate,11), td.prodid, sum (td.qty)
from t_sale t inner join t_saled td on t.chid = td.chid
where left (t.docdate,11) between @p and @p and td.prodid = 401
group by left (t.docdate,11), td.prodid
