----03-Генерировать случайную последовательность
--/*
--Условия:
---MS SQL Server 2008
--*/
--IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP
--CREATE TABLE @TMP (ID INT null,rnd INT null)

--INSERT #TMP		
--          select 1,null
--union all select 2,null
--union all select 3,null
--union all select 4,null
--union all select 5,null
--union all select 6,null
--union all select 7,null
--union all select 8,null
--union all select 9,null
--union all select 10,null
--union all select 11,null
--union all select 12,null
--union all select 13,null
--union all select 14,null
--union all select 15,null


----Ниже напишите ваши варианты решения данной задачи

--DECLARE @ID INT, @R INT, @in INT = 0
--WHILE ISNULL((SELECT top 1 1 FROM @TMP WHERE rnd IS NULL),0) = 1    		 
--BEGIN
--	--skript
--	SET @R = ABS(CHECKSUM(NewId())) % 15  + 1 
--	--SELECT  @R
--	update top(1) @TMP set rnd = @R where rnd is null and @R not in (SELECT rnd FROM @TMP where rnd is not null)
--	--SELECT * FROM #TMP
--	set @in = @in + 1
--END 

--SELECT row_number() over(ORDER BY id) N,rnd FROM (
--SELECT top 5 * FROM @TMP where rnd between 1 and 5
--union all
--SELECT top 5 * FROM @TMP where rnd between 6 and 15
--ORDER BY 1
--)s1

--SELECT @in
--SELECT sum(rnd) FROM #TMP


/*
IF OBJECT_ID (N'tempdb..#TMP2', N'U') IS NOT NULL DROP TABLE #TMP2
CREATE TABLE #TMP2 (i INT null,ID INT null,rnd INT null)

DECLARE @n INT = 1000, @i INT = 1
WHILE @n >= @i
BEGIN

--IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP
--CREATE TABLE @TMP (ID INT null,rnd INT null)

declare @TMP TABLE(ID INT null,rnd INT null)

INSERT @TMP		
          select 1,null
union all select 2,null
union all select 3,null
union all select 4,null
union all select 5,null
union all select 6,null
union all select 7,null
union all select 8,null
union all select 9,null
union all select 10,null
union all select 11,null
union all select 12,null
union all select 13,null
union all select 14,null
union all select 15,null

DECLARE @ID INT, @R INT, @in INT = 0
WHILE ISNULL((SELECT top 1 1 FROM @TMP WHERE rnd IS NULL),0) = 1    		 
BEGIN
	--skript
	--SET @R = ABS(CHECKSUM(NewId())) % 15  + 1 
	SET @R =  cast(rand()*15 as int) + 1
	--SELECT  @R
	update top(1) @TMP set rnd = @R where rnd is null and @R not in (SELECT rnd FROM @TMP where rnd is not null)
	--SELECT * FROM #TMP
	set @in = @in + 1
END 

insert #TMP2
SELECT @i i, row_number() over(ORDER BY id) N,rnd FROM (
SELECT top 5 * FROM @TMP where rnd between 1 and 5
union all
SELECT * FROM (SELECT top 10 * FROM @TMP where rnd between 6 and 15 ORDER BY 1 ) s3
--ORDER BY 1
)s1

--SELECT @in
--SELECT sum(rnd) FROM #TMP
delete @TMP	
	SET @i = @i + 1
END

SELECT * FROM #TMP2



SELECT  [1], [2], [3], [4], [5], [6], [7], [8], [9], [10] 
FROM  
(SELECT id, rnd, count(rnd) count_rnd  FROM #TMP2 group by id, rnd) AS SourceTable  
PIVOT  
(  
max(count_rnd)
FOR id IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10])  
) AS PivotTable;

SELECT  [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15] 
FROM  
(SELECT id, rnd, count(rnd) count_rnd  FROM #TMP2 group by id, rnd) AS SourceTable  
PIVOT  
(  
max(count_rnd)
FOR id IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15] )  
) AS PivotTable;

--select rand()
*/

/*
DECLARE @TMP3 TABLE(ID INT identity(1,1),Data_s varchar(250) null, rnd INT null)
INSERT @TMP3
SELECT *,null FROM [zf_FilterToTable]('1,15')

SELECT * FROM @TMP3
*/
--DECLARE @S VARCHAR(MAX) = 'A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17,A18'
DECLARE @S VARCHAR(MAX) = 'A1,A2,A3,A4,A5,A6,A7,A8,A9,A10' -- последовательность

IF OBJECT_ID (N'tempdb..#TMP2', N'U') IS NOT NULL DROP TABLE #TMP2
CREATE TABLE #TMP2 (i INT null,ID INT null,rnd INT null,Data_s VARCHAR(MAX) NULL)

DECLARE @spr TABLE(ID INT IDENTITY(1,1),Data_s VARCHAR(MAX) NULL, RND INT NULL)
DECLARE @pos INT = 1, @len INT, @buf VARCHAR(MAX) = ''
SET @len = LEN(@S)
WHILE @len >= @pos
BEGIN
	IF SUBSTRING (@S,@pos,1) = ',' OR @len = @pos
	BEGIN
		IF @len = @pos SET @buf = @buf + SUBSTRING (@S,@pos,1)
		INSERT @spr SELECT @buf,NULL
		SET @buf = '' 	
	END
	ELSE SET @buf = @buf + SUBSTRING (@S,@pos,1)

	SET @pos = @pos + 1
END

SELECT * FROM @spr

DECLARE @i INT = 1, @n INT = 1000 --количество последовательностей
WHILE @n >= @i
BEGIN


DECLARE @out TABLE(ID INT IDENTITY(1,1),Data_s VARCHAR(MAX) NULL, RND INT NULL)
select @pos  = 1, @len  = LEN(@S), @buf  = ''
WHILE @len >= @pos
BEGIN
	IF SUBSTRING (@S,@pos,1) = ',' OR @len = @pos
	BEGIN
		IF @len = @pos SET @buf = @buf + SUBSTRING (@S,@pos,1)
		INSERT @out SELECT @buf,NULL
		SET @buf = '' 	
	END
	ELSE SET @buf = @buf + SUBSTRING (@S,@pos,1)

	SET @pos = @pos + 1
END

DECLARE @ID INT, @R INT, @in INT = 0
WHILE ISNULL((SELECT top 1 1 FROM @out WHERE RND IS NULL),0) = 1    		 
BEGIN
	--skript
	--SET @R = ABS(CHECKSUM(NewId())) % (SELECT count(*) FROM @out)  + 1 
	SET @R =  cast(rand()*(SELECT count(*) FROM @out) as int) + 1
	UPDATE top(1) @out SET RND = @R WHERE RND IS NULL AND @R NOT IN (SELECT RND FROM @out WHERE RND IS NOT NULL)
	SET @in = @in + 1
END 

--insert #TMP2
--SELECT @i i, row_number() over(ORDER BY id) N,rnd,(SELECT Data_s FROM @spr p where p.ID = m.RND) Data_s FROM (
--SELECT top 5 * FROM @out where rnd between 1 and 5
--union all
--SELECT top 15 * FROM @out where rnd between 6 and 15 
----SELECT * FROM (SELECT top 10 * FROM @out where rnd between 6 and 15 ORDER BY 1 ) s3
----ORDER BY 1
--)s1

insert #TMP2
SELECT @i i, row_number() over(ORDER BY id) N,rnd,(SELECT Data_s FROM @spr p where p.ID = m.RND) Data_s FROM @out m
--SELECT top 5 @i i, row_number() over(ORDER BY id)+5 N,rnd+5,(SELECT Data_s FROM @spr p where p.ID = m.RND) Data_s FROM @out m


--SELECT @in
--SELECT sum(rnd) FROM #TMP
delete @out	
	SET @i = @i + 1
END

SELECT * FROM #TMP2



SELECT  [1], [2], [3], [4], [5], [6], [7], [8], [9], [10] 
FROM  
(SELECT id, rnd, count(rnd) count_rnd  FROM #TMP2 group by id, rnd) AS SourceTable  
PIVOT  
(  
max(count_rnd)
FOR id IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10])  
) AS PivotTable;

/*
SELECT  [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15] 
FROM  
(SELECT id, rnd, count(rnd) count_rnd  FROM #TMP2 group by id, rnd) AS SourceTable  
PIVOT  
(  
max(count_rnd)
FOR id IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15] )  
) AS PivotTable;
*/

/*
IF OBJECT_ID (N'tempdb..#ARHIV', N'U') IS NOT NULL DROP TABLE #ARHIV
SELECT *
 INTO #ARHIV 
FROM #TMP2

SELECT * FROM #TMP2
SELECT * FROM #ARHIV


SELECT m.i, m.ID,case when d.rnd is null then m.rnd else d.rnd end rnd FROM #TMP2 m
left join #ARHIV d on d.i = m.i and m.rnd = d.id
--left join #TMP2 d2 on d2.i = m.i and d2.id = m.id
ORDER BY 1,2

*/

