select * from t_saled 
where 
--chid in
--(select chid from t_sale where crid = 108 and TTaxSum >0)
--and
 ChID = 100301266

union
select * from t_SaleD  where ChID =100302206 


select * from t_Sale  where ChID in (100302206 , 100301266)

select * from t_Sale  where DocDate = '20160413' and CRID = 108

update t_SaleD 
set TaxSum = 0 , Tax = 0 , PriceCC_nt = PriceCC_wt , SumCC_nt = SumCC_wt , PurPriceCC_nt = PurPriceCC_wt , PurTax = 0
from t_saled where chid in
(select chid from t_sale where crid = 108 and TTaxSum >0)
and ChID = 100301266