use otdata
--select r.ProdId, r.ProdName, r.InStopList
update r_prods
set InStopList=1
--from r_Prods r
where ProdName like '% ������ %�����%' /*and r.ProdName like '%���%'*/ and instoplist=0