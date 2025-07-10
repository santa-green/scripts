USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EDI_add_GLN_auto]    Script Date: 09.08.2021 15:56:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ap_EDI_add_GLN_auto] as
begin
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHECKPOINT 2021-08-04 16:08:34*/
--ТЕСТОВЫЙ РЕЖИМ !!
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DB_NAME() 'db'

--#region [0] CHANGELOG

--#endregion [0] CHANGELOG

--#region [1] Формирование базовой таблицы с GLN.

BEGIN

    IF OBJECT_ID (N'tempdb..#N', N'U') IS NOT NULL
	    DROP TABLE #N

    SELECT TOP(1) 
           LTRIM(RTRIM(REPLACE(rc.GLNCode, CHAR(9), '')))  'GLN_address_CODE'
    ,      (SELECT VarValue FROM [s-sql-d4].[elit].dbo.r_CompValues WHERE CompID = rc.CompID and VarName = 'base_gln')  'GLN_base_CODE'
    ,      rc.CompAddID 'CompAddID'
    ,      rc.CompGrID2 'CompGrID2'
    ,      rc.CompID 'COMP_ID'
    ,      (SELECT CodeID2 FROM [s-sql-d4].[elit].dbo.r_comps WHERE compid = rc.CompID) 'CodeID2'
    --,      (SELECT ZEO_ZEC_ADD FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_NUMBER = rc.GLNCode) 'GLN_CODE'
    --,      '9864232465362' 'GLN_CODE'
    INTO #N
    FROM      [s-sql-d4].[elit].dbo.r_CompsAdd                      rc
    LEFT JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT ag ON (
			    rc.CompID = ag.ZEC_KOD_KLN_OT
			    and rc.GLNCode = ag.ZEC_KOD_ADD)
    WHERE rc.GLNCode not in ('', '0')
	    and ag.ZEC_KOD_ADD IS NULL
        and rc.compid NOT BETWEEN 10790 AND 10795 --фильтруем Винтаж.

    SELECT * FROM #N
    IF NOT EXISTS (SELECT * FROM #N) RETURN

END;

--#endregion [1] Формирование базовой таблицы с GLN.

--#region [2] Добавить базовый GLN (rkv0 '2021-08-06 15:56' допилить как появится новый живой GLN)
/*
BEGIN--подобрать CompID и добавить ему BASE_GLN
    
SELECT 'Добавить базовый GLN. Базовый GLN должен быть только один!' '[2]'
SELECT 'Запустить скрипты в строчках где совпадают поля GLNName и RefName после =>' '[2.1]'
    
SELECT DISTINCT m.ZEO_ORDER_NUMBER                                                                                                                                              
,               m.ZEO_ORDER_DATE                                                                                                                                                
,               m.ZEO_ZEC_BASE                                                                                                                                                  
,               (SELECT TOP(1) GLNName
FROM [S-SQL-D4].Elit.dbo.at_gln p1
where p1.GLN = m.ZEO_ZEC_BASE) as            'GLNName'
,               g.RefID                                                                                                                                                         
,               g.RefName                                                                                                                                                       
,               g.Notes                                                                                                                                                         
,               (SELECT top(1) VarValue
FROM [S-SQL-D4].Elit.dbo.r_CompValues p
where p.CompID = g.RefID
	and p.VarName = 'BASE_GLN') as          'GLN уже есть'
,               'INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ('+cast(g.RefID as varchar)+',''BASE_GLN'','''+cast(m.ZEO_ZEC_BASE as varchar)+''')' as 'Выбрать правильные строки по RefName и GLNName'
FROM        dbo.ALEF_EDI_ORDERS_2 m
cross apply (
	SELECT *
	FROM [S-SQL-D4].Elit.dbo.r_uni
	where RefTypeID = 6680117
		and isnumeric(notes) = 1
		and cast(notes as int) in (SELECT RefID
		FROM [S-SQL-D4].Elit.dbo.r_uni
		where RefTypeID = 6680116
			and notes = '1')
		and cast(notes as int) <> 0
		and Notes in (SELECT TOP 1 RetailersID
		FROM [S-SQL-D4].Elit.dbo.at_gln p1
		where p1.GLN = m.ZEO_ZEC_BASE)
	)                             g
WHERE NOT EXISTS (SELECT TOP(1) 1
	FROM ALEF_EDI_GLN_OT s1
	WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE
		and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD)
	AND ZEO_ORDER_STATUS NOT IN (33,4,5)
	AND (SELECT RetailersID
	FROM [S-SQL-D4].Elit.dbo.at_gln p1
	where p1.GLN = m.ZEO_ZEC_BASE) in
	(
	SELECT distinct cast(notes as int)
	FROM [S-SQL-D4].Elit.dbo.r_uni
	where RefTypeID = 6680117
		and isnumeric(notes) = 1
		and cast(notes as int) in (SELECT RefID
		FROM [S-SQL-D4].Elit.dbo.r_uni
		where RefTypeID = 6680116
			and notes = '1')
		and cast(notes as int) <> 0
	)
	AND m.ZEO_AUDIT_DATE > DATEADD(day, -10, getdate()) -- только заказы не старше 10 дней
	AND m.ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
	FROM #N)
ORDER BY ZEO_ZEC_BASE

END;
*/
--#endregion [2] Добавить базовый GLN (rkv0 '2021-08-06 15:56' допилить как появится новый живой GLN)

--#region [2.1] Лог добавлений базовых GLN
/*
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (59318,'BASE_GLN','9864066959136')
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7161,'BASE_GLN','9864232211587')
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (66803,'BASE_GLN','9864232435242') --Толиман Плюс (Чудо/Колос).
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7160,'BASE_GLN','9864232419938') --Копейка (Модерн-Ритейл).
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (58103,'BASE_GLN','9864066866014') --Эпицентр (Кировоград).
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (9022,'BASE_GLN','9864232300410') --РС Точка.
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7134,'BASE_GLN','9863577638028') --Новус (Союз Ритейл).
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (56005,'BASE_GLN','9864066866014') --Эпицентр ПЕРВОМАЙСК.
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (75137,'BASE_GLN','9864066866014') --Эпицентр МЕЛИТОПОЛЬ.
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (66772,'BASE_GLN','9864232375777') --Дигма (ООО "Люксопт")
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (66774,'BASE_GLN','9864232375685') --КОЛОС/ЧУДО ТОВ "ТАЛАСА ТРЕЙД"
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (72226,'BASE_GLN','9864066866014') --Эпицентр ЛЬВОВ
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (71746,'BASE_GLN','9864066866014') --Эпицентр КИЕВ (Винница)
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (66743,'BASE_GLN','9864232355472') --КОЛОС/ЧУДО ТОВ "АРТЕМІДА СХІД"
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (66385,'BASE_GLN','9864066853281') --КОЛОС/ЧУДО ТОВ Дивия Трейд
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (72165,'BASE_GLN','9864232350330') --ОККО-Нафтопродукт ТОВ «ОККО-ДРАЙВ» (Львов); замена старых юрлиц.
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (71711,'BASE_GLN','9864232350330') --ОККО-Нафтопродукт ТОВ «ОККО-ДРАЙВ» (Киев); замена старых юрлиц.
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7156,'BASE_GLN','9864232359616') --РОСТ ТОВ «ДИСТРИБУЦІЙНО-ЛОГІСТИЧНА КОМПАНІЯ «ПІЛОТ» (вместо 4-х старых юрлиц)
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (66559,'BASE_GLN','9864066980598') --ГВЕДЕОН (сеть "Семья")
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7117,'BASE_GLN','4820123566124') --Фуршет ДП "Рітейл Центр"
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (65867,'BASE_GLN','9864066918782') --Легион-2015(Пчелка Маркет)
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7060,'BASE_GLN','4820038509612') --Львівхолод
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7155,'BASE_GLN','9864232128281') --АРІТЕЙЛ (сеть "КОЛО")
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7138,'BASE_GLN','4829900023799') --Розетка.УА ТОВ  ТОВ "Розетка.УА" (вода)
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7136,'BASE_GLN','4829900024055') --Розетка.УА ТОВ  "ТОРГОВИЙ ДІМ "МЕДІАТРЕЙДІНГ" (алкоголь)
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7031,'BASE_GLN','9863577638028') --Новус Украина ТОВ «Новус Україна»
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (71520,'BASE_GLN','9864060910836') --ОККО-Нафтопродукт ТОВ ОККО-Схід (Львов)
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (71521,'BASE_GLN','9864232210368') --ОККО-Нафтопродукт ТОВ “Зіра-Консалт” (Львов)
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (70953,'BASE_GLN','9864066927104') --ОККО-Нафтопродукт ТЗОВ "ОККО-РІТЕЙЛ" (Львов)
INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (71522,'BASE_GLN','9864066927104') --ОККО-Нафтопродукт ТЗОВ "ОККО-РІТЕЙЛ" (Киев)
*/
--#endregion [2.1] Лог добавлений базовых GLN

--#region [3] ДОБАВЛЕНИЕ НОВОГО АДРЕСА
BEGIN TRAN

IF 1=1
BEGIN
--#region [3.1] ТАБЛИЦА №1 - ALEF_EDI_GLN_OT

--добавляем новый адрес в таблицу №1 dbo.ALEF_EDI_GLN_OT (KOD_BASE - базовый GLN, KOD_ADD - GLN адреса доставки, KOD_KLN_OT - код контрагента, KOD_ADD_OT - ID адреса доставки, KOD_SKLAD_OT - код нашего склада, STATUS - default 1)
--[ADDED] rkv0 '2020-08-26 14:28' добавил проверку для сети ОККО, т.к. одно предприятие разделено условно на 2: Киев, Львов.
SELECT 'ДОБАВЛЕНИЕ НОВОГО АДРЕСА' '[3]'
SELECT 'ТАБЛИЦА №1 - SELECT: ALEF_EDI_GLN_OT' '[3.1]'
INSERT INTO dbo.ALEF_EDI_GLN_OT
OUTPUT inserted.*
SELECT (/*select top 1 ZEO_ZEC_BASE
from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
	FROM #N)*/ SELECT GLN_base_CODE FROM #N) 'ZEC_KOD_BASE'
,      (/*select top 1 ZEO_ZEC_ADD
from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
	FROM #N)*/ SELECT GLN_address_CODE FROM #N) 'ZEC_KOD_ADD'
--[CHANGED] rkv0 '2020-08-26 14:27' в виде исключения для сети ОККО выбираем один CompID (одно предприятие разделено условно на 2: Киев, Львов).
--,(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) ZEC_KOD_KLN_OT
--,(SELECT MAX(CompID) FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) ZEC_KOD_KLN_OT
,      (SELECT COMP_ID
FROM #N)      'ZEC_KOD_KLN_OT'
,      (/*select CompAddID
from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK)
WHERE GLNCode = (select top 1 ZEO_ZEC_ADD
	from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
	where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
		FROM #N))
	and CompID = (SELECT COMP_ID
	FROM #N) /*(SELECT top 1 CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues p where p.VarName = 'BASE_GLN' and p.VarValue =
		    (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))	)*/
*/ SELECT CompAddID FROM #N)             'ZEC_KOD_ADD_OT'
--если другой адрес то коментируем сверху и разкоментируем снизу и вписываем правильный код адреса
--, 17 ZEC_KOD_ADD_OT
,      case (
    select CompGrID2 FROM #N
/*
	select CompGrID2
	from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK)
	--/*test*/ select CompGrID2,*  from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK) where CompID = 71520
	where CompID = (SELECT COMP_ID
		FROM #N) --in ((SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))))
		and GLNCode = (select top 1 ZEO_ZEC_ADD
		from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
		where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
			FROM #N))
	*/
    )
--[CHANGED] '2021-03-31 16:15' rkv0 изменил привязку склада для CompGrID2: 30 - если подразделение в Условиях работы(АТ) = 10000, 220 - остальные.
--when 2030 then 220 --склад НАЦСЕТЕЙ Киев
when 2030 then (CASE WHEN (SELECT DepID
		FROM [S-SQL-D4].[ELIT].dbo.av_at_r_CompOurTerms1 WITH(NOLOCK)
		WHERE compid = (SELECT COMP_ID
			FROM #N)) = 10000 THEN 30 --склад общий Киев
	                          ELSE 220 --склад НАЦСЕТЕЙ Киев
	END)
when 2031 then 4 --склад общий Днепр
when 2034 then 23 --склад общий Одесса
when 2035 then 27 --склад общий Львов
when 2036 then 11 --склад общий Харьков
when 2048 then 85 --склад общий Черкассы
when 2048 then 85 --склад общий Черкассы
-- [ADDED] rkv0 '2021-06-02 17:48' добавил группу 2081.
when 2081 then 23 --склад общий Одесса (Эпицентр Николаев)
--[ADDED] rkv0 '2020-11-23 18:25' новая группа предприятий 2032 "Запорожье дистрибуция".
when 2032 then 4 --склад общий Днепр
-- [ADDED] '2020-03-25 14:44' rkv0 добавлен киевский склад №30 (не нацсети) для Легиона
          else case when /*ISNULL((select top 1 ZEO_ZEC_BASE
		from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
		where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
			FROM #N)),0) = '9864066918782' then 30 --склад общий Киев*/
			(SELECT GLN_base_CODE FROM #N) = '9864066918782' then 30 --склад общий Киев
	-- [ADDED] '2020-04-24 10:10' rkv0 добавлен харьковский склад для Гведеон/Семья.
	                /*when ISNULL((select top 1 ZEO_ZEC_BASE
		from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
		where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
			FROM #N)),0) = '9864066980598' then 11 --склад общий Харьков (Гведеон/Семья)*/
			when (SELECT GLN_base_CODE FROM #N) = '9864066980598' then 11 --склад общий Харьков (Гведеон/Семья)
	-- [ADDED] '2020-04-28 14:17' rkv0 добавлен киевский склад для Ридо Групп (Пчелка).
	                /*when ISNULL((select top 1 ZEO_ZEC_BASE
		from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
		where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
			FROM #N)),0) = '9864232279860' then 30 --склад общий Киев*/
			when (SELECT GLN_base_CODE FROM #N) = '9864232279860' then 30 --склад общий Киев
	-- [ADDED] '2021-04-19 17:11' rkv0 добавлен одесский склад для Модерн-Ритейл.
	                /*when ISNULL((select top 1 ZEO_ZEC_BASE
		from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
		where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
			FROM #N)),0) = '9864232419938' then 23 --склад общий Одесса (Модерн-Ритейл)*/
			when (SELECT GLN_base_CODE FROM #N) = '9864232419938' then 23 --склад общий Одесса (Модерн-Ритейл)
	end end   'ZEC_KOD_SKLAD_OT'
,      1      'ZEC_STATUS'

--#region [3.1] ТАБЛИЦА №1 - ALEF_EDI_GLN_OT

--#region [3.2] ТАБЛИЦА №2 - ALEF_EDI_GLN_SETI
--добавляем новый адрес в таблицу №2 dbo.ALEF_EDI_GLN_SETI (EGS_GLN_SETI_ID - ID сети)
--[CHANGED] -6 полей- rkv0 '2020-08-26 14:27' в виде исключения для сети ОККО выбираем один CompID (одно предприятие разделено условно на 2: Киев, Львов).
SELECT 'ТАБЛИЦА №2 - SELECT: ALEF_EDI_GLN_SETI' '[3.2]'

;WITH union_cte as (--для ОККО изменить на SELECT TOP(1)* FROM.
SELECT 
/*(select top(1) ZEO_ZEC_ADD
from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
	FROM #N))      'EGS_GLN_ID'*/
	(SELECT GLN_address_CODE FROM #N)      'EGS_GLN_ID'
/*,      (SELECT Adress
FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK)
where GLN in (select top(1) ZEO_ZEC_ADD
	from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
	where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
		FROM #N))) 'EGS_GLN_NAME' --ищем в справочнике предприятий адрес доставки на вкладке Адреса доставки*/
,		(SELECT Adress
FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK)
where GLN = (SELECT GLN_address_CODE FROM #N)) 'EGS_GLN_NAME' --ищем в справочнике предприятий адрес доставки на вкладке Адреса доставки
       --, '95 Гіпермаркет, м.Миколаїв-3' 'EGS_GLN_NAME'
-- [ADDED] '2020-03-25 14:44' rkv0 добавлен ID сети 998 (Легион)
,      case when (/*SELECT CodeID2
	FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH(NOLOCK)
	where compid =
		--(SELECT MAX(CompID) FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		(SELECT COMP_ID
		FROM #N)
	*/ Select CodeID2 FROM #N) = 0   then 998
            else (/*SELECT CodeID2
	FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK)
	where compid =
		--(SELECT MAX(CompID) FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		(SELECT COMP_ID
		FROM #N)
	*/Select CodeID2 FROM #N) end          'EGS_GLN_SETI_ID' -- ищем в справочнике предприятий на вкладке Дополнительно поле Код признака 2
,      null        'EGS_STATUS'

UNION ALL

SELECT /*(select top(1) ZEO_ZEC_BASE
from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
	FROM #N))      'EGS_GLN_ID'*/
(SELECT GLN_base_CODE FROM #N)      'EGS_GLN_ID'

/*,      (SELECT GLNName
FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK)
where GLN in (select top 1 ZEO_ZEC_BASE
	from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK)
	where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER
		FROM #N))) 'EGS_GLN_NAME' --берем короткое название с сайта Edi-n.com*/
,      (SELECT GLNName
FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK)
where GLN = (Select GLN_base_CODE FROM #N)) 'EGS_GLN_NAME' --берем короткое название с сайта Edi-n.com

-- [ADDED] '2020-03-25 14:44' rkv0 добавлен ID сети 998 (Легион)
,      case when (/*SELECT CodeID2
	FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK)
	where compid =
		--(SELECT MAX(CompID) FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		(SELECT COMP_ID
		FROM #N)
	*/ SELECT CodeID2 FROM #N) = 0   then 998
            else (/*SELECT CodeID2
	FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK)
	where compid =
		--(SELECT MAX(CompID) FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		(SELECT COMP_ID
		FROM #N)
	*/ SELECT CodeID2 FROM #N) end          'EGS_GLN_SETI_ID' -- ищем в справочнике предприятий на вкладке Дополнительно поле Код признака 2
,      null        'EGS_STATUS'
)
-- [ADDED] '2020-03-25 14:44' rkv0 добавлен ID сети 998 (Легион)
INSERT INTO dbo.ALEF_EDI_GLN_SETI
OUTPUT inserted.*
SELECT * FROM union_cte where EGS_GLN_ID not in (
	SELECT EGS_GLN_ID
	FROM dbo.ALEF_EDI_GLN_SETI WITH(NOLOCK)
	where EGS_GLN_SETI_ID = (SELECT CASE WHEN (/*SELECT CodeID2
			FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH(NOLOCK)
			where compid =
				(SELECT COMP_ID
				FROM #N)
			*/ SELECT CodeID2 FROM #N) = 0                        then 998
		                                 else (/*SELECT CodeID2
			FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH(NOLOCK)
			where compid =
				(SELECT COMP_ID
				FROM #N)
			*/ SELECT CodeID2 FROM #N) end)
	)

--[CHANGED] -6 полей- rkv0 '2020-08-26 14:27' в виде исключения для сети ОККО выбираем один CompID (одно предприятие разделено условно на 2: Киев, Львов).
    --#endregion [4.2] ТАБЛИЦА №2 - ALEF_EDI_GLN_SETI
END;

COMMIT TRAN
--ROLLBACK TRAN

--#endregion [3] ДОБАВЛЕНИЕ НОВОГО АДРЕСА

--#region [4] Проверка на подвязку кодов.

/*CREATE TABLE ALEF_EDI_EXTCODES_CHECK (NewCompID int, EmailStatus bit)
ALTER TABLE ALEF_EDI_EXTCODES_CHECK  ALTER COLUMN NewCompid int not NULL
ALTER TABLE ALEF_EDI_EXTCODES_CHECK  ADD CONSTRAINT UC_COMPID UNIQUE (NewCompID)
ALTER TABLE ALEF_EDI_EXTCODES_CHECK  ADD CONSTRAINT PK_COMPID PRIMARY KEY (NewCompID)
*/

IF (SELECT COMP_ID FROM #N) IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT TOP 1 1 FROM [s-sql-d4].[elit].dbo.r_prodec WHERE compid = (SELECT COMP_ID FROM #N))
        AND
        NOT EXISTS (SELECT TOP 1 1 FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_EXTCODES_CHECK WHERE NewCompID = (SELECT COMP_ID FROM #N))
    BEGIN

        DECLARE @subject varchar(max) = 'Новое предприятие в EDI. Не подвязаны внешние коды по новому предприятию EDI: ' + 
            CAST((SELECT COMP_ID FROM #N) AS varchar)
        EXEC msdb.dbo.sp_send_dbmail @profile_name       = 'arda'
        ,                            @from_address       = '<support_arda@const.dp.ua>'
        ,                            @recipients         = 'tumaliieva@const.dp.ua'
        --,                            @recipients         = 'rumyantsev@const.dp.ua'
        ,                            @copy_recipients    = 'support_arda@const.dp.ua'
        ,                            @subject            = @subject
        ,                            @body               = 'Это автоматическое уведомление [Добавление GLN_auto.sql]'
        --,                            @body_format        = 'HTML'
        ,                            @append_query_error = 1

        INSERT INTO ALEF_EDI_EXTCODES_CHECK SELECT COMP_ID, 1 FROM #N; --Статус 1 - email отправлен.

    END;
END;
--#endregion [4A] Проверка на подвязку кодов.

--#region [5] ФИНАЛЬНАЯ ПРОВЕРКА НА ДУБЛИ
-- [ADDED] '2020-04-21 16:33' rkv0 добавлена дополнительная проверка на дубликаты (их не должно быть).

--Вариант №1.
/*DECLARE @query nvarchar(max) 
SET @query = 'SELECT CompID,GLNCode,count(*) ''dubli'' FROM  [S-SQL-D4].Elit.dbo.r_CompsAdd where GLNCode <> '''' group by CompID,GLNCode having count(*) > 1'
SET @query = 'IF NOT EXISTS (' + @query + ') SELECT ''SUCCESS - Дубликатов нет.'' ELSE ' + @query
EXEC (@query)*/

--Вариант №2.
IF NOT EXISTS (SELECT CompID,GLNCode,count(*) 'dubli' FROM  [S-SQL-D4].Elit.dbo.r_CompsAdd where GLNCode <> '' group by CompID,GLNCode having count(*) > 1) SELECT 'SUCCESS - Дубликатов нет.'
    ELSE SELECT CompID,GLNCode,count(*) 'dubli' FROM  [S-SQL-D4].Elit.dbo.r_CompsAdd where GLNCode <> '' group by CompID,GLNCode having count(*) > 1 ORDER BY CompID DESC
--#endregion [5] ФИНАЛЬНАЯ ПРОВЕРКА НА ДУБЛИ

--#region [6] Перезаливка заказа (ручной режим).
--TRAN

/*
IF 1 = 0
BEGIN
    BEGIN TRAN
    
    --DECLARE @glncode varchar(30) = '9864232440321'
    --SELECT * FROM ALEF_EDI_ORDERS_2 m WHERE m.ZEO_ZEC_ADD = @glncode
    --SELECT * FROM ALEF_EDI_ORDERS_2 m WHERE m.ZEO_ZEC_ADD = @glncode

        --DECLARE @order varchar(max) = '323658'
        DECLARE @ZEO_ORDER_ID varchar(max) = (SELECT ZEO_ORDER_ID FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_NUMBER = @order)
        SELECT * FROM ALEF_EDI_ORDERS_CHANGES WHERE EOC_ORDER_ID = @ZEO_ORDER_ID

        INSERT INTO ALEF_EDI_ORDERS_CHANGES (EOC_ORDER_ID, EOC_CH_DATE,EOC_TYPE, EOC_POS, EOC_CH_DATA, EOC_COMMITTED, EOC_EMP)
        VALUES 
        (@ZEO_ORDER_ID, CURRENT_TIMESTAMP, 1, 0, '2021-12-31', 0, 7277) --изменение даты.
        ,(@ZEO_ORDER_ID, CURRENT_TIMESTAMP, 200, 0, '0', 0, 7277) --перезаливка.

        SELECT * FROM ALEF_EDI_ORDERS_CHANGES WHERE EOC_ORDER_ID = @ZEO_ORDER_ID
    ROLLBACK TRAN
END;
*/

--#endregion [8] Перезаливка заказа (ручной режим).

--#region [7] Проверка несовпадения кодов в адресах доставки r_CompsAdd и таблице ALEF_EDI_GLN_OT.
IF EXISTS (
SELECT TOP 1 1 FROM [s-sql-d4].[elit].dbo.r_CompsAdd rc
JOIN ALEF_EDI_GLN_OT ag ON (rc.CompID = ag.ZEC_KOD_KLN_OT and rc.GLNCode = ag.ZEC_KOD_ADD)
WHERE rc.GLNCode not in ('', '0')
and rc.CompAddID <> ag.ZEC_KOD_ADD_OT
--добавляем исключения (здесь коды переподвязаны из-за новых адресов - старый удалять нельзя).
and CompID NOT IN (7013,65867,71520,71522,71527)
and GLNCode NOT IN ('4820069609916', '9864066921706', '9864066921713', '9864066921720', '9864066921744', '9864066921751', '9864066921768', '9864066934928', '9864066950836', '9864066998999', '9864232153122', '9864232169635', '9864232190936', '9864232210207', '9864232264736', '9864232266822', '9864232283584', '9864232291466', '9864232303220', '9864232322979', '9864232331537', '9864232335580', '9864232350422', '9864232354420', '9864232356936', '9864232368380', '9864232399377', '9864232428572', '9864232440413')
)
BEGIN
    EXEC msdb.dbo.sp_send_dbmail  
        @profile_name = 'arda',
        @from_address = '<support_arda@const.dp.ua>',
        @recipients = 'rumyantsev@const.dp.ua',
        --@copy_recipients = 'support_arda@const.dp.ua',
        @subject = 'Обнаружены несовпадения кодов в адресах доставки r_CompsAdd и таблице ALEF_EDI_GLN_OT',
        @body = 'Job: GLN_AUTO_ADD',  
        @body_format = 'HTML',
        @append_query_error = 1
END;
--#endregion [7] Проверка несовпадения кодов в адресах доставки r_CompsAdd и таблице ALEF_EDI_GLN_OT.

end;

GO
