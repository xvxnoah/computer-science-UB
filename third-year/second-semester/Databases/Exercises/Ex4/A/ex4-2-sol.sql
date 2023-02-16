-- This script deletes everything in your database
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO CURRENT_USER;
\set ON_ERROR_STOP ON
SET client_min_messages TO NOTICE; -- More talk
\set QUIET false

CREATE TABLE Customers (
    id INT PRIMARY KEY,
    name TEXT,
    -- mothly billing? --> CustomersView
    isPrivate BOOLEAN,
    UNIQUE (id, isPrivate) -- added because is being referenced
);

CREATE TABLE Subscriptions (
    customer INT,
    phoneNumber TEXT PRIMARY KEY,
    plan TEXT,
    fee INT,
    balance INT,
    isPrivate BOOLEAN, -- added because of c
    FOREIGN KEY (customer, isPrivate) REFERENCES Customers(id, isPrivate) 
        ON DELETE CASCADE,                                -- e
    CHECK (plan IN ('prepaid', 'corporate', 'flatrare')), -- a
    -- if not(prepaid) then balance=0
    -- a => b ---> not(a) or b
    -- not(not(prepaid)) or balance = 0
    -- prepaid or balance = 0
    CHECK (plan='prepaid' OR balance=0),                  -- b
    -- if corporate then not(isPrivate) --->
    -- not(corporate) or not(isPrivate)
    CHECK (plan != 'corporate' OR NOT isPrivate),          -- c
    CHECK (fee >= 0)                                       -- d
);

-- d
CREATE VIEW CustomersView AS
    SELECT customer, name, SUM(fee) AS monthlyBilling, Customers.isPrivate 
    FROM Customers JOIN Subscriptions ON id=customer
    GROUP BY customer, name, Customers.isPrivate;


-- OLD = (customer, ph1, plan, fee, balance, isPrivate)
CREATE OR REPLACE FUNCTION fun_deleteEmpty ()
    RETURNS TRIGGER AS $$
    BEGIN
        IF NOT EXISTS (SELECT * FROM Subscriptions WHERE customer=OLD.customer)
        THEN DELETE FROM Customers WHERE id=OLD.customer;
        END IF;
        RETURN OLD;
    END;
$$ LANGUAGE plpgsql;

-- f
CREATE TRIGGER deleteEmpty
    AFTER DELETE ON Subscriptions
    FOR EACH ROW
    EXECUTE PROCEDURE fun_deleteEmpty();



