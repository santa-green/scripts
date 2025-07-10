USE ElitR_test;
--������� ��������� �� ������� #TMP
/*
�������:
-MS SQL Server 2008
-������ ������� �������, �������� �� ��������� � �����������
-������ ������� ��� ������ �� �������
*/

IF OBJECT_ID(N'tempdb..#TMP', N'U') IS NOT NULL
    DROP TABLE #TMP;
CREATE TABLE #TMP(DocID INT NULL);
INSERT INTO #TMP
       SELECT 1700003301
       UNION ALL
       SELECT 1700003302
       UNION ALL
       SELECT 1700003302
       UNION ALL
       SELECT 1700003302
       UNION ALL
       SELECT 1700003403
       UNION ALL
       SELECT 1700003504
       UNION ALL
       SELECT 1700005105
       UNION ALL
       SELECT 1700005105
       UNION ALL
       SELECT 1700003506;

--������� �1 (����� ����������� ���� ������� - �����).
IF 1 = 0
    BEGIN
        BEGIN TRAN;
        --DELETE FROM #TMP WHERE DocID IN (SELECT MAX(DocID) from #TMP GROUP BY DocID HAVING count(DocID)>2)
        SELECT DISTINCT 
               *
        INTO #TMP2
        FROM #TMP;
        DELETE FROM #TMP;
        INSERT INTO #TMP
               SELECT *
               FROM #TMP2;
        DROP TABLE #TMP2;
        SELECT *
        FROM #TMP;
        ROLLBACK TRAN;
END;

--������� �2 (������� ���).
IF 2 = 0
    BEGIN
        BEGIN TRAN;
        DELETE FROM #TMP
        WHERE DocID IN
        (
            SELECT MAX(DocID)
            FROM #TMP
            GROUP BY DocID
            HAVING COUNT(DocID) > 2
        );
        ROLLBACK TRAN;
END;

----SELECT *,(select count(*) from #TMP t1 where t1.DocID = t2.DocID ) FROM #TMP t2
----DELETE top((select count(*)-1 from #TMP t1 where t1.DocID = DocID )) FROM #TMP  --WHERE DocID IN (1700003302)
--select *, (SELECT count(*) FROM #TMP) FROM #TMP
--select * from (
--SELECT *,(select count(*) from #TMP t1 where t1.DocID = t2.DocID ) N FROM #TMP t2
--) S1
--SELECT DocID, COUNT(*) AS CNT
--FROM #TMP
--PARTITION BY DocID
--HAVING COUNT(*) > 1
--select *, %%physloc%% FROM #TMP m1 WHERE EXISTS
--   (SELECT * FROM #TMP m2 WHERE
--      (m2.DocID = m1.DocID /*or (T2.column1 is null and T2.column1 is null)*/) 
--	  AND
--      (m2.%%physloc%% < m1.%%physloc%%))

--������� �1: �������� ����� %%physloc%%
SELECT %%physloc%% guid, sys.fn_PhysLocFormatter(%%physloc%%),
       *
FROM #TMP;
DELETE m1
FROM #TMP m1
CROSS APPLY fn_PhysLocCracker(%%physloc%%)
WHERE EXISTS
(
    SELECT *
    FROM #TMP m2
    WHERE(m2.DocID = m1.DocID)
         AND (m2.%%physloc%% < m1.%%physloc%%)
);

SELECT %%physloc%% guid, sys.fn_PhysLocFormatter(%%physloc%%),*
FROM #tmp
CROSS APPLY fn_PhysLocCracker(%%physloc%%)

--�������2: �������� ����� rownumber
WITH TempEmp(DocID, 
             duplicateRecCount)
     AS (SELECT DocID, 
                ROW_NUMBER() OVER(PARTITION BY DocID
                ORDER BY DocID) AS duplicateRecCount
         FROM #TMP)
     DELETE FROM TempEmp
     WHERE duplicateRecCount > 1; 
SELECT *
FROM #TMP;

SET DELETED ON
SELECT * FROM #TMP