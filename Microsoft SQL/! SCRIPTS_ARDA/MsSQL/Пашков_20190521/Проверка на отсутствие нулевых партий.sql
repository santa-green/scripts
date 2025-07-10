--Поиск кодов товаров где отсутствуют нулевые партии в t_PInP
--ElitR Центральная 
select * from [s-sql-d4].elitr.dbo.r_Prods 
	where ProdID not in (select ProdID from [s-sql-d4].elitr.dbo.t_PInP where ppid = 0)
	
--ElitV_DP Днепр
select * from [s-marketa].elitv_dp.dbo.r_Prods 
	where ProdID not in (select ProdID from [s-marketa].elitv_dp.dbo.t_PInP where ppid = 0)
	
--ElitV_KIEV Киев
select * from [s-marketa2].elitv_kiev.dbo.r_Prods 
	where ProdID not in (select ProdID from [s-marketa2].elitv_kiev.dbo.t_PInP where ppid = 0)

--ElitV_DP2 Харьков
select * from [s-marketa3].elitv_dp2.dbo.r_Prods 
	where ProdID not in (select ProdID from [s-marketa3].elitv_dp2.dbo.t_PInP where ppid = 0)

--ElitV_O Одесса
select * from [192.168.22.21].elitv_o.dbo.r_Prods 
	where ProdID not in (select ProdID from [192.168.22.21].elitv_o.dbo.t_PInP where ppid = 0)




