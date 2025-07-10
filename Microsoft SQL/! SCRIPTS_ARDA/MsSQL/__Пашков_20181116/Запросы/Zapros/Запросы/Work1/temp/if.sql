use otdatacafe
select min (ppid)
from t_rem 
where prodid = 39 and qty > 0

declare @qty float
select @qty = sum (qty)
from t_rem 
where prodid = 39
if @qty > 0 select min (ppid )from t_rem where qty >0 and prodid = 39 else select max(ppid)from t_rem where prodid = 39