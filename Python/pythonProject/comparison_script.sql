with objects_cte as (
	--tables
	select table_type || '_' || table_schema || '.' || table_name "object_info"
	from information_schema.tables
	union all
	--procedures and functions
	select routine_type || '_' || routine_schema || '.' || routine_name
	from information_schema.routines where routine_schema = 'public'
	union all
	--table triggers
	select 'TABLE_TRIGGER_' || tgname from pg_catalog.pg_trigger
	union all
	--database triggers
	select 'DB_TRIGGER_' || evtname from pg_catalog.pg_event_trigger
	union all
	--types
	select
	'TYPECATEGORY_' || typname || '.' ||
		CASE
		    WHEN typcategory = 'E' THEN 'Enum'
		    WHEN typcategory = 'X' THEN 'Unknown'
		    WHEN typcategory = 'G' THEN 'Geometric'
		    WHEN typcategory = 'D' THEN 'Date/Time'
		    WHEN typcategory = 'R' THEN 'Range'
		    WHEN typcategory = 'B' THEN 'Boolean'
		    WHEN typcategory = 'P' THEN 'Pseudo'
		    WHEN typcategory = 'C' THEN 'Composite'
		    WHEN typcategory = 'S' THEN 'String'
		    WHEN typcategory = 'Z' THEN 'Bit'
		    WHEN typcategory = 'A' THEN 'Array'
		    WHEN typcategory = 'V' THEN 'Numeric'
		    WHEN typcategory = 'T' THEN 'Timespan'
		    WHEN typcategory = 'U' THEN 'User-Defined'
		    WHEN typcategory = 'I' THEN 'Network Address'
		    WHEN typcategory = 'N' THEN 'Bit N'
		ELSE 'Unknown Category'
	  END "type_info"
	 from pg_type
	union all
	select 'INDEX_' || schemaname || '.' || tablename || '.' || indexname 
	from pg_catalog.pg_indexes
	union all
	select 'SEQUENCE_' || schemaname || '.' || sequencename || '.' 
	from pg_catalog.pg_sequences
	union all
	select 'TABLE_SPACE_' || spcname from pg_tablespace
	union all	
	select 'ROLE_' || rolname from pg_catalog.pg_roles
	union all		
	select
		--conrelid = constrained relation (e.g., a table), 
		--regclass = built-in data type that represents the name of a table, view, index, sequence, or other object
		--'CONSTRAINT_objectname_columnname_constraintname_constraintdefinition'
		'CONSTRAINT_' || c.conrelid::regclass || '.' || a.attname || '.' || c.conname || '.' || pg_get_constraintdef(c.oid) as "constraint_info"
	from
		pg_constraint c
	join pg_attribute a on
		a.attnum = any(c.conkey)
	union all		
	select
		'COLUMN_TYPE_' || table_schema || '.' || table_name || '.' || column_name || '.' || data_type || '.NULLable:' || is_nullable
	from
		information_schema."columns"
	union all		
	select schema_name from information_schema.schemata
)
select * from objects_cte where object_info is not null order by 1; 



select * from actor where actor_id = 1;
--ALTER USER postgres WITH PASSWORD 'p0$tgre$';
--create database dvdrental_2;
--pg_dump -h your_host -p your_port -U your_user -d source_database -F c -f source_database.dump
--pg_restore -h your_host -p your_port -U your_user -d your_target_database your_database.dump

--Now let's delete the actor table.
drop table actor cascade;
drop table film_actor;

select * from actor;
select * from film_actor;

--select all tables
--SELECT *

SELECT table_name, table_type 
FROM information_schema.tables
WHERE table_schema = 'public'; AND table_type = 'BASE TABLE';




select 'TABLE_TRIGGER_' || tgname, * from pg_catalog.pg_trigger where "oid" = 16841;
select * from information_schema.tables where;
select 'INDEX_' || schemaname || '.' || tablename || '.' || indexname , * from pg_catalog.pg_indexes;
select 'SEQUENCE_' || schemaname || '.' || sequencename || '.' from pg_catalog.pg_sequences;
select 'TABLE_SPACE_' || spcname from pg_tablespace;

select 'CONSTRAINT' || conname  * from pg_catalog.pg_constraint 



select conrelid, conrelid::regclass, * from pg_catalog.pg_constraint

select * from city c order by 1;
update city set city = null where city_id = 2;
alter table city alter column country_id drop not null;

SELECT
  conname AS constraint_name,
  conrelid::regclass AS table_name,
  a.attname AS column_name
FROM
  pg_constraint c
  JOIN pg_attribute a ON a.attnum = ANY(c.conkey)
WHERE
  contype = 'n';  -- 'n' represents not-null constraints

CREATE DATABASE dvdrental_3;
drop DATABASE dvdrental3;



select 'TABLE_TRIGGER_' || tgname from pg_catalog.pg_trigger;
select 'TABLE_TRIGGER_' || tgname, * from pg_catalog.pg_trigger order by oid ;
select * from pg_catalog.pg_trigger;


--tables
select coalesce(table_type || '_' || table_schema || '.' || table_name, 'n/a') "object_info"
from information_schema.tables
order by 1;

select count(table_name) from information_schema.tables;

--copy a table
create table "language_2" as 
select * from "language" l ;

select * from language_2 l ;

CREATE ROLE alice 
LOGIN 
PASSWORD 'securePass1';

create role john superuser login password 'p@ss';





