
use otdatamc
--deallocate Newtable 
--declare Newtable cursor
--for 
select /*t.docid ,ta.achid, td.Achid ,*/ ta.prodid , ta.qty , r.prodname,  sum (td.subqty)as subqty
from t_srec  t inner join t_sreca ta on (t.chid = ta.chid )
		inner join t_srecD td on ta.achid = td.Achid INNER join r_prods r on td.subprodid = r.prodid 
where t.docid = 475 
group by t.docid ,ta.achid, td.Achid , ta.prodid , ta.qty , td.subprodid ,r.prodname
/*open Newtable
fetch next from Newtable  
while @@fetch_status = 0
begin 
fetch next from Newtable  
end

deallocate Newtable 
*/
