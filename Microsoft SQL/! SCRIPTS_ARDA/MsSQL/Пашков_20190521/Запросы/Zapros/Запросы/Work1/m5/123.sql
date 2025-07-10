select td.chid
from t_epp t full join t_eppd td on t.chid = td.chid
where t.chid is null
group by td.chid

select *
from t_eppd 
where chid = 848

select *
from t_epp
where chid = 848
