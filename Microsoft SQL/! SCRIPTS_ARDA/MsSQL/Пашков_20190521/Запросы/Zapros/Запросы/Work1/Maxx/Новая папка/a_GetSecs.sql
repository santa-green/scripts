CREATE PROCEDURE dbo.a_GetSecs @SecList NText
AS

  SET NOCOUNT ON

  IF @SecList NOT LIKE '()'
	BEGIN
		
		CREATE TABLE #tmp_Secs (SecID int)
	
		EXEC('INSERT INTO #tmp_Secs (SecID) SELECT SecID FROM dbo.r_Secs WHERE '+@SecList)

		SELECT 
			s.SecID, s.SecName
		FROM dbo.r_Secs s INNER JOIN #tmp_Secs ON #tmp_Secs.SecID=s.SecID
		ORDER BY s.SecID

	END
  ELSE
	BEGIN

		SELECT 
			s.SecID, s.SecName
		FROM dbo.r_Secs s
		ORDER BY s.SecID

	END



GO
