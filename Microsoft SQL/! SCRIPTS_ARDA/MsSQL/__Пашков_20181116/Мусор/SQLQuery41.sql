--insert [s-marketa].elitv_dp.dbo.t_Excd
select * from t_Exc where DocID = 600000007 

--insert [s-marketa].elitv_dp.dbo.t_PInP
select * from t_PInP where prodid= 706242 and PPID = 50000

select * from [s-marketa].elitv_dp.dbo.t_Exc where ChID = 572

select * from [s-marketa2].elitv_kiev.dbo.t_Exc where ChID = 572



select * from [s-marketa2].elitv_kiev.dbo.t_PInP where prodid= 706242
select * from [s-marketa].elitv_dp.dbo.t_PInP where prodid= 706242
select * from t_PInP where prodid= 706242 and PPID = 50000

select * from t_Excd where ChID = 200001652--DocID = 200001461


select * from [s-marketa].elitv_dp.dbo.t_Excd where ChID = 572

select * from [s-marketa2].elitv_kiev.dbo.t_Excd where ChID = 572



begin tran

insert [s-marketa2].elitv_kiev.dbo.t_Excd
select * from [s-marketa].elitv_dp.dbo.t_Excd where ChID = 572

rollback tran