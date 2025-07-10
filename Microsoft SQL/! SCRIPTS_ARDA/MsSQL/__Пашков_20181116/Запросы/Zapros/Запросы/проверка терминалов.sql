select t.DocDate , DocID ,DocTime ,p.SumCC_wt ,p.Notes  ,t.CRID
from t_SalePays p join t_Sale t on p.ChID = t.ChID
where POSPayID != 0 and DocDate = dbo.zf_GetDate (GETDATE())
order by DocDate ,DocTime



