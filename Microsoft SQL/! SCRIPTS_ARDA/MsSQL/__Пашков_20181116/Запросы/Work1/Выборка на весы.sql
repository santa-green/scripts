use otdata
select --top 550
convert (int, substring (p.Barcode,5,7)),
substring (r.ProdName,1,28),
substring (r.ProdName,29,20) + ' ' + '(' + convert (varchar(5),r.ProdID) + ')',
convert (int, (pr.PriceMC*100)),
r.Age,
convert (int, r.Weight),
convert (int, substring (p.Barcode,5,7)),
substring (p.Barcode,1,2),'
'
from r_Prods r
inner join r_ProdMQ p on r.ProdID=p.ProdID
inner join r_ProdMP pr on r.ProdID=pr.ProdID
where p.BarCode like '2200%' and p.PLID=pr.PLID
order by p.BarCode