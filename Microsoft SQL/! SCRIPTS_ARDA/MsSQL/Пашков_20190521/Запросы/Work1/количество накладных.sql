--use otdata
select p.DocDate, count(p.DocID)--, t.EmpName
from t_Rec p--, t_RecD r
--, r_Emps t
where --p.CHID=r.CHID and 
--p.EmpID=t.EmpID
p.DocDate between '01/01/2008' and '01/31/2008'
group by p.DocDate--, t.EmpName
order by p.DocDate