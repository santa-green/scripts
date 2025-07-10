USE [base_ArdaSQL]
GO
/****** Object:  View [dbo].[v_Data_group]    Script Date: 01/23/2018 16:59:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_Data_group]
AS
SELECT tYear_tMonth, Retail, artid, Brand, CAT, SKU1, SUM(SalesQty) AS TSalesQty
FROM (
	SELECT tYear * 100 + tMonth AS tYear_tMonth, g.Retail Retail, artid, SalesQty, BPrice, SPrice, a.Brand, a.CAT, a.SKU1 FROM dbo.DATA d 
	join dbo.GEO g on g.KOD = d.geoid
	join ART a on a.KOD = d.artid
) AS gr
GROUP BY tYear_tMonth, Retail, artid, Brand, CAT, SKU1

