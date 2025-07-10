

BEGIN TRAN

DECLARE @s nvarchar(100) = '%r_ProdMS'
select  * from z_ReplicaIn where status != 1 
and ExecStr like @s + '%'
order by replicaeventid 

update z_ReplicaIn
set ExecStr = SUBSTRING (ExecStr, 1, LEN(ExecStr)-2)
FROM z_ReplicaIn where  status != 1 
and ExecStr like @s + '%'

select  * from z_ReplicaIn where status != 1 
and ExecStr like @s + '%'
order by replicaeventid 

ROLLBACK TRAN
