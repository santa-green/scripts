select t.docdate , t.chid , sum(td.sumcc_wt)as summcc
into _t_sale 
from t_sale t inner join t_saled td on t.chid = td.chid
where  t.docdate BETWEEN CONVERT(DATETIME, '2007-08-01 00:00:00', 102) AND CONVERT(DATETIME, '2007-08-31 00:00:00', 102)
group by t.docdate , t.chid 
order by t.docdate 


select docdate , count (chid)
from _t_sale
where summcc > 200 --and summcc <=200
group by docdate
order by docdate

