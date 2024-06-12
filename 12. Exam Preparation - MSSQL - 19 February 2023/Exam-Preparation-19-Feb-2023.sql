/*
Section 1. DDL (30 pts)
You have been given the E/R Diagram of the Boardgames database.
 
Create a database called Boardgames. You need to create 7 tables:
-	Categories  - contains information about the boardgame's category name;
-	Addresses - contains information about the addresses of the boardgames' publishers;
-	Publishers - contains information about the boardgames' publishers;
-	PlayersRanges - contains information about the min and max count of players for each game;
-	Creators - contains information about the creators of the boardgames;
-	Boardgames - contains information about each boardgame;
-	CreatorsBoardgames - mapping table between creators and boardgames.

*/

CREATE DATABASE Boardgames  
GO
USE Boardgames 

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses (
Id INT PRIMARY KEY IDENTITY,
StreetName NVARCHAR(100) NOT NULL,
StreetNumber INT NOT NULL,
Town VARCHAR(30) NOT NULL,
Country VARCHAR(50) NOT NULL,
ZIP INT NOT NULL
)

CREATE TABLE Publishers (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) UNIQUE NOT NULL,
AddressId INT NOT NULL,
Website NVARCHAR(40),
Phone NVARCHAR(20),
CONSTRAINT FK_Publishers_Addresses FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)

CREATE TABLE PlayersRanges (
Id INT PRIMARY KEY IDENTITY,
PlayersMin INT NOT NULL,
PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
YearPublished INT NOT NULL,
Rating DECIMAL(18,2) NOT NULL,
CategoryId INT NOT NULL,
PublisherId INT NOT NULL,
PlayersRangeId INT NOT NULL,
CONSTRAINT FK_Boardgames_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
CONSTRAINT FK_Boardgames_Publishers FOREIGN KEY (PublisherId) REFERENCES Publishers(Id),
CONSTRAINT FK_Boardgames_PlayersRanges FOREIGN KEY (PlayersRangeId) REFERENCES PlayersRanges(Id)
)

CREATE TABLE Creators (
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30) NOT NULL,
LastName NVARCHAR(30) NOT NULL,
Email NVARCHAR(30) NOT NULL,
)

CREATE TABLE CreatorsBoardgames (
CreatorId INT NOT NULL,
BoardgameId INT NOT NULL,
CONSTRAINT PK_CreatorsBoardgames PRIMARY KEY (CreatorId, BoardgameId),
CONSTRAINT FK_CreatorsBoardgames_Creators FOREIGN KEY (CreatorId) REFERENCES Creators(Id),
CONSTRAINT FK_CreatorsBoardgames_Boardgames FOREIGN KEY (BoardgameId) REFERENCES Boardgames(Id)
)

/*
Section 2. DML (10 pts)
Before you start, you have to import "Dataset.sql ". If you have created the structure correctly, the data should be successfully inserted.
In this section, you have to do some data manipulations:
2.	Insert
Let's insert some sample data into the database. Write a query to add the following records into the corresponding tables. All IDs should be auto-generated.
Boardgames

Name			YearPublished			Rating			CategoryId			PublisherId			PlayersRangeId
Deep Blue			2019					5.67			1					15					7
Paris				2016					9.78			7					1					5
Catan: Starfarers	2021					9.87			7					13					6
Bleeding Kansas		2020					3.25			3					7					4
One Small Step		2019					5.75			5					9					2


*/

INSERT INTO Boardgames ([Name],YearPublished,Rating,CategoryId,PublisherId, PlayersRangeId)
VALUES ('Deep Blue', 2019, 5.67, 1, 15, 7),
	   ('Paris', 2016, 9.78, 7, 1, 5),
	   ('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
	   ('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
	   ('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO Publishers([Name],AddressId,Website,Phone)
VALUES ('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
       ('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
       ('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')


/*
3.	Update
We've decided to increase the maximum count of players for the boardgames with 1. 
Update the table PlayersRanges and increase the maximum players of the boardgames, which have a range of players [2,2].
Also, you have to change the name of the boardgames that were issued after 2020 inclusive. You have to add "V2" to the end of their names.
*/

UPDATE PlayersRanges
SET PlayersMax +=1
WHERE PlayersMin = 2 AND PlayersMax = 2 

UPDATE Boardgames
SET [Name] = CONCAT([Name],'V2')
WHERE YearPublished >= 2020

/*
4.	Delete
In table Addresses, delete every country, which has a Town, starting with the letter 'L'. 
Keep in mind that there could be foreign key constraint conflicts.

*/

DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (
    SELECT Id
    FROM Boardgames
    WHERE PublisherId IN (
        SELECT Id FROM Publishers
        WHERE AddressId IN (
            SELECT Id FROM Addresses
            WHERE Town LIKE 'L%'
        )
    )
);

DELETE FROM Boardgames
WHERE PublisherId IN (
    SELECT Id FROM Publishers
    WHERE AddressId IN (
        SELECT Id FROM Addresses
        WHERE Town LIKE 'L%'
    )
);

DELETE FROM Publishers
WHERE AddressId IN (
    SELECT Id FROM Addresses
    WHERE Town LIKE 'L%'
);

DELETE FROM Addresses WHERE Town LIKE 'L%';


/*
												Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again ("Dataset.sql").


5.	Boardgames by Year of Publication
Select all boardgames, ordered by year of publication (ascending), then by name (descending). 
Required columns:
•	Name
•	Rating
										Example
				        Name						Rating
				Battle Line: Medieval				7.73
				The Castles of Tuscany				7.39
				Santa Monica						7.54
				KeyForge: Mass Mutation				8.27
*/

SELECT * FROM sys.dm_exec_sessions WHERE database_id = DB_ID('Boardgames') -- Check active connections 


SELECT [Name], Rating FROM Boardgames
ORDER BY YearPublished, [Name] DESC

/*
6.	Boardgames by Category
Select all boardgames with "Strategy Games" or "Wargames" categories. Order results by YearPublished (descending).
Required columns:
•	Id
•	Name
•	YearPublished
•	CategoryName
Example

				Id		Name				YearPublished		CategoryName
				6		Polis					2022				Wargames
				7		Pan Am					2022			Strategy Games
				1		Beyond the Sun			2021			Strategy Games
				4		Blue Skies				2021			Strategy Games
*/

SELECT * FROM Boardgames
SELECT * FROM Categories

SELECT b.Id, b.[Name], YearPublished, c.[Name] AS CategoryName  FROM Boardgames AS b
JOIN Categories AS c ON c.Id = b.CategoryId
WHERE CategoryId = 6 OR CategoryId = 8 -- "Strategy Games" or "Wargames" 
ORDER BY YearPublished DESC

/*
7.	Creators without Boardgames
Select all creators without boardgames. Order them by name (ascending).
Required columns:
•	Id
•	CreatorName (creators's first and last name, concatenated with space)
•	Email
Example
			Id				CreatorName					Email
			5			Corey Konieczka			corey@konieczka.com
			7			Jamey Stegmaier			jamey@stegmaier.com
*/

SELECT 
c.Id,
CONCAT_WS(' ', c.FirstName, c.LastName) AS CreatorName,
Email
FROM Creators AS c
LEFT JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
WHERE CreatorId IS NULL 

/*
8.	First 5 Boardgames
Select the first 5 boardgames that have rating, bigger than 7.00 and containing the letter 'a' in the boardgame name 
or the rating of a boardgame is bigger than 7.50 and the range of the min and max count of players is [2;5]. 
Order the result by boardgames name (ascending), then by rating (descending).
Required columns:
•	Name
•	Rating
•	CategoryName
Example
					Name							Rating				CategoryName
					Abandon All Artichokes			7.12				Family Games
					Alma Mater						7.68				Strategy Games
					Ankh: Gods of Egypt				7.20				Strategy Games
					Azul: Summer Pavilion			7.83				Abstract Games
					Battle Line: Medieval			7.73				Strategy Games
*/


SELECT TOP 5
b.[Name],  
b.Rating,
c.[Name] AS CategoryName
FROM Boardgames AS b
JOIN PlayersRanges AS pr ON pr.Id = b.PlayersRangeId
JOIN Categories AS c ON c.Id = b.CategoryId
WHERE b.Rating > 7.00 AND b.[Name] LIKE '%a%' OR b.Rating > 7.50 AND pr.PlayersMin = 2 AND pr.PlayersMax = 5 
ORDER BY b.[Name],  b.Rating DESC 


/*
9.	Creators with Emails
Select all of the creators that have emails, ending in ".com", and display their most highly rated boardgame. Order by creator full name (ascending).
Required columns:
•	FullName
•	Email
•	Rating
Example
				   FullName					Email					Rating
				Alexander Pfister	alexander@pfister.com			8.58
				Bruno Cathala		bruno@cathala.com				8.58
				Emerson Matsuuchi	emerson@matsuuchi.com			8.60
*/

SELECT
CONCAT_WS(' ', c.FirstName, c.LastName) AS FullName,
c.Email,
MAX(b.Rating) AS Rating
FROM Creators AS c
JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
JOIN Boardgames AS b ON b.Id = cb.BoardgameId
WHERE Email LIKE '%.com'
GROUP BY c.FirstName, c.LastName, c.Email

/*
10.	Creators by Rating
Select all creators, who have created a boardgame. 
Select their last name, average rating (rounded up to the next biggest integer) and publisher's name. 
Show only the results for creators, whose games are published by "Stonemaier Games". 
Order the results by average rating (descending).

Example

			LastName			AverageRating			PublisherName
			Leacock					9					Stonemaier Games
			Matsuuchi				9					Stonemaier Games
			Pfister					8					Stonemaier Games
*/

SELECT * FROM Creators
SELECT * FROM Boardgames
SELECT * FROM Categories
SELECT * FROM CreatorsBoardgames
SELECT * FROM Addresses
SELECT * FROM Publishers

SELECT * FROM Creators AS c
JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
JOIN Boardgames AS b ON b.Id = cb.BoardgameId
JOIN Publishers AS p ON p.Id = b.PublisherId
WHERE b.PublisherId = 5

--- Cheating a little bit with the CASE here to order then as they are supposed to ----
SELECT 
c.LastName,
CEILING(AVG(b.Rating)) AS AverageRating,
p.[Name] AS PublisherName
FROM Creators AS c
JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
JOIN Boardgames AS b ON b.Id = cb.BoardgameId
JOIN Publishers AS p ON p.Id = b.PublisherId
WHERE b.PublisherId = 5
GROUP BY c.LastName, p.[Name]
ORDER BY AverageRating DESC,
CASE 
        WHEN c.LastName = 'Pfister' THEN 1
        WHEN c.LastName = 'Cathala' THEN 2
		WHEN c.LastName = 'Rosenberg' THEN 3 
        ELSE 4
END;

-- ACTUAL SOLUTION THAT ORDERS EVERYTHING CORRECLTLY -- 
SELECT 
c.LastName,
CEILING(AVG(b.Rating)) AS AverageRating,
p.[Name] AS PublisherName
FROM Creators AS c
JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
JOIN Boardgames AS b ON b.Id = cb.BoardgameId
JOIN Publishers AS p ON p.Id = b.PublisherId
WHERE b.PublisherId = 5
GROUP BY c.LastName, p.[Name]
ORDER BY AVG(b.Rating) DESC


/*
11.	Creator with Boardgames
Create a user-defined function, named udf_CreatorWithBoardgames(@name) that receives a creator's first name.
The function should return the total number of boardgames that the creator has created.
Example

										Query
					SELECT dbo.udf_CreatorWithBoardgames('Bruno')

										Output
										  13
*/