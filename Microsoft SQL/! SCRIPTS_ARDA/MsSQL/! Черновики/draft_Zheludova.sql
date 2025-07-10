--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Желудова #2402*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ap_EDI_Importing_Orders_OT

SELECT * FROM [s-sql-d4].[elit].dbo.z_tables WHERE tableName LIKE '%t_IORec%' OR tableDesc LIKE '%t_IORec%';
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME like '%at_t_IORec_С%'
SELECT * FROM [S-SQL-D4].Elit.dbo.at_t_IORec_С

SELECT * FROM ALEF_EDI_ORDERS_CHANGES m WHERE m.EOC_ORDER_ID = '1000070075' ORDER BY EOC_CH_DATE DESC
SELECT * FROM ALEF_EDI_ORDERS_CHANGES m ORDER BY EOC_CH_DATE DESC
SELECT * FROM ALEF_EDI_ORDERS_2 m WHERE m.ZEO_ORDER_ID = '1000069174'
SELECT * FROM ALEF_EDI_ORDERS_CHANGES m WHERE m.EOC_ORDER_ID = '1000069174' ORDER BY EOC_CH_DATE DESC

SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = 'Ord-GLL0140998' --CAST(@docid as varchar(30))
SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = 'Ord-APR0111298' --CAST(@docid as varchar(30))
SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = 'Ord-CTR0259338' --CAST(@docid as varchar(30))
SELECT * FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_STATUS in (0, 1) ORDER BY ZEO_ORDER_DATE DESC
SELECT * FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_STATUS in (3) ORDER BY ZEO_AUDIT_DATE DESC
SELECT * FROM ALEF_EDI_ORDERS_2 ORDER BY ZEO_ORDER_DATE DESC
SELECT distinct(ZEO_ORDER_STATUS) FROM ALEF_EDI_ORDERS_2 ORDER BY ZEO_ORDER_DATE DESC

SELECT * FROM [s-sql-d4].[elit].dbo.z_tables WHERE tableName LIKE '%at_t_IORec_С%' OR tableDesc LIKE '%at_t_IORec_С%';
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME like '%at_t_IORec_С%'

select distinct(ZEC_KOD_BASE) from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_KLN_OT in (10797, 10798, 10792, 10791, 10796) --gln МаркетВина.
select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_KLN_OT in (10797, 10798, 10792, 10791, 10796) --compid МаркетВина.
select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE = '7001'
select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE in ('700', '181', '171', '701', '971', '981') --gln МаркетВина.
SELECT * FROM [s-sql-d4].[elit].dbo.r_comps WHERE compname like '%МаркетВин%'


--update dbo.ALEF_EDI_ORDERS_2
set
ZEO_ORDER_STATUS = 3 --3	Блокировка менеджера;
where ZEO_ORDER_STATUS = 0
and (exists(select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD and ZEC_STATUS = 0) 
or exists(select * from dbo.ALEF_EDI_GLN_SETI with (nolock) where EGS_GLN_ID = ZEO_ZEC_BASE and EGS_STATUS = 0)
or exists(select * from dbo.ALEF_EDI_GLN_SETI with (nolock) where EGS_GLN_ID = ZEO_ZEC_ADD and EGS_STATUS = 0)
--TESTING...--[ADDED] rkv0 '2020-11-18 17:48' добавляю автоматическую блокировку заказов по МаркетВину (заявка №2402).
or exists(select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_KLN_OT in (10797, 10798, 10792, 10791, 10796)) --compid МаркетВина [ap_EDI_Receiving_New_MarketA_Orders].
)

select m.ZEC_KOD_BASE 'базовый gln OT', o.ZEO_ZEC_BASE 'базовый gln ORDER', * from dbo.ALEF_EDI_GLN_OT m 
JOIN dbo.ALEF_EDI_ORDERS_2 o ON m.ZEC_KOD_BASE = o.ZEO_ZEC_BASE and m.ZEC_KOD_ADD = o.ZEO_ZEC_ADD and m.ZEC_STATUS = 0
--where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD and ZEC_STATUS = 0

SELECT * FROM dbo.ALEF_EDI_ORDERS_2
where ZEO_ORDER_STATUS = 0 AND ZEO_ZEC_BASE in ('700', '181', '171', '701', '971', '981') AND ZEC_KOD_SKLAD_OT in (4, 304)

select * from dbo.ALEF_EDI_ORDERS_2 WHERE ZEO_ZEC_BASE in ('700', '181', '171', '701', '971', '981') AND ZEO_ZEC_ADD in ('1001', '1004', '1201', '1203', '1204', '1212', '1257', '1327', '1328') ORDER BY ZEO_AUDIT_DATE DESC
select * from dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE in ('700', '181', '171', '701', '971', '981') AND ZEC_KOD_ADD in ('1001', '1004', '1201', '1203', '1204', '1212', '1257', '1327', '1328')

/*ZEO_ORDER_STATUS != 0

and */(exists(select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD and ZEC_STATUS = 0) 
or exists(select * from dbo.ALEF_EDI_GLN_SETI with (nolock) where EGS_GLN_ID = ZEO_ZEC_BASE and EGS_STATUS = 0)
or exists(select * from dbo.ALEF_EDI_GLN_SETI with (nolock) where EGS_GLN_ID = ZEO_ZEC_ADD and EGS_STATUS = 0)
--TESTING...--[ADDED] rkv0 '2020-11-18 17:48' добавляю автоматическую блокировку заказов по МаркетВину (заявка №2402).
or exists(select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_KLN_OT in (10797, 10798, 10792, 10791, 10796) AND ZEC_KOD_SKLAD_OT IN (4, 304)) --compid МаркетВина [ap_EDI_Receiving_New_MarketA_Orders].
)

begin tran
    SElect ' Блокируем новые заказы для неактивных "Юр. лиц" или "Адресов доставки" или связки "Юр. лицо" + "Адрес доставки" (блокировка менеджера) '
    update dbo.ALEF_EDI_ORDERS_2
    set
    ZEO_ORDER_STATUS = 3 --3	Блокировка менеджера;
    where (ZEO_ORDER_STATUS = 0
    and (exists(select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD and ZEC_STATUS = 0) 
    or exists(select * from dbo.ALEF_EDI_GLN_SETI with (nolock) where EGS_GLN_ID = ZEO_ZEC_BASE and EGS_STATUS = 0)
    or exists(select * from dbo.ALEF_EDI_GLN_SETI with (nolock) where EGS_GLN_ID = ZEO_ZEC_ADD and EGS_STATUS = 0)
    )) OR
    --TESTING...--[ADDED] rkv0 '2020-11-18 17:48' добавляю автоматическую блокировку заказов по МаркетВину по складам Днепр 004, 304 (заявка №2402).
    --Найти коды адресов доставки: (select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_KLN_OT in (10797, 10798, 10792, 10791, 10796) AND ZEC_KOD_SKLAD_OT IN (4, 304)) 
    (ZEO_ORDER_STATUS = 0
     AND ZEO_ZEC_BASE in ('700', '181', '171', '701', '971', '981') 
     AND ZEO_ZEC_ADD in ('1001', '1004', '1201', '1203', '1204', '1212', '1257', '1327', '1328'))
 rollback tran


--select * from dbo.ALEF_EDI_GLN_OT, ALEF_EDI_ORDERS_2 with (nolock) where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD and ZEC_STATUS = 0


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*не заливается заказ (Журавлева)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM dbo.ALEF_EDI_ORDERS_2 with (nolock) 
join dbo.ALEF_EDI_ORDERS_2_POS with (nolock) on ZEO_ORDER_ID = ZEP_ORDER_ID
where ZEO_ORDER_STATUS in (33)
and ZEO_ORDER_NUMBER = '600003716'
ORDER BY ZEO_AUDIT_DATE DESC

--Перезаливка здесь:
	select *
	from dbo.ALEF_EDI_ORDERS_CHANGES with (nolock) 
	--where EOC_COMMITTED = 0
	where EOC_COMMITTED = 1
	and EOC_TYPE = 200
    ORDER BY EOC_CH_DATE DESC