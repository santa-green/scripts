insert t_Sale
select * from [s-sql-d4].elitr.dbo.t_Sale  where chid =  400000356
insert t_SaleD
select 400000356,1,600072,0,'пл€ш',1.000000000,66.583330000,66.583330000,13.316670000,13.316670000,79.900000000,79.900000000,4820024226301,1,70.083333330,14.016666670,84.100000000,81,0.000000000,0,1,0,1.000000000,0,'2015-03-05 17:34:45.983','2015-03-05 17:34:45.983',0,79.900000000,79.900000000
 
from [s-sql-d4].elitr.dbo.t_Saled 

where chid =  400000356
insert t_SalePays
select * from [s-sql-d4].elitr.dbo.t_SalePays where chid =  400000356


select *  from [s-sql-d4].elitr.dbo.t_zRep where crid =120 and chid  =400000056
select *  from [S-MARKETA].elitv_dp.dbo.t_MonIntExp where crid =120
select *  from [s-sql-d4].elitr.dbo.t_MonIntrec where crid =120
insert t_MonIntExp
select * from [ElitV_DP_3].dbo.t_MonIntExp where crid = 120

select * from z_Vars