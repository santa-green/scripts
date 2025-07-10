SELECT r.ReplicaPubCode,t.TableName, t.TableDesc,d.DocName,* FROM z_ReplicaFilters r
join z_Tables t on t.TableCode = r.TableCode
join z_docs d on d.DocCode = t.DocCode
where ReplicaPubCode = 13
order by d.DocName,t.TableDesc


SELECT * FROM z_ReplicaFields
SELECT * FROM z_ReplicaFilters
SELECT * FROM z_ReplicaIn
SELECT * FROM z_ReplicaPCs
SELECT * FROM z_ReplicaPubs
SELECT * FROM z_ReplicaSubs
SELECT * FROM z_ReplicaTables
SELECT * FROM z_RoleDocs
SELECT * FROM z_RoleObjects
SELECT * FROM z_Roles
SELECT * FROM z_RoleTables
SELECT * FROM z_RoleUsers
SELECT * FROM z_Tables where TableName = 't_EOExp'
SELECT * FROM z_docs