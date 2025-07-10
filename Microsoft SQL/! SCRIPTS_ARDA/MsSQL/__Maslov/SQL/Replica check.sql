use ElitR
select ReplicaEventID, ReplicaSubCode, ExecStr as 'ЦЕНТРАЛЬНЫЙ СЕРВЕР, Днепр [S-SQL-D4].ElitR 10.1.0.155', Status, Msg, DocTime 
from [s-sql-d4].elitr_test_spp.dbo.z_ReplicaIn WITH (NOLOCK) where status != 1 ORDER BY ReplicaEventID  OPTION (FAST 1)
GO
select ReplicaEventID, ReplicaSubCode, ExecStr as 'Днепр, локальный сервер 192.168.70.137', Status, Msg, DocTime 
from [192.168.70.137].ElitRTS502.dbo.z_replicain WITH (NOLOCK) where status != 1 ORDER BY ReplicaEventID  OPTION (FAST 1)
