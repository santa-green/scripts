SELECT * FROM z_ReplicaPubs --������� ����������: ����������
SELECT * FROM z_ReplicaTables --������� ����������: ���������� - ������
SELECT * FROM z_ReplicaFilters --������� ����������: �������
SELECT * FROM z_ReplicaSubs --������� ����������: ��������
SELECT * FROM z_ReplicaPCs --������� ����������: �������� - ����������
SELECT * FROM z_ReplicaEvents --������� ����������: �������
SELECT * FROM z_ReplicaOut --������� ����������: ���������
SELECT * FROM z_ReplicaIn --������� ����������: ��������
SELECT * FROM z_ReplicaReplace --������� ����������: ������
SELECT * FROM z_ReplicaConfigEvents --������� ����������: ������� ������������
SELECT * FROM z_ReplicaConfigOut --������� ����������: ��������� ������������
SELECT * FROM z_ReplicaConfigSent --������� ����������: ������������ ������������
SELECT * FROM z_ReplicaConfigIn --������� ����������: �������� ������������
SELECT * FROM z_ReplicaFields --������� ����������: ����


SELECT * FROM z_ReplicaPubs where ReplicaPubCode = 12 --������� ����������: ����������
SELECT * FROM z_ReplicaTables  where ReplicaPubCode = 12--������� ����������: ���������� - ������
SELECT * FROM z_ReplicaFilters  where ReplicaPubCode = 12--������� ����������: �������
SELECT * FROM z_ReplicaSubs  where ReplicaPubCode = 12--������� ����������: ��������
SELECT * FROM z_ReplicaPCs where ReplicaSubCode in (15,16)--������� ����������: �������� - ����������
SELECT * FROM z_ReplicaFields  where ReplicaPubCode = 12 --������� ����������: ����
SELECT * FROM z_ReplicaReplace --������� ����������: ������

SELECT * FROM z_ReplicaConfigEvents --������� ����������: ������� ������������
SELECT * FROM z_ReplicaConfigOut --������� ����������: ��������� ������������
SELECT * FROM z_ReplicaConfigSent --������� ����������: ������������ ������������
SELECT * FROM z_ReplicaConfigIn --������� ����������: �������� ������������



SELECT * FROM z_ReplicaEvents   where ReplicaPubCode = 12--������� ����������: �������
SELECT * FROM z_ReplicaOut where ReplicaSubCode in (15,16)--������� ����������: ���������
SELECT * FROM z_ReplicaIn --������� ����������: ��������