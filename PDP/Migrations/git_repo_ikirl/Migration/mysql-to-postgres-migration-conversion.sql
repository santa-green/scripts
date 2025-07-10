
delimiter $$
            

-- ------------ Write DROP-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE ec2_migration_db_mysql.employees DROP FOREIGN KEY employees_ibfk_1;$$

ALTER TABLE ec2_migration_db_mysql.employees DROP FOREIGN KEY employees_ibfk_2;$$

ALTER TABLE ec2_migration_db_mysql.order_items DROP FOREIGN KEY order_items_ibfk_1;$$

ALTER TABLE ec2_migration_db_mysql.orders DROP FOREIGN KEY orders_ibfk_1;$$

ALTER TABLE ec2_migration_db_mysql.payments DROP FOREIGN KEY payments_ibfk_1;$$

ALTER TABLE ec2_migration_db_mysql.products DROP FOREIGN KEY products_ibfk_1;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write DROP-INDEX-stage scripts -----------

DROP INDEX officeCode ON ec2_migration_db_mysql.employees;$$

DROP INDEX reportsTo ON ec2_migration_db_mysql.employees;$$

DROP INDEX order_id ON ec2_migration_db_mysql.order_items;$$

DROP INDEX customerNumber ON ec2_migration_db_mysql.orders;$$

DROP INDEX productLine ON ec2_migration_db_mysql.products;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write DROP-TABLE-stage scripts -----------

DROP TABLE IF EXISTS ec2_migration_db_mysql.employees;$$

DROP TABLE IF EXISTS ec2_migration_db_mysql.offices;$$

DROP TABLE IF EXISTS ec2_migration_db_mysql.order_items;$$

DROP TABLE IF EXISTS ec2_migration_db_mysql.orders;$$

DROP TABLE IF EXISTS ec2_migration_db_mysql.orders_test;$$

DROP TABLE IF EXISTS ec2_migration_db_mysql.payments;$$

DROP TABLE IF EXISTS ec2_migration_db_mysql.productlines;$$

DROP TABLE IF EXISTS ec2_migration_db_mysql.products;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write DROP-DATABASE-stage scripts -----------


delimiter ;
            


delimiter $$
            

-- ------------ Write CREATE-DATABASE-stage scripts -----------

CREATE DATABASE IF NOT EXISTS ec2_migration_db_mysql;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write CREATE-TABLE-stage scripts -----------

CREATE TABLE ec2_migration_db_mysql.employees (
employeeNumber int  NOT NULL,
lastName varchar(50)  NOT NULL,
firstName varchar(50)  NOT NULL,
extension varchar(10)  NOT NULL,
email varchar(100)  NOT NULL,
officeCode varchar(10)  NOT NULL,
reportsTo int  DEFAULT NULL,
jobTitle varchar(50)  NOT NULL,
PRIMARY KEY (employeeNumber)
);$$

CREATE TABLE ec2_migration_db_mysql.offices (
officeCode varchar(10)  NOT NULL,
city varchar(50)  NOT NULL,
phone varchar(50)  NOT NULL,
addressLine1 varchar(50)  NOT NULL,
addressLine2 varchar(50)  DEFAULT NULL,
state varchar(50)  DEFAULT NULL,
country varchar(50)  NOT NULL,
postalCode varchar(15)  NOT NULL,
territory varchar(10)  NOT NULL,
PRIMARY KEY (officeCode)
);$$

CREATE TABLE ec2_migration_db_mysql.order_items (
id int  NOT NULL,
order_id int  DEFAULT NULL,
item_name varchar(50)  DEFAULT NULL,
PRIMARY KEY (id)
);$$

CREATE TABLE ec2_migration_db_mysql.orders (
orderNumber int  NOT NULL,
orderDate date  NOT NULL,
requiredDate date  NOT NULL,
shippedDate date  DEFAULT NULL,
status varchar(15)  NOT NULL,
comments text(65535)  DEFAULT NULL,
customerNumber int  NOT NULL,
PRIMARY KEY (orderNumber)
);$$

CREATE TABLE ec2_migration_db_mysql.orders_test (
id int  NOT NULL,
order_date date  DEFAULT NULL,
PRIMARY KEY (id)
);$$

CREATE TABLE ec2_migration_db_mysql.payments (
customerNumber int  NOT NULL,
checkNumber varchar(50)  NOT NULL,
paymentDate date  NOT NULL,
amount decimal(10,2)  NOT NULL,
PRIMARY KEY (customerNumber,checkNumber)
);$$

CREATE TABLE ec2_migration_db_mysql.productlines (
productLine varchar(50)  NOT NULL,
textDescription varchar(4000)  DEFAULT NULL,
htmlDescription mediumtext  DEFAULT NULL,
image mediumblob  DEFAULT NULL,
PRIMARY KEY (productLine)
);$$

CREATE TABLE ec2_migration_db_mysql.products (
productCode varchar(15)  NOT NULL,
productName varchar(70)  NOT NULL,
productLine varchar(50)  NOT NULL,
productScale varchar(10)  NOT NULL,
productVendor varchar(50)  NOT NULL,
productDescription text(65535)  NOT NULL,
quantityInStock smallint  NOT NULL,
buyPrice decimal(10,2)  NOT NULL,
MSRP decimal(10,2)  NOT NULL,
PRIMARY KEY (productCode)
);$$


delimiter ;
            


delimiter $$
            

-- ------------ Write CREATE-INDEX-stage scripts -----------

CREATE INDEX officeCode
USING BTREE ON ec2_migration_db_mysql.employees (officeCode);$$

CREATE INDEX reportsTo
USING BTREE ON ec2_migration_db_mysql.employees (reportsTo);$$

CREATE INDEX order_id
USING BTREE ON ec2_migration_db_mysql.order_items (order_id);$$

CREATE INDEX customerNumber
USING BTREE ON ec2_migration_db_mysql.orders (customerNumber);$$

CREATE INDEX productLine
USING BTREE ON ec2_migration_db_mysql.products (productLine);$$


delimiter ;
            


delimiter $$
            

-- ------------ Write CREATE-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE ec2_migration_db_mysql.employees
ADD CONSTRAINT employees_ibfk_1 FOREIGN KEY (reportsTo) 
REFERENCES ec2_migration_db_mysql.employees (employeeNumber)
ON DELETE NO ACTION
ON UPDATE NO ACTION;$$

ALTER TABLE ec2_migration_db_mysql.employees
ADD CONSTRAINT employees_ibfk_2 FOREIGN KEY (officeCode) 
REFERENCES ec2_migration_db_mysql.offices (officeCode)
ON DELETE NO ACTION
ON UPDATE NO ACTION;$$

ALTER TABLE ec2_migration_db_mysql.order_items
ADD CONSTRAINT order_items_ibfk_1 FOREIGN KEY (order_id) 
REFERENCES ec2_migration_db_mysql.orders_test (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;$$

ALTER TABLE ec2_migration_db_mysql.orders
ADD CONSTRAINT orders_ibfk_1 FOREIGN KEY (customerNumber) 
REFERENCES ec2_migration_db_mysql.customers (customerNumber)
ON DELETE NO ACTION
ON UPDATE NO ACTION;$$

ALTER TABLE ec2_migration_db_mysql.payments
ADD CONSTRAINT payments_ibfk_1 FOREIGN KEY (customerNumber) 
REFERENCES ec2_migration_db_mysql.customers (customerNumber)
ON DELETE NO ACTION
ON UPDATE NO ACTION;$$

ALTER TABLE ec2_migration_db_mysql.products
ADD CONSTRAINT products_ibfk_1 FOREIGN KEY (productLine) 
REFERENCES ec2_migration_db_mysql.productlines (productLine)
ON DELETE NO ACTION
ON UPDATE NO ACTION;$$


delimiter ;
            

