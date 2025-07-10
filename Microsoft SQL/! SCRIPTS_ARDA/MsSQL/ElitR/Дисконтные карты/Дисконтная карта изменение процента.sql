USE ElitR

declare @kart varchar (13)
set  @kart = '2220000430029'
select * from r_DCards where DCardID like @kart

update r_DCards
set Discount = 10 , DCTypeCode = 1 
from r_DCards where DCardID like @kart


select * from r_DCards where DCardID like @kart
