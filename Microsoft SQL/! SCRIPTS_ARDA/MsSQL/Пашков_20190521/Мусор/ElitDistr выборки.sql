select DocID, SUM(Qty) Qty from t_Ret a join t_retD  b on a.chid=b.chid
WHERE  DocID  between 3449 and 3484
group by DocID
ORDER BY 1

select  SUM(Qty) Qty from t_Ret a join t_retD  b on a.chid=b.chid
WHERE  DocID  between 3449 and 3484

select  SUM(Qty) Qty from t_Ret a join t_retD  b on a.chid=b.chid
WHERE  DocDate = '2017-11-22'


select DocID, ProdID, SUM(Qty) Qty from t_Ret a join t_retD  b on a.chid=b.chid
WHERE  DocID  = 3452
group by DocID, ProdID
ORDER BY 1,2,3






select * from t_Ret a join t_retD  b on a.chid=b.chid

SELECT * FROM (
select DocID, ProdID, count(ProdID) col from t_Ret a join t_retD  b on a.chid=b.chid
--WHERE  count(ProdID) <>1
group by DocID, ProdID
)gr
WHERE  col = 2
ORDER BY 3,1,2


SELECT * FROM t_SRec m 
join t_SRecA a ON a.ChID = m.ChID
join t_SRecD d ON d.AChID = a.AChID
where m.DocDate = '2017-11-22'

--список составляющих товаров в комплектации
SELECT distinct d.SubProdID FROM t_SRec m 
join t_SRecA a ON a.ChID = m.ChID
join t_SRecD d ON d.AChID = a.AChID
where m.DocDate = '2017-11-22'
ORDER BY 1

--приходы товаров
SELECT distinct d.ProdID FROM t_Rec m
JOIN t_RecD d ON d.ChID = m.ChID
--JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE m.DocID in (16,17)  --and d.ProdID = 
ORDER BY 1

--список товаров которых нет в приходах 16,17 но есть в комплектации товара 36
SELECT distinct d.SubProdID, p.ProdName FROM t_SRec m 
join t_SRecA a ON a.ChID = m.ChID
join t_SRecD d ON d.AChID = a.AChID
JOIN r_Prods p ON p.ProdID = d.SubProdID
where m.DocDate = '2017-11-22'
and d.SubProdID not in (
	--приходы товаров
	SELECT distinct d.ProdID FROM t_Rec m
	JOIN t_RecD d ON d.ChID = m.ChID
	--JOIN r_Prods p ON p.ProdID = d.ProdID
	WHERE m.DocID in (16,17)  --and d.ProdID = 
)
ORDER BY 1
