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
