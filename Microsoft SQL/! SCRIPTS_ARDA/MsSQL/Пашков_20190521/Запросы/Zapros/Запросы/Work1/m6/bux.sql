use otdata_m6
update _r_comps
set _r_comps.[№п/п] = ' '
where _r_comps.[№п/п]is null and _r_comps.[наименование предприятия] not like 'итого'

/*update _r_comps
set _r_comps.[№п/п] = '№п/п'
where _r_comps.[№п/п] = 0
*/

update _r_comps
set _r_comps.[% скидки] = _r_comps.[% скидки]*100

select t.compID,r.compname, sum (td.sumcc_wt)as sumcc, round (avg (td.extra),2)as extra, r.notes ,r.discount ,r.codeId4
into _r_comps1
from t_rec t inner join t_recd td on t.chid = td.chid inner join r_comps r on t.compid = r.compid 
where year (t.docdate)= 2008 /*year (getdate())*/ and month (t.docdate)= 10 --month (getdate()) - 3 
group by t.compID,r.compname, r.notes ,r.discount ,r.codeId4
order by r.compname

update _r_comps

		set _r_comps.[1] =round (_r_comps1.sumcc , 2 )

from _r_comps ,_r_comps1 
where _r_comps.[код]= _r_comps1.compId
drop table _r_comps1

select t.compID,r.compname, sum (td.sumcc_wt)as sumcc, round (avg (td.extra),2)as extra, r.notes ,r.discount ,r.codeId4
into _r_comps1
from t_rec t inner join t_recd td on t.chid = td.chid inner join r_comps r on t.compid = r.compid 
where year (t.docdate)= year (getdate()) and month (t.docdate)= month (getdate()) - 2 
group by t.compID,r.compname, r.notes ,r.discount ,r.codeId4
order by r.compname

update _r_comps

	set _r_comps.[2] =round (_r_comps1.sumcc , 2 )

from _r_comps ,_r_comps1 
where _r_comps.[код]= _r_comps1.compId
drop table _r_comps1

select t.compID,r.compname, sum (td.sumcc_wt)as sumcc, round (avg (td.extra),2)as extra, r.notes ,r.discount ,r.codeId4
into _r_comps1
from t_rec t inner join t_recd td on t.chid = td.chid inner join r_comps r on t.compid = r.compid 
where year (t.docdate)= year (getdate()) and month (t.docdate)= month (getdate()) - 1 
group by t.compID,r.compname, r.notes ,r.discount ,r.codeId4
order by r.compname

update _r_comps
	set _r_comps.[% наценки] = _r_comps1.extra,
		_r_comps.[3] =round (_r_comps1.sumcc , 2 )

from _r_comps ,_r_comps1 
where _r_comps.[код]= _r_comps1.compId
drop table _r_comps1


select *
from _r_comps


	--truncate table _r_comps
