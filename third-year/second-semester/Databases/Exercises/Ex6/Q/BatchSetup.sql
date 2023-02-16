\set ON_ERROR_STOP OFF
SELECT * FROM Logbook;

-- This script deletes everything in your database
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO CURRENT_USER;
\set ON_ERROR_STOP ON
SET client_min_messages TO NOTICE; -- More talk
\set QUIET false


CREATE TABLE Users (
id INTEGER PRIMARY KEY,
name TEXT,
password TEXT
);

CREATE TABLE UserStatus (
id INTEGER PRIMARY KEY REFERENCES Users,
loggedin BOOLEAN NOT NULL
);

CREATE TABLE Logbook (
id INTEGER REFERENCES Users,
timestamp TIMESTAMP,
entry TEXT,
PRIMARY KEY (id, timestamp)
);

INSERT INTO Users VALUES (11, 'S11', 'pwd11');
--INSERT INTO Users VALUES (42, 'S42', 'pwd42');
INSERT INTO Users VALUES (55, 'S55', 'pwd55');

