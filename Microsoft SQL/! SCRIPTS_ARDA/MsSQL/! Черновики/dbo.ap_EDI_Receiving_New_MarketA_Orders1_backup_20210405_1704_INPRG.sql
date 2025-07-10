USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EDI_Receiving_New_MarketA_Orders]    Script Date: 05.04.2021 17:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_EDI_Receiving_New_MarketA_Orders]    
AS    
BEGIN
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Получение новых заказов МаркетВин (старое название: Маркет-А).
Импорт из заказ внешний формирование [S-SQL-D4].[ELITR].dbo.t_EOExp/t_EOExpD в
-->> [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.Alef_Elit ALEF_EDI_ORDERS_2 / ALEF_EDI_ORDERS_2_POS
В том числе заказы Решетняк (Решетняк уже давно не работает).
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ADDED] Pashkovv '2019-10-22 09:23' добавил предприятие 80.

IF OBJECT_ID (N'tempdb..#tmp', N'U') IS NOT NULL DROP TABLE #tmp

	SELECT 
	h.chid 'OrderID', 
	Docid 'OrderNumber', 
	DocDate, 
	isnull(ExpDate,dateadd(dd,1,DocDate)) 'ExpDate', 
	case        
		when OurID = 7 then 700 
		when OurID in (6,9) and Stockid = 1203 then 181
		when OurID in (6,9,12) and Stockid = 1203 and CompID = 171 then 171
		when OurID = 12 and StockID = 1001 and CompID = 82 then 701
		when OurID = 12 and StockID = 1001 then 700
		when CompID = 71 then 971 
		when CompID = 81 then 981
		when CompID = 171 then 171
		when CompID = 181 then 181
        --[ADDED] Pashkovv '2019-10-22 09:23' добавил предприятие 80.
		when CompID = 80 then 981
	end 'BaseGLN', 
	StockID 'AddGLN', 
	srcposid 'PosID', 
	Prodid, 
	Qty 
	
    INTO #tmp
	
    FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExp] h 
    --[ADDED] Pashkovv '2019-10-22 09:23' добавил предприятие 80.
	--inner join [S-SQL-D4].[ElitR].[dbo].[t_EOExpD] d on h.chid = d.chid and OurID in (6,7,9,12) and CodeID3 = 8
	inner join [S-SQL-D4].[ElitR].[dbo].[t_EOExpD] d on h.chid = d.chid and OurID in (6,7,9,12) and CodeID3 = 8 and CompID in (71,81,171,181,82,80) 
	WHERE 1 = 1
    and DocDate >= dateadd(dd, -10, cast(CURRENT_TIMESTAMP as date))
	and DocDate >= cast('2014-10-13' as date)
	--and not exists(select top 1 1 from dbo.ALEF_EDI_ORDERS_2 o where o.ZEO_ORDER_ID = h.chid) 
	--Pashkovv '2020-04-23 14:11:17.902' вылечил последствия добавления в ZEO_ORDER_ID данных на R000000000
	and not exists(select top 1 1 from dbo.ALEF_EDI_ORDERS_2 o where o.ZEO_ORDER_ID = cast(h.chid as varchar(10))) 

	SELECT * FROM #TMP

	/*
	--delete from #tmp where exists(select * from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_ID = OrderID) 
	*/

	INSERT dbo.ALEF_EDI_ORDERS_2(ZEO_ORDER_ID, ZEO_ORDER_NUMBER, ZEO_ORDER_DATE, ZEO_ZEC_BASE, ZEO_ZEC_ADD, ZEO_ORDER_STATUS, ZEO_AUDIT_DATE)
		select OrderID, OrderNumber, ExpDate, max(BaseGLN), AddGLN, 0, CURRENT_TIMESTAMP
		from #tmp
		group by OrderID, OrderNumber, ExpDate, AddGLN;

	INSERT dbo.ALEF_EDI_ORDERS_2_POS(ZEP_ORDER_ID, ZEP_POS_ID, ZEP_POS_KOD, ZEP_POS_QTY, ZEP_ORDER_STATUS)
		select OrderID, PosID, Prodid, Qty, 0
		from #tmp;

	DROP TABLE #TMP

END;



GO
