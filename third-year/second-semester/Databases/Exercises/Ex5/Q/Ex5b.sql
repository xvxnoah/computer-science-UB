
DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS FlightCodes;
DROP TABLE IF EXISTS Airports;

-- Airports(_code,city)
-- FlightCodes(_code, airlineName)
-- Flights(departureAirport, destinationAirport, _code)
--   departureAirport -> Airports.code
--   destinationAirport -> Airports.code
--   code -> FlightCodes.code

CREATE TABLE Airports(
  code TEXT PRIMARY KEY, 
  city TEXT NOT NULL
  );
  
CREATE TABLE FlightCodes(
  code TEXT PRIMARY KEY, 
  airlineName TEXT NOT NULL
  );
  
CREATE TABLE Flights(
  departureAirport TEXT NOT NULL REFERENCES Airports, 
  destinationAirport TEXT NOT NULL REFERENCES Airports, 
  code TEXT PRIMARY KEY REFERENCES FlightCodes
  );


INSERT INTO Airports VALUES ('GOT', 'Gothenburg');
INSERT INTO Airports VALUES ('FRA', 'Frankfurt');
INSERT INTO Airports VALUES ('ORY', 'Paris');
INSERT INTO Airports VALUES ('MLA', 'Malta');
INSERT INTO Airports VALUES ('MUC', 'Munich');

INSERT INTO FlightCodes VALUES ('SK111', 'SAS');
INSERT INTO FlightCodes VALUES ('AF222', 'Air France');
INSERT INTO FlightCodes VALUES ('AB222', 'Air Berlin');
INSERT INTO FlightCodes VALUES ('KM111', 'Air Malta');

INSERT INTO Flights VALUES ('GOT', 'FRA', 'SK111');
INSERT INTO Flights VALUES ('ORY', 'MLA', 'AF222');
INSERT INTO Flights VALUES ('FRA', 'MUC', 'AB222');
INSERT INTO Flights VALUES ('MUC', 'MLA', 'KM111');

-- Recreate the table from the assignment
-- (Not part of the solution)
/*
SELECT F.code       AS flight_code, 
       airlineName  AS airline,
       Dep.city     AS DepCity,
       Dep.code     AS DepAirport,
       Dest.city    AS ArrCity,
       Dest.code    AS ArrAirport       
  FROM Flights F 
       JOIN FlightCodes FC USING (code)
       JOIN Airports Dep ON (departureAirport = Dep.code)
       JOIN Airports Dest ON (destinationAirport = Dest.code);
*/

-- Convert all three tables into one big JSON document
-- First convert each of the tables
-- Hint: Use jsonb_object_agg(key, value) to aggregate into a big object
WITH 
 Ap AS (SELECT json_object_agg(code, city) AS jsondata FROM Airports
       )

SELECT jsonb_pretty(
  jsonb_build_object(
    'Airports', (SELECT jsondata FROM Ap),
    )
);
  
 

