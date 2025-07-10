
select '' as 's-marketa', * from [s-marketa].elitv_dp.dbo.z_replicain WITH (NOLOCK) where status != 0 --Dnepr Vintage 192.168.70.2
order by DocTime desc OPTION (FAST 1)

SELECT * FROM r_Prods where ProdID = 607468

SELECT * FROM [s-marketa].elitv_dp.dbo.r_Prods where ProdID = 607468

SELECT * FROM [s-marketa2].elitv_kiev.dbo.r_Prods where ProdID = 607468
