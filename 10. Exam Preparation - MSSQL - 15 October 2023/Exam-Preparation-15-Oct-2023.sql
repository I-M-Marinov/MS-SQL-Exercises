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

DROP DATABASE TouristAgency

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
Email VARCHAR(80),
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


/*
3.	Update
We've decided to change the departure date of the bookings that are scheduled to arrive in December 2023. 
The updated departure date for these bookings should be set to one day later than their original departure date.
We need to update the email addresses of tourists, whose names contain "MA". 
The new value of their email addresses should be set to NULL.

*/

SELECT * FROM Bookings
SELECT * FROM Tourists

UPDATE Bookings
SET DepartureDate = DATEADD(DAY, 1, DepartureDate)
WHERE DepartureDate > '2023-12-01';

UPDATE Tourists
SET Email = NULL
WHERE Email LIKE '%MA%'


/*

4.	Delete
In table Tourists, delete every tourist, whose Name contains family name "Smith". 
Keep in mind that there could be foreign key constraint conflicts.

*/

DELETE FROM Bookings
WHERE TouristId IN (SELECT Id FROM Tourists WHERE Name LIKE '%Smith%');

DELETE FROM Tourists
WHERE Name LIKE '%Smith%';


/*
Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again ("Dataset.sql").

5.	Bookings by Price of Room and Arrival Date
Select all bookings, ordered by price  of room (descending), then by arrival date (ascending). 
The arrival date should be formatted in the 'yyyy-MM-dd' format in the query results.
Required columns:
•	ArrivalDate
•	AdultsCount
•	ChildrenCount

								Example:

			ArrivalDate		AdultsCount	 ChildrenCount

			2023-10-05			3				1
			2023-11-19			4				2
			2023-12-10			5				1
			2023-10-01			2				0
*/

SELECT FORMAT(ArrivalDate, 'yyyy-MM-dd') AS ArrivalDate,
	   AdultsCount,
	   ChildrenCount
		FROM Bookings AS b
		JOIN Rooms AS r ON r.Id = b.RoomId
ORDER BY r.Price DESC, b.ArrivalDate


/*
6.	Hotels by Count of Bookings
Select all hotels with "VIP Apartment" available. 
Order results by the count of bookings (count of all bookings for the specific hotel, not only for VIP apartment) made for every hotel (descending).
Required columns:
•	Id
•	Name

Example

			Id				Name
			5			Saint Ouen Marche Aux Puces
			11			Silken Al-Andalaus Palace
			20			Kivotos
			3			Antica Panada

*/

SELECT h.Id,
	   h.[Name] AS [Name]
	   FROM Hotels AS h
	   JOIN Bookings AS b ON b.HotelId = h.Id
	   JOIN Rooms AS r ON r.Id = b.RoomId
	   JOIN HotelsRooms AS hr ON hr.HotelId = h.Id
    WHERE hr.RoomId = 8 -- ID 8 is a VIP Apartment
	GROUP BY h.Id, h.[Name]
	ORDER BY COUNT(b.HotelId) DESC


/*
7.	Tourists without Bookings
Select all tourists that haven’t booked a hotel yet. Order them by name (ascending).
Required columns:
•	Id
•	Name
•	PhoneNumber

Example
			Id	Name				PhoneNumber
			19	Ahmet Yilmaz		777-777-7707
			14	Friedrich Weber		434-444-4414
*/

SELECT t.Id,
	   t.[Name],
	   t.PhoneNumber
FROM Tourists AS t
LEFT JOIN Bookings AS b ON b.TouristId = t.Id
WHERE b.TouristId IS NULL
ORDER BY t.[Name]

/*
8.	First 10 Bookings
Select the first 10 bookings that will arrive before 2023-12-31. 
You will need to select the bookings in hotels with odd-numbered IDs. 
Sort the results in ascending order, first by CountryName, and then by ArrivalDate.

Required columns:
•	HotelName
•	DestinationName
•	CountryName
Example

			        HotelName					DestinationName		CountryName
			Royal Promenade des Anglais			   Nice				   France
			Saint Ouen Marche Aux Puces			   Paris			   France
			Saint Ouen Marche Aux Puces			   Paris			   France
*/


SELECT * FROM Destinations
SELECT * FROM Hotels


SELECT TOP 10 
    h.[Name] AS HotelName,
    d.[Name] AS DestinationName,
    c.[Name] AS CountryName
FROM Bookings AS b
JOIN Hotels AS h ON h.Id = b.HotelId
JOIN Destinations as d ON d.Id = h.DestinationId
JOIN Countries AS c ON c.Id = d.CountryId
WHERE h.Id % 2 = 1
  AND b.ArrivalDate < '2023-12-31'
ORDER BY c.[Name], b.ArrivalDate;

/*
9.	Tourists booked in Hotels
Select all of the tourists that have a name, not ending in "EZ", and display the names of the hotels, 
that they have booked a room in. Order by the price of the room (descending).
Required columns:
•	HotelName
•	RoomPrice

Example

			HotelName								RoomPrice
			Kivotos									600.00
			Silken Al-Andalaus Palace				280.50
			Liebesbier Urban Art & Smart Hotel		280.50
			Anklamer Hof							250.00
			Silken Al-Andalaus Palace				250.00
			Silken Al-Andalaus Palace				250.00
*/

SELECT * FROM Destinations
SELECT * FROM Hotels

SELECT
h.[Name] AS HotelName,
r.Price AS RoomPrice
FROM Tourists AS t
JOIN Bookings AS b ON b.TouristId = t.Id
JOIN Hotels AS h ON h.Id = b.HotelId
JOIN Rooms AS r ON r.Id = b.RoomId
WHERE t.[Name] NOT LIKE '%EZ%'
ORDER BY r.Price DESC

/*
10.	Hotels Revenue
In this task, you will write an SQL query to calculate the total price of all 
bookings for each hotel based on the room price and the number of nights guests have stayed. 
The result should list the hotel names and their corresponding revenue.

•	Foreach Booking you should join data for the Hotel and the Room, using the Id references;
•	NightsCount – you will need the ArrivalDate and DepartureDate for a DATEDIFF function;
•	Calculate the TotalRevenue by summing the price of each booking, 
using Price of the Room that is referenced to the specific Booking and multiply it by the NightsCount. 
•	Group all the bookings by HotelName using the reference to the Hotel. 
•	Order the results by TotalRevenue in descending order.

Required columns:
•	HotelName
•	TotalRevenue

Example
				HotelName			HotelRevenue
				Bonvecchiati			10521.50
				Kivotos					6530.00
				Cavo Tagoo				3666.75
*/

SELECT * FROM Bookings
SELECT * FROM Hotels
SELECT * FROM Rooms
SELECT * FROM HotelsRooms

SELECT 
h.[Name] AS HotelName,
SUM(r.Price * DATEDIFF(DAY, b.ArrivalDate, b.DepartureDate)) AS TotalRevenue 
FROM Bookings AS b
JOIN Hotels AS h ON h.Id = b.HotelId
JOIN Rooms AS r ON r.Id = b.RoomId
GROUP BY h.[Name]
ORDER BY TotalRevenue DESC