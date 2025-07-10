USE Alef_Elit
SELECT DB_NAME() 'db'

DECLARE @docid VARCHAR(max) = 'Ц0000041912'

--#region INFO
/*
[ap_EDI_Importing_Orders_OT]   --Здесь запускается на S-PPC джоб EDI
Кнопка "Перезалить Заказы" меняет поле EOC_COMMITTED на 0 в таблице ALEF_EDI_ORDERS_CHANGES (Alef_Elit)
select * from dbo.ALEF_EDI_ORDERS_CHANGES where EOC_COMMITTED = 0 and EOC_TYPE = 200
exec [S-SQL-D4].[Elit].[dbo].ap_OP_OrderProcessing  --Здесь запускается на S-SQL-D4 джоб ELIT OrderProcessing
*/
--#endregion INFO

--#region Реестр документов с EDI-N.com

--ap_EDI_Importing_Orders_OT
SELECT 'Реестр документов с EDI-N.com'

SELECT 'R' + right('0000000000' + cast(ChID as varchar(10)) , 10) ZEO_ORDER_ID
,      *                                                         
FROM at_EDI_reg_files
where ID = @docid

--#endregion Реестр документов с EDI-N.com

--#region Заказ внешний Формирование (только для заказов Маркетвина)

SELECT 'Заказ внешний Формирование (только для заказов Маркетвина)'
--джоб EDI шаг Receiving_New_MarketA_Orders 
--[ap_EDI_Receiving_New_MarketA_Orders] переливает заказы с [S-SQL-D4].[ElitR].[dbo].[t_EOExp] в [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_ORDERS_2

SELECT *
FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExp]
where CAST(docid as varchar(30)) = @docid
ORDER BY 1

SELECT *
FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExpD]
where chid in
	(SELECT chid
	FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExp]
	where CAST(docid as varchar(30)) = @docid)
ORDER BY 1

--#endregion Заказ внешний Формирование (только для заказов Маркетвина)

--#region Заказ ALEF_EDI_ORDERS_2 и ALEF_EDI_ORDERS_2_POS

SELECT 'Заказ ALEF_EDI_ORDERS_2 и ALEF_EDI_ORDERS_2_POS'
--exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=1;
--джоб EDI шаг ZAM-S2- запустить exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=1;

SELECT *
FROM ALEF_EDI_ORDERS_2
where ZEO_ORDER_NUMBER = CAST(@docid as varchar(30))

SELECT *
FROM ALEF_EDI_ORDERS_2_POS
where ZEP_ORDER_ID in (SELECT ZEO_ORDER_ID
	FROM ALEF_EDI_ORDERS_2
	where ZEO_ORDER_NUMBER = CAST(@docid as varchar(30)))
ORDER BY 1
,        ZEP_POS_ID

--#endregion Заказ ALEF_EDI_ORDERS_2 и ALEF_EDI_ORDERS_2_POS

--#region Заказ at_t_IORec_С и at_t_IORecD_С

SELECT 'Заказ at_t_IORec_С и at_t_IORecD_С'

SELECT *
FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С
where IOH_ORDER = CAST(@docid as varchar(30))

SELECT *
FROM [S-SQL-D4].[Elit].[dbo].at_t_IORecD_С
WHERE IOD_IOH_ID in (SELECT IOH_ID
	FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С
	WHERE IOH_ORDER = CAST(@docid as varchar(30)))
ORDER BY 1
,        IOD_POS

--#endregion Заказ at_t_IORec_С и at_t_IORecD_С

--#region Заказ внутренний: Формирование

SELECT 'Заказ внутренний: Формирование'

SELECT *
FROM [S-SQL-D4].[Elit].[dbo].[t_IORec]
where OrderID = CAST(@docid as varchar(30))

SELECT *
FROM [S-SQL-D4].[Elit].[dbo].[t_IORecD]
where chid in (SELECT chid
	FROM [S-SQL-D4].[Elit].[dbo].[t_IORec]
	where OrderID = CAST(@docid as varchar(30)))
ORDER BY 1
,        SrcPosID

--#endregion Заказ внутренний: Формирование

--#region Заказ внутренний: Резерв

SELECT 'Заказ внутренний: Резерв'

SELECT StateCode, *
FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes]
where OrderID = CAST(@docid as varchar(30))

SELECT *
FROM [S-SQL-D4].[Elit].[dbo].[at_t_IOResD]
where chid in (SELECT chid
	FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes]
	where OrderID = CAST(@docid as varchar(30)))
ORDER BY 1
,        SrcPosID

--#endregion Заказ внутренний: Резерв

--#region Расходная накладная

SELECT 'Расходная накладная'
-- Здесь Девочки руками делают РН мастером копирования

SELECT *
FROM [S-SQL-D4].[Elit].[dbo].[t_Inv]
WHERE OrderID = CAST(@docid as varchar(30))

SELECT *
FROM [S-SQL-D4].[Elit].[dbo].[t_InvD]
where chid in (SELECT chid
	FROM [S-SQL-D4].[Elit].[dbo].[t_Inv]
	where OrderID = CAST(@docid as varchar(30)))
ORDER BY 1
,        SrcPosID

--#endregion Расходная накладная

--#region EXTRA
/*
SELECT * FROM [s-sql-d4].Elit.dbo.r_ProdMP where prodid in (34235) and plid = 66

SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where /*c.UsePL = 1 and*/ c.CompID =7060

SELECT * FROM [S-SQL-D4].[Elit].[dbo].t_Rem where prodid in (2999,31878,3101,31879,3127)
SELECT * FROM [S-SQL-D4].[Elit].[dbo].t_Rem where prodid in (32361)
SELECT * FROM [S-SQL-D4].[Elit].[dbo].t_Rem where prodid in (32361)
SELECT * FROM [S-SQL-D4].[Elit].[dbo].t_Rem where prodid in (34235)
SELECT * FROM [S-SQL-D4].[Elit].[dbo].r_prodec where ExtProdID in ('602668')
SELECT * FROM [S-SQL-D4].[Elit].[dbo].r_prodec where CompID in (7060) and ExtProdID in ('602668','0202020243','0202010160')

SELECT rpec.ProdID, m.ZEO_ORDER_ID, d.ZEP_POS_KOD, d.ZEP_POS_QTY, tiord.Qty, tiord.Qty/d.ZEP_POS_QTY AS 'Metro_val'
FROM ALEF_EDI_ORDERS_2 m
JOIN ALEF_EDI_ORDERS_2_POS d ON d.ZEP_ORDER_ID = m.ZEO_ORDER_ID
JOIN [S-SQL-D4].[Elit].[dbo].[t_IORec] tior ON tior.OrderID = m.ZEO_ORDER_NUMBER
JOIN [S-SQL-D4].[Elit].[dbo].[t_IORecD] tiord ON  tiord.ChID = tior.ChID
JOIN [S-SQL-D4].[Elit].[dbo].[r_ProdEC] rpec ON rpec.ProdID = tiord.ProdID AND rpec.ExtProdID = d.ZEP_POS_KOD AND rpec.CompID = tior.CompID
WHERE m.ZEO_AUDIT_DATE > '20170101' AND tior.CompID in (7001,7003,7002) --AND d.ZEP_POS_QTY != 0--m.ZEO_ORDER_ID = '463620540'
ORDER BY 6,1

SELECT * FROM ALEF_EDI_ORDERS_2 m
JOIN ALEF_EDI_ORDERS_2_POS d ON d.ZEP_ORDER_ID = m.ZEO_ORDER_ID
WHERE m.ZEO_AUDIT_DATE > '20190301' AND d.ZEP_POS_QTY = 0



SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С where IOH_ORDER = '600008086'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORecD_С where IOD_IOH_ID = 1042867

SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = '600008086'


select ZEO_ORDER_ID from dbo.ALEF_EDI_ORDERS_2
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

SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_ID IN (SELECT ZEP_ORDER_ID FROM ALEF_EDI_ORDERS_2_POS where ZEP_POS_KOD IN ('6032166','6032033','6032152','6032173','6032427'))
SELECT * FROM ALEF_EDI_ORDERS_2_POS where ZEP_POS_KOD IN ('6032166','6032033','6032152','6032173','6032427')

SELECT * FROM [S-SQL-D4].[Elit].[dbo].r_ProdEC 

SELECT DISTINCT ProdID from r_ProdEC rpe WHERE rpe.ExtProdID IN ('1135889','6032166','6032033','6032173','1135894','1135923','1135924','1135928','1135891','6032152','6032427','1135898')
AND rpe.ProdID NOT IN (26213,31815,31874,29151,28585,28586,29152,31878,26168,31880,3127 ,31879,30843)


SELECT * FROM z_tables

SELECT top 1000 * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С 
where IOH_DEP_DATE = '2019-01-21 00:00:00.000' and IOH_STOCK = 11
ORDER BY 3 desc

--ap_EDI_Importing_Orders_OT

SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_EOExp] m
JOIN [S-SQL-D4].[Elit].[dbo].[t_EOExpD] d on d.ChID = m.ChID
WHERE d.prodid = 601059 
ORDER BY DocDate desc

*/
/*
IF OBJECT_ID (N'tempdb..#EDI2OT', N'U') IS NOT NULL DROP TABLE #EDI2OT

select
-- Existing Staff
ZEO_ORDER_ID,
ZEO_ORDER_NUMBER,
ZEO_ORDER_DATE,
(SELECT TOP 1 ZEC_KOD_KLN_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_KOD, --700
(SELECT TOP 1 ZEC_KOD_ADD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_ADD,--1001
(SELECT TOP 1 ZEC_KOD_SKLAD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_SKL,
(SELECT TOP 1 ZEC_KOD_BASE FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_BASE,
cast(0 as tinyint) as ZEO_OT_SKL_CH,
cast('' as varchar(200)) ZEO_NOTE,
ZEP_POS_ID, 
ZEP_POS_KOD, 
ZEP_POS_QTY, 
ZEO_AUDIT_DATE,
ZEO_XML_HEAD,
-- New Staff
cast(0 as int) as ZE_ORDER_ExID,
cast(0 as tinyint) as ZE_ORDER_SubID,
cast(0 as smallint) as ZE_KLN_OT_DELAY,
cast(0 as smallint) as ZE_KLN_OT_PRICE,
cast('' as varchar(200)) as ZE_KLN_OT_JOB3,
cast(0 as int) as ZE_POS_OT_KOD,
cast('' as varchar(42)) as ZE_POS_BAR,
cast(0 as numeric(21,9)) as ZE_POS_CENA,
cast(4 as int) as ZE_CODE_3,
cast(110 as int) as ZE_STATUS,
cast(0 as tinyint) as ZE_READY_STATUS
 into #EDI2OT
from dbo.ALEF_EDI_ORDERS_2 
join dbo.ALEF_EDI_ORDERS_2_POS on ZEO_ORDER_ID = ZEP_ORDER_ID
where 
ZEO_ORDER_ID in (28572)
--ZEO_ORDER_STATUS in (0,1)
--or ZEO_ORDER_ID in (
--	select EOC_ORDER_ID
--	from dbo.ALEF_EDI_ORDERS_CHANGES
--	where EOC_COMMITTED = 0
--	and EOC_TYPE = 200)

SELECT * FROM #EDI2OT

update #EDI2OT
set
ZE_POS_OT_KOD = SelectedProd
from
	(select ZEO_ORDER_ID, ZEP_POS_ID, MAX(ProdID) SelectedProd 
	from 
		(select ZEO_ORDER_ID, ZEP_POS_ID, ZEP_POS_QTY, ProdID, Rem, MAX(Rem) OVER(partition by ZEO_ORDER_ID, ZEP_POS_ID) MaxRem 
		from 
			(
			select ZEO_ORDER_ID, ZEP_POS_ID, ZEP_POS_QTY, ProdID, isnull((select sum(Qty-AccQty) from [s-sql-d4].Elit.dbo.t_Rem r where r.ProdID = ec.ProdID and StockID = ZEO_OT_SKL),0) Rem 
			from [s-sql-d4].Elit.dbo.r_ProdEC ec 
			join #EDI2OT t on ExtProdID = ZEP_POS_KOD and Compid = ZEO_OT_KOD 
					--Pashkovv '2019-04-02 11:51:10.920' теперь в альтернативные товары попадают только товары которые присутствуют в прайсе 66
		and exists(SELECT top 1 1 FROM [s-sql-d4].Elit.dbo.r_ProdMP mp 
					where mp.PLID = (SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = ZEO_OT_KOD) 
					and mp.ProdID = ec.ProdID
					)

			) as R
		) as RR
	where Rem = MaxRem or Rem >= ZEP_POS_QTY
	group by ZEO_ORDER_ID, ZEP_POS_ID) as Pr
where Pr.ZEO_ORDER_ID = #EDI2OT.ZEO_ORDER_ID
and Pr.ZEP_POS_ID = #EDI2OT.ZEP_POS_ID
and ZE_POS_OT_KOD = 0
and ZE_READY_STATUS = 0

SELECT * FROM #EDI2OT

SELECT PLID,UsePL,* FROM [s-sql-d4].Elit.dbo.r_Comps ORDER BY 1
SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = ZEO_OT_KOD

-- Разделяем по складам 4 и 1104; 220 и 1130; 11 и 1111 
create table #MarketA(
or_ID varchar(12),
or_Sklad smallint,
or_PosID smallint,
alt_ProdID int,
alt_ProdQty int
);

;with kika as(
	select 
	ZEO_ORDER_ID,
	ZEO_OT_SKL,
	ZEP_POS_ID,
	ZEP_POS_QTY,
	ROW_NUMBER() over(partition by ZEO_ORDER_ID,ZEP_POS_ID order by ALT_QTY desc) ROW_ID,
	ALT_PROD,
	ALT_QTY
	from 
		(
		select ZEO_ORDER_ID, case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end ZEO_OT_SKL, ZEP_POS_ID, ZEP_POS_QTY,
		ec.prodid ALT_PROD, isnull((select sum(Qty) from [s-sql-d4].Elit.dbo.t_Rem r where ec.ProdID = r.ProdID and StockID = case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end),0) ALT_QTY
		from #EDI2OT
		inner join [s-sql-d4].Elit.dbo.r_ProdEC ec on Compid = ZEO_OT_KOD and extprodid = ZEP_POS_KOD
		where ZEO_OT_KOD in (10797,10798)
		and ZEO_OT_SKL in (4,11,220)
		and ZEO_OT_SKL_CH = 0
		and ZEP_POS_QTY > 0
		) as T
	where ALT_QTY > 0
)
insert #MarketA
select ZEO_ORDER_ID, ZEO_OT_SKL, ZEP_POS_ID, ALT_PROD, case when ZEP_POS_QTY >= STOCKS then ALT_QTY else ZEP_POS_QTY - (STOCKS - ALT_QTY) end QTY
from
	(select *,	(select SUM(ALT_QTY) from kika k2 where k1.ZEO_ORDER_ID = k2.ZEO_ORDER_ID and k1.ZEP_POS_ID = k2.ZEP_POS_ID and k2.ROW_ID <= k1.ROW_ID) STOCKS
	from kika k1) as T
where ZEP_POS_QTY >= STOCKS
or (ZEP_POS_QTY < STOCKS and ZEP_POS_QTY > isnull((select SUM(ALT_QTY) from kika k where k.ZEO_ORDER_ID = T.ZEO_ORDER_ID and k.ZEP_POS_ID = T.ZEP_POS_ID and k.ROW_ID < T.ROW_ID),0))

SELECT * FROM #MarketA
SELECT * FROM #EDI2OT


		select ZEO_ORDER_ID, case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end ZEO_OT_SKL, ZEP_POS_ID, ZEP_POS_QTY,
		ec.prodid ALT_PROD,
		 isnull((select sum(Qty) from [s-sql-d4].Elit.dbo.t_Rem r where ec.ProdID = r.ProdID and StockID = case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end),0) ALT_QTY
		from #EDI2OT
		inner join [s-sql-d4].Elit.dbo.r_ProdEC ec on Compid = ZEO_OT_KOD and extprodid = ZEP_POS_KOD
		where ZEO_OT_KOD in (10797,10798)
		and ZEO_OT_SKL in (4,11,220)
		and ZEO_OT_SKL_CH = 0
		and ZEP_POS_QTY > 0
		and exists(SELECT top 1 1 FROM [s-sql-d4].Elit.dbo.r_ProdMP mp 
					where mp.PLID = (SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = ZEO_OT_KOD) 
					and mp.ProdID = ec.ProdID
					)

		SELECT * FROM [s-sql-d4].Elit.dbo.r_prodmp where PLID = 66 and ProdID = 32479


			select ZEO_ORDER_ID, ZEP_POS_ID, ZEP_POS_QTY, ProdID, isnull((select sum(Qty-AccQty) from [s-sql-d4].Elit.dbo.t_Rem r where r.ProdID = ec.ProdID and StockID = ZEO_OT_SKL),0) Rem 
			from [s-sql-d4].Elit.dbo.r_ProdEC ec 
			join #EDI2OT t on ExtProdID = ZEP_POS_KOD and Compid = ZEO_OT_KOD 
			--Pashkovv '2019-04-02 11:51:10.920' теперь в альтернативные товары попадают только товары которые присутствуют в прайсе 66
			and exists(SELECT top 1 1 FROM [s-sql-d4].Elit.dbo.r_ProdMP mp 
						where mp.PLID = (SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = ZEO_OT_KOD) 
						and mp.ProdID = ec.ProdID
						)


select
-- Existing Staff
(SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = (SELECT TOP 1 ZEC_KOD_KLN_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD)) plid,
ZEO_ORDER_ID,
ZEO_ORDER_NUMBER,
ZEO_ORDER_DATE,
(SELECT TOP 1 ZEC_KOD_KLN_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_KOD, --700
(SELECT TOP 1 ZEC_KOD_ADD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_ADD,--1001
(SELECT TOP 1 ZEC_KOD_SKLAD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_SKL,
(SELECT TOP 1 ZEC_KOD_BASE FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_BASE,
cast(0 as tinyint) as ZEO_OT_SKL_CH,
cast('' as varchar(200)) ZEO_NOTE,
ZEP_POS_ID, 
ZEP_POS_KOD, 
ZEP_POS_QTY, 
ZEO_AUDIT_DATE,
ZEO_XML_HEAD,
-- New Staff
cast(0 as int) as ZE_ORDER_ExID,
cast(0 as tinyint) as ZE_ORDER_SubID,
cast(0 as smallint) as ZE_KLN_OT_DELAY,
cast(0 as smallint) as ZE_KLN_OT_PRICE,
cast('' as varchar(200)) as ZE_KLN_OT_JOB3,
cast(0 as int) as ZE_POS_OT_KOD,
cast('' as varchar(42)) as ZE_POS_BAR,
cast(0 as numeric(21,9)) as ZE_POS_CENA,
cast(4 as int) as ZE_CODE_3,
cast(110 as int) as ZE_STATUS,
cast(0 as tinyint) as ZE_READY_STATUS
 --into #EDI2OT
from dbo.ALEF_EDI_ORDERS_2 
join dbo.ALEF_EDI_ORDERS_2_POS on ZEO_ORDER_ID = ZEP_ORDER_ID
where ZEO_ORDER_STATUS in (0,1)
or ZEO_ORDER_ID in (
	select EOC_ORDER_ID
	from dbo.ALEF_EDI_ORDERS_CHANGES
	where EOC_COMMITTED = 0
	and EOC_TYPE = 200)


SELECT * from dbo.ALEF_EDI_ORDERS_2 
join dbo.ALEF_EDI_ORDERS_2_POS on ZEO_ORDER_ID = ZEP_ORDER_ID
where ZEO_ORDER_STATUS in (0,1) 



EXEC ALEF_WEB_EDI_GET_PROD_MarketA '29368'

SELECT * FROM ALEF_EDI_ORDERS_2
SELECT * FROM ALEF_EDI_ORDERS_2_POS
WHERE ZEP_ORDER_ID = '29368'

*/
--#endregion EXTRA