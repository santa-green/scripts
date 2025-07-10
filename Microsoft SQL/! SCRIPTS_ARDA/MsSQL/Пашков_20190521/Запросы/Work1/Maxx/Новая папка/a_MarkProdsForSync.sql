CREATE PROCEDURE dbo.a_MarkProdsForSync @ProdList NText
AS

  SET NOCOUNT ON

  IF OBJECT_ID('tempdb..#tmp_Prods') IS NOT NULL DROP TABLE #tmp_Prods
  IF OBJECT_ID('tempdb..#tmp_Table') IS NOT NULL DROP TABLE #tmp_Table

  CREATE TABLE #tmp_Prods (ProdID int)  
  CREATE TABLE #tmp_Table (EqID int NOT NULL, EqName varchar(255), URL varchar(255), Port int, StockID int)
	
  EXEC('INSERT INTO #tmp_Prods (ProdID) SELECT ProdID FROM dbo.r_Prods WHERE '+@ProdList)

  INSERT INTO #tmp_Table
  EXEC dbo.a_GetEqs

  INSERT INTO dbo.r_ProdFSync(ProdID, EqID)
  SELECT ProdID, EqID
  FROM #tmp_Table t CROSS JOIN #tmp_Prods p
  WHERE NOT EXISTS(SELECT * FROM dbo.r_ProdFSync fs WHERE fs.EqID=t.EqID AND fs.ProdID=p.ProdID)
GO
