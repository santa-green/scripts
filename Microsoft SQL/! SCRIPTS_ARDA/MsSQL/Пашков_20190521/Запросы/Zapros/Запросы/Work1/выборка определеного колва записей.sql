declare bar cursor 
	for 
	select prodid 
	from r_prods
	where prodid < 1000
	group by prodid
	order by prodid
declare @p int ,@i int
open bar
	fetch next from bar into @p
	
	select top 3 prodid , barcode 
	into #test
	from r_prodmq where prodid = @p
	while @@fetch_status = 0
	begin 
	
	begin 
	
	fetch next from bar into @p
	insert into #test
	select  TOP 3 prodid , barcode 
	from r_prodmq where prodid = @p
	
	
	end
	end
	close bar

deallocate bar

select *
from #test