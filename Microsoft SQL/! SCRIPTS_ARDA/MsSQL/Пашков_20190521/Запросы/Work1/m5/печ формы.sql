select *
from otdata.dbo._pform p1 full join otdataM5.dbo._pform p2 on p1.repcode = p2.repcode
where p1.repcode is null

