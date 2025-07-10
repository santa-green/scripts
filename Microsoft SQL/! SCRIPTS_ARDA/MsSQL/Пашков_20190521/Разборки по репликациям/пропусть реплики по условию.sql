--лечение. пропусть реплики по условию

--поиск репликций
DECLARE @s nvarchar(100) = 'z_Replica_Upd_t_CRRet_800000000'
select  * from z_ReplicaIn where status != 1 
and ExecStr like @s + '%'
order by replicaeventid 

--Изменение статуса на 1 для отмены репликации
update z_replicain 
set status = 1
where status != 1 and ExecStr like @s + '%'


