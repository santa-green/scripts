
select t.docdate ,t.compid , r.compname ,sum (td.sumcc_wt),t.chid ,sum(tp.paysumcc), r.codeid1
from t_rec t inner join r_comps r on t.compid= r.compid inner join t_recD td on t.chid = td.chid full join t_recpo tp
		on td.chid= tp.chid
	where tp.chid is null and r.codeid1 = 58 and r.compname not like 'малин%' and r.compid <> 5
group by t.docdate ,t.compid , r.compname ,t.chid ,r.codeid1
order by t.docdate ,t.compid 