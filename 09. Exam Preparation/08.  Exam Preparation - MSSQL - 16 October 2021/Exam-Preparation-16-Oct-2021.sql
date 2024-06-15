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
Streat NVARCHAR(100) NOT NULL, 
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


/*
Section 2. DML (10 pts)
Before you start you have to import "01-DDL-Data-Seeder.sql ". If you have created the structure correctly the data should be successfully inserted.
In this section, you have to do some data manipulations:

2.	Insert
Let us insert some sample data into the database. 
Write a query to add the following records into the corresponding tables. All IDs should be auto-generated.
Cigars

		CigarName							BrandId			TastId			SizeId			PriceForSingleCigar			ImageURL
		COHIBA ROBUSTO							9				1				5				15.50					cohiba-robusto-stick_18.jpg
		COHIBA SIGLO I							9				1				10				410.00					cohiba-siglo-i-stick_12.jpg
		HOYO DE MONTERREY LE HOYO DU MAIRE		14				5				11				7.50					hoyo-du-maire-stick_17.jpg
		HOYO DE MONTERREY LE HOYO DE SAN JUAN	14				4				15				32.00					hoyo-de-san-juan-stick_20.jpg
		TRINIDAD COLONIALES						2				3				8				85.21					trinidad-coloniales-stick_30.jpg
*/

INSERT INTO Cigars (CigarName,BrandId,TastId,SizeId,PriceForSingleCigar, ImageURL)
VALUES ('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses (Town,Country,Streat,ZIP)
VALUES ('Sofia', 'Bulgaria', '18 Bul. Vasil levski', 1000),
('Athens', 'Greece', '4342 McDonald Avenue', 10435),
('Zagreb', 'Croatia', '4333 Lauren Drive', 10000)

/*
3.	Update
We've decided to increase the price of some cigars by 20%. 
Update the table Cigars and increase the price of all cigars, which TasteType is "Spicy" by 20%. 
Also add the text "New description" to every brand, which does not has BrandDescription.
*/


DECLARE @SpicyTasteId INT;
SELECT @SpicyTasteId = Id FROM Tastes WHERE TasteType = 'Spicy';

UPDATE Cigars
SET PriceForSingleCigar = PriceForSingleCigar * 1.20
WHERE TastId = @SpicyTasteId;

UPDATE Brands
SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL;
	   

/*
4.	Delete
In table Addresses, delete every country which name starts with 'C', 
keep in mind that could be foreign key constraint conflicts.
*/

DELETE FROM ClientsCigars
WHERE ClientId IN (SELECT ClientId FROM Clients IN ( AddressID IN ( SELECT AddressID FROM Addresses WHERE Country LIKE 'C%')

DELETE FROM Clients
WHERE AddressID IN ( SELECT AddressID FROM Addresses WHERE Country LIKE 'C%')

DELETE FROM Addresses
WHERE Country LIKE 'C%'

SELECT * FROM ClientsCigars 
SELECT * FROM Clients



