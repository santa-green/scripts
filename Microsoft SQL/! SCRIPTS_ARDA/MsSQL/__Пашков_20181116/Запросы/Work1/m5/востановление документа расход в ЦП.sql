insert into  otdataM5_last.dbo.t_epp
select *
from otdataM5.dbo.t_epp
where otdataM5.dbo.t_epp.chid in
(select td.chid
from otdataM5_last.dbo.t_epp t full join otdataM5_last.dbo.t_eppd td on t.chid = td.chid
where t.chid is null
group by td.chid)

