use ElitR
select * from [s-marketa].elitv_dp.dbo.z_ReplicaIn where status != 1 --Dnepr Alef 10.1.0.155
order by replicaeventid

7580291	100000002	z_Replica_Ins_t_PInP_100000002 611616,0,NULL,0.000000000,0.000000000,0,NULL,NULL,980,0,NULL,0.000000000,0.000000000,'',NULL,NULL,0.000000000,0.000000000,0,NULL,0,0.000000000,0.000000000,NULL,NULL,0,0,NULL	2	Violation of PRIMARY KEY constraint '_pk_t_PInP'. Cannot insert duplicate key in object 'dbo.t_PInP'. The duplicate key value is (611616, 0).	2016-11-02 15:40:00.000

--лечение. пропусть эту реплику изменив статус на 1
update [s-marketa].elitv_dp.dbo.z_ReplicaIn
set status = 1
where status != 1 and ReplicaEventID = 7580291