select * from [192.168.22.21].elitv_O.dbo.z_replicain where status != 1 --Odessa 192.168.22.21
order by replicaeventid

7450166	9	z_Replica_Ins_t_PInP_10 600226,0,NULL,0.000000000,0.000000000,0,'1900-01-01T00:00:00',NULL,0,0,NULL,0.000000000,0.000000000,NULL,NULL,NULL,0.000000000,0.000000000,0,NULL,0,0.000000000,0.000000000,NULL,NULL,0,0,NULL	2	Нарушение "_pk_t_PInP" ограничения PRIMARY KEY. Не удается вставить повторяющийся ключ в объект "dbo.t_PInP". Повторяющееся значение ключа: (600226, 0).	2016-10-17 11:05:00.000

--лечение. пропусть эту реплику
update [192.168.22.21].elitv_O.dbo.z_replicain
set status = 1
where status != 1 and ReplicaEventID = 7450166