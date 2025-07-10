--S-marketa3 зайти под GMSSync
USE ElitV_DP2

-- просмотр не проведенных реплик
SELECT * FROM z_ReplicaIn where status != 1
order by ReplicaEventID 

/*
--запуск репликации S-marketa3
exec z_ReplicaExecCmds 7

*/