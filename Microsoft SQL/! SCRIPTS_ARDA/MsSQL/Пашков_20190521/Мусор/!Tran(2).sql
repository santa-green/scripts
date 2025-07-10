begin tran

exec ap_Rkiper_Imort_Sale

rollback tran


select * from t_sale  where docid = 129877

select * from t_sale_r  where docid = 129877


update t_sale_R
set Import = 0
where Docdate BETWEEN '2016-11-15' and '2016-11-30'
select * from  t_sale_r where Docdate >='2016-12-01'  and  StockID in (1315 , 1314) 
select * from  t_sale_r where Docdate >='2016-12-01'  and  StockID in (1315 , 1314) and CRID = 153
--delete  t_sale_R where Docdate BETWEEN '2016-11-01' and '2016-11-30' and  StockID in (1315 , 1314)

select * from  t_sale where Docdate BETWEEN '2016-11-01' and '2016-11-30' and StockID in (1315 , 1314)
--delete t_sale where Docdate BETWEEN '2016-11-01' and '2016-11-30' and StockID in (1315 , 1314)

select * from z_DocLinks where ParentChID in (select chid from  t_sale where Docdate BETWEEN '2016-11-01' and '2016-11-30' and StockID in (1315,1314) ) 
--delete z_DocLinks where ParentChID in (select chid from  t_sale where Docdate BETWEEN '2016-11-01' and '2016-11-30' and StockID in (1315,1314) ) 


select * from  t_saled where chid in (select chid from  t_sale where Docdate BETWEEN '2016-11-01' and '2016-11-30' and StockID = 1315 ) 


--insert r_OperCRs
select * from [s-sql-d4].elitr.dbo.r_OperCRs where CRID not in (select CRID from r_OperCRs)

select * from r_OperCRs where OperID = 239



--insert r_Opers
select * from [s-sql-d4].elitr.dbo.r_Opers where ChID not in (select ChID from r_Opers)
select * from r_Opers where OperID = 239

select * from t_sale_R where Docid = 129008


select * from t_sale  where docid = 129877

select * from t_sale_r  where docid = 129877


select * from t_sale s
join t_SaleD d on s.ChID = d.ChID
where s.Docdate >='2016-12-01'  and  StockID in (1315 , 1314) 

select * from [s-marketa].elitv_dp.dbo.t_sale s
join [s-marketa].elitv_dp.dbo.t_SaleD d on s.ChID = d.ChID
where Docdate BETWEEN '2016-11-15' and '2016-11-15' and  StockID in (1315 , 1314)
