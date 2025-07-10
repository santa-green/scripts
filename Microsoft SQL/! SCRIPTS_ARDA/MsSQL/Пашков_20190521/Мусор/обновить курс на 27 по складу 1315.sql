update t_sale
set KursMC = 27
from t_sale where DocDate >= '2016-10-01'
and StockID = 1315 and KursMC <> 27


select *  
from t_sale where DocDate >= '2016-10-01'
and StockID = 1315 and KursMC <> 27
order by DocDate desc