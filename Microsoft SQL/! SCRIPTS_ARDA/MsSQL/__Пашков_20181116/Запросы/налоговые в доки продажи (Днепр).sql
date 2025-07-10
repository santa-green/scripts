declare @date varchar(30) , @nomer int , @nomer1 int , @nomer2 Int , @nomer3 int
set @date =  '20131022'
set @nomer = 431
set @nomer1 = 433
--set @nomer2 = 299	
--set @nomer3 = 300	
update t_Sale
set t_Sale.TaxDocID = @nomer
from t_Sale 
where DocDate = @date  and stockid in (1201, 1202)
update t_Sale
set t_Sale.TaxDocID = @nomer1
from t_Sale 
where DocDate = @date  and stockid in (1310)
/*
update t_Sale
set t_Sale.TaxDocID = @nomer2
from t_Sale 
where DocDate = @date  and stockid in (1314)

update t_Sale
set t_Sale.TaxDocID = @nomer3
from t_Sale 
where DocDate = @date  and stockid in (1315)

*/
select docdate , stockid , TaxDocID
from t_Sale 
where DocDate  between  '20131012' and '20131031' and stockid in (1201, 1202,1310)
group  by docdate , stockid , TaxDocID
order by DocDate

/*
select docdate ,DocID , StockID ,TaxDocID ,t.StateCode , r.*
from t_CRRet t inner join r_States r on  t.StateCode = r.StateCode
where DocDate = '20131016' 


update t_CRRet
set t_CRRet.TaxDocID = 434
from t_CRRet 
where DocDate = '20131022' 

*/
