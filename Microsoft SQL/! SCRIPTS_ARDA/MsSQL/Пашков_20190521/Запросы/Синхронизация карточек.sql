declare Dcards cursor for 
select  top 100 logid from [s-marketa2].elitv_kiev.dbo.z_LogDiscRec  order by logid
declare @logid int 
OPEN Dcards
FETCH NEXT FROM Dcards into @logid
WHILE @@Fetch_Status = 0
BEGIN
print @logid
insert z_LogDiscRec
select * from [s-marketa2].elitv_kiev.dbo.z_LogDiscRec  where logid = @logid
FETCH NEXT FROM Dcards into @logid
END
CLOSE Dcards
DEALLOCATE Dcards

select * from z_LogDiscRec order by LogID


/*
use ElitR_TEST
select * from z_DocDC

insert z_DocDC
select * from [s-marketa2].elitv_kiev.dbo.z_DocDC 
 where dcardid in (select  dcardid from r_DCards ) and doccode = 10400 and dcardid <> '2220000007559'
 and chid in (select chid from t_Sale )

select doccode from z_DocDC group by doccode
*/