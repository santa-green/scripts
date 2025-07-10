select * from t_MonRec
where DocDate >= '2016-11-01'
and KursMC <> 27
--and StockID = 1315 

/*
update t_MonRec
set KursMC = 27
from t_MonRec
where DocDate >= '2016-11-01'
and KursMC <> 27
--and StockID = 1315 
*/