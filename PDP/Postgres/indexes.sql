/* objects creation */
---------------------------------------------------------------------------------------------------- 1
drop table if exists customer;

create table customer (
customer_id int,
first_name varchar(50),
last_name varchar(50),
email varchar(100),
modified_date date,
age int,
active boolean);

select * from customer;
alter table customer add constraint customer_pk primary key (customer_id);
--CREATE UNIQUE INDEX customer_pk ON public.customer USING btree (customer_id);

INSERT INTO customer
SELECT
    gs AS customer_id,
    concat('firstname', gs) AS first_name,
    concat('lastname', gs) AS last_name,
    concat('firstname', 'lastname', gs, '@email.com') AS email,
    modifieddate + INTERVAL '1 day' * (gs % 365) AS modified_date,
    gs % 90 AS age,
    gs % 7 = 0 AS active
FROM
    GENERATE_SERIES(1, 1000000) as gs
CROSS JOIN
    (SELECT * FROM humanresources.employee LIMIT 1) as emp;

-- 2
select * from pg_indexes where schemaname = 'public' and tablename = 'customer';

-- 3 Create a B-tree multi-column index on the customer table on the first_name and last_name columns.
create index idx_mul_full_name on public.customer using btree (first_name, last_name);
--create index idx_mul_full_name on public.customer (first_name, last_name);

/* queries */
----------------------------------------------------------------------------------------------------

explain analyze
select * from customer where age between 18 and 60;

/*
The output should be:
Index Scan using customer_age_idx on customer (...)
Index Cond: ((age >= 18) AND (age <= 60))
*/
--[ ! ] No, it's a mistake. No index created on the 'age' column.

--analyze customer; --stats update.
--vacuum analyze customer; --removes dead tuples and updates stats.
--vacuum full customer; --fully rewrites the entire table and its indexes to reclaim disk space and compact the data.
explain (analyze, buffers)
--select * from customer where first_name like 'firstname1%' and last_name like 'lastname1%'; -- no index is used (gather/parallel seq scan)
select * from customer where first_name like 'firstname1%'; -- no index is used (seq scan): leading wildcard never uses index, but trailing could use..
--Seq Scan on customer  (cost=0.00..26690.00 rows=101010 width=75) (actual time=0.011..184.980 rows=111112 loops=1)

explain analyze
select * from customer where first_name = 'firstname1'; --index scan.
select * from customer where last_name = 'lastname1'; --gather/parallel seq scan.

explain analyze
select
	first_name,
	last_name
from
	customer
where
	first_name = 'firstname1'; --index ONLY scan (w/ or w/o 'last_name').
	
--PostgreSQL does not support explicit index hints (no USE INDEX like MySQL).
	
-- Check table modification stats:
SELECT n_tup_ins, n_tup_upd, n_tup_del
FROM pg_stat_all_tables
WHERE relname = 'customer';

-- Check last 'analyze' time:
SELECT relname, last_analyze, last_autoanalyze	
FROM pg_stat_user_tables	
WHERE relname = 'customer';

create index idx_email on public.customer using btree (email);
explain (analyze, buffers)
select * from customer where email like 'firstnamelastname1%'; -- seq scan (eventually this is up to query optimizer whether to use a certain index or not).


--5 Create a covering index customer_modified_date_idx
--drop index customer_modified_date_idx;
create index customer_modified_date_idx on public.customer (modified_date) include (last_name, email, age);

explain analyze
select last_name, email, age from customer where modified_date = '2014-12-21'; --BitmapHeapScan.
vacuum analyze customer; --marks pages as all-visible if no recent tuple changes exist 
-- simple analyze customer didn't help here!
explain analyze
select last_name, email, age from customer where modified_date = '2014-12-21'; --Index Only Scan.

alter table public.customer drop constraint customer_pk;

--7 Rename previously created covering index customer_modified_date_idx to customer_modified_date_idx_covering
alter index customer_modified_date_idx rename to customer_modified_date_idx_covering;

--8 Create a Hash index called customer_modified_date_idx on the customer table on the modified_date column
create index customer_modified_date_idx on public.customer using hash (modified_date);
explain analyze
select modified_date from customer where modified_date = '2014-12-21'; --Index Only Scan
--select * from customer where modified_date = '2014-12-21'; --Bitmap Heap Scan 

--9 Create a partial index on the email column only for those records that have active = true. Also, write a query to the table in which this index will be used
create index idx_partial_email on public.customer (email) where active = 'true';
explain analyze
select email from customer --seq scan (w/o where)
where email = 'firstnamelastname78078@email.com' and active = 'true'; --Index Only Scan
--where email = 'firstnamelastname78078@email.com';/* and active = 'true';*/ --Parallel Seq Scan 

--10 Create an index on expression on the customer table to quickly find records using this rule. Expression must implement the following logic: if first_name = 'firstname1' and last_name = 'lastname1', then we are looking for 'f, lastname1', if the first name 'my_name' and last name 'apple' → result should be 'm, apple', etc.
create index idx_concat on public.customer ((left(first_name, 1) || ', ' || last_name));


--11 Check the query plan that this index is being used
explain analyze
select
--	(left(first_name, 1) || ', ' || last_name) as "searched_pattern"
	*
from
	customer
where
--	(left(first_name, 1) || ', ' || last_name) = 'f, lastname78080'; --Bitmap Heap Scan
--	concat(left(first_name, 1), ', ', last_name) = 'f, lastname78080'; --Parallel Seq Scan 
--analyze customer;
--	(left(first_name, 1) || ', ' || last_name) = 'f, lastname78080'; --Index Scan (after 'analyze customer'! - stats updated.)
--vacuum analyze customer;
--vacuum full customer;
	(left(first_name, 1) || ', ' || last_name) = 'f, lastname78080'; --Index Scan (after 'analyze customer'! - stats updated.)
	
	|QUERY PLAN                                                                                                          |
|--------------------------------------------------------------------------------------------------------------------|
|Index Scan using idx_concat on customer  (cost=0.42..8.45 rows=1 width=32) (actual time=0.036..0.037 rows=1 loops=1)|
|  Index Cond: ((("left"((first_name)::text, 1) || ', '::text) || (last_name)::text) = 'f, lastname78080'::text)     |
|Planning Time: 0.094 ms                                                                                             |
|Execution Time: 0.061 ms                                                                                            |


