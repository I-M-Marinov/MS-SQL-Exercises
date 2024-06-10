/*
																Section 1. DDL (30 pts)
You have been given the E/R Diagram of the TouristAgency database.

Create a database called TouristAgency. You need to create 7 tables:
-	Countries - contains information about the countries, in which the destinations and hotels are located, each tourist will also has a country;
-	Destinations - contains information about the holiday destinations(areas, resorts, etc.);
-	Rooms - contains information about the rooms (type of room, count of beds);
-	Hotels - contains information about each hotel;
-	Tourists - containts information about each tourist, that has booked a room in a hotel;
-	Bookings - contains information about each booking;
-	HotelsRooms  - mapping table between hotels and rooms;

*/

CREATE DATABASE TouristAgency 
GO
USE TouristAgency

CREATE TABLE Countries (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Destinations (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
CountryId INT NOT NULL,
CONSTRAINT FK_Destinations_Countries FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

CREATE TABLE Rooms (
Id INT PRIMARY KEY IDENTITY,
[Type] VARCHAR(40) NOT NULL,
Price DECIMAL(18,2) NOT NULL,
BedCount INT CHECK (BedCount > 0 AND BedCount <= 10) NOT NULL
)

CREATE TABLE Hotels (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
DestinationId INT NOT NULL,
CONSTRAINT FK_Hotels_Destinations FOREIGN KEY (DestinationId) REFERENCES Destinations(Id)
)

CREATE TABLE Tourists (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(80) NOT NULL,
PhoneNumber VARCHAR(20) NOT NULL,
Email VARCHAR(80) NOT NULL,
CountryId INT NOT NULL,
CONSTRAINT FK_Tourists_Countries FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

CREATE TABLE Bookings (
Id INT PRIMARY KEY IDENTITY,
ArrivalDate DATETIME2 NOT NULL,
DepartureDate DATETIME2 NOT NULL,
AdultsCount INT CHECK (AdultsCount >= 1 AND AdultsCount <= 10) NOT NULL,
ChildrenCount INT CHECK (ChildrenCount >= 0 AND ChildrenCount <= 9) NOT NULL,
TouristId INT NOT NULL, 
HotelId INT NOT NULL, 
RoomId INT NOT NULL,
CONSTRAINT FK_Bookings_Tourists FOREIGN KEY (TouristId) REFERENCES Tourists(Id),
CONSTRAINT FK_Bookings_Hotels FOREIGN KEY (HotelId) REFERENCES Hotels(Id),
CONSTRAINT FK_Bookings_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
)

CREATE TABLE HotelsRooms (
HotelId INT NOT NULL,
RoomId INT NOT NULL,
CONSTRAINT PK_HotelsRooms PRIMARY KEY (HotelId, RoomId),
CONSTRAINT FK_HotelsRoomss_Hotels FOREIGN KEY (HotelId) REFERENCES Hotels(Id),
CONSTRAINT FK_HotelsRooms_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
)

/*
Section 2. DML (10 pts)
Before you start, you have to import "Dataset.sql ". If you have created the structure correctly, the data should be successfully inserted.
In this section, you have to do some data manipulations:
2.	Insert
Let's insert some sample data into the database. Write a query to add the following records into the corresponding tables. All IDs (Primary Keys) should be auto-generated.
Tourists


		Name				PhoneNumber				Email						CountryId
		John Rivers			653-551-1555		john.rivers@example.com				6
		Adeline Aglaé		122-654-8726		adeline.aglae@example.com			2
		Sergio Ramirez		233-465-2876		s.ramirez@example.com				3
		Johan Müller		322-876-9826		j.muller@example.com				7
		Eden Smith			551-874-2234		eden.smith@example.com				6
*/

INSERT INTO Tourists ([Name],PhoneNumber,Email,CountryId)
VALUES ('John Rivers', '653-551-1555', 'john.rivers@example.com', 6),
	   ('Adeline Aglaé', '122-654-8726', 'adeline.aglae@example.com', 2),
	   ('Sergio Ramirez', '233-465-2876', 's.ramirez@example.com', 3),
	   ('Johan Müller', '322-876-9826', 'j.muller@example.com', 7),
	   ('Eden Smith', '551-874-2234', 'eden.smith@example.com', 6)


INSERT INTO Bookings(ArrivalDate,DepartureDate,AdultsCount,ChildrenCount,TouristId,HotelId,RoomId)
VALUES ('2024-03-01', '2024-03-11', 1, 0, 21, 3, 5),
	   ('2023-12-28', '2024-01-06', 2, 1, 22, 13, 3),
	   ('2023-11-15', '2023-11-20', 1, 2, 23, 19, 7),
	   ('2023-12-05', '2023-12-09', 4, 0, 24, 6, 4),
	   ('2024-05-01', '2024-05-07', 6, 0, 25, 14, 6)