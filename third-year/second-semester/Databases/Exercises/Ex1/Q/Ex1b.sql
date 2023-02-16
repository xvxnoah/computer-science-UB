-- This script deletes everything in your database
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO CURRENT_USER;
\set ON_ERROR_STOP ON
SET client_min_messages TO NOTICE; -- More talk
\set QUIET false


-- Periods(_pname, started, ended)
--Periods have a starting and ending year (both are inclusive) e.g. ('World war II', 1939, 1945) could be an entry. 
CREATE TABLE Periods(
  pname TEXT PRIMARY KEY,
  started INT NOT NULL,
  ended INT NOT NULL
  );

-- Events(_ename, year)
-- Events have a year when they occurred e.g. ('SQL became an ISO standard', 1987) could be an entry. 
CREATE TABLE Events(
  ename TEXT PRIMARY KEY,
  year INT
  );  


-- Test data (not part of assignment)
INSERT INTO Periods VALUES ('P1', 1950, 2050);
INSERT INTO Periods VALUES ('P2', 1975, 2150);
INSERT INTO Periods VALUES ('P3', 1920, 1975);


INSERT INTO Events VALUES ('E1', 1925); -- In P3 only
INSERT INTO Events VALUES ('E2', 2150); -- In P2 only
INSERT INTO Events VALUES ('E3', 1975); -- In P1, P2 and P3
INSERT INTO Events VALUES ('The GCHD', 2000); -- In P1 and P2
--                         ^ shortened the name down a bit


-- a) Find the names of all events that occurred during any of the same historical periods as "The Great Collapsing Hrung Disaster" (a fictional event that you may assume is in the Events table). Make sure each such event occurs only once in the result.  
-- To clarify: "The Great Collapsing Hrung Disaster" happened in some year, and that year is during some number of historical periods. Your job is to find all events that occurred during all those periods.
--Hint: First write an query for finding all periods the event is in, and then use it to find all events in those periods.  

CREATE VIEW EventPeriods AS
  SELECT *
  FROM Events, Periods
  WHERE started <= year AND year <= ended;

-- Testing
SELECT * FROM EventPeriods;

CREATE VIEW GCHDPeriods AS
  SELECT pname, started, ended
  FROM EventPeriods
  WHERE ename = 'The GCHD';

-- Testing so far
SELECT * FROM GCHDPeriods;

SELECT DISTINCT ename FROM EventPeriods JOIN GCHDPeriods USING(pname);

--b) Find the name of the most eventful historical period(s). In other words, the period with the greatest number of events in it. May be more than one period only if there are several periods with the same number of events.
--CREATE VIEW EventCount AS
  --SELECT pname, 

CREATE VIEW EventCount AS
  SELECT pname, COUNT(*) AS periods
  FROM EventPeriods
  GROUP BY (pname);

SELECT pname FROM EventCount WHERE periods = (SELECT MAX(periods) FROM EventCount);
