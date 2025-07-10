CREATE TABLE practice_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL
);

select * from public.practice_table;


INSERT INTO practice_table (name, balance) VALUES ('Alice', 1000.00);
INSERT INTO practice_table (name, balance) VALUES ('Bob', 1500.50);

|id |name |balance|
|---|-----|-------|
|1  |Alice|1,000  |
|2  |Bob  |1,500.5|

--stored procedure to update the balance for an account
create or replace procedure update_balance (p_id int, p_balance decimal(10,2))
as $$
declare
	updated_row record;
begin
	update practice_table set balance = p_balance where id = p_id;
end;
$$ language plpgsql;

call update_balance(2, 4000);
select * from practice_table;

----------------------------------------------------------------------------------------------------
/* Advanced Examples */
----------------------------------------------------------------------------------------------------
--funds transfer.
CREATE OR REPLACE PROCEDURE transfer_funds(sender_id INT, receiver_id INT, amount DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE practice_table SET balance = balance - amount WHERE id = sender_id;
    UPDATE practice_table SET balance = balance + amount WHERE id = receiver_id;
END;
$$;

CALL transfer_funds(1, 2, 200.00);
select * from practice_table;

--bulk insert data.
CREATE OR REPLACE PROCEDURE bulk_insert(data JSON)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO practice_table (name, balance)
    SELECT (rec->>'name')::VARCHAR, (rec->>'balance')::DECIMAL
    FROM json_array_elements(data) AS rec;
END;
$$;

CALL bulk_insert('[{"name":"Charlie", "balance":3000}, {"name":"Dana", "balance":2500}]'::JSON);
select * from practice_table;

--delete records safely
CREATE OR REPLACE PROCEDURE safe_delete(account_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM practice_table WHERE id = account_id AND balance = 0) THEN
        DELETE FROM practice_table WHERE id = account_id;
    ELSE
        RAISE EXCEPTION 'Account balance is not zero.';
    END IF;
END;
$$;
--Safely delete an account.
CALL safe_delete(1);










----------------------------------------------------------------------------------------------------
/* test */
----------------------------------------------------------------------------------------------------
/*

-- 1. Create a simple log table
CREATE TABLE balance_log (
    log_id SERIAL PRIMARY KEY,
    user_id INT,
    new_balance DECIMAL(10,2),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create a logging function
CREATE OR REPLACE FUNCTION log_balance_change(p_user_id INT, p_new_balance DECIMAL)
RETURNS VOID AS $$
BEGIN
    INSERT INTO balance_log(user_id, new_balance)
    VALUES (p_user_id, p_new_balance);
END;
$$ LANGUAGE plpgsql;

-- 3. Create the main procedure using PERFORM
CREATE OR REPLACE PROCEDURE update_user_balance(p_user_id INT, p_balance DECIMAL)
AS $$
BEGIN
    UPDATE practice_table
    SET balance = p_balance
    WHERE id = p_user_id;

     Log the balance change using PERFORM (ignoring return)
    PERFORM log_balance_change(p_user_id, p_balance);
END;
$$ LANGUAGE plpgsql;

-- 4. Call the procedure
CALL update_user_balance(2, 2000.00);
select * from balance_log;
PERFORM * from balance_log;


-- 1. Create a table for logging
CREATE TABLE login_log (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    login_time TIMESTAMP NOT NULL
);

-- 2. Create the function to insert a login log
CREATE OR REPLACE FUNCTION log_login(p_user_id INT)
RETURNS void AS $$
BEGIN
    INSERT INTO login_log(user_id, login_time)
    VALUES (p_user_id, now());
END;
$$ LANGUAGE plpgsql;

-- 3. Use PERFORM to call the function (nothing will be shown, but the row is added!)
PERFORM log_login(123);
SELECT * FROM login_log;

DO $$
BEGIN
    PERFORM log_login(123);
END;
$$;

*/


