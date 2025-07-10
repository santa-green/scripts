select r.*
 from _iv_prods r
 

declare bla cursor for
select nom from  _iv_prods1  where nom > 3

declare @nom int
open bla
fetch next from bla into @nom
while @@FETCH_STATUS = 0 
begin
insert into ir_ProdOpers
select ProdID,Percent1,Percent2,IsDefault,BDate,EDate,OperTypeID from _iv_prods1  where Nom = @nom
fetch next from bla into @nom
end
close bla
deallocate bla 


insert into ir_ProdOpers
select * from dbo._iv_prods
where prodid = 610540