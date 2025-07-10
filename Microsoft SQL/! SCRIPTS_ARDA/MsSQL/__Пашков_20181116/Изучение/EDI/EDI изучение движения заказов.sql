USE Alef_Elit

--DECLARE @docid int = 45215838
DECLARE @docid VARCHAR(max) = '45216404'


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




