USE [ElitR]
GO
/****** Object:  StoredProcedure [dbo].[ap_rkeeper_menu_check]    Script Date: 05.05.2021 17:53:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<rkv0>
-- Create date: <20201013>
-- Description:	<Проверка меню Rkeeper>
-- =============================================
ALTER PROCEDURE [dbo].[ap_rkeeper_menu_check] 
AS
BEGIN
/* 
    EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0')
    GO

	REVERT
    select system_user;
    select USER_NAME();
*/
    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] '2020-02-19 12:00' rkv0 добавил в исключение 9 товаров (Ровнягина подтвердила изменение группы на НДС-20, позже администраторы сказали, что им так пробивать товары неудобно (например, Вода Моршинская теперь пробивается на баре через Марию). Скорее всего, надо будет пригласить Диму Rkeeper для настройки новой схемы (согласовать с Ровнягиной и админами парка). А изначально Лейла изменила норму 5 с "0" на "1" по большому количеству товаров (9 из них оказались в Rkeeper). Больше деталей см. здесь: "\\s-elit-dp\F\Румянцев\! ЗАЯВКИ\Ровнягина\RE  Налоговые группы в Rkeeper.msg" 
-- [ADDED] '2019-06-12 11:55' rkv0 добавил в исключение 8000 (Услуга доставки курьером)
-- [FIXED] '2020-03-26 14:26' rkv0 добавил в вывод код товара 608350 (был только в блоке проверки IF EXISTS).
-- [ADDED] '2020-06-12 15:33' rkv0 добавил в исключение кальяны (т.к. были перенесены в отдельную группу по заявке Бышинской).
-- [CHANGED] rkv0 '2020-10-27 14:36' сменил * на названия полей (в связи добавлением поля Код - нужно для поиска блюд в Rkeeper).
-- [ADDED] Maslov Oleg '2020-12-21 13:32:52.420' Долго же я разбирался чтобы понять, что хочет эта проверка. Хватит это терпеть!
-- [FIXED] rkv0 '2021-01-29 17:20' добавил к CASE WHEN IS NULL OR ... = 0
-- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
-- [CHANGED] '2021-04-30 18:26' rkv0 добавил в исключение Бизнес-ланч 2 и 3.
--[CHANGED] rkv0 '2021-05-06 13:58' добавил в исключение кальян аналогично остальным кальянам.


/*
SELECT * FROM #Baze WHERE ProdID in (608334)
SELECT (SELECT PCatName FROM r_ProdC pc WHERE pc.PCatID = p.PCatID),(SELECT PGrName FROM r_ProdG pg WHERE pg.PGrID = p.PGrID) ,* FROM r_prods p WHERE ProdID in (608334)
SELECT * FROM r_prodc WHERE ProdID in (608334)


SELECT * FROM #Baze WHERE ProdName like '%шей%'
SELECT ProdID,(SELECT top 1 ProdName FROM r_prods p where p.ProdID = m.ProdID) ProdName, ProdName FROM #Baze m WHERE ProdName like '%ДОБАВЬТЕ "r01 - Короткое название для RKeeper" во вкладку Значения%'
SELECT * FROM dbo.r_ProdValues rpv WHERE rpv.VarName LIKE 'r01%' AND rpv.ProdID = p.ProdID),'ДОБАВЬТЕ "r01 - Короткое название для RKeeper" во вкладку Значения') ProdName 

--для вставки в Excel
="INSERT INTO [ElitR].[dbo].[r_ProdValues] ([ProdID],[VarName],[VarValue])VALUES ("&A1&",'r01 - Короткое название для RKeeper','"&B1&"')"

INSERT INTO [ElitR].[dbo].[r_ProdValues] ([ProdID],[VarName],[VarValue]) VALUES (608020,'r01 - Короткое название для RKeeper','Кофе холодный заварной Ореховый 450мл, п');
select * from r_ProdValues
--генерировать скрипт добавления короткого названия в базу
select [Внешний код], Название 
,'INSERT INTO [ElitR].[dbo].[r_ProdValues] ([ProdID],[VarName],[VarValue]) VALUES ('+[Внешний код]+',''r01 - Короткое название для RKeeper'','''+Название+''');'
from #Menu_ALL where [Внешний код] not in (SELECT ProdID FROM dbo.r_ProdValues rpv WHERE rpv.VarName LIKE 'r01%')
and [Внешний код] in (SELECT ProdID FROM dbo.r_Prods )
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Загружаем меню Ркипера из Excel файла*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF 1=1
BEGIN
	--загружаем меню Ркипера из шаблона menu_R_keeper.xlsx в таблицу #Menu.
	IF OBJECT_ID (N'tempdb..#Menu', N'U') IS NOT NULL DROP TABLE #Menu
    -- [CHANGED] rkv0 '2020-10-27 14:36' сменил * на названия полей (в связи добавлением поля Код - нужно для поиска блюд в Rkeeper).
	--SELECT * 
	SELECT [Внешний код], Название, Статус, Основная, [Балоньез летняя], [Детская площадка], [Летняя площадка], [Путь по группам], [Налоговая группа], [По-умолчанию#Балоньез], [По-умолчанию#Ресторан], [По-умолчанию#Летняя площадка], [для акций], [для предчеков], Классификация, [Отдел ФР], [Сервис печать] 
	 INTO #Menu	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\R_keeper\menu_R_keeper.xlsx' , 'select * from [Лист1$]') as ex
	WHERE Статус = 'Активный'

/*	--загружаем старое меню Ркипера из шаблона menu_R_keeper_old.xlsx
	IF OBJECT_ID (N'tempdb..#Menu_old', N'U') IS NOT NULL DROP TABLE #Menu_old
	SELECT * 
	 INTO #Menu_old	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\R_keeper\menu_R_keeper_old.xlsx' , 'select * from [Лист1$]') as ex
	WHERE  Статус = 'Активный'*/

	--загружаем полное меню Ркипера из шаблона menu_R_keeper.xlsx в таблицу #Menu_ALL.
	IF OBJECT_ID (N'tempdb..#Menu_ALL', N'U') IS NOT NULL DROP TABLE #Menu_ALL
    -- [CHANGED] rkv0 '2020-10-27 14:36' сменил * на названия полей (в связи добавлением поля Код - нужно для поиска блюд в Rkeeper).
	--SELECT *
	SELECT [Внешний код], Название, Статус, Основная, [Балоньез летняя], [Детская площадка], [Летняя площадка], [Путь по группам], [Налоговая группа], [По-умолчанию#Балоньез], [По-умолчанию#Ресторан], [По-умолчанию#Летняя площадка], [для акций], [для предчеков], Классификация, [Отдел ФР], [Сервис печать]
	 INTO #Menu_ALL	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\R_keeper\menu_R_keeper.xlsx' , 'select * from [Лист1$]') as ex

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Товары, которые изменились с прошлого раза*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*	IF EXISTS(
		SELECT * FROM (
			SELECT * FROM #Menu_old
			EXCEPT 
			SELECT * FROM #Menu
					  ) ex
		UNION ALL
		SELECT * FROM (
			SELECT * FROM #Menu
			EXCEPT
			SELECT * FROM #Menu_old
					  ) ex2
			 )
	BEGIN
		SELECT 'Товары, которые изменились с прошлого раза'
		SELECT * FROM (
			SELECT * FROM #Menu_old
			EXCEPT 
			SELECT * FROM #Menu
					  ) ex
		UNION ALL
		SELECT * FROM (
			SELECT * FROM #Menu
			EXCEPT
			SELECT * FROM #Menu_old
					  ) ex2
		ORDER BY 1
	END
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Загружаем меню из базы (Бизнеса)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#Baze', N'U') IS NOT NULL DROP TABLE #Baze
	SELECT * 
	 INTO #Baze	
	--SELECT * 
	FROM (
			SELECT [Внешний код], Название, ProdID , ProdName,baze_Основная, [baze_Балоньез летняя], [baze_Летняя площадка],[Путь по группам], 
			str_Основная, [str_Балоньез летняя], [str_Детская площадка],[str_Летняя площадка], menu_Основная, [menu_Балоньез летняя], [menu_Детская площадка],[menu_Летняя площадка],
			[По-умолчанию#Ресторан] p71, [По-умолчанию#Балоньез] л2_76,  [По-умолчанию#Летняя площадка] л1_77 ,[Статус],[Налоговая группа]
			--, ISNULL((SELECT top 1 20 FROM r_Prods p WHERE p.ProdID = baze.ProdID and p.PGrID2 = 40014),0) [baze_НДС]
			, ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = baze.ProdID),0) [baze_Акциз]
			--неправильная, ISNULL((SELECT top 1 20 FROM r_Prods p WHERE p.ProdID = baze.ProdID and p.PGrID2 = 40014),0) + ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = baze.ProdID),0) [baze_Налог]
			,Norma5, Norma4
			,baze_Налог,[для акций], [для предчеков], Классификация, [Отдел ФР], [Сервис печать]
			,Категория,Группа
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
				,[для акций], [для предчеков], Классификация, [Отдел ФР], [Сервис печать]
				FROM #Menu) menu
			FULL JOIN  (SELECT p.ProdID
						--, p.ProdName 
						,isnull((SELECT VarValue FROM dbo.r_ProdValues rpv WHERE rpv.VarName LIKE 'r01%' AND rpv.ProdID = p.ProdID),'ДОБАВЬТЕ "r01 - Короткое название для RKeeper" во вкладку Значения') ProdName 
						, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 71 and  mp.InUse = 1) 'baze_Основная'
						, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 76 and  mp.InUse = 1) 'baze_Балоньез летняя'
						, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 77 and  mp.InUse = 1) 'baze_Летняя площадка'
						,Norma5, Norma4
						, case  Norma5 when 1 then 20 else 
						case  Norma4 when 2 then 20  else 0 end
						end + ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = p.ProdID),0) baze_Налог
						,(SELECT PCatName FROM r_ProdC pc WHERE pc.PCatID = p.PCatID) Категория
						,(SELECT PGrName FROM r_ProdG pg WHERE pg.PGrID = p.PGrID) Группа

						FROM r_Prods p where p.ProdID in (SELECT ProdID FROM r_ProdMP mp where mp.PLID in (71,76,77) and  mp.InUse = 1) --r_ProdMP: Справочник товаров - Цены для прайс-листов
						) baze on baze.ProdID = menu.[Внешний код] 
		) s1
END;


-- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
--SELECT 'Если пусто, то все ок' 'Инфо', (SELECT COUNT(*) FROM #Baze ) 'Кол активных товаров в базе', (SELECT COUNT(*) FROM #Menu ) 'Кол активных товаров в файле меню Ркипера'
SELECT 
    'Если пусто, то все ок' 'Инфо',
    (SELECT COUNT(*) FROM #Baze WHERE ProdID IS NULL OR ProdID NOT IN (N'605229', N'605230')) 'Кол активных товаров в базе', --Бизнес-ланч 2 и 3.
    (SELECT COUNT(*) FROM #Menu) 'Кол активных товаров в файле меню Ркипера'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ПРОВЕРКИ: */
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Новые Товары, которые должны быть ДОБАВЛЕНЫ в RKeeper*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT TOP 1 1 FROM #Baze WHERE [Внешний код] is null AND ProdID NOT IN (SELECT [Внешний код] FROM #Menu_ALL)
    -- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
     AND ProdID NOT IN (N'605229', N'605230') --Бизнес-ланч 2 и 3.
) 
BEGIN
	SELECT 'Новые Товары, которые должны быть в RKeeper' 'проверка'
	SELECT 'Name', 'ExtCode', 'Price:Основная', 'Instruct', 'AltName' union
	SELECT 
		(SELECT VarValue FROM dbo.r_ProdValues rpv WHERE rpv.VarName LIKE 'r01%' AND rpv.ProdID = p.ProdID) Name
		, cast(p.ProdID AS nvarchar) ExtCode
		,cast(isnull((SELECT cast(PriceMC AS numeric(21,2)) FROM dbo.r_ProdMP mp WHERE mp.plid = 77 AND mp.ProdID = p.ProdID),0) AS nvarchar) 'Price:Основная'
		,(SELECT VarValue FROM dbo.r_ProdValues rpv WHERE rpv.VarName LIKE 'r01%' AND rpv.ProdID = p.ProdID) Instruct
		,(SELECT VarValue FROM dbo.r_ProdValues rpv WHERE rpv.VarName LIKE 'r01%' AND rpv.ProdID = p.ProdID) AltName
	 FROM #Baze p WHERE [Внешний код] is null 
	 AND p.ProdID NOT IN (SELECT [Внешний код] FROM #Menu_ALL)
     -- [CHANGED] '2021-04-30 18:26' rkv0 добавил в исключение Бизнес-ланч 2 и 3.
     AND p.ProdID NOT IN (605229, 605230)
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Товары, которые должны быть АКТИВНЫ в RKeeper*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT TOP 1 1 FROM #Baze WHERE ProdID NOT IN (SELECT [Внешний код] FROM #Menu)
        -- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
        AND ProdID NOT IN (N'605229', N'605230') ----Бизнес-ланч 2 и 3.
    ) 
BEGIN
	SELECT 'Товары, которые должны быть АКТИВНЫ в RKeeper' 'проверка'
	SELECT Категория, Группа, [Внешний код], Название, ProdID, ProdName
	,(select ProdName from r_prods rp where rp.ProdID = p.ProdID) 'Длинное название > 40 символов'
	,'' 'Заполни короткое название до 40 символов'
	, baze_Основная, [baze_Балоньез летняя], [baze_Летняя площадка], [Путь по группам]
	, str_Основная, [str_Балоньез летняя], [str_Детская площадка], [str_Летняя площадка]
	, menu_Основная, [menu_Балоньез летняя], [menu_Детская площадка], [menu_Летняя площадка]
	, p71, л2_76, л1_77, Статус, [Налоговая группа], baze_Акциз, Norma5, Norma4, baze_Налог
	, [для акций], [для предчеков], Классификация, [Отдел ФР], [Сервис печать], Категория, Группа
	 FROM #Baze p 
     WHERE p.ProdID NOT IN (SELECT [Внешний код] FROM #Menu)
     -- [CHANGED] '2021-04-30 18:26' rkv0 добавил в исключение Бизнес-ланч 2 и 3.
     AND p.ProdID NOT IN (605229, 605230)
	 
	 SELECT  ProdID, (select ProdName from r_prods rp where rp.ProdID = p.ProdID) 'Длинное название > 40 символов'	,'' 'Заполни короткое название до 40 символов'
	 FROM #Baze p 
     WHERE 1 = 1
        AND p.ProdID NOT IN (SELECT [Внешний код] FROM #Menu) and ProdName like '%ДОБАВЬТЕ "r01 - Короткое название для RKeeper" во вкладку Значения%'
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Товары, которых не должно быть в RKeeper*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT TOP 1 1 FROM #Baze 
            WHERE 1 = 1
            AND (ProdID IS NULL  and (p71 + л2_76 + л1_77) > 0 )
            -- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
            AND ([Внешний код] NOT IN (134, 135, 136, 137) OR str_Основная NOT IN ('129,9', '159,9'))
) 
BEGIN
	SELECT 'Товары, которых не должно быть в RKeeper' 'проверка'
	SELECT * FROM #Baze 
    WHERE (ProdID IS NULL  and (p71 + л2_76 + л1_77) > 0 )
    -- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
    AND ([Внешний код] NOT IN (134, 135, 136, 137) OR str_Основная NOT IN ('129,9', '159,9'))

END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Проверка включенных торговых групп*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE
	(
    (CASE WHEN baze_Основная IS NULL THEN 0 ELSE 1 END) <>  p71 --торговая группа в ркипере не равна состоянию в базе
	OR 
	(CASE WHEN [baze_Балоньез летняя] IS NULL THEN 0 ELSE 1 END) <>  л2_76 --торговая группа в ркипере не равна состоянию в базе
	OR 
	(CASE WHEN [baze_Летняя площадка] IS NULL THEN 0 ELSE 1 END) <>  л1_77 --торговая группа в ркипере не равна состоянию в базе
    )
    -- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
    AND [Внешний код] NOT IN (134, 135, 136, 137)
) 
BEGIN
	-- [ADDED] Maslov Oleg '2020-12-21 13:32:52.420' Долго же я разбирался чтобы понять, что хочет эта проверка. Хватит это терпеть!
    -- [FIXED] rkv0 '2021-01-29 17:20' добавил к CASE WHEN IS NULL OR ... = 0
	SELECT 'Проверка включенных торговых групп' AS 'проверка' UNION
	SELECT 'Если в поле "Основная в ElitR" стоит значение "Включен",' UNION
	SELECT 'то и в поле "Основная в RKeeper" должно быть "Включен".' UNION
	SELECT 'Нужно вкл\выкл галочки.'
	SELECT [Внешний код] AS 'Внешний код в RKeeper', [Название] AS 'Название в RKeeper'
		  ,ProdID AS 'Код товара ElitR', ProdName AS 'Название товара ElitR'
		  ,CASE WHEN [baze_Основная] IS NULL THEN 'Исключен' ELSE 'Включен' END AS 'Основная в ElitR'
		  ,CASE WHEN p71 IS NULL OR p71 = 0 THEN 'Исключен' ELSE 'Включен' END AS 'Основная в RKeeper'
		  ,CASE WHEN [baze_Балоньез летняя] IS NULL THEN 'Исключен' ELSE 'Включен' END AS 'Балоньез в ElitR'
		  ,CASE WHEN л2_76 IS NULL OR л2_76 = 0 THEN 'Исключен' ELSE 'Включен' END AS 'Балоньез в RKeeper'
		  ,CASE WHEN [baze_Летняя площадка] IS NULL THEN 'Исключен' ELSE 'Включен' END AS 'Летняя площадка в ElitR'
		  ,CASE WHEN л1_77 IS NULL OR л1_77 = 0 THEN 'Исключен' ELSE 'Включен' END AS 'Летняя площадка в RKeeper'
	FROM #Baze WHERE
	(
    (CASE WHEN baze_Основная IS NULL THEN 0 ELSE 1 END) <>  p71 --торговая группа в ркипере не равна состоянию в базе
	OR 
	(CASE WHEN [baze_Балоньез летняя] IS NULL THEN 0 ELSE 1 END) <>  л2_76 --торговая группа в ркипере не равна состоянию в базе
	OR 
	(CASE WHEN [baze_Летняя площадка] IS NULL THEN 0 ELSE 1 END) <>  л1_77 --торговая группа в ркипере не равна состоянию в базе
    )
    -- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
    AND ([Внешний код] NOT IN (134, 135, 136, 137) OR str_Основная NOT IN ('129,9', '159,9'))

	--(CASE WHEN baze_Основная IS NULL THEN 0 ELSE 1 END) <>  p71 --торговая группа в ркипере не равна состоянию в базе
	--and p71 = 1
	--OR 
	--(CASE WHEN [baze_Балоньез летняя] IS NULL THEN 0 ELSE 1 END) <>  л2_76 --торговая группа в ркипере не равна состоянию в базе
	--and л2_76 = 1
	--OR 
	--(CASE WHEN [baze_Летняя площадка] IS NULL THEN 0 ELSE 1 END) <>  л1_77 --торговая группа в ркипере не равна состоянию в базе
	--and л1_77 = 1
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Проверка цен*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE 
	(
    (menu_Основная <> baze_Основная and p71 = 1 )
	OR 
	([menu_Балоньез летняя] <> [baze_Балоньез летняя] and [menu_Балоньез летняя] <> 0 and л2_76 = 1 )
	OR
	([menu_Детская площадка] <> [baze_Балоньез летняя] and [menu_Детская площадка] <> 0 and л2_76 = 1 )
	OR 
	([menu_Летняя площадка] <> [baze_Летняя площадка] and л1_77 = 1 )
    )
    -- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
    AND ([Внешний код] NOT IN (608779, 608807, 608809, 608811) OR baze_Основная != 0.1)
) 
BEGIN
	SELECT 'проверка цен' 'проверка'
	SELECT * FROM #Baze WHERE 
	--(
	(
    (menu_Основная <> baze_Основная and p71 = 1 )
	OR 
	([menu_Балоньез летняя] <> [baze_Балоньез летняя] and [menu_Балоньез летняя] <> 0 and л2_76 = 1 )
	OR
	([menu_Детская площадка] <> [baze_Балоньез летняя] and [menu_Детская площадка] <> 0 and л2_76 = 1 )
	OR 
	([menu_Летняя площадка] <> [baze_Летняя площадка] and л1_77 = 1 )
    )
	--)
	--and [Внешний код] in (607511,607516,607784,607977,607525,607980,605490,607023,607979,607853,607972,607809,607993,606388,606385,606386,606387,605675,605169,605172,605173,605174,606132,605176,605162,605163,606336,606769,607678,800362,801307,800360,607651,607650,607653,607652,608025,608026,608027,608028,608029,608019,608020,608021,608022,608023,608024,608030,608013,608014,608015,608016,608017,608018)
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Проверка цен разных по 76 прайсу Балоньез*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Проверка налога*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	and ProdID not in (800890,607045,607044,607046,603101,602688,803096,606044,605917,607025,607640,607029,608350)
	--[CHANGED] rkv0 '2021-05-06 13:58' добавил в исключение кальян аналогично остальным кальянам.
    and ProdID not in (605918)
-- [ADDED] '2020-02-19 12:00' rkv0 добавил в исключение 9 товаров (Ровнягина подтвердила изменение группы на НДС-20, позже администраторы сказали, что им так пробивать товары неудобно (например, Вода Моршинская теперь пробивается на баре через Марию). Скорее всего, надо будет пригласить Диму Rkeeper для настройки новой схемы (согласовать с Ровнягиной и админами парка). А изначально Лейла изменила норму 5 с "0" на "1" по большому количеству товаров (9 из них оказались в Rkeeper). Больше деталей см. здесь: "\\s-elit-dp\F\Румянцев\! ЗАЯВКИ\Ровнягина\RE  Налоговые группы в Rkeeper.msg" 
	AND ProdID NOT IN (800196,800197,600373,603417,602341,602999,603000,800311,800207)
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
    -- [FIXED] '2020-03-26 14:26' rkv0 добавил в вывод код товара 608350 (был только в блоке проверки IF EXISTS).
	and ProdID not in (800890,607045,607044,607046,603101,602688,803096,606044,605917,607025,607640,607029,608350)
    --[CHANGED] rkv0 '2021-05-06 13:58' добавил в исключение кальян аналогично остальным кальянам.
    and ProdID not in (605918)
-- [ADDED] '2020-02-19 12:00' rkv0 добавил в исключение 9 товаров (Ровнягина подтвердила изменение группы на НДС-20, позже администраторы сказали, что им так пробивать товары неудобно (например, Вода Моршинская теперь пробивается на баре через Марию). Скорее всего, надо будет пригласить Диму Rkeeper для настройки новой схемы (согласовать с Ровнягиной и админами парка). А изначально Лейла изменила норму 5 с "0" на "1" по большому количеству товаров (9 из них оказались в Rkeeper). Больше деталей см. здесь: "\\s-elit-dp\F\Румянцев\! ЗАЯВКИ\Ровнягина\RE  Налоговые группы в Rkeeper.msg" 
	AND ProdID NOT IN (800196,800197,600373,603417,602341,602999,603000,800311,800207)
	ORDER BY [Налоговая группа],baze_Налог,[Путь по группам],Название
END


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Проверка на украинские буквы*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(
	SELECT TOP 1 1 FROM #Menu WHERE [Название] like '%і%' --Ролл Каліфорнія з вугром 200г, порц.
) 
BEGIN
	SELECT 'проверка на украинские буквы' 'проверка'
	SELECT * FROM #Menu WHERE [Название] like '%і%' --Ролл Каліфорнія з вугром 200г, порц.
END


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Не сходятся названия товаров*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(
	SELECT TOP 1 1 FROM #Menu m WHERE NOT EXISTS(SELECT VarValue FROM r_ProdValues WHERE ProdID = [Внешний код] and varname like 'r01%')
    -- [CHANGED] rkv0 '2021-02-09 17:05' добавил в исключение инфо по комбо блюдам (Бизнес ланч 2 и 3).
    AND m.[Внешний код] NOT IN (134, 135, 136, 137) --select * from #menu WHERE [внешний код] in (134, 135, 136, 137)
) 
BEGIN
     SELECT 'Не сходится названия товаров' 'Проверка', * FROM #Menu m WHERE NOT EXISTS(SELECT VarValue FROM r_ProdValues WHERE ProdID = [Внешний код] and varname like 'r01%')
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Короткое названия товаров*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(
SELECT TOP 1 1 FROM #Baze WHERE len([Название] ) < 9
) 
BEGIN
	SELECT 'короткое названия товаров' 'проверка'
	SELECT * FROM #Baze WHERE len([Название] ) < 9
END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*разные названия товаров первые 9 букв*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(
	--SELECT TOP 1 1 FROM #Baze WHERE cast(REPLACE([Название],'#','') as varchar(9)) <> cast(ProdName as varchar(9))
	SELECT TOP 1 1 FROM #Baze WHERE cast([Название] as varchar(9)) <> cast(ProdName as varchar(9))
) 
BEGIN
	SELECT 'разные названия товаров первые 9 букв' 'проверка'
	SELECT * FROM #Baze WHERE cast([Название] as varchar(9)) <> cast(ProdName as varchar(9))
END


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Разные названия товаров*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE cast([Название] as varchar(40)) <> cast(ProdName as varchar(40))
) 
BEGIN
	SELECT 'разные названия товаров' 'проверка'
	SELECT * FROM #Baze WHERE  cast([Название] as varchar(40)) <> cast(ProdName as varchar(40))
END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Проверка для предчеков*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(
	SELECT TOP 1 1 FROM  #Baze
	--select * from #Baze where [внешний код] = 605068
	WHERE  baze_Налог <>  (case when [для предчеков] = '21 Кухня' then 0  when [для предчеков] = '2021 Бар' and baze_Налог <> '20' then 25  when [для предчеков] = '2021 Бар' and baze_Налог = '20' then 20  else null end )
	and ProdID  IS NOT NULL
	and ProdID not in (602688,603101,606044,607044,607045,607046,800890,803096)
	-- [ADDED] 19.02.2020 rkv0 добавил в исключение 9 товаров (Ровнягина подтвердила изменение группы на НДС-20, позже администраторы сказали, что им так пробивать товары неудобно (например, Вода Моршинская теперь пробивается на баре через Марию). Скорее всего, надо будет пригласить Диму Rkeeper для настройки новой схемы (согласовать с Ровнягиной и админами парка). А изначально Лейла изменила норму 5 с "0" на "1" по большому количеству товаров (9 из них оказались в Rkeeper). Больше деталей см. здесь: "\\s-elit-dp\F\Румянцев\! ЗАЯВКИ\Ровнягина\RE  Налоговые группы в Rkeeper.msg" 
	AND ProdID NOT IN (800196,800197,600373,603417,602341,602999,603000,800311,800207)
) 
BEGIN
	SELECT 'Проверка для предчеков' 'проверка'
	SELECT * FROM #Baze
	WHERE  baze_Налог <>  (case when [для предчеков] = '21 Кухня' then 0  when [для предчеков] = '2021 Бар' and baze_Налог <> '20' then 25  when [для предчеков] = '2021 Бар' and baze_Налог = '20' then 20  else null end )
	and ProdID  IS NOT NULL
	and ProdID not in (602688,603101,606044,607044,607045,607046,800890,803096)
	-- [ADDED] 19.02.2020 rkv0 добавил в исключение 9 товаров (Ровнягина подтвердила изменение группы на НДС-20, позже администраторы сказали, что им так пробивать товары неудобно (например, Вода Моршинская теперь пробивается на баре через Марию). Скорее всего, надо будет пригласить Диму Rkeeper для настройки новой схемы (согласовать с Ровнягиной и админами парка). А изначально Лейла изменила норму 5 с "0" на "1" по большому количеству товаров (9 из них оказались в Rkeeper). Больше деталей см. здесь: "\\s-elit-dp\F\Румянцев\! ЗАЯВКИ\Ровнягина\RE  Налоговые группы в Rkeeper.msg" 
	AND ProdID NOT IN (800196,800197,600373,603417,602341,602999,603000,800311,800207)
	ORDER BY 1
END


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Проверка для группы и категории*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- '2019-06-12 11:55' rkv0 - убрали из проверки кофе (Лейла): это для их удобства.
IF EXISTS(
	SELECT TOP 1 1 FROM  #Baze
	WHERE  [Путь по группам] <>  Категория +'\'+ Группа
	-- [ADDED] '2019-06-12 11:55' rkv0 добавил в исключение 8000 (Услуга доставки курьером)
	and ProdID not in (608230,608231,608232,608233,608234,608235,608236,608237,8000)
    -- [ADDED] '2020-06-12 15:33' rkv0 добавил в исключение кальяны (т.к. были перенесены в отдельную группу по заявке Бышинской).
	and ProdID not in (607025,607029,608350,607640)
    --[CHANGED] rkv0 '2021-05-06 13:58' добавил в исключение кальян аналогично остальным кальянам.
    and ProdID not in (605918)
) 
BEGIN
	SELECT 'Проверка для группы и категории: часть товаров добавлена в исключение (см. комменты)' 'проверка'
	SELECT [Путь по группам] 'Путь по группам в RKeeper', Категория +'\'+ Группа 'ПУТЬ ПО ГРУППАМ В БАЗЕ',* FROM #Baze
	WHERE  [Путь по группам] <>  Категория +'\'+ Группа
	--and ProdID  IS NOT NULL
	-- [ADDED] '2019-06-12 11:55' rkv0 добавил в исключение 8000 (Услуга доставки курьером)
	and ProdID not in (608230,608231,608232,608233,608234,608235,608236,608237,8000)
	-- [ADDED] '2020-06-12 15:33' rkv0 добавил в исключение кальяны (т.к. были перенесены в отдельную группу по заявке Бышинской).
	and ProdID not in (607025,607029,608350,607640)
	--[CHANGED] rkv0 '2021-05-06 13:58' добавил в исключение кальян аналогично остальным кальянам.
    and ProdID not in (605918)
	ORDER BY 1
END


/*
select * from #Baze
--шаблон для импорта новых товаров в Ркипер
SELECT 
(SELECT VarValue FROM dbo.r_ProdValues rpv WHERE rpv.VarName LIKE 'r01%' AND rpv.ProdID = p.ProdID) Name
, p.ProdID ExtCode
,isnull((SELECT cast(PriceMC AS numeric(21,2)) FROM dbo.r_ProdMP mp WHERE mp.plid = 71 AND mp.ProdID = p.ProdID),0) 'Price:Основная'
,(SELECT VarValue FROM dbo.r_ProdValues rpv WHERE rpv.VarName LIKE 'r01%' AND rpv.ProdID = p.ProdID) Instruct
,(SELECT VarValue FROM dbo.r_ProdValues rpv WHERE rpv.VarName LIKE 'r01%' AND rpv.ProdID = p.ProdID) AltName
FROM dbo.r_Prods p WHERE p.ProdID IN (
--вставьте  коды новых товаров
608231,608235,608232,608236,608233,608237,608230,608234
)
*/

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


/*
SELECT * FROM [ElitR].dbo.r_DCards rd	
SELECT * FROM [ElitR_test].dbo.r_DCards rd
*/

END













GO
