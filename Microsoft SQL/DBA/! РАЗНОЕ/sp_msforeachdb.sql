EXEC master.sys.sp_MSforeachdb 'USE [?]; IF object_id(''a_UpdateAzPerms'',''P'') IS NOT NULL EXEC a_UpdateAzPerms'

EXEC sp_msforeachdb 'USE ?; PRINT DB_NAME()'

EXEC SP_HELPTEXT 'sp_msforeachdb'

--�������� ����������� ��
EXEC sp_msforeachdb 'DBCC CHECKDB(?)'

--����� ��������� �� (���������� ����, ������������� � �.�.):
EXEC sp_msforeachdb 'USE ? EXEC sp_helpfile'


--����� ������ ������ �������:
EXEC sp_msforeachdb 'USE ?;
	SELECT DB_NAME() AS DatabaseName,
	OBJECT_NAME(object_Id) AS TableName FROM sys.tables'



EXEC SP_HELPTEXT 'ap_VC_ImportOrders'