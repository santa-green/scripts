SELECT CURRENT_USER
SELECT SUSER_NAME()
SELECT SYSTEM_USER
SELECT SUSER_SNAME()
SELECT ORIGINAL_LOGIN()

GO
EXECUTE AS USER = 'kea20';
GO

SELECT CURRENT_USER
SELECT SUSER_NAME()
SELECT SYSTEM_USER
SELECT SUSER_SNAME()
SELECT ORIGINAL_LOGIN()
GO
REVERT;
GO
SELECT CURRENT_USER
SELECT SUSER_NAME()
SELECT SYSTEM_USER
SELECT SUSER_SNAME()
SELECT ORIGINAL_LOGIN()


SELECT @@CONNECTIONS

SELECT HOST_ID ()
SELECT HOST_NAME  ()
SELECT HOST_ID ()
SELECT HOST_ID ()
SELECT HOST_ID ()
SELECT HOST_ID ()

SELECT 
ConnectionProperty('net_transport') AS 'Net transport', 
ConnectionProperty('net_transport') AS 'Net transport', 
ConnectionProperty('auth_scheme') AS 'auth_scheme', 
ConnectionProperty('local_net_address') AS 'local_net_address', 
ConnectionProperty('local_tcp_port') AS 'local_tcp_port', 
ConnectionProperty('client_net_address') AS 'client_net_address', 
ConnectionProperty('physical_net_transport') AS 'physical_net_transport', 
ConnectionProperty('protocol_type') AS 'Protocol type';

SELECT 
    c.session_id, c.net_transport, c.encrypt_option, 
    c.auth_scheme, s.host_name, s.program_name, 
    s.client_interface_name, s.login_name, s.nt_domain, 
    s.nt_user_name, s.original_login_name, c.connect_time, 
    s.login_time 
FROM sys.dm_exec_connections AS c
JOIN sys.dm_exec_sessions AS s
    ON c.session_id = s.session_id
WHERE c.session_id = @@SPID;

SELECT s.* 
FROM sys.dm_exec_sessions AS s
WHERE EXISTS 
    (
    SELECT * 
    FROM sys.dm_tran_session_transactions AS t
    WHERE t.session_id = s.session_id
    )
    AND NOT EXISTS 
    (
    SELECT * 
    FROM sys.dm_exec_requests AS r
    WHERE r.session_id = s.session_id
    );
    
--Г.Поиск сведений о собственном соединении запросов
--Типичный запрос для сбора сведений о собственном соединении запросов.
SELECT 
    c.session_id, c.net_transport, c.encrypt_option, 
    c.auth_scheme, s.host_name, s.program_name, 
    s.client_interface_name, s.login_name, s.nt_domain, 
    s.nt_user_name, s.original_login_name, c.connect_time, 
    s.login_time 
FROM sys.dm_exec_connections AS c
JOIN sys.dm_exec_sessions AS s
    ON c.session_id = s.session_id
WHERE c.session_id = @@SPID;    

SELECT authenticating_database_id,* FROM sys.dm_exec_sessions WHERE session_id = @@SPID;   

SELECT * FROM sys.dm_exec_connections WHERE session_id = @@SPID; 
SELECT * FROM  sys.dm_exec_sessions WHERE session_id = @@SPID; 
SELECT * FROM  sys.dm_exec_requests WHERE session_id = @@SPID; 
SELECT * FROM sys.sysprocesses 

SELECT * FROM sys.dm_db_session_space_usage
SELECT * FROM sys.dm_exec_cursors(0)
SELECT * FROM dbo.sysdac_instances 

SELECT CONTEXT_INFO()

