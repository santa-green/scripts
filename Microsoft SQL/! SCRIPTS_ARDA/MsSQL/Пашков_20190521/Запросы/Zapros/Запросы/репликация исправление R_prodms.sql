--íà áàçå ìàãàçèíà
select * 
from z_ReplicaIn
where Status != 1  and ExecStr like '%z_Replica_Upd_r_ProdMS_100000002%%,%%,0,0,0,%'
order by ReplicaEventID


update z_ReplicaIn
set ExecStr = REPLACE (ExecStr ,',0,0,0,',',0,0,' ) 
from z_ReplicaIn
where Status != 1  and ExecStr like '%z_Replica_Upd_r_ProdMS_100000002%%,%%,0,0,0,%'



--íà áàçå ìàãàçèíà
select * 
from z_ReplicaIn
where Status != 1  and ExecStr like '%z_Replica_Ins_r_ProdMS_100000002%%,%%,0,0,0%'
order by ReplicaEventID


update z_ReplicaIn
set ExecStr = REPLACE (ExecStr ,',0,0,0',',0,0' ) 
from z_ReplicaIn
where Status != 1  and ExecStr like '%z_Replica_Ins_r_ProdMS_100000002%%,%%,0,0,0%'