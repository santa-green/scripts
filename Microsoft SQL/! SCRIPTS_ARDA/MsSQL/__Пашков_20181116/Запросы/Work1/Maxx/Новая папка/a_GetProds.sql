CREATE PROCEDURE dbo.a_GetProds @ProdList NText
AS

  SET NOCOUNT ON

  IF @ProdList NOT LIKE '()'
	BEGIN
		
		CREATE TABLE #tmp_Prods (ProdID int)
	
		EXEC('INSERT INTO #tmp_Prods (ProdID) SELECT ProdID FROM dbo.r_Prods WHERE '+@ProdList)

		SELECT 
			p.ProdID, p.ProdName, p.Article, p.Um, p.ClassName,
			mq.Um AS MQUm, ISNULL(mq.BarCode, 0) AS BarCode
		FROM (dbo.r_Prods p LEFT JOIN dbo.r_ProdMQ mq ON mq.ProdID=p.ProdID)
			INNER JOIN #tmp_Prods ON #tmp_Prods.ProdID=p.ProdID
		
		ORDER BY p.ProdID, mq.BarCode

	END
  ELSE
	BEGIN

		SELECT 
			p.ProdID, p.ProdName, p.Article, p.Um, p.ClassName,
			mq.Um AS MQUm, ISNULL(mq.BarCode, 0) AS BarCode
		FROM dbo.r_Prods p LEFT JOIN dbo.r_ProdMQ mq ON mq.ProdID=p.ProdID
		
		ORDER BY p.ProdID, mq.BarCode

	END




GO
