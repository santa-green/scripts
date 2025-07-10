SELECT * FROM t_Rec where DocID = 600000042

--insert t_Rec
SELECT * FROM [s-sql-d4].elitr.dbo.t_Rec where ChID = 6207

--insert t_RecD
SELECT * FROM [s-sql-d4].elitr.dbo.t_RecD where ChID = 6207

--insert t_pinp
SELECT * FROM [s-sql-d4].elitr.dbo.t_pinp where ProdID = 705502 and PPID = 100000

SELECT * FROM t_Rec where DocID = 600000042

SELECT * FROM t_Rec where ChID = 6207

SELECT * FROM t_RecD where ChID = 6207

select '' as 's-marketa', * from [s-marketa].elitv_dp.dbo.z_replicain WITH (NOLOCK) where status != 0 --Dnepr Vintage 192.168.70.2
order by replicaeventid  OPTION (FAST 1)