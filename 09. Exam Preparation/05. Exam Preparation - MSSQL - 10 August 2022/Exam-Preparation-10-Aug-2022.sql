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

SELECT * FROM Tourists
SELECT * FROM Categories
SELECT * FROM BonusPrizes
SELECT * FROM Sites
SELECT * FROM Locations

UPDATE Sites
SET Establishment = '(not defined)'
WHERE Establishment IS NULL 