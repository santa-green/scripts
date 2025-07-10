--смена статуса репликации на 1 - пропустить реплику
update z_ReplicaIn
set status = 1
where status != 1 and ReplicaEventID = 8056576