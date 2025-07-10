use otdatacafe
declare Qty cursor
for  
select prodid , Achid , qty 
from T_srecA
where chid = 23
order by chid
open Qty
declare @TAprodid int , @TAAchid int , @qty float 
FETCH NEXT FROM Qty into @TAprodid , @TAAchid ,@qty
WHILE @@Fetch_Status = 0
begin
declare trem cursor
for   
select sprodid ,eexp
 from r_prodms
 where prodid = @TAprodid
	open  trem
	declare @qty1 float , @x float , @y int  , @z int  , @eexp float ,@sprodid int
	FETCH NEXT FROM trem into @sprodid ,@eexp
	set  @qty1  = @qty * @eexp
	begin 
		print @qty1
		print @sprodid 
		FETCH NEXT FROM trem into @sprodid ,@eexp
	end 
	CLOSE trem
	DEALLOCATE trem
FETCH NEXT FROM Qty into @TAprodid , @TAAchid ,@qty
END
CLOSE Qty
DEALLOCATE Qty


