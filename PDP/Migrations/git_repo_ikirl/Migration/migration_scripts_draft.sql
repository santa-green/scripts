SELECT TABLE_NAME, CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'
  AND TABLE_SCHEMA = 'ec2_migration_db';

SELECT CONCAT(
  'ALTER TABLE `', kcu.TABLE_NAME, '` ADD CONSTRAINT `', kcu.CONSTRAINT_NAME, '` FOREIGN KEY (`', kcu.COLUMN_NAME, '`) REFERENCES `',
  kcu.REFERENCED_TABLE_NAME, '`(`', kcu.REFERENCED_COLUMN_NAME, '`)',
  IF(rc.UPDATE_RULE = 'CASCADE', ' ON UPDATE CASCADE', ''),
  IF(rc.UPDATE_RULE = 'SET NULL', ' ON UPDATE SET NULL', ''),
  IF(rc.DELETE_RULE = 'CASCADE', ' ON DELETE CASCADE', ''),
  IF(rc.DELETE_RULE = 'SET NULL', ' ON DELETE SET NULL', ''),
  ';'
) AS fk_sql
FROM information_schema.KEY_COLUMN_USAGE kcu
JOIN information_schema.REFERENTIAL_CONSTRAINTS rc
  ON kcu.CONSTRAINT_SCHEMA = rc.CONSTRAINT_SCHEMA
  AND kcu.CONSTRAINT_NAME = rc.CONSTRAINT_NAME
WHERE kcu.REFERENCED_TABLE_NAME IS NOT NULL
  AND kcu.TABLE_SCHEMA = 'ec2_migration_db';

ALTER TABLE `employees` ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`reportsTo`) REFERENCES `employees`(`employeeNumber`);
ALTER TABLE `employees` ADD CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`officeCode`) REFERENCES `offices`(`officeCode`);
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders_test`(`id`);
ALTER TABLE `orders` ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers`(`customerNumber`);
ALTER TABLE `payments` ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers`(`customerNumber`);
ALTER TABLE `products` ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`productLine`) REFERENCES `productlines`(`productLine`);

-- SQL script that generates ALTER TABLE statements for all foreign keys in your MariaDB/MySQL source database, including those with multiple columns (composite keys). You can run this script in DBeaver (or any SQL client) and then copy/paste the results to your target Aurora DB:
SELECT
  CONCAT(
    'ALTER TABLE `', kcu.TABLE_NAME, '` ADD CONSTRAINT `', kcu.CONSTRAINT_NAME,
    '` FOREIGN KEY (',
    GROUP_CONCAT('`' + kcu.COLUMN_NAME + '`' ORDER BY kcu.ORDINAL_POSITION SEPARATOR ', '),
    ') REFERENCES `', kcu.REFERENCED_TABLE_NAME, '` (',
    GROUP_CONCAT('`' + kcu.REFERENCED_COLUMN_NAME + '`' ORDER BY kcu.ORDINAL_POSITION SEPARATOR ', '),
    ')',
    IF(rc.UPDATE_RULE = 'CASCADE', ' ON UPDATE CASCADE', ''),
    IF(rc.UPDATE_RULE = 'SET NULL', ' ON UPDATE SET NULL', ''),
    IF(rc.DELETE_RULE = 'CASCADE', ' ON DELETE CASCADE', ''),
    IF(rc.DELETE_RULE = 'SET NULL', ' ON DELETE SET NULL', ''),
    ';'
  ) AS fk_sql
FROM information_schema.KEY_COLUMN_USAGE kcu
JOIN information_schema.REFERENTIAL_CONSTRAINTS rc
  ON kcu.CONSTRAINT_SCHEMA = rc.CONSTRAINT_SCHEMA
  AND kcu.CONSTRAINT_NAME = rc.CONSTRAINT_NAME
WHERE kcu.REFERENCED_TABLE_NAME IS NOT NULL
  AND kcu.TABLE_SCHEMA = 'ec2_migration_db'
GROUP BY kcu.TABLE_NAME, kcu.CONSTRAINT_NAME
ORDER BY kcu.TABLE_NAME, kcu.CONSTRAINT_NAME;

ALTER TABLE `employees` ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (0) REFERENCES `employees` (0);
ALTER TABLE `employees` ADD CONSTRAINT `employees_ibfk_2` FOREIGN KEY (0) REFERENCES `offices` (0);
ALTER TABLE `orders` ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (0) REFERENCES `customers` (0);
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (0) REFERENCES `orders_test` (0);
ALTER TABLE `payments` ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (0) REFERENCES `customers` (0);
ALTER TABLE `products` ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (0) REFERENCES `productlines` (0);

-- ----------------------------------------------------------------------------------------------------
/* final */
-- ----------------------------------------------------------------------------------------------------
SELECT 
  CONCAT(
    'ALTER TABLE `', kcu.TABLE_NAME, '` ADD CONSTRAINT `', kcu.CONSTRAINT_NAME, 
    '` FOREIGN KEY (',
      GROUP_CONCAT('`' , kcu.COLUMN_NAME, '`' ORDER BY kcu.ORDINAL_POSITION SEPARATOR ', '),
    ') REFERENCES `', 
      kcu.REFERENCED_TABLE_NAME, '` (',
      GROUP_CONCAT('`', kcu.REFERENCED_COLUMN_NAME, '`' ORDER BY kcu.ORDINAL_POSITION SEPARATOR ', '),
    ')',
    IF(rc.UPDATE_RULE = 'CASCADE', ' ON UPDATE CASCADE', 
      IF(rc.UPDATE_RULE = 'SET NULL', ' ON UPDATE SET NULL', 
      IF(rc.UPDATE_RULE = 'RESTRICT', ' ON UPDATE RESTRICT', 
      IF(rc.UPDATE_RULE = 'NO ACTION', ' ON UPDATE NO ACTION', '')))),
    IF(rc.DELETE_RULE = 'CASCADE', ' ON DELETE CASCADE', 
      IF(rc.DELETE_RULE = 'SET NULL', ' ON DELETE SET NULL', 
      IF(rc.DELETE_RULE = 'RESTRICT', ' ON DELETE RESTRICT', 
      IF(rc.DELETE_RULE = 'NO ACTION', ' ON DELETE NO ACTION', '')))),
    ';'
  ) AS fk_sql
FROM information_schema.KEY_COLUMN_USAGE kcu
JOIN information_schema.REFERENTIAL_CONSTRAINTS rc
  ON kcu.CONSTRAINT_SCHEMA = rc.CONSTRAINT_SCHEMA
  AND kcu.CONSTRAINT_NAME = rc.CONSTRAINT_NAME
WHERE kcu.REFERENCED_TABLE_NAME IS NOT NULL
--   AND kcu.TABLE_SCHEMA = 'ec2_migration_db'   -- <=== CHANGE THIS!
--   AND kcu.TABLE_SCHEMA = 'classicmodels_from_ec2'   -- <=== CHANGE THIS!
  AND kcu.TABLE_SCHEMA = 'classicmodels_rds_scen8'   -- <=== CHANGE THIS!
GROUP BY kcu.TABLE_NAME, kcu.CONSTRAINT_NAME
ORDER BY kcu.TABLE_NAME, kcu.CONSTRAINT_NAME;

ALTER TABLE `employees` ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`reportsTo`) REFERENCES `employees` (`employeeNumber`) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE `employees` ADD CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`officeCode`) REFERENCES `offices` (`officeCode`) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE `orders` ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders_test` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE `payments` ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE `products` ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`productLine`) REFERENCES `productlines` (`productLine`) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- Update statistics for the optimizer
ANALYZE TABLE employees;
ANALYZE TABLE orders;
ANALYZE TABLE order_items;...

-- Optional: Rebuild/optimize tables
OPTIMIZE TABLE employees;
OPTIMIZE TABLE orders;
OPTIMIZE TABLE order_items;...

SHOW VARIABLES LIKE 'log_bin';
SHOW BINARY LOGS;


----------------------------------------------------------------------------------------------------
/* rds to aurora (mysql) */
----------------------------------------------------------------------------------------------------

call mysql.rds_import_s3_file('classicmodels_dump_migrate.sql', 'migration-bucket-ikirl', 'arn:aws:iam::730335241553:role/rds-to-s3-access');

SELECT
    CONCAT(
        'CREATE INDEX `', INDEX_NAME, '` ON `', TABLE_NAME, '` (', GROUP_CONCAT('`', COLUMN_NAME, '`' ORDER BY SEQ_IN_INDEX), ');'
    ) AS create_index_statement
FROM
    information_schema.STATISTICS
WHERE
    TABLE_SCHEMA = 'classicmodels_rds_scen8'
    AND NON_UNIQUE = 1  -- Exclude unique indexes and primary key
    AND INDEX_NAME != 'PRIMARY'
GROUP BY
    TABLE_NAME, INDEX_NAME
ORDER BY
    TABLE_NAME, INDEX_NAME;

CREATE INDEX `officeCode` ON `employees` (`officeCode`);
CREATE INDEX `reportsTo` ON `employees` (`reportsTo`);
CREATE INDEX `order_id` ON `order_items` (`order_id`);
CREATE INDEX `customerNumber` ON `orders` (`customerNumber`);
CREATE INDEX `productLine` ON `products` (`productLine`);


ALTER TABLE `employees` ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`reportsTo`) REFERENCES `employees` (`employeeNumber`) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `employees` ADD CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`officeCode`) REFERENCES `offices` (`officeCode`) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders_test` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `orders` ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `payments` ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `products` ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`productLine`) REFERENCES `productlines` (`productLine`) ON UPDATE NO ACTION ON DELETE NO ACTION;
