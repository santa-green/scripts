--����� ����� ������� ��� ����������� ������� ������ � t_PInP
--ElitR ����������� 
select * from [s-sql-d4].elitr.dbo.r_Prods 
	where ProdID not in (select ProdID from [s-sql-d4].elitr.dbo.t_PInP where ppid = 0)
	
--ElitV_DP �����
select * from [s-marketa].elitv_dp.dbo.r_Prods 
	where ProdID not in (select ProdID from [s-marketa].elitv_dp.dbo.t_PInP where ppid = 0)
	
--ElitV_KIEV ����
select * from [s-marketa2].elitv_kiev.dbo.r_Prods 
	where ProdID not in (select ProdID from [s-marketa2].elitv_kiev.dbo.t_PInP where ppid = 0)

--ElitV_DP2 �������
select * from [s-marketa3].elitv_dp2.dbo.r_Prods 
	where ProdID not in (select ProdID from [s-marketa3].elitv_dp2.dbo.t_PInP where ppid = 0)

--ElitV_O ������
select * from [192.168.22.21].elitv_o.dbo.r_Prods 
	where ProdID not in (select ProdID from [192.168.22.21].elitv_o.dbo.t_PInP where ppid = 0)




