----------------------------------------------------------------------------------------------------
/* INDEXES */
----------------------------------------------------------------------------------------------------
-- Check existing indexes
SELECT * 
FROM pg_indexes 
WHERE schemaname = 'public';

-- copy as markdown
|schemaname|tablename|indexname|tablespace|indexdef|
|----------|---------|---------|----------|--------|
|public|authors|authors_pkey||CREATE UNIQUE INDEX authors_pkey ON public.authors USING btree (author_id)|
|public|authors_and_books|authors_and_books_pkey||CREATE UNIQUE INDEX authors_and_books_pkey ON public.authors_and_books USING btree (author_id, book_id)|
|public|books|books_pkey||CREATE UNIQUE INDEX books_pkey ON public.books USING btree (id)|
|public|bookstore_warehouse|bookstore_warehouse_pkey||CREATE UNIQUE INDEX bookstore_warehouse_pkey ON public.bookstore_warehouse USING btree (id)|
|public|operation_logs|operation_logs_pkey||CREATE UNIQUE INDEX operation_logs_pkey ON public.operation_logs USING btree (id)|
|public|order_items|order_items_pkey||CREATE UNIQUE INDEX order_items_pkey ON public.order_items USING btree (order_id, book_id)|
|public|orders|orders_pkey||CREATE UNIQUE INDEX orders_pkey ON public.orders USING btree (order_id)|
|public|permission|permission_pkey||CREATE UNIQUE INDEX permission_pkey ON public.permission USING btree (id)|
|public|permission|permission_user_role_type_id_operation_type_key||CREATE UNIQUE INDEX permission_user_role_type_id_operation_type_key ON public.permission USING btree (user_role_type_id, operation_type)|
|public|user_role_type|user_role_type_pkey||CREATE UNIQUE INDEX user_role_type_pkey ON public.user_role_type USING btree (id)|
|public|user_role_type|user_role_type_type_key||CREATE UNIQUE INDEX user_role_type_type_key ON public.user_role_type USING btree (role_type)|
|public|users|users_pkey||CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id)|
|public|users|users_name_user_role_type_id_key||CREATE UNIQUE INDEX users_name_user_role_type_id_key ON public.users USING btree (name, user_role_type_id)|

-- copy as sql
INSERT INTO pg_indexes (schemaname,tablename,indexname,"tablespace",indexdef) VALUES
	 ('public','authors','authors_pkey',NULL,'CREATE UNIQUE INDEX authors_pkey ON public.authors USING btree (author_id)'),
	 ('public','authors_and_books','authors_and_books_pkey',NULL,'CREATE UNIQUE INDEX authors_and_books_pkey ON public.authors_and_books USING btree (author_id, book_id)'),
	 ('public','books','books_pkey',NULL,'CREATE UNIQUE INDEX books_pkey ON public.books USING btree (id)'),
	 ('public','bookstore_warehouse','bookstore_warehouse_pkey',NULL,'CREATE UNIQUE INDEX bookstore_warehouse_pkey ON public.bookstore_warehouse USING btree (id)'),
	 ('public','operation_logs','operation_logs_pkey',NULL,'CREATE UNIQUE INDEX operation_logs_pkey ON public.operation_logs USING btree (id)'),
	 ('public','order_items','order_items_pkey',NULL,'CREATE UNIQUE INDEX order_items_pkey ON public.order_items USING btree (order_id, book_id)'),
	 ('public','orders','orders_pkey',NULL,'CREATE UNIQUE INDEX orders_pkey ON public.orders USING btree (order_id)'),
	 ('public','permission','permission_pkey',NULL,'CREATE UNIQUE INDEX permission_pkey ON public.permission USING btree (id)'),
	 ('public','permission','permission_user_role_type_id_operation_type_key',NULL,'CREATE UNIQUE INDEX permission_user_role_type_id_operation_type_key ON public.permission USING btree (user_role_type_id, operation_type)'),
	 ('public','user_role_type','user_role_type_pkey',NULL,'CREATE UNIQUE INDEX user_role_type_pkey ON public.user_role_type USING btree (id)');
INSERT INTO pg_indexes (schemaname,tablename,indexname,"tablespace",indexdef) VALUES
	 ('public','user_role_type','user_role_type_type_key',NULL,'CREATE UNIQUE INDEX user_role_type_type_key ON public.user_role_type USING btree (role_type)'),
	 ('public','users','users_pkey',NULL,'CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id)'),
	 ('public','users','users_name_user_role_type_id_key',NULL,'CREATE UNIQUE INDEX users_name_user_role_type_id_key ON public.users USING btree (name, user_role_type_id)');


-- Create index on books.publish_year for faster filtering by year
CREATE INDEX idx_books_publish_year ON books(publish_year);

-- Create composite index on order_items for (order_id, book_id)
CREATE INDEX idx_order_items_order_book ON order_items(order_id, book_id);



-- Create COVERING INDEX on books (access to index pages w/o accessing data pages).

-- w/o index:
EXPLAIN ANALYZE
SELECT title, "cost", publish_year FROM books WHERE publish_year = 2005;
--Seq Scan on books  (cost=0.00..11.75 rows=1 width=536) (actual time=0.016..0.017 rows=1 loops=1)
--  Filter: (publish_year = 2005)
--  Rows Removed by Filter: 7
--Planning Time: 0.069 ms
--Execution Time: 0.034 ms

-- w/ index:
CREATE INDEX idx_books_publish_year_coveringalter ON books (publish_year) INCLUDE (title, "cost");

EXPLAIN ANALYZE
SELECT title, "cost", publish_year FROM books WHERE publish_year = 2005;

ANALYZE books; -- to update statistics.
--Seq Scan on books  (cost=0.00..1.10 rows=1 width=28) (actual time=0.010..0.012 rows=1 loops=1)
--  Filter: (publish_year = 2005)
--  Rows Removed by Filter: 7
--Planning Time: 0.372 ms
--Execution Time: 0.031 ms

SELECT 'We don''t see any change because the data volume is too small, 
	engine considers seq scan the best option here as the cheapest' "TAKEAWAY";


----------------------------------------------------------------------------------------------------
/* SEQUENCES */
----------------------------------------------------------------------------------------------------
--Sequence = db object generating unique numeric values sequentially (not tied directly to tables), often used for auto-incrementing IDs. 

-- Create two sequences
CREATE SEQUENCE seq_order_id START 1000 INCREMENT 1;
CREATE SEQUENCE seq_user_id START 500 INCREMENT 5;

-- Get next values from sequences
SELECT nextval('seq_order_id') AS order_id;  -- Returns 1000 first, then increments
SELECT nextval('seq_user_id') AS user_id;    -- Returns 500 first, then increments by 5

-- Use sequence value in an insert (manual id generation)
INSERT INTO orders (order_id, customer_id) VALUES (nextval('seq_order_id'), 2);

-- Get current value of sequence in session
SELECT currval('seq_order_id');  -- Returns last value returned by nextval in current session

-- Heads-up!
CREATE SEQUENCE seq_test_id START 10 INCREMENT 1;
SELECT currval('seq_test_id');  -- throws an error: SQL Error [55000]: ERROR: currval of sequence "seq_test_id" is not yet defined in this session

select nextval('seq_test_id');



----------------------------------------------------------------------------------------------------
/* VIEWS */
----------------------------------------------------------------------------------------------------

-- Customers and their ordered books:
SELECT u.name, o.order_id, b.title, b.publish_year, b."cost"
FROM users u 
JOIN orders o ON u.id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN books b ON oi.book_id = b.id;

create view "ordered_books" as
SELECT u.name, o.order_id, b.title, b.publish_year, b."cost"
FROM users u 
JOIN orders o ON u.id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN books b ON oi.book_id = b.id;

select * from ordered_books;



-- Create materialized view summarizing average book cost by year
CREATE MATERIALIZED VIEW book_cost_summary AS
SELECT publish_year, AVG(cost) AS avg_cost
FROM books
GROUP BY publish_year;

-- Query materialized view
SELECT * FROM book_cost_summary WHERE avg_cost > 15;

-- Refresh materialized view when underlying data changes
REFRESH MATERIALIZED VIEW book_cost_summary;

