--S-ppc
--ALEF_WEB_EDI_GET_PROD_MarketA

select 
		ZEP_ORDER_ID,
		ChArda,--isnull((select top 1 ChID from [s-sql-d4].Elit.dbo.at_t_IORes where OrderID = ZEO_ORDER_NUMBER and CompID = Ord_CompID and StateCode in (120,140)),0) AS ChArda,
		Ord_CompID,
		ZEP_POS_ID, 
		ZEP_POS_KOD,
		er_ProdMame,
		ZEP_POS_QTY,
		--ISNULL((select MIN(ProdID) from [s-sql-d4].Elit.dbo.r_ProdEC where ExtProdID = ZEP_POS_KOD and Compid in (10793,10795,10797,10798)),0),
		(
			SELECT TOP 1 ProdID FROM [S-SQL-D4].Elit.dbo.at_t_IOResD WHERE ChID = ChArda
																	   AND ProdID IN (SELECT DISTINCT ProdID FROM [s-sql-d4].Elit.[dbo].r_ProdEC WHERE CompID = (SELECT CompID FROM [s-sql-d4].Elit.[dbo].at_t_IORes WHERE ChID = T.ChArda) AND ExtProdID = T.ZEP_POS_KOD)
																	   --AND T.ZEP_POS_QTY = Qty
		) p_posCodeOT,
		null,
		Ord_Stock,
		0,
		0,
		0,
		ISNULL((select plid from [s-sql-d4].Elit.[dbo].r_Comps where CompID = Ord_CompID),0),
		0,
		null,
		null,
		null,
		null
		from 
(
select 
     ZEP_ORDER_ID, 
     ZEO_ORDER_NUMBER,
     ZEP_POS_ID,
	 isnull((select top 1 ChID from [s-sql-d4].Elit.dbo.at_t_IORes where OrderID = ZEO_ORDER_NUMBER and CompID = ((select ZEC_KOD_KLN_OT from dbo.ALEF_EDI_GLN_OT where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD)) and StateCode in (120,140)),0) AS ChArda,
     (select ZEC_KOD_KLN_OT from dbo.ALEF_EDI_GLN_OT where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) Ord_CompID,
     (select ZEC_KOD_SKLAD_OT from dbo.ALEF_EDI_GLN_OT where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) Ord_Stock,
     ZEP_POS_KOD, 
     isnull((select ProdName from [s-sql-d4].ElitR.[dbo].r_Prods where ProdID = cast(ZEP_POS_KOD as int)),'неизвестно') er_ProdMame,
     ZEP_POS_QTY
     from dbo.ALEF_EDI_ORDERS_2_POS d
     join dbo.ALEF_EDI_ORDERS_2 h on ZEP_ORDER_ID = ZEO_ORDER_ID and ZEP_ORDER_ID = 545673726--30968--30960
) AS T


/*
SELECT * FROM [s-sql-d4].ElitR.[dbo].r_ProdEC WHERE ProdID = 803261--600159
SELECT * FROM [s-sql-d4].ElitR.[dbo].r_Comps WHERE CompID IN (80,81)

SELECT ProdID FROM [S-SQL-D4].Elit.dbo.at_t_IOResD WHERE ChID = 101527974


*/