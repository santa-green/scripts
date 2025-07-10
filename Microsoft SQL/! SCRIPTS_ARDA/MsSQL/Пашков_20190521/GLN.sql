-- ДОБАВЛЕНИЕ НОВОГО АДРЕСА GLN
USE Alef_Elit


select TOP 100 
ZEO_ORDER_NUMBER 'номер заказа'
,m.ZEO_AUDIT_DATE 'дата заказа'
,m.ZEO_ORDER_DATE 'дата доставки'
,m.ZEO_ZEC_ADD GLN
,(SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) compid
,(select top 1 compshort from [S-SQL-D4].Elit.dbo.r_Comps p2 where compid =(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) compshort
,'' 'заказы в которых отсутствуют gln адреса в  Alef_Elit.dbo.ALEF_EDI_GLN_SETI'
,*
from dbo.ALEF_EDI_ORDERS_2 m
where zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) 
AND ZEO_ORDER_STATUS NOT IN (33,4,5)
AND EXISTS (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) 
and (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) not in (23501) --исключить предприятия
and m.ZEO_AUDIT_DATE >  DATEADD(day ,-30,getdate()) -- только заказы не старше 30 дней
ORDER BY ZEO_ORDER_DATE DESC

--select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid =7135

--взяв номер заказа на сайте
select * from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = '4510412251'
select * from dbo.ALEF_EDI_ORDERS_2_POS where ZEP_ORDER_ID = 411718125

--делаем добавление нового адреса с помощью

BEGIN TRAN

DECLARE @ZEO_ORDER_NUMBER varchar(200) = 'РОЗ8968053'

	SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_BASE
	,(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_ADD
	,(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ) ZEC_KOD_KLN_OT
	,(select top 1 CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) )) ORDER BY ChDate desc) ZEC_KOD_ADD_OT
	,case (select top 1 CompGrID2 from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) )) ORDER BY ChDate desc)
	 when 2030 then 220
	 when 2031 then 4
	 when 2034 then 23
	 when 2035 then 27
	 when 2036 then 11
	 when 2048 then 85
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS

INSERT dbo.ALEF_EDI_GLN_OT
	SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_BASE
	,(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_ADD
	,(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ) ZEC_KOD_KLN_OT
	,(select top 1 CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) )) ORDER BY ChDate desc) ZEC_KOD_ADD_OT
	,case (select top 1 CompGrID2 from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) )) ORDER BY ChDate desc)
	 when 2030 then 220
	 when 2031 then 4
	 when 2034 then 23
	 when 2035 then 27
	 when 2036 then 11
	 when 2048 then 85
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS

ROLLBACK TRAN

BEGIN TRAN

DECLARE @ZEO_ORDER_NUMBER_2 varchar(200) = 'РОЗ8968053'

	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) )) ORDER BY ChDate desc) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2)) EGS_GLN_SETI_ID
	,null EGS_STATUS

INSERT dbo.ALEF_EDI_GLN_SETI
	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) )) ORDER BY ChDate desc) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2)) EGS_GLN_SETI_ID
	,null EGS_STATUS

ROLLBACK TRAN

/*

--делаем добавление нового адреса с помощью
--insert dbo.ALEF_EDI_GLN_OT
--select '9864066918782','9864232143314',65867,16,220,1;
--в базе ALEF_Elit
--где '9864066918782' - базовый код (BASE)
--'9864232143314' - код адреса доставки (ADD)
--65867 - код сети (Легион 2015 / Пчелка)

SELECT * FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = '9864232254966'
SELECT * FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = '9864232254966'

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

