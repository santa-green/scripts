use otdata
select prodname, convert (int, substring (p.Barcode,5,7)) as [Код весов]
from r_prods r
INNER JOIN r_ProdMQ p on r.ProdID=p.ProdID
where p.barcode like '2200%' and p.plid=0 and r.InStopList=0 and pgrid2=26
order by r.prodname
