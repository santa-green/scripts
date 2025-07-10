43153115	300000000	z_Replica_Ins_z_LogDiscExp_300000000 1443576,'<Нет дисконтной карты>',0,11035,300026025,1,27,0.000000000,23.429541596,'2016-12-14T18:29:00',0,NULL,NULL,4	2	Violation of PRIMARY KEY constraint 'pk_z_LogDiscExp'. Cannot insert duplicate key in object 'dbo.z_LogDiscExp'. The duplicate key value is (4, 1443576).	2016-12-14 18:35:00.000

select * from z_LogDiscExp --where DBiID = 4 --and LogID = 1443576
order by LogDate desc

select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp where LogID = 1443576

select * from z_LogDiscExp where LogID = 1443576

select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp where LogID = 1443577

select * from t_sale where ChID = 300026025

select * from [s-marketa3].elitv_dp2.dbo.t_sale where ChID = 300026025


select * from z_LogDiscExp where ChID = 300026025

select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp where ChID = 300026025

select top 1 * from z_replicain WITH (NOLOCK) where ReplicaEventID = 43153115 --Dnepr Vintage 192.168.70.2
order by replicaeventid  OPTION (FAST 1)