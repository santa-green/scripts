use ElitR
select * from [s-sql-d4].elitr.dbo.z_ReplicaIn where status != 1 
order by replicaeventid

select * from [s-marketa].elitv_dp.dbo.z_replicain where status != 1 
order by replicaeventid

select * from [s-marketa2].elitv_kiev.dbo.z_replicain where status != 1 
order by replicaeventid

--select * from [s-marketa3].elitv_dp2.dbo.z_replicain where status != 1 
--order by replicaeventid


/*
use ElitR
select * from [s-sql-d4].elitr.dbo.z_ReplicaIn where status != 1 
order by replicaeventid
declare @prodid int,  @ppid int
set @prodid = 610113 
set @ppid   = 186

select * from t_Rem  where ProdID = @prodid and PPID = @ppid 
select * from t_PInP where ProdID = @prodid and PPID = @ppid 

delete  from t_Rem  where ProdID = @prodid  and PPID = @ppid 
delete  from t_PInP where ProdID = @prodid  and PPID = @ppid 

select * from t_Rem  where ProdID = @prodid and PPID = @ppid 
select * from t_PInP where ProdID = @prodid and PPID = @ppid 

ALTER TABLE dbo.t_PInP DISABLE TRIGGER TReplica_Ins_t_PInP
INSERT t_PInP
SELECT *
FROM [s-sql-d4].elitR.dbo.t_PInP tp
WHERE exists (SELECT * FROM [s-sql-d4].elitR.dbo.t_ExcD WHERE ChID = 100016702  AND ProdID = tp.ProdID AND PPID = tp.PPID)
AND not exists (SELECT * FROM t_PInP WHERE ProdID = tp.ProdID and PPID = tp.PPID)
ALTER TABLE dbo.t_PInP ENABLE TRIGGER TReplica_Ins_t_PInP



*/