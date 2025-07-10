use otdata_m6
select docdate , compid , compname ,  Приход , Возврат , [оплата прихода] , abs (Долг) as dolg                                    
--from _dolg d1 inner join _dolg d2 on abs(d1.[долг]) = d2.[долг] 
into _dolg1
from _dolg 
where [долг]<0
delete  
--select d1.docdate , d1.compid , d1.compname ,  d1.Приход , d1.Возврат , d1.[оплата прихода] , d1.Долг
from _dolg inner join _dolg1
where _dolg.долг =  _dolg1.dolg

select *
from  _dolg1