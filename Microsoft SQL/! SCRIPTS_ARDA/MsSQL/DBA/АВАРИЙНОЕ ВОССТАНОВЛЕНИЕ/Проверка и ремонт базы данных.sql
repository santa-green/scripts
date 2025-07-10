--https://infostart.ru/public/59520/
--https://habr.com/ru/sandbox/40161/

EXEC sp_resetstatus 'ElitV_DP'; --���������� ��������� SUSPECT ��� ���� ������.
ALTER DATABASE ElitV_DP SET EMERGENCY

--����� ��������� ������������ ����:


DBCC checkdb ('ElitV_DP')
ALTER DATABASE ElitV_DP SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DBCC CheckDB ('ElitV_DP', REPAIR_ALLOW_DATA_LOSS)
ALTER DATABASE ElitV_DP SET MULTI_USER

DBCC CHECKIDENT(dbo.z_LogCreate, RESEED); --���
DBCC CHECKIDENT(z_LogCreate);

SELECT * FROM z_LogCreate