--#region Просмотреть блокировки
--ALTER PROCEDURE [dbo].[ap_SendEmail_do_Blocked]
BEGIN
    SELECT 
        spid
        ,[status]
        ,CONVERT(CHAR(3), blocked) AS blocked
        ,loginame
        ,SUBSTRING([program_name] ,1,25) AS program
        ,SUBSTRING(DB_NAME(p.dbid),1,20) AS [database]
        ,SUBSTRING(hostname, 1, 12) AS host
        ,cmd
        ,sys.fn_varbintohexstr (waittype ) waittype --,cast(waittype as varchar) waittype
	    ,cast(t.[text] as varchar(250)) text
       FROM sys.sysprocesses p
        CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t
      WHERE ( (spid IN (SELECT blocked FROM sys.sysprocesses WHERE blocked <> 0) AND blocked = 0)  or (blocked <> 0) )
           AND ( [dbo].[zf_MatchFilterInt](p.dbid, '1,10,14',',') = 1) 
END;

--https://social.msdn.microsoft.com/Forums/sqlserver/en-US/2659aa8a-e2f5-4c7a-86f0-8b02b834eb90/how-to-solve-if-sql-server-sleeping-transaction-is-creating-blocking?forum=sqldatabaseengine
BEGIN
    SELECT des.session_id ,
    des.status ,
    des.login_name ,
    des.[HOST_NAME] ,
    der.blocking_session_id ,
    DB_NAME(der.database_id) AS database_name ,
    der.command ,
    des.cpu_time ,
    des.reads ,
    des.writes ,
    dec.last_write ,
    des.[program_name] ,
    der.wait_type ,
    der.wait_time ,
    der.last_wait_type ,
    der.wait_resource ,
    CASE des.transaction_isolation_level
    WHEN 0 THEN 'Unspecified'
    WHEN 1 THEN 'ReadUncommitted'
    WHEN 2 THEN 'ReadCommitted'
    WHEN 3 THEN 'Repeatable'
    WHEN 4 THEN 'Serializable'
    WHEN 5 THEN 'Snapshot'
    END AS transaction_isolation_level ,
    OBJECT_NAME(dest.objectid, der.database_id) AS OBJECT_NAME ,
    SUBSTRING(dest.text, der.statement_start_offset / 2,
    ( CASE WHEN der.statement_end_offset = -1
    THEN DATALENGTH(dest.text)
    ELSE der.statement_end_offset
    END - der.statement_start_offset ) / 2)
    AS [executing statement] ,
    deqp.query_plan
    FROM sys.dm_exec_sessions des --any connection (active or not) 
    LEFT JOIN sys.dm_exec_requests der --lists only requests currently executing (active only) !!!
    ON des.session_id = der.session_id
    LEFT JOIN sys.dm_exec_connections dec
    ON des.session_id = dec.session_id
    CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) dest
    CROSS APPLY sys.dm_exec_query_plan(der.plan_handle) deqp
    ORDER BY last_write DESC
END;

--Below code would give you query behind sql_handle:
SELECT er.session_id,
er.command,
t.text --gives query behind sql_handle
from sys.dm_exec_requests er --When blocking_session_id = 0, a session is not being blocked.
cross apply sys.dm_exec_sql_text(er.sql_handle) t
--#endregion Просмотреть блокировки

--#region kill sessions
SELECT conn.session_id, host_name, program_name,
    nt_domain, login_name, connect_time, last_request_end_time 
FROM sys.dm_exec_sessions AS sess
JOIN sys.dm_exec_connections AS conn
   ON sess.session_id = conn.session_id
   --WHERE login_name in ('rkv0', 'corp\rumyantsev', 'const\rumyantsev')
   --WHERE sess.session_id = '-2'
   --WHERE login_name in ('')
sp_who
sp_who2
--#endregion kill sessions

--#region EXTRA
DBCC useroptions 
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SELECT * FROM sys.dm_os_waiting_tasks --кто кого блокирует (blocking_session_id = блокирущая сессия).
SELECT * FROM sys.dm_exec_requests ---кто кого блокирует.

SELECT * FROM sys.dm_tran_locks --currently lock requests and their statuses. (dm = dynamic management view).
--http://infocenter.sybase.com/help/index.jsp?topic=/com.sybase.infocenter.dc36274.1550/html/tables/X39735.htm
SELECT * FROM sys.sysprocesses WHERE loginame like '%rumyantsev%' /*WHERE blocked <> 0*/ --any process (active or not) will be listed.
--SELECT * FROM sys.databases WITH(NOLOCK) --list all databases (Elit - 14, ElitR - 10, ElitTest - 38, ElitDistr - 35).
select spid, status, loginame, hostname, blocked, db_name(dbid), cmd from master..sysprocesses where db_name(dbid) = 'Elit' and spid = 145
SELECT * FROM sys.dm_exec_sql_text...--Parameters were not supplied for the function 'sys.dm_exec_sql_text'.
SELECT * FROM sys.dm_tran_session_transactions
--#endregion EXTRA

--#region CHECK
EXEC dbo.sp_who 'kvg3'
EXEC dbo.sp_who2_log 'kvg3'
DBCC INPUTBUFFER(145)
SELECT * FROM sys.dm_exec_sessions WHERE original_login_name = 'hia3'
SELECT * FROM sys.dm_tran_locks WHERE request_session_id = 145 --currently lock requests and their statuses. (dm = dynamic management view).
SELECT * FROM sys.dm_exec_connections WHERE session_id = 145 --connect_time...
SELECT * FROM sys.dm_exec_sessions WHERE session_id = 145

EXEC dbo.sp_locks
select * from sys.dm_exec_requests er cross apply sys.dm_exec_sql_text (sql_handle)

SELECT @@SPID
DBCC INPUTBUFFER(409)
DBCC OPENTRAN
--kiLL 271 --Process ID 295 is not an active process ID. / Cannot use KILL to kill your own process.
--#endregion CHECK


