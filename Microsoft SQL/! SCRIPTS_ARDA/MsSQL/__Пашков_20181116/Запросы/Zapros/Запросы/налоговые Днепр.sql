select chid , docid , SUM (TSumCC_nt), SUM (TTaxSum), SUM (TSumCC_wt) , SUM (TSumCC_nt)+ SUM (TTaxSum)- SUM (TSumCC_wt) 
from t_Sale where DocDate = '20150124' and StockID  =1201 group  by chid , docid 



select ChID,SrcPosID,ProdID,PPID,UM,Qty,PriceCC_nt,SumCC_nt,Tax,TaxSum,PriceCC_wt,SumCC_wt,BarCode,TaxID,SecID,PurPriceCC_nt,PurTax,PurPriceCC_wt,PLID,Discount,DepID,IsFiscal,SubStockID,OutQty,EmpID,CreateTime,ModifyTime
 from t_SaleD where chid =100188329
union
select ChID,SrcPosID,ProdID,PPID,UM,Qty,PriceCC_nt,round (SumCC_nt,2)SumCC_nt,Tax,round (TaxSum, 2)TaxSum,PriceCC_wt,round (SumCC_wt,2)SumCC_wt,BarCode,TaxID,SecID,PurPriceCC_nt,PurTax,PurPriceCC_wt,PLID,Discount,DepID,IsFiscal,SubStockID,OutQty,EmpID,CreateTime,ModifyTime
 from t_SaleD where chid =100188329


update t_saled 
set SumCC_nt = round (SumCC_nt,2) , TaxSum= round (SumCC_wt,2)- round (SumCC_nt,2)  , SumCC_wt = round (SumCC_wt,2)
from t_saled where chid  =100188329

 in (
select chid 
from t_Sale where DocDate = '20150124' and StockID  =1201 )

select ChID,SrcPosID,ProdID,PPID,UM,Qty,PriceCC_nt,SumCC_nt,Tax,TaxSum,PriceCC_wt,SumCC_wt,BarCode,TaxID,SecID,PurPriceCC_nt,PurTax,PurPriceCC_wt,PLID,Discount,DepID,IsFiscal,SubStockID,OutQty,EmpID,CreateTime,ModifyTime
 from t_SaleD where chid =100188329

select ChID,SrcPosID,ProdID,PPID,UM,Qty,PriceCC_nt,round (SumCC_nt,2)SumCC_nt,Tax,round (TaxSum, 2)TaxSum,PriceCC_wt,round (SumCC_wt,2)SumCC_wt,BarCode,TaxID,SecID,PurPriceCC_nt,PurTax,PurPriceCC_wt,PLID,Discount,DepID,IsFiscal,SubStockID,OutQty,EmpID,CreateTime,ModifyTime
 from t_SaleD where chid =100188329




select SUM (TSumCC_nt), SUM (TTaxSum), SUM (TSumCC_wt) , SUM (TSumCC_nt)+ SUM (TTaxSum)- SUM (TSumCC_wt) 
from t_Sale where DocDate = '20150124' and StockID  =1201 


select sum (SumCC_nt), sum (TaxSum ),sum (SumCC_wt ), SUM (SumCC_nt)+ SUM (TaxSum)- SUM (SumCC_wt)  from t_saled where chid  in (
select chid 
from t_Sale where DocDate = '20150124' and StockID  =1201 )
