
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

