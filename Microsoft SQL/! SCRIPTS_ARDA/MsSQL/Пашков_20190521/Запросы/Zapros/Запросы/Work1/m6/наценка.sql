use otdata

select  t.prodid ,r.prodname , max (t.ppid)as MaxPPid , sum(t.qty)as SQty ,r.um ,r.pgrid 
into _t_rem
from t_rem t inner join r_prods r on t.prodid = r.prodid
group by t.prodid ,r.prodname ,r.pgrid , r.um
having sum(t.qty)>0 and r.pgrid = 27
order by t.prodid

select rc.compname [Поставщик],rg.Pgrname [Наименование группы],t.prodname [Наименование товара],t.um [Ед.изм.],
	tp.priceMC_in[Цена прихода с НДС], rm.priceMC [Цена продажи],
	round( (rm.priceMC/tp.priceMC_in -1)*100 ,2) as Наценка , t.Sqty [Текущие остатки]
from _t_rem t inner join t_pinp tp on t.prodid = tp.prodid inner join r_prodMp rm on tp.prodid = rm.prodid
	inner join r_comps rc on tp.compid = rc.compid inner join r_prodG rg on t.pgrid = rg.pgrid
where t.MaxPPid = tp.ppid and rm.plid= 0
order by rc.compname

drop table  _t_rem