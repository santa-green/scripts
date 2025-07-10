use otdatam6
/*выборка заголовков чеков*/
set nocount on
declare @ch2 int,
	@ch3 int,	
	@dey int,
	@tday datetime		

set @dey = 10
print @dey
while @dey > 0  
begin 
print @dey
drop table _tests5
drop table _tests2
drop table _tests3
set @tday  = CONVERT(DATETIME ,(datediff (day ,@dey,getdate())), 102)
 print @tday



select @ch2 = min (t.chid)
from  t_sale t
	where t.docdate  = @tday /*дата начала работы магазина*/
and t.stockid = 2
/*print @ch2*/


select @ch3 = min (t.chid)
from  t_sale t
	where t.docdate  = @tday /*дата начала работы магазина*/
and t.stockid = 3
/*print @ch3*/

select *
 into _tests5
from  t_sale t
	where t.chid = @ch2 or t.chid = @ch3 
print 'заполнили таблицу _tests5'
 




select  chid =@ch2, 
		
 identity(smallint,1,1) SrcPosID, td.ProdID ,td.PPID,td.UM,sum (td.Qty)QTY , td.PriceCC_nt,sum (td.SumCC_nt)SumCC_nt,td.Tax, sum (td.TaxSum)TaxSum,td.PriceCC_wt,
				sum (td.SumCC_wt)SumCC_wt ,td.BarCode , td.TaxID,td.SecID,td.PurPriceCC_nt, td.PurTax,td.PurPriceCC_wt,td.PLID

into  _tests2/*имя таблицы зависит от скалада*/
	from t_sale t inner join t_saled td on t.chid = td.chid 
		
	where t.docdate  = @tday and t.StockID = 2 /*склад*/
group by  td.ProdID ,td.PPID,td.UM, td.PriceCC_nt,td.Tax, td.PriceCC_wt,
			td.BarCode , td.TaxID,td.SecID,td.PurPriceCC_nt, td.PurTax,td.PurPriceCC_wt,td.PLID,
	t.StockID

print 'заполнили таблицу _tests2'

select  chid =@ch3, 
		
 identity(smallint,1,1) SrcPosID, td.ProdID ,td.PPID,td.UM,sum (td.Qty)QTY , td.PriceCC_nt,sum (td.SumCC_nt)SumCC_nt,td.Tax, sum (td.TaxSum)TaxSum,td.PriceCC_wt,
				sum (td.SumCC_wt)SumCC_wt ,td.BarCode , td.TaxID,td.SecID,td.PurPriceCC_nt, td.PurTax,td.PurPriceCC_wt,td.PLID

into  _tests3/*имя таблицы зависит от скалада*/
	from t_sale t inner join t_saled td on t.chid = td.chid 
		
	where t.docdate  = @tday and t.StockID = 3 /*склад*/
group by  td.ProdID ,td.PPID,td.UM, td.PriceCC_nt,td.Tax, td.PriceCC_wt,
			td.BarCode , td.TaxID,td.SecID,td.PurPriceCC_nt, td.PurTax,td.PurPriceCC_wt,td.PLID,
	t.StockID
print 'заполнили таблицу _tests3'

delete 
from t_sale
where t_sale.docdate = @tday

print 'удалили данные за день'

insert into t_sale
select *
from _tests5
where _tests5.docdate = @tday

print 'заполнили таблицу t_sale за день'

declare @i int ,
	@x int	
select @i=max (SrcPosID)
from _tests2

set @x = 1
while @x<=@i
begin 
insert into t_saled 
select *
from _tests2
where _tests2.SrcPosID = @x
set @x= @x+1
end
print 'заполнили таблицу t_saled за день по 2 складу' 

select @i=max (SrcPosID)
from _tests3

set @x = 1
while @x<=@i
begin 
insert into t_saled 
select *
from _tests3
where _tests3.SrcPosID = @x
set @x= @x+1
end
print 'заполнили таблицу t_saled за день по 3 складу'

print 'Закончили обрабатывать '+ RTRIM(CONVERT(varchar(11),@tday))
set  @dey = @dey -1
end
print 'Сжатие БД'
dbcc  shrinkdatabase (otdatam6)
