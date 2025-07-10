----------------------------------------------------------------------------------------------------
/* information_schema */
----------------------------------------------------------------------------------------------------

select * from information_schema.SCHEMATA s ; -- information about all schemas within the current database.

SELECT PL.*
FROM information_schema.`PROCESSLIST` PL 
WHERE PL.HOST LIKE '10.187.%'


----------------------------------------------------------------------------------------------------
/* events */
----------------------------------------------------------------------------------------------------

SHOW EVENTS;
SELECT * FROM mysql.event;
SHOW VARIABLES LIKE '%event%';

----------------------------------------------------------------------------------------------------
/* password */
----------------------------------------------------------------------------------------------------

SELECT * FROM mysql.user;
describe mysql.user;
SELECT user, host, plugin FROM mysql.user where user = 'kirill';

START TRANSACTION;

SELECT user, host, plugin, authentication_string, password_last_changed FROM mysql.user;
-- ALTER USER 'test_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'newpass777';
ALTER USER 'test_user3'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'newpass888';
GRANT ALL PRIVILEGES ON classicmodels.* TO 'test_user3'@'localhost';
show grants for test_user3@localhost;
FLUSH PRIVILEGES;


COMMIT;
-- ROLLBACK;

-- SELECT user, host, plugin FROM mysql.user WHERE user = 'root';
create user 'test_user3'@'localhost' identified with mysql_native_password by 'pass333';
-- create user 'test_user'@'localhost' identified by 'pass222';

-- GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
-- FLUSH PRIVILEGES;


grant all privileges on classicmodels.* to 'test_user'@'localhost';
GRANT ALL PRIVILEGES ON classicmodels.* TO 'test_user2'@'localhost';

flush privileges;
select current_user(); -- root@localhost
show grants for root@localhost;
-- GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `root`@`localhost` WITH GRANT OPTION
show grants for test_user@localhost;


ALTER USER 'kirill' IDENTIFIED BY 'new_password...';
-- ALTER USER 'kirill' IDENTIFIED BY '5ph:eP41]2D'; -- Noga
ALTER USER 'kirill' IDENTIFIED BY 'as*^&*(43:LJK'; -- me

----------------------------------------------------------------------------------------------------
/* check restored snapshot */
----------------------------------------------------------------------------------------------------

-- monitor key metrics.
show global status;
-- Check Replication Status (if applicable)
SHOW SLAVE STATUS;

-- Check Database and Table Information
SHOW DATABASES;
SHOW TABLE STATUS;

-- Check Table Structure and Data
SHOW TABLES;
CHECK TABLE customers;
SHOW CREATE TABLE customers;
SELECT * FROM information_schema.TABLES;
SELECT * FROM information_schema.COLUMNS;
SELECT * FROM information_schema.TABLE_CONSTRAINTS;

-- Check Performance and Logs
SHOW VARIABLES LIKE '%slow_query_log%';
SHOW VARIABLES LIKE '%error_log%';
SHOW VARIABLES LIKE '%general_log%';
SHOW MASTER STATUS;
SHOW INDEX FROM customers;
SHOW GRANTS FOR kirill;
SELECT * FROM mysql.user;
SHOW ENGINE INNODB STATUS;
SELECT @@optimizer_switch;
show full processlist;
select * from INFORMATION_SCHEMA.PROCESSLIST;
SHOW BINARY LOG STATUS;

-- Check Table Size and Row Count
SELECT 
    table_name AS `Table`, 
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Size (MB)`,
    TABLE_ROWS
FROM 
    information_schema.tables
WHERE 
    table_schema = 'nb'
    AND (table_name IN ('NODE', 'ACTIVITY', 'ACTIVITY_OUTCOME', 'ACTIVITY_OUTCOME_DETAIL')
        OR table_name IN ('SNAPSHOT'))
GROUP BY table_name
ORDER BY (data_length + index_length) DESC;

-- Check Stored Procedures
SELECT 
    routine_name, 
    routine_type, 
    created, 
    last_altered 
FROM 
    information_schema.routines 
WHERE 
    routine_type = 'PROCEDURE';

-- Check Table Structure and Description
SHOW CREATE TABLE world.city;
DESCRIBE world.city;
DESCRIBE TABLE world.city;

-- Check InnoDB Status
SELECT * FROM information_schema.innodb_trx;
SELECT * FROM INFORMATION_SCHEMA.INNODB_TABLESPACES;

-- Check MySQL Version
SELECT VERSION(), @@version;
SHOW VARIABLES LIKE '%version%';

-- Additional Checks (from the original code)
SELECT * from mysql.general_log;
show grants;

----------------------------------------------------------------------------------------------------
/* Transactions */
----------------------------------------------------------------------------------------------------

select * from information_schema.innodb_trx;
-- locks.
select * from performance_schema.data_locks;


----------------------------------------------------------------------------------------------------
/* REGEX */
----------------------------------------------------------------------------------------------------
-- [i] https://www.geeksforgeeks.org/mysql-regular-expressions-regexp/

select * from mysql.user WHERE lower(`User`) like '%nischal%' or lower(`User`) like '%sharma%';
select * from mysql.user WHERE `User` REGEXP 'nischal|sharma|kirill';
select * from mysql.user WHERE `User` RLIKE 'nischal|sharma|kirill';

----------------------------------------------------------------------------------------------------
/* server */
----------------------------------------------------------------------------------------------------

SHOW ENGINE INNODB STATUS;
show engines;
create table test_me (id int) engine=memory;
select * from test_me;
show create table test_me;
show create table ACTIVITY;

/*
=====================================
2024-11-15 13:21:32 0x6d78 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 1 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 20 srv_active, 0 srv_shutdown, 90528 srv_idle
srv_master_thread log flush and writes: 0
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 51
OS WAIT ARRAY INFO: signal count 54
RW-shared spins 0, rounds 0, OS waits 0
RW-excl spins 0, rounds 0, OS waits 0
RW-sx spins 0, rounds 0, OS waits 0
Spin rounds per wait: 0.00 RW-shared, 0.00 RW-excl, 0.00 RW-sx
------------
TRANSACTIONS
------------
Trx id counter 4094
Purge done for trx's n:o < 4094 undo n:o < 0 state: running but idle
History list length 0
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 283191197700032, not started
0 lock struct(s), heap size 1128, 0 row lock(s)
---TRANSACTION 283191197699256, not started
0 lock struct(s), heap size 1128, 0 row lock(s)
---TRANSACTION 283191197698480, not started
0 lock struct(s), heap size 1128, 0 row lock(s)
--------
FILE I/O
--------
I/O thread 0 state: wait Windows aio ((null))
I/O thread 1 state: wait Windows aio (insert buffer thread)
I/O thread 2 state: wait Windows aio (read thread)
I/O thread 3 state: wait Windows aio (read thread)
I/O thread 4 state: wait Windows aio (read thread)
I/O thread 5 state: wait Windows aio (read thread)
I/O thread 6 state: wait Windows aio (write thread)
I/O thread 7 state: wait Windows aio (write thread)
I/O thread 8 state: wait Windows aio (write thread)
Pending normal aio reads: [0, 0, 0, 0] , aio writes: [0, 0, 0, 0] ,
 ibuf aio reads:
Pending flushes (fsync) log: 0; buffer pool: 0
1760 OS file reads, 4989 OS file writes, 2599 OS fsyncs
0.00 reads/s, 0 avg bytes/read, 0.00 writes/s, 0.00 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 0, seg size 2, 0 merges
merged operations:
 insert 0, delete mark 0, delete 0
discarded operations:
 insert 0, delete mark 0, delete 0
Hash table size 34679, node heap has 6 buffer(s)
Hash table size 34679, node heap has 2 buffer(s)
Hash table size 34679, node heap has 2 buffer(s)
Hash table size 34679, node heap has 2 buffer(s)
Hash table size 34679, node heap has 4 buffer(s)
Hash table size 34679, node heap has 3 buffer(s)
Hash table size 34679, node heap has 2 buffer(s)
Hash table size 34679, node heap has 9 buffer(s)
0.00 hash searches/s, 0.00 non-hash searches/s
---
LOG
---
Log sequence number          46603599
Log buffer assigned up to    46603599
Log buffer completed up to   46603599
Log written up to            46603599
Log flushed up to            46603599
Added dirty pages up to      46603599
Pages flushed up to          46603599
Last checkpoint at           46603599
Log minimum file id is       10
Log maximum file id is       14
2448 log i/o's done, 0.00 log i/o's/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total large memory allocated 0
Dictionary memory allocated 931147
Buffer pool size   8191
Free buffers       6358
Database pages     1803
Old database pages 645
Modified db pages  0
Pending reads      0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 1161, not young 2219
0.00 youngs/s, 0.00 non-youngs/s
Pages read 1108, created 702, written 1616
0.00 reads/s, 0.00 creates/s, 0.00 writes/s
No buffer pool page gets since the last printout
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 1803, unzip_LRU len: 0
I/O sum[0]:cur[0], unzip sum[0]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
0 read views open inside InnoDB
Process ID=27484, Main thread ID=17840 , state=sleeping
Number of rows inserted 52618, updated 0, deleted 0, read 248
0.00 inserts/s, 0.00 updates/s, 0.00 deletes/s, 0.00 reads/s
Number of system rows inserted 848, updated 2766, deleted 783, read 19225
0.00 inserts/s, 0.00 updates/s, 0.00 deletes/s, 0.00 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================
*/
SELECT * FROM INFORMATION_SCHEMA.INNODB_TABLESPACES; -- SQL Error [1227] [42000]: Access denied; you need (at least one of) the PROCESS privilege(s) for this operation

select
	*
from
	INFORMATION_SCHEMA.INNODB_TABLESPACES
-- where NAME regexp 'worlD'; 
-- where NAME like 'worlD%'; 

SELECT
	VERSION(),
	@@version; -- MySql server 8.0.35; 8.3.0 local: classicmodels.

show variables like '%version%';
SHOW VARIABLES;
SHOW GLOBAL VARIABLES;
SHOW SESSION VARIABLES;
show variables like 'innodb_buffer_pool_size'; -- 24,696,061,952 (CLONE) -> 24 GB / 32 GB of RAM = 75%
show variables like 'innodb_log_buffer_size'; -- 16,777,216 -> 16 MB (CLONE)
show variables like 'innodb_buffer_pool_size'; -- 134,217,728 (classimodels) ~128 MB


----------------------------------------------------------------------------------------------------
/* Structure */
----------------------------------------------------------------------------------------------------

-- db schema:
SELECT @@hostname, CONNECTION_ID(), database(); -- nb


-- CLONE
SHOW DATABASES;
-- Summary:
-- 31 DBs
-- Main DB: nb
/*PROD
analytics
archive
auto_submit
clhm
course_data_2019
course_data_2022_18587_922690
cxp
deprovision
googledoc
information_schema
innodb
lpg
maintenance
messagecenter
mtprod
mysql
nb
offline
onedrive
percona
performance_schema
sam_templates
soa
sys
test
test_data
test_data_2022
test_data_2023_07
tmp
weblink*/

SELECT table_name FROM information_schema.tables WHERE table_schema = 'nb';

-- 136 tables.
/*AA_SHARED_SECRET
ACTIVITY
ACTIVITY_COMMENT
ACTIVITY_OUTCOME
ACTIVITY_OUTCOME_DETAIL
ACTIVITY_OUTCOME_SUMMARY
ANALYTICS_COURSE_SYNC_SNAPSHOT_VIEW
ANALYTICS_DURATION
ANNOTATION_INFO
ANNOTATION_INFO_ANNOTATION_TYPES
API_ACCESS
APP
APP_ACTION
APP_ACTION_CAPABILITIES
APP_ACTION_CATEGORIES
APP_ACTION_ROLES
APP_ACTIVITY
APP_CATEGORY
APP_CATEGORY_ROLES
APP_FEATURE
APP_GATING
APP_INTERACTIONS
APP_LIFE_CYCLE_EVENT
APP_LIFE_CYCLE_EVENTS
APP_LTI_ROLE_MAPPING
APP_OAUTH
APP_PROVISION
APP_PROVISION_BACKUP
APP_PROVISION_TEMP
APP_SCORE
ASSIGNABLE_ACTIVITY
ASSIGNABLE_ACTIVITY_TAKE
ATTEMPT_STATUS
BLOG_INFO
BLOG_SOURCE
CAPABILITY
COMPONENT_STATUS
COURSE
COURSE_INFO_VIEW
COURSE_TYPE
CXP_ACTIVITY
EVERNOTE_NB_USER
EVERNOTE_NOTEBOOK
FLASH_CARD
FLASH_CARD_USER_PREF
GRADEBOOK
GRADEBOOK_ACTION
GRADEBOOK_ACTION_ROLES
GRADEBOOK_CALCULATION_QUEUE
GRADEBOOK_CATEGORY
GRADEBOOK_CATEGORY_OUTCOME
GRADEBOOK_ITEM
GRADEBOOK_QRTZ_BLOB_TRIGGERS
GRADEBOOK_QRTZ_CALENDARS
GRADEBOOK_QRTZ_CRON_TRIGGERS
GRADEBOOK_QRTZ_FIRED_TRIGGERS
GRADEBOOK_QRTZ_JOB_DETAILS
GRADEBOOK_QRTZ_LOCKS
GRADEBOOK_QRTZ_PAUSED_TRIGGER_GRPS
GRADEBOOK_QRTZ_SCHEDULER_STATE
GRADEBOOK_QRTZ_SIMPLE_TRIGGERS
GRADEBOOK_QRTZ_SIMPROP_TRIGGERS
GRADEBOOK_QRTZ_TRIGGERS
GRADE_SYNC_STATUS
ILOVEAPPS_QRTZ_BLOB_TRIGGERS
ILOVEAPPS_QRTZ_CALENDARS
ILOVEAPPS_QRTZ_CRON_TRIGGERS
ILOVEAPPS_QRTZ_FIRED_TRIGGERS
ILOVEAPPS_QRTZ_JOB_DETAILS
ILOVEAPPS_QRTZ_LOCKS
ILOVEAPPS_QRTZ_PAUSED_TRIGGER_GRPS
ILOVEAPPS_QRTZ_SCHEDULER_STATE
ILOVEAPPS_QRTZ_SIMPLE_TRIGGERS
ILOVEAPPS_QRTZ_SIMPROP_TRIGGERS
ILOVEAPPS_QRTZ_TRIGGERS
IN_PROGRESS_ATTEMPT
JOB_LAST_COMPLETED
KEY_PAIR
LEARNING_GROUP
LEARNING_PATH
LEARNING_UNIT
LTI_LAUNCH_PARAMETER
NBCORE_JOBS_QRTZ_BLOB_TRIGGERS
NBCORE_JOBS_QRTZ_CALENDARS
NBCORE_JOBS_QRTZ_CRON_TRIGGERS
NBCORE_JOBS_QRTZ_FIRED_TRIGGERS
NBCORE_JOBS_QRTZ_JOB_DETAILS
NBCORE_JOBS_QRTZ_LOCKS
NBCORE_JOBS_QRTZ_PAUSED_TRIGGER_GRPS
NBCORE_JOBS_QRTZ_SCHEDULER_STATE
NBCORE_JOBS_QRTZ_SIMPLE_TRIGGERS
NBCORE_JOBS_QRTZ_SIMPROP_TRIGGERS
NBCORE_JOBS_QRTZ_TRIGGERS
NBCORE_QRTZ_BLOB_TRIGGERS
NBCORE_QRTZ_CALENDARS
NBCORE_QRTZ_CRON_TRIGGERS
NBCORE_QRTZ_FIRED_TRIGGERS
NBCORE_QRTZ_JOB_DETAILS
NBCORE_QRTZ_LOCKS
NBCORE_QRTZ_PAUSED_TRIGGER_GRPS
NBCORE_QRTZ_SCHEDULER_STATE
NBCORE_QRTZ_SIMPLE_TRIGGERS
NBCORE_QRTZ_SIMPROP_TRIGGERS
NBCORE_QRTZ_TRIGGERS
NELSON_ISBN
NEXTBOOK
NODE
NODE_PASSWORD
ORG
ORG_SETTINGS
PERMISSION
PROGRESS_APP_ACTIVITY_VIEW
READ_SPEAKER_USER_PREF
ROLE
ROLE_CAPABILITY
ROLE_PERMISSION
RSSFEED_ACTIVITY
RSSFEED_FEED
SNAPSHOT
SNAPSHOT_APP_DATA
SNAPSHOT_COMPONENT_STATUS
SNAPSHOT_DISCIPLINE
SNAPSHOT_USER_VIEW
SSOGuids_Tracker
STUDENT_OUTCOME_SUMMARY
STUDENT_SUMMARY_VIEW
USER
USER_APP_CATEGORY_PREFERENCE
USER_CAPABILITY
USER_CREDENTIALS
USER_NODE
USER_ORG_PROFILE
WEBVIDEO_ACTIVITY
ZERO_GRADE_STATUS
dbmaintain_scripts
tmp_all_masters*/

-----------------------------------------------------------------------------------------------------------------------------------
/* connection info */
-----------------------------------------------------------------------------------------------------------------------------------

SELECT 
    CONNECTION_ID() AS connection_id,
    USER() AS user,
    DATABASE() AS current_database,
    @@hostname AS host,
    @@port AS port,
    @@version AS version,
    @@socket AS socket,
    @@max_connections AS max_connections,
    @@autocommit AS autocommit,
    @@character_set_server AS character_set_server,
    @@collation_server AS collation_server,
    @@time_zone AS time_zone,
    @@sql_mode AS sql_mode,
    @@wait_timeout AS wait_timeout,
    @@interactive_timeout AS interactive_timeout;

SHOW full PROCESSLIST;
SELECT * FROM information_schema.PROCESSLIST order by 1 desc;
SELECT * FROM performance_schema.processlist;
-- kill 1718;
SHOW ENGINE INNODB STATUS;



    
-----------------------------------------------------------------------------------------------------------------------------------
/* tables sizes */
-----------------------------------------------------------------------------------------------------------------------------------

-- Check DB Size (archival process)
SELECT 
    it.table_schema,
    floor(
    	SUM(((data_length + index_length) / 1024 / 1024 / 1024))
    	) 
    AS `Size (GB)`
FROM 
    information_schema.tables it
WHERE 
--     table_schema like 'course_data_2022%'
    table_schema like 'nb'
group by table_schema
order by cast(substring_index(table_schema, '_batch_', -1) as UNSIGNED);


-- Summary:
-- PROD RDS instance size: ~ 3 TB
-- data regarding archival process: ~ 150 GB

select
	sum(ROUND(((data_length + index_length) / 1024 / 1024) / 1024, 2)) AS `Size (GB)`
from
	information_schema.TABLES; -- 3 TB
WHERE TABLE_SCHEMA like 'course_data%'; -- 148 GB

-- Total Instance Size (GB)
SELECT 
    ROUND(
        (
            -- Tables size (data + indexes)
            (SELECT COALESCE(SUM(DATA_LENGTH + INDEX_LENGTH), 0)
             FROM information_schema.TABLES)
            
            -- Stored procedures and functions
            + (SELECT COALESCE(SUM(LENGTH(ROUTINE_DEFINITION)), 0)
               FROM information_schema.ROUTINES)
            
            -- Triggers
            + (SELECT COALESCE(SUM(LENGTH(ACTION_STATEMENT)), 0)
               FROM information_schema.TRIGGERS)
            
            -- Events
            + (SELECT COALESCE(SUM(LENGTH(EVENT_DEFINITION)), 0)
               FROM information_schema.EVENTS)
        ) / 1024 / 1024 / 1024
    , 2) as 'Total Instance Size (GB)'


/*
'archive' database size:
-- PROD 253 GB (RFC required)
-- CLONE 253 GB
-- PERF 250 GB
-- INT 0.8 GB
-- QA 0.7 GB
-- STAGE 0.5 GB

RDS instance size	
BEFORE	AFTER
-- PROD	    3143.4	-> 2878.09 (2879.06 Jan 29)
-- CLONE	3323.26	-> 3069.96
-- PERF	    2625.28 -> 2371.97
-- STAGE	60.37	-> 59.88
-- QA	    37.16	-> 36.47
-- INT	    17.64	-> 16.83
*/
    
select
	TABLE_SCHEMA,
	sum(ROUND(((data_length + index_length) / 1024 / 1024) / 1024, 2)) AS `Size (GB)`
from
	information_schema.TABLES
-- WHERE TABLE_SCHEMA like 'course_data%' -- 148 GB
-- and TABLE_NAME like 'tmp%' and TABLE_NAME not like 'local'
group by
	TABLE_SCHEMA
order by
	2 desc;

select * from information_schema.tables WHERE table_name = 'ACTIVITY_OUTCOME_DETAIL';

SELECT
	table_name AS `Table`,
	ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Size (MB)`,
	TABLE_ROWS
FROM
	information_schema.tables
WHERE
	table_schema = 'nb'
	and 
    (table_name in ('NODE', 'ACTIVITY', 'ACTIVITY_OUTCOME', 'ACTIVITY_OUTCOME_DETAIL')
		OR table_name in ('SNAPSHOT')
		)
GROUP BY table_name
	ORDER BY
		(data_length + index_length) DESC;

-- from Noga
SELECT
	TABLE_NAME,
	SUM(ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024 ), 2)) AS "SIZE IN MB",
	SUM(ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 ), 2)) AS "SIZE IN KB"
FROM
	information_schema.TABLES
WHERE
	TABLE_SCHEMA = 'nb'
	AND TABLE_NAME IN ('NODE', 'ACTIVITY', 'ACTIVITY_OUTCOME', 'ACTIVITY_OUTCOME_DETAIL')
	-- 2,093,430.30
GROUP BY
	TABLE_NAME
order by
	2 desc;
select
	11093424.00 / 1024;

select
-- 	sum(ROUND(((data_length + index_length) / 1024 / 1024) / 1024, 2)) AS `Size (GB)`
	*
from
	information_schema.TABLES
where table_schema = 'classicmodels';

-- Total Instance Size (GB)
SELECT 
    ROUND(
        (
            -- Tables size (data + indexes)
            (SELECT COALESCE(SUM(DATA_LENGTH + INDEX_LENGTH), 0)
             FROM information_schema.TABLES where table_schema = 'classicmodels')
            
            -- Stored procedures and functions
            + (SELECT COALESCE(SUM(LENGTH(ROUTINE_DEFINITION)), 0)
               FROM information_schema.ROUTINES where routine_schema = 'classicmodels')
            
            -- Triggers
            + (SELECT COALESCE(SUM(LENGTH(ACTION_STATEMENT)), 0)
               FROM information_schema.TRIGGERS where trigger_schema = 'classicmodels')
            
            -- Events
            + (SELECT COALESCE(SUM(LENGTH(EVENT_DEFINITION)), 0)
               FROM information_schema.EVENTS where EVENT_SCHEMA = 'classicmodels')
        ) / 1024 / 1024 
    , 2) as 'Total Instance Size (MB)'

    SELECT * FROM information_schema.TABLES where table_schema = 'classicmodels';
	
----------------------------------------------------------------------------------------------------
/* data vs index size */
----------------------------------------------------------------------------------------------------

SELECT
	table_schema AS "Database",
	TABLE_NAME AS "Table",
	ROUND(SUM(data_length) / 1024 / 1024, 2) AS "Size_Data (MB)",
	ROUND(SUM(index_length) / 1024 / 1024, 2) AS "Size_Index (MB)",
	ROUND(SUM(data_length) / 1024 / 1024, 2) - ROUND(SUM(index_length) / 1024 / 1024, 2) AS "Size_Diff" 
FROM
	information_schema.TABLES
WHERE
-- 	TABLE_NAME IN ('ACTIVITY_OUTCOME', 'ACTIVITY_OUTCOME_DETAIL', 'ACTIVITY_OUTCOME_SUMMARY', 'STUDENT_OUTCOME_SUMMARY', 'ACTIVITY_COMMENT', 'USER_NODE', 'USER_ORG_PROFILE')
-- 	TABLE_NAME IN ('ACTIVITY_OUTCOME')
-- 	AND TABLE_SCHEMA = 'nb'
	TABLE_SCHEMA = 'nb'
	and TABLE_TYPE = 'BASE TABLE'
GROUP BY
-- 	table_schema, TABLE_NAME;
	TABLE_NAME
-- order by `Size_Data (MB)` DESC; -- backticks work.
-- order by "Size_Data (MB)" DESC; -- FAILED: no go..
-- order by "Size_Diff" DESC; -- FAILED: no go..
-- order by Size_Diff DESC; -- bare alias w/o wrapping.
-- order by `Size_Diff` DESC; -- backticks work..(for spaces)
order by 3 DESC; -- column number works..



-----------------------------------------------------------------------------------------------------------------------------------
/* information schema */
-----------------------------------------------------------------------------------------------------------------------------------
-- https://dev.mysql.com/doc/refman/8.3/en/information-schema.html

show tables;
show table status;

show databases;

use information_schema;
-- default database called "mysql" which stores system-related tables
select
	*
from
	information_schema.tables;
select
	*
from
	information_schema.tables
WHERE
	TABLE_NAME = 'COLUMNS';

select
	*
from
	information_schema.ENGINES;

select
	*
from
	information_schema.plugins;

select
	*
from
	mysql.user
WHERE `User` like 'rouser%';

select * from mysql.db db WHERE db.`User` = 'kirill'; -- db-level privileges
select * from mysql.`user` u WHERE u.`User` = 'kirill'; -- global user account information / entire mysql server (global privileges, etc.).
-- SUPER: This is the most powerful privilege, granting superuser access to the server. It allows the user to perform administrative tasks such as shutting down the server, managing other users' privileges, and accessing system tables.   
-- PROCESS: Allows the user to view and kill other user's connections.
-- REPLICATION: Grants privileges related to replication setup and management.
-- CREATE USER: Allows the user to create new user accounts.   
-- GRANT OPTION: Allows the user to grant privileges to other users.  

----------------------------------------------------------------------------------------------------
/* Built-in functions */
----------------------------------------------------------------------------------------------------

-- if
select if(a.id > 100, 'hun', 'ten'), a.* from ACTIVITY a limit 10;

-- trim
SELECT TRIM('  Hello, World!  ');
SELECT TRIM('x' FROM 'xxxHello, World!');  -- Removes leading 'x'
SELECT TRIM('x' FROM 'Hello, World!xxx');  -- Removes trailing 'x'


----------------------------------------------------------------------------------------------------
/* RAND */
----------------------------------------------------------------------------------------------------

select CONCAT('GDPR',SUBSTR(RAND() FROM 3 FOR 15),'@forgetme.cengage.com');
select SUBSTR(RAND() FROM 3 FOR 15);
SELECT rand();
select SUBSTR('0.5448935856529452' FROM 3 FOR 15);

----------------------------------------------------------------------------------------------------
/* reserved keywords */
----------------------------------------------------------------------------------------------------

select * from information_schema.keywords WHERE reserved = 1;

----------------------------------------------------------------------------------------------------
/* mysql server log */
----------------------------------------------------------------------------------------------------
set GLOBAL general_log = 'on';
set global log_output = 'table';

SHOW GLOBAL VARIABLES LIKE 'general_log';
SHOW GLOBAL VARIABLES LIKE 'log_output';

select * from customers c ;
select * from mysql.general_log;

set GLOBAL general_log = 'off';

----------------------------------------------------------------------------------------------------
/* execution plans */
----------------------------------------------------------------------------------------------------

select * from mysql.server_cost; -- configurable at any time
select * from mysql.engine_cost; -- configurable at any time

select * from ACTIVITY a ;
explain ACTIVITY ;
describe ACTIVITY ;
show columns from ACTIVITY;

-- SELECT @@optimizer_switch\G; (for command line)
SELECT @@optimizer_switch;
index_merge = on
,
index_merge_union = on
,
index_merge_sort_union = on
,
index_merge_intersection = on
,
engine_condition_pushdown = on
,
index_condition_pushdown = on
,
mrr = on
,
mrr_cost_based = on
,
block_nested_loop = on
,
batched_key_access = off,
materialization = on
,
semijoin = on
,
loosescan = on
,
firstmatch = on
,
duplicateweedout = on
,
subquery_materialization_cost_based = on
,
use_index_extensions = on
,
condition_fanout_filter = on
,
derived_merge = on
,
use_invisible_indexes = off,
skip_scan = on
,
hash_join = on
,
subquery_to_derived = off,
prefer_ordering_index = on
,
hypergraph_optimizer = off,
derived_condition_pushdown = on




----------------------------------------------------------------------------------------------------
/* Process list */
----------------------------------------------------------------------------------------------------

-- select * from performance_schema.processlist;

-- deprecated:
show processlist;
select 177694/3600;
show full processlist;
select * from INFORMATION_SCHEMA.PROCESSLIST;
SHOW BINARY LOG STATUS;
SHOW SLAVE STATUS;
select current_user();
----------------------------------------------------------------------------------------------------
/* variable */
----------------------------------------------------------------------------------------------------	

-- select @var1;
-- set @var1 = 'hello';
set @var1 = (select ID from ACTIVITY limit 1);
select @var1;

select row_count() into @row_count;
insert into audit_rows_count values (@row_count);


SELECT
	routine_name,
	routine_type,
	created,
	last_altered
FROM
	information_schema.routines
WHERE
	routine_type = 'PROCEDURE'
	AND routine_name = 'delete_course_data_2022_local';

-----------------------------------------------------------------------------------------------------------------------------------
/* delimiters online */
-----------------------------------------------------------------------------------------------------------------------------------
-- https://convert.town/column-to-comma-separated-list
-- https://delim.co/#


-----------------------------------------------------------------------------------------------------------------------------------
/* crate sp */
-----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE GetSnapshotDetailsByExternalID (IN external_id VARCHAR(255))
BEGIN
    SELECT
        S.ID,
        S.ISBN,
        O.EXTERNAL_ID,
        O.NAME,
        U.ID AS USER_ID,
        U.FNAME,
        U.LNAME,
        U.EMAIL,
        UOP.ROLE_ID
    FROM
        nb.`SNAPSHOT` S
    JOIN nb.ORG O ON
        S.ORG_ID = O.ID
    JOIN nb.COURSE C ON
        C.ORG_ID = O.ID
    JOIN nb.USER_ORG_PROFILE UOP ON
        UOP.ORG_ID = O.ID
    JOIN nb.USER U ON
        UOP.USER_ID = U.ID
    WHERE
        O.EXTERNAL_ID = external_id;
END;


call analytics.GetSnapshotDetailsByExternalID('GWMT-JRHC-PUZG-UWYM');

SELECT *
FROM information_schema.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE' and ROUTINE_SCHEMA = 'nb';
SHOW PROCEDURE STATUS;
SHOW CREATE PROCEDURE get_course_details_by_external_id;  -- Replace with your procedure name


select * from test.tmp_write_experience_activity_outcome_detail_51770 tweaod ;

-----------------------------------------------------------------------------------------------------------------------------------
/* DRAFT */
-----------------------------------------------------------------------------------------------------------------------------------
-- Scorable means that an activity can receive a score.
-- Gradable means it counts towards grade.
-- So if an activity is Scorable but not gradable it is a practice activity.
-- 
-- IS_SCORABLE=1 and IS_GRADABLE being 1 means "counts towards grade"
-- IS_SCORABLE=1 and IS_GRADABLE being 0 means "PRACTICE"

SELECT
	COUNT(*) AS TOTAL_NUM_COURSES
FROM
	nb.`SNAPSHOT` S
JOIN nb.ORG O ON
	S.ORG_ID = O.ID
JOIN nb.COURSE C ON
	C.ORG_ID = O.ID; -- 3,143,500

	
SELECT
	COUNT(*) AS NUM_OF_COURSES_OLDER_2_YEARS
FROM
	nb.`SNAPSHOT` S
JOIN nb.ORG O ON
	S.ORG_ID = O.ID
JOIN nb.COURSE C ON
	C.ORG_ID = O.ID
WHERE
	DATE(FROM_UNIXTIME(C.END_DATE / 1000)) < DATE_SUB(NOW(), INTERVAL 2 YEAR); -- 1,798,036
	
select
	now(),
	UNIX_TIMESTAMP(), -- the number of seconds elapsed since January 1, 1970, UTC (Coordinated Universal Time)
	FROM_UNIXTIME(UNIX_TIMESTAMP()); 

select DATE_SUB(now(), interval 2 year);

--rounding numbers.
SELECT FLOOR(123.456); -- Output: 123
SELECT FLOOR(-123.456); -- Output: -124
SELECT CEILING(123.456); -- Output: 124
SELECT CEILING(-123.456); -- Output: -123
SELECT FORMAT(12345.6789, 2, 'de_DE') AS formatted_number;
SELECT round(12345.6789, 2) AS formatted_number;


-----------------------------------------------------------------------------------------------------------------------------------
/* checking privileges */
-----------------------------------------------------------------------------------------------------------------------------------
use archive;
show tables;
show grants for 'kirill'@'%';
select * from GRADEBOOK_CATEGORY_OUTCOME_ARCHIVE_2020;

SELECT *
FROM information_schema.USER_PRIVILEGES
WHERE GRANTEE LIKE '%kirill%';

start transaction;
select * from SAM_MT_CUSTOMER_COURSES where sectionID = 193520;
delete from SAM_MT_CUSTOMER_COURSES where sectionID = 193520;
select * from SAM_MT_CUSTOMER_COURSES where sectionID = 193520;

rollback;

-- select * from ANALYTICS_RETRY where id = 178947366;
-- select * from ANALYTICS_RETRY where id = 178947621;
-- UPDATE ANALYTICS_RETRY set ENGAGEMENT_ID = 777 where id = 178947621;
-- select * from ANALYTICS_RETRY where id = 178947621;
-- insert
-- 	into
-- 	ANALYTICS_RETRY (RETRY_TYPE_ID,
-- 	ENGAGEMENT_ID,
-- 	COURSE_KEY,
-- 	SSO_ISBN,
-- 	ACTIVITY_OUTCOME_ID,
-- 	RETRY_ATTEMPT,
-- 	STATUS,
-- 	FAILURE_REASON,
-- 	VERSION,
-- 	CREATED_DATE,
-- 	CREATED_BY,
-- 	LAST_MODIFIED_BY,
-- 	LAST_MODIFIED_DATE,
-- 	STUDENT_OUTCOME_SUMMARY_ID)
-- select
-- 	RETRY_TYPE_ID,
-- 	ENGAGEMENT_ID,
-- 	COURSE_KEY,
-- 	SSO_ISBN,
-- 	ACTIVITY_OUTCOME_ID,
-- 	RETRY_ATTEMPT,
-- 	STATUS,
-- 	FAILURE_REASON,
-- 	VERSION,
-- 	CREATED_DATE,
-- 	CREATED_BY,
-- 	LAST_MODIFIED_BY,
-- 	LAST_MODIFIED_DATE,
-- 	STUDENT_OUTCOME_SUMMARY_ID
-- from
-- 	ANALYTICS_RETRY
-- where
-- 	id = 178947621;
-- select * from ANALYTICS_RETRY WHERE ID = 178947621 order by CREATED_DATE desc;
-- select * from ANALYTICS_RETRY WHERE ACTIVITY_OUTCOME_ID = 952423036;


show tables;
select * from SAM_MT_CUSTOMER_COURSES;
create temporary table kirl_test (id int, comment text);
drop table kirl_test;
select * from kirl_test;

GRANT SHOW DATABASES, SHOW VIEW ON *.* TO `kirill`@`%`; -- ok
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `analytics`.* TO `kirill`@`%` -- ok
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `archive`.* TO `kirill`@`%` -- ok
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `clhm`.* TO `kirill`@`%` -- ok
GRANT SELECT ON `deprovision`.* TO `kirill`@`%` -- ok
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `enhancedinsite`.* TO `kirill`@`%` -- n/a
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `googledoc`.* TO `kirill`@`%` -- ok
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `lpg`.* TO `kirill`@`%` -- ok
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `messagecenter`.* TO `kirill`@`%` -- ok
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `nb`.* TO `kirill`@`%`
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `onedrive`.* TO `kirill`@`%`
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, CREATE TEMPORARY TABLES, EXECUTE ON `test`.* TO `kirill`@`%`
GRANT DROP ON `test`.* TO `kirill`@`%`
GRANT ALTER TABLE ON `test`.* TO `kirill`@`%`
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, CREATE TEMPORARY TABLES, EXECUTE ON `tmp`.* TO `kirill`@`%`
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `weblink`.* TO `kirill`@`%`
GRANT SELECT ON `test_data`.* TO `kirill`@`%`
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `test_data_2019`.* TO `kirill`@`%`
GRANT FILE ON *.* TO `kirill`@`%`;

     
-- show grants for 'kirill'@'%'; gives the same list. Also, I've checked them one by one. Some points to consider:
-- 1) All select statements work fine, for some databases I've also checked dml commands (will rollback), also worked fine;
-- 2) I haven't executed any stored procedures as I can't check their source code and I'm not aware about what exactly they should do (anyways, it's supposed to work..);
-- 3) GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `enhancedinsite`.* TO `kirill`@`%` -- can't be checked as there's no such a db on this rds instance.
-- 4) temporary tables create/drop - ok (for 'test', 'tmp');
-- 5) GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `test_data_2019`.* TO `kirill`@`%` -- can't be checked as there's no such a db on this rds instance.
-- 6) can't check 'GRANT FILE ON *.* TO `kirill`@`%`;' as  it allows to read and write files on the server's file system using the LOAD DATA INFILE and SELECT ... INTO OUTFILE statements.
-- In our case it's an RDS instance, so I might assume we need to export data to an S3 bucket.

select max(LENGTH(REF_ID)) from ACTIVITY a where REF_ID is not null;
select * from ACTIVITY_OUTCOME ao ;
select * from ACTIVITY_OUTCOME_DETAIL aod ;
select * from ACTIVITY_OUTCOME_SUMMARY aos ;


-----------------------------------------------------------------------------------------------------------------------------------
/* MISC */
-----------------------------------------------------------------------------------------------------------------------------------

SHOW VARIABLES LIKE '%ssl%';
SHOW VARIABLES LIKE 'have_ssl';


show schemas;
show databases;


-- Return a substring of a string before a specified number of delimiter occurs:
SELECT SUBSTRING_INDEX("www.w3schools.com", ".", 2);
select SUBSTRING_INDEX('http://alg.cengage.com/ALG.aspx?id=388', '.', 3);

SELECT
    FLOOR(453698 / 86400) AS days,
    FLOOR((453698 % 86400) / 3600) AS hours,
    FLOOR((453698 % 3600) / 60) AS minutes,
    (453698 % 60) AS seconds;
   
SELECT SEC_TO_TIME(453698) AS uptime_in_hms;


-- postgres
select * from course_data_2022_18587_922690.SNAPSHOT_ARCHIVE_AUDIT_NG_85991 saan order by FINISH_TIME desc nulls first;
-- mysql
select * from course_data_2022_18587_922690.SNAPSHOT_ARCHIVE_AUDIT_NG_85991 saan order by FINISH_TIME IS NULL desc;

show create table world.city ;
describe world.city ;
describe table world.city ;
CREATE TABLE `city` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` char(35) NOT NULL DEFAULT '',
  `CountryCode` char(3) NOT NULL DEFAULT '',
  `District` char(20) NOT NULL DEFAULT '',
  `Population` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `CountryCode` (`CountryCode`),
  CONSTRAINT `city_ibfk_1` FOREIGN KEY (`CountryCode`) REFERENCES `country` (`Code`)
) ENGINE=InnoDB AUTO_INCREMENT=4080 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

SHOW VARIABLES LIKE 'tmp_table_dir';
SELECT CURRENT_TIMESTAMP(); 

show variables like 'sql_mode';

SHOW CREATE TABLE course_data_2022_18587_922690.SNAPSHOT_ARCHIVE_AUDIT_NG_85991

-- find field in all tables.
SET SESSION group_concat_max_len = 1000000; -- May need adjustment

SELECT 
    GROUP_CONCAT(
        DISTINCT CONCAT('SELECT "', table_name, '" as table_name FROM ', table_schema, '.', table_name, ' WHERE ', column_name, ' = ''your_search_value'';') 
    ) AS search_queries
FROM 
    information_schema.columns
WHERE 
    column_name like '%grade%'
    
    AND table_schema NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys');

select * FROM 
    information_schema.columns
WHERE 
--     column_name like '%grade%'
--     column_name like '%last%'
    table_schema = 'nb'
--     and column_name like '%score%'
    and column_name like '%ISBN%'
   
select * from information_schema.columns where COLUMN_NAME = 'credit';
select * from information_schema.tables where table_name not like 'tmp%' and table_name like '%master%';
select * from information_schema.tables where table_name not like 'tmp%' and table_name like '%snapshot%';
select * from information_schema.tables where table_name like '%user%';
select * from GRADEBOOK_ITEM gi ;

-----------------------------------------------------------------------------------------------------------------------------------
/* request: find courses with apps: mindapp-ab and CNOW.HW-qanorth_ilrn_com */
-----------------------------------------------------------------------------------------------------------------------------------
select * from NODE n ;
USE nb;
-- explain analyze
select
	distinct
	o.NAME "course_name",
	">>>>>>",
	o.*
from
	ORG o
join SNAPSHOT s on
	s.ORG_ID = o.ID 
join NODE n on n.SNAPSHOT_ID = s.ID
join APP_PROVISION ap on ap.SNAPSHOT_ID = s.ID
join APP a on a.ID = ap.APP_ID 
-- where a.ID in (102, 232)
where a.ID in
	(select ID from APP a 
		WHERE NAME RLIKE '^mindapp-ab$|CNOW.HW-qanorth_ilrn_com') -- https://dev.mysql.com/doc/refman/8.0/en/regexp.html
;

select ID from APP a WHERE NAME RLIKE '^mindapp-ab$|CNOW.HW-qanorth_ilrn_com';
select * from APP_PROVISION ap ;
select * from APP a WHERE NAME like '%mindapp-ab%';
select * from APP a WHERE NAME RLIKE '^mindapp-ab$|CNOW.HW-qanorth_ilrn_com';
select * from APP a WHERE NAME = 'CNOW.HW-qanorth_ilrn_com';

select * from NODE n WHERE SNAPSHOT_ID = 29;
select * from SNAPSHOT s WHERE ID = 29;



-- Noga's version:
-- this query looks for courses that are provisioned with a set of apps.
SELECT S.ID AS SNAPSHOT_ID,O.EXTERNAL_ID AS COURSE_KEY,APP.NAME AS APP_NAME,
       FROM_UNIXTIME(C.CREATED_DATE/1000) AS COURSE_CREATED_DATE,  
			 FROM_UNIXTIME(C.START_DATE/1000) AS COURSE_START_DATE, 
			 FROM_UNIXTIME(C.END_DATE/1000) AS COURSE_END_DATE
FROM nb.`SNAPSHOT` S 
JOIN nb.APP_PROVISION APRN ON APRN.SNAPSHOT_ID = S.ID 
JOIN nb.ORG O ON S.ORG_ID = O.ID
JOIN nb.COURSE C ON C.ORG_ID = O.ID
JOIN nb.APP APP ON APRN.APP_ID = APP.ID
WHERE APRN.APP_ID IN (25,893)
AND C.END_DATE > UNIX_TIMESTAMP()*1000
LIMIT 1000; 

select * from APP a WHERE id IN (25,893);
-- select * from APP a WHERE id IN (102, 232);
select * from APP_PROVISION ap where APP_ID in (25, 893);
select FROM_UNIXTIME(UNIX_TIMESTAMP());

-- to find courses that are provisioned with specific apps you don't need the NODE table.
-- To find courses that contain apps in their LPN then you do need the NODE table as well as the APP_ACTIVITY table.
-- The query to look for courses that contain the apps in their LPN is as follows:
SELECT S.ID AS SNAPSHOT_ID,O.EXTERNAL_ID AS COURSE_KEY,ACTY.NAME AS APP_ACTIVITY_NAME,
       FROM_UNIXTIME(C.CREATED_DATE/1000) AS COURSE_CREATED_DATE,  
			 FROM_UNIXTIME(C.START_DATE/1000) AS COURSE_START_DATE, 
			 FROM_UNIXTIME(C.END_DATE/1000) AS COURSE_END_DATE
FROM nb.`SNAPSHOT` S 
JOIN nb.ORG O ON S.ORG_ID = O.ID
JOIN nb.COURSE C ON C.ORG_ID = O.ID
JOIN nb.NODE N ON N.SNAPSHOT_ID = S.ID 
JOIN nb.ACTIVITY A ON A.ID = N.ID 
JOIN nb.APP_ACTIVITY ACTY ON A.APP_ACTIVITY_ID = ACTY.ID 
WHERE ACTY.ID IN (31,32,893)
AND C.END_DATE > UNIX_TIMESTAMP()*1000
LIMIT 1000;

-- For apps and app-activity references:
SELECT APP.ID AS APP_ID,APP.NAME AS APP_NAME,APP.DISPLAY_NAME,
       ACTY.ID,ACTY.NAME
FROM nb.APP APP 
JOIN nb.APP_ACTIVITY ACTY ON ACTY.APP_ID = APP.ID
WHERE APP.ID IN (25,893);



-----------------------------------------------------------------------------------------------------------------------------------
/* Common scripts from Noga */
-----------------------------------------------------------------------------------------------------------------------------------

-- Course enrollment information script:
SELECT
	S.ID,
	S.ISBN,
	O.EXTERNAL_ID,
	O.NAME,
	U.ID AS USER_ID,
	U.FNAME,
	U.LNAME,
	U.EMAIL,
	UOP.ROLE_ID
FROM
	nb.`SNAPSHOT` S
JOIN nb.ORG O on
	S.ORG_ID = O.ID
JOIN nb.COURSE C ON
	C.ORG_ID = O.ID
JOIN nb.USER_ORG_PROFILE UOP ON
	UOP.ORG_ID = O.ID
JOIN nb.USER U ON
	UOP.USER_ID = U.ID
WHERE
	O.EXTERNAL_ID = 'GWMT-JRHC-PUZG-UWYM';

-- App - activity information script:
SELECT
	APP.ID AS APP_ID,
	APP.`NAME` AS APP_NAME,
	APP.DISPLAY_NAME,
	ACTY.ID AS APP_ACTIVITY_ID,
	ACTY.`NAME` AS APP_ACTIVITY_NAME
FROM
	nb.APP APP
LEFT JOIN nb.APP_ACTIVITY ACTY ON
	ACTY.APP_ID = APP.ID;

-- Course provisioned with "xyz" apps:
SELECT
	APRN.*
FROM
	nb.APP_PROVISION APRN
JOIN nb.`SNAPSHOT` S ON
	S.ID = APRN.SNAPSHOT_ID
WHERE
	S.ID = 123456
	AND APRN.APP_ID = xyz;





-----------------------------------------------------------------------------------------------------------------------------------
/* active courses */
-----------------------------------------------------------------------------------------------------------------------------------

USE test;

DROP TABLE IF EXISTS tmp_active_course_info;
-- CREATE TABLE tmp_active_course_info AS 
SELECT
	S.ID AS SNAPSHOT_ID,
	S.AUTHOR,
	S.TITLE,
	S.ISBN,
	S.CORE_TEXT_ISBN,
	S.PARENT_ID AS MASTER_ID,
	S.SOURCE_ID AS COPIED_FROM_COURSE,
	S.BRANDING_DISCIPLINE,
	S.INTEGRATION_TYPE,
	O.EXTERNAL_ID AS COURSE_KEY,
	O.`NAME` AS COURSE_NAME,
	DATE(FROM_UNIXTIME(C.CREATED_DATE / 1000)) AS COURSE_CREATED_DATE,
	DATE(FROM_UNIXTIME(C.START_DATE / 1000)) AS COURSE_START_DATE,
	DATE(FROM_UNIXTIME(C.END_DATE / 1000)) AS COURSE_END_DATE,
	U.FNAME,
	U.LNAME,
	U.EMAIL,
	U.SOURCE_ID,
	(
	select
		count(*)
	from
		nb.USER_ORG_PROFILE uop
	where
		uop.ORG_ID = O.ID
		and uop.ROLE_ID = 1004) AS STUDENT_COUNT
FROM
	nb.ORG O
JOIN nb.`SNAPSHOT` S ON
	S.ORG_ID = O.ID
JOIN nb.`USER` U ON
	S.CREATED_BY = U.ID
JOIN nb.COURSE C ON
	C.ORG_ID = O.ID
WHERE
	O.ORG_TYPE = 3
	-- real course (not a demo..)
	AND DATE((FROM_UNIXTIME(C.END_DATE / 1000))) > '2022-12-31'
		AND U.EMAIL NOT LIKE '%cengage.com'
		AND U.EMAIL NOT LIKE '%@cloud.cengage.com'
		AND U.EMAIL NOT LIKE '%CENGAGE.COM'
		AND U.EMAIL NOT LIKE '%Cengage.com'
		AND U.EMAIL NOT LIKE '%qait.com'
		AND U.EMAIL NOT LIKE '%qai.com'
		AND U.EMAIL NOT LIKE '%testaccount.com'
		AND U.EMAIL NOT LIKE '%development%'
		AND U.EMAIL NOT LIKE '%cengage1.com'
		AND U.EMAIL NOT LIKE '%@nelson.com'
		AND U.EMAIL NOT LIKE '%qaitest.com'
		AND U.EMAIL NOT LIKE '%qaittest.com'
		AND U.EMAIL NOT LIKE '%@swlearning.com'
		AND U.EMAIL NOT LIKE '%@lunarlogic.com'
		AND U.EMAIL NOT LIKE '%@mtx.com'
		AND U.EMAIL NOT LIKE '%@mtxqa.com'
		AND U.EMAIL NOT LIKE '%@henley.com'
		AND U.EMAIL NOT LIKE '%@cengagetest.com'
		AND U.EMAIL NOT LIKE '%@concentricsky.com'
		AND U.EMAIL NOT LIKE '%@test.com'
		AND U.EMAIL NOT LIKE '%@ng.com'
		AND U.EMAIL NOT LIKE '%@qa4u.com'
		AND U.EMAIL NOT LIKE '%@aplia.com'
		AND U.EMAIL NOT LIKE '%@qainfotech.net'
		AND U.EMAIL NOT IN ('inst1_gateway_130514@yahoo.com', '01_gtwy_instructor_30042015@gmail.com', 'i1_instructor_16052014@gmail.com', 'i9_instructor_040814@gmail.com', 'i19_instructor_091014@gmail.com')
			AND O.`NAME` NOT LIKE 'demo%'
			AND O.`NAME` NOT LIKE '%Demo%'
			AND O.`NAME` NOT LIKE 'Practice%'
		GROUP BY
			O.ID
			-- HAVING STUDENT_COUNT >= 2
;

ALTER TABLE test.tmp_active_course_info ADD INDEX (SNAPSHOT_ID),
ADD INDEX (MASTER_ID);

explain
SELECT
	COUNT(*)
FROM
	test.tmp_active_course_info;
select
	*
from
	nb.NODE;


-----------------------------------------------------------------------------------------------------------------------------------
/* autocommit mode */
-----------------------------------------------------------------------------------------------------------------------------------
set autocommit = 0;
select * from NODE n ;
select @@autocommit;
set autocommit = 1;
select @@autocommit;
show session variables like '%transaction_isolation%';
show tables;
select * from test_kirl tk ;
lock table test_kirl write;


;
