use otdata_M7	
select r.prodid , p.prodname , p.prodid, r.pricemc , r.notes
from r_prodMp r inner join priseMc p on r.prodid = p.prodid
where r.plid = 0

update r_prodMp 
set r_prodMp .notes = r.pricemc
from r_prodMp r inner join priseMc p on r.prodid = p.prodid
where r.plid = 0


update r_prodMp 
set r_prodMp .pricemc = round (r.pricemc * 0.97 ,2)
from r_prodMp r inner join priseMc p on r.prodid = p.prodid
where r.plid = 0

update r_prodMp 
set r_prodMp .pricemc = r.notes
from r_prodMp r inner join priseMc p on r.prodid = p.prodid
where r.plid = 0