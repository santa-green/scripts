-- просмотреть подключеных пользователей к  базе со скриптом sql
  DECLARE @DBID int, @SPID int

SELECT s1.*,sp.sql_handle,db_name(dbid) as db_name,spid,loginame, status,hostname, program_name
, nt_domain, nt_username,login_time, last_batch, sp.* 
	FROM master.dbo.sysprocesses sp --WHERE dbid in (SELECT database_id FROM master.sys.databases where name <> 'master' )
	cross apply  (SELECT dbid dbid_ca, objectid, number, encrypted, text FROM  ::fn_get_sql(sp.sql_handle) ca1 ) s1

	--ORDER BY sp.status,sp.loginame
	ORDER BY sp.loginame

/*

	--EXEC dbo.ap_VC_ImportOrders_Kiev


/*
SELECT * FROM  ::fn_get_sql(0x01000A004BE9171470BAF02D0400000000000000)
*/
set @SPID = 76

DECLARE @sql_handle binary(20), @stmt_start int, @stmt_end int

select
@sql_handle = sql_handle, 
@stmt_start = stmt_start/2, 
@stmt_end = CASE WHEN stmt_end = -1 THEN -1 ELSE stmt_end/2 END 
FROM master.dbo.sysprocesses 
WHERE spid = @SPID AND ecid = 0

select @sql_handle,@stmt_start,@stmt_end

--SELECT * FROM  ::fn_get_sql(0x010031008238FB24709F4E5D0400000000000000)


DECLARE @line nvarchar(4000) 

SET @line = (SELECT SUBSTRING([text], COALESCE(NULLIF(@stmt_start, 0), 1), 
  CASE @stmt_end WHEN -1 THEN DATALENGTH([text]) ELSE (@stmt_end - @stmt_start) END) FROM ::fn_get_sql(@sql_handle))  

print @line

select @line

SET @line = (SELECT text FROM  ::fn_get_sql(@sql_handle))
print @line
*/