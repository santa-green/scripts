update t_sale  --продажа
set t_sale.docstatId = 4
--select *
from t_sale as t
where month (t.docdate)<> month (getdate()) and t.DocStatID = 0 
		or year (t.docdate)<= year (getdate())-1 and t.DocStatID = 0 


--update t_Rec  --приход
--set t_Rec.docstatId = 4
select *
from t_Rec as t
where month (t.docdate)<> month (getdate()) and t.DocStatID = 0 
		or year (t.docdate)<= year (getdate())-1 and t.DocStatID = 0 


update t_CRet --возврат магазина поставщику
set t_CRet.docstatId = 4
--select *
from t_CRet as t
where month (t.docdate)<> month (getdate()) and t.DocStatID = 0 
		or year (t.docdate)<= year (getdate())-1 and t.DocStatID = 0 



update t_Epp --расход магазина в ЦП
set t_Epp.docstatId = 4
--select *
from t_Epp as t
where month (t.docdate)<> month (getdate()) and t.DocStatID = 0 
		or year (t.docdate)<= year (getdate())-1 and t.DocStatID = 0 


update t_Exp --расход магазина 
set t_Exp.docstatId = 4
--select *
from t_Exp as t
where month (t.docdate)<> month (getdate()) and t.DocStatID = 0 
		or year (t.docdate)<= year (getdate())-1 and t.DocStatID = 0 


update t_Ven--инвентаризация магазина
set t_Ven.docstatId = 4
--select *
from t_Ven as t
where month (t.docdate)<> month (getdate()) and t.DocStatID = 0 
		or year (t.docdate)<= year (getdate())-1 and t.DocStatID = 0 