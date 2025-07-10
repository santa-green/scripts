-- Basic SELECT
SELECT * FROM books;
SELECT title, cost FROM books;
SELECT DISTINCT user_role_type_id FROM users;

-- Conditions with different operators
SELECT * FROM books WHERE cost > 20;
SELECT * FROM users WHERE upper(name) LIKE 'A%';
SELECT * FROM orders WHERE customer_id IN (6,7);
SELECT * FROM books WHERE publish_year BETWEEN 1900 AND 2000;
SELECT * FROM bookstore_warehouse WHERE qty IS NOT NULL;

-- Nested queries in conditions
SELECT * FROM order_items WHERE book_id IN (
	SELECT id FROM books WHERE cost > 20);

SELECT * FROM authors_and_books WHERE author_id IN (
	SELECT author_id FROM authors WHERE author_name LIKE 'J%');

-- ORDER BY
SELECT * FROM books ORDER BY publish_year DESC;

-- UNION of two queries
SELECT name FROM users WHERE user_role_type_id = 1
UNION
SELECT name FROM users WHERE user_role_type_id = 2;

-- INNER JOIN queries with aliases
SELECT u.name, o.order_id, b.title, b.publish_year, b."cost"
FROM users u 
JOIN orders o ON u.id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN books b ON oi.book_id = b.id;

SELECT b.title, a.author_name 
FROM books b 
INNER JOIN authors_and_books ab ON b.id = ab.book_id 
INNER JOIN authors a ON ab.author_id = a.author_id;

-- LEFT and RIGHT OUTER JOIN queries with aliases
SELECT u.name, coalesce(cast(o.order_id as text), '[ ! ] no order yet')
FROM users u 
LEFT JOIN orders o ON u.id = o.customer_id;

SELECT o.order_id, oi.book_id 
FROM orders o 
RIGHT JOIN order_items oi ON o.order_id = oi.order_id;

-- Numeric function usage
SELECT id, ROUND(cost) AS "rounded_cost, $" FROM books;

-- String function usage
SELECT name, UPPER(name) AS uppercase_name FROM users;
SELECT length(title) FROM books;
SELECT SUBSTRING(a.author_name FROM '[^ ]+$') "mostly_known_by", * FROM authors a ;

-- Aggregate functions with GROUP BY and HAVING
SELECT o.customer_id, u."name" customer_name, COUNT(o.order_id) AS total_orders 
FROM orders o
JOIN users u on o.customer_id = u.id 
GROUP BY o.customer_id,u."name" 
HAVING COUNT(o.order_id) > 1;

SELECT user_role_type_id, AVG(cost) AS avg_cost 
FROM books 
GROUP BY user_role_type_id;
