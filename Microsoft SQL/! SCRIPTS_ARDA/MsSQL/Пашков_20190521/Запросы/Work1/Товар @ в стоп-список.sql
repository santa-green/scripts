use otdata
--select r.ProdId, r.ProdName, r.InStopList
update r_prods
set InStopList=1
--from r_Prods r
where ProdName like '% свиточ %эмоци%' /*and r.ProdName like '%авк%'*/ and instoplist=0