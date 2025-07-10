CREATE PROCEDURE dbo.a_GetStocks
AS

	SELECT 
		StockID, StockName
	FROM dbo.r_Stocks


GO
