use ElitR
select top 1 * from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) where status != 1  --Dnepr Alef 10.1.0.155
order by replicaeventid  OPTION (FAST 1)

--это я вручную заливал расходные документы в локалку днепра
63268524	100000001	z_Replica_Ins_t_Exp_100000001 673,4049,'4','2016-05-31T00:00:00',28.000000000,8,704,10790,2032,2146,5,2531,2018,0.000000000,0,6429,'Расход пакетов для ИМ',0,'2016-05-31T00:00:00',NULL,NULL,NULL,NULL,980,75.000000000,15.000000000,90.000000000,0.000000000,0.000000000,0,0	2	Violation of PRIMARY KEY constraint 'pk_t_Exp'. Cannot insert duplicate key in object 'dbo.t_Exp'. The duplicate key value is (673).	2016-12-14 17:41:00
63268525	100000001	z_Replica_Ins_t_Exp_100000001 674,4050,'4','2016-06-06T00:00:00',26.000000000,8,704,10790,2032,2146,5,2531,2018,0.000000000,0,6429,'Расход для ИМ',0,'2016-06-06T00:00:00',NULL,NULL,NULL,NULL,980,75.000000000,15.000000000,90.000000000,0.000000000,0.000000000,0,0	2	Violation of PRIMARY KEY constraint 'pk_t_Exp'. Cannot insert duplicate key in object 'dbo.t_Exp'. The duplicate key value is (674).	2016-12-14 17:41:00
63268526
63268527
63268528
63268529	100000001	z_Replica_Ins_t_ExpD_100000001 673,1,601285,64,'шт',30.000000000,2.500000000,75.000000000,0.500000000,15.000000000,3.000000000,90.000000000,'2900006012855',1	2	Violation of PRIMARY KEY constraint '_pk_t_ExpD'. Cannot insert duplicate key in object 'dbo.t_ExpD'. The duplicate key value is (673, 1).	2016-12-14 17:41:00
63268531	100000001	z_Replica_Ins_t_ExpD_100000001 674,1,601285,64,'шт',30.000000000,2.500000000,75.000000000,0.500000000,15.000000000,3.000000000,90.000000000,'2900006012855',1	2	Violation of PRIMARY KEY constraint '_pk_t_ExpD'. Cannot insert duplicate key in object 'dbo.t_ExpD'. The duplicate key value is (674, 1).	2016-12-14 17:41:00
63268533	100000001	z_Replica_Ins_t_ExpD_100000001 675,1,601285,64,'шт',30.000000000,2.500000000,75.000000000,0.500000000,15.000000000,3.000000000,90.000000000,'2900006012855',1	2	Violation of PRIMARY KEY constraint '_pk_t_ExpD'. Cannot insert duplicate key in object 'dbo.t_ExpD'. The duplicate key value is (675, 1).	2016-12-14 17:41:00
63268535	100000001	z_Replica_Ins_t_ExpD_100000001 676,1,601285,64,'шт',50.000000000,2.500000000,125.000000000,0.500000000,25.000000000,3.000000000,150.000000000,'2900006012855',1	2	Violation of PRIMARY KEY constraint '_pk_t_ExpD'. Cannot insert duplicate key in object 'dbo.t_ExpD'. The duplicate key value is (676, 1).	2016-12-14 17:41:00
63268537	100000001	z_Replica_Ins_t_ExpD_100000001 678,1,601285,64,'шт',25.000000000,0.000000000,0.000000000,0.000000000,0.000000000,0.000000000,0.000000000,'2900006012855',1	2	Violation of PRIMARY KEY constraint '_pk_t_ExpD'. Cannot insert duplicate key in object 'dbo.t_ExpD'. The duplicate key value is (678, 1).	2016-12-14 17:41:00


--лечение. пропусть эту реплику изменив статус на 1
update [s-sql-d4].elitr.dbo.z_ReplicaIn
set status = 1
where status != 1 and ReplicaEventID = 63268537