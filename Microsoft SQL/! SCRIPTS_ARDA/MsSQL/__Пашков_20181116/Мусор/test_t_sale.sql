--insert [s-marketa].elitv_dp.dbo.test_t_sale
select * from t_sale where DocDate >= '2016-10-01'
and StockID = 1315 


--insert [s-marketa].elitv_dp.dbo.test_t_saleD
select * from t_saleD where ChID in(
select ChID from t_sale where DocDate >= '2016-10-01'
and StockID = 1315 
)