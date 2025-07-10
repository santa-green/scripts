CREATE PROC [dbo].[p_DinamicPivot] (@rezet int = null)
AS 
	DECLARE @SQL NVARCHAR(max);
	DECLARE @Fields AS NVARCHAR(MAX);
	
	IF @rezet = 1 
	BEGIN
		--создать представление если его нет
		IF OBJECT_ID (N'dbo.v_Data_group', N'V') IS NULL 
		BEGIN
			SET @SQL = N'CREATE VIEW [dbo].[v_Data_group] AS SELECT tYear_tMonth, Retail, artid, Brand, CAT, SKU1, SUM(SalesQty) AS TSalesQty FROM (
						SELECT tYear * 100 + tMonth AS tYear_tMonth, g.Retail Retail, artid, SalesQty, BPrice, SPrice, a.Brand, a.CAT, a.SKU1 FROM dbo.DATA d 
						join dbo.GEO g on g.KOD = d.geoid join ART a on a.KOD = d.artid ) AS gr GROUP BY tYear_tMonth, Retail, artid, Brand, CAT, SKU1'
			EXECUTE (@SQL);  
		END
		--пересоздать промежуточную таблицу  Data_group
		IF OBJECT_ID (N'dbo.Data_group', N'U') IS NOT NULL DROP TABLE dbo.Data_group
		SELECT * INTO dbo.Data_group FROM  [dbo].[v_Data_group]
	END

	--;WITH Fields_CTE as (SELECT distinct top(1000) tYear_tMonth FROM dbo.Data_group ORDER BY tYear_tMonth)
	--SELECT @Fields=COALESCE(@Fields + ', ','')+QUOTENAME(cast(tYear_tMonth as varchar)) FROM Fields_CTE s1 
	SELECT @Fields=COALESCE(@Fields + ', ','')+QUOTENAME(cast(tYear_tMonth as varchar)) FROM (SELECT distinct top(1000) tYear_tMonth FROM dbo.Data_group ORDER BY tYear_tMonth) s1
	--SELECT @Fields
	
	IF OBJECT_ID (N'dbo.v_Dinamic_Pivot_tmp', N'V') IS NOT NULL DROP VIEW dbo.v_Dinamic_Pivot_tmp
	
	SET @SQL = N'CREATE VIEW [dbo].[v_Dinamic_Pivot_tmp] AS SELECT Retail,artid,Brand,CAT,SKU1,' + @Fields + ' FROM dbo.Data_group PIVOT (SUM(TSalesQty) FOR tYear_tMonth IN(' + @Fields + N')) pvt';
	 
	--SELECT @SQL;
	
	EXECUTE (@SQL);
	
	SELECT * FROM dbo.v_Dinamic_Pivot_tmp
	 
	

/*
exec [p_DinamicPivot] -- 7 сек
exec [p_DinamicPivot] @rezet = 1 -- 290 сек


SELECT Retail,artid,Brand,CAT,SKU1,[201706], [201712], [201709], [201703], [201704], [201701], [201710], [201707], [201708], [201702], [201711], [201705] 
FROM dbo.Data_group
 PIVOT
 (SUM(TSalesQty)
 FOR tYear_tMonth
 IN([201706], [201712], [201709], [201703], [201704], [201701], [201710], [201707], [201708], [201702], [201711], [201705])
 ) pvt;
 
 SELECT * FROM OPENROWSET('SQLNCLI', 'Server=(local)\TK;Trusted_Connection=yes;', 'EXEC base_ArdaSQL.dbo.p_DinamicPivot')
 
 
*/


GO
