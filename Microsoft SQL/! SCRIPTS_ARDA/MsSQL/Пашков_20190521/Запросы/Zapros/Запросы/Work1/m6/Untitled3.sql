use otdata_m6
select docdate , compid , compname ,  ������ , ������� , [������ �������] , abs (����) as dolg                                    
--from _dolg d1 inner join _dolg d2 on abs(d1.[����]) = d2.[����] 
into _dolg1
from _dolg 
where [����]<0
delete  
--select d1.docdate , d1.compid , d1.compname ,  d1.������ , d1.������� , d1.[������ �������] , d1.����
from _dolg inner join _dolg1
where _dolg.���� =  _dolg1.dolg

select *
from  _dolg1