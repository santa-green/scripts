	IF OBJECT_ID (N'tempdb..#linenum', N'U') IS NOT NULL DROP TABLE #linenum
	SELECT ROW_NUMBER()OVER(ORDER BY number) n , number
	into #linenum
	FROM (
		SELECT ROW_NUMBER()OVER(ORDER BY(SELECT 1)) number
		FROM 
		 (SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s1
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s2
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s3
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s4
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s5
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s6
	) gen
	where number BETWEEN 10000 AND 100000

	SELECT * FROM #linenum


	SELECT ROW_NUMBER()OVER(ORDER BY number) n , number
	FROM (
		SELECT ROW_NUMBER()OVER(ORDER BY(SELECT 1)) number
		FROM 
		 (SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s1
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s2
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s3
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s4
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s5
		,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s6
	) gen
	where number BETWEEN 90000 AND 100000
