--select * from t_SaleTemp where StockID = 1310


select * 
from t_SaleTempD 
where ProdID between 605429 and 605436 
--where ChID = 100001040

select * from t_SaleTemp where CRID = 6

select * 
from t_SaleTempD 
where ProdID = 600879
--where ChID = 100001040

select r.prodname ,t.* 
from t_SaleTempD t join r_Prods r on t.ProdID = r.ProdID
where t.ChID = 100001044

select * from z_LogDiscRec where ChID = 100001015 and BonusType = 1
select * from z_LogDiscExp where chid = 100001015



/*
delete t_SaleTempD where chid = 100001044 --and ProdID = 600879

delete z_LogDiscRec where ChID = 100001044 and BonusType = 1

delete from z_LogDiscExp where chid = 100001044

*/