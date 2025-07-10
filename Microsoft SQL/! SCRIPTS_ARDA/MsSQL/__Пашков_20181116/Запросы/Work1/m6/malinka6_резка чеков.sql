use otdata_m6
/*выборка заголовков чеков*/

BEGIN TRANSACTION T1
set nocount on
declare @ch2 int,
	@ch3 int,	
	@dey int,
	@tday datetime		

set @dey = 35
print @dey
while @dey >30
begin 
print @dey
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
drop table _tests5
drop table _tests2
drop table _tests3
end

PRINT 'Производится расчёт текущих остатков. Пожалуйста подождите...'
SELECT (t_PRemReady)FROM z_SysApps
UPDATE z_SysApps SET t_PRemReady = 0
SELECT SUM (Qty) FROM t_Rem
SELECT * FROM t__BProd
TRUNCATE TABLE t_Remx
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_ExpsE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_RecsE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_CRRetsE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_SalesE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_CRSalesE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_zInPsE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_ExcsER WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_ExcsEE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_VensER WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_VensEE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_EstsER WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_EstsEE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_EppsE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_RetsE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_SExpsEE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_SExpsER WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_SRecsEE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_SRecsER WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(Qty*10) FROM t_CstsE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecId, ProdID, PPID, SUM(0 - Qty*10) FROM t_CRetsE WHERE InRems<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
INSERT INTO t_Remx (OurID, StockID, SecID, ProdID, PPID, Qty) SELECT OurID, StockID, SecID, ProdID, PPID, SUM(0 - Qty*10) FROM t_AccsE WHERE InRems<>0  AND ReserveProds<>0 GROUP BY OurID, StockID, SecID, ProdID, PPID
UPDATE t_Rem SET Qty=0 WHERE Qty IS NULL
DELETE FROM t_Rem
INSERT INTO t_Rem (OurID, StockID, SecId, ProdID, PPID, Qty) SELECT OurID, StockID, SecID, ProdID, PPID, SUM(Qty)/10 FROM t_Remx GROUP BY OurID, StockID, SecID, ProdID, PPID ORDER BY OurID, StockID, SecID, ProdID, PPID
SELECT (t_RZ) FROM z_Sys
TRUNCATE TABLE t_Remx
SELECT SUM (Qty) FROM t_Rem
UPDATE STATISTICS t_Rem
UPDATE z_SysApps
SET t_PRemReady = 1
If @@error <> 0  ROLLBACK TRANSACTION T1
print 'Сжатие БД'
dbcc  shrinkdatabase (otdata_m6)


