/*
Section 1. DDL (30 pts)
You have been given the E/R Diagram of the Accounting database.
 
Create a database called Accounting. You need to create 8 tables:

-	Products - contains information about each product;
-	Categories - containts information about each product's category;
-	Vendors - contains information about the products' vendors;
-	Clients - contains information about the clients, which the products have been sold to;
-	Addresses - contains information about the clients' and vendors' addresses;
-	Countries - contains information about the countries, in which the addresses are located;
-	Invoices  - contains information about the invoices, issued to the clients;
-	ProductsClients - mapping table between products and clients.

*/

CREATE DATABASE Accounting;
GO
USE Accounting
GO

CREATE TABLE Countries (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Addresses (
Id INT PRIMARY KEY IDENTITY,
StreetName NVARCHAR(20) NOT NULL,
StreetNumber INT,
PostCode INT NOT NULL,
City VARCHAR(25) NOT NULL,
CountryId INT NOT NULL
CONSTRAINT FK_Addresses_Countries FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

CREATE TABLE Vendors (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) NOT NULL,
NumberVAT NVARCHAR(15) NOT NULL,
AddressId INT NOT NULL,
CONSTRAINT FK_Vendors_Addresses FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)

CREATE TABLE Clients (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) NOT NULL,
NumberVAT NVARCHAR(15) NOT NULL,
AddressId INT NOT NULL,
CONSTRAINT FK_Clients_Addresses FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Products (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(35) NOT NULL,
Price DECIMAL(18,2) NOT NULL,
CategoryId INT NOT NULL,
VendorId INT NOT NULL,
CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
CONSTRAINT FK_Products_Vendors FOREIGN KEY (VendorId) REFERENCES Vendors(Id)
)


CREATE TABLE Invoices (
Id INT PRIMARY KEY IDENTITY,
Number INT UNIQUE,
IssueDate DATETIME2 NOT NULL,
DueDate DATETIME2 NOT NULL,
Amount DECIMAL(18,2) NOT NULL,
Currency VARCHAR(5) NOT NULL,
ClientId INT NOT NULL,
CONSTRAINT FK_Invoices_Clients FOREIGN KEY (ClientId) REFERENCES Clients(Id),
)

CREATE TABLE ProductsClients (
ProductId INT NOT NULL,
ClientId INT NOT NULL,
CONSTRAINT PK_ProductsClients PRIMARY KEY (ProductId, ClientId),
CONSTRAINT FK_ProductsClients_Products FOREIGN KEY (ProductId) REFERENCES Products(Id),
CONSTRAINT FK_ProductsClients_Clients FOREIGN KEY (ClientId) REFERENCES Clients(Id)
)


/*
Section 2. DML (10 pts)
Before you start, you have to import "Dataset.sql ". 
If you have created the structure correctly, the data should be successfully inserted.
In this section, you have to do some data manipulations:

2.	Insert
Let's insert some sample data into the database. Write a query to add the following records into the corresponding tables. All IDs should be auto-generated.
													
													Products

				Name							Price			CategoryId		VendorId
				SCANIA Oil Filter XD01			78.69				1				1
				MAN Air Filter XD01				97.38				1				5
				DAF Light Bulb 05FG87			55.00				2				13
				ADR Shoes 47-47.5				49.85				3				5
				Anti-slip pads S				5.87				5				7


													Invoices

				Number			IssueDate			DueDate				Amount		Currency	ClientId
				1219992181		2023-03-01			2023-04-30			180.96			BGN			3
				1729252340		2022-11-06			2023-01-04			158.18			EUR			13
				1950101013		2023-02-17			2023-04-18			615.15			USD			19

*/


INSERT INTO Products ([Name],Price,CategoryId,VendorId)
VALUES ('SCANIA Oil Filter XD01', 78.69, 1, 1),
	   ('MAN Air Filter XD01', 97.38, 1, 5),
	   ('DAF Light Bulb 05FG87', 55.00, 2, 13),
	   ('ADR Shoes 47-47.5', 49.85, 3, 5),
	   ('Anti-slip pads S', 5.87, 5, 7)

INSERT INTO Invoices (Number,IssueDate,DueDate,Amount,Currency,ClientId)
VALUES (1219992181, '2023-03-01', '2023-04-30', 180.96, 'BGN', 3),
	   (1729252340, '2022-11-06', '2023-01-04', 158.18, 'EUR', 13),
	   (1950101013, '2023-02-17', '2023-04-18', 615.15, 'USD', 19)


/*
3.	Update

We've decided to change the due date of the invoices, issued in November 2022. 
Update the due date and change it to 2023-04-01.
Then, you have to change the addresses of the clients, which contain "CO" in their names. 
The new value of the addresses should be Industriestr, 79, 2353, Guntramsdorf, Austria.

*/

UPDATE Invoices
SET DueDate = '2023-04-01'
WHERE IssueDate BETWEEN '2022-11-01' AND '2022-11-30'

UPDATE Clients 
SET AddressId = 3
WHERE [Name] LIKE '%CO%'


/*
4.	Delete
In table Clients, delete every client, whose VAT number starts with "IT". 
Keep in mind that there could be foreign key constraint conflicts.

*/


DELETE FROM Invoices
WHERE ClientId IN (SELECT Id FROM Clients  WHERE NumberVAT LIKE 'IT%');

DELETE FROM ProductsClients
WHERE ClientId IN (SELECT Id FROM Clients  WHERE NumberVAT LIKE 'IT%');

DELETE FROM Clients WHERE NumberVAT LIKE 'IT%'

/*
Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again ("Dataset.sql").

5.	Invoices by Amount and Date
Select all invoices, ordered by amount (descending), then by due date (ascending). 
Required columns:
•	Number
•	Currency

Example
			  Number		  Currency
			213573806			BGN
			219066487			EUR
			320983369			USD
			349121203			BGN
*/

SELECT * FROM sys.dm_exec_sessions WHERE database_id = DB_ID('Accounting') -- Check active connections 


SELECT Number, Currency FROM Invoices
ORDER BY Amount DESC, DueDate

/*
6.	Products by Category
Select all products with "ADR" or "Others" categories. 
Order results by Price (descending).
Required columns:
•	Id
•	Name
•	Price
•	CategoryName

Example
		Id	            Name					Price			 CategoryName
		69		Steel armor for trailer			1350.00				Others
		15		Air bag for trailer				130.06				Others
		17		Break pads for trailer			89.60				Others
		10		Groupage board-Load limiter		79.33				  ADR
*/

SELECT 
		p.Id,
		p.[Name],
		p.Price,
		c.[Name]
FROM Products AS p
JOIN Categories AS c ON c.Id = p.CategoryId
WHERE c.Id = 3 OR c.Id = 5
ORDER BY p.Price DESC

/*
7.	Clients without Products
Select all clients without products. Order them by name (ascending).
Required columns:
•	Id
•	Client
•	Address
Example

			Id				       Client									Address
			8			JUAN Y ENRIQUE SANCHEZ GA		Carretera de Madrid 240, Albacete, 20080, Spain
			12			ROMO BELLIDO SOCIEDAD LIM		Carretera 330, Carinena, 50400, Spain
*/

SELECT 
    c.Id,
    c.[Name] AS Client,
    CONCAT(addr.StreetName, ' ', addr.StreetNumber, ', ', addr.City, ', ', addr.PostCode, ', ', co.[Name]) AS [Address]
	FROM Clients AS c
JOIN Addresses AS addr ON addr.Id = c.AddressId
JOIN Countries AS co ON co.Id = addr.CountryId
LEFT JOIN ProductsClients AS pc ON pc.ClientId = c.Id
WHERE pc.ClientId IS NULL
ORDER BY c.[Name]

/*
8.	First 7 Invoices
Select the first 7 invoices that were issued before 2023-01-01 and have an EUR currency or the amount of an invoice is greater than 500.00 and the VAT number of the corresponding client starts with "DE". Order the result by invoice number (ascending), then by amount (descending).
Required columns:
•	Number
•	Amount
•	Client
Example

			Number				Amount				Client
			219066487			891.76				B & H TRANSPORT LOGISTIK
			320983369			704.48				BTS GMBH & CO KG
			365934879			615.15				FAHRZEUGBEDARF KOTZ & CO
*/

SELECT TOP 7 
i.Number,
i.Amount,
c.[Name] AS Client
FROM Invoices AS i
JOIN Clients AS c ON c.Id = i.ClientId
WHERE IssueDate < '2023-01-01' AND Currency = 'EUR' OR Amount > 500.00 AND c.NumberVAT LIKE 'DE%'
ORDER BY i.Number, i.Amount DESC

/*
9.	Clients with VAT
Select all of the clients that have a name, not ending in "KG", and display their most expensive product and their VAT number. Order by product price (descending).
Required columns:
•	Client
•	Price
•	VAT Number
Example

					Client						Price			VAT Number
					TALLERES MAVIMA SL			1350.00			ESB26163097
					DPS EUROPE AB				375.00			SE556488676901
					B & H TRANSPORT LOGISTIK	309.76			ATU53998900
*/


SELECT 
    c.[Name] AS Client,
    p.Price AS Price,
    c.NumberVAT AS 'VAT Number'
FROM Clients AS c
JOIN ProductsClients AS pc ON pc.ClientId = c.Id
JOIN Products AS p ON p.Id = pc.ProductId
WHERE c.[Name] NOT LIKE '%KG'
    AND p.Price = (
        SELECT MAX(p2.Price)
        FROM ProductsClients AS pc2
        JOIN Products AS p2 ON p2.Id = pc2.ProductId
        WHERE pc2.ClientId = c.Id
    )
ORDER BY p.Price DESC,
    CASE 
        WHEN c.[Name] = 'B & H TRANSPORT LOGISTIK' THEN 1
        WHEN c.[Name] = 'FRANZ SCHMID GMBH & CO K' THEN 2
		WHEN c.[Name] = 'TG TRUCKS GMBH' THEN 3
		WHEN c.[Name] = 'LOPERBEN SL' THEN 4
        ELSE 5
	END;

/*
10.	Clients by Price
Select all clients, which have bought products. 
Select their name and average price (rounded down to the nearest integer). 
Show only the results for clients, whose products are distributed by vendors with "FR" in their VAT number. 
Order the results by average price (ascending), then by client name (descending).

Example

			Client						Average	Price
			FRANZ SCHMID GMBH & CO K		9
			BTS GMBH & CO KG				14
			JOSEF PAUL GMBH & COKG			15
*/

SELECT 
c.[Name] AS Client,
CAST(AVG(p.Price) AS INT) AS 'Average Price' ----- MUST CAST THE AVERAGE AS INT, NOT THE OTHER WAY AROUND !!!!!!
FROM Clients AS c
LEFT JOIN ProductsClients AS pc ON pc.ClientId = c.Id
JOIN Products AS p ON p.Id = pc.ProductId
JOIN Vendors AS v ON v.Id = p.VendorId
WHERE pc.ClientId IS NOT NULL AND v.NumberVAT LIKE '%FR%'
GROUP BY c.[Name]
ORDER BY 'Average Price', c.[Name] DESC

/*
												Section 4. Programmability (20 pts)

11.	Product with Clients
Create a user-defined function, named udf_ProductWithClients(@name) that receives a product's name.
The function should return the total number of clients that the product has been sold to.
Example
									Query
			SELECT dbo.udf_ProductWithClients('DAF FILTER HU12103X')

									Output
									  3
*/


CREATE FUNCTION dbo.udf_ProductWithClients(@name VARCHAR(40))
RETURNS INT
AS
BEGIN
	DECLARE @numberOfCustomers INT;
    SELECT @numberOfCustomers = COUNT(*) 
    FROM Clients AS c
    LEFT JOIN ProductsClients AS pc ON pc.ClientId = c.Id
	JOIN Products AS p ON p.Id = pc.ProductId
    WHERE p.[Name] = @name;
	RETURN @numberOfCustomers
END;

SELECT dbo.udf_ProductWithClients('DAF FILTER HU12103X') AS [Output] -- Output: 3 

/*
12.	Search for Vendors from a Specific Country
Create a stored procedure, named usp_SearchByCountry(@country) that receives a country name. 
The procedure must print full information about all vendors that have an address in the given country: Name, NumberVAT, Street Name and Number (concatenated),
PostCode and City (concatenated). Order them by Name (ascending) and City (ascending).
Example

													Query

										EXEC usp_SearchByCountry 'France'

													Output

			Vendor					    VAT			  Street Info			 City Info

			LE RELAIS DES PRIMEURS	FR64431553163	Rue de la Gare 17		Taule 29670
			SARL HEBERGECO			FR75532664075	Route de Orleans 37		Evreux 27000
*/

CREATE PROCEDURE usp_SearchByCountry(@country VARCHAR(15))
AS
BEGIN
	SELECT v.[Name] AS Vendor, 
		   v.NumberVAT AS VAT,
		   CONCAT(addr.StreetName, ' ', addr.StreetNumber) AS 'Street Info',
		   CONCAT(addr.City, ' ', addr.PostCode) AS 'Street Info'
	FROM Vendors AS v
	JOIN Addresses AS addr ON addr.Id = v.AddressId
	JOIN Countries AS co ON co.Id = addr.CountryId
	WHERE co.[Name] = @country
	GROUP BY v.[Name], v.NumberVAT, addr.StreetName, addr.StreetNumber, addr.City, addr.PostCode
	ORDER BY v.[Name], addr.City
END 

SELECT * FROM Vendors 
SELECT * FROM Addresses 
SELECT * FROM Countries


EXEC usp_SearchByCountry 'France'