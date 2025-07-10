declare Ppqty cursor for

select ppid, qty from t_rem where prodid = 601842 and stockid  = 1201 and qty >0
        
        
        OPEN Ppqty
        declare 
        @tempppid int ,
        @tempqty  int ,
        @qty int ,
        @RemQty int
        
        set @qty = 158 
        
        FETCH NEXT FROM Ppqty INTO @tempppid, @tempqty 
        WHILE (@@FETCH_STATUS = 0 AND @qty > 0)
        BEGIN
        if @qty <= @tempqty 
        begin
        set @RemQty = @qty 
        set @qty = @qty - @tempqty 
        end
        else
        begin
        set @RemQty = @tempqty set @qty = @qty - @tempqty 
        end
        --print @qty
        --print  @tempqty 
        print @tempppid
        print @RemQty 
        FETCH NEXT FROM Ppqty INTO @tempppid, @tempqty 
        END
        close Ppqty
        deallocate Ppqty
        
        --select ppid, qty from t_rem where prodid = 601842 and stockid  = 1201 and qty >0