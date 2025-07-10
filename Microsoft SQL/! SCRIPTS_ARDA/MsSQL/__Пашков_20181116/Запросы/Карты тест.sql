 insert z_DocDC
 select  * from [s-marketa2].elitv_kiev.dbo.z_DocDC where chid in (select chid from t_Sale) order by chid
 
 insert z_DocDC
 select  * from [s-marketa].elitv_dp.dbo.z_DocDC where chid in (select chid from t_Sale) and  doccode in ( 11035, 11004)  order by chid
 
 insert z_DocDC
 select  * from [s-marketa].elitv_dp.dbo.z_DocDC 
 where chid in (select chid from t_Sale) and  doccode = 10400 
 and dcardid not in (select dcardid from z_DocDC  where ChID = 0 and  doccode = 10400 )
 order by chid
 
 
 insert z_LogDiscRec
select top 30000 * 
from [s-marketa2].elitv_kiev.dbo.z_LogDiscRec 
where logid not in (select logid from z_LogDiscRec where DBiID =3  ) and chid in (select chid from t_Sale) and doccode <> 1011
order by logid

 insert z_LogDiscRec
select  top 1000 * 
from [s-marketa].elitv_dp.dbo.z_LogDiscRec 
where logid not in (select logid from z_LogDiscRec where DBiID =2  ) and chid in (select chid from t_Sale)and doccode <> 1011
order by logid

insert z_LogDiscRec
select  * 
from [s-marketa].elitv_dp.dbo.z_LogDiscRec 
where  doccode = 11004
order by logid

insert z_LogDiscRec
select top 5  * 
from [s-marketa2].elitv_kiev.dbo.z_LogDiscRec
where  doccode = 11004
order by logid



select * from z_DocDC where ChID  = 100000014