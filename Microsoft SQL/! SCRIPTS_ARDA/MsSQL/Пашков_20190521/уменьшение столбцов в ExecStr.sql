IF OBJECT_ID (N'dbo.fnExtNum', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.fnExtNum;  
GO  
Create Function dbo.fnExtNum(@txt VarChar(8000), @N int)
returns int
as
begin

DECLARE @pos int,@S VARCHAR(8000)
set @S = @txt

SELECT @pos = number  FROM 
(
 SELECT N=ROW_NUMBER()OVER(ORDER BY number),number
 FROM master.dbo.spt_values
 WHERE type='P' AND number BETWEEN 1 AND LEN(@S) AND SUBSTRING(@S,number,1)=','
) nn 
where N = @N 

return @pos
end

go

SELECT SUBSTRING(ExecStr,1,dbo.fnExtNum(ExecStr, 35)) + SUBSTRING(ExecStr,dbo.fnExtNum(ExecStr, 35)+25,LEN(ExecStr)),* 
from z_ReplicaIn  where ExecStr like 'z_Replica_Ins_b_TExp_3%' and Status <> 1 and (len(ExecStr) - len(replace(ExecStr, ',', '')) + 1) = 47
--and ReplicaEventID in ( 10297416)
go
update z_ReplicaIn
set ExecStr = SUBSTRING(ExecStr,1,dbo.fnExtNum(ExecStr, 35)) + SUBSTRING(ExecStr,dbo.fnExtNum(ExecStr, 35)+25,LEN(ExecStr))
from z_ReplicaIn  where ExecStr like 'z_Replica_Ins_b_TExp_3%' and Status <> 1 and (len(ExecStr) - len(replace(ExecStr, ',', '')) + 1) = 47
--and ReplicaEventID in ( 10297416)


go
DROP FUNCTION dbo.fnExtNum

