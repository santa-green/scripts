--“овары в кафе без кода ” “¬Ёƒ
SELECT r.ProdID,r.ProdName, r.CstProdCode, * FROM r_Prods r
where r.ProdID in (SELECT AValue FROM zf_FilterToTable('605001-609999'))
and r.Norma4 = 2
and r.ProdID in (SELECT ProdID FROM r_ProdMP where PLID in (71,76) and InUse = 1 and PriceMC > 0)
and r.CstProdCode  is null

--јктуальные товары в магазине без кода ” “¬Ёƒ
SELECT r.ProdID,r.ProdName ,r.CstProdCode, * FROM r_Prods r
where (r.ProdID between 600001 and 604999 or r.ProdID between 800000 and 900000)
and r.ProdID in (
	SELECT distinct d.ProdID FROM t_Sale s
		join t_SaleD d on d.ChID = s.ChID
		where s.OurID in (9) 
		and DocDate > '2016-01-01'
	UNION
		SELECT distinct ProdID FROM t_Rem where Qty <> 0
)
and len( isnull(r.CstProdCode,0))  < 10
order by r.CstProdCode
--and r.ProdID = 602435


	SELECT distinct d.ProdID FROM t_Sale s
	join t_SaleD d on d.ChID = s.ChID
	where s.OurID in (9) 
	and DocDate > '2016-01-01'

SELECT distinct ProdID FROM t_Rem where Qty <> 0

SELECT distinct ProdID FROM r_ProdMP 

SELECT AValue FROM zf_FilterToTable('800000-900000')

--af_FilterToFilter(AzValids +',12')  
--zf_FilterToTable

--
SELECT distinct  d.ProdID fROM t_Sale m
join t_SaleD D on d.ChID = m.ChID
where m.DocDate >= '2016-01-01' and m.OurID = 9
union
SELECT distinct  ProdID FROM t_Rem where OurID = 9 and Qty >0
and ProdID between 600001 and 604999 or ProdID between 800000 and 900000
order by 1
