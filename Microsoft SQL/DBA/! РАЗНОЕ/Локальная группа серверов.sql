SELECT @@VERSION

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
           AND ( [dbo].[zf_MatchFilterInt](p.dbid, '10,14',',') = 1) 
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
    FROM sys.dm_exec_sessions des
    LEFT JOIN sys.dm_exec_requests der
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
from sys.dm_exec_requests er
cross apply sys.dm_exec_sql_text(er.sql_handle) t
--#endregion Просмотреть блокировки

--#region Running jobs
SELECT 'Running jobs'
EXEC msdb.dbo.sp_help_job @execution_status = 1
--#endregion Running jobs
