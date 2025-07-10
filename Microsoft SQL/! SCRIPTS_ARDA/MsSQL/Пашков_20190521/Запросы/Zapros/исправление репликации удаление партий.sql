use elitr
select * from [s-sql-d4].elitr.dbo. z_replicain where status !=1 and ReplicaSubCode <> 70000000
order by replicaeventid

select * from t_rem where prodid = 610169 and ppid = 116
select * from t_pinp  where prodid = 610169 and ppid = 116


delete  from t_rem where prodid = 610169 and ppid = 116
delete   from t_pinp  where prodid = 610169 and ppid = 116