-- This script deletes everything in your database
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO CURRENT_USER;
\set ON_ERROR_STOP ON
SET client_min_messages TO NOTICE; -- More talk
\set QUIET false


-- Make a table with a column for state names (or abbreviations), columns for Biden and Trump votes respectively and a column for number of electors. 
CREATE TABLE States (
  name TEXT PRIMARY KEY,
  biden INT, 
  trump INT, 
  electors INT
);



-- Test data
INSERT INTO States VALUES ('NV', 588252,  580605,  6);
INSERT INTO States VALUES ('AZ', 3215969, 3051555, 11);
INSERT INTO States VALUES ('GA', 2406774, 2429783, 16);
INSERT INTO States VALUES ('PA', 3051555, 3215969, 20);
-- Slightly simplified data
INSERT INTO States VALUES ('Red states',  0,  1,  232);
INSERT INTO States VALUES ('Blue states', 1, 0, 253);




-- Q:Then create a view called StateResults that shows for each state: The name of the state, the name of the winning candidate (Biden or Trump) and the number of electors. 
-- GENERAL IDEA: We started with a query that only showed bidens states, dit the same for trump and merged them with UNION
-- NOTE: UNION or UNION ALL are equally valid, there will be no duplicates since each state name can only appear once. 
CREATE VIEW StateResults AS
(SELECT name, 'Biden' AS winner, electors
FROM States
WHERE biden > trump)
UNION ALL
(SELECT name, 'Trump' AS winner, electors
FROM States
WHERE biden < trump);

-- Just checking that it works
SELECT * FROM StateResults;

-- Q:Finally make a query that shows the total number of electoral votes of both candidates (the result should have two rows for the two candidates). 
-- GENERAL IDEA: This is an obvious application of the SUM aggregation. Grouping by winner means there will be exactly two groups (A Biden and a Trump group), and thus two rows in the result. 
SELECT winner, SUM(electors) AS total
FROM StateResults
GROUP BY winner;

