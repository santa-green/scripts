	--таблица исключений РН
	IF OBJECT_ID (N'tempdb..#ProdsPalet', N'U') IS NOT NULL DROP TABLE #ProdsPalet
	CREATE TABLE #ProdsPalet (Num INT IDENTITY(1,1) NOT NULL ,ProdID INT null, TaxDocDate varchar(250) null, QtyInPalet INT NULL, WidthPalet NUMERIC(21,9))
		
	INSERT #ProdsPalet
	--="union all select "&C4&",'"&ТЕКСТ(D4;"ГГГГ-ММ-ДД")&"',"&H4&","&L4&""
select           30766,'Вермут Trino Бьянко 0,5*21 14,8% Design 2013',504,800
union all select 30767,'Вермут Trino Бьянко 1*12 14,8% Design 2013',384,800
union all select 28246,'Вино Агмарти. Алазанская долина белое, полусладкое 0,75*12',480,1000
union all select 28245,'Вино Агмарти. Алазанская долина красное, полусладкое 0,75*12 ',480,1000
union all select 30497,'Виски Шотл МакАртурс 40% 0,5*12',768,1000
union all select 4165,'Виски Шотл МакАртурс 40% 0,7*12',840,1000
union all select 4167,'Виски Шотл МакАртурс 40% 1,0*12',480,1000
union all select 26135,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,5*12',1140,1000
union all select 26136,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,7*12',768,1000
union all select 26137,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 0,7*12 в коробке',768,1000
union all select 26133,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 1,0*12',576,1000
union all select 26139,'Виски Шотл Ханки Баннистер бленд 40% New Design Original 1,0*12 в коробке',576,1000
union all select 3127,'Вода Эвиан минеральная 1,5*6',504,800
union all select 26168,'Вода Эвиан минеральная 0,75*12 в стекле New',780,1000
union all select 26213,'Вода Эвиан минеральная 0,33*20 в стекле New',1540,1000
union all select 30843,'Вода Эвиан минеральная Спорт 0,75*6 New Design',1080,1000
union all select 31878,'Вода Эвиан минеральная 0,33*24 Prestige',3120,1000
union all select 31879,'Вода Эвиан минеральная 0,5*24 Prestige',2016,1000
union all select 31880,'Вода Эвиан минеральная 1,0*12 Prestige',1008,1000
union all select 32143,'Водка Фински 40% 0,7*12',600,800
union all select 32142,'Водка Фински 40% 0,5*15',825,800
union all select 32144,'Водка Фински 40% 1,0*12',336,800

	SELECT * FROM #ProdsPalet
