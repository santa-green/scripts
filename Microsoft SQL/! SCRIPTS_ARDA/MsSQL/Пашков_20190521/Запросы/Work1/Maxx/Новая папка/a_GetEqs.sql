CREATE PROCEDURE dbo.a_GetEqs
AS

SELECT dbo.a_Eqs.EqID, dbo.a_Eqs.EqName,  dbo.a_Eqs.URL, dbo.a_Eqs.Port, dbo.a_Eqs.StockID
FROM dbo.a_Eqs 
INNER JOIN dbo.a_EqMe ON dbo.a_EqMe.EqID=dbo.a_Eqs.EqID
WHERE Port<>0 AND GetDate() BETWEEN dbo.a_EqMe.BDate AND dbo.a_EqMe.EDate
ORDER BY dbo.a_Eqs.EqName


GO
