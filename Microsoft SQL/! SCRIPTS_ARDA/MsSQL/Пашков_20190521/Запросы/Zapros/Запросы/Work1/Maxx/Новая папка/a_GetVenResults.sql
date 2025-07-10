CREATE PROCEDURE dbo.a_GetVenResults @VenID int, @ShowDetsOnly bit, @Filter nvarchar(1000)
AS

SET NOCOUNT ON

  IF @ShowDetsOnly=0
	  EXEC ('SELECT 
		ClassName, dbo.a_VenResult.ProdID, Article, ProdName, VenPrice, PQty, 
		(SELECT ISNULL(Sum(FQty), 0) FROM a_Ven m INNER JOIN a_VenD d ON d.QID=m.QID WHERE m.VenID='+@VenID+' AND d.ProdID=dbo.a_VenResult.ProdID) AS FQty,
		CorrQty 
		FROM dbo.a_VenResult INNER JOIN dbo.r_Prods ON dbo.r_Prods.ProdID=dbo.a_VenResult.ProdID INNER JOIN dbo.a_VenCorrs ON dbo.a_VenCorrs.VenID=dbo.a_VenResult.VenID AND dbo.a_VenCorrs.ProdID=dbo.a_VenResult.ProdID 
		WHERE dbo.a_VenResult.VenID='+@VenID+' AND '+@Filter)
  ELSE
	  EXEC ('SELECT 
		ClassName, dbo.a_VenResult.ProdID, Article, ProdName, VenPrice, PQty, 
		(SELECT ISNULL(Sum(FQty), 0) FROM a_Ven m INNER JOIN a_VenD d ON d.QID=m.QID WHERE m.VenID='+@VenID+' AND d.ProdID=dbo.a_VenResult.ProdID) AS FQty,
		CorrQty 
		FROM dbo.a_VenResult INNER JOIN dbo.r_Prods ON dbo.r_Prods.ProdID=dbo.a_VenResult.ProdID INNER JOIN dbo.a_VenCorrs ON dbo.a_VenCorrs.VenID=dbo.a_VenResult.VenID AND dbo.a_VenCorrs.ProdID=dbo.a_VenResult.ProdID 
		WHERE PQty<>CorrQty
		AND dbo.a_VenResult.VenID='+@VenID+' AND '+@Filter)
GO
