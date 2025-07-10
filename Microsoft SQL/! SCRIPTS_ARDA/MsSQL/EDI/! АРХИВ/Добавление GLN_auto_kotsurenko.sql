/* ОПИСАНИЕ: Данный скрипт добавляет новый GLN / изменяет адрес GLN / добавляет новую сеть*/
USE Alef_Elit --S-PPC

/*1 Сеть хочет работать с нами в EDI
после согласования документов и сценария работы
добавляем новую сеть в справочники

--/*Справочник универсальный*/EDI - Справочник партнеров
SELECT * FROM [S-SQL-D4].Elit.dbo.[r_UniTypes] where  RefTypeID = 6680116
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and RefID = 9

INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680116,16508,'Класс','1')
--или если уже сеть добавлена то меняем поле Notes на 1
update [S-SQL-D4].Elit.dbo.r_uni set Notes = '1' where  RefTypeID = 6680116 and RefID = 16508

--/*Справочник универсальный*/EDI - Спраовчник соответствия кодов предприятий и сетей (по EDI)
SELECT * FROM [S-SQL-D4].Elit.dbo.[r_UniTypes] where  RefTypeID = 6680117
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 and Notes = '9'

INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7079,'УКР-ТРЕЙД Общество  с ограниченной ответственностью (Укр-Трейд) => сеть КЛАСС','16508')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7088,'Мега-Трейд Торговая компания Общество с ограниченной ответственностью (Мегатрейд) => сеть КЛАСС','16508')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7095,'АЛЬФА-ПРОДУКТ  Общество с ограниченной  ответственностью (Альфа-Продукт) => сеть КЛАСС','16508')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7114,'Гранд-Маркет Компания Общество с ограниченой ответственностью (Грандмаркет) => сеть КЛАСС','16508')

--/*Справочник универсальный*/EDI - Допустимые типы  документов по сетям
SELECT * FROM [S-SQL-D4].Elit.dbo.[r_UniTypes] where  RefTypeID = 80019
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 80019 and RefID in (7004)

INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7079,'УКР-ТРЕЙД Общество  с ограниченной ответственностью (Укр-Трейд) => сеть КЛАСС','ORDERS,DESADV')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7088,'Мега-Трейд Торговая компания Общество с ограниченной ответственностью (Мегатрейд) => сеть КЛАСС','ORDERS,DESADV')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7095,'АЛЬФА-ПРОДУКТ  Общество с ограниченной  ответственностью (Альфа-Продукт) => сеть КЛАСС','ORDERS,DESADV')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7114,'Гранд-Маркет Компания Общество с ограниченой ответственностью (Грандмаркет) => сеть КЛАСС','ORDERS,DESADV')

--/*Справочник предприятий - Вкладка Значения*/ добавляем к предприятиям привязку базового GLN
select c.CompID, CompName, CompShort, Address, case when cv.VarName <> '' then cv.VarName 
else 'insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ('+cast(c.CompID as varchar)+',''BASE_GLN'','''')' end VarName 
, VarValue from [S-SQL-D4].Elit.dbo.r_Comps c 
left join [S-SQL-D4].Elit.dbo.r_CompValues cv on cv.CompID = c.CompID and cv.VarName = 'BASE_GLN'
WHERE c.compid in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 and Notes = '9')

SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln ORDER BY ImportDate desc

insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7088,'BASE_GLN','')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7095,'BASE_GLN','9864232185048')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7114,'BASE_GLN','')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (64030,'BASE_GLN','9863569647762')

ждем новых заказов
*/

IF OBJECT_ID (N'tempdb..#N', N'U') IS NOT NULL DROP TABLE #N
CREATE TABLE #N (ORDER_NUMBER varchar(max))
INSERT #N (ORDER_NUMBER) VALUES (
--Номер заказа
'4512583234'
)
(SELECT ORDER_NUMBER FROM #N)


--подобрать CompID и добавить ему BASE_GLN
SELECT 'запустить скрипты в строчках где совпадают поля GLNName и RefName после =>'
SELECT 'Базовый GLN должен быть только один!'
select distinct  m.ZEO_ORDER_NUMBER,m.ZEO_ORDER_DATE,m.ZEO_ZEC_BASE
,(SELECT TOP 1 GLNName FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) GLNName
,g.RefID,g.RefName,g.Notes
,(SELECT top 1 VarValue FROM [S-SQL-D4].Elit.dbo.r_CompValues p where p.CompID = g.RefID and p.VarName = 'BASE_GLN') 'GLN уже есть'
,'insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ('+cast(g.RefID as varchar)+',''BASE_GLN'','''+cast(m.ZEO_ZEC_BASE as varchar)+''')' 'выбрать правильные строки по RefName и GLNName'
from dbo.ALEF_EDI_ORDERS_2 m
cross apply (SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
	and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
	and cast(notes as int) <> 0
	and Notes in (SELECT TOP 1 RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) 
) g 
where  
NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
ZEO_ORDER_STATUS NOT IN (33,4,5)
and (SELECT RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) in (
	SELECT distinct cast(notes as int) FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
	and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
	and cast(notes as int) <> 0
)
and m.ZEO_AUDIT_DATE >  DATEADD(day ,-10,getdate()) -- только заказы не старше 10 дней
--****************************************************
AND m.ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)
--****************************************************
ORDER BY ZEO_ZEC_BASE


/*
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where GLN in ('9864232331926')

SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues where VarName = 'BASE_GLN' and CompID = 7134
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (71522,'BASE_GLN','9864066927104')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7031,'BASE_GLN','9863577638028')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7136,'BASE_GLN','4829900024055')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7155,'BASE_GLN','9864232128281')
*/


--подобрать новый адрес под GLN точки (ZEO_ZEC_ADD) и обновить GLNCode в r_CompsAdd
SELECT 'запустить скрипты в строчках где совпадают поля Adress и CompAdd'
DECLARE @CompID_FindAdress int = (SELECT top 1 CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues p WITH (NOLOCK) where p.VarName = 'BASE_GLN' and p.VarValue = 
(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
) --номер предприятия
	SELECT distinct m.ZEO_ORDER_NUMBER,m.ZEO_ORDER_DATE,m.ZEO_ZEC_ADD
	,(SELECT TOP 1 Adress FROM [S-SQL-D4].Elit.dbo.at_gln p1 WITH (NOLOCK) where p1.GLN = m.ZEO_ZEC_ADD) Adress
	,g.CompID, g.CompAdd, g.CompAddID,g.GLNCode,g.CompAddDesc
	,'UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '''+m.ZEO_ZEC_ADD+''' where compid = '+cast(@CompID_FindAdress as varchar)+' and CompAddID = '+cast(g.CompAddID as varchar) 'Script'
	,g.*
	--,'insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ('+cast(g.RefID as varchar)+',''BASE_GLN'','''+cast(m.ZEO_ZEC_BASE as varchar)+''')' 'выбрать правильные строки по RefName и GLNName'
	from dbo.ALEF_EDI_ORDERS_2 m  WITH (NOLOCK)
	CROSS APPLY (select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2  WITH (NOLOCK) where compid = @CompID_FindAdress) g 
	where  
	--NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WITH (NOLOCK) WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
	ZEO_ORDER_STATUS NOT IN (33,4,5)
	and (SELECT RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 WITH (NOLOCK) where p1.GLN = m.ZEO_ZEC_BASE) in (
		SELECT distinct cast(notes as int) FROM [S-SQL-D4].Elit.dbo.r_uni WITH (NOLOCK) where  RefTypeID = 6680117 
		and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni WITH (NOLOCK) where  RefTypeID = 6680116 and notes = '1')  
		and cast(notes as int) <> 0
	)
	and m.ZEO_AUDIT_DATE >  DATEADD(day ,-10,getdate()) -- только заказы не старше 10 дней
	--****************************************************
	AND m.ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)
	--****************************************************
	ORDER BY g.CompAddID



/*
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid in (7031) 
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232265764' where compid = 71521 and CompAddID = 5
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232265771' where compid = 7067 and CompAddID = 9
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864045714190' where compid = 7067 and CompAddID = 20
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864066911400' where compid = 7135 and CompAddID = 72
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232306924' where compid = 7067 and CompAddID = 21
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232322870' where compid = 7031 and CompAddID = 60
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232331926' where compid = 7031 and CompAddID = 61
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '4824025001011' where compid = 7026 and CompAddID = 1
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232173168' where compid = 7155 and CompAddID = 1
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864169615472' where compid = 7031 and CompAddID = 62
*/


BEGIN TRAN
-------------------------------------------------------ДОБАВЛЕНИЕ НОВОГО АДРЕСА--------------------------------------------------------------
--------ТАБЛИЦА № 1----------
--добавляем новый адрес в таблицу №1 dbo.ALEF_EDI_GLN_OT (KOD_BASE - базовый GLN, KOD_ADD - GLN адреса доставки, KOD_KLN_OT - код контрагента, KOD_ADD_OT - ID адреса доставки, KOD_SKLAD_OT - код нашего склада, STATUS - default 1)

IF 1=1
BEGIN
	--DECLARE @ZEO_ORDER_NUMBER varchar(200) = '4549765650' --номер заказа в EDI

	SELECT
	(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) ZEC_KOD_BASE
	,(select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) ZEC_KOD_ADD
	,(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) ZEC_KOD_KLN_OT
	,(select CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK) WHERE GLNCode = (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
	  and CompID = (SELECT top 1 CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues p where p.VarName = 'BASE_GLN' and p.VarValue = 
		(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))	)
	) ZEC_KOD_ADD_OT
	--если другой адрес то коментируем сверху и разкоментируем снизу и вписываем правильный код адреса
	--, 17 ZEC_KOD_ADD_OT
	,case 
	(
	select CompGrID2  from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK)
	--/*test*/ select CompGrID2,*  from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK) where CompID = 71520
	where CompID in ((SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))))
	and GLNCode = (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
	)
	 when 2030 then 220 --склад НАЦСЕТЕЙ Киев
	 when 2031 then 4 --склад общий Днепр
	 when 2034 then 23 --склад общий Одесса
	 when 2035 then 27 --склад общий Львов
	 when 2036 then 11 --склад общий Харьков
	 when 2048 then 85 --склад общий Черкассы
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS


INSERT dbo.ALEF_EDI_GLN_OT
	SELECT
	(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) ZEC_KOD_BASE
	,(select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) ZEC_KOD_ADD
	,(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) ZEC_KOD_KLN_OT
	,(select CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK) WHERE GLNCode = (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
	  and CompID = (SELECT top 1 CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues p where p.VarName = 'BASE_GLN' and p.VarValue = 
		(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))	)
	) ZEC_KOD_ADD_OT
	--если другой адрес то коментируем сверху и разкоментируем снизу и вписываем правильный код адреса
	--, 17 ZEC_KOD_ADD_OT
	,case 
	(
	select CompGrID2  from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK)
	where CompID in ((SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))))
	and GLNCode = (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
	)
	 when 2030 then 220 --склад НАЦСЕТЕЙ Киев
	 when 2031 then 4 --склад общий Днепр
	 when 2034 then 23 --склад общий Одесса
	 when 2035 then 27 --склад общий Львов
	 when 2036 then 11 --склад общий Харьков
	 when 2048 then 85 --склад общий Черкассы
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS


------------------------------------------------------------------------------------------
--------ТАБЛИЦА № 2----------
--добавляем новый адрес в таблицу №2 dbo.ALEF_EDI_GLN_SETI (EGS_GLN_SETI_ID - ID сети)

SELECT * FROM (
  SELECT
	(select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) EGS_GLN_ID
	,(SELECT Adress FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) EGS_GLN_NAME --ищем в справочнике предприятий адрес доставки на вкладке Адреса доставки 
	,(SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
		(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
	) EGS_GLN_SETI_ID -- ищем в справочнике предприятий на вкладке Дополнительно поле Код признака 2
	,null EGS_STATUS
	UNION ALL
  SELECT
	(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) EGS_GLN_ID
	,(SELECT GLNName FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) EGS_GLN_NAME --берем короткое название с сайта Edi-n.com
	,(SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
		(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
	) EGS_GLN_SETI_ID -- ищем в справочнике предприятий на вкладке Дополнительно поле Код признака 2
	,null EGS_STATUS
) s1 
where EGS_GLN_ID not in (
SELECT EGS_GLN_ID FROM dbo.ALEF_EDI_GLN_SETI WITH (NOLOCK) where EGS_GLN_SETI_ID = (SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
		(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		)
)


INSERT dbo.ALEF_EDI_GLN_SETI
	SELECT * FROM (
	  SELECT
		(select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) EGS_GLN_ID
		,(SELECT Adress FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) EGS_GLN_NAME --ищем в справочнике предприятий адрес доставки на вкладке Адреса доставки 
		,(SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
			(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		) EGS_GLN_SETI_ID -- ищем в справочнике предприятий на вкладке Дополнительно поле Код признака 2
		,null EGS_STATUS
		UNION ALL
	  SELECT
		(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) EGS_GLN_ID
		,(SELECT GLNName FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) EGS_GLN_NAME --берем короткое название с сайта Edi-n.com
		,(SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
			(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		) EGS_GLN_SETI_ID -- ищем в справочнике предприятий на вкладке Дополнительно поле Код признака 2
		,null EGS_STATUS
	) s1 
	where EGS_GLN_ID not in (
	SELECT EGS_GLN_ID FROM dbo.ALEF_EDI_GLN_SETI WITH (NOLOCK) where EGS_GLN_SETI_ID = (SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
			(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
			)
	)

END

ROLLBACK TRAN

/*
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_NAME like '%новус%' --EGS_GLN_ID = '9864060910836'
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_SETI_ID = 846 --621 новус
*/

----поиск новых GLN адресов
select TOP 100 
ZEO_ORDER_NUMBER 'номер заказа'
,m.ZEO_AUDIT_DATE 'дата заказа'
,m.ZEO_ORDER_DATE 'дата доставки'
,m.ZEO_ZEC_BASE BASEGLN
,m.ZEO_ZEC_ADD GLN
,(SELECT TOP 1 RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) RetailersID
,(SELECT TOP 1 RetailersName FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) RetailersName
,(SELECT TOP 1 GLNName FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) GLNName
,(SELECT TOP 1 Adress FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) Adress
--,(SELECT SUBSTRING((SELECT   ',' +cast(RefID as varchar)+ '='+ RefName as [text()]  FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
--	and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
--	and cast(notes as int) <> 0
--	and Notes in (SELECT TOP 1 RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE)
--	for XML PATH('')),2,65535)
--) comps
,(SELECT top 1 CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues where VarName = 'BASE_GLN' and VarValue = m.ZEO_ZEC_BASE) CompID
,(SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) compid
,(select top 1 compshort from [S-SQL-D4].Elit.dbo.r_Comps p2 where compid =(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) compshort
, (SELECT top 1 ZEC_KOD_ADD_OT FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = m.ZEO_ZEC_ADD) 'Внимание!!!уже добавленные адреса'
,(SELECT top 1 (SELECT isnull(CodeName3,'') + ' ' + (SELECT isnull(EMail,'')+' '+isnull(Mobile,'') + ' ' + isnull(EmpName,'')+' '+isnull(Mobile,'')+' '+isnull(MilProfes,'') FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = (SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) '*Заказы без GLN адреса в Alef_Elit.dbo.ALEF_EDI_GLN_SETI*'
,*
from dbo.ALEF_EDI_ORDERS_2 m
where  
NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
ZEO_ORDER_STATUS NOT IN (33,4,5)
and (SELECT RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) in (
	SELECT distinct cast(notes as int) FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
	and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
	and cast(notes as int) <> 0
)
and m.ZEO_AUDIT_DATE >  DATEADD(day ,-10,getdate()) -- только заказы не старше 10 дней
ORDER BY ZEO_ORDER_DATE DESC







-----------Изменить адрес доставки--------------/*pvm0 '2019-05-27'*/

BEGIN TRAN
SELECT * FROM dbo.ALEF_EDI_ORDERS_2 m  WITH (NOLOCK) where m.ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031 
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031 and GLNCode = '9863576637923'
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031  and CompAddID = 11
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031  and CompAddID = 59

UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '' where compid = 7031 and CompAddID = 11
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9863576637923' where compid = 7031 and CompAddID = 59
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031 and GLNCode = '9863576637923'

SELECT * FROM ALEF_EDI_GLN_OT WHERE  ZEC_KOD_KLN_OT = 7031 and ZEC_KOD_ADD = '9863576637923'
UPDATE ALEF_EDI_GLN_OT set ZEC_KOD_ADD_OT = 59  where ZEC_KOD_KLN_OT = 7031 and ZEC_KOD_ADD = '9863576637923'
SELECT * FROM ALEF_EDI_GLN_OT WHERE  ZEC_KOD_KLN_OT = 7031 and ZEC_KOD_ADD = '9863576637923'

--запускаем блок
BEGIN
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_ID = '9863576637923'

UPDATE ALEF_EDI_GLN_SETI set EGS_GLN_NAME = 
(SELECT Adress FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in ('9863576637923'))  
where EGS_GLN_ID = '9863576637923'

SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_ID = '9863576637923'
END;


ROLLBACK TRAN



/*
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln ORDER BY ImportDate desc
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where GLN = '4829900024055'
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where GLN = '4829900023799'
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where RetailersID = 17154


--[ap_EDI_SendToEmail_New_GLN] оповещение о новых gln

SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1' 
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 80019 and len(notes) > 4 
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 80019 and notes like '%ORDRSP%'

SELECT SUBSTRING((SELECT   ',' +cast(RefID as varchar)+ '='+ RefName as [text()]  FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
and cast(notes as int) <> 0
and Notes = '16508'
for XML PATH('')),2,65535)

--поиск адреса
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7079 ORDER BY CompAddID DESC
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7095 ORDER BY CompAddID DESC


 
--просмотр ответственного менеджера по предприятию
SELECT (SELECT isnull(CodeName3,'') + ' ' + (SELECT isnull(EMail,'')+' '+isnull(Mobile,'') + ' ' + isnull(EmpName,'')+' '+isnull(MilProfes,'') FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = 7079

SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = 7079


select * from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE compid = 7140


select * from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER like 'РОЗ%' ORDER BY ZEO_AUDIT_DATE desc--номер заказа на сайте

select * from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = '111207172000' --номер заказа на сайте
select * from dbo.ALEF_EDI_ORDERS_2_POS where ZEP_ORDER_ID = 461093936
SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = '4820128010004'--(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
SELECT * FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '9864066940967'
SELECT * FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_BASE = '9864066940967'
--delete ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_BASE = ''
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_ID = '9863569647762'
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_ID = '9864066940967'
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_SETI_ID = 615

SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln ORDER BY ImportDate desc
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where GLN in ('9864066888078','9864232280095','9864066862047')
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
and notes = (SELECT top 1 RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln where GLN in ('9864232185000','9864232280095'))

SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117  order by notes
SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues


select top 1 * from dbo.ALEF_EDI_ORDERS_2 with (NOLOCK) where  ZEO_ORDER_NUMBER = 'ЗПп00083880' --номер заказа на сайте


*/



---------------------------------------------ДОБАВЛЕНИЕ НОВОЙ СЕТИ---------------------------------------------

/*
--При добавлении новой сети добавляем первую запись
  DECLARE @ZEO_ORDER_NUMBER varchar(200) = '111207172000' --номер заказа в EDI

--INSERT dbo.ALEF_EDI_GLN_OT
	SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_BASE
	,(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_ADD
	,7089 ZEC_KOD_KLN_OT --ищем в справочнике предприятий код предприятия 
	,3 ZEC_KOD_ADD_OT --ищем в справочнике предприятий код адреса доставки на вкладке Адреса доставки 
	,case (select top 1 CompGrID2 from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID = 
	7089)--ищем в справочнике предприятий код предприятия 
	 when 2030 then 220 --склад НАЦСЕТЕЙ Киев
	 when 2031 then 4 --склад общий Днепр
	 when 2034 then 23 --склад общий Одесса
	 when 2035 then 27 --склад общий Львов
	 when 2036 then 11 --склад общий Харьков
	 when 2048 then 85 --склад общий Черкассы
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS

  DECLARE @ZEO_ORDER_NUMBER_2 varchar(200) = '111207172000' --номер заказа в EDI

--INSERT dbo.ALEF_EDI_GLN_SETI
  SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,'супермаркет; м. Харків, пр. Гагаріна, 165' EGS_GLN_NAME --ищем в справочнике предприятий адрес доставки на вкладке Адреса доставки 
	,614 EGS_GLN_SETI_ID -- ищем в справочнике предприятий на вкладке Дополнительно поле Код признака 2
	,null EGS_STATUS
	UNION ALL
  SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,'ТОВ СУЧАСНИЙ МОДЕРН' EGS_GLN_NAME --берем короткое название с сайта Edi-n.com
	,614 EGS_GLN_SETI_ID -- ищем в справочнике предприятий на вкладке Дополнительно поле Код признака 2
	,null EGS_STATUS
*/






/*



--???????????????????
--добавление фиксированного адреса, если GLN завели неправильно.
--таблица 2
IF 1=1 
BEGIN
BEGIN TRAN

SELECT * FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = '4824025200506'
/*
--удаляем старый GLN
-- delete ALEF_EDI_GLN_SETI where EGS_GLN_ID = '4824025200506'
*/

DECLARE @ZEO_ORDER_NUMBER_3 varchar(200) = '2018019037' --номер заказа в EDI
--select * from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) ))
DECLARE @CompAddID int = 43 --добавить адрес

	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where  CompAddID = @CompAddID and CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) ))) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3)) EGS_GLN_SETI_ID
	,null EGS_STATUS

INSERT dbo.ALEF_EDI_GLN_SETI
	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where  CompAddID = @CompAddID and CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) ))) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3)) EGS_GLN_SETI_ID
	,null EGS_STATUS

ROLLBACK TRAN
END

/* 
Далее переходим к следующему шагу:
Обновить GLN в базе Elit (запускаем джоб GLN_Update на s_ppc) вручную 
или через команду EXEC msdb.dbo.sp_start_job N'GLN_Update'
На сайте перебросов перезаливаем заказы и запускаем джоб EXEC msdb.dbo.sp_start_job N'EDI'
*/


/*
АРХИВ-----------------------------------------------------------
--делаем добавление нового адреса с помощью
--insert dbo.ALEF_EDI_GLN_OT
--select '9864066918782','9864232143314',65867,16,220,1;
--в базе ALEF_Elit
--где '9864066918782' - базовый код (BASE)
--'9864232143314' - код адреса доставки (ADD)
--65867 - код сети (Легион 2015 / Пчелка)

9864066888160	Крамниця; м.Одеса, Малиновський р-н, вул.М 'ясоєдівська, буд.39
delete ALEF_EDI_GLN_SETI where EGS_GLN_ID = '9864066888160'

9864066888078

SELECT * FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = '9864066888078'
SELECT * FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = '9864066876396'
SELECT * FROM ALEF_EDI_GLN_OT where ZEC_KOD_ADD = '9864232293668'

SELECT * FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = '9864040514146'
SELECT * FROM ALEF_EDI_GLN_OT where ZEC_KOD_KLN_OT = '7136'--4829900025656
EGS_GLN_ID	EGS_GLN_NAME	EGS_GLN_SETI_ID	EGS_STATUS
9864046014190	РЦ; 67663, Одеська обл., Біляївський р-н, Усатівська с/р, автодорога Київ-Одеса, 462 км+100 м	751	NULL

/*
SELECT * FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = '4829900024116'
select * from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ( 7136) ORDER BY ChDate desc
*/
--16 - адрес доставки, определяем из базы elit с пом-ю, это CompADDID
select * from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ( 7136,7138)

--220 - наш склад отгрузки
--1 - оставляем (статус)

--запускаем еще одно добавление адреса в другую таблицу
--в базе ALEF_Elit
---insert dbo.ALEF_EDI_GLN_SETI
---select '9864232143314','м. Київ, вул. Шолом-Алейхема, буд. 10 А',998,null

--адрес из elit
--998 - столбец нац.сеть - пчелка

-- Привязка кодов в EDI для Вересень, на base Elit
-- exec ap_KPK_SetProdsExtProdID @CompID = 64030, @ProdID = 31519, @ExtProdID = '888-20852'

select 
 (SELECT top 1 EGS_GLN_NAME FROM ALEF_EDI_GLN_SETI p1 where p1.EGS_GLN_ID = m.ZEO_ZEC_BASE)
, (SELECT top 1 EGS_GLN_NAME FROM ALEF_EDI_GLN_SETI p1 where p1.EGS_GLN_ID = m.ZEO_ZEC_ADD)
,* from dbo.ALEF_EDI_ORDERS_2 m where ZEO_ORDER_STATUS = 31 
and  (SELECT top 1 EGS_GLN_NAME FROM ALEF_EDI_GLN_SETI p1 where p1.EGS_GLN_ID = m.ZEO_ZEC_BASE) is not null
ORDER BY m.ZEO_ORDER_DATE desc
 
Код статуса	Значение статуса
0	Новый заказ
1	Заливается в ОТ
3	Блокировка менеджера
4	Задублированный
5	Заказ залит в ОТ
31	Новый адрес, нет соответствия
32	Дата доставки меньше текущей
33	Неизвестный внешний код товара
34	Не установлен прайс лист
35	Не установлена отсрочка платежа
36	Нет цены для товара
37	Нет сканкода для товараа
38	Пустой заказ
39	Уже есть накладная
null	Неизвестная ошибка

*/

SELECT * FROM  Alef_EDI_EMPS
SELECT * FROM  alef_edi_SETI_EMPS


	SELECT  distinct m.ZEO_ORDER_NUMBER,m.ZEO_ORDER_DATE,m.ZEO_ZEC_ADD,m.ZEO_ORDER_STATUS
	,(SELECT TOP 1 Adress FROM [S-SQL-D4].Elit.dbo.at_gln p1 WITH (NOLOCK) where p1.GLN = m.ZEO_ZEC_ADD) Adress
	,g.CompID, g.CompAdd, g.CompAddID,g.GLNCode,g.CompAddDesc
	,'UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '''+m.ZEO_ZEC_ADD+''' where compid = '+cast(64030 as varchar)+' and CompAddID = '+cast(g.CompAddID as varchar) 'Script'
	,g.*
	--,'insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ('+cast(g.RefID as varchar)+',''BASE_GLN'','''+cast(m.ZEO_ZEC_BASE as varchar)+''')' 'выбрать правильные строки по RefName и GLNName'
	from dbo.ALEF_EDI_ORDERS_2 m  WITH (NOLOCK)
	CROSS APPLY (select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2  WITH (NOLOCK) where compid = 64030 /*and CompAddID in (59,58)*/) g 
	where  
	--NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WITH (NOLOCK) WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
	--ZEO_ORDER_STATUS NOT IN (33,4,5)
	--and 
    (SELECT RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 WITH (NOLOCK) where p1.GLN = m.ZEO_ZEC_BASE) in (
		SELECT distinct cast(notes as int) FROM [S-SQL-D4].Elit.dbo.r_uni WITH (NOLOCK) where  RefTypeID = 6680117 
		and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni WITH (NOLOCK) where  RefTypeID = 6680116 and notes = '1')  
		and cast(notes as int) <> 0
	)
	and m.ZEO_AUDIT_DATE >  DATEADD(day ,-10,getdate()) -- только заказы не старше 10 дней
	----****************************************************
	AND 
    m.ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)
	--****************************************************
	ORDER BY g.CompAddID
*/
/*
--Запуск джоба
exec msdb.dbo.sp_start_job 'edi'
exec msdb.dbo.sp_help_job @execution_status = 1, @job_name = 'EDI'

SELECT * FROM sysjobs

select j.name, step_id, js.step_name, database_name 
from msdb.dbo.sysjobsteps js
join msdb.dbo.sysjobs j on j.job_id=js.job_id
where subsystem='TSQL'
order by j.name, step_id


EXECUTE sp_get_composite_job_info @job_id = 'D23DAD66-7598-4A03-A2BE-1CF79894D7DD'
EXECUTE sp_get_composite_job_info @job_id = 'E0C79A69-0C86-4F95-889E-2AB95F7D82AE'

SELECT current_execution_step,* FROM OPENROWSET('SQLNCLI', 'Server=localhost;Trusted_Connection=yes;', 'EXECUTE  msdb.dbo.sp_get_composite_job_info @job_id = ''D23DAD66-7598-4A03-A2BE-1CF79894D7DD''')

declare @str varchar(max) = ''
WHILE @str <> '0 (unknown)'    		 
BEGIN
	set @str = (SELECT current_execution_step FROM OPENROWSET('SQLNCLI', 'Server=localhost;Trusted_Connection=yes;', 'EXECUTE  msdb.dbo.sp_get_composite_job_info @job_id = ''D23DAD66-7598-4A03-A2BE-1CF79894D7DD'''))
	RAISERROR ('Выполнено %s', 10,1,@str) WITH NOWAIT

	WAITFOR DELAY '00:00:05'
END 
*/

SELECT * FROM dbo.ALEF_EDI_GLN_OT aego where ZEC_KOD_BASE = '9863577638028' ORDER BY 4 --ZEC_KOD_ADD = ''
SELECT * FROM dbo.ALEF_EDI_GLN_OT aego where ZEC_KOD_KLN_OT in('7031') ORDER BY 4
SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE compid = 7031 ORDER BY ChDate
SELECT * FROM [s-sql-d4].[elit].dbo.r_compValues WHERE compid = 7031


SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln WHERE retailersid = 16 and gln = '4824025200506'
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_NAME like '%новус%'--WHERE EGS_GLN_SETI_ID = 252

(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues WHERE varvalue = '4824025000007' --AND compid = 7026
--DELETE [S-SQL-D4].Elit.dbo.r_CompValues WHERE varvalue = '9863577638028' AND compid = 7134


-----------------------------------------------------------------------------ДОБАВЛЕНИЕ ЗАРАНЕЕ ВРУЧНУЮ БЕЗ ФАКТИЧЕСКОГО ЗАКАЗА-----------------------------------------------------------------
SELECT 'Поехали...'
BEGIN TRAN
BEGIN

    DECLARE @base_GLN varchar(13) = '9864232280231' --базовый GLN
    DECLARE @compID int = (SELECT DISTINCT ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = @base_GLN)
    DECLARE @new_GLN varchar(100) = '9864232340140' --новый GLN (его должен предоставить менеджер)
    DECLARE @new_Address varchar(250) = 'Супермаркет; м.Харків, просп. Московський, буд. 257' --новый адрес точки (его должен предоставить менеджер - сверяем с закладкой "Адреса доставки" в Справочнике предприятий)


    IF OBJECT_ID (N'tempdb..#add_GLN', N'U') IS NOT NULL DROP TABLE #add_GLN
    CREATE TABLE #add_GLN (
    base_GLN varchar(13),
    comp_ID int,
    new_GLN varchar(13),
    new_Address varchar(250)
    )
    SELECT * FROM #add_GLN
    INSERT INTO #add_GLN (base_GLN, comp_ID, new_GLN, new_Address) VALUES (
    @base_GLN, 
    (SELECT DISTINCT ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = @base_GLN),
    @new_GLN,
    @new_Address   
    )
    SELECT * FROM #add_GLN

--ТАБЛИЦА №1
BEGIN    
    SELECT 'Таблица №1'
    SELECT * FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)
    INSERT INTO ALEF_EDI_GLN_OT (ZEC_KOD_BASE, ZEC_KOD_ADD, ZEC_KOD_KLN_OT, ZEC_KOD_ADD_OT, ZEC_KOD_SKLAD_OT, ZEC_STATUS) 
    VALUES (
    (SELECT base_GLN FROM #add_GLN), 
    (SELECT new_GLN FROM #add_GLN), 
    (select DISTINCT ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)),
    (select MAX(ZEC_KOD_ADD_OT) + 1 FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)),
    (select DISTINCT ZEC_KOD_SKLAD_OT FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)),
    (select DISTINCT ZEC_STATUS FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN))
    )
    SELECT * FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)
END;

--ТАБЛИЦА №2
BEGIN    
    SELECT 'Таблица №2'
    SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_SETI_ID = (SELECT egs_gln_seti_id FROM ALEF_EDI_GLN_SETI WHERE egs_gln_id = (SELECT base_GLN FROM #add_GLN))
    INSERT INTO ALEF_EDI_GLN_SETI (EGS_GLN_ID, EGS_GLN_NAME, EGS_GLN_SETI_ID, EGS_STATUS)
    VALUES (
    (SELECT new_GLN FROM #add_GLN),
    (SELECT new_Address FROM #add_GLN),
    (SELECT egs_gln_seti_id FROM ALEF_EDI_GLN_SETI WHERE egs_gln_id = (SELECT base_GLN FROM #add_GLN)),
    NULL
    )
    SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_SETI_ID = (SELECT egs_gln_seti_id FROM ALEF_EDI_GLN_SETI WHERE egs_gln_id = (SELECT base_GLN FROM #add_GLN))
END;
END;
ROLLBACK TRAN

--ТАБЛИЦА №3 (операции на linked server нельзя завернуть в транзакцию - надо менять настройки сервера)
BEGIN   
    SELECT 'Таблица №3'
    SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues where VarName = 'BASE_GLN' and CompID = (SELECT comp_ID FROM #add_GLN)
    INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ((SELECT comp_ID FROM #add_GLN),'BASE_GLN',(SELECT base_GLN FROM #add_GLN))
    SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues where VarName = 'BASE_GLN' and CompID = (SELECT comp_ID FROM #add_GLN)
END;

--ТАБЛИЦА №4 (операции на linked server нельзя завернуть в транзакцию - надо менять настройки сервера)
BEGIN   
    SELECT 'Таблица №4'
    SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompsAdd where compid = (SELECT comp_ID FROM #add_GLN) and CompAddID = (select MAX(ZEC_KOD_ADD_OT) FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN))
    UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = (SELECT new_GLN FROM #add_GLN) where compid = (SELECT comp_ID FROM #add_GLN) and CompAddID = (select MAX(ZEC_KOD_ADD_OT) FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN))
    SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompsAdd where compid = (SELECT comp_ID FROM #add_GLN) and CompAddID = (select MAX(ZEC_KOD_ADD_OT) FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN))
END;

SELECT 'Приехали.'

