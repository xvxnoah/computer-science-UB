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
  price NUMERIC NOT NULL
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
--INSERT INTO Categories VALUES ('NoSale'); -- Extra data added


INSERT INTO Discounts VALUES ('Sale', 0.75);

INSERT INTO Categorized VALUES ('Cheap', 'Sale');
INSERT INTO Categorized VALUES ('Cheapish', 'Sale');
--INSERT INTO Categorized VALUES ('Expensive', 'NoSale'); -- Extra data added



-- a) Find the name and actual price of each item, factoring in discounts where applicable.

-- We use OUTER JOIN to first get all products and the category they belong to, with null if they have no category, then again to add the discount for all categories with null if there is no discount. 
-- That means pricefactor is null for all items that are not discounted, and we get the actual price by replacing null with 1 and multiplying with the base price. 
SELECT itemname, price*COALESCE(pricefactor, 1) AS acturalPrice
FROM Items 
     LEFT OUTER JOIN Categorized ON (itemname = item)
     LEFT OUTER JOIN Discounts USING (category)
     ;

-- b) Find the largest difference in base price (ignoring discounts) between any two products in the same category. The result should be a single number. Items that have no category are irrelevant to this query.

-- This one was not solved in the question, here's a solution.
-- It uses WITH (we could just have easily created a view, but I want to demonstrate the feature)
-- The idea is to start with a table containing only the categorized items. 
-- This table is then joined with itself using category, so each item is paired up with every other item from the same category (and with itself!). We then compute the largest difference using MAX. 
-- NOTE: Replacing MAX(...) with * may be useful for undestanding the approach
-- NOTE: Adding a few more categories (and items to those categories) would be necessary to properly test this query.
-- NOTE: This is a rare example of having an expression as parameter to max, not just a column name.
WITH 
 ItemsWithCats AS (SELECT * FROM Items JOIN Categorized ON item=itemname)
SELECT MAX(A.price-B.price)
FROM ItemsWithCats AS A JOIN 
     ItemsWithCats AS B USING (category);

-- Optional (maybe better?) solution using GROUP BY. It has three 
-- Basic idea: the CatDiffs query gives the difference between the highest and lowest price of each category, the maximum of that difference is the solution
WITH 
 ItemsWithCats AS (SELECT * FROM Items JOIN Categorized ON item=itemname),
 CatDiffs AS (SELECT MAX(price) - MIN(price) AS diff FROM ItemsWithCats GROUP BY Category)
SELECT MAX(diff) FROM CatDiffs;


-- c) Find the average price of all products that do not have a category. The result should be a single number.

-- These are two alternative solutions that do the same thing. 
-- NOTE: To develop these queries, we started by not applying AVG, but just selecting price. When the prices shows were the ones we wanted, we added the aggregation. 

-- Taking the outer join and just keeping the extra rows. This seems a bit silly (why would we JOIN with Categorized to get products that do NOT have a category?!), but it does work. 
SELECT AVG(price) 
FROM Items LEFT JOIN Categorized ON (itemname = item)
WHERE item IS NULL;

-- Using the not in operator might seem be a more intuitive way of doing this. 
-- We express "not having a category" as "the name of the item is not in the item column of Categorized" and put that condition in our where clause. 
SELECT AVG(price) 
FROM Items
WHERE itemname NOT IN (SELECT item FROM Categorized);

