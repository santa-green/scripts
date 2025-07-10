CREATE PROCEDURE dbo.a_GetComps
AS

	SELECT 
		CompID, CompName, Notes
	FROM dbo.r_Comps


GO
