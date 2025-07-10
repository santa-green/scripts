select *
from t_rem t full join t_zInP tz on t.prodid = tz.prodid
where t.prodid is null