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

INSERT INTO Passengers (FullName, Email)
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    CONCAT(FirstName, LastName, '@gmail.com') AS Email
FROM Pilots AS p
WHERE p.Id BETWEEN 5 AND 15;

/*
3.	Update
Update all Aircraft, which:
•	Have a condition of 'C' or 'B' 
•	Have FlightHours Null or up to 100 (inclusive)
•	Have Year after 2013 (inclusive)
 By setting their condition to 'A'.
*/

UPDATE Aircraft
SET Condition = 'A'
 WHERE Condition = 'C' AND FlightHours IS NULL AND [Year] >= 2013
 OR FlightHours <= 100 AND [Year] >= 2013
 OR Condition = 'B' AND FlightHours IS NULL AND [Year] >= 2013
 OR FlightHours <= 100 AND [Year] >= 2013
 
 /*
 4.	Delete
Delete every passenger whose FullName is up to 10 characters (inclusive) long.

 */


DELETE FROM Passengers WHERE LEN(FullName) <= 10

/*
Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again ("01. DDL_Dataset.sql").

5.	Aircraft
Extract information about all the Aircraft. Order the results by aircraft's FlightHours descending.
Required columns:
•	Manufacturer
•	Model
•	FlightHours
•	Condition
Example

		Manufacturer				Model			FlightHours		Condition
		Northrop Grumman			Bat	1				49039			C
		Airbus						A330				999				B
		Rolls-Royce Holdings		Trent900			958				B
		GE Aviation					CF6					936				C
		Boeing						BBJ					925				C
		Northrop Grumman			X-47A Pegasus		906				B
*/


SELECT
Manufacturer,
Model,
FlightHours,
Condition
FROM Aircraft
ORDER BY FlightHours DESC

/*
6.	Pilots and Aircraft
Select pilots and aircraft that they operate. Extract the pilot's First, Last names, aircraft's Manufacturer, Model, and FlightHours. Skip all plains with NULLs and up to 304 FlightHours. Order the result by the FlightHours in descending order, then by the pilot's FirstName alphabetically. 
Required columns:
•	FirstName
•	LastName
•	Manufacturer
•	Model
•	FlightHours
Example

		FirstName		LastName		Manufacturer			Model		FlightHours
		Genna			Jaquet				Safran				SaM146			303
		Jaynell			Kidson				Safran				SaM146			303
		Lexie			Salasar				Safran				SaM146			303
		Roddie			Gribben				Safran				SaM146			303
		Delaney			Stove				GE Aviation			CT10			275
		Crosby			Godlee				Lockheed Martin		F-22 Raptor		271
*/

SELECT 
p.FirstName, 
p.LastName,
a.Manufacturer,
a.Model,
a.FlightHours
FROM Pilots AS p
JOIN PilotsAircraft AS pe ON pe.PilotId = p.Id
JOIN Aircraft AS a ON a.Id = pe.AircraftId
WHERE a.FlightHours < 304 AND a.FlightHours IS NOT NULL
ORDER BY a.FlightHours DESC, p.FirstName

/*
7.	Top 20 Flight Destinations
Select top 20  flight destinations, where Start day is an even number. Extract DestinationId, Start date, passenger's FullName, AirportName, and TicketPrice. 
Order the result by TicketPrice descending, then by AirportName ascending.

Required columns:
•	DestinationId
•	Start
•	FullName (passenger)
•	AirportName
•	TicketPrice
Example

DestinationId	Start						FullName					AirportName											TicketPrice
	95		2020-07-02 15:27:47.000		Cullan Dogerty			Kisangani Bangoka International Airport						5048.89
	9		2020-02-06 22:32:14.000		Lanita Crockatt			Providenciales Airport										4100.49
	56		2021-02-20 21:04:53.000		Gaye Sillars			Netaji Subhas Chandra Bose International Airport			4002.21
	55		2021-02-28 13:13:55.000		Zeke Rowston			Sir Seretse Khama International Airport						3700.65
	32		2020-09-10 01:55:19.000		Jacquelynn Plackstone	Bujumbura International Airport								3690.22
	38		2020-11-28 17:58:40.000		Jeralee Tue				WinnipegJames Armstrong Richardson International Airport	3390.81

*/

SELECT TOP 20
fd.Id AS DestinationId,
fd.[Start],
p.FullName,
a.AirportName,
fd.TicketPrice
FROM FlightDestinations AS fd
JOIN Passengers AS p ON p.Id = fd.PassengerId
JOIN Airports AS a ON a.Id = fd.AirportId
WHERE DAY(fd.[Start]) % 2 = 0
ORDER BY fd.TicketPrice DESC, a.AirportName ASC

/*
8.	Number of Flights for Each Aircraft
Extract information about all the Aircraft and the count of their FlightDestinations. 
Display average ticket price (AvgPrice) of each flight destination by the Aircraft, rounded to the second digit. 
Take only the aircraft with at least 2  FlightDestinations. 
Order the results by count of flight destinations descending, then by the aircraft's id ascending. 

Required columns:

•	AircraftId
•	Manufacturer
•	FlightHours
•	FlightDestinationsCount
•	AvgPrice

Example

		AircraftId	Manufacturer		FlightHours	FlightDestinationsCount		AvgPrice
			13			Safran				849					4				3208.200000
			80			Lockheed Martin		714					4				1743.140000
			1			Safran				559					3				.710000
			8			Safran				527					3				1366.200000
			25			Northrop Grumman	414					3				452.960000
			37			GE Aviation			4					3				896.950000

*/


SELECT * FROM Aircraft
SELECT * FROM AircraftTypes
SELECT * FROM Airports
SELECT * FROM FlightDestinations
SELECT * FROM Passengers
SELECT * FROM Pilots
SELECT * FROM PilotsAircraft

SELECT 
a.Id AS AircraftId,
a.Manufacturer,
a.FlightHours,
COUNT (fd.AircraftId) AS FlightDestinationsCount,
ROUND(AVG(fd.TicketPrice), 2) AS AvgPrice
FROM Aircraft AS a
JOIN FlightDestinations AS fd ON fd.AircraftId = a.Id
GROUP BY a.Id, a.Manufacturer, a.FlightHours
HAVING COUNT (fd.AircraftId) >= 2
ORDER BY COUNT (fd.AircraftId) DESC, a.Id ASC