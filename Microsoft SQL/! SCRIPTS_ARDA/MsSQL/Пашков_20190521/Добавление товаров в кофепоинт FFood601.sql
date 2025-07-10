--Добавление товаров в кофепоинт [FFood601]

USE [FFood601] -- --CofePoint DP 192.168.42.6
--select * from [dbo].[z_ReplicaIn] order by replicaeventid  desc OPTION (FAST 1)

/*
после добавления товаров добавте эти товары в справочник меню
*/

/*
SELECT * FROM r_ProdC where PCatID in (SELECT AValue FROM dbo.zf_FilterToTable((SELECT top 1 VarValue FROM z_Vars where VarName like 'Food_CatFilter')))
ORDER BY Priority

SELECT * FROM r_ProdG3 where notes <> ''
ORDER BY Priority


SELECT * FROM r_prods p
join r_ProdMP mp on mp.ProdID= p.ProdID --and mp.PLID = 34 and mp.InUse = 1
where p.ProdName like '%Шоудье%'

SELECT * FROM r_prods p --and mp.PLID = 34 and mp.InUse = 1
where p.ProdName like '%Шоудье%'

Шоудье черный
Шоудье белый-молочный
Шоудье молочный трюфель
Шоудье черный карамель-корица



SELECT top 10000 * FROM r_Prods
order by 3

SELECT * FROM r_prods where ProdID = 605675
SELECT * FROM r_ProdA where ProdID = 605675
SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdA where PGrAID = 5027
SELECT PGrAID,* FROM [S-SQL-D4].ElitR.dbo.r_prods where ProdID = 605675
SELECT PGrAID,* FROM r_prods

SELECT top 100 * FROM dbo.r_ProdMP WHERE ProdID in (600362,611078) and PLID = 34 ORDER BY 1 
SELECT top 100 * FROM [S-SQL-D4].ElitR.dbo.r_Prods WHERE ProdID in (607877,607878) ORDER BY 1 
SELECT top 100 * FROM [S-SQL-D4].ElitR.dbo.r_ProdMP WHERE ProdID in (607877,607878) and PLID = 34 ORDER BY 1 
SELECT top 1000 * FROM r_Prods WHERE ProdID in (600362,611078) ORDER BY 1 

SELECT top 100 * FROM r_Prods WHERE ProdID in (607877,607878) ORDER BY 2
SELECT top 100 * FROM r_ProdMP WHERE ProdID in (607877,607878) ORDER BY 1
 
SELECT top 100 * FROM r_Prods WHERE ProdName like '%чай%%' ORDER BY 1 


SELECT * FROM r_prods p, r_ProdMP mp 
where p.ProdID = mp.ProdID
and mp.PLID = 34 --and mp.InUse = 1
 and p.ProdID in  (607133,607136,607203)

SELECT * FROM r_ProdMP mp where  mp.PLID = 34  and mp.ProdID in  (607877,607878)

update  mp
set mp.InUse = 1
from r_ProdMP mp where  mp.PLID = 34  and mp.ProdID in  (607877,607878)
 
 SELECT * FROM dbo.r_ProdMQ 
WHERE ProdID in (608187,608188,608189,608190,608191,608192,612330,612331,612332,612333,612334,612335,612336,603816)
*/

SELECT * FROM r_Prods where prodid in (611598,803903,803904,803905,803906)
SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Prods where prodid in (611598,803903,803904,803905,803906)

BEGIN TRAN

DECLARE @ProdIDTable table(ProdID int NULL) 
insert into @ProdIDTable select ProdID from [S-SQL-D4].ElitR.dbo.r_prods
	where ProdID in 
(
--Введите коды товаров	
803903,803904,803905,803906
)


	
SELECT ProdID FROM @ProdIDTable


--insert r_ProdA
--	SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdA where PGrAID not in (SELECT PGrAID FROM r_ProdA) and PGrAID in( 5027)
--SELECT * FROM r_ProdA

--insert at_r_ProdG4
--	SELECT * FROM [S-SQL-D4].ElitR.dbo.at_r_ProdG4 where PGrID4 not in (SELECT PGrID4 FROM at_r_ProdG4)
--SELECT * FROM at_r_ProdG4

insert r_ProdC
	SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdC where PCatID not in (SELECT PCatID FROM r_ProdC) and PCatID in( 204)
SELECT * FROM r_ProdC

insert r_ProdG
	SELECT ChID, PGrID, PGrName, Notes FROM [S-SQL-D4].ElitR.dbo.r_ProdG where PGrID not in (SELECT PGrID FROM r_ProdG) and PGrID in(50011,50121,50034,50051)
SELECT * FROM r_ProdG

insert r_ProdG1
	SELECT ChID, PGrID1, PGrName1, Notes FROM [S-SQL-D4].ElitR.dbo.r_ProdG1 where PGrID1 not in (SELECT PGrID1 FROM r_ProdG1) and PGrID1 in( 708,208,200)
SELECT * FROM r_ProdG1

insert r_ProdG2
	SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdG2 where PGrID2 not in (SELECT PGrID2 FROM r_ProdG2) and PGrID2 in( 40005,40015,40004)
SELECT * FROM r_ProdG2

insert r_ProdG3
	SELECT ChID, PGrID3, PGrName3, Notes FROM [S-SQL-D4].ElitR.dbo.r_ProdG3 where PGrID3 not in (SELECT PGrID3 FROM r_ProdG3) and PGrID3 in( 22,4)
SELECT * FROM r_ProdG3

insert r_prods
	SELECT ChID, ProdID, ProdName, UM, Country, Notes, PCatID, PGrID, Article1, Article2, Article3, Weight, Age, PriceWithTax, Note1, Note2, Note3, MinPriceMC, MaxPriceMC, MinRem, CstDty, CstPrc, CstExc, StdExtraR, StdExtraE, MaxExtra, MinExtra, UseAlts, UseCrts, PGrID1, PGrID2, PGrID3, PGrAID, PBGrID, LExpSet, EExpSet, InRems, IsDecQty, File1, File2, File3, AutoSet, Extra1, Extra2, Extra3, Extra4, Extra5, Norma1, Norma2, Norma3, Norma4, Norma5, RecMinPriceCC, RecMaxPriceCC, RecStdPriceCC, RecRemQty, InStopList, PrepareTime, ScaleGrID, ScaleStandard, ScaleConditions, ScaleComponents, TaxFreeReason, CstProdCode, TaxTypeID, 0 CstDty2, 0 CounID
	 FROM [S-SQL-D4].ElitR.dbo.r_prods 
WHERE ProdID in (SELECT ProdID FROM @ProdIDTable)

SELECT * FROM dbo.r_prods 
WHERE ProdID in (SELECT ProdID FROM @ProdIDTable)


insert r_ProdMP
	SELECT ProdID, PLID, PriceMC, Notes, CurrID, DepID--ProdID, PLID, PriceMC, Notes, CurrID, BDate, EDate, InUse, isnull(PromoPriceCC,0)  
	FROM [S-SQL-D4].ElitR.dbo.r_ProdMP 
	WHERE ProdID in (SELECT ProdID FROM @ProdIDTable) and plid = 34
	
SELECT * FROM dbo.r_ProdMP 
WHERE ProdID in (SELECT ProdID FROM @ProdIDTable) and plid = 34


insert t_PInP
	SELECT ProdID, PPID, PPDesc, PriceMC_In, PriceMC, Priority, ProdDate, CurrID, CompID, Article, CostAC, PPWeight, File1, File2, File3, PriceCC_In, CostCC, PPDelay, ProdPPDate, IsCommission, CstProdCode, CstDocCode, ParentDocCode, ParentChID, PriceAC_In, CostMC
	FROM [S-SQL-D4].ElitR.dbo.t_PInP 
	WHERE ProdID in (SELECT ProdID FROM @ProdIDTable) and ppid = 0
       
SELECT * FROM t_PInP WHERE ProdID in (SELECT ProdID FROM @ProdIDTable) and ppid = 0


insert r_ProdMQ
	SELECT ProdID, UM, Qty, Weight, Notes, BarCode, ProdBarCode, PLID, 0 TareWeight
	FROM [S-SQL-D4].ElitR.dbo.r_ProdMQ 
	WHERE ProdID in (SELECT ProdID FROM @ProdIDTable) and plid = 0
	
SELECT * FROM dbo.r_ProdMQ 
WHERE ProdID in (SELECT ProdID FROM @ProdIDTable)


SELECT * FROM dbo.r_ProdMP where PLID = 34 and PriceMC <> 0

--проверка разных цен в ElitR и [FFood601]
SELECT ProdID, PLID, PriceMC, Notes, CurrID, DepID
, (SELECT PriceMC FROM dbo.r_ProdMp p316 where PLID = 34 and p316.ProdID = p.ProdID)
, 'update r_ProdMp set PriceMC = ' + cast(p.PriceMC as varchar(20)) + ' where ProdID = ' + cast (p.ProdID as varchar(20))  + ' and plid = 34'
FROM [S-SQL-D4].ElitR.dbo.r_ProdMP p where PLID = 34 and inuse = 1 and PriceMC <> 0
and (SELECT PriceMC FROM dbo.r_ProdMp p316 where PLID = 34 and p316.ProdID = p.ProdID) <> p.PriceMC

/*

update r_ProdMp set PriceMC = 545.000000000 where ProdID = 603606 and plid = 34
update r_ProdMp set PriceMC = 647.000000000 where ProdID = 611596 and plid = 34

update r_ProdMp set PriceMC = 550.000000000 where ProdID = 611598 and plid = 34
*/


/*

SELECT * FROM z_Vars where VarName like '%food%'


SELECT top 10 * FROM dbo.r_prods WHERE ProdID in (SELECT ProdID FROM @ProdIDTable)


SELECT top 100 * FROM [S-SQL-D4].ElitR.dbo.r_ProdMP WHERE ProdID in (SELECT ProdID FROM @ProdIDTable) and PLID = 34 ORDER BY 1

SELECT top 100 * FROM dbo.r_ProdMP WHERE ProdID in (SELECT ProdID FROM @ProdIDTable) and PLID = 34 ORDER BY 1



--список групп товаров кофепоинта
SELECT * FROM r_ProdG3 where notes in (SELECT AValue FROM dbo.zf_FilterToTable((SELECT top 1 VarValue FROM z_Vars where VarName like 'Food_CatFilter')))
ORDER BY Priority

SELECT * FROM z_Vars where VarName like 'Food_CatFilter'

SELECT top 1000 PGrID3,* FROM r_Prods WHERE ProdID in (606385,606386,606387,606388,606389,607682,607683,607696,607877,607878,803353,803354) ORDER BY 1 

SELECT top 1000 PGrID3,* FROM [S-SQL-D4].ElitR.dbo.r_Prods WHERE ProdID in (
607696
) ORDER BY 1 


SELECT * FROM r_prods p --and mp.PLID = 34 and mp.InUse = 1
where p.PGrID3 =1 

-- переместить товары в группу кофепоинта
UPDATE  p
SET p.PGrID3 = 2 -- укажите код группы 3
FROM r_Prods p WHERE  p.ProdID in  (
607696
)
*/

ROLLBACK TRAN

/*
--заменить цены в прайслисте
BEGIN TRAN

SELECT * FROM  r_ProdMP where plid = 34 and ProdID in (803176,803178,803180,803179)

delete r_ProdMP where plid = 34 and ProdID in (600362,601217,603583,603744,603752,603766,603777,603778,603796,603802,603809,603810,603811,603816,603828,603829,603839,603840,603842,603845,603847,603848,603850,603853,603857,603874,605327,605781,605787,605789,605791,606385,606386,606387,606388,606389,607087,607132,607133,607135,607136,607137,607203,607205,607682,607683,607696,607877,607878,611078,611596,801135,801136,801317,801318,801438,801663,802121,803353,803354)

insert r_ProdMP (ProdID, PLID, PriceMC, Notes, CurrID, BDate, EDate, InUse, PromoPriceCC)
	SELECT distinct ProdID, PLID, PriceMC, Notes, CurrID, BDate, EDate, InUse, isnull(PromoPriceCC,0) FROM [S-SQL-D4].elitr.dbo.r_ProdMP where plid = 34 and inuse = 1 and ProdID in (600362,601217,603583,603744,603752,603766,603777,603778,603796,603802,603809,603810,603811,603816,603828,603829,603839,603840,603842,603845,603847,603848,603850,603853,603857,603874,605327,605781,605787,605789,605791,606385,606386,606387,606388,606389,607087,607132,607133,607135,607136,607137,607203,607205,607682,607683,607696,607877,607878,611078,611596,801135,801136,801317,801318,801438,801663,802121,803353,803354)
	ORDER BY 1

SELECT * FROM  r_ProdMP where plid = 34 and ProdID in (600362,601217,603583,603744,603752,603766,603777,603778,603796,603802,603809,603810,603811,603816,603828,603829,603839,603840,603842,603845,603847,603848,603850,603853,603857,603874,605327,605781,605787,605789,605791,606385,606386,606387,606388,606389,607087,607132,607133,607135,607136,607137,607203,607205,607682,607683,607696,607877,607878,611078,611596,801135,801136,801317,801318,801438,801663,802121,803353,803354)

ROLLBACK TRAN

*/