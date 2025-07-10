SELECT *
, CASE Cnt 
	WHEN 1 THEN CAST(CEILING(Case 
								When ExtProdID in (268687,268677) or Prodid IN (4697) Then TQty / 12 
								WHEN Prodid IN (4696) THEN TQty / 6   
								Else TQty / InBoxQty 
							 End
							 ) AS NUMERIC(21,9)) 
	ELSE Case 
			When ExtProdID in (268687,268677) or Prodid IN (4697) Then TQty / 12 
			When Prodid IN (4696) Then TQty / 6  
			Else TQty / InBoxQty 
		 End  
   END BoxQty
FROM
(
	SELECT
	CAST(ec.ExtProdID AS BIGINT) AS ExtProdID, 
	d.ProdID, p.Notes ProdName, p.PGrID,
	d.PriceCC_nt, 
	mq.Qty AS InBoxQty,
	CASE WHEN SUBSTRING(pp.Article, CHARINDEX(' ', pp.Article)+1, 255) LIKE '[0-9][0-9][0-9][0-9].[0-9][0-9].[0-9][0-9]' OR SUBSTRING(pp.Article, CHARINDEX(' ', pp.Article)+1, 255) LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' THEN dbo.zf_DateToStr(CAST(REPLACE(SUBSTRING(pp.Article, CHARINDEX(' ', pp.Article)+1, 255), '.', '-') AS DATE)) ELSE SUBSTRING(pp.Article, CHARINDEX(' ', pp.Article)+1, 255) END AS Article,
	REPLACE(pp.File1, ' ', '') File1, 
	CASE WHEN pp.File2 LIKE '[0-9][0-9][0-9][0-9].[0-9][0-9].[0-9][0-9]' OR pp.File2 LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' THEN dbo.zf_DateToStr(CAST(REPLACE(pp.File2, '.', '-') AS DATE)) ELSE pp.File2 END AS File2,
	pp.ProdPPDate, p.UM,  
	ISNULL(NULLIF(p.File1,''),'------') HigNo,
	ISNULL(NULLIF(p.File2,''),'------') HigBDate, 
	ISNULL(NULLIF(p.File3,''),'------') HigEDate,
	SUM(d.Qty) AS TQty, SUM(d.SumCC_nt) AS TSumCC_nt, 
	SUM(d.TaxSum) AS TTaxSum, SUM(d.SumCC_wt) AS TSumCC_wt,
	ISNULL((SELECT Qty FROM r_ProdMQ WITH(NOLOCK) WHERE r_ProdMQ.UM LIKE '%метро/един%' AND ProdID=d.ProdID),1) as MetroQty,
		(SELECT COUNT(*) FROM (
			SELECT NULL NL FROM t_Inv m0 WITH(NOLOCK) 
			JOIN t_InvD d0 WITH(NOLOCK) ON d0.ChID=m0.ChID 
			JOIN t_PInP pp0 WITH(NOLOCK) ON pp0.ProdID=d0.ProdID AND pp0.PPID=d0.PPID
			WHERE (m0.DocID IN (SELECT AValue FROM dbo.zf_FilterToTable('3115832'))) AND m0.OurID = 1 AND d0.ProdID = d.ProdID
			GROUP BY d0.ProdID, d0.PriceCC_nt, SUBSTRING(pp0.Article, CHARINDEX(' ', pp0.Article)+1, 255),pp0.File1, pp0.File2, pp0.File3
			) ct
		) Cnt
	FROM t_Inv m WITH(NOLOCK)
	JOIN t_InvD d WITH(NOLOCK) ON d.ChID=m.ChID
	JOIN t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID
	JOIN r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID
	LEFT JOIN r_ProdEC ec WITH(NOLOCK) ON ec.ProdID=d.ProdID AND ec.CompID=m.CompID
	LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID=d.ProdID AND mq.UM='ящ.' AND mq.Qty != 0
	WHERE (m.DocID IN (SELECT AValue FROM dbo.zf_FilterToTable('3115832'))) AND m.OurID = 1
	GROUP BY ec.ExtProdID, d.ProdID, p.Notes, p.PGrID, d.PriceCC_nt, mq.Qty, SUBSTRING(Article, CHARINDEX(' ', pp.Article)+1, 255),
	pp.File1, pp.File2, pp.ProdPPDate, m.SrcDocID, p.UM,
	ISNULL(NULLIF(p.File1,''),'------'), ISNULL(NULLIF(p.File2,''),'------'), ISNULL(NULLIF(p.File3,''),'------')
) m
ORDER BY 1