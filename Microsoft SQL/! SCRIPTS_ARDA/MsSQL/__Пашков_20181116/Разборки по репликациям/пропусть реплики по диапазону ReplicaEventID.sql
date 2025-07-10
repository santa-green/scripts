--лечение. пропусть реплики по условию

--поиск репликций

select  * from z_ReplicaIn 
where status != 1 and replicaeventid between 4526 and 4997
order by replicaeventid 

--Изменение статуса на 1 для отмены репликации
update z_replicain 
set status = 1
where status != 1 and replicaeventid between 4526 and 4997


