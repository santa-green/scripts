
select tp.chid , tp.LayUM , tp.LayQty , [Ед# изм# закладки] as UM ,[Норма закладки]as Norms
into _param
from dbo.it_SpecParams tp join _newcalc n on tp.chid = n.chid
where tp.chid between  1565 and 1910 
group by tp.chid , tp.LayUM , tp.LayQty , [Ед# изм# закладки],[Норма закладки]



select tp.* ,p.*
from _param p join dbo.it_SpecParams tp on p.chid = tp.chid
where tp.chid between  1565 and 1910

update dbo.it_SpecParams 
set LayUM = p.UM , LayQty = p.Norms
from _param p join dbo.it_SpecParams tp on p.chid = tp.chid
where tp.chid between  1565 and 1910

select 

drop table _param


select * 
into _Newcalc
from ElitV_TEST.dbo._Newcalc