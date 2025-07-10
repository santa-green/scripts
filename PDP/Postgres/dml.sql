----------------------------------------------------------------------------------------------------
/* INSERT STATEMENTS */
----------------------------------------------------------------------------------------------------
-- Insert into user_role_type
INSERT INTO user_role_type (role_type) VALUES
('administrator'),
('customer');

-- Insert into permission
INSERT INTO permission (user_role_type_id, operation_type) VALUES
(1, 'added'),
(1, 'removed'),
(1, 'changed'),
(2, 'ordered'),
(2, 'viewed');


-- Insert users (expanded to 10+)
INSERT INTO users (name, user_role_type_id) VALUES
('Alice', 1), ('Charlie', 1), ('Diana', 1), ('Eve', 1), ('Frank', 1), -- administrators
('Bob', 2), ('Grace', 2), ('Heidi', 2), ('Ivan', 2), ('Judy', 2);     -- customers

-- Insert authors (expanded to 10)
INSERT INTO authors (author_name) VALUES
('Chuck Palahniuk'), ('J.K. Rowling'), ('George Orwell'), ('Agatha Christie'),
('Stephen King'), ('Isaac Asimov'), ('Ernest Hemingway'), ('Jane Austen'),
('Mark Twain'), ('F. Scott Fitzgerald');

-- Insert books (expanded to 10+)
INSERT INTO books (title, publish_year, cost) VALUES
('Fight Club', 2005, 19.99), ('Harry Potter and the Sorcerer''s Stone', 1997, 29.99),
('1984', 1949, 15.50), ('Murder on the Orient Express', 1934, 10.99),
('The Shining', 1977, 22.00), ('Foundation', 1951, 18.75),
('The Old Man and the Sea', 1952, 12.00), ('Pride and Prejudice', 1813, 9.99),
('Adventures of Huckleberry Finn', 1884, 8.50), ('The Great Gatsby', 1925, 14.99);

-- Link authors and books
INSERT INTO authors_and_books (author_id, book_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Bookstore warehouse stock (at least 10 rows)
INSERT INTO bookstore_warehouse (book_id, wh_location, qty) VALUES
(1, 'Main Warehouse', 100), (2, 'Main Warehouse', 50), (3, 'Secondary Warehouse', 70),
(4, 'Main Warehouse', 30), (5, 'Secondary Warehouse', 25), (6, 'Main Warehouse', 40),
(7, 'Secondary Warehouse', 10), (8, 'Main Warehouse', 60), (9, 'Secondary Warehouse', 15),
(10, 'Main Warehouse', 20);

-- Insert orders (10 orders, different customers)
INSERT INTO orders (customer_id) VALUES
(6), (7), (8), (9), (10), (6), (7), (8), (9), (10);

-- Insert order items (multiple books per order)
INSERT INTO order_items (order_id, book_id) VALUES
(1, 2), (1, 3),
(2, 1),
(3, 5), (3, 6),
(4, 4),
(5, 7), (5, 8),
(6, 9),
(7, 10),
(8, 1), (8, 5),
(9, 3),
(10, 2), (10, 4);

-- Insert operation logs (10+ logs)
INSERT INTO operation_logs (user_id, user_role_type_id, operation_type) VALUES
(1, 1, 'added'), (2, 2, 'ordered'), (3, 1, 'changed'), (4, 1, 'removed'),
(6, 2, 'ordered'), (7, 2, 'viewed'), (8, 2, 'ordered'), (9, 2, 'viewed'),
(10, 2, 'ordered'), (5, 1, 'added');


----------------------------------------------------------------------------------------------------
/* DML: update, delete */
----------------------------------------------------------------------------------------------------

START TRANSACTION;
SELECT * FROM books;
UPDATE books SET cost = cost * 1.1 WHERE id = 7 returning *;
-- COMMIT;
-- ROLLBACK;


-- ON DELETE CASCADE can be dangerous on prod (though it seems to be a fast workaround).
SELECT txid_current(); -- 47410 / 47411
START TRANSACTION;
SELECT * FROM books;
SELECT * FROM books WHERE publish_year < 1900;
SELECT * FROM order_items WHERE book_id in (SELECT id FROM books WHERE publish_year < 1900);
delete FROM order_items WHERE book_id in (SELECT id FROM books WHERE publish_year < 1900) returning *;
SELECT * FROM authors_and_books aab;
SELECT * FROM authors_and_books aab WHERE book_id in (SELECT id FROM books WHERE publish_year < 1900);
delete FROM authors_and_books aab WHERE book_id in (SELECT id FROM books WHERE publish_year < 1900) returning *;
SELECT * FROM bookstore_warehouse bw WHERE bw.book_id in (SELECT id FROM books WHERE publish_year < 1900);
DELETE FROM bookstore_warehouse bw WHERE bw.book_id in (SELECT id FROM books WHERE publish_year < 1900) returning *;
DELETE FROM books WHERE publish_year < 1900 RETURNING *;
-- COMMIT;
-- ROLLBACK;
SELECT * FROM books;

