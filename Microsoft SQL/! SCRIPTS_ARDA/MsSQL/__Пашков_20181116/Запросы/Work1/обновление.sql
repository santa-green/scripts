use otdata
declare @i int ,
	@x int	
select @i=max (SrcPosID)
from _tests2

set @x = 1
while @x<=@i
begin 
insert into t_saled 
select *
from _tests3
where _tests3.SrcPosID = @x
set @x= @x+1
end