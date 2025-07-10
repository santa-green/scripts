use otdata_cafe
set nocount on
declare @chid int
declare @data datetime 
declare @chidP int
set @data = CONVERT(DATETIME ,(datediff (day ,1,getdate())), 102) -- текущая дата
/*Номер максимального заполненного чека*/
/*select @chidP = max (chid)
from t_saled td inner join t_sale t on td.chid = t.chid 
where t.docdate = @data
*/
/**/
select @chid = max(chid) 
from t_srec

/*Создание нового док- та комплектации по кухне*/
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

select prodid , ppid
into _t_rem 
from t_rem
group by prodid , qty, ppid
having sum (qty) <0 
order by prodid

/*заполнение временой таблици данными из таблицы продаж по кухне */

select @chid as ChID ,identity(smallint,1,1) as SrcPosID ,td.ProdID , 0 as PPID ,td.UM ,sum (td.Qty) as qty,
	0 as SetCostCC ,0 as SetValue1 ,0 as SetValue2 ,0 as SetValue3 ,0 as PriceCC_nt ,0 as SumCC_nt ,0 as Tax ,
	0 as TaxSum ,0 as PriceCC_wt ,0 as SumCC_wt ,0 as Extra ,0 as PriceCC ,0 as NewPriceCC_nt ,0 as NewSumCC_nt ,
	0 as NewTax ,0 as NewTaxSum ,0 as NewPriceCC_wt ,0 as NewSumCC_wt ,@AChID as AChID ,td.BarCode ,1 as SecID
 into _T_srecA
from t_saled td inner join t_sale t on td.chid = t.chid inner join r_prods r on td.prodid = r.prodid 
		INNER join _t_rem tq on td.prodid = tq.prodid 
where  t.docdate = @data and t.CodeID5 = 0 and r.PgriD3 = 2 and /*t.chid <= @chidP and*/  td.prodid = tq.prodid 
									and td.ppid = tq.ppid 					
	/*td.prodid in 
				
					(select t1.prodid 
						from t_rem t1
						group by t1.prodid
						having sum (qty)<0
						)
								
		*/
 group by td.ProdID ,td.UM, td.BarCode
/*обновление Achid во временной таблице*/
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

/*заполение комплектации из временной таблицы*/
insert into T_srecA
select *
from _T_srecA
drop table _T_srecA



select @chid = max(chid) 
from t_srec
print @chid
/*Создание нового док- та комплектации по бару*/
	insert into t_srec
	select ChID+1 as chid,DocID+1 as DocID,IntDocID+1 as IntDocID,@data as DocDate,KursMC,OurID,2 as StockID,
		CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,DocStatID,EmpID,Notes,@data as SubDocDate,3 as SubStockID,
		Value1,Value2,Value3 
	  from t_srec
	where chid = @chid
set @chid = @chid + 1


select @AChID = max (AChID)+1
from t_srecA
print @AChID

/*заполнение временой таблици данными из таблицы продаж по бару*/

select @chid as ChID ,identity(smallint,1,1) as SrcPosID ,td.ProdID , 0 as PPID ,td.UM ,sum (td.Qty) as qty,
	0 as SetCostCC ,0 as SetValue1 ,0 as SetValue2 ,0 as SetValue3 ,0 as PriceCC_nt ,0 as SumCC_nt ,
	0 as Tax ,0 as TaxSum ,0 as PriceCC_wt ,0 as SumCC_wt ,0 as Extra ,0 as PriceCC ,0 as NewPriceCC_nt ,
	0 as NewSumCC_nt ,0 as NewTax ,0 as NewTaxSum ,0 as NewPriceCC_wt ,0 as NewSumCC_wt ,@AChID as AChID ,
	td.BarCode ,1 as SecID
 into _T_srecA
from t_saled td inner join t_sale t on td.chid = t.chid inner join r_prods r on td.prodid = r.prodid 
		INNER join _t_rem tq on td.prodid = tq.prodid 
where  t.docdate = @data and t.CodeID5 = 0 and r.PgriD3 = 3 and /*t.chid <= @chidP and*/  td.prodid = tq.prodid 
									and td.ppid = tq.ppid 					
	/*td.prodid in 
				
					(select t1.prodid 
						from t_rem t1
						group by t1.prodid
						having sum (qty)<0
						)
								
		*/
 group by td.ProdID ,td.UM, td.BarCode

/*обновление Achid во временной таблице*/
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
/*обновление заголовка чека - док- нт скопирован в комплектацию и не доступен для редактирования*/
update t_sale 
set t_sale.CodeID5 = 1, t_sale.docstatId = 4
where t_sale.CodeID5 = 0 and t_sale.docdate = @data and t_sale.chid <= @chidP

/*заполение комплектации из временной таблицы*/
insert into T_srecA
select *
from _T_srecA
drop table _T_srecA
drop table  _t_rem