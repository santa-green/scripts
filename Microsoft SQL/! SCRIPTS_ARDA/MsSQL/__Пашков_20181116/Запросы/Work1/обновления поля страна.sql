select r.prodid , r.prodname, r.um  ,r.country ,rq.barcode
from r_prods r inner join r_prodMQ rq on r.prodid = rq.prodid

where country = '' --поле страна в карточке пустое
and r.um = rq.um --основной  вид упаковки 
and rq.barcode  like '48200%' -- скан код -48200 - украина
and r.pgrid1 = -- код отдела
order  by r.prodid

update r_prods
	set  r_prods.country = 'Украина' --обновление
from r_prods r inner join r_prodMQ rq on r.prodid = rq.prodid

where country = '' --поле страна в карточке пустое
and r.um = rq.um --основной  вид упаковки 
and rq.barcode  like '48200%' -- скан код -48200 - украина
and r.pgrid1 = -- код отдела

