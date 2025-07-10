/*для прайс листов на утро*/

--IF OBJECT_ID (N'dbo.at_r_ChPriceMorning', N'U') IS NOT NULL DROP TABLE dbo.at_r_ChPriceMorning

TRUNCATE TABLE dbo.at_r_ChPriceMorning

--записть изменений цен по всем прайсам  
INSERT dbo.at_r_ChPriceMorning  
--select * into dbo.at_r_ChPriceMorning from (
	SELECT mp.ProdID 'ProdID', mp.PLID 'PLID', [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) 'PriceToDay',
		mp.PriceMC,  s.PriceMC oldPriceMC, mp.PromoPriceCC, s.PromoPriceCC oldPromoPriceCC, mp.BDate, mp.EDate, s.BDate OldBDate, s.EDate OldEDate,
		[dbo].[af_GetPriceYesterday](mp.ProdID, mp.PLID) 'PriceBefore',
		case [dbo].[af_GetTypePrice](mp.ProdID,mp.PLID) when 1 then 'Акционный - '  when 2 then 'Количественный - '  else 'Обычный - ' end 
		+ case when [dbo].[af_GetPriceYesterday](mp.ProdID, mp.PLID) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) then 'текущая'  else 'основная'  end 'ChPrice'
		, ps.ProdName ProdName
		,[dbo].[af_GetTypePrice](mp.ProdID,mp.PLID) as TypePrice 
		,case when [dbo].[af_GetPriceYesterday](mp.ProdID, mp.PLID) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) then 1  else 0  end 'ChPriceToDay'
	FROM dbo.r_ProdMP_Snapshot_Yesterday s WITH(NOLOCK)
	RIGHT JOIN  dbo.r_ProdMP_Snapshot_Last mp WITH(NOLOCK) ON mp.ProdID = s.ProdID and mp.PLID = s.PLID AND mp.PLID IN (70,83,84,85,86) AND mp.InUse = 1
	JOIN  dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = mp.ProdID 
	WHERE 
	(
	( [dbo].[af_GetPriceYesterday](mp.ProdID, mp.PLID) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID)
	AND [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) <> 0
	)
	OR	s.PriceMC <> mp.PriceMC -- если поменялась основная цена
	)
--) tt

SELECT * FROM dbo.at_r_ChPriceMorning ORDER BY PLID,ChPrice,ProdID
