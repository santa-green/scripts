--use otdata
select p.DocDate, count(r.SrcPosID)--, t.EmpName
from t_Rec p, t_RecD r, r_Emps t
where p.CHID=r.CHID and p.EmpID=t.EmpID
and p.DocDate between '1/01/2008' and '1/31/2008'
group by p.DocDate
order by p.DocDate