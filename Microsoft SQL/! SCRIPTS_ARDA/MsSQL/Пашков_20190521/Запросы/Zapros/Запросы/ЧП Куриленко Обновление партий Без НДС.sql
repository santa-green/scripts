select * from t_rec where compid = 10803 and DocDate >= '20160516' and StockID = 1201 and TTaxSum >0
select * from t_Rec where DocID =100010329

select * from t_RecD where chid  =100022510 and ProdID = 800171

select * from t_PInP where ppid  = 518 and ProdID = 800171

update t_RecD
set Tax =0 , PriceCC_nt = PriceCC_wt , SumCC_nt =SumCC_wt
from  t_RecD where chid  =100022510 and ProdID = 800171