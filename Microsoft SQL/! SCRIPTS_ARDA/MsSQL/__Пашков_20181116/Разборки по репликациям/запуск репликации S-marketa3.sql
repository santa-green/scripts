--S-marketa3 ����� ��� GMSSync
USE ElitV_DP2

-- �������� �� ����������� ������
SELECT * FROM z_ReplicaIn where status != 1
order by ReplicaEventID 

/*
--������ ���������� S-marketa3
exec z_ReplicaExecCmds 7

*/