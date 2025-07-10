use otdata
select p.DocDate, count(r.SrcPosID), t.EmpName
from t_Rec p, t_RecD r, r_Emps t
where p.CHID=r.CHID and p.EmpID=t.EmpID
and p.DocDate between '6/09/2006' and '6/09/2006'
group by p.DocDate, t.EmpName
order by p.DocDate