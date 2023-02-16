-- This script deletes everything in your database
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO CURRENT_USER;
\set ON_ERROR_STOP ON
SET client_min_messages TO NOTICE; -- More talk
\set QUIET false


-- Customer: id, name, billing, isPrivate
CREATE TABLE Customers (
    id INT PRIMARY KEY,
    name TEXT,
    -- monthly billing? --> CustomersView
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
        ON DELETE CASCADE, -- e
    CHECK (plan IN ('prepaid' OR 'flatrate' OR 'corporate')), -- a
    CHECK (plan = 'prepaid' OR balance = 0), -- b
    CHECK (plan ! = 'corporate' OR NOT isPrivate), -- c
    CHECK (fee >= 0) -- d
);
-- Subscription: customer, phoneNumber, plan, fee, balance

-- a) plan must be 'prepaid', 'flatrate' or 'corporate' 

-- b) Balance must be 0 if plan is not prepaid

-- c) Private customers can not have corporate plans

-- d) Monthly billing is sum of fees. 

CREATE VIEW CustomersView AS
    SELECT customer, name, SUM(fee) AS monthlybilling, Customers.isPrivate
    FROM Customers JOIN Subscriptions ON id=customer
    GROUP BY customer, name, Customers.isPrivate;

-- e) Delete subscriptions for deleted customers automatically

-- f) If all subscriptions are deleted, delete customer

-- OLD = (customer, ph1, plan, fee, balance, isPrivate)
CREATE OR REPLACE FUNCTION fun_deleteEmpty ()
    RETURNS TRIGGER AS $$
    BEGIN
        IF NOT EXISTS (SELECT * FROM Subscriptions WHERE customer=OLD.customer)
        THEN DELETE FROM Customers WHERE id=Old.customer;
        END IF;
        RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;

-- f
CREATE TRIGGER fun_deleteEmpty
    AFTER DELETE ON Subscriptions
    FOR EACH ROW
    EXECUTE PROCEDURE fun_deleteEmpty();
