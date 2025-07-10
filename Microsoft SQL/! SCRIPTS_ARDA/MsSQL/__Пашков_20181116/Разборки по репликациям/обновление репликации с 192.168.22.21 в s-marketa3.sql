USE ElitR_TEST
--обновление репликации с 192.168.22.21 в s-marketa3
--insert [s-marketa3].elitv_dp2.dbo.z_replicain 
	select  ReplicaEventID, 7 ReplicaSubCode, REPLACE(ExecStr ,'_10 ','_8 ') as ExecStr, 0 Status, Msg, DocTime from [192.168.22.21].elitv_O.dbo.z_replicain 
	where  ReplicaEventID >=9109954
	and ReplicaEventID not in (SELECT ReplicaEventID FROM [s-marketa3].elitv_dp2.dbo.z_replicain)
	order by ReplicaEventID


SELECT * FROM [s-marketa3].elitv_dp2.dbo.z_replicain
order by ReplicaEventID desc


  
/*
update __z_ReplicaIn
set ExecStr = REPLACE(ExecStr ,'_10 ','_8 ')
,ReplicaSubCode = 7
,Status = 0
from r_Prods
*/


SELECT * FROM [s-marketa3].elitv_dp2.dbo.z_replica