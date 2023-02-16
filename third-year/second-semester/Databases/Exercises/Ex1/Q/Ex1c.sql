-- This script deletes everything in your database
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO CURRENT_USER;
\set ON_ERROR_STOP ON
SET client_min_messages TO NOTICE; -- More talk
\set QUIET false


CREATE TABLE Items(
  itemname TEXT PRIMARY KEY, 
  price NUMERIC
);

CREATE TABLE Categories(catname TEXT PRIMARY KEY);

CREATE TABLE Categorized(
  item TEXT PRIMARY KEY REFERENCES Items, 
  category TEXT NOT NULL REFERENCES Categories
);

CREATE TABLE Discounts(
  category TEXT NOT NULL REFERENCES Categories,
  pricefactor NUMERIC NOT NULL
);

-- Test data (not included in question)
INSERT INTO Items VALUES ('Cheap', 100);
INSERT INTO Items VALUES ('Cheapish', 1000);
INSERT INTO Items VALUES ('Expensive', 10000);
INSERT INTO Items VALUES ('SuperExpensive', 100000);

INSERT INTO Categories VALUES ('Sale');

INSERT INTO Discounts VALUES ('Sale', 0.75);

INSERT INTO Categorized VALUES ('Cheap', 'Sale');
INSERT INTO Categorized VALUES ('Cheapish', 'Sale');



-- a) Find the name and actual price of each item, factoring in discounts where applicable.
CREATE VIEW Test AS SELECT * FROM Items
  LEFT OUTER JOIN Categorized ON (itemname = item)
  LEFT OUTER JOIN Discounts USING (category);

SELECT * FROM Test;

SELECT itemname, price*COALESCE(pricefactor, 1) AS actualPrice
FROM Items
  LEFT OUTER JOIN Categorized ON (itemname = item)
  LEFT OUTER JOIN Discounts USING (category);

-- b) Find the largest difference in base price (ignoring discounts) between any two products in the same category. The result should be a single number. Items that have no category are irrelevant to this query.
WITH
  ItemsWithCats AS (SELECT * FROM Items JOIN Categorized ON item=itemname)

SELECT MAX(A.price-B.price)
FROM ItemsWithCats AS A JOIN
     ItemsWithCats AS B USING (category);

-- c) Find the average price of all products that do not have a category. The result should be a single number.
SELECT AVG(price)
FROM Items LEFT JOIN Categorized ON (itemname = item)
WHERE item IS NULL;

SELECT AVG(price)
FROM Items
WHERE itemname NOT IN (SELECT item FROM Categorized);
