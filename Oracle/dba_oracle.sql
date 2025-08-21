select * from dual;
SELECT sys_context('USERENV', 'SID') FROM dual;

SELECT SYSDATE FROM dual;  -- Get current date/time
SELECT USER FROM dual;  -- Get current user
SELECT 2 + 3 FROM dual;  -- Perform calculations

show pdbs;
SELECT pdb_name, status FROM dba_pdbs;
SELECT * FROM sysauth$;
SELECT privilege# FROM sys.sysauth$;
select 

SET PAGESIZE 100;
CLEAR SCREEN;

SELECT username FROM dba_users WHERE username = 'HR';

ALTER SESSION SET CONTAINER = XEPDB1;
show pdbs;
drop user hr;
CREATE USER hr IDENTIFIED BY test1234 CONTAINER=CURRENT;
GRANT CREATE MATERIALIZED VIEW, CREATE PROCEDURE, CREATE TABLE TO HR;

GRANT CONNECT, RESOURCE TO hr;
GRANT CREATE MATERIALIZED VIEW, CREATE PROCEDURE, CREATE SEQUENCE TO hr;
GRANT CREATE SESSION, CREATE SYNONYM, CREATE TABLE, CREATE TRIGGER, CREATE TYPE, CREATE VIEW TO hr;

SELECT * FROM sys.countries;
update sys.countries set country_name = null where country_id = 'GB';
SELECT name, state, type, total_mb, free_mb FROM v$asm_diskgroup;

--@$ORACLE_HOME/rdbms/admin/awrrpt.sql;

SELECT name, value FROM v$pgastat;

-- information about redo log groups from Oracle's in-memory structures

SELECT group#, status, members FROM v$log;
SELECT * FROM v$log; 

SELECT * FROM dba_indexes;

SELECT 
    object_name,
    index_name,
    blevel, 
    leaf_rows, 
    leaf_blks
FROM 
    dba_indexes;

-- version check
SELECT * FROM v$version;
SELECT version FROM v$instance;

-- retrieves runtime performance and execution details for SQL statements currently in the library cache in Oracle. It's part of Oracle's dynamic performance views (V$ views) and can be very useful for performance tuning and SQL monitoring
select * from v$sql;

--null (Oracle treats '' (empty string) as NULL — unlike most other RDBMSs!)
select 1 from dual where null is null; -- 1
select 1 from dual where null = ''; -- empty
select 1 from dual where null = null; -- empty
select 1 from dual where '' is null; -- 1
SELECT CASE WHEN '' IS NULL THEN 'Yes' ELSE 'No' END FROM dual; -- Output: Yes


--data dictionary
SELECT * FROM all_tables WHERE owner = 'SYS';

-- users info (authentication method, etc.) 
select * from dba_users;
-- users with password hashes:
SELECT * FROM dba_users_with_defpwd;
-- current user;
select user from dual;
SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') FROM dual;
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') FROM dual;

-- all session details:
SELECT 
  username, 
  osuser, 
  sid, 
  serial#, 
  status, 
  machine, 
  program
FROM v$session
WHERE audsid = USERENV('SESSIONID');

-- server version:
SELECT * FROM v$version;

-- NVL
SELECT NVL(NULL, 5) FROM DUAL;


-- FLASHBACK
SHOW PARAMETER undo_retention;
SELECT table_name, flashback_archive_name 
FROM user_flashback_archive_tables;


SELECT * 
FROM countries
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '15' MINUTE);


update countries set country_name = 'AR-na' where region_id = 20 and country_id= 'AR';
select * from countries where region_id = 20 and country_id= 'AR';
rollback;
commit;




