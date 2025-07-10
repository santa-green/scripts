Declare @i int = 1000;--кол. циклов

DISABLE TRIGGER ALL ON r_DCards;

while @i > 0
Begin

--print @i

delete top (100) from r_DCards
where DCTypeCode  in (17)

set @i = @i - 1

end;

ENABLE  TRIGGER ALL ON r_DCards;



SELECT COUNT(*) FROM r_DCards
where DCTypeCode  in (17)





