USE ElitR

	EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'
	GO
	--REVERT

IF 1=1
BEGIN
	--загружаем меню Ркипера из шаблона menu_R_keeper.xlsx
	IF OBJECT_ID (N'tempdb..#Menu', N'U') IS NOT NULL DROP TABLE #Menu
	SELECT * 
	 INTO #Menu	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\R_keeper\menu_R_keeper.xlsx' , 'select * from [Лист1$]') as ex
	WHERE  Статус = 'Активный'

	--загружаем старое меню Ркипера из шаблона menu_R_keeper.xlsx
	IF OBJECT_ID (N'tempdb..#Menu_old', N'U') IS NOT NULL DROP TABLE #Menu_old
	SELECT * 
	 INTO #Menu_old	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\R_keeper\menu_R_keeper_old.xlsx' , 'select * from [Лист1$]') as ex
	WHERE  Статус = 'Активный'

--товары которые изменились с прошлого раза
SELECT * FROM (
	SELECT * FROM #Menu_old
	except 
	SELECT * FROM #Menu
) ex
union all
SELECT * FROM (
	SELECT * FROM #Menu
	except
	SELECT * FROM #Menu_old
) ex2
ORDER BY 1

	--загружаем меню из базы
	IF OBJECT_ID (N'tempdb..#Baze', N'U') IS NOT NULL DROP TABLE #Baze
	SELECT * 
	 INTO #Baze	
	--SELECT * 
	FROM (
			SELECT [Внешний код], Название, ProdID ,ProdName,baze_Основная, [baze_Балоньез летняя], [baze_Летняя площадка],[Путь по группам], 
			str_Основная, [str_Балоньез летняя], [str_Детская площадка],[str_Летняя площадка], menu_Основная, [menu_Балоньез летняя], [menu_Детская площадка],[menu_Летняя площадка],
			[По-умолчанию#Ресторан] p71, [По-умолчанию#Балоньез] л2_76,  [По-умолчанию#Летняя площадка] л1_77 ,[Статус],[Налоговая группа]
			--, ISNULL((SELECT top 1 20 FROM r_Prods p WHERE p.ProdID = baze.ProdID and p.PGrID2 = 40014),0) [baze_НДС]
			, ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = baze.ProdID),0) [baze_Акциз]
			--неправильная, ISNULL((SELECT top 1 20 FROM r_Prods p WHERE p.ProdID = baze.ProdID and p.PGrID2 = 40014),0) + ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = baze.ProdID),0) [baze_Налог]
			,Norma5, Norma4
			FROM (
				SELECT [Внешний код], [Название],[Путь по группам], 
				[Основная] 'str_Основная',[Балоньез летняя] 'str_Балоньез летняя',[Детская площадка] 'str_Детская площадка',[Летняя площадка] 'str_Летняя площадка', 
				case when ISNUMERIC(REPLACE (REPLACE ([Основная],',','.'),' ','')) = 1 then CAST(REPLACE (REPLACE ([Основная],',','.'),' ','') AS NUMERIC(21,9)) else 0 end 'menu_Основная',
				case when ISNUMERIC(REPLACE (REPLACE ([Балоньез летняя],',','.'),' ','')) = 1 then CAST(REPLACE (REPLACE ([Балоньез летняя],',','.'),' ','') AS NUMERIC(21,9)) else 0 end 'menu_Балоньез летняя',
				case when ISNUMERIC(REPLACE (REPLACE ([Детская площадка],',','.'),' ','')) = 1 then CAST(REPLACE (REPLACE ([Детская площадка],',','.'),' ','') AS NUMERIC(21,9)) else 0 end 'menu_Детская площадка',
				case when ISNUMERIC(REPLACE (REPLACE ([Летняя площадка],',','.'),' ','')) = 1 then CAST(REPLACE (REPLACE ([Летняя площадка],',','.'),' ','') AS NUMERIC(21,9)) else 0 end 'menu_Летняя площадка'
				--[Балоньез летняя], case when ISNUMERIC([Балоньез летняя]) = 1 then CAST(REPLACE ([Балоньез летняя],',','.') AS NUMERIC(21,9)) else 0 end 'Балоньез летняя',
				--[Летняя площадка], case when ISNUMERIC([Летняя площадка]) = 1 then CAST(REPLACE ([Летняя площадка],',','.') AS NUMERIC(21,9)) else 0 end 'Летняя площадка'
				,case when [По-умолчанию#Балоньез] like '%Включен%' then 1 else 0 end 'По-умолчанию#Балоньез'
				,case when [По-умолчанию#Ресторан] like '%Включен%' then 1 else 0 end 'По-умолчанию#Ресторан'
				,case when [По-умолчанию#Летняя площадка] like '%Включен%' then 1 else 0 end 'По-умолчанию#Летняя площадка'
				,[Статус],[Налоговая группа]
				FROM #Menu) menu
			FULL JOIN  (SELECT p.ProdID, p.ProdName 
						, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 71 and  mp.InUse = 1) 'baze_Основная'
						, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 76 and  mp.InUse = 1) 'baze_Балоньез летняя'
						, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 77 and  mp.InUse = 1) 'baze_Летняя площадка'
						,Norma5, Norma4
						FROM r_Prods p where p.ProdID in (SELECT ProdID FROM r_ProdMP mp where mp.PLID in (71,76,77) and  mp.InUse = 1)
						) baze on baze.ProdID = menu.[Внешний код] 
		) s1
END

/*
SELECT * FROM #Baze WHERE ProdID in (607286)
SELECT * FROM #Baze WHERE ProdName like '%шей%'
*/

IF EXISTS(SELECT TOP 1 1 FROM #Baze WHERE [Внешний код] is null) 
BEGIN
	SELECT 'товары которые должы быть в ркипере' 'проверка'
	SELECT * FROM #Baze WHERE [Внешний код] is null ORDER BY ProdName
END
--SELECT distinct ProdID, PLID,(SELECT ProdName FROM r_Prods p where p.ProdID = mp.ProdID) ProdName FROM ElitR.dbo.r_ProdMP mp
--where PLID in (71,76,77) and InUse = 1 and Notes not in (SELECT [Внешний код] FROM #Menu)
--ORDER BY 3,2

IF EXISTS(SELECT TOP 1 1 FROM #Baze WHERE (ProdID IS NULL  and (p71 + л2_76 + л1_77) > 0 )) 
BEGIN
	SELECT 'товары которых не должно быть в ркипере' 'проверка'
	SELECT * FROM #Baze WHERE (ProdID IS NULL  and (p71 + л2_76 + л1_77) > 0 )
END

IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE
	(CASE WHEN baze_Основная IS NULL THEN 0 ELSE 1 END) <>  p71 --торговая группа в ркипере не равна состоянию в базе
	OR 
	(CASE WHEN [baze_Балоньез летняя] IS NULL THEN 0 ELSE 1 END) <>  л2_76 --торговая группа в ркипере не равна состоянию в базе
	OR 
	(CASE WHEN [baze_Летняя площадка] IS NULL THEN 0 ELSE 1 END) <>  л1_77 --торговая группа в ркипере не равна состоянию в базе
) 
BEGIN
	SELECT 'проверка включенных торговых групп' 'проверка'
	SELECT * FROM #Baze WHERE
	(CASE WHEN baze_Основная IS NULL THEN 0 ELSE 1 END) <>  p71 --торговая группа в ркипере не равна состоянию в базе
	OR 
	(CASE WHEN [baze_Балоньез летняя] IS NULL THEN 0 ELSE 1 END) <>  л2_76 --торговая группа в ркипере не равна состоянию в базе
	OR 
	(CASE WHEN [baze_Летняя площадка] IS NULL THEN 0 ELSE 1 END) <>  л1_77 --торговая группа в ркипере не равна состоянию в базе

	--(CASE WHEN baze_Основная IS NULL THEN 0 ELSE 1 END) <>  p71 --торговая группа в ркипере не равна состоянию в базе
	--and p71 = 1
	--OR 
	--(CASE WHEN [baze_Балоньез летняя] IS NULL THEN 0 ELSE 1 END) <>  л2_76 --торговая группа в ркипере не равна состоянию в базе
	--and л2_76 = 1
	--OR 
	--(CASE WHEN [baze_Летняя площадка] IS NULL THEN 0 ELSE 1 END) <>  л1_77 --торговая группа в ркипере не равна состоянию в базе
	--and л1_77 = 1
END

IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE 
	(menu_Основная <> baze_Основная and p71 = 1 )
	OR 
	([menu_Балоньез летняя] <> [baze_Балоньез летняя] and [menu_Балоньез летняя] <> 0 and л2_76 = 1 )
	OR
	([menu_Детская площадка] <> [baze_Балоньез летняя] and [menu_Детская площадка] <> 0 and л2_76 = 1 )
	OR 
	([menu_Летняя площадка] <> [baze_Летняя площадка] and л1_77 = 1 )
) 
BEGIN
	SELECT 'проверка цен' 'проверка'
	SELECT * FROM #Baze WHERE 
	--(
	(menu_Основная <> baze_Основная and p71 = 1 )
	OR 
	([menu_Балоньез летняя] <> [baze_Балоньез летняя] and [menu_Балоньез летняя] <> 0 and л2_76 = 1 )
	OR
	([menu_Детская площадка] <> [baze_Балоньез летняя] and [menu_Детская площадка] <> 0 and л2_76 = 1 )
	OR 
	([menu_Летняя площадка] <> [baze_Летняя площадка] and л1_77 = 1 )
	--)
	--and [Внешний код] in (607511,607516,607784,607977,607525,607980,605490,607023,607979,607853,607972,607809,607993,606388,606385,606386,606387,605675,605169,605172,605173,605174,606132,605176,605162,605163,606336,606769,607678,800362,801307,800360,607651,607650,607653,607652,608025,608026,608027,608028,608029,608019,608020,608021,608022,608023,608024,608030,608013,608014,608015,608016,608017,608018)
END


IF EXISTS(
	SELECT TOP 1 1
	FROM #Baze WHERE [menu_Балоньез летняя] <> [menu_Детская площадка] and [baze_Балоньез летняя] is not null
	and [menu_Балоньез летняя] <> 0 and [menu_Детская площадка] <> 0
	and [baze_Балоньез летняя]=[menu_Балоньез летняя]
) 
BEGIN
	SELECT 'проверка цен разных по 76 прайсу болоньез' 'проверка'
	SELECT [Внешний код], Название, ProdID, ProdName, [baze_Балоньез летняя], [Путь по группам], [str_Балоньез летняя], [str_Детская площадка],  [menu_Балоньез летняя], [menu_Детская площадка], л2_76, Статус, [Налоговая группа], baze_Акциз, Norma5, Norma4 
	FROM #Baze WHERE [menu_Балоньез летняя] <> [menu_Детская площадка] and [baze_Балоньез летняя] is not null
	and [menu_Балоньез летняя] <> 0 and [menu_Детская площадка] <> 0
	and [baze_Балоньез летняя]=[menu_Балоньез летняя]
END


IF EXISTS(
	SELECT TOP 1 1 FROM (
	SELECT [Внешний код], Название, [Путь по группам], [Налоговая группа], ProdID, ProdName, baze_Основная, [baze_Балоньез летняя], [baze_Летняя площадка] 
	,ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = #baze.ProdID),0) baze_акциз
	,Norma5
	, case  Norma5 when 0 then 'наш - НДС 0' when 1 then 'не наш - НДС 20' else null end норма5
	,Norma4
	, case  Norma4 when 1 then 'ЧП - НДС 0' when 2 then 'ООО - НДС 20' else null end норма4
	, case  Norma5 when 1 then 20 else 
		case  Norma4 when 2 then 20  else 0 end
		end + ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = #baze.ProdID),0) baze_Налог
	FROM #Baze) s1
	WHERE  baze_Налог <>  (case when [Налоговая группа] = '4 НДС + Акциз' then 25  when [Налоговая группа] = '3 НДС 20' then 20 when [Налоговая группа] = '1 НДС 0' then 0 else null end )
	and ProdID  IS NOT NULL
	and ProdID not in (800890,607045,607044,607046,603101,602688,803096,606044,605917,607025,607640,607029)
) 
BEGIN
	SELECT 'Проверка налога' 'проверка'
	SELECT [Внешний код], Название, [Путь по группам], [Налоговая группа], baze_Налог, Norma5, норма5, Norma4, норма4, baze_акциз FROM (
	SELECT [Внешний код], Название, [Путь по группам], [Налоговая группа], ProdID, ProdName, baze_Основная, [baze_Балоньез летняя], [baze_Летняя площадка] 
	,ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = #baze.ProdID),0) baze_акциз
	,Norma5
	, case  Norma5 when 0 then 'наш - НДС 0' when 1 then 'не наш - НДС 20' else null end норма5
	,Norma4
	, case  Norma4 when 1 then 'ЧП - НДС 0' when 2 then 'ООО - НДС 20' else null end норма4
	, case  Norma5 when 1 then 20 else 
		case  Norma4 when 2 then 20  else 0 end
		end + ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = #baze.ProdID),0) baze_Налог
	FROM #Baze) s1
	WHERE  baze_Налог <>  (case when [Налоговая группа] = '4 НДС + Акциз' then 25  when [Налоговая группа] = '3 НДС 20' then 20 when [Налоговая группа] = '1 НДС 0' then 0 else null end )
	and ProdID  IS NOT NULL
	and ProdID not in (800890,607045,607044,607046,603101,602688,803096,606044,605917,607025,607640,607029)
	ORDER BY [Налоговая группа],baze_Налог,[Путь по группам],Название
END


IF EXISTS(
	SELECT TOP 1 1 FROM #Menu WHERE [Название] like '%і%' --Ролл Каліфорнія з вугром 200г, порц.
) 
BEGIN
	SELECT 'проверка на украинские буквы' 'проверка'
	SELECT * FROM #Menu WHERE [Название] like '%і%' --Ролл Каліфорнія з вугром 200г, порц.
END


IF EXISTS(
SELECT TOP 1 1 FROM #Baze WHERE len([Название] ) < 9
) 
BEGIN
	SELECT 'короткое названия товаров' 'проверка'
	SELECT * FROM #Baze WHERE len([Название] ) < 9
END


IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE cast(REPLACE([Название],'#','') as varchar(9)) <> cast(ProdName as varchar(9))
) 
BEGIN
	SELECT 'разные названия товаров первые 9 букв' 'проверка'
	SELECT * FROM #Baze WHERE cast(REPLACE([Название],'#','') as varchar(9)) <> cast(ProdName as varchar(9))
END


IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE cast([Название] as varchar(40)) <> cast(ProdName as varchar(40))
) 
BEGIN
	SELECT 'разные названия товаров' 'проверка'
	SELECT * FROM #Baze WHERE cast([Название] as varchar(40)) <> cast(ProdName as varchar(40))
END










--сравниваем меню Ркипера из шаблона menu_R_keeper.xlsx и данные с базы
--SELECT * FROM #Baze
--WHERE 1=1
--AND
--[Внешний код] in (608061)
--ProdID in (605630)
--ProdID IS NULL ORDER BY 2
--(ProdID IS NULL  and (p71 + л2_76 + л1_77) > 0 )--товары которых не должно быть в ркипере

--(p71 + л2_76 + л1_77) = 0

--[Внешний код] in (SELECT ProdID FROM r_Prods where ProdName like '%дарк%')
--ProdID in (SELECT ProdID FROM r_Prods where ProdName like '%энко%')

/*проверка цен*/
--menu_Основная <> baze_Основная  
--OR 
--([menu_Балоньез летняя] <> [baze_Балоньез летняя])
--OR 
--[menu_Летняя площадка] <> [baze_Летняя площадка]

/*Проверка налога*/
--baze_Налог <> (case when [Налоговая группа] = '4 НДС + Акциз' then 25  when [Налоговая группа] = '3 НДС 20' then 20 when [Налоговая группа] = '1 НДС 0' then 0 else null end )
--and ProdID  IS NOT NULL

--cast([Название] as varchar(40)) <> cast(ProdName as varchar(40))
--and  
--[Название] like '%і%' --Ролл Каліфорнія з вугром 200г, порц.

--/*проверка включенных торговых групп*/
--(CASE WHEN baze_Основная IS NULL THEN 0 ELSE 1 END) <>  p71 --торговая группа в ркипере не равна состоянию в базе
--OR 
--(CASE WHEN [baze_Балоньез летняя] IS NULL THEN 0 ELSE 1 END) <>  л2_76 --торговая группа в ркипере не равна состоянию в базе
--OR 
--(CASE WHEN [baze_Летняя площадка] IS NULL THEN 0 ELSE 1 END) <>  л1_77 --торговая группа в ркипере не равна состоянию в базе


--(CASE WHEN baze_Основная IS NULL THEN 0 ELSE 1 END) <>  p71 --торговая группа в ркипере не равна состоянию в базе
--and p71 = 1
--OR 
--(CASE WHEN [baze_Балоньез летняя] IS NULL THEN 0 ELSE 1 END) <>  л2_76 --торговая группа в ркипере не равна состоянию в базе
--and л2_76 = 1
--OR 
--(CASE WHEN [baze_Летняя площадка] IS NULL THEN 0 ELSE 1 END) <>  л1_77 --торговая группа в ркипере не равна состоянию в базе
--and л1_77 = 1

--ORDER BY [Путь по группам],2

/*
--SELECT ProdID, PLID, PriceMC, (SELECT ProdName FROM r_Prods p where p.ProdID = mp.ProdID) ProdName FROM r_ProdMP mp where mp.PLID = 71 and  mp.InUse = 1
--SELECT ProdID, PLID, PriceMC, (SELECT ProdName FROM r_Prods p where p.ProdID = mp.ProdID) ProdName FROM r_ProdMP mp where mp.PLID = 71 and  mp.InUse = 1
SELECT ProdID, PLID, PriceMC, DepID, (SELECT ProdName FROM r_Prods p where p.ProdID = mp.ProdID) ProdName FROM r_ProdMP mp where mp.PLID = 76 and  mp.InUse = 1
ORDER BY DepID desc

SELECT ProdName,* FROM r_Prods where ProdName like '%энко%'

SELECT * FROM r_Prods where ProdID in (601792)
SELECT * FROM r_Prodmp where ProdID in (601792) and PLID = 76 and InUse = 1

--меню с базы
SELECT p.ProdID, p.ProdName 
, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 71 and  mp.InUse = 1) 'baze_Основная'
, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 76 and  mp.InUse = 1) 'baze_Балоньез летняя'
, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 77 and  mp.InUse = 1) 'baze_Летняя площадка'
FROM r_Prods p where p.ProdID in (SELECT ProdID FROM r_ProdMP mp where mp.PLID in (71,76,77) and  mp.InUse = 1)
ORDER BY p.ProdID


--SELECT * FROM #Menu where Название like '%дарк%'
--ORDER BY 1



--select case when ISNUMERIC('0,1') = 1 then CAST(REPLACE ('3 924,00',',','.') AS NUMERIC(21,9)) else 0 end 'Основная'
--select case when ISNUMERIC(REPLACE (REPLACE ('3 924,00',',','.'),' ','')) = 1 then 1 else 0 end 'Основная'
--select case when ISNUMERIC(REPLACE ('3 924',' ','')) = 1 then 1 else 0 end 'Основная'

SELECT * FROM r_PLs where PLID in (71,76,77)
SELECT * FROM r_stocks where PLID in (71,76,77)
SELECT * FROM r_Prods where ProdName like '%лагер%'

and prodid not in (607673,607951,607668,607950,607672,607675,607671,607674,607676,607670,607954,607952)

--select cast('Луиджи Боска Вино Совиньон Блан 2011 белое 0,75л' as varchar(40))


SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5),p2.PGrID5 FROM r_Prods p2 where p2.ProdID in (803252)
SELECT * FROM at_r_ProdG5 p5 where p5.PGrID5 = 165

SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = 165

SELECT * FROM #Menu




SELECT p.ProdID , p.Prodname
,p.PGrID5
,(SELECT top 1 PGrName5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p.PGrID5) подгруппа5
,(SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p.PGrID5) акциз 
,p.PGrID2 
,(SELECT top 1 PGrName2 FROM r_ProdG2 p2 where p2.PGrID2 = p.PGrID2) подгруппа2
,(SELECT top 1 case when p2.PGrID2 in (40014)then 20 else 0 end FROM r_ProdG2 p2 where p2.PGrID2 = p.PGrID2) НДС
,(SELECT top 1 [Налоговая группа]  FROM #Menu m where m.[Внешний код] = p.ProdID) [Налоговая группа]
,p.Norma5
, case  p.Norma5 when 0 then 'наш - НДС 0' when 1 then 'не наш - НДС 20' else null end норма5
,p.Norma4
, case  p.Norma4 when 1 then 'ЧП - НДС 0' when 2 then 'ООО - НДС 20' else null end норма4
--,(SELECT top 1 PGrName2 FROM r_ProdG2 n5 where n5.Norma5 = p.Norma5) 
FROM r_Prods p where p.ProdID in (605917,607025,607640,607029,803252,800360,801306,803017,803018,605382,800362,801307,803251,800355,803250,607652,607653,607650,607651,607490,607491,607920,607919,607752,607753,607986,607987,607985)


SELECT d.* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE d.ProdID = 800360
and m.DocDate > '2018-05-01'
ORDER BY 1

SELECT distinct [Сервис печать] FROM #Menu
SELECT *  FROM #Menu where [Сервис печать] = '31 Коктейли' and [По-умолчанию#Балоньез] != 'Исключен'
SELECT *  FROM #Menu where [Сервис печать] is null
SELECT *  FROM #Menu where [Внешний код] in (607598,607600,607606,607607,607610,607611,607613,607617,607621,607622,607623,607624,607626,607628,608032,608033,608034,608035,608036,608037,608038,608039,608040,608041,608042,608043,608044,608045,608046,608047,608048,608049,608050,608051,608052,608110,607645,607810,607811,608084,608085,608086,608087,608088,607994)
*/

