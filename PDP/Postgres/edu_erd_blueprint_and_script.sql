/*----------------------------------------------------------------------------------------------------
/* BLUEPRINT: tables and their fields */
----------------------------------------------------------------------------------------------------
--user role management:

user_role_type:
id PK,
type (data: administrator, customer)

permission:
id PK,
user_role_type_id (FK ref to user_role_type type),
operation_type (data: added, removed, changed, ordered, viewed),
user_allowed_operation: concat(user_role_type_id, '/', operation_type)
constraint: unique index = user_role_type_id + operation_type
--	(admin: added, removed, changed; 
--	 customer: ordered, viewed)

user:
id PK, 
name,
user_role_type
constraint: unique index = name + user_role_type


order:
order_id PK,
customer_id (FK ref to 'user' id field)

order_items:
order_id (FK ref to order: order_id)
book_id (FK ref to 'book' id),
PK composite (order_id + book_id)



--bookstore

book:
id PK,
title,
publish_year,
cost

author:
author_id,
author_name

author_and_book:
id PK,
author_id,
book_id

bookstore_warehouse:
id PK,
book_id,
qty

operation_log:
id PK,
user_id (FK ref to 'user' id),
user_role_type_id (FK ref to 'user_role_type' id),
operation_type (FK ref to 'user_role_type' type),
user_allowed_operation: concat(user_role_type_id, '/', operation_type) (FK ref to 'user_role_type' user_allowed_operation)
op_timestamp*/


----------------------------------------------------------------------------------------------------
/* CREATE STATEMENTS */
----------------------------------------------------------------------------------------------------
-- Drop tables if exist (in order of dependencies)
DROP TABLE IF EXISTS operation_logs;
DROP TABLE IF EXISTS bookstore_warehouse;
DROP TABLE IF EXISTS authors_and_books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS permission;
DROP TABLE IF EXISTS user_role_type;

-- User role management
CREATE TABLE user_role_type (
    id SERIAL PRIMARY KEY,
    type VARCHAR(20) UNIQUE NOT NULL CHECK (type IN ('administrator', 'customer'))
);

CREATE TABLE permission (
    id SERIAL PRIMARY KEY,
    user_role_type_id INT NOT NULL REFERENCES user_role_type(id),
    operation_type VARCHAR(20) NOT NULL CHECK (operation_type IN ('added', 'removed', 'changed', 'ordered', 'viewed')),
    UNIQUE(user_role_type_id, operation_type)
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    user_role_type_id INT NOT NULL REFERENCES user_role_type(id),
    UNIQUE(name, user_role_type_id)
);

-- Orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES users(id)
);

-- Bookstore and authors
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publish_year INT NOT NULL,
    cost DECIMAL(10,2) NOT NULL
);

-- Order items
CREATE TABLE order_items (
    order_id INT NOT NULL REFERENCES orders(order_id),
    book_id INT NOT NULL REFERENCES books(id),
    PRIMARY KEY (order_id, book_id)
);


CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

CREATE TABLE authors_and_books (
    author_id INT NOT NULL REFERENCES authors(author_id),
    book_id INT NOT NULL REFERENCES books(id),
    PRIMARY KEY (author_id, book_id)
);

CREATE TABLE bookstore_warehouse (
    id SERIAL PRIMARY KEY,
    book_id INT NOT NULL REFERENCES books(id),
    location VARCHAR(50) NOT NULL,
    qty INT NOT NULL CHECK (qty >= 0)
);

-- Operation log for auditing
CREATE TABLE operation_logs (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    user_role_type_id INT NOT NULL REFERENCES user_role_type(id),
    operation_type VARCHAR(20) NOT NULL,
    operation_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_permission FOREIGN KEY (user_role_type_id, operation_type) REFERENCES permission(user_role_type_id, operation_type)
);

-- Insert roles
INSERT INTO user_role_type (type) VALUES 
('administrator'), 
('customer');

-- Insert permissions
INSERT INTO permission (user_role_type_id, operation_type) VALUES
(1, 'added'), 
(1, 'removed'), 
(1, 'changed'),
(2, 'ordered'),
(2, 'viewed');

-- Insert users
INSERT INTO users (name, user_role_type_id) VALUES
('Alice', 1),   -- administrator
('Bob', 2);     -- customer

-- Insert authors
INSERT INTO authors (author_name) VALUES
('Chuck Palahniuk'),
('J.K. Rowling');

-- Insert books
INSERT INTO books (title, publish_year, cost) VALUES
('Fight Club', 2005, 19.99),
('Fight Club', 2011, 21.99),
('Harry Potter and the Sorcerer''s Stone', 1997, 29.99);

-- Link authors and books
INSERT INTO authors_and_books (author_id, book_id) VALUES
(1, 1),  -- Chuck Palahniuk - Fight Club (2005)
(1, 2),  -- Chuck Palahniuk - Fight Club (2011)
(2, 3);  -- J.K. Rowling - Harry Potter

-- Insert bookstore warehouse stock
INSERT INTO bookstore_warehouse (book_id, location, qty) VALUES
(1, 'Main Warehouse', 100),
(2, 'Main Warehouse', 50),
(3, 'Main Warehouse', 200);

-- Insert an order by Bob (customer)
INSERT INTO orders (customer_id) VALUES (2);

-- Insert books into the order (order_id will be 1 if first order)
INSERT INTO order_items (order_id, book_id) VALUES
(1, 3);  -- Bob orders 'Harry Potter'

-- Insert operation logs
INSERT INTO operation_logs (user_id, user_role_type_id, operation_type) VALUES
(1, 1, 'added'),   -- Alice added something
(2, 2, 'ordered'); -- Bob placed an order



