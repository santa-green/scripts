use otdata
select --top 550
convert (int, substring (p.Barcode,5,7)),
substring (r.ProdName,1,28),
substring (r.ProdName,29,20) + ' ' + '(' + convert (varchar(5),r.ProdID) + ')',
pr.PriceMC
--r.Age,
--convert (int, r.Weight),
,convert (int, substring (p.Barcode,5,7))
--substring (p.Barcode,1,2)
, rc.compname 
from r_Prods r
inner join r_ProdMQ p on r.ProdID=p.ProdID
inner join r_ProdMP pr on r.ProdID=pr.ProdID inner join t_pinp tp on r.prodid = tp.prodid 
	inner join r_comps rc on tp.compid = rc.compid
where p.BarCode like '2200%' and p.PLID=pr.PLID and r.ProdName not like '@%'
group by rc.compname ,p.Barcode ,r.ProdName ,pr.PriceMC ,r.ProdID
order by rc.compname ,r.ProdName, p.BarCode 