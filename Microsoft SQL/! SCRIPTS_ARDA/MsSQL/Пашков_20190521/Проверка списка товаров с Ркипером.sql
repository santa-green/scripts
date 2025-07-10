USE ElitR


SELECT * FROM (
	SELECT ProdID,	ProdName,	PriceMC,	Norma4
	,(SELECT top 1 1 FROM r_ProdMP where ProdID = vvv.ProdID and PLID = 76 and InUse = 1) as '76 - Болоньез'  
	,(SELECT top 1 1 FROM r_ProdMP where ProdID = vvv.ProdID and PLID = 71 and InUse = 1) as '71 - Ресторан' 
	,(SELECT top 1 1 FROM r_ProdMP where ProdID = vvv.ProdID and PLID = 77 and InUse = 1) as '77 - Летняя плошадка' 
	FROM (
		SELECT distinct p.ProdID,p.ProdName,mp.PriceMC,p.Norma4
		FROM r_ProdMP mp
		JOIN r_Prods p ON p.ProdID = mp.ProdID
		WHERE mp.InUse = 1
		and PLID in (71)
		--and p.ProdID in (607759)
	) vvv
)ttt
--where ttt.[76 - Болоньез] = 1
where ttt.[71 - Ресторан] = 1
ORDER BY 1

SELECT * FROM (
	SELECT ProdID,	ProdName,	PriceMC,	Norma4
	,(SELECT top 1 1 FROM r_ProdMP where ProdID = vvv.ProdID and PLID = 76 and InUse = 1) as '76 - Болоньез'  
	,(SELECT top 1 1 FROM r_ProdMP where ProdID = vvv.ProdID and PLID = 71 and InUse = 1) as '71 - Ресторан' 
	,(SELECT top 1 1 FROM r_ProdMP where ProdID = vvv.ProdID and PLID = 77 and InUse = 1) as '77 - Летняя плошадка' 
	FROM (
		SELECT distinct p.ProdID,p.ProdName,mp.PriceMC,p.Norma4
		FROM r_ProdMP mp
		JOIN r_Prods p ON p.ProdID = mp.ProdID
		WHERE mp.InUse = 1
		and PLID in (76)
		--and p.ProdID in (607759)
	) vvv
)ttt
where ttt.[76 - Болоньез] = 1
--where ttt.[71 - Ресторан] = 1
ORDER BY 1


SELECT ProdID,	ProdName,	PriceMC,	Norma4
	,(SELECT top 1 1 FROM r_ProdMP where ProdID = vvv.ProdID and PLID = 76 and InUse = 1) as '76 - Болоньез'  
	,(SELECT top 1 1 FROM r_ProdMP where ProdID = vvv.ProdID and PLID = 71 and InUse = 1) as '71 - Ресторан' 
	,(SELECT top 1 1 FROM r_ProdMP where ProdID = vvv.ProdID and PLID = 77 and InUse = 1) as '77 - Летняя плошадка' 
	FROM (
		SELECT distinct p.ProdID,p.ProdName,mp.PriceMC,p.Norma4
		FROM r_ProdMP mp
		JOIN r_Prods p ON p.ProdID = mp.ProdID
		WHERE mp.InUse = 1
		and PLID in (71,76,77)
		--and p.ProdID in (600362,605069,800360)
	) vvv
ORDER BY 1	

SELECT distinct p.ProdID,p.ProdName,mp.PriceMC,p.Norma4
		FROM r_ProdMP mp
		JOIN r_Prods p ON p.ProdID = mp.ProdID
		WHERE mp.InUse = 1
		and PLID in (71,76,77)
ORDER BY 1			

SELECT distinct p.ProdID,p.ProdName,mp.PriceMC,p.Norma4, *
		FROM r_ProdMP mp
		JOIN r_Prods p ON p.ProdID = mp.ProdID
		WHERE mp.InUse = 1
		--and PLID in (71,76)
		and p.ProdID in (607759)
ORDER BY 1		