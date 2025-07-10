select * from ElitR_316.dbo.z_Tables m where m.TableCode in (select m1.TableCode from ElitR_316.dbo.z_ReplicaTables m1 where m1.ReplicaPubCode = 12)
order by m.TableCode

select * from ElitR_316.dbo.z_ReplicaTables m1