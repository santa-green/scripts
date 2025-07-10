SELECT * FROM z_ReplicaSubs
SELECT * FROM z_ReplicaPubs where ReplicaPubCode = 12
SELECT * FROM z_ReplicaPubs where ReplicaPubCode = 1200000000

--список таблиц ќфис -> ElitRTS
SELECT zrt.TableCode,zt.TableName, zt.TableDesc FROM z_ReplicaTables zrt
join z_Tables zt on zt.TableCode = zrt.TableCode
where ReplicaPubCode = 12

--список таблиц  ElitRTS181 -> ќфис
SELECT zrt.TableCode,zt.TableName, zt.TableDesc FROM z_ReplicaTables zrt
join z_Tables zt on zt.TableCode = zrt.TableCode
where ReplicaPubCode = 1200000000

SELECT * FROM z_Tables
SELECT * FROM z_docs