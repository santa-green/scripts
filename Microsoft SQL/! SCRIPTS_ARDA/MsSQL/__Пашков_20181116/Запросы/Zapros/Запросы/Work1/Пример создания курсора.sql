use mc
declare maxppid cursor
for 
select prodid , max (ppid)
from t_pinp
group by prodid
open maxppid  
fetch next from maxppid  
while @@fetch_status = 0
	begin 
	fetch next from maxppid  
	end
close maxppid   
open maxppid  
fetch next from maxppid  
while @@fetch_status = 0
	begin 
	fetch next from maxppid  
	end
deallocate maxppid
