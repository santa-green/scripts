
select * from it_Spec where ChID in (10687 )

declare @Mchid int  ,@stockid int , @docdate smalldatetime 
set @stockid =1315
set @docdate = '20160401'
select @Mchid = MAX (chid)+1 from it_Spec

DECLARE kalc CURSOR 
FOR
select  chid 
from it_Spec 
where ChID in (10687)
DECLARE @chid INT
OPEN kalc
FETCH NEXT FROM kalc INTO @chid 
 WHILE @@FETCH_STATUS = 0    		 
  BEGIN  
     EXEC ip_SpecCopy  @chid,12,@docdate,@stockid
     FETCH NEXT FROM kalc INTO @chid 
  END
CLOSE kalc
DEALLOCATE kalc


select * from it_Spec where ChID >= @Mchid
select * from it_SpecParams where ChID >= @Mchid

update it_SpecParams
set StockID = 1204 , ProdDate = @docdate
from it_SpecParams where ChID >= @Mchid

select * from it_SpecParams where ChID >= @Mchid