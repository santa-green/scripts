--�� ���� ��������
select * 
from z_ReplicaIn
where Status != 1 -- and ExecStr like '%���%'
order by ReplicaEventID

/*
update z_ReplicaIn
set ExecStr = REPLACE (ExecStr ,'���','Jan' ) 
from z_ReplicaIn
where Status !=1 and ExecStr like '%���%'
*/


