select convert (int, substring (p.Barcode,3,7))as code,r.ProdName,convert (int, (pr.PriceMC*100))as prise
from r_Prods r
inner join r_ProdMQ p on r.ProdID=p.ProdID
inner join r_prodMP pr on r.ProdID=pr.ProdID
where p.BarCode like '23%' and r.UM like '%Í„%' and pr.PlID=p.PlID
order by r.ProdID