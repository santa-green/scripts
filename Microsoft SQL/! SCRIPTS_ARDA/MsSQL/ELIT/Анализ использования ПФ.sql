/*������� ��������� ������������ ��� */

IF OBJECT_ID (N'tempdb..#LogPrint', N'U') IS NOT NULL DROP TABLE #LogPrint

SELECT (SELECT AppName FROM z_Apps a where a.AppCode = ap.AppCode) AppName 
,*,
case
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else ap.FileName end NewFileName
 into #LogPrint
FROM z_LogPrint ap ORDER BY NewFileName

SELECT * FROM #LogPrint ORDER BY NewFileName
SELECT * FROM #LogPrint where NewFileName like '%MeDoc%'


IF OBJECT_ID (N'tempdb..#AppPrints', N'U') IS NOT NULL DROP TABLE #AppPrints
SELECT distinct
case
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else ap.FileName end NewFileName
 into #AppPrints
FROM z_AppPrints ap ORDER BY NewFileName
SELECT * FROM #AppPrints ORDER BY NewFileName

IF OBJECT_ID (N'tempdb..#DocPrints', N'U') IS NOT NULL DROP TABLE #DocPrints
SELECT distinct
case
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else ap.FileName end NewFileName
 into #DocPrints
FROM z_DocPrints ap ORDER BY NewFileName
SELECT * FROM #DocPrints ORDER BY NewFileName

--����� ���������� �������
SELECT * FROM (

SELECT * 
,(SELECT count(*) FROM #LogPrint lp with (nolock) where lp.NewFileName = m.NewFileName) '���'
FROM (
SELECT * FROM #AppPrints
union 
SELECT * FROM #DocPrints
) m 

) s1 
--where ��� = 0
ORDER BY 2 desc

----------------------------------------------------------------------------------


SELECT * 
,(SELECT count(*) FROM #LogPrint lp with (nolock) where lp.NewFileName = m.NewFileName) '���'
FROM (
SELECT * FROM #AppPrints
union 
SELECT * FROM #DocPrints
) m ORDER BY 1


SELECT (SELECT AppName FROM z_Apps a where a.AppCode = m.AppCode) AppName,* FROM z_AppPrints m where FileName like '%test_TaxDocs.fr3%'
SELECT (SELECT DocName FROM z_Docs d where d.DocCode = m.DocCode) DocName ,* FROM z_DocPrints m where FileName like '%test_TaxDocs.fr3%'


--SELECT * into z_AppPrints_old FROM z_AppPrints
--SELECT * into z_DocPrints_old FROM z_DocPrints


SELECT (SELECT DocName FROM z_Docs d where d.DocCode = m.DocCode) DocName,* FROM z_DocPrints m ORDER BY 1,FileDesc
SELECT (SELECT AppName FROM z_Apps d where d.AppCode = m.AppCode) AppName,* FROM z_AppPrints m ORDER BY 1,FileDesc
SELECT * FROM z_AppPrints where  AppCode = 11000 ORDER BY FileDesc
SELECT * FROM z_AppPrints where FileName like '\%'
SELECT * FROM z_DocPrints where FileName like '\%'

SELECT * FROM z_AppPrints where FileName like '�������%'
SELECT * FROM z_DocPrints where FileName like '�������%'
SELECT * FROM z_DocPrints where DocCode = 11012 ORDER BY FileDesc
SELECT * FROM z_DocPrints_old where FileName like '����������.fr3%'

--�������� ��� ������� z_AppPrints
SELECT (SELECT AppName FROM z_Apps a where a.AppCode = m.AppCode) AppName 
,(SELECT count(*) FROM #LogPrint lp with (nolock) where lp.AppCode = m.AppCode and lp.NewFileName = 
case 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',m.FileName) <> 0 then replace(m.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else m.FileName end ) '��� ������'
,AppCode,FileName
, FileDesc, OldFileName 
FROM z_AppPrints m ORDER BY 1,FileDesc 

--�������� ��� ������� z_DocPrints
SELECT (SELECT DocName FROM z_Docs d where d.DocCode = m.DocCode) DocName 
,(SELECT count(*) FROM #LogPrint lp with (nolock) where lp.DocCode = m.DocCode and lp.NewFileName = 
case 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',m.FileName) <> 0 then replace(m.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else m.FileName end ) '��� ������'
,DocCode,FileName
, FileDesc, OldFileName 
FROM z_DocPrints m ORDER BY 1,FileDesc 


/* Elit_ARHIV
����� �� �� � z_AppPrints
�������	12000	������\�������������� ������\��� ������ (���) �������.fr3	������\�������������� ������\��� ������ (���) �������.fr3	��� ������ (���) �������	NULL
������	11000	������\�������������� ������\��� ������ (���) �������.fr3	������\�������������� ������\��� ������ (���) �������.fr3	��� ������ (���) �������	NULL
����	14010	�����\������\������ - �����������.fr3	�����\������\������ - �����������.fr3	������ - �����������	NULL
�����������	14000	�����\������\������ - �����������.fr3	�����\������\������ - �����������.fr3	������ - �����������	NULL
������	11000	�����\������\������ - �����������.fr3	�����\������\������ - �����������.fr3	������ - �����������	NULL
�������	12000	�����\������\������ - �����������.fr3	�����\������\������ - �����������.fr3	������ - �����������	NULL

����� �� �� � z_DocPrints
DocName	DocCode	FileName	NewFileName	FileDesc	OldFileName
������: ����������� ������	11521	������\���������\����������� ������\����������� ������ (�����).fr3	������\���������\����������� ������\����������� ������ (�����).fr3	����������� ������ (�����)	NULL
����������� ������	11021	������\���������\����������� ������\����������� ������ (�����).fr3	������\���������\����������� ������\����������� ������ (�����).fr3	����������� ������ (�����)	NULL
����������� ������	11021	������\���������\����������� ������\����������� ������ (��) ���.fr3	������\���������\����������� ������\����������� ������ (��) ���.fr3	����������� ������ (��) ���	NULL
������: ����������� ������	11521	������\���������\����������� ������\����������� ������ (��) ���.fr3	������\���������\����������� ������\����������� ������ (��) ���.fr3	����������� ������ (��) ���	NULL
������: ����������� ������	11521	������\���������\����������� ������\����������� ������.fr3	������\���������\����������� ������\����������� ������.fr3	����������� ������ (��.)	NULL
����������� ������	11021	������\���������\����������� ������\����������� ������.fr3	������\���������\����������� ������\����������� ������.fr3	����������� ������ (��.)	NULL
������: ����������� ������	11521	������\���������\����������� ������\��� ����� (�����).fr3	������\���������\����������� ������\��� ����� (�����).fr3	��� ����� (�����)	NULL
����������� ������	11021	������\���������\����������� ������\��� ����� (�����).fr3	������\���������\����������� ������\��� ����� (�����).fr3	��� ����� (�����)	NULL
����������� ������	11021	������\���������\����������� ������\���.fr3	������\���������\����������� ������\���.fr3	���	NULL
������: ����������� ������	11521	������\���������\����������� ������\���.fr3	������\���������\����������� ������\���.fr3	���	NULL
��������� ���������	11012	������\���������\��������� ���������\��� ������������� �� ���� (����������) �����.fr3	������\���������\��������� ���������\��� ������������� �� ���� (����������) �����.fr3	��� ������������� �� ���� (����������) �����	NULL
������� ������ �� ����������	11003	������\���������\��������� ���������\��� ������������� �� ���� (����������) �����.fr3	������\���������\��������� ���������\��� ������������� �� ���� (����������) �����.fr3	��� ������������� �� ���� (����������) �����	NULL
������� ������ �� ����������	11003	\\s-sql-d4\OT38ElitServer\Reports\������\���������\��������� ���������\��� �� ������ _AT� (2020).fr3	������\���������\��������� ���������\��� �� ������ _AT� (2020).fr3	��� �� ������ _AT� (2020)	NULL
��������� ���������	11012	\\s-sql-d4\OT38ElitServer\Reports\������\���������\��������� ���������\��� �� ������ _AT� (2020).fr3	������\���������\��������� ���������\��� �� ������ _AT� (2020).fr3	��� �� ������ _AT� (2020)	NULL
������� ������ �� ����������	11003	������\���������\��������� ���������\���������������� ��������� (Test).fr3	������\���������\��������� ���������\���������������� ��������� (Test).fr3	������������� �� ����/���-�� (������ �������������)	NULL
��������� ���������	11012	������\���������\��������� ���������\���������������� ��������� (Test).fr3	������\���������\��������� ���������\���������������� ��������� (Test).fr3	������������� �� ����/���-�� (������ �������������)	NULL
������� ������ �� ����������	11003	������\���������\��������� ���������\���������������� ���������.fr3	������\���������\��������� ���������\���������������� ���������.fr3	������������� �� ����/���-�� (������ �������������) �� 01.12.2016	NULL
��������� ���������	11012	������\���������\��������� ���������\���������������� ���������.fr3	������\���������\��������� ���������\���������������� ���������.fr3	������������� �� ����/���-�� (������ �������������) �� 01.12.2016	NULL
��������� ���������	11012	������\���������\��������� ���������\���������������� �������� ���������.fr3	������\���������\��������� ���������\���������������� �������� ���������.fr3	������������� �� ����/���-�� (��� �������������) �� 01.12.2016	NULL
������� ������ �� ����������	11003	������\���������\��������� ���������\���������������� �������� ���������.fr3	������\���������\��������� ���������\���������������� �������� ���������.fr3	������������� �� ����/���-�� (��� �������������) �� 01.12.2016	NULL
��������� ���������	11012	������\���������\��������� ���������\��������� ��������� (����� ����������) ��� (Test).fr3	������\���������\��������� ���������\��������� ��������� (����� ����������) ��� (Test).fr3	��������� ��������� (����� ����������) ���	NULL
������: ��������� ���������	11512	������\���������\��������� ���������\��������� ��������� (����� ����������) ��� (Test).fr3	������\���������\��������� ���������\��������� ��������� (����� ����������) ��� (Test).fr3	��������� ��������� (����� ����������) ���	NULL
������: ��������� ��������� ��������	1666045	������\���������\��������� ���������\��������� ��������� (����� ����������) ��� (Test).fr3	������\���������\��������� ���������\��������� ��������� (����� ����������) ��� (Test).fr3	��������� ��������� (����� ����������) ��� (Test)	NULL
������: ��������� ��������� ��������	1666045	������\���������\��������� ���������\������ - ��������� ���������.fr3	������\���������\��������� ���������\������ - ��������� ���������.fr3	������ - ��������� ���������	NULL
������: ��������� ���������	11512	������\���������\��������� ���������\������ - ��������� ���������.fr3	������\���������\��������� ���������\������ - ��������� ���������.fr3	������ - ��������� ���������	NULL
��������� ���������	11012	������\���������\��������� ���������\���.fr3	������\���������\��������� ���������\���.fr3	��� �� 01.12.2016	NULL
������: ��������� ��������� ��������	1666045	������\���������\��������� ���������\���.fr3	������\���������\��������� ���������\���.fr3	���	NULL
������: ��������� ���������	11512	������\���������\��������� ���������\���.fr3	������\���������\��������� ���������\���.fr3	��� �� 01.12.2016	NULL
������: ��������� ���������	11512	������\���������\������ ��\��������� ��������� (����� ����������) ��� (2 �����).fr3	������\���������\������ ��\��������� ��������� (����� ����������) ��� (2 �����).fr3	������: ��������� ��������� (����� ����������) ��� (2 �����)	NULL
��������� ���������	11012	������\���������\������ ��\��������� ��������� (����� ����������) ��� (2 �����).fr3	������\���������\������ ��\��������� ��������� (����� ����������) ��� (2 �����).fr3	������: ��������� ��������� (����� ����������) ��� (2 �����)	NULL
��������� ���������	11012	������\���������\������ ��\��������� ��������� (����� ����������) ��� (������).fr3	������\���������\������ ��\��������� ��������� (����� ����������) ��� (������).fr3	������: ��������� ��������� (����� ����������) ��� (������)	NULL
������: ��������� ���������	11512	������\���������\������ ��\��������� ��������� (����� ����������) ��� (������).fr3	������\���������\������ ��\��������� ��������� (����� ����������) ��� (������).fr3	������: ��������� ��������� (����� ����������) ��� (������)	NULL
������: ��������� ���������	11512	������\���������\������ ��\��������� ��������� (����� ����������) ��� ��� ������������ �����������.fr3	������\���������\������ ��\��������� ��������� (����� ����������) ��� ��� ������������ �����������.fr3	������: ��������� ��������� (����� ����������) ��� ��� ������������ �����������	NULL
��������� ���������	11012	������\���������\������ ��\��������� ��������� (����� ����������) ��� ��� ������������ �����������.fr3	������\���������\������ ��\��������� ��������� (����� ����������) ��� ��� ������������ �����������.fr3	������: ��������� ��������� (����� ����������) ��� ��� ������������ �����������	NULL
��������� ���������	11012	������\���������\������ ��\��������� ��������� (����� ����������) ���.fr3	������\���������\������ ��\��������� ��������� (����� ����������) ���.fr3	������: ��������� ��������� (����� ����������) ���	NULL
������: ��������� ���������	11512	������\���������\������ ��\��������� ��������� (����� ����������) ���.fr3	������\���������\������ ��\��������� ��������� (����� ����������) ���.fr3	������: ��������� ��������� (����� ����������) ���	NULL
���: ���� �� ������	14101	�����\���������\��������� ��������� ��������� (�� ������).fr3	�����\���������\��������� ��������� ��������� (�� ������).fr3	��������� ��������� ��������� (�� ������)	NULL
���: ��������� ���������	14111	�����\���������\��������� ��������� ��������� (�� ������).fr3	�����\���������\��������� ��������� ��������� (�� ������).fr3	��������� ��������� ��������� (�� ������)	NULL
���: ������ �� ���	14132	�����\���������\��������� ��������� ��������� (�� ������).fr3	�����\���������\��������� ��������� ��������� (�� ������).fr3	��������� ��������� ��������� (�� ������)	NULL
�������� ��������: �������	14206	�����\���������\��������� ��������� ��������� (�� ������).fr3	�����\���������\��������� ��������� ��������� (�� ������).fr3	��������� ��������� ��������� (�� ������)	NULL
��������� ��������	11015	�����\���������\��������� ��������� ��������� (�� ������).fr3	�����\���������\��������� ��������� ��������� (�� ������).fr3	��������� ��������� ��������� (�� ������)	NULL
��������� �������� � ����� �������	11016	�����\���������\��������� ��������� ��������� (�� ������).fr3	�����\���������\��������� ��������� ��������� (�� ������).fr3	��������� ��������� ��������� (�� ������)	NULL
������� ������ ����������	11035	�����\���������\��������� ��������� ��������� (�� ������).fr3	�����\���������\��������� ��������� ��������� (�� ������).fr3	��������� ��������� ��������� (�� ������)	NULL
��������� ���������	11012	�����\���������\��������� ��������� ��������� (�� ������).fr3	�����\���������\��������� ��������� ��������� (�� ������).fr3	��������� ��������� ��������� (�� ������)	NULL
���� �� ������ ������	11001	�����\���������\��������� ��������� ��������� (�� ������).fr3	�����\���������\��������� ��������� ��������� (�� ������).fr3	��������� ��������� ��������� (�� ������)	NULL

*/






SELECT (SELECT AppName FROM z_Apps a where a.AppCode = ap.AppCode) AppName 

,* FROM z_AppPrints ap ORDER BY 1


SELECT (SELECT AppName FROM z_Apps a where a.AppCode = ap.AppCode) AppName ,* FROM z_AppPrints ap ORDER BY 1

SELECT (SELECT DocName FROM z_Docs d where d.DocCode = dp.DocCode) DocName, * FROM z_DocPrints dp ORDER BY 1


SELECT (SELECT AppName FROM z_Apps a where a.AppCode = ap.AppCode) AppName 
,AppCode,FileName
, case 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',FileName) <> 0 then replace(FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else FileName end NewFileName
, FileDesc, OldFileName 
FROM z_AppPrints ap ORDER BY NewFileName


SELECT (SELECT DocName FROM z_Docs d where d.DocCode = dp.DocCode) DocName
,DocCode,FileName
, case 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',FileName) <> 0 then replace(FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else FileName end NewFileName
, FileDesc, OldFileName 
FROM z_DocPrints dp  ORDER BY NewFileName



SELECT * FROM z_LogPrint ORDER BY 7








SELECT (SELECT DocName FROM z_Docs d where d.DocCode = dp.DocCode) DocName, * FROM z_DocPrints dp ORDER BY 1

/*
select * from z_Tables WHERE TableName like '%log%' OR TableDesc like '%log%'
select patindex('\\%','\fsdfsdf')
SELECT * FROM z_vars ORDER BY VarValue
SELECT * FROM z_LogTools
\\s-sql-d4.corp.local\OT38ElitServer\Reports\������\���������\��������� ��������\��������� �������� � ���.fr3
\\s-sql-d4\OT38ElitServer\ReportsUni\������\���������\��������� ���������\02-VN1-��������� ��������� (��������� ���������) ��� (auto)_uni.fr3
\\S-SQL-D4\OT38ElitServer\ReportsUni\�������\���������\������ ����������� �� � �����(UNI).fr3
\\s-sql-d4\OT38ElitServer\Reports\�����\������\������ - ����������� +Elit_ARHIV.fr3
\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\������\������\������ - ����������� � ������� ���������.fr3
\\s-sql-d4\OT38ElitServer\Import\OTFRExporter\TestExport-form.fr3

*/


























