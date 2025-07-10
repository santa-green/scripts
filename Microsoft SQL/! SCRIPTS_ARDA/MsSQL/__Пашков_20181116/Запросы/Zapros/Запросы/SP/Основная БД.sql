-- 1) основная база 
update r_DBIs
set chid =  1
from r_DBIs where ChID  = 100000001 

insert r_DBIs
select * from  ElitV_TEST.dbo.r_DBIs where ChID >= 2

delete from z_LogDiscRec 
-- после SP
/*
insert z_LogDiscRec
select * from [s-marketa].elitv_dp.dbo.z_LogDiscRec order by LogID 

insert z_LogDiscRec
select * from [s-marketa2].elitv_kiev.dbo.z_LogDiscRec order by LogID 
*/
