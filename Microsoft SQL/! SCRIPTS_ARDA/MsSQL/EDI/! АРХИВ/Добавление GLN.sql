/* ОПИСАНИЕ: Данный скрипт добавляет новый GLN / изменяет адрес GLN / добавляет новую сеть*/
--ZEC_KOD_ADD_OT - код адреса доставки
--EGS_GLN_NAME - адрес
USE Alef_Elit --S-PPC

--поиск новых GLN адресов
select TOP 100 
ZEO_ORDER_NUMBER 'номер заказа'
,m.ZEO_AUDIT_DATE 'дата заказа'
,m.ZEO_ORDER_DATE 'дата доставки'
,m.ZEO_ZEC_ADD GLN
,(SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) compid
,(select top 1 compshort from [S-SQL-D4].Elit.dbo.r_Comps p2 where compid =(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) compshort
, (SELECT top 1 ZEC_KOD_ADD_OT FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = m.ZEO_ZEC_ADD) 'Внимание!!!уже добавленные адреса'
,(SELECT top 1 (SELECT isnull(CodeName3,'') + ' ' + (SELECT isnull(EMail,'')+' '+isnull(Mobile,'') + ' ' + isnull(EmpName,'')+' '+isnull(Mobile,'')+' '+isnull(MilProfes,'') FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = (SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) '*Заказы без GLN адреса в Alef_Elit.dbo.ALEF_EDI_GLN_SETI*'
,*
from dbo.ALEF_EDI_ORDERS_2 m
where --zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) AND 
NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
ZEO_ORDER_STATUS NOT IN (33,4,5)
AND EXISTS (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) 
and (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) not in (23501) --исключить предприятия
and m.ZEO_AUDIT_DATE >  DATEADD(day ,-30,getdate()) -- только заказы не старше 30 дней
ORDER BY ZEO_ORDER_DATE DESC


/*
--поиск адреса
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7067 ORDER BY CompAddID DESC

--просмотр ответственного менеджера по предприятию
SELECT (SELECT isnull(CodeName3,'') + ' ' + (SELECT isnull(EMail,'')+' '+isnull(Mobile,'') + ' ' + isnull(EmpName,'')+' '+isnull(MilProfes,'') FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = 7138

select * from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE compid = 7140

select * from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = 'За10175892046' --номер заказа на сайте
select * from dbo.ALEF_EDI_ORDERS_2_POS where ZEP_ORDER_ID = 449633783
SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = '9864232280231'--(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
SELECT * FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '9864232280248'
*/



-------------------------------------------------------ДОБАВЛЕНИЕ НОВОГО АДРЕСА--------------------------------------------------------------
--------ТАБЛИЦА № 1----------
--добавляем новый адрес в таблицу №1 dbo.ALEF_EDI_GLN_OT (KOD_BASE - базовый GLN, KOD_ADD - GLN адреса доставки, KOD_KLN_OT - код контрагента, KOD_ADD_OT - ID адреса доставки, KOD_SKLAD_OT - код нашего склада, STATUS - default 1)

--SELECT * FROM dbo.ALEF_EDI_GLN_OT aego	WHERE aego.ZEC_KOD_ADD	= '9864232227441'

IF 1=1
BEGIN
BEGIN TRAN

DECLARE @ZEO_ORDER_NUMBER varchar(200) = '9231164' --номер заказа в EDI

SELECT * 
, (SELECT 'update ALEF_EDI_GLN_OT set ZEC_STATUS = 1 
WHERE ALEF_EDI_GLN_OT.ZEC_KOD_BASE = '''+s1.ZEC_KOD_BASE+''' and dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '''+s1.ZEC_KOD_ADD+''' and ALEF_EDI_GLN_OT.ZEC_KOD_ADD_OT = '+cast(s1.ZEC_KOD_ADD_OT as varchar(20) )
FROM ALEF_EDI_GLN_OT WHERE ALEF_EDI_GLN_OT.ZEC_KOD_BASE = s1.ZEC_KOD_BASE and dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = s1.ZEC_KOD_ADD and ALEF_EDI_GLN_OT.ZEC_KOD_ADD_OT = s1.ZEC_KOD_ADD_OT ) 'дубликат! такой код адреса уже добавлен.смените статус на 1 для обновления GLN в Elit'
FROM (
SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_BASE
	,(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_ADD
	,(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ) ZEC_KOD_KLN_OT
	,(select top 1 CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE GLNCode = '' and CompID in 
		(
			(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
		) ORDER BY ChDate desc) ZEC_KOD_ADD_OT
	,case (select top 1 CompGrID2 from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) )) ORDER BY ChDate desc)
	 when 2030 then 220 --склад НАЦСЕТЕЙ Киев
	 when 2031 then 4 --склад общий Днепр
	 when 2034 then 23 --склад общий Одесса
	 when 2035 then 27 --склад общий Львов
	 when 2036 then 11 --склад общий Харьков
	 when 2048 then 85 --склад общий Черкассы
/*14.12.2018 - надо добавить 30 склад*/
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE GLNCode = '' and CompID in 
		(
			(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
		) ORDER BY ChDate desc) CompAdd
	) s1 

	
/*
--если GLN завели неправильно, удаляем старый GLN и добавляем новый номер через INSERT (см. код ниже)
SELECT * FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '9864232293248'
--DELETE ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '9864066969142'
*/

INSERT dbo.ALEF_EDI_GLN_OT
	SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_BASE
	,(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_ADD
	,(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ) ZEC_KOD_KLN_OT
	,(select top 1 CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE GLNCode = '' and CompID in 
		(
			(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
		) ORDER BY ChDate desc) ZEC_KOD_ADD_OT
	--если другой адрес то коментируем сверху и разкоментируем снизу и вписываем правильный код адреса
	--, 17 ZEC_KOD_ADD_OT
	,case (select top 1 CompGrID2 from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) )) ORDER BY ChDate desc)
	 when 2030 then 220 --склад НАЦСЕТЕЙ Киев
	 when 2031 then 4 --склад общий Днепр
	 when 2034 then 23 --склад общий Одесса
	 when 2035 then 27 --склад общий Львов
	 when 2036 then 11 --склад общий Харьков
	 when 2048 then 85 --склад общий Черкассы
/*14.12.2018 - надо добавить 30 склад*/
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS

ROLLBACK TRAN
END 



------------------------------------------------------------------------------------------
--------ТАБЛИЦА № 2----------
--добавляем новый адрес в таблицу №2 dbo.ALEF_EDI_GLN_SETI (EGS_GLN_SETI_ID - ID сети)
IF 1=1 
BEGIN
BEGIN TRAN

SELECT * FROM dbo.ALEF_EDI_GLN_SETI aegs where aegs.EGS_GLN_ID = '9864066969142'

DECLARE @ZEO_ORDER_NUMBER_2 varchar(200) = '9231164' --номер заказа в EDI

	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where GLNCode = '' and CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) )) ORDER BY ChDate desc) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2)) EGS_GLN_SETI_ID
	,null EGS_STATUS

INSERT dbo.ALEF_EDI_GLN_SETI
	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where GLNCode = '' and CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) )) ORDER BY ChDate desc) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2)) EGS_GLN_SETI_ID
	,null EGS_STATUS

ROLLBACK TRAN
END


---------------------------------------------ДОБАВЛЕНИЕ НОВОЙ СЕТИ---------------------------------------------

/*
--При добавлении новой сети добавляем первую запись
  DECLARE @ZEO_ORDER_NUMBER varchar(200) = '555' --номер заказа в EDI

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

  DECLARE @ZEO_ORDER_NUMBER_2 varchar(200) = '555' --номер заказа в EDI

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

