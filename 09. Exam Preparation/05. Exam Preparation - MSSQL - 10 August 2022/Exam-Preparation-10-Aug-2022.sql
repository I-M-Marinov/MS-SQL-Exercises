﻿/*
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

/*
8.	Tourist Sites established BC
Extract information about the tourist sites, which have a location name that does NOT start with the letters 'B', 'M' or 'D' 
and which are established Before Christ (BC). Select the site name, location name, municipality, province and establishment. 
Order the result by name of the site (ascending).
NOTE: If the establishment century is Before Christ (BC), it will always be in the following format: 'RomanNumeral BC'.
Example

			Site										Location			Municipality			Province		Establishment
	Asen's Fortress										Asenovgrad			Asenovgrad				Plovdiv				V BC
	National archaeological reserve Kabile				Yambol				Yambol					Yambol				II BC
	Perperikon – Medieval Archaeological Complex		Rhodope Mountain	NULL					NULL				V BC
	Shumen Fortress Historical-Archaeological Preserve	Shumen				Shumen					Shumen				I BC
	Starosel – Thracian Temple Complex					Starosel village	Hisarya					Plovdiv				V BC
	Thracian Tomb of Kazanlak							Kazanlak			Karlovo					Plovdiv				IV BC

*/

SELECT 
s.[Name] AS [Site],
l.[Name] AS [Location],
l.Municipality,
l.Province,
s.Establishment
FROM Sites AS s
JOIN Locations AS l ON l.Id = s.LocationId
WHERE (s.[Name] NOT LIKE 'B%' AND  s.[Name] NOT LIKE 'M%' AND  s.[Name] NOT LIKE 'D%') 
		AND s.Establishment LIKE '%BC'
ORDER BY s.[Name] 

/*
9.	Tourists with their Bonus Prizes

Extract information about the tourists, along with their bonus prizes. 
If there is no data for the bonus prize put '(no bonus prize)'. 
Select tourist's name, age, phone number, nationality and bonus prize. 
Order the result by the name of the tourist (ascending).

NOTE: There will never be a tourist with more than one prize.
Example


			Name					Age			PhoneNumber			Nationality			Reward
			Alonzo Conti			36			+393336258996		Italy			(no bonus prize)
			Brus Brown				42			+447459881347		UK				(no bonus prize)
			Claudia Reuss			54			+4930774615846		Germany				Sleeping bag
			Cosimo Ajello			51			+393521112654		Italy			(no bonus prize)
			Cyrek Gryzbowski		64			+48503435735		Poland			(no bonus prize)
			Danny Kane				39			+32487454880		Belgium	Water		filter jug
*/

SELECT 
t.[Name],
t.Age,
t.PhoneNumber,
t.Nationality,
COALESCE(bp.[Name], '(no bonus prize)') AS Reward 
FROM Tourists AS t
LEFT JOIN TouristsBonusPrizes AS tb ON tb.TouristId = t.Id
LEFT JOIN BonusPrizes AS bp ON bp.Id = tb.BonusPrizeId
ORDER BY t.[Name]

/*
10.	Tourists visiting History and Archaeology sites

Extract all tourists, who have visited sites from category 'History and archaeology'. 
Select their last name, nationality, age and phone number. 
Order the result by their last name (ascending).

NOTE: The name of the tourists will always be in the following format: 'FirstName LastName'.

Example


			LastName			Nationality			Age		PhoneNumber
			Bauer				Germany				49		+496913265224
			Becker				Germany				36		+491711234567
			Bianchi				Italy				51		+393125965845
			Brown				UK					42		+447459881347
			Conti				Italy				36		+393336258996
			Dimitrova			Bulgaria			42		+359898645326
*/

SELECT 
SUBSTRING(t.[Name], CHARINDEX(' ', t.[Name]) + 1, LEN(t.[Name])) AS LastName,
t.Nationality,
t.Age,
t.PhoneNumber
FROM Tourists AS t
JOIN SitesTourists AS st ON st.TouristId = t.Id
JOIN Sites AS s ON s.Id = st.SiteId
JOIN Categories AS c ON c.Id = s.CategoryId
WHERE c.Id = 8 
GROUP BY SUBSTRING(t.[Name], CHARINDEX(' ', t.[Name]) + 1, LEN(t.[Name])), t.Nationality, t.Age, t.PhoneNumber
ORDER BY LastName

/*
															Section 4. Programmability (20 pts)
11.	Tourists Count on a Tourist Site
Create a user-defined function named udf_GetTouristsCountOnATouristSite (@Site) which receives a tourist site and returns the count of tourists, who have visited it.
Examples


														Query
				SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa')

														Output
														  6

														Query
							SELECT dbo.udf_GetTouristsCountOnATouristSite ('Samuil’s Fortress')

														Output
														  8

														Query
							SELECT dbo.udf_GetTouristsCountOnATouristSite ('Gorge of Erma River')

														Output
														  7
*/

SELECT * FROM Tourists
SELECT * FROM Categories
SELECT * FROM BonusPrizes
SELECT * FROM Sites
SELECT * FROM SitesTourists
SELECT * FROM Locations
SELECT * FROM TouristsBonusPrizes


CREATE FUNCTION dbo.udf_GetTouristsCountOnATouristSite(@site VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @countOfTourists INT;
    SELECT @countOfTourists = COUNT(t.[Name])
    FROM Sites AS s
	LEFT JOIN SitesTourists AS st ON st.SiteId = s.Id
	LEFT JOIN Tourists AS t ON t.Id = st.TouristId
    WHERE s.[Name] = @site;
	RETURN @countOfTourists
END;

SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa') AS [Output]
SELECT dbo.udf_GetTouristsCountOnATouristSite ('Samuil’s Fortress') AS [Output]
SELECT dbo.udf_GetTouristsCountOnATouristSite ('Gorge of Erma River') AS [Output]

/*
12.	Annual Reward Lottery
A reward scheme has been developed to encourage collection of as many stamps as possible. 
Depending on the number of stamps collected, participants may receive bronze, silver or gold badges. 
Create a stored procedure, named usp_AnnualRewardLottery(@TouristName). 
Update the reward of the given tourist according to the count of the sites he have visited:

**	>= 100 receives 'Gold badge'
**	>= 50 receives 'Silver badge'
**	>= 25 receives 'Bronze badge'
Extract the name of the tourist and the reward he has.

Example
											Query
							EXEC usp_AnnualRewardLottery 'Gerhild Lutgard'
											Result
							Name						Reward
							Gerhild Lutgard				Gold badge

*/

CREATE PROCEDURE usp_AnnualRewardLottery(@TouristName NVARCHAR(20))
AS
BEGIN
		SELECT 
			t.[Name],
			CASE 
					WHEN COUNT(st.TouristId) >= 100 THEN 'Gold badge'
					WHEN COUNT(st.TouristId) >= 50 THEN 'Silver badge'
					WHEN COUNT(st.TouristId) >= 25 THEN 'Bronze badge'
					ELSE t.Reward 
				END AS Reward
			FROM Tourists AS t
			LEFT JOIN SitesTourists AS st ON st.TouristId = t.Id
			WHERE t.[Name] = @TouristName
			GROUP BY t.[Name], t.Reward

END

EXEC usp_AnnualRewardLottery 'Gerhild Lutgard' -- Gold badge
EXEC usp_AnnualRewardLottery 'Teodor Petrov' -- Silver badge
EXEC usp_AnnualRewardLottery 'Zac Walsh' -- Bronze badge
EXEC usp_AnnualRewardLottery 'Brus Brown' -- NULL