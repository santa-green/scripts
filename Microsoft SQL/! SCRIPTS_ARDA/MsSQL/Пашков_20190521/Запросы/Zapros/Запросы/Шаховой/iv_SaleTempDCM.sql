ALTER VIEW dbo.iv_SaleTempDCM
AS
	SELECT
		d.ChID, d.SrcPosID, d.ProdID, d.TaxID, d.UM, d.Qty, 
		d.RealQty, d.PriceCC_wt, d.SumCC_wt, d.PurPriceCC_wt, 
		d.PurSumCC_wt, d.BarCode, d.RealBarCode, d.PLID, 
		d.UseToBarQty, d.PosStatus, d.ServingTime, d.CSrcPosID, 
		d.ServingID, d.CReasonID, d.PrintTime, d.CanEditQty
	FROM t_SaleTempD d WITH (NOLOCK) 
	LEFT JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
	WHERE cm.ProdID IS NULL
UNION ALL
	SELECT
		d.ChID, MIN(d.SrcPosID) SrcPosID, d.ProdID, NULL TaxID, p.UM, 
		SUM(Qty), 
		1 RealQty, 
		SUM(SumCC_wt) / SUM(Qty), 
		SUM(SumCC_wt) SumCC_wt, 
		SUM(PurSumCC_wt) / SUM(Qty), 
		SUM(PurSumCC_wt) PurSumCC_wt, NULL BarCode, NULL RealBarCode, d.PLID, 
		NULL UseToBarQty, NULL PosStatus, NULL ServingTime, NULL CSrcPosID, 
		NULL ServingID, NULL CReasonID, NULL PrintTime, NULL CanEditQty
	FROM 
		(SELECT
			 m.ChID, MIN(m.SrcPosID) SrcPosID, m.PLID, m.ProdID,
			 CASE WHEN CASE WHEN MAX(MaxQty) >= 1 AND SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / ISNULL(NULLIF(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)),0), MAX(m.Qty))> MAX(MaxQty)
					   THEN CAST(CEILING(SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / MAX(MaxQty)) AS numeric(21, 9)) 
					   ELSE CAST(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)) AS numeric(21, 9))
				  END < MAX(CMQty) /*ќбработка, если количество порций сопутствующих товаров больше количества корзин основных блюд - использовать его*/
			 THEN MAX(CMQty) 
			 ELSE CASE WHEN MAX(MaxQty) >= 1 AND SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / ISNULL(NULLIF(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)),0), MAX(m.Qty)) > MAX(MaxQty)
					   THEN CAST(CEILING(SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / MAX(MaxQty)) AS numeric(21, 9)) 
					   ELSE CAST(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)) AS numeric(21, 9))
					END 
			 END Qty, 
			 SUM(m.SumCC_wt) SumCC_wt, SUM(m.PurSumCC_wt) PurSumCC_wt
		FROM (
			SELECT 
				d.ChID, MIN(d.SrcPosID) SrcPosID, d.PLID, d.ProdID, d.CMPosID, SUM(d.Qty) Qty, SUM(d.SumCC_wt) SumCC_wt, SUM(d.PurSumCC_wt) PurSumCC_wt,
				MAX(d.MaxQty) MaxQty, IsRelated, t.CMQty
			FROM (SELECT 
						d.ChID, MIN(d.SrcPosID) SrcPosID, d.PLID, cm.ProdID, cm.SrcPosID CMPosID, CAST(CEILING(SUM(Qty)/MAX(DetQty)) AS numeric(21,9)) Qty, SUM(d.SumCC_wt) SumCC_wt, SUM(d.PurSumCC_wt) PurSumCC_wt, MAX(MaxQty) MaxQty, IsRelated /*ќпредел€ем количество условных едениц максимума по товарам*/
				  FROM t_SaleTempD d
				  INNER JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
				  INNER JOIN r_ProdMP mp WITH (NOLOCK) ON d.ProdID = mp.ProdID AND d.PLID = mp.PLID
				  GROUP BY d.ChID, d.PLID, cm.ProdID, cm.SrcPosID, IsRelated, SubProdID
				  ) d
			INNER JOIN (SELECT 
							ChID, CMPosID, SUM(Qty) CMQty /*ќпредел€ем сумму условных едениц максимума по каждой категории. ( лиенту доступно по одной еденице из каждой категории)*/
						FROM (SELECT 
									d.ChID, cm.SrcPosID CMPosID, CAST(CEILING(SUM(Qty)/MAX(DetQty)) AS numeric(21,9)) Qty /*ќпредел€ем количество условных едениц максимума по товарам*/
							  FROM t_SaleTempD d
							  INNER JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
							  INNER JOIN r_ProdMP mp WITH (NOLOCK) ON d.ProdID = mp.ProdID AND d.PLID = mp.PLID
							  GROUP BY d.ChID, cm.SrcPosID, SubProdID
							  ) tt 
						GROUP BY ChID, CMPosID
						) t ON t.ChID = d.ChID AND t.CMPosID = d.CMPosID 
			GROUP BY
				d.ChID, d.PLID, d.CMPosID, IsRelated, d.ProdID/*, d.SubProdID, d.DetQty*/, t.CMQty
			HAVING SUM(d.Qty) <> 0
				) m
		GROUP BY m.ChID, m.ProdID, m.PLID
	) d
	INNER JOIN r_Prods p WITH (NOLOCK) ON d.ProdID = p.ProdID
	GROUP BY d.ChID, d.ProdID, d.PLID, p.UM




