select * from t_MonRec
where DocDate >= '2016-10-01'
and KursMC <> 27

/*
update t_MonRec
set KursMC = 27
from t_MonRec
where DocDate >= '2016-10-01'
and KursMC <> 27

*/