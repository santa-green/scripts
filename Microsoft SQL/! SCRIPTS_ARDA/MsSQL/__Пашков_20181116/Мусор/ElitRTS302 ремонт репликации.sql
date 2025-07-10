	4525	1100000000	z_Replica_Ins_z_DocDC_1100000000 11035,1100000168,'<Нет дисконтной карты>'	2	Violation of PRIMARY KEY constraint 'pk_z_DocDC'. Cannot insert duplicate key in object 'dbo.z_DocDC'. The duplicate key value is (11035, 1100000168, <Нет дисконтной карты>).	2017-06-23 12:40:00
	
	z_Replica_Upd_t_Sale_1100000000 1100000185,1100000185,'2017-06-23T00:00:00',27.000000000,6,1260,1,63,18,92,0,0,0.000000000,'',302,384,'','2017-06-23T11:25:27.803',0,'2017-06-23T00:00:00','<Нет дисконтной карты>',10584,NULL,401.300000000,60.000000000,980,270.880000000,54.170000000,325.050000000,22,0,0,360.958333330,72.191666670,433.150000000,'2017-06-23T11:15:23.373',0,0,0,NULL,NULL,NULL,0,341.300000000,16.250000000,NULL,1100000185
	
	SELECT * FROM z_DocDC where ChID = 1100000168
	
	SELECT * FROM t_Sale where ChID = 1100000186
	
	
	select '' as 's-sql-d4', * from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) where ExecStr like 'z_Replica_Ins_z_DocDC_1100000000 11035,1100000168%' --status != 1  --Dnepr Alef 10.1.0.155
order by replicaeventid  OPTION (FAST 1)


select * from [s-sql-d4].elitr.dbo.z_ReplicaIn where ReplicaSubCode = 1100000000--where ReplicaEventID in (4525,4526)
order by replicaeventid

select * from [192.168.157.22].ElitRTS302.dbo.z_ReplicaOut where ReplicaEventID in (4525,4526)

SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_ReplicaEvents where ReplicaEventID >4525 ORDER BY ReplicaEventID

SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_ReplicaEvents ORDER BY ReplicaEventID

SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_ReplicaOut ORDER BY ReplicaEventID