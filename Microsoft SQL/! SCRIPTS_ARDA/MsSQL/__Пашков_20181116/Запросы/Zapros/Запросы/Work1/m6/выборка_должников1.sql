use otdata_m6
select chid,  sum (paysumcc)as paysumcc
into _t_recPR
from t_recPR
group by chid

/*select *
from _t_recPR
order by chid

*/

select chid , sum (paysumcc)as 'оплата'	
into _t_recpo
from t_recpo
group by chid 

/*select *
from _t_recPO
order by chid
*/

select t.docdate , t.compid ,r.compname, round (sum(td.sumcc_wt),2)as 'ѕриход', isnull (tr.paysumcc,0.00 )as '¬озврат', isnull (tro.оплата,0.00)as 'оплата прихода'
				,round ((sum(td.sumcc_wt)- isnull (tr.paysumcc,0.00 ) - isnull (tro.оплата,0.00)),2) as 'ƒолг'
--			, t.chid as chid1 , tr.chid as chid2 ,tr.pchid , tro.chid as chid3 ,tro.pchid as pchid1 
into _Dolg
from t_rec t inner join t_recd td on t.chid = td.chid 
	left join _t_recPR tr on td.chid = tr.chid left join _t_recpo tro on t.chid = tro.chid 
		inner join r_comps r on t.compid = r.compid
		where year (t.docdate)= year (getdate()) and month (t.docdate)<= month (getdate()) - 1 and r.CodeID4 = 0 
		and t.docdate  >= CONVERT(DATETIME, '2007-01-01 00:00:00', 102) and t.compid = 450
group by t.docdate , t.compid ,tr.paysumcc, tro.оплата ,r.compname --, t.chid , tr.chid ,tr.pchid , tro.chid ,tro.pchid
order by t.docdate, t.compid

drop table  _t_recPR
drop table  _t_recpo

select compname , docdate , приход , возврат ,[оплата прихода],долг
from _dolg
where [долг]<>0
--GROUP by docdate, compid, compname, [приход], [возврат],[ќплата прихода] , [долг}
order by  compname ,docdate 
--drop table _dolg


select *
into _dolg22
from _dolg
where [долг]<>0

drop table _dolg
drop table _dolg22



