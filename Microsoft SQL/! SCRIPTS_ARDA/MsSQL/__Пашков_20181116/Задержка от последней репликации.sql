--Задержка от последней репликации
select top 1  's-sql-d4 - ' + str(DATEPART(n, GETDATE() - DocTime)) as 'задержка репликации, мин' from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) order by DocTime desc OPTION (FAST 1)
select top 1  's-marketa - ' + str(DATEPART(n, GETDATE() - DocTime))  as 'задержка репликации, мин' from [s-marketa].elitv_dp.dbo.z_replicain WITH (NOLOCK) order by DocTime desc OPTION (FAST 1)
select top 1  's-marketa2 - ' + str(DATEPART(n, GETDATE() - DocTime))  as 'задержка репликации, мин' from [s-marketa2].elitv_kiev.dbo.z_replicain WITH (NOLOCK) order by DocTime desc OPTION (FAST 1)
select top 1  's-marketa3 - ' + str(DATEPART(n, GETDATE() - DocTime))  as 'задержка репликации, мин' from [s-marketa3].elitv_dp2.dbo.z_replicain WITH (NOLOCK) order by DocTime desc OPTION (FAST 1)
select top 1  's-marketa5 - ' + str(DATEPART(n, GETDATE() - DocTime))  as 'задержка репликации, мин' from [192.168.22.21].elitv_O.dbo.z_replicain WITH (NOLOCK) order by DocTime desc OPTION (FAST 1)
select top 1  'CP1_DP - ' + str(DATEPART(n, GETDATE() - DocTime))  as 'задержка репликации, мин' from [CP1_DP].[ElitCP1].[dbo].[z_ReplicaIn] WITH (NOLOCK) order by DocTime desc OPTION (FAST 1)

