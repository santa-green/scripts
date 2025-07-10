;WITH block_cte as (
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
)

SELECT * FROM block_cte ORDER BY last_write DESC