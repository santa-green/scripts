/*SELECT TOP 100 * FROM z_DocLinks WITH(NOLOCK) WHERE LinkID = 8435366

SELECT TOP 10 * FROM z_DocLinks WITH(NOLOCK) ORDER BY 1 DESC
SELECT top 10 * FROM t_Inv WHERE ChID = 100191955

SELECT * FROM z_Docs WHERE DocName like '%расход%'
SELECT * FROM z_Docs WHERE DocCode = 666028
SELECT top 10 * FROM t_Ret ORDER BY 1 DESC

SELECT * FROM t_Ret WHERE ChID = 100156433
SELECT * FROM z_DocLinks WHERE childchid = 100156433*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Join - это не "пересечение", а "декартово произведение с условием".

--create table #table1 (id int)
INSERT INTO #table1 (id)
VALUES
(1),
(1),
(3)

--create table #table2 (id int)
INSERT INTO #table2
(id)
VALUES
(1),
(1),
(2);

SELECT *
FROM #table1 t1
   JOIN #table2 t2
      ON t1.id = t2.id; --any boolean expression; 1=1 - аналог cross join (декартово произведение).
      --ON t1.id = 1 and t2.id = 2;

SELECT * FROM #table1 t1 WITH(NOLOCK), #table2 t2 WITH(NOLOCK) 
WHERE t1.id = t2.id

SELECT * FROM #table1
SELECT * FROM #table2

SELECT *
FROM #table1 t1
   LEFT JOIN #table2 t2
      ON t1.id = t2.id; --any boolean expression; 1=1 - аналог cross join (декартово произведение).
      --ON t1.id = 1 and t2.id = 2;

SELECT *
FROM #table1 t1
   RIGHT JOIN #table2 t2
      ON t1.id = t2.id; --any boolean expression; 1=1 - аналог cross join (декартово произведение).
      --ON t1.id = 1 and t2.id = 2;

SELECT *
FROM #table1 t1
   FULL JOIN #table2 t2
      ON t1.id = t2.id; --any boolean expression; 1=1 - аналог cross join (декартово произведение).
      --ON t1.id = 1 and t2.id = 2;