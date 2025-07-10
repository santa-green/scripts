/*	
EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'

	IF OBJECT_ID (N'tempdb..#uCat', N'U') IS NOT NULL DROP TABLE #uCat
	SELECT *
	 INTO #uCat
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\EDI\uCat_шаблон.xls' , 'select * from [Выгрузка$]') as ex;

SELECT * FROM #uCat
	*/

SELECT  *,
s1.QuantityOfLayersPerPallet * s1.QuantityOfTradeItemsPerPalletLayer * s1.QuantityOfChild1 * s1.QuantityOfChild2 * s1.QuantityOfChild3 as qty_on_palet
, 'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v01-Количество в ящике'',''' + cast(s1.QuantityOfChild1 * s1.QuantityOfChild2  as varchar) +''',''uCat'');'
, 'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v02-Количество ящиков в слое на паллете 800х1200'',''' + cast(s1.QuantityOfTradeItemsPerPalletLayer  as varchar) +''',''uCat'');'
, 'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v03-Количество слоев на паллете 800х1200'',''' + cast(s1.QuantityOfLayersPerPallet  as varchar) +''',''uCat'');'
, 'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v04-Количество шт на паллете 800х1200'',''' + cast(s1.QuantityOfLayersPerPallet * s1.QuantityOfTradeItemsPerPalletLayer * s1.QuantityOfChild1 * s1.QuantityOfChild2 * s1.QuantityOfChild3  as varchar) +''',''uCat'');'
FROM (
	SELECT u.id id1, u2.id id2,u3.id id3
	,cast(u.QuantityOfChild as int) QuantityOfChild1
	,cast(case when u2.QuantityOfChild <> '' then u2.QuantityOfChild else 1 end as int)  QuantityOfChild2
	,cast(case when u3.QuantityOfChild <> '' then u3.QuantityOfChild else 1 end as int)  QuantityOfChild3
	,cast(u.QuantityOfLayersPerPallet as int) QuantityOfLayersPerPallet ,cast(u.QuantityOfTradeItemsPerPalletLayer as int) QuantityOfTradeItemsPerPalletLayer
	FROM #uCat u
	left JOIN (SELECT * FROM #uCat) u2 on u2.GTIN = u.ChildGTIN and u2.GTIN <> ''
	left JOIN (SELECT * FROM #uCat) u3 on u3.GTIN = u2.ChildGTIN and u3.GTIN <> ''
	where u.UnitDescriptor = 'CASE' 
	and (case when u3.id is null then u2.id else u3.id end) is not null 
	AND (u.QuantityOfLayersPerPallet <> '' OR u.QuantityOfTradeItemsPerPalletLayer <> '')
) s1
JOIN (SELECT distinct ProdID,pp.ProdBarCode FROM t_PInP pp  ) pp2 on pp2.ProdBarCode = (SELECT GTIN FROM #uCat u4 where u4.id = case when id3 is null then id2 else id3 end)
ORDER BY 3,2





IF OBJECT_ID (N'tempdb..#res', N'U') IS NOT NULL DROP TABLE #res
CREATE TABLE #res (barcode varchar(100), name varchar(250), qty_on_palet INT)

DECLARE @ID INT, @qty INT = 1

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT id FROM #uCat WHERE UnitDescriptor = 'CASE'


OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ID
WHILE @@FETCH_STATUS = 0		 
BEGIN

	IF (SELECT ChildGTIN FROM #uCat WHERE id = @ID) != ''
	BEGIN
	    SET @qty = @qty * ((SELECT CASE WHEN CAST(QuantityOfChild AS INT) = 0 THEN 1 ELSE CAST(QuantityOfChild AS INT) END FROM #uCat WHERE id = @ID)*(SELECT CASE WHEN CAST(QuantityOfLayersPerPallet AS INT) = 0 THEN 1 ELSE CAST(QuantityOfLayersPerPallet AS INT) END FROM #uCat WHERE id = @ID)*(SELECT CASE WHEN CAST(QuantityOfTradeItemsPerPalletLayer AS INT) = 0 THEN 1 ELSE CAST(QuantityOfTradeItemsPerPalletLayer AS INT) END FROM #uCat WHERE id = @ID))
		SET @ID = (SELECT m.id FROM #uCat m WHERE m.GTIN = (SELECT ChildGTIN FROM #uCat WHERE id = @ID))
	END;

	ELSE
	BEGIN
		INSERT #res
		VALUES ((SELECT GTIN FROM #uCat WHERE id = @ID), (SELECT DescriptionTextRu FROM #uCat WHERE id = @ID),@qty)
		SET @qty = 1
		FETCH NEXT FROM CURSOR1 INTO @ID
	END;
	
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

SELECT * 
,(SELECT top 1 pp.ProdID FROM t_PInP pp where pp.ProdBarCode = r.barcode ORDER BY PPID desc) ProdBarCode
FROM #res r

SELECT distinct pp.prodid, p.prodname ,r.* FROM #res r
join t_PInP pp on pp.ProdBarCode = r.barcode 
join r_prods p on p.prodid = pp.prodid 
ORDER BY 5

SELECT distinct 'union all select '''+ cast(r.barcode as varchar)+''',' + cast(p.prodid as varchar) +','''+ p.prodname +''','+ cast(r.qty_on_palet as varchar)+',800'  FROM #res r
join t_PInP pp on pp.ProdBarCode = r.barcode 
join r_prods p on p.prodid = pp.prodid 
where r.qty_on_palet > 100


SELECT * FROM #uCat where GTIN in ('3068320063003','3068320113265','3068320063010')
SELECT * FROM #uCat where UnitDescriptor = 'BASE_UNIT_OR_EACH'
SELECT * FROM #uCat where UnitDescriptor = 'PREPACK'

SELECT  GTIN,QuantityOfLayersPerPallet,QuantityOfTradeItemsPerPalletLayer,[BASE_UNIT_OR_EACH],[PREPACK],[CASE]
FROM #uCat
PIVOT (max(ChildGTIN) for UnitDescriptor  IN([BASE_UNIT_OR_EACH],[PREPACK],[CASE]) ) pvt
--where GTIN in ('3068320063003','3068320113265','3068320063010')
where not ([PREPACK] is null and  [CASE] is null)

--where UnitDescriptor = 'CASE'




SELECT * FROM #uCat where UnitDescriptor = 'BASE_UNIT_OR_EACH'

SELECT distinct u.GTIN, u.ChildGTIN,u2.GTIN, u2.ChildGTIN ,u3.GTIN, u3.ChildGTIN,u2.QuantityOfLayersPerPallet, u2.QuantityOfTradeItemsPerPalletLayer ,u3.QuantityOfLayersPerPallet, u3.QuantityOfTradeItemsPerPalletLayer
FROM #uCat u 
CROSS APPLY (SELECT GTIN, ChildGTIN,QuantityOfLayersPerPallet, QuantityOfTradeItemsPerPalletLayer  FROM #uCat u2 where u2.ChildGTIN = u.GTIN and GTIN <> '') u2
CROSS APPLY (SELECT GTIN, ChildGTIN,QuantityOfLayersPerPallet, QuantityOfTradeItemsPerPalletLayer  FROM #uCat u3 where u3.ChildGTIN = u2.GTIN and GTIN <> '') u3
where u.GTIN in ('3068320063003','3068320113265','3068320063010','4823069001520')
where u.UnitDescriptor = 'CASE'
--where u.UnitDescriptor = 'BASE_UNIT_OR_EACH'


SELECT u.id,DescriptionTextRu,u.GTIN, u.ChildGTIN,u.QuantityOfLayersPerPallet, u.QuantityOfTradeItemsPerPalletLayer,u.UnitDescriptor
FROM #uCat u 
where u.UnitDescriptor = 'CASE' and QuantityOfLayersPerPallet <> '' and QuantityOfTradeItemsPerPalletLayer <> ''

SELECT  u2.id,  u3.id,u2.GTIN, u2.ChildGTIN ,u3.GTIN, u3.ChildGTIN FROM #uCat u2,#uCat u3 where u2.ChildGTIN = u3.GTIN and u2.ChildGTIN <> ''  
--and u2.GTIN in ('3068320063003','3068320113265','3068320063010','4823069001520')
and u2.GTIN in ('4823069001520')

SELECT  u2.id,  u3.id,u2.GTIN, u2.ChildGTIN ,u3.GTIN, u3.ChildGTIN 
FROM #uCat u2 where u2.ChildGTIN = u3.GTIN  
and u2.GTIN in ('3068320063003','3068320113265','3068320063010','4823069001520')

3068320063010
3068320113265
3068320063003


SELECT u.id,GTIN,ChildGTIN,QuantityOfLayersPerPallet,QuantityOfTradeItemsPerPalletLayer, 
FROM #uCat u
where u.GTIN in ('3068320063003','3068320113265','3068320063010')

SELECT u.id,u.GTIN,u.ChildGTIN,u2.id, u2.GTIN, u2.ChildGTIN, u3.id, u3.GTIN, u3.ChildGTIN FROM #uCat u
CROSS APPLY (SELECT u2.id, u2.GTIN, u2.ChildGTIN FROM #uCat u2 where u2.GTIN = u.ChildGTIN and u2.GTIN <> '') u2
CROSS APPLY (SELECT u3.id, u3.GTIN, u3.ChildGTIN FROM #uCat u3 where u3.GTIN = u2.ChildGTIN and u3.GTIN <> '') u3
where u.id in (59726)


(SELECT id, GTIN, ChildGTIN FROM #uCat u2 where u2.GTIN = '3068320113265' and u2.GTIN <> '')
(SELECT id, GTIN, ChildGTIN FROM #uCat u2 where u2.GTIN = '3068320063003' and u2.GTIN <> '')
(SELECT id, GTIN, ChildGTIN FROM #uCat u2 where u2.GTIN = '' and u2.GTIN <> '')


SELECT (SELECT GTIN FROM #uCat u4 where u4.id = id_unit) BarCode_unit
, pp2.ProdID
, cast(u.QuantityOfLayersPerPallet as int) * cast(u.QuantityOfTradeItemsPerPalletLayer as int)
--, 'UNION SELECT '+cast(pp2.ProdID as varchar)+',''Количество шт на паллете 800х1200'','+cast(u.QuantityOfLayersPerPallet*u.QuantityOfTradeItemsPerPalletLayer as varchar)+''''
,u.id,DescriptionTextRu,u.GTIN, u.ChildGTIN,u.UnitDescriptor ,u.QuantityOfLayersPerPallet,u.QuantityOfTradeItemsPerPalletLayer 
,s1.*
FROM #uCat u
JOIN (
	SELECT u.id id_case, case when u3.id is null then u2.id else u3.id end id_unit FROM #uCat u
	left JOIN (SELECT * FROM #uCat) u2 on u2.GTIN = u.ChildGTIN and u2.GTIN <> ''
	left JOIN (SELECT * FROM #uCat) u3 on u3.GTIN = u2.ChildGTIN and u3.GTIN <> ''
	where u.UnitDescriptor = 'CASE' and (case when u3.id is null then u2.id else u3.id end) is not null 
) s1 on s1.id_case = u.id
JOIN (SELECT distinct ProdID,pp.ProdBarCode FROM t_PInP pp  ) pp2 on pp2.ProdBarCode = (SELECT GTIN FROM #uCat u4 where u4.id = id_unit)
AND (u.QuantityOfLayersPerPallet <> '' OR u.QuantityOfTradeItemsPerPalletLayer <> '')


--IF 1=0
--BEGIN
--	--таблица исключений РН
--	IF OBJECT_ID (N'tempdb..#ProdsPalet', N'U') IS NOT NULL DROP TABLE #ProdsPalet
--	CREATE TABLE #ProdsPalet (Num INT IDENTITY(1,1) NOT NULL , BarCode varchar(250) null, ProdID INT null, ProdName varchar(250) null, QtyInPalet INT NULL, WidthPalet NUMERIC(21,9))
		
--	INSERT #ProdsPalet
--	--="union all select "&C4&",'"&ТЕКСТ(D4;"ГГГГ-ММ-ДД")&"',"&H4&","&L4&""
--select           null,30766,'Вермут Trino Бьянко 0,5*21 14,8% Design 2013',504,800
--union all select null,30767,'Вермут Trino Бьянко 1*12 14,8% Design 2013',384,800
--union all select null,28246,'Вино Агмарти. Алазанская долина белое, полусладкое 0,75*12',480,1000
--union all select null,28245,'Вино Агмарти. Алазанская долина красное, полусладкое 0,75*12 ',480,1000
--union all select null,30497,'Виски Шотл МакАртурс 40% 0,5*12',768,1000
--union all select null,4165,'Виски Шотл МакАртурс 40% 0,7*12',840,1000
--union all select null,4167,'Виски Шотл МакАртурс 40% 1,0*12',480,1000
--union all select null,26135,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,5*12',1140,1000
--union all select null,26136,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,7*12',768,1000
--union all select null,26137,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,7*12 в коробке',768,1000
--union all select null,26133,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 1,0*12',576,1000
--union all select null,26139,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 1,0*12 в коробке',576,1000
--union all select null,3127,'Вода Эвиан минеральная 1,5*6',504,800
--union all select null,26168,'Вода Эвиан минеральная 0,75*12 в стекле New',780,1000
--union all select null,26213,'Вода Эвиан минеральная 0,33*20 в стекле New',1540,1000
--union all select null,30843,'Вода Эвиан минеральная Спорт 0,75*6 New Design',1080,1000
--union all select null,31878,'Вода Эвиан минеральная 0,33*24 Prestige',3120,1000
--union all select null,31879,'Вода Эвиан минеральная 0,5*24 Prestige',2016,1000
--union all select null,31880,'Вода Эвиан минеральная 1,0*12 Prestige',1008,1000
--union all select null,32143,'Водка Фински 40% 0,7*12',600,800
--union all select null,32142,'Водка Фински 40% 0,5*15',825,800
--union all select null,32144,'Водка Фински 40% 1,0*12',336,800
--union all select null,29873,'Джин Вилмор 37,5% 0,7*6',396,800
--union all select null,33926,'Вино игристое Decordi. Фраголино Россо красное 0,75*6',630,800
--union all select null,34111,'Вино игристое Decordi. Фраголино Розато розовое 0,75*6',630,800
--union all select null,34130,'Вино Lozano. Кабальерос де ла Роса Тинто Семидульче, красное 0,75*6',750,800

----uCat
--union all select '8410310607196',28956,'Вино Vicente Gandia. Органик Вердехо Грейпс 2011 белое 0,75*6',504,800
--union all select '8002235572057',23431,'Вино Zonin. Бардолино Терре Палладиане 2006 красное 0,75*12',630,800
--union all select '3395940520648',31960,'Вино Aujoux. Лис Блан белое сухое 0,75*12',600,800
--union all select '5390683100629',29119,'Ликер Шариc 0,7*6',576,800
--union all select '4860053012636',32363,'Коньяк Агмарти 3 года 40%  0,5*12',720,800
--union all select '3700631902472',34405,'Ром Ботафого Спайсед 40% 0,7*6',576,800
--union all select '8002235020312',22814,'Вино Zonin. Пино Гриджио "Терре Палладиане" 2006 белое 0,75*12',630,800
--union all select '3068320063003',31878,'Вода Эвиан минеральная 0,33*24 Prestige',2160,800
--union all select '4006714004859',29876,'Ром Кана Карибия Спайсед Голд 35% 0,7*6',600,800
--union all select '8002350133874',34583,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави Миная 2017 белое 0,75*12',480,800
--union all select '3357340306215',30627,'Вино Pascal Bouchard. Шабли 2012 белое 0,75*12',480,800
--union all select '3395940520686',31958,'Вино Aujoux. Лис Руж красное сухое 0,75*12',600,800
--union all select '5010509414081',23355,'Виски Шотл Ханки Баннистер бленд 40% New Design 1,0*12 в коробке',384,800
--union all select '4820073560739',26697,'Коньяк Шато де Луи VS 0,5*6 в коробке',576,800
--union all select '8710625527203',4140,'Ликер Де Кайпер Трипл Сек (апельсин) 40 % 0,7*6',570,800
--union all select '8002095200046',4755,'Ликер Самбука Молинари Экстра 0,75*12 + кофейное зерно',576,800
--union all select '8002235572057',33962,'Вино Zonin. Бардолино 2016 красное 0,75*6',630,800
--union all select '4860053012643',28573,'Коньяк Агмарти 5 лет 40% 0,5*12',720,800
--union all select '3068320103631',26213,'Вода Эвиан минеральная 0,33*20 в стекле New',800,800
--union all select '8710625527203',34791,'Ликер Де Кайпер Трипл Сек (апельсин) 40 % 0,7*6 Essentials ',570,800
--union all select '3014220909118',27499,'Вино Guy Saget. Вувре 2010 белое 0,75*12',480,800
--union all select '5010509001229',34357,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,7*12 в коробке',576,800
--union all select '3068320103631',31874,'Вода Эвиан минеральная 0,33*20 в стекле АКЦИЯ',800,800
--union all select '8002235011310',22812,'Вино T.Савolani. Токай Фриулано Фриули Акилеа DOC 2006 белое 0,75*6',504,800
--union all select '8002235662055',23172,'Вино Zonin. Соаве "Терре Палладиане" 2006 белое 0,75*12',630,800
--union all select '8002235662055',34316,'Вино Zonin. Соаве 2017 белое 0,75*6',630,800
--union all select '4823069001216',31779,'Вино Чинчорро Каберне красное сухое 0,75*12',480,800
--union all select '7804414000655',24558,'Вино Luis Felipe Edwards. Шардоне Пупилла 2009 белое 0,75*12',480,800
--union all select '5010509415705',26135,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,5*12',900,800
--union all select '3550142055460',2204,'Коньяк Шато Монтифо VSОР Файн Пти Шампань 40% Жарнак 0,5*12',576,800
--union all select '8410310606892',34003,'Вино Vicente Gandia. Раица Крианца 2015 красное 0,75*6',504,800
--union all select '5010509003087',4167,'Виски Шотл МакАртурс 40% 1,0*12',480,800
--union all select '8002235216050',22695,'Вино T. Ca* Vescovo. Рислинг Фриули Акилеа 2006, полусухое белое 0,75*6',630,800
--union all select '8410310606977',31938,'Вино Vicente Gandia. Небла 2014 белое 0,75*6',504,800
--union all select '3550142025463',4903,'Коньяк Шато Монтифо VS Файн Пти Шампань 40% Жарнак 0,5*12 в тубусе',576,800
--union all select '8002350133874',29114,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави Миная 2011 белое  0,75*12',480,800
--union all select '4820139240261',34076,'Водка Дистил №9 1,0*6',396,800
--union all select '8410310606977',27392,'Вино Vicente Gandia. Небла 2010 белое 0,75*6',504,800
--union all select '8002235395953',31007,'Вино Zonin. Каберне Вино Варьетале 2012 красное 0,75*6',630,800
--union all select '8410310606977',29086,'Вино Vicente Gandia. Небла 2011 белое 0,75*6',504,800
--union all select '8002235692052',27039,'Вино Zonin. Вальполичелла  2010 красное 0,75*6',600,800
--union all select '5014218794557',32192,'Виски Douglas Laing. Рок Ойстер Бленд 46,8% 0,7*6 в подарочной упаковке',600,800
--union all select '8410310606977',32035,'Вино Vicente Gandia. Небла 2015 белое 0,75*6',504,800
--union all select '8002235572057',27037,'Вино Zonin. Бардолино 2010, красное 0,75*6',630,800
--union all select '8002235022323',24915,'Вино Zonin. Къянти 2007 красное 0,75*6',630,800
--union all select '4905846960050',32414,'Вино Чоя Сильвер 0,5*6',600,800
--union all select '5010509415439',4298,'Виски Шотл Ханки Баннистер бленд 40% New Design 0,2*24',1680,800
--union all select '5010509414081',4639,'Виски Шотл Ханки Баннистер бленд 40% New Design 1,0*12',384,800
--union all select '5010509414081',26139,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 1,0*12 с коробкой в наборе',384,800
--union all select '4062400543125',34678,'Текила Сиерра Репосадо 38% 0,7*6 + солонка',576,800
--union all select '4820024226301',4668,'Вермут Trino Бьянко 1*12 14,8% (плоская)',384,800
--union all select '8410310607196',34004,'Вино Vicente Gandia. Органик Вердехо 2016 белое 0,75*6',504,800
--union all select '8008820158354',33927,'Вино игристое Decordi. Фраголино Бьянко белое 0,75*6',504,800
--union all select '8410310607110',33691,'Вино Vicente Gandia. Органик Темпранильо 2016 красное 0,75*6',504,800
--union all select '3550142027344',4353,'Коньяк Шато Монтифо VS Файн Пти Шампань 40% 0,7*6 в тубусе',384,800
--union all select '8427894007632',34111,'Вино Lozano. Кабальерос де ла Роса Тинто Семидульче, красное 0,75*6',480,800
--union all select '7804414001027',28368,'Вино Luis Felipe Edwards. Шираз Каберне Совиньон Розе 2011 розовое 0,75*12',480,800
--union all select '7804414000655',23198,'Вино Luis Felipe Edwards. Шардоне Пупилла 2007 белое 0,75*12',480,800
--union all select '8002350133881',27045,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави 2010 белое  0,75*12',480,800
--union all select '5390683100636',34048,'Ликер Шарис New Design 1,0*12',360,800
--union all select '3014220909101',30400,'Вино Guy Saget. Роз д*Анжу 2012 розовое 0,75*12',480,800
--union all select '3014220909118',26860,'Вино Guy Saget. Вувре 2009  белое 0,75*12',480,800
--union all select '5391524710656',32316,'Виски Вест Корк Ориджинал Ирландия 40% 0,7*6',600,800
--union all select '7804414000655',23586,'Вино Luis Felipe Edwards. Шардоне Пупилла 2008 белое 0,75*12',480,800
--union all select '8002235692052',23289,'Вино Zonin. Вальполичелла "Терре Палладиане" 2006 красное 0,75*12',600,800
--union all select '8002235020312',25768,'Вино Zonin. Пино Гриджио  2009 белое 0,75*6',630,800
--union all select '8002235662055',33023,'Вино Zonin. Соаве 2016 белое 0,75*6',630,800
--union all select '4860053012650',28574,'Коньяк Агмарти КВВК 8 лет 40% 0,5*12',720,800
--union all select '4062400311083',4717,'Джин Финсбари 37,5% 1*6',360,800
--union all select '4860053012636',28572,'Коньяк Агмарти 3 года 40% 0,5*12',720,800
--union all select '8002235020312',23357,'Вино Zonin. Пино Гриджио "Терре Палладиане" 2007 белое 0,75*12',630,800
--union all select '8002235020312',32445,'Вино Zonin. Пино Гриджио делле Венеция 2015 белое 0,75*6',630,800
--union all select '8002235020312',34315,'Вино Zonin. Пино Гриджио Делле Венеция 2017 белое 0,75*6',630,800
--union all select '3068320063003',33990,'Вода Эвиан минеральная 0,33*24 Chiara Limited',2160,800
--union all select '7804350004540',30726,'Вино Santa Carolina. Премио Семисвит 2013 белое полусладкое 0,75*12',480,800
--union all select '4062400115483',31974,'Текила Сиерра Сильвер 38%  0,7*6 + рюмка',576,800
--union all select '8002235022811',30735,'Вино Zonin. Шардоне Вино Варьетале 2012 белое 0,75*6',630,800
--union all select '8002235662055',23290,'Вино Zonin. Соаве "Терре Палладиане" 2007 белое 0,75*12',630,800
--union all select '5011166056508',34624,'Джин Уитли Нейлл Рубаб энд Джинжер 43% 0,7*6',480,800
--union all select '3068320055008',31879,'Вода Эвиан минеральная 0,5*24 Prestige',1296,800
--union all select '8002350133881',29113,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави 2011 белое  0,75*12',480,800
--union all select '8002235022323',25767,'Вино Zonin. Къянти 2008 красное 0,75*6',630,800
--union all select '8002235022811',34317,'Вино Zonin. Шардоне Вино Варьетале 2017 белое 0,75*6',630,800
--union all select '8002350133874',30406,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави Миная 2012 белое  0,75*12',480,800
--union all select '4823069000554',31809,'Вино Кастелло Дель Соль Столовое красное полусладкое 0,75*12',480,800
--union all select '4823069000561',31776,'Вино Кастелло Дель Соль Шардоне белое сухое 0,75*12',480,800
--union all select '8427894007045',23776,'Вино Lozano. Лозано, красное 0,75*12',480,800
--union all select '8002235216050',31277,'Вино T.Cabolani. Пино Гриджио Фриули Акилеа DOC 2013 белое 0,75*6',630,800
--union all select '8028936007001',27487,'Вино Villa Gritti. Валполичела 2010 красное 0,75*12',480,800
--union all select '4823069000547',31777,'Вино Кастелло Дель Соль Каберне красное сухое 0,75*12',480,800
--union all select '5010509414081',4162,'Виски Шотл Ханки Баннистер бленд 40% 1,0*12',384,800
--union all select '8427894007038',24549,'Вино Lozano. Лозано, белое 0,75*12',480,800
--union all select '7804414000655',26673,'Вино Luis Felipe Edwards. Шардоне Пупилла 2010 белое 0,75*12',480,800
--union all select '8410310607110',32033,'Вино Vicente Gandia. Органик Темпранильо 2014 красное 0,75*6',504,800
--union all select '8002235692052',31280,'Вино Zonin. Вальполичелла 2012 красное 0,75*6',600,800
--union all select '4006714004798',29879,'Виски Олд Роад 3 года 40% 0,7*6',756,800
--union all select '6438052555553',34815,'Водка Фински 40% 0,5*15 в наборе с рюмкой',825,800
--union all select '8410310607110',31390,'Вино Vicente Gandia. Органик Темпранильо 2013 красное 0,75*6',504,800
--union all select '8410310607110',32602,'Вино Vicente Gandia. Органик Темпранильо 2015 красное 0,75*6',504,800
--union all select '3181250000402',4525,'Кальвадос Пер Маглуар VSOP  0,5*12',720,800
--union all select '7804414001027',30917,'Вино Luis Felipe Edwards. Шираз Каберне Совиньон Розе 2013 розовое 0,75*12',480,800
--union all select '8028936008336',30461,'Вино Villa Gritti. Кьянти 2012 красное 0,75*12',480,800
--union all select '8002235022323',26871,'Вино Zonin. Къянти 2010 красное 0,75*6',630,800
--union all select '8410310607110',30702,'Вино Vicente Gandia. Органик Темпранильо 2012 красное 0,75*6',504,800
--union all select '8002235572057',30382,'Вино Zonin. Бардолино 2011 красное 0,75*6',630,800
--union all select '8028936007001',31486,'Вино Villa Gritti. Валполичела 2013 красное 0,75*12',480,800
--union all select '4062400115483',33718,'Текила Сиерра Сильвер 38%  0,7*6 + солонка',576,800
--union all select '8002235020312',24257,'Вино Zonin. Пино Гриджио  2008 белое 0,75*6',630,800
--union all select '8002235662055',24255,'Вино Zonin. Соаве  2008 белое 0,75*6',630,800
--union all select '8028936008336',31101,'Вино Villa Gritti. Кьянти 2013 красное 0,75*12',480,800
--union all select '8028936008336',31884,'Вино Villa Gritti. Кьянти 2014 красное 0,75*12',480,800
--union all select '627843480358',33539,'Водка Канадская 40% 0,5*12',384,800
--union all select '3068320080000',31880,'Вода Эвиан минеральная 1,0*12 Prestige',720,800
--union all select '8410310606977',33723,'Вино Vicente Gandia. Небла 2016 белое 0,75*6',504,800
--union all select '8002235216050',31799,'Вино T.Cabolani. Пино Гриджио Фриули Акилеа DOC 2014 белое 0,75*6',630,800
--union all select '8002235216050',32344,'Вино T.Cabolani. Пино Гриджио Фриули Акилеа DOC 2015 белое 0,75*6',630,800
--union all select '8002095200046',4737,'Набор Самбука Молинари Экстра ликер  0,75 + Самбука Молинари Кафе ликер 0,03   *12',576,800
--union all select '8028936008336',26201,'Вино Villa Gritti. Кьянти 2009 красное 0,75*12',480,800
--union all select '4820139240056',33534,'Водка Старицкий Левицкий 1,0*12',324,800
--union all select '7804350004540',29305,'Вино Santa Carolina. Премио Семисвит 2012 белое, полусладкое 0,75*12',480,800
--union all select '8002235692052',25208,'Вино Zonin. Вальполичелла  2008 красное 0,75*6',600,800
--union all select '8002235662055',25766,'Вино Zonin. Соаве 2008 белое 0,75*6',630,800
--union all select '4062400311700',4622,'Джин Финсбари Платинум 47% 0,7*6 + стакан в коробке',486,800
--union all select '5010509427067',4149,'Виски Шотл А Нок 12 лет 40% 0,7*6 в тубусе',456,800
--union all select '8002235216050',34171,'Вино T.Cabolani. Пино Гриджио Фриули Акилеа 2017 белое 0,75*6',630,800
--union all select '5010509415439',26134,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,2*24',1680,800
--union all select '5010509414081',24571,'Виски Шотл Ханки Баннистер бленд 43% New Design 1,0*12',384,800
--union all select '8002235395953',25945,'Вино Zonin. Каберне делле Венеция 2009 красное 0,75*6',630,800
--union all select '8713427000073',25944,'Ликер Де Кайпер Пина Колада (кокосово-ананасовый) 14,5 % 0,7*6 New Design',750,800
--union all select '8002235216050',33295,'Вино T.Cabolani. Пино Гриджио Фриули Акилеа 2016 белое 0,75*6',630,800
--union all select '8002235011310',30825,'Вино T.Cabolani. Фриулано Фриули Акилея DOC 2012 белое 0,75*6',504,800
--union all select '4867601703367',28241,'Вино Агмарти. Саперави красное, сухое 0,75*12 (АО Корпорация Киндзмараули)',480,800
--union all select '8002235692052',30732,'Вино Zonin. Вальполичелла  2011 красное 0,75*6',600,800
--union all select '8006315900136',29054,'Вино игристое Trino Асти белое 0,75*6',456,800
--union all select '8028936008336',31337,'Вино Fattoria Scaligera. Кьянти 2013 красное 0,75*12',480,800
--union all select '8002235020312',31804,'Вино Zonin. Пино Гриджио делле Венеция 2014 белое 0,75*6',630,800
--union all select '8002235662055',32346,'Вино Zonin. Соаве 2015 белое 0,75*6',630,800
--union all select '4820024226516',30766,'Вермут Trino Бьянко 0,5*21 14,8% Design 2013',630,800
--union all select '8002235572057',22563,'Вино Zonin. Бардолино 2005 красное 0,75*12',630,800
--union all select '8002235692052',34606,'Вино Zonin. Вальполичелла 2017 красное 0,75*6',600,800
--union all select '4867601703398',28246,'Вино Агмарти. Алазанская долина белое, полусладкое 0,75*12 (АО Корпорация Киндзмараули)',480,800
--union all select '4820139240018',30689,'Водка Старицкий Левицкий 0,7*6',504,800
--union all select '4062400311601',20222,'Джин Финсбари Платинум 47% 1,0*6',360,800
--union all select '4006714004897',29872,'Ликер Манзони Самбука 38% 0,7*6',600,800
--union all select '4820024226301',30767,'Вермут Trino Бьянко 1*12 14,8% Design 2013',384,800
--union all select '4062400111218',30728,'Джин Финсбари 37,5% 0,7*6 New Design',600,800
--union all select '7804350004533',27575,'Вино Santa Carolina. Премио Семисвит 2011 красное, полусладкое 0,75*12',480,800
--union all select '8410310606892',32037,'Вино Vicente Gandia. Раица Крианца 2013 красное 0,75*6',504,800
--union all select '8002235395953',30383,'Вино Zonin. Каберне Вино Варьетале 2011 красное 0,75*6',630,800
--union all select '5010509414104',23135,'Виски Шотл Ханки Баннистер бленд 40% New Design 0,35*24',1152,800
--union all select '4062400111218',4621,'Джин Финсбари 37,5% 0,7*6 + стакан в коробке',600,800
--union all select '8710625524707',4141,'Ликер Де Кайпер Пич Три (персик прозрачный) 20 % 0,7*6',480,800
--union all select '8002095736606',27052,'Ликер Самбука Молинари Кафе 36% 0,7*6',528,800
--union all select '8002235011310',33953,'Вино T.Cabolani. Фриулано Фриули Акилея DOC 2016 белое 0,75*6',504,800
--union all select '4062400311601',24664,'Джин Финсбари Платинум 47% 1,0*6 New Design',360,800
--union all select '4905846114859',33848,'Ликер Чоя Умешу Экстра Шизо 17% 0,7*6',600,800
--union all select '3550142055460',4355,'Коньяк Шато Монтифо VSОР Файн Пти Шампань 40% Жарнак 0,5*12 в тубусе',576,800
--union all select '7804350004533',29304,'Вино Santa Carolina. Премио Семисвит 2012 красное, полусладкое 0,75*12',480,800
--union all select '8002235022811',31361,'Вино Zonin. Шардоне Вино Варьетале 2013 белое 0,75*6',630,800
--union all select '5010509001229',4161,'Виски Шотл Ханки Баннистер бленд 40% 0,7*12 в коробке',576,800
--union all select '6438052555775',32144,'Водка Фински 40% 1,0*12',480,800
--union all select '5011166054795',34336,'Джин Уитли Нейлл Квинс 43% 0,7*6',480,800
--union all select '8002350133881',30405,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави 2012 белое  0,75*12',480,800
--union all select '8002235022323',32443,'Вино Zonin. Къянти 2015 красное 0,75*6',630,800
--union all select '3068320085005',3127,'Вода Эвиан минеральная 1,5*6',504,800
--union all select '4820073560739',27592,'Коньяк Образец под Шато де Луи VS 0,5*6 в коробке',576,800
--union all select '8002350133874',32713,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави Миная 2015 белое 0,75*12',480,800
--union all select '8002235692052',32446,'Вино Zonin. Вальполичелла 2015 красное 0,75*6',600,800
--union all select '8002235395953',33684,'Вино Zonin. Каберне Вино Варьетале 2015 красное 0,75*6',630,800
--union all select '4905846114811',33847,'Ликер Чоя Умешу Экстра Еарс 17% 0,7*6',600,800
--union all select '3014220909101',31110,'Вино Guy Saget. Роз д*Анжу 2013 розовое 0,75*12',480,800
--union all select '5010509800648',30497,'Виски Шотл МакАртурс 40% 0,5*12',768,800
--union all select '8710625524707',24235,'Ликер Де Кайпер Пич Три (персик прозрачный) 20 % 0,7*6 New Design',480,800
--union all select '7804414001027',30353,'Вино Luis Felipe Edwards. Шираз Каберне Совиньон Розе 2012 розовое 0,75*12',480,800
--union all select '8002235216050',28979,'Вино T.Cabolani. Пино Гриджио Фриули Акилея 2011 белое 0,75*6',630,800
--union all select '8002235022323',22821,'Вино Zonin. Къянти "Терре Палладиане" 2005 красное 0,75*12',630,800
--union all select '4823069000547',34388,'Вино Кастелло Соул Каберне Совиньон Вайнери Спешиал красное сухое 0,75*12',480,800
--union all select '4820139240056',30691,'Водка Старицкий Левицкий 1,0*6',324,800
--union all select '8002235572057',32699,'Вино Zonin. Бардолино 2015 красное 0,75*6',630,800
--union all select '3068320080000',32256,'Вода Эвиан минеральная 1,0*6 Prestige',720,800
--union all select '4062400111218',4718,'Джин Финсбари 37,5% 0,7*6',600,800
--union all select '8006315900136',32021,'Набор ЗДИВУЙСЯ (Вино игристое Trino Асти белое 1бут.*0,75 + Вермут Trino Бьянко 2бут.*0,5)*3',456,800
--union all select '8710625500305',4144,'Ликер Де Кайпер Адвокат (яичный) 14,8 % 0,7*6',750,800
--union all select '8410310606892',31829,'Вино Vicente Gandia. Раица Крианца 2012 красное 0,75*6',504,800
--union all select '8713427000073',4986,'Ликер Де Кайпер Пина Колада (кокосово-ананасовый) 14,5 % 0,7*6 + конфеты',750,800
--union all select '8002350133874',33917,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави Миная 2016 белое 0,75*12',480,800
--union all select '7804350004533',30987,'Вино Santa Carolina. Премио Семисвит 2013 красное полусладкое 0,75*12',480,800
--union all select '3014220909118',30878,'Вино Guy Saget. Вувре 2012 белое 0,75*12',480,800
--union all select '3068320055008',32880,'Вода Эвиан минеральная 0,5*24 Lacroix',1296,800
--union all select '8002235662055',31923,'Вино Zonin. Соаве 2014 белое 0,75*6',630,800
--union all select '3068320103389',34032,'Вода Эвиан минеральная 0,75*12 в стекле АКЦИЯ',432,800
--union all select '4062400311700',24412,'Джин Финсбари Платинум 47% 0,7*6 New Design',486,800
--union all select '4867601703343',28244,'Вино Агмарти. Цинандали белое, сухое 0,75*12 (АО Корпорация Киндзмараули)',480,800
--union all select '8002235662055',26088,'Вино Zonin. Соаве 2009 белое 0,75*6',630,800
--union all select '5010509003001',30990,'Набор подарочный (Шотл. Виски МакАртурс 0,7+ Энергетический напиток Fashion F88 0,25)*12',720,800
--union all select '4062400543125',32615,'Текила Сиерра Репосадо 38% 0,7*6 + рюмка',576,800
--union all select '8410310613432',31794,'Вино Vicente Gandia. Лирико белое 0,75*6',600,800
--union all select '8002235022323',26089,'Вино Zonin. Къянти 2009 красное 0,75*6',630,800
--union all select '6438052555553',32142,'Водка Фински 40% 0,5*15',825,800
--union all select '8710625640704',4136,'Ликер Де Кайпер Кюрасао Блю (апельсин голуб) 24 % 0,7*6',570,800
--union all select '7804414000655',27459,'Вино Luis Felipe Edwards. Шардоне Пупилла 2011 белое 0,75*12',480,800
--union all select '8002235692052',31922,'Вино Zonin. Вальполичелла 2014 красное 0,75*6',600,800
--union all select '4867601703398',34487,'Вино Агмарти. Алазанская долина белое, полусладкое 0,75*6 (АО Корпорация Киндзмараули)',480,800
--union all select '8002235572057',23601,'Вино Zonin. Бардолино Терре Палладиане 2007 красное 0,75*12',630,800
--union all select '8002235216050',24914,'Вино T.Cabolani. Пино Гриджио Фриули Акилеа 2008 белое 0,75*6',630,800
--union all select '8410310607196',31389,'Вино Vicente Gandia. Органик Вердехо 2013 белое 0,75*6',504,800
--union all select '4823069001209',34387,'Вино Чинчорро Шардоне Вайнери Спешиал белое сухое 0,75*12',480,800
--union all select '5010509414081',26133,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 1,0*12',384,800
--union all select '8028936007001',30717,'Вино Villa Gritti. Валполичела 2012 красное 0,75*12',480,800
--union all select '4006714004781',29875,'Ром Кана Карибия Блек 38% 0,7*6',600,800
--union all select '8002235022811',32442,'Вино Zonin. Шардоне Вино Варьетале 2015 белое 0,75*6',630,800
--union all select '8427894007656',23775,'Вино Lozano. Кабальерос де ла Роса Бланко Семидульче, белое 0,75*12',480,800
--union all select '4867601703381',34329,'Вино Агмарти. Алазанская долина красное, полусладкое 0,75*6 (АО Корпорация Киндзмараули)',480,800
--union all select '3357340306215',27725,'Вино Pascal Bouchard. Шабли 2010 белое 0,75*12',480,800
--union all select '8002235022323',33296,'Вино Zonin. Къянти 2016 красное 0,75*6',630,800
--union all select '8002235020312',30561,'Вино Zonin. Пино Гриджио делле Венеция 2012 белое 0,75*6',630,800
--union all select '3014220909101',26859,'Вино Guy Saget. Роз д*Анжу 2010 розовое 0,75*12',480,800
--union all select '8002235572057',3366,'Вино Zonin. Бардолино Kлассико DOC 2002 красное 0,75*6',630,800
--union all select '5010509003001',4165,'Виски Шотл МакАртурс 40% 0,7*12',720,800
--union all select '7804414001027',32576,'Вино Luis Felipe Edwards. Шираз Каберне Совиньон Розе 2015 розовое 0,75*12',480,800
--union all select '4823069001520',31846,'Вино Tамрико Каха Глобал Вайн Алазанская долина красное полусладкое 0,75*12',480,800
--union all select '4823069000554',34390,'Вино Кастелло Соул Вайнери Спешиал красное полусладкое 0,75*12',480,800
--union all select '4867601703367',34616,'Вино Агмарти. Саперави красное, сухое 0,75*6 (АО Корпорация Киндзмараули)',480,800
--union all select '5011166057093',34335,'Джин Уитли Нейлл Блэд Оранж 43% 0,7*6',480,800
--union all select '5014218776256',31978,'Виски Douglas Laing. Биг Пит Бленд 46% 0,7*6 в тубусе ',600,800
--union all select '8002235662055',28268,'Вино Zonin. Соаве 2011 белое 0,75*6',630,800
--union all select '4823069000578',31808,'Вино Кастелло Дель Соль Москато белое полусладкое 0,75*12',480,800
--union all select '3068320063003',2999,'Вода Эвиан минеральная 0,33*24',2160,800
--union all select '3700631997720',34403,'Ром Ботафого Вайт  40% 0,7*6',576,800
--union all select '8028936007001',26204,'Вино Villa Gritti. Валполичела 2009 красное 0,75*12',480,800
--union all select '5010509001229',4829,'Виски Шотл Ханки Баннистер бленд 40% 0,7*1 в тубусе',576,800
--union all select '4006714004866',29877,'Ликер Кана Карибия Мохито 15% 0,7*6',600,800
--union all select '8002235020312',33300,'Вино Zonin. Пино Гриджио делле Венеция 2016 белое 0,75*6',630,800
--union all select '3068320055008',3101,'Вода Эвиан минеральная 0,5*24',1296,800
--union all select '8002235011310',3552,'Вино T.Савolani. Токай Фриулано Акилеа Фриули DOC 2003, белое  0,75*6',504,800
--union all select '5391524710663',32317,'Виски Вест Корк Ориджинал Ирландия 10 лет односолодовый 40% 0,7*6',600,800
--union all select '7804350004540',31395,'Вино Santa Carolina. Премио Семисвит 2014 белое полусладкое 0,75*12',480,800
--union all select '8410310606892',31393,'Вино Vicente Gandia. Раица Крианца 2010 красное 0,75*6',504,800
--union all select '4603928000969',30900,'Водка Белуга Нобл 0,5*12',576,800
--union all select '4860053012643',32364,'Коньяк Агмарти 5 лет 40%  0,5*12',720,800
--union all select '8410310607196',32549,'Вино Vicente Gandia. Органик Вердехо 2015 белое 0,75*6',504,800
--union all select '4006714004934',29878,'Виски Олд Роад 6 лет 40% 0,7*6',756,800
--union all select '4603928000983',31623,'Водка Белуга Нобл 1,0*12',384,800
--union all select '8002235011310',21984,'Вино T.Савolani. Токай Фриулано Фриули Акилеа DOC 2005 белое  0,75*6',504,800
--union all select '4867601703381',28245,'Вино Агмарти. Алазанская долина красное, полусладкое 0,75*12 (АО Корпорация Киндзмараули)',480,800
--union all select '627843480365',33541,'Водка Канадская 40% 1,0*12',384,800
--union all select '4820139240070',30690,'Водка Старицкий Левицкий 0,7*6 в коробке',324,800
--union all select '8410310615771',33778,'Вино Vicente Gandia. Эль Пескаито Блу голубое 0,75*6',600,800
--union all select '8002350133874',31270,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави Миная 2013 белое  0,75*12',480,800
--union all select '4062400543002',3248,'Текила Сиерра Репосадо 38% 1,0*6',384,800
--union all select '3357340306215',26347,'Вино Pascal Bouchard. Шабли 2009 белое 12,5%  0,75*6',480,800
--union all select '4867601703374',34327,'Вино Агмарти. Киндзмараули красное, полусладкое 0,75*6 (АО Корпорация Киндзмараули)',480,800
--union all select '3550142637970',31896,'Коньяк Шато Монтифо VSОР Премиум 40% Дива 0,7*6 в коробке',450,800
--union all select '4062400115483',4696,'Текила Сиерра Сильвер 38%  0,7*12',576,800
--union all select '8002235395953',31412,'Вино Zonin. Каберне Вино Варьетале 2013 красное 0,75*6',630,800
--union all select '8002350133881',32467,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави 2015 белое 0,75*12',480,800
--union all select '8002235011310',32440,'Вино T.Cabolani. Фриулано Фриули Акилея DOC 2015 белое 0,75*6',504,800
--union all select '8410310606977',31391,'Вино Vicente Gandia. Небла 2013 белое 0,75*6',504,800
--union all select '4823069001209',31780,'Вино Чинчорро Шардоне белое сухое 0,75*12',480,800
--union all select '8002235020312',26872,'Вино Zonin. Пино Гриджио делле Венеция 2010 белое 0,75*6',630,800
--union all select '8002235020312',28267,'Вино Zonin. Пино Гриджио делле Венеция 2011 белое 0,75*6',630,800
--union all select '8002235022811',31761,'Вино Zonin. Шардоне Вино Варьетале 2014 белое 0,75*6',630,800
--union all select '8004499750011',34366,'Ликер Caffo. Веккьо Амаро дель Капо 35% 0,7*8',576,800
--union all select '8002350133874',31964,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави Миная 2014 белое 0,75*12',480,800
--union all select '3357340306215',29184,'Вино Pascal Bouchard. Шабли 2011 белое 0,75*12',480,800
--union all select '3068320103389',24023,'Вода Эвиан минеральная 0,75*12 в стекле',432,800
--union all select '8002350133881',33422,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави 2016 белое 0,75*12',480,800
--union all select '3357340306215',25948,'Вино Pascal Bouchard. Шабли 2009 белое 0,75*6',480,800
--union all select '8710521444703',4143,'Ликер Де Кайпер Кантри Лейн Крем 17 % 0,7*6',480,800
--union all select '3357340306215',31757,'Вино Pascal Bouchard. Шабли 2014 белое 0,75*12',480,800
--union all select '6438052555560',32143,'Водка Фински 40% 0,7*12',720,800
--union all select '3550142055460',34683,'Коньяк Шато Монтифо VSОР Файн Пти Шампань 40% Ариана 0,5*12 в тубусе',576,800
--union all select '4062400543125',4697,'Текила Сиерра Репосадо 38% 0,7*12',576,800
--union all select '4062400542074',4695,'Текила Сиерра Сильвер 38%  1,0*12',384,800
--union all select '3068320085005',34726,'Вода Эвиан минеральная 1,5*6 Magnum',504,800
--union all select '7804414000655',31927,'Вино Luis Felipe Edwards. Шардоне 2015 белое 0,75*12',480,800
--union all select '3357340306215',31366,'Вино Pascal Bouchard. Шабли 2013 белое 0,75*12',480,800
--union all select '8002235692052',31760,'Вино Zonin. Вальполичелла 2013 красное 0,75*6',600,800
--union all select '5010509414104',1204,'Виски Шотл Ханки Баннистер бленд 40% 0,35*24',1152,800
--union all select '4820139240025',30688,'Водка Старицкий Левицкий 0,5*12',720,800
--union all select '8410310613418',31795,'Вино Vicente Gandia. Лирико красное 0,75*6',600,800
--union all select '4017871800031',32409,'Саке Чоя 0,75*6',600,800
--union all select '7804414000655',29056,'Вино Luis Felipe Edwards. Шардоне 2012 белое 0,75*12',480,800
--union all select '8002235011310',31359,'Вино T.Cabolani. Фриулано Фриули Акилея DOC 2013 белое 0,75*6',504,800
--union all select '8002235572057',31279,'Вино Zonin. Бардолино 2013 красное 0,75*6',630,800
--union all select '8002235395953',31802,'Вино Zonin. Каберне Вино Варьетале 2014 красное 0,75*6',630,800
--union all select '8028936008336',29154,'Вино Villa Gritti. Кьянти 2011 красное 0,75*12',480,800
--union all select '5011166055709',32318,'Виски Погис Ирландия 40% 0,7*6',600,800
--union all select '4006714004927',29881,'Ликер Альтер Герцог 30% 0,7*6',720,800
--union all select '3068320063003',31872,'Вода Эвиан минеральная 0,33*24 АКЦИЯ',2160,800
--union all select '8002235216050',26866,'Вино T.Cabolani. Пино Гриджио Фриули Акилея 2010 белое 0,75*6',630,800
--union all select '5010509415705',23126,'Виски Шотл Ханки Баннистер бленд 40% New Design 0,5*12',900,800
--union all select '8410310606892',30701,'Вино Vicente Gandia. Раица Крианца 2009 красное 0,75*6',504,800
--union all select '8002235572057',26091,'Вино Zonin. Бардолино 2009 красное 0,75*6',630,800
--union all select '8008820158804',34130,'Вино игристое Decordi. Фраголино Розато розовое 0,75*6',504,800
--union all select '4823069001537',31845,'Вино Tамрико Каха Глобал Вайн Алазанская долина белое полусладкое 0,75*12',480,800
--union all select '8002235662055',27038,'Вино Zonin. Соаве 2010 белое 0,75*6',630,800
--union all select '4006714004941',29880,'Виски Мост Вонтед Кентуки 40% 0,7*6',720,800
--union all select '4820024226301',26696,'Вермут Trino Бьянко 1*12 в коробке + зеркальце',384,800
--union all select '3068320080000',3124,'Вода Эвиан минеральная 1,0*6 в паках',720,800
--union all select '7804414000655',33486,'Вино Luis Felipe Edwards. Шардоне 2017 белое 0,75*12',480,800
--union all select '4823069000561',34391,'Вино Кастелло Соул Шардоне Вайнери Спешиал белое сухое 0,75*12',480,800
--union all select '7804414000655',30916,'Вино Luis Felipe Edwards. Шардоне 2013 белое 0,75*12',480,800
--union all select '8002235216050',30559,'Вино T.Cabolani. Пино Гриджио Фриули Акилея 2012 белое 0,75*6',630,800
--union all select '3068320103389',26168,'Вода Эвиан минеральная 0,75*12 в стекле New',432,800
--union all select '3068320085005',32531,'Вода Эвиан минеральная 1,5*6 АКЦИЯ ',504,800
--union all select '4820024226516',4669,'Вермут Trino бьянко 0,5*21 14,8% (плоская)',630,800
--union all select '7804350004540',27576,'Вино Santa Carolina. Премио Семисвит 2011 белое, полусладкое 11,5%  0,75*12',480,800
--union all select '4062400311700',21398,'Джин Финсбари Платинум 47% 0,7*6',486,800
--union all select '8410310606977',34217,'Вино Vicente Gandia. Небла 2017 белое 0,75*6',504,800
--union all select '8002235692052',33438,'Вино Zonin. Вальполичелла 2016 красное 0,75*6',600,800
--union all select '4867601703343',34709,'Вино Агмарти. Цинандали белое, сухое 0,75*6 (АО Корпорация Киндзмараули)',480,800
--union all select '5011166052845',33545,'Джин Уитли Нейлл 43% 0,7*6',480,800
--union all select '8410310607196',32032,'Вино Vicente Gandia. Органик Вердехо 2014 белое 0,75*6',504,800
--union all select '4820148520569',30790,'Кофе зеленый молотый 250 гр*12',924,800
--union all select '8427894007656',34112,'Вино Lozano. Кабальерос де ла Роса Бланко Семидульче, белое 0,75*6',480,800
--union all select '8410310607110',28955,'Вино Vicente Gandia. Органик Темпранилло Грейпс 2011 красное 0,75*6',504,800
--union all select '5014218794557',33640,'Виски Douglas Laing. Рок Ойстер Бленд 46,8% 0,7*6 в тубусе',600,800
--union all select '8002235022323',23432,'Вино Zonin. Къянти "Терре Палладиане" 2007 красное 0,75*12',630,800
--union all select '4820139240247',31844,'Водка Дистил №9 0,7*12',576,800
--union all select '3700631997713',34404,'Ром Ботафого Блэк  40% 0,7*6',576,800
--union all select '8002235395953',34458,'Вино Zonin. Каберне Вино Варьетале 2016 красное 0,75*6',630,800
--union all select '8002350133874',27046,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави Миная 2010 белое  0,75*12',480,800
--union all select '8002235216050',23171,'Вино T.Cabolani. Пино Гриджио Фриули Акилеа 2007 белое 0,75*6',630,800
--union all select '8002235022323',31360,'Вино Zonin. Къянти 2013 красное 0,75*6',630,800
--union all select '3068320055008',31873,'Вода Эвиан минеральная 0,5*24 АКЦИЯ',1296,800
--union all select '8002095200046',4702,'Ликер Самбука Молинари Экстра 0,75*12',576,800
--union all select '8410310607196',30703,'Вино Vicente Gandia. Органик Вердехо 2012 белое 0,75*6',504,800
--union all select '8002235572057',25889,'Вино Zonin. Бардолино 2007 красное 0,75*6',630,800
--union all select '8008820158330',33926,'Вино игристое Decordi. Фраголино Россо красное 0,75*6',504,800
--union all select '8002235022323',30733,'Вино Zonin. Къянти 2012 красное 0,75*6',630,800
--union all select '8410310606977',30395,'Вино Vicente Gandia. Небла 2012 белое 0,75*6',504,800
--union all select '8002235022323',28975,'Вино Zonin. Къянти 2011 красное 0,75*6',630,800
--union all select '8710521444703',28253,'Ликер Де Кайпер Кантри Лейн Крем 17 % 0,7*6 New Design',480,800
--union all select '5390683100629',34047,'Ликер Шарис New Design 0,7*6',576,800
--union all select '4062400543002',4698,'Текила Сиерра Репосадо 38% 1,0*12',384,800
--union all select '4905846134093',1717,'Вино Чоя Ориджинал 0,75*6',600,800
--union all select '5010509414104',26138,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,35*24',1152,800
--union all select '3014220909101',29730,'Вино Guy Saget. Роз д*Анжу 2011 розовое 0,75*12',480,800
--union all select '3357340306215',27425,'Вино Pascal Bouchard. Шабли 2010 белое 0,75*6',480,800
--union all select '8002235662055',31282,'Вино Zonin. Соаве 2013 белое 0,75*6',630,800
--union all select '5010509003087',30991,'Набор подарочный (Шотл. Виски МакАртурс 1,0+ Энергетический напиток Fashion F88 0,25)*12',480,800
--union all select '8002235395953',28264,'Вино Zonin. Каберне делле Венеция 2010 красное 0,75*6',630,800
--union all select '3014220909118',26342,'Вино Guy Saget. Вувре 2008  белое 0,75*12',480,800
--union all select '4823069000578',34389,'Вино Кастелло Соул Москато Вайнери Спешиал белое полусладкое 0,75*12',480,800
--union all select '8002235020312',31281,'Вино Zonin. Пино Гриджио делле Венеция 2013 белое 0,75*6',630,800
--union all select '3550142027344',22234,'Коньяк Подарочный набор Шато Монтифо VS Файн Пти Шампань 40% 0,7*6 в тубусе + VSОР Файн Пти Шампань 0,05*12',384,800
--union all select '3014220909118',29732,'Вино Guy Saget. Вувре 2011 белое 0,75*12',480,800
--union all select '8028936008336',28284,'Вино Villa Gritti. Кьянти 2010 красное 0,75*12',480,800
--union all select '8002235022323',31803,'Вино Zonin. Къянти 2014 красное 0,75*6',630,800
--union all select '4603928000983',30902,'Водка Белуга Нобл 1,0*6',384,800
--union all select '5390683100636',29120,'Ликер Шариc 1,0*12',360,800
--union all select '3014220909101',25940,'Вино Guy Saget. Роз д*Анжу 2009 розовое 0,75*12',480,800
--union all select '5014218792102',31996,'Виски Douglas Laing. Скалливаг Бленд 46% 0,7*6 в тубусе ',600,800
--union all select '7804414000655',32574,'Вино Luis Felipe Edwards. Шардоне 2016 белое 0,75*12',480,800
--union all select '8713427000073',4145,'Ликер Де Кайпер Пина Колада (кокосово-ананасовый) 14,5 % 0,7*6',750,800
--union all select '8410310606892',32914,'Вино Vicente Gandia. Раица Крианца 2014 красное 0,75*6',504,800
--union all select '5011166057116',34337,'Джин Уитли Нейлл Резбери 43% 0,7*6',480,800
--union all select '8427894007632',23774,'Вино Lozano. Кабальерос де ла Роса Тинто Семидульче, красное 0,75*12',480,800
--union all select '8002235692052',24254,'Вино Zonin. Вальполичелла  2007 красное 0,75*6',600,800
--union all select '5010509001229',23128,'Виски Шотл Ханки Баннистер бленд 40% New Design 0,7*12 в коробке',576,800
--union all select '4820073560739',27595,'Коньяк Образец под Шато де Луи VS 0,5*6',576,800
--union all select '3014220909118',31597,'Вино Guy Saget. Вувре 2013 белое 0,75*12',480,800
--union all select '8002235572057',31632,'Вино Zonin. Бардолино 2014 красное 0,75*6',630,800
--union all select '8002235020312',26108,'Вино Zonin. Пино Гриджио делле Венеция 2009 белое 0,75*6',630,800
--union all select '3068320103631',24022,'Вода Эвиан минеральная 0,33*20 в стекле',800,800
--union all select '4860053012650',33850,'Коньяк Агмарти КВВК 8 лет 40%  0,5*12',720,800
--union all select '8002235011310',27043,'Вино T.Cabolani. Фриулано Фриули Акилея DOC 2010 белое 0,75*6',504,800
--union all select '5010509001229',26137,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,7*12 с коробкой в наборе',576,800
--union all select '3068320103631',30740,'Набор минеральной природной столовой воды Эвиан (4 бут.*0,33 в стекле)*4',800,800
--union all select '8002235662055',30734,'Вино Zonin. Соаве 2012 белое 0,75*6',630,800
--union all select '3395940520709',31957,'Вино Aujoux. Лис Руж красное полусладкое 0,75*12',600,800
--union all select '5010509414081',4213,'Виски Шотл Ханки Баннистер бленд 40% 1,0*4 + 2 стакана в коробке',384,800
--union all select '8002350133881',31963,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави 2014 белое 0,75*12',480,800
--union all select '4823069001513',31847,'Вино Tамрико Каха Глобал Вайн Саперави красное сухое 0,75*12',480,800
--union all select '8002235572057',34658,'Вино Zonin. Бардолино 2017 красное 0,75*6',630,800
--union all select '4823069001216',34392,'Вино Чинчорро Каберне Совиньон Вайнери Спешиал красное сухое 0,75*12',480,800
--union all select '4006714004958',29874,'Ром Кана Карибия Вайт 38% 0,7*6',600,800
--union all select '4062400542005',33601,'Текила Сиерра Сильвер 38% 1,5*6',216,800
--union all select '8002350133881',31271,'Вино Bergaglio Nicola. Гави дель Комуне ди Гави 2013 белое  0,75*12',480,800
--union all select '4820139240247',32020,'Водка Дистил №9 0,7*6',576,800
--union all select '3395940520662',31959,'Вино Aujoux. Лис Блан белое полусладкое 0,75*12',600,800
--union all select '7804414000655',28938,'Вино Luis Felipe Edwards. Шардоне 2011 белое 0,75*12',480,800
--union all select '4867601703374',28240,'Вино Агмарти. Киндзмараули красное, полусладкое 0,75*12 (АО Корпорация Киндзмараули)',480,800
--union all select '8002095200046',23090,'Самбука Молинари Экстра ликер  0,75*2 + 2 стакана в коробке АКЦИЯ',576,800
--union all select '3550142025463',25216,'Коньяк Шато Монтифо VS Файн Пти Шампань 40% Жарнак 0,5*12',576,800
--union all select '8002235022811',33685,'Вино Zonin. Шардоне Вино Варьетале 2016 белое 0,75*6',630,800

--	SELECT * FROM #ProdsPalet ORDER BY 3
	
--END



