use otdata
select rq.barcode ,r.prodid , r.prodname , r.um ,v.st

from  r_prods r inner join r_prodmq rq on r.prodid = rq.prodid
		inner join  _vw v on r.prodid = v.prodid

where v.st = 0 and rq.barcode like '2200%'
order by rq.barcode 

