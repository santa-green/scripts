use otdatacafe
declare @qty float , @x float , @y int  , @z int  
set @x = 15 -- кол -во товара которое надо списать 

select @qty = sum (qty)
from t_rem 
where prodid = 39

select @z = max(ppid)
from t_rem 
where prodid = 39

if @qty > 0 select @y = min (ppid )from t_rem where qty >0 and prodid = 39 else select @z = max(ppid)from t_rem where prodid = 39
print @y


label1:
select @qty = qty
from t_rem 
where prodid = 39 and ppid = @y
print @x
print @qty

if (@qty- @x)>= 0  
		begin
	update t_rem set t_rem.qty = (@qty-@x)from t_rem t where  t.prodid = 39 and t.ppid = @y
	set @x= 0
	goto label2 
		end 
	else 
	begin
set @x = @x- @qty  print @x update  t_rem set t_rem.qty = 0 from t_rem t where  t.prodid = 39 and t.ppid = @y
		end
	if @y < @z and @x > 0 begin set @y=@y +1 goto label1 end else 
		update  t_rem set t_rem.qty = -@x from t_rem t where  t.prodid = 39 and t.ppid = @z

label2:
