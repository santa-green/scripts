select * from [s-marketa3].elitv_dp2.dbo.z_replicain where status != 1 --Harkov 192.168.126.21
order by replicaeventid

7450164	7	z_Replica_Ins_t_PInP_8 600226,0,NULL,0.000000000,0.000000000,0,'1900-01-01T00:00:00',NULL,0,0,NULL,0.000000000,0.000000000,NULL,NULL,NULL,0.000000000,0.000000000,0,NULL,0,0.000000000,0.000000000,NULL,NULL,0,0,NULL	2	Violation of PRIMARY KEY constraint '_pk_t_PInP'. Cannot insert duplicate key in object 'dbo.t_PInP'. The duplicate key value is (600226, 0).	2016-10-17 11:05:00.000

--лечение. пропусть эту реплику
update [s-marketa3].elitv_dp2.dbo.z_replicain
set status = 1
where status != 1 and ReplicaEventID = 7450164