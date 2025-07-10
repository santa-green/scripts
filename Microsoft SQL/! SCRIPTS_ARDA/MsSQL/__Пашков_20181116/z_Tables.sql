use ElitR

select * from z_Tables
--where TableName like '%r_OperCRs%'  
where TableDesc like '%парт%'
ORDER BY TableDesc

select * from z_LogDiscRec where DCardID = '2220000278966'
select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscRec where DCardID = '2220000278966'
select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscRec where DCardID = '2220000260039'
