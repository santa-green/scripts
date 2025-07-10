
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
				d.ChID, d.PLID, d.CMPosID, IsRelated, d.ProdID, t.CMQty
				
				) m
		GROUP BY m.ChID, m.ProdID, m.PLID
	) d
	INNER JOIN r_Prods p WITH (NOLOCK) ON d.ProdID = p.ProdID
	GROUP BY d.ChID, d.ProdID, d.PLID, p.UM

GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*ќбновление текста представлени€ iv_SaleDCM*/

ALTER VIEW [dbo].[iv_SaleDCM]
AS
SELECT
	ChID, d.SrcPosID, d.ProdID, d.PPID, d.UM, d.Qty, 
	d.PriceCC_nt, d.SumCC_nt, d.Tax, d.TaxSum, d.PriceCC_wt, 
	d.SumCC_wt, d.BarCode, d.TaxID, d.SecID, d.PurPriceCC_nt, 
	d.PurTax, d.PurPriceCC_wt, d.PLID, d.Discount
FROM t_SaleD d WITH (NOLOCK)
LEFT JOIN it_ComplexMenu cm WITH (NOLOCK)
ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
WHERE 
	cm.ProdID IS NULL
UNION ALL
SELECT
	d.ChID, MIN(d.SrcPosID) SrcPosID, d.ProdID, NULL PPID, p.UM, 
	SUM(Qty) Qty, 
	SUM(SumCC_nt) / SUM(Qty) PriceCC_nt, SUM(SumCC_nt) SumCC_nt, 
	SUM(TaxSum) / SUM(Qty) Tax, SUM(TaxSum) TaxSum, 
	SUM(SumCC_wt) / SUM(Qty) PriceCC_wt, SUM(SumCC_wt) SumCC_wt, 
	NULL BarCode, NULL TaxID, NULL SecID, 
	SUM(PurSumCC_nt) / SUM(Qty) PurPriceCC_nt, 
	SUM(PurTaxSum) / SUM(Qty) PurTax, 
	SUM(PurSumCC_wt) / SUM(Qty) PurPriceCC_wt, 
	d.PLID, NULL Discount
FROM	
(

		SELECT
			 m.ChID, MIN(m.SrcPosID) SrcPosID, m.PLID, m.ProdID,
			 CASE WHEN CASE WHEN MAX(MaxQty) >= 1 AND SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / ISNULL(NULLIF(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)),0), MAX(m.Qty)) > MAX(MaxQty)
					   THEN CAST(CEILING(SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / MAX(MaxQty)) AS numeric(21, 9)) 
					   ELSE CAST(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)) AS numeric(21, 9))
				  END < MAX(CMQty) /*ќбработка, если количество порций сопутствующих товаров больше количества корзин основных блюд - использовать его*/
			 THEN MAX(CMQty) 
			 ELSE CASE WHEN MAX(MaxQty) >= 1 AND SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / ISNULL(NULLIF(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)),0), MAX(m.Qty)) > MAX(MaxQty)
					   THEN CAST(CEILING(SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / MAX(MaxQty)) AS numeric(21, 9)) 
					   ELSE CAST(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)) AS numeric(21, 9))
					END 
			 END Qty, 
			SUM(m.SumCC_nt) SumCC_nt, 
			SUM(m.TaxSum) TaxSum, 
			SUM(m.SumCC_wt) SumCC_wt, 
			SUM(m.PurPriceCC_nt * m.Qty) PurSumCC_nt, 
			SUM(m.PurTax * m.Qty) PurTaxSum, 
			SUM(m.PurPriceCC_wt * m.Qty) PurSumCC_wt
		FROM (
			SELECT 
				d.ChID, MIN(d.SrcPosID) SrcPosID, d.PLID, d.ProdID, d.CMPosID, SUM(d.Qty) Qty,
				MAX(d.MaxQty) MaxQty, IsRelated, t.CMQty,
				SUM(d.SumCC_nt) SumCC_nt, 
				SUM(d.TaxSum) TaxSum, 
				SUM(d.SumCC_wt) SumCC_wt, 
				SUM(d.PurPriceCC_nt) PurPriceCC_nt, 
				SUM(d.PurTax) PurTax, 
				SUM(d.PurPriceCC_wt) PurPriceCC_wt				
			FROM (SELECT 
						d.ChID, MIN(d.SrcPosID) SrcPosID, d.PLID, cm.ProdID, cm.SrcPosID CMPosID, CAST(CEILING(SUM(Qty)/MAX(DetQty)) AS numeric(21,9)) Qty, 
						SUM(d.SumCC_nt) SumCC_nt, 
						SUM(d.TaxSum) TaxSum, 
						SUM(d.SumCC_wt) SumCC_wt, 
						SUM(d.PurPriceCC_nt) PurPriceCC_nt, 
						SUM(d.PurTax) PurTax, 
						SUM(d.PurPriceCC_wt) PurPriceCC_wt, 
						MAX(MaxQty) MaxQty, IsRelated /*ќпредел€ем количество условных едениц максимума по товарам*/
				  FROM t_SaleD d
				  INNER JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
				  INNER JOIN r_ProdMP mp WITH (NOLOCK) ON d.ProdID = mp.ProdID AND d.PLID = mp.PLID
				  GROUP BY d.ChID, d.PLID, cm.ProdID, cm.SrcPosID, IsRelated, SubProdID
				  ) d
			INNER JOIN (SELECT 
							ChID, CMPosID, SUM(Qty) CMQty /*ќпредел€ем сумму условных едениц максимума по каждой категории. ( лиенту доступно по одной еденице из каждой категории)*/
						FROM (SELECT 
									d.ChID, cm.SrcPosID CMPosID, CAST(CEILING(SUM(Qty)/MAX(DetQty)) AS numeric(21,9)) Qty /*ќпредел€ем количество условных едениц максимума по товарам*/
							  FROM t_SaleD d
							  INNER JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
							  INNER JOIN r_ProdMP mp WITH (NOLOCK) ON d.ProdID = mp.ProdID AND d.PLID = mp.PLID
							  GROUP BY d.ChID, cm.SrcPosID, SubProdID
							  ) tt 
						GROUP BY ChID, CMPosID
						) t ON t.ChID = d.ChID AND t.CMPosID = d.CMPosID 
			GROUP BY
				d.ChID, d.PLID, d.CMPosID, IsRelated, d.ProdID, t.CMQty
				) m
		GROUP BY m.ChID, m.ProdID, m.PLID
	) d
INNER JOIN r_Prods p WITH (NOLOCK) ON d.ProdID = p.ProdID
GROUP BY
	d.ChID, d.ProdID, d.PLID, p.UM

GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*ќбновление процедуры пересчета цен*/

ALTER PROCEDURE [dbo].[ip_ChequePosComplexMenu]
(
	@ChID int, @ProdID int, @PLID int
)
AS



DECLARE @CMProdID int

SELECT
	TOP 1 @CMProdID = cm.ProdID
FROM it_ComplexMenu cm WITH (NOLOCK)
INNER JOIN r_ProdMP mp WITH (NOLOCK) ON cm.ProdID = mp.ProdID AND mp.PLID = @PLID
WHERE
	cm.SubProdID = @ProdID
	AND cm.ProdID <> @ProdID

IF @CMProdID IS NULL
RETURN



SELECT 
	d.PLID, cm.ProdID, cm.SrcPosID CMPosID, cm.IsRelated, 
	d.SrcPosID, d.Qty, cm.MaxQty, cm.SubProdID, cm.DetQty,
	d.Qty * mp.PriceMC PriceSumCC
INTO #SaleTempDC
FROM t_SaleTempD d WITH (NOLOCK)
INNER JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
INNER JOIN r_ProdMP mp WITH (NOLOCK) ON d.ProdID = mp.ProdID AND d.PLID = mp.PLID
WHERE 
	d.ChID = @ChID AND cm.ProdID = @CMProdID
	



  /*ѕринимаетс€ ƒоп. оличество (DetQty) - это одна условна€ единица от ћаксимального количества (MaxQty). 
	“.е. DetQty=2 занимает одну единицу от MaxQty*/
SELECT 
	m.PLID, m.ProdID, 
	CASE WHEN CASE WHEN MAX(MaxQty) >= 1 AND SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / ISNULL(NULLIF(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)),0), MAX(m.Qty)) > MAX(MaxQty)
				   THEN CAST(CEILING(SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / MAX(MaxQty)) AS numeric(21, 9)) 
				   ELSE CAST(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)) AS numeric(21, 9))
			  END < MAX(CMQty) /*ќбработка, если количество порций сопутствующих товаров больше количества корзин основных блюд - использовать его*/
		 THEN MAX(CMQty) 
		 ELSE CASE WHEN MAX(MaxQty) >= 1 AND SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / ISNULL(NULLIF(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)),0), MAX(m.Qty)) > MAX(MaxQty)
				   THEN CAST(CEILING(SUM(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END) / MAX(MaxQty)) AS numeric(21, 9)) 
				   ELSE CAST(CEILING(MAX(CASE WHEN m.IsRelated = 0 THEN m.Qty ELSE 0 END)) AS numeric(21, 9))
				END 
	END * mp.PriceMC CSumCC
INTO #CProdSums
FROM
(
	SELECT 
		d.PLID, d.ProdID, d.CMPosID, SUM(d.Qty) Qty, 
		MAX(d.MaxQty) MaxQty, IsRelated, t.CMQty
	FROM (SELECT 
			PLID, ProdID, CMPosID, CAST(CEILING(SUM(Qty)/MAX(DetQty)) AS numeric(21,9)) Qty, MAX(MaxQty) MaxQty, IsRelated /*ќпредел€ем количество условных едениц максимума по товарам*/
			FROM #SaleTempDC 
			GROUP BY PLID, ProdID, CMPosID, IsRelated, SubProdID
		  ) d
	INNER JOIN (SELECT 
					CMPosID, SUM(Qty) CMQty /*ќпредел€ем сумму условных едениц максимума по каждой категории. ( лиенту доступно по одной еденице из каждой категории)*/
				FROM (SELECT 
						CMPosID, CAST(CEILING(SUM(Qty)/MAX(DetQty)) AS numeric(21,9)) Qty /*ќпредел€ем количество условных едениц максимума по товарам*/
					  FROM #SaleTempDC 
					  GROUP BY CMPosID, SubProdID
					  ) tt 
				GROUP BY CMPosID
				) t ON t.CMPosID = d.CMPosID 
	GROUP BY
		d.PLID, d.CMPosID, IsRelated, d.ProdID/*, d.SubProdID, d.DetQty*/, t.CMQty
) m 
INNER JOIN r_ProdMP mp WITH (NOLOCK) ON m.ProdID = mp.ProdID AND m.PLID = mp.PLID
GROUP BY
	m.PLID, m.ProdID, mp.PriceMC


UPDATE d 
SET 
	d.PurSumCC_wt =   ROUND(cm.PriceSumCC / CASE WHEN IsRelated = 0 
											   THEN ISNULL(NULLIF(td.PriceSumCC - td.RelatedSum, 0),td.PriceSumCC) 
											   ELSE td.RelatedSum 
										  END  * CASE WHEN IsRelated = 0 
													  THEN cs.CSumCC - td.RelatedSum 
													  ELSE CASE WHEN td.PriceSumCC = td.RelatedSum 
																THEN cs.CSumCC 
																ELSE td.RelatedSum 
														   END 
												 END / d.Qty, 2)  * d.Qty, 
	d.PurPriceCC_wt = ROUND(cm.PriceSumCC / CASE WHEN IsRelated = 0 
											   THEN ISNULL(NULLIF(td.PriceSumCC - td.RelatedSum, 0),td.PriceSumCC) 
											   ELSE td.RelatedSum 
										  END  * CASE WHEN IsRelated = 0 
													  THEN cs.CSumCC - td.RelatedSum 
													  ELSE CASE WHEN td.PriceSumCC = td.RelatedSum 
																THEN cs.CSumCC 
																ELSE td.RelatedSum 
														   END 
												 END / d.Qty, 2) , 
	d.SumCC_wt =	  ROUND(cm.PriceSumCC / CASE WHEN IsRelated = 0 
											   THEN ISNULL(NULLIF(td.PriceSumCC - td.RelatedSum, 0),td.PriceSumCC) 
											   ELSE td.RelatedSum 
										  END  * CASE WHEN IsRelated = 0 
													  THEN cs.CSumCC - td.RelatedSum 
													  ELSE CASE WHEN td.PriceSumCC = td.RelatedSum 
																THEN cs.CSumCC 
																ELSE td.RelatedSum 
														   END 
												 END / d.Qty, 2)  * d.Qty, 
	d.PriceCC_wt =    ROUND(cm.PriceSumCC / CASE WHEN IsRelated = 0 
											   THEN ISNULL(NULLIF(td.PriceSumCC - td.RelatedSum, 0),td.PriceSumCC) 
											   ELSE td.RelatedSum 
										  END  * CASE WHEN IsRelated = 0 
													  THEN cs.CSumCC - td.RelatedSum 
													  ELSE CASE WHEN td.PriceSumCC = td.RelatedSum 
																THEN cs.CSumCC 
																ELSE td.RelatedSum 
														   END 
												 END / d.Qty, 2) 	
FROM t_SaleTempD d WITH (NOLOCK)
INNER JOIN #SaleTempDC cm ON d.SrcPosID = cm.SrcPosID
INNER JOIN #CProdSums cs ON d.PLID = cs.PLID AND cm.ProdID = cs.ProdID
INNER JOIN ( SELECT
				d.PLID, d.ProdID, SUM(d.PriceSumCC) PriceSumCC, SUM(CASE WHEN IsRelated = 1 THEN d.PriceSumCC ELSE 0 END) RelatedSum
			 FROM #SaleTempDC d
			 GROUP BY
				d.PLID, d.ProdID
			) td ON d.PLID = td.PLID AND cm.ProdID = td.ProdID 
WHERE 
	d.ChID = @ChID AND d.Qty <> 0
	
SELECT 
	d.PLID, cm.ProdID, d.ProdID DetProdID, 
	dbo.zf_Round(SUM(d.PriceCC_wt * d.Qty), 0.01) SumCC, 
	SUM(d.Qty) Qty
INTO #SaleTempGP
FROM t_SaleTempD d WITH (NOLOCK)
INNER JOIN #SaleTempDC cm ON d.SrcPosID = cm.SrcPosID
WHERE
	d.ChID = @ChID
GROUP BY 
	cm.ProdID, d.ProdID, d.PLID, d.BarCode, 
	d.TaxID, d.RealQty, d.PriceCC_wt

UPDATE d
SET
	d.PriceCC_wt = (p1.SumCC + c.DSumCC) / p1.Qty, 
	d.PurPriceCC_wt = (p1.SumCC + c.DSumCC) / p1.Qty, 
	d.SumCC_wt = (p1.SumCC + c.DSumCC) / p1.Qty * d.Qty, 
	d.PurSumCC_wt = (p1.SumCC + c.DSumCC) / p1.Qty * d.Qty
FROM
(
	SELECT
		ds.PLID, ds.ProdID,
		cs.CSumCC - SUM(ds.SumCC) DSumCC
	FROM
	#SaleTempGP ds
	INNER JOIN #CProdSums cs ON ds.PLID = cs.PLID AND ds.ProdID = cs.ProdID
	GROUP BY
		ds.PLID, ds.ProdID, cs.CSumCC
	HAVING 
		cs.CSumCC - SUM(ds.SumCC) <> 0
) c
INNER JOIN #SaleTempDC cm ON c.PLID = cm.PLID AND c.ProdID = cm.ProdID
INNER JOIN t_SaleTempD d WITH (NOLOCK) ON d.ChID = @ChID AND cm.SrcPosID = d.SrcPosID 
INNER JOIN 
			(
				SELECT
					TOP 1 PLID, DetProdID, SUM(SumCC) SumCC, SUM(Qty) Qty
				FROM #SaleTempGP
				GROUP BY
					PLID, DetProdID
				HAVING 
					SUM(Qty) <> 0
				ORDER BY
					SIGN(ABS(DetProdID - @ProdID)) DESC, SUM(Qty)
			) p1
ON d.ProdID = p1.DetProdID AND d.PLID = p1.PLID

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/


