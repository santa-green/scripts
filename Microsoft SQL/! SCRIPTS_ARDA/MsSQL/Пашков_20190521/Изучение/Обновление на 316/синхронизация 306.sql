SELECT * FROM z_ReplicaSubs
SELECT * FROM z_ReplicaPubs where ReplicaPubCode = 12
SELECT * FROM z_ReplicaPubs where ReplicaPubCode = 1200000000

--������ ������ ���� -> ElitRTS
SELECT zrt.TableCode,zt.TableName, zt.TableDesc FROM z_ReplicaTables zrt
join z_Tables zt on zt.TableCode = zrt.TableCode
where ReplicaPubCode = 12

--������ ������  ElitRTS181 -> ����
SELECT zrt.TableCode,zt.TableName, zt.TableDesc FROM z_ReplicaTables zrt
join z_Tables zt on zt.TableCode = zrt.TableCode
where ReplicaPubCode = 1200000000

SELECT * FROM z_Tables
SELECT * FROM z_docs