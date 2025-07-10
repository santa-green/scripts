declare @date varchar(30) , @nomer int 
set @date =  '20121217'
set @nomer = 962
select docdate ,DocID , StockID ,TaxDocID ,t.StateCode , r.*
from t_Sale t inner join r_States r on  t.StateCode = r.StateCode
where DocDate = @date  and stockid in ( 1221 , 1222)

update t_Sale
set t_Sale.TaxDocID = @nomer
from t_Sale 
where DocDate = @date  and stockid in ( 1221 , 1222)


select docdate , stockid , TaxDocID
from t_Sale 
where DocDate  between  '20121211' and '20121217'
group  by docdate , stockid , TaxDocID
order by DocDate

/*
select docdate ,DocID , StockID ,TaxDocID ,t.StateCode , r.*
from t_CRRet t inner join r_States r on  t.StateCode = r.StateCode
where DocDate = '20121217' 


update t_CRRet
set t_CRRet.TaxDocID = 960
from t_CRRet 
where DocDate = '20121217' 

*/