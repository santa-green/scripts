/* MISC */
-----------------------------------------------------------------------------------------------------------------------------------
-- Sample rows randomly from a table
SELECT * FROM customer TABLESAMPLE SYSTEM (1);
-- List all available extensions
SELECT * FROM pg_available_extensions;





/* DDL triggers */
----------------------------------------------------------------------------------------------------
drop table if exists ddl_history;
CREATE TABLE ddl_history (
  id serial primary key,
  ddl_date timestamptz,
  ddl_tag text,
  object_name text,
  ddl_user text
);


--function to track the creation and alteration of objects:
drop function if exists log_ddl cascade;
create or replace function log_ddl()
  returns event_trigger as $$

declare
  audit_query TEXT;
  r RECORD;

begin
  if tg_tag <> 'DROP TABLE'
  then
    r := pg_event_trigger_ddl_commands();
insert
	into
	ddl_history (
	ddl_date,
	ddl_tag,
	object_name,
	ddl_user)
values (statement_timestamp(), tg_tag, r.object_identity, session_user);
end if;
end;
$$ LANGUAGE plpgsql;

--function to track the dropping of objects:
drop function if exists log_ddl_drop cascade;
create or replace function log_ddl_drop()
  returns event_trigger as $$

declare
  audit_query TEXT;
  r RECORD;

begin
  if tg_tag = 'DROP TABLE'
  then
    for r in
select * from pg_event_trigger_ddl_commands() 

    loop

    insert
	into
	ddl_history (ddl_date,
	ddl_tag,
	object_name)
values (statement_timestamp(),
tg_tag,
r.object_identity);
end loop;
end if;
end;

$$ language plpgsql;

--event triggers
drop event trigger if exists log_ddl_info;
drop event trigger if exists log_ddl_drop_info;
create event trigger log_ddl_info on ddl_command_end execute function log_ddl();
create event trigger log_ddl_drop_info on sql_drop execute function log_ddl_drop();

CREATE TABLE testtable2 (id int, first_name text);
ALTER TABLE testtable2 ADD COLUMN last_name text;

select * from ddl_history;
select current_user;


/* Optimization */
----------------------------------------------------------------------------------------------------
select
	*
from
	pg_stat_activity
where
	state = 'active'
order by
	query_start asc;




/* SYSTEM */
----------------------------------------------------------------------------------------------------
select * from pg_database; --databases
select * from pg_class; --tables, indexes

select txid_current();
select
	pid, --processid
	backend_xid,
	*
from
	pg_stat_activity
where
	backend_xid is not null;

show config_file; --C:/Program Files/PostgreSQL/16/data/postgresql.conf

select version(); --PostgreSQL 16.1, compiled by Visual C++ build 1937, 64-bit
show server_version; --16.1
set lc_messages = 'C'; --session only.

select * from pg_stat_activity; -- Get-Process -name postgres
select name, setting, unit from pg_settings where name like '%buffer%';

select now();
select pg_catalog.now(); -- always first schema to be searched implicitly.
SHOW search_path;

--track_commit_timestamp
show track_commit_timestamp;
create table students (id int, name text);
select pg_xact_commit_timestamp(xmin), oid, relname from pg_class where relname = 'students';
select * from pg_class where relname = 'students';
SHOW config_file;
alter table students add column phone_numbers text;



/* information_schema */
----------------------------------------------------------------------------------------------------
select * from information_schema.SCHEMATA s ; -- information about all schemas within the current database.




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

/* Transactions */
----------------------------------------------------------------------------------------------------

select * from information_schema.innodb_trx;
-- locks.
select * from performance_schema.data_locks;

select txid_current(), txid_current_if_assigned();
SHOW transaction_isolation;
SELECT current_setting('transaction_isolation');
select * from pg_stat_activity where state = 'active';



/* REGEX */
----------------------------------------------------------------------------------------------------
-- [i] https://www.geeksforgeeks.org/mysql-regular-expressions-regexp/

select * from mysql.user WHERE lower(`User`) like '%nischal%' or lower(`User`) like '%sharma%';
select * from mysql.user WHERE `User` REGEXP 'nischal|sharma|kirill';
select * from mysql.user WHERE `User` RLIKE 'nischal|sharma|kirill';

/* server */
----------------------------------------------------------------------------------------------------

SHOW ENGINE INNODB STATUS;
show engines;
create table test_me (id int) engine=memory;
select * from test_me;
show create table test_me;
show create table ACTIVITY;

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



    
/* tables sizes */
-----------------------------------------------------------------------------------------------------------------------------------

-- Quickly list table bloat
CREATE EXTENSION pgstattuple;
SELECT * FROM pgstattuple('customer');


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

/* Built-in functions */
----------------------------------------------------------------------------------------------------

-- if
select if(a.id > 100, 'hun', 'ten'), a.* from ACTIVITY a limit 10;

-- trim
SELECT TRIM('  Hello, World!  ');
SELECT TRIM('x' FROM 'xxxHello, World!');  -- Removes leading 'x'
SELECT TRIM('x' FROM 'Hello, World!xxx');  -- Removes trailing 'x'


/* RAND */
----------------------------------------------------------------------------------------------------

select CONCAT('GDPR',SUBSTR(RAND() FROM 3 FOR 15),'@forgetme.cengage.com');
select SUBSTR(RAND() FROM 3 FOR 15);
SELECT rand();
select SUBSTR('0.5448935856529452' FROM 3 FOR 15);

/* reserved keywords */
----------------------------------------------------------------------------------------------------

select * from information_schema.keywords WHERE reserved = 1;

/* mysql server log */
----------------------------------------------------------------------------------------------------
set GLOBAL general_log = 'on';
set global log_output = 'table';

SHOW GLOBAL VARIABLES LIKE 'general_log';
SHOW GLOBAL VARIABLES LIKE 'log_output';

select * from customers c ;
select * from mysql.general_log;

set GLOBAL general_log = 'off';

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



/* delimiters online */
-----------------------------------------------------------------------------------------------------------------------------------
-- https://convert.town/column-to-comma-separated-list
-- https://delim.co/#




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



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* FILTER instead of Case When */
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select sum(case when id > 0 then id end) from id_test;
select sum(case when id < 0 then id end) from id_test;

select sum(id) filter (where id > 0) from id_test;
select sum(id) filter (where id < 0) from id_test;

select
	date_part('year', log_date) "year",
	count(distinct case when message ~* 'App:iOS.' then user_id end) "Users iOS",
	count(distinct case when message ~* 'App:Android.' then user_id end) "Users Android",
	count(distinct case when message ~* 'App:AndroidLib.' then user_id end) "Users AndroidLib",
	count(distinct case when message ~* 'App:iOS.|App:Android.|App:AndroidLib.' then user_id end) "Total mobile users" 
	count(distinct user_id) filter (where message ~* 'App:iOS.') "Users iOS",
	count(distinct user_id) filter (where message ~* 'App:Android.') "Users Android",
	count(distinct user_id) filter (where message ~* 'App:AndroidLib.') "Users AndroidLib",
	count(distinct user_id) filter (where message ~* 'App:iOS.|App:Android.|App:AndroidLib.') "Total mobile users"
from
	accesslog a …

-----------------------------------------------------------------------------------------------------------------------------------
/* 10th highest salary of employees */
-----------------------------------------------------------------------------------------------------------------------------------
--Postgres specific.
select distinct * from employees e order by salary desc limit 1 offset 9;

--with window functions.
with top_ten_cte as (
	select distinct row_number() over (order by salary desc) "rn", * from employees e order by salary desc limit 10
)
select * from top_ten_cte where rn = 10;

--with sorting.
with top_ten_cte as (
	select distinct * from employees e order by salary desc limit 10
)
select * from top_ten_cte order by salary limit 1;

-----------------------------------------------------------------------------------------------------------------------------------
/* Helper function to generate random names */
-----------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION generate_random_name(min_length INTEGER, max_length INTEGER)
    RETURNS VARCHAR AS
$$
DECLARE
    alphabet VARCHAR := 'abcdefghijklmnopqrstuvwxyz';
    name_length INTEGER := floor(random() * (max_length - min_length + 1) + min_length);
    random_name VARCHAR := '';
    i INTEGER;
BEGIN
    FOR i IN 1..name_length LOOP
        random_name := random_name || substr(alphabet, floor(random() * length(alphabet) + 1)::integer, 1);
    END LOOP;
    RETURN random_name;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------
/* REGEX */
-----------------------------------------------------------------------------------------------------------------------------------
--https://www.postgresql.org/docs/9.0/functions-matching.html
--https://www.postgresql.org/docs/current/functions-matching.html
--https://www.postgresql.org/docs/current/functions-matching.html#FUNCTIONS-POSIX-REGEXP
/*

[] - matching any of the chars.
() - group items into a single logical item e.g.: select * from accesslog where message ~ 'UnitAccessLog(s|d) read'
\ - escape. select * from accesslog where message ~ 'UnitAccessLog\(s\) read'
| - alternation (or..or..)

. - dot matches any single character (analog of _ in like)
* - repetition of the previous item >= 0 times e.g.: select * from accesslog where message ~* 'do*r' --door, dr
.* - analog of % in the LIKE operator.

+ - repetition of the previous item >= 1 times.
	? - ...zero or one time. 
	{m} - ... exactly m times e.g.: select * from accesslog where message ~* 'do{2}r'
	{m,} - ...m or more times.
	{m,n} - ...m <= times <= n.
^ begin anchor, $ - end anchor.
~* - case insensitive.
^\d - starts with a digit.
\d$ - ends with a digit.	
^\D - starts with not a digit.
\D$ - ends with not a digit.
\s - space.
\mSM - matches only at the beginning of a word e.g.: select * from accesslog where message ~* '\mSM'
ound\m - matches only at the end of a word e.g.: select * from accesslog where message ~* 'ound\M'

*/
select * from xaddress where distrct_name ~* '^Red\s.....\sDistrict';
select * from xaddress where distrct_name ~* '^Red\s.*\sDistrict';
select * from xaddress where distrct_name ~* 'red.*district';
select * from xaddress where distrct_name ~* 'district.*red';

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* https://www.postgresqltutorial.com/dollar-quoted-string-constants/ */
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select $$I'm a string constant that contains a backslash \\\''''"'    $$;

-----------------------------------------------------------------------------------------------------------------------------------
/* IN predicate */
-----------------------------------------------------------------------------------------------------------------------------------
select * from address where address = '898 Jining Lane' or address2 = '898 Jining Lane' or district = '898 Jining Lane';
select * from address where '898 Jining Lane' in (address, address2, district);


-----------------------------------------------------------------------------------------------------------------------------------
/* joins */
-----------------------------------------------------------------------------------------------------------------------------------
--cross join (Cartesian product)
select * from address a join city on 1 = 1;
select * from address a join city on true;
select * from address a, city c;
select * from address a cross join city c;

--join using
select * from address join city using(city_id); --USING implies that only one of each pair of equivalent columns will be included in the join output, not both.

--natural join (not recommended due to ambiguity, explicit is better than implicit)
select * from address natural join city; --mentions all columns in the two tables that have matching names.

--lateral join (correlated subquery). Postgres specific.
select * from address a join lateral (
	select c.city, count(*) "city_count" from city c where a.city_id = c.city_id group by c.city
) ac on true;

-----------------------------------------------------------------------------------------------------------------------------------
/* update with join */
-----------------------------------------------------------------------------------------------------------------------------------
--ver 1
start transaction;
	update address
	set postal_code = '1111'
	where city_id = (select city_id from city where city = 'Adana')
	select * from address where postal_code = '1111';
rollback;

--ver 2
start transaction;
	update address a
	set postal_code = '1111'
	from city c
	where a.city_id = c.city_id and c.city = 'Adana'
	returning *; --Postgres specific.
	select * from address where postal_code = '1111';
rollback;


-----------------------------------------------------------------------------------------------------------------------------------
/* Copy a table with select!*/
-----------------------------------------------------------------------------------------------------------------------------------
drop table if exists address_2;

select
	* 
into
	address_2
from
	address a
limit 10; --or choose other conditions if you need. 

select * from address_2 ;
--Drawbacks: fields only are copied (no indexes, constraints...).

start transaction;
	select * from address_2 ;
	truncate table address_2;
rollback;
--commit;
	select * from address_2 ;


-----------------------------------------------------------------------------------------------------------------------------------
/* DISTINCT ON */
-----------------------------------------------------------------------------------------------------------------------------------
--distinct on (district) -> this field will be unique (first in the group)
select distinct district, address from address where district = 'Hubei';
select distinct on (district) district, address from address where district = 'Hubei' order by district, address;





analyze customer; --stats update.
vacuum analyze customer; --removes dead tuples and updates stats (marks pages as all-visible if no recent tuple changes exist).
vacuum full customer; --fully rewrites the entire table and its indexes to reclaim disk space and compact the data.

-- Check table modification stats:
SELECT n_tup_ins, n_tup_upd, n_tup_del
FROM pg_stat_all_tables
WHERE relname = 'customer';

-- Check last 'analyze' time:
SELECT relname, last_analyze, last_autoanalyze	
FROM pg_stat_user_tables	
WHERE relname = 'customer';


-- SQL trick (PostgreSQL): Generate a table of standard origami paper sizes
SELECT unnest(ARRAY['15x15 cm', '20x20 cm', '25x25 cm']) AS origami_paper_size;


--regclass
select * from pg_depend WHERE refobjid = 'product'::regclass;
-- returns: my_table (OID is shown if you SELECT with oid column)
SELECT 'product'::regclass::oid; 
select objid::regclass AS dependent_object
FROM pg_depend
WHERE refobjid = 'product'::regclass;



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