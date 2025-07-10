/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*Добавление доп.поля в репозиторий*/

INSERT INTO z_FieldsRep (FieldsRepGrpCode, FieldName, FieldDesc, FieldNick, FieldInfo, DataType, DataSize, SQLType, SQLPrec, SQLScale, FieldCount, Required, ReadOnly, Visible, DisplayFormat, Width, AutoNewType, AutoNewValue, Calc, Lookup, LookupKey, LookupSource, LookupSourceKey, LookupSourceResult, PickListType, PickList, EditMask, EditFormat, MinValue, MaxValue, CustomConstraint, ErrorMessage, DBDefault, Separator, HideZeros, DecimalCount, FixedCount, Currency, Alignment, InitBeforePost, IsHidden)
SELECT 0, 'IsRelated', 'Сопутствующий', '', '', 8, 0, 104, 0, 0, 0, 1, 0, 0, '', 25, 0, '', 0, 0, '', '', '', '', 0, '', '', '', 0.000000000, 0.000000000, '', '', NULL, 0, 0, 0, 0, 0, 0, 0, 0

GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*Добавление доп.поля в таблицу*/

ALTER TABLE it_ComplexMenu ADD IsRelated bit NULL
GO

UPDATE it_ComplexMenu SET IsRelated=0
GO

ALTER TABLE it_ComplexMenu ALTER COLUMN IsRelated bit NOT NULL
GO

ALTER TABLE it_ComplexMenu ADD DetQty numeric(21, 9) NULL
GO

UPDATE it_ComplexMenu SET DetQty=1
GO

ALTER TABLE it_ComplexMenu ALTER COLUMN DetQty numeric(21, 9) NOT NULL
GO
/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*Добавление доп.поля в таблицу полей и источники*/


INSERT INTO z_Fields VALUES  (1000005001, (SELECT MAX(FieldPosID)+1 FROM z_Fields WHERE TableCode = 1000005001), 'IsRelated', NULL, 1, 1, NULL)
INSERT INTO z_Fields VALUES (1000005003, (SELECT MAX(FieldPosID)+1 FROM z_Fields WHERE TableCode = 1000005003), 'IsRelated', NULL, 1, 1, NULL)
INSERT INTO z_Fields VALUES (1000005004, (SELECT MAX(FieldPosID)+1 FROM z_Fields WHERE TableCode = 1000005004), 'IsRelated', NULL, 1, 1, NULL)
INSERT INTO z_Fields VALUES (1000005004, (SELECT MAX(FieldPosID)+1 FROM z_Fields WHERE TableCode = 1000005004), 'DetQty', NULL, 1, 13, NULL)
INSERT INTO z_Fields VALUES (1000005001, (SELECT MAX(FieldPosID)+1 FROM z_Fields WHERE TableCode = 1000005001), 'DetQty', NULL, 1, 13, NULL)
GO


INSERT INTO z_DataSetFields VALUES (1000005002, (SELECT MAX(FieldPosID)+1 FROM z_DataSetFields WHERE DSCode = 1000005002), 'IsRelated', '', 1, 0, 1, '', 20, 1, 'False', 0, 0, 0, '', '', '', '', 0, '', '', '', 0, 0, '', '', 0, 0)
INSERT INTO z_DataSetFields VALUES (1000005003, (SELECT MAX(FieldPosID)+1 FROM z_DataSetFields WHERE DSCode = 1000005003), 'DetQty', '', 1, 0, 1, '#,##0.#####', 12, 0, '', 13, 0, 0, '', '', '', '', 0, '', '', '', 0, 0, '', '', NULL, 0)
INSERT INTO z_DataSetFields VALUES (1000005003, (SELECT MAX(FieldPosID)+1 FROM z_DataSetFields WHERE DSCode = 1000005003), 'IsRelated', '', 1, 0, 0, '', 25, 0, '', 0, 0, 0, '', '', '', '', 0, '', '', '', 0, 0, '', '', NULL, 0)
		
GO

UPDATE z_DataSets SET MasterFields = 'PLID;ProdID;SrcPosID;IsRelated' , SortFields = 'PLID;ProdID;SrcPosID;IsRelated' WHERE DSCode = 1000005003
GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*Обновление текста представления iv_ComplexMenuD*/

ALTER VIEW iv_ComplexMenuD
AS
SELECT
  m.PLID, m.ProdID, m.MaxQty, m.SrcPosID, m.IsRelated, 
  m.Notes, m.SubProdID, DetQty,   
  ISNULL(mp.PriceMC, 0) PriceCC
FROM it_ComplexMenu m WITH (NOLOCK)
LEFT JOIN r_ProdMP mp WITH (NOLOCK) ON m.SubProdID = mp.ProdID AND m.PLID = mp.PLID
WHERE m.ProdID <> m.SubProdID

GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*Обновление текста представления iv_ComplexMenuA*/

ALTER VIEW iv_ComplexMenuA
AS
SELECT
  m.PLID, m.ProdID, MAX(m.MaxQty) MaxQty, m.SrcPosID, 
  MIN(m.Notes) Notes,   
  ISNULL(MIN(CASE WHEN m.ProdID = m.SubProdID THEN NULL ELSE NULLIF(mp.PriceMC, 0) END), 0) MinPriceMC, 
  ISNULL(AVG(CASE WHEN m.ProdID = m.SubProdID THEN NULL ELSE NULLIF(mp.PriceMC, 0) END), 0) AvgPriceMC,   
  ISNULL(MAX(CASE WHEN m.ProdID = m.SubProdID THEN NULL ELSE NULLIF(mp.PriceMC, 0) END), 0) MaxPriceMC,  
  IsRelated
FROM it_ComplexMenu m WITH (NOLOCK)
LEFT JOIN r_ProdMP mp WITH (NOLOCK) ON m.SubProdID = mp.ProdID AND m.PLID = mp.PLID
WHERE m.SrcPosID > 0
GROUP BY
  m.PLID, m.ProdID, m.SrcPosID, IsRelated

GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*Обновление текста представления iv_SaleTempDCM*/

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
		CASE WHEN MAX(MaxQty) >= 1 AND SUM(d.Qty) / CEILING(MAX(d.Qty)) > MAX(MaxQty) 
			 THEN CAST(CEILING(SUM(d.Qty) / MAX(MaxQty)) AS numeric(21, 9)) 
			 ELSE CAST(CEILING(MAX(d.Qty)) AS numeric(21, 9)) 
		END Qty, 
		1 RealQty, 
		SUM(SumCC_wt) / CASE WHEN MAX(MaxQty) >= 1 AND SUM(d.Qty) / CEILING(MAX(d.Qty)) > MAX(MaxQty) 
							 THEN CAST(CEILING(SUM(d.Qty) / MAX(MaxQty)) AS numeric(21, 9)) 
							 ELSE CAST(CEILING(MAX(d.Qty)) AS numeric(21, 9)) 
						END PriceCC_wt, 
		SUM(SumCC_wt) SumCC_wt, 
		SUM(PurSumCC_wt) / CASE WHEN MAX(MaxQty) >= 1 AND SUM(d.Qty) / CEILING(MAX(d.Qty)) > MAX(MaxQty) 
								THEN CAST(CEILING(SUM(d.Qty) / MAX(MaxQty)) AS numeric(21, 9)) 
								ELSE CAST(CEILING(MAX(d.Qty)) AS numeric(21, 9)) 
						   END PurPriceCC_wt, 
		SUM(PurSumCC_wt) PurSumCC_wt, NULL BarCode, NULL RealBarCode, d.PLID, 
		NULL UseToBarQty, NULL PosStatus, NULL ServingTime, NULL CSrcPosID, 
		NULL ServingID, NULL CReasonID, NULL PrintTime, NULL CanEditQty
	FROM (
		SELECT
			d.ChID, MIN(d.SrcPosID) SrcPosID, cm.ProdID, SUM(Qty) Qty, MAX(MaxQty) MaxQty, 
			SUM(d.SumCC_wt) SumCC_wt, SUM(d.PurSumCC_wt) PurSumCC_wt, d.PLID, cm.IsRelated
		FROM t_SaleTempD d WITH (NOLOCK) 
		INNER JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
		WHERE cm.IsRelated = 0
		GROUP BY d.ChID, cm.ProdID, d.PLID, cm.SrcPosID, cm.IsRelated
		HAVING SUM(Qty) <> 0) d
	INNER JOIN r_Prods p WITH (NOLOCK) ON d.ProdID = p.ProdID
	GROUP BY d.ChID, d.ProdID, d.PLID, p.UM

GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*Обновление текста представления iv_SaleDCM*/

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
	CAST(CEILING(MAX(d.Qty)) AS numeric(21,9)) Qty, 
	SUM(SumCC_nt) / CEILING(MAX(d.Qty)) PriceCC_nt, SUM(SumCC_nt) SumCC_nt, 
	SUM(TaxSum) / CEILING(MAX(d.Qty)) Tax, SUM(TaxSum) TaxSum, 
	SUM(SumCC_wt) / CEILING(MAX(d.Qty)) PriceCC_wt, SUM(SumCC_wt) SumCC_wt, 
	NULL BarCode, NULL TaxID, NULL SecID, 
	SUM(PurSumCC_nt) / CEILING(MAX(d.Qty)) PurPriceCC_nt, 
	SUM(PurTaxSum) / CEILING(MAX(d.Qty)) PurTax, 
	SUM(PurSumCC_wt) / CEILING(MAX(d.Qty)) PurPriceCC_wt, 
	d.PLID, NULL Discount
FROM	
(
	SELECT 
		d.ChID, MIN(d.SrcPosID) SrcPosID, 
		cm.ProdID, 
		SUM(Qty) Qty, MAX(cm.MaxQty) MaxQty, 
		SUM(d.SumCC_nt) SumCC_nt, 
		SUM(d.TaxSum) TaxSum, 
		SUM(d.SumCC_wt) SumCC_wt, 
		SUM(d.PurPriceCC_nt * d.Qty) PurSumCC_nt, 
		SUM(d.PurTax * d.Qty) PurTaxSum, 
		SUM(d.PurPriceCC_wt * d.Qty) PurSumCC_wt, 
		d.PLID, cm.IsRelated
	FROM t_SaleD d WITH (NOLOCK)
	INNER JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
	WHERE cm.IsRelated = 0
	GROUP BY
		d.ChID, cm.ProdID, d.PLID, cm.SrcPosID, cm.IsRelated 
) d 
INNER JOIN r_Prods p WITH (NOLOCK) ON d.ProdID = p.ProdID
GROUP BY
	d.ChID, d.ProdID, d.PLID, p.UM

GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*Обновление процедуры пересчета цен*/

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
	d.SrcPosID, d.Qty, cm.MaxQty, cm.DetQty,
	d.Qty * mp.PriceMC PriceSumCC
INTO #SaleTempDC
FROM t_SaleTempD d WITH (NOLOCK)
INNER JOIN it_ComplexMenu cm WITH (NOLOCK) ON d.PLID = cm.PLID AND d.ProdID = cm.SubProdID
INNER JOIN r_ProdMP mp WITH (NOLOCK) ON d.ProdID = mp.ProdID AND d.PLID = mp.PLID
WHERE 
	d.ChID = @ChID AND cm.ProdID = @CMProdID

SELECT 
	m.PLID, m.ProdID, 
	CASE WHEN MAX(MaxQty) >= 1 AND SUM(m.Qty)/CEILING(MAX(m.Qty/m.DetQty)) > MAX(MaxQty) 
		 THEN CAST(CEILING(SUM(m.Qty)/MAX(MaxQty)) AS numeric(21,9))
		 ELSE CAST(CEILING(MAX(m.Qty/m.DetQty)) AS numeric(21,9))
	END * mp.PriceMC CSumCC
INTO #CProdSums
FROM
(
	SELECT 
		d.PLID, d.ProdID, d.CMPosID, SUM(d.Qty) Qty, 
		MAX(d.MaxQty) + ISNULL((SELECT SUM(Qty) FROM #SaleTempDC WHERE ProdID = d.ProdID AND PLID = d.PLID AND IsRelated = 1),0) MaxQty, IsRelated, d.DetQty
	FROM #SaleTempDC d
	GROUP BY
		d.PLID, d.CMPosID, IsRelated, d.ProdID, d.DetQty
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


GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/


