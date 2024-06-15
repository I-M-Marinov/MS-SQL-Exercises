/*
Section 1. DDL (30 pts)
You have been given the E/R Diagram of the CigarShop
 
Create a database called CigarShop. You need to create 7 tables:
•	Sizes – contains information about the cigar's length and ring range;
•	Tastes – contains information about the cigar's taste type, taste strength, and image of the taste;
•	Brands – contains information about the cigar's brand name and brand description;
•	Cigars – contains information for every single cigar;
•	Addresses – contains information about the clients' address details;
•	Clients – contains information about the customers that buy cigars;
•	ClientsCigars – mapping table between clients and cigars.

*/

CREATE DATABASE CigarShop
GO
USE CigarShop
GO

CREATE TABLE Sizes (
Id INT PRIMARY KEY IDENTITY,
[Length] INT NOT NULL CHECK ([Length] >=10 AND [Length] <= 25),
RingRange DECIMAL(18,2) NOT NULL CHECK (RingRange >= 1.5 AND RingRange <= 7.5)
)

CREATE TABLE Tastes (
Id INT PRIMARY KEY IDENTITY,
TasteType VARCHAR(20) NOT NULL,
TasteStrength VARCHAR(15) NOT NULL,
ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Brands (
Id INT PRIMARY KEY IDENTITY,
BrandName VARCHAR(20) NOT NULL UNIQUE,
BrandDescription VARCHAR(MAX)
)

CREATE TABLE Cigars (
    Id INT PRIMARY KEY IDENTITY,
    CigarName VARCHAR(80) NOT NULL,
    BrandId INT NOT NULL,
    TastId INT NOT NULL,
    SizeId INT NOT NULL,
    PriceForSingleCigar MONEY NOT NULL,
    ImageURL NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Cigars_Brands FOREIGN KEY (BrandId) REFERENCES Brands(Id),
    CONSTRAINT FK_Cigars_Tastes FOREIGN KEY (TastId) REFERENCES Tastes(Id),
    CONSTRAINT FK_Cigars_Sizes FOREIGN KEY (SizeId) REFERENCES Sizes(Id)
)

CREATE TABLE Addresses (
Id INT PRIMARY KEY IDENTITY,
Town VARCHAR(30) NOT NULL,
Country NVARCHAR(30) NOT NULL,
Street NVARCHAR(100) NOT NULL, 
ZIP VARCHAR(20) NOT NULL
)


CREATE TABLE Clients (
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30) NOT NULL,
LastName NVARCHAR(30) NOT NULL,
Email NVARCHAR(50) NOT NULL, 
AddressId INT NOT NULL,
CONSTRAINT FK_Clients_Addresses FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)

CREATE TABLE ClientsCigars (
ClientId INT NOT NULL,
CigarId INT NOT NULL,
CONSTRAINT PK_ClientsCigars PRIMARY KEY (ClientId, CigarId),
CONSTRAINT FK_ClientsCigars_Clients FOREIGN KEY (ClientId) REFERENCES Clients(Id),
CONSTRAINT FK_ClientsCigars_Cigars FOREIGN KEY (CigarId) REFERENCES Cigars(Id)
)





