use otdata_m6
declare @chid  int, 
	@compid int
declare newcompid cursor
for
select compid , chid
from _sm7

open newcompid 
fetch next from newcompid into @compid ,@chid  
while @@fetch_status = 0
	begin 
update r_comps
set r_comps.compid = @compid 

where r_comps.compid = @chid 
	fetch next from newcompid into @compid ,@chid  
	end
deallocate newcompid 


select *
from r_comps r
--inner join _sm6 s on r.compid = s.compid 
where r.compid <1000
order by r.compid 