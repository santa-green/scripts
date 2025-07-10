

DECLARE kalc1 CURSOR 
FOR
select * from _789
open kalc1 

 declare  @prodid1 int  ,@OperTypeID int 
FETCH NEXT FROM kalc1 INTO @prodid1 , @OperTypeID

	WHILE @@FETCH_STATUS = 0    		 
    BEGIN  


 select  prodid  
 into _123
 from  it_Spec where ChID in (
 select ChID from it_SpecD where ProdID = @prodid1 and OperTypeID = @OperTypeID ) and StockID = 1224 and ProdID not in (select ProdID from _345)
group by prodid



DECLARE kalc CURSOR 
FOR
select max (chid) , t.ProdID  from it_spec t join _123 d on t.ProdID = d.ProdID where StockID = 1224 group by t.ProdID 



DECLARE @chid INT, @prodid int
OPEN kalc
FETCH NEXT FROM kalc INTO @chid , @prodid 
WHILE @@FETCH_STATUS = 0    		 
  BEGIN  
     EXEC ip_SpecCopy  @chid,9,'20130518',1224;
     FETCH NEXT FROM kalc INTO @chid , @prodid 
  END
CLOSE kalc
DEALLOCATE kalc




insert _345
select ProdID 
from kkm0._123 

  
drop table _123
--truncate table kkm0._345  
FETCH NEXT FROM kalc1 INTO @prodid1 , @OperTypeID
  END
CLOSE kalc1
DEALLOCATE kalc1



--select * into _345 from ElitV_TEST.kkm0._345


-- select * from _345 