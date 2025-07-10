declare @compid int 
declare NewcompID Cursor
for select compid
from   r_comps
where compid > 1 and compid < 1000
order  by compid
open NewcompID
fetch next from NewcompID into @compid
	
while @@fetch_status = 0
	begin 
	print @compid
	update r_comps 
	set r_comps . compid = r.compid + 1000
	from r_comps r 
	where r.compid = @compid
	fetch next from NewcompID into @compid
	

	end
close NewcompID


deallocate NewcompID