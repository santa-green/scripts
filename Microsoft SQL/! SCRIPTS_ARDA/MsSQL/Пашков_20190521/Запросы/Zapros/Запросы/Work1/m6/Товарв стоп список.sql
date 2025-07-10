select prodid , sum (qty)as sumqty 
into temp_t_rem
from t_rem 
group by prodid

select t.prodid , sum (t.qty) as sumSqty
into temp_t_Saled
from t_saled t  inner join t_sale ts on t.chid =  ts.chid
where ts.docdate >= CONVERT(DATETIME, '2010-01-01 00:00:00', 102) -- дата после котрой товар не продавался
group by t.prodid

select td.prodid , sum (td.qty)as RecQty
into temp_t_recD
from   t_rec t inner join t_recD td  on t.chid= td.chid
where t.docdate >= CONVERT(DATETIME, '2010-01-01 00:00:00', 102) and t.compid = 615 --код поставщика и дата после которой товар не приходил
group by td.prodid


select  temp_t_rem .prodid , r.prodname , sum (temp_t_rem .sumqty)as Remsum, temp_t_recD.RecQty ,temp_t_Saled.sumSqty 
into r_prods_instoplist
from temp_t_rem  full join temp_t_Saled  on temp_t_rem.prodid = temp_t_Saled.prodid   
 full join temp_t_recD on temp_t_rem.prodid = temp_t_recD .prodid
	inner join r_prods r on r.prodid = temp_t_rem .prodid inner join t_pinp tn on temp_t_rem .prodid= tn.prodid 

 where sumqty =0 and temp_t_Saled.prodid  is null and temp_t_recD .prodid is null and tn.compid =615 -- то же код поставщика 
group by temp_t_rem .prodid , r.prodname , temp_t_recD.RecQty  ,temp_t_Saled.sumSqty 
order by r.prodname

/*select  *
from temp_t_Saled where sumSqty = 0

select  *
from temp_t_recD where Recqty =0
*/
select *
from r_prods_instoplist rs inner join r_prods r on rs.prodid = r.prodid
order by r.prodname




update r_prods
set r_prods.instoplist = 1 
from r_prods_instoplist 
where r_prods_instoplist .prodid = r_prods.prodid

drop table r_prods_instoplist
drop table temp_t_rem
drop table temp_t_Saled
drop table temp_t_recD