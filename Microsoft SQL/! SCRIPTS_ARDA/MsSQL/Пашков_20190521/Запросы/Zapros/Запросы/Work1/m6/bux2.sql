
select round ( sum (td.qty*tp.priceMC_In),2)as [����� ������� � ��] ,r.[���] 
into _t_sale
from t_sale t inner join t_saleD td on t.chid = td.chid inner join t_pinp tp on (td.prodid = tp.prodid and td.ppid = tp.ppid)
			inner join _r_comps r on tp.compid  = r.[���] 
where year (t.docdate)= year (getdate()) and month (t.docdate)= month (getdate()) - 1 
group by r.[���]


select *
from _r_comps 

update _r_comps 
set _r_comps.[����� ������� � ��] = t.[����� ������� � ��]
from _r_comps r inner join _t_sale t on r.[���] = t.[���]

--drop table  _t_sale




