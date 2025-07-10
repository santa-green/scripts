set nocount on
declare @chid int
declare @data datetime 
declare @chidP int
set @data = CONVERT(DATETIME ,(datediff (day ,2,getdate())), 102)
select prodid ,sum(qty) qty
into _t_rem1
from t_rem
group by prodid
order by prodid
select *
into _t_rem2
from _t_rem1
where qty < 0
select @chid = max(chid) 
from t_srec
	insert into t_srec
	select ChID+1 as chid,DocID+1 as DocID,IntDocID+1 as IntDocID,@data as DocDate,KursMC,OurID,2 as StockID,
	CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,DocStatID,EmpID,Notes, @data as SubDocDate,2 as SubStockID,Value1,
	Value2,Value3 
	  from t_srec
	where chid = @chid
set @chid = @chid + 1
declare @AChID int
select @AChID = max (AChID)+1
from t_srecA
select @chid as ChID ,identity(smallint,1,1) as SrcPosID ,td.ProdID , 0 as PPID ,td.UM ,sum (td.Qty) as qty,
	0 as SetCostCC ,0 as SetValue1 ,0 as SetValue2 ,0 as SetValue3 ,0 as PriceCC_nt ,0 as SumCC_nt ,0 as Tax ,
	0 as TaxSum ,0 as PriceCC_wt ,0 as SumCC_wt ,0 as Extra ,0 as PriceCC ,0 as NewPriceCC_nt ,0 as NewSumCC_nt ,
	0 as NewTax ,0 as NewTaxSum ,0 as NewPriceCC_wt ,0 as NewSumCC_wt ,@AChID as AChID ,rq.BarCode ,1 as SecID
 into _T_srecA
from t_saled td inner join t_sale t on td.chid = t.chid inner join r_prods r on td.prodid = r.prodid 
		INNER join _t_rem2 tq on td.prodid = tq.prodid inner join r_prodmq rq on td.prodid = rq.prodid 
where  t.docdate = @data and t.CodeID5 = 0 and r.PgriD3 = 2 and td.prodid = tq.prodid and r.um = rq.um
group by td.ProdID ,td.UM, rq.BarCode
declare @t int , @i int ,@d int 
select  @t = max (Achid),@i = max(srcposid)
from _T_srecA
set @d= 0 
while @d < @i
begin 
update _T_srecA
set _T_srecA.Achid = @t+@d
where  _T_srecA.srcposid = @d+1 
set @d= @d+1
end
insert into T_srecA
select *
from _T_srecA
update t_sale 
set t_sale.CodeID5 = 1, t_sale.docstatId = 4
where t_sale.CodeID5 = 0 and t_sale.docdate = @data
drop table _T_srecA
drop table  _t_rem1
drop table  _t_rem2