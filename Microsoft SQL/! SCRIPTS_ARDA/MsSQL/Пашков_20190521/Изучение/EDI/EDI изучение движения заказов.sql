USE Alef_Elit

--DECLARE @docid int = 45215838
DECLARE @docid VARCHAR(max) = '2018019037'


----Заказ внешний Формирование
--SELECT * FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExp] where docid = @docid ORDER BY 1
--SELECT * FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExpD] where chid in (SELECT chid FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExp] where docid = @docid) ORDER BY 1

SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = CAST(@docid as varchar(30))
SELECT * FROM ALEF_EDI_ORDERS_2_POS where ZEP_ORDER_ID in (SELECT ZEO_ORDER_ID FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = CAST(@docid as varchar(30))) ORDER BY 1, ZEP_POS_ID

--Заказ внутренний: Формирование
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORecD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID

--Заказ внутренний: Резерв
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IOResD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID

--Расходная накладная
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_InvD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID




/*
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


SELECT DISTINCT ProdID from r_ProdEC rpe WHERE rpe.ExtProdID IN ('1135889','6032166','6032033','6032173','1135894','1135923','1135924','1135928','1135891','6032152','6032427','1135898')
AND rpe.ProdID NOT IN (26213,31815,31874,29151,28585,28586,29152,31878,26168,31880,3127 ,31879,30843)

*/