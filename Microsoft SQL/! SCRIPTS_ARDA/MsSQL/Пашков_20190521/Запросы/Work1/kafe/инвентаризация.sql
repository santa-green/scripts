select prodid , max(ppid) as MaxppiD
into _tempPID
from t_pinp 
where prodid >0 
group by prodid 

select t.prodid , t1.priceMC_IN, t1.ppid
into _temppriceMC_IN
from  _tempPID t inner join t_pinp t1 on t.prodid = t1.prodid
where t.Maxppid = t1.ppid and t.Maxppid >0
order  by t.prodid 


--select *
--from _temppriceMC_IN

update _inv
set _inv.[цена]= t1.priceMC_IN
from _temppriceMC_IN t1 inner join _inv i on t1.prodid = i.[код товара]

select [цена],[позиция]
from _inv

drop table _tempPID
drop table _temppriceMC_IN
