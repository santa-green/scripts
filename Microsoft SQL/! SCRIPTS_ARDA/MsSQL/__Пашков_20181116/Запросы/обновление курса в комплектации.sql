declare @docid int , @chid int 
set @docid = 100006582
select @chid  = ChID from t_SRec where DocID = @docid 

declare test cursor   for 
select Achid from t_SRecA where chid = @chid
declare @achid int
open test 
FETCH NEXT FROM test INTO @achid
WHILE @@FETCH_STATUS = 0    		 
  BEGIN  
  declare test1 cursor   for 
select SubSrcPosID , SubProdID , SubPPID ,SubPriceCC_wt   from t_SRecD where AChID = @achid

declare @SubSrcPosID int , @SubProdID  int , @SubPPID int  ,@SubPriceCC_wt   float
open test1

FETCH NEXT FROM test1 INTO @SubSrcPosID , @SubProdID , @SubPPID ,@SubPriceCC_wt  
WHILE @@FETCH_STATUS = 0    		 
  BEGIN  
select @SubSrcPosID , @SubProdID , @SubPPID ,@SubPriceCC_wt   

declare @p8 float
set @p8=@SubPriceCC_wt
exec "t_GetPriceCC" 11321,@docid,@SubProdID,@SubPPID,13,0,0,@p8 output
select @p8
  
update d
set d.SubPriceCC_wt = @p8 ,d.SubNewPriceCC_wt = @p8,
d.SubPriceCC_nt = @p8 /1.2 ,
d.SubSumCC_nt = @p8 /1.2 *SubQty,
d.SubSumCC_wt = @p8  *SubQty,
d.SubTax = @p8 - @p8 /1.2 ,
d.subtaxsum = (@p8 - @p8 /1.2 )*SubQty,

d.SubnewPriceCC_nt = @p8 /1.2,
d.SubnewSumCC_nt = @p8 /1.2 *SubQty,
d.SubnewSumCC_wt = @p8  *SubQty,
d.SubnewTax = @p8 - @p8 /1.2,
d.subnewtaxsum = (@p8 - @p8 /1.2 )*SubQty


from t_SRecD  D where SubSrcPosID = @SubSrcPosID and SubProdID  = @SubProdID and SubPPID =@SubPPID
  
     FETCH NEXT FROM test1 INTO @SubSrcPosID , @SubProdID , @SubPPID ,@SubPriceCC_wt  
   end
   CLOSE test1
DEALLOCATE test1

   FETCH NEXT FROM test INTO @achid  
  END
CLOSE test
DEALLOCATE test



select * from t_SRecD where achid  =100160101
