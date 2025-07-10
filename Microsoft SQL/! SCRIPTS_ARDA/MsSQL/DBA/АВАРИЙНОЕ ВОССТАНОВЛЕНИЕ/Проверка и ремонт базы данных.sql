--https://infostart.ru/public/59520/
--https://habr.com/ru/sandbox/40161/

EXEC sp_resetstatus 'ElitV_DP'; --Сбрасывает состояние SUSPECT для базы данных.
ALTER DATABASE ElitV_DP SET EMERGENCY

--Потом выполнять тестирование базы:


DBCC checkdb ('ElitV_DP')
ALTER DATABASE ElitV_DP SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DBCC CheckDB ('ElitV_DP', REPAIR_ALLOW_DATA_LOSS)
ALTER DATABASE ElitV_DP SET MULTI_USER

DBCC CHECKIDENT(dbo.z_LogCreate, RESEED); --ИЛИ
DBCC CHECKIDENT(z_LogCreate);

SELECT * FROM z_LogCreate