--������� ��������� �� ������� #TMP
/*
�������:
-MS SQL Server 2008
-������ ������� �������, �������� �� ��������� � �����������
-������ ������� ��� ������ �� �������
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

--���� �������� ���� �������� ������� ������ ������