/*
					Section 1. DDL (30 pts)

You have been given the E/R Diagram of the Airport
 
Create a database called Airport. You need to create 7 tables:
-		Passengers - contains information about the passenger
-		  Each passenger has a full name column and an email column.
-		Pilots - contains information about the pilot 
-	  Each pilot has first and last name columns, an age column, and a rating column.
-		AircraftTypes - contains information about the aircraft type
-		  Contains the name of the type of aircraft.
-		Aircraft - contains information about the aircraft
-		Each aircraft has a manufacturer, a model column, a year column, a flight hours column, a condition  column, and an aircraft type column.
-		PilotsAircraft - a many to many mapping tables between the aircraft and the pilots
-		Have composite primary key from the AircraftId column and the PilotId column.
-		Airports - contains information about airport name and the country.
-		FlightDestinations – contains information about the flight destination
-	Each flight destination has an airport Id column, a start column, an aircraft Id column, a passenger Id column, and a price of the ticket column.

*/

CREATE DATABASE Airport
GO 
USE Airport
GO 

CREATE TABLE Passengers (
Id INT PRIMARY KEY IDENTITY,
FullName VARCHAR(100) NOT NULL,
Email VARCHAR(50) NOT NULL
)

CREATE TABLE Pilots (
Id INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(30) NOT NULL,
LastName VARCHAR(30) NOT NULL,
Age TINYINT NOT NULL CHECK (Age >= 21 AND Age <= 62),
Rating FLOAT CHECK (Rating >= 0.0 AND Rating <= 10.0)
)

CREATE TABLE AircraftTypes (
Id INT PRIMARY KEY IDENTITY,
TypeName VARCHAR(30) NOT NULL
)

CREATE TABLE Aircraft (
Id INT PRIMARY KEY IDENTITY,
Manufacturer VARCHAR(25) NOT NULL,
Model VARCHAR(30) NOT NULL,
[Year] INT NOT NULL,
FlightHours INT,
Condition CHAR NOT NULL,
TypeId INT NOT NULL,
CONSTRAINT FK_Aircraft_AircraftTypes FOREIGN KEY (TypeId) REFERENCES AircraftTypes(Id)
)

CREATE TABLE PilotsAircraft (
AircraftId INT NOT NULL,
PilotId INT NOT NULL,
CONSTRAINT PK_PilotsAircraft PRIMARY KEY (AircraftId, PilotId),
CONSTRAINT FK_PilotsAircraft_Aircraft FOREIGN KEY (AircraftId) REFERENCES Aircraft(Id),
CONSTRAINT FK_PilotsAircraft_Pilots FOREIGN KEY (PilotId) REFERENCES Pilots(Id)
)

CREATE TABLE Airports (
Id INT PRIMARY KEY IDENTITY,
AirportName VARCHAR(70) NOT NULL,
Country VARCHAR(100) NOT NULL
)


CREATE TABLE FlightDestinations (
Id INT PRIMARY KEY IDENTITY,
AirportId INT NOT NULL,
[Start] DATETIME NOT NULL,
AircraftId INT NOT NULL,
PassengerId INT NOT NULL,
TicketPrice DECIMAL(18,2) NOT NULL DEFAULT 15.00
CONSTRAINT FK_FlightDestinations_Airports FOREIGN KEY (AirportId) REFERENCES Airports(Id),
CONSTRAINT FK_FlightDestinations_Aircraft FOREIGN KEY (AircraftId) REFERENCES Aircraft(Id),
CONSTRAINT FK_FlightDestinations_Passengers FOREIGN KEY (PassengerId) REFERENCES Passengers(Id)
)

/*
											Section 2. DML (10 pts)
Before you start you have to import "01.DDL_Dataset.sql". If you have created the structure correctly the data should be successfully inserted.
In this section, you have to do some data manipulations:



2.	Insert
Write a query to insert data into the Passengers table, based on the Pilots table. For all Pilots with an id between 5 and 15 (both inclusive), insert data in the Passengers table with the following values:
-	FullName  -  get the first and last name of the pilot separated by a single space
-	Example - 'Lois Leidle'
-	Email - set it to start with full name with no space and add '@gmail.com' - 'FullName@gmail.com'
-	 Example - 'LoisLeidle@gmail.com'

*/

SELECT * FROM Aircraft
SELECT * FROM AircraftTypes
SELECT * FROM Airports
SELECT * FROM FlightDestinations
SELECT * FROM Passengers
SELECT * FROM Pilots
SELECT * FROM PilotsAircraft


INSERT INTO Passengers (FullName, Email)
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    CONCAT(FirstName, LastName, '@gmail.com') AS Email
FROM Pilots AS p
WHERE p.Id BETWEEN 5 AND 15;

