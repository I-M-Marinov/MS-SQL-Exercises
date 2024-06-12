/*
Section 1. DDL (30 pts)
You have been given the following E/R Diagram.
 

Create a database called NationalTouristSitesOfBulgaria. You need to create 7 tables:
•	Categories – contains information about the different categories of the tourist sites;
•	Locations – contains information about the locations of the tourist sites;
•	Sites – contains information about the tourist sites;
•	Tourists – contains information about the tourists, who are visiting the tourist sites;
•	SitesTourists – a many to many mapping table between the sites and the tourists;
•	BonusPrizes – contains information about the bonus prizes, which are given to an annual raffle;
•	TouristsBonusPrizes – a many to many mapping table between the tourists and the bonus prizes.

*/

CREATE DATABASE NationalTouristSitesOfBulgaria;
GO
USE NationalTouristSitesOfBulgaria
GO

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
Municipality VARCHAR(50),
Province VARCHAR(50)
)

CREATE TABLE Sites (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL,
LocationId INT NOT NULL,
CategoryId INT NOT NULL,
Establishment VARCHAR(15),
CONSTRAINT FK_Sites_Locations FOREIGN KEY (LocationId) REFERENCES Locations(Id),
CONSTRAINT FK_Sites_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)

CREATE TABLE Tourists (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
Age INT NOT NULL CHECK (Age >= 0 AND Age <= 120),
PhoneNumber VARCHAR(20) NOT NULL,
Nationality VARCHAR(30) NOT NULL,
Reward VARCHAR(20)
)

CREATE TABLE SitesTourists (
TouristId INT NOT NULL,
SiteId INT NOT NULL,
CONSTRAINT PK_SitesTourists PRIMARY KEY (TouristId, SiteId),
CONSTRAINT FK_SitesTourists_Tourists FOREIGN KEY (TouristId) REFERENCES Tourists(Id),
CONSTRAINT FK_SitesTourists_Sites FOREIGN KEY (SiteId) REFERENCES Sites(Id)
)

CREATE TABLE BonusPrizes (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE TouristsBonusPrizes (
TouristId INT NOT NULL,
BonusPrizeId INT NOT NULL,
CONSTRAINT PK_TouristsBonusPrizes PRIMARY KEY (TouristId, BonusPrizeId),
CONSTRAINT FK_TouristsBonusPrizes_Tourists FOREIGN KEY (TouristId) REFERENCES Tourists(Id),
CONSTRAINT FK_TouristsBonusPrizes_BonusPrizes FOREIGN KEY (BonusPrizeId) REFERENCES BonusPrizes(Id)
)


/*
Section 2. DML (10 pts)
Before you start you have to import "01. DDL_Dataset.sql ". If you have created the structure correctly the data should be successfully inserted.
In this section, you have to do some data manipulations:

2.	Insert
Let's insert some sample data into the database. Write a query to add the following records into the corresponding tables. 
All Ids should be auto-generated.

					Tourists
									Name				Age			PhoneNumber			Nationality		Reward
							Borislava Kazakova			52			+359896354244		Bulgaria		NULL
							Peter Bosh					48			+447911844141		UK				NULL
							Martin Smith				29			+353863818592		Ireland			Bronze badge
							Svilen Dobrev				49			+359986584786		Bulgaria		Silver badge
							Kremena Popova				38			+359893298604		Bulgaria		NULL



						Sites

							      Name							LocationId			CategoryId			Establishment
							Ustra fortress						90					7					X
							Karlanovo Pyramids					65					7					NULL
							The Tomb of Tsar Sevt				63					8					V BC
							Sinite Kamani Natural Park			17					1					NULL
							St. Petka of Bulgaria – Rupite		92					6					1994

*/

INSERT INTO Tourists ([Name],Age,PhoneNumber,Nationality,Reward)
VALUES ('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
	   ('Peter Bosh', 48, '+447911844141', 'UK', NULL),
	   ('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge'),
	   ('Svilen Dobrev', 49, '+359986584786', 'Bulgaria', 'Silver badge'),
	   ('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL)

INSERT INTO Sites ([Name],LocationId,CategoryId,Establishment)
VALUES ('Ustra fortress', 90, 7, 'X'),
		('Karlanovo Pyramids', 65, 7, NULL),
		('The Tomb of Tsar Sevt', 63, 8, 'V BC'),
		('Sinite Kamani Natural Park', 17, 1, NULL),
		('St. Petka of Bulgaria – Rupite', 92, 6, '1994')


/*
3.	Update
For some of the tourist sites there are no clear records when they were established, 
so you need to update the column 'Establishment' for those records by putting the text '(not defined)'.
*/

UPDATE Sites
SET Establishment = '(not defined)'
WHERE Establishment IS NULL 

/*
4.	Delete
For this year's raffle it was decided to remove the Sleeping bag from the bonus prizes.
*/


DELETE FROM TouristsBonusPrizes WHERE BonusPrizeId IN (SELECT Id FROM BonusPrizes WHERE [Name] = 'Sleeping bag');

DELETE FROM BonusPrizes WHERE [Name] = 'Sleeping bag';

/*    Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again (01. DDL_Dataset.sql). 
DO NOT CHANGE OR INCLUDE DATA FROM DELETE, INSERT AND UPDATE TASKS!!! */

SELECT * FROM sys.dm_exec_sessions WHERE database_id = DB_ID('NationalTouristSitesOfBulgaria')

/*
5.	Tourists
Extract information about all the Tourists – name, age, phone number and nationality. 
Order the result by nationality (ascending), then by age (descending), and then by tourist name (ascending).
Example

					Name				Age		PhoneNumber	    Nationality
				Danny Kane				39		+32487454880	Belgium
				Krasen Krasenov			62		+359897653265	Bulgaria
				Pavel Mateev			51		+359879632123	Bulgaria
				Kameliya Dimitrova		42		+359898645326	Bulgaria
				Dobroslav Mihalev		39		+359889632200	Bulgaria
				Mariya Petrova			37		+359887564235	Bulgaria
*/

SELECT 
[Name],
Age,
PhoneNumber,
Nationality
FROM Tourists
ORDER BY Nationality, Age DESC, [Name] 

/*
6.	Sites with Their Location and Category
Select all sites and find their location and category. Select the name of the tourist site, name of the location,  
establishment year/ century and name of the category. Order the result by name of the category (descending), 
then by name of the location (ascending) and then by name of the site itself (ascending).

Example

					Site								Location				Establishment				Category
		Clock Tower – Botevgrad							Botevgrad					1866				Spare time in the city
		Clock Tower of Etropole							Etropole					1710				Spare time in the city
		House of Humour and Satire Museum – Gabrovo		Gabrovo						1972				Spare time in the city
		Museum of Education – Gabrovo					Gabrovo						1974				Spare time in the city
		Antique Theater – Plovdiv						Plovdiv						II					Spare time in the city
		Salt Museum – Pomorie							Pomorie						2002				Spare time in the city
*/

SELECT 
s.[Name] AS [Site],
l.[Name] AS [Location], 
s.Establishment,
c.[Name]
FROM Sites AS s
JOIN Locations AS l ON l.Id = s.LocationId
JOIN Categories AS c ON c.Id = s.CategoryId
ORDER BY c.[Name] DESC,l.[Name], s.[Name]

/*
7.	Count of Sites in Sofia Province
Extract all locations which are in Sofia province. 
Find the count of sites in every location. Select the name of the province, name of the municipality, 
name of the location and count of the tourist sites in it. Order the result by count of tourist sites (descending) and then by name of the location (ascending).
Example

			Province	Municipality			Location			CountOfSites
			Sofia			Sofia				Sofia					11
			Sofia			Etropole			Etropole				3
			Sofia			Botevgrad			Botevgrad				1
			Sofia			Koprivshtitsa		Koprivshtitsa			1
			Sofia			Svoge				Osenovlag village		1
			Sofia			Samokov				Samokov					1

*/

SELECT * FROM Tourists
SELECT * FROM Categories
SELECT * FROM BonusPrizes
SELECT * FROM Sites
SELECT * FROM Locations
SELECT * FROM TouristsBonusPrizes

SELECT 
l.Province,
l.Municipality,
l.[Name] AS [Location],
COUNT(s.LocationId) AS CountOfSites
FROM Locations AS l
JOIN Sites AS s ON s.LocationId = l.Id
WHERE l.Province = 'Sofia'
GROUP BY l.Province, l.Municipality, l.[Name]
ORDER BY COUNT(s.LocationId) DESC, l.[Name]
