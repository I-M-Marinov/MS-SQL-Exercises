
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




