use otdata

declare @ch int,
	@dey int
set @dey = 0
while @dey <= 0
begin 
select @ch = max (t.chid)
from  t_sale t
	where t.docdate  = CONVERT(DATETIME ,(dateadd (day , @dey,'2005-05-08')), 102)/*дата начала работы магазина*/
print @ch

set  @dey = @dey +1
end
/*select */
delete 
from t_sale 
where t_sale.chid > = 1339970
  
--order by t_sale.chid 