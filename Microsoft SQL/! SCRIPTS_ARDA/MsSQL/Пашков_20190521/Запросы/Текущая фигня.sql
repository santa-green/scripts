
insert  _copicalc
select ChID 
from it_Spec where DocID in (5636,5534,5535,5536,5537)

select * from _copicalc
DECLARE kalc CURSOR 
FOR
select * from _copicalc

DECLARE @chid INT
OPEN kalc
FETCH NEXT FROM kalc INTO @chid
WHILE @@FETCH_STATUS = 0    		 
  BEGIN  
     EXEC ip_SpecCopy  @chid,9,'20140118',1224;
     FETCH NEXT FROM kalc INTO @chid
  END
CLOSE kalc
DEALLOCATE kalc






 select * 
 from it_Spec 
 where ChID > 6694 
 order by ChID desc
 
 select * from it_SpecParams where ChID > =6755

 update it_SpecParams
 set ProdDate = '2014-01-18 00:00:00' , StockID = 1224
  from it_SpecParams 
 where ChID > =6768
 
 TRUNCATE table _copicalc
