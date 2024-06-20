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

DELETE FROM Clients
WHERE AddressID IN ( SELECT Id FROM Addresses WHERE Country LIKE 'C%')

DELETE FROM Addresses
WHERE Country LIKE 'C%'

/*
Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again ("01-DDL-Data-Seeder.sql").

5.	Cigars by Price
Select all cigars ordered by price (ascending) then by cigar name (descending). 
Required columns

•	CigarName
•	PriceForSingleCigar
•	ImageURL
Example

		CigarName						PriceForSingleCigar						ImageURL
		H.UPMANN NO. 2							5.45						h-upmann-magnum-50_6_4_1_9.png
		EL-REY-DEL-MUNDO DEMI TASSE				11.45						EL-REY-DEL-MUNDO-magnum-50_6_4_1_9.jpg
		VEGUEROS TAPADOS						15.62						VEGUEROS-open-junior_1_1_2_1_1_1_4_1_1_1_1_1_1_1_1_2_4_1_9.jpg
		BOLIVAR CORONAS JUNIOR					17.34						bolivar-coronas-junior.jpg
*/

SELECT 
CigarName,
PriceForSingleCigar,
ImageURL
FROM Cigars
ORDER BY PriceForSingleCigar, CigarName DESC

/*
6.	Cigars by Taste
Select all cigars with "Earthy" or "Woody" tastes. Order results by PriceForSingleCigar (descending).
Required columns

•	Id
•	CigarName
•	PriceForSingleCigar
•	TasteType
•	TasteStrength

Example

			Id	CigarName									PriceForSingleCigar		TasteType		TasteStrength
			18	TRINIDAD CASILDA COLECCION HABANOS 2019		756.82						Woody			Medium
			25	RAMON ALLONES SMALL CLUB CORONAS			567.34						Earthy			Medium to Full
			39	MONTECRISTO OPEN MASTER TUBOS				555.45						Earthy			Medium to Full
			38	MONTECRISTO OPEN JUNIOR						545.45						Woody			Medium

*/

SELECT * FROM Cigars
SELECT * FROM Tastes

SELECT 
c.Id,
c.CigarName,
c.PriceForSingleCigar,
t.TasteType,
t.TasteStrength
FROM Cigars AS c
JOIN Tastes AS t ON t.Id = c.TastId
WHERE t.TasteType = 'Earthy' OR  t.TasteType = 'Woody'
ORDER BY c.PriceForSingleCigar DESC

/*
7.	Clients without Cigars
Select all clients without cigars. Order them by name (ascending).
Required columns

•	Id
•	ClientName – customer's first and last name, concatenated with space
•	Email
Example

		Id		ClientName					Email
		8		Brenda Wallace		Wallace.khan@gmail.com
		10		Harry Jones			5ornob.Jones@gmail.com
		7		Jason Hamilton		nob.Jason@gmail.com
*/

SELECT 
c.Id,
CONCAT(c.FirstName, ' ', c.LastName) AS ClientName,
c.Email
FROM Clients AS c
LEFT JOIN ClientsCigars AS cs ON cs.ClientId = c.Id
WHERE cs.CigarId IS NULL
ORDER BY c.FirstName

/*
8.	First 5 Cigars
Select the first 5 cigars that are at least 12cm long and contain "ci" in the cigar name or price for a 
single cigar is bigger than $50 and ring range is bigger than 2.55. 
Order the result by cigar name (ascending), then by price for a single cigar (descending).

Required columns
•	CigarName
•	PriceForSingleCigar
•	ImageURL
Example

CigarName									PriceForSingleCigar					ImageURL

COHIBA 1966 EDICION LIMITADA 2011				19.45						cohiba-siglo-i-stick_18.png
COHIBA BEHIKE 54								254.09						cohiba-esplendidos-stick.jpg
FONSECA NO. 1									76.34						FONSECA-50_6_4_1_9.jpg
HOYO-DE-MONTERREY EPICURE ESPECIAL				98.89						HOYO-DE-MONTERREY-siglo-i-stick_18.jpg
HOYO-DE-MONTERREY EPICURE NO. 2					78.57						HOYO-DE-MONTERREY-siglo-i-stick_18.jpg

*/

SELECT TOP 5
c.CigarName,
c.PriceForSingleCigar,
c.ImageURL
FROM Cigars AS c
JOIN Sizes AS s ON s.Id = c.SizeId 
WHERE s.[Length] >= 12 AND (c.CigarName LIKE '%ci%' 
OR (c.PriceForSingleCigar > 50 AND s.RingRange > 2.55))
ORDER BY c.CigarName, c.PriceForSingleCigar DESC

/*
9.	Clients with ZIP Codes
Select all clients which have addresses with ZIP code that contains only digits, and display they're the most expensive cigar. 
Order by client full name ascending.
Required columns
•	FullName
•	Country
•	ZIP
•	CigarPrice – formated as "${CigarPrice}"
Example

FullName					Country	ZIP			CigarPrice
Betty Wallace	Turkey			13760			$555.45
Joan Peters	Japan				06511			$543.23
Rachel Bishop	Andorra			08043			$555.45

*/


SELECT 
CONCAT_WS(' ', c.FirstName, c.LastName) AS FullName,
a.Country,
a.ZIP,
FORMAT(MAX(ci.PriceForSingleCigar), '$####.###') AS CigarPrice
FROM Clients AS c
LEFT JOIN [Addresses] AS a ON a.Id = c.AddressId
LEFT JOIN ClientsCigars AS cc ON cc.ClientId = c.Id
LEFT JOIN Cigars AS ci ON ci.Id = cc.CigarId
WHERE a.ZIP NOT LIKE '%[^0-9]%' --- REGEX
GROUP BY c.FirstName, c.LastName, a.Country, a.ZIP
ORDER BY FullName

/*
10.	Cigars by Size
Select all clients which own cigars. Select their last name, average length, and ring range 
(rounded up to the next biggest integer) of their cigars.
Order the results by average cigar length (descending).
Example

LastName	CiagrLength		CiagrRingRange
Miller			20				5
Riley			19				3
Ramirez			18				5
*/

SELECT * FROM Cigars
SELECT * FROM Sizes
SELECT * FROM Tastes
SELECT * FROM Clients
SELECT * FROM Addresses
SELECT * FROM ClientsCigars

SELECT
c.LastName,
AVG(s.[Length]) AS CigarLength,
CEILING(AVG(s.RingRange)) AS CigarRingRange
FROM Clients AS c 
JOIN ClientsCigars AS cc ON c.Id = cc.ClientId
JOIN Cigars AS ci ON ci.Id = cc.CigarId
JOIN Sizes AS s ON s.Id = ci.SizeId
GROUP BY c.LastName
ORDER BY CigarLength DESC;

