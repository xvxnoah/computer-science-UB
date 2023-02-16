-- This script deletes everything in your database
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
-- Use this instead of drop schema if running on the Chalmers Postgres server
-- DROP OWNED BY TDA357_XXX CASCADE;
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
\set QUIET false

-- \ir is for include relative, it will run files in the same directory as this file
-- Note that these are not SQL statements but rather Postgres commands (no terminating ;). 
\ir setup.sql
\ir triggers.sql
\ir tests.sql

-- Tests various queries from the assignment, uncomment these as you make progress
/*SELECT idnr, name, login, program, branch FROM BasicInformation ORDER BY idnr;

SELECT student, course, grade, credits FROM FinishedCourses ORDER BY student;

SELECT student, course, credits FROM PassedCourses ORDER BY student;

SELECT student, course, status FROM Registrations ORDER BY student;

SELECT student, course FROM UnreadMandatory ORDER BY student;

SELECT student, totalCredits, mandatoryLeft, mathCredits, researchCredits, seminarCourses, qualified FROM PathToGraduation ORDER BY student; */


-- Life-hack: When working on a new view you can write it as a query here (without creating a view) and when it works just add CREATE VIEW and put it in views.sql
