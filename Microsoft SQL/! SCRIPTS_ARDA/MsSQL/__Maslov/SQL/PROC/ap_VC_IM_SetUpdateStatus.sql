ALTER PROCEDURE [dbo].[ap_VC_IM_SetUpdateStatus] @RegionID INT = -1
AS
BEGIN
/*
Устанавливаем статусы обновления для товаров интренет-магазина из Днепра

Brevis descriptio
Здесь устанавливаются статусы товаров, которые можно или нужно установить
отдельно от основных скриптов.

*/

/*
EXEC ap_VC_IM_SetUpdateStatus @RegionID = 2
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET NOCOUNT ON

IF @RegionID = -1
BEGIN
	RETURN;
END;

DECLARE @SQL_Select NVARCHAR(MAX), @IM_table VARCHAR(100)

--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
SELECT @IM_table = 'r_ShopifyProds'--(SELECT RefName FROM r_Uni WHERE RefTypeID = 1000000015 AND RefID = @RegionID)

SET @SQL_Select = 'IF (SELECT COUNT(*) FROM '
				+ @IM_table 
				+ ' WHERE IsActive = 1 AND Price = 0) != 0 BEGIN	UPDATE '
				+ @IM_table
				+ ' SET IsActive = 0, UpdateDate = GETDATE(), UpdateState = 2 WHERE IsActive = 1 AND Price = 0 AND UpdateState = 0 END; '
				+ ' IF (SELECT COUNT(*) FROM '
				+ @IM_table 
				--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
				--+ ' WHERE IsActive = 0 AND Price > 0 AND Qty > 0) != 0 BEGIN	UPDATE '
				+ ' WHERE IsActive = 0 AND Price > 0 AND (QtyDp + QtyKv + QtyKh) > 0) != 0 BEGIN	UPDATE '
				+ @IM_table
				--[CHANGED] Maslov Oleg '2020-03-20 10:23:43.453' Переходим на один сайт. И вместе с тем на одну таблицу вместо трех.
				--+ ' SET IsActive = 1, UpdateDate = GETDATE(), UpdateState = 2 WHERE IsActive = 0 AND Price > 0 AND Qty > 0 AND UpdateState = 0 END;'
				+ ' SET IsActive = 1, UpdateDate = GETDATE(), UpdateState = 2 WHERE IsActive = 0 AND Price > 0 AND (QtyDp + QtyKv + QtyKh) > 0 AND UpdateState = 0 END;'

EXEC sp_executesql @SQL_Select
/*
--Выключаем товары, цена которых равна нулю
IF (SELECT COUNT(*) FROM r_ShopifyProdsDp WHERE IsActive = 1 AND Price = 0) != 0
BEGIN

	UPDATE r_ShopifyProdsDp SET IsActive = 0, UpdateDate = GETDATE(), UpdateState = 2
	WHERE IsActive = 1 AND Price = 0 AND UpdateState = 0

END;

--Включаем товары, цена которых не равны нулю и есть остаток.
IF (SELECT COUNT(*) FROM r_ShopifyProdsDp WHERE IsActive = 0 AND Price > 0 AND Qty > 0) != 0
BEGIN

	UPDATE r_ShopifyProdsDp SET IsActive = 1, UpdateDate = GETDATE(), UpdateState = 2
	WHERE IsActive = 0 AND Price > 0 AND Qty > 0 AND UpdateState = 0

END;
*/
END