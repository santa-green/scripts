--проверка репликации в киеве
select * from [s-marketa2].elitv_kiev.dbo.z_replicain where status != 1 --Kiev 192.168.74.3
order by replicaeventid
/*
7450167	100000002	z_Replica_Ins_t_PInP_100000002 600226,0,NULL,0.000000000,0.000000000,0,'1900-01-01T00:00:00',NULL,0,0,NULL,0.000000000,0.000000000,NULL,NULL,NULL,0.000000000,0.000000000,0,NULL,0,0.000000000,0.000000000,NULL,NULL,0,0,NULL	2	Violation of PRIMARY KEY constraint '_pk_t_PInP'. Cannot insert duplicate key in object 'dbo.t_PInP'. The duplicate key value is (600226, 0).	2016-10-17 11:05:00
*/
/*лечение

declare @prodid int,  @ppid int
set @prodid = 600226 
set @ppid   = 0

select * from t_Rem  where ProdID = @prodid and PPID = @ppid 
select * from t_PInP where ProdID = @prodid and PPID = @ppid 

delete  from t_Rem  where ProdID = @prodid  and PPID = @ppid 
delete  from t_PInP where ProdID = @prodid  and PPID = @ppid 

select * from t_Rem  where ProdID = @prodid and PPID = @ppid 
select * from t_PInP where ProdID = @prodid and PPID = @ppid 



*/