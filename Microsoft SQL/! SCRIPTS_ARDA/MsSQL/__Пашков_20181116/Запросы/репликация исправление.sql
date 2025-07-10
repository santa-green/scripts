--на базе магазина
select * 
from z_ReplicaIn
where Status != 1 -- and ExecStr like '%янв%'
order by ReplicaEventID

/*
update z_ReplicaIn
set ExecStr = REPLACE (ExecStr ,'янв','Jan' ) 
from z_ReplicaIn
where Status !=1 and ExecStr like '%янв%'
*/


