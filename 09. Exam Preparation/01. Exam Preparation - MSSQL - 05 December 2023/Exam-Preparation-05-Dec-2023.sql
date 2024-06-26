﻿
/*
Section 1. DDL (30 pts)
Create a database called RailwaysDb. You need to create 7 tables:
•	Passengers – contains information about the names of the passengers;
•	Towns – contains information about the names of the towns;
•	RailwayStations – holds data about railway stations, such as their names and associated town IDs, indicating the towns where these stations are located.;
•	Trains – details about trains, including departure and arrival times and their corresponding town IDs;
•	TrainsRailwayStations - Manages the many-to-many relationship between trains and railway stations, indicating which trains stop at which stations;
•	MaintenanceRecords – records maintenance activities for trains, including dates and detailed descriptions of maintenance work;
•	Tickets – contains information about tickets, including price, departure and arrival date, and associated train and passenger IDs;

*/

CREATE DATABASE RailwaysDb;
GO
USE RailwaysDb
GO

SELECT * FROM sys.dm_exec_sessions WHERE database_id = DB_ID('RailwaysDb') -- Check active connections 
 -- KILL session_id TO KILL THE active connections BEFORE YOU DROP THE DATABASE 

DROP DATABASE RailwaysDb;

CREATE TABLE Passengers (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(80) NOT NULL
)

CREATE TABLE Towns (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE RailwayStations (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
TownId INT NOT NULL,
CONSTRAINT FK_RailwayStations_Towns FOREIGN KEY (TownId) REFERENCES Towns(Id)
)

CREATE TABLE Trains (
Id INT PRIMARY KEY IDENTITY,
HourOfDeparture VARCHAR(5) NOT NULL,
HourOfArrival VARCHAR(5) NOT NULL,
DepartureTownId INT NOT NULL,
ArrivalTownId INT NOT NULL,
CONSTRAINT FK_Trains_DepartureTown FOREIGN KEY (DepartureTownId) REFERENCES Towns(Id),
CONSTRAINT FK_Trains_ArrivalTown FOREIGN KEY (ArrivalTownId) REFERENCES Towns(Id)
)

CREATE TABLE TrainsRailwayStations (
TrainId INT NOT NULL,
RailwayStationId INT NOT NULL,
CONSTRAINT PK_TrainsRailwayStations PRIMARY KEY (TrainId, RailwayStationId),
CONSTRAINT FK_TrainsRailwayStations_Trains FOREIGN KEY (TrainId) REFERENCES Trains(Id),
CONSTRAINT FK_TrainsRailwayStations_RailwayStations FOREIGN KEY (RailwayStationId) REFERENCES RailwayStations(Id)
)


CREATE TABLE MaintenanceRecords (
Id INT PRIMARY KEY IDENTITY,
DateOfMaintenance DATE NOT NULL,
Details VARCHAR(2000) NOT NULL,
TrainId INT NOT NULL,
CONSTRAINT FK_MaintenanceRecords_Trains FOREIGN KEY (TrainId)
REFERENCES Trains(Id)
)

CREATE TABLE Tickets (
Id INT PRIMARY KEY IDENTITY,
Price DECIMAL(18,2) NOT NULL,
DateOfDeparture DATE NOT NULL,
DateOfArrival DATE NOT NULL,
TrainId INT NOT NULL,
PassengerId INT NOT NULL,
CONSTRAINT FK_Tickets_Trains FOREIGN KEY (TrainId)
REFERENCES Trains(Id),
CONSTRAINT FK_Tickets_Passengers FOREIGN KEY (PassengerId)
REFERENCES Passengers(Id)
)


/*

2.	Insert
Let's insert some sample data into the database. Write a query to add the following records into the corresponding tables. 
All IDs (Primary Keys) should be auto-generated.
					Trains

HourOfDeparture	HourOfArrival	DepartureTownId	ArrivalTownId
'07:00'			'19:00'					1				3
'08:30'			'20:30'					5				6
'09:00'			'21:00'					4				8
'06:45'			'03:55'					27				7
'10:15'			'12:15'					15				5


TrainsRailwayStations
TrainId	RailwayStationId	TrainId	RailwayStationId	TrainId	RailwayStationId
36				1			37			60			       39			3
36				4			37			16				   39			31
36				31			38			10				   39			19
36				57			38			50				   40			41
36				7			38			52				   40			7
37				13			38			22				   40			52
37				54			39			68				   40			13


Tickets
Price	DateOfDeparture	DateOfArrival	TrainId	PassengerId
90.00	'2023-12-01'	'2023-12-01'	  36			1
115.00	'2023-08-02'	'2023-08-02'	  37			2
160.00	'2023-08-03'	'2023-08-03'	  38			3
255.00	'2023-09-01'	'2023-09-02'	  39			21
95.00	'2023-09-02'	'2023-09-03'	  40			22


*/

INSERT INTO Trains (HourOfDeparture,HourOfArrival,DepartureTownId,ArrivalTownId)
VALUES ('07:00', '19:00', 1, 3),
	   ('08:30', '20:30', 5, 6),
	   ('09:00', '21:00', 4, 8),
	   ('06:45', '03:55', 27, 7),
	   ('10:15', '12:15', 15, 5)

INSERT INTO TrainsRailwayStations (TrainId,RailwayStationId)
VALUES (36, 1),
	   (36, 4),
	   (36, 31),
	   (36, 57),
	   (36, 7),
	   (37, 13),
	   (37, 54),
	   (37, 60),
	   (37, 16),
	   (38, 10),
	   (38, 50),
	   (38, 52),
	   (38, 22),
	   (39, 68),
	   (39, 3),
	   (39, 31),
	   (39, 19),
	   (40, 41),
	   (40, 7),
	   (40, 52),
	   (40, 13)

INSERT INTO Tickets(Price,DateOfDeparture,DateOfArrival,TrainId,PassengerId)
VALUES (90.00, '2023-12-01', '2023-12-01', 36, 1),
	   (115.00, '2023-08-02', '2023-08-02', 37, 2),
	   (160.00, '2023-08-03', '2023-08-03', 38, 3),
	   (255.00, '2023-09-01', '2023-09-02', 39, 21),
	   (95.00, '2023-09-02', '2023-09-03', 40, 22)

/*
3.	Update
Due to technical reasons, every ticket with a DateOfDeparture after October 31st will be postponed with one week.  
That means that both DateOfDeparture and DateOfArrival should be changed for 7 days later.

*/

UPDATE Tickets
SET DateOfDeparture = DATEADD(DAY, 7, DateOfDeparture),
    DateOfArrival = DATEADD(DAY, 7, DateOfArrival)
WHERE DateOfDeparture > '2023-10-31';


/*
4.	Delete
In table Trains, delete the train, that departures from Berlin. Keep in mind that there could be foreign key constraint conflicts.
*/

DELETE FROM Tickets
WHERE TrainId IN (SELECT Id FROM Trains WHERE DepartureTownId IN (SELECT Id FROM Towns WHERE Name = 'Berlin'));

DELETE FROM MaintenanceRecords
WHERE TrainId IN (SELECT Id FROM Trains WHERE DepartureTownId IN (SELECT Id FROM Towns WHERE Name = 'Berlin'));

DELETE FROM TrainsRailwayStations
WHERE TrainId IN (SELECT Id FROM Trains WHERE DepartureTownId IN (SELECT Id FROM Towns WHERE [Name] = 'Berlin'));

DELETE FROM Trains
WHERE DepartureTownId IN (SELECT Id FROM Towns WHERE Name = 'Berlin');

/*
Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again ("Dataset.sql").


5.	Tickets by Price and Date of Departure
Select all tickets, ordered by price  (ascending), then by departure date (descending).
Required columns:
•	DateOfDeparture
•	TicketPrice

							Example
			DateOfDeparture			TicketPrice
			  2023-11-06				45.00
			  2023-10-20				45.00
			  2023-10-08				45.00
			  2023-09-11				45.00
			  2023-09-02				45.00
			  2023-11-07				50.00
*/

SELECT DateOfDeparture, Price AS TicketPrice FROM Tickets
ORDER BY Price, DateOfDeparture DESC


/*
6.	Passengers with their Tickets

Select all the tickets purchased, along with the names of the passengers who purchased them.  
For the tickets you will need information for the price, date of departure, related train’s id. 
The report should be organized in a way that lists the tickets starting from the highest price to the lowest. 
In case of identical ticket prices, further order the entries alphabetically by the passenger's name.

Required columns:
•	PassengerName
•	TicketPrice
•	DateOfDeparture
•	TrainID

Example
			PassengerName			TicketPrice 	DateOfDeparture			TrainID
			Mary Campbell			275.00			2023-09-24				29
			Wayne Richardson		275.00			2023-10-29				29
			Bruce Howard			180.00			2023-11-14				10
			Matthew Allen			180.00			2023-09-05				10
*/

SELECT p.[Name] AS PassengerName,
	   t.Price AS TicketPrice,
	   t.DateOfDeparture,
	   t.TrainId
		FROM Tickets AS t
JOIN Passengers AS p ON t.PassengerId = p.Id
ORDER BY t.Price DESC, p.[Name]

/*
7.	Railway Stations without Passing Trains

Select all railway stations that do not have any trains scheduled to stop or pass through them. 
Each station must be associated with the town it is located in. 
The town's name should be included in your result set to understand the geographical distribution of these inactive stations. 
The results should be ordered by the name of the town in ascending order, then by the name of the railway station in ascending order.
Required columns:
•	Town
•	RailwayStation
						Example

			  Town			RailwayStation
			Amsterdam			Amstel
			Amsterdam			Sloterdijk
			Athens				Larissa Station
			Barcelona			Passeig de Garcia
*/

SELECT t.[Name] AS Town,
	   rs.[Name] AS RailwayStation
	   FROM RailwayStations AS rs
    LEFT JOIN TrainsRailwayStations trs ON rs.Id = trs.RailwayStationId
    JOIN Towns t ON rs.TownId = t.Id
WHERE trs.TrainId IS NULL
ORDER BY t.[Name], rs.[Name];


/*
8.	First 3 Trains Between 8:00 and 8:59

Select the top 3 trains departing between 8:00 and 08:59 with ticket prices above €50.00 in the RailwaysDb. 
Your query should join trains with arrival town names, ordering the results by ticket price in ascending order. 
The output should include TrainId, HourOfDeparture, TicketPrice, and Destination. 
Keep in mind that you cannot compare VARCHAR data, so you will have to approach differently. 

Required columns:
•	TrainId
•	HourOfDeparture
•	TicketPrice
•	Destination
 
Example
				TrainId	HourOfDeparture	TicketPrice	Destination
					1		08:00			55.00		Paris
					17		08:00			60.00		Zurich
					17		08:00			85.00		Zurich

*/



SELECT TOP 3 tr.Id AS TrainId,
	  tr.HourOfDeparture,
	  tck.Price AS TicketPrice,
	  twn.[Name] AS Destination
FROM Trains AS tr
JOIN Tickets AS tck ON tr.Id = tck.TrainId
JOIN Towns as twn ON twn.Id = tr.ArrivalTownId
WHERE tr.HourOfDeparture BETWEEN '08:00' AND '08:59' AND tck.Price > 50.00
ORDER BY  tck.Price;

/*
9.	Count of Passengers Paid More Than Average With Arrival Towns

The average price of all tickets is €76.99. 
Select all passengers who have paid more than the average price of all tickets. 
Your query should generate a table grouped by the name of arrival town, showing the count of passengers arriving in each town. 
Order the results by town name.

Required columns:
•	TownName
•	PassengersCount
								Example
			TownName		PassengersCount
			Barcelona				1
			Brussels				1
			Budapest				2
			Gdansk					1
			Lisbon					3
			London					4
*/

SELECT  twns.Name AS TownName,
		COUNT(p.Id) AS PassengersCount
FROM Tickets AS tcks
JOIN Trains AS tr ON tr.Id = tcks.TrainId
JOIN Passengers AS p ON p.Id = tcks.PassengerId
JOIN Towns AS twns ON twns.Id = tr.ArrivalTownId
WHERE tcks.Price > 76.99
GROUP BY tr.ArrivalTownId, twns.Name
ORDER BY twns.Name

/*
10.	Maintenance Inspection with Town
Your task is to generate a table report for train maintenance related to inspections. 
This report should include the train ID, the name of the town where the train departs from and the maintenance record details, 
that include the word "inspection". Order the records by train ID.

Required columns:
•	TrainID
•	DepartureTown
•	Details
									Example

		TrainID	DepartureTown	Details
			1		London		Brake system inspection and overhaul
			2		London		Brake system inspection and overhaul
			4		Paris		Wheel and axle inspection
*/

SELECT * FROM MaintenanceRecords
SELECT * FROM Trains
SELECT * FROM Towns

SELECT 
tr.Id AS TrainID,
twns.[Name] AS DepartureTown,
mr.Details AS Details
FROM Trains AS tr
JOIN MaintenanceRecords AS mr ON mr.TrainId = tr.Id
JOIN Towns AS twns ON twns.Id = tr.DepartureTownId
WHERE mr.Details LIKE '%inspection%'
ORDER BY tr.Id;

/*
							Section 4. Programmability (20 pts)
11.	Towns with Trains
Create a user-defined function, named udf_TownsWithTrains(@name) that receives a town’s name.
The function should return the total number of trains that departures or arrives at that town.
												Example
									Query
				SELECT dbo.udf_TownsWithTrains('Paris')

									Output
									   7
*/

CREATE FUNCTION udf_TownsWithTrains(@name VARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @trainCount INT;
    SELECT @trainCount = COUNT(*) 
    FROM Trains AS tr
    JOIN Towns AS t ON tr.ArrivalTownId = t.Id OR tr.DepartureTownId = t.Id
    WHERE t.[Name] = @name;
	RETURN @trainCount
END;

SELECT dbo.udf_TownsWithTrains('Paris'); -- OUTPUT ----> 7 

/*
12.	Search Passenger Travelling to Specific Town

Create a stored procedure, named usp_SearchByTown(@townName) that receives a town name. 
The procedure must print full information about all passengers that are travelling to the town with the given townName. 
Order them by DateOfDeparture (descending) and PassengerName (ascending).

Required columns:
•	PassengerName
•	DateOfDeparture
•	HourOfDeparture

Example
						Query
			EXEC usp_SearchByTown 'Berlin'
						Output
			PassengerName		DateOfDeparture	 HourOfDeparture
			Beverly Ross		2023-10-30			12:00
			Kenneth Parker		2023-09-25			12:00

*/

SELECT * FROM Passengers
SELECT * FROM Trains
SELECT * FROM Towns
SELECT * FROM Tickets

CREATE PROCEDURE usp_SearchByTown(@townName VARCHAR(30))
AS
BEGIN
	SELECT p.[Name] AS PassengerName, 
		   ti.DateOfDeparture,
		   tr.HourOfDeparture
	FROM Tickets AS ti
	JOIN Trains AS tr ON tr.Id = ti.TrainId
	JOIN Passengers AS p ON p.Id = ti.PassengerId
	JOIN Towns AS twn ON twn.Id = tr.ArrivalTownId
	WHERE twn.[Name] = @townName
	ORDER BY  ti.DateOfDeparture DESC, p.[Name]
END 

EXEC usp_SearchByTown 'London'
EXEC usp_SearchByTown 'Berlin'