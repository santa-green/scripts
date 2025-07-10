select DB_NAME(pr.dbid) AS 'DB'
	   ,pr.spid
	   ,pr.status
	   ,RTRIM(pr.loginame) AS 'Login'
	   ,pr.program_name AS 'Program'
	   ,txt.[text] AS 'sql_query'
from master.dbo.sysprocesses pr
outer apply sys.[dm_exec_sql_text](pr.[sql_handle]) as txt
where txt.[text] like '%D02_Axapta_OPEX_CAPEX_t%';