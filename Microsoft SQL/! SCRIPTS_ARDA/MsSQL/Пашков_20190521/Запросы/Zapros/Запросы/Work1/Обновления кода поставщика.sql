use otdatam6
update otdataM6.dbo.r_comps
set otdataM6.dbo.r_comps.compname = otdataM7.dbo.r_comps.compname
 
--select otdataM6.dbo.r_comps.compid , otdataM6.dbo.r_comps.compname ,otdataM7.dbo.r_comps.compid , otdataM7.dbo.r_comps.compname 

from otdataM6.dbo.r_comps
full join otdataM7.dbo.r_comps   on otdataM6.dbo.r_comps.compid  = otdataM7.dbo.r_comps.compid 
--where otdataM6.dbo.r_comps.compid is not null
--and substring (otdataM6.dbo.r_comps.compname,1,3) like (substring (otdataM7.dbo.r_comps.compname,1,3))
where otdataM7.dbo.r_comps.compid = 307
