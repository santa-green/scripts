CREATE PROCEDURE dbo.a_FillVenCorrs @VenID int
AS

SET NOCOUNT ON

  INSERT INTO dbo.a_VenCorrs(VenID, ProdID, CorrQty)
  SELECT 
	@VenID, ProdID, 
	ISNULL((SELECT Sum(FQty) FROM a_Ven m INNER JOIN a_VenD d ON d.QID=m.QID WHERE m.VenID=@VenID AND d.ProdID=r.ProdID), 0) AS CorrQty
  FROM a_VenResult r  
  WHERE VenID=@VenID 
	AND NOT EXISTS(SELECT * FROM a_VenCorrs c WHERE c.VenID=@VenID AND c.ProdID=r.ProdID)
  GROUP BY ProdID

GO
