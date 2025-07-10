-- сведени€ о каждом из запросов, выполн€ющихс€ в SQL Server
SELECT (SELECT text FROM sys.dm_exec_sql_text(sql_handle)) as txt, * FROM sys.dm_exec_requests ORDER BY start_time desc