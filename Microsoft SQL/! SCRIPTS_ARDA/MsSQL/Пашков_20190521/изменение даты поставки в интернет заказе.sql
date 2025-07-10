-- изменение даты поставки в интернет заказе
update at_t_IORes
set ExpDate = '2016-12-27'
from at_t_IORes where DocID = 123043 and RemSchID = 2



select * from at_t_IORes where DocID = 123043 and RemSchID = 2