USE Alef_Elit

--DECLARE @docid int = 45215838
DECLARE @docid VARCHAR(max) = '45233134'


SELECT 'Заказ внешний Формирование'
SELECT * FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExp] where CAST(docid as varchar(30)) = @docid ORDER BY 1
SELECT * FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExpD] where chid in (SELECT chid FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExp] where CAST(docid as varchar(30)) = @docid) ORDER BY 1


SELECT 'Заказ ALEF_EDI_ORDERS_2 и ALEF_EDI_ORDERS_2_POS'
SELECT * FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_NUMBER = CAST(@docid as varchar(30))
SELECT * FROM ALEF_EDI_ORDERS_2_POS where ZEP_ORDER_ID in (SELECT ZEO_ORDER_ID FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = CAST(@docid as varchar(30))) ORDER BY 1, ZEP_POS_ID

SELECT 'Заказ at_t_IORec_С и at_t_IORecD_С'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С where IOH_ORDER = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORecD_С where IOD_IOH_ID in (SELECT IOH_ID FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С where IOH_ORDER = CAST(@docid as varchar(30))) ORDER BY 1, IOD_POS


SELECT 'Заказ внутренний: Формирование'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORecD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID

SELECT 'Заказ внутренний: Резерв'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IOResD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID

SELECT 'Расходная накладная'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_InvD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID

/*
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
SELECT * FROM [S-SQL-D4].[Elit].[dbo].t_IORec WHERE OrderID = '45233134'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].t_IORecD WHERE ChID = 102086562
SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORecD_С where IOD_IOH_ID = 1042867

SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_AUDIT_DATE > '20190301'

SELECT * FROM [S-SQL-D4].[Elit].[dbo].r_ProdEC

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
*/