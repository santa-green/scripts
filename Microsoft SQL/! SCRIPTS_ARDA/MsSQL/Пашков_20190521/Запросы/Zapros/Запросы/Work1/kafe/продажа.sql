use otdata_cafe
set nocount on
declare @chid int
declare @data datetime 
declare @chidP int
set @data = CONVERT(DATETIME ,(datediff (day ,3,getdate())), 102) -- текущая дата
/*Номер максимального заполненного чека*/
select @chidP = max (chid)
from t_saled 
/**/
select @chid = max(chid) 
from t_srec


update t_sale 
set t_sale.CodeID5 = 0, t_sale.docstatId = 0
where t_sale.CodeID5 = 1 and t_sale.docdate = @data and t_sale.chid <= @chidP
