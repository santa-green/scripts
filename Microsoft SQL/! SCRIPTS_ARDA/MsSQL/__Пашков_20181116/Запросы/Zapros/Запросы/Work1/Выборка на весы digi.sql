use otdata
select
r.ProdID,
r.ProdName,
convert (int, (pr.PriceMC*100)),
r.Age,
convert (int, r.Weight),
convert (int, substring (p.Barcode,5,7)),'
'
from r_Prods r
inner join r_ProdMQ p on r.ProdID=p.ProdID
inner join r_ProdMP pr on r.ProdID=pr.ProdID
where p.BarCode like '2200%' and p.PLID=pr.PLID
order by p.BarCode