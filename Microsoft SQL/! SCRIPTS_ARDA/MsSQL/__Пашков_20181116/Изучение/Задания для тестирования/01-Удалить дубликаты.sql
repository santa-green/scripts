--Удалить дубликаты из таблицы #TMP
/*
Условия:
-MS SQL Server 2008
-Нельзя удалять таблицу, изменять ее структуру и ограничения
-Нельзя удалять все записи из таблицы
*/
IF OBJECT_ID (N'tempdb..#TMP', N'U') IS NOT NULL DROP TABLE #TMP
CREATE TABLE #TMP (DocID INT null)

INSERT #TMP		
          select 1700003301
union all select 1700003302
union all select 1700003302
union all select 1700003302
union all select 1700003403
union all select 1700003504
union all select 1700005105
union all select 1700005105
union all select 1700003506

SELECT * FROM #TMP

--Ниже напишите ваши варианты решения данной задачи