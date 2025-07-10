IF OBJECT_ID (N'fnExtNum', N'FN') IS NOT NULL  
    DROP FUNCTION fnExtNum;  
GO
Create Function fnExtNum(@txt VarChar(8000))
returns VarChar(8000)
as
begin

Declare @pos int
set @pos = len(@txt)

while @pos>0
Begin
IF Substring(@txt,@pos,1) not like '[0-9]'
	set @txt = STUFF(@txt,@pos,1,'')

set @pos = @pos - 1
end

IF LEN(@txt) = 9 and Substring(@txt,1,1) <> 0  
	set @txt = '0' + @txt
	
IF LEN(@txt) = 10
	set @txt = '38' + @txt
	
return @txt
end

go
select DCardID, PhoneMob, dbo.fnExtNum(PhoneMob), LEN(dbo.fnExtNum(PhoneMob)), *
from r_DCards 
where dbo.fnExtNum(PhoneMob) is not null and len(PhoneMob) > 0
order by 4, 3

go
select LEN(dbo.fnExtNum(PhoneMob)) as dlina, COUNT(LEN(dbo.fnExtNum(PhoneMob))) as kol
from r_DCards 
where dbo.fnExtNum(PhoneMob) is not null and len(PhoneMob) > 0
group by LEN(dbo.fnExtNum(PhoneMob))
order by 1

go
/*
update r_DCards
set PhoneMob = dbo.fnExtNum(PhoneMob)
from r_DCards 
where dbo.fnExtNum(PhoneMob) is not null and len(PhoneMob) > 0

and DCardID in ('2500000019975','2500000009693')

go
select DCardID, PhoneMob, dbo.fnExtNum(PhoneMob), LEN(dbo.fnExtNum(PhoneMob))
from r_DCards 
where dbo.fnExtNum(PhoneMob) is not null and len(PhoneMob) > 0
and DCardID in ('2500000019975','2500000009693')
*/
go
Drop Function fnExtNum
go

--проверить эти номера они не правильные
select DCardID, PhoneMob, *
from r_DCards 
where PhoneMob is not null and len(PhoneMob) > 0 and PhoneMob not like '380%'
order by 2

/* удаление неправильных номеров
update r_DCards
set PhoneMob = ''
from r_DCards 
where PhoneMob is not null and len(PhoneMob) > 0 and PhoneMob not like '380%'
*/
